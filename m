Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED7D5029DD
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353571AbiDOMeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353824AbiDOMdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:22 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF102F03F;
        Fri, 15 Apr 2022 05:30:53 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 11so4757131edw.0;
        Fri, 15 Apr 2022 05:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KCYsQY/y5IS+uLLSbczPyROpjTi5JnKwjdboy6JQyM=;
        b=c8tJ2FSSPaEqVRtRhXYc8sgQTfYtNFcB6CTG3Ae0iCHlMVPDi0c3SICkTbZwepYo4p
         xU3X93yaYi8aAlcXrdADKu2LXuxPn/GR7oL66fnPlgJa7OmOINJ/xEIQL+6hYZ8yUSoQ
         7Xak+mMuwkZw1URcphJpYDVHc7+nXeWht2xleoSi85Cdjpf7ai9zz6uYmZNGppEYkvFL
         aEG6B9HNWYFeXTxuwGQSdH8x7YqoiGZ719kpFy5Idm1Rx1wMNcnUOLyT/LzIulvfprEo
         plYsODJ40dQzFvq11UTfXkDNAIZmPJ/Zxw9fHFQsIuJIA/bdMy2HR30antzmBYlQTAng
         xF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KCYsQY/y5IS+uLLSbczPyROpjTi5JnKwjdboy6JQyM=;
        b=VJD+KLJSEFC0r13kFaEQwNk7tXUO1YiLKqUuAtdBMzV2t7E23EOWjUCJ909fVawzUf
         M28qv/ipqPh8d2d720OkTDzsYwJGDzEroMooBSbyzlnJE/8mgQfEXrvRIB5va5t//EOA
         3oIyJFWsqDXMWVr+SJGqFAs74yMjMcuRBi7j12ylslko1D3TWPdp+K3syXh2gm4P9k+h
         2Wbmbj1dO6A/DAQsT/lMRP+x3wRJo81gBTNK0N5gbIZj5332i6roFjxcCOqUCEI+fDmG
         soOAsc57nqnqQbgFnuUxNI3B8275VrolzLdQdvVQANUekJQ6m30HbvO7Zym6uzmnUzZh
         v7Aw==
X-Gm-Message-State: AOAM530EjQxoZmnWzhz/3Nww2nzJ5KGZs0tWH6Q1yRpaBtysTttu2ewW
        Um+KGDu+Vu1t8v+IzuAWfvo=
X-Google-Smtp-Source: ABdhPJz3mJeDYdvdKpfwwqP6ynW2oMh4u6NHyPRzN+YmogUpokwo+g9Jqk9X+ozi9dyyRi0vEERRww==
X-Received: by 2002:a50:d592:0:b0:41d:6bae:bd36 with SMTP id v18-20020a50d592000000b0041d6baebd36mr7951369edi.221.1650025852122;
        Fri, 15 Apr 2022 05:30:52 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:30:51 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v4 05/18] net: dsa: mv88e6xxx: remove redundant check in mv88e6xxx_port_vlan()
Date:   Fri, 15 Apr 2022 14:29:34 +0200
Message-Id: <20220415122947.2754662-6-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415122947.2754662-1-jakobkoschel@gmail.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We know that "dev > dst->last_switch" in the "else" block.
In other words, that "dev - dst->last_switch" is > 0.

dsa_port_bridge_num_get(dp) can be 0, but the check
"if (bridge_num + dst->last_switch != dev) continue", rewritten as
"if (bridge_num != dev - dst->last_switch) continue", aka
"if (bridge_num != something which cannot be 0) continue",
makes it redundant to have the extra "if (!bridge_num) continue" logic,
since a bridge_num of zero would have been skipped anyway.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64f4fdd02902..b3aa0e5bc842 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1404,9 +1404,6 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 		list_for_each_entry(dp, &dst->ports, list) {
 			unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 
-			if (!bridge_num)
-				continue;
-
 			if (bridge_num + dst->last_switch != dev)
 				continue;
 
-- 
2.25.1


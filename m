Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E48511EBA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbiD0QMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbiD0QLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:11:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCFF49A14C;
        Wed, 27 Apr 2022 09:08:02 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y3so4325550ejo.12;
        Wed, 27 Apr 2022 09:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uXZUMLY6oT5/pgJ3JE+0g8SiU8XVYCT+G02CN/YaIC8=;
        b=fOg0kwucAT7Z1tCyzoXxHJk7ZWXzD71f/n3w9jXO9wukuuAReuE3yVOT24ZTZv+vZm
         JVCT9LA60wN3RiFubbL0xNXDlmIptbiIcweT5+Iq+pQQ6rKMStHVdmh8zMziwlhhLDEp
         o8LUjUr464P844d7LmXXYYURuZtwf7n778EPPFFl38Vs2y7Bk3MTfaIhIp0UGGuvWsZB
         V0yaz+aX0zbM+kSLR5p0i1zfdWN4mxLTilWZrPILmf3nz43NVBsr/tdaBHWDSesveLIV
         1IUaZlZjgjBxaddfiVtdP4ZDhvL2E1w47LgWAFMxtgcfPowPl68x/5o2vcZ6UJ411GuY
         2b3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uXZUMLY6oT5/pgJ3JE+0g8SiU8XVYCT+G02CN/YaIC8=;
        b=hwjTw+nQ93aGdLgdzdK4Rn/IjXnq8xeAW6iQA6tE08Pa1JHGHdWXxJJFYLJ1szlQDl
         YORIYrODJknuj9NzkSDtUbC+uzqyCepsAWo80gElMi2h3RTzbZzdFJxZ3nTlWQ1LES0s
         O/7KbWm1qsqIzDveYcxJ1xciboGwqABjn+Fb1UQlgduuUbHa1+Gi0OhqfVamC/sgByfg
         SPVlcUJVqhLRYFWAjj6Syd6Wony9ebHNl2YsF5qQmqq0Xpih4V+1HPJsv9Io25BsVthX
         ESBwjCA7RtAifuHHg9CKkHFBvXy2GM5vIy1jIQNR5GlJUzPwBh8TM19o09zXie+OxtBq
         FhfQ==
X-Gm-Message-State: AOAM530fx9BkysXPCfNMMz16BcE1nBqYJK5z8w3rR6y8amwl8wqxBdCe
        s2Oo+0NG6FPmWMDZ7W9Q4QA=
X-Google-Smtp-Source: ABdhPJxJlxuNbQqjV45PE6cobcBsqISDpGtNtIgUKkVpPXa5SbB8VitgJHOwbhD0WzWZbMVXZ0mgIQ==
X-Received: by 2002:a17:906:a05a:b0:6ef:a44d:2f46 with SMTP id bg26-20020a170906a05a00b006efa44d2f46mr27868498ejb.192.1651075640777;
        Wed, 27 Apr 2022 09:07:20 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:20 -0700 (PDT)
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
        Jakob Koschel <jakobkoschel@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
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
Subject: [PATCH net-next v5 05/18] net: dsa: mv88e6xxx: remove redundant check in mv88e6xxx_port_vlan()
Date:   Wed, 27 Apr 2022 18:06:22 +0200
Message-Id: <20220427160635.420492-6-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427160635.420492-1-jakobkoschel@gmail.com>
References: <20220427160635.420492-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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


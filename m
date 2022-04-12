Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3A24FDF03
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347944AbiDLMFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351382AbiDLMCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC0878062;
        Tue, 12 Apr 2022 03:58:59 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u15so17893593ejf.11;
        Tue, 12 Apr 2022 03:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PwlvdFh40zWrnBHSnvRolkyWcqqdHXS406E/ZGgN6EM=;
        b=qbvgYgagzSXxv6YmhWQbxqNdOmSbQgfVFVfg080pnmD2QQT4ewAjsptb6A151wy3qB
         l6YN8srio8jNhYnocQB9/Du9NaXc7tZUtoTURut7ItC2ERogITRXDModlgdtZqjY2hoA
         vYjbslfGvCzth9QlMXFSRC8+gpbvhVtL9EnROoIzIai1bv0v+3U8etOIs85gXb2avuu0
         wXup3n/MaYi0FQUmW7W9MseeBhsedGuwcgBndyFWy1KvjzSHRp3PnwiU33VAYbjVdr+k
         XXZ7rWh6GJt6kkgM93uVduBBw0Piopt0wRQtEsiohjxYPFVFZXdutCjO5dD/WJCTgmfj
         RZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PwlvdFh40zWrnBHSnvRolkyWcqqdHXS406E/ZGgN6EM=;
        b=eXih0CSBXAC41lKBORjVqYfvD/7vSt0q9b0TVgKByaPdsCMlVt8478ELjS16uHmX+7
         xlhycBZncNyBKQqx6vWirlkaUkR0AtHxFT2GWRC3XJsUs0NwDa1ACVfqhaZdlUF4/Cz0
         LU/d21Lb0xz8tCiXfPkzk6eiFn/CQbwvaBVCZ/n+KeqZo7rsajGEGniUYuM2oVqH1DH+
         p4aOC/zP8G9scXMshMoOQfJARCquLrK6pxG8ELKV8cNek2wJ5qPruYJ7Osc2a0+EO7wS
         904ugEPLvdMtAOYLcKEbMnxYZa/CiUQIXk2GDitYIRYEs9FirNXIQp4sqXXQklXdrteY
         +/WQ==
X-Gm-Message-State: AOAM532khrwTbBNj2M2XdcUDuMUvdIBsToCBFcB7n/h1kKMnc7zBZauQ
        A3u//cJ0Hw9Sl9/p2hZ/Uio=
X-Google-Smtp-Source: ABdhPJwA+rvSjheEa32LQoy9hOd6Zb25JtwO8XMjJGvYpQlukrjH+4wgEFqK8xj7XJh4Ax1vjoAg/g==
X-Received: by 2002:a17:906:c111:b0:6db:cf0e:3146 with SMTP id do17-20020a170906c11100b006dbcf0e3146mr34735453ejc.280.1649761138218;
        Tue, 12 Apr 2022 03:58:58 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:58:57 -0700 (PDT)
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
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 05/18] net: dsa: mv88e6xxx: remove redundant check in mv88e6xxx_port_vlan()
Date:   Tue, 12 Apr 2022 12:58:17 +0200
Message-Id: <20220412105830.3495846-6-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412105830.3495846-1-jakobkoschel@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
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

We know that "dev > dst->last_switch" in the "else" block.
In other words, that "dev - dst->last_switch" is > 0.

dsa_port_bridge_num_get(dp) can be 0, but the check
"if (bridge_num + dst->last_switch != dev) continue", rewritten as
"if (bridge_num != dev - dst->last_switch) continue", aka
"if (bridge_num != something which cannot be 0) continue",
makes it redundant to have the extra "if (!bridge_num) continue" logic,
since a bridge_num of zero would have been skipped anyway.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
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


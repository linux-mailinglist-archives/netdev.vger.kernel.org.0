Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9640E67F6CA
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 10:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjA1JnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 04:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbjA1JnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 04:43:15 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C571A4B2;
        Sat, 28 Jan 2023 01:43:08 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kt14so19667129ejc.3;
        Sat, 28 Jan 2023 01:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+NVaJNsYOcpWsCC0UjHpjZYeJZxBoJYuUyff1fnBSQg=;
        b=Hmy5WkmGohJ9WVaWhgbfQE3weSi/D5Vwi6pPhpNnwzLVnBUQXutrArNwCNWo95bqX8
         all8KFENU+kOTKTA6wgPQfYquikXVlVWsB6Sduae1vJwPXtmgLL/qDF2e4J3iXc25m2J
         RD1qbCE4xSrPAM+SmO2a+R331lOCaxxoSPkuKimHehTC7/SP68n2sCwxrHTZWGzdUMa7
         6OVWpF4+mlj3omOBFGySxeXBOBQYGsQi8ls4yQRAI5uqGigIwoFehmlIMwq+a1bINYsj
         IImX+H/lhY1QVdapPuHHAxeZH2Lstk4mnUJU7VlQaV5FM7HkcMAoOJ0dlQkeoYGoRr1M
         mUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+NVaJNsYOcpWsCC0UjHpjZYeJZxBoJYuUyff1fnBSQg=;
        b=2RKZJ0XqHcptEMqPTEip+qaJG+4JckRLsAMXXNfCt0f/iB3qZU7Jzw5VlqnDxWNoEx
         +Ai2utz9C56up8kflCfNu+WOVtF5pC8PN7cRch4OJIzIQ92JpiJVEm2WCOub7K8/Nmtr
         pZxfUJsXB6oESEzT7f2A6C13DVgOMU8/5MyVudty+3OT4rxFUFiEojLf1QiYWPzccHv7
         71NlAvPg8fXzsLI/QQoUu4VLd/ii84MelB104UKSu02J4LNFcYQlEQONU1z6vXOTVSa4
         dpsK7n9/EwGbYLFlaIi/YjlV4yasCLqh3TyUmFCQP9hQQdkIW8NTHGjGhPdIkjkX05ZB
         K6UA==
X-Gm-Message-State: AFqh2kpt3tgrY3rz6vV9zEa/IlQbkLZRfGknBS5vD4hJx24B+s56gCvR
        SitsBqP6aJbDWkbyhVYuAlk=
X-Google-Smtp-Source: AMrXdXtkqnUY5Sa47hw9T1Zkd5PYap4RHk+CykKfG5lX93Cx6X/b7QG0F9HMIsbJZHdrNIgW0IkdAw==
X-Received: by 2002:a17:907:9118:b0:7c1:22a6:818f with SMTP id p24-20020a170907911800b007c122a6818fmr35050341ejq.25.1674898986863;
        Sat, 28 Jan 2023 01:43:06 -0800 (PST)
Received: from arinc9-PC.lan ([37.120.152.236])
        by smtp.gmail.com with ESMTPSA id z16-20020a170906435000b007b935641971sm3616723ejm.5.2023.01.28.01.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 01:43:06 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
Subject: [PATCH net] net: ethernet: mtk_eth_soc: disable hardware DSA untagging for second MAC
Date:   Sat, 28 Jan 2023 12:42:32 +0300
Message-Id: <20230128094232.2451947-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

According to my tests on MT7621AT and MT7623NI SoCs, hardware DSA untagging
won't work on the second MAC. Therefore, disable this feature when the
second MAC of the MT7621 and MT7623 SoCs is being used.

Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Link: https://lore.kernel.org/netdev/6249fc14-b38a-c770-36b4-5af6d41c21d3@arinc9.com/
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

Final send which should end up on the list. I tested this with Felix's
upcoming patch series. This fix is still needed on top of it.

https://lore.kernel.org/netdev/20221230073145.53386-1-nbd@nbd.name/

The MTK_GMAC1_TRGMII capability is only on the MT7621 and MT7623 SoCs which
I see this problem on. I'm new to coding so I took an educated guess from
the use of MTK_NETSYS_V2 to disable this feature altogether for MT7986 SoC.

Arınç

---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 801deac58bf7..f1cb1efc94cf 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3243,7 +3243,8 @@ static int mtk_open(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 	int i, err;
 
-	if (mtk_uses_dsa(dev) && !eth->prog) {
+	if ((mtk_uses_dsa(dev) && !eth->prog) &&
+	    !(mac->id == 1 && MTK_HAS_CAPS(eth->soc->caps, MTK_GMAC1_TRGMII))) {
 		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
 			struct metadata_dst *md_dst = eth->dsa_meta[i];
 
@@ -3260,7 +3261,8 @@ static int mtk_open(struct net_device *dev)
 		}
 	} else {
 		/* Hardware special tag parsing needs to be disabled if at least
-		 * one MAC does not use DSA.
+		 * one MAC does not use DSA, or the second MAC of the MT7621 and
+		 * MT7623 SoCs is being used.
 		 */
 		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 		val &= ~MTK_CDMP_STAG_EN;
-- 
2.37.2


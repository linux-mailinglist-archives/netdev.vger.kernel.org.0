Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897B45AAA78
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiIBIqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiIBIq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:46:28 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AD25018D
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 01:45:50 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id k18so1507786lji.13
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 01:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date;
        bh=XJ3GEUJfnEG0y62g59L9xe7ed2Im4vQIf8luI9e/xu8=;
        b=WmNqLFfw6vyhq10vWIuNIt5M7z4OzGftlpHbPhy1BLocI25C8hNPNVibnmJDg6YpC+
         oG60XaQIsiDJtSOlDElQLicbij69k9jk0bUtpq0NeUMzsB5EyZAAMtSh8jvbH9HzUwGI
         VnLbedfSx32zQd8fCiVJE1VJw0yvDihWWMJc2tcjQPPJnhFAMo1MQnDL68d7hd+quQsE
         /JNKMbixRI/lPN9HooTMAe2bHSaJo94A+aFb9JjsRfHLBxRnPkT9VamfilyZ91XoD640
         1T6A999dWerWT+gYnH8I77Wu/6sQK7ng8N3dkZJeiU0XqmTgpVR8GtM1at0Il95MabnG
         Df5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=XJ3GEUJfnEG0y62g59L9xe7ed2Im4vQIf8luI9e/xu8=;
        b=gUhcbWrDSqGXi4GgCfqhUSFx+zhIrSJhslzN0/eE2krOOe6QC+7ASlBq8J52DeiAUz
         yV6oWfbtnbqL5rVmtTjD2mrxRSMaDlO/MWZV1/4CY4VHJbzQfXrwJ1kWoY66kBQpdcBC
         94++Sp0JAR2hTaVp31V6LuoYeHQja3+mfvUFdr3Xya3hH8aIG3PE9+XBliRHrSyuUfqs
         YKdzR3r6EYijmOpJOwtoEr1/mflGDlqv5T6XR6Pz0rQpR5LZXeffGrYzu0C0dj+QHjG4
         SGtRM4W9UljNGMSfo2o/KVusw37qO7qKE7g7gWaepjSAl/Qji0Q3pHsWCWVD59BVQBHJ
         qorQ==
X-Gm-Message-State: ACgBeo31QahmttFopb888yCwyOvOUFP6Yd2lZNgpg3uBsy68cDFoUmu7
        eueaS8NIlDnGRBgd5aWgD2s=
X-Google-Smtp-Source: AA6agR5Xy6O9WgE11IFjU4k12Btz6L4e3iLDQe4310Vgwv01OkQG8moUb3kQsaRYRxqO1+9qQpLmBQ==
X-Received: by 2002:a05:651c:1112:b0:268:a0ad:ac1d with SMTP id e18-20020a05651c111200b00268a0adac1dmr2494457ljo.261.1662108348350;
        Fri, 02 Sep 2022 01:45:48 -0700 (PDT)
Received: from localhost.localdomain (c90-143-177-32.bredband.tele2.se. [90.143.177.32])
        by smtp.gmail.com with ESMTPSA id a12-20020a19e30c000000b00494942bec60sm183652lfh.17.2022.09.02.01.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 01:45:47 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Casper Andersson <casper.casan@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: sparx5: fix return values to correctly use bool
Date:   Fri,  2 Sep 2022 10:45:21 +0200
Message-Id: <20220902084521.3466638-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Function was declared to return bool, but used error return strategy (0
for success, else error). Now correctly uses bool to indicate whether
the entry was found or not.

Does not have any impact on functionality.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../ethernet/microchip/sparx5/sparx5_mactable.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index a5837dbe0c7e..4bc80bc7475f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -189,7 +189,8 @@ bool sparx5_mact_getnext(struct sparx5 *sparx5,
 bool sparx5_mact_find(struct sparx5 *sparx5,
 		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
 {
-	int ret;
+	bool found = false;
+	int err;
 	u32 cfg2;
 
 	mutex_lock(&sparx5->lock);
@@ -201,18 +202,18 @@ bool sparx5_mact_find(struct sparx5 *sparx5,
 		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
 		sparx5, LRN_COMMON_ACCESS_CTRL);
 
-	ret = sparx5_mact_wait_for_completion(sparx5);
-	if (ret == 0) {
+	err = sparx5_mact_wait_for_completion(sparx5);
+	if (!err) {
 		cfg2 = spx5_rd(sparx5, LRN_MAC_ACCESS_CFG_2);
-		if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(cfg2))
+		if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(cfg2)) {
 			*pcfg2 = cfg2;
-		else
-			ret = -ENOENT;
+			found = true;
+		}
 	}
 
 	mutex_unlock(&sparx5->lock);
 
-	return ret;
+	return found;
 }
 
 int sparx5_mact_forget(struct sparx5 *sparx5,
@@ -296,7 +297,7 @@ int sparx5_add_mact_entry(struct sparx5 *sparx5,
 	u32 cfg2;
 
 	ret = sparx5_mact_find(sparx5, addr, vid, &cfg2);
-	if (!ret)
+	if (ret)
 		return 0;
 
 	/* In case the entry already exists, don't add it again to SW,
-- 
2.34.1


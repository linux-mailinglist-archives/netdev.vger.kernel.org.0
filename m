Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA45155AC28
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiFYT3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 15:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiFYT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 15:29:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B6E13F5D;
        Sat, 25 Jun 2022 12:29:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so337141pji.4;
        Sat, 25 Jun 2022 12:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5lEV7bdqnDxF2NAwEQaD17yfLDKPDGXJ3egD+ggkUc=;
        b=JuFkR299mwMEl/sHjr8YsK7XkBcyohPBCGMflYSQenEHx83adbPHh8Ptx+F/W23Dxm
         yFAXkBkY7ErqSL3Ow9xju+nmn/2J50TeMR71bfP4YqN4Dr7y/5tRbDDEkcPQHXMlTEV3
         8o7ibWcvTqb9BTLsvQhTfSHMuWbBxrb9BtHxkIanzaxWmTfxC6H4KMBCFPP39eJv6Zdh
         Sd+4J56AplRlz2+XZ8Sxq5OUdOgtwAgkMGR3T2kEprDHBYs+n9Ypc2gWO5u3Ou+CqUYo
         HfN/URxPQVOkVcStOwEHkxNZLQ8f1Ae+b3cXjSrzJePWUQGPBmpHntOFA+dNDQ6QuVDp
         ZSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5lEV7bdqnDxF2NAwEQaD17yfLDKPDGXJ3egD+ggkUc=;
        b=0pj6ha02u4jLemPPqv4aFwR9RJwPUq0Vk2btMMhwFWP2h2NGA/lMLSqGefzvC0zlT6
         wkQqXGOMYWEmZpjTG1cwIPzx4M8ZJEVs8/QWBix6HxxFvH+4Jj36zedW+tIOmFI3YcYi
         K60rjMZV7+fjIahO2OskVYR03hCTsfvepQYTkJ5DRb+kVC+5mea/jhIpCI/Ux8/+RsbX
         VHM+F0rYRUxa6XsznPfozr6B4HWrsq416+LRW9CJpp7Kt/XkV5YKfGm0NX6cUFQNPqTV
         gd78t4BSjvdRmSDfAc0F976Ng7SJcAcoMttZ+ZB0vuhEU5QPLzNu1TKVxkKTaEVq7T2o
         Sz7w==
X-Gm-Message-State: AJIora988Vl05veVi9QU12snJG6kymPlSeHru0yCY6vcKYGfE8nC5Bmv
        SQKDv66aLw0FfpbJz21Zq8U=
X-Google-Smtp-Source: AGRyM1sBR1gbq+FRX/P79kfzBtenpKE3iztXCEXfUro5yRwMen+vBGatOmgkhGddAmSoQ7gzYnargQ==
X-Received: by 2002:a17:902:d488:b0:16a:158e:dd19 with SMTP id c8-20020a170902d48800b0016a158edd19mr5787747plg.105.1656185363072;
        Sat, 25 Jun 2022 12:29:23 -0700 (PDT)
Received: from ip-172-31-11-128.ap-south-1.compute.internal (ec2-15-207-248-140.ap-south-1.compute.amazonaws.com. [15.207.248.140])
        by smtp.gmail.com with ESMTPSA id c12-20020a17090a1d0c00b001ec92575e83sm3933650pjd.4.2022.06.25.12.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 12:29:22 -0700 (PDT)
From:   Praghadeesh T K S <praghadeeshthevendria@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Praghadeesh T K S <praghadeeshthevendria@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     praghadeeshtks@zohomail.in, skhan@linuxfoundation.org
Subject: [PATCH] net: wireless/broadcom: fix possible condition with no effect
Date:   Sat, 25 Jun 2022 19:29:01 +0000
Message-Id: <20220625192902.30050-1-praghadeeshthevendria@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Fix a coccinelle warning by removing condition with no possible effect

Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
---
 drivers/net/wireless/broadcom/b43/xmit.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
index 7651b1b..667a74b 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -169,12 +169,7 @@ static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
 	const struct b43_phy *phy = &dev->phy;
 	const struct b43_tx_legacy_rate_phy_ctl_entry *e;
 	u16 control = 0;
-	u16 bw;
-
-	if (phy->type == B43_PHYTYPE_LP)
-		bw = B43_TXH_PHY1_BW_20;
-	else /* FIXME */
-		bw = B43_TXH_PHY1_BW_20;
+	u16 bw = B43_TXH_PHY1_BW_20;
 
 	if (0) { /* FIXME: MIMO */
 	} else if (b43_is_cck_rate(bitrate) && phy->type != B43_PHYTYPE_LP) {
-- 
2.34.1


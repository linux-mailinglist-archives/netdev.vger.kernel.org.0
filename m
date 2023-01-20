Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690B067604B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjATWkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjATWk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:40:28 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D3778577;
        Fri, 20 Jan 2023 14:40:25 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id F27E61A07;
        Fri, 20 Jan 2023 23:40:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674254423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DaItXxFJlXbhnny9pEslryZf5rRWhsYt/rO9M38cY10=;
        b=oziOGAoAtdSNi/JUecBvPvqA2+q9KuVYTq8krY54od76W6nkT7pJpz5iBaNSk8zGbKHKKd
        01Zg6OgdKHxXC8+I2kUG9zuLZMOFJ1wCUxXoVkYsbltboDBF4jcfabCG07Ld0aSM8Thv9M
        CyRuMmsnu11fWPDX5T4v+1mP88wfnQTMH4X+NexNUm7fL3UXEZGAxptJwIMj8f1E+JeWgl
        QG0/S1bplKHe8s/9LU9ZlXN8/j77fP6WcnqFobtIpsi0ClNgpQOh8UpV2O9a5njKIKTPul
        eanYSQgWPxQTKXkFOs0Nqz87pJlIKDYgblbocTyjA9NoH8udIvY+g82lzg1MZw==
From:   Michael Walle <michael@walle.cc>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 5/5] net: phy: mxl-gpy: remove unneeded ops
Date:   Fri, 20 Jan 2023 23:40:11 +0100
Message-Id: <20230120224011.796097-6-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230120224011.796097-1-michael@walle.cc>
References: <20230120224011.796097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have proper c45-over-c22 support and the PHY driver promote
the PHY to a C45 device, we can drop the ops because the core will
already call them.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 4dc1093dbdc1..043c084a8a16 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -799,13 +799,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx),
 		.name		= "Maxlinear Ethernet GPY2xx",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -817,13 +815,11 @@ static struct phy_driver gpy_drivers[] = {
 		.phy_id		= PHY_ID_GPY115B,
 		.phy_id_mask	= PHY_ID_GPYx15B_MASK,
 		.name		= "Maxlinear Ethernet GPY115B",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -834,13 +830,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY115C),
 		.name		= "Maxlinear Ethernet GPY115C",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -852,13 +846,11 @@ static struct phy_driver gpy_drivers[] = {
 		.phy_id		= PHY_ID_GPY211B,
 		.phy_id_mask	= PHY_ID_GPY21xB_MASK,
 		.name		= "Maxlinear Ethernet GPY211B",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -869,13 +861,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY211C),
 		.name		= "Maxlinear Ethernet GPY211C",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -887,13 +877,11 @@ static struct phy_driver gpy_drivers[] = {
 		.phy_id		= PHY_ID_GPY212B,
 		.phy_id_mask	= PHY_ID_GPY21xB_MASK,
 		.name		= "Maxlinear Ethernet GPY212B",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -904,13 +892,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY212C),
 		.name		= "Maxlinear Ethernet GPY212C",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -922,13 +908,11 @@ static struct phy_driver gpy_drivers[] = {
 		.phy_id		= PHY_ID_GPY215B,
 		.phy_id_mask	= PHY_ID_GPYx15B_MASK,
 		.name		= "Maxlinear Ethernet GPY215B",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -939,13 +923,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY215C),
 		.name		= "Maxlinear Ethernet GPY215C",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -956,13 +938,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY241B),
 		.name		= "Maxlinear Ethernet GPY241B",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -973,13 +953,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY241BM),
 		.name		= "Maxlinear Ethernet GPY241BM",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
@@ -990,13 +968,11 @@ static struct phy_driver gpy_drivers[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_GPY245B),
 		.name		= "Maxlinear Ethernet GPY245B",
-		.get_features	= genphy_c45_pma_read_abilities,
 		.config_init	= gpy_config_init,
 		.probe		= gpy_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.config_aneg	= gpy_config_aneg,
-		.aneg_done	= genphy_c45_aneg_done,
 		.read_status	= gpy_read_status,
 		.config_intr	= gpy_config_intr,
 		.handle_interrupt = gpy_handle_interrupt,
-- 
2.30.2


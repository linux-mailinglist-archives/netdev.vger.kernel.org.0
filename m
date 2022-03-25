Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF4A4E7C12
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiCYVhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiCYVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:08 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47E84C781;
        Fri, 25 Mar 2022 14:35:31 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7C36622441;
        Fri, 25 Mar 2022 22:35:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XVjpM9D5VGrAUgKJMEHNq1fyfBDvN1zB6ahSnoH5oRg=;
        b=WGpo/+Y8zl0AwdHULMabyQrRBaUmf/6rJl7N9vyuQHfOyz+BDPHFn0VsF1DxBHrJchG0+s
        tVtJL+ovtqbxUwmK41dc45SLDkkoKtm7XmCvK4RuWZQ0XmNRJJekiwKQiMqqvDYyWBo00b
        PxueaPh43Sq/q6mqF8xmnXrQkhyQTec=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 8/8] net: phy: mxl-gpy: remove unneeded ops
Date:   Fri, 25 Mar 2022 22:35:18 +0100
Message-Id: <20220325213518.2668832-9-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325213518.2668832-1-michael@walle.cc>
References: <20220325213518.2668832-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index fe9417528444..c68c7621c3d9 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -513,13 +513,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -531,13 +529,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -548,13 +544,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -566,13 +560,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -583,13 +575,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -601,13 +591,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -618,13 +606,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -636,13 +622,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -653,13 +637,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -670,13 +652,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -687,13 +667,11 @@ static struct phy_driver gpy_drivers[] = {
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
@@ -704,13 +682,11 @@ static struct phy_driver gpy_drivers[] = {
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


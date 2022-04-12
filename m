Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DE4FCFB1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 08:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349628AbiDLGgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 02:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349319AbiDLGgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 02:36:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD8135DD0;
        Mon, 11 Apr 2022 23:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649745218; x=1681281218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mq3h1yyGxNGjLIox7hCoYlBU0GvesA0gIlk/iL9J+Ac=;
  b=xlcVY3vuqAP/1KahK/gFvzKh2pFeVhE5OX8XIi/KPQQSz/uRAR3+aeul
   OqUsGvT/n9XsPS4mvpCRY8cSJzxAiyLBa+cUnQeHmicxTqXL3WV4ITmiA
   u8yabzO/VCd/Pnk+QHl3r4dqMirmDDiDM/9jo9tQA09ze8M2n460N8DBm
   gltW7q+qFiow7Wm9KGOfVLempPq0C5+1OMAvcLwHWS6QzmtPzqsc93xm2
   PgHj228aJiJBUE4s7hesgsBJCay07956vX5RhrbF3ymOgXcl+AW8NbFar
   jMv23BsEkJ+us+v0BVtgBjGrFlBSJUo9g7q5JKQ0rwaJFIWvTYurFszga
   w==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643698800"; 
   d="scan'208";a="159767808"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2022 23:33:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 11 Apr 2022 23:33:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 11 Apr 2022 23:33:33 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [Patch net-next 1/3] net: phy: LAN937x: added PHY_POLL_CABLE_TEST flag
Date:   Tue, 12 Apr 2022 12:03:15 +0530
Message-ID: <20220412063317.4173-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220412063317.4173-1-arun.ramadoss@microchip.com>
References: <20220412063317.4173-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added the phy_poll_cable_test flag for the lan937x phy driver.
Tested using command -  ethtool --cable-test <dev>

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 389df3f4293c..363bfbfa182b 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -748,6 +748,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_LAN937X),
 		.name		= "Microchip LAN937x T1",
+		.flags          = PHY_POLL_CABLE_TEST,
 		.features	= PHY_BASIC_T1_FEATURES,
 		.config_init	= lan87xx_config_init,
 		.suspend	= genphy_suspend,
-- 
2.33.0


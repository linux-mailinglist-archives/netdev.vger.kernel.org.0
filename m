Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CC74CD18C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbiCDJpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiCDJpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:45:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9652C134DCC;
        Fri,  4 Mar 2022 01:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387058; x=1677923058;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EmjHiPsMxOOnWiYDwCWMUBLUdno138ROaGI7g3qe+u0=;
  b=bpFPhby/+7QgAG0SmEKfBsXsJGV1enYV6KpHVikl/3rEQtdlaSqFZI6g
   PfMWoykQErxoUEwdyajwjvVGf6RYEwwuykzgYix+NmF/KEo3ZddKXQM4h
   loDOjtxL7y0vKNy5ketg5pFE2h8l1qmwPZgTsPuN2ry5wNSW+vi0NRnEJ
   W0xw2G7QgZh9nysVzmh8LxDPvDA2KatpEMpzekcBoJZejxMaP0bzIHtQw
   0OcXG/GRvYP6cWWMiPRRaHCwgYgco+c1PpbYAD1uWbAqvH9vKAbWOkvhO
   QBbT+NqWSNF4g1+oNccjiQKKMLhUfUP2XU0PyrPS25FyNXOZPK1dXlAbB
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="148081499"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:44:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:44:17 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:44:13 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 0/6] Add support for LAN937x T1 Phy Driver
Date:   Fri, 4 Mar 2022 15:13:55 +0530
Message-ID: <20220304094401.31375-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x is a Multi-port 100Base-T1 Switch and it internally uses LAN87xx
T1 Phy.  This series of patch update the initialization routine for the
LAN87xx phy and also add LAN937x part support. Added the T1 Phy
master-slave configuration through ethtool.

Arun Ramadoss (6):
  net: phy: used genphy_soft_reset for phy reset in LAN87xx
  net: phy: used the PHY_ID_MATCH_MODEL macro for LAN87XX
  net: phy: removed empty lines in LAN87XX
  net: phy: updated the initialization routine for LAN87xx
  net: phy: added the LAN937x phy support
  net: phy: added ethtool master-slave configuration support

 drivers/net/phy/microchip_t1.c | 387 +++++++++++++++++++++++++++------
 1 file changed, 325 insertions(+), 62 deletions(-)


base-commit: f9f52c3474282a5485b28cf188b47d6e2efee185
-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69164C6ED1
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbiB1OGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiB1OGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:06:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75553B3DC;
        Mon, 28 Feb 2022 06:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646057132; x=1677593132;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1nZF0HpQ2wo0mAScS5ydtcfQp5ck1cBR9B27AfyPrAM=;
  b=tZWKUvbLtKKWTGrg4myYfVk323nhJidDmZnla9o0fHMOYmT64WIip0ec
   YooETTx+19MsWSRWCClbZhQWRc/3CyCRrl71/WE8fKRKetyvjWayGgc4T
   olPCjbm2qPpxeL+JeX3n+1KXgQLX4kTQHbARPKCtfvMca3+szLXJpOiAa
   KjGnsh9KROOKnI0qVzLTAIbzvlawkJrwMN7TqeytDEbXi0bcrVkXtLapR
   ZXqwbVZfoS4NtjhTev4zStvyUgSk5qtp24cXZyvXHNtwNT5Bb90TkaZzs
   ecgHRf7HBl6Kdm9nZeXGrrqp/zRQb66Tic4GRhlrcMzr3K3RfmhHD7vbC
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643698800"; 
   d="scan'208";a="163875295"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2022 07:05:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Feb 2022 07:05:28 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 28 Feb 2022 07:05:24 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net-next 0/4] Add support for LAN937x T1 Phy
Date:   Mon, 28 Feb 2022 19:35:06 +0530
Message-ID: <20220228140510.20883-1-arun.ramadoss@microchip.com>
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
T1 Phy.  This series of patch update the intialization routine for the
LAN87xx phy and also add LAN937x part support. Added the T1 Phy
master-slave configuration through ethtool.

Arun Ramadoss (4):
  net: phy: used the genphy_soft_reset for phy reset in Lan87xx
  net: phy: updated the initialization routine for LAN87xx
  net: phy: added the LAN937x phy support
  net: phy: added master-slave config and cable diagnostics for Lan937x

 drivers/net/phy/microchip_t1.c | 373 +++++++++++++++++++++++++++------
 1 file changed, 308 insertions(+), 65 deletions(-)

-- 
2.33.0


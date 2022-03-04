Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0224CD128
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbiCDJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238812AbiCDJgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:36:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDB518E3F1;
        Fri,  4 Mar 2022 01:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646386530; x=1677922530;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=OEBCwV4gYIEMY6/7C6NgMRZqVYsrG0pU0/zpgEqXjmA=;
  b=pal6YhWd+KQOilBWOfC0zEXQWVWZYdUXBwOOBYtgyxZxA7KOXrQfWUd3
   0PurYwOtTlBq/C0SY9+5eqVbUUAKwpEK+rjFsJY0V2rzhLmXnB4FjBoGE
   0yJuBd5bWymxSQZdANHKnbJoOWJg6LAQJSawKLyruPR5YF/W3dkxoqOG7
   +r6t28NrNZy5CN0A3nXjOxiChc2Le1rhsDXsbahFr8UdiHe3k/xLBr7N4
   Zi0G9oosLsSJ6o4a12bCxDOiw+Vt2dS0ayDa5GOUOr/Nt2VCD7ZD1duaf
   xQNtMqwtSPmB8PsvcCD/AlqQQUS1HngpG4sUAfx3C3t16PpOf7Z/tdYYA
   g==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150846843"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:35:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:35:29 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:35:24 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <madhuri.sripada@microchip.com>, <manohar.puri@microchip.com>
Subject: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Date:   Fri, 4 Mar 2022 15:04:15 +0530
Message-ID: <20220304093418.31645-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
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

The following patch series contains:
- Fix for concurrent register access, which provides
  atomic access to extended page register reads/writes.
- Provides dt-bindings related to latency and timestamping
  that are required for LAN8814 phy.
- 1588 hardware timestamping support in LAN8814 phy.

Divya Koppera (3):
  net: phy: micrel: Fix concurrent register access
  dt-bindings: net: micrel: Configure latency values and timestamping
    check for LAN8814 phy
  net: phy: micrel: 1588 support for LAN8814 phy

 .../devicetree/bindings/net/micrel.txt        |   17 +
 drivers/net/phy/micrel.c                      | 1114 ++++++++++++++++-
 2 files changed, 1097 insertions(+), 34 deletions(-)

-- 
2.17.1


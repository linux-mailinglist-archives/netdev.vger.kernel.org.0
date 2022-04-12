Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0714FCF9E
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 08:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349068AbiDLGgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 02:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349222AbiDLGf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 02:35:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863FA35A98;
        Mon, 11 Apr 2022 23:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649745207; x=1681281207;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wdOz0G9dFdtEHxJLQ2VMc63tUbkujekIH18wACrbNj4=;
  b=oGtcjD/ElL3ZEfFeh9DEXgFzGQRDRO0lcVMtJWDIrH9E8W/n5U4w5XeO
   MMG5WrWLaPPdgrRgLrbVQN8hW20xmQvS1I/8JlPM8r2rTxkWmCquNXFrJ
   nzzLw0v1Vpah44RC7y2xCFBN3/TkuCPrcKpSX36FoPTJgUtnT6NQZLa0/
   o55UhlXwtDrWnYmaRHRIOwbb1/B3MJlv9iqh5KdKOncz4K1wD3F3ZZGd5
   gq1wEVo3hnOQ1ew1wQtFF2uts7eBw0T8F5Rn2+kelPda7OvlTS8M17V+U
   7ijEkrxc9rkoOIhEfnjj/rK0K7hgTod1LPpHUhDwXobp1cvaMCMSX4D0t
   w==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643698800"; 
   d="scan'208";a="160188581"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2022 23:33:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 11 Apr 2022 23:33:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 11 Apr 2022 23:33:23 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [Patch net-next 0/3] add ethtool SQI support for LAN87xx T1 Phy
Date:   Tue, 12 Apr 2022 12:03:14 +0530
Message-ID: <20220412063317.4173-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
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

This patch series add the Signal Quality Index measurement for the LAN87xx and
LAN937x T1 phy. Added the PHY_POLL_CABLE_TEST flag for LAN937x phy. Updated the
maintainers file for microchip_t1.c.

Arun Ramadoss (3):
  net: phy: LAN937x: added PHY_POLL_CABLE_TEST flag
  net: phy: LAN87xx: add ethtool SQI support
  MAINTAINERS: Add maintainers for Microchip T1 Phy driver

 MAINTAINERS                    |  6 +++++
 drivers/net/phy/microchip_t1.c | 49 ++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)


base-commit: b66bfc131c69bd9a5ed3ae90be4cf47ec46c1526
-- 
2.33.0


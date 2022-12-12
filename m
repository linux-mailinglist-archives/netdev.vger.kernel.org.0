Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251A9649D83
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiLLLYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiLLLX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:23:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2768C2B;
        Mon, 12 Dec 2022 03:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670844213; x=1702380213;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qE3rGYPHT42eUSwMS/SUMBxIsdKWa8DJkE2Olb7Y7K8=;
  b=Lyvf+Z7TlxJjd2LE3+HGv4uaaW5H2ba2nfOK22RKzheYX3wzwlLsr1Dp
   Q92octGv1cvUTCypCVnz4EHApnNxENo1M62aIJy8SE5LD5Py8cYymfycB
   xmMQ4PFUIVFTtcqDnn4/KHaUwLm2TiHNm8jYvgkbbWv+ZTBJUZLEg0uX4
   ljkbgHcBWwy76wwVg95NQkxhHWrQWCxgxU2TvupmvLWDJ+qD8/JkNHmpp
   Ao6Vt0MQpdwgI+S/NqxMVUkNnSxsApaQ+z2fXXRt4oYbe7VnfuLuKPJBv
   HbMzHRnThZtWUlpDw5esxn/mAfF/DyfNL188N8ltqaWclWI3lo/EEEieF
   A==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="127662327"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 04:23:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 04:23:32 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 04:23:29 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 0/2] net: macb: fix connectivity after resume
Date:   Mon, 12 Dec 2022 13:28:43 +0200
Message-ID: <20221212112845.73290-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series fixes connectivity on SAMA7G5 with KSZ9131 ethernet PHY.
Driver fix is in patch 2/2. Patch 1/2 is a prerequisite.

Thank you,
Claudiu Beznea

Changes in v2:
- patch 1 has been updated to call phy_init_hw() on phylink_resume()
- patch 2 is new; the previous one was only calling phy_init_hw()

Claudiu Beznea (2):
  net: phylink: init phydev on phylink_resume()
  net: macb: use phylink_suspend()/phylink_resume()

 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++----------
 drivers/net/phy/phylink.c                |  6 ++++++
 2 files changed, 13 insertions(+), 10 deletions(-)

-- 
2.34.1


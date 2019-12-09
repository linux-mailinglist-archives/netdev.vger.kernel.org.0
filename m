Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1FC11771E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 21:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLIUMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 15:12:39 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:58066 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLIUMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 15:12:38 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB9KCYgE127564;
        Mon, 9 Dec 2019 14:12:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575922354;
        bh=b1dx9RfgDJ5UAlXPjVOL/TLMzf8DwKXRH4HKbwoZ1xk=;
        h=From:To:CC:Subject:Date;
        b=sPJ9LnkI4+PRHXs90VTX1TGCSOAmuoJF30NNu6y+dlsU+Awu0asI7S+OpXhAxlUIK
         V0Mlu9D/4/XWg+iKV+mGGD+FRsq2j6DiKTSq+KHegmuEN/zUsRhK+RuEQLrmcbALBc
         ckaPRZ+cLxnybGux/LC8b+PqjCRoZmBMowMPFbLE=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB9KCYP5036567
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 9 Dec 2019 14:12:34 -0600
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 9 Dec
 2019 14:12:33 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 9 Dec 2019 14:12:34 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9KCX3Y022354;
        Mon, 9 Dec 2019 14:12:33 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 0/2] Fix Tx/Rx FIFO depth for DP83867
Date:   Mon, 9 Dec 2019 14:10:23 -0600
Message-ID: <20191209201025.5757-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

The DP83867 supports both the RGMII and SGMII modes.  The Tx and Rx FIFO depths
are configurable in these modes but may not applicable for both modes.

When the device is configured for RGMII mode the Tx FIFO depth is applicable
and for SGMII mode both Tx and Rx FIFO depth settings are applicable.  When
the driver was originally written only the RGMII device was available and there
were no standard fifo-depth DT properties.

The patchset converts the special ti,fifo-depth property to the standard
tx-fifo-depth property while still allowing the ti,fifo-depth property to be
set as to maintain backward compatibility.

In addition to this change the rx-fifo-depth property support was added and only
written when the device is configured for SGMII mode.

Dan

Dan Murphy (2):
  dt-bindings: dp83867: Convert fifo-depth to common fifo-depth and make
    optional
  net: phy: dp83867: Add rx-fifo-depth and tx-fifo-depth

 .../devicetree/bindings/net/ti,dp83867.txt    | 12 +++-
 drivers/net/phy/dp83867.c                     | 62 +++++++++++++++----
 2 files changed, 58 insertions(+), 16 deletions(-)

-- 
2.23.0


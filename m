Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E151C40F913
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243735AbhIQN1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:27:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:41049 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241419AbhIQN1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885187; x=1663421187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QssFTqsZ5UAlTmqKAKaZZcz9WX/De78bpUot5wsvlI0=;
  b=kdqCqkn8UdTe/9HIzpaw/fPcltHDHpLsmSGe2t/7t28qRP26v6qprOsY
   +Zmhx1Bk+P6veJz5Uk/WuyGgON9OwaqJLMFbf1hEyX7TfmSVO/vAdmSQx
   ZPtJvV/x8Cp0TgmOeRH8vs8Hb0s6DvQ5aPLNhtDtEYu44/Tmv4poVnOR3
   RbQ+ZEDTNof2VaKqODI854tcl7zXa8F/uoASKUnW7/HL70eexgTO8AgOq
   ml84K2Sk3YljbXXo0mxeanFmQfnP9DJ77pHdAN4fznAK+34PnoN65guB8
   brk+jaXwrHpA0CGlrjCxZ0+w89NamOGj2TkqDbeZYSwGK2zbvLH9VjWL7
   w==;
IronPort-SDR: 3R+lmdd7iZ3OoRIT6G0O3tGMmM8OwlrF1F5NxpJQeOTH+XWAVDhMfegpBsQ6insIk5MSnJJEfJ
 9tkFEKc5i1h4bK8CY0WefzWua2a3eqjXUOtTTXIcme/ipP/JxWWgjaCi6/BGYhqIXheyLmbtch
 kz6EVNOj3/+cPwuQWpNn5Zm49ikFLgm7jc/Hzrf2AFNPTaTarSthMGygPi6h92Dk3/vQjpgvYE
 YzR2Q/USDQ9d+Q3iovpQ+x/oWmwyCJsx5WXfZbgO0Je583azCTLu16WrGTkP0MGFmkKY+vhVWT
 g7AoaA6BkBNlCktK6HFaUoAr
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="136363995"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:26:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:26:25 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 17 Sep 2021 06:26:24 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 4/4] net: macb: enable mii on rgmii for sama7g5
Date:   Fri, 17 Sep 2021 16:26:15 +0300
Message-ID: <20210917132615.16183-5-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210917132615.16183-1-claudiu.beznea@microchip.com>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both MAC IPs available on SAMA7G5 support MII on RGMII feature.
Enable these by adding proper capability to proper macb_config
objects.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index cdf3e35b5b33..e2730b3e1a57 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4597,7 +4597,8 @@ static const struct macb_config zynq_config = {
 };
 
 static const struct macb_config sama7g5_gem_config = {
-	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG,
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG |
+		MACB_CAPS_MIIONRGMII,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
@@ -4605,7 +4606,8 @@ static const struct macb_config sama7g5_gem_config = {
 };
 
 static const struct macb_config sama7g5_emac_config = {
-	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_USRIO_HAS_CLKEN,
+	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII |
+		MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_MIIONRGMII,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
-- 
2.25.1


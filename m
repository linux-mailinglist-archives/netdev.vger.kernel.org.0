Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C342FDE5
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbhJOWMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:12:36 -0400
Received: from mx3.wp.pl ([212.77.101.9]:14371 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhJOWMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:12:36 -0400
Received: (wp-smtpd smtp.wp.pl 2578 invoked from network); 16 Oct 2021 00:10:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1634335826; bh=VJELnwuVsY6Fvxf/y6HrM3j278T4TgY0rp9y2CnGkos=;
          h=From:To:Cc:Subject;
          b=HzvJ7D88e8VlbrH65OVxDejMmN7CllqRsxHjh989gUxUhiFdvHL6+8g1Uma1Oep3Z
           EvudjxSdaQqQUhCrmRv2L6kKCF1OVfSOgcNk1VUHROAcOy6tL/puxVyspihG7+89l3
           yZJkKW4gE0AvKRzR6KUJKrKqy+MBEVMFRtW5mvoE=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 16 Oct 2021 00:10:26 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net] net: dsa: lantiq_gswip: fix register definition
Date:   Sat, 16 Oct 2021 00:10:20 +0200
Message-Id: <20211015221020.3590-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 5fec2bb4fb05d58b6178e70acd2b2e16
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gTNk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I compared the register definitions with the D-Link DWR-966
GPL sources and found that the PUAFD field definition was
incorrect. This definition is unused and causes no issues.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/dsa/lantiq_gswip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 3ff4b7e177f3..dbd4486a173f 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -230,7 +230,7 @@
 #define GSWIP_SDMA_PCTRLp(p)		(0xBC0 + ((p) * 0x6))
 #define  GSWIP_SDMA_PCTRL_EN		BIT(0)	/* SDMA Port Enable */
 #define  GSWIP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
-#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(1)	/* Pause Frame Forwarding */
+#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(3)	/* Pause Frame Forwarding */
 
 #define GSWIP_TABLE_ACTIVE_VLAN		0x01
 #define GSWIP_TABLE_VLAN_MAPPING	0x02
-- 
2.30.2


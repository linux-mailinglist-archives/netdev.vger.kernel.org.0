Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC0430F2D0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhBDMBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:01:50 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:34058 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbhBDMBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 07:01:49 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7cro-008lpZ-5v; Thu, 04 Feb 2021 11:32:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 7/9] lan78xx: set maximum MTU
Date:   Thu,  4 Feb 2021 11:31:19 +0000
Message-Id: <20210204113121.29786-8-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix setting of maximum MTU to support jumbo frames.

This was missed in the work to add the NAPI support.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index a4278f9dc319..9bd21d17d6f1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4252,6 +4252,9 @@ static int lan78xx_probe(struct usb_interface *intf,
 	if (ret < 0)
 		goto out3;
 
+	/* MTU range: 68 - 9000 */
+	netdev->max_mtu = LAN78XX_MAX_MTU;
+
 	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
 	netif_napi_add(netdev, &dev->napi, lan78xx_poll, LAN78XX_NAPI_WEIGHT);
-- 
2.17.1


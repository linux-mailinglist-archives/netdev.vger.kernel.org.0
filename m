Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF24C3F1130
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 05:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhHSDGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 23:06:50 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45052 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbhHSDGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 23:06:48 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17J3624t8007588, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17J3624t8007588
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Aug 2021 11:06:02 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 19 Aug 2021 11:06:01 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 19 Aug
 2021 11:06:00 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 2/2] r8152: fix the maximum number of PLA bp for RTL8153C
Date:   Thu, 19 Aug 2021 11:05:37 +0800
Message-ID: <20210819030537.3730-379-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210819030537.3730-377-nic_swsd@realtek.com>
References: <20210819030537.3730-377-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36501.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/19/2021 02:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzgvMTggpFWkyCAxMToyNTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/19/2021 02:54:56
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165646 [Aug 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/19/2021 02:57:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum PLA bp number of RTL8153C is 16, not 8. That is, the
bp 0 ~ 15 are at 0xfc28 ~ 0xfc46, and the bp_en is at 0xfc48.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 3fd17b6dc61d..79832374f78d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3955,13 +3955,24 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	case RTL_VER_06:
 		ocp_write_byte(tp, type, PLA_BP_EN, 0);
 		break;
+	case RTL_VER_14:
+		ocp_write_word(tp, type, USB_BP2_EN, 0);
+
+		ocp_write_word(tp, type, USB_BP_8, 0);
+		ocp_write_word(tp, type, USB_BP_9, 0);
+		ocp_write_word(tp, type, USB_BP_10, 0);
+		ocp_write_word(tp, type, USB_BP_11, 0);
+		ocp_write_word(tp, type, USB_BP_12, 0);
+		ocp_write_word(tp, type, USB_BP_13, 0);
+		ocp_write_word(tp, type, USB_BP_14, 0);
+		ocp_write_word(tp, type, USB_BP_15, 0);
+		break;
 	case RTL_VER_08:
 	case RTL_VER_09:
 	case RTL_VER_10:
 	case RTL_VER_11:
 	case RTL_VER_12:
 	case RTL_VER_13:
-	case RTL_VER_14:
 	case RTL_VER_15:
 	default:
 		if (type == MCU_TYPE_USB) {
@@ -4331,7 +4342,6 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 		case RTL_VER_11:
 		case RTL_VER_12:
 		case RTL_VER_13:
-		case RTL_VER_14:
 		case RTL_VER_15:
 			fw_reg = 0xf800;
 			bp_ba_addr = PLA_BP_BA;
@@ -4339,6 +4349,13 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 			bp_start = PLA_BP_0;
 			max_bp = 8;
 			break;
+		case RTL_VER_14:
+			fw_reg = 0xf800;
+			bp_ba_addr = PLA_BP_BA;
+			bp_en_addr = USB_BP2_EN;
+			bp_start = PLA_BP_0;
+			max_bp = 16;
+			break;
 		default:
 			goto out;
 		}
-- 
2.31.1


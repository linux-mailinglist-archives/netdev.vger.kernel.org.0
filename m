Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0214361B22
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 10:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhDPIGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:06:48 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60532 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbhDPIGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 04:06:36 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13G866Sm8023557, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13G866Sm8023557
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Apr 2021 16:06:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 16 Apr 2021 16:06:05 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 16 Apr
 2021 16:06:03 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/6] r8152: adjust rtl8152_check_firmware function
Date:   Fri, 16 Apr 2021 16:04:33 +0800
Message-ID: <1394712342-15778-352-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-350-Taiwan-albertk@realtek.com>
References: <1394712342-15778-350-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMTYgpFekyCAwNjowMDowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/16/2021 07:42:45
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163158 [Apr 16 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/16/2021 07:45:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMTYgpFekyCAwNjozODowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/16/2021 07:46:47
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163158 [Apr 16 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/16/2021 07:50:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bits operations to record and check the firmware.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 51 +++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 10db48f4ed77..28c9b4dc1a60 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -874,6 +874,14 @@ struct fw_header {
 	struct fw_block blocks[];
 } __packed;
 
+enum rtl8152_fw_flags {
+	FW_FLAGS_USB = 0,
+	FW_FLAGS_PLA,
+	FW_FLAGS_START,
+	FW_FLAGS_STOP,
+	FW_FLAGS_NC,
+};
+
 /**
  * struct fw_mac - a firmware block used by RTL_FW_PLA and RTL_FW_USB.
  *	The layout of the firmware block is:
@@ -3800,10 +3808,7 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 {
 	const struct firmware *fw = rtl_fw->fw;
 	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
-	struct fw_mac *pla = NULL, *usb = NULL;
-	struct fw_phy_patch_key *start = NULL;
-	struct fw_phy_nc *phy_nc = NULL;
-	struct fw_block *stop = NULL;
+	unsigned long fw_flags = 0;
 	long ret = -EFAULT;
 	int i;
 
@@ -3832,50 +3837,52 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 				goto fail;
 			goto fw_end;
 		case RTL_FW_PLA:
-			if (pla) {
+			if (test_bit(FW_FLAGS_PLA, &fw_flags)) {
 				dev_err(&tp->intf->dev,
 					"multiple PLA firmware encountered");
 				goto fail;
 			}
 
-			pla = (struct fw_mac *)block;
-			if (!rtl8152_is_fw_mac_ok(tp, pla)) {
+			if (!rtl8152_is_fw_mac_ok(tp, (struct fw_mac *)block)) {
 				dev_err(&tp->intf->dev,
 					"check PLA firmware failed\n");
 				goto fail;
 			}
+			__set_bit(FW_FLAGS_PLA, &fw_flags);
 			break;
 		case RTL_FW_USB:
-			if (usb) {
+			if (test_bit(FW_FLAGS_USB, &fw_flags)) {
 				dev_err(&tp->intf->dev,
 					"multiple USB firmware encountered");
 				goto fail;
 			}
 
-			usb = (struct fw_mac *)block;
-			if (!rtl8152_is_fw_mac_ok(tp, usb)) {
+			if (!rtl8152_is_fw_mac_ok(tp, (struct fw_mac *)block)) {
 				dev_err(&tp->intf->dev,
 					"check USB firmware failed\n");
 				goto fail;
 			}
+			__set_bit(FW_FLAGS_USB, &fw_flags);
 			break;
 		case RTL_FW_PHY_START:
-			if (start || phy_nc || stop) {
+			if (test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
 				dev_err(&tp->intf->dev,
 					"check PHY_START fail\n");
 				goto fail;
 			}
 
-			if (__le32_to_cpu(block->length) != sizeof(*start)) {
+			if (__le32_to_cpu(block->length) != sizeof(struct fw_phy_patch_key)) {
 				dev_err(&tp->intf->dev,
 					"Invalid length for PHY_START\n");
 				goto fail;
 			}
-
-			start = (struct fw_phy_patch_key *)block;
+			__set_bit(FW_FLAGS_START, &fw_flags);
 			break;
 		case RTL_FW_PHY_STOP:
-			if (stop || !start) {
+			if (test_bit(FW_FLAGS_STOP, &fw_flags) ||
+			    !test_bit(FW_FLAGS_START, &fw_flags)) {
 				dev_err(&tp->intf->dev,
 					"Check PHY_STOP fail\n");
 				goto fail;
@@ -3886,28 +3893,28 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 					"Invalid length for PHY_STOP\n");
 				goto fail;
 			}
-
-			stop = block;
+			__set_bit(FW_FLAGS_STOP, &fw_flags);
 			break;
 		case RTL_FW_PHY_NC:
-			if (!start || stop) {
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
 				dev_err(&tp->intf->dev,
 					"check PHY_NC fail\n");
 				goto fail;
 			}
 
-			if (phy_nc) {
+			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
 				dev_err(&tp->intf->dev,
 					"multiple PHY NC encountered\n");
 				goto fail;
 			}
 
-			phy_nc = (struct fw_phy_nc *)block;
-			if (!rtl8152_is_fw_phy_nc_ok(tp, phy_nc)) {
+			if (!rtl8152_is_fw_phy_nc_ok(tp, (struct fw_phy_nc *)block)) {
 				dev_err(&tp->intf->dev,
 					"check PHY NC firmware failed\n");
 				goto fail;
 			}
+			__set_bit(FW_FLAGS_NC, &fw_flags);
 
 			break;
 		default:
@@ -3921,7 +3928,7 @@ static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 	}
 
 fw_end:
-	if ((phy_nc || start) && !stop) {
+	if (test_bit(FW_FLAGS_START, &fw_flags) && !test_bit(FW_FLAGS_STOP, &fw_flags)) {
 		dev_err(&tp->intf->dev, "without PHY_STOP\n");
 		goto fail;
 	}
-- 
2.26.3


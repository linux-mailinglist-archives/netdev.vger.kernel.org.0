Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C24E369EFE
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 08:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhDXGL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 02:11:58 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:34032 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhDXGL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 02:11:56 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13O6B8uH4001152, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13O6B8uH4001152
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 24 Apr 2021 14:11:08 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 24 Apr 2021 14:11:08 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Sat, 24 Apr
 2021 14:11:06 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: remove some bit operations
Date:   Sat, 24 Apr 2021 14:09:03 +0800
Message-ID: <1394712342-15778-362-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMjQgpFekyCAwNDo1OTowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/24/2021 05:56:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163316 [Apr 23 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/24/2021 06:00:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/24/2021 05:56:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163316 [Apr 23 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/24/2021 06:00:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove DELL_TB_RX_AGG_BUG and LENOVO_MACPASSTHRU flags of rtl8152_flags.
They are only set when initializing and wouldn't be change. It is enough
to record them with variables.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 9986f8969d02..136ea06540ff 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -767,8 +767,6 @@ enum rtl8152_flags {
 	PHY_RESET,
 	SCHEDULE_TASKLET,
 	GREEN_ETHERNET,
-	DELL_TB_RX_AGG_BUG,
-	LENOVO_MACPASSTHRU,
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
@@ -934,6 +932,8 @@ struct r8152 {
 	u32 fc_pause_on, fc_pause_off;
 
 	u32 support_2500full:1;
+	u32 lenovo_macpassthru:1;
+	u32 dell_tb_rx_agg_bug:1;
 	u16 ocp_base;
 	u16 speed;
 	u16 eee_adv;
@@ -1594,7 +1594,7 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	acpi_object_type mac_obj_type;
 	int mac_strlen;
 
-	if (test_bit(LENOVO_MACPASSTHRU, &tp->flags)) {
+	if (tp->lenovo_macpassthru) {
 		mac_obj_name = "\\MACA";
 		mac_obj_type = ACPI_TYPE_STRING;
 		mac_strlen = 0x16;
@@ -2283,7 +2283,7 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 
 		remain = agg_buf_sz - (int)(tx_agg_align(tx_data) - agg->head);
 
-		if (test_bit(DELL_TB_RX_AGG_BUG, &tp->flags))
+		if (tp->dell_tb_rx_agg_bug)
 			break;
 	}
 
@@ -6941,7 +6941,7 @@ static void r8153_init(struct r8152 *tp)
 	/* rx aggregation */
 	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	if (test_bit(DELL_TB_RX_AGG_BUG, &tp->flags))
+	if (tp->dell_tb_rx_agg_bug)
 		ocp_data |= RX_AGG_DISABLE;
 
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
@@ -9447,7 +9447,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
-			set_bit(LENOVO_MACPASSTHRU, &tp->flags);
+			tp->lenovo_macpassthru = 1;
 		}
 	}
 
@@ -9455,7 +9455,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	    (!strcmp(udev->serial, "000001000000") ||
 	     !strcmp(udev->serial, "000002000000"))) {
 		dev_info(&udev->dev, "Dell TB16 Dock, disable RX aggregation");
-		set_bit(DELL_TB_RX_AGG_BUG, &tp->flags);
+		tp->dell_tb_rx_agg_bug = 1;
 	}
 
 	netdev->ethtool_ops = &ops;
-- 
2.26.3


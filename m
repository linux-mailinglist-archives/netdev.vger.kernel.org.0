Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E44A1D9EAC
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgESSC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:02:26 -0400
Received: from mail-eopbgr100102.outbound.protection.outlook.com ([40.107.10.102]:62080
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729089AbgESSC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 14:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcQQKZhseJqu42pCi1MlpsnhnDF4BsPw5L94e1105JdAAwPsLjj27cYT4++BfjnaSM8metZPWDCyrxRUO8k/Bn5GEUwkyPKTKxyxjIO/NZqOSRM0T1Oqzy2M2QZZBK8d1fvAIO2/JOvIIb0if3XzoXRVxGym8AC0BBgFsWhlJDtnc9yrOkYmybZh77EeAtmtQD2OkmokfeZJ+8WUzazW9O/Nbiakzg///ZGbYv8VM9JP/rALAkfi30ujLdmitE4OcTx0d0+iv3kvnW2IPvLnQvU+CPW1NCYLDqSjEUjO2YdtxnL/bu4E9W2UQssJ+vRRqScrSCA3MxqOW46W1n4zSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f22Ihmg00Fpd5lCHSRRP+8jOnT6qa703QfQa7GCmd9g=;
 b=eSlMD0YcGjQ65RyeRzuhKYyHZ4hzs5GwRBy+o29EVlHAFi0cBDPqGRkCT7qbeRgp96P4ojr7j55UaHRQiPN3NDLiGWBJ6UCEYCMJ90+ahth9Nxpn52PETvj7qPgwef5LSSE96rw1VDhUuBHRiop/LWFjRUVq/Poa4jx7k245HyWPW2ybuBAnKXyTSOFcTJvOkl35HLmx9kfioU48oaR2oC1DGCP7AX/Dxgs4L26E1gNvhNIsD2SzNFirWyQRgc5dn9CNcxxvmvqL2r76Kgpybt6Mb9V3MWQVT7JVPji8p3gvEwZ8xOR4FnQ2elUY3ffCbpXIfvwJCGMdLejcTCybAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mdpsys.co.uk; dmarc=pass action=none header.from=mdpsys.co.uk;
 dkim=pass header.d=mdpsys.co.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mdpsys.onmicrosoft.com; s=selector1-mdpsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f22Ihmg00Fpd5lCHSRRP+8jOnT6qa703QfQa7GCmd9g=;
 b=GNcnOyMe4Vf0QzpU4nlDI1PQoEkpIpH9xYfQ/81joKBIr1JJK18I6htti4p4XvH2vTrfn35jUQRRCQ6NA2PWet6B4ESJy6n79rgBW5OVIcIPdPVVeLEh0qcjzueveLSHa6w4NYidO/VItfdZHS0tubr6QyNFuxQghQlrV+r/mQQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mdpsys.co.uk;
Received: from LO2P123MB1934.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:c6::20)
 by LO2P123MB2574.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Tue, 19 May
 2020 18:02:22 +0000
Received: from LO2P123MB1934.GBRP123.PROD.OUTLOOK.COM
 ([fe80::91ff:f59:2fa9:29d8]) by LO2P123MB1934.GBRP123.PROD.OUTLOOK.COM
 ([fe80::91ff:f59:2fa9:29d8%4]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 18:02:22 +0000
From:   Marc Payne <marc.payne@mdpsys.co.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Oliver Neukum <oliver@neukum.org>
Cc:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        Marc Payne <marc.payne@mdpsys.co.uk>
Subject: [PATCH] r8152: support additional Microsoft Surface Ethernet Adapter variant
Date:   Tue, 19 May 2020 19:01:46 +0100
Message-Id: <20200519180146.2362-1-marc.payne@mdpsys.co.uk>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::15) To LO2P123MB1934.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:c6::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nuc-arch.mdpnet.uk (86.134.74.138) by LO2P265CA0027.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Tue, 19 May 2020 18:02:22 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [86.134.74.138]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8746c6d-40a6-4bc7-c5bc-08d7fc1ec7b5
X-MS-TrafficTypeDiagnostic: LO2P123MB2574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <LO2P123MB25740AA971AB62596FAC4D6FB8B90@LO2P123MB2574.GBRP123.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JEln6urpWU4zpQRCMxlKsLrlZakJQlNpRcyyQpnCaxfZwR12Jhb0EBGUcoh6WcHDoEWIO6zGJIBrA/mensgIRxX/cAdOvbV+ecIZB7QRVkEvUsH7yEY22pFjQa63xz0TpbMMg0RsN18CZzTwzEGwr/D8uj55wDeEy6Y/vDSOPyFESInctw82VNb1PQ96nvlpcUyrXf/xUP/UzBXV7xn5NupWVCCuMR9St6aoOxbWARP+Qpc8zhLZz5vl0HWkBdRsleOZfDFm930Wnl3b5V+PxrMboHqXe3/nNbIdoooJ9qD+pxz7yV5a1XEhW3J/QpMV8dYqKtTQ+VV2cMgKm8jWgEOdUXioxw+ZLVd7hgw9J8vI1Fnqsxq/FFBK/WR1AsF3jl2WVaRh3efQ7xtLaLt48kgeyFPBMU1xzufCopJbyOWHvi5oAQBFRQOhZ5sQjRHb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB1934.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(39830400003)(376002)(396003)(366004)(47530400004)(107886003)(45080400002)(5660300002)(1076003)(316002)(6666004)(6512007)(52116002)(36756003)(8936002)(4326008)(8676002)(54906003)(6506007)(110136005)(508600001)(26005)(186003)(16526019)(66556008)(52230400001)(2906002)(86362001)(6486002)(44832011)(2616005)(66946007)(66476007)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IO0BK0Zj3bl9AOwtRQpWoNgqg/g00PuYPRkS4/lJ0TntmCnJ7KZYLYuEzkHJY6jAZdRG29YAszSoL43lDRwdp/n/w7PWoqMthwbKjzrq3dR/wm5aoOB/tdaOFA+ZPKcP84FaGftXfwqrtYFsCAhJbqIR5STYleKgfh9Ag4Hc0JNEcVjqNbUkgd3CewACNhJVGxJH4xKUpiH1J0IWyWR3sjbwBh61Mh1h+xc84tYqNqau77/U4wJ2zPuEbzS8VgBEtuk0QQxug7EOEZK4s+7BYJEV9B0i3qy++aFoSUASj/ZNxtCu7BOMPFdU5EbhsidSXHqovWZbZKZEwRVunMRD/1TeQMV0kgiBC1l+GLF03wt0cdHDSp+d4yTvw1E25FVxMJx67MHjQqV+mywgFh/5Vd8zzOtcHjsl+rck+VJ3NNNFfve+4sYD0BFy10edVY4/gJVzXIGGZ/a260i/rI/JJGKAk4BE3xS5lStOn7nq6Ro=
X-OriginatorOrg: mdpsys.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: b8746c6d-40a6-4bc7-c5bc-08d7fc1ec7b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 18:02:22.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 07eb37f3-62d1-4b5c-a7c4-ed2a24dbebc2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WReECpioGkFsi68SptV9zRnEoUe7vsdRZ/RafPHth2Vt8KpANcZwQ/t907nioZE5wppVNEEmclqTYbLynSJt+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P123MB2574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device id 0927 is the RTL8153B-based component of the 'Surface USB-C to
Ethernet and USB Adapter' and may be used as a component of other devices
in future. Tested and working with the r8152 driver.

Update the cdc_ether blacklist due to the RTL8153 'network jam on suspend'
issue which this device will cause (personally confirmed).

Signed-off-by: Marc Payne <marc.payne@mdpsys.co.uk>
---
 drivers/net/usb/cdc_ether.c | 11 +++++++++--
 drivers/net/usb/r8152.c     |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 0cdb2ce47645..a657943c9f01 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -815,14 +815,21 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
-/* Microsoft Surface 3 dock (based on Realtek RTL8153) */
+/* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x07c6, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
-	/* TP-LINK UE300 USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
+/* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153B) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x0927, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
+/* TP-LINK UE300 USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, 0x0601, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8f8d9883d363..c8c873a613b6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6880,6 +6880,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
-- 
2.26.2


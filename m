Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7C4A4F13
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358940AbiAaS6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:58:24 -0500
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:43494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358793AbiAaS6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:58:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVa190GUBTH3Zb1sTOg5HOlXjKvDmRuK3X6fme+MBWVea/Nqg7+WtbA/CBtm4yimuVihOgnWvjKKZ7mLlM8MNvdl00kZ9bjPYIuyBn6yZxGZDrEENaOIOWxFZuRoubcQ8NbhJU/lABwMUI0ZLeQUr2FFFlC6snE+PhBmtIvROEDCXqcv3CUBfD5gstudLFMfNJPYT4QjxEH0BIyAL5XNywQRv37YIeoNNOeA/vOQ/0sGe/yD3Yqyn+aN9Ty7leR9SCicIQVMR1MTaTZRGbYZk05mhnSFcTYYbbV4/v46A6iJtIVprvkiUMa7Ajo0OI5IYdFiDj5SJQt2nlYtColmuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6nKj64t+rKGP9Ks+0eihHBka4tTvMidteY7PgV051M=;
 b=Wv8wvqQDv22VmPW0rVlBYAe3JnMhU8IYqvAwNZm1FecE7/F/n2eFkGN18UuWgFtyilLXkcEqFKyzfm0u/lsmT+Y1co4JVDs+soizug6C/NSQamQt1gMa/CTVDXH2KYftFXj4G4E96o+4ZWAkQvcf059FiKhfifNwfjp71zHlW1d3r++XNvXliPExuh1zRiKFOg2k1JPwqc9hoB9ZdFOBi3A+X0Y8MnlJe4Gja6kGCGFIUJAE7HNJpwnBStwKka65c+0mtAMFeInsmOT3N7S1AJeFjNoFIvcvn6sXrLGxwnKOct6HYoKlw7v81zIKbVLoTk4KS1jzvp+wTJQJdmMasQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6nKj64t+rKGP9Ks+0eihHBka4tTvMidteY7PgV051M=;
 b=G0ymYy1QgTDpHIl4yoAi3L1Qm0aQkC3ggod+MNA6FYPBrSEXmu00JGTSX7j+5FZd02wv95WNULV9TK3MKrdG4ELV9PBaPC9lfp8f8OxLQ1byhTkujzjH4sVVmSXOSoP5YOZ3L1o/M+wid2hrwDO7LGFA05/XpbSaQCQqmwxQQ7bkrcCvsD4x3v7BHVVDf9deL9Yct6I+X81ZpzMiEv4OE/bF6MCNu1pmrLUHAQUpWG37NyVecLQDcqyPmpZ8wV9ZO0zkLc9MCF+8RhjPbCURlzw3hVex9o1a7Nj2NgoglXIhke7R5sjsr6IuLMElbk/BkqD/cZYT/ZEIdDPArvkcBw==
Received: from SV0P279CA0059.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:14::10)
 by PA4PR10MB4478.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:100::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 18:58:17 +0000
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:f10:14:cafe::a) by SV0P279CA0059.outlook.office365.com
 (2603:10a6:f10:14::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 18:58:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 18:58:16 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 31 Jan 2022 19:58:16 +0100
Received: from [167.87.32.84] (167.87.32.84) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 31 Jan
 2022 19:58:15 +0100
Message-ID: <2f001839-2628-cf80-f5e3-415e7492e206@siemens.com>
Date:   Mon, 31 Jan 2022 19:58:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Georgi Valkov <gvalkov@abv.bg>
CC:     linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.32.84]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ad1a14c-8467-4e21-837b-08d9e4eba3fb
X-MS-TrafficTypeDiagnostic: PA4PR10MB4478:EE_
X-Microsoft-Antispam-PRVS: <PA4PR10MB44781576D3B444915CE23EB495259@PA4PR10MB4478.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmquV7lZhAc5koCVhpe/D06JHKP5IGXR9S34s0q+/oLotSubacrLV2KqpVhZp3R4Pu+cwgYb5EYARdXQd2XboLo85wN5Rh3JnqFSfC04jMNAUCp2TwYNmFHNg1fSRBF38ifzC/MyN2DkbdfIbMyppRpBTky03hhvQMkM0aMweMCIrQiMhC/2ne9JE1A5LCqweI2C6n4qZvbMHrJyb9x58NXBqULV7j+9mLLIaM2K0eaO8xA7EfoMg0XGGdFStI64FnR3ro2ZHCvudqXTT7bTk0gxPFCBJDgiS+Pre7sSpakyLha/2pzs+N7IlAr3pUsk2yfI6D/7+ysZSSJCqBkXKxmFrpbhISvCf6+ggArJaoGLAW0qWUiZXvOOpycO8QIFhiyvCESFuzXHtPLZIXq2AJUh4tUqZsuQrytAVKiWnMzp5OfAlKoiJRuK3n9+0sGy9VVqlvGT9pZCkTDRf1tdLnYQwiyw3O+0LFp765jSX8a+B+pqw6tD7vrK2HwtraQOIL3u1TBh01xi7fL1Rd6uR7nA1KRZ1A8OcvsiU5yXdEOdH9NKSdzdNS+AJadZ4S4fAxz20k8DByBq7atf+xPZ5flSf0MLPd9GOL/XwK5OZD7EsDwX558hH9k22SL3UV0WCUDzOpabTrm7LFm6iqnQcYRPrJC0pnzG50dwxqA/BDsqJNyk9vK2u7RoEbTaGL7TSPHrZpv8OYCBOQHccSGj8rNwfAmeHxkc+yP0WZ52yJbm0TVRNoE50s2QcPweYQbf7Q/WcV6zD87Ezo0/RYkQAg==
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2616005)(5660300002)(44832011)(82310400004)(83380400001)(186003)(26005)(16526019)(336012)(36860700001)(47076005)(956004)(2906002)(110136005)(6706004)(54906003)(316002)(40460700003)(356005)(81166007)(31686004)(16576012)(70206006)(86362001)(31696002)(508600001)(82960400001)(36756003)(4326008)(70586007)(8936002)(8676002)(3940600001)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 18:58:16.8439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad1a14c-8467-4e21-837b-08d9e4eba3fb
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR10MB4478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Georgi Valkov <gvalkov@abv.bg>

When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
which reduces the usable size by 2 bytes. Otherwise we have 1512
bytes usable instead of 1514, and if we receive more than 1512
bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
after which the driver malfunctiones and all communication stops.

Resolves ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75

Fixes: f33d9e2b48a3 ("usbnet: ipheth: fix connectivity with iOS 14")
Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
---
  drivers/net/usb/ipheth.c | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index cd33955df0b6..6a769df0b421 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
  	if (tx_buf == NULL)
  		goto free_rx_urb;
  
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
  				    GFP_KERNEL, &rx_urb->transfer_dma);
  	if (rx_buf == NULL)
  		goto free_tx_buf;
@@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
  
  static void ipheth_free_urbs(struct ipheth_device *iphone)
  {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
  			  iphone->rx_urb->transfer_dma);
  	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
  			  iphone->tx_urb->transfer_dma);
@@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
  
  	usb_fill_bulk_urb(dev->rx_urb, udev,
  			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
  			  ipheth_rcvbulk_callback,
  			  dev);
  	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-- 
2.34.1

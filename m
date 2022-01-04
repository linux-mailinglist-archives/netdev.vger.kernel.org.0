Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16AB484102
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiADLiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:38:21 -0500
Received: from mail-eopbgr00046.outbound.protection.outlook.com ([40.107.0.46]:2096
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230166AbiADLiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 06:38:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwgOvSwRw2MRi12vv4xNNAoCKyzUKKZu6q6hJCux/I/pXVKLYRVxkSlGvrJU4az68fk2bd4Tuyrzs9clWvNWWmTMhy4t1usLetp6BPX10yoCps3ZAKPduqVJhtOsTp3zxK0zrY+5kjLIfFHPF3WIGxD3kjE6T+n+UOU3X+9s4kWccJ0A911sRy955zmyFm8PtkxMv3ZbMxZb/D5PZSqMZ4n7zk0+hbfJCnUjZcyPXsvGe6o1dD7QrgVYP1SevF4ettuv1kcr0afb7WFUv4qjcHAGf8aRN2nGAxdhUUnK+u7r7QNFxlUFU9Ysf+csucXWcZsZnW1/0l+GYbDJNjL7/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ9F2JqgP+RafjOsIHZdERztQrTtQ02DYxLtaV2SsKI=;
 b=JpC7PLe4bHBRjmC1LnrPBpLyTyEi7IPAF1x2+A9R7vxQVWhloLA+7FFUgaFNj7f0rdj+ClHB9luEBATSxOB95bDKu6Vv2FRP3in3T2LjssAj32plMeIgWicx977NZ50iSfIFMRM9qDdiL5/KZyQguzm7VQCvZoltSR58ILOUqjV+jGnINygDurE3qQOAMCbKq6/XVUbfNbnNQNBuSFmDabxV71Xym62cYUugXBf2OitQdyNqA8wLmiKWffT2EmRqIx0wY2+chAjHVvd6Xiu0TwKX6e/NSkI8Je7Q6c83E7Hz+VR2xDc8yVilRVJyU7TbGLPthi9UFMpyLWXi9xkbvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ9F2JqgP+RafjOsIHZdERztQrTtQ02DYxLtaV2SsKI=;
 b=AvxGy8nUx+HhCIemWppq9jPxlXP2Av2cEXQK5fIo9w4+MNk4sEIw/OCie2x0ytQIfVhUU3eX8agxnFP6RBMpzskjpbeltH76AkZFKfF2WBuDgTl1a7VKFwfD5Gf7cpgopQav4BnRLAyrAjao/w5QrY80pHpJCzTokqhJ89zbspULpFoaZL1PJtWkM47Ob19pHAAvPV1+3nJ39dSUVd5+ZnCecouu7BbetRXuCc/34W2r7mJNsWLvbFM0YM/AmAYtAv80KscR5DDFNxEgnFJrHfxAFJNIXdW8LSAfGH5H3bzAIRwKfozivYBV3VIit2Cg6CMyRCgQX5wbx496ltofTQ==
Received: from DB9PR05CA0008.eurprd05.prod.outlook.com (2603:10a6:10:1da::13)
 by AM0PR10MB2370.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:d7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Tue, 4 Jan
 2022 11:38:18 +0000
Received: from DB5EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:1da:cafe::f1) by DB9PR05CA0008.outlook.office365.com
 (2603:10a6:10:1da::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 11:38:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 DB5EUR01FT038.mail.protection.outlook.com (10.152.4.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 11:38:18 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 12:38:17 +0100
Received: from md1za8fc.ad001.siemens.net (167.87.0.7) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 12:38:17 +0100
Date:   Tue, 4 Jan 2022 12:38:14 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hayeswang@realtek.com>,
        <tiwai@suse.de>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
In-Reply-To: <20211116141917.31661-1-aaron.ma@canonical.com>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.0.7]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80931c7e-e1fe-435c-c9b4-08d9cf76b404
X-MS-TrafficTypeDiagnostic: AM0PR10MB2370:EE_
X-Microsoft-Antispam-PRVS: <AM0PR10MB237002782E044BC4091C4DE3854A9@AM0PR10MB2370.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68xzEBTXD5Mnenirnyc9WQM2/jO2TWZb6Coew39WsXZXNCoH5zjA3R4XdETdzbAz0VFQSkS7wu5dt3h027K8jC0S3c99GzC2ZgHgoHDai8KzIK4DMcoaN5kmoRioyVyenJNfb//oj8qeZYXtSCxyHU4t2EWIng3qu/0lhZsIJu/u/aSrrAgL3wBZy+yU6YwizrUWryrzXvIoz0+uJD+vABb4N6TX0Fz+PadJRWKDOCsqVsyzEde6VJUQnl59BZs7COQOFXPG0495/LTJdy7bPPgq8ZiKiyYTKanyAtveQopXKvvD3a/xyxHjmMuZ9A/8csQ6QdUo57o4u6tRwOe/QsShnPPVar/JsV/sAzvBQvO+cRLYvTW+Er7HdsJiJp8cvDkLfoeeElfKjW80ZOVYIX75ocbU9IA+K5rO+qIGRbTyvEIRoXEuTHMdal7O6fLFiw2pEY6ktNGAn9rT9borO9TLDx5z/A1hdssnHO3CTxhEVhb8P7Y0I3JtM8VCFh+jh85iB2EkmCKVJqd71/hEFINBCrqtnMUFMHD5qU2mlRvdvyqSBFiBpzBnKyUc8gXPOV4Thd/H9+vgURkY+DehfJZ3YKbJCvocJd0MY1THpEXzTdASagxSDKQZcERq49BKysA98/JsDy9cf5Te2hRi1J3rGKKjmqJUbFo/zLCPm4JjAMNIQVmhSZ6Lzo8IsOQlvAFTqIPkpEYpt7pKFyr1HoNoPUA8hv+aOW1t7mka0TjivxqpA0ZHJvoD2bVpo2JF/5G6BVefSR4Z0w4887w5Y5XY8tabhBip5/zwASqDybE=
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(44832011)(36860700001)(82310400004)(186003)(7696005)(54906003)(8936002)(356005)(83380400001)(81166007)(16526019)(2906002)(26005)(6666004)(9686003)(55016003)(498600001)(47076005)(70206006)(956004)(336012)(40460700001)(70586007)(8676002)(4326008)(5660300002)(82960400001)(86362001)(6916009)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 11:38:18.2157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80931c7e-e1fe-435c-c9b4-08d9cf76b404
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT038.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is wrong and taking the MAC inheritance way too far. Now any
USB Ethernet dongle connected to a Lenovo USB Hub will go into
inheritance (which is meant for docks).

It means that such dongles plugged directly into the laptop will do
that, or travel adaptors/hubs which are not "active docks".

I have USB-Ethernet dongles on two desks and both stopped working as
expected because they took the main MAC, even with it being used at the
same time. The inheritance should (if at all) only be done for clearly
identified docks and only for one r8152 instance ... not all. Maybe
even double checking if that main PHY is "plugged" and monitoring it to
back off as soon as it is.

With this patch applied users can not use multiple ethernet devices
anymore ... if some of them are r8152 and connected to "Lenovo" ...
which is more than likely!

Reverting that patch solved my problem, but i later went to disabling
that very questionable BIOS feature to disable things for good without
having to patch my kernel.

I strongly suggest to revert that. And if not please drop the defines of

> -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:

And instead of crapping out with "(unnamed net_device) (uninitialized):
Invalid header when reading pass-thru MAC addr" when the BIOS feature
is turned off, one might want to check
DSDT/WMT1/ITEM/"MACAddressPassThrough" which is my best for asking the
BIOS if the feature is wanted.

regards,
Henning

Am Tue, 16 Nov 2021 22:19:17 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> Like ThinkaPad Thunderbolt 4 Dock, more Lenovo docks start to use the
> original Realtek USB ethernet chip ID 0bda:8153.
> 
> Lenovo Docks always use their own IDs for usb hub, even for older
> Docks. If parent hub is from Lenovo, then r8152 should try MAC
> passthrough. Verified on Lenovo TBT3 dock too.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 4a02f33f0643..f9877a3e83ac 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -9603,12 +9603,9 @@ static int rtl8152_probe(struct usb_interface
> *intf, netdev->hw_features &= ~NETIF_F_RXCSUM;
>  	}
>  
> -	if (le16_to_cpu(udev->descriptor.idVendor) ==
> VENDOR_ID_LENOVO) {
> -		switch (le16_to_cpu(udev->descriptor.idProduct)) {
> -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
> -			tp->lenovo_macpassthru = 1;
> -		}
> +	if (udev->parent &&
> +
> le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO) {
> +		tp->lenovo_macpassthru = 1;
>  	}
>  
>  	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 &&
> udev->serial &&


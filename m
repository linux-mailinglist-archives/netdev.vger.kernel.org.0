Return-Path: <netdev+bounces-3256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5357063EF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A8D2815E0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC60110956;
	Wed, 17 May 2023 09:18:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DD7525D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:18:38 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2108.outbound.protection.outlook.com [40.107.92.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF964F9;
	Wed, 17 May 2023 02:18:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRK3h2oc1mnHHQhNvIIpIQchNpkKsI7euVI/d6lT3UEHyyPggY9kRC2/189OSS96P8Cx/EhhWWihVz4sUPQVZGhom+igTUQA7ixDD4vdu5M3fGSJgGKvxUHQR80Z0hFYLXi/gKaHuNrHBeSVT10w0kPPvhusphyHskCGnhw2rsNMBIsdz9AdFywbXMNJL/5yl7zOd/Dj1ouZ+68fMmr6hitihlCDrpOuHIscjJj2EwI4MSzQvS4YBDEYSnYXR16nd8QppGJkQrxGEXHYd9iNgYpSB0+tHJRe3G99q2cZUlfoLt+qD/qGCKc1+crQcD990fCLIUENNNuvsgWSYIODtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/c/dyGKWIEaz1GDKa1vUbo3Zc2+2T+xiidEqpoOMg4=;
 b=XuaeTPflv2SXWD6ltfRpqxKZLYIvkbA3xEF3J8VedY6cq+iWKi0M6CQzNyjvDxV1m93mX/QEYT4RBo4m2K5ksmFtnNgZak+h8Gx9+rvJeySjfRi3tNJfi3wBy+3tiaMVvyREja1UIuDcIOroiuK0Wx88rBXVISKFqTuIDix1OMKvTDPtoTq5ZU+pQkadBHi+G63bCP27bCH5mOp1s93HFBZ53TWPfKwEcpt/r/xzNryAISA5HVJf2isxi8spWo8oZq6LWU+wVJmv7W37lz+LzzKv+Ss254gvM7tb18j72GgjgNz05tz8HbI+KWcF0aM6etR2WRqkaFUZ0YbpeEdtvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/c/dyGKWIEaz1GDKa1vUbo3Zc2+2T+xiidEqpoOMg4=;
 b=HX/cBlA44jvoVH4Tz4EIFlZJGvZKa8xGBRrbeHJnfXpgoxlrBh/dsQtdUR3D13J38shMOraIKvd2A/+7q0Rqn9IQhA7Z9EhvaHnHQd1YdSQBnWldnWlAnCs6GEGV8hxUIZBSrYwj9kxcgIvfb5OfdAvGkMR98fop6CvueFL9L+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4773.namprd13.prod.outlook.com (2603:10b6:303:fb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 09:18:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 09:18:33 +0000
Date: Wed, 17 May 2023 11:18:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Foster Snowhill <forst@pen.gy>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-usb@vger.kernel.org, netdev@vger.kernel.org,
	Georgi Valkov <gvalkov@gmail.com>
Subject: Re: [PATCH] net: usb: ipheth: add CDC NCM support
Message-ID: <ZGSb4l8XcxclFsB1@corigine.com>
References: <20230516210127.35841-1-forst@pen.gy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516210127.35841-1-forst@pen.gy>
X-ClientProxiedBy: AM3PR07CA0074.eurprd07.prod.outlook.com
 (2603:10a6:207:4::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4773:EE_
X-MS-Office365-Filtering-Correlation-Id: ea479466-b9a5-4214-3c0d-08db56b7af88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SeqBYTzpx4HdxAt7Mb1/GKcf90i23ABVdgx1dGWaE9Wb4pOcxYOsKsHP51FII8k8fUP8llku/GbBXkoN3JJ+tpDTD0IoJv/cjmz4COA+PUDxLwrE70dFotvDyzjh4cGfLM3U4qzxk/PPV8kVKzF4rVD+eLyDjHIvfaPwA8NfWC9/z7nhfgt+9GrtGo5c5vqRr6Pu4yrUFPd6JPt/s5tBgILLEoyNy+Zo2aOz18C17P68UFJaExcHXnw8ceuGRtzEBwSsvoPz332CBAR0gUZqLy9jMDRIK8J8Nfx1cZ3t0cZ+AvavGDivuM/bK31QlTxu9r4lGNGDfyk3ecKv6xq+JH8BvbGqugMtcwaORrtr/JAVhpqvGktLHYS0f9LIOKar197B2n0Nsk22PJTRgldE8AJwFIBApThLoA9hsDbmuak8LOvGfkQFpVVAqfrVZNl8Maioslv1KrDyCQjQjS57YICKJuUB9nYrDvWQLflO79zWC0f2EDW8MFLvFXIStvum9U+viMzz3RdrYhTnFG1xLP5yWoqSvOkJ7/k2k+5nYQc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(36756003)(86362001)(54906003)(66946007)(66556008)(66476007)(4326008)(316002)(966005)(6916009)(478600001)(6666004)(8936002)(8676002)(41300700001)(6486002)(5660300002)(2906002)(44832011)(38100700002)(2616005)(6506007)(6512007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Av1AabyPGSDrEejc4E0ppbY1XLmghj2rQ2rn7B4tTN6DwUmIZD4juk2EIOUV?=
 =?us-ascii?Q?7XG02/n/7wQAXG+mJOlMBrRMQGJrA0xFm5sx7/JXGzB+SgJ7rN2U13RL9bs7?=
 =?us-ascii?Q?PlL28Q6RqazDh1Q0+8f5XVYAzpTwOzK2UdDtB1lwYjOgL4j+uFyJlFCaKZ5A?=
 =?us-ascii?Q?jSUO1wa3sNVt8/vl33jcXR7Om7fVSrmCWX+uK6zfJJrwCnW8FOKWj5zPNqKd?=
 =?us-ascii?Q?3l/4rYZyemerO5NcLlHKTLVP0upW6guag0aZ+DPdRs4RqT7KHlqwKqZG8w2X?=
 =?us-ascii?Q?3BAcUHC6/aAeYBTEONxTAHku0tYv0+iDqsglJf3obchfG4cjwgrgRI8Yxjr+?=
 =?us-ascii?Q?oIw/PUA5jb4fawN+iEUUnDz6tG5aM133pRZdWfWLEHxz0upHD+EbCyHMzdwL?=
 =?us-ascii?Q?qMk4yvcumNrx0STLWyXl2AjhwahrpnfVtYqlt/qC05DcNiRSpzPxSF53dNWN?=
 =?us-ascii?Q?S2z8N+089rCcgL0an3HS7Q88Q1uw0WUYHbGUm1iLa2q4Vlv3ryTcyz+aEclf?=
 =?us-ascii?Q?lmfe/BgI9eB+RWdXR+dTPPUaRsBvaLztko0l+WgcXvzfUoMQP6AAU2wlB536?=
 =?us-ascii?Q?lL0jLbCqiwwZHwPRqVcoL32B/jhG9UkXn0/gvoe5ovUM+xD59iLJFhP24Gbk?=
 =?us-ascii?Q?GTIiJpKEdhyWNHxD4kmC/4k235bVo0yHVhke0EehpGXt3nhIKdvi72O8J2OY?=
 =?us-ascii?Q?vtgcyrWQ85HhPo+QzRDkRYPQcC/KvMvaYCNbkr3PnHSusO9zRXmuNmXHPJg+?=
 =?us-ascii?Q?PrdjmdVJAwQrZ1V3irBlsWqPXIHFwotLmnfZxrdwWcom75QOTFrC6q61fDPz?=
 =?us-ascii?Q?l0HOkLMv2mx3KGuKo1+rbsb9uFwKiFPYml2+Nt69FcuiHEYxEri6LCOQo+4l?=
 =?us-ascii?Q?oXM7KrdMuf/Iil1SdpZMEybeo5DxVrUI5T20Gpxm/XzeOO8k22uV7HOSvxWB?=
 =?us-ascii?Q?FBYD6s4Z6/kUKQvzxTbrVJc7Hxg4bZc1vpem10kiXTDtfUv+RewFI+vfZDmE?=
 =?us-ascii?Q?B/ubOX3XIm79iBvvPHPqwkbsJ/PtdJN1OfuDdUKaIC/dd9lX0jMNiCjXDKPJ?=
 =?us-ascii?Q?19Q++Is3ZLA0Nyrt7AtSctlrYPXBhhATKpxi+okE/uGiLfrL61kIJTyU7zZR?=
 =?us-ascii?Q?8Lyy+l50R5wMF5B1QMavgwzfd2lXZE92mJX5Y2FKiNfhNr1n03XBnr1/7O+z?=
 =?us-ascii?Q?PcY+xDnmTgP/exJfdLg4+jn8t5G+P1eR9I80Zxcfki3DyqwPYd9cVxPQhDj7?=
 =?us-ascii?Q?y75EgsLairF0ABthwkbZeW6SBXDXm8CyhOZ6izAN+z6a4eudhXw4zBBtiKxp?=
 =?us-ascii?Q?NyD6e34d7W3RDP3FbnZEM6DuNs9fJOfgRFE7rW+Gq+s4XMQVEOQDNpfvNn2M?=
 =?us-ascii?Q?8NXi0NEL67eFf3EfstnTX5/mYRo8FsV42OsVXPydEgLCq1T6ZV0bDOKtfFRV?=
 =?us-ascii?Q?dZIT/NTRDSr2nE7lAjis/knZgOvC7hYrHDXzECSrRs4+V0prX41SnmtyjRNI?=
 =?us-ascii?Q?0/5c+Jtrgq12OYE2ZKez5QG3su9yCoBA+j7qzy3NLZ+lMH8aG6Zv2YvvALZA?=
 =?us-ascii?Q?TRSMKkC6rzO4DZE7zg9CxaZYT2Rxp/Go7o6hN12g/HqJ1EM4A33gE+KCvdyx?=
 =?us-ascii?Q?Ml6GfNJObNjOzVIojNqIGLEF1MBrdxCmsQ9j27OmgY+vwbQlN3JWW71wQ4uJ?=
 =?us-ascii?Q?+5PuZw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea479466-b9a5-4214-3c0d-08db56b7af88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 09:18:32.9637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HuZb2LutzHDpnD6qMS+wYeurmvq0v9k/5+Ns1poWvLniyy8BcirADyih5wFAIAjOlD4cEL6ff1S2p7883StZlGIjS3/L+XQ7HYn7aJfxXEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4773
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:01:51PM +0000, Foster Snowhill wrote:
> Recent iOS releases support CDC NCM encapsulation on RX. This mode is
> the default on macOS and Windows. In this mode, an iOS device may include
> one or more Ethernet frames inside a single URB.
> 
> Freshly booted iOS devices start in legacy mode, but are put into
> NCM mode by the official Apple driver. When reconnecting such a device
> from a macOS/Windows machine to a Linux host, the device stays in
> NCM mode, making it unusable with the legacy ipheth driver code.
> 
> To correctly support such a device, the driver has to either support
> the NCM mode too, or put the device back into legacy mode.
> 
> To match the behaviour of the macOS/Windows driver, and since there
> is no documented control command to revert to legacy mode, implement
> NCM support. The device is attempted to be put into NCM mode by default,
> and falls back to legacy mode if the attempt fails.
> 
> Signed-off-by: Foster Snowhill <forst@pen.gy>
> Tested-by: Georgi Valkov <gvalkov@gmail.com>
> ---
> Georgi Valkov and I have been using this patch for one year with OpenWrt,
> Linux kernel versions 5.10 and 5.15 on the following devices:
> 
> * Linksys WRT3200ACM (Marvell Armada 385, ARMv7-A LE), with iPhone 7 Plus
> * Linksys EA8300 (Qualcomm IPQ4019, ARMv7-A LE), with iPhone Xs Max
> 
> Georgi also performed limited tests on
> 
> * TP-Link TL-WR1043ND (QCA9558, MIPS 74Kc BE)
> * OrangePi Zero (Allwinner H2+, ARMv7-A LE)
> 
> There is an interest, specifically from Georgi, to have this patch
> backported to v5.15 to then be used in OpenWrt.
> 
> Neither me nor Georgi are by any means skilled in developing for the
> Linux kernel. Please review the patch carefully and advise if any
> changes are needed in regards to security (e.g. data validation)
> or code formatting.

Hi Foster,

thanks for your patch.

Some initial feedback follows (hopefully there will be feedback from
others too).

nit: The target tree for this patch is probably net-next.
     As such it should be included in the Subject:

     Subject: [PATCH net-next v2] ...

     Link: https://kernel.org/doc/html/latest/process/maintainer-netdev.html

nit: Looking at Git history, probably the patch prefix should be
     'usbnet: ipheth: '

     Subject: [PATCH net-next v2] usbnet: ipheth: ...

Above you mention 5.10 and 5.15. I see that this patch applies
to current net-next, which is where development occurs. Has
the patch been tested there?

> ---
>  drivers/net/usb/ipheth.c | 186 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 152 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
> index 6a769df0b..3cdf92b39 100644
> --- a/drivers/net/usb/ipheth.c
> +++ b/drivers/net/usb/ipheth.c
> @@ -52,6 +52,7 @@
>  #include <linux/ethtool.h>
>  #include <linux/usb.h>
>  #include <linux/workqueue.h>
> +#include <linux/usb/cdc.h>
>  
>  #define USB_VENDOR_APPLE        0x05ac
>  
> @@ -59,8 +60,11 @@
>  #define IPHETH_USBINTF_SUBCLASS 253
>  #define IPHETH_USBINTF_PROTO    1
>  
> -#define IPHETH_BUF_SIZE         1514
>  #define IPHETH_IP_ALIGN		2	/* padding at front of URB */
> +#define IPHETH_NCM_HEADER_SIZE  (12 + 96) /* NCMH + NCM0 */
> +#define IPHETH_TX_BUF_SIZE      ETH_FRAME_LEN
> +#define IPHETH_RX_BUF_SIZE      65536

I wonder if there are any issues with increasing the RX size
from 1514 to 65536. Not that I have anything specific in mind.

> +
>  #define IPHETH_TX_TIMEOUT       (5 * HZ)
>  
>  #define IPHETH_INTFNUM          2

...

> +static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
> +{
> +	struct ipheth_device *dev;
> +	struct usb_cdc_ncm_nth16 *ncmh;
> +	struct usb_cdc_ncm_ndp16 *ncm0;
> +	struct usb_cdc_ncm_dpe16 *dpe;
> +	char *buf;
> +	int len;
> +	int retval = -EINVAL;

For networking code, please arrange local variables in reverse xmas tree
order - longest line to shortest. There is, IMHO, no need to go and fix any
existing instances. But please follow this for new code.

Something like this:

	struct usb_cdc_ncm_nth16 *ncmh;
	struct usb_cdc_ncm_ndp16 *ncm0;
	struct usb_cdc_ncm_dpe16 *dpe;
	struct ipheth_device *dev;
	int retval = -EINVAL;
	char *buf;
	int len;

> +
> +	dev = urb->context;
> +
> +	if (urb->actual_length < IPHETH_NCM_HEADER_SIZE) {
> +		dev->net->stats.rx_length_errors++;
> +		return retval;
> +	}
> +
> +	ncmh = (struct usb_cdc_ncm_nth16 *)(urb->transfer_buffer);

nit: There is no need to cast a void pointer.

> +	if (ncmh->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN) ||
> +	    le16_to_cpu(ncmh->wNdpIndex) >= urb->actual_length) {
> +		dev->net->stats.rx_errors++;
> +		return retval;
> +	}
> +
> +	ncm0 = (struct usb_cdc_ncm_ndp16 *)(urb->transfer_buffer + le16_to_cpu(ncmh->wNdpIndex));

Ditto.

> +	if (ncm0->dwSignature != cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN) ||
> +	    le16_to_cpu(ncmh->wHeaderLength) + le16_to_cpu(ncm0->wLength) >= urb->actual_length) {

nit: Lines less than 80 columns wide a re a bit nicer IMHO

> +		dev->net->stats.rx_errors++;
> +		return retval;
> +	}
> +
> +	dpe = ncm0->dpe16;
> +	while (le16_to_cpu(dpe->wDatagramIndex) != 0 &&
> +	       le16_to_cpu(dpe->wDatagramLength) != 0) {
> +		if (le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
> +		    (le16_to_cpu(dpe->wDatagramIndex) + le16_to_cpu(dpe->wDatagramLength))
> +		    > urb->actual_length) {
> +			dev->net->stats.rx_length_errors++;
> +			return retval;
> +		}
> +
> +		buf = urb->transfer_buffer + le16_to_cpu(dpe->wDatagramIndex);
> +		len = le16_to_cpu(dpe->wDatagramLength);
> +
> +		retval = ipheth_consume_skb(buf, len, dev);
> +		if (retval != 0)
> +			return retval;
> +
> +		dpe++;
> +	}
> +
> +	return 0;
> +}

...

> @@ -481,6 +595,10 @@ static int ipheth_probe(struct usb_interface *intf,
>  	if (retval)
>  		goto err_get_macaddr;
>  
> +	retval = ipheth_enable_ncm(dev);
> +	if (retval == 0)

nit: if (!retval)

> +		dev->rcvbulk_callback = ipheth_rcvbulk_callback_ncm;
> +
>  	INIT_DELAYED_WORK(&dev->carrier_work, ipheth_carrier_check_work);
>  
>  	retval = ipheth_alloc_urbs(dev);
> @@ -510,8 +628,8 @@ static int ipheth_probe(struct usb_interface *intf,
>  	ipheth_free_urbs(dev);
>  err_alloc_urbs:
>  err_get_macaddr:
> -err_alloc_ctrl_buf:
>  	kfree(dev->ctrl_buf);
> +err_alloc_ctrl_buf:
>  err_endpoints:
>  	free_netdev(netdev);
>  	return retval;

nit: this hunk seems unrelated to the rest of the patch


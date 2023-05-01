Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B536F3237
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjEAOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 10:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjEAOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 10:44:41 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2099.outbound.protection.outlook.com [40.107.100.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040E9CD
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 07:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcSSO6A3jHxX/SXHETBBwxDlnIxMm0I8gxXm5Na0SyAx5cFt9Zj40tL8f4rDy+Idxuhv6gXIa6LVDpzkl78WcLmAAdK7q0wIJ/cCtagNYQknPcGqOMsYfQk6+55sMK2SB//Bddcwh99DkEqDUoz+x1LSflpA4l9t9u7BdoHDPV1yYrF4ztlf4KLqbZAjbVIzBLp8SwmSIYGa6PPzsxYTcr6GwHBmkVx8Hx+F858UeJlcXgTxZ0Xwp0RqtJclA0ON44k4hCWIOJRjph0nvR/3H/sxs0vi/k8oacLF2Y7Xo4oggH009pflSyGlGOlMgzegXOaWlS3ymaJkIWyEarPBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Od/8f9CmPf28wS3ekP8zoeuDbqKS8vUrI8Th3PklK9E=;
 b=E27wEYRHC0WLgHra8iusosjbSuq6yAUWbv+pzOh9FjbnIjw3MQ5TBlpXukEsxISlvlP9u6rQj4+zjh6p4djDiwGXFZH2HXGqYKzaltY760ceelWxYBIGyTqprziFwba6hpsRToT/m1AiFddXKEgSv3j7Iu2glfF8hzEyq0mAYAb8ZGYnOksaoDarquWdfWcm+akjRc7vt5icrF2OXPpvDLCc23z7heZd8qCxOvN6IeIc5cf6LrjkuEh4P+V3jR1hNix7XK3E/gLdlOdmK0IhQXStgNbO0vK1QeQIBJ2P0z9G2W8hCeS+TkqZG1dhdZ7ye4OKnY7RN/L3NSmr3DnV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od/8f9CmPf28wS3ekP8zoeuDbqKS8vUrI8Th3PklK9E=;
 b=aHTfMH8Uiv/7PjRbPV04KLFSw2g+vP8E2Ln3eMqvjy6yZqiv7t24ivKAISoj6QaO1V3RzI5uD3PIYZKw9tluVu194Ercw2u8HdsqbYleY/fXRIvd/CiBDIlxos2RjSD2P13OJ/0qAqiY2V2VaVoO5ox8Y+m0O8YI77mA9yK+mU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6485.namprd13.prod.outlook.com (2603:10b6:610:19b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Mon, 1 May
 2023 14:44:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 14:44:35 +0000
Date:   Mon, 1 May 2023 16:44:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 01/10] virtio: allow caller to override device
 id and DMA mask
Message-ID: <ZE/QS0lnUvxFacjf@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-2-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-2-shannon.nelson@amd.com>
X-ClientProxiedBy: AM0PR10CA0119.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ac1715-bb8f-448a-f546-08db4a529521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlhRxL9lCrVR6/LavnJ+TbicWAY5yN+ejyhyUQfmrmfvS5HaMY9pLLVwgSqWcAA+W9oyGQb23icAIdBjYQiMq6/u7YLejAJU2F6W67ZBvUbF0ejIBYrjhINHkoDMuWGimefdRSc/ZEurkBtWuxUt7QmrEgE+PSYgGPWPMOoVM1aIJieDIxswx+JDAW2MOPw0e7ceU/z/KWdIv3n6N3JeaZNgnKxfyOcLAZsaYxXBTTh1QGXHypAqht7PEZTr2ud/3CAExJyvHgBjvJTqcvHaBk4EcHK99FzyRWGs+i0opmGujwe4Wc/qyeR6A/9uubLIbLwMp5YuOojWJmt7ONFaM7EUNgeekM7hVUad06O4ak4IosU6Achmhuv+Be0kzdwt3HOzTC4sPlhXqRux2l0DG9Q+Sq8DeLoBlc5iiHCHeThwMtCzRdHzlJ4jwhHZQDCqWAzUgZgVkW0nWtJbOoKUMu7j+fNBCNUxoo1LpCymctl/80wnHfCV2wUSqSkD4u83rccr4fekwOtn+aAgb62q/rnFk644mTR3xPoX17xLfB/Jm3eekWOOBqrabIa5+5qd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(376002)(39830400003)(451199021)(5660300002)(44832011)(86362001)(2616005)(83380400001)(6506007)(186003)(6512007)(38100700002)(8936002)(8676002)(478600001)(6486002)(6666004)(316002)(36756003)(41300700001)(4326008)(6916009)(66946007)(66556008)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WRSAFxqDTGj8BuVeL8nYE/L8PjWi8iF2hLICZ4y7IGboTSZ1oaNqQWhrO24g?=
 =?us-ascii?Q?0C8AhhmsTp8You856rf7mHipnTdugq4OaZhKq/ybLr0iXAZ9nNtR6Xtaxev9?=
 =?us-ascii?Q?4Kk/31UJdmSRitR14esag2Ksd9CVQMAssFya4sh3kz4MWYs6cnUnZ/L6YxXt?=
 =?us-ascii?Q?Tw1NB/l1yOJ1LrhQhQgF9I446mTDbQ+4PY4TnN7jfpSihozWjawUdFFhhMIn?=
 =?us-ascii?Q?YXZ3CIi3oZ5Yj56xl/BFXL4JIerw4f7e1MwtZOKB2qDfGbzU+fF5a3m/k8CI?=
 =?us-ascii?Q?K4dmEIJ3ChSpFJBSumVru3VHjw1LLmnMfbSvgrWo/8QoUmG8XhWPfgBYr/MT?=
 =?us-ascii?Q?9Sbt57mBD0I/ONBeCAWxMozTTwaReCvOp5JRuAWe50pwhsUoBf9Zp83H8bdC?=
 =?us-ascii?Q?k4XyJCMb/woogYsXB09WWA/m2HIlKaYYW0BJfi30B9V+Hw9GoUb5BAnhK+vR?=
 =?us-ascii?Q?pJRQrjz521cm9nzmN0PTx5xnerYpQfD/P64+VRsfqraWcnDyVYpAKYOXfI3L?=
 =?us-ascii?Q?LBv75+bmewAyfiZWvNPKYWNnYb91//cqnHXpswcYSAvgc1sqsV2ICqjVE7iv?=
 =?us-ascii?Q?W6POQyQPqvlfoDUcJczIlZydcUdMpiK5UE3W/U1429N6l06upaDA8Mt/HW2w?=
 =?us-ascii?Q?aSz/Or5ckFH+L83edupwsP2jO6bmUTVfyWS6EIXUbfOMpQUliJzZWyb7arfy?=
 =?us-ascii?Q?bbqKfugbUhgMRmUGzbz2TrAlS6p9nEyQYGb1XDS+QEq3Sq45HI/R4IGeucQe?=
 =?us-ascii?Q?wWi99tKbfxUe4Q306bfO/8aShTmz6j+BOT4XcOQ2TcQP9/srjG8MiIJxzmML?=
 =?us-ascii?Q?9aUNIhKBz9bSNNeoOVPrdZQQ1zZ/uj46EptNtdg0dt5WYmy9TQ+Kf4AzQvA8?=
 =?us-ascii?Q?w3RnsMmOniN8TXmDXyd2jRrFwFiks8knE6qC34u3SsceuN1caAcanORqWFqc?=
 =?us-ascii?Q?VaGfr5GyiZ8KyF1whs8hVzhNsbOlvjGJmDD5zLZd+I0AUQe1F4EYJeehsqoo?=
 =?us-ascii?Q?5LyC6FlaP3TvJP8GZj6RCmgA9/58Y6ccz8XDlnSlcBFDJhFqIxNoDEeGNa4W?=
 =?us-ascii?Q?EW9/Fr9tqKEb2GS+owkf747cJttM/Y03oVhuPxJS/j9NEGiWf/S3QHUom+d5?=
 =?us-ascii?Q?ymXtPsvUMOcfO3KEMBaEojs3JWuaTSkKtKV41BmHf045dshydZB/lapsaYCw?=
 =?us-ascii?Q?aFJplLzgQbv1cFsaM2XSxG3gp87W7S1i0WGqp0YnTtNjzta3pWi3dIWEgTMW?=
 =?us-ascii?Q?PobumNWptW+OvpLIdnqhl+ArXFh0oWmKo7YyTEr8HcMQCQbARiwXsEHNCykF?=
 =?us-ascii?Q?hTG81J7iNPkXNluP8M79W6rRobCLRlublbqpRMvM6XMnhzYITft6ycol8UXD?=
 =?us-ascii?Q?+MZ/aFRFYsN6n5FmMxCXTrQFu2NOW2x98uZ0dsTO2AWU7chRqg7+tzlafLZu?=
 =?us-ascii?Q?raYjBIS4hbmw9ph9jbH+E2jQjlS9vHkvtw75HBQM4csPrLFs4ttOy54ofEdR?=
 =?us-ascii?Q?FrYUDOFXNCts/jNzr8Fed/ryGPSkChBTPV3hL1IePQGqQUCVcqJ0emj6T1wh?=
 =?us-ascii?Q?f2E57b0G+41aqeb+LjNs47zPJhw0nVJ3GnvyPMFa+3aLHUMeSaAYD0NIhmHf?=
 =?us-ascii?Q?hCqqldjWJ9VZp76vh28n8fPqOK5QGZKbj4ToFW6wneRYMkSfO/dticruZPCT?=
 =?us-ascii?Q?uLwUig=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ac1715-bb8f-448a-f546-08db4a529521
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 14:44:35.6901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogI7qHeTnhnxci/O/d4HbMT4AkT1FIjt5O78GHiS9VOKiN0EN9rBbgJBZh9mzne4lbtjY61RYjvY6NZuhgMWVPOX/DnRJOJchWSUHaPp5dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6485
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:53PM -0700, Shannon Nelson wrote:
> To add a bit of flexibility with various virtio based devices, allow
> the caller to specify a different device id and DMA mask.  This adds
> fields to struct virtio_pci_modern_device to specify an override device
> id check and a DMA mask.
> 
> int (*device_id_check)(struct pci_dev *pdev);
> 	If defined by the driver, this function will be called to check
> 	that the PCI device is the vendor's expected device, and will
> 	return the found device id to be stored in mdev->id.device.
> 	This allows vendors with alternative vendor device ids to use
> 	this library on their own device BAR.
> 
> u64 dma_mask;
> 	If defined by the driver, this mask will be used in a call to
> 	dma_set_mask_and_coherent() instead of the traditional
> 	DMA_BIT_MASK(64).  This allows limiting the DMA space on
> 	vendor devices with address limitations.

Hi Shannon,

I don't feel strongly about this, but as there are two new features,
perhaps it would appropriate to have two patches.

> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/virtio/virtio_pci_modern_dev.c | 37 +++++++++++++++++---------
>  include/linux/virtio_pci_modern.h      |  6 +++++
>  2 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index 869cb46bef96..1f2db76e8f91 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -218,21 +218,29 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>  	int err, common, isr, notify, device;
>  	u32 notify_length;
>  	u32 notify_offset;
> +	int devid;
>  
>  	check_offsets();
>  
> -	/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
> -	if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> -		return -ENODEV;
> -
> -	if (pci_dev->device < 0x1040) {
> -		/* Transitional devices: use the PCI subsystem device id as
> -		 * virtio device id, same as legacy driver always did.
> -		 */
> -		mdev->id.device = pci_dev->subsystem_device;
> +	if (mdev->device_id_check) {
> +		devid = mdev->device_id_check(pci_dev);
> +		if (devid < 0)
> +			return devid;
> +		mdev->id.device = devid;
>  	} else {
> -		/* Modern devices: simply use PCI device id, but start from 0x1040. */
> -		mdev->id.device = pci_dev->device - 0x1040;
> +		/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
> +		if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> +			return -ENODEV;
> +
> +		if (pci_dev->device < 0x1040) {
> +			/* Transitional devices: use the PCI subsystem device id as
> +			 * virtio device id, same as legacy driver always did.
> +			 */
> +			mdev->id.device = pci_dev->subsystem_device;
> +		} else {
> +			/* Modern devices: simply use PCI device id, but start from 0x1040. */
> +			mdev->id.device = pci_dev->device - 0x1040;
> +		}
>  	}
>  	mdev->id.vendor = pci_dev->subsystem_vendor;
>  

The diff above is verbose, but looks good to me :)

> @@ -260,7 +268,12 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>  		return -EINVAL;
>  	}
>  
> -	err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
> +	if (mdev->dma_mask)
> +		err = dma_set_mask_and_coherent(&pci_dev->dev,
> +						mdev->dma_mask);
> +	else
> +		err = dma_set_mask_and_coherent(&pci_dev->dev,
> +						DMA_BIT_MASK(64));

Maybe it is nicer to avoid duplicating the function call, something like
this:

	u64 dma_mask;
	...

	dma_mask = mdev->dma_mask ? : DMA_BIT_MASK(64);
	err = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);

or, without a local variable.

	err = dma_set_mask_and_coherent(&pci_dev->dev,
					mdev->dma_mask ? : DMA_BIT_MASK(64));

>  	if (err)
>  		err = dma_set_mask_and_coherent(&pci_dev->dev,
>  						DMA_BIT_MASK(32));
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index c4eeb79b0139..067ac1d789bc 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h

Maybe it would be good to add kdoc for struct virtio_pci_modern_device
at some point.

> @@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
>  	int modern_bars;
>  
>  	struct virtio_device_id id;
> +
> +	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
> +	int (*device_id_check)(struct pci_dev *pdev);
> +
> +	/* optional mask for devices with limited DMA space */
> +	u64 dma_mask;
>  };
>  
>  /*
> -- 
> 2.17.1
> 

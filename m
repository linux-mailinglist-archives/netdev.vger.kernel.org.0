Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB9716AB4E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgBXQ05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:26:57 -0500
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:10579
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727160AbgBXQ05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 11:26:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivKntjcFGEDwI6t73Y+i2VsB/+D+pwXFxUPMAbsRvxhHKC95K/wxdlSVXOzczaR3T4aKr8IhLbVdN6i0IdDiefElqjEkIs2WO1tVK/1PSztzT2QO0GqcZlIJg5ALblZhZvGi0HEjuhh190erTQ5wB5tIRaOU2RYG1Q7IJMmO0JZcrFTuzNhSa8GFMJPKVMPR1dpLND5e0cswzlHvfThZTeq8z7SswO8LIidfdgbT2SdqGLIl2NHSLwbwGYEmuiPDOdkR2CYadTAVWhyIlKn9NyLdsCTqaAwiVhAU8/blY+25HELJjsmeitQY+iFtmAL2CwLxD6r9FiYfZmP3IP6nFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMhiIvqaY6lC6zTmHcF9bJqy/Z7rfhoMFXupMNL3niA=;
 b=Dn3RKFQ1/FVbIQQ0m26A2axuueuKu9jA5upD5w4brjg0nYOE0HPtC8gRZeknii+Jyd12T6eMkjd3cLUUOujfqPTkKkr+lpRPOdfZ5VGEFEEUY9Q02W8pSb5MtkAjs8SmCZRgvSAGhnYRs8mjHElEAIKL7iHy+6qVuQ0qSUVfV3Ux4SExcrkxnfJPD8aVDSrrIIVHNiNJ2n4eZFlSnvxnB8H6SJYVnnnbVUPFOp1cEr93QuvkqrmK+1TC7m/ALU8GBFNtPCOSKOEh4tKkH6SPeSFjKvYhuHyehAruePi9W9aYdsi9bzBI8GHu0h9NLd4rmXutukaZH/lVgj8rHVdsYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMhiIvqaY6lC6zTmHcF9bJqy/Z7rfhoMFXupMNL3niA=;
 b=I577bsVQSEOGPSwuYzli/1wYij/q6Gy7n5J3c1TA2kL31ybZSFgUJJrx4Nzjb5LTVcgFKqKZtOfEP1mCjfsRlXV3C3OP8VtRp8pd1WexkwD+2fi18395lOJ6B4eL979/t8+7OfZQcC7tuUl/xqW69Bpn0Rtc42yFy/WPzcWFLdU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB6213.eurprd05.prod.outlook.com (20.178.95.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Mon, 24 Feb 2020 16:26:53 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 16:26:53 +0000
Date:   Mon, 24 Feb 2020 18:26:49 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>
Subject: Re: [PATCH] net/amazon: Ensure that driver version is aligned to the
 linux kernel
Message-ID: <20200224162649.GA4526@unreal>
References: <20200224094116.GD422704@unreal>
 <20200224154027.16499-1-sameehj@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224154027.16499-1-sameehj@amazon.com>
X-ClientProxiedBy: PR0P264CA0107.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::23) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::f87) by PR0P264CA0107.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Mon, 24 Feb 2020 16:26:52 +0000
X-Originating-IP: [2a00:a040:183:2d::f87]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 776f8c75-f336-491f-632c-08d7b9465bc6
X-MS-TrafficTypeDiagnostic: AM6PR05MB6213:
X-Microsoft-Antispam-PRVS: <AM6PR05MB6213741C1213FB6FF23E0843B0EC0@AM6PR05MB6213.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 032334F434
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(47630400002)(189003)(199004)(6486002)(6916009)(66946007)(66556008)(316002)(5660300002)(66476007)(16526019)(2906002)(478600001)(186003)(4326008)(81166006)(8676002)(6496006)(33656002)(52116002)(6666004)(86362001)(9686003)(1076003)(33716001)(8936002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6213;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FA6dOpz58++y/IZP2K9Lo5Lpjur04zCOG1f5do3TdFSnpabUSYIOHDoE/le/SjBE8UIat8V07UaoAJYimVrTo393koZOptPROsnCv8rqkL07s4u1Zy9bL6Z/6pV47xocelytnCkVLYxcRqDifMDi54I5i+G1WxzSbWDY6P48Y9/HPg1Dt33WeB2xWpMkLXAwcFXa9xdKmstAikeEGZYY31Ht59LYPCkzqk4GWG9jjIJXcRm+EPq8v7DyrRwF0IMQdjIKSGVRElMW2TVGOAJ++CxpcGKwJJEe2rG3ewHDroJFCTbSVNNGM1Et8Uuxb97X9vs9cuzNemrzqmKTuZM56pmPUpu4pZtyNupowDDXWm1HqAMBldnFYGgcRVLkuYow0CZaT+xYlRNAYZ1M3BfOwmP4zY1dqB4SKnpQ4AY9/z5PhWbicaJ4ruwpv2nlB2kj
X-MS-Exchange-AntiSpam-MessageData: VaG+CcXi5xD3wBGBqXn+yiphly/rnvJ9jfvsBjHyrja2NRnOnUsXiG4AodAZgTXXG3JfhatAN4FDV3mWlx3x4pkxb+AZbtBC4aQwXYPSEYCyiIf74CyqFZujaDIX1T0w99deOqWUNNPRnrywBHZ0jaMxeHwS4KJxktw1CGobhug=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776f8c75-f336-491f-632c-08d7b9465bc6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2020 16:26:53.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUdsfmb7nCbnXoAuMMBzMVAbApchIRpog9a99kh76nkQ9gRHr6f4rN9QjHDRpD9BrGlZ0MGltbX4COHn8Ri3rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6213
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 03:40:27PM +0000, sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
>
> Upstream drivers are managed inside global repository and released all
> together, this ensure that driver version is the same as linux kernel,
> so update amazon drivers to properly reflect it.
>
> Also rename current driver version constants used in interface with
> ENA device FW for code clarity.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 -
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 17 ++++-------------
>  drivers/net/ethernet/amazon/ena/ena_netdev.h  | 16 ++++++++--------
>  3 files changed, 12 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index 971f02ea5..ad2148b86 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -404,7 +404,6 @@ static void ena_get_drvinfo(struct net_device *dev,
>  	struct ena_adapter *adapter = netdev_priv(dev);
>
>  	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
> -	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
>  	strlcpy(info->bus_info, pci_name(adapter->pdev),
>  		sizeof(info->bus_info));
>  }
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 1c1a41bd1..b14772812 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -49,12 +49,9 @@
>  #include "ena_netdev.h"
>  #include "ena_pci_id_tbl.h"
>
> -static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
> -
>  MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
>  MODULE_DESCRIPTION(DEVICE_NAME);
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(DRV_MODULE_VERSION);
>
>  /* Time in jiffies before concluding the transmitter is hung. */
>  #define TX_TIMEOUT  (5 * HZ)
> @@ -2441,9 +2438,9 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
>  	strncpy(host_info->os_dist_str, utsname()->release,
>  		sizeof(host_info->os_dist_str) - 1);
>  	host_info->driver_version =
> -		(DRV_MODULE_VER_MAJOR) |
> -		(DRV_MODULE_VER_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
> -		(DRV_MODULE_VER_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
> +		(DRV_MODULE_GEN_MAJOR) |
> +		(DRV_MODULE_GEN_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
> +		(DRV_MODULE_GEN_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
>  		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
>  	host_info->num_cpus = num_online_cpus();
>
> @@ -2822,9 +2819,7 @@ static int ena_restore_device(struct ena_adapter *adapter)
>  		netif_carrier_on(adapter->netdev);
>
>  	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
> -	dev_err(&pdev->dev,
> -		"Device reset completed successfully, Driver info: %s\n",
> -		version);
> +	dev_err(&pdev->dev, "Device reset completed successfully\n");
>
>  	return rc;
>  err_disable_msix:
> @@ -3459,8 +3454,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>
>  	dev_dbg(&pdev->dev, "%s\n", __func__);
>
> -	dev_info_once(&pdev->dev, "%s", version);
> -
>  	rc = pci_enable_device_mem(pdev);
>  	if (rc) {
>  		dev_err(&pdev->dev, "pci_enable_device_mem() failed!\n");
> @@ -3766,8 +3759,6 @@ static struct pci_driver ena_pci_driver = {
>
>  static int __init ena_init(void)
>  {
> -	pr_info("%s", version);
> -
>  	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
>  	if (!ena_wq) {
>  		pr_err("Failed to create workqueue\n");
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> index 2fe5eeea6..ac3f481b7 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> @@ -44,16 +44,16 @@
>  #include "ena_com.h"
>  #include "ena_eth_com.h"
>
> -#define DRV_MODULE_VER_MAJOR	2
> -#define DRV_MODULE_VER_MINOR	1
> -#define DRV_MODULE_VER_SUBMINOR 0
> +#define DRV_MODULE_GEN_MAJOR	2
> +#define DRV_MODULE_GEN_MINOR	1
> +#define DRV_MODULE_GEN_SUBMINOR 0

I'm completely fine with this variant and did very similar thing for
broadcom driver where authors forwarded similar data to FW, but please
add the following line above those defines:
/* DO NOT CHANGE DRV_MODULE_GEN_* values in in-tree code */

Thanks

>
>  #define DRV_MODULE_NAME		"ena"
> -#ifndef DRV_MODULE_VERSION
> -#define DRV_MODULE_VERSION \
> -	__stringify(DRV_MODULE_VER_MAJOR) "."	\
> -	__stringify(DRV_MODULE_VER_MINOR) "."	\
> -	__stringify(DRV_MODULE_VER_SUBMINOR) "K"
> +#ifndef DRV_MODULE_GENERATION
> +#define DRV_MODULE_GENERATION \
> +	__stringify(DRV_MODULE_GEN_MAJOR) "."	\
> +	__stringify(DRV_MODULE_GEN_MINOR) "."	\
> +	__stringify(DRV_MODULE_GEN_SUBMINOR) "K"
>  #endif
>
>  #define DEVICE_NAME	"Elastic Network Adapter (ENA)"
> --
> 2.24.1.AMZN
>

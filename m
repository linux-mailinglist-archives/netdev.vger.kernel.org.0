Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA1946E416
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhLII1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:27:31 -0500
Received: from mail-bn8nam11on2104.outbound.protection.outlook.com ([40.107.236.104]:38528
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229654AbhLII1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 03:27:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kroBKaY+AX6+/1cXwpOnA7cHgU27FZpWR5w32jizS6JRWEZg4mox4HHUhp7mwT7rsYtfuLtUtsoW9P/8vBbaoPl/yT7y33Lc5IpgkQrKmUirUaKVk8Fim+Wv/eUu5G7qkbGvLey7TpWpst0JxEd0mEW7GFU96FCMr6c0IeC2fU6LSiB2yQdNqFrMX4rxEUguMP4m/eL482oQPc32hDa1t7ApM/IGD6WPE7Diw06SKwEWGpoJiymKDT8dcGiXzIPHBSvfvw6zM1CLNavDB3aTZkqfzu5/GiVZkP8PPkUM0gy3iFTJEqpi1k9Ls7IcVeP+LWLltGtgum8RcUduUy/7IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEgN8BqPTUm5WCHowvBEdL5R2pK/EJdsAR/aJ0Wb0ig=;
 b=PhN3oviflRTOpZLn8PgP9TTT/DBOcPVXGT7Fpfx5vh+T/q4fZmunt/3jedDezqrfncviPulVOSl4Dfor8DzU9a6hBuCUoOVX2SXairTMGMg08hcIp4eWHXHJJ0XSjRz2NTxb5nx7sGIQX4CCixHEKAPnQEryNThiGuybaRNVBAV+o9XW7SpKQMjPx6cxgYHBNeO9cvGAbKvmdJImCuiFe2Uhj/a5v9Esb5bJLis8KHzwd/Sn/OAB8NSC6yoPuz/LaoivLiWTCrd/frVSW2Amuv/9lHRk9EqDDx+g+bD6WtJ6igBQQrb8Jdli1IhFHOfHCKHCcCyNc753efba+/3fWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEgN8BqPTUm5WCHowvBEdL5R2pK/EJdsAR/aJ0Wb0ig=;
 b=hMwI27cHyzO3l4Ps84d/rLPQWBrjbnXiBNdEcC6Zk754xk6IscTyRorluJhUVBrCqpq2Af/lsK9gOOI0jErtoJiBxm8stSM6agfGBRjltmFKmUzui8fm5mF2JLiu7y0kT/rLs5mVGO8Fy/G7AZ6edGebiqXwINtQLVBa9C1ll2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5716.namprd13.prod.outlook.com (2603:10b6:510:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.8; Thu, 9 Dec
 2021 08:23:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 08:23:54 +0000
Date:   Thu, 9 Dec 2021 09:23:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     kuba@kernel.org, davem@davemloft.net, libaokun1@huawei.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: Fix memory leak in nfp_cpp_area_cache_add()
Message-ID: <20211209082347.GC30443@corigine.com>
References: <20211209061511.122535-1-niejianglei2021@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209061511.122535-1-niejianglei2021@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:208:1::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1786d4b2-fcf3-4dde-bb21-08d9baed3ce2
X-MS-TrafficTypeDiagnostic: PH0PR13MB5716:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5716356B16DDC1EF87C7F21AE8709@PH0PR13MB5716.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+BBqZctwCRKdYble9CHopawTaOGGXf8/8zG9TN3xprcU9PXIOEB7F3kXmyvMVPxp4SUHZ6Zzr0d6AikKQs7gvY7/iqhGaxy0a0y5DLPxeYoG4Xi4bsj0xeXLEqLF1qynEWQVsAOozY+iXXmwj2qkqIYiHEA3wUKqWWhrTSgA2ARNIZnVOpjLv3tzO8C7v0X2fukneIDOVmgitbmIlLVOGCrkuXQJLbp9SbNzbecWctSPCxvt4hoJ1KyQXRU1SwL0JdkZZ3rzvRXuupMSu7IGPAGrejvZ3zkqtLN5oXbBe8bjUSdy9twhebtxmzMMofJowB4p3VsEuSmGLI1pIsUv1pH8QzWyulpOl+9X9Iv7azquTro2BDqf08x54XCLVdS1hVdAjc6wBfIrotm4xabUwENtSOqflGvPuaadA7J4j2zRKptfEa2ETvpA3ekYRJgKuQCx/LrgsNtMPeNzZuSmBw2D3xyXqeA+O5Z4XH5KqBv76Aqk9uQ9xlddTCrH+iLg/Gl2RVhHzvfHO9Bl48uutZ84+A+zXXIT1r/xDQ8+U2WT5XYyMV/vZUu+yKPI6cjxpQzTtugM1GyZikCvZJ2C6jvRcjiuYVDssSJQsh/RbBFAbVSmpwZegWSMt5j5vLAOIZoFJUNpGu6HTpoZGkLmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(376002)(366004)(396003)(346002)(8676002)(8936002)(6486002)(38100700002)(508600001)(1076003)(44832011)(6512007)(33656002)(316002)(2906002)(83380400001)(36756003)(52116002)(66946007)(186003)(6506007)(6666004)(66476007)(2616005)(5660300002)(6916009)(4326008)(86362001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o9gYQEMFeiPNGN73EbqimFvhPmFa3fdFSBAlasFAcCOKIPglp6zNvV4j/b/5?=
 =?us-ascii?Q?cWw9gAkMeHfvvEKA1Y//36IAmiQnq8LjysSfk8ZfDgRz/HX5jXkaRfrXzlE7?=
 =?us-ascii?Q?Vr6Qeig8FCx5no4thCc6TlVIhGdiQkO6mEWuKgJxzw+2Ip4ncAPgMDIoyWt3?=
 =?us-ascii?Q?mDJl/RzrXPqB3H6LBYD2PlB0Ndo96v4KZj1Q5XSfST5a1QcHXt0ysoFBd+Pm?=
 =?us-ascii?Q?vebXOp4MiePVW8rNgKcMiLEAC0F1PPBalz6CUL5uEzr9u5NJgCbClPe5szg4?=
 =?us-ascii?Q?/MTfWUBRdxUYTpl/H2cnNNpV5ntvoPSK+mi0W46YiflIkyH05ytQa53dtY+U?=
 =?us-ascii?Q?QC8UCDuQnUU4kaYHz0tQ/2gB9zYUO88UjZq9U3vAnNFPDp4fL8dJd48izImO?=
 =?us-ascii?Q?bqHkL2azDG/WP7IuMrNR6HxIf90IBIdVkWCrSss1m225kgVSmmCbCZTnQKTW?=
 =?us-ascii?Q?3/YVU5thR4UQhK49TCAh6wLn/FP/J1XSEnWmp3tZWF89KzvfOZ2ArdT/qrS3?=
 =?us-ascii?Q?8A4OF1R4rseiOtvt+GCvX6IpEjiduOvD85Ip8+YezuEVHOQ1wwczzbGoy96G?=
 =?us-ascii?Q?lIq1mpJnI00/0gCQfwVyqa+gZlAmzQ8nzFF3Tnv7STWfxLkjn76hhSr0yfre?=
 =?us-ascii?Q?3EbbNer9q8yJKB8ZCpibp9HJuwy/uOE8psw/Y1t5fyJlo+b2sJnDVPtD368D?=
 =?us-ascii?Q?l3eR5uFqXsyyhc11xi2osXl7E7yx/kAMkadCyUErEaoHwzwVMgFGwzBJrVJ8?=
 =?us-ascii?Q?MvB6xLApVh6ff7W9KGf4QHDlAN8aWwq4lgGndBeGmRefHVg/MtnmMWrR9luh?=
 =?us-ascii?Q?LKDU/z3kAG2P4LidL5/BAIDrD1erao8gVXY6ZNGrBiib4m0j5YK1SyEXXCTn?=
 =?us-ascii?Q?brHmsFBAhU3cYQaE7HecwXE6NPyE2F6EF2x0Nwxgd82/1JnpYGISHTEV94L1?=
 =?us-ascii?Q?ynfMMljlFzXZQPGDtKVdPxC6SZ6CE08EE5NDswwHSHRNbBOFq7Fb+NUga1YL?=
 =?us-ascii?Q?Cz6UgC5nbX6lwotQeHdlwDQRCmmnSTn1VuS38Znz/M0+ZzAj5Za6AYz5kAXr?=
 =?us-ascii?Q?/dw1m8UsRnO8qH2cSzkyxYwEDtVeoxoDHhLdmbGLqI89v4sPHnvHsQ1rgt8f?=
 =?us-ascii?Q?IdR5DQBbGIOK85oSqUTn8H/qPdF7Pz6y82dXriq+RInsknqMocMogiR+ekt6?=
 =?us-ascii?Q?+UBhC4nYZqNfAwY6ds8ILvgpWIiGk6F2S7FRXO5FAZd6VHtOIHfbaIKJHrzh?=
 =?us-ascii?Q?sMS+hD7KJrl12FyTdNrBsSgISrlwNZXUCOLx5WMLiHWLDxZhdM18l0qEntSb?=
 =?us-ascii?Q?8VPrNhnaJjZei125/+Nh63gCzYBgW0CSQlYo5yOapfc5ILhVOqudB8qzcGV6?=
 =?us-ascii?Q?nkneCOdRAr3NFA27+LnLVGY4mpm6vQR9E+eCBW553CwKWP3TEwLzP20+semh?=
 =?us-ascii?Q?l1scbpntITt1AMONQgPfsqf3uThkgwXfhxqNxcWCwk43Z2J09qw7oc09e6HG?=
 =?us-ascii?Q?wbnNRNNZP4VLHg2lvH5dBjqtMGwKQQXYbxe2fjoGHlFZD9iO4+qRSBUoIRK+?=
 =?us-ascii?Q?A4bJq9aKWBWt7DYm5jjFShL3sLRtIzchLnMwXmHIbULzQ64AhsiJwLX907En?=
 =?us-ascii?Q?dOMxIcDPmfqSFl+HQSlmSnmcrowlC3x985CgZ/sgxeibghc2iDaJsj/8R4XU?=
 =?us-ascii?Q?ROnHFwJG7Lltw5qxcQO8ibbzd61oHIr43aaNDy/tI38TnLsj6Pnm14DQk0CN?=
 =?us-ascii?Q?BzoagrpFF/icOWEDDKU5AnZQVccdGXo=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1786d4b2-fcf3-4dde-bb21-08d9baed3ce2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 08:23:54.2029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gq0ebpdxWzCmxbl1AvLaFU36EaXVpiqvDdftkaQ5pGEWWm/o6IMRMtjj7sDfF0riLbnkeVRZJl+o3s7lVi0MW+pBN2eCjQn72R6UmPCP9UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jianglei,

On Thu, Dec 09, 2021 at 02:15:11PM +0800, Jianglei Nie wrote:
> In line 800 (#1), nfp_cpp_area_alloc() allocates and initializes a
> CPP area structure. But in line 807 (#2), when the cache is allocated
> failed, this CPP area structure is not freed, which will result in
> memory leak.
> 
> We can fix it by freeing the CPP area when the cache is allocated
> failed (#2).
> 
> 792 int nfp_cpp_area_cache_add(struct nfp_cpp *cpp, size_t size)
> 793 {
> 794 	struct nfp_cpp_area_cache *cache;
> 795 	struct nfp_cpp_area *area;
> 
> 800	area = nfp_cpp_area_alloc(cpp, NFP_CPP_ID(7, NFP_CPP_ACTION_RW, 0),
> 801 				  0, size);
> 	// #1: allocates and initializes
> 
> 802 	if (!area)
> 803 		return -ENOMEM;
> 
> 805 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
> 806 	if (!cache)
> 807 		return -ENOMEM; // #2: missing free
> 
> 817	return 0;
> 818 }
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Thanks for noticing this. I agree that this seems to be incorrect
and that your patch addresses the problem.

I do wonder if there is a value in adding:

Fixes: 4cb584e0ee7d ("nfp: add CPP access core")

Also, as I don't think this is hurting anything in practice, perhaps
this is for net-next (as oppoed to net), which is not specified
in the patch subject.

Regardless,

Acked-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> index d7ac0307797f..34c0d2ddf9ef 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> @@ -803,8 +803,10 @@ int nfp_cpp_area_cache_add(struct nfp_cpp *cpp, size_t size)
>  		return -ENOMEM;
>  
>  	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
> -	if (!cache)
> +	if (!cache) {
> +		nfp_cpp_area_free(area);
>  		return -ENOMEM;
> +	}
>  
>  	cache->id = 0;
>  	cache->addr = 0;
> -- 
> 2.25.1
> 

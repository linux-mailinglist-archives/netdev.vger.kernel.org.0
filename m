Return-Path: <netdev+bounces-10620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 134B772F688
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1E2F281329
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD2C210B;
	Wed, 14 Jun 2023 07:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B3A7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:38:51 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2103.outbound.protection.outlook.com [40.107.223.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB1C2103;
	Wed, 14 Jun 2023 00:38:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoW8uy8YZdzRR317dsuL0NGYsSBI5gFjqx0QTkNtXggZbaMPT56ZfokEtI4oISVmkrYcPWiU6IpBNYmZ3eaVobhcNEwSJ7yV7t5AYCAQ9oTeYrRFNdYBI/i+CM4JKVSXbbBcd3eVnX5v7l3mpIRP277LzV4JuZShmIPEUD8xYpbvGlOkOQdvgVA+EUBxUX9xhtg4V+5+hhutHl6ZlLMblmVVdliIHPSyKtBLqfiUT+B019GQ2545NFaX51+XCwObbf/DOhOEkWFLhRNjIGQ5PJORwLNMg6SZCaaegCQMzx0lGaDwYUzBI6kmJoGnZ2OLYqlIYmBQ8zxY4XKJeop0sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0D2wYvImE2pR0ifp1wxMzHJhS3b3oQX4FETIejTeLM=;
 b=gNm7Uin7dCFx7jG59HwBFyI4fYWAozMOHm1U8tHnUvLSrPvPHzT7YD3yQhiS1KfEF1/DZAm9er1VHp69Yfe8kknO5uIcYJWrJY5RvGNOS+6XHxhA4+wyPi6XUjkCGHa6cpSEqySBpUv/7iAg1nq77qhzq4Dn/9paOlvYNn1cPhRHPifgZHWBEBwUaLJ843OjJNneSHwmB3tyvueKfp7QC+R9PAjehJOhzNxCge5uzb2lfmc7utPQ9siefgHkii2snlxghE/y27SGC6B+RrySKOGXhnYuMKMhZLaiv826RxqkweFkY5lQ44rieSP2MD8HxQ8F0AuL0A9ESP2df0WzFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0D2wYvImE2pR0ifp1wxMzHJhS3b3oQX4FETIejTeLM=;
 b=IsDq9amVKpGCHoNXPQ7oifCY5DT+ZxkItTjrw8wVfHIZ0IwnMX9++AxCCFc9UMxPvATfRIRAXgNY/3G1oobP/yrfTeZAL39j/66TwVbqYd8NNyNoI7FowtqZV7DaleIVOWVajLQ1IBymbqYcAW81CJ91c4oNLtAOjPk+F2cPB5I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4804.namprd13.prod.outlook.com (2603:10b6:a03:355::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 07:38:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 07:38:39 +0000
Date: Wed, 14 Jun 2023 09:38:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
	rajur@chelsio.com, ayush.sawal@chelsio.com, dmichail@fungible.com,
	borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
	john.fastabend@gmail.com, anirudh.venkataramanan@intel.com,
	maxtram95@gmail.com, tariqt@nvidia.com, gal@nvidia.com,
	raeds@nvidia.com, liorna@nvidia.com, louis.peens@corigine.com,
	yinjun.zhang@corigine.com, na.wang@corigine.com,
	linux-rdma@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net-next] net: tls: make the offload check helper take
 skb not socket
Message-ID: <ZIludj9blHkIovR3@corigine.com>
References: <20230613205006.1995873-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613205006.1995873-1-kuba@kernel.org>
X-ClientProxiedBy: AM0PR02CA0135.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4804:EE_
X-MS-Office365-Filtering-Correlation-Id: bf0cee9d-e159-4eff-e04c-08db6caa5ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/n2NBAAzLBlo/XwbMcb+xeOMPown9lHvvlI/ePe7js4KZwMF3CsTu7tj/ydsUQWCY8qvnWfZIaze+gQxe6w8Yu3Is2aMSX9NedH9JI4WCabWoegW8VQI7K5UN7SyX80huGV/wZqqxUHoj3IyAtMc6oWJKvh0hqNlKa0rF4bK/LNdbaLsstza7mMxNfVO5jXSiz4W2XlO11dj4FdqjV5irXrYfM5gCiCYht02+akH2OMa4b53EdkpNd47YZ+3iX2O7O9jGrMcwySRB8Z8BbOarMOajAXni4TXdrPHC7tNpjcGx0WnFHpAR/iepsOPOQX/dMnPK9WzHdUjDKe16AOuOm6DXLsdgxiftY1NbBAWvQEnzwD/bO3oLW1JeliOa0sZdU+QLZptV0AJzksmdtpMHrJFA1x3wsX9H0+2wY/2pOpLCvH9TE52Kei0mf201LHmaJsV+41JsaW4d7bb739kMeNMTJyiOG5NtcEclvzBckAm7PpSo4Bqocfhu9ACB3juRi4zkjZ9GWSdtX6FqXCgPFkpM3G3enM8z/yGMAEWILbxfFXVmz0mySvpb9BNclNaP45/AMVKCTWWw9VNdpmedfRgN64jTfKIPIcHY9wpMH8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(376002)(396003)(346002)(451199021)(83380400001)(5660300002)(186003)(6506007)(44832011)(2906002)(2616005)(7416002)(107886003)(41300700001)(6512007)(8936002)(8676002)(6486002)(316002)(6666004)(36756003)(478600001)(38100700002)(86362001)(4326008)(66556008)(66476007)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N23XB9fB5OM0wxNB8QYMx5XEANWs8X/aiwvAHtuahPd2Pt9jK8E1zwKTGHTM?=
 =?us-ascii?Q?ogx7vVXzmvQJHLnLT3hTyLeQ/Vew61UsgsoVFxwmyqnynea/NocORM09zMPV?=
 =?us-ascii?Q?DakbVHcH3tvEAzPPZ/gj9PFP+YWtdxviExkc1yoPXh2lr2jM2e7RGI/YHeeU?=
 =?us-ascii?Q?AuAdVwoYhpPu+C7eqztLDVatUO1WKHW+BeGCjsiqeR3WpOCYnNRJnqP9ab7g?=
 =?us-ascii?Q?8BXV7B0yCBD3aWGGo9JowIzJne/5ovusocUuBgk6Gbpa747cNSkZVxJSh2FK?=
 =?us-ascii?Q?gd/dQ+E9ZI8ZSqva7RfG06D6WRjwA5Oj0kEpUxj3tHUd5ToCYb1bpPDTLlUc?=
 =?us-ascii?Q?PGxDscUrrE5nyNYTJOg6/A1+xrfYnY1m5/3lTxX+kTyugdf2P6D6leA5TciZ?=
 =?us-ascii?Q?TeGWSv069rhdUMvmk/5C2IoJ/HMVieQbaH24a+8LIz6vsX+oYsvRy3IToK12?=
 =?us-ascii?Q?7EP16DSL4U+h6XtP5NBb6XWQW8CgLep+n+ikZKzmkqW2U5Xt7nEPvLyHvRoD?=
 =?us-ascii?Q?jiVzH5zMd+wE2FqciOmwH0H/iWDS1Gi9KvxSUOgwShO5GiWOhQZZGvjbpnvC?=
 =?us-ascii?Q?ytFbRBC5LIOUKP5ktwzrZ++I76bAJpE6tmCC2WLIfuo+5rOOzJo65/vShVmp?=
 =?us-ascii?Q?qYgy6JNhGD0IrjhIpU7wP9MY5JBW7OgEwpZykVuOFgtUXOyhgmgB5/etLs6a?=
 =?us-ascii?Q?V1/uSMXYY1FORdu9Qm87MJKg9XW/oNhtpjbjGdTmuRLwpGc4O8wwh7/mUt2G?=
 =?us-ascii?Q?z8YjmYBekiR3SyLGqRDY32xT5wtdkPISnzhpz6FXZAjQi3U+xJtHY1XZ2sv9?=
 =?us-ascii?Q?NihZmOBDQuLSOIbNPyXyVhqVzv4/pkM4RpWtMEQ/z7Don4Ft1qE/xXaBdlG1?=
 =?us-ascii?Q?meALP0WWaxQmR7ilaT1cp49Pm26aFNdKpHXS6k8Ycb5iaSIISRd/JOSsajvP?=
 =?us-ascii?Q?5b6MYMmxab89+dmJR8hMxqNhQceDECPxjKCIe34/6T9H3JLV8d/H1bMxUAg9?=
 =?us-ascii?Q?g9va9xCjm2HywOvXlnxpXevWGoRiVwSCpIw5TbD7UlvXrvHW7Jw/jmIeCt3j?=
 =?us-ascii?Q?fNgF7vv+S6ctj64uLbu3A/tp24ZqJ3rGkfjEvCDG0OHEE6teJHBepBUuIVHC?=
 =?us-ascii?Q?vN2tEeZeeGZJWqRAbaJ059ntym4WVkNuP3oyoxc+WENohIBynhpN0CF2td02?=
 =?us-ascii?Q?IQVspNzI8/WDo1oIkCaienD9XVi+8jP+yQhRNfqBczAUe3NF4r8zOwSb76mX?=
 =?us-ascii?Q?MKOhtsEci9DWglQLzvjFY1xzl73gXr9QnY0p7w/zMtx0eTu0nbd7nE2HdNoJ?=
 =?us-ascii?Q?csu8oybKdvN5hc2vYUcV4eV3BYlS99jgLtbS4b4PQ2q/GmJOxBID81qk0znG?=
 =?us-ascii?Q?AWddmFqrPkr9BzH58V0SoFa71i8mmTV8SG+9tyClYqrRSjbhnT5tV2GYn4Nn?=
 =?us-ascii?Q?gVZncsPT8aR0Qy1pslpbbZLCc4rKOefqgEy9j0XHjp+5tz3P/M+WisATRGmO?=
 =?us-ascii?Q?PIbQol6WBWgo0tuZhFlVbnBUQ/QWycDDiwSViFTi4Wh3RmbRiTDujEt3f+pw?=
 =?us-ascii?Q?HvaTZ3wKSKIPaAfLHhQIfA7EHlEtUpE1l11cVTOXfDD8HjmZ9KWxB1QS3iJt?=
 =?us-ascii?Q?fiGIsNv4llbj7MqeiU/pWCBaqFMZ/+hudBBAUqMGs/Zn6xbd4/BWVwAIbm8Z?=
 =?us-ascii?Q?GNY0Vg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0cee9d-e159-4eff-e04c-08db6caa5ea2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:38:39.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hr8B6dM17iFAL1FPg9icGaCJn/nbHBI6hv0MMr8TTu97IkZ97HmbILjonc27rSw9whnTGxUg84FNyIMJ3H+8m26qOw8D3z2vBHi3/24IMko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4804
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 01:50:06PM -0700, Jakub Kicinski wrote:
> All callers of tls_is_sk_tx_device_offloaded() currently do
> an equivalent of:
> 
>  if (skb->sk && tls_is_skb_tx_device_offloaded(skb->sk))
> 
> Have the helper accept skb and do the skb->sk check locally.
> Two drivers have local static inlines with similar wrappers
> already.
> 
> While at it change the ifdef condition to TLS_DEVICE.
> Only TLS_DEVICE selects SOCK_VALIDATE_XMIT, so the two are
> equivalent. This makes removing the duplicated IS_ENABLED()
> check in funeth more obviously correct.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks. This looks correct.
And try as I did, I couldn't find anything missing.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 007cec23a92f..16405b84dc2f 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5442,7 +5442,7 @@ static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *sk
>  {
>  	struct net_device *tls_netdev = rcu_dereference(tls_get_ctx(skb->sk)->netdev);
>  
> -	/* tls_netdev might become NULL, even if tls_is_sk_tx_device_offloaded
> +	/* tls_netdev might become NULL, even if tls_is_skb_tx_device_offloaded
>  	 * was true, if tls_device_down is running in parallel, but it's OK,
>  	 * because bond_get_slave_by_dev has a NULL check.
>  	 */
> @@ -5461,7 +5461,7 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
>  		return NETDEV_TX_OK;
>  
>  #if IS_ENABLED(CONFIG_TLS_DEVICE)
> -	if (skb->sk && tls_is_sk_tx_device_offloaded(skb->sk))
> +	if (tls_is_skb_tx_device_offloaded(skb))
>  		return bond_tls_device_xmit(bond, skb, dev);
>  #endif

<2c>
Possibly some further shuffling, perhaps by making bond_tls_device_xmit
do nothing if CONFIG_TLS_DEVICE isn't enabled, could remove the #if from
here. But possibly that wouldn't be an improvement anyway.
</2c>


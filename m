Return-Path: <netdev+bounces-9513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B93E7298FB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E5402818D3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693AD1641F;
	Fri,  9 Jun 2023 12:05:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DA7154A8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:05:29 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C839030FD;
	Fri,  9 Jun 2023 05:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686312327; x=1717848327;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q4iVldE0P7EshFYLchb23L7R2hNB7e7nUWpFzWliIGc=;
  b=dqJKYhRIOxJ9HMgr9/CaHmimtevoQQCdTMZ47zT6QOCE/311PxqnI23D
   9njBCwGJffD6resGxkVCJ0kZ8K321sHj0P8hvsoEYB5jVqkUPXIjsWPDB
   wcwHItI0s8frAscFfVc3Ys9IF/rSN4gev2NojtyLy9K/AXQlPeJmQYIPo
   R/X4Nw5uLnw/VtrjyPsjXouXu0unreMflAscN01EIOCELa9iGjKL6HbHT
   14hnW3l2DIGxcelYPqeSZ2cKux++tRmmwecBk7DSYRJ4cQRr+H7P88oBK
   8bFgbrEoKNkj0ByfPNHiWB6Fr4zMQj6WcbOn7RtVXZpZ872FqKrApwob9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="342259481"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="342259481"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="834628958"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="834628958"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 09 Jun 2023 05:05:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:05:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:05:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 05:05:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 05:05:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD0QavwkAxLgZ8z/NqLJsvd3IE9fcycX8LoBP3PfnipPmC4IixsjHfJemlKracAEyrKup766PVHBT5uR1z7jCHQTHNed7fhafbTTG2LkPnxQWaXGh9uciEk6Io/kC010yBUUSms0XaIJ/0jKxhLwEUOMq9nAGX4N9ZYGMALbC1Cik/aHpJgw06VXBaNt060y4VXeGM041eYJAKkCr+Qk9/r6M0V5JfadPTKy3o8gYJpxCBbr1Gs3cmn1Mor8gKZO7Wy3RFKfCITvSbct2V8luVHmEGPIUPMZhbCi2Vfz5R3PKx/IXOJ74gboxLWOIKWGldjiXRIDS6fzWbBClAoZIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLUOFHZSqGv0+k4KxWvlULEKc0cinvkxDM5fZ9T9gG4=;
 b=BQ9eiU/eqJwItXl4/tUNMkEnvdyq75CFxkxWuH53O6WFn6a3/7SkH91sHAx2kswUF6Ow5lgkRsG2hAaLsUp7xG3lywwMvdBpZhtUHoz+6ULmow4JNBzN3EojRgmPGD3zsVAGKsr3iNLcRCoE8cUsUneImeBa2ZA0K6+ATTsm4thMu+N3xtG8mR0eBHzmztgvDrg2rhhobBz9DH2+Grpz2NB5MKP67hW3wxtlDBfVj4ydkMuhn7+lzkLQ+I7l4MKU7FtehDkB2J9ueT36x/+fDoU/3FVQJ/xx5X/Ipt9uJX0dzEuNV3Tq1C3ePVRYqQAjQIlx7IGCxRCnDIGfxtS7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CO6PR11MB5667.namprd11.prod.outlook.com (2603:10b6:5:35b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 12:05:22 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:05:26 +0000
Date: Fri, 9 Jun 2023 14:02:18 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
CC: <mptcp@lists.linux.dev>, Mat Martineau <martineau@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Geliang Tang
	<geliang.tang@suse.com>
Subject: Re: [PATCH net-next 3/4] mptcp: unify pm get_flags_and_ifindex_by_id
Message-ID: <ZIMUyt2f2D+fiuGI@lincoln>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
 <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-3-b301717c9ff5@tessares.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-3-b301717c9ff5@tessares.net>
X-ClientProxiedBy: FR3P281CA0034.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::20) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CO6PR11MB5667:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f87c24c-40d4-4065-9788-08db68e1cf47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMLKVXWfT23UFxGmRaoI40Y6dToUKl+ltKzyZlzZoV3tyPOEDVBuzj/OC5gji0Zq1XbcDZlXX6BldPTen7YbkAgQturiaXpXAKtoypK31EaZBVDsqKHG+XRmIIBRx13txD0IgQ9+fpGcObpdrBPwaZQg2zSJZGH2+zL2wJDdbGhIAcO9elkttiseayWxdwtNSomQxTzRfFJ+N1CutcBJDtWdjW52eyYuO3Z2AzdvYQEJnMG6v3+wPur0yQbDWh6M1/Da5Q0JAB04MHbomIxOBOr6rm1LVKsVMnFnX43G1mV3tWJSCAoejNE3Psd4XB81Eb/pyRd9h86qsfnoaHG6ouwwkia16HwtFlGPCaJ3rzhJC/5idtayZ82npIpSWk3ifJtaR7fd5/qOSVvIO90nNsQs50+Vhj9tujnx0zA9EOR7HTViEdFtdtHufViuiI7Nz1ZyfiNPtwsOeQKIWK9Gw9+9ZDFFh9GYny1KPzmnmXk1LyscpHPntDX9KvV1oArb7YLWF2BoQZyAPAYvgBqw/Z1U22kML10pgKnL03WUVKARL035jnSBO7xwT59APR3Vif6GyEjR/5S1ZwQDcqsrF9P5eitsLK9HWUrQdN4W4WQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199021)(54906003)(82960400001)(478600001)(38100700002)(5660300002)(8936002)(8676002)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(41300700001)(186003)(6486002)(83380400001)(6666004)(26005)(6512007)(6506007)(9686003)(86362001)(44832011)(7416002)(33716001)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oY9qS6MlH8WY2xMqw2ZvnBx2lRAUfUX/E9/JeMbAVT0yFGRr2olPwopSsbN7?=
 =?us-ascii?Q?FHAIusmWZxq/xxmzIHkEI/464l2y0ofyjY/cbiHJciOwtqW4xTOTFaCEtL/A?=
 =?us-ascii?Q?i02xcw8LlBiJf7bscn0h1Yk5sDsKtytLnBEEZ2dCXOF52zCrB0uHkRowxLYt?=
 =?us-ascii?Q?1HjLLcLJM1ssmVAWyNvEAJ67ISq9wdmsvOLUsPaC6mQq/vQJWXPpm5rj0W1Z?=
 =?us-ascii?Q?L3Fnb41xfM62eEZnKo3eW6oIOk0U14nfi27Y/isZ1/YtczBpXkFRNqiQhdmp?=
 =?us-ascii?Q?7mXoV3LDefLMuqKJ0Oe/ACwOR2HCloSJzG0oVdGtXSUe20mfCIXoRKH/IIeT?=
 =?us-ascii?Q?uUmUC9CaDyhMceHsUf6SVHk3kGyNy/dVg5k8VKcbElrq0tLs6ZWZkE6Gth0i?=
 =?us-ascii?Q?9n7Vt0baT82VNsY5lXC622JH0n+SaxD06DakNLkAhovcMQAePySAEqcRITaX?=
 =?us-ascii?Q?VyNJk1McJP/GQrMzFl7QYmnRwZQYc6BEXh7IGq0pxhmzNQohyX0wziqoDpZL?=
 =?us-ascii?Q?62HASV1zilbvQBmsUiE8Pe26aPHhHfoFfyt2KQlGeqE9NfLzPTYZmzKWNyKL?=
 =?us-ascii?Q?V8GFe0USKURLN2gDw0v6UgJaShY+c/TQrQIbZHLz/7pAOe1fTRsGEiRXSiQT?=
 =?us-ascii?Q?mjix9BFn66NVrdCUF/EOPCd2laYQPowyV+bDlRIH08bFMb2UQE2TL5ieY+ia?=
 =?us-ascii?Q?Wn3v26JH+DBqh6F689bw3+xwm9DdOh3eW7Qxr0s/ZMYUzCe8M6tyVJ1Jnspb?=
 =?us-ascii?Q?aiNy8gS1m4VHDzHbJ2+zHQkkZlfblV/vTwnFje2CtEtkLwN5FIbl0rMJ+QBR?=
 =?us-ascii?Q?s+H/Iym113tBwrbxgQfan6Dxw4SoE4AasesLtlqw0RC5cti9/fPVe+QnHrlP?=
 =?us-ascii?Q?u0LZi2H5XBTEWhFxyJ/zRS/6G0ehb2mIGmiFNp+P0ZpYQ6drOI+JEnTYWs0e?=
 =?us-ascii?Q?ersrsUqja8ormB5dVt3kfViqRwC5mZ6N5/fGb/dw+d0IklHfzun6dtR472KM?=
 =?us-ascii?Q?ds4blyvpnC5tdHgMIPOjT1R2v6YfY2bVWePl+oLx4mjUutvYZ+X50k2n3vCN?=
 =?us-ascii?Q?W3zK9yggt2FQbYUqIqQXzGi6rjOZ+Mq6HJ80QOJmdoUNEIlMVzw3qTN9y0p0?=
 =?us-ascii?Q?39t8C03UJCFKUyw2pZFbXXsaxwAe3LcWAwBPQiLPY+eb4wlLyFotRYxZBfja?=
 =?us-ascii?Q?0ogm5X6oU1lGwX4d8JBccg8n0IPkNUkHzwgsdHdfPyQ9oWsvC2CvYzh44jRp?=
 =?us-ascii?Q?UFDAxJMeEYmbepObeC4YNGM1+hJDWD7Xw/RIAU4ESBi8rZ+W4CnoLBBKIJBg?=
 =?us-ascii?Q?Rdu3Gpjdzq97e72S4YlJBqqtS1ad3b75lB77JvRXhIzA+62kvvzZz3wYDjPS?=
 =?us-ascii?Q?Xm+Ai1lwE8Y+LUm5CiJcumqFN3KCw4XReVbVuyxcHAVrPGDCEaQWvQn7u/6D?=
 =?us-ascii?Q?4VEqZStSEQNMOQGPIqSxnp30VbfTWX7ytL7xbe12kvrQW8/3mr9+pn/J4rAC?=
 =?us-ascii?Q?oYOXnHmAWDlW3lG4ahPI3LjkaJj+elxkcKgOyqw/ZbmrekgHc13f3hIMMjm1?=
 =?us-ascii?Q?X2DLwmQc1zc/DQMP1Nlr4FMc1ffC5jw7zZzqXe421jrofOCD+8oXe8D5I5Dp?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f87c24c-40d4-4065-9788-08db68e1cf47
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 12:05:26.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmmxvhFw8vp6M3xNA7eU5lMgwwHwQnLmB9GpPKfXX86lhSrUxaEbvCDhq/gBtG5Rhr3X+oG/j0HZK8aqQzwja5XRub88Qq78uSudx6pdymw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5667
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:20:51PM +0200, Matthieu Baerts wrote:
> From: Geliang Tang <geliang.tang@suse.com>
> 
> This patch unifies the three PM get_flags_and_ifindex_by_id() interfaces:
> 
> mptcp_pm_nl_get_flags_and_ifindex_by_id() in mptcp/pm_netlink.c for the
> in-kernel PM and mptcp_userspace_pm_get_flags_and_ifindex_by_id() in
> mptcp/pm_userspace.c for the userspace PM.
> 
> They'll be switched in the common PM infterface
> mptcp_pm_get_flags_and_ifindex_by_id() in mptcp/pm.c based on whether
> mptcp_pm_is_userspace() or not.
> 
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
>  net/mptcp/pm.c           | 14 ++++++++++++++
>  net/mptcp/pm_netlink.c   | 27 ++++++++-------------------
>  net/mptcp/pm_userspace.c |  3 ---
>  net/mptcp/protocol.h     |  2 ++
>  4 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
> index 5a027a46196c..2d04598dde05 100644
> --- a/net/mptcp/pm.c
> +++ b/net/mptcp/pm.c
> @@ -419,6 +419,20 @@ int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
>  	return mptcp_pm_nl_get_local_id(msk, &skc_local);
>  }
>  
> +int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
> +					 u8 *flags, int *ifindex)
> +{
> +	*flags = 0;
> +	*ifindex = 0;
> +
> +	if (!id)
> +		return 0;
> +
> +	if (mptcp_pm_is_userspace(msk))
> +		return mptcp_userspace_pm_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
> +	return mptcp_pm_nl_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
> +}
> +
>  void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 315ad669eb3c..e8b32d369f11 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -1356,31 +1356,20 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
>  	return ret;
>  }
>  
> -int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
> -					 u8 *flags, int *ifindex)
> +int mptcp_pm_nl_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
> +					    u8 *flags, int *ifindex)
>  {
>  	struct mptcp_pm_addr_entry *entry;
>  	struct sock *sk = (struct sock *)msk;
>  	struct net *net = sock_net(sk);
>  
> -	*flags = 0;
> -	*ifindex = 0;
> -
> -	if (id) {
> -		if (mptcp_pm_is_userspace(msk))
> -			return mptcp_userspace_pm_get_flags_and_ifindex_by_id(msk,
> -									      id,
> -									      flags,
> -									      ifindex);
> -
> -		rcu_read_lock();
> -		entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
> -		if (entry) {
> -			*flags = entry->flags;
> -			*ifindex = entry->ifindex;
> -		}
> -		rcu_read_unlock();
> +	rcu_read_lock();
> +	entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
> +	if (entry) {
> +		*flags = entry->flags;
> +		*ifindex = entry->ifindex;
>  	}
> +	rcu_read_unlock();
>  
>  	return 0;
>  }
> diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
> index 27a275805c06..e1df3a4a4f23 100644
> --- a/net/mptcp/pm_userspace.c
> +++ b/net/mptcp/pm_userspace.c
> @@ -85,9 +85,6 @@ int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
>  {
>  	struct mptcp_pm_addr_entry *entry, *match = NULL;
>  
> -	*flags = 0;
> -	*ifindex = 0;
> -
>  	spin_lock_bh(&msk->pm.lock);
>  	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
>  		if (id == entry->addr.id) {
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 8a2e01d10582..607cbd2ccb98 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -822,6 +822,8 @@ mptcp_lookup_anno_list_by_saddr(const struct mptcp_sock *msk,
>  int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
>  					 unsigned int id,
>  					 u8 *flags, int *ifindex);
> +int mptcp_pm_nl_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
> +					    u8 *flags, int *ifindex);
>  int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
>  						   unsigned int id,
>  						   u8 *flags, int *ifindex);
> 
> -- 
> 2.40.1
> 
> 


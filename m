Return-Path: <netdev+bounces-9552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAA4729BB5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:38:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BE801C210E0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BAF1773B;
	Fri,  9 Jun 2023 13:38:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1283D174E4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:38:47 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2431430F1;
	Fri,  9 Jun 2023 06:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686317926; x=1717853926;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=z8LpolJrBZD1f2xrkoa7M9ugiziI46rMa8u2i+0sn3E=;
  b=XYbZ6icUwRk8nkwoPt2keT8WKFmK7esSkraBgJzSh0zvdMtdcQuNHk0r
   E2jvfdvqRaOof3QLNFBgKxJKwGGuLSuneWaZBdSuXGgdM9pouVP4Y8Y9q
   oz/xLO8vF7liYmb+2FzRQH0WlexASDvD9k1FqV8WSMVkGwXTagB2+UqPf
   Zm0r39+j7A2mR0R8rSRwL4CDWQazOnDL1kfUCUigLSHhhW2PJNCSRNjga
   P+7bRvIP6kp67jtuurIdDXNJ8Mi689Lgn5+XqB/pLfFmXv2vGFpSSfIWd
   zXQ/QrCY6Ts57xbTmDE7fHw58ZBRT4yUR7CJ7FBDTkw94mocW9UYxAlY+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="337232442"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337232442"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 06:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="834648646"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="834648646"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 09 Jun 2023 06:38:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 06:38:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 06:38:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 06:38:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQc3goRmHCmFtrDNXk6DgRfShGmvsbRiJAx++QXzJ29TzFl/ShLJPFL4cEMdEUobDiIQhRSpVHTvJ+GN17twGSKPVuV3lNYA7aRHHEbCFf9IF+i9kdwChmDQEgq/Sj2yq1w4LwLDGpuHteibqcpPW/0M6nQKB6NKfUv+CLial97+ryryCcKaPnzsj/pU+xwnW9XnVtEUdv/en8Z8qUQRLs+abkF3vM9Gz/ZjsNKQRzM5NFs0KJL0fulhzH3tGsynG8EvjEKQUNK5+lC3PRmFESuhCgb6ayGdWW+WK7pehTTa+c98AWVFIto3epqb+/pn3GqGNCdGqg0C9v2/fVodgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZC1saWRRuIVXhfp5YN/CQ27g7Z0eJXjmzL+wA90N4Y=;
 b=aF1KsrHv8Nl7FdP8sXGqtyj5oaqVDU6Sin97bnTrvp5ePGEjasGW3fCOrzU8yl4N4zKIWnmTulAvvO/jhRnhjJqsShiKnDoAJhDm9QsKZIsV/oGF9VSy40Hb9URPBmM2cjRGpNN/JpOmcNpNtubD21QeqjJ3ymjVhABkIxieDBHlS5p6SrKnxNKJhaVbw1JtZngCrwcsuoyn6VDYzH99DdgqNZMbbnLQa36xLdMFdN0hTPt0ayb/3UpAmiIFBq/Fqv98RKvSWxXkixfHte7qYE7pvq8bcM0WlN3CN+xeqO8Ibw08V1w45X4d0qq6yQuGJL5MPpYIUobEeF7kcnupbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by MW6PR11MB8368.namprd11.prod.outlook.com (2603:10b6:303:246::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 13:38:43 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 13:38:43 +0000
Date: Fri, 9 Jun 2023 15:35:35 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
CC: <mptcp@lists.linux.dev>, Mat Martineau <martineau@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Geliang Tang
	<geliang.tang@suse.com>
Subject: Re: [PATCH net-next 4/4] mptcp: unify pm set_flags interfaces
Message-ID: <ZIMqp+uJ9SUIHvR5@lincoln>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
 <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-4-b301717c9ff5@tessares.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-4-b301717c9ff5@tessares.net>
X-ClientProxiedBy: FR0P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::9) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|MW6PR11MB8368:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e2312c6-709c-4818-8726-08db68eed755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKyuPXcMh/6tZ6ROCHxhfqNuVHFBjRPTBPdYp/LaPdi95h1mGqq/QlJsdqns63qSSJ43oXr/RfJjfu5OJ6BFXPJBBxCUh5j+MsHY7azvYvsrKUoke/zUxIEs3ICbfYhDA2PgJ869cEO0BMd+AE4TC2zjAreDKJiFFMSC6Oy1wGXoO5OK379lUI7mU8loHbYbmQjbeZ0Msf5wmUkjqRXfTTE2cNUEXMWTFQdcs6eBGJbsIN9LFQpMrwAWf2WyWn//NeLPxSBJHIKcpLUbWX//frnZxNTlQDYAx1pgWVH9naFIwluQU+bQvuOWa4cCN0hchpfCKQNw2f7rQ2R4V7sH9SWKi/dplMgyy/pzhBqLxn9/FPCLlRqxIUONS7D4kOalpvbg/fWwmD/42bWh54Fbs/6FdwyxVaX4UYrG6GLwi2gBvCgc0FrkBX0xK3BIS6APrhtbGMLFwhJiTKV5Ww4d4pGpKG3gyv+HqxJ+lf1JMIlpiH3GarTdp9WZpjznX+kteyidR9/RZR84b0Y90ISj3qhDxk/TN/6KKuzHJmSF5mAjpHX+YS4+aTas2y4EmBn51+6T6euIql6678eURkzJ/V8do6vnD1LhvhHAt1ntNLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(83380400001)(7416002)(82960400001)(478600001)(8936002)(8676002)(4326008)(86362001)(66476007)(66946007)(66556008)(6916009)(5660300002)(38100700002)(41300700001)(316002)(6666004)(6486002)(2906002)(54906003)(44832011)(6512007)(33716001)(186003)(26005)(6506007)(9686003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xgu7fJihT3nWmKhBfV7k7FPK4TIcuHziQh+PyLT8OJtCGOJYkZ0FtzhiRtz9?=
 =?us-ascii?Q?K7EVtxEx3UWP92iGDcrN7d4y8v4ObhdgEDmDYNblAO16C/ZaQxc/S4kWZ5xZ?=
 =?us-ascii?Q?xo1OuppSumsnWTW1QU0bYWkjzL0/9DHwZuz6I2wqOPAQKao2QPzmoj/d2XZr?=
 =?us-ascii?Q?DrMOJSCdZNSo5/OHx5Gnenb3QpV3TjQ8tRFcYOf4XIEho8nBE71VlePgM5OM?=
 =?us-ascii?Q?9SG7DmwLuxeZ6CvBf28A56KrlkGbLgiT+INA4uwqMLC/dw2d/F/uPN3D6JHc?=
 =?us-ascii?Q?yb8g+MKHcnUDHwCw/DbjtperhrGOlw5tVCCHzmzvOgFAdqdXLJKMjneUEzvS?=
 =?us-ascii?Q?on8ILXex9GvHV/jy3ZEvNFboC9rq4703Aau1OXjZy1RVSo8x78+WT+lZXpHu?=
 =?us-ascii?Q?BDMgM0ie9DHqjbxzrvfOWCaoowCwja8DGdfjBY5ICLUIe2EWyYSEi7bXCNif?=
 =?us-ascii?Q?qHlnudfoTgWQIiMSIcH+vBYUja3fB+9F+pngAiXh8uYMT8kRlROC1PVSxSGu?=
 =?us-ascii?Q?Qms9M3DcjbrmWdenY9O9PrwePPP+i/UN7s7/KEvrEykiGhWFHs5L+mB965G6?=
 =?us-ascii?Q?9Wbbn9unDRsUd6Qgy4UTNRQ3K31uZP+0YAjZCj9mdKJpjSVdj8l88AiIepAJ?=
 =?us-ascii?Q?EQCM5gOCUoxRrhi0iWqJ1kyGNN8nVKCWrdahXXLlGm/mKPk3G9jaq9y98hXV?=
 =?us-ascii?Q?TEDMJllsjYXV35Fa5xA5Wb8Df4KHrf4KdN6WvITcwxzQLXf6kV4flbvMIURX?=
 =?us-ascii?Q?upFSNiR7YeMPBUKAFdtbGHtBtd5O3w84hgYOlOfhBb0F6PAS//RYbUr9NhJ6?=
 =?us-ascii?Q?Uw124Ktojzgt/WWn7UfFTzBLBoSXYuZdoNmcaFDjb+/QYVNmRiEw6SyVV9Rm?=
 =?us-ascii?Q?z/RNtfTtHjUaEwtVV6ujEGoj6/HHTM3qZNBiS1pcLCXrHlfyDVmG3M9OO2aH?=
 =?us-ascii?Q?32FZ33YOQH0sZgfcO7S8bkvi+b20/R37ZKDZPMmNWWj5H/L23zNbwZq94oao?=
 =?us-ascii?Q?V2XSYyE1DHtZEs0WPmjd9meLoBDd2raBdXcmmfDTxs3RN1x9hmZPGvDDvidV?=
 =?us-ascii?Q?OJhRxxA8EvgtqTKKop3P86kfDgjHf8RNxapGe9/vb2UFImZFOwxCoKaVvas3?=
 =?us-ascii?Q?aA4jlE4gLmqR+4uyNPzNHxerSWaNmxlSpWwMJCLOaUEFi1DaQ3jYfhfc7xIm?=
 =?us-ascii?Q?ZZpVSBLwzTGl9morMJStmUreoRSDgg3ee4mgHiOdYUvXx7m/T0Y1IkXrMGGE?=
 =?us-ascii?Q?5/m1dZcDj+PmKsZ3274SsLHDvKqji3wgrH+opFW3TlY/XWYoEW9uTzx3itdT?=
 =?us-ascii?Q?g8n6agJNWuXco4iX7DfBBaeiXsL/qPnau3RyUg5q7n9Oyl9eIVSeDggMZZDZ?=
 =?us-ascii?Q?rmMjDxaz+mN6sF1BOOPcXPKdmAGmd+YITZtu05zccJzRU80NhLhfghR5oafd?=
 =?us-ascii?Q?+CvXNUy8zvEy2PeK1eUv/gKrG6LgB82/Nj2avjLkvCL1WhC74Q3kgkn4lPOd?=
 =?us-ascii?Q?atsvthqlU/OS/S2BZ8uCu2a3en9CBYZZ0i70Gip76POBlRAJMV9XXa39fFq7?=
 =?us-ascii?Q?eHwvOj85ncy5CUDjyUg6C91XqjO+ALCGm5CL4BrmJ6bnWTUbNLNDdlqtRp9+?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2312c6-709c-4818-8726-08db68eed755
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 13:38:42.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkumhNFqSbnDw77y/KdR2TBf+UUSJoxKO/yEtPU5FSwD2eOCu4bkQ9dI7XDiFGgSMcnkPNC/wyhmueAusyDyiSWHAWH1QBIJuCwITumOii8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:20:52PM +0200, Matthieu Baerts wrote:
> From: Geliang Tang <geliang.tang@suse.com>
> 
> This patch unifies the three PM set_flags() interfaces:
> 
> mptcp_pm_nl_set_flags() in mptcp/pm_netlink.c for the in-kernel PM and
> mptcp_userspace_pm_set_flags() in mptcp/pm_userspace.c for the
> userspace PM.
> 
> They'll be switched in the common PM infterface mptcp_pm_set_flags() in
> mptcp/pm.c based on whether token is NULL or not.
> 
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
>  net/mptcp/pm.c         |  9 +++++++
>  net/mptcp/pm_netlink.c | 70 +++++++++++++++++++++++++++-----------------------
>  net/mptcp/protocol.h   |  4 +++
>  3 files changed, 51 insertions(+), 32 deletions(-)
> 
> diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
> index 2d04598dde05..36bf9196168b 100644
> --- a/net/mptcp/pm.c
> +++ b/net/mptcp/pm.c
> @@ -433,6 +433,15 @@ int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id
>  	return mptcp_pm_nl_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
>  }
>  
> +int mptcp_pm_set_flags(struct net *net, struct nlattr *token,
> +		       struct mptcp_pm_addr_entry *loc,
> +		       struct mptcp_pm_addr_entry *rem, u8 bkup)
> +{
> +	if (token)
> +		return mptcp_userspace_pm_set_flags(net, token, loc, rem, bkup);
> +	return mptcp_pm_nl_set_flags(net, loc, bkup);
> +}
> +
>  void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index e8b32d369f11..13be9205d36d 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -1864,18 +1864,50 @@ static int mptcp_nl_set_flags(struct net *net,
>  	return ret;
>  }
>  
> +int mptcp_pm_nl_set_flags(struct net *net, struct mptcp_pm_addr_entry *addr, u8 bkup)
> +{
> +	struct pm_nl_pernet *pernet = pm_nl_get_pernet(net);
> +	u8 changed, mask = MPTCP_PM_ADDR_FLAG_BACKUP |
> +			   MPTCP_PM_ADDR_FLAG_FULLMESH;
> +	struct mptcp_pm_addr_entry *entry;
> +	u8 lookup_by_id = 0;
> +
> +	if (addr->addr.family == AF_UNSPEC) {
> +		lookup_by_id = 1;
> +		if (!addr->addr.id)
> +			return -EOPNOTSUPP;
> +	}
> +
> +	spin_lock_bh(&pernet->lock);
> +	entry = __lookup_addr(pernet, &addr->addr, lookup_by_id);
> +	if (!entry) {
> +		spin_unlock_bh(&pernet->lock);
> +		return -EINVAL;
> +	}
> +	if ((addr->flags & MPTCP_PM_ADDR_FLAG_FULLMESH) &&
> +	    (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
> +		spin_unlock_bh(&pernet->lock);
> +		return -EINVAL;
> +	}
> +
> +	changed = (addr->flags ^ entry->flags) & mask;
> +	entry->flags = (entry->flags & ~mask) | (addr->flags & mask);
> +	*addr = *entry;
> +	spin_unlock_bh(&pernet->lock);
> +
> +	mptcp_nl_set_flags(net, &addr->addr, bkup, changed);
> +	return 0;
> +}
> +
>  static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
>  {
> -	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
>  	struct mptcp_pm_addr_entry remote = { .addr = { .family = AF_UNSPEC }, };
> +	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, };
>  	struct nlattr *attr_rem = info->attrs[MPTCP_PM_ATTR_ADDR_REMOTE];
>  	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
>  	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
> -	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
> -	u8 changed, mask = MPTCP_PM_ADDR_FLAG_BACKUP |
> -			   MPTCP_PM_ADDR_FLAG_FULLMESH;
>  	struct net *net = sock_net(skb->sk);
> -	u8 bkup = 0, lookup_by_id = 0;
> +	u8 bkup = 0;
>  	int ret;
>  
>  	ret = mptcp_pm_parse_entry(attr, info, false, &addr);
> @@ -1890,34 +1922,8 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
>  
>  	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
>  		bkup = 1;
> -	if (addr.addr.family == AF_UNSPEC) {
> -		lookup_by_id = 1;
> -		if (!addr.addr.id)
> -			return -EOPNOTSUPP;
> -	}
>  
> -	if (token)
> -		return mptcp_userspace_pm_set_flags(net, token, &addr, &remote, bkup);
> -
> -	spin_lock_bh(&pernet->lock);
> -	entry = __lookup_addr(pernet, &addr.addr, lookup_by_id);
> -	if (!entry) {
> -		spin_unlock_bh(&pernet->lock);
> -		return -EINVAL;
> -	}
> -	if ((addr.flags & MPTCP_PM_ADDR_FLAG_FULLMESH) &&
> -	    (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
> -		spin_unlock_bh(&pernet->lock);
> -		return -EINVAL;
> -	}
> -
> -	changed = (addr.flags ^ entry->flags) & mask;
> -	entry->flags = (entry->flags & ~mask) | (addr.flags & mask);
> -	addr = *entry;
> -	spin_unlock_bh(&pernet->lock);
> -
> -	mptcp_nl_set_flags(net, &addr.addr, bkup, changed);
> -	return 0;
> +	return mptcp_pm_set_flags(net, token, &addr, &remote, bkup);
>  }
>  
>  static void mptcp_nl_mcast_send(struct net *net, struct sk_buff *nlskb, gfp_t gfp)
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 607cbd2ccb98..1e7465bb66d5 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -827,6 +827,10 @@ int mptcp_pm_nl_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int
>  int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
>  						   unsigned int id,
>  						   u8 *flags, int *ifindex);
> +int mptcp_pm_set_flags(struct net *net, struct nlattr *token,
> +		       struct mptcp_pm_addr_entry *loc,
> +		       struct mptcp_pm_addr_entry *rem, u8 bkup);
> +int mptcp_pm_nl_set_flags(struct net *net, struct mptcp_pm_addr_entry *addr, u8 bkup);
>  int mptcp_userspace_pm_set_flags(struct net *net, struct nlattr *token,
>  				 struct mptcp_pm_addr_entry *loc,
>  				 struct mptcp_pm_addr_entry *rem, u8 bkup);
> 
> -- 
> 2.40.1
> 
> 


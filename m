Return-Path: <netdev+bounces-9510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0997298BE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3440828186C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745701640F;
	Fri,  9 Jun 2023 11:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA7479E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:53:38 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0763E420E;
	Fri,  9 Jun 2023 04:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686311590; x=1717847590;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c1TyHeyXq7Us0cWyJaIBLJp8PMHuIC3va0ceyVqi5y8=;
  b=QUJQJp2rmKkbTDp+my1hY1uMnGUg+6XPKTZMlUeTuGxILDrIanqSMbfQ
   tY2hLJqCVdhHtoGNWIyEhQ0VMHzwQdCWaW6GhE00QK0PLgdlnAwkJ+75p
   6OJbQiww8B6YgfcWzHqeJXelWbBYBlrUdYoX4GzQ4YE7kELns59/H9/jy
   JJy9/dOtYC3UYs7vBRVvEJPBpFZtP/YbD+17NNLz02eldpCSaaVaoDvdU
   0TLlz3cKPXMs+1zu3p2fZSdJYHRVlErcz3+TDcWbimCVjDBDIzEWSJzgK
   R06EppY7aJIqsaYhgfbnYZMSj9WZd974xgMfcIo7zLY4aT7+brf9jEqya
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="360065029"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="360065029"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 04:52:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="780285596"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="780285596"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2023 04:52:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 04:52:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 04:52:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 04:52:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzK9vGRntE67hsWKzbjETUEguKe4wR8YQdwQC3E86SRzkfQsjyIVkgIWJgnNaxK/Ks/on0WdGGRemdHsSNN0eI3H/vtC7am/kJQAi5IcG67zbU7uiNWFetNt9HL2fQBe15kTfhc+1LkKGZtsmacrPFPtL0hzeaj3/XrB9Kf6t9adW04ncAA/b4bKko9QO278nCl0OPl3V6PaAziBMs8/Ca0oACRurBMUmKeuz08ZQrfxi9BC1uamDV843AHCF/Hw9+gNr4rROB/Cx3FdV7iZyqMAk4vZSJB3+zRlwZreddBSool+vOAeZX1/HeMlF1Ak+8ay5BcSOJ5gQT462zza5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+SmHPkU+Ma2XwRr22fO9fF+ShcYDuILp1rb9DCYdc8=;
 b=EyTSmKgxCgtYr0gt8fucUpDP5gKlrV8wh4rf/nYFfW7HzW8dBYEWI1RqJ65/ZpRFKjwxA6mLSHx2KoAfQOy0p50ftaB3HkJhn9V/R9+J45ovNp2r3ZMRdZ17kWVcKWFAqAp1RCFJPQA3pnPaDibKxqWux8G+Apcx7DYtprIavGNQLjOJq4o4+iq8BPcqEHaAsOsLapnfO1UOLSj2Go2nOFo+dov/3dU1gA2I7Hwygv3spZ9O8B7AS3BS00WMZda4TJ3nDv0sg89gVrijr9L4IFkG5rhWUqRquLYt5ZAlTTUJo59OXG9F4D5TV0GG8eBZ6eN/dbUYfQ5FRdJ3Z1pVbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CH3PR11MB8342.namprd11.prod.outlook.com (2603:10b6:610:167::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 11:52:07 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 11:52:07 +0000
Date: Fri, 9 Jun 2023 13:48:58 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
CC: <mptcp@lists.linux.dev>, Mat Martineau <martineau@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Geliang Tang
	<geliang.tang@suse.com>
Subject: Re: [PATCH net-next 2/4] mptcp: unify pm get_local_id interfaces
Message-ID: <ZIMRqh1uMp8K57CK@lincoln>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
 <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-2-b301717c9ff5@tessares.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-2-b301717c9ff5@tessares.net>
X-ClientProxiedBy: FR0P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::15) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CH3PR11MB8342:EE_
X-MS-Office365-Filtering-Correlation-Id: dc4e8b5d-b01b-445b-2db6-08db68dff33b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIMCfbO34FneLlfRX5gNhEeGc9inecVkZmclvr8TNAod8D6XcN7/JrIUOLM3qSnD9OBTEaZxoPgOK2ge4VP0cNzuS039RfXz0FhLPJiFOpXWH14LC6sNZdEKS21+BoCyGnzB7xIpBk3ntB8/LyiC2DQQ70QNs9JnAAtLcdLsSCNV1aVTmpgv8B+RKXLxzsARnx0CTjixGKdRQ8CKz8eHIYgDmQ4wuaKkDNMT/v8TWAMAq2whpknzISLKgDMPGP3lHPQADncbrz5JEE8yPUevFh0sM1oC2QV3jClXBUIjAn/5cHrXpmb4uu7jPLekB5jssIYBJpC4+G4+W40tEgrQTInVKDrAgLLKeNHr1mCt/s0X92I0EUF6/0hvg+WapNZZXQ0tAr7q6tcq9sMJzxSHGxvKsuR4HxFaK5KKzZIrFKZB9FWB9V92c2lKskrdIGPw3ySRA1RAwmum+UBCSgKEMuuRlrjshLiiGRecLsZz3/g0O1XaRRtFR/yED9x7jY583UDlOXc9EuzzBaOGy6mZjTZWJqZAhIomd+wz6CxhQFIE/T67t8G/V3q+d8xbjrRI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(2906002)(6486002)(478600001)(6666004)(83380400001)(26005)(9686003)(86362001)(38100700002)(82960400001)(6512007)(6506007)(186003)(33716001)(5660300002)(316002)(7416002)(41300700001)(8676002)(8936002)(66946007)(66476007)(6916009)(66556008)(4326008)(44832011)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VpP6Oe7j2ljJnJs7ejeyXglL2z5eYGGxOuXu1Vgw9dirSNuUTwYERtm+fBe2?=
 =?us-ascii?Q?FuYp8JJl5AELHooXbFM69bIjLyQlfZNPYLY+AhktzzmQC73f/B/By8C0+Kbp?=
 =?us-ascii?Q?Cxs7ylSSC2bSTbSJhKzWSpw1Dduxe6GZgPzUFmwmzM02WGQ3+whu8+ppWSPq?=
 =?us-ascii?Q?aaUAG5AkdNacZ8f0vvLUZvMrdjDqEpv38XnxJnzME7mYgNCkTAAqhEm+z5+v?=
 =?us-ascii?Q?jD0MSzxlWMxZAZo2Z5v1DlY8sdOObwMA1+143/OG0XJQLYrFJx8HIzLI/1kO?=
 =?us-ascii?Q?BBapGeqqJdNWoAPsnjkA37Im66GIwqHEssQOYgzqiXgZ8jEx3za1Jo+5CJKz?=
 =?us-ascii?Q?faSCNVWZ0lr/ox0ozN02B8bcP34fvQbyAuLwpMCIMi+ceWg7itZ2sTzVFZQ4?=
 =?us-ascii?Q?Dy4uGO0F9RB3XCHBjyzXQM4pwnrSBUofxPtc6FKQGQi6zPFI5VnAzrQXE03g?=
 =?us-ascii?Q?cPSQ18Xp9ORqeaLXYotod9u9TBDhRMBxQbYirgALVwANwiykW6je5/tdHLfZ?=
 =?us-ascii?Q?8W6n5QrbINLeTl5eKYPR1z5/hT8NeMr/VKtV60bZ9oOYCvKOmg51PDlWHUrY?=
 =?us-ascii?Q?w+qcj1VB4YOkhgTAkz4/CkQoFcAjCf0SsvZoiGSM5NcuwAcPpfmQFSuJu2sH?=
 =?us-ascii?Q?NV/TvWYfqDzD4/ZH9YAYCsKIlilmy0Eops1JZoNMMaHOBYr8axf7nPd3SOc7?=
 =?us-ascii?Q?bMU9bVFYyUQztDlmt7pD4/JGejPgZxJdgjpIpTElw1uGu1PicVA/ehdVQyY0?=
 =?us-ascii?Q?u7petd7VvK60AX0vTiZXIZaA62xCGvsVJojW2nRs7AQJ/R5qZg10LCm5gp91?=
 =?us-ascii?Q?R9MBkVY1cb6jR9jQ/S9cu+79vtMwM/FHXKvKDghDLUtACW3heM/zJfiK6dmx?=
 =?us-ascii?Q?d63rFUqTi7+iUw81Z2jElSs9+Y21N4NqOOdZ++vi4HBzYUjo6qBIA44Ndrlo?=
 =?us-ascii?Q?v9D+weHVxNzrgMxf0G9ailCFhcFpJ5q3d1oS+ocdf/k7VMSGPpceYEyCK+4g?=
 =?us-ascii?Q?wTtNl0u6Iq266sV9RNa5fCaU8ACUUGXnDent6rhuBsCQZac0etVOruLl68C1?=
 =?us-ascii?Q?k8SYCSbHoQy9A1e4AzZFk4e73unzUIC61Gk/hAWCnbMT6yc7Be8Nd2le79Uj?=
 =?us-ascii?Q?LuHFPP4IrJMhSFW6H96CiYwmvGaZM+VPJsjig2E3lPdOkkF5MS1ivBXeilGQ?=
 =?us-ascii?Q?gfe2YwqIzaFRWflGFLkqEOjLBsIy6ldMTBHO1yk1jhkNQU0hi0jOiYgRSEWA?=
 =?us-ascii?Q?dTGv3bUcUJRedmRzNZKtGfL9y8E+0TqIRLEJScY9/C0btrKYV4IQ1IlMxOUm?=
 =?us-ascii?Q?125eG5cYnf5Gxw/0hcbCnw1KXfFKqzIyVBI2kp9qIl6eyphcvqoK7713PfLe?=
 =?us-ascii?Q?kU4MkBvESRlWxozlP+JaKmN0HOcMKs2qXEPqggvB1jJpmw4hEPHgBm2qn5SN?=
 =?us-ascii?Q?xbkdlw+GWGCGdtIDjPg4Z911CcuY4FFry08NRlCcTJjYQrbbwr8CuMk5cQjJ?=
 =?us-ascii?Q?dcFg6YWzXCRec5nnutCdl4BzRgb8jkFB3I3PyDhOHPjgy8C8ZDcfwJFYbYgR?=
 =?us-ascii?Q?zpZQFOraVif7jGeHTU+yzDU9gnH8jllXWBxWedscgrx6uUjvvWg9gD3yVc5y?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4e8b5d-b01b-445b-2db6-08db68dff33b
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 11:52:07.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDZ5pWIwhEPlz0rvEFKdYkKFv0Sb3Pz0jDxl8R8rRji85iQc9gFAVAAVYy8yJqLQkVcyLk//R5bq0nihVKTx6rIFKqhbvs6uzw0ix3mGfs0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:20:50PM +0200, Matthieu Baerts wrote:
> From: Geliang Tang <geliang.tang@suse.com>
> 
> This patch unifies the three PM get_local_id() interfaces:
> 
> mptcp_pm_nl_get_local_id() in mptcp/pm_netlink.c for the in-kernel PM and
> mptcp_userspace_pm_get_local_id() in mptcp/pm_userspace.c for the
> userspace PM.
> 
> They'll be switched in the common PM infterface mptcp_pm_get_local_id()
> in mptcp/pm.c based on whether mptcp_pm_is_userspace() or not.
> 
> Also put together the declarations of these three functions in protocol.h.
> 
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
>  net/mptcp/pm.c         | 18 +++++++++++++++++-
>  net/mptcp/pm_netlink.c | 22 +++-------------------
>  net/mptcp/protocol.h   |  2 +-
>  3 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
> index 7d03b5fd8200..5a027a46196c 100644
> --- a/net/mptcp/pm.c
> +++ b/net/mptcp/pm.c
> @@ -400,7 +400,23 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
>  
>  int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
>  {
> -	return mptcp_pm_nl_get_local_id(msk, skc);
> +	struct mptcp_addr_info skc_local;
> +	struct mptcp_addr_info msk_local;
> +
> +	if (WARN_ON_ONCE(!msk))
> +		return -1;
> +
> +	/* The 0 ID mapping is defined by the first subflow, copied into the msk
> +	 * addr
> +	 */
> +	mptcp_local_address((struct sock_common *)msk, &msk_local);
> +	mptcp_local_address((struct sock_common *)skc, &skc_local);
> +	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
> +		return 0;
> +
> +	if (mptcp_pm_is_userspace(msk))
> +		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
> +	return mptcp_pm_nl_get_local_id(msk, &skc_local);
>  }
>  
>  void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index c55ed3dda0d8..315ad669eb3c 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -1055,33 +1055,17 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
>  	return 0;
>  }
>  
> -int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
> +int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc)
>  {
>  	struct mptcp_pm_addr_entry *entry;
> -	struct mptcp_addr_info skc_local;
> -	struct mptcp_addr_info msk_local;
>  	struct pm_nl_pernet *pernet;
>  	int ret = -1;
>  
> -	if (WARN_ON_ONCE(!msk))
> -		return -1;
> -
> -	/* The 0 ID mapping is defined by the first subflow, copied into the msk
> -	 * addr
> -	 */
> -	mptcp_local_address((struct sock_common *)msk, &msk_local);
> -	mptcp_local_address((struct sock_common *)skc, &skc_local);
> -	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
> -		return 0;
> -
> -	if (mptcp_pm_is_userspace(msk))
> -		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
> -
>  	pernet = pm_nl_get_pernet_from_msk(msk);
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
> -		if (mptcp_addresses_equal(&entry->addr, &skc_local, entry->addr.port)) {
> +		if (mptcp_addresses_equal(&entry->addr, skc, entry->addr.port)) {
>  			ret = entry->addr.id;
>  			break;
>  		}
> @@ -1095,7 +1079,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
>  	if (!entry)
>  		return -ENOMEM;
>  
> -	entry->addr = skc_local;
> +	entry->addr = *skc;
>  	entry->addr.id = 0;
>  	entry->addr.port = 0;
>  	entry->ifindex = 0;
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 6e6cffc04ced..8a2e01d10582 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -916,13 +916,13 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
>  bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
>  			     struct mptcp_rm_list *rm_list);
>  int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
> +int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
>  int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
>  
>  void __init mptcp_pm_nl_init(void);
>  void mptcp_pm_nl_work(struct mptcp_sock *msk);
>  void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
>  				     const struct mptcp_rm_list *rm_list);
> -int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
>  unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk);
>  unsigned int mptcp_pm_get_add_addr_accept_max(const struct mptcp_sock *msk);
>  unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk);
> 
> -- 
> 2.40.1
> 
> 


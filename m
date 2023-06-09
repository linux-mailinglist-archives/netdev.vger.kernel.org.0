Return-Path: <netdev+bounces-9508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF22972982F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4349D2818AF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C018154B3;
	Fri,  9 Jun 2023 11:28:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68301154A8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:28:53 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1BA2D70;
	Fri,  9 Jun 2023 04:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686310127; x=1717846127;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XC4ttSuarwYKRngqUt3rc871KkPXfMJF6Pta48lzLdE=;
  b=OBl5C1CrWdM9o+yt/9PSHAoBdaKOXnvSA/5Yr6hZWDXTNzF/r30Jp7gF
   IhYCr0aY7qGswA2MhF4ioqKX9tq1YYXbFAWLZwwVAySw69dr2feJPoWEK
   ZNru5/NYTq6eQN9arbn84U656rvzdMpMrvCYYjt31wFjn5sP76RmFmnxm
   1tONw1FjJ0XHAjiJzHx+IhYBuswIF73V+xSaERRRvSi4g7FsOHZkAhAu+
   0Ed4xjvw8cinnC5KJiqUuu+qoygcjhzh2Kc+nkTJORbOyv9ISm3pkqlFG
   HC0d/r7z3LF/OQbYF4Ys9+yMY9cQL6ILDmDuMvObXgCsnV1nV8cTwJpDj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="355068939"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="355068939"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 04:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="713480715"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="713480715"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2023 04:28:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 04:28:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 04:28:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 04:28:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 04:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz6QQmMJRZBvncedJu2V8f860/7V0+NNc4fmaZnH3acT2jShVbvxQciBxxlyF9izCxkflFqgBV+cRDscUJD2nohnZRqZukQ5yhcHYGhe7/JzCA3PH5MI3lIXKS3i570P+kCQEtN3bbd5mUoZp7PPy57+XMArf/mrDozqVrb/89+pe/sJODKaU8LDTuEfFu02BB95iF8JOJTu3niBCDH6nEPFGO/coLeEfkLlLULjvYpifhvr5PJHeF5Rh7dhkEZvIVvQQyXHz2Z/2R7r8N3h55+fVz5WLt3JXhDiD5H5LHjAgM8UuRUUuoowJfULAW4FwW2uuGLujHNsxa1/wEnOhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNlCFVqOZcxOi4K7ziRSlOBqHDUdgbENFqb+fQfZifs=;
 b=XUScpOnddU+l5YhWgRHnMTL84DMZY0N9+6fkFVFFfYVe7I9vnVnhNwWmGiYS1uauUKOG5rMxNhuBEGlgZe5lrKWCqDiNM+XIwFeKrmMZxecxv/zWHzuSIyQiKnFHqqJoZxUB0k3629Imtosd95Mx1fymz4BRy5YmfS1zB4GvKqStCMizUjXeqDlMjDUm3ySPFWMjqXHaW4YWpGMc0jx6AWeBvuAhE/dSE4Y6vLK0D2zWqHoP33c3MoE1m7+XXa06UU9cmTislYIHP4q35hFFuVbpUe7vukxbzO7fv10VW99mVFtoAZEfOpIhfpNdCBCBgaiYXEeudAa16VnvGJ/jkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by MW4PR11MB5909.namprd11.prod.outlook.com (2603:10b6:303:168::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 11:28:45 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 11:28:45 +0000
Date: Fri, 9 Jun 2023 13:25:38 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
CC: <mptcp@lists.linux.dev>, Mat Martineau <martineau@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Geliang Tang
	<geliang.tang@suse.com>
Subject: Re: [PATCH net-next 1/4] mptcp: export local_address
Message-ID: <ZIMMMkT4teqPtKBm@lincoln>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
 <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-1-b301717c9ff5@tessares.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-1-b301717c9ff5@tessares.net>
X-ClientProxiedBy: FR2P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::18) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|MW4PR11MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b834cf-02cc-4a1d-8c30-08db68dcaf74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3mg+UsLN90+AKBdveC/ApKfPPC9MKPUXwa92VwkDDjASQMEyfFYOaBXFHMMSFZo1vZRUOVbVh6U+fK1oCBzrvqJOiWE5HhsIT2HBX8I3wl8DWxs3OiLCo9fotFUOUTU0D83xnaZ/LDgpEvedC1WbNBFJOt2a/+zyWF/Zw2C7CRbEgXRkIRJiu0h4cORx/NCqRo30x/c05mkfFzaoC7yf0wo6DmXUVPe06oASbUGNhB76GUDHHAWhfAN/IgKB7WO2Ym/xP3lYLRL1SEDzwsuCnaBD/UYggg7+Q0ZsqQjXpwe0OSNPzHLKyqMUH9i/tJVYbKSQZoYqBU1Cbyami9u4V7bD9cRi2FwGt44Cn/ogOB7F5ryxAq7/o8a1iti0JCvzqH0WiTFqXyvXrzhKEVum9W5H6TfGcv+85pQuXubU9Ifk5YBLJWVy/TnYAHwFnYscZFGowAuEwi3Z87PYYJfzUN8gZpozoGlGCy63hUFX8nXYGAddeGTDbGAwZ3FI7e9YG+gOIGmqYUWIr0Q4eDnAC0jXnqDCi1ot/X3X8QoKOlwgFquteNze45PmCyNIscW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199021)(54906003)(478600001)(66476007)(6916009)(44832011)(8936002)(8676002)(66556008)(7416002)(2906002)(33716001)(5660300002)(86362001)(4326008)(66946007)(82960400001)(316002)(38100700002)(6506007)(41300700001)(9686003)(6512007)(26005)(186003)(83380400001)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?26oZKTwB2djb7EDu3KxN425xONk1YEYCqwVQ5xS8g/KTsxve7sZhs29QKb7Z?=
 =?us-ascii?Q?Ml1Goleurers0A8eA7gPCPjbmS2h0CqnX7mmEx3pmqv/dTPWh1kZ1OpG6qKe?=
 =?us-ascii?Q?fkldTlfSeUg430tJPw1MzV7SAPN8fKsr3KAJTQY/PrH1C2LW96cDflowgdPY?=
 =?us-ascii?Q?9ejurAhlb4Ph7jdAE0t0BKaDPhEjZfjIMICVCtlZpkFU2R6EuCp2hxFy5/sV?=
 =?us-ascii?Q?LCzWIq4ekE0oSOvJgA/Qx7/WVWfz4rUNqksWGuLaQ8d5XQVfwXWaPIMtgt1V?=
 =?us-ascii?Q?rmZzF/wv9UCutFh7ByaSdpPa29wctvppZJyTGeMyy0TQzs9XkU3y+XWiixLQ?=
 =?us-ascii?Q?mkXe/z+xV5iy+fGqWc28Zr1XC28qF+UdTOrMFauCj8l2fUgjesCCMccL7Zp5?=
 =?us-ascii?Q?tUWP70yk+0Qnbb2H1GthxnggetJGeK+Tt85fm4ok2Pdz4GDjIcimM/PLYq1o?=
 =?us-ascii?Q?aeF9lyft4eBRy4GwStLbDsaLkHdlSjLq5ONm8R6JHPa/RWaI5pCO4Rm3qlue?=
 =?us-ascii?Q?Co7vW3s9JmmCxan7fijZdN/Z/ChEMwNIuSNq2MxGGOVp8e0s8TwEx9JU8IV1?=
 =?us-ascii?Q?j25gFMNeUjXpiIU3/PwiUP6LjdWACEG2epBnxCuCS/NEIqrOjqsOIlMuazg/?=
 =?us-ascii?Q?vOFt8qxdSx3un/43oegCSgBL1QRGn27cdpAeRlGmvkSjJSCPMmp5lf1TL52h?=
 =?us-ascii?Q?jQqqbCGrFuM7Ttd70IIIIiZ9EumQrrlkCHmJxr6pfvzYa5qIQui14XV6xIIC?=
 =?us-ascii?Q?FyFeY4fDAn9y87KNzXGKh12WGIUfCEYaR615Q5GVSyAUGbCx9OsS7XVxyLB4?=
 =?us-ascii?Q?f1htj7iYnHNBWxMSfXXvaMcDVmGW/Srb0aFDl8Kw8vqxAN+Qu96Ee52cdAhz?=
 =?us-ascii?Q?OO3+8goJPtuLo1lUUdgVoGxY9NrT/OOYlQyFHocsjPirZ9xCg5fKE78t9sPP?=
 =?us-ascii?Q?OojppoxyDqQowXFNH40CIE+fQJPlr510saCwL23TZDVhtoXsc+40YNmOD2F4?=
 =?us-ascii?Q?IXVqctEylVjAoo1cmMzzeDbl4hfRAB/EAnwTPqrsMJwBkaiExoQvPE9PMshu?=
 =?us-ascii?Q?QNGCg51whp3fSRbDwzg0uNpYewiDaikJDkZBOuhQuR30eUVwhRcGnsjGdhAI?=
 =?us-ascii?Q?fwTarWI5om+nsjRi7WHadh+xYFi69t5fopBFw9RkFo7MGKkBY5p4cZlqdFh8?=
 =?us-ascii?Q?SEi/s0+sg/wOQi5C5MsgW17ViATwfaaHNZIAPGsKQrEwWf/2aUPgQSuZQ1MA?=
 =?us-ascii?Q?nzwILb/qCc07VtuD8aYHQ7sIVfh147H+H2/p0Jq/VopP0bHJGf4nRpLNIGN5?=
 =?us-ascii?Q?THKL5Z3Ut4SL2ONXUsgf15em54wTqRh9MEWKB+xjp0bz7b3mYVsqiyXSYcF6?=
 =?us-ascii?Q?VJNHzvbiDkG5cYBt6kHkVoOPmQCo/Ddm99yCHp8WSG/xf80DLC+dhNkxnaeF?=
 =?us-ascii?Q?voVZi/MCQHg43IE1ZubtRJG7/+ciZfunJ6SPBsKlOMiU/Tsl0W6yUVZ0kEg5?=
 =?us-ascii?Q?fVMEdnWzxenejIWP67dKa9lKWwcsgXlxMl7SETJJhDyazKmUOWyzY8mD+EFl?=
 =?us-ascii?Q?Oj+NcGvz6wos0jjVQwX5A1By1s22fEuxlukUW24uBqTDZzDTvz4L11A72Wbr?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b834cf-02cc-4a1d-8c30-08db68dcaf74
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 11:28:45.1962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ov7HXzkJaDCsHw2E9QrwZfZSCBc4El6qU1HjWBZZzPcAexDgvDPg4P4u2RQAHBUo85mbQpPKfK4BldTKmxCSBIeFU1NFoGM8Zh3Wq08blnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5909
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:20:49PM +0200, Matthieu Baerts wrote:
> From: Geliang Tang <geliang.tang@suse.com>
> 
> Rename local_address() with "mptcp_" prefix and export it in protocol.h.
> 
> This function will be re-used in the common PM code (pm.c) in the
> following commit.
> 
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>


Checkpatch on patchwork complains about line length exceeding 80 columns.
But from what I see, changed files do not comply anyway.

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
>  net/mptcp/pm_netlink.c | 17 ++++++++---------
>  net/mptcp/protocol.h   |  1 +
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index bc343dab5e3f..c55ed3dda0d8 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -86,8 +86,7 @@ bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
>  	return a->port == b->port;
>  }
>  
> -static void local_address(const struct sock_common *skc,
> -			  struct mptcp_addr_info *addr)
> +void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr)
>  {
>  	addr->family = skc->skc_family;
>  	addr->port = htons(skc->skc_num);
> @@ -122,7 +121,7 @@ static bool lookup_subflow_by_saddr(const struct list_head *list,
>  	list_for_each_entry(subflow, list, node) {
>  		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
>  
> -		local_address(skc, &cur);
> +		mptcp_local_address(skc, &cur);
>  		if (mptcp_addresses_equal(&cur, saddr, saddr->port))
>  			return true;
>  	}
> @@ -263,7 +262,7 @@ bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk)
>  	struct mptcp_addr_info saddr;
>  	bool ret = false;
>  
> -	local_address((struct sock_common *)sk, &saddr);
> +	mptcp_local_address((struct sock_common *)sk, &saddr);
>  
>  	spin_lock_bh(&msk->pm.lock);
>  	list_for_each_entry(entry, &msk->pm.anno_list, list) {
> @@ -541,7 +540,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
>  		struct mptcp_addr_info mpc_addr;
>  		bool backup = false;
>  
> -		local_address((struct sock_common *)msk->first, &mpc_addr);
> +		mptcp_local_address((struct sock_common *)msk->first, &mpc_addr);
>  		rcu_read_lock();
>  		entry = __lookup_addr(pernet, &mpc_addr, false);
>  		if (entry) {
> @@ -752,7 +751,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
>  		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
>  		struct mptcp_addr_info local, remote;
>  
> -		local_address((struct sock_common *)ssk, &local);
> +		mptcp_local_address((struct sock_common *)ssk, &local);
>  		if (!mptcp_addresses_equal(&local, addr, addr->port))
>  			continue;
>  
> @@ -1070,8 +1069,8 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
>  	/* The 0 ID mapping is defined by the first subflow, copied into the msk
>  	 * addr
>  	 */
> -	local_address((struct sock_common *)msk, &msk_local);
> -	local_address((struct sock_common *)skc, &skc_local);
> +	mptcp_local_address((struct sock_common *)msk, &msk_local);
> +	mptcp_local_address((struct sock_common *)skc, &skc_local);
>  	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
>  		return 0;
>  
> @@ -1491,7 +1490,7 @@ static int mptcp_nl_remove_id_zero_address(struct net *net,
>  		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
>  			goto next;
>  
> -		local_address((struct sock_common *)msk, &msk_local);
> +		mptcp_local_address((struct sock_common *)msk, &msk_local);
>  		if (!mptcp_addresses_equal(&msk_local, addr, addr->port))
>  			goto next;
>  
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index c5255258bfb3..6e6cffc04ced 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -638,6 +638,7 @@ void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
>  
>  bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
>  			   const struct mptcp_addr_info *b, bool use_port);
> +void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr);
>  
>  /* called with sk socket lock held */
>  int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
> 
> -- 
> 2.40.1
> 
> 


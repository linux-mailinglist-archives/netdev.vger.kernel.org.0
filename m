Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E458469AA8E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjBQLhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBQLhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:37:50 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F347E2117;
        Fri, 17 Feb 2023 03:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676633868; x=1708169868;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kHmVJ+OEkf2Jpbhjw+f9Lr6NQUu9JkCombLnUGVpNqs=;
  b=H+6rpH0cspRfLzwwB1grAU2bo2PLkyZOeQ5depCd5F/zj909Ou/3jWsR
   GeWbBcjRdIWf6aNK+QVmgJMHQtHh4sbtVe5xozMUHMbIIFjCHmDbTrspu
   xrEGv3GP7MUX/L24VXCjs3q28v1l74lIZLCGy8mUR5GGDmCUelVnoTl78
   0JSdlDUxg1IhMtIJqwnjqMROsPerJhtFPe3941iKx0PlhlBgp/fwi90eM
   lYVWwfZ6p3KzaJhDq9VAwhl3nRhccBAGA5ROqlG6unEjylVFhoxxpde0N
   k1mw1RIRmZtVMzNO6XDWEWJoJEPoWdWRzjnv5Cq8OO0cG9q953qUOT1Jv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="396642582"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="396642582"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 03:37:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="620369105"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="620369105"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 17 Feb 2023 03:37:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 03:37:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 03:37:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 03:37:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixpOLH32BJVKrZMB/yvQdcvmJ/h3eMRkndutFpz7bkEovfymo+QH7T0T+I2Szcg16Gvk3DgJU/mOT0apfCa+Ifik/3NouAtCcFd49JeNYkQ8+QIabTwIWNwV4IjjqQGZTa0NSXmapenMGr8yjEIPHf880syzxEQvOYk9Gf6h6UJwp9n1XgiT1B+uj0kDgE7q7XrylBy5f7aOFX6kzzhgcShkwCyQ7zgAxXQDqT2RM+rgmWwxpuXZOY8lUarMwpjdIu1Qjp/cb2tVFGI27j6HKpf1gHtwYIqW5g3wZOGjDGS+iRezgNK96Y3s8RTET0hIHANNlcWx6BG6qoJxzrHEcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uojB0RSkiu6fzeTubxb8xgfgdbxNCvxSiJuQt8raIFk=;
 b=UsvN3hjALutQXaK0uHdKCH9kuyFMaM9hvF10Iu89duhz2o8mmSDI/la7fimKRFXHnEBOqJOgVEti2ybk9HYUAdpBPSR0wXXULxVMGtatOOfQGxjCdYUWKKRwlk0paTD7nVafPaqnje1K8nEqMZ4ciJNFKXxzj9MwCTIHYtN5z0xb3I8tyP8THM7GibnVZVwJFt0DsXueWQaR+TzyoerUGQyCIvq0ArSJf3iGuP3LGsDZZ4XhgAKMu9znBlSjHWExmgSPZ07aJjENmSv7JW3SG0dMwhXWpgAPes+TpiwF2qPvqOETgnDK4VxBArL/3w/DW8St3ThdpRyLAxRXSAQBBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by PH8PR11MB6973.namprd11.prod.outlook.com (2603:10b6:510:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Fri, 17 Feb
 2023 11:37:46 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 11:37:46 +0000
Date:   Fri, 17 Feb 2023 12:19:16 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        "Matthieu Baerts" <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next] selftests/bpf: run mptcp in a dedicated netns
Message-ID: <Y+9itBDl8itgA0e3@lincoln>
References: <20230217082607.3309391-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230217082607.3309391-1-liuhangbin@gmail.com>
X-ClientProxiedBy: FR3P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::9) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|PH8PR11MB6973:EE_
X-MS-Office365-Filtering-Correlation-Id: ce772f3e-4719-40dd-e3f0-08db10db63a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NR67laHgk2n8bm9vuwLNBYjg2iDPrazJhZqxO0p5tpr5zHdnCvQUKmiPWALO/wP0ScUfx6o0YGaZk+wyTQNc/yok4Qo1CaF1U5nqbBDSfkbzVSirwoT1q8OWOSFDNRsH671IUH/zj2aQGlPuuW9dglyDMoe46NImbM3H8ugeYaWQzjnYv1EnvFtY8gCCZeD1PfobKWx6Ntu1MJCVT+CLipLv+XKZ0EoacD3AmOblmj74vT3Abztb1SRnkwN3xfGeZuQmuUT/W+mg/owVFwsHDOP+rRX3cKJeBAnKJI2qs2nweDi7a0j2NyyLAMEZer3cMwUej0HMuN1IbOweKLokfcXG+UBwopa2+XYiNR9tyzBo/UFZNt/i9a7ChJCgtr8rlNNGj8Ql0Svp8FZXuIDYzQSYG0QmUQL3dcG0ZqjSETqJa5pgy0ZCJwLZo5xAwPwMVU+hugVpLLzu6+YojCINxdf1v6rr+B5JMlpH7aJibQYoL8lCWMjq6qytpSJZPZimC5RrjRoqDElfw/KiIRbdXey4EYCg1Vdh+Us96YvwoAXvKefMqi2Vsis9R2rNEwbI6Xhf7Ro482hRyWCDz/XcjmUw0YO5/v3EEHLm8nsRZ029MZW3vi8C46o4AJAC8O0oY35SjodBwR3FBHcfFqZ9G8lwWlDrhYsdakNiDFZ1hy/d30dTHSjC4g7f3HfL+fP7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199018)(54906003)(83380400001)(6666004)(5660300002)(7416002)(316002)(2906002)(33716001)(6506007)(6486002)(41300700001)(8676002)(66476007)(66556008)(478600001)(86362001)(26005)(38100700002)(8936002)(6916009)(66946007)(4326008)(44832011)(82960400001)(9686003)(6512007)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HLAHBfassNUhaPBZ5lRYruBUzwSfpbOGFBk2CFRdpwY6pUsOSeywsdeYlYQ/?=
 =?us-ascii?Q?vSOsHai919KVeAiZZ0Bm96ghToFX/cT7QYJbewzWXYd4MOT5r4e6GUb5xilI?=
 =?us-ascii?Q?2RSHy3ig2FrRYZtKe9vxD30Dl4UtcPKnAM0g9IyPV6wl8bayJ65z+bgLv2xU?=
 =?us-ascii?Q?GJkuyY9rSBVZC1OclK3FB+hNhDUdOei84ys8oCztBHRyd2gxyGBBXg2nSHpn?=
 =?us-ascii?Q?5mL5ugHjIyfyX3C7R5I3gNI7kPO3oN9vRsU7Cwpl6kchzqZr+bb3yaWWqcyt?=
 =?us-ascii?Q?UXWYI5ccH0apVZw0bpcNgecKsrrQzvCAymPDBnIY3xfkZ7acSweFnz2USUXF?=
 =?us-ascii?Q?kaR7Xt+cWEyG5td50YunxQHcbKZqJLt87lwo/xw1oDa9vG4J4sjQrQ74dCIA?=
 =?us-ascii?Q?rUnGwYVgaMgGg4dDVi7pTh0ApsBRTwIeFPJMHs/sqAqzmhcWo3z+0jl2QNum?=
 =?us-ascii?Q?6q0KRng85MzDsqogtPM/L73tqkhQjyC3K+eeG5HsLKFykIyMZ0ExK9aGUoGX?=
 =?us-ascii?Q?DcjRBWrwGT/wOM4j4y8QPmmhdgGoLmR9Rkk2yn7ydz4tu9c/DTc5X/NtoeoV?=
 =?us-ascii?Q?Yo7OrKf1zbni2T+ejhzZsMGgSEurKsEJNeYuOqzQDi6OrzJANkKzh5g5c7cz?=
 =?us-ascii?Q?Jr2Mhvwgb6n4kdUFckte3iC1VQxUrEIoYmRf65z97x3Huyf/XELQdyV0tgJz?=
 =?us-ascii?Q?arLy8yd98nh/6rMtTeDv7NsEBi5fDsEE5nkeqm0R/Ud8cve82kgwr98jAD+9?=
 =?us-ascii?Q?nyTRlHNHj21ayP7EB2hAWmEk8kbYHryR3hp8e8AoGizO+P3Ns7w4XY4OUlpX?=
 =?us-ascii?Q?RqPW42yIltoe5SuExt9ywxVmZ6BsBANDpb12FvAv+6/25SkSzi/AMb6GeM6V?=
 =?us-ascii?Q?8+yyLXvD8XNRcVoL/Rz7weLuJ2PbWGTN4jBnzAKmOlDsnyXFl6ROtJop7Gst?=
 =?us-ascii?Q?emjq+pr/dDK7Ym4SyRkAaJPKmbqtdT3ZukRckpwP1aKv+fW7bTmyG1xNwU4V?=
 =?us-ascii?Q?rZTmtCbdfaKYE2h6AzrMizyEMGusseootykrcu/eUdxZQCzpyIRBggxsx+ym?=
 =?us-ascii?Q?dRxP97NgHkfFnWTSuLa2zIsrx8TAaNhaHX/aC4xT4flhSjBFuoEpmjN+vwkV?=
 =?us-ascii?Q?WvcVeRtWQrg68SNklOIHNQ+Yq3hgeimBzW+C5HTFhP1C4caFet78bA+eFmg2?=
 =?us-ascii?Q?dtikbAqXuzKUuF/1NE36jYj3UJhr7OjspETAxufeP7jW6+ZmNz2YcSBeX3CH?=
 =?us-ascii?Q?W9V2D2rFy02+jKPN1bARNTWijGArvu8UfUsZcG+tLvAW5g+o70RJ7GPdqANE?=
 =?us-ascii?Q?Qa3SB+sxNiuWsvwIWWAeP2zsV0M+XV/y2Br1FWGPfcBInIqafRNrazZ2io0x?=
 =?us-ascii?Q?bqTSAIeZLC+FEkV3Zee1d4P1yliAFp3iTuF6mJLpqOrdUbkMtdFWVP/c12Ws?=
 =?us-ascii?Q?fWYYPvdsXS2ny1PIZDgKrD72VfCNuGYqrqsw1A1Emg0m8dVCCxap1ijWwCgQ?=
 =?us-ascii?Q?g5cFKN4k39AFnGtuS+kzudDk5qvpLiEEjItHEWMPxw0Zm08HEy13T9BQXlV6?=
 =?us-ascii?Q?BzztQCcd46mSMrTk0GoqZIGT4LNQWYKjgpm/nlAZj0JRUfQWGwACx1uWVkZ7?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce772f3e-4719-40dd-e3f0-08db10db63a9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 11:37:46.0892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Nofa+xa/zlQqv2UNPNMlPLB3gnaLGYLeaksZSfJb88bTQjA+oP5MXHLqZ7qb56aD/aQeCzGZdBv0SFTcot2NnNt53gSRCCMoPKsP/6FC3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:26:07PM +0800, Hangbin Liu wrote:
> The current mptcp test is run in init netns. If the user or default
> system config disabled mptcp, the test will fail. Let's run the mptcp
> test in a dedicated netns to avoid none kernel default mptcp setting.
> 
> Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> index 59f08d6d1d53..8a4ed9510ec7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> @@ -7,6 +7,16 @@
>  #include "network_helpers.h"
>  #include "mptcp_sock.skel.h"
>  
> +#define SYS(fmt, ...)						\
> +	({							\
> +		char cmd[1024];					\
> +		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
> +		if (!ASSERT_OK(system(cmd), cmd))		\
> +			goto cmd_fail;				\
> +	})
> +
> +#define NS_TEST "mptcp_ns"
> +
>  #ifndef TCP_CA_NAME_MAX
>  #define TCP_CA_NAME_MAX	16
>  #endif
> @@ -138,12 +148,20 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
>  
>  static void test_base(void)
>  {
> +	struct nstoken *nstoken = NULL;
>  	int server_fd, cgroup_fd;
>  
>  	cgroup_fd = test__join_cgroup("/mptcp");
>  	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
>  		return;
>  
> +	SYS("ip netns add %s", NS_TEST);
> +	SYS("ip -net %s link set dev lo up", NS_TEST);
> +
> +	nstoken = open_netns(NS_TEST);
> +	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
> +		goto cmd_fail;
> +
>  	/* without MPTCP */
>  	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
>  	if (!ASSERT_GE(server_fd, 0, "start_server"))
> @@ -163,6 +181,12 @@ static void test_base(void)
>  
>  	close(server_fd);
>  
> +cmd_fail:
> +	if (nstoken)
> +		close_netns(nstoken);
> +
> +	system("ip netns del " NS_TEST " >& /dev/null");
> +
>  close_cgroup_fd:
>  	close(cgroup_fd);
>  }
> -- 
> 2.38.1
> 

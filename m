Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7993F5296A2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiEQBSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiEQBSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:18:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6131FCEF;
        Mon, 16 May 2022 18:18:52 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIX0Mo015942;
        Mon, 16 May 2022 18:18:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=VJEXOzHt8QEUlBw+FzKrXRB9N7pcMS+kC3fW1P8xC/8=;
 b=OqDFqEwCykW51T2tk0BhnBn11N04WzZaM6iu7ozer9+ftvpZMKL0ufYN1s590InXptFc
 xrdGbW2DEeAI1o2ltiCDMpAmWVlca4L9r9x/Uq2I/p/BJA8/KNuSWXWzW6Ba1OncMOWG
 3RT/cNs6CRkvQpfLenvDMdgjPKbz+3W9SPA= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g28fke86h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:18:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC0qHYbbpHlPKAXGFRjsum90ODCB6D66XpXBNZwUKW/0NR7uU9G295tVssGjeuFXWlOmLD39DDKDBxFVEzJi2BU75Pj0kiahQRlzUh3+f3JAzehdZPivE2mp8lK9VAq/gPOI1kC0E8NPUbTSuUjL+S/9d41hzSAhtbDUDiRUvCor8iwV6wUGhbpP64mwy9k8thMivtAbUFuDSceIafMjIbnLUp0z1qHbABWaWBDjBRfF/6bZVc0SfrrqtiiZJ4LKg1ED39DJHVa+9ipEiERtvX8sS2rPuTsP3B6FY/ht1/JiNVPtCOvdJpjTn8l0TN2lVotB+8VQsbtxMZlR6JsPaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJEXOzHt8QEUlBw+FzKrXRB9N7pcMS+kC3fW1P8xC/8=;
 b=OQC19WEjWEq3/DzK3jcDKWsfrhN7ImqslhMKX+Ubz61H/3Gz3W6YGUhONCgR2zpYux0zHW9Uo+22yMGHBaU5+wF4oFEni/BFSTTO35duYhn/KmKQkyj0n8bmgOCGwfOpAkSofC3i2r68NqoRG8YKLXZb8XDMDZcLxnBwlek8biKNDPm6zb3l103IRXOtRMHz0HyEeNL5WTNfB0I+KB0Ir4i81a5RDsxiCHX26TTGzRkO8UlDVoLaNQTmfKId2CzCATaLKLQu5aSNjMX9dJHjX4z5JQj6pjW+aR55aq1aD0cR2TpBlsCK96oLXEh8TPr5W/tdQY3LBq/eafpvrl3Dvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN8PR15MB2947.namprd15.prod.outlook.com (2603:10b6:408:87::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 01:18:29 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:18:29 +0000
Date:   Mon, 16 May 2022 18:18:27 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
Subject: Re: [PATCH bpf-next v4 3/7] selftests/bpf: add MPTCP test base
Message-ID: <20220517011827.6pk2ao23tb4xjuap@kafai-mbp.dhcp.thefacebook.com>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-4-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513224827.662254-4-mathew.j.martineau@linux.intel.com>
X-ClientProxiedBy: BYAPR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abc85612-7085-44e2-3cf4-08da37a32697
X-MS-TrafficTypeDiagnostic: BN8PR15MB2947:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2947FAE397F675F1E08E9B0DD5CE9@BN8PR15MB2947.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGMxMgTUJKw8vcJGI3a/rPL5sb4+Wd2w0uBZG50avLB2RDtreuOksUp1r4cgci8NLfvAJkxV49oo9fYWuh74EJFEL/ZmO0jb2vFwdlgDXoJA8vkvMBYCNMxEq5vRCiu1fPs/WXK03iZu9PytWlB4vSVwGiqp6GNIkyK0Njd8q21S4pHDU9j3xojZUYPeSHPvfgjPqpX7xBAkPOaKiprNcJJaB7o2TiB4pvolAhWOWRHZnEPFnJqs/ah9XF0tgfQ6NzEqJsgacPy2hrJsy8/pZzubiE+AARmT3taI2NuB+Xyl1ox5Z37BIyuQhgsB/MEyMpzvrMKitYYbhemsFAW+JDpdnxQ5XVCghFzEHZ0X9ztZfcAbI6WOOJnrE7sCGPtkg4k19kOiwGbDVoY9iBHbTfFvcuUyNSY1c5U9BcM6SnLGtWKANPog2Ewa6zV2rhEvG5mAtKNCL4nvn4E65Ugb8QFG+9MkuRgVz5n9TPgJiUA7SuAj6WTBFM3p+EOO3ggZX0q+xaQhdLfXHm9hSWVW3mIfoLud/X6WV1o6tX3Ta4LEjnCpmdkKkywaaJxvlgmC8VqSbyYUjSe/dD9E80TRLq3UmOl7ZAIul7O3dCtVqXrpF+DEV8pT4AEtzOGkihH30bV8SIEG93/xDf98a8oZgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(52116002)(2906002)(7416002)(6512007)(9686003)(8676002)(1076003)(6486002)(8936002)(508600001)(316002)(66476007)(6916009)(83380400001)(4326008)(66556008)(86362001)(66946007)(54906003)(6506007)(38100700002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mmYrkYoJ13G3nwSh2Qa3Fjyej9Qr5tKbnCWNFMe8ENQ0lJSioXmuRXG8cgXw?=
 =?us-ascii?Q?UJMcEppWI6rSJxW4GasVxFIGZFQYpIH5ddp+pQPTmt0/RZhA44el4fF8gMXv?=
 =?us-ascii?Q?91SBdnFraEkbSZWX1VPN048NYdnLEgSO9max7p6+vSNie1kjbtXpQjWN/uDv?=
 =?us-ascii?Q?keBPIW3XpsDhtJ63bA5hFHxK6ogEelB/z6OCuxOoqqrPVjc/uadwIU7Jobx6?=
 =?us-ascii?Q?C0nJqWsYILOudKAZg4hp0/t0LvEaRYW7Bi+GvqxKtb9LDs+uZeZ6D7hxzIYx?=
 =?us-ascii?Q?hXEaWWQB6JIPgQ0fj67BMpr/u3dOAnUgcbFl3YO6Ks0y58Imm+nxGl8bcvap?=
 =?us-ascii?Q?R2i3umSRPzgOgUjEvlK3TBFxZDZnsv2xioXZdGbfLbuy6qbtwSu7QdAXTyhg?=
 =?us-ascii?Q?bpHY2rAgwObdeHXzjDuKN5sO36ErvvSO99qTLnV568xaEdtnM0fZvZouuHcV?=
 =?us-ascii?Q?ktF8auibllD1ZrJB/6mlvNCrbiQCmUIX4yJG9fdO5JK/ewL7mt/GZR387ddq?=
 =?us-ascii?Q?pJ5dSk2YKXekzGN2xUMBWwnu4yeoWnuhtPUiI7OlGR8o9ioaTmzmOINVlNEa?=
 =?us-ascii?Q?mDcGbYEdFx+eUGy1l5uVGjXx6ib87w76dUVxmwY2dr5oMbMLpRV5MSYodDU1?=
 =?us-ascii?Q?XzfmqlrjZqvLhyF1jpWdrQIS4JzEMLIELP3nd+v2yitU5uTzDzAyzZWdIU3y?=
 =?us-ascii?Q?d3liZn7eZUffLOom5Mn5QbSIbTDYyEwEmd6MVSJXteIMeJxbHgKtxNUoTgxp?=
 =?us-ascii?Q?4OvMOnPmr7SsxZHcyGVTo0ujKxnv8oZaVTDvCnZE7JnjbF624ODOL2+Sm8wR?=
 =?us-ascii?Q?sGXofBACSop8em/V/rshjk1gRxFOCmPgSdXx179tQ0+XD8bEoz+3zE1TsZsa?=
 =?us-ascii?Q?owqpSQZmMZOJ0CP3CinDM8sc2ob2qQwWOGNyRTQ7g9LQflqsW+28rlUFblal?=
 =?us-ascii?Q?UYNOs84j/kAfPdurFOdiDjdt6/mYpuvjgFAVVFNgtzo8wzRWFl586XY9utp3?=
 =?us-ascii?Q?zW8i1wR9ys9IX+8wcGC8KDsYy5tWv2ZKjZaBY+iJygQ62xEVrsizJNsYqsej?=
 =?us-ascii?Q?oTy8Fzzy4/0CnJUlK4YFtU+lVWshK530vG+H9oig9Rbx29+vuNr0UHImjEg+?=
 =?us-ascii?Q?UGBJrQ0c2sUmUJSvxOk0qMIwxXRC1sBC5gDTa6J6RgBnRVpOfP21ZnvDSthZ?=
 =?us-ascii?Q?mwvVFjVbmD5hmOLa6G0sDUtXsn8C+q1VkWbmf/JC3bc+AfEHFWHgjvhN2D/j?=
 =?us-ascii?Q?0mrvged896dzPMS/Ke4YjkoDFOY6twGpDyoqB+hWP6cG8Ur7h8mz9cIWDt6B?=
 =?us-ascii?Q?MPk0mqOPd4B9vMB9BQdUUapXeLZnYs9sMZ1dSdmMYYrMqhMOLUopLKYlRr6y?=
 =?us-ascii?Q?pdTMHyYtPNkxc58XSTNc2yzMoypa+qZGY+nCGgZaQj6dFmBxPG0P/5LrDJ72?=
 =?us-ascii?Q?MdwryRmXDKj70Jp3mNSJsRcMSo9cMZIHlLam9E5DQDvEbvUer5HwDgTOHSY3?=
 =?us-ascii?Q?sDHS3/egplQSPqVb+ZVF0ax/PopZNDfwMOf/q3B1dBnKFKQcYzjayUd6b0Bw?=
 =?us-ascii?Q?9ehc/ck6s/j0LaGdg3TDDJwqfdnRSVjDtd3idixJhi2cLL4Y9vfCqVx3fn8O?=
 =?us-ascii?Q?/hNXtsBcjpaX1Naq2/fgJ6ERZDMuEWENWlAvJXANmEXrHw1UhPd9M2dEle3H?=
 =?us-ascii?Q?L5+N8uQ/kIQn3yF+b15EOMj7s+WjWlEOfkrKv8b1fHv3GdiKA3mWtagRGE4x?=
 =?us-ascii?Q?hFBZWhGXB41kZkgWTZpwQj+ZlnOb+jw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc85612-7085-44e2-3cf4-08da37a32697
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:18:29.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKQ/qSmu/TTx8YtBm6o1mJTrlAQKZpakyBBVXQ1HbpJyQes2Jqz9A1Pm3KcORsgv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2947
X-Proofpoint-ORIG-GUID: fdTFKne1M3jurPyLEtPRvoA0vfmS9Pse
X-Proofpoint-GUID: fdTFKne1M3jurPyLEtPRvoA0vfmS9Pse
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_16,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:48:23PM -0700, Mat Martineau wrote:
[ ... ]

> @@ -265,7 +282,7 @@ int connect_to_fd_opts(int server_fd, const struct network_helper_opts *opts)
>  	}
>  
>  	addr_in = (struct sockaddr_in *)&addr;
> -	fd = socket(addr_in->sin_family, type, 0);
> +	fd = socket(addr_in->sin_family, type, opts->protocol);
ops->protocol is the same as the server_fd's protocol ?

Can that be learned from getsockopt(server_fd, SOL_SOCKET, SO_PROTOCOL, ....) ?
Then the ops->protocol additions and related changes are not needed.

connect_to_fd_opts() has already obtained the SO_TYPE in similar way.

>  	if (fd < 0) {
>  		log_err("Failed to create client socket");
>  		return -1;
> @@ -298,6 +315,16 @@ int connect_to_fd(int server_fd, int timeout_ms)
>  	return connect_to_fd_opts(server_fd, &opts);
>  }
>  
> +int connect_to_mptcp_fd(int server_fd, int timeout_ms)
> +{
> +	struct network_helper_opts opts = {
> +		.timeout_ms = timeout_ms,
> +		.protocol = IPPROTO_MPTCP,
> +	};
> +
> +	return connect_to_fd_opts(server_fd, &opts);
> +}
> +
>  int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
>  {
>  	struct sockaddr_storage addr;
> diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
> index a4b3b2f9877b..e0feb115b2ae 100644
> --- a/tools/testing/selftests/bpf/network_helpers.h
> +++ b/tools/testing/selftests/bpf/network_helpers.h
> @@ -21,6 +21,7 @@ struct network_helper_opts {
>  	const char *cc;
>  	int timeout_ms;
>  	bool must_fail;
> +	int protocol;
>  };
>  
>  /* ipv4 test vector */
> @@ -42,11 +43,14 @@ extern struct ipv6_packet pkt_v6;
>  int settimeo(int fd, int timeout_ms);
>  int start_server(int family, int type, const char *addr, __u16 port,
>  		 int timeout_ms);
> +int start_mptcp_server(int family, const char *addr, __u16 port,
> +		       int timeout_ms);
>  int *start_reuseport_server(int family, int type, const char *addr_str,
>  			    __u16 port, int timeout_ms,
>  			    unsigned int nr_listens);
>  void free_fds(int *fds, unsigned int nr_close_fds);
>  int connect_to_fd(int server_fd, int timeout_ms);
> +int connect_to_mptcp_fd(int server_fd, int timeout_ms);
>  int connect_to_fd_opts(int server_fd, const struct network_helper_opts *opts);
>  int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
>  int fastopen_connect(int server_fd, const char *data, unsigned int data_len,

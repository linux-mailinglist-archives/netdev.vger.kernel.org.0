Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CF32A3993
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgKCB0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:26:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28390 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727281AbgKCB0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:26:20 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A31NTM7012713;
        Mon, 2 Nov 2020 17:26:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=A1OPb5dSXBVISAgqj1Dhb652TSeeC5BSRBGzgrs50ec=;
 b=dQ2v1dIOvKy35qowolImQmnxqnRWUizIvzDKeUYgImuu6REgqc9GEPsBsn3VCvSQ3bi1
 Ds5FXrD3NiWgtx9CLyLMYscFMogZMflBp3WfzD19cIkgn7XybjnUWd/zGhdHTiaxnU/b
 UiTXrZ4678FPkiIiKq/jK3QRvLXll19JXYg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34h5rfk6xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 17:26:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 17:26:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dh01VAAz0TUmX85wtsPIxjcd9VoEmcXHfVqULbLnja+Lk7/EzXXNox/uE/3My1b3VZgrzKTT9FjV1wW7n12HnOWF7GAFNOvnApeJJrhYeUDsMd8kYvT4a7d3SYXF94uVByCZYWOUlGRH1N9ELicqY5cvt9TgbghjEB1iOz1MzMdCKPwmfqJ7RLFX3yvLQMh6wZLfSTBENKJ7WIUu76wralf/BHa64rkNFcVHiisgihrq1fAKoHwJprkaBInN5rFdfeiFN1yW7F0rsVTBa19AfRHaYuEuBKzAofdJBwhyxUb3cGjn4pZrvWZSJLdzwdhh9xTGcH1Qi6DHwL5AT3ohiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1OPb5dSXBVISAgqj1Dhb652TSeeC5BSRBGzgrs50ec=;
 b=LX3r8phh3CXnG0q7exr+c9PmpDesF1Oa4YnvEhJkHdxleAbUFZmkmQ76XDDliGxQHhC3TuCjzopJSlKBIWJUJVmGSGn7QPOmNsGvOP5+nYmbQlFZgxEKCMy4gV0+/BWWYN3Maf15k3qgi5aaEefcz2aqpp6i3ExG7e+cqrMG2YHdvzU5LsGISe5bPx+rImOG+cJr862b76qlefBo7jryB6snSI5qDjbhZg/jrbK85eHnqhojtU29xdp5tl3LMiT2wl2M6Mv97Nxpp+pMFSfA0OJK/zqdhu8ryC02bEJ1Y5mAuwBwVURZ/DbSOAGnVOwBh/8pAsw05Y+r2uWA15Bt5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1OPb5dSXBVISAgqj1Dhb652TSeeC5BSRBGzgrs50ec=;
 b=DYSUZQ8fJwPP09B5l+xUj5aOKgDX62rI8cKOjJT6qhrUZtyIpW4KM6teCEFmRBcIrtDcO0YdEOUbdY6kXpr8eV0HzxqpV4gLVfvbE/4AKVLTV22f2/t57n1ntTHHnEZv2fk3jxVyu7eLDfcGpZe1dA+doNUQkYEEV3TSG7UN3WY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2374.namprd15.prod.outlook.com (2603:10b6:a02:8b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 01:25:59 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 01:25:59 +0000
Date:   Mon, 2 Nov 2020 17:25:52 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>, <brakmo@fb.com>,
        <andrii.nakryiko@gmail.com>, <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v2 5/5] selftest/bpf: Use global variables
 instead of maps for test_tcpbpf_kern
Message-ID: <20201103012552.twbqzgbhc35nushq@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417035730.2823.6697632421519908152.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160417035730.2823.6697632421519908152.stgit@localhost.localdomain>
X-Originating-IP: [2620:10d:c090:400::5:8aa6]
X-ClientProxiedBy: MWHPR14CA0036.namprd14.prod.outlook.com
 (2603:10b6:300:12b::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8aa6) by MWHPR14CA0036.namprd14.prod.outlook.com (2603:10b6:300:12b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 01:25:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 906573c8-bd7a-453b-3cf2-08d87f976b7b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2374A06D778ED767B2BCD073D5110@BYAPR15MB2374.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OI8cg6klUGnpBrXqbjvoiNA3pF9IPhdVOySvw/gd0QWxnMwRW5KFvhH5/auXObALqCoQ/6oVlxur+2JCSlU3v/u/HTdtH62CV8A82rGhUFVpbS2AwyRw+wvKuyxjlsiG50SkbvPPT3UFY9wTFfIiyAy5NIakFAnLJcEdyBPAhtBeY/nJkpSp0Ir/uNlPvbm4a82XkdcgrqD0Bgt/w+5Pr4PFSfle2t+jq1jU6bLPxOuHFw6TcswXgWtqIn1vxgEYUMd5hACKTUAUNbsSt8ibbnIYMnFAAsjcFlAHLDQBtc4Pp8W/vJu7mjASMDik8plv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(6666004)(8936002)(66556008)(66946007)(66476007)(86362001)(2906002)(316002)(16526019)(1076003)(186003)(478600001)(55016002)(7696005)(5660300002)(6916009)(4326008)(8676002)(83380400001)(52116002)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rJvtvBXtGQ47P3e0ERG+7quzwBlzpxu0Gk3gYaJ7vLGP6fkkLCoe7g0prRVpKJW6YdznxznOzQFDSWaqCociIOod6IbFXWP6A15JLhpjiLvgi3Tw1PShEN6EKG2kShTKuA4zR0Ls+U95WXbcj5P0rSiKPIhlVySvNjJfDtA9MhnNoEyedrWcLHBUc+F96+SpD2FdiAOlqwQd+FgHBEfbOR4NTWr+qMSpfooMB4LgWjMyX659fVdbOa8CG3g8qwrd6CL8crlYVTMKPzVMC9D/qFkD0QrGClsUxcxBkjVaQXDdTsdgFUDTn8yhIL5Z/rh94RRhKKbV3WDGMEMbkICZcfrnbC7qWOfrsn6prpsCsliPCUUYDFHHft7qV2CR8nV8kgrlP/6CQE9yBexCn7AyIia/xwiEmAHAly8mglSeeO5cfEneJ4xDs8QhJF0PJLqLTdWrkGQGPnTyiAO72PTIcC85WJfgEV2YQ9FRG15FyKPOirXK+IqpuawHeRIu2SQzouNGI7U0mForPf4E1tY2iy4TipKa7tqdQeeJ4knLekmns/boFFsWbQiAqKBeGX4exE2hTJFystVwafBt++dMSlRvaYHKoJjtn2aCYcgwKZsHxv2lagGM1+FNOUinlB0cTojQ3NrhNK1lxCoRx954QioNr9/bvLLO1b0WoaGNERCNM7pg7k8f9sk8/tRjcWMF
X-MS-Exchange-CrossTenant-Network-Message-Id: 906573c8-bd7a-453b-3cf2-08d87f976b7b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 01:25:59.4732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vql1+0af6kjk9+8P4IJ8YaizqzaY25xvuhmqLjBJceHvOJtDyVHDhFzOlR0mVyMO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2374
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=1 bulkscore=0
 spamscore=0 mlxlogscore=796 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011030006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:52:37AM -0700, Alexander Duyck wrote:
[ ... ]

> +struct tcpbpf_globals global = { 0 };
>  int _version SEC("version") = 1;
>  
>  SEC("sockops")
> @@ -105,29 +72,15 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>  
>  	op = (int) skops->op;
>  
> -	update_event_map(op);
> +	global.event_map |= (1 << op);
>  
>  	switch (op) {
>  	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
>  		/* Test failure to set largest cb flag (assumes not defined) */
> -		bad_call_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
> +		global.bad_cb_test_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
>  		/* Set callback */
> -		good_call_rv = bpf_sock_ops_cb_flags_set(skops,
> +		global.good_cb_test_rv = bpf_sock_ops_cb_flags_set(skops,
>  						 BPF_SOCK_OPS_STATE_CB_FLAG);
> -		/* Update results */
> -		{
> -			__u32 key = 0;
> -			struct tcpbpf_globals g, *gp;
> -
> -			gp = bpf_map_lookup_elem(&global_map, &key);
> -			if (!gp)
> -				break;
> -			g = *gp;
> -			g.bad_cb_test_rv = bad_call_rv;
> -			g.good_cb_test_rv = good_call_rv;
> -			bpf_map_update_elem(&global_map, &key, &g,
> -					    BPF_ANY);
> -		}
>  		break;
>  	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
>  		skops->sk_txhash = 0x12345f;
> @@ -143,10 +96,8 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>  
>  				thdr = (struct tcphdr *)(header + offset);
>  				v = thdr->syn;
> -				__u32 key = 1;
>  
> -				bpf_map_update_elem(&sockopt_results, &key, &v,
> -						    BPF_ANY);
> +				global.tcp_saved_syn = v;
>  			}
>  		}
>  		break;
> @@ -156,25 +107,16 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>  		break;
>  	case BPF_SOCK_OPS_STATE_CB:
>  		if (skops->args[1] == BPF_TCP_CLOSE) {
> -			__u32 key = 0;
> -			struct tcpbpf_globals g, *gp;
> -
> -			gp = bpf_map_lookup_elem(&global_map, &key);
> -			if (!gp)
> -				break;
> -			g = *gp;
>  			if (skops->args[0] == BPF_TCP_LISTEN) {
> -				g.num_listen++;
> +				global.num_listen++;
>  			} else {
> -				g.total_retrans = skops->total_retrans;
> -				g.data_segs_in = skops->data_segs_in;
> -				g.data_segs_out = skops->data_segs_out;
> -				g.bytes_received = skops->bytes_received;
> -				g.bytes_acked = skops->bytes_acked;
> +				global.total_retrans = skops->total_retrans;
> +				global.data_segs_in = skops->data_segs_in;
> +				global.data_segs_out = skops->data_segs_out;
> +				global.bytes_received = skops->bytes_received;
> +				global.bytes_acked = skops->bytes_acked;
>  			}
> -			g.num_close_events++;
> -			bpf_map_update_elem(&global_map, &key, &g,
> -					    BPF_ANY);
It is interesting that there is no race in the original "g.num_close_events++"
followed by the bpf_map_update_elem().  It seems quite fragile though.

> +			global.num_close_events++;
There is __sync_fetch_and_add().

not sure about the global.event_map though, may be use an individual
variable for each _CB.  Thoughts?

>  		}
>  		break;
>  	case BPF_SOCK_OPS_TCP_LISTEN_CB:
> @@ -182,9 +124,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>  		v = bpf_setsockopt(skops, IPPROTO_TCP, TCP_SAVE_SYN,
>  				   &save_syn, sizeof(save_syn));
>  		/* Update global map w/ result of setsock opt */
> -		__u32 key = 0;
> -
> -		bpf_map_update_elem(&sockopt_results, &key, &v, BPF_ANY);
> +		global.tcp_save_syn = v;
>  		break;
>  	default:
>  		rv = -1;
> diff --git a/tools/testing/selftests/bpf/test_tcpbpf.h b/tools/testing/selftests/bpf/test_tcpbpf.h
> index 6220b95cbd02..0ed33521cbbb 100644
> --- a/tools/testing/selftests/bpf/test_tcpbpf.h
> +++ b/tools/testing/selftests/bpf/test_tcpbpf.h
> @@ -14,5 +14,7 @@ struct tcpbpf_globals {
>  	__u64 bytes_acked;
>  	__u32 num_listen;
>  	__u32 num_close_events;
> +	__u32 tcp_save_syn;
> +	__u32 tcp_saved_syn;
>  };
>  #endif
> 
> 

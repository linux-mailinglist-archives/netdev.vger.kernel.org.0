Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59651875F3
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbgCPW5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:57:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732877AbgCPW5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 18:57:51 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GMswvt018592;
        Mon, 16 Mar 2020 15:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=L2ipR5bkHUxkWMztyrGtm3KI091Mq1x2hoaHGAGM+Wo=;
 b=M2Qln2urPix94Wx0Y/OAdnRIqsG6Vs2NPViOUUZjg1peV8mf38g4TpUYF/3cGnZ9uIdN
 MRx/VyYZ23UNeS9uxHwq2/z5RkSgho+PU1jdsEnfmT+JOHvJYK8QwYn90qVskbSVqzzz
 rQTcqo2eEHwDEwrMCE4qKFyu5nVHa4eD8/A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf9nybvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 15:57:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 15:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxjyYirT4Q5hws/NX1AAv23wcM38VHz1/JrPOZbACkkZbDggS6ZRS12Gd7IKxxfzZH4QGIi9ozO0rC2JfucAMom0gQutWpcWgn7pQo2nxg13XuUh2r2eR81NqCBonuky54+3tNxljepIJK3PPktLJbpsrLXxMOuVEBUm7AqD0Rtu/s2Oea3ZGKpKvDq0d8oxjDlomwJ8ANYO0QzGMW6t0zG5KBsEcu6tn8pXO2l21komzKHW1XVlVu7W+EUMDOmr97jytu5wiIMsJcX7Qxs1Wso2KWY+kCpJwtcJ8q/vHNNz8gMxgN0ETW9dkpdXb4OlWjOEhkZTmc9jVXJuyw/vJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2ipR5bkHUxkWMztyrGtm3KI091Mq1x2hoaHGAGM+Wo=;
 b=Q5L6BKdw4aYZk9FktTFDlfdgA/ReTk8Tnd4HbV5cJkkISTXImlT0i6j7WwR2ipV7mfjDX7dxGwLksCvS+hiVqLRRtYpzaNKf6AeMNhnEHPeVaqImDI9ztcwMIn3UIsK/yyXGKzNJIuNLWnGcJS0UTIVcGNYVT9BL8NpEmg+/8t2JAD9REcEx5lUmh0JLtXqt3++CmUtO7Y702pm9VMMoFHqfH3X5QjiSaNjJesti6+IYVOsBgB/pvp0rF2/A57SkErtTVyXJk4cENB9ye3MA2/DVpS1UnL+RcrhmN9u5is8REfOQc62JxXfQp4NDZz3DCaw8JRdiI5bId20qSjsDSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2ipR5bkHUxkWMztyrGtm3KI091Mq1x2hoaHGAGM+Wo=;
 b=lHRvbRa9+8pP6bJjE8XVUCb7n/sbg6AFgIrvSk+abQMXbuv/GftJtv5PSipulGehnJ58DSpnPgR42sYbVg8Vp93MIload87hInorT6vk+frZj6Rs6CwLRxuDEDBYsZFbE0aKsYd3g4wHyF6YQgIfl8+eUGwecobcTFKAxOpbewQ=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2408.namprd15.prod.outlook.com (2603:10b6:a02:85::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Mon, 16 Mar
 2020 22:57:33 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 22:57:33 +0000
Date:   Mon, 16 Mar 2020 15:57:29 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
Message-ID: <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-4-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312233648.1767-4-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:300:4b::33) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR02CA0023.namprd02.prod.outlook.com (2603:10b6:300:4b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Mon, 16 Mar 2020 22:57:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30775cb0-d6e5-4b9e-e1fa-08d7c9fd6924
X-MS-TrafficTypeDiagnostic: BYAPR15MB2408:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2408343D76675F429867DD29D5F90@BYAPR15MB2408.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(366004)(136003)(396003)(199004)(9686003)(1076003)(55016002)(16526019)(186003)(5660300002)(4326008)(86362001)(478600001)(33716001)(81166006)(52116002)(2906002)(6496006)(8676002)(316002)(81156014)(6916009)(66476007)(8936002)(66556008)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2408;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEmXkiyGU0PgUGKkKFkas5E65jFaG+bN/rRDL9YF56IIsVvWWk+iSu/sSPbHfNgRjwbSGk7QDXVnnU1lqRj2HW311/O6hfTreWraq9IpZ7JVzW22walMwzbcuF4Kmduatn8fdRnXt1yJk7DKjZ1I00Nuj4sZ8qj7vUo+16kNmMokOvscsBgY/yfofhbJHVdSk4N+SdlI1b723j5455AD/9eWEUhBI7cNbc2jDNo44TJu9qGHcmSIIWTtaQcf+cb0QLmR0bGas0vP984Ktg4ODRakANBXCCdoLW2tWvKkkiT+OEgU1NxoregsbNi+wVlDY/LC9xnB89k9OY4UpE4cA/f0CfDF0LSqjGF7TrDmDoDBv/16PVMGLuEpccrL9YT6bOXQZd0u8yVb9h/t+t/0ey5pd3hkRl84eSKtyb2f0f5UOvoKKN4MFkd1AmukGhRp
X-MS-Exchange-AntiSpam-MessageData: NIv0yPlwFvy27poG6AyhCckguMJj1t6kBiKYDG6Kp2xZw77dnkXZW6sZkNG9alrzr3gG5Hawi3k8uVrIW5WRFXRRa33rC+y4UGpO7WxgI1SZpeTu+6QrqKelNliLmZ2yo9eOcMKMEe1wJ3p+qNVsKZtCV136xaRlRSi4hdDSi3kY7RZ+jdQovRn2wX2BQbUK
X-MS-Exchange-CrossTenant-Network-Message-Id: 30775cb0-d6e5-4b9e-e1fa-08d7c9fd6924
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 22:57:32.9585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBJPQy0NUjq8pFBcLJEmuJx029vlXkJShySPUP8z/S/VycIFVo+5giEgR7nXnm0b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_10:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1011 phishscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160094
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> 
> This helper requires the BPF program to discover the socket via a call
> to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> helper takes its own reference to the socket in addition to any existing
> reference that may or may not currently be obtained for the duration of
> BPF processing. For the destination socket to receive the traffic, the
> traffic must be routed towards that socket via local route, the socket
I also missed where is the local route check in the patch.
Is it implied by a sk can be found in bpf_sk*_lookup_*()?

> must have the transparent option enabled out-of-band, and the socket
> must not be closing. If all of these conditions hold, the socket will be
> assigned to the skb to allow delivery to the socket.
> 
> The recently introduced dst_sk_prefetch is used to communicate from the
> TC layer to the IP receive layer that the socket should be retained
> across the receive. The dst_sk_prefetch destination wraps any existing
> destination (if available) and stores it temporarily in a per-cpu var.
> 
> To ensure that no dst references held by the skb prior to sk_assign()
> are lost, they are stored in the per-cpu variable associated with
> dst_sk_prefetch. When the BPF program invocation from the TC action
> completes, we check the return code against TC_ACT_OK and if any other
> return code is used, we restore the dst to avoid unintentionally leaking
> the reference held in the per-CPU variable. If the packet is cloned or
> dropped before reaching ip{,6}_rcv_core(), the original dst will also be
> restored from the per-cpu variable to avoid the leak; if the packet makes
> its way to the receive function for the protocol, then the destination
> (if any) will be restored to the packet at that point.
> 

[ ... ]

> diff --git a/net/core/filter.c b/net/core/filter.c
> index cd0a532db4e7..bae0874289d8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
>  	.arg5_type	= ARG_CONST_SIZE,
>  };
>  
> +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> +{
> +	if (flags != 0)
> +		return -EINVAL;
> +	if (!skb_at_tc_ingress(skb))
> +		return -EOPNOTSUPP;
> +	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> +		return -ENOENT;
> +
> +	skb_orphan(skb);
> +	skb->sk = sk;
sk is from the bpf_sk*_lookup_*() which does not consider
the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
However, the use-case is currently limited to sk inspection.

It now supports selecting a particular sk to receive traffic.
Any plan in supporting that?

> +	skb->destructor = sock_edemux;
> +	dst_sk_prefetch_store(skb);
> +
> +	return 0;
> +}
> +

[ ... ]

> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index aa438c6758a7..9bd4858d20fc 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -509,7 +509,10 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  	IPCB(skb)->iif = skb->skb_iif;
>  
>  	/* Must drop socket now because of tproxy. */
> -	skb_orphan(skb);
> +	if (skb_dst_is_sk_prefetch(skb))
> +		dst_sk_prefetch_fetch(skb);
> +	else
> +		skb_orphan(skb);
>  
>  	return skb;
>  
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index 7b089d0ac8cd..f7b42adca9d0 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>  	rcu_read_unlock();
>  
>  	/* Must drop socket now because of tproxy. */
> -	skb_orphan(skb);
> +	if (skb_dst_is_sk_prefetch(skb))
> +		dst_sk_prefetch_fetch(skb);
> +	else
> +		skb_orphan(skb);
If I understand it correctly, this new test is to skip
the skb_orphan() call for locally routed skb.
Others cases (forward?) still depend on skb_orphan() to be called here?

>  
>  	return skb;
>  err:
> diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
> index 46f47e58b3be..b4c557e6158d 100644
> --- a/net/sched/act_bpf.c
> +++ b/net/sched/act_bpf.c
> @@ -11,6 +11,7 @@
>  #include <linux/filter.h>
>  #include <linux/bpf.h>
>  
> +#include <net/dst_metadata.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -53,6 +54,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
>  		bpf_compute_data_pointers(skb);
>  		filter_res = BPF_PROG_RUN(filter, skb);
>  	}
> +	if (filter_res != TC_ACT_OK)
> +		dst_sk_prefetch_reset(skb);
>  	rcu_read_unlock();
>  
>  	/* A BPF program may overwrite the default action opcode.
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 40b2d9476268..546e9e1368ff 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -2914,6 +2914,21 @@ union bpf_attr {
>   *		of sizeof(struct perf_branch_entry).
>   *
>   *		**-ENOENT** if architecture does not support branch records.
> + *
> + * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
> + *	Description
> + *		Assign the *sk* to the *skb*.
> + *
> + *		This operation is only valid from TC ingress path.
> + *
> + *		The *flags* argument must be zero.
> + *	Return
> + *		0 on success, or a negative errno in case of failure.
> + *
> + *		* **-EINVAL**		Unsupported flags specified.
> + *		* **-EOPNOTSUPP**:	Unsupported operation, for example a
> + *					call from outside of TC ingress.
> + *		* **-ENOENT**		The socket cannot be assigned.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3035,7 +3050,8 @@ union bpf_attr {
>  	FN(tcp_send_ack),		\
>  	FN(send_signal_thread),		\
>  	FN(jiffies64),			\
> -	FN(read_branch_records),
> +	FN(read_branch_records),	\
> +	FN(sk_assign),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> -- 
> 2.20.1
> 

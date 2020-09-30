Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4536727E1A8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgI3Gsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:48:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgI3Gsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:48:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U6jYPl025960;
        Tue, 29 Sep 2020 23:48:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Gr24neuXGMKALLcpiqDfZVIlHq9QJbK9/cNJvAGErQo=;
 b=U18Cc4lSKnRR3UbixbilxQOJZgZTQFP44eOqDc4eGT7+J0YD7zCBjbhGWjPia/MrH63j
 XOeLBqNxmVCImITlj/Rl5FDuWzPqegKIRyd5F1eLWBBh0k6qImYX3dP+CkNnPeDwev6e
 SmHwngYMO6QDqXLBFVAmUbEv0KWSs83wREg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33tn4tq0d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 23:48:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 23:48:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8HhfdQZA/5LOd/s91XBIb/SeiLSMhwq/qCQ1eEJHqqp41vKZciyYF80dlEuFBIWZ9uLUqpac+Sy8XtxZ8/EyY2IPpG3a5W9hTiZlMWZmSYzGBDOaQyLuldxdviVY6JXPbR8coeZaNK2mjSSjs/L9U9AbS5cp+qjrVnDvKG+MttPh7a6t8364l//1/v90vE5BDbuxTVIxulwqpfCZe1rdzHFRwNFpVWPV6vYKOqDF7lvBQCsJklDJsIZsj1aIayiSem6LcZ+h9yUNjXoXiG69dMUMbkdFPAbqr76zWYZY2DxulYfiTpbtCIxEpKkqjwEMwk9PACn3kGMcrfd7sJ4vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gr24neuXGMKALLcpiqDfZVIlHq9QJbK9/cNJvAGErQo=;
 b=aXhZNsLA/OMSnMJ/SJUYRpAPQahlEXOTXqFFLAcRrpUMNJt+AuPPU0VdLZbI9dK/y3w9Ot49x7tAjDlhYjRma8PuqrWFvKRxyGkzlXa6NpwIN/MrLSnZlmKfqZ1MurFjCQmoMt5shueghURUSF8UENrbUQpxzyDHkCHCjdnQfW9dLnbqqAA+ISIJE81nnZ8mw6qevqezaJAgvw1ehsVr3LMGMzVZz2VkpmjrE0p/wiUcPXbOEtUWvu3CeQ9Jec82FzHGPUNlPL9PjAJgC4NSH7a74uFYos2ArMm7hJJ2KLeusWLaiiCPbQ6+LzPZMLVIBhXSmBryBufDI2323F1aAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gr24neuXGMKALLcpiqDfZVIlHq9QJbK9/cNJvAGErQo=;
 b=QArZofBi67CPBy/c2EbZGydwyBq6bkfaOB/YHf+52qcWJRB7Ilu8OmQzhua8sAGTvASQKt/04FTZgzCBmWddI9CYT8s2UyJTicnIB9Zp7quDEiePXNZ41n1M4Rb/ZDrT8YBoTU564uRsPAwoe7Hx0k+4DJtydUev8bt9SsSVnak=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3205.namprd15.prod.outlook.com (2603:10b6:a03:104::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 06:48:19 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 06:48:18 +0000
Date:   Tue, 29 Sep 2020 23:48:11 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH bpf-next v3 3/6] bpf: add redirect_neigh helper as
 redirect drop-in
Message-ID: <20200930064811.mroafbnrrnb77qki@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1601414174.git.daniel@iogearbox.net>
 <f46cce33255c0c00b8c64393a7a419253dd0b949.1601414174.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f46cce33255c0c00b8c64393a7a419253dd0b949.1601414174.git.daniel@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR22CA0031.namprd22.prod.outlook.com
 (2603:10b6:300:69::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR22CA0031.namprd22.prod.outlook.com (2603:10b6:300:69::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 30 Sep 2020 06:48:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47ff950e-80a4-4452-2c91-08d8650cd034
X-MS-TrafficTypeDiagnostic: BYAPR15MB3205:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3205E417C76A6EE8CE3957B0D5330@BYAPR15MB3205.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jY6mXtB4Oi0fClZoYHy5U2EuKJWLvUaEzQ6TzdvgpQrNRdsvuFdMNbKiW2xqr77kUTX53yv4CigtCIyzomqK/7lARPgx5eskUhTMksxPiVyCnYzZ7aK8n/fdMankgfkQ3ejyIChNPbM5pAVPj1GH6t+tZVel21wUfBG3sWO/rSELFLAm1BNSQjL8qm5pyDfDoYmZFJeHaR6ViSZMinBOLF3wXl4E+YZGdJWcSS5JM7qLklK+n8SlBili0R/rWalHwWx2uHZCqQ5D3vCfi6i7aq9VuUdJZNPlJGZle60nPsa71gQcGi9ybjedWJ59pT0xVo5pICc5gD19wQhS0dJlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(8676002)(4326008)(9686003)(2906002)(83380400001)(8936002)(55016002)(478600001)(86362001)(316002)(16526019)(186003)(6916009)(6666004)(52116002)(7696005)(5660300002)(6506007)(66556008)(66946007)(66476007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qDjHS1njnx8cvntgvz5Z3o9vwjcuSYjYPRGHhVXiZ5jjdY5rTNguWozGBaabuuvXnPDmBg4Z0+tkmx5w0l0Pv3Kcz8ICO1XMXhgT0zZcz14AfcgysxqYwtBuwe9ALC5xMxEJHGcGvsqL84L9qJhrweg9eJ2eFF/grsK762bSP5noQXAkCSNREgYI519QURO+WbAhcnXJWGrUismy941k/S36wuffAQOZGwSlgkAaCv0mm/52TILI1EYPyxy20r6rsqmEulZM6TOAu3/WXC/wtzLjG8jlIZy4DnBRGrFq3dZ9mBdZidzA4rQUhTARsRV/Id6MjNf39L1WnNj9qOB9y2IWxvEm1nB4pM8d25KoGrju4aAE2eKi/w0DuNxcfW7gMjFnN14rY/+yY6dmR85A0PJFma2R84aD1HM5hprvR9/bewM+xkREtRZ+oBF1MVbbo1/arOctsBM8vrQO4UK/880Z/k1yrv5RxKLTWN1B89UXqsaEs8PQdTcHRSnem+bhsbTKaUuqwZWK8HbOGIzwUTM0bnwl/dtemNXNGQ/mUyQDuoxyDEFfqm1t4WqJfzeQC+/yYaVMGkK2iezYKXLo6n09nSdP2hmOP71upAjUq2E23ONCF20g+pLSPtQI4Hd1+EcNbFjyxin6HQsJPUkTiRjo+k2zUWRKjxZ0RGH179I=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ff950e-80a4-4452-2c91-08d8650cd034
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 06:48:18.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHAUkuaSVkAp+k1Tk0HWR+CCh44sQX4NsmVDyiAkL64iBlcoEH5JfzBdmqWE2u+x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3205
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_03:2020-09-29,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 suspectscore=1 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300053
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 11:23:03PM +0200, Daniel Borkmann wrote:

[ ... ]

> ---
>  include/linux/skbuff.h         |   5 +
>  include/uapi/linux/bpf.h       |  14 ++
>  net/core/filter.c              | 273 +++++++++++++++++++++++++++++++--
>  tools/include/uapi/linux/bpf.h |  14 ++
>  4 files changed, 293 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 04a18e01b362..3d0cf3722bb4 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2548,6 +2548,11 @@ static inline int skb_mac_header_was_set(const struct sk_buff *skb)
>  	return skb->mac_header != (typeof(skb->mac_header))~0U;
>  }
>  
> +static inline void skb_unset_mac_header(struct sk_buff *skb)
> +{
> +	skb->mac_header = (typeof(skb->mac_header))~0U;
> +}
> +
>  static inline void skb_reset_mac_header(struct sk_buff *skb)
>  {
>  	skb->mac_header = skb->data - skb->head;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6116a7f54c8f..1f17c6752deb 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3652,6 +3652,19 @@ union bpf_attr {
>   * 		associated socket instead of the current process.
>   * 	Return
>   * 		The id is returned or 0 in case the id could not be retrieved.
> + *
> + * long bpf_redirect_neigh(u32 ifindex, u64 flags)
> + * 	Description
> + * 		Redirect the packet to another net device of index *ifindex*
> + * 		and fill in L2 addresses from neighboring subsystem. This helper
> + * 		is somewhat similar to **bpf_redirect**\ (), except that it
> + * 		fills in e.g. MAC addresses based on the L3 information from
> + * 		the packet. This helper is supported for IPv4 and IPv6 protocols.
> + * 		The *flags* argument is reserved and must be 0. The helper is
> + * 		currently only supported for tc BPF program types.
> + * 	Return
> + * 		The helper returns **TC_ACT_REDIRECT** on success or
> + * 		**TC_ACT_SHOT** on error.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3806,6 +3819,7 @@ union bpf_attr {
>  	FN(snprintf_btf),		\
>  	FN(seq_printf_btf),		\
>  	FN(skb_cgroup_classid),		\
> +	FN(redirect_neigh),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a0776e48dcc9..14b1534f6b46 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2163,6 +2163,222 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>  		return __bpf_redirect_no_mac(skb, dev, flags);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct net_device *dev = dst->dev;
> +	u32 hh_len = LL_RESERVED_SPACE(dev);
> +	const struct in6_addr *nexthop;
> +	struct neighbour *neigh;
> +
> +	if (dev_xmit_recursion())
> +		goto out_rec;
> +
> +	skb->dev = dev;
> +	skb->tstamp = 0;
> +
> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
> +		struct sk_buff *skb2;
> +
> +		skb2 = skb_realloc_headroom(skb, hh_len);
> +		if (!skb2) {
> +			kfree_skb(skb);
> +			return -ENOMEM;
> +		}
> +		if (skb->sk)
> +			skb_set_owner_w(skb2, skb->sk);
> +		consume_skb(skb);
> +		skb = skb2;
> +	}
> +
> +	rcu_read_lock_bh();
> +	nexthop = rt6_nexthop(container_of(dst, struct rt6_info, dst),
> +			      &ipv6_hdr(skb)->daddr);
> +	neigh = ip_neigh_gw6(dev, nexthop);
> +	if (likely(!IS_ERR(neigh))) {
> +		int ret;
> +
> +		sock_confirm_neigh(skb, neigh);
> +		dev_xmit_recursion_inc();
> +		ret = neigh_output(neigh, skb, false);
> +		dev_xmit_recursion_dec();
> +		rcu_read_unlock_bh();
> +		return ret;
> +	}
> +	rcu_read_unlock_bh();
> +	IP6_INC_STATS(dev_net(dst->dev),
> +		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
> +out_drop:
> +	kfree_skb(skb);
> +	return -EINVAL;
> +out_rec:
> +	net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
> +	goto out_drop;
nit. may be log this at the earlier "if (dev_xmit_recursion)" and
then directly goto out_drop.

> +}
> +

[ ... ]

> +/* Internal, non-exposed redirect flags. */
> +enum {
> +	BPF_F_NEIGH = (1ULL << 1),
> +};
It will be useful to ensure the future "flags" of BPF_FUNC_redirect
will not overlap with this.  May be a BUILD_BUG_ON?

Others LGTM.

Acked-by: Martin KaFai Lau <kafai@fb.com>


>  
>  int skb_do_redirect(struct sk_buff *skb)
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  	struct net_device *dev;
> +	u32 flags = ri->flags;
>  
>  	dev = dev_get_by_index_rcu(dev_net(skb->dev), ri->tgt_index);
>  	ri->tgt_index = 0;
> @@ -2231,7 +2440,22 @@ int skb_do_redirect(struct sk_buff *skb)
>  		return -EINVAL;
>  	}
>  
> -	return __bpf_redirect(skb, dev, ri->flags);
> +	return flags & BPF_F_NEIGH ?
> +	       __bpf_redirect_neigh(skb, dev) :
> +	       __bpf_redirect(skb, dev, flags);
> +}

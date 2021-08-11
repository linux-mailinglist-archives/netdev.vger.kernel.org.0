Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000093E9A5E
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhHKVXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:23:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229589AbhHKVX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:23:29 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BLAmtZ027482;
        Wed, 11 Aug 2021 14:23:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YNf2eO3QTZOmj0zYIDPFveC7rAkC9kuq2yQxzoO+qek=;
 b=qABRgjKpOPCJVClcSYUmJgPGrJ9yCS21Lp2pRhyrriPMEJqsCQC8kev8mmds/w+Xu+gC
 mleOs7NSo0yY8BfqPkSdi6jnu0h/Xn929p07+H8Tu2OchiGmLLw3SGy3i7DrpO7lSVzF
 gNiFRXJ7j/FDxN9ZraNEy0imyJ3kxEORHx0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aby7kg7n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 11 Aug 2021 14:23:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 14:23:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5xdsvVg5YDR9YpUNQdtSC75pMxtmjCmZcxpJtr6Z+muHvq43/Gzod1M1mnyYTzL83hNqlbhrzeTrHTFWCdx++IMcyegZC5YI+te7bAUEWlxKjyMocJSII310XVGLlGoDnt4QuJuFyTYitBfKaIxGnwDIKA6mM2PyQpba9RWAf23GiOaOsje2y6WVRXGUJGlR0DoEIUWIV4D8kcKGcM73B5HvJhd6Z2UV5dnaQotOcknB9TX3Ukksj9v8P+z3m9wSdnBydQdbfLCIYegjfEIcdpcLwVPXpaXQgisHPqw5OQDBawMFVs0ImKXADR7gwCO2OEMU9B35wd/dSmWjA4eYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNf2eO3QTZOmj0zYIDPFveC7rAkC9kuq2yQxzoO+qek=;
 b=IsJ6mTvzAQTbllUk932Knfo5XxnfrfgUtKgbxjqvc9CTBNf5blx6lJl594qcnCz+UT9lyfu2dtIxdCOhWV6V5hvRvdn5x8rEEkrdoVduxJPql3FWrcf2fr8jpmmgIbKNuRus7r/H53NHQPB1YzcHqKTD96QvFsdOZhtI0XAGqHQxLCBZUv71DdQD47ABp89OUtM03+pk5BVZ2Ai6CkxSt6rSH4ptHMdX36rfCrJMuCqd/eu0JFOhqSwflYPYyM/gKnkerl4KFI+oN566qDce3an0ZemZ/7A1ZPVcQHxEX5yNwZcMDt7EUQDY2jdVuTuaiBman39SHqfK6apSo+sG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB4013.namprd15.prod.outlook.com (2603:10b6:806:8b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 11 Aug
 2021 21:23:00 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f%4]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 21:23:00 +0000
Date:   Wed, 11 Aug 2021 14:22:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, <bpf@vger.kernel.org>
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint
 trace_ip_queue_xmit()
Message-ID: <20210811212257.l3mzdkcwmlbbxd6k@kafai-mbp>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210805185750.4522-3-xiyou.wangcong@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:a03:333::12) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ba88) by SJ0PR03CA0097.namprd03.prod.outlook.com (2603:10b6:a03:333::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Wed, 11 Aug 2021 21:23:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e2e467-c19b-41b4-9eb9-08d95d0e3238
X-MS-TrafficTypeDiagnostic: SA0PR15MB4013:
X-Microsoft-Antispam-PRVS: <SA0PR15MB4013D4118D71CF6C5433AA64D5F89@SA0PR15MB4013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Act1ic8BIMylRKUtyB8QveP6qHdSaPIP6D8VhYGledwVLb3UAyQzOxFrODZ0XnJNNQmfsjX6Ka1hb2ohetTNNrMOecp/P7wDauuTTBRH0O0s0nDRvg2xmCi3Dx8PNjEGUgpmOMlTCUlvub7wgkOM7kfaIrSsTt1hhFykr/iby2j+7C+Kmeqkxj+899E5U4zGqx3uU4LusJ+y6IV65iedVg3jWS4xFjlSmJswQo22YlxF1M9y1OTrD+iFWEjok6Xbf94Xd6jTIxy9vSaQc4J1HZOSZqd24PkG8//Z7jczO/gTSkjrWizKamp0GceWgmok/qKvUHa4OHbddKR9wkqBihwYDC8JQzh0AcOwasdxOjX8gVuI0IoAeVPeq5wunD3u7UPa/Ci4B05BgZWnDa64HdU17te8j7nWHZoVdOPELa7quCuc/RZVXE4q8eyaFmjNeEeMhgf3gWouTTRbzDNwHEtv5JXGz7pCPv7cCEIm/DINqkpVk17nZN1P5Pkk1a4nr/ni2MO/odgBwKbzuw9dRy+/cnaHYjzVldSTw2gYeio0s7cjT3W3VghKxfjF1ol8cYnIoXgMvwODDr/1qvDzkLFiBexKBat3rRwsJ9fkLdW+WnIq826PjkFDrDB54lb+t9a1FaOb7QAd3JmxTJWCWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(5660300002)(83380400001)(33716001)(2906002)(186003)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(9686003)(6916009)(52116002)(55016002)(8936002)(478600001)(6496006)(316002)(38100700002)(54906003)(6666004)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pl/NrP0uV2Dmxxt8cWSqvhTOKExAEVJ/aX1hfGQ1FDxAh5VeT/rYEGpSs7/1?=
 =?us-ascii?Q?jlr3wlnlrpVnH541l3v3CwsUE7K6a7ATRWrY0W8sDwvGrQ+O6pZiFX2tfbkm?=
 =?us-ascii?Q?VDn8dc01/b8v7nb8hZwKJh74HStR0YCTAmi1ZNl/XgNI/dM6qN1Du5xxrWY6?=
 =?us-ascii?Q?KMlj6O7Y78TQ+148a+d/rRPqWEj9SGdOItSy3Xw5RTjaC8s9mzjWahKNKqHo?=
 =?us-ascii?Q?myOwMInscQCHGgH1izZAEani/sIIWz1wuBEz20DLNVtqWVaTkTH75LFcNWRL?=
 =?us-ascii?Q?BzmiNTmA2Lm7JdkE6NgBK7rO6+cBatIH4JuAK+8IOIx0X8wStT1jHOXQE4NL?=
 =?us-ascii?Q?w7GyOIBrHT70UkeqqAQhAoEylJhxFMySbZLtdNH8iEj7WoJRN8d9LmGEbL1B?=
 =?us-ascii?Q?gi1poC/h7OVce3+oVMNRA+jHHy7Rt1kZTsgxUv870UB8oQHBsO0ZxO2jN5Y7?=
 =?us-ascii?Q?Sdnopo5nlI/7hWej74VoG4RC7vA5CMV+8j7/bD4mL+e5I8KParm3OiUE8yhd?=
 =?us-ascii?Q?yy8SmfFBHm4IeDyJAOtmLydRu2gI9dy8xA0M0wEM/CvDXUqZPejBuAi0mIP3?=
 =?us-ascii?Q?HSQmcbxlwbmMJBVP+KkA/Kdv9dvYWOMn2d1u01hrJ+q0HXOVw0V2tRneJhNc?=
 =?us-ascii?Q?qhYMFl5iJ1+oJkLLTsW4O6vObbKFZFT/KaHEVyFOBFCLBXWnl/OcPX4LV8Ic?=
 =?us-ascii?Q?ESxWLCqRIEmpI8YxJSenUxdjopicCOlpTzJLFeKtXzkwF7VBPe8pJCsEFc2x?=
 =?us-ascii?Q?4CDjCkRiNxbvTuB9WBTQMFmT89h1xL/q9wV1JW4kkax2wK7Q6ollPc6Ib3yf?=
 =?us-ascii?Q?28SSPPwXS/Y9wQaG3PY1eTUoole8mRnBs0BDQrqipEVJKmwIBChTLqrLoOoc?=
 =?us-ascii?Q?ncKIoCaywWiU8NwWBb0IVU7iBAtXcNCVj8ax4gU0/ukbnES79loKAG0XBsx/?=
 =?us-ascii?Q?iimosS6YtgY9o6QuxNvh9roS9m9zekacYfFu1bNJPUQ2O2Hb3KDig8B9OHcD?=
 =?us-ascii?Q?fbMJuTsBha5rCDm5RoawNejxpRI22Y/OLMfgORT+5NwGaMnOW5TnXZyLY8d7?=
 =?us-ascii?Q?3B0VbIBND/MCaXMReNKKfg86an/aRNuaR/SUPMpJAxs5YPXWGERLFYDuaY2G?=
 =?us-ascii?Q?NkC1oFru56czRTT+Eyk4sTt5i1gqFbB++gns6+SiDNrVhALchDFTvVfcOAkQ?=
 =?us-ascii?Q?ZFpl4/G/gwGyLQahtthWExm2cG+aJ6ibqiui9JFJlTBmJCGZUXfTSNEWlUx4?=
 =?us-ascii?Q?qWuy7HXUxMN/h0luUdfzmWCWkEyppeapqW6vKSvRBqwxxk8ZdaNDeepJYgMq?=
 =?us-ascii?Q?KVhgG+v+wpDuBvabT0bnR0/kguse2J5q7E+gt0Rlax1osQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e2e467-c19b-41b4-9eb9-08d95d0e3238
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 21:23:00.5113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miNAqmYqUyPutswUap4KbnuiplMJ5iN2vxvEYTM0WblBzcvHnBq2IRQQjXIGqsmJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4013
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: pxwEbYpUDmWr3EtKqwkED38Gah6pQjZO
X-Proofpoint-ORIG-GUID: pxwEbYpUDmWr3EtKqwkED38Gah6pQjZO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_07:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110145
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 11:57:39AM -0700, Cong Wang wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Tracepoint trace_ip_queue_xmit() is introduced to trace skb
> at the entrance of IP layer on TX side.
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
>  include/trace/events/ip.h | 42 +++++++++++++++++++++++++++++++++++++++
>  net/ipv4/ip_output.c      | 10 +++++++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
> index 008f821ebc50..553ae7276732 100644
> --- a/include/trace/events/ip.h
> +++ b/include/trace/events/ip.h
> @@ -41,6 +41,48 @@
>  	TP_STORE_V4MAPPED(__entry, saddr, daddr)
>  #endif
>  
> +TRACE_EVENT(ip_queue_xmit,
> +
> +	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
> +
> +	TP_ARGS(sk, skb),
> +
> +	TP_STRUCT__entry(
> +		__field(const void *, skbaddr)
> +		__field(const void *, skaddr)
> +		__field(__u16, sport)
> +		__field(__u16, dport)
> +		__array(__u8, saddr, 4)
> +		__array(__u8, daddr, 4)
> +		__array(__u8, saddr_v6, 16)
> +		__array(__u8, daddr_v6, 16)
> +	),
> +
> +	TP_fast_assign(
> +		struct inet_sock *inet = inet_sk(sk);
> +		__be32 *p32;
> +
> +		__entry->skbaddr = skb;
> +		__entry->skaddr = sk;
> +
> +		__entry->sport = ntohs(inet->inet_sport);
> +		__entry->dport = ntohs(inet->inet_dport);
> +
> +		p32 = (__be32 *) __entry->saddr;
> +		*p32 = inet->inet_saddr;
> +
> +		p32 = (__be32 *) __entry->daddr;
> +		*p32 =  inet->inet_daddr;
> +
> +		TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
> +			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
> +	),
> +
> +	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c skbaddr=%px",
> +		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
> +		  __entry->saddr_v6, __entry->daddr_v6, __entry->skbaddr)
> +);
> +
>  #endif /* _TRACE_IP_H */
>  
>  /* This part must be outside protection */
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 6b04a88466b2..dcf94059112e 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -82,6 +82,7 @@
>  #include <linux/netfilter_bridge.h>
>  #include <linux/netlink.h>
>  #include <linux/tcp.h>
> +#include <trace/events/ip.h>
>  
>  static int
>  ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
> @@ -536,7 +537,14 @@ EXPORT_SYMBOL(__ip_queue_xmit);
>  
>  int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
>  {
> -	return __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
> +	int ret;
> +
> +	ret = __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
> +	if (!ret)
> +		trace_ip_queue_xmit(sk, skb);
Instead of adding tracepoints, the bpf fexit prog can be used here and
the bpf prog will have the sk, skb, and ret available (example in fexit_test.c).
Some tracepoints in this set can also be done with bpf fentry/fexit.
Does bpf fentry/fexit work for your use case?

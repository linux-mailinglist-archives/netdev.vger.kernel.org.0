Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C9B4CB332
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 01:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiCCAVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiCCAVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:21:13 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B963139CFD;
        Wed,  2 Mar 2022 16:20:27 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMi0t029835;
        Wed, 2 Mar 2022 16:20:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NkkW/gubnVZZPPmbHGogBkXWV4OD3ZgoodckJcCo5sU=;
 b=ZKYDLVjHr1xtNQOABv5p81Fn++r5/aQXIpvNW4TnLycNvJEzdk/sbzt7i0OynkMUAyTi
 lbIQJqs1Q7rIjaaY+4vhv2wi4Ni4k+oMYfCsIYwtnNCtDKNdq0lC90bdhpsK98ZGzMdk
 KJFdKWXkXyHUKckoDsUkyWCXJf3rOfcyjsw= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ej1r0s5hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 16:20:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pt2i2WZ95J1CtDPnFle1dJXp+/CrQFIu3iaIrCP0alC/pi4gxEf4S8qcfyuDLuCuG4RA2ud6ghR1i96ViDmIByHyXZ5dm+ht9vntsA4Nl/dNCtZNhYgzOM0fy9u/SykoT1VHNwkVNnwGzoW8cdi4lAu4Wqe0a/EAqL82TZrul5/tudPItHEap+Mq+LkuSgN7C03rMtljBbmmdjf4KKDYUoETr2hXAnwObE0GcbhOhY2+Qd5FNolpoR5mInVyAg9AtsI3z7uhezcFM02s3a1NJL19Kc8qpsum6sjX4Ze/Lkg8pc85NNfkLSYg9mkvVFYRFF2oOCdrpalQxaO+GU4wEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkkW/gubnVZZPPmbHGogBkXWV4OD3ZgoodckJcCo5sU=;
 b=n3uVpqXxXgNo5pr1xO03Ln+K0w3KCDByv9ht2a0JzOwrhIScIZ6vHBuEvg6IZStJ+woTtv0dtEIqZ6gLKGMGvgHXYLiL30oCehFNTbbPpHAySSaoC0adElKInnvF6esjuSyo5BD22iX+PyE0KillpQwxdDcxLkKJ5+I7hDkBARkL7Yghbj523Wt1YORk8JCTEZNeNCAd2rQraFV7vSVbfbbqiTH8fPNTe2H8X7bGOiX1Z4t5b35rq8dRLLOL4SK6fxsptf6JMbn6B22BOQOU87bSF1LSkA/ZulVOIXHmXOKHDp+FI+IVb79nP6n1eI19hMV0yyfuOzBowE+xrGSKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW5PR15MB5146.namprd15.prod.outlook.com (2603:10b6:303:192::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 3 Mar
 2022 00:20:09 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 00:20:09 +0000
Date:   Wed, 2 Mar 2022 16:19:01 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v6 net-next 10/13] net: Postpone
 skb_clear_delivery_time() until knowing the skb is delivered locally
Message-ID: <20220303001901.nuq66ukomfqqkytg@kafai-mbp>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195622.3483941-1-kafai@fb.com>
 <CANn89iKN06bKxjrEeZAmcj0x4tYMwRv-YzdZLWKbCcuTYT+SpQ@mail.gmail.com>
 <20220302223352.txuhu4ielmlxldrg@kafai-mbp>
 <CANn89i+ZLB8EK2CUC7dnERvcawSAOhpzHpeKSvL0dVfK-fusXg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+ZLB8EK2CUC7dnERvcawSAOhpzHpeKSvL0dVfK-fusXg@mail.gmail.com>
X-ClientProxiedBy: MWHPR19CA0005.namprd19.prod.outlook.com
 (2603:10b6:300:d4::15) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f089476-45ad-4faa-e630-08d9fcab934c
X-MS-TrafficTypeDiagnostic: MW5PR15MB5146:EE_
X-Microsoft-Antispam-PRVS: <MW5PR15MB51469A9963A8ECD5817CED4ED5049@MW5PR15MB5146.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p26+wv68ga/f9qykot9JMmCCNw0/l7BZnOObtbXKmT1Iqfcnx/ve/tsRkuG4yoGMjNh+iN0AoEq1W6LxhZlrE8e6/EWGhP8Tjuin78bP7WVAMk0YquwT0XVAvi6MPd0eg2wsKIwl+Jne9/QAm2XzQVBGUTeFLPzWj0mttqCSRQLlwYGCD4Md+1l/jCusBFuZmbfuuitpVsXozurmHJmk6PFwgKyFCxSEyWWUz9klIERJQqkwV46QebcvW1Mu7HTPwD6NKuk01v5LMKKBzwpX7bcxdqn54V27PYa0Kk0TRkmJ4N+ZDXmb3CgZTu5lnWn9BvdpOyrbIYErpE07q1BpyhOgLStVZUjhXy8zr5uGyiwNNgbI/nSIJAYMQt1wnVmcTzW/dBmC8H9kd54gRwc+pTb0HyCuVdIyEy7M+Dt50zCd59nRDpyOVR4DbgGjkTJWAvoaYs2cFxB/ktalCTREwq8GZfinvGkkuRlCWKcShrnQhzIe+u2osILiL4KsnP7egVRTJ21fkYpqPofL9L8L233zNiqdCJHumHyebxLr/s+FaefBJfU9X41I1bPG2z2F0FnC2njr3Dr9UQD/htiGN9CwY1HfTV1BjpzWOPINbYsJmvALkPVop6GRLo61kL27IelCxli21sf+wUjxJ+gcIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(9686003)(6512007)(6916009)(86362001)(66946007)(8676002)(54906003)(33716001)(66476007)(316002)(66556008)(6486002)(6666004)(4326008)(508600001)(6506007)(2906002)(186003)(83380400001)(52116002)(8936002)(1076003)(53546011)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dg1qdRhWYlFgZvQfOeShAnok6HG+u01Yz3gzYviQ84eYfbGMpy8bLQ/p7UYd?=
 =?us-ascii?Q?rIDnGZwTD8Q45b7Grc1dDwiG5mprz1U090penBbygazuLeNhLdU15ewdSqfU?=
 =?us-ascii?Q?SbHrdJs15/oWOkkMmJ4JXH+fN3BiqHMsebi568+xagrakwsBDBk6zazO5iiK?=
 =?us-ascii?Q?nDPmcXwzFLDqPjN9huaK7KnUre8KaVnJGEvmarIKxse+Ux3/CF4o+KGf9vOb?=
 =?us-ascii?Q?fmshFSIXoCCZ80corrxG2q0dStlO4Evgx4rXCGkPtUtIsDZu/9jygQQp9bmO?=
 =?us-ascii?Q?r9Beu+3J5Ieb1y5iSUteuchcxzn5V/SiCWDU8Snh2JewAF958rXAUIN7gCxv?=
 =?us-ascii?Q?ioxYJDHTRYB2poG3jgyiPPZbsd+gWskNJu5/VbMQxVFAfYgj+7nso0DTWvYq?=
 =?us-ascii?Q?/b/f/azebKukhNhymzfqv3vc8Tknfe24qM8f/iphZf74GAcuMCvEDAC+X3+r?=
 =?us-ascii?Q?KLyjmnwN66g5lMDqKwssq3qqNFAagaOvuTvfdS0ttyIx76EnAoUend3QDkW9?=
 =?us-ascii?Q?9gwR5kjFxMfpAecV2z9WnmuVWzbH46RagghWZfceejD3hwPUJxWg4nbbkL6U?=
 =?us-ascii?Q?LxXN0ZN2NytD7Bj+iuPHLklnTEBlSFYwIAtOMr4Geu8WQXfA/Nx8Ui3wo3sa?=
 =?us-ascii?Q?dajOqOP5TPIEYsTm/xLgprwyYg4Xvd/+XfztxdqOXvFXXVV10Zjm2BP8U2y5?=
 =?us-ascii?Q?UHZXkVc15cZ/JD6Bh+ORvHE98AWJIm5PbYcOqwi9Fvsjdf0l4xvJeMBh+L12?=
 =?us-ascii?Q?DBt0CrORN7Qr6+saLeMiEy6p2m99lmtuh5egnqTCq5l4XSB137Clmx7E1+ZQ?=
 =?us-ascii?Q?tx+xJLMagdoygIhJhkyTvR1zS82bwSm/N6RkHMctoQDCiiGBYg72kQvX5wPc?=
 =?us-ascii?Q?DifA0Pu2336NQzdLX/j45lnOrvwSdzsp7A7OGHD0vHim22PYbqnGblJCcEoh?=
 =?us-ascii?Q?5lHYU1TT51soYiA6eZdgS+uiGvlafR7EXhwM/gfvZqTwjDU+/xfJQJ+aiDbH?=
 =?us-ascii?Q?U8T2af8LYONNeEr2OAGhQXD1+YT1BGl/EpbjBO2kNy/xwkWnNRcKKZSKe+Aw?=
 =?us-ascii?Q?vWpzwxFyy+K3IQ10dDcaNtc7lBq8n+fdduXIQBVuSQGfRH2xjqDYCbd3tADo?=
 =?us-ascii?Q?VUwdy+NFe+01ecXYU5+tWAZjBQ0z4ZAwNPHwGD0cSL7/5eCwFaiY4MqejjPY?=
 =?us-ascii?Q?Ej5RWIjpUZtbSbn8WsUK2dSLQwpOxULp0d2lK0UqP066NZP0Rxy74vZ5m6gT?=
 =?us-ascii?Q?lKfvE1owVqd3YVK2TCJ+XnZRJhrVzDVBCzjHw9Zcx9zhVs4R9pIl5NfHemFR?=
 =?us-ascii?Q?sfrzqEQ1yT9rKvUEHITAa6Vq5GwNrx7NX1RQaxszRPPsU9G+zkagMnzP0VGu?=
 =?us-ascii?Q?N7Cx1QIDqSJ+6jyAgeQaUk3J6LhqdlwDWYHuLz1zar0+zF7IyNxOoxV1VKiQ?=
 =?us-ascii?Q?OJXbnSU5+JjAcjK5OxZM+zUcLFVQ+vikNYhepmYTYweUbahwWMUdYnFiAdp/?=
 =?us-ascii?Q?ivQA9Ubq0XJnEurlMW42rCROZSX8xITN/Itq5FZYFtbdMA6/BKnsSAsuWsbk?=
 =?us-ascii?Q?9+rPByAI5vPZ6dpPXRitRsjNN6pHUDeUOaUWdLovo2UHIBRhapo3BjEbdoF7?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f089476-45ad-4faa-e630-08d9fcab934c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 00:20:09.1626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtaCi4Ky6iIy2M7DInHD3tK0Fx/5JrZq7YqCH1fKKsJpcfFoejCxFCUDBeBZF+7A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5146
X-Proofpoint-ORIG-GUID: wQV1ErFEV-MYzSds6V5A2QXD0mFoFyf8
X-Proofpoint-GUID: wQV1ErFEV-MYzSds6V5A2QXD0mFoFyf8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030000
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 03:41:59PM -0800, Eric Dumazet wrote:
> On Wed, Mar 2, 2022 at 2:34 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Mar 02, 2022 at 12:30:14PM -0800, Eric Dumazet wrote:
> > > On Wed, Mar 2, 2022 at 11:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > The previous patches handled the delivery_time in the ingress path
> > > > before the routing decision is made.  This patch can postpone clearing
> > > > delivery_time in a skb until knowing it is delivered locally and also
> > > > set the (rcv) timestamp if needed.  This patch moves the
> > > > skb_clear_delivery_time() from dev.c to ip_local_deliver_finish()
> > > > and ip6_input_finish().
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  net/core/dev.c       | 8 ++------
> > > >  net/ipv4/ip_input.c  | 1 +
> > > >  net/ipv6/ip6_input.c | 1 +
> > > >  3 files changed, 4 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 0fc02cf32476..3ff686cc8c84 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -5193,10 +5193,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> > > >                         goto out;
> > > >         }
> > > >
> > > > -       if (skb_skip_tc_classify(skb)) {
> > > > -               skb_clear_delivery_time(skb);
> > > > +       if (skb_skip_tc_classify(skb))
> > > >                 goto skip_classify;
> > > > -       }
> > > >
> > > >         if (pfmemalloc)
> > > >                 goto skip_taps;
> > > > @@ -5225,14 +5223,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> > > >                         goto another_round;
> > > >                 if (!skb)
> > > >                         goto out;
> > > > -               skb_clear_delivery_time(skb);
> > > >
> > > >                 nf_skip_egress(skb, false);
> > > >                 if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
> > > >                         goto out;
> > > > -       } else
> > > > +       }
> > > >  #endif
> > > > -               skb_clear_delivery_time(skb);
> > > >         skb_reset_redirect(skb);
> > > >  skip_classify:
> > > >         if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
> > > > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > > > index d94f9f7e60c3..95f7bb052784 100644
> > > > --- a/net/ipv4/ip_input.c
> > > > +++ b/net/ipv4/ip_input.c
> > > > @@ -226,6 +226,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
> > > >
> > > >  static int ip_local_deliver_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> > > >  {
> > > > +       skb_clear_delivery_time(skb);
> > > >         __skb_pull(skb, skb_network_header_len(skb));
> > > >
> > > >         rcu_read_lock();
> > > > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > > > index d4b1e2c5aa76..5b5ea35635f9 100644
> > > > --- a/net/ipv6/ip6_input.c
> > > > +++ b/net/ipv6/ip6_input.c
> > > > @@ -459,6 +459,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
> > > >
> > > >  static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> > > >  {
> > > > +       skb_clear_delivery_time(skb);
> > > >         rcu_read_lock();
> > > >         ip6_protocol_deliver_rcu(net, skb, 0, false);
> > > >         rcu_read_unlock();
> > > > --
> > > > 2.30.2
> > > >
> > >
> > > It is not clear to me why we need to clear tstamp if packet is locally
> > > delivered ?
> > It does not clear the rx tstamp in skb->tstamp.
> >
> > It only clears the EDT in skb->tstamp when the skb
> > is transmitted out of a local tcp_sock and then loop back from egress
> > to ingress through virtual interface like veth.
> >
> > >
> > > TCP stack is using tstamp for incoming packets (look for
> > > TCP_SKB_CB(skb)->has_rxtstamp)
> > skb_clear_delivery_time() will put ktime_get_real() back to skb->tstamp
> > so that the receiving tcp_sock can use it.
> 
> 
> Oh... I had to look at
> 
> +static inline void skb_clear_delivery_time(struct sk_buff *skb)
> +{
> +       if (skb->mono_delivery_time) {
> +               skb->mono_delivery_time = 0;
> +               if (static_branch_unlikely(&netstamp_needed_key))
> +                       skb->tstamp = ktime_get_real();
> +               else
> +                       skb->tstamp = 0;
> +       }
> +}
> 
> Name was a bit confusing :)
A few names were attempted in the early version and
then concluded on delivery_time. :p

> 
> And it seems you have a big opportunity to not call ktime_get_real()
> when skb->sk is known at this point (early demux)
> because few sockets actually enable timestamping ?
iiuc, you are suggesting to also check the skb->sk (if early demux)
and check for SK_FLAGS_TIMESTAMP.

Without checking skb->sk here, it should not be worse than the
current ktime_get_real() done in dev.c where it also does not have sk
available?  netstamp_needed_key should have been enabled as
long as there is one sk asked for it.

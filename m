Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458244CB266
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 23:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiCBWfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 17:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiCBWfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 17:35:00 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECE88E1AC;
        Wed,  2 Mar 2022 14:34:15 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMiaf010338;
        Wed, 2 Mar 2022 14:33:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hfzuG1j+9jyk8PIFSvsb63rZJayHiAR926HOur1IKcM=;
 b=ko2672sYrxesNPqoTqO4+etTuDnkpGCyfT89meDjNtGeHBA1GEFzqB5vbcNbvBWFmVrT
 9NWRplV6tLzSMDiv9Uy/0ntGZBFsBd+nEeIH3mYk6Do1JLPPln0MNcViaTaaofyl4Ie8
 fBXlIdOU789ZakeHTqSQlxTE7qtgKDZ26jE= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ejam13g62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 14:33:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUKIdrkxKKDk5Wxh/07WwUZyahlC1xWaPMeBMxbpTB6HY8Ugl7jD9V+6Zcokotw8Up/sKT3akat++ULnNINiQGYRutWyICOjD87pi60o5Rc7le59BsmnO2wmlBCOwKka8T9kt3HGYDa2wGGn3tMoWzq4pnb9Y3f5Arb/ny2UDQAUE1Ta/xujOrKn0Ax9L3Whv5SY3nmm2Ke1BP69Xv3vyB2VylsFhtbTpGfgkP+47BxJvuOyww07/btYDjhQ5xr49DDx3y7cXfubH0w6Yzh1Wi4SBbgdGAI7TntEu0T78h3SDxY4NQrN5eMjWpvhRGfc1BtRHCPP2xaLahAEpX05eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfzuG1j+9jyk8PIFSvsb63rZJayHiAR926HOur1IKcM=;
 b=c5W3Bh2Y4Cqib29GFxc4MgYheVAN2CeDYss0bMXl+Pb50Vqe7H/rv/CY3ZU7yNGb4Uig1pNV97OfpPE9kjHPiVxs7HqYgtmri1WOeH1QQnaR3GEyRy/QpJXG1ADxfW2YYfqzulV1RO1LLi6ZL81woUs2CuqEFFT0Y7eloM6vpR0B7CbF8EQYVQjkvyrvcD7YhyvjKnlMX79k7QkoyIWuCYzuaMvnLu3BtjcOhdatSSYIRCPgenyQ+2G8+xATJzqBZbsx/qyEc0oiLu0WMr1C115Hb4mgI6TExiNHyqGe84pP1lAdrGD4B1pcZtZ59ATZvVs6k9DddusHu+1x+53hyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3854.namprd15.prod.outlook.com (2603:10b6:806:80::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 22:33:57 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 22:33:57 +0000
Date:   Wed, 2 Mar 2022 14:33:52 -0800
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
Message-ID: <20220302223352.txuhu4ielmlxldrg@kafai-mbp>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195622.3483941-1-kafai@fb.com>
 <CANn89iKN06bKxjrEeZAmcj0x4tYMwRv-YzdZLWKbCcuTYT+SpQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKN06bKxjrEeZAmcj0x4tYMwRv-YzdZLWKbCcuTYT+SpQ@mail.gmail.com>
X-ClientProxiedBy: MWHPR14CA0059.namprd14.prod.outlook.com
 (2603:10b6:300:81::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f388b81-b6ca-485f-b6df-08d9fc9cbd4c
X-MS-TrafficTypeDiagnostic: SA0PR15MB3854:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB385461AF54FB9F8100AAF520D5039@SA0PR15MB3854.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i3ix9aGVCy51/DHc6ucX+7s0kLyYZkEk/LuLMgE1ku8FP0xFINVqe/UPaQT3F3+LiMWvXrxT14FbYVoQSpVVhhwRv2GL9wZQp0TUcTztl38c3OJxb01O4MW5SHYnbRpBjbdC+aA+VXhxb7Lf5hnHHYr7D4hP2QvdNecpPRVcl9tPdw7HR70PAP8HvXj5FwcxDvy9xOG55x4vDzI0y/Yn/7ej5UU3vko5drkGbYT9vW6wYEYsE3SXPBcmT/79iL0OdJKjExwYbV1v6gF6L791w78HUWp1qr2fy2KaNt/j3wKv6SyiAT9sOIupIJurUux05EVs7wr4z+W/Nr2zqYMs+8A4jQ7/eWvoTbf+HRB4lI1JNIORBoYDkxYYNsFTTHksvIq/Q3GZ3rs9aD4OwhU8UX05EIiMdEqXwGkNvVQtI0yM2ky4NIyHILTSxTy83F3H03Rs6w4vHiL3+uW3yD17WWejtyGdpxlzqYNuNF2QNThraqxY13O70ey45zldLAhLFpXwA0yxhfiOq2vWgIEMr14qFurQRLEkOr4Px19KBnk/IO+7MeaCXE551+3wZ7qyK2o1TI3P6OLykazaSI13LxIk/vFp45eIFFZPajL4UhybeBiQhgmpy3Oy9TNBtO2cjhMOd1s7O4OPVNdsYZI0Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(83380400001)(8676002)(1076003)(186003)(8936002)(4326008)(53546011)(508600001)(52116002)(38100700002)(6512007)(6666004)(6506007)(9686003)(66476007)(66556008)(86362001)(66946007)(6486002)(5660300002)(6916009)(54906003)(316002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pHPjYV4bQ7j/D/vfGD8ICyKaW12tIMfMZh9KPtKfOS9KTR4injA1RcO0yrWX?=
 =?us-ascii?Q?jThFM2eJOHOSK7Dqoqs2C/a50Q3RrG5Mqw6W2vHx4K2Mp8QrTwz8JkGjObMg?=
 =?us-ascii?Q?Ty9V3iAeW8zKNdqklCa4+QoUfwEYeGGtcWKKBZCIxprodtz3Irb75VFx5Gfb?=
 =?us-ascii?Q?xIE5KGWHMkZQ7tIQHdaz/DO5TijWhLYeiLodfsdu5HzHJIs0NyWT1ysGchEV?=
 =?us-ascii?Q?vbBo2deGBYcnrsd1GmkSKbWxG9Hgrl4bShXVW2Alw2jSSlDIiycGWh5vMJIP?=
 =?us-ascii?Q?A1G3L6z1/K9KOjbysiDy6NeIIYapDy8U4M3nFRhSmV/VyW7eQMdxFqgq8nOf?=
 =?us-ascii?Q?weXHLC7+kE7YH79IwETofeH5PHmZ+pPYnHe6+8kRU0ZVfrkyFoCUbQUAZ4Hk?=
 =?us-ascii?Q?VN/kleazWw5IfeJWXr7vM54psKykHc0TTBMwduThiEDIEQG0pwlUzYJrVXbc?=
 =?us-ascii?Q?7QyeOzeQcnh0e0D9FcLiaBThvp8tngJdY9J7S456u6CnEgYURta0uBOf5n/+?=
 =?us-ascii?Q?P+Qr+Rtvqu++agf15D2pgI786KuvF2e9srjnQTeB9R3FgDyCYSSsikTz6cZR?=
 =?us-ascii?Q?IZ/MOBrzcGkqHNp9X0z/S2H2fWT/ToquS5d+CNjeHk8Mgv/a/GUMMukAUX8j?=
 =?us-ascii?Q?uEuiOxO8K8MgNZeaLGLkOkJ0xBEChYffs8UOMuxGZeCusV6emr17fOWNc3od?=
 =?us-ascii?Q?RQiuEwFI0GqnkMmROfptgik6JkuaGlvhArLYYHqVxCZf7AOrPEIWUkIb6iUn?=
 =?us-ascii?Q?ESWcodUHurj/JwsjwVlcs7pTTMO23YTSbLw3zqohCFxC9tGe5Blt78OfjAn+?=
 =?us-ascii?Q?ou0a+9zRcTH29lK2YwRY8vZ+7g8eLGj8pXmd2oC2ToR6Krwjt/92Oh3X+qFh?=
 =?us-ascii?Q?6LVNKMZLYJDs+sXhed+b4wq4gNurdSlcP88s/OzTRsb+9mP+Q28Q8gnDqa7c?=
 =?us-ascii?Q?fwVX6bn7VYFshzJNfyNfTMnSpKEggxqiY16KUuB83coGu2ew0v4MDyInZBDn?=
 =?us-ascii?Q?nusKmgBMoZh/8bP6wzbFr+YeJg/0qiCdVuxWxnl09/tXL5ujXojhFk4PWESA?=
 =?us-ascii?Q?+bWRllXYohVtiiAjagFS1fb/X41oNs55Svo9sneNLMJs6Qx7dncUKUeBWpG3?=
 =?us-ascii?Q?ooXUkbHr+58IsWJh9v7zOTINXDNP8u0VzHm0kq/oOhioF6GJXBQmC6IVjxBx?=
 =?us-ascii?Q?Zp/ZYZSjS3+GcBv91xNNzxuLnW8rYkcqFfTS8ZapvYqAVipsGLYV9vmASH6A?=
 =?us-ascii?Q?jDgnC9Iy+VXpWRuE3SvH3gsebx7YLiHTw3rpSkGzfeyIUXYoA54zx2snbHyd?=
 =?us-ascii?Q?zUXfydfQy4HzFp0S81AWDtsT1oI8OOrQOeP9wcPS2g8Dh164DZjWTLmPuleL?=
 =?us-ascii?Q?1CvF6tWsW+udnJblsURAmHXbZ2hKJZR416JZQCqvfnSa8GStlzJHhCg/pRhL?=
 =?us-ascii?Q?Nl5HOsrdn40+m4p+BCc4xRbiiRhjxCaqVjuODqLES9M9g99jLgR0LnjIavl0?=
 =?us-ascii?Q?2tVF8MaMOAFMFaww6++0h9S1/z0oGnByUPlcA33bCqVlobyD9NNFJzo94Rzt?=
 =?us-ascii?Q?1tmeuHkM7ntA+62mAD181BhXXn40RC1sk9olCqQm?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f388b81-b6ca-485f-b6df-08d9fc9cbd4c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 22:33:57.2060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQzzuRZqY9T1ouhcbtmtHq5zZZTrvaRNhKKFFnwfHbXyWZAS/1VKHd2bT9crLZJQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3854
X-Proofpoint-GUID: Eq555DJybaWX7-eIxJEEW9J2IYn7-muD
X-Proofpoint-ORIG-GUID: Eq555DJybaWX7-eIxJEEW9J2IYn7-muD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020095
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

On Wed, Mar 02, 2022 at 12:30:14PM -0800, Eric Dumazet wrote:
> On Wed, Mar 2, 2022 at 11:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The previous patches handled the delivery_time in the ingress path
> > before the routing decision is made.  This patch can postpone clearing
> > delivery_time in a skb until knowing it is delivered locally and also
> > set the (rcv) timestamp if needed.  This patch moves the
> > skb_clear_delivery_time() from dev.c to ip_local_deliver_finish()
> > and ip6_input_finish().
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/core/dev.c       | 8 ++------
> >  net/ipv4/ip_input.c  | 1 +
> >  net/ipv6/ip6_input.c | 1 +
> >  3 files changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 0fc02cf32476..3ff686cc8c84 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5193,10 +5193,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> >                         goto out;
> >         }
> >
> > -       if (skb_skip_tc_classify(skb)) {
> > -               skb_clear_delivery_time(skb);
> > +       if (skb_skip_tc_classify(skb))
> >                 goto skip_classify;
> > -       }
> >
> >         if (pfmemalloc)
> >                 goto skip_taps;
> > @@ -5225,14 +5223,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> >                         goto another_round;
> >                 if (!skb)
> >                         goto out;
> > -               skb_clear_delivery_time(skb);
> >
> >                 nf_skip_egress(skb, false);
> >                 if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
> >                         goto out;
> > -       } else
> > +       }
> >  #endif
> > -               skb_clear_delivery_time(skb);
> >         skb_reset_redirect(skb);
> >  skip_classify:
> >         if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
> > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > index d94f9f7e60c3..95f7bb052784 100644
> > --- a/net/ipv4/ip_input.c
> > +++ b/net/ipv4/ip_input.c
> > @@ -226,6 +226,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
> >
> >  static int ip_local_deliver_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> >  {
> > +       skb_clear_delivery_time(skb);
> >         __skb_pull(skb, skb_network_header_len(skb));
> >
> >         rcu_read_lock();
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index d4b1e2c5aa76..5b5ea35635f9 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -459,6 +459,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
> >
> >  static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> >  {
> > +       skb_clear_delivery_time(skb);
> >         rcu_read_lock();
> >         ip6_protocol_deliver_rcu(net, skb, 0, false);
> >         rcu_read_unlock();
> > --
> > 2.30.2
> >
> 
> It is not clear to me why we need to clear tstamp if packet is locally
> delivered ?
It does not clear the rx tstamp in skb->tstamp.

It only clears the EDT in skb->tstamp when the skb
is transmitted out of a local tcp_sock and then loop back from egress
to ingress through virtual interface like veth.

> 
> TCP stack is using tstamp for incoming packets (look for
> TCP_SKB_CB(skb)->has_rxtstamp)
skb_clear_delivery_time() will put ktime_get_real() back to skb->tstamp
so that the receiving tcp_sock can use it.

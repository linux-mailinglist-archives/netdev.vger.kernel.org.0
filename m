Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC269496DB3
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiAVTw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:52:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61700 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbiAVTw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 14:52:57 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20MH1Q9H019406;
        Sat, 22 Jan 2022 11:52:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=f+DzzQyM3FfGlnKpwYie7A1Xup5ka43xgY2qYGkyLjo=;
 b=nhtBcwYoUQzjWzmLdy/OkpGKwjfwJsR/7sB8QwWraZDb0j4N/wbtjCWQm5aDmvqcVI17
 84cgn9ujL7yYSF668Er1aymYuBB5OyUw/BFVmCfrjSchR8fBsJACNz8WMarFKoHQcgpE
 0HxB9SCvPqk07s/EIG7u5ZtxwbBDqOCTpPo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3drj45h7hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 22 Jan 2022 11:52:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 22 Jan 2022 11:52:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFd92gpgSUC9wzgAsYFkEZdcVamhvte7NQA3ujC13M3l7met3vELmTk6q02BLF1r1WiENjNIBqztjM1lSEWge4tgNNgkM6Uq3jYOGP028omboEiuwRs+uoI1xeTFUAk7DYCuNvHOjpeCxBDSRH17ASin6LTmsWxE6GuOY4FI28RC0TtckUlmhFog0p+HzEGziGHH/c6jqzrSUK/SfiyKG1YG/q0xyw6Njc6ofgqtHONnaEOIa3W0RWF1fDzSO2lH3b4UhBSXnIsoi9sfK8WOwN8gIFZB+UgEkigaDJFiXyiGSF7IwhJ9sQyJjskcQ0t/x4lvDEb7UaRxHtOo8qOmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3hyta9FbsBMJo0qqTr4xF9oesOcP7ofixpKOxWSHnQ=;
 b=awVZcmXls5IYaQQV59K2ltasKAQ5IXMmOHMfOOoXJ4j18mXAdRdlnR0agXzbdIz6cpXuNGYZhHax9/sry3DnyJMD6EE+tE4mlwJINikNQgHAW+irpn99BxFMjiB9NaTjPXpPoRtOBcCjmBc4kAfjhFnhigg/Tmn/cQUhu25+hE90teLIze8yIznbTYHmh7E4vHv50phkO1q1ycTyLtZWfu5azYDn1R36AL/czAuMoM+M4rb+CvbJ0DCAHUA2FqhLbuh03X4zGCF9Tzs4ggC62F0DHgQ+OSpwlrOqEhZnpLJ/FVnYawzL97ygKZQR+eXfKEbJgSqINmhcR3hS8+vKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4806.namprd15.prod.outlook.com (2603:10b6:806:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Sat, 22 Jan
 2022 19:52:32 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 19:52:31 +0000
Date:   Sat, 22 Jan 2022 11:52:28 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v3 net-next 1/4] net: Add skb->mono_delivery_time to
 distinguish mono delivery_time from (rcv) timestamp
Message-ID: <20220122195228.psu6bsodh3k3ds5q@kafai-mbp.dhcp.thefacebook.com>
References: <20220121073026.4173996-1-kafai@fb.com>
 <20220121073032.4176877-1-kafai@fb.com>
 <CA+FuTSe1d91JC_bQvFGdoAaAEG4fur6KfzkNheA-ymnnMharXQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSe1d91JC_bQvFGdoAaAEG4fur6KfzkNheA-ymnnMharXQ@mail.gmail.com>
X-ClientProxiedBy: MWHPR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:300:16::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3cca16c-5770-4b24-c27e-08d9dde0ba47
X-MS-TrafficTypeDiagnostic: SA1PR15MB4806:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4806F86CED1D66892D6ECB0ED55C9@SA1PR15MB4806.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cVyyPiL1zDvXKcWhgeYHvvAbsPWsI8oGrYFo9jZ2fI5ZbWWSZFt3JV2zbgrQI/XPrn3SxpedNdMqR/gwhBjebHDZXbY55+3Boc/4NWOTzGOUYufUzXxH9ToHKoESqJD7suOQpXI1XCB7kHDg5u63E/uO5fHks1ACSWYC6Ugp+E27nwh5dG+gId7WKyX/aw6maa5OEfC2UVS5I1GTWptbuMcE6kkdWPkEgr4dDFmIUnEmSkX4rpHmkrjXQ0ZCunGV5UuJ9tYFXdm6dEtiOZpc/H283Md9XCSl3BDFS0bAPIDhVv633DNW/Y7gmGtHysKkVKNBHnOrITyevb1+iooMXRVyoUfKVocvLtR7G+cpnDJkW/7DwAs13Fwa2qrn6/fHKPF/OIS4b3ELJJBZ8tmAMa4H1T0Cjyut4UTWK69ZivsHOiM7VWOuRkcMSCK9VBrC3Fy08Yv9tfo84G53y07cfuyv/2xYxnZCMcgyqXF5xydxi0C7CM6cafBKn//aLx/fe8q2jJCpOeL8FPf0sUxQWa9iILVjKe7wwoulFpB50NfaJQvnKhuI0maYMSnzR7kKisoAoHZAoCB1exDgVdFixvqkTzz81S5osAU1FdqPTezpBb4qAytYuAl4q/l9Tjq4v2Tji2GvWW7QspOX2DAAxw3FgkPNz8bzpBBmW+avMCfoZQSdLbuITmC8jRwhzGYTdNL8ednlM76oqI65j2AHR2nwJdMU7t8F0rIbf93cK28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(4326008)(966005)(53546011)(6506007)(8936002)(86362001)(5660300002)(508600001)(9686003)(1076003)(6512007)(186003)(52116002)(54906003)(316002)(8676002)(6486002)(38100700002)(6666004)(66556008)(2906002)(66476007)(6916009)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AAeURaIyavuKxSk7ZC6tAWf3mxPnBxCgbUYm+HUu/seYvroy/kA9l5BfXDUj?=
 =?us-ascii?Q?u9TlgKdFZFCEoGn5xUriLisBrD7hLJxzhk+cQdrJq5tI7+Zjir1KnoUzDPLp?=
 =?us-ascii?Q?AJr/TFKwxoWlsxWRzaTkEUHjRSwB8Gcf77tc+v1nL8h7G5DcxR5IoFHB3hu+?=
 =?us-ascii?Q?9DJWjn6TiFSr5XxQZzWBBevAC3mhfs2vF5pALihmb0I0jFkBr9a2W53PDBLq?=
 =?us-ascii?Q?MJsc1Dz5f9Ax3YxVt7gD0suQ0rS30O4VecSX47IBIaowECmKko0LautvNh+m?=
 =?us-ascii?Q?lnHSBgmHaJ++lxVAveOpXU08DNEjcNHaM1+ntbEo+GcdKwAHJ0c1JRjeqADD?=
 =?us-ascii?Q?PFJvU0LuFDtltOoBbKpXx/9f0XThCbLoPQozc9K8GBkxkZMq/KJ+d3LQd2Na?=
 =?us-ascii?Q?ALmbfdcsACpekffk+amLFtcLUGW6rU1/gYf66YjEMfUUBjqmeyHPZFIu2O/p?=
 =?us-ascii?Q?YL1vVOaAaIeleIB9jRZOk3wGzUl3ffxyksrIw0VtFaqN3V5Kvi9715YANcti?=
 =?us-ascii?Q?FMAIew+OPbdV/GZqFuQGNdgoxvFIijvzeOTqJ3+gcjfqJkdaz6snfQnLx0HZ?=
 =?us-ascii?Q?vPhohsQJmCtUvNJ+X1BfMbRT/966u5lTiFb8U+FhVuhzQclAWwMhbEVZfk29?=
 =?us-ascii?Q?e4/kZqEC7r7NydzAh2lgpkWD2AvNfvxQa/98R1cgj1OmkefRV+917hiiVnGo?=
 =?us-ascii?Q?p3yTLkH0SEAz8AQIYowI8VI7NA6w8cPRYqgqYsh26y9vxIC7Fk0ws0F6oYOf?=
 =?us-ascii?Q?fo4otts+cltEHnxJDGbDfThzmPwbY85IJZY0VKYP34q+OWYQaXlXVh6ybw7d?=
 =?us-ascii?Q?OAbPdbEvHGA55yjSu8v0NmvQSHTiMzk2fYx90EaGjdTjHVubSV6uO/2luJFi?=
 =?us-ascii?Q?YEZjuDglEOydHIqfLvtgCiWnTFHtshKp8keKMdFBzhAVTV40I7k6cUKd+jKK?=
 =?us-ascii?Q?p0GUzpHi5IoNZxnuQoxzipNC9zH+81Y7gLyf7XsDZ4HelX6uMQhRjKPcKIe4?=
 =?us-ascii?Q?FbsEBcpOtX7XPHsYR2kcr4akwdUizpUjO60GGXMxrMZc9/0W5trvtUZr1n73?=
 =?us-ascii?Q?c4BZ+/4xASPtCccrVpRZNihpRUiShd4v2Zq4NMArdq2UAW8GpfArT+lQv+H2?=
 =?us-ascii?Q?gAumdVrfus1ih5qvUdyJRl03stKXQlGSRefea8RkSqE6FhC0xfYZ2Jchd83P?=
 =?us-ascii?Q?THnSuwjmWafdwdY4iTqE9tcIhl3EB69qxs2IW92MGA7+k6xMfdtdMaSJp9/E?=
 =?us-ascii?Q?abUR2JT2TCksi2xS4PIU4ZNKvMOH/59qBGl+741J4FE/dyGWfE198IrreBnf?=
 =?us-ascii?Q?nuBNY0hA16UCU/ijDTzWmSa5aSeEdRlgVFb923JgnMx3BanEzsBd4Q5YkDnu?=
 =?us-ascii?Q?WJCprovcjTUNpMm78sOFRPdzIzHeE4yu2nENmkwKTq2bty/zEWHp2dGOzXsI?=
 =?us-ascii?Q?DukDwZlYDBZkOyF6z8CxL50sHMNVoll51nCOmyMIToGWSTlwgt+tID9n48BS?=
 =?us-ascii?Q?hCHz5WpAMILN3BYMXhzuK0H014BVbrp0rNxrYSS6YGeUueW2rcSUFexhvutS?=
 =?us-ascii?Q?dDYL9V9T70q42UIeler7wggr4A2gunxOsw0e52Fq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3cca16c-5770-4b24-c27e-08d9dde0ba47
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 19:52:31.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ER2tBamxHzaHQakEgOatG4Iyzvqxm2mkJSykrFXev+Gys/AXYJXTiDyfpEmPUT/b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4806
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 1iYCDZkSKOZ4o4hoUcHYKSkPZVkeROeY
X-Proofpoint-GUID: 1iYCDZkSKOZ4o4hoUcHYKSkPZVkeROeY
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201220142
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 10:32:16AM -0500, Willem de Bruijn wrote:
> On Fri, Jan 21, 2022 at 2:30 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > skb->tstamp was first used as the (rcv) timestamp in real time clock base.
> > The major usage is to report it to the user (e.g. SO_TIMESTAMP).
> >
> > Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in TCP)
> > during egress and used by the qdisc (e.g. sch_fq) to make decision on when
> > the skb can be passed to the dev.
> >
> > Currently, there is no way to tell skb->tstamp having the (rcv) timestamp
> > or the delivery_time, so it is always reset to 0 whenever forwarded
> > between egress and ingress.
> >
> > While it makes sense to always clear the (rcv) timestamp in skb->tstamp
> > to avoid confusing sch_fq that expects the delivery_time, it is a
> > performance issue [0] to clear the delivery_time if the skb finally
> > egress to a fq@phy-dev.  For example, when forwarding from egress to
> > ingress and then finally back to egress:
> >
> >             tcp-sender => veth@netns => veth@hostns => fq@eth0@hostns
> >                                      ^              ^
> >                                      reset          rest
> >
> > [0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/attachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf 
> >
> > This patch adds one bit skb->mono_delivery_time to flag the skb->tstamp
> > is storing the mono delivery_time instead of the (rcv) timestamp.
> >
> > The current use case is to keep the TCP mono delivery_time (EDT) and
> > to be used with sch_fq.  The later patch will also allow tc-bpf to read
> > and change the mono delivery_time.
> >
> > In the future, another bit (e.g. skb->user_delivery_time) can be added
> > for the SCM_TXTIME where the clock base is tracked by sk->sk_clockid.
> >
> > [ This patch is a prep work.  The following patch will
> >   get the other parts of the stack ready first.  Then another patch
> >   after that will finally set the skb->mono_delivery_time. ]
> >
> > skb_set_delivery_time() function is added.  It is used by the tcp_output.c
> > and during ip[6] fragmentation to assign the delivery_time to
> > the skb->tstamp and also set the skb->mono_delivery_time.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/skbuff.h                     | 13 +++++++++++++
> >  net/bridge/netfilter/nf_conntrack_bridge.c |  5 +++--
> >  net/ipv4/ip_output.c                       |  5 +++--
> >  net/ipv4/tcp_output.c                      | 16 +++++++++-------
> >  net/ipv6/ip6_output.c                      |  5 +++--
> >  net/ipv6/netfilter.c                       |  5 +++--
> >  6 files changed, 34 insertions(+), 15 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index bf11e1fbd69b..b9e20187242a 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -720,6 +720,10 @@ typedef unsigned char *sk_buff_data_t;
> >   *     @dst_pending_confirm: need to confirm neighbour
> >   *     @decrypted: Decrypted SKB
> >   *     @slow_gro: state present at GRO time, slower prepare step required
> > + *     @mono_delivery_time: When set, skb->tstamap has the
> 
> tstamp
> 
> > + *             delivery_time in mono clock base (i.e. EDT).  Otherwise, the
> > + *             skb->tstamp has the (rcv) timestamp at ingress and
> > + *             delivery_time at egress.
> >   *     @napi_id: id of the NAPI struct this skb came from
> >   *     @sender_cpu: (aka @napi_id) source CPU in XPS
> >   *     @secmark: security marking
> > @@ -890,6 +894,7 @@ struct sk_buff {
> >         __u8                    decrypted:1;
> >  #endif
> >         __u8                    slow_gro:1;
> > +       __u8                    mono_delivery_time:1;
> 
> This bit fills a hole, does not change sk_buff size, right?
> 
> >
> >  #ifdef CONFIG_NET_SCHED
> >         __u16                   tc_index;       /* traffic control index */
> > @@ -3903,6 +3908,14 @@ static inline ktime_t net_invalid_timestamp(void)
> >         return 0;
> >  }
> >
> > +static inline void skb_set_delivery_time(struct sk_buff *skb, ktime_t kt,
> > +                                        bool mono)
> > +{
> > +       skb->tstamp = kt;
> > +       /* Setting mono_delivery_time will be enabled later */
> > +       /* skb->mono_delivery_time = kt && mono; */
> > +}
> > +
> >  static inline u8 skb_metadata_len(const struct sk_buff *skb)
> >  {
> >         return skb_shinfo(skb)->meta_len;
> > diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> > index fdbed3158555..ebfb2a5c59e4 100644
> > --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> > +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> > @@ -32,6 +32,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
> >                                            struct sk_buff *))
> >  {
> >         int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
> > +       bool mono_delivery_time = skb->mono_delivery_time;
> 
> This use of a local variable is just a style choice, not needed for
> correctness, correct?
It is needed.  The current code also saves the very first
skb->tstamp (two lines below):

> >         unsigned int hlen, ll_rs, mtu;
> >         ktime_t tstamp = skb->tstamp;

My understanding is all frags reuse the first (/original) skb tstamp info.
The frags output() is one-by-one, meaning when sending the later frags,
the first skb has already been output()-ed, so the first skb tstamp info
needs to be saved in local variables.

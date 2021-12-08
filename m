Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841D846C87C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhLHALw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:11:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60596 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233913AbhLHALw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:11:52 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7N284t021628;
        Tue, 7 Dec 2021 16:08:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FY+xOpRH5RwY8nIcU93BBb1tTm/sTSlCuj21AFoHHiI=;
 b=TVckgVFSV3Htmvejou5We6VRgXRokXG7YZME8KPcVHDX9i+M3yLCfZMk9tjrS9KCKQee
 S2K2Kky9OdM1SyIMLrusrBI4nsJqrkljhwofH1hxSNsNU7iL0LcRgN6qg1UJWKE85a2V
 JWKHGUxnvmOu0uS/6ZSDCOgrzAoA9dz1GJM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ct99jbxve-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Dec 2021 16:08:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 16:08:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFZAlaLt1iU8WRc7NI5OOjIcfipoyHZREvV7eOxKSzca41/UvCc8BoaM17anfWIq7h5wZrlaIFTLo8lzjvw4z2o2ec2UEc7spFtNsAf9ucwB5wThPpY0mCG5+p7IiYv0QKvHR8EsaIa7anJ1SIoaQMvGX8LasMA5IVb63LaSUEvy8/5LWfvCLttWNZhP2w5qOexjux9ifxcGMiwVcmUG7J0X7Ep9rG7w7NBTq6f8aVdYqrVC5HsFoxQ1M3TTMjaJy35DLk0nYVVaepgN3M0zqFFx9jA2E3/PtyDpalQsmDyK6MeWcs+CVZGlcmHu2C1VNoDs5FK7WXZKVFUOXR3nTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FY+xOpRH5RwY8nIcU93BBb1tTm/sTSlCuj21AFoHHiI=;
 b=NFulRCUdBWXG/tAYNkSbVAnkqVJdHbMhPCuRJIxCuIDxWYC6sojflIEcpEUqav5S21JoGp4tkySdnFQqAFmLxny265YzZsN2zUGDwPjdXG9Xl9WYCCqLQg4pnSODtm8oZnYFDteuI30clxrbuuP9vtLC4CtfSSoFfzMl784S8fIOt7uO/Hsf44DS/tN0MKXpRyom7ba19sZ1Y0mE1LqTszODYFE0lMUGgAWFeoxM4ZjFDX26fVmX08iNJaEgG98PIrmrElzsoxWTca+5e9GkatbakKFlDXO+UkduxD8QwgPkFI6wQBh0/nXhBCm3zF3PRAlvMiz4/hRMvjsogHG9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2512.namprd15.prod.outlook.com (2603:10b6:805:28::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 00:08:03 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 00:08:03 +0000
Date:   Tue, 7 Dec 2021 16:07:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211208000757.c5oshpdxud6rbzuv@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0299.namprd03.prod.outlook.com
 (2603:10b6:303:b5::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fdb2) by MW4PR03CA0299.namprd03.prod.outlook.com (2603:10b6:303:b5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Wed, 8 Dec 2021 00:08:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 073ac022-2730-41ca-20d1-08d9b9decd62
X-MS-TrafficTypeDiagnostic: SN6PR15MB2512:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB25123D8D16ADAF0068C3E9D7D56F9@SN6PR15MB2512.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9oX+q5CWueVogwJejSQH8BkpzIXf9gVHx5T8gJuPGou9R5f2xvGN2S3uAt0m1GsA1gxbattgKXEfiJ7Vu93eBkf8ELtIl0gwGv8IWiMe9zBxh6QRvYzOtaVolwnkxtEmZ05I1MWeihAv3RoiBzIt9GuKWo79d2Sra0CNIy+gYQ6QQw8xraCE5+H6OGPvEkgPSRjlrHdsZvpNjKIgWJSC5bip+FPL2GsCnPmbe9mH1Zb6Ws/lysa38ulVmd0dgcSt75/y1DfhkaxUvAGK+mKWPt9CG9lMGwuBEQhp06LHiQbG06ZqWVTIA69jD4m4Z0olFuLsicW+b3awle+xuzuqWVTPUWebvXRoLrPaVTgsSjEJq8y7Tk9YB281XClMGi4isUqrBIveK/kHIf4rbIETbfbTzKsbqnxwXwTL3NbQZ4uQfGJ5+zTnqINz9Cp3Nxr9sPwNNEOkO7nTVSNsL0xbR6cl2y7yf7Rxney9/7dsE6sw8DY8EvK8L+tZNBs0P7NSRo7cr6raPsvxdKGWO+midU100hcSJ7u6sm1GdwCvCOU53U+ZK2bDO18yp37pfz5t/Qk3h8GO8x6cAcbE3p0v1N34Hzhnrsg8SvleMetkoOeOrp6QbU7L4Xv8JHFKLa56g1QFBM99IrM+TAGIkeTr/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(83380400001)(54906003)(52116002)(7696005)(2906002)(316002)(86362001)(186003)(9686003)(6506007)(8936002)(66476007)(66556008)(53546011)(508600001)(4326008)(1076003)(55016003)(6666004)(38100700002)(6916009)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QxScLV2jxmJY7LrfK3T/F/l6keOR0LlWIaCXgzG6ubhbbVaFqDLMa6uHo8Q+?=
 =?us-ascii?Q?WSVfXbnIiad0CAr5wGI1F+gQaI0Owf6vYVvHqgbLyyAv+kqgZK1jyKzNquVi?=
 =?us-ascii?Q?9LAbLI7RFNSnpS2Ow1imcaCxDGFfO1u7+11dqIO4b1VmGStqwYeWNdSEsH0G?=
 =?us-ascii?Q?LqHMRA8JWAGPAGWEF0xKagdXh1TeFXeA9/ufrPrUA3nS43I9iBYJE4NPCHIV?=
 =?us-ascii?Q?/6cuJWB6j08Hnzm9oAL9YlTpJUIZ5zZYJnsdJ8KU5xdtkeynn1fav3TDYz9m?=
 =?us-ascii?Q?hCbnQbb/ivfGu2HM0v+bWACz/I2MSr6Qour58APXjdlty74pKJ3FRpr9GfRT?=
 =?us-ascii?Q?fF0YO0pTP4IPkQoeUhLp9Zco/QNPMcebQmvZD29qkK/oSg3+ww0DSR9VzjHm?=
 =?us-ascii?Q?onzRobHhmdQhtfQHr31w5VUFsiZ1CZBEE+IPslCf43szOJx7fhJuRTio/JOH?=
 =?us-ascii?Q?vDpNpEb8YQgi/OoAWDs7cgRwoVnV0U4eLdq2WX5kSZXcEjNH1t6KahdoISNF?=
 =?us-ascii?Q?2jyPv6xJ6sFGYwvZOhSsWwZNONFYs3fGxfjeCumdZKDwnG9/0GyCFD665rC7?=
 =?us-ascii?Q?MjrwQVZFw9MopRrHEBle7/L+8ZmCsbT5dhtNkbGjZuHgDSuOq2bDxT16dSSC?=
 =?us-ascii?Q?T8C9RPX3G1NSFNMfnM3XYYN+VqSpgJOc+8vViry56a+g34RhkqbFOmQ9WEnS?=
 =?us-ascii?Q?5eMufzloMqVmEdUqYbBdwdy44QZPK8Is2KKsp9uPtsjaoymsxLslejE5mbxZ?=
 =?us-ascii?Q?1ek62si40H9xmAMnqbWA/VUCarL0RqC4huVKJRzWNibOp1VjX3fnox4sdz58?=
 =?us-ascii?Q?ms5cNak5UNY+KP5MGoo0nwEq0xQ1Mqb+NPjqrOltsNvDlkKbdlpdod1+GXBx?=
 =?us-ascii?Q?rEj5jE3s564HBz8MaXsFXt8rDixnf6Zp2CkKbyHd4P5VSowJopoe8xzYJF5w?=
 =?us-ascii?Q?ysWXBpfYZXNMowdjkJ6UpzH226MFKWaJLA7iwZcgp9kO2pD4yoku+S9YZeth?=
 =?us-ascii?Q?yvA3dIyfLd+YyCuVLkE9XrNMp/5q5/J2ye7gtOVZMvYUNiB3Lo8n2hz21wcM?=
 =?us-ascii?Q?FJ94ulsT3f9m5Uiavfrlecz8cp9YQZhACf7ycLsCoZR4HvBcUp77ANbNz3pU?=
 =?us-ascii?Q?jM+tN60pNgXWGvO95j7Vm5+2aYWRGYNRchVDEF1CRL7RY3mwSuvtH8ayZ2Xv?=
 =?us-ascii?Q?WFY+1FLEVs4T6lNIj8wT78hzHWCPte8Je1+vtKpH445CoFFwrPsn1bzNpmgg?=
 =?us-ascii?Q?t/prX/pqkGN90oUpwXFqgz7CY31aFIltOJULi6lK7Rbt/troSH9JAgSAhMTy?=
 =?us-ascii?Q?6/tlgdT9Qy2G6VSKTzTUMGyCUATaaw9NjL7G84ecR61GUlIgScHrXonP28IR?=
 =?us-ascii?Q?ZhN+/MDoCY4o5zpnlwJeLVMDMtINDRDWMz6bjGFke9XY1NrqeHEx0Y+oUe/7?=
 =?us-ascii?Q?36bmkVHdAtFPx+Cb2WMSEn4ifXRPbzQo5Qu2X62Rg4KQp7ATkQVYYv35IUD8?=
 =?us-ascii?Q?QTOLS2G8WiuoaWKpqTiklKEgVg7WP/uKWUm8ICawYt+NanXrN6iBc8XdzBwz?=
 =?us-ascii?Q?nHXKEgyiRAG/jSwZTC5eOhaHSsZq44jmUNcdquwo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 073ac022-2730-41ca-20d1-08d9b9decd62
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 00:08:03.3894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zN+r363WhZ7d3KuJQ0yO1vXeexBOBRPnyeC3MEfxX4cZeupXex+aNlguJGNXo4G3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2512
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: n_UvdHXv0fjbetJjYQXQsSu5uzXpRCoU
X-Proofpoint-ORIG-GUID: n_UvdHXv0fjbetJjYQXQsSu5uzXpRCoU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_09,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 clxscore=1011
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070148
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 09:27:55AM -0500, Willem de Bruijn wrote:
> On Mon, Dec 6, 2021 at 9:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The skb->tstamp may be set by a local sk (as a sender in tcp) which then
> > forwarded and delivered to another sk (as a receiver).
> >
> > An example:
> >     sender-sk => veth@netns =====> veth@host => receiver-sk
> >                              ^^^
> >                         __dev_forward_skb
> >
> > The skb->tstamp is marked with a future TX time.  This future
> > skb->tstamp will confuse the receiver-sk.
> >
> > This patch marks the skb if the skb->tstamp is forwarded.
> > Before using the skb->tstamp as a rx timestamp, it needs
> > to be re-stamped to avoid getting a future time.  It is
> > done in the RX timestamp reading helper skb_get_ktime().
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/skbuff.h | 14 +++++++++-----
> >  net/core/dev.c         |  4 +++-
> >  net/core/skbuff.c      |  6 +++++-
> >  3 files changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index b609bdc5398b..bc4ae34c4e22 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -867,6 +867,7 @@ struct sk_buff {
> >         __u8                    decrypted:1;
> >  #endif
> >         __u8                    slow_gro:1;
> > +       __u8                    fwd_tstamp:1;
> >
> >  #ifdef CONFIG_NET_SCHED
> >         __u16                   tc_index;       /* traffic control index */
> > @@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(struct sk_buff *skb,
> >  }
> >
> >  void skb_init(void);
> > +void net_timestamp_set(struct sk_buff *skb);
> >
> > -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
> > +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
> >  {
> > +       if (unlikely(skb->fwd_tstamp))
> > +               net_timestamp_set(skb);
> >         return ktime_mono_to_real_cond(skb->tstamp);
> 
> This changes timestamp behavior for existing applications, probably
> worth mentioning in the commit message if nothing else. A timestamp
> taking at the time of the recv syscall is not very useful.
> 
> If a forwarded timestamp is not a future delivery time (as those are
> scrubbed), is it not correct to just deliver the original timestamp?
> It probably was taken at some earlier __netif_receive_skb_core.
Make sense.  I will compare with the current mono clock first before
resetting and also mention this behavior change in the commit message.

Do you think it will be too heavy to always compare with
the current time without testing the skb->fwd_tstamp bit
first?

> 
> >  }
> >
> > -static inline void net_timestamp_set(struct sk_buff *skb)
> > +void net_timestamp_set(struct sk_buff *skb)
> >  {
> >         skb->tstamp = 0;
> > +       skb->fwd_tstamp = 0;
> >         if (static_branch_unlikely(&netstamp_needed_key))
> >                 __net_timestamp(skb);
> >  }
> > +EXPORT_SYMBOL(net_timestamp_set);
> >
> >  #define net_timestamp_check(COND, SKB)                         \
> >         if (static_branch_unlikely(&netstamp_needed_key)) {     \
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f091c7807a9e..181ddc989ead 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
> >  {
> >         struct sock *sk = skb->sk;
> >
> > -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
> > +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
> 
> There is a slight race here with the socket flipping the feature on/off.
Right, I think it is an inherited race by relating skb->tstamp with
a bit in sk, like the existing sch_etf.c.
Directly setting a bit in skb when setting the skb->tstamp will help.

> 
> >
> >                 skb->tstamp = 0;
> > +               skb->fwd_tstamp = 0;
> > +       } else if (skb->tstamp) {
> > +               skb->fwd_tstamp = 1;
> > +       }
> 
> SO_TXTIME future delivery times are scrubbed, but TCP future delivery
> times are not?
It is not too much about scrubbing future SO_TXTIME or future TCP
delivery time for the local delivery.

fwd_mono_tstamp may be a better name.  It is about the forwarded tstamp
is in mono.  e.g. the packet from a container-netns can be queued
at the fq@hostns (the case described in patch 1 commit log).
Also, the bpf@ingress@veth@hostns can now expect the skb->tstamp is in
mono time.  BPF side does not have helper returning real clock, so it is
safe to assume that bpf prog is comparing (or setting) skb->tstamp as
mono also.

> If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
> scrub based on that. That is also not open to the above race.
It was one of my earlier attempts by adding tstamp_is_tx_mono and
set it in tcp_output.c and then test it before scrubbing.
Other than changing the tcp_output.c (e.g. in __tcp_transmit_skb),
I ended up making another change on the bpf side to also set
this bit when the bpf_prog is updating the __sk_buff->tstamp.  Thus,
in this patch , I ended up setting a bit only in the forward path.

I can go back to retry the tstamp_is_edt/tstamp_is_tx_mono idea and
that can also avoid the race in testing sock_flag(sk, SOCK_TXTIME)
as you suggested.

Thanks for the review !

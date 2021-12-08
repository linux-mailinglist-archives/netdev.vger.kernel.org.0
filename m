Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA75A46CEC3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhLHIWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:22:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231496AbhLHIWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:22:38 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B80GkMY002276;
        Wed, 8 Dec 2021 00:18:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fx2NbxShPXJqZRW3yrnBcBUgb6m+j6FPSoJkRjHVVVA=;
 b=qAq2+1IlLrJpk25DINjOwh4pAdtUYBX+Zkc21aEwZmGH/IhjnzXzzFbg73JvHg2ZAFhW
 UBJ+G4KMXtrgEFqGxVapZGxwgizbZjGYM4T06kAL0dJoiWJZHl43np1dotRFXv1wdlxc
 jBFmslG+K/EPPhk/9PCGhi2kp3mzdcr//Bg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ctj12j3fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Dec 2021 00:18:49 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 00:18:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9PqdG1PwTVNV5eqegmsxo4Gth08GvlrJm/hyo53G2Xea2RebmxGpXBYWsEI68C69CBZgW52afpZBNHUXDL5fcBeuSECuc5yAZsZwAOkD9VbZIUpQdkQP3n8n6fXz8ZJWvVIfQzVL0iCKIgv2Sm+zOTm9OluIjR5kv3STzmrJsLmzCaQfRWYMfAYPMjqEGx+kFQ9rpsVCPWCTVcOlddn+F7fv8JwpnqsSHEPG6Fdq1t9sm9o4n7GNHa02O/rD7oIOBMaWv5QryLwvDXKnfiY61Rogv2TJYGOd6Os1dvwzFYTV4DS9IzI4+/AYdWl43HeMej3EE9TiOPzV1QFbsWOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fx2NbxShPXJqZRW3yrnBcBUgb6m+j6FPSoJkRjHVVVA=;
 b=bOuKD63BWHnF0eN7QvxbRPa0snBmSA4+59v/OWwP0aeNe5+Bv5Qcc2diTJ695yFQ/cXBBGlImkYPFsCfvF7Nu3oCyPDHoiS4J6kELrTcyD7kyblq/+3YNT7cM6ihQqhcZq10RqZ2YfQBLyEIIDA4DHQXJkfAAWPnQ4I5sE+F4boXD2zkQg1UmYNj30WTF82ixp89QQjvHlFNzqly2MJ8Teo0/Lz/cdh5fDD73UJ+2/bFnL1g0ysCeGZbn7jBBkaS8KLTEydK3Q/yGjOHQaj+PgyrRjhJLvtKoROBLrPAHLEzuHIPTbvpsY2jSkagwA+pPP42llD98GuYDrgDCkHQlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4610.namprd15.prod.outlook.com (2603:10b6:806:19d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Wed, 8 Dec
 2021 08:18:46 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 08:18:46 +0000
Date:   Wed, 8 Dec 2021 00:18:42 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
X-ClientProxiedBy: MWHPR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:300:6c::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4a0c) by MWHPR04CA0067.namprd04.prod.outlook.com (2603:10b6:300:6c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 08:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ed3da86-81b3-480e-c31f-08d9ba235b07
X-MS-TrafficTypeDiagnostic: SA1PR15MB4610:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4610F470F384FFC871F6661CD56F9@SA1PR15MB4610.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LoWcUm7KpwYy4coDNvwoR+zuf+DCyt6CBzau2FW+4kbWrRt/VxpRWratrnAVg5phv+qmn/FzztvbPhMZrnTZ37Gqsc7bQvEhF9W3eflJGp4NGboJYYEBsjTCCwZa9eLBHwrbX5T4ETW8U8ikTpoy8qLnI/sBHHSnwJODZT2sQIGORoRdLv8NE/1Aa+K/bGtf0H2WZB4gJNuxHaPU0JvCI+YLGhmxnQNrFwpvC0JmPCHHxu9qGJD6D432lxf5Sk1h4KcdbEQgO+utaBVg8oYKrCsAzanWWpwHEyA6awohEvkSYsapJ6jZuA3VwCZ+jH4nXimJhQkuI5yQg3Hl0SelyWGinKdMuW92U3Yh2GG22HGIRWax02/edAM7r/zYOo0h6Uggvax2jNCQ7c8CCvRuTUAli8kLqbLgdu9pH0YF85vMSSoICYuOeHvpPpAy5ZuqYlwdzTW51yVj0ndzVw2s5sKCb/+jawW5ERiVzpeApMUnYK6EO+XsCbABvbrLCodt4KY+WWMywSkIJMp1GlwVNZmesqVhvzyQ+8kgIGT8F/RJGbQCo087kUkg8Z9c0F1ouz2Qrk+PnNSrIFDc3wle9Muz2lF8vrd2XnDmjEuGcx8pHXShctnai2JZhtBbNO1XX81cyEjrgp6xHVpGPeOKOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(8676002)(66946007)(86362001)(66476007)(66556008)(7696005)(1076003)(83380400001)(9686003)(508600001)(55016003)(6666004)(54906003)(8936002)(316002)(4326008)(53546011)(6916009)(38100700002)(2906002)(5660300002)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?srokS+UtkrGhhm42uZaGoGgRLh066WgyrPjbyBUe1e5oxpYfa8QHZg202EV6?=
 =?us-ascii?Q?H1erIQ2tsmwK/LpD6IxCGobWfJl5jvvuiPYUJswZIwols4Wue9I3wm/fvkGT?=
 =?us-ascii?Q?YJf1yjv5DJL0cGTeUfYMQRyTXMId+DTu7izGXRDV2gEMVSoaXTl/qx2zO+6N?=
 =?us-ascii?Q?m9feFGaB9ftdIq0sJb+drWC1WdJH5ap6wPr4xEdzhiY9r709QuATEiMNLxyj?=
 =?us-ascii?Q?FRrQdVN7PcBlqKfBaooC05DoTSf4ZYu7gO5xa7ZzLD5H5oONAE63RPj8muC2?=
 =?us-ascii?Q?CjzpWH+fobA1uMVDRo1gk/9fsWg2pgzafFaFzlvQt8OxVkOY79GzfStplvUo?=
 =?us-ascii?Q?inH7WkkWTS0/45lk0TWDe3O2xvaJHVtrAs9JI3ei4ERGRffmI01O498MZ7ik?=
 =?us-ascii?Q?zzn4NsP3vY/cKPgXO65pM2bjv6JunR7FoVapZex9R5/Uy7Q4aNQrRZMne+Sd?=
 =?us-ascii?Q?4RIuUpxhsf+K7coxz91GYVH+JuQoJzc7WQ1++XRhiOx6bWdoErsskADGD9i7?=
 =?us-ascii?Q?leDX/50DwhU47LSkmNgX+2XMqbNgcDGRy9Nl03/MJfE5+X4tp7/PFO59v8gk?=
 =?us-ascii?Q?DU46h++7pyuipFYNhfpWxdTARPyjwIUh0QSyp/yuhqr/bYjddoO7lPoep5gU?=
 =?us-ascii?Q?K7EjHVNLtOyuynh77RL9Zdo9F6LL8zpEov2WNGd5EeRIjxqEcygt4MclF8ZY?=
 =?us-ascii?Q?43KpN1eysTlEOAZ38dbaqOaX95KkWFx0jDEFcPhtO6APYum5nRIDftO6FOo1?=
 =?us-ascii?Q?OYN0uD+OKNE1JvSyG/nluDiPyVPDId78o1nuJ0PA08rWuIBO+loA7FHq7STr?=
 =?us-ascii?Q?wRC9u6bjzMsfSVzr+ualcSDS0tpytarlv02I+KKD8ySXmfHbDdLaFqMAGvjj?=
 =?us-ascii?Q?5DyjEAR/BYnzHB/qVVJlruGaL2VH6gaY0tuz0vW720lmuL9965sUgkkWJEWw?=
 =?us-ascii?Q?9l3WpUgmSNGAGxrWYk+M4X+lyKa1+S1byjBPnX78SzBtcEN4Wc2SXuPIPs8k?=
 =?us-ascii?Q?xqCY7R9WLPWTzfV0gVuTKK7VDuvvIXHd6JfRgcofeZf1gD/gvXjs5en5KykN?=
 =?us-ascii?Q?X1Fk/FAk5wcR/xx4VpqtpQttJuGyA6kkfImPJpcqvQeN7+QKqoTUK07U36RR?=
 =?us-ascii?Q?GAATJs1M8+g8wEdKZ0KMDgJVUsFxHnCzgFXFiJvjCZmJvjLblBxEBatDSxgH?=
 =?us-ascii?Q?RMbPKj9hKDlMYh5psQBcb0dyk+WOd4xmwVzqAGspISKW+WrTOK1cDUCJXkLB?=
 =?us-ascii?Q?X1B0EvWAJKbe3Vz+M4dA1QPdHiQ9SDj1OHgwxc8k1E7/pvvzGLBx3ea7jNN3?=
 =?us-ascii?Q?AzSlN8GDnWO8CtiTGM3etybC5+o6nyQciSt3aJ6TbUc47hewYQYoIL/Vct+v?=
 =?us-ascii?Q?Y1eoOSncMMe4EaAXLlkgKFfrASxsgCfWVZsQnjaUSh+l0ATesceaKMp8gvHq?=
 =?us-ascii?Q?8bCqMsht3BejuV9qWrP3HgTGEE3iTS2hVsT7vZZ63ryhIDGev3RvG0pH6ilz?=
 =?us-ascii?Q?NT8Iux3EY4sDGOEtZCoixH0epV0+dMbRbcKVHkQURqhRsEYp/pfQ+nyk0ifH?=
 =?us-ascii?Q?oqV93sNSK6pVkmn1kaoz0Tk7U6QVGwtmn6TJRvGP+RlXIgSJI60XdjfHb8K/?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed3da86-81b3-480e-c31f-08d9ba235b07
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 08:18:46.6250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uw19dMK4VTtGDz9T97KWi8sIoOQcSxu3rxT1G4eOciy+zx+J9h0v3dhq33/Ejr1r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4610
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 2zpRwxnu9Fwoi2vekHBjMO0WF7_s7HiY
X-Proofpoint-ORIG-GUID: 2zpRwxnu9Fwoi2vekHBjMO0WF7_s7HiY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 adultscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080055
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:48:53PM +0100, Daniel Borkmann wrote:
> On 12/7/21 3:27 PM, Willem de Bruijn wrote:
> > On Mon, Dec 6, 2021 at 9:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > 
> > > The skb->tstamp may be set by a local sk (as a sender in tcp) which then
> > > forwarded and delivered to another sk (as a receiver).
> > > 
> > > An example:
> > >      sender-sk => veth@netns =====> veth@host => receiver-sk
> > >                               ^^^
> > >                          __dev_forward_skb
> > > 
> > > The skb->tstamp is marked with a future TX time.  This future
> > > skb->tstamp will confuse the receiver-sk.
> > > 
> > > This patch marks the skb if the skb->tstamp is forwarded.
> > > Before using the skb->tstamp as a rx timestamp, it needs
> > > to be re-stamped to avoid getting a future time.  It is
> > > done in the RX timestamp reading helper skb_get_ktime().
> > > 
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >   include/linux/skbuff.h | 14 +++++++++-----
> > >   net/core/dev.c         |  4 +++-
> > >   net/core/skbuff.c      |  6 +++++-
> > >   3 files changed, 17 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index b609bdc5398b..bc4ae34c4e22 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -867,6 +867,7 @@ struct sk_buff {
> > >          __u8                    decrypted:1;
> > >   #endif
> > >          __u8                    slow_gro:1;
> > > +       __u8                    fwd_tstamp:1;
> > > 
> > >   #ifdef CONFIG_NET_SCHED
> > >          __u16                   tc_index;       /* traffic control index */
> > > @@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(struct sk_buff *skb,
> > >   }
> > > 
> > >   void skb_init(void);
> > > +void net_timestamp_set(struct sk_buff *skb);
> > > 
> > > -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
> > > +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
> > >   {
> > > +       if (unlikely(skb->fwd_tstamp))
> > > +               net_timestamp_set(skb);
> > >          return ktime_mono_to_real_cond(skb->tstamp);
> > 
> > This changes timestamp behavior for existing applications, probably
> > worth mentioning in the commit message if nothing else. A timestamp
> > taking at the time of the recv syscall is not very useful.
> > 
> > If a forwarded timestamp is not a future delivery time (as those are
> > scrubbed), is it not correct to just deliver the original timestamp?
> > It probably was taken at some earlier __netif_receive_skb_core.
> > 
> > >   }
> > > 
> > > -static inline void net_timestamp_set(struct sk_buff *skb)
> > > +void net_timestamp_set(struct sk_buff *skb)
> > >   {
> > >          skb->tstamp = 0;
> > > +       skb->fwd_tstamp = 0;
> > >          if (static_branch_unlikely(&netstamp_needed_key))
> > >                  __net_timestamp(skb);
> > >   }
> > > +EXPORT_SYMBOL(net_timestamp_set);
> > > 
> > >   #define net_timestamp_check(COND, SKB)                         \
> > >          if (static_branch_unlikely(&netstamp_needed_key)) {     \
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index f091c7807a9e..181ddc989ead 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
> > >   {
> > >          struct sock *sk = skb->sk;
> > > 
> > > -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
> > > +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
> > 
> > There is a slight race here with the socket flipping the feature on/off.
> > 
> > >                  skb->tstamp = 0;
> > > +               skb->fwd_tstamp = 0;
> > > +       } else if (skb->tstamp) {
> > > +               skb->fwd_tstamp = 1;
> > > +       }
> > 
> > SO_TXTIME future delivery times are scrubbed, but TCP future delivery
> > times are not?
> > 
> > If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
> > scrub based on that. That is also not open to the above race.
> 
> One other thing I wonder, BPF progs at host-facing veth's tc ingress which
> are not aware of skb->tstamp will then see a tstamp from future given we
> intentionally bypass the net_timestamp_check() and might get confused (or
> would confuse higher-layer application logic)? Not quite sure yet if they
> would be the only affected user.
Considering the variety of clock used in skb->tstamp (real/mono, and also
tai in SO_TXTIME),  in general I am not sure if the tc-bpf can assume anything
in the skb->tstamp now.
Also, there is only mono clock bpf_ktime_get helper, the most reasonable usage
now for tc-bpf is to set the EDT which is in mono.  This seems to be the
intention when the __sk_buff->tstamp was added.
For ingress, it is real clock now.  Other than simply printing it out,
it is hard to think of a good way to use the value.  Also, although
it is unlikely, net_timestamp_check() does not always stamp the skb.

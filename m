Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2267146CF01
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbhLHIeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:34:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55662 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231669AbhLHIeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:34:07 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B80Gh2q002225;
        Wed, 8 Dec 2021 00:30:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=e0+P+OzK/N/cmXGvOFzYPf23Vc5rnJcCT3mVCGkAWo0=;
 b=EOuR18hNzNZa8A2bJtXleIUjHcMkDFrgMGlaXwKe2rz9xViy1tWYUSne0bREBRRv6jlb
 ckZRwcc3VfFLWj7yl6ZSWs9NXLtEaEw6CJ/GqA0by/3JypR0zayPiepmAvyPWCRI+04r
 k6YrbkYACO30IJSVEJkhBaU+vk9rr8g3C4c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ctj12j552-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Dec 2021 00:30:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 00:30:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDzn+bw1KYzNThQtnD6xtFdNoav8Um3x/xM38Zrj30mr53RCNPK+d0mquPsDZOKUcPGWCuthVh0dY4tNypXbcywxL0MWhCxLrHADmmntHXaVCKrg2IFdk5B1gjc93HHVQToA1zZ38gn/8p/yiMIOZn4jRKsksNOYwn+oGTSrWzvi1n/cnFwucUJgka492ULipKgCqzgqg6tCd6XRgenRRNEReTpkiAmnwR5O3exQ46+NWFstiCrxNeVmLocXWYVJ4M7E3FrILmUavcuAQcTpSKIAAYoyI7xL1zK34K7KIQympBhn8xVNTfbJkVjvuUb3/s5Dj1wpMwPPAQV2NpjSag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e0+P+OzK/N/cmXGvOFzYPf23Vc5rnJcCT3mVCGkAWo0=;
 b=kLETAch8mckQuLTqBxgPJAA3iNBJs2PchNhx54KSjwQ6HubX2pcQA0BF2WEhK3YNNA35bsGOf04WleAIClra0ksf4/rD3FzfAZsv5Pp5SnrYJRyxpwW8lad+Ok3VQMFbWw3f/TD8ro1GPLYcN3CS1Eg7TEVHxxyBmziXzopye33JxjNmTszgAUZARL8pQOi8sGXKZdunnoEbDJR1DwjKPIF0shprkb4iHsH+nZcT9JqLJpU8z6/BtRuW22BceFm51jKSJOOBft2kZ1WCgV7nNuoKWx6Tg809CIPzpiZB+jXPEa/il6guVC6tbjGinU8mK5I9rLcPYvgndI1cBC4/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5045.namprd15.prod.outlook.com (2603:10b6:806:1d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 08:30:17 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 08:30:17 +0000
Date:   Wed, 8 Dec 2021 00:30:13 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MWHPR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:300:16::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4a0c) by MWHPR13CA0009.namprd13.prod.outlook.com (2603:10b6:300:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 08:30:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e37536a-8639-4acd-1210-08d9ba24f699
X-MS-TrafficTypeDiagnostic: SA1PR15MB5045:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB50454AFF1B78464F2CA8F588D56F9@SA1PR15MB5045.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +H9vvSJrue2XYYlHJOsH4Dp8XfOm1WWMAlbtDaiFxFezSGRBrady3b4aUm0l8MM8bHRi1ObRpegE6L8MmgeyfWLeQICqt1TUmR/7zg+kPhFux4YBkxLVuTCLNs27WmL6YJlzuPKQwY8W4ohZF4D8eGN2mA6LFJbDmuhItnKQB6QYZj79MZooxf0frRQNV0rH5+8Y0qttobkiZigXYCQug+inCN70gi/k7SHe4zDMLGr9ZNPsXsq7PZoiJXT4CMRC8AfgswLZ05fNX+6Qh6GPYGzFIwDkuXJ6SLUsEMbLhk1vYyT7uPDof5HpUHmA36HZHTDUqzIyIjbUbOkgvoqCBoxeT2QueKUKaabfkCw+S3CHD27HFtBLYlxAPo0LfvbL5WLKEk/qKePxijQKT9TK9SWFwW7dGgA7DBYE7vE7wdkv2est55BoRPN0m+lPUoP2q7TtwzSkXNK5bOVpQOKvqUq3OI47GMgTcBomo5Cyn9yiamy4fOTmakOewtTDrq+HwFsfY0AVEMLOJvqiD7rojOHGQpDvKA4fVcz96Gm1QUmD78MKnRD8A8qmLMGhC7/9BlUd/Vp2Vbb71ZqAb7Tne9q2k54ypC9TiytOn44WSFbaUsbVAcYFV7E3Z73CE6zsdOtwzwP9Bzg4JXuV405OFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(1076003)(52116002)(7696005)(6506007)(5660300002)(55016003)(53546011)(83380400001)(186003)(66476007)(66556008)(508600001)(8676002)(316002)(9686003)(66946007)(86362001)(54906003)(38100700002)(6666004)(8936002)(6916009)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ngd9pnDkqldXO9T9P3GWnkOBQM6r4GWjvwvy/tHsAmBZ13alZt6YNSsxhDR5?=
 =?us-ascii?Q?E8rT4cQK0WVDfJG2hPdeImQJHTzj5Oz3okB39KwegYCcRectdlkgrqTi44Z0?=
 =?us-ascii?Q?w2/dE60VYsqzS+IQ7+crxf+AzJuarpxafsg60yaeIkwTopVS5Lsa7Isj2EUB?=
 =?us-ascii?Q?HS0SL6dn0o1MKkpdwWVRLFoRh2bb711UDr/zuJa+HZ6YfT3OIavrFAVpEz5q?=
 =?us-ascii?Q?hu63Pe9mk2wTkXdL0e5LtK5LjBnPooBDgWgYc0ufYWnTk+m8tY8lQMILMF7f?=
 =?us-ascii?Q?dzPHvAMOWTVPAQKXuWF1ykDYB4c9YPLp+05cenDmDcp6So+pM1bVC8WpC3jq?=
 =?us-ascii?Q?LrvfM+LX/amYp2nl5immzZntJGG8Fnj57qy/UO0sB63Y8c29h6yADyl8cwt6?=
 =?us-ascii?Q?+fSi1OEL4lqytYcBV7x/xgWewFvenW7rpPCAaDHE+Nrt1d1YXRMGJ1qsGsq/?=
 =?us-ascii?Q?vwEFdlnfSqpXXxMSmNPqqLBey1AaSS9cCZkOyknxkLA/SFQx06aq4a8LM4/y?=
 =?us-ascii?Q?GKNKQjUPANLsdyG0LfyoQUupGeHjBuEgMQshfnWziUoyA6pJAc9q2IIhbZNK?=
 =?us-ascii?Q?0C+2FR+7b0xGLzT9WZTfL3gjEMOnnMhpD8UAjkQ/xKXWUn6tXHOK6n2at/Pw?=
 =?us-ascii?Q?1zbOYhJnLLpbhIz25DkqAw0K5cBUOsjAUpA6mQjGQ/Yp6qrizxYgPcgtu2T3?=
 =?us-ascii?Q?Xv8FJva9ZP0IG9J7AuoP7qmFgR9oSBUQxThK9MiSj/ThsmN04vN2hlSgQ4U2?=
 =?us-ascii?Q?EiK/pCi72zGO0FWfhsKEKOBQw9mxA0RbDgAvT0u1oCZ4EVCMNdsWGpJdR0g6?=
 =?us-ascii?Q?OCAvTMZBy0C71DK/dx+MXbEJLzCDpeqjElQ4voBtRRV/xgncPcdd8ZjWSVuG?=
 =?us-ascii?Q?5+YmYUsIhiV6UpM9kpycOEJp/W1VGPQym3yY2JvDG/Cu6y2kcgcjW3vpyFJs?=
 =?us-ascii?Q?tnux/NaKL2a90+Ae+gdeIlORcm9QhUYhkzzVzZ4m3p43asPpxGF4hvHflXvI?=
 =?us-ascii?Q?+q5rOEDsNpOJq+y9QuMaz5JCGEUPi4cnlTzfvWX0GwD/CKcxEs6hdDeRUFO+?=
 =?us-ascii?Q?IhtvOoP2WgZa3V4CSg63GhkXX5jYRazzWgpOk2olomocHekEU0la7UnNIGDB?=
 =?us-ascii?Q?Kk/dbZNdT14yYZHucDT0vDPDVyeA3ZJMZRSpVjU2xyCKtD5SrnUPlCQXZ6qZ?=
 =?us-ascii?Q?k8b3X3syU+6MqaLzHSg9RZ06Hd4JB/Ujo1nOuFEzatYoIS7OSNyafZSG43pQ?=
 =?us-ascii?Q?wUjXkVgsl9vBRmnCwMIwHgevjwMmtmokdyrXtNf5i7firVP+FPDH0yGSAJsO?=
 =?us-ascii?Q?zf19tqypFITDaghd16GY/D2g+9KujC+X/Di7cc9hOn+jJEczrbgG9A5hISyf?=
 =?us-ascii?Q?ysiD1ksj7L+qLiHelLhbzKN46HkXborbNNKbwiizrrLgxAdhN6KWJ4QJKhFH?=
 =?us-ascii?Q?dhilAnAjH50hPJcoASjEamL1qh9dC7Wr0SfNV39kifhHiMiCJx+J/ELbglps?=
 =?us-ascii?Q?StZfvdpPft+0Db4wtyFSDVFzDrQQMm8Yr8ZBg6UPL4VPNuSu5ucPCZvHGuTy?=
 =?us-ascii?Q?uorCekZzfiki0RxXdSpCfTUaZg7OKKfw/AZuFFEVUJ/1uk8XmvPWvEeww0Xb?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e37536a-8639-4acd-1210-08d9ba24f699
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 08:30:17.0074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LyrcoAI6W0guZMn3JfN0F2D1PWsKYtngUmRC+GnEk5MRifuHYDWbQnhmnNwvJeCp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5045
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: fbvQvWqMC9VM1uEFqDSK4HG6oBGYHN83
X-Proofpoint-ORIG-GUID: fbvQvWqMC9VM1uEFqDSK4HG6oBGYHN83
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

On Wed, Dec 08, 2021 at 12:18:46AM -0800, Martin KaFai Lau wrote:
> On Tue, Dec 07, 2021 at 10:48:53PM +0100, Daniel Borkmann wrote:
> > On 12/7/21 3:27 PM, Willem de Bruijn wrote:
> > > On Mon, Dec 6, 2021 at 9:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > 
> > > > The skb->tstamp may be set by a local sk (as a sender in tcp) which then
> > > > forwarded and delivered to another sk (as a receiver).
> > > > 
> > > > An example:
> > > >      sender-sk => veth@netns =====> veth@host => receiver-sk
> > > >                               ^^^
> > > >                          __dev_forward_skb
> > > > 
> > > > The skb->tstamp is marked with a future TX time.  This future
> > > > skb->tstamp will confuse the receiver-sk.
> > > > 
> > > > This patch marks the skb if the skb->tstamp is forwarded.
> > > > Before using the skb->tstamp as a rx timestamp, it needs
> > > > to be re-stamped to avoid getting a future time.  It is
> > > > done in the RX timestamp reading helper skb_get_ktime().
> > > > 
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >   include/linux/skbuff.h | 14 +++++++++-----
> > > >   net/core/dev.c         |  4 +++-
> > > >   net/core/skbuff.c      |  6 +++++-
> > > >   3 files changed, 17 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > > index b609bdc5398b..bc4ae34c4e22 100644
> > > > --- a/include/linux/skbuff.h
> > > > +++ b/include/linux/skbuff.h
> > > > @@ -867,6 +867,7 @@ struct sk_buff {
> > > >          __u8                    decrypted:1;
> > > >   #endif
> > > >          __u8                    slow_gro:1;
> > > > +       __u8                    fwd_tstamp:1;
> > > > 
> > > >   #ifdef CONFIG_NET_SCHED
> > > >          __u16                   tc_index;       /* traffic control index */
> > > > @@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(struct sk_buff *skb,
> > > >   }
> > > > 
> > > >   void skb_init(void);
> > > > +void net_timestamp_set(struct sk_buff *skb);
> > > > 
> > > > -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
> > > > +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
> > > >   {
> > > > +       if (unlikely(skb->fwd_tstamp))
> > > > +               net_timestamp_set(skb);
> > > >          return ktime_mono_to_real_cond(skb->tstamp);
> > > 
> > > This changes timestamp behavior for existing applications, probably
> > > worth mentioning in the commit message if nothing else. A timestamp
> > > taking at the time of the recv syscall is not very useful.
> > > 
> > > If a forwarded timestamp is not a future delivery time (as those are
> > > scrubbed), is it not correct to just deliver the original timestamp?
> > > It probably was taken at some earlier __netif_receive_skb_core.
> > > 
> > > >   }
> > > > 
> > > > -static inline void net_timestamp_set(struct sk_buff *skb)
> > > > +void net_timestamp_set(struct sk_buff *skb)
> > > >   {
> > > >          skb->tstamp = 0;
> > > > +       skb->fwd_tstamp = 0;
> > > >          if (static_branch_unlikely(&netstamp_needed_key))
> > > >                  __net_timestamp(skb);
> > > >   }
> > > > +EXPORT_SYMBOL(net_timestamp_set);
> > > > 
> > > >   #define net_timestamp_check(COND, SKB)                         \
> > > >          if (static_branch_unlikely(&netstamp_needed_key)) {     \
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index f091c7807a9e..181ddc989ead 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
> > > >   {
> > > >          struct sock *sk = skb->sk;
> > > > 
> > > > -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
> > > > +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
> > > 
> > > There is a slight race here with the socket flipping the feature on/off.
> > > 
> > > >                  skb->tstamp = 0;
> > > > +               skb->fwd_tstamp = 0;
> > > > +       } else if (skb->tstamp) {
> > > > +               skb->fwd_tstamp = 1;
> > > > +       }
> > > 
> > > SO_TXTIME future delivery times are scrubbed, but TCP future delivery
> > > times are not?
> > > 
> > > If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
> > > scrub based on that. That is also not open to the above race.
> > 
> > One other thing I wonder, BPF progs at host-facing veth's tc ingress which
> > are not aware of skb->tstamp will then see a tstamp from future given we
> > intentionally bypass the net_timestamp_check() and might get confused (or
> > would confuse higher-layer application logic)? Not quite sure yet if they
> > would be the only affected user.
> Considering the variety of clock used in skb->tstamp (real/mono, and also
> tai in SO_TXTIME),  in general I am not sure if the tc-bpf can assume anything
> in the skb->tstamp now.
> Also, there is only mono clock bpf_ktime_get helper, the most reasonable usage
> now for tc-bpf is to set the EDT which is in mono.  This seems to be the
> intention when the __sk_buff->tstamp was added.
> For ingress, it is real clock now.  Other than simply printing it out,
> it is hard to think of a good way to use the value.  Also, although
> it is unlikely, net_timestamp_check() does not always stamp the skb.
For non bpf ingress, hmmm.... yeah, not sure if it is indeed an issue :/
may be save the tx tstamp first and then temporarily restamp with __net_timestamp()

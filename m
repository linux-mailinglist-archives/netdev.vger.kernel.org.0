Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0318E37B663
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELG5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 02:57:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29648 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhELG53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 02:57:29 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210512065618epoutp013893281ee04da37e1734382f0707b611~_P1uugj7r2385023850epoutp01Q
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 06:56:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210512065618epoutp013893281ee04da37e1734382f0707b611~_P1uugj7r2385023850epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620802578;
        bh=7i2CDfHh137h+0Yx+khzYwntcbYdWTB26Lu9nlZudh4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Ae2NGZhkI7cQVBwRAgJl5STBwV+NQWfS5pHFmHlV8y/P/5gB9UsoXFiiz0bQX5SIF
         E/+Dm+/6stnKyDSNB8imPIvbj0qFdsi7Bk6iJSrrkgNDdMXpkHDHg55sSraRB1ndSO
         GjnGjR3LnuQtS4IdOkEs/m8KXbzN32DjJfq7QCS0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210512065618epcas2p43982d5a56d45cc068550a73d4dfd2fd7~_P1uSMLnC2509925099epcas2p4f;
        Wed, 12 May 2021 06:56:18 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Fg5DH4Glwz4x9QP; Wed, 12 May
        2021 06:56:15 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.54.09433.F0C7B906; Wed, 12 May 2021 15:56:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210512065615epcas2p1d961fcba48fe698b44705cc599b4eb85~_P1rJWL3P2548025480epcas2p1f;
        Wed, 12 May 2021 06:56:15 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210512065615epsmtrp18759fa2574faf0aa6011c3431e47fa25~_P1rIchAI3249932499epsmtrp17;
        Wed, 12 May 2021 06:56:15 +0000 (GMT)
X-AuditID: b6c32a47-f4bff700000024d9-ad-609b7c0fa027
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.74.08163.E0C7B906; Wed, 12 May 2021 15:56:14 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210512065614epsmtip25e0ca34a0b60b77c7b76f9248dd550d4~_P1q8OGKz1561715617epsmtip2I;
        Wed, 12 May 2021 06:56:14 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'bpf'" <bpf@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF=yD-+8676QHiKD2ZA4e0kVE+11cOi6sa+M-vmx0+05tm1GfQ@mail.gmail.com>
Subject: RE: [PATCH bpf v2] bpf: check BPF_F_ADJ_ROOM_FIXED_GSO when
 upgrading mss in 6 to 4
Date:   Wed, 12 May 2021 15:56:14 +0900
Message-ID: <01f901d746fb$e683ec60$b38bc520$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGn2ZQLsozVdio9CgO6qPhknutQhgG+YoocAZxTHfABt+AtLasVriFg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmhS5/zewEg+4JMhbff89mtvjy8za7
        xecjx9ksFi/8xmwx53wLi0XTjhVMFi8+PGG0eL6vl8niwrY+VovLu+awWRxbIGbx8/AZZovF
        PzcAVSyZwejA57Fl5U0mj4nN79g9ds66y+7RdeMSs8emVZ1sHp83yQWwReXYZKQmpqQWKaTm
        JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdq6RQlphTChQKSCwuVtK3
        synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMlY8eEQe8FxxYq/
        7UfYGhjXS3QxcnJICJhI7H54iKmLkYtDSGAHo8TBu/uYIZxPjBJbtn9gg3A+M0qs2fWVDabl
        2Nf3UFW7GCWadk2EqnrBKDFj63d2kCo2AS2JN7PaWUFsEQErif+zT7CDFDELTGORWH5/BQtI
        glMgUGJax00mEFtYIE5i9/dzYCtYBFQlrp2ZB1bDK2ApsftKJyOELShxcuYTsDizgLzE9rdz
        mCFOUpD4+XQZ1DI3iYnHp0DViEjM7mwDO1VC4AKHxKUpR6F+cJF4sPwTE4QtLPHq+BZ2CFtK
        4mV/G5DNAWTXS7R2x0D09jBKXNkHsVhCwFhi1rN2RpAaZgFNifW79CHKlSWO3IJayyfRcfgv
        1BReiY42IQhTSWLil3iIGRISL05OZpnAqDQLyV+zkPw1C8n9sxBWLWBkWcUollpQnJueWmxU
        YIwc2ZsYwSlZy30H44y3H/QOMTJxMB5ilOBgVhLhFUuanSDEm5JYWZValB9fVJqTWnyI0RQY
        0hOZpUST84FZIa8k3tDUyMzMwNLUwtTMyEJJnPdnal2CkEB6YklqdmpqQWoRTB8TB6dUA1Pt
        EiH27V0t9rLXjmnkBnVz+Cf2LSo22bzJ5qb+Gt4fKXwu7469a239P/9Y48QZhZLsiZb1iX9u
        5ZW+5hYpdWKe1r9xcsft3Zv8n+z+8OLSe8nPF5+9WnDI/fd54adaNX8sauQNP5ncvmgXdUX2
        Xp/qjhcNZa7f6pdo5O3x/C3puCx/7ZmqmFsSvW62HwVqbI7OCI0p/9H2bP6hlq+LO6L+pDaK
        G3qstzrzv80rKHuddmbTWgHLDVq5Isks/QVmz441zInnSf49L41lQ6/m9rKqvEuLdTvNYqK9
        Coz2tE/+aSAYPz3jUNg3jfbzP68ZfKm6cW8ap9hFhleJ2XWHa0UWaAVdbufcpRT4bobvTSWW
        4oxEQy3mouJEALfOm6BSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWy7bCSvC5fzewEgyVnrSy+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hszi2QMzi5+EzzBaL
        f24Aqlgyg9GBz2PLyptMHhOb37F77Jx1l92j68YlZo9NqzrZPD5vkgtgi+KySUnNySxLLdK3
        S+DKWPHhEHvBccWKv+1H2BoY10t0MXJySAiYSBz7+p65i5GLQ0hgB6PE6Y3nGbsYOYASEhK7
        NrtC1AhL3G85wgpR84xR4tqn8ywgCTYBLYk3s9pZQWwRASuJ/7NPsIMUMQssYJHoeDSJHaJj
        CpPE/GurmECqOAUCJaZ13ASzhQViJJq6l4B1swioSlw7Mw9sKq+ApcTuK52MELagxMmZT8Di
        zALaEr0PWxkhbHmJ7W/nMEOcpyDx8+kyqCvcJCYenwJVLyIxu7ONeQKj8Cwko2YhGTULyahZ
        SFoWMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjk8trR2Me1Z90DvEyMTBeIhR
        goNZSYRXLGl2ghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTByc
        Ug1M1mubn0rt8AzsfLtM0k1Ns2hVQ30Iu+8bZbaNZo/ynqX8eW0g7lR4qcb4Bgv3ukr+pudK
        Fvn/J//KEtvGxFEvP2H7HamZ3xNmvvWs2bkvL8T9r7KW4CsW3Qa78kO+vU8+Hr1npRjI6zRj
        jcqEc+m2Nqv3v1das/f+N8Wtuy/ohca+ubv9eG1u/rdilfk3pqyTuHlpqxW/pvTWk+2JBzkO
        NrZfPVHBdDdq4pr9KbLGic3P6r88PXra3SGSK6lt/dm5tdPFlz+fF3iUL02dYXL3vPnzQ5OU
        zobdt710xvr1zQddTJWz0hly5U6tt1wyRbjAvL3m3X5ejbRFUju3vXt38byH5Dv5qo/xjbEC
        Jtf2KrEUZyQaajEXFScCAJGP10Y+AwAA
X-CMS-MailID: 20210512065615epcas2p1d961fcba48fe698b44705cc599b4eb85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0
References: <CGME20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0@epcas2p1.samsung.com>
        <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <1620714998-120657-1-git-send-email-dseok.yi@samsung.com>
        <CAF=yD-+8676QHiKD2ZA4e0kVE+11cOi6sa+M-vmx0+05tm1GfQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 01:42:46PM -0400, Willem de Bruijn wrote:
> On Tue, May 11, 2021 at 2:51 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
> > coalesced packet payload can be > MSS, but < MSS + 20.
> > bpf_skb_proto_6_to_4 will increase the MSS and it can be > the payload
> > length. After then tcp_gso_segment checks for the payload length if it
> > is <= MSS. The condition is causing the packet to be dropped.
> >
> > tcp_gso_segment():
> >         [...]
> >         mss = skb_shinfo(skb)->gso_size;
> >         if (unlikely(skb->len <= mss))
> >                 goto out;
> >         [...]
> >
> > Allow to increase MSS when BPF_F_ADJ_ROOM_FIXED_GSO is not set.
> >
> > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> >
> > ---
> 
> Thanks. Note that this feature does not preclude the alternatives
> discussed, of converting the packet to non-TSO (by clearing gso_size)
> or optionally modifying MSS (but that should get okay from TCP
> experts).
> 
> I would target this for bpf-next and drop the Fixes. But that is
> admittedly debatable.

No problem. We can make a better decision under bpf-next.

> 
> >  net/core/filter.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > v2:
> > per Willem de Bruijn request,
> > checked the flag instead of a generic approach.
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index cae56d0..a98b28d 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3276,7 +3276,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
> >         return 0;
> >  }
> >
> > -static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > +static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
> >  {
> >         const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
> >         u32 off = skb_mac_header_len(skb);
> > @@ -3305,7 +3305,8 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> >                 }
> >
> >                 /* Due to IPv4 header, MSS can be upgraded. */
> > -               skb_increase_gso_size(shinfo, len_diff);
> > +               if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
> > +                       skb_increase_gso_size(shinfo, len_diff);
> >                 /* Header must be checked, and gso_segs recomputed. */
> >                 shinfo->gso_type |= SKB_GSO_DODGY;
> >                 shinfo->gso_segs = 0;
> > @@ -3317,7 +3318,7 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> >         return 0;
> >  }
> >
> > -static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
> > +static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u64 flags)
> >  {
> >         __be16 from_proto = skb->protocol;
> >
> > @@ -3327,7 +3328,7 @@ static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
> >
> >         if (from_proto == htons(ETH_P_IPV6) &&
> >               to_proto == htons(ETH_P_IP))
> > -               return bpf_skb_proto_6_to_4(skb);
> > +               return bpf_skb_proto_6_to_4(skb, flags);
> >
> >         return -ENOTSUPP;
> >  }
> > @@ -3337,7 +3338,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
> >  {
> >         int ret;
> >
> > -       if (unlikely(flags))
> > +       if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
> >                 return -EINVAL;
> 
> Once allowing this flag, please immediately support it for both
> bpf_skb_proto_6_to_4 and bpf_skb_4_to_6.
> 
> We cannot do that later if we ignore the second case now.

I will make v3 for both 6_to_4 and 4_to_6.

> 
> 
> >         /* General idea is that this helper does the basic groundwork
> > @@ -3357,7 +3358,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
> >          * that. For offloads, we mark packet as dodgy, so that headers
> >          * need to be verified first.
> >          */
> > -       ret = bpf_skb_proto_xlat(skb, proto);
> > +       ret = bpf_skb_proto_xlat(skb, proto, flags);
> >         bpf_compute_data_pointers(skb);
> >         return ret;
> >  }
> > --
> > 2.7.4
> >


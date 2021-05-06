Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A904B374D83
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 04:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhEFC2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 22:28:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53958 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhEFC2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 22:28:48 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210506022749epoutp03d8a1cf830cc4b867c23af7551523b487~8WTl0dOCG2451224512epoutp03j
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 02:27:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210506022749epoutp03d8a1cf830cc4b867c23af7551523b487~8WTl0dOCG2451224512epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620268069;
        bh=u/oFc+RysAcbNw7YBahwmspRG76JwCdAvRU5YZymBtQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=mv72/qx6upbyf+Ci1uVmZupfffIgESs0Yx2cPbh6PLqRedP0DDybU17fFGDHp2WsK
         OYlRrCJQRwI37I4NCC7JXYObRGD8l36dgvzwCMV19r7XGIQrECL/faENtmUTv199MZ
         Bd1IMuNag5zEPyA9RLqmze721vp0tUCuqgc3g9ig=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210506022748epcas2p1610e9e45315dba4e420e0e5ec7537405~8WTlPMEpu1397613976epcas2p1B;
        Thu,  6 May 2021 02:27:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FbHYG2K7Zz4x9Py; Thu,  6 May
        2021 02:27:46 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.6F.09694.12453906; Thu,  6 May 2021 11:27:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210506022744epcas2p1207466493a0e0da9d4ee6c14e1182242~8WThDuF8-1656616566epcas2p10;
        Thu,  6 May 2021 02:27:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210506022744epsmtrp11024c10fdd7d1a791bd0e1c772001a60~8WThCwYcr2275722757epsmtrp1a;
        Thu,  6 May 2021 02:27:44 +0000 (GMT)
X-AuditID: b6c32a46-e17ff700000025de-73-609354217f03
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.85.08163.F1453906; Thu,  6 May 2021 11:27:43 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210506022743epsmtip10680df7c93430fe8d7f9f3eff2744b4d~8WTgzxUwN2316123161epsmtip1S;
        Thu,  6 May 2021 02:27:43 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'bpf'" <bpf@vger.kernel.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Thu, 6 May 2021 11:27:43 +0900
Message-ID: <02c801d7421f$65287a90$2f796fb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYqN8+O7A=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmqa5iyOQEg9NdEhbff89mtvjy8za7
        xecjx9ksFi/8xmwx53wLi0XTjhVMFi8+PGG0eL6vl8niwrY+VovLu+awWRxbIGbx8/AZZovF
        PzcAVSyZwejA57Fl5U0mj4nN79g9ds66y+7RdeMSs8emVZ1sHp83yQWwReXYZKQmpqQWKaTm
        JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdq6RQlphTChQKSCwuVtK3
        synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMm4cr2PuWCBUsW5
        HSsYGxgnSnYxcnJICJhIPF47k72LkYtDSGAHo8SsGQvYQBJCAp8YJea9d4VIfGaUODtpOjtM
        R+u0LYwQiV2MEn/XTWCBcF4wSmxd0QpWxSagJfFmVjsriC0iYCXxf/YJsDizwDwWibZTIiA2
        p0CgxO5ZP5hBbGGBYImnk5qYuhg5OFgEVCQ2XHUBCfMKWEp0b97MDmELSpyc+YQFYoy8xPa3
        c5ghDlKQ+Pl0GStEXERidmcbM8RaP4nHjz5CHX2BQ+Lb2giQ8RICLhIHlrBAhIUlXh3fAlUi
        JfGyv40doqReorU7BuQrCYEeRokr+55A1RtLzHrWzghSwyygKbF+lz5EubLEkVtQh/FJdBz+
        CzWFV6KjTQjCVJKY+CUeYoaExIuTk1kmMCrNQvLVLCRfzULyySyEVQsYWVYxiqUWFOempxYb
        FRghx/MmRnAi1nLbwTjl7Qe9Q4xMHIyHGCU4mJVEeAvW9icI8aYkVlalFuXHF5XmpBYfYjQF
        BvNEZinR5HxgLsgriTc0NTIzM7A0tTA1M7JQEuf9mVqXICSQnliSmp2aWpBaBNPHxMEp1cBk
        t3RFp/ouzwIxxXMHhPPuKmzuYvXbpxp7miMhzG/WWdesJ7+4jl/U1ZGYVGAwx9H2rfPJEM3X
        jxvYe2xEHuczS7UzTH/RlaoaqXvIdpHM3x0H3zLOSb853TRfgDH19+MPEX4+OXJvZs99u1Ty
        2NQdAapvWp/dm3nUyJrTdkP61WiZZy/Ktk0Q40/2c+N4sjV+9pIdZetuswh6/q1Ouy9wIPbk
        JsOZb+WtZV6s9Z0acnjpdJsnW040NbZdsVphrr/76sNCw/dKQQXv/nVLzfs50XahQ/+2k99/
        rF7A+/dfoj/z+xvLryakHv4VFuOu1lYqmcgpPUVGxlhkw94e3wm83BW/bc9+lV115MYeGdFa
        JZbijERDLeai4kQA79dojU0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCSnK5CyOQEg/fqFt9/z2a2+PLzNrvF
        5yPH2SwWL/zGbDHnfAuLRdOOFUwWLz48YbR4vq+XyeLCtj5Wi8u75rBZHFsgZvHz8Blmi8U/
        NwBVLJnB6MDnsWXlTSaPic3v2D12zrrL7tF14xKzx6ZVnWwenzfJBbBFcdmkpOZklqUW6dsl
        cGVcud7HXLBAqeLcjhWMDYwTJbsYOTkkBEwkWqdtYQSxhQR2MErs73LoYuQAiktI7NrsClEi
        LHG/5QhrFyMXUMkzoJLVm1lAEmwCWhJvZrWzgtgiAlYS/2efYAcpYhZYwSJxoOM9O0THXiaJ
        K1c/g1VxCgRK7J71gxnEFgay+//dYgTZxiKgIrHhqgtImFfAUqJ782Z2CFtQ4uTMJ2DLmAW0
        JXoftjJC2PIS29/OYYa4TkHi59NlrBBxEYnZnW3MEAf5STx+9JF9AqPwLCSjZiEZNQvJqFlI
        2hcwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOTC2tHYx7Vn3QO8TIxMF4iFGC
        g1lJhLdgbX+CEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxS
        DUzunKIp6Y2Mia6LOrPfOtxWNebcetf1TuWCtGqjiwzTps7cV+mb5fpkY3UEK+uU7mlqbb8/
        bluz4+SvfVl+PK+vvzG9GzT/vOTfDdYO7FeNfte1J+3WUNv2VcU+1D1tk5z0pFuO1Yxf120z
        a35h91cvy/6WEuf9JuuyadzTPV9POijOr/Jcx2/17Zc1FoXXtva93GzvvmN78pF4rxuiilPv
        iGg/Ob7EKdHtSnnJjFuVwkrqBzbdUWgQ7mmdb8HGLxJ1ri5x85pp/OdCrrClbpQMjm248mid
        2bYU84Wtk9lYJjPyas24EdPJ9mBuot35y1PNeAJv1c7kPur7bOrLlQfmLvxRKhce/vClbEed
        QpMSS3FGoqEWc1FxIgAgod7UOwMAAA==
X-CMS-MailID: 20210506022744epcas2p1207466493a0e0da9d4ee6c14e1182242
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
        <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
        <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
        <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 09:45:37PM -0400, Willem de Bruijn wrote:
> On Wed, May 5, 2021 at 8:45 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > On Wed, May 05, 2021 at 10:55:10PM +0200, Daniel Borkmann wrote:
> > > On 4/29/21 12:08 PM, Dongseok Yi wrote:
> > > > tcp_gso_segment check for the size of GROed payload if it is bigger
> > > > than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
> > > > bigger than the size of GROed payload unexpectedly if data_len is not
> > > > big enough.
> > > >
> > > > Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4
> 
> Is this a typo and is this intended to read skb->data_len = 1380?

This is not a typo. I intended skb->data_len = 8.

> 
> The issue is that payload length (1380) is greater than mss with ipv6
> (1372), but less than mss with ipv4 (1392).
> 
> I don't understand data_len = 8 or why the patch compares
> skb->data_len to len_diff (20).

skb_gro_receive():
        unsigned int len = skb_gro_len(skb);
        [...]
done:
        NAPI_GRO_CB(p)->count++;
        p->data_len += len;

head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
data_len could be 8 if server sent a small size packet and it is GROed
to head_skb.

Please let me know if I am missing something.

> 
> One simple solution if this packet no longer needs to be segmented
> might be to reset the gso_type completely.

I am not sure gso_type can be cleared even when GSO is needed.

> 
> In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> converting from IPv6 to IPv4, fixed gso will end up building packets
> that are slightly below the MTU. That opportunity cost is negligible
> (especially with TSO). Unfortunately, I see that that flag is
> available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> 
> 
> > > > would increse the gso_size to 1392. tcp_gso_segment will get an error
> > > > with 1380 <= 1392.
> > > >
> > > > Check for the size of GROed payload if it is really bigger than target
> > > > mss when increase mss.
> > > >
> > > > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > ---
> > > >   net/core/filter.c | 4 +++-
> > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 9323d34..3f79e3c 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > > >             }
> > > >
> > > >             /* Due to IPv4 header, MSS can be upgraded. */
> > > > -           skb_increase_gso_size(shinfo, len_diff);
> > > > +           if (skb->data_len > len_diff)
> > >
> > > Could you elaborate some more on what this has to do with data_len specifically
> > > here? I'm not sure I follow exactly your above commit description. Are you saying
> > > that you're hitting in tcp_gso_segment():
> > >
> > >          [...]
> > >          mss = skb_shinfo(skb)->gso_size;
> > >          if (unlikely(skb->len <= mss))
> > >                  goto out;
> > >          [...]
> >
> > Yes, right
> >
> > >
> > > Please provide more context on the bug, thanks!
> >
> > tcp_gso_segment():
> >         [...]
> >         __skb_pull(skb, thlen);
> >
> >         mss = skb_shinfo(skb)->gso_size;
> >         if (unlikely(skb->len <= mss))
> >         [...]
> >
> > skb->len will have total GROed TCP payload size after __skb_pull.
> > skb->len <= mss will not be happened in a normal GROed situation. But
> > bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> > hit an error condition.
> >
> > We should ensure the following condition.
> > total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> >
> > Due to
> > total GROed TCP payload = the original mss + skb->data_len
> > IPv6 size - IPv4 size = len_diff
> >
> > Finally, we can get the condition.
> > skb->data_len > len_diff
> >
> > >
> > > > +                   skb_increase_gso_size(shinfo, len_diff);
> > > > +
> > > >             /* Header must be checked, and gso_segs recomputed. */
> > > >             shinfo->gso_type |= SKB_GSO_DODGY;
> > > >             shinfo->gso_segs = 0;
> > > >
> >
> >


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A09377A1D
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 04:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhEJCXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 22:23:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21834 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhEJCXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 22:23:47 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210510022241epoutp04cc7d73580d610f47cf3a8fdc0c3dc44f~9k0QRXAzH0868908689epoutp04H
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:22:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210510022241epoutp04cc7d73580d610f47cf3a8fdc0c3dc44f~9k0QRXAzH0868908689epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620613361;
        bh=cPButctKmrrZXM/6u9WU7erJpLUuP4/V9hThU/X1pcU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=WK3X8wUS0oRqQlvvVz5rrb6okq+kXl7Nb+DsaZMml8bNUvd61msx9IfXMdoV3bG/y
         OXn90UIoqzsVyfuDpDAnEylq8uOX28jDYSsGDPY9Zw8JZiQ18K80isvS1nbHl36nNR
         L+NYg9v/MXDYocR8CyCUugqwSXTyF/5iqu7T24zg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210510022240epcas2p4b1b66080c026374e399ed3a45f178eaa~9k0P0M0Hh2259022590epcas2p4X;
        Mon, 10 May 2021 02:22:40 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FdlFW0zMrz4x9QV; Mon, 10 May
        2021 02:22:39 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.F3.09717.DE898906; Mon, 10 May 2021 11:22:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210510022237epcas2p2a55d3ec5b401627a2d82d60d31949618~9k0MhsQMi1757817578epcas2p2u;
        Mon, 10 May 2021 02:22:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210510022237epsmtrp1d35fec293ebcf05e6e8a39faa111129e~9k0MfqTfn2202122021epsmtrp1B;
        Mon, 10 May 2021 02:22:37 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-45-609898ed183d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.D8.08637.DE898906; Mon, 10 May 2021 11:22:37 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210510022237epsmtip1e337501ffcf70dc947e708fac3265eed~9k0MM2Qny2865128651epsmtip1L;
        Mon, 10 May 2021 02:22:37 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
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
In-Reply-To: <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Mon, 10 May 2021 11:22:36 +0900
Message-ID: <00c901d74543$57fa3620$07eea260$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYAiru3ucBq8RF2QKY6vTDAm6kVlUBadK04AMaqQ3GARiLayQDE+caW6hZCGpw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJsWRmVeSWpSXmKPExsWy7bCmue67GTMSDH7tZbT4/ns2s8WXn7fZ
        LT4fOc5msXjhN2aLOedbWCyadqxgsnjx4QmjxfN9vUwWF7b1sVpc3jWHzaLhLZfFsQViFj8P
        n2G2WPxzA1DVkhmMDvweW1beZPKY2PyO3WPnrLvsHi1H3rJ6dN24xOyxaVUnm8fnTXIB7FE5
        NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAZysplCXm
        lAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEqE3Iy
        7jyYxlzwzahi8cU+9gbGDrUuRk4OCQETiZ/zH7B2MXJxCAnsYJR4PeU2I4TziVHi783PUM43
        RokrXVPZYFr2NjWyQCT2MkpcmzyXDcJ5wSgx69ZaFpAqNgEtiTez2llBbBEBK4n/s0+wgxQx
        C5xmkXiy+hsTSIJTIFDi369P7CC2sECwxNNJTWBxFgFVifObJ4E18wpYSkxt2cAMYQtKnJz5
        BGwBs4C8xPa3c5ghTlKQ+Pl0GdgXIgJNjBLTW6czQRSJSMzubIMqesAhse87H4TtInG/4Skj
        hC0s8er4FnYIW0riZX8bkM0BZNdLtHbHgMyUEOgB+n8fxGIJAWOJWc/aGUFqmAU0Jdbv0oco
        V5Y4cgvqND6JjsN/oabwSnS0CUGYShITv8RDzJCQeHFyMssERqVZSP6aheSvWUjOn4WwagEj
        yypGsdSC4tz01GKjAhPkyN7ECE7SWh47GGe//aB3iJGJg/EQowQHs5IIr2jHtAQh3pTEyqrU
        ovz4otKc1OJDjKbAkJ7ILCWanA/ME3kl8YamRmZmBpamFqZmRhZK4rw/U+sShATSE0tSs1NT
        C1KLYPqYODilGpgU/fa/dDnx2N2zS7z6p/3HaNFSK57AeROkPtrNv+01Wzup/P6HHXyfdNkl
        Qu+1bg1a13xwwQzXw+81UmrFmEyEWlTen5Bc9fVE5if7n3XuZ1Yvcg13v5Pd4hK72/4oj2O+
        peDvgLJTMmsPrFMQD3ztt+FM+AepJ7Vsm7xPzQ/ijdy79dM31lmSZ39eaCo8/WO92tMreauN
        FQQuJFaWMixP2X4n/O/V4terHbsMmwoZPhyM+vNhQ1e33PdDz76wPdlyNO/Z1lVBpzJOf32Q
        L8p8dbHb1reBmne2ywjYn5F+XuZ3m/3aLSUmtncpvk83HWqbeTju8+I5Ts+mlPfM6l/nIPs+
        LXheFcvxh9aJcyZdVWIpzkg01GIuKk4EAE8RZyNbBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWy7bCSnO7bGTMSDE5+47f4/ns2s8WXn7fZ
        LT4fOc5msXjhN2aLOedbWCyadqxgsnjx4QmjxfN9vUwWF7b1sVpc3jWHzaLhLZfFsQViFj8P
        n2G2WPxzA1DVkhmMDvweW1beZPKY2PyO3WPnrLvsHi1H3rJ6dN24xOyxaVUnm8fnTXIB7FFc
        NimpOZllqUX6dglcGXceTGMu+GZUsfhiH3sDY4daFyMnh4SAicTepkaWLkYuDiGB3YwSWw8t
        Zexi5ABKSEjs2uwKUSMscb/lCCtEzTNGiY8H17GCJNgEtCTezGoHs0UErCT+zz7BDlLELHCV
        RWLzj2/MEB29bBJntk9hAqniFAiU+PfrEzuILQxk9/+7xQhiswioSpzfPAlsEq+ApcTUlg3M
        ELagxMmZT1hAbGYBbYneh62MELa8xPa3c5ghzlOQ+Pl0Gdh5IgJNjBLTW6czQRSJSMzubGOe
        wCg8C8msWUhmzUIyaxaSlgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJjVktz
        B+P2VR/0DjEycTAeYpTgYFYS4RXtmJYgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0
        xJLU7NTUgtQimCwTB6dUA9OewCt2DFpS8x/2Tj3v9FOW/+LZprV9j25Nj/S8e0KGub83eslJ
        LbNMlf4TXN28hXY1qhoSKxXDVCJWX7AU0WovW93dXqWqZpl78cnhpOzyP7r3XScGqVy8qy1/
        aLrJi5PnrZeLpkYGZFYKbar0e5a/6jIP61PZ65aqUUEiR14HsSuLMBhYX2fxTCsWy/prdOuc
        JrtbQNTjK8a8PNf/iEzuKqw1a32puLrlf+rJ4Ifvv/jGbfA+FxhyzX9dmPW2WsPPQZeNn7G9
        /Or+bE/v8cn9Dv+YXvn/NPQ8wbZTq/PzqY8ZU74yT1IPvF9ePG/iBheXiSvmJOoE5J/2VtY9
        06C8eBHrLiu2Twee8KnWKLEUZyQaajEXFScCAJ1amGxIAwAA
X-CMS-MailID: 20210510022237epcas2p2a55d3ec5b401627a2d82d60d31949618
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
        <02c801d7421f$65287a90$2f796fb0$@samsung.com>
        <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
        <001801d742db$68ab8060$3a028120$@samsung.com>
        <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
        <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
        <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
        <007001d7431a$96281960$c2784c20$@samsung.com>
        <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 09:50:03AM -0400, Willem de Bruijn wrote:
> On Fri, May 7, 2021 at 4:25 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > On Thu, May 06, 2021 at 09:53:45PM -0400, Willem de Bruijn wrote:
> > > On Thu, May 6, 2021 at 9:45 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > > >
> > > > On 2021/5/7 9:25, Willem de Bruijn wrote:
> > > > >>>> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> > > > >>>> data_len could be 8 if server sent a small size packet and it is GROed
> > > > >>>> to head_skb.
> > > > >>>>
> > > > >>>> Please let me know if I am missing something.
> > > > >>>
> > > > >>> This is my understanding of the data path. This is a forwarding path
> > > > >>> for TCP traffic.
> > > > >>>
> > > > >>> GRO is enabled and will coalesce multiple segments into a single large
> > > > >>> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> > > > >>> + 20.
> > > > >>>
> > > > >>> Somewhere between GRO and GSO you have a BPF program that converts the
> > > > >>> IPv6 address to IPv4.
> > > > >>
> > > > >> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
> > > > >> GSO.
> > > > >>
> > > > >>>
> > > > >>> There is no concept of head_skb at the time of this BPF program. It is
> > > > >>> a single SKB, with an skb linear part and multiple data items in the
> > > > >>> frags (no frag_list).
> > > > >>
> > > > >> Sorry for the confusion. head_skb what I mentioned was a skb linear
> > > > >> part. I'm considering a single SKB with frags too.
> > > > >>
> > > > >>>
> > > > >>> When entering the GSO stack, this single skb now has a payload length
> > > > >>> < MSS. So it would just make a valid TCP packet on its own?
> > > > >>>
> > > > >>> skb_gro_len is only relevant inside the GRO stack. It internally casts
> > > > >>> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> > > > >>> reused for other purposes later by other layers of the datapath. It is
> > > > >>> not safe to read this inside bpf_skb_proto_6_to_4.
> > > > >>
> > > > >> The condition what I made uses skb->data_len not skb_gro_len. Does
> > > > >> skb->data_len have a different meaning on each layer? As I know,
> > > > >> data_len indicates the amount of frags or frag_list. skb->data_len
> > > > >> should be > 20 in the sample case because the payload size of the skb
> > > > >> linear part is the same with mss.
> > > > >
> > > > > Ah, got it.
> > > > >
> > > > > data_len is the length of the skb minus the length in the skb linear
> > > > > section (as seen in skb_headlen).
> > > > >
> > > > > So this gso skb consists of two segments, the first one entirely
> > > > > linear, the payload of the second is in skb_shinfo(skb)->frags[0].
> > > > >
> > > > > It is not guaranteed that gso skbs built from two individual skbs end
> > > > > up looking like that. Only protocol headers in the linear segment and
> > > > > the payload of both in frags is common.
> > > > >
> > > > >> We can modify netif_needs_gso as another option to hit
> > > > >> skb_needs_linearize in validate_xmit_skb. But I think we should compare
> > > > >> skb->gso_size and skb->data_len too to check if mss exceed a payload
> > > > >> size.
> > > > >
> > > > > The rest of the stack does not build such gso packets with payload len
> > > > > < mss, so we should not have to add workarounds in the gso hot path
> > > > > for this.
> > > > >
> > > > > Also no need to linearize this skb. I think that if the bpf program
> > > > > would just clear the gso type, the packet would be sent correctly.
> > > > > Unless I'm missing something.
> > > >
> > > > Does the checksum/len field in ip and tcp/udp header need adjusting
> > > > before clearing gso type as the packet has became bigger?
> > >
> > > gro takes care of this. see for instance inet_gro_complete for updates
> > > to the ip header.
> >
> > I think clearing the gso type will get an error at tcp4_gso_segment
> > because netif_needs_gso returns true in validate_xmit_skb.
> 
> Oh right. Whether a packet is gso is defined by gso_size being
> non-zero, not by gso_type.
> 
> > >
> > > > Also, instead of testing skb->data_len, may test the skb->len?
> > > >
> > > > skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
> > >
> > > Yes. Essentially doing the same calculation as the gso code that is
> > > causing the packet to be dropped.
> >
> > BPF program is usually out of control. Can we take a general approach?
> > The below 2 cases has no issue when mss upgrading.
> > 1) skb->data_len > mss + 20
> > 2) skb->data_len < mss && skb->data_len > 20
> > The corner case is when
> > 3) skb->data_len > mss && skb->data_len < mss + 20
> 
> Again, you cannot use skb->data_len alone to make inferences about the
> size of the second packet.

This approach is oriented a general way that does not make inferences
about the size of the second packet.

We can obviously increase the mss size when
1) skb->data_len > mss + 20
The issue will be fixed even if we consider the #1 condition.

But there is a precondition that mss < skb payload. If skb->data_len <
mss then skb_headlen(skb) contains the size of mss. So, we can check
the #2 condition too.
2) skb->data_len < mss && skb->data_len > 20

> 
> >
> > But to cover #3 case, we should check the condition Yunsheng Lin said.
> > What if we do mss upgrading for both #1 and #2 cases only?
> >
> > +               unsigned short off_len = skb->data_len > shinfo->gso_size ?
> > +                       shinfo->gso_size : 0;
> > [...]
> >                 /* Due to IPv4 header, MSS can be upgraded. */
> > -               skb_increase_gso_size(shinfo, len_diff);
> > +               if (skb->data_len - off_len > len_diff)
> > +                       skb_increase_gso_size(shinfo, len_diff);
> 
> That generates TCP packets with different MSS within the same stream.
> 
> My suggestion remains to just not change MSS at all. But this has to
> be a new flag to avoid changing established behavior.

I don't understand why the mss size should be kept in GSO step. Will
there be any issue with different mss?

In general, upgrading mss make sense when 6 to 4. The new flag would be
set by user to not change mss. What happened if user does not set the
flag? I still think we should fix the issue with a general approach. Or
can we remove the skb_increase_gso_size line?


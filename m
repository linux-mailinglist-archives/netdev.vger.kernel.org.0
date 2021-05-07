Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69837375E15
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhEGAyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:54:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56325 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhEGAyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:54:39 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210507005338epoutp048addcb5482d63e231de32d92ba4e1609~8oqpr9Bhg3012030120epoutp04G
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 00:53:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210507005338epoutp048addcb5482d63e231de32d92ba4e1609~8oqpr9Bhg3012030120epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620348818;
        bh=K+z4J1uCBtDF9XuCuwzjJmfZ/fk7X3cTpbveAJuDEjA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=aBUvQsLnQkNiBHUdGYcLSAOOLD1kp+J57rsRYUdD1/VLJb1+3c/OvdB0LR/5/sbMK
         YcIJBVZuYG58oIECmlSoaNd6z7Ww8qsQryigdgiJflMRt4cRJPYzZD36+KvokbosUq
         Eammt4zWAdJ85hzSeUQJfxKjbIKc5Vg88pQxYmJo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210507005338epcas2p3790cfc6540c05ab43f15c95751b77485~8oqpH58R10448604486epcas2p3q;
        Fri,  7 May 2021 00:53:38 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FbsQ807gTz4x9Q7; Fri,  7 May
        2021 00:53:36 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.F7.09604.F8F84906; Fri,  7 May 2021 09:53:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210507005335epcas2p2dc80cfbd4074fa935b1a8664738c56a0~8oqml7nsU3052130521epcas2p2h;
        Fri,  7 May 2021 00:53:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210507005335epsmtrp1852292c8b20ee08fae32db3ad7bd27b6~8oqmk-lgB1067210672epsmtrp1g;
        Fri,  7 May 2021 00:53:35 +0000 (GMT)
X-AuditID: b6c32a45-dc9ff70000002584-12-60948f8ff1c3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.8F.08637.F8F84906; Fri,  7 May 2021 09:53:35 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210507005335epsmtip1771359c0099e6f76c210d0408698506b~8oqmTeb9O2414124141epsmtip1c;
        Fri,  7 May 2021 00:53:35 +0000 (GMT)
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
In-Reply-To: <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Fri, 7 May 2021 09:53:34 +0900
Message-ID: <001801d742db$68ab8060$3a028120$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYAiru3ucBq8RF2ajB+2kg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxbVRjGPb13bcF0uZZuHAhxzdVsgQm0ldbLQmWJSGows2RGGWDaO3rT
        wvplb6ubJtsEV1gHdgWnWMosYyEFN9GmASQriZSMr8kaBKJDnEtgsg8mAYbUDWfLZZH/fuec
        53nf53xxEf4VdjK33GilLEZSj7Pj0a5Qqizd6fxcLfKuZRF/P2pCiJXINIdYHhhkE60tqwjh
        uf4pSlT2+FjE/OIsIP7sq2MR4a7PthE/93rYxFXvTiISuoYQrZHvooqLjWD/dkWg/VeWwlX1
        gKP4wT3DUTh+GUcU/o7TbMWy/3klu1ifo6NIDWURUsYyk6bcqJXjBQdVr6mkMpE4XZxNvIIL
        jaSBkuN5byrT88v10bS48ANSb4tOKUmaxjNfzbGYbFZKqDPRVjlOmTV6s1hszqBJA20zajPK
        TIZ9YpFIIo0q1XpdpyvMMXuyjlaP/cU+Cby7HSCOC7EsaF+/BGLMx3oAnHxY4ADxUV4CsDn4
        BcosrAL4zy3TU8NK/QhgREEAL7taWMxgHsBK57UNBxtLg/fd1dtiLMD2wSdNQ5wYI9h5FNpH
        BDGOwwrhuXu1SIwTsINwrr6SFWMUexFOutc35nlYNvS6bgOGn4PDX82iTJ1dsHvBgzCJhDAy
        17bZqxh+HwqwGY0ANp22I7FwEAtzoWt2AmUMefDx9BpgOAHeHQxwGE6Gd5z2KHOjfAKeOlPK
        eGsBnOib3fS+DN23q0FMg2CpsLM3k5G/AAdubEbbDmtC65tVeLDGzmcQh64VFVMDwvnhBvQs
        wN1b9uXesi/3lvzu/1t5AdoBdlJm2qClaIlZvPWm/WDjGae93gMaFhYz+gGLC/oB5CK4gDd6
        oUHN52nIYx9RFpPKYtNTdD+QRk/ahSTvKDNF/4HRqhJLJTKZKFtKSGUSAk/kRajjaj6mJa3U
        EYoyU5anPhY3Lvkk69s99fkl+1utU0W+e2/7PMcOTAaCeZ2f3GhMSpK7cts/PNDLlTsWJCfe
        SaElgsvX8wK6d+ceNw0eMu3OLzGQj7ptO5bSMrt6pqadF3V4TWprbVVvBTrwcWdlQ9E4Pl5M
        jFH+r9WHQyZDySLr/cO+W21UxmTFoZmXLq2VSxqRm/q2J8qq1Q6RWFTTPTT847l5X45feER+
        9WFd7r/h3JQzFfVvYN8kKbNvhtZbjr8HlhMTsp7p/2ltpvD+lOStZ4f6dh3VBgtTvvSfPzVX
        2+xObFwa3asOnm1vKR77TTQmbnbcrRgP/d6+pzRREi56kLs3Hlyw1WkKfCulf6RO3LkyOmLD
        UVpHitMQC03+B72ZnnVPBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnG5//5QEg87Nghbff89mtvjy8za7
        xecjx9ksFi/8xmwx53wLi0XTjhVMFi8+PGG0eL6vl8niwrY+VovLu+awWRxbIGbx8/AZZovF
        PzcAVSyZwejA57Fl5U0mj4nN79g9ds66y+7RdeMSs8emVZ1sHp83yQWwRXHZpKTmZJalFunb
        JXBlrJ94gb1gjklF+7n3bA2MC9S6GDk5JARMJL5MOsUIYgsJ7GaU6F+l28XIARSXkNi12RWi
        RFjifssR1i5GLqCSZ4wSn5vuMoEk2AS0JN7MamcFsUUErCT+zz7BDlLELLCCReJAx3t2iI4N
        zBKHGp8xg1RxCgRKTH3dA2YLA9n9/26BbWYRUJG4OusvWJxXwFJiwcRnjBC2oMTJmU9YQGxm
        AW2J3oetjBC2vMT2t3OYIc5TkPj5dBnUFVESGw9vYYOoEZGY3dnGPIFReBaSUbOQjJqFZNQs
        JC0LGFlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIER6eW5g7G7as+6B1iZOJgPMQo
        wcGsJMJ7etHkBCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4
        pRqY8gMElZkFHk3lbH/lv8bEUm6ms9WCY1wJgT+LtzHc7xI06Gb96GisJWvCGXUu5gnbljV7
        b76bFsmQ/2DXLfk9FxWUk/5c7pnttbPa7+cJ/sXJnJrpcc2X1377nDzpf0bYzxNxb5l37GGS
        XZOmr11lvv966qrEhqXfpi9ZxjNb40lJ+LUP7tYBEs/XZoZVXM6wWt75Qfbh9hM77/k4tUct
        +aguI+rUfuzN0zWKWfoPbxbN+xTeL5udsEbQ3Med9/Hqkt77s0IExH+7KXsUnshay/r+7sR7
        rEpbXipu2Ty9iuHnuqLlLGuUl/8/H1d38oOghVaxW0XpstfJxgn/anjm9Z9nz8z4YcH0frWV
        /qYIJZbijERDLeai4kQAlh7vnj0DAAA=
X-CMS-MailID: 20210507005335epcas2p2dc80cfbd4074fa935b1a8664738c56a0
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 02:21:37PM -0400, Willem de Bruijn wrote:
> On Wed, May 5, 2021 at 10:27 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > On Wed, May 05, 2021 at 09:45:37PM -0400, Willem de Bruijn wrote:
> > > On Wed, May 5, 2021 at 8:45 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> > > >
> > > > On Wed, May 05, 2021 at 10:55:10PM +0200, Daniel Borkmann wrote:
> > > > > On 4/29/21 12:08 PM, Dongseok Yi wrote:
> > > > > > tcp_gso_segment check for the size of GROed payload if it is bigger
> > > > > > than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
> > > > > > bigger than the size of GROed payload unexpectedly if data_len is not
> > > > > > big enough.
> > > > > >
> > > > > > Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4
> > >
> > > Is this a typo and is this intended to read skb->data_len = 1380?
> >
> > This is not a typo. I intended skb->data_len = 8.
> >
> > >
> > > The issue is that payload length (1380) is greater than mss with ipv6
> > > (1372), but less than mss with ipv4 (1392).
> > >
> > > I don't understand data_len = 8 or why the patch compares
> > > skb->data_len to len_diff (20).
> >
> > skb_gro_receive():
> >         unsigned int len = skb_gro_len(skb);
> >         [...]
> > done:
> >         NAPI_GRO_CB(p)->count++;
> >         p->data_len += len;
> >
> > head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> > data_len could be 8 if server sent a small size packet and it is GROed
> > to head_skb.
> >
> > Please let me know if I am missing something.
> 
> This is my understanding of the data path. This is a forwarding path
> for TCP traffic.
> 
> GRO is enabled and will coalesce multiple segments into a single large
> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> + 20.
> 
> Somewhere between GRO and GSO you have a BPF program that converts the
> IPv6 address to IPv4.

Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
GSO.

> 
> There is no concept of head_skb at the time of this BPF program. It is
> a single SKB, with an skb linear part and multiple data items in the
> frags (no frag_list).

Sorry for the confusion. head_skb what I mentioned was a skb linear
part. I'm considering a single SKB with frags too.

> 
> When entering the GSO stack, this single skb now has a payload length
> < MSS. So it would just make a valid TCP packet on its own?
> 
> skb_gro_len is only relevant inside the GRO stack. It internally casts
> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> reused for other purposes later by other layers of the datapath. It is
> not safe to read this inside bpf_skb_proto_6_to_4.

The condition what I made uses skb->data_len not skb_gro_len. Does
skb->data_len have a different meaning on each layer? As I know,
data_len indicates the amount of frags or frag_list. skb->data_len
should be > 20 in the sample case because the payload size of the skb
linear part is the same with mss.

We can modify netif_needs_gso as another option to hit
skb_needs_linearize in validate_xmit_skb. But I think we should compare
skb->gso_size and skb->data_len too to check if mss exceed a payload
size.

> 
> 
> > >
> > > One simple solution if this packet no longer needs to be segmented
> > > might be to reset the gso_type completely.
> >
> > I am not sure gso_type can be cleared even when GSO is needed.
> >
> > >
> > > In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> > > converting from IPv6 to IPv4, fixed gso will end up building packets
> > > that are slightly below the MTU. That opportunity cost is negligible
> > > (especially with TSO). Unfortunately, I see that that flag is
> > > available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> > >
> > >
> > > > > > would increse the gso_size to 1392. tcp_gso_segment will get an error
> > > > > > with 1380 <= 1392.
> > > > > >
> > > > > > Check for the size of GROed payload if it is really bigger than target
> > > > > > mss when increase mss.
> > > > > >
> > > > > > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > > > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > > > ---
> > > > > >   net/core/filter.c | 4 +++-
> > > > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > index 9323d34..3f79e3c 100644
> > > > > > --- a/net/core/filter.c
> > > > > > +++ b/net/core/filter.c
> > > > > > @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > > > > >             }
> > > > > >
> > > > > >             /* Due to IPv4 header, MSS can be upgraded. */
> > > > > > -           skb_increase_gso_size(shinfo, len_diff);
> > > > > > +           if (skb->data_len > len_diff)
> > > > >
> > > > > Could you elaborate some more on what this has to do with data_len specifically
> > > > > here? I'm not sure I follow exactly your above commit description. Are you saying
> > > > > that you're hitting in tcp_gso_segment():
> > > > >
> > > > >          [...]
> > > > >          mss = skb_shinfo(skb)->gso_size;
> > > > >          if (unlikely(skb->len <= mss))
> > > > >                  goto out;
> > > > >          [...]
> > > >
> > > > Yes, right
> > > >
> > > > >
> > > > > Please provide more context on the bug, thanks!
> > > >
> > > > tcp_gso_segment():
> > > >         [...]
> > > >         __skb_pull(skb, thlen);
> > > >
> > > >         mss = skb_shinfo(skb)->gso_size;
> > > >         if (unlikely(skb->len <= mss))
> > > >         [...]
> > > >
> > > > skb->len will have total GROed TCP payload size after __skb_pull.
> > > > skb->len <= mss will not be happened in a normal GROed situation. But
> > > > bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> > > > hit an error condition.
> > > >
> > > > We should ensure the following condition.
> > > > total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> > > >
> > > > Due to
> > > > total GROed TCP payload = the original mss + skb->data_len
> > > > IPv6 size - IPv4 size = len_diff
> > > >
> > > > Finally, we can get the condition.
> > > > skb->data_len > len_diff
> > > >
> > > > >
> > > > > > +                   skb_increase_gso_size(shinfo, len_diff);
> > > > > > +
> > > > > >             /* Header must be checked, and gso_segs recomputed. */
> > > > > >             shinfo->gso_type |= SKB_GSO_DODGY;
> > > > > >             shinfo->gso_segs = 0;
> > > > > >
> > > >
> > > >
> >


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1763763EC
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhEGKh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:37:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44827 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236919AbhEGKhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:37:21 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210507103619epoutp047c39feb0b478e95cfc573b06ab66ce73~8wnZGMy6L2271322713epoutp04b
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 10:36:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210507103619epoutp047c39feb0b478e95cfc573b06ab66ce73~8wnZGMy6L2271322713epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620383779;
        bh=+KFwL554FiUYsQuDiwrbpamm8pEVQzumGw8EbUUwLus=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=NlMq+jV80XchRUV1LZA5hK+9j7Se2VJtKeW1l6E4MZWodjXKPQJXB8K0DLmSRGz5F
         upLToYKwlA2zjOQs8Mbrsj0k0Ij0CDClOpSnBc4PXXX6shtKSuP8DTPSNTRFYw0G3w
         yDtwAYCSJHRoz5jejQtPbo6GTsOziX3lJyyxra6M=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210507103618epcas2p2af58c0c639c48450bf8d47b35bb6de1a~8wnYAIjxX2373523735epcas2p26;
        Fri,  7 May 2021 10:36:18 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Fc6LS0RBgz4x9Pp; Fri,  7 May
        2021 10:36:16 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.0E.09433.F1815906; Fri,  7 May 2021 19:36:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210507103615epcas2p420f76362ca61282a6ac26ee7d42fb347~8wnVpLACs0064300643epcas2p4m;
        Fri,  7 May 2021 10:36:15 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210507103615epsmtrp111794de89e8f0967055fc952da34ef79~8wnVn_76V0947109471epsmtrp1t;
        Fri,  7 May 2021 10:36:15 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-7f-6095181f07dc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.7C.08163.F1815906; Fri,  7 May 2021 19:36:15 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210507103615epsmtip2dedeaa9f15a3819b0f451d230ad54195~8wnVU0YfC1119311193epsmtip2i;
        Fri,  7 May 2021 10:36:15 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
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
In-Reply-To: <5824b2ab-46a2-a70c-0ac9-8c5eb0a9665a@huawei.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Fri, 7 May 2021 19:36:15 +0900
Message-ID: <008101d7432c$ce733e00$6b59ba00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYAiru3ucBq8RF2QKY6vTDAm6kVlUBadK04AMaqQ3GARiLayQCOMjohahbuIog
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmma68xNQEg4f3rC2+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hs2h4y2VxbIGYxc/D
        Z5gtFv/cAFS1ZAajA7/HlpU3mTwmNr9j99g56y67R8uRt6weXTcuMXtsWtXJ5vF5k1wAe1SO
        TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q2UoKZYk5
        pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScAkPDAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyM
        b0cfMxY0hlbs6JjA1sD41bGLkZNDQsBE4vKDe2xdjFwcQgI7GCU23L0D5XwCch5eYIVwPjNK
        LNh9nBWmpX3RPqjELkaJ9y/nsEM4LxglGt5MYASpYhPQkngzqx2sQ0QgXWJuy2FGkCJmgXks
        EleXtYAlOAXsJD6/2s8CYgsLBEs8ndTEBGKzCKhIHH17EGwQr4ClxNHj65khbEGJkzOfgNUz
        C8hLbH87hxniJAWJn0+XgZ0kItDEKLF41yRWiCIRidmdbcwgCQmBBxwSj84uZYHocJF4e286
        I4QtLPHq+BZ2CFtK4mV/G5DNAWTXS7R2x0D09jBKXNn3BKrXWGLWs3ZGkBpmAU2J9bv0IcqV
        JY7cgrqNT6Lj8F+oKbwSHW1CEKaSxMQv8RAzJCRenJzMMoFRaRaSx2YheWwWkvtnIaxawMiy
        ilEstaA4Nz212KjAGDm2NzGC07SW+w7GGW8/6B1iZOJgPMQowcGsJMJ7etHkBCHelMTKqtSi
        /Pii0pzU4kOMpsCgnsgsJZqcD8wUeSXxhqZGZmYGlqYWpmZGFkrivD9T6xKEBNITS1KzU1ML
        Uotg+pg4OKUamJZ2L2vm/t7uMJlB79wLQ7lL7/3qv62Ydz356/oovetBa7Z3Cb5yWi74PUpk
        sVCr+TeWTRwa+ydsa/XymmCt0f0i+79XbqtOWSBvwGKHZQGXBeJXPV3t+ZS7Y/vdaV4ra184
        sx9mtVMpOLHn9tRjvAt39mkyMbB/LF2lyMBlvEOS6ULULxajuav02W/m3XPLrwhz6dh9+suL
        2xO33NjheGu6mhFnd8KHawVLdLRkprF+SF+8dp9pPI/pR6Fb5QLmPStbLe5nWLmGe86v6WX0
        N3Pi4HDdkB/19htjTWXbTM3yoHl93F9/vdmaIbN2n65YiIP7si3zo313fg1Ndat1PSddUXxO
        QkozNGdf694gJZbijERDLeai4kQA4NBxLFwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSvK68xNQEgxvzBC2+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hs2h4y2VxbIGYxc/D
        Z5gtFv/cAFS1ZAajA7/HlpU3mTwmNr9j99g56y67R8uRt6weXTcuMXtsWtXJ5vF5k1wAexSX
        TUpqTmZZapG+XQJXxrejjxkLGkMrdnRMYGtg/OrYxcjJISFgItG+aB9rFyMXh5DADkaJl5uf
        sXUxcgAlJCR2bXaFqBGWuN9yhBXEFhJ4xiix8nE5iM0moCXxZlY7WFxEIF3iyt+n7CBzmAVW
        sEhcWH+RHWLoL1aJFc3vWUCqOAXsJD6/2g9mCwsESvT/u8UIYrMIqEgcfXsQzOYVsJQ4enw9
        M4QtKHFy5hOwemYBbYneh62MELa8xPa3c5ghrlOQ+Pl0GdgHIgJNjBKLd01ihSgSkZjd2cY8
        gVF4FpJZs5DMmoVk1iwkLQsYWVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgRHrJbW
        DsY9qz7oHWJk4mA8xCjBwawkwnt60eQEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmk
        J5akZqemFqQWwWSZODilGpjys4QXpKzb/3PJ+0OxYQm197pWfao33VpsFHQ78YadZMTugOye
        FecNlcXZXtrdWhpbMPfbqzS+x7G5QVYSS1QZHFYvib8gUSLXLuy/7bzkdrZHskxLap7oZ/W1
        86bwsh9c3hwTJWxZtcE8f2Zr0ItNTCdfhh5sTeQ68IMtjOvqulj+rUabZx8/+Otq1mkv9scx
        HH2yWx3W3SueLu559n3Xh2e56o7deqtWGDUI+X86yzEzStsxrLnTg6/55x1mFw65m2Lh84Ly
        FtTe0Wk/nTgrj8VrHuOb+Gqf1INOiwxeGemzNdzWUjj2b3Lud/XDnte1tWJEjHbENV9jnbW/
        +MUmmSV+Nv2NzgwPVDZUK7EUZyQaajEXFScCAO7RlS9HAwAA
X-CMS-MailID: 20210507103615epcas2p420f76362ca61282a6ac26ee7d42fb347
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
        <5824b2ab-46a2-a70c-0ac9-8c5eb0a9665a@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 05:11:20PM +0800, Yunsheng Lin wrote:
> On 2021/5/7 16:25, Dongseok Yi wrote:
> > On Thu, May 06, 2021 at 09:53:45PM -0400, Willem de Bruijn wrote:
> >> On Thu, May 6, 2021 at 9:45 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>
> >>> On 2021/5/7 9:25, Willem de Bruijn wrote:
> >>>>>>> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> >>>>>>> data_len could be 8 if server sent a small size packet and it is GROed
> >>>>>>> to head_skb.
> >>>>>>>
> >>>>>>> Please let me know if I am missing something.
> >>>>>>
> >>>>>> This is my understanding of the data path. This is a forwarding path
> >>>>>> for TCP traffic.
> >>>>>>
> >>>>>> GRO is enabled and will coalesce multiple segments into a single large
> >>>>>> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> >>>>>> + 20.
> >>>>>>
> >>>>>> Somewhere between GRO and GSO you have a BPF program that converts the
> >>>>>> IPv6 address to IPv4.
> >>>>>
> >>>>> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
> >>>>> GSO.
> >>>>>
> >>>>>>
> >>>>>> There is no concept of head_skb at the time of this BPF program. It is
> >>>>>> a single SKB, with an skb linear part and multiple data items in the
> >>>>>> frags (no frag_list).
> >>>>>
> >>>>> Sorry for the confusion. head_skb what I mentioned was a skb linear
> >>>>> part. I'm considering a single SKB with frags too.
> >>>>>
> >>>>>>
> >>>>>> When entering the GSO stack, this single skb now has a payload length
> >>>>>> < MSS. So it would just make a valid TCP packet on its own?
> >>>>>>
> >>>>>> skb_gro_len is only relevant inside the GRO stack. It internally casts
> >>>>>> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> >>>>>> reused for other purposes later by other layers of the datapath. It is
> >>>>>> not safe to read this inside bpf_skb_proto_6_to_4.
> >>>>>
> >>>>> The condition what I made uses skb->data_len not skb_gro_len. Does
> >>>>> skb->data_len have a different meaning on each layer? As I know,
> >>>>> data_len indicates the amount of frags or frag_list. skb->data_len
> >>>>> should be > 20 in the sample case because the payload size of the skb
> >>>>> linear part is the same with mss.
> >>>>
> >>>> Ah, got it.
> >>>>
> >>>> data_len is the length of the skb minus the length in the skb linear
> >>>> section (as seen in skb_headlen).
> >>>>
> >>>> So this gso skb consists of two segments, the first one entirely
> >>>> linear, the payload of the second is in skb_shinfo(skb)->frags[0].
> >>>>
> >>>> It is not guaranteed that gso skbs built from two individual skbs end
> >>>> up looking like that. Only protocol headers in the linear segment and
> >>>> the payload of both in frags is common.
> >>>>
> >>>>> We can modify netif_needs_gso as another option to hit
> >>>>> skb_needs_linearize in validate_xmit_skb. But I think we should compare
> >>>>> skb->gso_size and skb->data_len too to check if mss exceed a payload
> >>>>> size.
> >>>>
> >>>> The rest of the stack does not build such gso packets with payload len
> >>>> < mss, so we should not have to add workarounds in the gso hot path
> >>>> for this.
> >>>>
> >>>> Also no need to linearize this skb. I think that if the bpf program
> >>>> would just clear the gso type, the packet would be sent correctly.
> >>>> Unless I'm missing something.
> >>>
> >>> Does the checksum/len field in ip and tcp/udp header need adjusting
> >>> before clearing gso type as the packet has became bigger?
> >>
> >> gro takes care of this. see for instance inet_gro_complete for updates
> >> to the ip header.
> >
> > I think clearing the gso type will get an error at tcp4_gso_segment
> > because netif_needs_gso returns true in validate_xmit_skb.
> 
> So the bpf_skb_proto_6_to_4() is called after validate_xmit_skb() and
> before tcp4_gso_segment()?
> If Yes, clearing the gso type here does not seem to help.

The order what I checked is bpf_skb_proto_6_to_4() ->
validate_xmit_skb() -> tcp4_gso_segment().

> 
> >
> >>
> >>> Also, instead of testing skb->data_len, may test the skb->len?
> >>>
> >>> skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
> >>
> >> Yes. Essentially doing the same calculation as the gso code that is
> >> causing the packet to be dropped.
> >
> > BPF program is usually out of control. Can we take a general approach?
> > The below 2 cases has no issue when mss upgrading.
> > 1) skb->data_len > mss + 20
> > 2) skb->data_len < mss && skb->data_len > 20
> > The corner case is when
> > 3) skb->data_len > mss && skb->data_len < mss + 20
> 
> As my understanding:
> 
> Usually skb_headlen(skb) >= (mac header + ip/ipv6 header + udp/tcp header),
> other than that, there is no other guarantee as long as:
> skb->len = skb_headlen(skb) + skb->data_len
> 
> So the cases should be:
> 1. skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
> 2. skb->len - (mac header + ip/ipv6 header + udp/tcp header) <= mss + len_diff
> 
> The corner case is case 2.

I agree. In addition,
skbs which hits skb_increase_gso_size in bpf_skb_proto_6_to_4 are all
IPv6 + TCP by (skb_is_gso(skb) && !skb_is_gso_tcp(skb)) condition. So
(mac header + ip/ipv6 header + udp/tcp header) can be
(mac header + ipv6 header + tcp header). But I thick Willem de Bruijn
would not want to check such network payloads in the BPF step.

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
> >
> >>
> >>>>
> >>>> But I don't mean to argue that it should do that in production.
> >>>> Instead, not playing mss games would solve this and stay close to the
> >>>> original datapath if no bpf program had been present. Including
> >>>> maintaining the GSO invariant of sending out the same chain of packets
> >>>> as received (bar the IPv6 to IPv4 change).
> >>>>
> >>>> This could be achieved by adding support for the flag
> >>>> BPF_F_ADJ_ROOM_FIXED_GSO in the flags field of bpf_skb_change_proto.
> >>>> And similar to bpf_skb_net_shrink:
> >>>>
> >>>>                 /* Due to header shrink, MSS can be upgraded. */
> >>>>                 if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
> >>>>                         skb_increase_gso_size(shinfo, len_diff);
> >>>>
> >>>> The other case, from IPv4 to IPv6 is more difficult to address, as not
> >>>> reducing the MSS will result in packets exceeding MTU. That calls for
> >>>> workarounds like MSS clamping. Anyway, that is out of scope here.
> >>>>
> >>>>
> >>>>
> >>>>>>
> >>>>>>
> >>>>>>>>
> >>>>>>>> One simple solution if this packet no longer needs to be segmented
> >>>>>>>> might be to reset the gso_type completely.
> >>>>>>>
> >>>>>>> I am not sure gso_type can be cleared even when GSO is needed.
> >>>>>>>
> >>>>>>>>
> >>>>>>>> In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> >>>>>>>> converting from IPv6 to IPv4, fixed gso will end up building packets
> >>>>>>>> that are slightly below the MTU. That opportunity cost is negligible
> >>>>>>>> (especially with TSO). Unfortunately, I see that that flag is
> >>>>>>>> available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>>>> would increse the gso_size to 1392. tcp_gso_segment will get an error
> >>>>>>>>>>> with 1380 <= 1392.
> >>>>>>>>>>>
> >>>>>>>>>>> Check for the size of GROed payload if it is really bigger than target
> >>>>>>>>>>> mss when increase mss.
> >>>>>>>>>>>
> >>>>>>>>>>> Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> >>>>>>>>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> >>>>>>>>>>> ---
> >>>>>>>>>>>   net/core/filter.c | 4 +++-
> >>>>>>>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>>>>>>>>
> >>>>>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
> >>>>>>>>>>> index 9323d34..3f79e3c 100644
> >>>>>>>>>>> --- a/net/core/filter.c
> >>>>>>>>>>> +++ b/net/core/filter.c
> >>>>>>>>>>> @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> >>>>>>>>>>>             }
> >>>>>>>>>>>
> >>>>>>>>>>>             /* Due to IPv4 header, MSS can be upgraded. */
> >>>>>>>>>>> -           skb_increase_gso_size(shinfo, len_diff);
> >>>>>>>>>>> +           if (skb->data_len > len_diff)
> >>>>>>>>>>
> >>>>>>>>>> Could you elaborate some more on what this has to do with data_len specifically
> >>>>>>>>>> here? I'm not sure I follow exactly your above commit description. Are you saying
> >>>>>>>>>> that you're hitting in tcp_gso_segment():
> >>>>>>>>>>
> >>>>>>>>>>          [...]
> >>>>>>>>>>          mss = skb_shinfo(skb)->gso_size;
> >>>>>>>>>>          if (unlikely(skb->len <= mss))
> >>>>>>>>>>                  goto out;
> >>>>>>>>>>          [...]
> >>>>>>>>>
> >>>>>>>>> Yes, right
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> Please provide more context on the bug, thanks!
> >>>>>>>>>
> >>>>>>>>> tcp_gso_segment():
> >>>>>>>>>         [...]
> >>>>>>>>>         __skb_pull(skb, thlen);
> >>>>>>>>>
> >>>>>>>>>         mss = skb_shinfo(skb)->gso_size;
> >>>>>>>>>         if (unlikely(skb->len <= mss))
> >>>>>>>>>         [...]
> >>>>>>>>>
> >>>>>>>>> skb->len will have total GROed TCP payload size after __skb_pull.
> >>>>>>>>> skb->len <= mss will not be happened in a normal GROed situation. But
> >>>>>>>>> bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> >>>>>>>>> hit an error condition.
> >>>>>>>>>
> >>>>>>>>> We should ensure the following condition.
> >>>>>>>>> total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> >>>>>>>>>
> >>>>>>>>> Due to
> >>>>>>>>> total GROed TCP payload = the original mss + skb->data_len
> >>>>>>>>> IPv6 size - IPv4 size = len_diff
> >>>>>>>>>
> >>>>>>>>> Finally, we can get the condition.
> >>>>>>>>> skb->data_len > len_diff
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>> +                   skb_increase_gso_size(shinfo, len_diff);
> >>>>>>>>>>> +
> >>>>>>>>>>>             /* Header must be checked, and gso_segs recomputed. */
> >>>>>>>>>>>             shinfo->gso_type |= SKB_GSO_DODGY;
> >>>>>>>>>>>             shinfo->gso_segs = 0;
> >>>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>
> >>>>>
> >>>>
> >>>> .
> >>>>
> >>>
> >
> >
> > .
> >



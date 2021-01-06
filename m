Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067382EB870
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 04:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAFDdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 22:33:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30080 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbhAFDdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 22:33:37 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210106033252epoutp0377204a31dad17f746659e96157b8400b~XhyIknVlt2729327293epoutp03Y
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 03:32:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210106033252epoutp0377204a31dad17f746659e96157b8400b~XhyIknVlt2729327293epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609903972;
        bh=bGWPcY9a08WKQA4OIXUu6hsOWr+H/kC8gmmbQGcToQU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=GjVssBFc+NPIVpxLD4g5PPhosAJb2axKiaoqeGYQHg35yLzMbAZ5JAFQua2ZoGaoZ
         rjxxc6X3icfHixN3UlGxSfK8SB7Wi69TTQCyEtoKHXP7aFdoDSGfj3lteJ69AnPzyB
         tUllIQpLsnuyZdJzvy+0cnJ0vDOfPF0w+xXZf/wo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210106033251epcas2p4806c78aa52bea158bb7216db59a8e62a~XhyHekFrJ1094410944epcas2p4D;
        Wed,  6 Jan 2021 03:32:51 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D9Zgj2VN9z4x9Q9; Wed,  6 Jan
        2021 03:32:49 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.A1.52511.16F25FF5; Wed,  6 Jan 2021 12:32:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210106033248epcas2p26477e5d9cbf0f05eeb42cf39272255e6~XhyElMLPF1687216872epcas2p2z;
        Wed,  6 Jan 2021 03:32:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210106033248epsmtrp1cf5b5ebabb4da7c090f5637b67f1c00b~XhyEkHlB52830228302epsmtrp1V;
        Wed,  6 Jan 2021 03:32:48 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-30-5ff52f618818
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.F5.13470.F5F25FF5; Wed,  6 Jan 2021 12:32:48 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210106033247epsmtip1283bbccedd3c19ea9a86067f19392ab9~XhyEQ73oj1580415804epsmtip1i;
        Wed,  6 Jan 2021 03:32:47 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Miaohe Lin'" <linmiaohe@huawei.com>,
        "'Willem de Bruijn'" <willemb@google.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Florian Westphal'" <fw@strlen.de>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'Guillaume Nault'" <gnault@redhat.com>,
        "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Yadu Kishore'" <kyk.segfault@gmail.com>,
        "'Marco Elver'" <elver@google.com>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, <namkyu78.kim@samsung.com>
In-Reply-To: <CAF=yD-Lg92JdpCU8CEQnutzi4VyS67_VNfAniRU=RxDvfYMruw@mail.gmail.com>
Subject: RE: [PATCH net] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Wed, 6 Jan 2021 12:32:47 +0900
Message-ID: <019b01d6e3dc$9a940330$cfbc0990$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGzSLyD0IId2D3HDIYy/7dNsmGIiACENc+NAWJEhNECbm6XgQEwXpGRqjT7W3A=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxbVRT3tq/to1p8QhnXZozmbUxp0tLiihcyln1FX9yyYHTRLMb6Cm+U
        2K+0ZRaiGRmD0g7ZGNOxwmYdiow5JrW0MAIqIEhYAlPcAMFNxwhulCEibBicLa+L/HfOub+P
        87v3PZwbM86X4HlGG2Mx0nqSL8T83clqOZ3yt0bpdkWj2sGjGCq9GuAh/4cXAaqebxagIX8F
        DzX5zwPkXPocQz9dqeWjoqAQFY0X81GvZx1aHJgBqN35QIAGV/p4aNbXI0B1D7/ibCco34VR
        DtXmnhBQHm8+dbQnyKO8jU4+db/zZz5V4WsElLfkMx7VteThUX95N1DeySAn68kD+q06hs5h
        LFLGmG3KyTPmZpJ7XtPs0qjTlCq5Kh29SEqNtIHJJHfvzZK/lKcPxSGlh2h9fmiURVutZMq2
        rRZTvo2R6kxWWybJmHP0ZpXKrLDSBmu+MVeRbTJkqJTKVHUI+Y5e19x+HTP3bbOP/F4HioBf
        7gJROCS2QGewE3MBIR5DtAI40dnGYZt5AG+2NESaRQB/GxziPaZ4XJN89qADwBtOB2Cb6RCl
        9E9BGMUnZHDG7VhliIkM+Kjmh9U5l1jC4PcfveICOB5FvAr7AwfD41jidRhousoN1xixCZ5q
        PrdKFRHp8HZ1FWDrZ2D/mUmMlUmEgWAtl11ICh/eqY9Y7YOVX/fyWIwY1jhLIxhHFLz07caw
        LSR2wxsBhh3Hwrt9PgFbS+Afx0sFLOQwLDn2VjgVJMoBHO5kbSHxAnRPhePiIflkePlKCgvf
        CHvGIotFw7LulYiKCJaVxrAlCSsXNKwGhNP9VdgJQLrXpHKvSeVes737fysPwBrBOsZsNeQy
        1lTzlrUP7QWrn7mMagU1wTlFF+DgoAtAnEuKRah3QRMjyqELChmLSWPJ1zPWLqAO3XMlVxKX
        bQr9J0abRqVOTUtTpquROi0VkfEii/KWJobIpW3MuwxjZiyPeRw8SlLEOd0/2xrc/OO+i2hm
        9IFkOe5IQjoCS8vt+53xHyfapk/zy+YKyo8Xa+yG27GiFn6FfrRlZb7iO21PzyeOgj2NXMO/
        98ZNqdXDh05ee+ry2diDzxufvqt98157xUTHB7Dh2PvyMXphh3CmHu46c0C7UzYibjp/ROaD
        nnK79to3m6b2Xz+1fnNJ8ViGg2ZEN5fsuLBQ2xaoWm4r7JjPTRLW7Yw+bKOeVfKG516OU5x8
        rnUx059w7sQ/vqgisWpHdcaUwnd/RJQkTsfcKVrs01uzb9u3xw9gT2x445deSUJ9e7fyznuC
        BkGgOVnxxYVfhxJTpJ7uL1s0A0nrqUfCSwqdXkpiVh2tknEtVvo/C6UxxW8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWy7bCSnG6C/td4g/PPmCzmnG9hsWg7s53V
        YlvvakaLGZ82sltc2NbHarFu2yJGi87vS1ksLu+aw2bR8JbLouFOM5vFsQViFt9Ov2G02N35
        g93i/N/jrBbvthxht1j8cwOTg4DHlpU3mTx2zrrL7rFgU6lHy5G3rB6bVnWyebzfd5XNo2/L
        KkaPTa1LWD0OfV/A6vF5k5zHpidvmQK4o7hsUlJzMstSi/TtErgyNu6+xlJw3K7ixqPFjA2M
        23S7GDk5JARMJBZ0PWHrYuTiEBLYzSix+8pr1i5GDqCEhMSuza4QNcIS91uOsELUPGOUuP73
        DSNIgk1AS+LNrHZWEFtEwEri/+wT7CBFzAKNrBJPz29hA0kICZxnkmj95QUylFMgUOLk9jSQ
        sLBAkMT+GxvASlgEVCSmbJwHNodXwFLi8YzJjBC2oMTJmU9YQGxmAW2J3oetjBC2vMT2t3OY
        IY5TkPj5dBnUDX4SEzcfY4WoEZGY3dnGPIFReBaSUbOQjJqFZNQsJC0LGFlWMUqmFhTnpucW
        GxYY5qWW6xUn5haX5qXrJefnbmIER7eW5g7G7as+6B1iZOJgPMQowcGsJMJrcexLvBBvSmJl
        VWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MHdpO38/c+iI+31lO
        5e4Ohw8Ob1P+rmL8++xZ+MIrJsJCq7bz5n7unSz94GHmj5Xv+n5+jVstsDXrhXNpuPDxt+5N
        +dcOGcQ2GTm02pr+sG4KXFUU/8N//4YF+u0rnDewlB3kPay4/W3SoZCyudkWnRX1essulMye
        MO9nc1aPxCNfVjOPN7/XJu3i6Xz9VtlTSKH7XcfxLras5U/C6+q9mE9/UzTjzTMPdRWW/eNn
        vTb/mcrZxT72awqvF186uEypjjkgWPTnv41/z09Zd3/RH/adgfuX8t62uXmr3tCC+w7X+Ud5
        xVph9bEv2Txmvq/+KlpR8fGoA9/x+QFcB/0jz3qf/C64dZvpnu+H9xdyK7EUZyQaajEXFScC
        AIUvpKNdAwAA
X-CMS-MailID: 20210106033248epcas2p26477e5d9cbf0f05eeb42cf39272255e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
        <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
        <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
        <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com>
        <CAF=yD-Lg92JdpCU8CEQnutzi4VyS67_VNfAniRU=RxDvfYMruw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-06 12:07, Willem de Bruijn wrote:
> 
> On Tue, Jan 5, 2021 at 8:29 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > On 2021-01-05 06:03, Willem de Bruijn wrote:
> > >
> > > On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> > > >
> > > > skbs in frag_list could be shared by pskb_expand_head() from BPF.
> > >
> > > Can you elaborate on the BPF connection?
> >
> > With the following registered ptypes,
> >
> > /proc/net # cat ptype
> > Type Device      Function
> > ALL           tpacket_rcv
> > 0800          ip_rcv.cfi_jt
> > 0011          llc_rcv.cfi_jt
> > 0004          llc_rcv.cfi_jt
> > 0806          arp_rcv
> > 86dd          ipv6_rcv.cfi_jt
> >
> > BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
> > (or ipv6_rcv). And it calls pskb_expand_head.
> >
> > [  132.051228] pskb_expand_head+0x360/0x378
> > [  132.051237] skb_ensure_writable+0xa0/0xc4
> > [  132.051249] bpf_skb_pull_data+0x28/0x60
> > [  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
> > [  132.051273] cls_bpf_classify+0x254/0x348
> > [  132.051284] tcf_classify+0xa4/0x180
> 
> Ah, you have a BPF program loaded at TC. That was not entirely obvious.
> 
> This program gets called after packet sockets with ptype_all, before
> those with a specific protocol.
> 
> Tcpdump will have inserted a program with ptype_all, which cloned the
> skb. This triggers skb_ensure_writable -> pskb_expand_head ->
> skb_clone_fraglist -> skb_get.
> 
> > [  132.051294] __netif_receive_skb_core+0x590/0xd28
> > [  132.051303] __netif_receive_skb+0x50/0x17c
> > [  132.051312] process_backlog+0x15c/0x1b8
> >
> > >
> > > > While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> > > > But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> > > > chain made by skb_segment_list().
> > > >
> > > > If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> > > > multiple ptypes can see this. The skb could be released by ptypes and
> > > > it causes use-after-free.
> > >
> > > If I understand correctly, a udp-gro-list skb makes it up the receive
> > > path with one or more active packet sockets.
> > >
> > > The packet socket will call skb_clone after accepting the filter. This
> > > replaces the head_skb, but shares the skb_shinfo and thus frag_list.
> > >
> > > udp_rcv_segment later converts the udp-gro-list skb to a list of
> > > regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> > > Now all the frags are fully fledged packets, with headers pushed
> > > before the payload. This does not change their refcount anymore than
> > > the skb_clone in pf_packet did. This should be 1.
> > >
> > > Eventually udp_recvmsg will call skb_consume_udp on each packet.
> > >
> > > The packet socket eventually also frees its cloned head_skb, which triggers
> > >
> > >   kfree_skb_list(shinfo->frag_list)
> > >     kfree_skb
> > >       skb_unref
> > >         refcount_dec_and_test(&skb->users)
> >
> > Every your understanding is right, but
> >
> > >
> > > >
> > > > [ 4443.426215] ------------[ cut here ]------------
> > > > [ 4443.426222] refcount_t: underflow; use-after-free.
> > > > [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> > > > refcount_dec_and_test_checked+0xa4/0xc8
> > > > [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> > > > [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> > > > [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> > > > [ 4443.426808] Call trace:
> > > > [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> > > > [ 4443.426823]  skb_release_data+0x144/0x264
> > > > [ 4443.426828]  kfree_skb+0x58/0xc4
> > > > [ 4443.426832]  skb_queue_purge+0x64/0x9c
> > > > [ 4443.426844]  packet_set_ring+0x5f0/0x820
> > > > [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> > > > [ 4443.426853]  __sys_setsockopt+0x188/0x278
> > > > [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> > > > [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> > > > [ 4443.426873]  el0_svc_handler+0x74/0x98
> > > > [ 4443.426880]  el0_svc+0x8/0xc
> > > >
> > > > Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > ---
> > > >  net/core/skbuff.c | 20 +++++++++++++++++++-
> > > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index f62cae3..1dcbda8 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > > >         unsigned int delta_truesize = 0;
> > > >         unsigned int delta_len = 0;
> > > >         struct sk_buff *tail = NULL;
> > > > -       struct sk_buff *nskb;
> > > > +       struct sk_buff *nskb, *tmp;
> > > > +       int err;
> > > >
> > > >         skb_push(skb, -skb_network_offset(skb) + offset);
> > > >
> > > > @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > > >                 nskb = list_skb;
> > > >                 list_skb = list_skb->next;
> > > >
> > > > +               err = 0;
> > > > +               if (skb_shared(nskb)) {
> > >
> > > I must be missing something still. This does not square with my
> > > understanding that the two sockets are operating on clones, with each
> > > frag_list skb having skb->users == 1.
> > >
> > > Unless the packet socket patch previously also triggered an
> > > skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
> > > calls skb_get on each frag_list skb.
> >
> > A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
> > with the original shinfo. pskb_expand_head reallocates the shinfo of
> > the skb and call skb_clone_fraglist. skb_release_data in
> > pskb_expand_head could not reduce skb->users of the each frag_list skb
> > if skb_shinfo(skb)->dataref == 2.
> >
> > After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
> > skb could have skb->users == 2.
> 
> Yes, that makes sense. skb_clone_fraglist just increments the
> frag_list skb's refcounts.
> 
> skb_segment_list must create an unshared struct sk_buff before it
> changes skb data to insert the protocol headers.
> 
> > >
> > >
> > > > +                       tmp = skb_clone(nskb, GFP_ATOMIC);
> > > > +                       if (tmp) {
> > > > +                               kfree_skb(nskb);
> > > > +                               nskb = tmp;
> > > > +                               err = skb_unclone(nskb, GFP_ATOMIC);
> 
> Calling clone and unclone in quick succession looks odd.
> 
> But you need the first to create a private skb and to trigger the
> second to create a private copy of the linear data (as well as frags,
> if any, but these are not touched). So this looks okay.
> 
> > > > +                       } else {
> > > > +                               err = -ENOMEM;
> > > > +                       }
> > > > +               }
> > > > +
> > > >                 if (!tail)
> > > >                         skb->next = nskb;
> > > >                 else
> > > >                         tail->next = nskb;
> > > >
> > > > +               if (unlikely(err)) {
> > > > +                       nskb->next = list_skb;
> 
> To avoid leaking these skbs when calling kfree_skb_list(skb->next). Is
> that concern new with this patch, or also needed for the existing
> error case?

It's new for this patch. nskb can lose next skb due to
tmp = skb_clone(nskb, GFP_ATOMIC); on the prior. I believe it is not
needed for the existing errors.

> 
> > > > +                       goto err_linearize;
> > > > +               }
> > > > +
> > > >                 tail = nskb;
> > > >
> > > >                 delta_len += nskb->len;
> > > > --
> > > > 2.7.4
> > > >
> >


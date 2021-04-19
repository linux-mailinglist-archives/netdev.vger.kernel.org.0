Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6A63638D1
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 02:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbhDSAgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 20:36:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54921 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhDSAgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 20:36:31 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210419003559epoutp028c98e00469666ba610b83704ce599f2e~3G0F8nHBo1857718577epoutp023
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 00:35:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210419003559epoutp028c98e00469666ba610b83704ce599f2e~3G0F8nHBo1857718577epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1618792559;
        bh=FUqDbQtAG9yorYOoLx+U+r48O6H0JxmLwHIv5Y10RGU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=oP4OmtXS13RkH+j0HXm4CQmWYULoqLag3m6vTaOgzEzLDdL1PGF5y9NHVNVgUnj7B
         ZFolQc1tiG9OTXWTg/buxK555aEH0vEc6Wd2c7UMyRVhUuXGD/uPws0ePvtee13GDv
         ZkM6HRAM3mhiP5S6gqxcP97K9lzAytwxQgTMtW8c=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210419003558epcas2p28a83478c63d0721fd7506568f315ce8a~3G0FfI2AX0964009640epcas2p21;
        Mon, 19 Apr 2021 00:35:58 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FNnt45zc2z4x9QW; Mon, 19 Apr
        2021 00:35:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.F1.09604.C60DC706; Mon, 19 Apr 2021 09:35:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210419003556epcas2p2ca56455c390ddec314ff2b8e9779b4ef~3G0DHssFk2012720127epcas2p2I;
        Mon, 19 Apr 2021 00:35:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210419003556epsmtrp2fc9b6ca5a86b9a7a88f1652dbfaf0ddc~3G0DFmiE20413204132epsmtrp2f;
        Mon, 19 Apr 2021 00:35:56 +0000 (GMT)
X-AuditID: b6c32a45-dc9ff70000002584-a7-607cd06c952b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.52.08637.B60DC706; Mon, 19 Apr 2021 09:35:55 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210419003555epsmtip11e76c514164074d75970f0acf4eada14~3G0CwI_8O0036900369epsmtip1b;
        Mon, 19 Apr 2021 00:35:55 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Miaohe Lin'" <linmiaohe@huawei.com>,
        "'Willem de Bruijn'" <willemb@google.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Florian Westphal'" <fw@strlen.de>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'Guillaume Nault'" <gnault@redhat.com>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Yadu Kishore'" <kyk.segfault@gmail.com>,
        "'Marco Elver'" <elver@google.com>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, <namkyu78.kim@samsung.com>
In-Reply-To: <18999f48-7dc8-e859-8629-3b5cab764faa@huawei.com>
Subject: RE: [PATCH net] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Mon, 19 Apr 2021 09:35:55 +0900
Message-ID: <04f601d734b3$f5ca86c0$e15f9440$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQGzSLyD0IId2D3HDIYy/7dNsmGIiACENc+NAWJEhNECbm6XgQEwXpGRAhEW9qYB/HcCx6q2PuMw
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTZRy/Z++7dxsy73WiPYedrtfqBBtuy+GDAWFYvUfeiWl3O8vbJrwB
        tV/tZZoCMgvBqeGAohrr4ixWQEc6YSgk2ViSgGkH1MGBFEHuxJEHCFJBbb548d/n+30+n+fz
        /Tw/hJhkmIgW5hhzGYtRp6eICNzbHoNk+hv5WnmlZyNyXS/CUXF3Mx9536sH6KPJcwJ0w1vK
        Rw3eMwDZZ2tw1NPiIpAtGIFsg+8S6Er1ajTTdQegVvt9Abo+38FHE41+Afps7iwvhaQba/t5
        9EXnkICu9ljpIn+QT3vq7AT9Z1sfQZc21gHac+xzPu2brebTU561tGc0yEtftlefmM3oMhmL
        lDFmmDJzjFlJ1Eu7NakaVbxcIVMkoC2U1KgzMEnU9h3pshdy9KE4lPSATm8NtdJ1LEttSk60
        mKy5jDTbxOYmUYw5U29WKMxxrM7AWo1ZcRkmw1aFXK5UhZhaffatGjtmHkx++4e5Ub4NuJQn
        gEgIyc1wsvYsfgJECCXkBQBbuhwCrpgE8LJjkOCKGQC/+nlG8FDi9Xl53MIlAOfGhxclAQB/
        6XcSYRZBxsI7zhJ+GEeRWfCTonYQJmFkJw67x++HHIVCEZkM63ojwpyV5B7Y3NCNhTFOPgFt
        C+ceYDGZAMv9rQSHV8CrH4/iYYyR62Bz0IVxE0nh3Jibz/WjYJW9GON898JTlX/zw76QLBHB
        yt6uxQjb4a+nR3AOr4S3OxoX+9FwauISEZ4NkoXw2MnXOO0pAHvbRhf5T0PnHyUgzMHIGPh1
        yyaOvh76BxZHWw6Pt88LuLYYHi+WcJCCZdMabg8IA1crcAegnEtyOZfkci7J4vzfqhrgdWA1
        Y2YNWQyrNCuW3rUHPHjpsc9fABXBu3E+wBMCH4BCjIoSDxfkayXiTN2hw4zFpLFY9QzrA6rQ
        SZdh0asyTKGvYszVKFTK+Hh5ggqp4pWIekS8JzVPKyGzdLnMmwxjZiwPdTyhKNrGQ23OI4lN
        6jyJ6542YszTKXo9UtYdWNgvuy3os27cH7CK1VXpPYXk96/A08wb6oQj67oeXbg2T9TqxduO
        bni/2TUg/7baFhlYU1Cf+tdC1Tb3k/VxBt9Tu6Y3pyH/WxtGvkmzu3ZFJQ9tmT5w8Mo7awvY
        WHecerbU0YEpvmza96F4bKi44uZs6XLXjk+bvrj58uP+sd8OI2HZ5c6ZmMKt4/sCz8TaRbIa
        Ue/6yDWH3C+ev3vL1XNx97PNzy2UJJX85BCsKBv5UXNtWT5THnw1reroRDkcPb/TIC2s8nzX
        559xRSsHtPPj//bnpfy+c9Vj6pQJPNkt0R784B95gNcwNX7mXiuFs9k6RSxmYXX/AY2zTCZy
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfUzMcRzH973fw/26uu3X1fh6qDiyOfTE9C2teZxfzDRmzFCnfqrpcrsr
        0squqewOeRpxTp0Kc0L95E61tM6FhJoKTUl1qdRJohR5uG62/nt9nl57bx8KEz3DZ1JxCYms
        IkEaLyYFuPGR2HPJ/obUSL/e1uVIV5+Bo6znJgIZT94C6OLXEj5qMGYT6I4xHyD16DUcNZbr
        SKSyCZCq9SiJHuunoZG6AYAq1D/4qH7iCYE+l1r4qGCsmLeSZkpvtvCYMm0bn9FzSUyGxUYw
        nEFNMoMPm0kmu9QAGC6zkGDMo3qCGeY8Gc5q44U77xSERLPxcQdZhW9opCC255oak7eGJj8d
        sxIqoAvQACcK0sug0WzkaYCAEtEVAGZ2l/0rqH8DCMvvrXPsuMH2DAthZxH9EUBrW7CdSVoC
        B7THJvvudAxsmujm2z0Y3YTD+6oazCG9i8Gi3HbMLnWiQ6GhSWA/cKO3wKq3xaSdcdobqn6X
        YHYW0kHwrKWCdLArrL1kxe2M0YvgyY5M4GAvaLLpMEe4OXCs+zrh6LvDy+oszBFoJzxx4Sdx
        Grhpp6i0U1TaKSrtlHM9wA1gBitXymJkSn+5fwJ7yEcplSmTEmJ8og7IODD5bsnCB8Bk+OJj
        BjwKmAGkMLG7sD0tNVIkjJYeTmEVByIUSfGs0gxmUbh4urBBUxshomOkiex+lpWziv9THuU0
        U8V78Kl667p9yeudloKo5nDz/KFUv5xx5+c2/dCRgoFdrrGwb7xaxJxptQZ5qHfMPziy/cOb
        K967Tb9WDXbd8FsTqlj/wiVsYdC7TenNlcGaS1pS+yM/b7jgnWSaJD1Xc0FWEz5etDF9bdy3
        7xsaqd3OyXhU5+yU+EClx2OAJRWWVVVHgxXItcucVci1vDz/6npB5d7VvbrF9fm+1obB4+/d
        PSciCK8i9qomZPuhP1XlaS5h33ZZd3TM7T93ap60uTxdXifkvP3qEN5Z6/varSfziWmz96hr
        yh7nNnnAgteBjRZr5/Aqblt/jqwlW3E7JPDi5rzcp6hrmX/YnxGPgLy+NWJcGSv1l2AKpfQv
        C8hfCF0DAAA=
X-CMS-MailID: 20210419003556epcas2p2ca56455c390ddec314ff2b8e9779b4ef
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
        <019b01d6e3dc$9a940330$cfbc0990$@samsung.com>
        <18999f48-7dc8-e859-8629-3b5cab764faa@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 11:44:35AM +0800, Yunsheng Lin wrote:
> 
> On 2021/1/6 11:32, Dongseok Yi wrote:
> > On 2021-01-06 12:07, Willem de Bruijn wrote:
> >>
> >> On Tue, Jan 5, 2021 at 8:29 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >>>
> >>> On 2021-01-05 06:03, Willem de Bruijn wrote:
> >>>>
> >>>> On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >>>>>
> >>>>> skbs in frag_list could be shared by pskb_expand_head() from BPF.
> >>>>
> >>>> Can you elaborate on the BPF connection?
> >>>
> >>> With the following registered ptypes,
> >>>
> >>> /proc/net # cat ptype
> >>> Type Device      Function
> >>> ALL           tpacket_rcv
> >>> 0800          ip_rcv.cfi_jt
> >>> 0011          llc_rcv.cfi_jt
> >>> 0004          llc_rcv.cfi_jt
> >>> 0806          arp_rcv
> >>> 86dd          ipv6_rcv.cfi_jt
> >>>
> >>> BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
> >>> (or ipv6_rcv). And it calls pskb_expand_head.
> >>>
> >>> [  132.051228] pskb_expand_head+0x360/0x378
> >>> [  132.051237] skb_ensure_writable+0xa0/0xc4
> >>> [  132.051249] bpf_skb_pull_data+0x28/0x60
> >>> [  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
> >>> [  132.051273] cls_bpf_classify+0x254/0x348
> >>> [  132.051284] tcf_classify+0xa4/0x180
> >>
> >> Ah, you have a BPF program loaded at TC. That was not entirely obvious.
> >>
> >> This program gets called after packet sockets with ptype_all, before
> >> those with a specific protocol.
> >>
> >> Tcpdump will have inserted a program with ptype_all, which cloned the
> >> skb. This triggers skb_ensure_writable -> pskb_expand_head ->
> >> skb_clone_fraglist -> skb_get.
> >>
> >>> [  132.051294] __netif_receive_skb_core+0x590/0xd28
> >>> [  132.051303] __netif_receive_skb+0x50/0x17c
> >>> [  132.051312] process_backlog+0x15c/0x1b8
> >>>
> >>>>
> >>>>> While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> >>>>> But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> >>>>> chain made by skb_segment_list().
> >>>>>
> >>>>> If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> >>>>> multiple ptypes can see this. The skb could be released by ptypes and
> >>>>> it causes use-after-free.
> >>>>
> >>>> If I understand correctly, a udp-gro-list skb makes it up the receive
> >>>> path with one or more active packet sockets.
> >>>>
> >>>> The packet socket will call skb_clone after accepting the filter. This
> >>>> replaces the head_skb, but shares the skb_shinfo and thus frag_list.
> >>>>
> >>>> udp_rcv_segment later converts the udp-gro-list skb to a list of
> >>>> regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> >>>> Now all the frags are fully fledged packets, with headers pushed
> >>>> before the payload. This does not change their refcount anymore than
> >>>> the skb_clone in pf_packet did. This should be 1.
> >>>>
> >>>> Eventually udp_recvmsg will call skb_consume_udp on each packet.
> >>>>
> >>>> The packet socket eventually also frees its cloned head_skb, which triggers
> >>>>
> >>>>   kfree_skb_list(shinfo->frag_list)
> >>>>     kfree_skb
> >>>>       skb_unref
> >>>>         refcount_dec_and_test(&skb->users)
> >>>
> >>> Every your understanding is right, but
> >>>
> >>>>
> >>>>>
> >>>>> [ 4443.426215] ------------[ cut here ]------------
> >>>>> [ 4443.426222] refcount_t: underflow; use-after-free.
> >>>>> [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> >>>>> refcount_dec_and_test_checked+0xa4/0xc8
> >>>>> [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> >>>>> [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> >>>>> [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> >>>>> [ 4443.426808] Call trace:
> >>>>> [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> >>>>> [ 4443.426823]  skb_release_data+0x144/0x264
> >>>>> [ 4443.426828]  kfree_skb+0x58/0xc4
> >>>>> [ 4443.426832]  skb_queue_purge+0x64/0x9c
> >>>>> [ 4443.426844]  packet_set_ring+0x5f0/0x820
> >>>>> [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> >>>>> [ 4443.426853]  __sys_setsockopt+0x188/0x278
> >>>>> [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> >>>>> [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> >>>>> [ 4443.426873]  el0_svc_handler+0x74/0x98
> >>>>> [ 4443.426880]  el0_svc+0x8/0xc
> >>>>>
> >>>>> Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> >>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> >>>>> ---
> >>>>>  net/core/skbuff.c | 20 +++++++++++++++++++-
> >>>>>  1 file changed, 19 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>>> index f62cae3..1dcbda8 100644
> >>>>> --- a/net/core/skbuff.c
> >>>>> +++ b/net/core/skbuff.c
> >>>>> @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>>>         unsigned int delta_truesize = 0;
> >>>>>         unsigned int delta_len = 0;
> >>>>>         struct sk_buff *tail = NULL;
> >>>>> -       struct sk_buff *nskb;
> >>>>> +       struct sk_buff *nskb, *tmp;
> >>>>> +       int err;
> >>>>>
> >>>>>         skb_push(skb, -skb_network_offset(skb) + offset);
> >>>>>
> >>>>> @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>>>                 nskb = list_skb;
> >>>>>                 list_skb = list_skb->next;
> >>>>>
> >>>>> +               err = 0;
> >>>>> +               if (skb_shared(nskb)) {
> >>>>
> >>>> I must be missing something still. This does not square with my
> >>>> understanding that the two sockets are operating on clones, with each
> >>>> frag_list skb having skb->users == 1.
> >>>>
> >>>> Unless the packet socket patch previously also triggered an
> >>>> skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
> >>>> calls skb_get on each frag_list skb.
> >>>
> >>> A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
> >>> with the original shinfo. pskb_expand_head reallocates the shinfo of
> >>> the skb and call skb_clone_fraglist. skb_release_data in
> >>> pskb_expand_head could not reduce skb->users of the each frag_list skb
> >>> if skb_shinfo(skb)->dataref == 2.
> >>>
> >>> After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
> >>> skb could have skb->users == 2.
> 
> Hi, Dongseok
>    I understand there is liner head data shared between the frag_list skb in the
> cloned skb(cloned by pf_packet?) and original skb, which should not be shared
> when skb_segment_list() converts the frag_list skb into regular packet.
> 
>    But both skb->users of original and cloned skb is one(skb_shinfo(skb)->dataref
> is one for both skb too), and skb->users of each fraglist skb is two because both
> original and cloned skb is linking to the same fraglist pointer, and there is
> "skb_shinfo(skb)->frag_list = NULL" for original skb in the begin of skb_segment_list(),
> if kfree_skb() is called with original skb, the fraglist skb will not be freed.
> If kfree_skb is called with original skb,cloned skb and each fraglist skb here, the
> reference counter for three of them seem right here, so why is there a refcount_t
> warning in the commit log? am I missing something obvious here?
> 
> Sorry for bringing up this thread again.

A skb which detects use-after-free was not a part of frag_list. Please
check the commit msg once again.

Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
a link for the same frag_skbs chain. If a new skb (*not frags*) is
queued to one of the sk_receive_queue, multiple ptypes can see and
release this. It causes use-after-free.

> 
> >>
> >> Yes, that makes sense. skb_clone_fraglist just increments the
> >> frag_list skb's refcounts.
> >>
> >> skb_segment_list must create an unshared struct sk_buff before it
> >> changes skb data to insert the protocol headers.
> >>



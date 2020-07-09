Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6119421A50F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgGIQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 12:47:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbgGIQrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 12:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594313217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D4Cg9v+84VMg0C0I/7y/8js1maQVdLrkCx8erNImFT4=;
        b=cXALfgvO4X9RSv/Umz9dUqN8g0jr3pzvbuzjO5t210tWA60as54to94ceeIevS0+1cpfQB
        0x3k2/a/rMs+MGYDOqq94THKrv9qkTODaUqS01mIHAfbFGDdQPbk54uvVVKW6aNYek6oJX
        ZcYw5aak3TVKAhTcO2CySttwffRldZs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-g2Ip-gttPw2dwO2X2XbEZg-1; Thu, 09 Jul 2020 12:46:52 -0400
X-MC-Unique: g2Ip-gttPw2dwO2X2XbEZg-1
Received: by mail-qk1-f197.google.com with SMTP id 124so2227199qko.8
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 09:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D4Cg9v+84VMg0C0I/7y/8js1maQVdLrkCx8erNImFT4=;
        b=PwHxBfr1B9NIISSFFcdIJr2I1iuaBuSc9wGLFHHVxwNzbTked+IRarp5wDkQ/yQDxH
         3meKo6cJENL5wnScnHeDYmukD/y343LswjWq8nmEUWibHNDUI5SgpS8JsHebVFdBfstf
         TiB9RqjUpdwXYU9XBX9k+CCx8wpS/L1Kn29EpzusOPP47isZpBR8DhEYWUqhdOleI1tu
         5R+kPGTriaCwSYMYA13Tl04vW2e/Dg5rCawbieWDvwwgNL4O/3Px90WOlDxj6QlqNrCj
         JXqEGZfNb0utGuOStzshcjck5Xb2s7BuviYlk2q0YkMORHNYYS0z7HSvyRXtG6YM1jjg
         vfAw==
X-Gm-Message-State: AOAM531n1SuaJVC0k61hsSfX1eSTZxE4AsON2J08/CpaEQDcO7YOWT1D
        lSs1py3yraPGaKXdO+RERB8fhBqhEU8gxu2cwm58WxWILNjZyU65Y6/7QK5Hb9RD8zTFMrCDxd2
        Beaav4BBnjgupl9+/mH1uchfURu8kn0Hx
X-Received: by 2002:a37:65cc:: with SMTP id z195mr59036250qkb.89.1594313211127;
        Thu, 09 Jul 2020 09:46:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTCb5vd1Hs1jyJ0qDv8+IsCPL46nzfxSl4UHDVv90mTc6mCNdWipZ9ROiPdYKJ28Q4nZ1mgsR3IDZPTPq64R4=
X-Received: by 2002:a37:65cc:: with SMTP id z195mr59036210qkb.89.1594313210696;
 Thu, 09 Jul 2020 09:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
 <20200622114622-mutt-send-email-mst@kernel.org> <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
 <20200622122546-mutt-send-email-mst@kernel.org> <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com> <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com>
In-Reply-To: <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 9 Jul 2020 18:46:13 +0200
Message-ID: <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 4:10 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/7/1 =E4=B8=8B=E5=8D=889:04, Eugenio Perez Martin wrote:
> > On Wed, Jul 1, 2020 at 2:40 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/7/1 =E4=B8=8B=E5=8D=886:43, Eugenio Perez Martin wrote:
> >>> On Tue, Jun 23, 2020 at 6:15 PM Eugenio Perez Martin
> >>> <eperezma@redhat.com> wrote:
> >>>> On Mon, Jun 22, 2020 at 6:29 PM Michael S. Tsirkin <mst@redhat.com> =
wrote:
> >>>>> On Mon, Jun 22, 2020 at 06:11:21PM +0200, Eugenio Perez Martin wrot=
e:
> >>>>>> On Mon, Jun 22, 2020 at 5:55 PM Michael S. Tsirkin <mst@redhat.com=
> wrote:
> >>>>>>> On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin wr=
ote:
> >>>>>>>> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> >>>>>>>> <eperezma@redhat.com> wrote:
> >>>>>>>>> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> >>>>>>>>> <konrad.wilk@oracle.com> wrote:
> >>>>>>>>>> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin w=
rote:
> >>>>>>>>>>> As testing shows no performance change, switch to that now.
> >>>>>>>>>> What kind of testing? 100GiB? Low latency?
> >>>>>>>>>>
> >>>>>>>>> Hi Konrad.
> >>>>>>>>>
> >>>>>>>>> I tested this version of the patch:
> >>>>>>>>> https://lkml.org/lkml/2019/10/13/42
> >>>>>>>>>
> >>>>>>>>> It was tested for throughput with DPDK's testpmd (as described =
in
> >>>>>>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_pat=
h.html)
> >>>>>>>>> and kernel pktgen. No latency tests were performed by me. Maybe=
 it is
> >>>>>>>>> interesting to perform a latency test or just a different set o=
f tests
> >>>>>>>>> over a recent version.
> >>>>>>>>>
> >>>>>>>>> Thanks!
> >>>>>>>> I have repeated the tests with v9, and results are a little bit =
different:
> >>>>>>>> * If I test opening it with testpmd, I see no change between ver=
sions
> >>>>>>> OK that is testpmd on guest, right? And vhost-net on the host?
> >>>>>>>
> >>>>>> Hi Michael.
> >>>>>>
> >>>>>> No, sorry, as described in
> >>>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.h=
tml.
> >>>>>> But I could add to test it in the guest too.
> >>>>>>
> >>>>>> These kinds of raw packets "bursts" do not show performance
> >>>>>> differences, but I could test deeper if you think it would be wort=
h
> >>>>>> it.
> >>>>> Oh ok, so this is without guest, with virtio-user.
> >>>>> It might be worth checking dpdk within guest too just
> >>>>> as another data point.
> >>>>>
> >>>> Ok, I will do it!
> >>>>
> >>>>>>>> * If I forward packets between two vhost-net interfaces in the g=
uest
> >>>>>>>> using a linux bridge in the host:
> >>>>>>> And here I guess you mean virtio-net in the guest kernel?
> >>>>>> Yes, sorry: Two virtio-net interfaces connected with a linux bridg=
e in
> >>>>>> the host. More precisely:
> >>>>>> * Adding one of the interfaces to another namespace, assigning it =
an
> >>>>>> IP, and starting netserver there.
> >>>>>> * Assign another IP in the range manually to the other virtual net
> >>>>>> interface, and start the desired test there.
> >>>>>>
> >>>>>> If you think it would be better to perform then differently please=
 let me know.
> >>>>> Not sure why you bother with namespaces since you said you are
> >>>>> using L2 bridging. I guess it's unimportant.
> >>>>>
> >>>> Sorry, I think I should have provided more context about that.
> >>>>
> >>>> The only reason to use namespaces is to force the traffic of these
> >>>> netperf tests to go through the external bridge. To test netperf
> >>>> different possibilities than the testpmd (or pktgen or others "blast
> >>>> of frames unconditionally" tests).
> >>>>
> >>>> This way, I make sure that is the same version of everything in the
> >>>> guest, and is a little bit easier to manage cpu affinity, start and
> >>>> stop testing...
> >>>>
> >>>> I could use a different VM for sending and receiving, but I find thi=
s
> >>>> way a faster one and it should not introduce a lot of noise. I can
> >>>> test with two VM if you think that this use of network namespace
> >>>> introduces too much noise.
> >>>>
> >>>> Thanks!
> >>>>
> >>>>>>>>     - netperf UDP_STREAM shows a performance increase of 1.8, al=
most
> >>>>>>>> doubling performance. This gets lower as frame size increase.
> >>> Regarding UDP_STREAM:
> >>> * with event_idx=3Don: The performance difference is reduced a lot if
> >>> applied affinity properly (manually assigning CPU on host/guest and
> >>> setting IRQs on guest), making them perform equally with and without
> >>> the patch again. Maybe the batching makes the scheduler perform
> >>> better.
> >>
> >> Note that for UDP_STREAM, the result is pretty trick to be analyzed. E=
.g
> >> setting a sndbuf for TAP may help for the performance (reduce the drop=
).
> >>
> > Ok, will add that to the test. Thanks!
>
>
> Actually, it's better to skip the UDP_STREAM test since:
>
> - My understanding is very few application is using raw UDP stream
> - It's hard to analyze (usually you need to count the drop ratio etc)
>
>
> >
> >>>>>>>>     - rests of the test goes noticeably worse: UDP_RR goes from =
~6347
> >>>>>>>> transactions/sec to 5830
> >>> * Regarding UDP_RR, TCP_STREAM, and TCP_RR, proper CPU pinning makes
> >>> them perform similarly again, only a very small performance drop
> >>> observed. It could be just noise.
> >>> ** All of them perform better than vanilla if event_idx=3Doff, not su=
re
> >>> why. I can try to repeat them if you suspect that can be a test
> >>> failure.
> >>>
> >>> * With testpmd and event_idx=3Doff, if I send from the VM to host, I =
see
> >>> a performance increment especially in small packets. The buf api also
> >>> increases performance compared with only batching: Sending the minimu=
m
> >>> packet size in testpmd makes pps go from 356kpps to 473 kpps.
> >>
> >> What's your setup for this. The number looks rather low. I'd expected
> >> 1-2 Mpps at least.
> >>
> > Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz, 2 NUMA nodes of 16G memory
> > each, and no device assigned to the NUMA node I'm testing in. Too low
> > for testpmd AF_PACKET driver too?
>
>
> I don't test AF_PACKET, I guess it should use the V3 which mmap based
> zerocopy interface.
>
> And it might worth to check the cpu utilization of vhost thread. It's
> required to stress it as 100% otherwise there could be a bottleneck
> somewhere.
>
>
> >
> >>> Sending
> >>> 1024 length UDP-PDU makes it go from 570kpps to 64 kpps.
> >>>
> >>> Something strange I observe in these tests: I get more pps the bigger
> >>> the transmitted buffer size is. Not sure why.
> >>>
> >>> ** Sending from the host to the VM does not make a big change with th=
e
> >>> patches in small packets scenario (minimum, 64 bytes, about 645
> >>> without the patch, ~625 with batch and batch+buf api). If the packets
> >>> are bigger, I can see a performance increase: with 256 bits,
> >>
> >> I think you meant bytes?
> >>
> > Yes, sorry.
> >
> >>>    it goes
> >>> from 590kpps to about 600kpps, and in case of 1500 bytes payload it
> >>> gets from 348kpps to 528kpps, so it is clearly an improvement.
> >>>
> >>> * with testpmd and event_idx=3Don, batching+buf api perform similarly=
 in
> >>> both directions.
> >>>
> >>> All of testpmd tests were performed with no linux bridge, just a
> >>> host's tap interface (<interface type=3D'ethernet'> in xml),
> >>
> >> What DPDK driver did you use in the test (AF_PACKET?).
> >>
> > Yes, both testpmd are using AF_PACKET driver.
>
>
> I see, using AF_PACKET means extra layers of issues need to be analyzed
> which is probably not good.
>
>
> >
> >>> with a
> >>> testpmd txonly and another in rxonly forward mode, and using the
> >>> receiving side packets/bytes data. Guest's rps, xps and interrupts,
> >>> and host's vhost threads affinity were also tuned in each test to
> >>> schedule both testpmd and vhost in different processors.
> >>
> >> My feeling is that if we start from simple setup, it would be more
> >> easier as a start. E.g start without an VM.
> >>
> >> 1) TX: testpmd(txonly) -> virtio-user -> vhost_net -> XDP_DROP on TAP
> >> 2) RX: pkgetn -> TAP -> vhost_net -> testpmd(rxonly)
> >>
> > Got it. Is there a reason to prefer pktgen over testpmd?
>
>
> I think the reason is using testpmd you must use a userspace kernel
> interface (AF_PACKET), and it could not be as fast as pktgen since:
>
> - it talks directly to xmit of TAP
> - skb can be cloned
>

Hi!

Here it is the result of the tests. Details on [1].

Tx:
=3D=3D=3D

For tx packets it seems that the batching patch makes things a little
bit worse, but the buf_api outperforms baseline by a 7%:

* We start with a baseline of 4208772.571 pps and 269361444.6 bytes/s [2].
* When we add the batching, I see a small performance decrease:
4133292.308 and 264530707.7 bytes/s.
* However, the buf api it outperform the baseline: 4551319.631pps,
291205178.1 bytes/s

I don't have numbers on the receiver side since it is just a XDP_DROP.
I think it would be interesting to see them.

Rx:
=3D=3D=3D

Regarding Rx, the reverse is observed: a small performance increase is
observed with batching (~2%), but buf_api makes tests perform equally
to baseline.

pktgen was called using pktgen_sample01_simple.sh, with the environment:
DEV=3D"$tap_name" F_THREAD=3D1 DST_MAC=3D$MAC_ADDR COUNT=3D$((2500000*25))
SKB_CLONE=3D$((2**31))

And testpmd is the same as Tx but with forward-mode=3Drxonly.

Pktgen reports:
Baseline: 1853025pps 622Mb/sec (622616400bps) errors: 7915231
Batch: 1891404pps 635Mb/sec (635511744bps) errors: 4926093
Buf_api: 1844008pps 619Mb/sec (619586688bps) errors: 47766692

Testpmd reports:
Baseline: 1854448pps, 860464156 bps. [3]
Batch: 1892844.25pps, 878280070bps.
Buf_api: 1846139.75pps, 856609120bps.

Any thoughts?

Thanks!

[1]
Testpmd options: -l 1,3
--vdev=3Dvirtio_user0,mac=3D01:02:03:04:05:06,path=3D/dev/vhost-net,queue_s=
ize=3D1024
-- --auto-start --stats-period 5 --tx-offloads=3D"$TX_OFFLOADS"
--rx-offloads=3D"$RX_OFFLOADS" --txd=3D4096 --rxd=3D4096 --burst=3D512
--forward-mode=3Dtxonly

Where offloads were obtained manually running with
--[tr]x-offloads=3D0x8fff and examining testpmd response:
declare -r RX_OFFLOADS=3D0x81d
declare -r TX_OFFLOADS=3D0x802d

All of the tests results are an average of at least 3 samples of
testpmd, discarding the obvious deviations at start/end (like warming
up or waiting for pktgen to start). The result of pktgen is directly
c&p from its output.

The numbers do not change very much from one stats printing to another
of testpmd.

[2] Obtained subtracting each accumulated tx-packets from one stats
print to the previous one. If we attend testpmd output about Tx-pps,
it counts a little bit less performance, but it follows the same
pattern:

Testpmd pps/bps stats:
Baseline: 3510826.25 pps, 1797887912bps =3D 224735989bytes/sec
Batch: 3448515.571pps, 1765640226bps =3D 220705028.3bytes/sec
Buf api: 3794115.333pps, 1942587286bps =3D 242823410.8bytes/sec

[3] This is obtained using the rx-pps/rx-bps report of testpmd.

Seems strange to me that the relation between pps/bps is ~336 this
time, and between accumulated pkts/accumulated bytes is ~58. Also, the
relation between them is not even close to 8.

However, testpmd shows a lot of absolute packets received. If we see
the received packets in a period subtracting from the previous one,
testpmd tells that receive more pps than pktgen tx-pps:
Baseline: ~2222668.667pps 128914784.3bps.
Batch: 2269260.933pps, 131617134.9bps
Buf_api: 2213226.467pps, 128367135.9bp


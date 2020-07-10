Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694A521AED8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 07:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgGJFkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 01:40:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31829 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727005AbgGJFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 01:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594359608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhOEC2tRp89fH1G6ExUzgv0xTUEDm3brL8ltbXrqFVw=;
        b=Uq9gIP7lXJuGMvIofzZNppK4abGn5M1z+5zkjujRQbzZ8DcFbWw/8BlA9QmuMnIOKBp83M
        8HExRkUznpTW3RYJmMr4JrfPn0v/16e6YDxUxThdDEOqqp7TbhK9ap/8tqh7RnL1NYwpcz
        FynHGnIw6hJEiHIC/vy6GUslyk5McJM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-n4st8JhhMoiHkjcSGNC6tg-1; Fri, 10 Jul 2020 01:40:04 -0400
X-MC-Unique: n4st8JhhMoiHkjcSGNC6tg-1
Received: by mail-qk1-f197.google.com with SMTP id i145so3642963qke.2
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 22:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hhOEC2tRp89fH1G6ExUzgv0xTUEDm3brL8ltbXrqFVw=;
        b=mus5EyQIkQ8F1DswQjQpmmN7M0mBDZRCy1WmmeYa6GA6kHh8iP3omsj8dIFR3vsZR9
         bs3NUwu3uxZdKJbulRoUO5lFG8hXk9HjSt4dHONiEPc1KLnPham+vo8PZQZUPjIispO6
         xFh2xqnrB/A/xyFm/SNxoKoYE7quQPyfU7N7YBuEMFcicJxNLl8wti7dzjk2D5i7ic5I
         3aQpS9AAY/OZh5IFbEeDSR9u/Syjp5AG6H9tVMGhHwKZO1yedFZep/P8E0oAnzE2LhTL
         1fdkzwSUTKb/hdBKFiGQp3a54oujEWMG9DkOdgtmjp4G0TjJEm3WCnADh+kzdmIYQjLX
         cmiA==
X-Gm-Message-State: AOAM532OT5uZgAN6kV3tNpy8s6KOAg9OZZ9CoV85LbFvynrSyIIP0xL1
        Za8e6AGct0RMTscMHypZ5LIOXhKczNaSsF+JwFiLochDvF7pMxJrl56bTwnj+aSffquVOZQuObM
        7XBE7tHb6OC1sbRcVrJfymie+NnMqIIjr
X-Received: by 2002:aed:2a75:: with SMTP id k50mr67356222qtf.27.1594359603349;
        Thu, 09 Jul 2020 22:40:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuFK7RtO6FVj8vK6txR9qyU141Cs9M32EyhXqgF4hlbvLthFYXy0BOzkCAo1I2N365RH/19xdV8BAXnLW5hGo=
X-Received: by 2002:aed:2a75:: with SMTP id k50mr67356200qtf.27.1594359602919;
 Thu, 09 Jul 2020 22:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
 <20200622114622-mutt-send-email-mst@kernel.org> <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
 <20200622122546-mutt-send-email-mst@kernel.org> <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com> <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com> <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org> <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
In-Reply-To: <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 10 Jul 2020 07:39:26 +0200
Message-ID: <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
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

On Fri, Jul 10, 2020 at 5:56 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/7/10 =E4=B8=8A=E5=8D=881:37, Michael S. Tsirkin wrote:
> > On Thu, Jul 09, 2020 at 06:46:13PM +0200, Eugenio Perez Martin wrote:
> >> On Wed, Jul 1, 2020 at 4:10 PM Jason Wang <jasowang@redhat.com> wrote:
> >>>
> >>> On 2020/7/1 =E4=B8=8B=E5=8D=889:04, Eugenio Perez Martin wrote:
> >>>> On Wed, Jul 1, 2020 at 2:40 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>>> On 2020/7/1 =E4=B8=8B=E5=8D=886:43, Eugenio Perez Martin wrote:
> >>>>>> On Tue, Jun 23, 2020 at 6:15 PM Eugenio Perez Martin
> >>>>>> <eperezma@redhat.com> wrote:
> >>>>>>> On Mon, Jun 22, 2020 at 6:29 PM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >>>>>>>> On Mon, Jun 22, 2020 at 06:11:21PM +0200, Eugenio Perez Martin w=
rote:
> >>>>>>>>> On Mon, Jun 22, 2020 at 5:55 PM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> >>>>>>>>>> On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin=
 wrote:
> >>>>>>>>>>> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> >>>>>>>>>>> <eperezma@redhat.com> wrote:
> >>>>>>>>>>>> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> >>>>>>>>>>>> <konrad.wilk@oracle.com> wrote:
> >>>>>>>>>>>>> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirki=
n wrote:
> >>>>>>>>>>>>>> As testing shows no performance change, switch to that now=
.
> >>>>>>>>>>>>> What kind of testing? 100GiB? Low latency?
> >>>>>>>>>>>>>
> >>>>>>>>>>>> Hi Konrad.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I tested this version of the patch:
> >>>>>>>>>>>> https://lkml.org/lkml/2019/10/13/42
> >>>>>>>>>>>>
> >>>>>>>>>>>> It was tested for throughput with DPDK's testpmd (as describ=
ed in
> >>>>>>>>>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_=
path.html)
> >>>>>>>>>>>> and kernel pktgen. No latency tests were performed by me. Ma=
ybe it is
> >>>>>>>>>>>> interesting to perform a latency test or just a different se=
t of tests
> >>>>>>>>>>>> over a recent version.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Thanks!
> >>>>>>>>>>> I have repeated the tests with v9, and results are a little b=
it different:
> >>>>>>>>>>> * If I test opening it with testpmd, I see no change between =
versions
> >>>>>>>>>> OK that is testpmd on guest, right? And vhost-net on the host?
> >>>>>>>>>>
> >>>>>>>>> Hi Michael.
> >>>>>>>>>
> >>>>>>>>> No, sorry, as described in
> >>>>>>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_pat=
h.html.
> >>>>>>>>> But I could add to test it in the guest too.
> >>>>>>>>>
> >>>>>>>>> These kinds of raw packets "bursts" do not show performance
> >>>>>>>>> differences, but I could test deeper if you think it would be w=
orth
> >>>>>>>>> it.
> >>>>>>>> Oh ok, so this is without guest, with virtio-user.
> >>>>>>>> It might be worth checking dpdk within guest too just
> >>>>>>>> as another data point.
> >>>>>>>>
> >>>>>>> Ok, I will do it!
> >>>>>>>
> >>>>>>>>>>> * If I forward packets between two vhost-net interfaces in th=
e guest
> >>>>>>>>>>> using a linux bridge in the host:
> >>>>>>>>>> And here I guess you mean virtio-net in the guest kernel?
> >>>>>>>>> Yes, sorry: Two virtio-net interfaces connected with a linux br=
idge in
> >>>>>>>>> the host. More precisely:
> >>>>>>>>> * Adding one of the interfaces to another namespace, assigning =
it an
> >>>>>>>>> IP, and starting netserver there.
> >>>>>>>>> * Assign another IP in the range manually to the other virtual =
net
> >>>>>>>>> interface, and start the desired test there.
> >>>>>>>>>
> >>>>>>>>> If you think it would be better to perform then differently ple=
ase let me know.
> >>>>>>>> Not sure why you bother with namespaces since you said you are
> >>>>>>>> using L2 bridging. I guess it's unimportant.
> >>>>>>>>
> >>>>>>> Sorry, I think I should have provided more context about that.
> >>>>>>>
> >>>>>>> The only reason to use namespaces is to force the traffic of thes=
e
> >>>>>>> netperf tests to go through the external bridge. To test netperf
> >>>>>>> different possibilities than the testpmd (or pktgen or others "bl=
ast
> >>>>>>> of frames unconditionally" tests).
> >>>>>>>
> >>>>>>> This way, I make sure that is the same version of everything in t=
he
> >>>>>>> guest, and is a little bit easier to manage cpu affinity, start a=
nd
> >>>>>>> stop testing...
> >>>>>>>
> >>>>>>> I could use a different VM for sending and receiving, but I find =
this
> >>>>>>> way a faster one and it should not introduce a lot of noise. I ca=
n
> >>>>>>> test with two VM if you think that this use of network namespace
> >>>>>>> introduces too much noise.
> >>>>>>>
> >>>>>>> Thanks!
> >>>>>>>
> >>>>>>>>>>>      - netperf UDP_STREAM shows a performance increase of 1.8=
, almost
> >>>>>>>>>>> doubling performance. This gets lower as frame size increase.
> >>>>>> Regarding UDP_STREAM:
> >>>>>> * with event_idx=3Don: The performance difference is reduced a lot=
 if
> >>>>>> applied affinity properly (manually assigning CPU on host/guest an=
d
> >>>>>> setting IRQs on guest), making them perform equally with and witho=
ut
> >>>>>> the patch again. Maybe the batching makes the scheduler perform
> >>>>>> better.
> >>>>> Note that for UDP_STREAM, the result is pretty trick to be analyzed=
. E.g
> >>>>> setting a sndbuf for TAP may help for the performance (reduce the d=
rop).
> >>>>>
> >>>> Ok, will add that to the test. Thanks!
> >>>
> >>> Actually, it's better to skip the UDP_STREAM test since:
> >>>
> >>> - My understanding is very few application is using raw UDP stream
> >>> - It's hard to analyze (usually you need to count the drop ratio etc)
> >>>
> >>>
> >>>>>>>>>>>      - rests of the test goes noticeably worse: UDP_RR goes f=
rom ~6347
> >>>>>>>>>>> transactions/sec to 5830
> >>>>>> * Regarding UDP_RR, TCP_STREAM, and TCP_RR, proper CPU pinning mak=
es
> >>>>>> them perform similarly again, only a very small performance drop
> >>>>>> observed. It could be just noise.
> >>>>>> ** All of them perform better than vanilla if event_idx=3Doff, not=
 sure
> >>>>>> why. I can try to repeat them if you suspect that can be a test
> >>>>>> failure.
> >>>>>>
> >>>>>> * With testpmd and event_idx=3Doff, if I send from the VM to host,=
 I see
> >>>>>> a performance increment especially in small packets. The buf api a=
lso
> >>>>>> increases performance compared with only batching: Sending the min=
imum
> >>>>>> packet size in testpmd makes pps go from 356kpps to 473 kpps.
> >>>>> What's your setup for this. The number looks rather low. I'd expect=
ed
> >>>>> 1-2 Mpps at least.
> >>>>>
> >>>> Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz, 2 NUMA nodes of 16G memor=
y
> >>>> each, and no device assigned to the NUMA node I'm testing in. Too lo=
w
> >>>> for testpmd AF_PACKET driver too?
> >>>
> >>> I don't test AF_PACKET, I guess it should use the V3 which mmap based
> >>> zerocopy interface.
> >>>
> >>> And it might worth to check the cpu utilization of vhost thread. It's
> >>> required to stress it as 100% otherwise there could be a bottleneck
> >>> somewhere.
> >>>
> >>>
> >>>>>> Sending
> >>>>>> 1024 length UDP-PDU makes it go from 570kpps to 64 kpps.
> >>>>>>
> >>>>>> Something strange I observe in these tests: I get more pps the big=
ger
> >>>>>> the transmitted buffer size is. Not sure why.
> >>>>>>
> >>>>>> ** Sending from the host to the VM does not make a big change with=
 the
> >>>>>> patches in small packets scenario (minimum, 64 bytes, about 645
> >>>>>> without the patch, ~625 with batch and batch+buf api). If the pack=
ets
> >>>>>> are bigger, I can see a performance increase: with 256 bits,
> >>>>> I think you meant bytes?
> >>>>>
> >>>> Yes, sorry.
> >>>>
> >>>>>>     it goes
> >>>>>> from 590kpps to about 600kpps, and in case of 1500 bytes payload i=
t
> >>>>>> gets from 348kpps to 528kpps, so it is clearly an improvement.
> >>>>>>
> >>>>>> * with testpmd and event_idx=3Don, batching+buf api perform simila=
rly in
> >>>>>> both directions.
> >>>>>>
> >>>>>> All of testpmd tests were performed with no linux bridge, just a
> >>>>>> host's tap interface (<interface type=3D'ethernet'> in xml),
> >>>>> What DPDK driver did you use in the test (AF_PACKET?).
> >>>>>
> >>>> Yes, both testpmd are using AF_PACKET driver.
> >>>
> >>> I see, using AF_PACKET means extra layers of issues need to be analyz=
ed
> >>> which is probably not good.
> >>>
> >>>
> >>>>>> with a
> >>>>>> testpmd txonly and another in rxonly forward mode, and using the
> >>>>>> receiving side packets/bytes data. Guest's rps, xps and interrupts=
,
> >>>>>> and host's vhost threads affinity were also tuned in each test to
> >>>>>> schedule both testpmd and vhost in different processors.
> >>>>> My feeling is that if we start from simple setup, it would be more
> >>>>> easier as a start. E.g start without an VM.
> >>>>>
> >>>>> 1) TX: testpmd(txonly) -> virtio-user -> vhost_net -> XDP_DROP on T=
AP
> >>>>> 2) RX: pkgetn -> TAP -> vhost_net -> testpmd(rxonly)
> >>>>>
> >>>> Got it. Is there a reason to prefer pktgen over testpmd?
> >>>
> >>> I think the reason is using testpmd you must use a userspace kernel
> >>> interface (AF_PACKET), and it could not be as fast as pktgen since:
> >>>
> >>> - it talks directly to xmit of TAP
> >>> - skb can be cloned
> >>>
> >> Hi!
> >>
> >> Here it is the result of the tests. Details on [1].
> >>
> >> Tx:
> >> =3D=3D=3D
> >>
> >> For tx packets it seems that the batching patch makes things a little
> >> bit worse, but the buf_api outperforms baseline by a 7%:
> >>
> >> * We start with a baseline of 4208772.571 pps and 269361444.6 bytes/s =
[2].
> >> * When we add the batching, I see a small performance decrease:
> >> 4133292.308 and 264530707.7 bytes/s.
> >> * However, the buf api it outperform the baseline: 4551319.631pps,
> >> 291205178.1 bytes/s
> >>
> >> I don't have numbers on the receiver side since it is just a XDP_DROP.
> >> I think it would be interesting to see them.
> >>
> >> Rx:
> >> =3D=3D=3D
> >>
> >> Regarding Rx, the reverse is observed: a small performance increase is
> >> observed with batching (~2%), but buf_api makes tests perform equally
> >> to baseline.
> >>
> >> pktgen was called using pktgen_sample01_simple.sh, with the environmen=
t:
> >> DEV=3D"$tap_name" F_THREAD=3D1 DST_MAC=3D$MAC_ADDR COUNT=3D$((2500000*=
25))
> >> SKB_CLONE=3D$((2**31))
> >>
> >> And testpmd is the same as Tx but with forward-mode=3Drxonly.
> >>
> >> Pktgen reports:
> >> Baseline: 1853025pps 622Mb/sec (622616400bps) errors: 7915231
> >> Batch: 1891404pps 635Mb/sec (635511744bps) errors: 4926093
> >> Buf_api: 1844008pps 619Mb/sec (619586688bps) errors: 47766692
> >>
> >> Testpmd reports:
> >> Baseline: 1854448pps, 860464156 bps. [3]
> >> Batch: 1892844.25pps, 878280070bps.
> >> Buf_api: 1846139.75pps, 856609120bps.
> >>
> >> Any thoughts?
> >>
> >> Thanks!
> >>
> >> [1]
> >> Testpmd options: -l 1,3
> >> --vdev=3Dvirtio_user0,mac=3D01:02:03:04:05:06,path=3D/dev/vhost-net,qu=
eue_size=3D1024
> >> -- --auto-start --stats-period 5 --tx-offloads=3D"$TX_OFFLOADS"
> >> --rx-offloads=3D"$RX_OFFLOADS" --txd=3D4096 --rxd=3D4096 --burst=3D512
> >> --forward-mode=3Dtxonly
> >>
> >> Where offloads were obtained manually running with
> >> --[tr]x-offloads=3D0x8fff and examining testpmd response:
> >> declare -r RX_OFFLOADS=3D0x81d
> >> declare -r TX_OFFLOADS=3D0x802d
> >>
> >> All of the tests results are an average of at least 3 samples of
> >> testpmd, discarding the obvious deviations at start/end (like warming
> >> up or waiting for pktgen to start). The result of pktgen is directly
> >> c&p from its output.
> >>
> >> The numbers do not change very much from one stats printing to another
> >> of testpmd.
> >>
> >> [2] Obtained subtracting each accumulated tx-packets from one stats
> >> print to the previous one. If we attend testpmd output about Tx-pps,
> >> it counts a little bit less performance, but it follows the same
> >> pattern:
> >>
> >> Testpmd pps/bps stats:
> >> Baseline: 3510826.25 pps, 1797887912bps =3D 224735989bytes/sec
> >> Batch: 3448515.571pps, 1765640226bps =3D 220705028.3bytes/sec
> >> Buf api: 3794115.333pps, 1942587286bps =3D 242823410.8bytes/sec
> >>
> >> [3] This is obtained using the rx-pps/rx-bps report of testpmd.
> >>
> >> Seems strange to me that the relation between pps/bps is ~336 this
> >> time, and between accumulated pkts/accumulated bytes is ~58. Also, the
> >> relation between them is not even close to 8.
> >>
> >> However, testpmd shows a lot of absolute packets received. If we see
> >> the received packets in a period subtracting from the previous one,
> >> testpmd tells that receive more pps than pktgen tx-pps:
> >> Baseline: ~2222668.667pps 128914784.3bps.
> >> Batch: 2269260.933pps, 131617134.9bps
> >> Buf_api: 2213226.467pps, 128367135.9bp
> > How about playing with the batch size? Make it a mod parameter instead
> > of the hard coded 64, and measure for all values 1 to 64 ...
>
>
> Right, according to the test result, 64 seems to be too aggressive in
> the case of TX.
>

Got it, thanks both!

> And it might also be worth to check:
>
> 1) Whether vhost thread is stressed as 100% CPU utilization, if not,
> there's bottleneck elsewhere

I forgot to check this, sorry. Will check in the next test.

> 2) For RX test, make sure pktgen kthread is running in the same NUMA
> node with virtio-user
>

It is allocated 1 thread in lcore 1 (F_THREAD=3D1) which belongs to the
same NUMA as testpmd. Actually, it is the testpmd master core, so it
should be a good idea to move it to another lcore of the same NUMA
node.

Is this enough for pktgen to allocate the memory in that numa node?
Since the script only write parameters to /proc, I assume that it has
no effect to run it under numactl/taskset, and pktgen will allocate
memory based on the lcore is running. Am I right?

Thanks!

> Thanks
>
>
> >
>


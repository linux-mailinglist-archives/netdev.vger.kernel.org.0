Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F72210BBC
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgGANFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:05:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35680 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730556AbgGANFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593608719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FXzJqt67e31ApHvs5SUuF//sO/9X3G5nc+xRenGHB1E=;
        b=isE+EmlmqYvjuG57EkHQhpNaKMkkIEm66RW4RBMk3+iKfNxjjPl6BLBhbUTM50bagEvvnc
        wZbEx0KKooOty1uUsd+wSTV1BqoXL6WNwKflEyjFb7tzn5a7zqE0MJrHfmbCH8PXusSn1q
        +lki1NVozQkphKxmSwzxd4M7KTxdZjY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-A3Z-s_pgNpuqgj0-QpFNuA-1; Wed, 01 Jul 2020 09:05:15 -0400
X-MC-Unique: A3Z-s_pgNpuqgj0-QpFNuA-1
Received: by mail-qk1-f199.google.com with SMTP id a205so16986400qkc.16
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 06:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FXzJqt67e31ApHvs5SUuF//sO/9X3G5nc+xRenGHB1E=;
        b=ak4VkhybfmDxkaUfMPHbYWjhzN5eV7pMaV5bzilXPRh7jqa74Jo3P6MTOfsZ3+Pl5Y
         7ketHFbFC3PazZF+WVCv2MDIPs+q7aAJ+ZXr5x39dJHOYYA2OyA7rIwhAOu0xhZya7HH
         SxXjnyokdcJfJ4Ab0/OguHq29aZK1EFKd04I8TrAatKyEwNgZAxxa5G+MWnwyCsr8Q8H
         pcxux+PGuECDZd1yumSVPJQRs+cVkVT8McFuBp9W88OR1/Uj3UXX3O6epgzSy31P5gMt
         7N/BJYHqdUxQQnj4BVKBZp/Q2mxBVtwyPT4eDeKmaHIA35cdVTymioiWolJModCLzI2m
         ihfQ==
X-Gm-Message-State: AOAM531NrP8t+s1k/RC4h6DGx4kUAIVRbak9Gfdg9Nj6kJOQsT0CHntE
        83ZlIWNnGLK/ifczPy5IJczdC+KC7YI/c0+a70mhIm+AqZ39Icq3Sk0404s/yiOK7bSySVc3l/O
        RWTrOBLHZDNJ/tOAiYZdB0IDPKTum5Na5
X-Received: by 2002:aed:2a75:: with SMTP id k50mr25110444qtf.27.1593608715109;
        Wed, 01 Jul 2020 06:05:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAoQK5YayOI2hmX5DxFb8Z9OAzUrZhiXlTOY3lP5Q9zDq4Yb1uXnRF7HWZxkJcPu2zkVNeRL8lFfgkom+a5Hg=
X-Received: by 2002:aed:2a75:: with SMTP id k50mr25110412qtf.27.1593608714741;
 Wed, 01 Jul 2020 06:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
 <20200622114622-mutt-send-email-mst@kernel.org> <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
 <20200622122546-mutt-send-email-mst@kernel.org> <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com> <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com>
In-Reply-To: <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Jul 2020 15:04:38 +0200
Message-ID: <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
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

On Wed, Jul 1, 2020 at 2:40 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/7/1 =E4=B8=8B=E5=8D=886:43, Eugenio Perez Martin wrote:
> > On Tue, Jun 23, 2020 at 6:15 PM Eugenio Perez Martin
> > <eperezma@redhat.com> wrote:
> >> On Mon, Jun 22, 2020 at 6:29 PM Michael S. Tsirkin <mst@redhat.com> wr=
ote:
> >>> On Mon, Jun 22, 2020 at 06:11:21PM +0200, Eugenio Perez Martin wrote:
> >>>> On Mon, Jun 22, 2020 at 5:55 PM Michael S. Tsirkin <mst@redhat.com> =
wrote:
> >>>>> On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin wrot=
e:
> >>>>>> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> >>>>>> <eperezma@redhat.com> wrote:
> >>>>>>> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> >>>>>>> <konrad.wilk@oracle.com> wrote:
> >>>>>>>> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wro=
te:
> >>>>>>>>> As testing shows no performance change, switch to that now.
> >>>>>>>> What kind of testing? 100GiB? Low latency?
> >>>>>>>>
> >>>>>>> Hi Konrad.
> >>>>>>>
> >>>>>>> I tested this version of the patch:
> >>>>>>> https://lkml.org/lkml/2019/10/13/42
> >>>>>>>
> >>>>>>> It was tested for throughput with DPDK's testpmd (as described in
> >>>>>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.=
html)
> >>>>>>> and kernel pktgen. No latency tests were performed by me. Maybe i=
t is
> >>>>>>> interesting to perform a latency test or just a different set of =
tests
> >>>>>>> over a recent version.
> >>>>>>>
> >>>>>>> Thanks!
> >>>>>> I have repeated the tests with v9, and results are a little bit di=
fferent:
> >>>>>> * If I test opening it with testpmd, I see no change between versi=
ons
> >>>>>
> >>>>> OK that is testpmd on guest, right? And vhost-net on the host?
> >>>>>
> >>>> Hi Michael.
> >>>>
> >>>> No, sorry, as described in
> >>>> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.htm=
l.
> >>>> But I could add to test it in the guest too.
> >>>>
> >>>> These kinds of raw packets "bursts" do not show performance
> >>>> differences, but I could test deeper if you think it would be worth
> >>>> it.
> >>> Oh ok, so this is without guest, with virtio-user.
> >>> It might be worth checking dpdk within guest too just
> >>> as another data point.
> >>>
> >> Ok, I will do it!
> >>
> >>>>>> * If I forward packets between two vhost-net interfaces in the gue=
st
> >>>>>> using a linux bridge in the host:
> >>>>> And here I guess you mean virtio-net in the guest kernel?
> >>>> Yes, sorry: Two virtio-net interfaces connected with a linux bridge =
in
> >>>> the host. More precisely:
> >>>> * Adding one of the interfaces to another namespace, assigning it an
> >>>> IP, and starting netserver there.
> >>>> * Assign another IP in the range manually to the other virtual net
> >>>> interface, and start the desired test there.
> >>>>
> >>>> If you think it would be better to perform then differently please l=
et me know.
> >>>
> >>> Not sure why you bother with namespaces since you said you are
> >>> using L2 bridging. I guess it's unimportant.
> >>>
> >> Sorry, I think I should have provided more context about that.
> >>
> >> The only reason to use namespaces is to force the traffic of these
> >> netperf tests to go through the external bridge. To test netperf
> >> different possibilities than the testpmd (or pktgen or others "blast
> >> of frames unconditionally" tests).
> >>
> >> This way, I make sure that is the same version of everything in the
> >> guest, and is a little bit easier to manage cpu affinity, start and
> >> stop testing...
> >>
> >> I could use a different VM for sending and receiving, but I find this
> >> way a faster one and it should not introduce a lot of noise. I can
> >> test with two VM if you think that this use of network namespace
> >> introduces too much noise.
> >>
> >> Thanks!
> >>
> >>>>>>    - netperf UDP_STREAM shows a performance increase of 1.8, almos=
t
> >>>>>> doubling performance. This gets lower as frame size increase.
> > Regarding UDP_STREAM:
> > * with event_idx=3Don: The performance difference is reduced a lot if
> > applied affinity properly (manually assigning CPU on host/guest and
> > setting IRQs on guest), making them perform equally with and without
> > the patch again. Maybe the batching makes the scheduler perform
> > better.
>
>
> Note that for UDP_STREAM, the result is pretty trick to be analyzed. E.g
> setting a sndbuf for TAP may help for the performance (reduce the drop).
>

Ok, will add that to the test. Thanks!

>
> >
> >>>>>>    - rests of the test goes noticeably worse: UDP_RR goes from ~63=
47
> >>>>>> transactions/sec to 5830
> > * Regarding UDP_RR, TCP_STREAM, and TCP_RR, proper CPU pinning makes
> > them perform similarly again, only a very small performance drop
> > observed. It could be just noise.
> > ** All of them perform better than vanilla if event_idx=3Doff, not sure
> > why. I can try to repeat them if you suspect that can be a test
> > failure.
> >
> > * With testpmd and event_idx=3Doff, if I send from the VM to host, I se=
e
> > a performance increment especially in small packets. The buf api also
> > increases performance compared with only batching: Sending the minimum
> > packet size in testpmd makes pps go from 356kpps to 473 kpps.
>
>
> What's your setup for this. The number looks rather low. I'd expected
> 1-2 Mpps at least.
>

Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz, 2 NUMA nodes of 16G memory
each, and no device assigned to the NUMA node I'm testing in. Too low
for testpmd AF_PACKET driver too?

>
> > Sending
> > 1024 length UDP-PDU makes it go from 570kpps to 64 kpps.
> >
> > Something strange I observe in these tests: I get more pps the bigger
> > the transmitted buffer size is. Not sure why.
> >
> > ** Sending from the host to the VM does not make a big change with the
> > patches in small packets scenario (minimum, 64 bytes, about 645
> > without the patch, ~625 with batch and batch+buf api). If the packets
> > are bigger, I can see a performance increase: with 256 bits,
>
>
> I think you meant bytes?
>

Yes, sorry.

>
> >   it goes
> > from 590kpps to about 600kpps, and in case of 1500 bytes payload it
> > gets from 348kpps to 528kpps, so it is clearly an improvement.
> >
> > * with testpmd and event_idx=3Don, batching+buf api perform similarly i=
n
> > both directions.
> >
> > All of testpmd tests were performed with no linux bridge, just a
> > host's tap interface (<interface type=3D'ethernet'> in xml),
>
>
> What DPDK driver did you use in the test (AF_PACKET?).
>

Yes, both testpmd are using AF_PACKET driver.

>
> > with a
> > testpmd txonly and another in rxonly forward mode, and using the
> > receiving side packets/bytes data. Guest's rps, xps and interrupts,
> > and host's vhost threads affinity were also tuned in each test to
> > schedule both testpmd and vhost in different processors.
>
>
> My feeling is that if we start from simple setup, it would be more
> easier as a start. E.g start without an VM.
>
> 1) TX: testpmd(txonly) -> virtio-user -> vhost_net -> XDP_DROP on TAP
> 2) RX: pkgetn -> TAP -> vhost_net -> testpmd(rxonly)
>

Got it. Is there a reason to prefer pktgen over testpmd?

> Thanks
>
>
> >
> > I will send the v10 RFC with the small changes requested by Stefan and =
Jason.
> >
> > Thanks!
> >
> >
> >
> >
> >
> >
> >
> >>>>> OK so it seems plausible that we still have a bug where an interrup=
t
> >>>>> is delayed. That is the main difference between pmd and virtio.
> >>>>> Let's try disabling event index, and see what happens - that's
> >>>>> the trickiest part of interrupts.
> >>>>>
> >>>> Got it, will get back with the results.
> >>>>
> >>>> Thank you very much!
> >>>>
> >>>>>
> >>>>>>    - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
> >>>>>>    - TCP_RR from 6223.64 transactions/sec to 5739.44
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE7210B60
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbgGAM53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 08:57:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730271AbgGAM52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 08:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593608246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9aHAu1fe/5+f35nrgAqNhkbpHOt1DMXflxZdTOhVWnM=;
        b=BBC0FkEj2217SQ7x0HZjmmaKvSpO2AYrrB/OGziL34ztcZCuP1/gCNqVQo9cnUJqGcZvxm
        KoOId3YhNRpsLdZzMMYlskJtgOCfKDJAUkwXI7S0xd/PuLfs6ovmIF3SyMrqLRr6WEcOt6
        MXgF8O4dGKHoggar3IusIuG0k1ihYBI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-xke8QGJrP-WkkaTkD3iBnQ-1; Wed, 01 Jul 2020 08:57:24 -0400
X-MC-Unique: xke8QGJrP-WkkaTkD3iBnQ-1
Received: by mail-qv1-f70.google.com with SMTP id bk16so15998456qvb.11
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 05:57:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9aHAu1fe/5+f35nrgAqNhkbpHOt1DMXflxZdTOhVWnM=;
        b=V0IfkWowG7TVMeBXcJFII2FDU2M4cFo9Owo+ycn09FR4m8adQYhCzkecyTcRAm90GV
         bvQGuk9sn3OojhJOW5q3+9MLsHWy/xvlJWKjWSb2rIYvTdI0v3rxaK4vz2eQJ8qs0iqX
         DKhnVSPuv0sAJTzFaZlEOJhdQimIgbd9Ibc7pO7SOD5+MWRhxaTnpArJj9QQe4Cm5NJ9
         HmAxzY2G9CHiAaU/90os8ZMB49NynYXA2b/3aYwOOCyzonhcsGTatEvDuLN7FaF2HMIo
         RR7UPr0YG363rgadFsCJ59MrwawsIYRv6/dCIS+yi+Tx55qLnKnZIF75DzF2WOfuLA5r
         L7dQ==
X-Gm-Message-State: AOAM531faVweSrT4GpK8kh57V/KP95kHRC3kUrD/dxnu/DqH7vPQ1Xgw
        ms1KjynynmANDfIiiFXakdGxF07PAQw0jIxJDi2wsYi5z2Uyq4qMGDmOnCjcSq+Md2dULFjymcc
        twecO57BDCl+XxOsc51fjDZc0rhmqqTus
X-Received: by 2002:aed:2a75:: with SMTP id k50mr25069841qtf.27.1593608243806;
        Wed, 01 Jul 2020 05:57:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL1f0eN6LhXqx9i3RVi3ZTLzWJX9zawk/bYCWVEriejNOHGvG3sjaWuj2FZBP4lDumnoiphf1YDStynwhEhnw=
X-Received: by 2002:aed:2a75:: with SMTP id k50mr25069812qtf.27.1593608243487;
 Wed, 01 Jul 2020 05:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
 <20200622114622-mutt-send-email-mst@kernel.org> <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
 <20200622122546-mutt-send-email-mst@kernel.org> <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com> <20200701071041-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200701071041-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Jul 2020 14:56:47 +0200
Message-ID: <CAJaqyWd-0N00FxULk5OVVKr4CnX45kMbrLHet8=nB+J67tEwfg@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 1:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 01, 2020 at 12:43:09PM +0200, Eugenio Perez Martin wrote:
> > On Tue, Jun 23, 2020 at 6:15 PM Eugenio Perez Martin
> > <eperezma@redhat.com> wrote:
> > >
> > > On Mon, Jun 22, 2020 at 6:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Jun 22, 2020 at 06:11:21PM +0200, Eugenio Perez Martin wrote:
> > > > > On Mon, Jun 22, 2020 at 5:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin wrote:
> > > > > > > On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> > > > > > > <eperezma@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> > > > > > > > <konrad.wilk@oracle.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > > > > > > > > > As testing shows no performance change, switch to that now.
> > > > > > > > >
> > > > > > > > > What kind of testing? 100GiB? Low latency?
> > > > > > > > >
> > > > > > > >
> > > > > > > > Hi Konrad.
> > > > > > > >
> > > > > > > > I tested this version of the patch:
> > > > > > > > https://lkml.org/lkml/2019/10/13/42
> > > > > > > >
> > > > > > > > It was tested for throughput with DPDK's testpmd (as described in
> > > > > > > > http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
> > > > > > > > and kernel pktgen. No latency tests were performed by me. Maybe it is
> > > > > > > > interesting to perform a latency test or just a different set of tests
> > > > > > > > over a recent version.
> > > > > > > >
> > > > > > > > Thanks!
> > > > > > >
> > > > > > > I have repeated the tests with v9, and results are a little bit different:
> > > > > > > * If I test opening it with testpmd, I see no change between versions
> > > > > >
> > > > > >
> > > > > > OK that is testpmd on guest, right? And vhost-net on the host?
> > > > > >
> > > > >
> > > > > Hi Michael.
> > > > >
> > > > > No, sorry, as described in
> > > > > http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html.
> > > > > But I could add to test it in the guest too.
> > > > >
> > > > > These kinds of raw packets "bursts" do not show performance
> > > > > differences, but I could test deeper if you think it would be worth
> > > > > it.
> > > >
> > > > Oh ok, so this is without guest, with virtio-user.
> > > > It might be worth checking dpdk within guest too just
> > > > as another data point.
> > > >
> > >
> > > Ok, I will do it!
> > >
> > > > > > > * If I forward packets between two vhost-net interfaces in the guest
> > > > > > > using a linux bridge in the host:
> > > > > >
> > > > > > And here I guess you mean virtio-net in the guest kernel?
> > > > >
> > > > > Yes, sorry: Two virtio-net interfaces connected with a linux bridge in
> > > > > the host. More precisely:
> > > > > * Adding one of the interfaces to another namespace, assigning it an
> > > > > IP, and starting netserver there.
> > > > > * Assign another IP in the range manually to the other virtual net
> > > > > interface, and start the desired test there.
> > > > >
> > > > > If you think it would be better to perform then differently please let me know.
> > > >
> > > >
> > > > Not sure why you bother with namespaces since you said you are
> > > > using L2 bridging. I guess it's unimportant.
> > > >
> > >
> > > Sorry, I think I should have provided more context about that.
> > >
> > > The only reason to use namespaces is to force the traffic of these
> > > netperf tests to go through the external bridge. To test netperf
> > > different possibilities than the testpmd (or pktgen or others "blast
> > > of frames unconditionally" tests).
> > >
> > > This way, I make sure that is the same version of everything in the
> > > guest, and is a little bit easier to manage cpu affinity, start and
> > > stop testing...
> > >
> > > I could use a different VM for sending and receiving, but I find this
> > > way a faster one and it should not introduce a lot of noise. I can
> > > test with two VM if you think that this use of network namespace
> > > introduces too much noise.
> > >
> > > Thanks!
> > >
> > > > > >
> > > > > > >   - netperf UDP_STREAM shows a performance increase of 1.8, almost
> > > > > > > doubling performance. This gets lower as frame size increase.
> >
> > Regarding UDP_STREAM:
> > * with event_idx=on: The performance difference is reduced a lot if
> > applied affinity properly (manually assigning CPU on host/guest and
> > setting IRQs on guest), making them perform equally with and without
> > the patch again. Maybe the batching makes the scheduler perform
> > better.
> >
> > > > > > >   - rests of the test goes noticeably worse: UDP_RR goes from ~6347
> > > > > > > transactions/sec to 5830
> >
> > * Regarding UDP_RR, TCP_STREAM, and TCP_RR, proper CPU pinning makes
> > them perform similarly again, only a very small performance drop
> > observed. It could be just noise.
> > ** All of them perform better than vanilla if event_idx=off, not sure
> > why. I can try to repeat them if you suspect that can be a test
> > failure.
> >
> > * With testpmd and event_idx=off, if I send from the VM to host, I see
> > a performance increment especially in small packets. The buf api also
> > increases performance compared with only batching: Sending the minimum
> > packet size in testpmd makes pps go from 356kpps to 473 kpps. Sending
> > 1024 length UDP-PDU makes it go from 570kpps to 64 kpps.
> >
> > Something strange I observe in these tests: I get more pps the bigger
> > the transmitted buffer size is. Not sure why.
> >
> > ** Sending from the host to the VM does not make a big change with the
> > patches in small packets scenario (minimum, 64 bytes, about 645
> > without the patch, ~625 with batch and batch+buf api). If the packets
> > are bigger, I can see a performance increase: with 256 bits, it goes
> > from 590kpps to about 600kpps, and in case of 1500 bytes payload it
> > gets from 348kpps to 528kpps, so it is clearly an improvement.
> >
> > * with testpmd and event_idx=on, batching+buf api perform similarly in
> > both directions.
> >
> > All of testpmd tests were performed with no linux bridge, just a
> > host's tap interface (<interface type='ethernet'> in xml), with a
> > testpmd txonly and another in rxonly forward mode, and using the
> > receiving side packets/bytes data. Guest's rps, xps and interrupts,
> > and host's vhost threads affinity were also tuned in each test to
> > schedule both testpmd and vhost in different processors.
> >
> > I will send the v10 RFC with the small changes requested by Stefan and Jason.
> >
> > Thanks!
> >
>
> OK so there's a chance you are seeing effects of an aggressive power
> management. which tuned profile are you using? It might be helpful
> to disable PM/frequency scaling.
>

I didn't change the tuned profile.

I set all cpus involved in the test isolated with cmdline:
'isolcpus=1,3,5,7,9,11 nohz_full=1,3,5,7,9,11 rcu_nocbs=1,3,5,7,9,11
rcu_nocb_poll intel_pstate=disable'

Wil try to change them though tuned, thanks!

>
> >
> >
> >
> >
> >
> > > > > >
> > > > > > OK so it seems plausible that we still have a bug where an interrupt
> > > > > > is delayed. That is the main difference between pmd and virtio.
> > > > > > Let's try disabling event index, and see what happens - that's
> > > > > > the trickiest part of interrupts.
> > > > > >
> > > > >
> > > > > Got it, will get back with the results.
> > > > >
> > > > > Thank you very much!
> > > > >
> > > > > >
> > > > > >
> > > > > > >   - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
> > > > > > >   - TCP_RR from 6223.64 transactions/sec to 5739.44
> > > > > >
> > > >
>


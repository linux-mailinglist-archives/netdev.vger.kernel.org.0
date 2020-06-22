Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096B5203C4A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgFVQMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:12:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729461AbgFVQMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592842320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9CuuDZWez1gPD7/EQaGB6uwPoIx9m3Z+Jr1eQeEOo4=;
        b=OqG/YNjvJelR3an6wmWgRM/jTG+mG+3Q7x3IIzg/0mQg2aF6Fq0HlYvOJicBR5HIvrwsfr
        eo6YS54kbd+kH1HnNP5qNA7p0efawqR7H179wLDw9VWML5wii2KptQae0rGDhwmycHxvwL
        BTGNxizRF+jZ0fEffbR52h0LUAFsziE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-eA6n0hsANa-AA__e7sKZMA-1; Mon, 22 Jun 2020 12:11:58 -0400
X-MC-Unique: eA6n0hsANa-AA__e7sKZMA-1
Received: by mail-qt1-f199.google.com with SMTP id k23so13701668qtb.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9CuuDZWez1gPD7/EQaGB6uwPoIx9m3Z+Jr1eQeEOo4=;
        b=V1TnWgkKtvd3YZaEVKkbZ1mG1xS8rfowmYlTsCEke+/HUhK+BCoO+jv+bTJXumFqkP
         BHSDSLmWvN3dMsUnzxN9GLvSEJNAzdWcuzzKH6j8qqyFSSSm24mVIKW8xTEeWc5l3U9g
         KLAt8rDlZ2BKpSrGkUGrDf+rNL6qcwalKsz8nwfoyBBpN3SSPC4sd1r8o2bKKDUxaKVS
         gEmTj2XdH35iluStGY9GvZdaVdCpd15VwwN98EJzqGDL6kCF/LC4aqZQHrAf/sgmS20p
         N0TNY6eVcvZ+Veb0Vmhi/puFrIiOsHFFtXbg1UVS2RygeUXit9yF+iJaoxvUcE3D1GJM
         +McA==
X-Gm-Message-State: AOAM5306t3Nz1ACybgwhS5GGC5so2CD+nX5UltcZ9Bg0oRarJSOqmSUP
        e0GwFg2vSNgzTgl91mwuHa3bhfZhxGzdFcHzS2+AzV1TPJJwFpHwPyLfRKNC1QtqPhjmQbbi1MU
        z/hw7ge72Uuq1OyTcYNQhNCS4+3T2OU2d
X-Received: by 2002:ac8:6897:: with SMTP id m23mr17079720qtq.379.1592842318280;
        Mon, 22 Jun 2020 09:11:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyifxHd4I0K380+T02Us257PwSC14VpREUv7M9piQBBjhpblxB2co9TPhLyGBKM46r+UB9UoruDIOuGXxRi6q8=
X-Received: by 2002:ac8:6897:: with SMTP id m23mr17079684qtq.379.1592842317963;
 Mon, 22 Jun 2020 09:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com> <20200622114622-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200622114622-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 22 Jun 2020 18:11:21 +0200
Message-ID: <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
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

On Mon, Jun 22, 2020 at 5:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin wrote:
> > On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> > <eperezma@redhat.com> wrote:
> > >
> > > On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> > > <konrad.wilk@oracle.com> wrote:
> > > >
> > > > On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > > > > As testing shows no performance change, switch to that now.
> > > >
> > > > What kind of testing? 100GiB? Low latency?
> > > >
> > >
> > > Hi Konrad.
> > >
> > > I tested this version of the patch:
> > > https://lkml.org/lkml/2019/10/13/42
> > >
> > > It was tested for throughput with DPDK's testpmd (as described in
> > > http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
> > > and kernel pktgen. No latency tests were performed by me. Maybe it is
> > > interesting to perform a latency test or just a different set of tests
> > > over a recent version.
> > >
> > > Thanks!
> >
> > I have repeated the tests with v9, and results are a little bit different:
> > * If I test opening it with testpmd, I see no change between versions
>
>
> OK that is testpmd on guest, right? And vhost-net on the host?
>

Hi Michael.

No, sorry, as described in
http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html.
But I could add to test it in the guest too.

These kinds of raw packets "bursts" do not show performance
differences, but I could test deeper if you think it would be worth
it.

> > * If I forward packets between two vhost-net interfaces in the guest
> > using a linux bridge in the host:
>
> And here I guess you mean virtio-net in the guest kernel?

Yes, sorry: Two virtio-net interfaces connected with a linux bridge in
the host. More precisely:
* Adding one of the interfaces to another namespace, assigning it an
IP, and starting netserver there.
* Assign another IP in the range manually to the other virtual net
interface, and start the desired test there.

If you think it would be better to perform then differently please let me know.

>
> >   - netperf UDP_STREAM shows a performance increase of 1.8, almost
> > doubling performance. This gets lower as frame size increase.
> >   - rests of the test goes noticeably worse: UDP_RR goes from ~6347
> > transactions/sec to 5830
>
> OK so it seems plausible that we still have a bug where an interrupt
> is delayed. That is the main difference between pmd and virtio.
> Let's try disabling event index, and see what happens - that's
> the trickiest part of interrupts.
>

Got it, will get back with the results.

Thank you very much!

>
>
> >   - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
> >   - TCP_RR from 6223.64 transactions/sec to 5739.44
>


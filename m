Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7173F1F58E7
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgFJQTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:19:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728513AbgFJQTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 12:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591805951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=anaWHR8ODh6bT+XuFE0Xz0+EuRSEm+J1BoLhgrw84d0=;
        b=PqwsPm3+wCtoi/v/uszAfAEjXalzKuvEu4AWipiAtWKzz1GnfaNnGLnOPmjOyIWdhWxO2b
        DFL3m6P4s0A3ucDHFEe8Y2nMEoEOvu6tdBe1jKqVclnpj7P9WUtWn6AyXF6LrPBjjfaBQI
        imBTP9sJb3LhvSUArEFFpRYYzpE+2As=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-63cJjWElOkG0rndkqPa_3Q-1; Wed, 10 Jun 2020 12:19:09 -0400
X-MC-Unique: 63cJjWElOkG0rndkqPa_3Q-1
Received: by mail-qt1-f199.google.com with SMTP id u48so2340964qth.17
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=anaWHR8ODh6bT+XuFE0Xz0+EuRSEm+J1BoLhgrw84d0=;
        b=uZ/NX5qopgf+rIO1MBP4SFqukUGtb75rX8M0iM1Ivt47TIfLJve8mW8lKCe4y1DMLJ
         7UUIvnZ6UmJ8Ckzbd6dqFXvmyZe/QOuTrky6dwOMDKpgKFe8DBf9/G0oB9qb4uMmNbRv
         SfgLjZhEfu7BEOQR0qgxRZo3T9RxTWwYtMiQ5J4l/e7knS6BuuuJ9BaWKe9MG4TqblqG
         E9DHgwUS2CLOM2s9vfbb7ZLUprG/L+79dJP3B7b7Hibt7lrlLQLngqr3o19z5Mg2eyWT
         VhxLnmL7GJ5yQP8QpoJHlq6XvpuE3qgqbt2V9l7l5d+U5YGuA0yrkcZ95LLymvNXmhGS
         YjvA==
X-Gm-Message-State: AOAM530+s01BRcw76BL/ryAbLRTXtFSuvDDIZCHeSsTH3IVX4oV6I/Gv
        akmTcJnS7JTDEZ8YRIDdcT7qV1+cqI1NA8nBkx7ZeHIEhJnLWLGxG0CPH7MF/kOS3qNbkupIckR
        Fskaa5CJwA+PKIpavwWvzqtMQhAHPKpxL
X-Received: by 2002:a37:2702:: with SMTP id n2mr3862400qkn.497.1591805949117;
        Wed, 10 Jun 2020 09:19:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4zn0n1VsDB2zRrhX3o2J87XhGBACiQ4fWr35+ECNuZ32gZdIovwS6Er7XIT1803b34VxsP/mWRIhTQj1OyYA=
X-Received: by 2002:a37:2702:: with SMTP id n2mr3862363qkn.497.1591805948686;
 Wed, 10 Jun 2020 09:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200610113515.1497099-1-mst@redhat.com> <20200610113515.1497099-4-mst@redhat.com>
 <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com> <20200610111147-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200610111147-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 10 Jun 2020 18:18:32 +0200
Message-ID: <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 10, 2020 at 02:37:50PM +0200, Eugenio Perez Martin wrote:
> > > +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > > + * A negative code is returned on error. */
> > > +static int fetch_descs(struct vhost_virtqueue *vq)
> > > +{
> > > +       int ret;
> > > +
> > > +       if (unlikely(vq->first_desc >= vq->ndescs)) {
> > > +               vq->first_desc = 0;
> > > +               vq->ndescs = 0;
> > > +       }
> > > +
> > > +       if (vq->ndescs)
> > > +               return 1;
> > > +
> > > +       for (ret = 1;
> > > +            ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> > > +            ret = fetch_buf(vq))
> > > +               ;
> >
> > (Expanding comment in V6):
> >
> > We get an infinite loop this way:
> > * vq->ndescs == 0, so we call fetch_buf() here
> > * fetch_buf gets less than vhost_vq_num_batch_descs(vq); descriptors. ret = 1
> > * This loop calls again fetch_buf, but vq->ndescs > 0 (and avail_vq ==
> > last_avail_vq), so it just return 1
>
> That's what
>          [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
> is supposed to fix.
>

Sorry, I forgot to include that fixup.

With it I don't see CPU stalls, but with that version latency has
increased a lot and I see packet lost:
+ ping -c 5 10.200.0.1
PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
From 10.200.0.2 icmp_seq=1 Destination Host Unreachable
From 10.200.0.2 icmp_seq=2 Destination Host Unreachable
From 10.200.0.2 icmp_seq=3 Destination Host Unreachable
64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=6848 ms

--- 10.200.0.1 ping statistics ---
5 packets transmitted, 1 received, +3 errors, 80% packet loss, time 76ms
rtt min/avg/max/mdev = 6848.316/6848.316/6848.316/0.000 ms, pipe 4
--

I cannot even use netperf.

If I modify with my proposed version:
+ ping -c 5 10.200.0.1
PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
64 bytes from 10.200.0.1: icmp_seq=1 ttl=64 time=7.07 ms
64 bytes from 10.200.0.1: icmp_seq=2 ttl=64 time=0.358 ms
64 bytes from 10.200.0.1: icmp_seq=3 ttl=64 time=5.35 ms
64 bytes from 10.200.0.1: icmp_seq=4 ttl=64 time=2.27 ms
64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=0.426 ms

[root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t TCP_STREAM
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.200.0.1 () port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384  16384    10.01    4742.36
[root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t UDP_STREAM
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.200.0.1 () port 0 AF_INET
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

212992   65507   10.00        9214      0     482.83
212992           10.00        9214            482.83

I will compare with the non-batch version for reference, but the
difference between the two is noticeable. Maybe it's worth finding a
good value for the if() inside fetch_buf?

Thanks!


> --
> MST
>


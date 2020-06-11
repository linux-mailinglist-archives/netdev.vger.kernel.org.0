Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DDE1F66A6
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgFKLaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:30:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20286 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727084AbgFKLaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 07:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9/jl7PRjuNx/C+pUMDHawKvKRMB5jFyju67YAOMh5Vw=;
        b=K7vMxZEreFMxTGl9sC1Xvi09Zg/bq+oJvjcv5mvk4M3nsPR2DQVrqAISV5Fpjod4nfY0fZ
        +M9cK2m17IX8fm1ru8e+tNogakwn3rFAn+V3TFl/Nw055WLbdq8sADW6tcxDM5CqA6TOcT
        UelvBpknphft7BB6GVbKlrzIG+if/5s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-9eFFSp3-OWyXtKl6Jxe3xw-1; Thu, 11 Jun 2020 07:30:19 -0400
X-MC-Unique: 9eFFSp3-OWyXtKl6Jxe3xw-1
Received: by mail-wr1-f69.google.com with SMTP id m14so2444199wrj.12
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 04:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9/jl7PRjuNx/C+pUMDHawKvKRMB5jFyju67YAOMh5Vw=;
        b=VKt/q5iEWm8Ivd2L4ReBcyVakvSu9tl1CrCqOZpny41Cqi+BtuxO1PqQ3dXcN0AWIV
         2RlTFG9m80GEvE4RKWK06LSUJi6svvVGK1g6lnG7KPjQfE96nUxMAK95kEheofA5ryQ1
         8ZGOgLfJqluWBlmHxdfKrhH8+xymHRYSfJSlraCpH2J13bHOZjRrnvgV4QgAIshiZhqv
         QyK/vMEKd+phwkIlFCz5xx0BljmzpFmoIzwAzF6Hsnv4gJAS3+BrsCmR/wAZAgxZiqiS
         La+7p+8k2MFjY0SyXV3pqg5bpPNuZCW5UGh9bZkVvxiYKQD6xOPxpdPZkmryBzPnPjvo
         oKcA==
X-Gm-Message-State: AOAM532j7SfcNGqVo2qGS2b0BNQBzjcViqcq/5c9sUF7IkQQ2l3H4CMF
        qmMyMBsGSvpnBDooQobM0qv3qbWdDHcx4+tsUOZw2OTaCtB1757HzauYS87BlWB0XfNWCFDYinG
        fHZBDyVh2jM2Cs8GI
X-Received: by 2002:a1c:3b8b:: with SMTP id i133mr7709148wma.111.1591875017440;
        Thu, 11 Jun 2020 04:30:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzJ6v/QkioaQycgPSzfq+keXBu76wlWx/mu62TPOFBjqUGGd1L5f5cXkoDx4uk2vFtzgVdWQ==
X-Received: by 2002:a1c:3b8b:: with SMTP id i133mr7709124wma.111.1591875017186;
        Thu, 11 Jun 2020 04:30:17 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id b81sm4055054wmc.5.2020.06.11.04.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:30:16 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:30:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
Message-ID: <20200611072702-mutt-send-email-mst@kernel.org>
References: <20200610113515.1497099-1-mst@redhat.com>
 <20200610113515.1497099-4-mst@redhat.com>
 <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com>
 <20200610111147-mutt-send-email-mst@kernel.org>
 <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 06:18:32PM +0200, Eugenio Perez Martin wrote:
> On Wed, Jun 10, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jun 10, 2020 at 02:37:50PM +0200, Eugenio Perez Martin wrote:
> > > > +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > > > + * A negative code is returned on error. */
> > > > +static int fetch_descs(struct vhost_virtqueue *vq)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       if (unlikely(vq->first_desc >= vq->ndescs)) {
> > > > +               vq->first_desc = 0;
> > > > +               vq->ndescs = 0;
> > > > +       }
> > > > +
> > > > +       if (vq->ndescs)
> > > > +               return 1;
> > > > +
> > > > +       for (ret = 1;
> > > > +            ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> > > > +            ret = fetch_buf(vq))
> > > > +               ;
> > >
> > > (Expanding comment in V6):
> > >
> > > We get an infinite loop this way:
> > > * vq->ndescs == 0, so we call fetch_buf() here
> > > * fetch_buf gets less than vhost_vq_num_batch_descs(vq); descriptors. ret = 1
> > > * This loop calls again fetch_buf, but vq->ndescs > 0 (and avail_vq ==
> > > last_avail_vq), so it just return 1
> >
> > That's what
> >          [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
> > is supposed to fix.
> >
> 
> Sorry, I forgot to include that fixup.
> 
> With it I don't see CPU stalls, but with that version latency has
> increased a lot and I see packet lost:
> + ping -c 5 10.200.0.1
> PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> >From 10.200.0.2 icmp_seq=1 Destination Host Unreachable
> >From 10.200.0.2 icmp_seq=2 Destination Host Unreachable
> >From 10.200.0.2 icmp_seq=3 Destination Host Unreachable
> 64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=6848 ms
> 
> --- 10.200.0.1 ping statistics ---
> 5 packets transmitted, 1 received, +3 errors, 80% packet loss, time 76ms
> rtt min/avg/max/mdev = 6848.316/6848.316/6848.316/0.000 ms, pipe 4
> --
> 
> I cannot even use netperf.

OK so that's the bug to try to find and fix I think.


> If I modify with my proposed version:
> + ping -c 5 10.200.0.1
> PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> 64 bytes from 10.200.0.1: icmp_seq=1 ttl=64 time=7.07 ms
> 64 bytes from 10.200.0.1: icmp_seq=2 ttl=64 time=0.358 ms
> 64 bytes from 10.200.0.1: icmp_seq=3 ttl=64 time=5.35 ms
> 64 bytes from 10.200.0.1: icmp_seq=4 ttl=64 time=2.27 ms
> 64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=0.426 ms


Not sure which version this is.

> [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t TCP_STREAM
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> 10.200.0.1 () port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> 131072  16384  16384    10.01    4742.36
> [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t UDP_STREAM
> MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> 10.200.0.1 () port 0 AF_INET
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
> 212992   65507   10.00        9214      0     482.83
> 212992           10.00        9214            482.83
> 
> I will compare with the non-batch version for reference, but the
> difference between the two is noticeable. Maybe it's worth finding a
> good value for the if() inside fetch_buf?
> 
> Thanks!
> 

I don't think it's performance, I think it's a bug somewhere,
e.g. maybe we corrupt a packet, or stall the queue, or
something like this.

Let's do this, I will squash the fixups and post v8 so you can bisect
and then debug cleanly.

> > --
> > MST
> >


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53AE1FB60B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgFPPY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:24:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728899AbgFPPY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:24:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592321064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCt56TgF5Tw5yluNgtWn5zzCa00ineAmOgTzmQ5THbs=;
        b=apSYDRoWbuNe9orHmXC01Br1Ph57X5N9487uLk+vfT91baIWLS9u32NPXCslzIgIsCwSzQ
        JfRG0FZuvQxsVuu5XF/qrTuzy9UluIE1nTsMNsCq0Tb/fIElQvPRkOKvScU2ixZZOKOVo0
        T/A7A8Ia3zjG38LP1ie+IjfSh/rzGP0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-kQjEPnhuNDaMT-i52efg7w-1; Tue, 16 Jun 2020 11:24:20 -0400
X-MC-Unique: kQjEPnhuNDaMT-i52efg7w-1
Received: by mail-qt1-f198.google.com with SMTP id w14so16984290qtv.19
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QCt56TgF5Tw5yluNgtWn5zzCa00ineAmOgTzmQ5THbs=;
        b=Uw6GL+lJw4uqMxPa307utvb5WNX6xetaRjxSDAQFDgyu4bvBUlOYWUbG3VsbfyRUKO
         dbcjfht6SCljrHVbdD1a/sK++VPxU/OLHSX0xOsgPqT1eHO1ULx9JmD+JygMlAt+yFQ2
         bDGagow2RDLA38cFc8u9BJYUtoiaf3k5L9Bt2c2oaQFA0GIYRdkoZ3wEBlJnKoqbDGAU
         8nJPpy8c0A0l0dYE7Py04v112ce2g7JEVtUXECgccmS2Gm8mmo8A8AhNg7lzKTKoOI01
         +CpGLunPy5TUQPDw5AwzUFhoCrxjkXXwj48B1Cu+yDNpvLvcbYqlEi0xQqNTb5IGKfxQ
         SqaA==
X-Gm-Message-State: AOAM532YBBPlBqiLuKf+2z+TGuYzrdSIu/OGSTp3Me+u/c1p0R5Bpmls
        iMfH4c8gAtFhs87u1MV7uGyKs61ozj5pq1qQJvz6+LpK+i2bICaTF/h/X/l1aBY/XPq4uMt8rKP
        DvT5KJ5NYk1SYoyR7nm/yC4CZP/53rXld
X-Received: by 2002:ac8:6f79:: with SMTP id u25mr21947987qtv.183.1592321059655;
        Tue, 16 Jun 2020 08:24:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFMDdrqK/OlOW77u7x1PWyKbJBzCxu+e2KyoDT0Uqm3C6a8PEU1QsN17lAMeGw4S6IidaoGZ0gOCmD+8ixV1g=
X-Received: by 2002:ac8:6f79:: with SMTP id u25mr21947954qtv.183.1592321059329;
 Tue, 16 Jun 2020 08:24:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200610113515.1497099-1-mst@redhat.com> <20200610113515.1497099-4-mst@redhat.com>
 <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com>
 <20200610111147-mutt-send-email-mst@kernel.org> <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
 <20200611072702-mutt-send-email-mst@kernel.org> <26bef3f07277b028034c019e456b4f236078c5fb.camel@redhat.com>
In-Reply-To: <26bef3f07277b028034c019e456b4f236078c5fb.camel@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 16 Jun 2020 17:23:43 +0200
Message-ID: <CAJaqyWeX7knekVPcsZ2+AAf8zvZhPvt46fZncAsLhwYJ3eUa1g@mail.gmail.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 6:05 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> On Thu, 2020-06-11 at 07:30 -0400, Michael S. Tsirkin wrote:
> > On Wed, Jun 10, 2020 at 06:18:32PM +0200, Eugenio Perez Martin wrote:
> > > On Wed, Jun 10, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> w=
rote:
> > > > On Wed, Jun 10, 2020 at 02:37:50PM +0200, Eugenio Perez Martin wrot=
e:
> > > > > > +/* This function returns a value > 0 if a descriptor was found=
, or 0 if none were found.
> > > > > > + * A negative code is returned on error. */
> > > > > > +static int fetch_descs(struct vhost_virtqueue *vq)
> > > > > > +{
> > > > > > +       int ret;
> > > > > > +
> > > > > > +       if (unlikely(vq->first_desc >=3D vq->ndescs)) {
> > > > > > +               vq->first_desc =3D 0;
> > > > > > +               vq->ndescs =3D 0;
> > > > > > +       }
> > > > > > +
> > > > > > +       if (vq->ndescs)
> > > > > > +               return 1;
> > > > > > +
> > > > > > +       for (ret =3D 1;
> > > > > > +            ret > 0 && vq->ndescs <=3D vhost_vq_num_batch_desc=
s(vq);
> > > > > > +            ret =3D fetch_buf(vq))
> > > > > > +               ;
> > > > >
> > > > > (Expanding comment in V6):
> > > > >
> > > > > We get an infinite loop this way:
> > > > > * vq->ndescs =3D=3D 0, so we call fetch_buf() here
> > > > > * fetch_buf gets less than vhost_vq_num_batch_descs(vq); descript=
ors. ret =3D 1
> > > > > * This loop calls again fetch_buf, but vq->ndescs > 0 (and avail_=
vq =3D=3D
> > > > > last_avail_vq), so it just return 1
> > > >
> > > > That's what
> > > >          [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc=
 version
> > > > is supposed to fix.
> > > >
> > >
> > > Sorry, I forgot to include that fixup.
> > >
> > > With it I don't see CPU stalls, but with that version latency has
> > > increased a lot and I see packet lost:
> > > + ping -c 5 10.200.0.1
> > > PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> > > > From 10.200.0.2 icmp_seq=3D1 Destination Host Unreachable
> > > > From 10.200.0.2 icmp_seq=3D2 Destination Host Unreachable
> > > > From 10.200.0.2 icmp_seq=3D3 Destination Host Unreachable
> > > 64 bytes from 10.200.0.1: icmp_seq=3D5 ttl=3D64 time=3D6848 ms
> > >
> > > --- 10.200.0.1 ping statistics ---
> > > 5 packets transmitted, 1 received, +3 errors, 80% packet loss, time 7=
6ms
> > > rtt min/avg/max/mdev =3D 6848.316/6848.316/6848.316/0.000 ms, pipe 4
> > > --
> > >
> > > I cannot even use netperf.
> >
> > OK so that's the bug to try to find and fix I think.
> >
> >
> > > If I modify with my proposed version:
> > > + ping -c 5 10.200.0.1
> > > PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> > > 64 bytes from 10.200.0.1: icmp_seq=3D1 ttl=3D64 time=3D7.07 ms
> > > 64 bytes from 10.200.0.1: icmp_seq=3D2 ttl=3D64 time=3D0.358 ms
> > > 64 bytes from 10.200.0.1: icmp_seq=3D3 ttl=3D64 time=3D5.35 ms
> > > 64 bytes from 10.200.0.1: icmp_seq=3D4 ttl=3D64 time=3D2.27 ms
> > > 64 bytes from 10.200.0.1: icmp_seq=3D5 ttl=3D64 time=3D0.426 ms
> >
> > Not sure which version this is.
> >
> > > [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t TCP_STREA=
M
> > > MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> > > 10.200.0.1 () port 0 AF_INET
> > > Recv   Send    Send
> > > Socket Socket  Message  Elapsed
> > > Size   Size    Size     Time     Throughput
> > > bytes  bytes   bytes    secs.    10^6bits/sec
> > >
> > > 131072  16384  16384    10.01    4742.36
> > > [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t UDP_STREA=
M
> > > MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> > > 10.200.0.1 () port 0 AF_INET
> > > Socket  Message  Elapsed      Messages
> > > Size    Size     Time         Okay Errors   Throughput
> > > bytes   bytes    secs            #      #   10^6bits/sec
> > >
> > > 212992   65507   10.00        9214      0     482.83
> > > 212992           10.00        9214            482.83
> > >
> > > I will compare with the non-batch version for reference, but the
> > > difference between the two is noticeable. Maybe it's worth finding a
> > > good value for the if() inside fetch_buf?
> > >
> > > Thanks!
> > >
> >
> > I don't think it's performance, I think it's a bug somewhere,
> > e.g. maybe we corrupt a packet, or stall the queue, or
> > something like this.
> >
> > Let's do this, I will squash the fixups and post v8 so you can bisect
> > and then debug cleanly.
>
> Ok, so if we apply the patch proposed in v7 08/14 (Or the version 8 of th=
e patchset sent), this is what happens:
>
> 1. Userland (virtio_test in my case) introduces just one buffer in vq, an=
d it kicks
> 2. vhost module reaches fetch_descs, called from vhost_get_vq_desc. From =
there we call fetch_buf in a for loop.
> 3. The first time we call fetch_buf, it returns properly one buffer. Howe=
ver, the second time we call it, it returns 0
> because vq->avail_idx =3D=3D vq->last_avail_idx and vq->avail_idx =3D=3D =
last_avail_idx code path.
> 4. fetch_descs assign ret =3D 0, so it returns 0. vhost_get_vq_desc will =
goto err, and it will signal no new buffer
> (returning vq->num).
>
> So to fix it and maintain the batching maybe we could return vq->ndescs i=
n case ret =3D=3D 0:
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c0dfb5e3d2af..5993d4f34ca9 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2315,7 +2327,8 @@ static int fetch_descs(struct vhost_virtqueue *vq)
>
>         /* On success we expect some descs */
>         BUG_ON(ret > 0 && !vq->ndescs);
> -       return ret;
> +       return ret ?: vq->ndescs;
>  }
>
>  /* Reverse the effects of fetch_descs */
> --
>
> Another possibility could be to return different codes from fetch_buf, bu=
t I find the suggested modification easier.
>
> What do you think?
>
> Thanks!
>

Hi!

I can send a proposed RFC v9 in case it is more convenient for you.

Thanks!


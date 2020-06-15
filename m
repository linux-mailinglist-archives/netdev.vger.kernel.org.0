Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454521F9C94
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgFOQGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:06:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23377 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729966AbgFOQGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EtKo6KVBT8F3Afdkrt4T9djjz+Jv9Qwx4Oz3C76nT6k=;
        b=aIKTON4dXJ8bFeoiK00cjb51896/wVeJ2ELmgkTJzUzPqxO0Ki/9/3XhBvbz7pZteYfmoz
        VeegTSWHR90XJSu13KPCjw16yfXeaj/jwqIlHAr7NK+IRpEL9ve410zSJkR4vox+pyK20+
        EuFUVdQ9/UHywKGaKYykUXoo1o1F1j4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-1QnVWVWENn6skw_sVWK6AQ-1; Mon, 15 Jun 2020 12:05:53 -0400
X-MC-Unique: 1QnVWVWENn6skw_sVWK6AQ-1
Received: by mail-wm1-f70.google.com with SMTP id p24so17548wma.4
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EtKo6KVBT8F3Afdkrt4T9djjz+Jv9Qwx4Oz3C76nT6k=;
        b=OJRToN/DZ/Pap36Y9MloX22zvVzXvn++sAweiDzbOg6VoMbhQQOqIwvttNcDIHYDa/
         UdtpN212YqdjQSitfI6MbntHfU8ckCjx3JFjQoNNtESncsspz6nJA22P/0fwlEUOH7sv
         Dien/7im0i5g33zHeL47+13A1oe+9QKDEi1dzo9tIrWt6GhhtHjdsUqDibTTLUV7Aa6U
         TcJW21K40BdT2qLtwoof0Y3yyg/lF/47XVVGS3sej7PogneOGdg0qwbtVKptmth8DcTU
         tJo0fxrckuJmX89QfbGOqZDgEQhB+fJKhwYbjjQVGOIWhlCLxy/TQhdvq0VW+MRHHGSm
         6Ing==
X-Gm-Message-State: AOAM530LyGwTWp+MAwzVJG9CygvKY/EGwFX1mE7qeBuztFdHZdDS/FXA
        I7mAuvbXxhzJD3zbjk5OCT3qHXR02lLgws3ino+JvTkSknwhYkD10BbpQBRDY86waRTTIN6pNNB
        VkGz3upqWNCl4VHDE
X-Received: by 2002:adf:ab09:: with SMTP id q9mr28781413wrc.79.1592237151238;
        Mon, 15 Jun 2020 09:05:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpIXgP9Ms+ZJpzoVE6mikNA364JTxrGxpUv0kJTDAr0AwoXyKEIdRdb45S5SHiSsNwq06UYw==
X-Received: by 2002:adf:ab09:: with SMTP id q9mr28781381wrc.79.1592237150934;
        Mon, 15 Jun 2020 09:05:50 -0700 (PDT)
Received: from eperezma.remote.csb (92.143.221.87.dynamic.jazztel.es. [87.221.143.92])
        by smtp.gmail.com with ESMTPSA id k64sm6548wmf.34.2020.06.15.09.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 09:05:50 -0700 (PDT)
Message-ID: <26bef3f07277b028034c019e456b4f236078c5fb.camel@redhat.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Date:   Mon, 15 Jun 2020 18:05:48 +0200
In-Reply-To: <20200611072702-mutt-send-email-mst@kernel.org>
References: <20200610113515.1497099-1-mst@redhat.com>
         <20200610113515.1497099-4-mst@redhat.com>
         <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com>
         <20200610111147-mutt-send-email-mst@kernel.org>
         <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
         <20200611072702-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-11 at 07:30 -0400, Michael S. Tsirkin wrote:
> On Wed, Jun 10, 2020 at 06:18:32PM +0200, Eugenio Perez Martin wrote:
> > On Wed, Jun 10, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Wed, Jun 10, 2020 at 02:37:50PM +0200, Eugenio Perez Martin wrote:
> > > > > +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > > > > + * A negative code is returned on error. */
> > > > > +static int fetch_descs(struct vhost_virtqueue *vq)
> > > > > +{
> > > > > +       int ret;
> > > > > +
> > > > > +       if (unlikely(vq->first_desc >= vq->ndescs)) {
> > > > > +               vq->first_desc = 0;
> > > > > +               vq->ndescs = 0;
> > > > > +       }
> > > > > +
> > > > > +       if (vq->ndescs)
> > > > > +               return 1;
> > > > > +
> > > > > +       for (ret = 1;
> > > > > +            ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> > > > > +            ret = fetch_buf(vq))
> > > > > +               ;
> > > > 
> > > > (Expanding comment in V6):
> > > > 
> > > > We get an infinite loop this way:
> > > > * vq->ndescs == 0, so we call fetch_buf() here
> > > > * fetch_buf gets less than vhost_vq_num_batch_descs(vq); descriptors. ret = 1
> > > > * This loop calls again fetch_buf, but vq->ndescs > 0 (and avail_vq ==
> > > > last_avail_vq), so it just return 1
> > > 
> > > That's what
> > >          [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
> > > is supposed to fix.
> > > 
> > 
> > Sorry, I forgot to include that fixup.
> > 
> > With it I don't see CPU stalls, but with that version latency has
> > increased a lot and I see packet lost:
> > + ping -c 5 10.200.0.1
> > PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> > > From 10.200.0.2 icmp_seq=1 Destination Host Unreachable
> > > From 10.200.0.2 icmp_seq=2 Destination Host Unreachable
> > > From 10.200.0.2 icmp_seq=3 Destination Host Unreachable
> > 64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=6848 ms
> > 
> > --- 10.200.0.1 ping statistics ---
> > 5 packets transmitted, 1 received, +3 errors, 80% packet loss, time 76ms
> > rtt min/avg/max/mdev = 6848.316/6848.316/6848.316/0.000 ms, pipe 4
> > --
> > 
> > I cannot even use netperf.
> 
> OK so that's the bug to try to find and fix I think.
> 
> 
> > If I modify with my proposed version:
> > + ping -c 5 10.200.0.1
> > PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> > 64 bytes from 10.200.0.1: icmp_seq=1 ttl=64 time=7.07 ms
> > 64 bytes from 10.200.0.1: icmp_seq=2 ttl=64 time=0.358 ms
> > 64 bytes from 10.200.0.1: icmp_seq=3 ttl=64 time=5.35 ms
> > 64 bytes from 10.200.0.1: icmp_seq=4 ttl=64 time=2.27 ms
> > 64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=0.426 ms
> 
> Not sure which version this is.
> 
> > [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t TCP_STREAM
> > MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> > 10.200.0.1 () port 0 AF_INET
> > Recv   Send    Send
> > Socket Socket  Message  Elapsed
> > Size   Size    Size     Time     Throughput
> > bytes  bytes   bytes    secs.    10^6bits/sec
> > 
> > 131072  16384  16384    10.01    4742.36
> > [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t UDP_STREAM
> > MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> > 10.200.0.1 () port 0 AF_INET
> > Socket  Message  Elapsed      Messages
> > Size    Size     Time         Okay Errors   Throughput
> > bytes   bytes    secs            #      #   10^6bits/sec
> > 
> > 212992   65507   10.00        9214      0     482.83
> > 212992           10.00        9214            482.83
> > 
> > I will compare with the non-batch version for reference, but the
> > difference between the two is noticeable. Maybe it's worth finding a
> > good value for the if() inside fetch_buf?
> > 
> > Thanks!
> > 
> 
> I don't think it's performance, I think it's a bug somewhere,
> e.g. maybe we corrupt a packet, or stall the queue, or
> something like this.
> 
> Let's do this, I will squash the fixups and post v8 so you can bisect
> and then debug cleanly.

Ok, so if we apply the patch proposed in v7 08/14 (Or the version 8 of the patchset sent), this is what happens:

1. Userland (virtio_test in my case) introduces just one buffer in vq, and it kicks
2. vhost module reaches fetch_descs, called from vhost_get_vq_desc. From there we call fetch_buf in a for loop.
3. The first time we call fetch_buf, it returns properly one buffer. However, the second time we call it, it returns 0
because vq->avail_idx == vq->last_avail_idx and vq->avail_idx == last_avail_idx code path.
4. fetch_descs assign ret = 0, so it returns 0. vhost_get_vq_desc will goto err, and it will signal no new buffer
(returning vq->num).

So to fix it and maintain the batching maybe we could return vq->ndescs in case ret == 0:

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c0dfb5e3d2af..5993d4f34ca9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2315,7 +2327,8 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 
 	/* On success we expect some descs */
 	BUG_ON(ret > 0 && !vq->ndescs);
-	return ret;
+	return ret ?: vq->ndescs;
 }
 
 /* Reverse the effects of fetch_descs */
--

Another possibility could be to return different codes from fetch_buf, but I find the suggested modification easier.

What do you think?

Thanks!


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0809B1C17E2
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgEAOh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:37:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728890AbgEAOh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:37:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588343845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+pSfuYwc07hQQ9dsDKJcYfTJmTKhIXhBIr9mDnsaJ8=;
        b=SOZnImqGkuaYBRIwwm3LtXW+UbBy/hXHl9brcumD1p5KJdRl77GoAmk59lfBJrE31zxQ+N
        ixlT3XcSdMJx+gpAcl6hPN4iOfTm4mklw4kOp3zOT8ETNfZShBoEdjtO4zRPQdkiFbvDgh
        iGfuvBEOPGpmlgcUvB4+kJLW1T5g5mE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-CQ1t0axZPlah8sQoi3Ld6w-1; Fri, 01 May 2020 10:37:22 -0400
X-MC-Unique: CQ1t0axZPlah8sQoi3Ld6w-1
Received: by mail-wm1-f70.google.com with SMTP id j5so2757599wmi.4
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 07:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=I+pSfuYwc07hQQ9dsDKJcYfTJmTKhIXhBIr9mDnsaJ8=;
        b=edTT8H+K4F9d3YyrAFCAO5yvD/BdWmT0y83e9raEbhfuQFK7Ir+AcpvNVnMOQfNkcE
         stRSIEzQKtTYdWCggGa7RjZhnPoeGCVVxr07tfAaBxF+fiYq8LBzgMDwmotKneqlW5zm
         aa3g9xh7jG3vP2SNk9U7WvTTK74XxUFxxBk1hgSkWlAFebs0ZyZwP/mcoDqAm+QYqOPn
         Evea2aud+haiP8OuQI8qTfynDOoCd8No/MLDuveu8EV7H47XhvGnL9hwp+ueXYlA68HZ
         SdIQ/+4fE5cCTn8h7hnDiSP7lpUpi1go0J0hDTQnNPLY6MF90NvjnHp4gSFZSOTnn/+b
         7N6Q==
X-Gm-Message-State: AGi0Pua1cPMCWgXTQEjZuR0U/sufftck6uj9wkPB+GZrLwf54rMBR3ns
        38kybAFKLu1MYZJWB50ut8gXqLjf8uHmfW/qfSIdhtDumNSuRrhpwTnWwIQ4VjnMh7LTJJ4QphP
        8mrscuVnh1OGAk3tv
X-Received: by 2002:a1c:1d4b:: with SMTP id d72mr4150363wmd.19.1588343840465;
        Fri, 01 May 2020 07:37:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypKHqBQQRlsc1K8bjThQcoW9mKD/VyXIIHA6zpDxxO2WCF7VUxpGnsPXDB+8huVAz76rKrLJPQ==
X-Received: by 2002:a1c:1d4b:: with SMTP id d72mr4150333wmd.19.1588343840150;
        Fri, 01 May 2020 07:37:20 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id r20sm4024126wmh.26.2020.05.01.07.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:37:19 -0700 (PDT)
Date:   Fri, 1 May 2020 16:37:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaly Xin <Kaly.Xin@arm.com>
Subject: Re: [PATCH] vhost: vsock: don't send pkt when vq is not started
Message-ID: <20200501143716.ln7hjh3vn77ng43i@steredhat>
References: <20200430021314.6425-1-justin.he@arm.com>
 <20200430082608.wbtqgglmtnd7e5ci@steredhat>
 <AM6PR08MB4069D4AB611B8C8180DC4B9CF7AA0@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200430162521.k4b4t3vttfabgqal@steredhat>
 <20200430153929-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430153929-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 03:43:00PM -0400, Michael S. Tsirkin wrote:
> On Thu, Apr 30, 2020 at 06:25:21PM +0200, Stefano Garzarella wrote:
> > On Thu, Apr 30, 2020 at 10:06:26AM +0000, Justin He wrote:
> > > Hi Stefano
> > > 
> > > > -----Original Message-----
> > > > From: Stefano Garzarella <sgarzare@redhat.com>
> > > > Sent: Thursday, April 30, 2020 4:26 PM
> > > > To: Justin He <Justin.He@arm.com>
> > > > Cc: Stefan Hajnoczi <stefanha@redhat.com>; Michael S. Tsirkin
> > > > <mst@redhat.com>; Jason Wang <jasowang@redhat.com>;
> > > > kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Kaly Xin
> > > > <Kaly.Xin@arm.com>
> > > > Subject: Re: [PATCH] vhost: vsock: don't send pkt when vq is not started
> > > >
> > > > Hi Jia,
> > > > thanks for the patch, some comments below:
> > > >
> > > > On Thu, Apr 30, 2020 at 10:13:14AM +0800, Jia He wrote:
> > > > > Ning Bo reported an abnormal 2-second gap when booting Kata container
> > > > [1].
> > > > > The unconditional timeout is caused by
> > > > VSOCK_DEFAULT_CONNECT_TIMEOUT of
> > > > > connect at client side. The vhost vsock client tries to connect an
> > > > > initlizing virtio vsock server.
> > > > >
> > > > > The abnormal flow looks like:
> > > > > host-userspace           vhost vsock                       guest vsock
> > > > > ==============           ===========                       ============
> > > > > connect()     -------->  vhost_transport_send_pkt_work()   initializing
> > > > >    |                     vq->private_data==NULL
> > > > >    |                     will not be queued
> > > > >    V
> > > > > schedule_timeout(2s)
> > > > >                          vhost_vsock_start()  <---------   device ready
> > > > >                          set vq->private_data
> > > > >
> > > > > wait for 2s and failed
> > > > >
> > > > > connect() again          vq->private_data!=NULL          recv connecting pkt
> > > > >
> > > > > 1. host userspace sends a connect pkt, at that time, guest vsock is under
> > > > > initializing, hence the vhost_vsock_start has not been called. So
> > > > > vq->private_data==NULL, and the pkt is not been queued to send to guest.
> > > > > 2. then it sleeps for 2s
> > > > > 3. after guest vsock finishes initializing, vq->private_data is set.
> > > > > 4. When host userspace wakes up after 2s, send connecting pkt again,
> > > > > everything is fine.
> > > > >
> > > > > This fixes it by checking vq->private_data in vhost_transport_send_pkt,
> > > > > and return at once if !vq->private_data. This makes user connect()
> > > > > be returned with ECONNREFUSED.
> > > > >
> > > > > After this patch, kata-runtime (with vsock enabled) boottime reduces from
> > > > > 3s to 1s on ThunderX2 arm64 server.
> > > > >
> > > > > [1] https://github.com/kata-containers/runtime/issues/1917
> > > > >
> > > > > Reported-by: Ning Bo <n.b@live.com>
> > > > > Signed-off-by: Jia He <justin.he@arm.com>
> > > > > ---
> > > > >  drivers/vhost/vsock.c | 8 ++++++++
> > > > >  1 file changed, 8 insertions(+)
> > > > >
> > > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > > index e36aaf9ba7bd..67474334dd88 100644
> > > > > --- a/drivers/vhost/vsock.c
> > > > > +++ b/drivers/vhost/vsock.c
> > > > > @@ -241,6 +241,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt
> > > > *pkt)
> > > > >  {
> > > > >  struct vhost_vsock *vsock;
> > > > >  int len = pkt->len;
> > > > > +struct vhost_virtqueue *vq;
> > > > >
> > > > >  rcu_read_lock();
> > > > >
> > > > > @@ -252,6 +253,13 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt
> > > > *pkt)
> > > > >  return -ENODEV;
> > > > >  }
> > > > >
> > > > > +vq = &vsock->vqs[VSOCK_VQ_RX];
> > > > > +if (!vq->private_data) {
> > > >
> > > > I think is better to use vhost_vq_get_backend():
> > > >
> > > > if (!vhost_vq_get_backend(&vsock->vqs[VSOCK_VQ_RX])) {
> > > > ...
> > > >
> > > > This function should be called with 'vq->mutex' acquired as explained in
> > > > the comment, but here we can avoid that, because we are not using the vq,
> > > > so it is safe, because in vhost_transport_do_send_pkt() we check it again.
> > > >
> > > > Please add a comment explaining that.
> > > >
> > > 
> > > Thanks, vhost_vq_get_backend is better. I chose a 5.3 kernel to develop
> > > and missed this helper.
> > 
> > :-)
> > 
> > > >
> > > > As an alternative to this patch, should we kick the send worker when the
> > > > device is ready?
> > > >
> > > > IIUC we reach the timeout because the send worker (that runs
> > > > vhost_transport_do_send_pkt()) exits immediately since 'vq->private_data'
> > > > is NULL, and no one will requeue it.
> > > >
> > > > Let's do it when we know the device is ready:
> > > >
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index e36aaf9ba7bd..295b5867944f 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -543,6 +543,11 @@ static int vhost_vsock_start(struct vhost_vsock
> > > > *vsock)
> > > >                 mutex_unlock(&vq->mutex);
> > > >         }
> > > >
> > > > +       /* Some packets may have been queued before the device was started,
> > > > +        * let's kick the send worker to send them.
> > > > +        */
> > > > +       vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
> > > > +
> > > Yes, it works.
> > > But do you think a threshold should be set here to prevent the queue
> > > from being too long? E.g. the client user sends too many connect pkts
> > > in a short time before the server is completely ready.
> > 
> > When the user call the connect() the socket status is moved to
> > SS_CONNECTING (see net/vmw_vsock/af_vsock.c), so another connect() on
> > the same socket will receive EALREADY error.
> > 
> > If the user uses multiple sockets, the socket layer already check for
> > any limits, so I don't think we should put a threshold here.
> > 
> > > 
> > > >         mutex_unlock(&vsock->dev.mutex);
> > > >         return 0;
> > > >
> > > > I didn't test it, can you try if it fixes the issue?
> > > >
> > > > I'm not sure which is better...
> > > I don't know, either. Wait for more comments 😊
> > 
> > I prefer the second option, because the device is in a transitional
> > state and a connect can block (for at most two seconds) until the device is
> > started.
> > 
> > For the first option, I'm also not sure if ECONNREFUSED is the right error
> > to return, maybe is better ENETUNREACH.
> > 
> > Cheers,
> > Stefano
> 
> IIRC:
> 
> ECONNREFUSED is what one gets when connecting to remote a port which does not
> yet have a listening socket, so remote sends back RST.
> ENETUNREACH is when local network's down, so you can't even send a
> connection request.
> EHOSTUNREACH is remote network is down.

Thanks for the clarification!

I was looking at connect(2) man page and there isn't EHOSTUNREACH in the
ERRORS section :-(

But connect(3p) contains the following that match what you said:
       ECONNRESET
              Remote host reset the connection request.
       ENETUNREACH
              No route to the network is present.
       EHOSTUNREACH
              The  destination host cannot be reached (probably because
              the host is down or a remote router cannot reach it).

So in this case, I think ENETUNREACH should be the best one, since the
device is down and we can't send the connection request, but also
EHOSTUNREACH should fit...

In af_vsock.c we already return ENETUNREACH when the stream is not allowed
or we don't have a transport to use.

Thanks,
Stefano


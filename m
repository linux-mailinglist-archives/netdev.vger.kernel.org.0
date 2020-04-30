Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5111BF2BC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgD3I00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:26:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46045 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726526AbgD3I0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588235176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YGyRDtb4bigS4OJJzosmGsfyXf9UuewqBG5sz68PxEc=;
        b=XD4+LjTR67qMiJunq9cF1ctpi5eWEO1IxZjj904vBOR9NTSrzkz9rnVY4l5fm684p4FtUe
        lo53d4oVFvaL+3rFdvIGx3E4/7bbuuJeG8iU7Yn2me8kn+6RINWv4K/X4DI7B1+T0vVJfD
        YYthciY3/DHq5OJ51ihV+R7xOUp7HpA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-S5Ox3dX-NxGNaBHjzXNr7A-1; Thu, 30 Apr 2020 04:26:13 -0400
X-MC-Unique: S5Ox3dX-NxGNaBHjzXNr7A-1
Received: by mail-wr1-f70.google.com with SMTP id g7so3465301wrw.18
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 01:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YGyRDtb4bigS4OJJzosmGsfyXf9UuewqBG5sz68PxEc=;
        b=sbBsy37VYYarWZF9HrQVuRZqEo6+7WlFHv82NaWUkpFAQaTPt+OOBhP3jrE2RAsuEW
         zoAnFyqOD+h9IkbwKEbrkDnFolnz7Ld07Vjy+owSnYAYmZubkwakzYag9bTR90UuPMkb
         SewPbBTKoWJmksFib9MGsrzNHu47Ykc6gMmR2XyQiT7FvAqozRJzP2XD2A8MUEHug86i
         KUlWzb1X/aQUokNgFPgPfCF/LXQ2axt6q6Hf73y25ZWMnGB5xMt5GmsY4w2TyJl445wk
         i268vKAlGmjFp3wO2X2Wfl2lcAaAcY7sNBSPueV3BmD6f4HiB+GCdDpRQItaoxxgjx2E
         9FgA==
X-Gm-Message-State: AGi0Pubzq9gI5gRbhd9VFwE943CSeaewuvBb8X7O0sJfjRJy1NGkF9ak
        44q3Fe4Jjaveoz05D25VAjmiymDMfR7+8FeSvZWoGXESZDsszILyiudtbd9EYAg8vUnn4cEDVO4
        82JmlcQHM5O975Aia
X-Received: by 2002:adf:f781:: with SMTP id q1mr2361211wrp.323.1588235172032;
        Thu, 30 Apr 2020 01:26:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJoi4cvRWNuIpuOzpMBz+IGc+hNuGVeAAtdk4bhTz0tRoJTi6UyA0vRsxW70RBXtjBsbtVC5Q==
X-Received: by 2002:adf:f781:: with SMTP id q1mr2361196wrp.323.1588235171773;
        Thu, 30 Apr 2020 01:26:11 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id z8sm2874873wrr.40.2020.04.30.01.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 01:26:11 -0700 (PDT)
Date:   Thu, 30 Apr 2020 10:26:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly.Xin@arm.com
Subject: Re: [PATCH] vhost: vsock: don't send pkt when vq is not started
Message-ID: <20200430082608.wbtqgglmtnd7e5ci@steredhat>
References: <20200430021314.6425-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430021314.6425-1-justin.he@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jia,
thanks for the patch, some comments below:

On Thu, Apr 30, 2020 at 10:13:14AM +0800, Jia He wrote:
> Ning Bo reported an abnormal 2-second gap when booting Kata container [1].
> The unconditional timeout is caused by VSOCK_DEFAULT_CONNECT_TIMEOUT of
> connect at client side. The vhost vsock client tries to connect an
> initlizing virtio vsock server.
> 
> The abnormal flow looks like:
> host-userspace           vhost vsock                       guest vsock
> ==============           ===========                       ============
> connect()     -------->  vhost_transport_send_pkt_work()   initializing
>    |                     vq->private_data==NULL
>    |                     will not be queued
>    V
> schedule_timeout(2s)
>                          vhost_vsock_start()  <---------   device ready
>                          set vq->private_data
> 
> wait for 2s and failed
> 
> connect() again          vq->private_data!=NULL          recv connecting pkt
> 
> 1. host userspace sends a connect pkt, at that time, guest vsock is under
> initializing, hence the vhost_vsock_start has not been called. So
> vq->private_data==NULL, and the pkt is not been queued to send to guest.
> 2. then it sleeps for 2s
> 3. after guest vsock finishes initializing, vq->private_data is set.
> 4. When host userspace wakes up after 2s, send connecting pkt again,
> everything is fine.
> 
> This fixes it by checking vq->private_data in vhost_transport_send_pkt,
> and return at once if !vq->private_data. This makes user connect()
> be returned with ECONNREFUSED.
> 
> After this patch, kata-runtime (with vsock enabled) boottime reduces from
> 3s to 1s on ThunderX2 arm64 server.
> 
> [1] https://github.com/kata-containers/runtime/issues/1917
> 
> Reported-by: Ning Bo <n.b@live.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  drivers/vhost/vsock.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index e36aaf9ba7bd..67474334dd88 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -241,6 +241,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
>  {
>  	struct vhost_vsock *vsock;
>  	int len = pkt->len;
> +	struct vhost_virtqueue *vq;
>  
>  	rcu_read_lock();
>  
> @@ -252,6 +253,13 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
>  		return -ENODEV;
>  	}
>  
> +	vq = &vsock->vqs[VSOCK_VQ_RX];
> +	if (!vq->private_data) {

I think is better to use vhost_vq_get_backend():

	if (!vhost_vq_get_backend(&vsock->vqs[VSOCK_VQ_RX])) {
		...

This function should be called with 'vq->mutex' acquired as explained in
the comment, but here we can avoid that, because we are not using the vq,
so it is safe, because in vhost_transport_do_send_pkt() we check it again.

Please add a comment explaining that.


As an alternative to this patch, should we kick the send worker when the
device is ready?

IIUC we reach the timeout because the send worker (that runs
vhost_transport_do_send_pkt()) exits immediately since 'vq->private_data'
is NULL, and no one will requeue it.

Let's do it when we know the device is ready:

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index e36aaf9ba7bd..295b5867944f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -543,6 +543,11 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
                mutex_unlock(&vq->mutex);
        }
 
+       /* Some packets may have been queued before the device was started,
+        * let's kick the send worker to send them.
+        */
+       vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+
        mutex_unlock(&vsock->dev.mutex);
        return 0;

I didn't test it, can you try if it fixes the issue?

I'm not sure which is better...

Thanks,
Stefano


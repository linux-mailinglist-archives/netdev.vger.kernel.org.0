Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3966B1C1804
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgEAOlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:41:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728724AbgEAOlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588344059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMCVUX3SZIQcfGxvWeP6Mw5R9IcHL0EXZloLxMg4CEI=;
        b=XPu4qCyELR0pt0+mjhA+gfy8tvJCVCfZVHh74qB7Yc9Kt1mVo8Oi8PYQwdW7O/XjxpEo+f
        n6pJpCwwFDPQkfgV2dk974zJakLRPabdX3q2mjYHsZ/zVveU1z4xRrgQ0sUhTmm83gVZWZ
        BcusGtGoovEQGbr+n0Kj/omU5wIwF30=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-VmbF2X1HMVm6MrXBI-1h5Q-1; Fri, 01 May 2020 10:40:56 -0400
X-MC-Unique: VmbF2X1HMVm6MrXBI-1h5Q-1
Received: by mail-wm1-f69.google.com with SMTP id s12so2763237wmj.6
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 07:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FMCVUX3SZIQcfGxvWeP6Mw5R9IcHL0EXZloLxMg4CEI=;
        b=hvUc+LeIzGY6si3X0E1upUfCw0bKQegrOJFIWJ4DBZYNMw1T1NTEK7Oxve/0DoE38h
         cg2aLL4oPUzy9YFlc2mZeMihQU/55TOwPZBBiVjc0IQU27D0dVhBTU2NnyqKbK+oD+7M
         oisiKiS4f0peY3pxeJqBurtkg+0k+fo8xdl2pZagctqtEDdaGL77va4hZx33gpVy1PtY
         q5+Ac67NOpTDiTICiDxfUT8ONnNK+b+yBn12tR0uaJrT4vkfw3r+vwYa6PLZA46DusMr
         sS6xMtasWv1lN1LhBDYLm1OsR0x8aZoA7oBac8zsJUziic3cHceVoisjhVWdlhjaJomV
         qKZQ==
X-Gm-Message-State: AGi0PuZerZdM6zI92sajkAbuE2swV7CL+18ZHf0YMsqTyWQ2ClX1ZsRZ
        23/0+r5hA+6EAWXF9a0lXB9XYP4jugnZdeTdFKzhCEylOxBDB6e3jV9gfH3r3wpxTXUCY8M5gAy
        5bnJhuAoheRJYadgY
X-Received: by 2002:adf:df82:: with SMTP id z2mr4930979wrl.58.1588344054919;
        Fri, 01 May 2020 07:40:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypIlKvu49W7Dejd9vm/UPweyZkYbpJJGe7ZlU91a4UNN1ZrYUoJL1vdxXdT4Bd7iUQNCZUPcMg==
X-Received: by 2002:adf:df82:: with SMTP id z2mr4930967wrl.58.1588344054718;
        Fri, 01 May 2020 07:40:54 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id j13sm4611452wrq.24.2020.05.01.07.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:40:53 -0700 (PDT)
Date:   Fri, 1 May 2020 16:40:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>
Subject: Re: [PATCH v2] vhost: vsock: kick send_pkt worker once device is
 started
Message-ID: <20200501144051.aotbofpyuy5tqcfp@steredhat>
References: <20200501043840.186557-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501043840.186557-1-justin.he@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 12:38:40PM +0800, Jia He wrote:
> Ning Bo reported an abnormal 2-second gap when booting Kata container [1].
> The unconditional timeout was caused by VSOCK_DEFAULT_CONNECT_TIMEOUT of
> connecting from the client side. The vhost vsock client tries to connect
> an initializing virtio vsock server.
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
> connect() again          vq->private_data!=NULL         recv connecting pkt
> 
> Details:
> 1. Host userspace sends a connect pkt, at that time, guest vsock is under
>    initializing, hence the vhost_vsock_start has not been called. So
>    vq->private_data==NULL, and the pkt is not been queued to send to guest
> 2. Then it sleeps for 2s
> 3. After guest vsock finishes initializing, vq->private_data is set
> 4. When host userspace wakes up after 2s, send connecting pkt again,
>    everything is fine.
> 
> As suggested by Stefano Garzarella, this fixes it by additional kicking the
> send_pkt worker in vhost_vsock_start once the virtio device is started. This
> makes the pending pkt sent again.
> 
> After this patch, kata-runtime (with vsock enabled) boot time is reduced
> from 3s to 1s on a ThunderX2 arm64 server.
> 
> [1] https://github.com/kata-containers/runtime/issues/1917
> 
> Reported-by: Ning Bo <n.b@live.com>
> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
> v2: new solution suggested by Stefano Garzarella
> 
>  drivers/vhost/vsock.c | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index e36aaf9ba7bd..0716a9cdffee 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -543,6 +543,11 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
>  		mutex_unlock(&vq->mutex);
>  	}
>  
> +	/* Some packets may have been queued before the device was started,
> +	 * let's kick the send worker to send them.
> +	 */
> +	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
> +
>  	mutex_unlock(&vsock->dev.mutex);
>  	return 0;
>  
> -- 
> 2.17.1
> 


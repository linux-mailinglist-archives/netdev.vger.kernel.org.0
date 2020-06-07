Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBD31F0B64
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 15:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgFGNXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 09:23:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726620AbgFGNXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 09:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591536192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nzWELUbihqr0OzJqk667T7ZcaVLQixxUzSoFLzNjkfY=;
        b=Yt1Vg0BrnuZm/ccQhSQ57GS7MCWn2hA5zWNjsh6/lbA1FQuHKlZefaWxmebByT6NKj2wZY
        OupqexIKNLLufAfLHSzFK5hE6tJXrE8e5QsI4MsoUzb0O/VqhkKwy+/uLLVtU5J2/z1Ayi
        o701rxWOfi7WMjvwk18YskvI7c7VEI8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-fy4JDZmiNbu91-POelaH5Q-1; Sun, 07 Jun 2020 09:23:08 -0400
X-MC-Unique: fy4JDZmiNbu91-POelaH5Q-1
Received: by mail-wr1-f70.google.com with SMTP id l1so6010356wrc.8
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 06:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nzWELUbihqr0OzJqk667T7ZcaVLQixxUzSoFLzNjkfY=;
        b=P8Y/iIp3p9HPtFC7pxCS5h0An+YmU374kaa81zWqg0J0tDWet8CfmvMx55lLalKCeY
         3XNFKZ4cl/RJ14Q7sK2PEUt5PY2YJRVv0VJG/8eaPQXTX5b/ckCPpu2GdOfFrIFHty0Y
         49IBF+d7XiCxBEszqUX0gvGACLpLTEc3FzvdkPEDj2xk1aqdN/MTZMVZ35wBMHh4IZYo
         DKwFZWoBX66Rw7XsgrfBmxEsc/2qDF1Vm8oQi7um0r2ai8G0nfGgUnns1TDwHJFft5YA
         4X3TpVC0VlavrNWkIvZWAEo9RXTwQc7lXZPHhmUEQ1HafkhYV90WB6erqS/eKdTsrCPe
         /oTQ==
X-Gm-Message-State: AOAM533Bq/RgJ9cbxgODhde0t8DmRiz+Dv0I1PHaZigX2RSmhtjGTKVd
        +d1Ra9UnBhgzy/JHAueVtPa+Fe4ckkZn7RSNHiK6mJZWNroxZiNQ3apIcrgPE7jZNwmwW/vo2Vp
        wQhUm5r0pPLbCKTPL
X-Received: by 2002:adf:ef47:: with SMTP id c7mr20308710wrp.57.1591536187513;
        Sun, 07 Jun 2020 06:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9Cz802alwljjy3QR3GieCH2PcRwXdp616DctWfOY9tE4occ9rLa9RTY7DIsA2TnSjwRq/+g==
X-Received: by 2002:adf:ef47:: with SMTP id c7mr20308698wrp.57.1591536187295;
        Sun, 07 Jun 2020 06:23:07 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id r2sm20886428wrg.68.2020.06.07.06.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 06:23:06 -0700 (PDT)
Date:   Sun, 7 Jun 2020 09:23:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] virtio_net: Unregister and re-register xdp_rxq across
 freeze/restore
Message-ID: <20200607091542-mutt-send-email-mst@kernel.org>
References: <20200605214624.21430-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605214624.21430-1-sean.j.christopherson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 02:46:24PM -0700, Sean Christopherson wrote:
> Unregister each queue's xdp_rxq during freeze, and re-register the new
> instance during restore.  All queues are released during free and
> recreated during restore, i.e. the pre-freeze xdp_rxq will be lost.
> 
> The bug is detected by WARNs in xdp_rxq_info_unreg() and
> xdp_rxq_info_unreg_mem_model() that fire after a suspend/resume cycle as
> virtnet_close() attempts to unregister an uninitialized xdp_rxq object.
> 
>   ------------[ cut here ]------------
>   Driver BUG
>   WARNING: CPU: 0 PID: 880 at net/core/xdp.c:163 xdp_rxq_info_unreg+0x48/0x50
>   Modules linked in:
>   CPU: 0 PID: 880 Comm: ip Not tainted 5.7.0-rc5+ #80
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:xdp_rxq_info_unreg+0x48/0x50
>   Code: <0f> 0b eb ca 0f 1f 40 00 0f 1f 44 00 00 53 48 83 ec 10 8b 47 0c 83
>   RSP: 0018:ffffc900001ab540 EFLAGS: 00010286
>   RAX: 0000000000000000 RBX: ffff88827f83ac80 RCX: 0000000000000000
>   RDX: 000000000000000a RSI: ffffffff8253bc2a RDI: ffffffff825397ec
>   RBP: 0000000000000000 R08: ffffffff8253bc20 R09: 000000000000000a
>   R10: ffffc900001ab548 R11: 0000000000000370 R12: ffff88817a89c000
>   R13: 0000000000000000 R14: ffffc900001abbc8 R15: 0000000000000001
>   FS:  00007f48b70e70c0(0000) GS:ffff88817bc00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f48b6634950 CR3: 0000000277f1d002 CR4: 0000000000160eb0
>   Call Trace:
>    virtnet_close+0x6a/0xb0
>    __dev_close_many+0x91/0x100
>    __dev_change_flags+0xc1/0x1c0
>    dev_change_flags+0x23/0x60
>    do_setlink+0x350/0xdf0
>    __rtnl_newlink+0x553/0x860
>    rtnl_newlink+0x43/0x60
>    rtnetlink_rcv_msg+0x289/0x340
>    netlink_rcv_skb+0xd1/0x110
>    netlink_unicast+0x203/0x310
>    netlink_sendmsg+0x32b/0x460
>    sock_sendmsg+0x5b/0x60
>    ____sys_sendmsg+0x23e/0x260
>    ___sys_sendmsg+0x88/0xd0
>    __sys_sendmsg+0x63/0xa0
>    do_syscall_64+0x4c/0x170
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   ------------[ cut here ]------------
> 
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Fixes: 754b8a21a96d5 ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Disclaimer: I am not remotely confident that this patch is 100% correct
> or complete, my VirtIO knowledge is poor and my networking knowledge is
> downright abysmal.
> 
>  drivers/net/virtio_net.c | 37 +++++++++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba38765dc490..61055be3615e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1469,6 +1469,21 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  	return received;
>  }
>  
> +static int virtnet_reg_xdp(struct xdp_rxq_info *xdp_rxq,
> +			   struct net_device *dev, u32 queue_index)
> +{
> +	int err;
> +
> +	err = xdp_rxq_info_reg(xdp_rxq, dev, queue_index);
> +	if (err < 0)
> +		return err;
> +
> +	err = xdp_rxq_info_reg_mem_model(xdp_rxq, MEM_TYPE_PAGE_SHARED, NULL);
> +	if (err < 0)
> +		xdp_rxq_info_unreg(xdp_rxq);
> +	return err;
> +}
> +
>  static int virtnet_open(struct net_device *dev)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> @@ -1480,17 +1495,10 @@ static int virtnet_open(struct net_device *dev)
>  			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>  				schedule_delayed_work(&vi->refill, 0);
>  
> -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i);
> +		err = virtnet_reg_xdp(&vi->rq[i].xdp_rxq, dev, i);
>  		if (err < 0)
>  			return err;
>  
> -		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> -						 MEM_TYPE_PAGE_SHARED, NULL);
> -		if (err < 0) {
> -			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -			return err;
> -		}
> -
>  		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>  		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>  	}
> @@ -2306,6 +2314,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>  
>  	if (netif_running(vi->dev)) {
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
> +			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>  			napi_disable(&vi->rq[i].napi);
>  			virtnet_napi_tx_disable(&vi->sq[i].napi);

I suspect the right thing to do is to first disable all NAPI,
then play with XDP. Generally cleanup in the reverse order
of init is a good idea.


>  		}
> @@ -2313,6 +2322,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>  }
>  
>  static int init_vqs(struct virtnet_info *vi);
> +static void virtnet_del_vqs(struct virtnet_info *vi);
> +static void free_receive_page_frags(struct virtnet_info *vi);

I'd really rather we reordered code so forward decls are not necessary.

>  static int virtnet_restore_up(struct virtio_device *vdev)
>  {
> @@ -2331,6 +2342,10 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>  				schedule_delayed_work(&vi->refill, 0);
>  
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
> +			err = virtnet_reg_xdp(&vi->rq[i].xdp_rxq, vi->dev, i);
> +			if (err)
> +				goto free_vqs;
> +
>  			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>  			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
>  					       &vi->sq[i].napi);
> @@ -2340,6 +2355,12 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>  	netif_tx_lock_bh(vi->dev);
>  	netif_device_attach(vi->dev);
>  	netif_tx_unlock_bh(vi->dev);
> +	return 0;
> +
> +free_vqs:
> +	cancel_delayed_work_sync(&vi->refill);
> +	free_receive_page_frags(vi);
> +	virtnet_del_vqs(vi);


I am not sure this is safe to do after device-ready.

Can reg xdp happen before device ready?


>  	return err;
>  }
>  
> -- 
> 2.26.0


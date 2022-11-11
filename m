Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C066262FC
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiKKUfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiKKUfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:35:18 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B11583F;
        Fri, 11 Nov 2022 12:35:18 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 6so5241159pgm.6;
        Fri, 11 Nov 2022 12:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCMPU3HV90X3WiMtwGJY9HCNz2GAEAWPUbWr5rH9PwM=;
        b=N+wlzuG5A4aC2jE7VxxEaMoCJvWY9E1jhzUcTzBRQuVpmlfEt24/Vi6nHHPeRMYF/T
         Ga8lCzDrsFZYvGPvgYr0iZdQWCn17jfl74Qpof7BGCFHGpfx0mh5vx7UorlDgDyaIQI3
         DhbezMk4Y2aRVV6iaYTMGYmI0osMjE95vtYy47FuKNfhsaKH74Ulh9o8aqVsQJnhcKSY
         bghfa27hD3czmEhcw62NLxc+mWRHc+o0lXckhUTo0iv3C5Nb67Y0loz2wokFOXnnw/xw
         N6/iFptkzrZywnZ+zWQs9/0tJL6ETtholGH76wYAyzab8JAJcxAOZvQ2Trm+4gBng0FL
         RJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCMPU3HV90X3WiMtwGJY9HCNz2GAEAWPUbWr5rH9PwM=;
        b=sEOqfbNmS/E9cum5UujZdPrGNJ/mgg0Rh5J1HcHgPz8Iv0slYEso7Rt7i7ZPxu+MQM
         APFhQB9SsbbTVUfTeqZ2C0gmSEND78iTJR8dJKY2/ga1jUx32TW9x6oDrTByoAJFqhGY
         GlfgFlqh0iiF5kLCCP/h8x2A9cSUGO5q+teTzfdAPD3VzvEbOw3wT1OjekrPl7KVOteP
         3r5dmlPLUvzSN3s2kwrqdsLV5KmkGNlt9zxTXkm6i6jkJTM3CBX2lHpwCBu7SblRdRes
         Hij+w96kG7On8xzjDBpto7NQFV8U/v57TWzHvezkJnLhf0N2eIarMPptW5mGIEnY/xr3
         2uFA==
X-Gm-Message-State: ANoB5pkjMt4uNnyZ5z9JA6neiIo2bylp73pkNRhPYUSyqn1XIVtXt+WI
        LCUvRSzmnPa7PZcrVAJLJtE=
X-Google-Smtp-Source: AA0mqf5BgcU1nCW7Xiia2kiZuzzfn3ngIHZ5kCHH0xFgk3cOcLpAIsbLFtE4BSMTW8jr1UNJj5Kk4g==
X-Received: by 2002:a63:b51:0:b0:42b:9219:d14e with SMTP id a17-20020a630b51000000b0042b9219d14emr3110834pgl.176.1668198917520;
        Fri, 11 Nov 2022 12:35:17 -0800 (PST)
Received: from localhost (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e80300b0016d72804664sm2120792plg.205.2022.11.11.12.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 12:35:17 -0800 (PST)
Date:   Fri, 11 Nov 2022 20:35:15 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 01/11] virtio/vsock: rework packet allocation logic
Message-ID: <Y0CnlSu8u5SBUb2N@bullseye>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <f896b8fd-50d2-2512-3966-3775245e9b96@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f896b8fd-50d2-2512-3966-3775245e9b96@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 07:36:02PM +0000, Arseniy Krasnov wrote:
> To support zerocopy receive, packet's buffer allocation is changed: for
> buffers which could be mapped to user's vma we can't use 'kmalloc()'(as
> kernel restricts to map slab pages to user's vma) and raw buddy
> allocator now called. But, for tx packets(such packets won't be mapped
> to user), previous 'kmalloc()' way is used, but with special flag in
> packet's structure which allows to distinguish between 'kmalloc()' and
> raw pages buffers.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

Hey Arseniy, great work here!

> ---
>  drivers/vhost/vsock.c                   |  1 +
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport.c        |  8 ++++++--
>  net/vmw_vsock/virtio_transport_common.c | 10 +++++++++-
>  4 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 5703775af129..65475d128a1d 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -399,6 +399,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>  		return NULL;
>  	}
>  
> +	pkt->slab_buf = true;
>  	pkt->buf_len = pkt->len;
>  
>  	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 35d7eedb5e8e..d02cb7aa922f 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -50,6 +50,7 @@ struct virtio_vsock_pkt {
>  	u32 off;
>  	bool reply;
>  	bool tap_delivered;
> +	bool slab_buf;
>  };

WRT the sk_buff series, I bet this bool will not be needed after the
rebase.

>  
>  struct virtio_vsock_pkt_info {
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index ad64f403536a..19909c1e9ba3 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -255,16 +255,20 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
>  	vq = vsock->vqs[VSOCK_VQ_RX];
>  
>  	do {
> +		struct page *buf_page;
> +
>  		pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>  		if (!pkt)
>  			break;
>  
> -		pkt->buf = kmalloc(buf_len, GFP_KERNEL);
> -		if (!pkt->buf) {
> +		buf_page = alloc_page(GFP_KERNEL);
> +
> +		if (!buf_page) {

I think it should not be too hard to use build_skb() around the page
here after rebasing onto the sk_buff series.

>  			virtio_transport_free_pkt(pkt);
>  			break;
>  		}
>  
> +		pkt->buf = page_to_virt(buf_page);
>  		pkt->buf_len = buf_len;
>  		pkt->len = buf_len;
>  
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index a9980e9b9304..37e8dbfe2f5d 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -69,6 +69,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>  		if (!pkt->buf)
>  			goto out_pkt;
>  
> +		pkt->slab_buf = true;
>  		pkt->buf_len = len;
>  
>  		err = memcpy_from_msg(pkt->buf, info->msg, len);
> @@ -1339,7 +1340,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
>  
>  void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
>  {
> -	kvfree(pkt->buf);
> +	if (pkt->buf_len) {
> +		if (pkt->slab_buf)
> +			kvfree(pkt->buf);
> +		else
> +			free_pages((unsigned long)pkt->buf,
> +				   get_order(pkt->buf_len));
> +	}
> +
>  	kfree(pkt);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
> -- 
> 2.35.0

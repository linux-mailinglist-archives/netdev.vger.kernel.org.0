Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1391F576B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgFJPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:14:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43148 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730062AbgFJPN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 11:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591802036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCaS5B0zDLBWnfrEXUqdrW0d6LJpY2CfoA/LuwizqL4=;
        b=iyeQxip+s5lRA+1HRVVaOY1Jr3cR/MCI5aOngU2MUut1pP3KbxOtetVHd/GWQGVU8WFiYg
        azcUS1wqR8kHPm2YH2ETT7PGMUyYxuSn5J50u8FP4YF8WTKIU8urwkBwqseLZDOaFalCS8
        tzrHLfeQdsJqVTUIcvf1s+kY5Hb9FbA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-oPtb_D-GM4qMDGf90z0p0w-1; Wed, 10 Jun 2020 11:13:53 -0400
X-MC-Unique: oPtb_D-GM4qMDGf90z0p0w-1
Received: by mail-wm1-f71.google.com with SMTP id x6so566480wmj.9
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UCaS5B0zDLBWnfrEXUqdrW0d6LJpY2CfoA/LuwizqL4=;
        b=SL+e5AUy5tPTe8MlO5iS9zgVi01ypjgUFCEgRYbASSfXcrULJRH+UaD6N6rSiMZWwN
         y9GWyn8XzAj/VsjwVn4QdAEe+mDMbkFO7AmYh72Xop+tXD8Pp+ltTS1OuulZ8Z9TAH7A
         UJm6BpEjsp7AEbNSprkBvm5rWPbvw6iRuXhvq5N1Pfk7gdpxjNJTwOuwkLkchoT5+YvG
         paYn5CoWwGEZ96Pg/hepQw+QOlD85k3Oftw4mc16dD43kz3gOCzNqg8mTPSE8EEYFJW1
         dA+Gbq/7+6IfY5XcpZvxztch2D1XoNWAnpfmdh6ydby2jILVESOiaQPEOzEtVRYRB7NB
         xKmw==
X-Gm-Message-State: AOAM530EEA4lC3jX/ZNdn7YXQn/VphC7wIIUAp5wbJTPzD4vpCuQQwpZ
        8f548rFSuBa3O7qbOhjwJpB/UbQYn6kgS0PbxPswbBwtFSGI4xAbbxI67A1yjpC1KdWjob1+Cs/
        aHLxUH3xs6Xf3q9e6
X-Received: by 2002:adf:e285:: with SMTP id v5mr4183931wri.129.1591802031334;
        Wed, 10 Jun 2020 08:13:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5S2qkrPk2gAmC4EmpHPkNmzHg3zetZnJqn/ot/vPFPTwl3usyYGmWEmhMX3VrjvnwAgO0OQ==
X-Received: by 2002:adf:e285:: with SMTP id v5mr4183909wri.129.1591802031104;
        Wed, 10 Jun 2020 08:13:51 -0700 (PDT)
Received: from eperezma.remote.csb (109.141.78.188.dynamic.jazztel.es. [188.78.141.109])
        by smtp.gmail.com with ESMTPSA id u12sm102944wrq.90.2020.06.10.08.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 08:13:50 -0700 (PDT)
Message-ID: <f2e20055215fcfb63eb4839644c1578b21aeded9.camel@redhat.com>
Subject: Re: [PATCH RFC v7 04/14] vhost/net: pass net specific struct pointer
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Date:   Wed, 10 Jun 2020 17:13:48 +0200
In-Reply-To: <20200610113515.1497099-5-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
         <20200610113515.1497099-5-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-06-10 at 07:36 -0400, Michael S. Tsirkin wrote:
> In preparation for further cleanup, pass net specific pointer
> to ubuf callbacks so we can move net specific fields
> out to net structures.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index bf5e1d81ae25..ff594eec8ae3 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
>  	 */
>  	atomic_t refcount;
>  	wait_queue_head_t wait;
> -	struct vhost_virtqueue *vq;
> +	struct vhost_net_virtqueue *nvq;
>  };
>  
>  #define VHOST_NET_BATCH 64
> @@ -231,7 +231,7 @@ static void vhost_net_enable_zcopy(int vq)
>  }
>  
>  static struct vhost_net_ubuf_ref *
> -vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
> +vhost_net_ubuf_alloc(struct vhost_net_virtqueue *nvq, bool zcopy)
>  {
>  	struct vhost_net_ubuf_ref *ubufs;
>  	/* No zero copy backend? Nothing to count. */
> @@ -242,7 +242,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  		return ERR_PTR(-ENOMEM);
>  	atomic_set(&ubufs->refcount, 1);
>  	init_waitqueue_head(&ubufs->wait);
> -	ubufs->vq = vq;
> +	ubufs->nvq = nvq;
>  	return ubufs;
>  }
>  
> @@ -384,13 +384,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>  static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  {
>  	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
> -	struct vhost_virtqueue *vq = ubufs->vq;
> +	struct vhost_net_virtqueue *nvq = ubufs->nvq;
>  	int cnt;
>  
>  	rcu_read_lock_bh();
>  
>  	/* set len to mark this desc buffers done DMA */
> -	vq->heads[ubuf->desc].len = success ?
> +	nvq->vq.heads[ubuf->desc].in_len = success ?

Not like this matter a lot, because it will be override in next patches of the series, but `.len` has been replaced by
`.in_len`, making compiler complain. This fixes it:

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index ff594eec8ae3..fdecf39c9ac9 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -390,7 +390,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
        rcu_read_lock_bh();
 
        /* set len to mark this desc buffers done DMA */
-       nvq->vq.heads[ubuf->desc].in_len = success ?
+       nvq->vq.heads[ubuf->desc].len = success ?
                VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
        cnt = vhost_net_ubuf_put(ubufs);

>  		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
>  	cnt = vhost_net_ubuf_put(ubufs);
>  
> @@ -402,7 +402,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  	 * less than 10% of times).
>  	 */
>  	if (cnt <= 1 || !(cnt % 16))
> -		vhost_poll_queue(&vq->poll);
> +		vhost_poll_queue(&nvq->vq.poll);
>  
>  	rcu_read_unlock_bh();
>  }
> @@ -1525,7 +1525,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  	/* start polling new socket */
>  	oldsock = vhost_vq_get_backend(vq);
>  	if (sock != oldsock) {
> -		ubufs = vhost_net_ubuf_alloc(vq,
> +		ubufs = vhost_net_ubuf_alloc(nvq,
>  					     sock && vhost_sock_zcopy(sock));
>  		if (IS_ERR(ubufs)) {
>  			r = PTR_ERR(ubufs);


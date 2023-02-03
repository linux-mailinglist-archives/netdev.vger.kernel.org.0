Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFACB689315
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjBCJGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjBCJGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:06:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9805FF8
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675415148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N9HoyxJH33BYSUp+w3oKvRgLGuA+ZhszcCRdBlbExCI=;
        b=SefTbRKfkZgNIJuRCnx743bhoejiIVCy+37fxlQ4bt4oTG6oB4B3CrwpNiXAOlEVcxbch7
        wfJGdddbaowfgHdEOn+DIVXRhux1mkQi0AGEsp1/tzvyezX+uLATkNWTxKr7KFwRJ4v00M
        pLx51SigmKJPrXocRGjl+nq2nikVJx4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-ADPEwO35Ob2ltNAIw8DlLA-1; Fri, 03 Feb 2023 04:05:44 -0500
X-MC-Unique: ADPEwO35Ob2ltNAIw8DlLA-1
Received: by mail-ed1-f70.google.com with SMTP id j10-20020a05640211ca00b0049e385d5830so3176847edw.22
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:05:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9HoyxJH33BYSUp+w3oKvRgLGuA+ZhszcCRdBlbExCI=;
        b=JSFYcPByo9oE2nGCS43919ZbmIFyRKVE5IxJ1CC6UKKY2dtXzEeCX9ENFsITch3kOc
         y9XHdzK66SvlQf1w9KQpZmWOpa8G5jk1AcaFRoeH8gpT1sMeAwSJQ4yINnRuqIUduAQU
         J872I9MSCFuDSHoS3RJDf7HqfD8NQvkLSbXMxQnmZ3EF5P5o3G4FoZWUSVxk952QyPcM
         SNqPoL/zwtPH0QRvYzYNDmkRtjqiINjuxVig82+qMfELLx8j5/Y4nwPBmFkIMd1qNDjy
         lvA9WsNKUQJkWF6dK3pBJ+N426coIwBjYT4Uoij2HpzEJf4t9ymFFaCGoafX8eJN3WnM
         YKRA==
X-Gm-Message-State: AO0yUKW2Tyn9J63cIneiKNbHKW5LiiRIcF0nm/2+9gXHHhe1HGdISY/O
        CWGlAhZwlOtr+nCjwpyKXUu0GyZmuS86scnVxWwEp8EhMSVUnL9Is3VGaD+t9jOXgRlF4dWjfKC
        GHc+LjmRtEGy3O3rV
X-Received: by 2002:a17:906:8a5b:b0:7c0:efb9:bc0e with SMTP id gx27-20020a1709068a5b00b007c0efb9bc0emr9548679ejc.62.1675415143626;
        Fri, 03 Feb 2023 01:05:43 -0800 (PST)
X-Google-Smtp-Source: AK7set/70jo8DZJ8ImD+MKXLnZRXs73Nase6/1PLq5yOJq+Ilm4UroMODDIeCGdgHw1DC8iEQ8H+WA==
X-Received: by 2002:a17:906:8a5b:b0:7c0:efb9:bc0e with SMTP id gx27-20020a1709068a5b00b007c0efb9bc0emr9548668ejc.62.1675415143456;
        Fri, 03 Feb 2023 01:05:43 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id s25-20020a170906285900b008867f1905f2sm1076527ejc.39.2023.02.03.01.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:05:42 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:05:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 06/33] virtio_ring: introduce virtqueue_reset()
Message-ID: <20230203040041-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-7-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-7-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:31PM +0800, Xuan Zhuo wrote:
> Introduce virtqueue_reset() to release all buffer inside vq.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 50 ++++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h       |  2 ++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index e32046fd15a5..7dfce7001f9f 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2735,6 +2735,56 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
>  }
>  EXPORT_SYMBOL_GPL(virtqueue_resize);
>  
> +/**
> + * virtqueue_reset - reset the vring of vq

..., detach and recycle all unused buffers

	after all this is why we are doing this reset, right?

> + * @_vq: the struct virtqueue we're talking about.
> + * @recycle: callback for recycle the useless buffer

not useless :) unused:

	callback to recycle unused buffers

I know we have the same confusion in virtqueue_resize, I will fix
that.

> + *
> + * Caller must ensure we don't call this with other virtqueue operations
> + * at the same time (except where noted).
> + *
> + * Returns zero or a negative error.
> + * 0: success.
> + * -EBUSY: Failed to sync with device, vq may not work properly
> + * -ENOENT: Transport or device not supported
> + * -EPERM: Operation not permitted
> + */
> +int virtqueue_reset(struct virtqueue *_vq,
> +		    void (*recycle)(struct virtqueue *vq, void *buf))
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	struct virtio_device *vdev = vq->vq.vdev;
> +	void *buf;
> +	int err;
> +
> +	if (!vq->we_own_ring)
> +		return -EPERM;
> +
> +	if (!vdev->config->disable_vq_and_reset)
> +		return -ENOENT;
> +
> +	if (!vdev->config->enable_vq_after_reset)
> +		return -ENOENT;
> +
> +	err = vdev->config->disable_vq_and_reset(_vq);
> +	if (err)
> +		return err;
> +
> +	while ((buf = virtqueue_detach_unused_buf(_vq)) != NULL)
> +		recycle(_vq, buf);
> +
> +	if (vq->packed_ring)
> +		virtqueue_reinit_packed(vq);
> +	else
> +		virtqueue_reinit_split(vq);
> +
> +	if (vdev->config->enable_vq_after_reset(_vq))
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_reset);
> +
>  /* Only available for split ring */
>  struct virtqueue *vring_new_virtqueue(unsigned int index,
>  				      unsigned int num,
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 3ebb346ebb7c..3ca2edb1aef3 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -105,6 +105,8 @@ dma_addr_t virtqueue_get_used_addr(struct virtqueue *vq);
>  
>  int virtqueue_resize(struct virtqueue *vq, u32 num,
>  		     void (*recycle)(struct virtqueue *vq, void *buf));
> +int virtqueue_reset(struct virtqueue *vq,
> +		    void (*recycle)(struct virtqueue *vq, void *buf));
>  
>  /**
>   * struct virtio_device - representation of a device using virtio
> -- 
> 2.32.0.3.g01195cf9f


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FD66893A1
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjBCJZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjBCJZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:25:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D3F953EA
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675416278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hzQ7UoxDCUOIsyyrWZEEJT3XokG9b81p4j2nZwVsXUk=;
        b=eu7YUVXNnlYoLrqBMmues/51LlqxCLbvTFzxG9eKVmCV+2XmD6lKXsb5ERAztxUO7H+O3U
        7ExdS+x9QnwLjU0J4qdVOWpgqPbA4/TTxQuOsLatQ2V6nSUh1vNAerFleBUuu24FLCS28D
        xC0U5WSXao/sDY/FHXaaGt/S2F7V940=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-14-_Iw2ynIjPiS3doZ8xrVpBw-1; Fri, 03 Feb 2023 04:24:37 -0500
X-MC-Unique: _Iw2ynIjPiS3doZ8xrVpBw-1
Received: by mail-ed1-f71.google.com with SMTP id s11-20020a056402164b00b004a702699dfaso2869893edx.14
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:24:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzQ7UoxDCUOIsyyrWZEEJT3XokG9b81p4j2nZwVsXUk=;
        b=gTO07X6sC3CNVIM4dpy+LWDV0k0ci6LVrl/ke8m+UN+Fh4ZYLq8ExLQPC2vLh+u/aU
         ydecnMzoVaoOgPX/zfljt/HEeIVi18ALtBjZbfm0eeJMDcV0uuIVJi6GRZK0q1EmLbzP
         /JoDESRcV+gJKObKGQqQGpJjwNjGfTdSU/iiTK2LVHka6DlgffceVst5drxKAgroBydP
         zXDZfv9yfGf+9jSP17r6RLvaznhMuSlwNVip6MstjaUn/N2GmhuVpn16K6qPOvc5Egdh
         OqUBkBGmI+mgBfxtyd9jOnFp/uksdfpcVB4BtkSZnaILNkh0okchf/eNh3dLwA3bWeBL
         rKlA==
X-Gm-Message-State: AO0yUKXC8AWEZOyendSLpDI524z5vTGlMrFFmPrCZyQfaoGAgWiFAE8x
        KGDfrM0MeGf4ssUrdWoYtjh2QtmUVRmDQqkL63uciyrVJ4Xo3AZVZd0T/2ktUadBZ31rHbhSF25
        ovVdObhiI9NQZ8x7A
X-Received: by 2002:a17:906:22c7:b0:877:ef84:c7de with SMTP id q7-20020a17090622c700b00877ef84c7demr8845472eja.61.1675416275951;
        Fri, 03 Feb 2023 01:24:35 -0800 (PST)
X-Google-Smtp-Source: AK7set+TxlGnu/L3yT0xGpB437kqNK6vjM70U7jlUdSRH3DIj5ht8LTpXWMZWGwS/IflEeUiZZRQzQ==
X-Received: by 2002:a17:906:22c7:b0:877:ef84:c7de with SMTP id q7-20020a17090622c700b00877ef84c7demr8845459eja.61.1675416275741;
        Fri, 03 Feb 2023 01:24:35 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id e11-20020a170906314b00b0084c4b87aa18sm1093420eje.37.2023.02.03.01.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:24:35 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:24:30 -0500
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
Subject: Re: [PATCH 08/33] virtio_ring: introduce dma sync api for virtio
Message-ID: <20230203042103-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-9-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-9-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:33PM +0800, Xuan Zhuo wrote:
> In the process of dma sync, we involved whether virtio uses dma api. On
> the other hand, it is also necessary to read vdev->dev.parent. So these
> API has been introduced.

you don't need to repeat implementation here.
just list the new APIs and how they will be used
with premapped API.



> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 61 ++++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h       |  8 +++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 67eda7bc23ea..7b393133fd27 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -3102,4 +3102,65 @@ void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
>  }
>  EXPORT_SYMBOL_GPL(virtio_dma_unmap);
>  
> +/**
> + * virtio_dma_need_sync - check dma address need sync

.... whether a dma address needs sync

> + * @dev: virtio device
> + * @addr: DMA address
> + */
> +bool virtio_dma_need_sync(struct device *dev, dma_addr_t addr)
> +{
> +	struct virtio_device *vdev = dev_to_virtio(dev);
> +
> +	if (!vring_use_dma_api(vdev))
> +		return 0;
> +
> +	return dma_need_sync(vdev->dev.parent, addr);
> +}
> +EXPORT_SYMBOL_GPL(virtio_dma_need_sync);
> +
> +/**
> + * virtio_dma_sync_signle_range_for_cpu - dma sync for cpu
> + * @dev: virtio device
> + * @addr: DMA address
> + * @offset: DMA address offset
> + * @size: mem size for sync
> + * @dir: DMA direction
> + *
> + * Before calling this function, use virtio_dma_need_sync() to confirm that the
> + * DMA address really needs to be synchronized
> + */
> +void virtio_dma_sync_signle_range_for_cpu(struct device *dev, dma_addr_t addr,
> +					  unsigned long offset, size_t size,
> +					  enum dma_data_direction dir)
> +{
> +	struct virtio_device *vdev = dev_to_virtio(dev);
> +
> +	dma_sync_single_range_for_cpu(vdev->dev.parent, addr, offset,
> +				      size, DMA_BIDIRECTIONAL);
> +}
> +EXPORT_SYMBOL_GPL(virtio_dma_sync_signle_range_for_cpu);
> +
> +/**
> + * virtio_dma_sync_signle_range_for_device - dma sync for device
> + * @dev: virtio device
> + * @addr: DMA address
> + * @offset: DMA address offset
> + * @size: mem size for sync
> + * @dir: DMA direction
> + *
> + * Before calling this function, use virtio_dma_need_sync() to confirm that the
> + * DMA address really needs to be synchronized
> + */
> +void virtio_dma_sync_signle_range_for_device(struct device *dev,
> +					     dma_addr_t addr,
> +					     unsigned long offset, size_t size,
> +					     enum dma_data_direction dir)
> +{
> +	struct virtio_device *vdev = dev_to_virtio(dev);
> +
> +	dma_sync_single_range_for_device(vdev->dev.parent, addr, offset,
> +					 size, DMA_BIDIRECTIONAL);
> +}
> +EXPORT_SYMBOL_GPL(virtio_dma_sync_signle_range_for_device);
> +


Pls document how these APIs are only for pre-mapped buffers,
for non premapped virtio core handles DMA API internally.


>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index ce89126becc5..8c2fae318b0c 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -227,4 +227,12 @@ dma_addr_t virtio_dma_map(struct device *dev, void *addr, unsigned int length,
>  int virtio_dma_mapping_error(struct device *dev, dma_addr_t addr);
>  void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
>  		      enum dma_data_direction dir);
> +bool virtio_dma_need_sync(struct device *dev, dma_addr_t addr);
> +void virtio_dma_sync_signle_range_for_cpu(struct device *dev, dma_addr_t addr,
> +					  unsigned long offset, size_t size,
> +					  enum dma_data_direction dir);
> +void virtio_dma_sync_signle_range_for_device(struct device *dev,
> +					     dma_addr_t addr,
> +					     unsigned long offset, size_t size,
> +					     enum dma_data_direction dir);
>  #endif /* _LINUX_VIRTIO_H */
> -- 
> 2.32.0.3.g01195cf9f


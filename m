Return-Path: <netdev+bounces-7857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E501721D93
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85DAC1C20AF2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9D72100;
	Mon,  5 Jun 2023 05:38:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355CB631
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:38:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A24A9
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 22:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685943536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRJJH0OW2J50d9NADx5u5KL1sSbMX6qrZ3gY09U8zZ0=;
	b=MNEd6gp9qoztVJ0ZXwQOGRvrXR5IvLNbROgCB13q5RzI6nHQ1q/N0Btt5/X5KOk2L2qBEX
	4GCv4/5wcOerIazU7jgy5E4JY3j8KX8CRT8LAob6VCBmop6phXDtpIjJnw+medyN/oEHCS
	UKIEHlt42g70SCPOuFmvPJ8IFPUdoGk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-r59y7sOEPwacXvJ0F4KYiQ-1; Mon, 05 Jun 2023 01:38:54 -0400
X-MC-Unique: r59y7sOEPwacXvJ0F4KYiQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30b218c0bbbso1806216f8f.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 22:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685943533; x=1688535533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRJJH0OW2J50d9NADx5u5KL1sSbMX6qrZ3gY09U8zZ0=;
        b=E+VafOl0eASdKATgTy4Ro3cYaNjf9jkaYiQfI503b9Eb/gry/Q5sxxwN7hUVmmweil
         RE5HIe0aXTbEy7yCV5lKWO5g8eS0xnF0MPZ5/w+AchK6a1WOshxbuA7XBYZKwV7w9M9Y
         IUEm+X/17kBIIvS6DwonHrn/dmnVXxzPg8oV264V/v8j/gykYW7cmNjxO3Nx4Tbk8sJu
         2xNluJG1fyEJtXW9TGgArf7bzMQUKyavLe4ul4pRkmQI7UUjKrIm7Rkwd/Y+TmTi/E21
         KQX97bQYIn3lq5n29SC/OeSBGRTbZZbrGsYxwKEAFY/T3NX4tzovWszzuYBT8/yZY6vC
         f2dg==
X-Gm-Message-State: AC+VfDy7fxzUogWYnwelTDATak1KVnOeC16Am8wfV/6PUEXa+MQRour5
	RpgsBsWd2iBqvqf/yhr+BFSKTeMrD28R4w58phZlLBVHvWSU3u3Dx949XFY9g0nVyAEtzBMtnPV
	wsQk+o2h9yOoLcemUVn2aWCHE
X-Received: by 2002:a5d:6b86:0:b0:30a:b4e1:a89c with SMTP id n6-20020a5d6b86000000b0030ab4e1a89cmr3896118wrx.66.1685943533204;
        Sun, 04 Jun 2023 22:38:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7bhQbx+cGVISzu+LTDpd2WoPYUQfudCiV0v4tPmO0GTljBr2mjJBinEUeuco5jPdn8SzBrbQ==
X-Received: by 2002:a5d:6b86:0:b0:30a:b4e1:a89c with SMTP id n6-20020a5d6b86000000b0030ab4e1a89cmr3896101wrx.66.1685943532831;
        Sun, 04 Jun 2023 22:38:52 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id m10-20020adfe94a000000b0030c6751a49dsm8552160wrn.115.2023.06.04.22.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 22:38:52 -0700 (PDT)
Date: Mon, 5 Jun 2023 01:38:48 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH vhost v10 07/10] virtio_ring: introduce helpers for
 premapped
Message-ID: <20230605013658-mutt-send-email-mst@kernel.org>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602092206.50108-8-xuanzhuo@linux.alibaba.com>
 <20230604094122-mutt-send-email-mst@kernel.org>
 <1685930811.137484-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685930811.137484-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:06:51AM +0800, Xuan Zhuo wrote:
> On Sun, 4 Jun 2023 09:45:14 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Fri, Jun 02, 2023 at 05:22:03PM +0800, Xuan Zhuo wrote:
> > > This patch introduces three helpers for premapped mode.
> > >
> > > * virtqueue_get_buf_premapped
> > > * virtqueue_detach_unused_buf_premapped
> > >
> > > The above helpers work like the non-premapped funcs. But a cursor is
> > > passed.
> > >
> > > virtqueue_detach is used to get the dma info of the last buf by
> > >   cursor.
> >
> > This isn't very clear from the description but virtqueue_detach is
> > also introduced by this patch as opposed to being used.
> >
> >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/virtio/virtio_ring.c | 83 ++++++++++++++++++++++++++++++++++++
> > >  include/linux/virtio.h       | 10 +++++
> > >  2 files changed, 93 insertions(+)
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index cbc22daae7e1..6771b9661798 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -2555,6 +2555,66 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
> > >  	return virtqueue_get_buf_ctx(_vq, len, NULL);
> > >  }
> > >  EXPORT_SYMBOL_GPL(virtqueue_get_buf);
> > > +
> > > +/**
> > > + * virtqueue_get_buf_premapped - get the next used buffer
> > > + * @_vq: the struct virtqueue we're talking about.
> > > + * @len: the length written into the buffer
> > > + * @ctx: extra context for the token
> > > + * @cursor: detach cursor
> > > + *
> > > + * If the device wrote data into the buffer, @len will be set to the
> > > + * amount written.  This means you don't need to clear the buffer
> > > + * beforehand to ensure there's no data leakage in the case of short
> > > + * writes.
> > > + *
> > > + * Caller must ensure we don't call this with other virtqueue
> > > + * operations at the same time (except where noted).
> > > + *
> > > + * This is used for the premapped vq. The cursor is passed by the dirver, that
> > > + * is used for virtqueue_detach. That will be initialized by virtio core
> > > + * internally.
> > > + *
> > > + * Returns NULL if there are no used buffers, or the "data" token
> > > + * handed to virtqueue_add_*().
> > > + */
> > > +void *virtqueue_get_buf_premapped(struct virtqueue *_vq, unsigned int *len,
> > > +				  void **ctx,
> > > +				  struct virtqueue_detach_cursor *cursor)
> > > +{
> > > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > > +
> > > +	return vq->packed_ring ? virtqueue_get_buf_ctx_packed(_vq, len, ctx, cursor) :
> > > +				 virtqueue_get_buf_ctx_split(_vq, len, ctx, cursor);
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_get_buf_premapped);
> > > +
> > > +/**
> > > + * virtqueue_detach - get the dma info of last buf
> >
> > detach what from what then?
> > I am guessing this is not the only thing this function does?
> > sounds like a bad name for a function.
> 
> Let me think of a good name
> 
> >
> > > + * @_vq: the struct virtqueue we're talking about.
> > > + * @cursor: detach cursor
> > > + * @addr: the dma address
> >
> > what address?  it's the 1st time you mention an address ...
> 
> Will fix.
> 
> 
> >
> > > + * @len: the length of the dma address
> > > + * @dir: the direction of the dma address
> > > + *
> > > + * This is used for the premapped vq. The cursor is initialized by
> > > + * virtqueue_get_buf_premapped or virtqueue_detach_unused_buf_premapped.
> > > + *
> > > + * Returns:
> > > + * -EAGAIN: there are more dma info, this function should be called more.
> >
> > here too, pls don't return -EAGAIN not in an error case.
> > something like "1" will do.
> 
> While I agree with you, -EAGAIN seems to be a commonly used method.

Where is it used like this? A typical use is e.g. in read(2):

      EAGAIN The file descriptor fd refers to a file other than a socket and has been marked nonblocking (O_NONBLOCK), and  the  read
              would block.  See open(2) for further details on the O_NONBLOCK flag.

a better analog here is read filling up all its buffer, in which
case it returns the # of bytes returned.


> How about we
> return EAGAIN instead of -EAGAIN ?
> 
> Thanks.
> 
> 
> 
> >
> > > + * -EINVAL: the process is done, should not call this function
> > > + * 0: no more dma info
> > > + */
> > > +int virtqueue_detach(struct virtqueue *_vq, struct virtqueue_detach_cursor *cursor,
> > > +		     dma_addr_t *addr, u32 *len, enum dma_data_direction *dir)
> > > +{
> > > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > > +
> > > +	return vq->packed_ring ? virtqueue_detach_packed(_vq, cursor, addr, len, dir) :
> > > +				 virtqueue_detach_split(_vq, cursor, addr, len, dir);
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_detach);
> > > +
> > >  /**
> > >   * virtqueue_disable_cb - disable callbacks
> > >   * @_vq: the struct virtqueue we're talking about.
> > > @@ -2682,6 +2742,29 @@ void *virtqueue_detach_unused_buf(struct virtqueue *_vq)
> > >  }
> > >  EXPORT_SYMBOL_GPL(virtqueue_detach_unused_buf);
> > >
> > > +/**
> > > + * virtqueue_detach_unused_buf_premapped - detach first unused buffer
> > > + * @_vq: the struct virtqueue we're talking about.
> > > + * @cursor: detach cursor
> > > + *
> > > + * This is used for the premapped vq. The cursor is passed by the dirver, that
> > > + * is used for virtqueue_detach. That will be initialized by virtio core
> > > + * internally.
> > > + *
> > > + * Returns NULL or the "data" token handed to virtqueue_add_*().
> > > + * This is not valid on an active queue; it is useful for device
> > > + * shutdown or the reset queue.
> > > + */
> > > +void *virtqueue_detach_unused_buf_premapped(struct virtqueue *_vq,
> > > +					    struct virtqueue_detach_cursor *cursor)
> > > +{
> > > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > > +
> > > +	return vq->packed_ring ? virtqueue_detach_unused_buf_packed(_vq, cursor) :
> > > +				 virtqueue_detach_unused_buf_split(_vq, cursor);
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_detach_unused_buf_premapped);
> > > +
> > >  static inline bool more_used(const struct vring_virtqueue *vq)
> > >  {
> > >  	return vq->packed_ring ? more_used_packed(vq) : more_used_split(vq);
> > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > index 7f137c7a9034..0a11c5b32fe5 100644
> > > --- a/include/linux/virtio.h
> > > +++ b/include/linux/virtio.h
> > > @@ -3,6 +3,7 @@
> > >  #define _LINUX_VIRTIO_H
> > >  /* Everything a virtio driver needs to work with any particular virtio
> > >   * implementation. */
> > > +#include <linux/dma-mapping.h>
> > >  #include <linux/types.h>
> > >  #include <linux/scatterlist.h>
> > >  #include <linux/spinlock.h>
> > > @@ -88,6 +89,10 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
> > >  void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
> > >  			    void **ctx);
> > >
> > > +void *virtqueue_get_buf_premapped(struct virtqueue *_vq, unsigned int *len,
> > > +				  void **ctx,
> > > +				  struct virtqueue_detach_cursor *cursor);
> > > +
> > >  void virtqueue_disable_cb(struct virtqueue *vq);
> > >
> > >  bool virtqueue_enable_cb(struct virtqueue *vq);
> > > @@ -101,6 +106,8 @@ bool virtqueue_poll(struct virtqueue *vq, unsigned);
> > >  bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
> > >
> > >  void *virtqueue_detach_unused_buf(struct virtqueue *vq);
> > > +void *virtqueue_detach_unused_buf_premapped(struct virtqueue *_vq,
> > > +					    struct virtqueue_detach_cursor *cursor);
> > >
> > >  unsigned int virtqueue_get_vring_size(const struct virtqueue *vq);
> > >
> > > @@ -114,6 +121,9 @@ dma_addr_t virtqueue_get_used_addr(const struct virtqueue *vq);
> > >  int virtqueue_resize(struct virtqueue *vq, u32 num,
> > >  		     void (*recycle)(struct virtqueue *vq, void *buf));
> > >
> > > +int virtqueue_detach(struct virtqueue *_vq, struct virtqueue_detach_cursor *cursor,
> > > +		     dma_addr_t *addr, u32 *len, enum dma_data_direction *dir);
> > > +
> > >  /**
> > >   * struct virtio_device - representation of a device using virtio
> > >   * @index: unique position on the virtio bus
> > > --
> > > 2.32.0.3.g01195cf9f
> >



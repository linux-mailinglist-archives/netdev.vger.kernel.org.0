Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77351B27C2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgDUNZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:25:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728909AbgDUNZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587475526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfN8aMzomRQQ96ayp+DSeaZXFE3YOenFrf2e10oUVkg=;
        b=Gc4VJoNnPP/JqwZHHYSOAH13Oda78QSesr4okHtOA+e+2ucqhVNbKA2ecXu7wa30kd1tDN
        IcHTHTQvFi7HQ12jeutfrPsj+tfXyzU2/Bs/3r9sI/X3ERdbze+/bFr1sN1A4emThbySxt
        4cUqoGXOQC+aWLok3l6EeVvseLrtE9M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-bgKt7lSRPD-guWdloTpXug-1; Tue, 21 Apr 2020 09:25:20 -0400
X-MC-Unique: bgKt7lSRPD-guWdloTpXug-1
Received: by mail-wr1-f71.google.com with SMTP id j22so7526502wrb.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MfN8aMzomRQQ96ayp+DSeaZXFE3YOenFrf2e10oUVkg=;
        b=oJJtBVlOhIXuyX5wiDeIZjhfDNVMovi7A+1wuuqi19Qx47j/pSyWsKXZxvGxT/tk6k
         74KXge/uUe8C6vE0MMSk0WpvCuwUb2w/diPTlsbil3LUGgV1atxM850PXrxhDnK+Z+gC
         R3iP70Oz6PN+0laZCMqEFYH/7DMCVegrw2Eipeuwdh7xSrlrzupxXrXHPNBs9oBzdztu
         d8Gpeft7EC0W7czs776VI05iEfeNiSl5obPS3lNOEy0nvT68FVK0cpJRSR4OEUORe4uL
         tl3zF2Wd43VUcUiFKGohwx9BguFU8aj2TNMmkvyhmzq9vkgnr831Zemu/eBuFv0cKam6
         Mq3w==
X-Gm-Message-State: AGi0PuYeNEp44M/pb7UusY2QrU15yJVJYrH8wjyJWtjC7w/2TsRKnTGO
        1GYuIJZnilUHsEiJuAwLw2FEfmBSpoxuPAbYy6FrerB1p6cyIwAjZPpgyZbFzaSzkTFP8NASJge
        wJImB/phOsYpTQNLr
X-Received: by 2002:a1c:9cc6:: with SMTP id f189mr4761654wme.75.1587475518694;
        Tue, 21 Apr 2020 06:25:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypISelS/YDn7C9T0crq8LJwZEGYjKFkHeDDSrMLyRZ+XVsh/Mvt4HCagYv9aKS72C1scyjQs7g==
X-Received: by 2002:a1c:9cc6:: with SMTP id f189mr4761633wme.75.1587475518362;
        Tue, 21 Apr 2020 06:25:18 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id 5sm3306952wmg.34.2020.04.21.06.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:25:17 -0700 (PDT)
Date:   Tue, 21 Apr 2020 09:25:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] virtio: force spec specified alignment on types
Message-ID: <20200421092418-mutt-send-email-mst@kernel.org>
References: <20200420204448.377168-1-mst@redhat.com>
 <a4939aeb-ed9d-a6af-1c70-c6c2513e86e2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4939aeb-ed9d-a6af-1c70-c6c2513e86e2@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 10:39:19AM +0800, Jason Wang wrote:
> 
> On 2020/4/21 上午4:46, Michael S. Tsirkin wrote:
> > The ring element addresses are passed between components with different
> > alignments assumptions. Thus, if guest/userspace selects a pointer and
> > host then gets and dereferences it, we might need to decrease the
> > compiler-selected alignment to prevent compiler on the host from
> > assuming pointer is aligned.
> > 
> > This actually triggers on ARM with -mabi=apcs-gnu - which is a
> > deprecated configuration, but it seems safer to handle this
> > generally.
> > 
> > Note that userspace that allocates the memory is actually OK and does
> > not need to be fixed, but userspace that gets it from guest or another
> > process does need to be fixed. The later doesn't generally talk to the
> > kernel so while it might be buggy it's not talking to the kernel in the
> > buggy way - it's just using the header in the buggy way - so fixing
> > header and asking userspace to recompile is the best we can do.
> > 
> > I verified that the produced kernel binary on x86 is exactly identical
> > before and after the change.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > changes from v2:
> > 	add vring_used_elem_t to ensure alignment for substructures
> > changes from v1:
> > 	swicth all __user to the new typedefs
> > 
> >   drivers/vhost/vhost.c            |  8 +++---
> >   drivers/vhost/vhost.h            |  6 ++---
> >   drivers/vhost/vringh.c           |  6 ++---
> >   include/linux/vringh.h           |  6 ++---
> >   include/uapi/linux/virtio_ring.h | 43 ++++++++++++++++++++++++--------
> >   5 files changed, 45 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index d450e16c5c25..bc77b0f465fd 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1244,9 +1244,9 @@ static int vhost_iotlb_miss(struct vhost_virtqueue *vq, u64 iova, int access)
> >   }
> >   static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
> > -			 struct vring_desc __user *desc,
> > -			 struct vring_avail __user *avail,
> > -			 struct vring_used __user *used)
> > +			 vring_desc_t __user *desc,
> > +			 vring_avail_t __user *avail,
> > +			 vring_used_t __user *used)
> >   {
> >   	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
> > @@ -2301,7 +2301,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
> >   			    struct vring_used_elem *heads,
> >   			    unsigned count)
> >   {
> > -	struct vring_used_elem __user *used;
> > +	vring_used_elem_t __user *used;
> >   	u16 old, new;
> >   	int start;
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index f8403bd46b85..60cab4c78229 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -67,9 +67,9 @@ struct vhost_virtqueue {
> >   	/* The actual ring of buffers. */
> >   	struct mutex mutex;
> >   	unsigned int num;
> > -	struct vring_desc __user *desc;
> > -	struct vring_avail __user *avail;
> > -	struct vring_used __user *used;
> > +	vring_desc_t __user *desc;
> > +	vring_avail_t __user *avail;
> > +	vring_used_t __user *used;
> >   	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
> >   	struct file *kick;
> >   	struct eventfd_ctx *call_ctx;
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index ba8e0d6cfd97..e059a9a47cdf 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -620,9 +620,9 @@ static inline int xfer_to_user(const struct vringh *vrh,
> >    */
> >   int vringh_init_user(struct vringh *vrh, u64 features,
> >   		     unsigned int num, bool weak_barriers,
> > -		     struct vring_desc __user *desc,
> > -		     struct vring_avail __user *avail,
> > -		     struct vring_used __user *used)
> > +		     vring_desc_t __user *desc,
> > +		     vring_avail_t __user *avail,
> > +		     vring_used_t __user *used)
> >   {
> >   	/* Sane power of 2 please! */
> >   	if (!num || num > 0xffff || (num & (num - 1))) {
> > diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> > index 9e2763d7c159..59bd50f99291 100644
> > --- a/include/linux/vringh.h
> > +++ b/include/linux/vringh.h
> > @@ -105,9 +105,9 @@ struct vringh_kiov {
> >   /* Helpers for userspace vrings. */
> >   int vringh_init_user(struct vringh *vrh, u64 features,
> >   		     unsigned int num, bool weak_barriers,
> > -		     struct vring_desc __user *desc,
> > -		     struct vring_avail __user *avail,
> > -		     struct vring_used __user *used);
> > +		     vring_desc_t __user *desc,
> > +		     vring_avail_t __user *avail,
> > +		     vring_used_t __user *used);
> >   static inline void vringh_iov_init(struct vringh_iov *iov,
> >   				   struct iovec *iovec, unsigned num)
> > diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
> > index 9223c3a5c46a..b2c20f794472 100644
> > --- a/include/uapi/linux/virtio_ring.h
> > +++ b/include/uapi/linux/virtio_ring.h
> > @@ -86,6 +86,13 @@
> >    * at the end of the used ring. Guest should ignore the used->flags field. */
> >   #define VIRTIO_RING_F_EVENT_IDX		29
> > +/* Alignment requirements for vring elements.
> > + * When using pre-virtio 1.0 layout, these fall out naturally.
> > + */
> > +#define VRING_AVAIL_ALIGN_SIZE 2
> > +#define VRING_USED_ALIGN_SIZE 4
> > +#define VRING_DESC_ALIGN_SIZE 16
> > +
> >   /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
> >   struct vring_desc {
> >   	/* Address (guest-physical). */
> > @@ -112,29 +119,43 @@ struct vring_used_elem {
> >   	__virtio32 len;
> >   };
> > +typedef struct vring_used_elem __aligned(VRING_USED_ALIGN_SIZE)
> > +	vring_used_elem_t;
> > +
> >   struct vring_used {
> >   	__virtio16 flags;
> >   	__virtio16 idx;
> > -	struct vring_used_elem ring[];
> > +	vring_used_elem_t ring[];
> >   };
> > +/*
> > + * The ring element addresses are passed between components with different
> > + * alignments assumptions. Thus, we might need to decrease the compiler-selected
> > + * alignment, and so must use a typedef to make sure the __aligned attribute
> > + * actually takes hold:
> > + *
> > + * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#Common-Type-Attributes
> > + *
> > + * When used on a struct, or struct member, the aligned attribute can only
> > + * increase the alignment; in order to decrease it, the packed attribute must
> > + * be specified as well. When used as part of a typedef, the aligned attribute
> > + * can both increase and decrease alignment, and specifying the packed
> > + * attribute generates a warning.
> > + */
> > +typedef struct vring_desc __aligned(VRING_DESC_ALIGN_SIZE) vring_desc_t;
> > +typedef struct vring_avail __aligned(VRING_AVAIL_ALIGN_SIZE) vring_avail_t;
> > +typedef struct vring_used __aligned(VRING_USED_ALIGN_SIZE) vring_used_t;
> 
> 
> I wonder whether we can simply use __attribute__(packed) instead?
> 
> Thanks

Packed is 1 byte alignment. As such generates very bad code for
accesses.


> 
> > +
> >   struct vring {
> >   	unsigned int num;
> > -	struct vring_desc *desc;
> > +	vring_desc_t *desc;
> > -	struct vring_avail *avail;
> > +	vring_avail_t *avail;
> > -	struct vring_used *used;
> > +	vring_used_t *used;
> >   };
> > -/* Alignment requirements for vring elements.
> > - * When using pre-virtio 1.0 layout, these fall out naturally.
> > - */
> > -#define VRING_AVAIL_ALIGN_SIZE 2
> > -#define VRING_USED_ALIGN_SIZE 4
> > -#define VRING_DESC_ALIGN_SIZE 16
> > -
> >   #ifndef VIRTIO_RING_NO_LEGACY
> >   /* The standard layout for the ring is a continuous chunk of memory which looks


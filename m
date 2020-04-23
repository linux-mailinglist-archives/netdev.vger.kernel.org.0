Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9741B5BA2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgDWMma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:42:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726503AbgDWMm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587645747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KE1bO4FRGOiJn/v1XLgXXIgCOUfvGBsgfFGQzPEWsaM=;
        b=J+AoL9p1aERkfQkH1FmBoNLQnoiTc01LaXEU+0tR7j2RUjpLuJ7rd+pUixbSFYvNmT7bMg
        uCOrMbdOR79sbqASU0JllHW5Wq5yFfvETHdgU9KmpVrXfnOCAjAuGMli1KLicfuGM5P2wA
        zPQzhcs+2q/1RLV0bSepeA6AEHGuhLs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-K7ruBynkOuqzoe7F9ciZ1g-1; Thu, 23 Apr 2020 08:42:22 -0400
X-MC-Unique: K7ruBynkOuqzoe7F9ciZ1g-1
Received: by mail-wr1-f69.google.com with SMTP id r11so2773427wrx.21
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 05:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KE1bO4FRGOiJn/v1XLgXXIgCOUfvGBsgfFGQzPEWsaM=;
        b=fpJvjZjo6I0qNsmwRW4tmizB1A4YwtWpRf5CVQO3cJzEKoyMoTepBm3cKVKgYptU4G
         zyo+qSz7wTAvAYYDsqJDghJ3mCgyadF9Ol8ebx8JtRYoddvN4zv06iOSw/8I0l779Bbd
         ZOPr931XCKiz8m1hCz2HoFfFVfMn9Jd7oZrOLbQGLjo5NTtT+VSLCagc30dKH7QfkvdU
         ZzK9q7m7zVJkdRHRib/FxAJnk/vPR6SNeopTUYUBUmi79kT6J0vD/f8ZXM7umliwKfCO
         MQfSpp45xOLxM09PZJzUgWGo+hfc2iXJx58fwNxNQtvVZ1//BjkykNJSsyAVbnMhn5Do
         M0+A==
X-Gm-Message-State: AGi0PubiagpkL6MZFKeUKKkbN21gwffxf3noE+a+jmL9ooVhsFW9aWZJ
        H1RZUgWm+61EeV7ZfmT3xSOgxhC8ftFPwNHpNuRFviQM79ONtgKuOTOS7ReNtj0GLXvUFY4dyAj
        dUni0E2KAyyZAmSbT
X-Received: by 2002:adf:aa8e:: with SMTP id h14mr5091731wrc.371.1587645741522;
        Thu, 23 Apr 2020 05:42:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypJb7vzVeUKkh1IeOvz0BrG6IVQHluWMcYq57o78EV05aVAwHYQwaCl8caVPingWSs3PT7cBSg==
X-Received: by 2002:adf:aa8e:: with SMTP id h14mr5091702wrc.371.1587645741154;
        Thu, 23 Apr 2020 05:42:21 -0700 (PDT)
Received: from redhat.com (bzq-109-65-97-189.red.bezeqint.net. [109.65.97.189])
        by smtp.gmail.com with ESMTPSA id 1sm3793790wmi.0.2020.04.23.05.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 05:42:20 -0700 (PDT)
Date:   Thu, 23 Apr 2020 08:42:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4] virtio: force spec specified alignment on types
Message-ID: <20200423083934-mutt-send-email-mst@kernel.org>
References: <20200422145510.442277-1-mst@redhat.com>
 <7ea553de-7a27-0aa0-4afb-d167147fd155@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ea553de-7a27-0aa0-4afb-d167147fd155@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 08:10:39PM +0800, Jason Wang wrote:
> 
> On 2020/4/22 下午10:58, Michael S. Tsirkin wrote:
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
> > changes since v3:
> > 	use __attribute__((aligned(X))) instead of __aligned,
> > 	to avoid dependency on that macro
> > 
> >   drivers/vhost/vhost.c            |  8 +++---
> >   drivers/vhost/vhost.h            |  6 ++---
> >   drivers/vhost/vringh.c           |  6 ++---
> >   include/linux/vringh.h           |  6 ++---
> >   include/uapi/linux/virtio_ring.h | 46 ++++++++++++++++++++++++--------
> >   5 files changed, 48 insertions(+), 24 deletions(-)
> 
> 
> Acked-by: Jason Wang <jasowang@redhat.com>
> 
> (I think we can then remove the BUILD_BUG_ON() in vhost?)
> 
> Thanks

We can in theory but then it's harmless and might catch some bugs in the
future. After all when I introduced BUILD_BUG_ON I also assumed it's not
really necessary, I put it there just in case.

> 
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
> > index 9223c3a5c46a..476d3e5c0fe7 100644
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
> > @@ -112,29 +119,46 @@ struct vring_used_elem {
> >   	__virtio32 len;
> >   };
> > +typedef struct vring_used_elem __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
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
> > + * alignment, and so must use a typedef to make sure the aligned attribute
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
> > +typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE)))
> > +	vring_desc_t;
> > +typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SIZE)))
> > +	vring_avail_t;
> > +typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
> > +	vring_used_t;
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


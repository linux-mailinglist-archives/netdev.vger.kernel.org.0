Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C170119F754
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgDFNzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:55:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728271AbgDFNzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586181336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JbffD6uHYn0Xws8gEnJhH/ASm7vL5TTpW7bpIjfQF0=;
        b=faJBbjK4TwD/vDhEELCtG2LzXSULtxwNLWC0YCG5gXbS3Yk5O9ABCjjnB5kUiD9w36Y8TW
        vS4lA8YFZ2iV2ks8dznIxOaJSMf3S3oRFAEss3fG3RzRatnkxzgTqFTBXA+Ja324/5IhnP
        Ek/qkN8bK8kBE/2naV30sVxnRUXXGlo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-mj0D1U0XOCGz_hcey3zkzg-1; Mon, 06 Apr 2020 09:55:30 -0400
X-MC-Unique: mj0D1U0XOCGz_hcey3zkzg-1
Received: by mail-wr1-f72.google.com with SMTP id e10so8402880wru.6
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 06:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4JbffD6uHYn0Xws8gEnJhH/ASm7vL5TTpW7bpIjfQF0=;
        b=I3slBb5oD4ApnbPM8LKAbMUt2xXBvvYWONVfQTLdpMQb3iOtNutyQpwsVanMncsF8A
         /HXeWpCLO74fQvYceQDTA03s/4+QA15Phx6yIOcZMHp2e9BS1SZcltZeetxjMHotrPz9
         5M5DMjLcLbe2y2HBaEWFMw59Y42zoC6AnKgTu7sjT2U+2kqjJtbnmlCrx6RBy+5Fp7Fp
         2E2xEuplS6KsRQ8tc8hTC4wHEHjDoQf6kcUfl9QRJISUpUlgMvIHmojhj0LT5vQFfnex
         C1caxcAXp8t3Ih5pefT3xvqPy7gsuTFnNIIj7nHA4xhhZgbg/JiUb0qjzcrrEJU1ORvE
         uF/Q==
X-Gm-Message-State: AGi0PuZRi30mp4pni9V2twQzo/aklWzv8l0TmaPCv3zqmLejmeAXM9We
        e23AEDwyfJ085N1roMCmKmBRt0ZV3g9r/ITKKVsJL8aCMpFw3zylenymEG6ALdkgsZqeehewuB9
        o3IHYpOnq0Bfj2+Fl
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr602256wrt.292.1586181328771;
        Mon, 06 Apr 2020 06:55:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypJMOX8DPPm6vlwNHfWsSuz0mrVkzWpGk7TU+nZhYELINvwWAIdcv57+eCeK2DYp6J7Z3YNU5w==
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr602237wrt.292.1586181328553;
        Mon, 06 Apr 2020 06:55:28 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id w204sm25954947wma.1.2020.04.06.06.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 06:55:28 -0700 (PDT)
Date:   Mon, 6 Apr 2020 09:55:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost: force spec specified alignment on types
Message-ID: <20200406095424-mutt-send-email-mst@kernel.org>
References: <20200406124931.120768-1-mst@redhat.com>
 <045c84ed-151e-a850-9c72-5079bd2775e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <045c84ed-151e-a850-9c72-5079bd2775e6@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 09:34:00PM +0800, Jason Wang wrote:
> 
> On 2020/4/6 下午8:50, Michael S. Tsirkin wrote:
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
> > I verified that the produced binary is exactly identical on x86.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > This is my preferred way to handle the ARM incompatibility issues
> > (in preference to kconfig hacks).
> > I will push this into next now.
> > Comments?
> 
> 
> I'm not sure if it's too late to fix. It would still be still problematic
> for the userspace that is using old uapi headers?
> 
> Thanks

It's not a problem in userspace. The problem is when
userspace/guest uses 2 byte alignment and passes it to kernel
assuming 8 byte alignment. The fix is for host not to
make these assumptions.

> 
> > 
> >   drivers/vhost/vhost.h            |  6 ++---
> >   include/uapi/linux/virtio_ring.h | 41 ++++++++++++++++++++++++--------
> >   2 files changed, 34 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index cc82918158d2..a67bda9792ec 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -74,9 +74,9 @@ struct vhost_virtqueue {
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
> >   	struct vhost_desc *descs;
> > diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
> > index 559f42e73315..cd6e0b2eaf2f 100644
> > --- a/include/uapi/linux/virtio_ring.h
> > +++ b/include/uapi/linux/virtio_ring.h
> > @@ -118,16 +118,6 @@ struct vring_used {
> >   	struct vring_used_elem ring[];
> >   };
> > -struct vring {
> > -	unsigned int num;
> > -
> > -	struct vring_desc *desc;
> > -
> > -	struct vring_avail *avail;
> > -
> > -	struct vring_used *used;
> > -};
> > -
> >   /* Alignment requirements for vring elements.
> >    * When using pre-virtio 1.0 layout, these fall out naturally.
> >    */
> > @@ -164,6 +154,37 @@ struct vring {
> >   #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
> >   #define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
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
> > +typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE)))
> > +	vring_desc_t;
> > +typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SIZE)))
> > +	vring_avail_t;
> > +typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
> > +	vring_used_t;
> > +
> > +struct vring {
> > +	unsigned int num;
> > +
> > +	vring_desc_t *desc;
> > +
> > +	vring_avail_t *avail;
> > +
> > +	vring_used_t *used;
> > +};
> > +
> >   static inline void vring_init(struct vring *vr, unsigned int num, void *p,
> >   			      unsigned long align)
> >   {


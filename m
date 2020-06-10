Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E021F574B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 17:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgFJPIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 11:08:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57773 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728095AbgFJPIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 11:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591801690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZvS3pY4wDKLBE9EMwiJvGN8pCoUxnpSAds/EiWZ00f4=;
        b=I0685ZcZf4Fvrvkqw92ZrVz05k9UvhO3LuNQg0Crb4FwgwbArZIF3ydxoCx7xwvp/D6Vx1
        OUvidjSL2xnOF8962wbYjwSiBJDSm/08UOSFSdlRozPBqIkVL5c615NSNUwUlAiVTinJvn
        pHs3RdDEVcTBI7ZsSIQSRTX90nY6hHw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-Pm6lYidUOjudvwFXIO2ogw-1; Wed, 10 Jun 2020 11:08:07 -0400
X-MC-Unique: Pm6lYidUOjudvwFXIO2ogw-1
Received: by mail-wm1-f69.google.com with SMTP id a7so477108wmf.1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 08:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZvS3pY4wDKLBE9EMwiJvGN8pCoUxnpSAds/EiWZ00f4=;
        b=jeoR4eeI3ihVChGAJOvul+gRVXzwSN2vx+upjK/3YAh9HXfttE2RDiWcnNwm+kRSnb
         SAjtD5gsrrpmOg99u3aGgdVdtXyooR9OsMN5LvgUBpmCl65mx8wxwJMMnK1I/P122oEn
         uFWzRBGzE5NqGGLSuBbFQZ1YmyLqci70oJH+lSHe1o2EenueyqkZGA8tiY/Fmt5rX3g2
         9Lr+lJaVUbVrAWmmm3LfmO3ZNAucVblZSxP/tgAW8+K+E3iK2TC96SkstEC97wFNO8wx
         UbaG3FoCxWiUtN1OufdYxXGfkl9RHNhi8R1AgYcrWLqZBu2J6Jd8eL9XQiIJEbDSPjhw
         3mtQ==
X-Gm-Message-State: AOAM531haQXPanP/3Mr2zL3vET3fAXC/m8u2E8Ltt+wJvXpAxeMyZd8Y
        u1wg1Sdd1AGfcVuLNE0s7DM6beDhbcgn0koCOL8tIfjzO5QzjLq6FSFxZGZSXdfsnd3lUxqSvDb
        b3wzdhSKvXyWt32fM
X-Received: by 2002:a05:6000:1104:: with SMTP id z4mr4211608wrw.272.1591801686260;
        Wed, 10 Jun 2020 08:08:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSwDALN5Pur0obQjyi2Uc0HobQX48dqJRmEevxPLOFxJwcAkmH8xWT1y5vRmc5DFWcLholqg==
X-Received: by 2002:a05:6000:1104:: with SMTP id z4mr4211584wrw.272.1591801685999;
        Wed, 10 Jun 2020 08:08:05 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id j4sm42126wma.7.2020.06.10.08.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 08:08:05 -0700 (PDT)
Date:   Wed, 10 Jun 2020 11:08:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
Message-ID: <20200610105829-mutt-send-email-mst@kernel.org>
References: <20200610113515.1497099-1-mst@redhat.com>
 <20200610113515.1497099-4-mst@redhat.com>
 <035e82bcf4ade0017641c5b457d0c628c5915732.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <035e82bcf4ade0017641c5b457d0c628c5915732.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 04:29:29PM +0200, Eugenio Pérez wrote:
> On Wed, 2020-06-10 at 07:36 -0400, Michael S. Tsirkin wrote:
> > As testing shows no performance change, switch to that now.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat.com
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/test.c  |   2 +-
> >  drivers/vhost/vhost.c | 318 ++++++++----------------------------------
> >  drivers/vhost/vhost.h |   7 +-
> >  3 files changed, 65 insertions(+), 262 deletions(-)
> > 
> > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index 0466921f4772..7d69778aaa26 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
> >  	dev = &n->dev;
> >  	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
> >  	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
> > -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> > +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
> >  		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
> >  
> >  	f->private_data = n;
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 11433d709651..28f324fd77df 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> >  {
> >  	vq->num = 1;
> >  	vq->ndescs = 0;
> > +	vq->first_desc = 0;
> >  	vq->desc = NULL;
> >  	vq->avail = NULL;
> >  	vq->used = NULL;
> > @@ -372,6 +373,11 @@ static int vhost_worker(void *data)
> >  	return 0;
> >  }
> >  
> > +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> > +{
> > +	return vq->max_descs - UIO_MAXIOV;
> > +}
> > +
> >  static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >  {
> >  	kfree(vq->descs);
> > @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
> >  	for (i = 0; i < dev->nvqs; ++i) {
> >  		vq = dev->vqs[i];
> >  		vq->max_descs = dev->iov_limit;
> > +		if (vhost_vq_num_batch_descs(vq) < 0) {
> > +			return -EINVAL;
> > +		}
> >  		vq->descs = kmalloc_array(vq->max_descs,
> >  					  sizeof(*vq->descs),
> >  					  GFP_KERNEL);
> > @@ -1610,6 +1619,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
> >  		vq->last_avail_idx = s.num;
> >  		/* Forget the cached index value. */
> >  		vq->avail_idx = vq->last_avail_idx;
> > +		vq->ndescs = vq->first_desc = 0;
> 
> This is not needed if it is done in vhost_vq_set_backend, as far as I can tell.
> 
> Actually, maybe it is even better to move `vq->avail_idx = vq->last_avail_idx;` line to vhost_vq_set_backend, it is part
> of the backend "set up" procedure, isn't it?
> 
> I tested with virtio_test + batch tests sent in 
> https://lkml.kernel.org/lkml/20200418102217.32327-1-eperezma@redhat.com/T/.

Ow did I forget to merge them for rc1?  Should I have? Maybe Linus won't
yell to hard at me if I merge them after rc1.


> I append here what I'm proposing in case it is clearer this way.
> 
> Thanks!
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 4d198994e7be..809ad2cd2879 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1617,9 +1617,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  			break;
>  		}
>  		vq->last_avail_idx = s.num;
> -		/* Forget the cached index value. */
> -		vq->avail_idx = vq->last_avail_idx;
> -		vq->ndescs = vq->first_desc = 0;
>  		break;
>  	case VHOST_GET_VRING_BASE:
>  		s.index = idx;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index fed36af5c444..f4902dc808e4 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -258,6 +258,7 @@ static inline void vhost_vq_set_backend(struct vhost_virtqueue *vq,
>  					void *private_data)
>  {
>  	vq->private_data = private_data;
> +	vq->avail_idx = vq->last_avail_idx;
>  	vq->ndescs = 0;
>  	vq->first_desc = 0;
>  }
> 

Seems like a nice cleanup, though it's harmless right?


-- 
MST


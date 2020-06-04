Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD351EE076
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 11:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgFDJDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 05:03:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58790 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728261AbgFDJDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 05:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591261409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kIAb7NyvRkDdFjS5z3YNHayJvBeusj5SE6fr0SttD8A=;
        b=fPcz5jBQ+JKfNWFuAWktKK19jLgDtZpkts0Qtc0pLpVjxVZGpuFPxHIAEfRQ05HIApTObE
        FtOtq1fuR7+J2d3gFOnn19qU5ZR+7IER5GSul90U2c9el25EFeF+Ss51qviKyBkOX98zZj
        Cc9r9qlcX2dHiCEErv/20gzs+t58GQE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-hL5X-L48OHKL8UxEtQimDA-1; Thu, 04 Jun 2020 05:03:27 -0400
X-MC-Unique: hL5X-L48OHKL8UxEtQimDA-1
Received: by mail-wm1-f70.google.com with SMTP id f62so1576772wme.3
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 02:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kIAb7NyvRkDdFjS5z3YNHayJvBeusj5SE6fr0SttD8A=;
        b=uOwWeICUqR69bUbK0jGWkeEOsLH+qwuCEmfzTy+AiGwKNOeK0D3ZhRdgxDJ1MaTFfH
         /97dPl3Jw33e3xiDsfvkJ62YNSPG4y9zkkTgs1sITy4S1X3nAMgI1JBe2PpJwSD2mlFT
         8qeer0a/xdyC6Zmpzqh/cpkNgJye/1sAJPIAkpxEJWEj9r9pD5TY6Upan43L9PHjvVO2
         Z21o3olmYvGdwt6MZeBMPEjEGSAjNZiuPxZ8xuS9Vvy+3QzyxIDecn6xBl+lbKt5sIT8
         dxgP4rmU5YI1GrVCo7G8em2pzd5qRO0PYnUIXOoH/gKjonwphzOFZQ7KHscFi6IjG4nS
         wSEQ==
X-Gm-Message-State: AOAM530N/04b7MogavypO8P5fUsspJ4O1goG+2Ox36UydYuynhNyY4rO
        XotZEC5vT4jWi8jUJmbXBP5DzK5YMeRJewNech2H/RIVZlBq6PgYzJrdx7MQ40qgS/RlZCNKIAc
        zFYDT5R/VnMEY2ofJ
X-Received: by 2002:a7b:c84b:: with SMTP id c11mr2984628wml.78.1591261406175;
        Thu, 04 Jun 2020 02:03:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK8wfsCxu3E9p7ycUHfNx0D5YgutQJ5LV0RZsf7ra/tC4JM/gzDFfv1l4UJCevPLTlT9guOg==
X-Received: by 2002:a7b:c84b:: with SMTP id c11mr2984604wml.78.1591261405902;
        Thu, 04 Jun 2020 02:03:25 -0700 (PDT)
Received: from redhat.com ([2a00:a040:185:f65:9a3b:8fff:fed3:ad8d])
        by smtp.gmail.com with ESMTPSA id u12sm7129873wrq.90.2020.06.04.02.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 02:03:25 -0700 (PDT)
Date:   Thu, 4 Jun 2020 05:03:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 07/13] vhost: format-independent API for used buffers
Message-ID: <20200604050135-mutt-send-email-mst@kernel.org>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-8-mst@redhat.com>
 <6d98f2cc-2084-cde0-c938-4ca01692adf9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d98f2cc-2084-cde0-c938-4ca01692adf9@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 03:58:26PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
> > Add a new API that doesn't assume used ring, heads, etc.
> > For now, we keep the old APIs around to make it easier
> > to convert drivers.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/vhost/vhost.c | 52 ++++++++++++++++++++++++++++++++++---------
> >   drivers/vhost/vhost.h | 17 +++++++++++++-
> >   2 files changed, 58 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index b4a6e44d56a8..be822f0c9428 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2292,13 +2292,12 @@ static int fetch_descs(struct vhost_virtqueue *vq)
> >    * number of output then some number of input descriptors, it's actually two
> >    * iovecs, but we pack them into one and note how many of each there were.
> >    *
> > - * This function returns the descriptor number found, or vq->num (which is
> > - * never a valid descriptor number) if none was found.  A negative code is
> > - * returned on error. */
> > -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > -		      struct iovec iov[], unsigned int iov_size,
> > -		      unsigned int *out_num, unsigned int *in_num,
> > -		      struct vhost_log *log, unsigned int *log_num)
> > + * This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > + * A negative code is returned on error. */
> > +int vhost_get_avail_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf,
> > +			struct iovec iov[], unsigned int iov_size,
> > +			unsigned int *out_num, unsigned int *in_num,
> > +			struct vhost_log *log, unsigned int *log_num)
> >   {
> >   	int ret = fetch_descs(vq);
> >   	int i;
> > @@ -2311,6 +2310,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >   	*out_num = *in_num = 0;
> >   	if (unlikely(log))
> >   		*log_num = 0;
> > +	buf->in_len = buf->out_len = 0;
> > +	buf->descs = 0;
> >   	for (i = vq->first_desc; i < vq->ndescs; ++i) {
> >   		unsigned iov_count = *in_num + *out_num;
> > @@ -2340,6 +2341,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >   			/* If this is an input descriptor,
> >   			 * increment that count. */
> >   			*in_num += ret;
> > +			buf->in_len += desc->len;
> >   			if (unlikely(log && ret)) {
> >   				log[*log_num].addr = desc->addr;
> >   				log[*log_num].len = desc->len;
> > @@ -2355,9 +2357,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >   				goto err;
> >   			}
> >   			*out_num += ret;
> > +			buf->out_len += desc->len;
> >   		}
> > -		ret = desc->id;
> > +		buf->id = desc->id;
> > +		++buf->descs;
> >   		if (!(desc->flags & VRING_DESC_F_NEXT))
> >   			break;
> > @@ -2365,7 +2369,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >   	vq->first_desc = i + 1;
> > -	return ret;
> > +	return 1;
> >   err:
> >   	for (i = vq->first_desc; i < vq->ndescs; ++i)
> > @@ -2375,7 +2379,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >   	return ret;
> >   }
> > -EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
> > +EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
> > +
> > +/* Reverse the effect of vhost_get_avail_buf. Useful for error handling. */
> > +void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
> > +			      struct vhost_buf *buf, unsigned count)
> > +{
> > +	vhost_discard_vq_desc(vq, count);
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
> >   static int __vhost_add_used_n(struct vhost_virtqueue *vq,
> >   			    struct vring_used_elem *heads,
> > @@ -2459,6 +2471,26 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
> >   }
> >   EXPORT_SYMBOL_GPL(vhost_add_used);
> > +int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
> > +{
> > +	return vhost_add_used(vq, buf->id, buf->in_len);
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_put_used_buf);
> > +
> > +int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
> > +			  struct vhost_buf *bufs, unsigned count)
> > +{
> > +	unsigned i;
> > +
> > +	for (i = 0; i < count; ++i) {
> > +		vq->heads[i].id = cpu_to_vhost32(vq, bufs[i].id);
> > +		vq->heads[i].len = cpu_to_vhost32(vq, bufs[i].in_len);
> > +	}
> > +
> > +	return vhost_add_used_n(vq, vq->heads, count);
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_put_used_n_bufs);
> > +
> >   static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
> >   {
> >   	__u16 old, new;
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index a67bda9792ec..6c10e99ff334 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -67,6 +67,13 @@ struct vhost_desc {
> >   	u16 id;
> >   };
> > +struct vhost_buf {
> > +	u32 out_len;
> > +	u32 in_len;
> > +	u16 descs;
> > +	u16 id;
> > +};
> 
> 
> So it looks to me the struct vhost_buf can work for both split ring and
> packed ring.
> 
> If this is true, we'd better make struct vhost_desc work for both.
> 
> Thanks

Both vhost_desc and vhost_buf can work for split and packed.

Do you mean we should add packed ring support based on this?
For sure, this is one of the motivators for the patchset.


> 
> > +
> >   /* The virtqueue structure describes a queue attached to a device. */
> >   struct vhost_virtqueue {
> >   	struct vhost_dev *dev;
> > @@ -193,7 +200,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
> >   		      unsigned int *out_num, unsigned int *in_num,
> >   		      struct vhost_log *log, unsigned int *log_num);
> >   void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
> > -
> > +int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
> > +			struct iovec iov[], unsigned int iov_count,
> > +			unsigned int *out_num, unsigned int *in_num,
> > +			struct vhost_log *log, unsigned int *log_num);
> > +void vhost_discard_avail_bufs(struct vhost_virtqueue *,
> > +			      struct vhost_buf *, unsigned count);
> >   int vhost_vq_init_access(struct vhost_virtqueue *);
> >   int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
> >   int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
> > @@ -202,6 +214,9 @@ void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
> >   			       unsigned int id, int len);
> >   void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
> >   			       struct vring_used_elem *heads, unsigned count);
> > +int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
> > +int vhost_put_used_n_bufs(struct vhost_virtqueue *,
> > +			  struct vhost_buf *bufs, unsigned count);
> >   void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
> >   void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
> >   bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);


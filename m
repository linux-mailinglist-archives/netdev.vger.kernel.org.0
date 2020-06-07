Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCD1F0B91
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 15:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgFGN7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 09:59:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28540 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726620AbgFGN7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 09:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591538346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49hQQxJz0ezLYVnWHq736mWDL47lS1M2M2KOpADI1+8=;
        b=dJbhVc1GxdZMlMC7tApDNYl/RyiDKkuNYD09UZNNwegdiTK9+BRllJrhFf4Apr94lkKbVk
        C6qASbBZVu4s3xlaZCPmKmtp1rU05ydyURaUPqTMQDZjmOU7kvuMkMwz2cbkUjSfETcQIJ
        gOMBxwBIkoy05pcrpFaSH3sQprEriJM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-zIpBpVlxO6iv_Lum_oAH0w-1; Sun, 07 Jun 2020 09:59:04 -0400
X-MC-Unique: zIpBpVlxO6iv_Lum_oAH0w-1
Received: by mail-wm1-f71.google.com with SMTP id x6so4271514wmj.9
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 06:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=49hQQxJz0ezLYVnWHq736mWDL47lS1M2M2KOpADI1+8=;
        b=NY1U1O49+MuOMan0N7yjjUClZqoNYLDsFzKDeEayumYoHeGwYIjoE9pFaYKbSRwUtE
         Cq/nzJyVtvDrCNBbqolpVixZ98m24BDuX96G8VMyEcDcHvEISpeBWy2JD+IHHQVd2dZq
         TKYJGfFhEMJ3PLrgz1vBoVouBIZgo2zpnFewirzn4iJ15iU0O7GKyQ4GOu4LryefsKDJ
         sV47jM6qm+IXVoWOPCSKK5YnarioWJWr44eXM/iBjXnL74YbVlvJnt+vvF0gcvhlHZ6G
         IG/PgkA0TrJFcIHx/TlB+JtZPM41TOIzmMq1Es70STR161jj/qOSwn28v42vjycH/r9C
         j9iA==
X-Gm-Message-State: AOAM532XoJJoVc/gNga0cfB55DTmgzofuT8N2fKMwBPb1bJ5k3Ks/Xnu
        Ijr2Or+WzO9KHTzuNqXSN9XCGKmgwErYyye6HCHGPNmSj7VKuHR8jKvdCveewKkPWv/5OS47Plc
        zzzzedFIoz5dCVBbQ
X-Received: by 2002:a1c:7e52:: with SMTP id z79mr12393934wmc.104.1591538343138;
        Sun, 07 Jun 2020 06:59:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPhCdg8nsVcYSKRsQtxYqjMu3Z2lGeq+GOYXsFNupGugKNhvKfrGs/gdkikgAZslAUpcg9tw==
X-Received: by 2002:a1c:7e52:: with SMTP id z79mr12393918wmc.104.1591538342920;
        Sun, 07 Jun 2020 06:59:02 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id y37sm23372137wrd.55.2020.06.07.06.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 06:59:02 -0700 (PDT)
Date:   Sun, 7 Jun 2020 09:59:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 01/13] vhost: option to fetch descriptors through an
 independent struct
Message-ID: <20200607095810-mutt-send-email-mst@kernel.org>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-2-mst@redhat.com>
 <e35e5df9-7e36-227e-7981-232a62b06607@redhat.com>
 <20200603045825-mutt-send-email-mst@kernel.org>
 <48e6d644-c4aa-2754-9d06-22133987b3be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48e6d644-c4aa-2754-9d06-22133987b3be@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 08:04:45PM +0800, Jason Wang wrote:
> 
> On 2020/6/3 下午5:48, Michael S. Tsirkin wrote:
> > On Wed, Jun 03, 2020 at 03:13:56PM +0800, Jason Wang wrote:
> > > On 2020/6/2 下午9:05, Michael S. Tsirkin wrote:
> 
> 
> [...]
> 
> 
> > > > +
> > > > +static int fetch_indirect_descs(struct vhost_virtqueue *vq,
> > > > +				struct vhost_desc *indirect,
> > > > +				u16 head)
> > > > +{
> > > > +	struct vring_desc desc;
> > > > +	unsigned int i = 0, count, found = 0;
> > > > +	u32 len = indirect->len;
> > > > +	struct iov_iter from;
> > > > +	int ret;
> > > > +
> > > > +	/* Sanity check */
> > > > +	if (unlikely(len % sizeof desc)) {
> > > > +		vq_err(vq, "Invalid length in indirect descriptor: "
> > > > +		       "len 0x%llx not multiple of 0x%zx\n",
> > > > +		       (unsigned long long)len,
> > > > +		       sizeof desc);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	ret = translate_desc(vq, indirect->addr, len, vq->indirect,
> > > > +			     UIO_MAXIOV, VHOST_ACCESS_RO);
> > > > +	if (unlikely(ret < 0)) {
> > > > +		if (ret != -EAGAIN)
> > > > +			vq_err(vq, "Translation failure %d in indirect.\n", ret);
> > > > +		return ret;
> > > > +	}
> > > > +	iov_iter_init(&from, READ, vq->indirect, ret, len);
> > > > +
> > > > +	/* We will use the result as an address to read from, so most
> > > > +	 * architectures only need a compiler barrier here. */
> > > > +	read_barrier_depends();
> > > > +
> > > > +	count = len / sizeof desc;
> > > > +	/* Buffers are chained via a 16 bit next field, so
> > > > +	 * we can have at most 2^16 of these. */
> > > > +	if (unlikely(count > USHRT_MAX + 1)) {
> > > > +		vq_err(vq, "Indirect buffer length too big: %d\n",
> > > > +		       indirect->len);
> > > > +		return -E2BIG;
> > > > +	}
> > > > +	if (unlikely(vq->ndescs + count > vq->max_descs)) {
> > > > +		vq_err(vq, "Too many indirect + direct descs: %d + %d\n",
> > > > +		       vq->ndescs, indirect->len);
> > > > +		return -E2BIG;
> > > > +	}
> > > > +
> > > > +	do {
> > > > +		if (unlikely(++found > count)) {
> > > > +			vq_err(vq, "Loop detected: last one at %u "
> > > > +			       "indirect size %u\n",
> > > > +			       i, count);
> > > > +			return -EINVAL;
> > > > +		}
> > > > +		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
> > > > +			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
> > > > +			       i, (size_t)indirect->addr + i * sizeof desc);
> > > > +			return -EINVAL;
> > > > +		}
> > > > +		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
> > > > +			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
> > > > +			       i, (size_t)indirect->addr + i * sizeof desc);
> > > > +			return -EINVAL;
> > > > +		}
> > > > +
> > > > +		push_split_desc(vq, &desc, head);
> > > 
> > > The error is ignored.
> > See above:
> > 
> >       	if (unlikely(vq->ndescs + count > vq->max_descs))
> > 
> > So it can't fail here, we never fetch unless there's space.
> > 
> > I guess we can add a WARN_ON here.
> 
> 
> Yes.
> 
> 
> > 
> > > > +	} while ((i = next_desc(vq, &desc)) != -1);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int fetch_descs(struct vhost_virtqueue *vq)
> > > > +{
> > > > +	unsigned int i, head, found = 0;
> > > > +	struct vhost_desc *last;
> > > > +	struct vring_desc desc;
> > > > +	__virtio16 avail_idx;
> > > > +	__virtio16 ring_head;
> > > > +	u16 last_avail_idx;
> > > > +	int ret;
> > > > +
> > > > +	/* Check it isn't doing very strange things with descriptor numbers. */
> > > > +	last_avail_idx = vq->last_avail_idx;
> > > > +
> > > > +	if (vq->avail_idx == vq->last_avail_idx) {
> > > > +		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
> > > > +			vq_err(vq, "Failed to access avail idx at %p\n",
> > > > +				&vq->avail->idx);
> > > > +			return -EFAULT;
> > > > +		}
> > > > +		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
> > > > +
> > > > +		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
> > > > +			vq_err(vq, "Guest moved used index from %u to %u",
> > > > +				last_avail_idx, vq->avail_idx);
> > > > +			return -EFAULT;
> > > > +		}
> > > > +
> > > > +		/* If there's nothing new since last we looked, return
> > > > +		 * invalid.
> > > > +		 */
> > > > +		if (vq->avail_idx == last_avail_idx)
> > > > +			return vq->num;
> > > > +
> > > > +		/* Only get avail ring entries after they have been
> > > > +		 * exposed by guest.
> > > > +		 */
> > > > +		smp_rmb();
> > > > +	}
> > > > +
> > > > +	/* Grab the next descriptor number they're advertising */
> > > > +	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
> > > > +		vq_err(vq, "Failed to read head: idx %d address %p\n",
> > > > +		       last_avail_idx,
> > > > +		       &vq->avail->ring[last_avail_idx % vq->num]);
> > > > +		return -EFAULT;
> > > > +	}
> > > > +
> > > > +	head = vhost16_to_cpu(vq, ring_head);
> > > > +
> > > > +	/* If their number is silly, that's an error. */
> > > > +	if (unlikely(head >= vq->num)) {
> > > > +		vq_err(vq, "Guest says index %u > %u is available",
> > > > +		       head, vq->num);
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	i = head;
> > > > +	do {
> > > > +		if (unlikely(i >= vq->num)) {
> > > > +			vq_err(vq, "Desc index is %u > %u, head = %u",
> > > > +			       i, vq->num, head);
> > > > +			return -EINVAL;
> > > > +		}
> > > > +		if (unlikely(++found > vq->num)) {
> > > > +			vq_err(vq, "Loop detected: last one at %u "
> > > > +			       "vq size %u head %u\n",
> > > > +			       i, vq->num, head);
> > > > +			return -EINVAL;
> > > > +		}
> > > > +		ret = vhost_get_desc(vq, &desc, i);
> > > > +		if (unlikely(ret)) {
> > > > +			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
> > > > +			       i, vq->desc + i);
> > > > +			return -EFAULT;
> > > > +		}
> > > > +		ret = push_split_desc(vq, &desc, head);
> > > > +		if (unlikely(ret)) {
> > > > +			vq_err(vq, "Failed to save descriptor: idx %d\n", i);
> > > > +			return -EINVAL;
> > > > +		}
> > > > +	} while ((i = next_desc(vq, &desc)) != -1);
> > > > +
> > > > +	last = peek_split_desc(vq);
> > > > +	if (unlikely(last->flags & VRING_DESC_F_INDIRECT)) {
> > > > +		pop_split_desc(vq);
> > > > +		ret = fetch_indirect_descs(vq, last, head);
> > > 
> > > Note that this means we don't supported chained indirect descriptors which
> > > complies the spec but we support this in vhost_get_vq_desc().
> > Well the spec says:
> > 	A driver MUST NOT set both VIRTQ_DESC_F_INDIRECT and VIRTQ_DESC_F_NEXT in flags.
> > 
> > Did I miss anything?
> > 
> 
> No, but I meant current vhost_get_vq_desc() supports chained indirect
> descriptor. Not sure if there's an application that depends on this
> silently.
> 
> Thanks
> 

I don't think we need to worry about that unless this actually
surfaces.

-- 
MST


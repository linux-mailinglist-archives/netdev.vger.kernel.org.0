Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01648360011
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhDOCiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDOCiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:38:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB94DC061574;
        Wed, 14 Apr 2021 19:37:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so13567195pjb.0;
        Wed, 14 Apr 2021 19:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SSKwWRHR5H0FFn4v5/H3xZJiJ4EvNjSHVt8IY/5zaIw=;
        b=Fg3bwYLpkxL+d+JoOkNVBa+CU9urcAPamvWJoOqB9MM25yoUftEGMfSZ0RDy3Xplr8
         J6jcbwhc5urTtA55oRgFTM1VqTL45DqKpCltAW3vnGeBSsZuQL9IGm/Ytn9dzIh/ys+U
         zMFeYkOn8CGvf59IUvovrs/LH032u2kulcjNhd4/3im+Nrm+c0WOl4pqD/cp1Z/S1BU0
         PFfu8lO0somBwn265LR+nhIqTi8GNzZ2eAGVb8OPxKb31xcS5wtfWBRddfTsvFdcuXMW
         SXMUmqQMfGIoH3Awqm7EScU1u5heIqW4lUDYIaeGLon3O5W1CrYfSDHLd6tr4NXxFr6u
         zqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SSKwWRHR5H0FFn4v5/H3xZJiJ4EvNjSHVt8IY/5zaIw=;
        b=UFSSd8yhkcj5RXl/3KajV3dnQphjKkF/wTRRvGhZ4Xo620gIYS6oUgatiCDODu8HOb
         diPw2Hl/jLD7ELcDsvIFSBicyQU3nceMjnumYw4QKrmMj+xHl9BHPGAwF8XptyPbR9Ot
         9ooX1NwqT6sGzoLToEypzyNcgPvIgcXMKkJPQp29U5+8wcUwbOaosJe9pN2kxrCeGdxB
         pTrqNQn+6T4tvDxg2vhvqBKT0+kw2m1GLE4INHiRSh18QIlaCgVWirvAaY6FuIrnW0D3
         5XqpRVqxidaqo2Z0JW0hyVe5WcunhIoyqANexTU51Ck/xIv3bW6mjqy6rF71/VGvgLPD
         L4Jw==
X-Gm-Message-State: AOAM5302DWHg5fQ4few4sZNDSh45EpXZLotmTxfQ3DVCipin4DmaLIqI
        pfMNsOQOQFSQdmC1NhUKHRQ=
X-Google-Smtp-Source: ABdhPJx/0L9qwQe/38cfWmvuCvHWbw0IFv+oNW54O3S1jIK0gvDPELMjw9L85O7kFI2CWEUZ59N9AA==
X-Received: by 2002:a17:90a:5407:: with SMTP id z7mr1324949pjh.228.1618454279498;
        Wed, 14 Apr 2021 19:37:59 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o4sm598253pfk.15.2021.04.14.19.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 19:37:59 -0700 (PDT)
Date:   Thu, 15 Apr 2021 10:37:46 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210415023746.GR2900@Leo-laptop-t470s>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:
> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >  {
> >  	struct net_device *dev = bq->dev;
> > -	int sent = 0, err = 0;
> > +	int sent = 0, drops = 0, err = 0;
> > +	unsigned int cnt = bq->count;
> > +	int to_send = cnt;
> >  	int i;
> >  
> > -	if (unlikely(!bq->count))
> > +	if (unlikely(!cnt))
> >  		return;
> >  
> > -	for (i = 0; i < bq->count; i++) {
> > +	for (i = 0; i < cnt; i++) {
> >  		struct xdp_frame *xdpf = bq->q[i];
> >  
> >  		prefetch(xdpf);
> >  	}
> >  
> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > +	if (bq->xdp_prog) {
> bq->xdp_prog is used here
> 
> > +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > +		if (!to_send)
> > +			goto out;
> > +
> > +		drops = cnt - to_send;
> > +	}
> > +
> 
> [ ... ]
> 
> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> > -		       struct net_device *dev_rx)
> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> >  {
> >  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
> >  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> >  	 * from net_device drivers NAPI func end.
> > +	 *
> > +	 * Do the same with xdp_prog and flush_list since these fields
> > +	 * are only ever modified together.
> >  	 */
> > -	if (!bq->dev_rx)
> > +	if (!bq->dev_rx) {
> >  		bq->dev_rx = dev_rx;
> > +		bq->xdp_prog = xdp_prog;
> bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
> How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
> It is not very obvious after taking a quick look at xdp_do_flush[_map].
> 
> e.g. what if the devmap elem gets deleted.

Jesper knows better than me. From my veiw, based on the description of
__dev_flush():

On devmap tear down we ensure the flush list is empty before completing to
ensure all flush operations have completed. When drivers update the bpf
program they may need to ensure any flush ops are also complete.

Thanks
Hangbin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBF72FE0DB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbhAUEFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbhAUD5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:57:43 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2471C061796;
        Wed, 20 Jan 2021 19:54:38 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m6so712093pfm.6;
        Wed, 20 Jan 2021 19:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vIdMv+Nr9RNa2hxBZhirUIpWxNLnXdv4lJ3EG1jjieg=;
        b=M1Hur7ybWkqdieJtm2AC2CBQQjYI5jHgfeHbH4mpGGOJF68jaUiFCB9X4AUCRoD++F
         TaHmUQlywsBfJ9ysBi58rsYcs9+7zqL34rpyCjQFQiOMFhg4ur3VfCl8CInhzmQuCXSr
         Etp8p7i4fFBRO6Z5N3C6WYjAVOEmd0KxLRdU1PpRLPdNC30Mslysaut5emzaf/CoTJV5
         VQ+lhqQMJLyBX6l2DaRE0mHH0ZcfnZGgDsU0ZrMsCyoN8nffY39/Bhg1RLNxAhR72GbJ
         GuYWq9jQgZNbaV+tB8yY/aMtgrIlpNOMWV7voc4tsV+TFbte75t0aZITNxXaFVYEf1U8
         Rqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vIdMv+Nr9RNa2hxBZhirUIpWxNLnXdv4lJ3EG1jjieg=;
        b=szBkPu9qXDKhJug1mV3yUhVHBdGsbHFv6kBhv1a+NdtDZvUkhCag4Vs4s5uT8zhYRS
         sqytuUC0KCIcac4I3uYhzhKjjUp4/UhEGorc2hyg53FE8xVE2aWiHEAmvpdUOeS8HJaa
         NpBPFIcDo1/DsOFKO9cN4m+JniIwYqPGmIGe0o7l3ARxTrppueSpxo3sa6Jr3WlpFumn
         6rZkVM+pVc+g6jeUwwmnfziLtxPjJv99mKD1rSauT/cltiYJwvJRqA2agEYg4gB6DIyk
         pYGkCTsPuO37FpcxZtVtndlJjQN75AYZrAbRJw0MdxUS7A1z1dX58gvwK/GFJqqTNLyy
         QnzQ==
X-Gm-Message-State: AOAM533b8OmDvMfActWPeW1t7eEagPe+STi2bm+BUG7RiQpRRJiYI1MT
        WizfXrEdgOyZU6iytB/QRGw=
X-Google-Smtp-Source: ABdhPJwsEtUoypR832OXSJJHOw/j/RpzkeqdcEOEnsgKfvV0psXjFWidduM2iWIwpc8wsrmT6/nUTQ==
X-Received: by 2002:a62:2e86:0:b029:1a6:5f94:2cb with SMTP id u128-20020a622e860000b02901a65f9402cbmr12446648pfu.19.1611201278289;
        Wed, 20 Jan 2021 19:54:38 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f29sm3708447pgm.76.2021.01.20.19.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 19:54:37 -0800 (PST)
Date:   Thu, 21 Jan 2021 11:54:24 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv15 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20210121035424.GK1421720@Leo-laptop-t470s>
References: <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210120022514.2862872-2-liuhangbin@gmail.com>
 <20210120224238.GA33532@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120224238.GA33532@ranger.igk.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,
On Wed, Jan 20, 2021 at 11:42:38PM +0100, Maciej Fijalkowski wrote:
> > +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> > +				struct xdp_frame **frames, int n,
> > +				struct net_device *dev)
> > +{
> > +	struct xdp_txq_info txq = { .dev = dev };
> > +	struct xdp_buff xdp;
> > +	int i, nframes = 0;
> > +
> > +	for (i = 0; i < n; i++) {
> > +		struct xdp_frame *xdpf = frames[i];
> > +		u32 act;
> > +		int err;
> > +
> > +		xdp_convert_frame_to_buff(xdpf, &xdp);
> > +		xdp.txq = &txq;
> > +
> > +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > +		switch (act) {
> > +		case XDP_PASS:
> > +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> 
> Bump on John's question.

Hi Jesper, would you please help answer John's question?
> >  
> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > +	/* Init sent to cnt in case there is no xdp_prog */
> > +	sent = cnt;
> > +	if (bq->xdp_prog) {
> > +		sent = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > +		if (!sent)
> > +			goto out;
> 
> Sorry, but 'sent' is a bit confusing to me, actual sending happens below
> via ndo_xdp_xmit, right? This hook will not actually send frames.
> Can we do a subtle change to have it in separate variable 'to_send' ?

Makes sense to me.
> 
> Although I'm a huge goto advocate, I feel like this particular usage could
> be simplified. Not sure why we had that in first place.
> 
> I gave a shot at rewriting/refactoring whole bq_xmit_all and I feel like
> it's more readable. I introduced 'to_send' variable and got rid of 'error'
> label.
> 
> Thoughts?
> 
> I might have missed something, though.
> 
> static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> {
> 	struct net_device *dev = bq->dev;
> 	unsigned int cnt = bq->count;
> 	int drops = 0, err = 0;
> 	int to_send = 0;

The to_send also need to init to cnt.

> 	int sent = cnt;
> 	int i;
> 
> 	if (unlikely(!cnt))
> 		return;
> 
> 	for (i = 0; i < cnt; i++) {
> 		struct xdp_frame *xdpf = bq->q[i];
> 
> 		prefetch(xdpf);
> 	}
> 
> 	if (bq->xdp_prog) {
> 		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> 		if (!to_send) {
> 			sent = 0;
> 			goto out;
> 		}
> 	}
> 
> 	drops = cnt - to_send;

This line could move in to the xdp_prog brackets to save time when no xdp_prog.

	if (bq->xdp_prog) {
		to_send = ...
		if (!to_send) {
			...
		}
		drops = cnt - to_send;
	}

> 	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);

If we don't have xdp_prog, the to_send should be cnt.

> 	if (sent < 0) {
> 		err = sent;
> 		sent = 0;
> 
> 		/* If ndo_xdp_xmit fails with an errno, no frames have been
> 		 * xmit'ed and it's our responsibility to them free all.
> 		 */
> 		for (i = 0; i < cnt - drops; i++) {
> 			struct xdp_frame *xdpf = bq->q[i];
> 
> 			xdp_return_frame_rx_napi(xdpf);
> 		}
> 	}
> out:
> 	drops = cnt - sent;
> 	bq->count = 0;
> 
> 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> 	bq->dev_rx = NULL;
> 	bq->xdp_prog = NULL;
> 	__list_del_clearprev(&bq->flush_node);
> 
> 	return;
> }

Thanks for your code, looks much clear now.

Hangbin

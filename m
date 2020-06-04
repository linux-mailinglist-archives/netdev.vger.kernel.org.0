Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169BC1EE221
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgFDKKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 06:10:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726248AbgFDKKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 06:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591265430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zGlJ8O4yA/W7bete/cF7FQcgVbI9QLdgYqKnnIFMKJ0=;
        b=WeEuDoa8OiPxB16TXP+9ii33NDIdKJKthW+81pVi63d1Gu3bBhjtkQCVEHMxBX5ruZfkzh
        iL+wV4K/QUInfOseiPHOlaYvUQ/dCn0wI2o0Pbpt3XUqo/UhoI66JYw7jrPGYAioW1lOQW
        7OfhJUwj1M1Q9EeR6G/Yq0pRXqLk454=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-daJWBcSuOVKJpy30EPFn4w-1; Thu, 04 Jun 2020 06:10:28 -0400
X-MC-Unique: daJWBcSuOVKJpy30EPFn4w-1
Received: by mail-wr1-f70.google.com with SMTP id t5so2208090wro.20
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 03:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zGlJ8O4yA/W7bete/cF7FQcgVbI9QLdgYqKnnIFMKJ0=;
        b=S8MU+eKRK9lHpSM0x+a4ZjT8dY8GRQMlkw8jK17XRpvneWUNs+ey2ZVANS0M0N3RXF
         jtf5C1WrWMiQ0WTC9hb/Wbc4kdVZ9SL7UIVyLlrdMIde2VvCuZRoj59MebhTNun732jc
         yC02DqHmo2pSsrdELYZhAw5HLeTMn7Y/K1u6qvyUNC8vAb23X/tGdbvomJzEyochPQlC
         AQTMZ09hLUNDmNAZm++1y/iOv6rxb1XXlV1TKV6FJKdTotHRdcR5qdOFdK9iAiYk3QwV
         pcqlZqe1GUiLbMdA95UucNmaTZRCM1td9YdhRbDz2tm7ub6Ftau+jTaJFZDnWis4b0He
         N7bg==
X-Gm-Message-State: AOAM532ri8SG4BIOwwy6ZXxOs07TWKOuNyLnxYgeG8cOOlZ4MW6+RiFN
        edtZhvg5rWWkjG+A7ZibMWk1kCUkva6K7nhMnSIMZKxU8I7Y/z0aTLw4RWyr2B0HrKBf8DNBiGC
        YAjJL9J/cSDKPQHK5
X-Received: by 2002:adf:a491:: with SMTP id g17mr3959304wrb.132.1591265427234;
        Thu, 04 Jun 2020 03:10:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzijAVv5VHzZzhMi12UtVYg+WDrXlw/h6wDpYasdoiFD2bcBzxkW4hQDmgITXHqbv7FeNCrHw==
X-Received: by 2002:adf:a491:: with SMTP id g17mr3959287wrb.132.1591265426992;
        Thu, 04 Jun 2020 03:10:26 -0700 (PDT)
Received: from redhat.com ([2a00:a040:185:f65:9a3b:8fff:fed3:ad8d])
        by smtp.gmail.com with ESMTPSA id b187sm7095817wmd.26.2020.06.04.03.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 03:10:26 -0700 (PDT)
Date:   Thu, 4 Jun 2020 06:10:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200604054516-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
 <20200603165205.GU23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603165205.GU23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 05:52:05PM +0100, Al Viro wrote:
> On Wed, Jun 03, 2020 at 01:29:00AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Jun 03, 2020 at 02:48:15AM +0100, Al Viro wrote:
> > > On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> > > > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > > > is thus benefitial to enable userspace access, do our thing, then
> > > > disable. Except access_ok has already been pre-validated with all the
> > > > relevant nospec checks, so we don't need that.  Add an API to allow
> > > > userspace access after access_ok and barrier_nospec are done.
> > > 
> > > BTW, what are you going to do about vq->iotlb != NULL case?  Because
> > > you sure as hell do *NOT* want e.g. translate_desc() under STAC.
> > > Disable it around the calls of translate_desc()?
> > > 
> > > How widely do you hope to stretch the user_access areas, anyway?
> > 
> > So ATM I'm looking at adding support for the packed ring format.
> > That does something like:
> > 
> > get_user(flags, desc->flags)
> > smp_rmb()
> > if (flags & VALID)
> > copy_from_user(&adesc, desc, sizeof adesc);
> > 
> > this would be a good candidate I think.
> 
> Perhaps, once we get stac/clac out of raw_copy_from_user() (coming cycle,
> probably).

That sounds good. Presumably raw_copy_from_user will be smart enough
to optimize aligned 2 byte accesses for flags above?

>  BTW, how large is the structure and how is it aligned?

It's a batch of 16 byte structures, aligned to 16 bytes.
At the moment I used batch size of 64 which seems enough.
Ideally we'd actually read the whole batch like this
without stac/clac back and forth. E.g.

	struct vring_desc adesc[64] = {};

	stac()
	for (i = 0; i < 64; ++i) {
	 get_user(flags, desc[i].flags)
	 smp_rmb()
	 if (!(flags & VALID))
		break;
	 copy_from_user(&adesc[i], desc + i, sizeof adesc[i]);
	}
	clac()




> > > BTW, speaking of possible annotations: looks like there's a large
> > > subset of call graph that can be reached only from vhost_worker()
> > > or from several ioctls, with all uaccess limited to that subgraph
> > > (thankfully).  Having that explicitly marked might be a good idea...
> > 
> > Sure. What's a good way to do that though? Any examples to follow?
> > Or do you mean code comments?
> 
> Not sure...  FWIW, the part of call graph from "known to be only
> used by vhost_worker" (->handle_kick/vhost_work_init callback/
> vhost_poll_init callback) and "part of ->ioctl()" to actual uaccess
> primitives is fairly large - the longest chain is
> handle_tx_net ->
>   handle_tx ->
>     handle_tx_zerocopy ->
>       get_tx_bufs ->
> 	vhost_net_tx_get_vq_desc ->
> 	  vhost_tx_batch ->
> 	    vhost_net_signal_used ->
> 	      vhost_add_used_and_signal_n ->
> 		vhost_signal ->
> 		  vhost_notify ->
> 		    vhost_get_avail_flags ->
> 		      vhost_get_avail ->
> 			vhost_get_user ->
> 			  __get_user()
> i.e. 14 levels deep and the graph doesn't factorize well...
> 
> Something along the lines of "all callers of thus annotated function
> must be annotated the same way themselves, any implicit conversion
> of pointers to such functions to anything other than boolean yields
> a warning, explicit cast is allowed only with __force", perhaps?
> Then slap such annotations on vhost_{get,put,copy_to,copy_from}_user(),
> on ->handle_kick(), a force-cast in the only caller of ->handle_kick()
> and force-casts in the 3 callers in ->ioctl().
> 
> And propagate the annotations until the warnings stop, basically...
> 
> Shouldn't be terribly hard to teach sparse that kind of stuff and it
> might be useful elsewhere.  It would act as a qualifier on function
> pointers, with syntax ultimately expanding to __attribute__((something)).
> I'll need to refresh my memories of the parser, but IIRC that shouldn't
> require serious modifications.  Most of the work would be in
> evaluate_call(), just before calling evaluate_symbol_call()...
> I'll look into that; not right now, though.


Thanks, that does sound useful!

> BTW, __vhost_get_user() might be better off expanded in both callers -
> that would get their structure similar to vhost_copy_{to,from}_user(),
> especially if you expand __vhost_get_user_slow() as well.

I agree, that does sound like a good cleanup.

> Not sure I understand what's going with ->meta_iotlb[] - what are the
> lifetime rules for struct vhost_iotlb_map and what prevents the pointers
> from going stale?

It can be zeroed at any point.
We just try to call __vhost_vq_meta_reset whenever anything can go
stale.


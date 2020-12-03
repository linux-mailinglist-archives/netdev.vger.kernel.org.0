Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89162CDD05
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgLCSD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:03:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgLCSD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607018522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=axK0fTMz77Hz0bk64Px7aNUIYm5yvWB8HrtkLoxcYrw=;
        b=OuxXGLwcdn6f/xsbgt9IfJLy6YwkmZyppnw73kzPaEtgc0FF3KUatCG3K4VDUg6wnZoNhJ
        aA2s80zxLXgzHRWRKIh9eb5vAYJlnUHvSGqIMgy+b6H3OrQfggYo9F6cyVfQfTN//opG04
        H2IxAVOLUWcIe3MA4/f344XA+WVuiQ8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-lwOJpmvzNaOldkS_-kzTtQ-1; Thu, 03 Dec 2020 13:02:01 -0500
X-MC-Unique: lwOJpmvzNaOldkS_-kzTtQ-1
Received: by mail-wr1-f72.google.com with SMTP id l5so1491889wrn.18
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 10:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=axK0fTMz77Hz0bk64Px7aNUIYm5yvWB8HrtkLoxcYrw=;
        b=PHfHJdz9LsWh9k08C+W/VtbqmOdozVjzAJ6SkuVDMeQrmlY0gjEHtu3igVEMuRF4GD
         svVNuucrneL3Ib7ykMU1q7002zO34CbVrhW71Snmc8nG2TczPx+UPlYokvd8I4MpD/7B
         AuArTQ8G+jcv8PWCBfqAb8nNrIh8tq/nSU92Umu3Y0p+4si3goQkIneb8SL/hBulFF2J
         LS/23wmfHAYp+JnETZbJ3a09pvWuZ/SC6BfJBYmWLxPJHzaZXYusADU3AeK+Ij6V8iNz
         DHItAIP85tVliO2aMAR+u0Lmh+5e3+Umg9lKO1j0yIogkWF0lhrTrg3CKzPly+Gq6JF2
         Z/kg==
X-Gm-Message-State: AOAM531/CeGXzAw31hRE0GOQxi2eAtYTDqbGdD3rfXVfZRLyi8Q7QZ20
        641wnFxKCgph250xVZGK3RbWu5Ku3vu/5vH6H6o4CekcfZHSUEiof8Zwu3GqlZsCju2C0zTxcZ6
        nStkEzjFzHE1tnC2g
X-Received: by 2002:a5d:488d:: with SMTP id g13mr407049wrq.274.1607018519265;
        Thu, 03 Dec 2020 10:01:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/aXCdgI2/zAGb4lOoH9bV1cARTWnnQVu4xejxeGa2LH2TpLfWxl64gG5wi/gluF9q1FrCDA==
X-Received: by 2002:a5d:488d:: with SMTP id g13mr407021wrq.274.1607018519033;
        Thu, 03 Dec 2020 10:01:59 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l8sm146630wmf.35.2020.12.03.10.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:01:58 -0800 (PST)
Date:   Thu, 3 Dec 2020 19:01:56 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v2 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201203180156.GA2735@linux.home>
References: <20201201115250.6381-1-tparkin@katalix.com>
 <20201201115250.6381-2-tparkin@katalix.com>
 <20201203002318.GA31867@linux.home>
 <20201203115717.GA12568@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203115717.GA12568@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 11:57:18AM +0000, Tom Parkin wrote:
> On  Thu, Dec 03, 2020 at 01:23:18 +0100, Guillaume Nault wrote:
> > On Tue, Dec 01, 2020 at 11:52:49AM +0000, Tom Parkin wrote:
> > > +	if (!pchb) {
> > > +		write_unlock_bh(&pch->upl);
> > > +		return -EINVAL;
> > 
> > I'm not sure I'd consider this case as an error.
> 
> To be honest I'd probably tend agree with you, but I was seeking to
> maintain consistency with how PPPIOCCONNECT/PPPIOCDISCONN behave.  The
> latter returns EINVAL if the channel isn't connected to an interface.

Indeed, that makes sense. I didn't think about that. I was mostly
thinking about the case where ->bridge was concurently reset by another
ppp_unbridge_channels(), which doesn't look like an error to me. But
we can let userspace responsible for properly using the API (or
ignoring EINVAL when they don't).

> If you feel strongly I'm happy to change it but IMO it's better to be
> consistent with existing ioctl calls.

I don't feel strongly about it :).

> > If there's no bridged channel, there's just nothing to do.
> > Furthermore, there might be situations where this is not really an
> > error (see the possible race below).
> > 
> > > +	}
> > > +	RCU_INIT_POINTER(pch->bridge, NULL);
> > > +	write_unlock_bh(&pch->upl);
> > > +
> > > +	write_lock_bh(&pchb->upl);
> > > +	RCU_INIT_POINTER(pchb->bridge, NULL);
> > > +	write_unlock_bh(&pchb->upl);
> > > +
> > > +	synchronize_rcu();
> > > +
> > > +	if (refcount_dec_and_test(&pch->file.refcnt))
> > > +		ppp_destroy_channel(pch);
> > 
> > I think that we could have a situation where pchb->bridge could be
> > different from pch.
> > If ppp_unbridge_channels() was also called concurrently on pchb, then
> > pchb->bridge might have been already reset. And it might have dropped
> > the reference it had on pch. In this case, we'd erroneously decrement
> > the refcnt again.
> > 
> > In theory, pchb->bridge might even have been reassigned to a different
> > channel. So we'd reset pchb->bridge, but without decrementing the
> > refcnt of the channel it pointed to (and again, we'd erroneously
> > decrement pch's refcount instead).
> > 
> > So I think we need to save pchb->bridge to a local variable while we
> > hold pchb->upl, and then drop the refcount of that channel, instead of
> > assuming that it's equal to pch.
> 
> Ack, yes.
> 
> The v1 series protected against this, although by nesting locks :-|

Well, I think the v1 could deadlock in this situation. The RFC was
immune to this problem, as it didn't modify ->bridge on pchb.

> I think in the case that pchb->bridge != pch, we probably want to
> leave pchb alone, so:
> 
>  1. Don't unset the pchb->bridge pointer
>  2. Don't drop the pch reference (pchb doesn't hold a reference on pch
>     because pchb->bridge != pch)
> 
> This is on the assumption that pchb has been reassigned -- in that
> scenario we don't want to mess with pchb at all since it'll break the
> other bridge instance.

Yes you're right.

Thanks!


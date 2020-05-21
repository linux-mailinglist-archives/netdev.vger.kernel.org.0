Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDE71DD33B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgEUQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 12:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbgEUQpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 12:45:09 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C32C061A0E;
        Thu, 21 May 2020 09:45:08 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f83so7784282qke.13;
        Thu, 21 May 2020 09:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/e3M7r5/Rp60C+fN+JbPPBbtVPKReDl/o0vfP4vWN6Q=;
        b=evVbhth4aZtiQ0SYxEqdiM9hiECSRCmR4ZDtB6HHILulk/cVpFZ4rzGBL+PZToYCHZ
         +9KhACE09dE5toYH4n8/mI088pqA5t1LWYVmiPM3iZ7bB9vryRD63p9oEsYLiovpWtAe
         NbsoLLrC8dGcYHNB5QFbGBkL+eutd+1bc6tksLKi3GfeksJa8vbf6fUjcqD0EUAtlZKz
         dTr2ZhElhAZQKql2grZyWaOkqt+RKbgPs1L08XNGfKwZYFzk08K1ufJPxhA8grlTzXbV
         e6S5amzfP5i97JgOupywwF/iEny1gKOVOaeQbbvuTsW9cublqyc3LjNc9ckBmvdPPHkK
         Lw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/e3M7r5/Rp60C+fN+JbPPBbtVPKReDl/o0vfP4vWN6Q=;
        b=ZNZaTrJOFnytCj9dXWPAKj9+/1ylKQqtgqUpt+N3chEzM6ioNXRMA6JGxixYELiKZX
         X8aJmUWiVeQ/jj9nELHJEbG6Ce/S5D6bMw9Af2B1+GB2iDUaGn5TchnSqMo/uQuaGgYq
         /7ZNoUNETZhGAdiCouQQrz9CY7jICgI+hnlPz+z8yRDvHBc/k91CvByWQ+WQEqDfHq53
         1sgZtzwM0wgxSdUK95CCQWEvJpg1oYC40UQCDxrrgRw+F2gJhBiQ3oTRKxv44YIRu+K+
         kte39JExca5+DhM3kQTWLgBU49KFjly47ncBiayUk+XtOzqoZ7u6oM0GQWZBsOnyVAK/
         XzZQ==
X-Gm-Message-State: AOAM533vhyzkrtIlVzbunElJ+PPiJfkTrzhNVUcfovHy2vCdhV3c1Q6U
        dpt+1baYSMp62WLJPxE1CUoRV9FRkw7fJQ==
X-Google-Smtp-Source: ABdhPJyLMztf+VSbCrwgD09p2e0G4PHkT4WPLJFGSCFEriynyHO4HknSg+x4KBB0BQhg1KaA57Spig==
X-Received: by 2002:a05:620a:1502:: with SMTP id i2mr10416243qkk.420.1590079507633;
        Thu, 21 May 2020 09:45:07 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id n31sm5963238qtc.36.2020.05.21.09.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 09:45:06 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 607DCC0BEB; Thu, 21 May 2020 13:45:04 -0300 (-03)
Date:   Thu, 21 May 2020 13:45:04 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Message-ID: <20200521164504.GA47547@localhost.localdomain>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521153729.GB74252@localhost.localdomain>
 <a681d1dc056a412bba24b9b4cde37785@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a681d1dc056a412bba24b9b4cde37785@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 04:09:15PM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 21 May 2020 16:37
> > On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> ...
> > > Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> > > It is also the only getsockopt() that wants to return a buffer
> > > and an error code. It is also definitely abusing getsockopt().
> > 
> > It should have been a linear buffer. The secondary __user access is
> > way worse than having the application to do another allocation. But
> > too late..
> 
> I think that is SCTP_SOCKOPT_CONNECTX ?

Right :-)

...
> > > +	if (optlen < sizeof (param_buf)) {
> > > +		if (copy_from_user(&param_buf, u_optval, optlen))
> > > +			return -EFAULT;
> > > +		optval = param_buf;
> > > +	} else {
> > > +		if (optlen > USHRT_MAX)
> > > +			optlen = USHRT_MAX;
> > 
> > There are functions that can work with and expect buffers larger than
> > that, such as sctp_setsockopt_auth_key:
> 
> I'd assumed the maximums were silly.
> But a few more than 64k is enough, the lengths are in bytes.
> OTOH 128k is a nice round limit - and plenty AFAICT.

LGTM too.

> 
> ...
> > > +	if (len < sizeof (param_buf)) {
> > > +		/* Zero first bytes to stop KASAN complaining. */
> > > +		param_buf[0] = 0;
> > > +		if (copy_from_user(&param_buf, u_optval, len))
> > > +			return -EFAULT;
> > > +		optval = param_buf;
> > > +	} else {
> > > +		if (len > USHRT_MAX)
> > > +			len = USHRT_MAX;
> > 
> > This limit is not present today for sctp_getsockopt_local_addrs()
> > calls (there may be others).  As is, it will limit it and may mean
> > that it can't dump all addresses.  We have discussed this and didn't
> > come to a conclusion on what is a safe limit to use here, at least not
> > on that time.
> 
> It needs some limit. memdup_user() might limit at 32MB.
> I couldn't decide is some of the allocators limit it further.
> In any case an IPv6 address is what? under 128 bytes.
> 64k is 512 address, things are going to explode elsewhere first.

If it does, we probably can fix that too.

> 
> I didn't see 'get' requests that did 64k + a bit.
> 
> It should be possible to loop using a larger kernel buffer if the
> data won't fit.
> Doable as a later patch to avoid complications.

Sounds complicated. 128k should be more than enough here as well.
sctp_getsockopt_local_addrs() will adjust the output to fit on the
buffer. Point being, with enough buffer, it will support the limits
the RFC states, and if the user supplies a smaller buffer, it will
dump what it can. If the user pass a larger buffer, it doesn't need
it, and it's safe to ignore the rest of the buffer (as the patch is
doing here). I didn't check the other functions now, though.

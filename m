Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F038D1F59A5
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgFJRDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgFJRDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 13:03:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60742C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 10:03:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so1139982pjd.0
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 10:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WnFhsHiRkjL5CKHVcJANd7l4RT2J9uPwXvDpKNqYxnE=;
        b=PIR7AKWKofwN1umcHuM09ZxByEVhsJVOX+V/OkCyg+RRtageSmj5AXBOw1PgAVS82M
         nNByVjXpoDHIG7eGGtgax/8dEArheP0Cpq0o02PdjBud76Rvs9QkyZ3aBIhNBoYq68xw
         0mWR8ibZsAqaCi+pwdrY/Z2pKEems7YkZMReI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WnFhsHiRkjL5CKHVcJANd7l4RT2J9uPwXvDpKNqYxnE=;
        b=MSCyFYFodqV9Zx8bgsSWKegGXtgTtMzqJj5AOAdq69yuUzO7DHNAoe0UmMVhMtoCOJ
         sSftL1FPM7P6LdvP2bTKm4o9/uhHrAgvXWNGJp0mUTqMn56WwyFVGygbnuImD95+Vcsp
         9tnkE7wW4PEdhWOwfrLJl03cVWeRDA99lAuCEB4gWw3xPstNWGfB288+Y07dBpMFKq8d
         dWqLWC09Ew31ybH4UCK8qzp/dLp4tHwZSEL2Y1ewoGA6mcfJNEnjjSH9uEweVmHcdfyZ
         s88ErATQ89IUCzpv7tN7dhmQA9cdCuyb0Z5M5opZPnXjev5rQn0QxzdVqeVYITQ+GFgB
         obJQ==
X-Gm-Message-State: AOAM533lwy/3ubyFBQATdvxtRHpYAcV2/RkgfvUuHR3NgVYB2ZbioXeq
        EJYndBDEWzqPayzJoqb0mtfMCA==
X-Google-Smtp-Source: ABdhPJw4PWREPUlcxU0tV+ltlwQoUM1QOuUEjsfwJs5U+2uv2dt2CRp1VjaG5JfN4FoaNx1oCuRJ4g==
X-Received: by 2002:a17:90a:fa95:: with SMTP id cu21mr3859547pjb.56.1591808585874;
        Wed, 10 Jun 2020 10:03:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n189sm449402pfn.108.2020.06.10.10.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 10:03:04 -0700 (PDT)
Date:   Wed, 10 Jun 2020 10:03:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian@brauner.io>,
        Sargun Dhillon <sargun@sargun.me>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Use __scm_install_fd() more widely
Message-ID: <202006101001.6738CA0@keescook>
References: <20200610045214.1175600-1-keescook@chromium.org>
 <20200610094735.7ewsvrfhhpioq5xe@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610094735.7ewsvrfhhpioq5xe@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 11:47:35AM +0200, Christian Brauner wrote:
> On Tue, Jun 09, 2020 at 09:52:12PM -0700, Kees Cook wrote:
> > Hi,
> > 
> > This extends the recent work hch did for scm_detach_fds(), and updates
> > the compat path as well, fixing bugs in the process. Additionally,
> > an effectively incomplete and open-coded __scm_install_fd() is fixed
> > in pidfd_getfd().
> 
> Since __scm_detach_fds() becomes something that is available outside of
> net/* should we provide a static inline wrapper under a different name? The
> "socket-level control message" prefix seems a bit odd in pidfd_getfd()
> and - once we make use of it there - seccomp.
> 
> I'd suggest we do:
> 
> static inline int fd_install_received(struct file *file, unsigned int flags)
> {
> 	return __scm_install_fd(file, NULL, flags);
> }
> 
> which can be called in pidfd_getfd() and once we have other callers that
> want the additional put_user() (e.g. seccomp_ in there we simply add:
> 
> static inline fd_install_user(struct file *file, unsigned int flags, int __user *ufd)
> {
> 	return __scm_install_fd(file, ufd, flags);
> }
> 
> and seems the wrappers both could happily live in the fs part of the world?

I combined your and Sargun's suggestions. (It can't live in any more
net/core/scm.c in the case of CONFIG_NET=n, but the wrappers make the
changes much nicer looking.)

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=devel/seccomp/addfd/v3.2

If 0-day doesn't kick anything back on this tree, I'll resend the
series...

-- 
Kees Cook

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2C62845B5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgJFF5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgJFF5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 01:57:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A7C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 22:57:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id p21so1040992pju.0
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 22:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gx4WOvLZE+8XVE2Cbj1TNlsvQN+bEc7hhbjF/tgIFks=;
        b=lIzQwVFztGvCS46aamlT+Zp90+6vgiZYuYVYPYCJ266iK/uoWXyEyrXdL+ASF2Rpqj
         ZMXs/jATshsL6nNxJIJtjbFrXbBtj+7EKt0zWl0QpYwJSVFxB/yglLqM6l06tKlgg73j
         pP+effqg9e6dsJyuFUrqtstsMcZCr/eCqWXu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gx4WOvLZE+8XVE2Cbj1TNlsvQN+bEc7hhbjF/tgIFks=;
        b=JuaVXw1YoOQLFrbkKrdF4kPPHFRX0g8ZYW3Jq7XiNxN65Ez6pWnegsRMa7NeUmoA+q
         Ha+eUgFAyijjkdZe6BVjEWIdskwo1GIGtnb4YfZPDN+Yu+2jzQue2dq4fo5NcXt7wV+h
         ueL9qjrmraMDleK7YgpjFSXghuu22qv9joRb/VF5PC6z+h1WBhkCiZlPfKSRsrTW2Vlq
         siUQgZYjSwO7c/EYO+ZGJqwyYPinLsUwz5vs5DAcnGaWocLOJFpOgDLdyDMesnENeA97
         leqdibPg3HzMBWWcDUYUd9zUt3y2JQ4gMnGj/3F2ugM/qhcFeoo+XLB+2RrWqvV/n5n+
         60kg==
X-Gm-Message-State: AOAM533ensYO+gGjEUniS4Ss0DN9jN78bVeAx2MYPr05VwtDzjhyNF9O
        /1B29MvXRj/81nSAaKFjLxrtwA==
X-Google-Smtp-Source: ABdhPJyyhqIDHGy7mDnDHpQB09ZhAu+H7/Ucq2xIm6TB1CInHA8Hx4CXWDmYBVa2VyTjeL4m+tfnaA==
X-Received: by 2002:a17:90a:8007:: with SMTP id b7mr274521pjn.84.1601963849512;
        Mon, 05 Oct 2020 22:57:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y126sm1607049pgb.40.2020.10.05.22.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 22:57:28 -0700 (PDT)
Date:   Mon, 5 Oct 2020 22:57:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <202010052257.CB8E47E@keescook>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
 <202010051910.BC7E9F4@keescook>
 <20201006022808.GA5531@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006022808.GA5531@1wt.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 04:28:09AM +0200, Willy Tarreau wrote:
> Hi Kees,
> 
> On Mon, Oct 05, 2020 at 07:12:29PM -0700, Kees Cook wrote:
> > On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> > > From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > > 
> > > Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> > > and activity") broke compilation and was temporarily fixed by Linus in
> > > 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> > > gcc plugin") by entirely moving net_rand_state out of the things handled
> > > by the latent_entropy GCC plugin.
> > > 
> > > From what I understand when reading the plugin code, using the
> > > __latent_entropy attribute on a declaration was the wrong part and
> > > simply keeping the __latent_entropy attribute on the variable definition
> > > was the correct fix.
> > > 
> > > Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: Willy Tarreau <w@1wt.eu>
> > > Cc: Emese Revfy <re.emese@gmail.com>
> > > Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > 
> > Yes, that looks correct. Thank you!
> > 
> > Acked-by: Kees Cook <keescook@chromium.org>
> > 
> > I'm not sure the best tree for this. Ted, Andrew, Linus? I'll take it
> > via my gcc plugin tree if no one else takes it. :)
> 
> It was already merged as commit 09a6b0bc3be79 and queued for -stable.

Ah, perfect! Thanks.

-- 
Kees Cook

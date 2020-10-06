Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404862843F4
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 04:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgJFCMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 22:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgJFCMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 22:12:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3B2C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 19:12:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so4870315pfp.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 19:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VZRD+TMaL8IPQ0MGbmyliD18F5b146FgOWwgTc6dgq4=;
        b=Qxk3h4dI0WGdYw3MgojRy3uS/mvhPwWzlYo/2snbGBUZgqXvojT2aIw2SZNRj7ahCC
         Dsc457ZOM4KJAIYzcXJphrjNvv7Ix2ADoPqRBGeYI39hntpFj/WvtjN1Uu9O29p0Yxce
         1Toi3J6qBr54e1SZCFb4ekFCzxtw+4I88tsNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VZRD+TMaL8IPQ0MGbmyliD18F5b146FgOWwgTc6dgq4=;
        b=jwObeszzJvp+rtYn/7+pJD4snVIwDMHYcJ4TJMfnCln1AwY1im6gUcLKDau7xyZOYZ
         kQNCpXSA5TgKqqlozqa5DB5gVmyD0M0TZAcDtVcAgB5KHyZXM4JOmAy+Tz4DvuIeElqi
         IB+VjcoeL54yw5tQOtJZYP4CX27XDiB3tLm7o0uqAkgCqICMYy/vNRdEt4d16gOa/DXw
         kxj1gx5GJEStZ5Sec77s6WJDJJWilvcGfHk0DlWon070YaYYVnAUCW/N+N5yi5ZVM7pv
         XBkXQUdWF4xrfZ5ryq2dPyw0g3vXTIK1f4L+EV56CocGBSvBdczLVfSpLb1XkbrqlkBW
         ts1g==
X-Gm-Message-State: AOAM531RWw8husOGESvl6KYatkO2654DzQUv5HgPdONGrtIUWeI74O+R
        vvFeT+r7hvs9MssNk4dnP/IHeQ==
X-Google-Smtp-Source: ABdhPJyVFFS9wGSPx2kS3ePT3bDnzMoFQeQuxGgqj3ijS0b1+VmeQQ38aHDXOr3umuIHUuzRADHQMA==
X-Received: by 2002:aa7:97a8:0:b029:13e:d13d:a105 with SMTP id d8-20020aa797a80000b029013ed13da105mr2299234pfq.33.1601950351477;
        Mon, 05 Oct 2020 19:12:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g1sm886958pjl.21.2020.10.05.19.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 19:12:30 -0700 (PDT)
Date:   Mon, 5 Oct 2020 19:12:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>, Emese Revfy <re.emese@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <202010051910.BC7E9F4@keescook>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> 
> Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> and activity") broke compilation and was temporarily fixed by Linus in
> 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> gcc plugin") by entirely moving net_rand_state out of the things handled
> by the latent_entropy GCC plugin.
> 
> From what I understand when reading the plugin code, using the
> __latent_entropy attribute on a declaration was the wrong part and
> simply keeping the __latent_entropy attribute on the variable definition
> was the correct fix.
> 
> Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Emese Revfy <re.emese@gmail.com>
> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>

Yes, that looks correct. Thank you!

Acked-by: Kees Cook <keescook@chromium.org>

I'm not sure the best tree for this. Ted, Andrew, Linus? I'll take it
via my gcc plugin tree if no one else takes it. :)

-- 
Kees Cook

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C70F3D855C
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbhG1BaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbhG1BaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:30:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A93C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 18:30:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f13so761043plj.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 18:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F/W78E3w8bd3psxYX0IIxref8Eo+wzHY8m4KRkXjPMs=;
        b=fSpVrx2KFTwbTxZxaxYBjKJ9a3HRRpiHfBG8wD07VjuWC7mdbYEQ/7GkiPoSY+/g36
         +TtB+dCcoMKG1TPpgjH+W/O2nqputas/NPxb5d/iKCDtXteeWA5Muau5Hiw7k0rZrmBp
         XaotHXeRLZbN2gC+C3tJaqkKc+t5iWRCRbObY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F/W78E3w8bd3psxYX0IIxref8Eo+wzHY8m4KRkXjPMs=;
        b=Ku5/HIHiG89OqBbEaPbA0uIaRsI+NaEH3qPb2BgAShcgLC1yp45cESTKqC08eIynAy
         B6IacPpLv28jTwIvqwgDU/e43J/HDJ9u9yC3qgZMG7jZ9FymxyGHq/j/QfRExtz+6FTj
         kx0ajPHBGVqoxfzdkkMjSL/3Ok3Wi6kbF7ltU3MTKVlb0yJicpOUGjFKzs7ZEEpK4QIL
         idl3OHyrxP+uvEesry1fzwN9V+G1NnzSAn7IfW0YF985bdks5WOKkDBhDXBTpsQRI3qi
         /IK47VbvGWEeNh6q7u6ozbAu/msg13MK8Fa2eImYhpHpN2fVcfZ6MqPObnIYtt7gBNUT
         3haw==
X-Gm-Message-State: AOAM531VGYVXwgRXvWO5o3ll069mg4vS6Q6zxpOoxEJRK4TZpGILneYj
        P+beQA2qyGbSosGsDt7ErEUibQ==
X-Google-Smtp-Source: ABdhPJwJtaC/+3L1bVkg9P8zv+anpCg9BvvGSgBVtWnX3lLVWENuhM7S6jL/vTi/ew8TMCXVE//XxA==
X-Received: by 2002:a17:90a:ca93:: with SMTP id y19mr7226022pjt.142.1627435813032;
        Tue, 27 Jul 2021 18:30:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r13sm5628761pgi.78.2021.07.27.18.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 18:30:12 -0700 (PDT)
Date:   Tue, 27 Jul 2021 18:30:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 33/64] lib: Introduce CONFIG_TEST_MEMCPY
Message-ID: <202107271829.CE9BADDB@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-34-keescook@chromium.org>
 <9827144a-dacf-61dc-d554-6c69434708de@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9827144a-dacf-61dc-d554-6c69434708de@acm.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 04:31:03PM -0700, Bart Van Assche wrote:
> On 7/27/21 1:58 PM, Kees Cook wrote:
> > +static int __init test_memcpy_init(void)
> > +{
> > +	int err = 0;
> > +
> > +	err |= test_memcpy();
> > +	err |= test_memmove();
> > +	err |= test_memset();
> > +
> > +	if (err) {
> > +		pr_warn("FAIL!\n");
> > +		err = -EINVAL;
> > +	} else {
> > +		pr_info("all tests passed\n");
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static void __exit test_memcpy_exit(void)
> > +{ }
> > +
> > +module_init(test_memcpy_init);
> > +module_exit(test_memcpy_exit);
> > +MODULE_LICENSE("GPL");
> 
> Has it been considered to implement this test using the Kunit framework?

Good point! I will see if that works here; it would make sense to make
this KUnit from the start.

-- 
Kees Cook

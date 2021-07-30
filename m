Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE63DBD34
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhG3QoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhG3QoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 12:44:07 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05A0C061796
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 09:44:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u16so3215048ple.2
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 09:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GyUcUuoM8BKbuKoLNn2u+7d0XlxZhH0DNdY0Zh2rhYM=;
        b=ZYvKVIonqBvgJBBAATOWKMJfg8hhtBXoHOTx/iDZ8PeyqX81+Jlea8xwKXsf8hLRfL
         cZu1unntwb1N1dPlv/zED5xJNy2wtv1RCybDlXePHHPimj/G0FREJ2I1N7CuPg+lBbXJ
         jeQKM02Svm4SC8aazygCKUYAW0jLhVCtX3l5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GyUcUuoM8BKbuKoLNn2u+7d0XlxZhH0DNdY0Zh2rhYM=;
        b=V4XAoTw6xOI5VwYDtC3cHgPFE3p5dIQcdbEMczMxdpSL+YWGIUAhPeXRBhgs4jLKme
         wBIvF9so1b2xLRZftu8OK1mE8lIQ5lEhIDcF7UnwCvxiaX5ggCnvEu+aJ7uxqI8u6MQ/
         XcO7PijLkScXo7hKLk3UQ48uuX9MmhPjV4UXaaD1jI0CZwaNbWPHXlxHen72dKS0jQNU
         YlqW+eoGGeioNskny7jO/s9BsHjb+PU4OwyNXyMV4v5HMQ/+2UtYbB9CbQ+tWgCL71n/
         AF2e5Jx3gEfeiOWLt/JiaL5RGuDcERelKpH7Fsu14Fb76jUgPtQ5FZ+1oaOmYblOufmK
         lVBg==
X-Gm-Message-State: AOAM531TCLOdogkjk4oeqb1GOCLmYNfHv7Y9kT5TxcyQwEDZM7oTj6+k
        /JVBrtb0PTr7jxB3rxxCM0Fq+w==
X-Google-Smtp-Source: ABdhPJxDpUEeHBq3Re7Vu5+5tlkejCoWFNrBHVi4jBAu2eZbQ1FOcFfN59r3+6EaNv+0Bo7SylpFyw==
X-Received: by 2002:aa7:9541:0:b029:32c:cefa:123f with SMTP id w1-20020aa795410000b029032ccefa123fmr3683021pfq.24.1627663442344;
        Fri, 30 Jul 2021 09:44:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y15sm2952160pfn.63.2021.07.30.09.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 09:44:01 -0700 (PDT)
Date:   Fri, 30 Jul 2021 09:44:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     dsterba@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <202107300937.C7016A82@keescook>
References: <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
 <20210728091434.GQ1931@kadam>
 <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
 <20210728213730.GR5047@suse.cz>
 <YQJDCw01gSp1d1/M@kroah.com>
 <20210729082039.GX25548@kadam>
 <202107291952.C08EAE039B@keescook>
 <20210730083845.GD5047@suse.cz>
 <20210730090054.GX1931@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730090054.GX1931@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 12:00:54PM +0300, Dan Carpenter wrote:
> On Fri, Jul 30, 2021 at 10:38:45AM +0200, David Sterba wrote:
> > Then is explicit memset the only reliable way accross all compiler
> > flavors and supported versions?
> > 
> 
> The = { } initializer works.  It's only when you start partially
> initializing the struct that it doesn't initialize holes.

No, partial works. It's when you _fully_ initialize the struct where the
padding doesn't get initialized. *sob*

struct foo {
	u8 flag;
	/* padding */
	void *ptr;
};

These are fine:

struct foo ok1 = { };
struct foo ok2 = { .flag = 7 };
struct foo ok3 = { .ptr = NULL };

This is not:

struct foo bad = { .flag = 7, .ptr = NULL };

(But, of course, it depends on padding size, compiler version, and
architecture. i.e. things remain unreliable.)

-- 
Kees Cook

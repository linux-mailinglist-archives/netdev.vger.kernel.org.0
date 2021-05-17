Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4325383B63
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhEQRiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhEQRiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:38:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A01C061573;
        Mon, 17 May 2021 10:36:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d11so7283560wrw.8;
        Mon, 17 May 2021 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=7XsYTUx1bd2TMLBzGLJMdAv8774GZAoLJjC4TPLuaiE=;
        b=hAI95AmEoPquzZm0RQNsHAvyYi3ps+FRa0T3uqSpNIyEqe30W6NP6MUWGtv6dd9tGO
         OVCfSkcdPwj9hMt7mIsTvql6WvP5FFWk6j5N3hAPqv2yaDWyORNFp6rThhOXHrUQQ8TA
         S+B+UvMefGprWPt4BxvUH39jRz9TLJCQbhAo/CXu5k2qN8KNEP67/ClzVwzpXzRbMk3n
         HEMap4DjS0ua8MYXSYzodqiBNgZTbgViS9yllUTCJiqy3w4kl04HohSQUlf+YcvfGoFV
         tKmCK8u4hlVhfFrk4OomxLtnWgjgFTiD42JlYNhKM0GC4gZljsCoUBrCm2j7t/q0D2/+
         Hyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=7XsYTUx1bd2TMLBzGLJMdAv8774GZAoLJjC4TPLuaiE=;
        b=jFeqiR2YkTrantVReGCcrLjI8E+B8GBu4B7yYbHMsr4ZM5E+LLt2hHFKRegR2CPkLl
         jpIwBA00QIdjuMzB7uSybNXeTmnSRZtcks+qXcCkAVH52sLYf5UJFizgPoShtLlbdAHd
         h/h1u5zgO5xmd2xUYctl6dDBodH3NuCHTxb8dXrlgRfqcKq9fOtREl12fQEMVcDYLSie
         f0qOTNfVlB15L6UYGiOljuPFM/kt5XiycrTdyTPiTaSs4fK271gfhiY7cA+DISu0eHPB
         P1Kkl9BGV1y5sBXMU19p4dhYXPO1mA3QKLjYQF4zqf2onGQ8cDDWiJBnDDOVeEjitvL6
         IAnQ==
X-Gm-Message-State: AOAM531AyztHtKqPPnEB2nnTa7LrUoSuIl4lQPMGc7tQEZ6rR37T4dyf
        2VvUq5h3GEc56cRoWxf6ar0=
X-Google-Smtp-Source: ABdhPJyTMCRrbZJtlGWzjFOP+iisuO5V0f43VIB3BybJky/mau5jTY9tY1T+msh+QRwo75w6j5rHug==
X-Received: by 2002:a5d:4b10:: with SMTP id v16mr922886wrq.259.1621273008861;
        Mon, 17 May 2021 10:36:48 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id g4sm15010689wmk.45.2021.05.17.10.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 10:36:48 -0700 (PDT)
Date:   Mon, 17 May 2021 19:36:46 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YKKprl2ukkR7Djv+@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
 <fcd869bc-50c8-8e31-73d4-3eb4034ff116@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcd869bc-50c8-8e31-73d4-3eb4034ff116@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 5/8/21 12:49 AM, Heiko Thiery wrote:
> > With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
> > open_by_handle_at() are introduced. But these function are not available
> > e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> > availability in the configure script and in case of absence do a direct
> > syscall.

> > Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> > Cc: Dmitry Yakunin <zeil@yandex-team.ru>
> > Cc: Petr Vorel <petr.vorel@gmail.com>
> > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > ---
> > v3:
> >  - use correct syscall number (thanks to Petr Vorel)
> >  - add #include <sys/syscall.h> (thanks to Petr Vorel)
> >  - remove bogus parameters (thanks to Petr Vorel)
> >  - fix #ifdef (thanks to Petr Vorel)
> >  - added Fixes tag (thanks to David Ahern)
> >  - build test with buildroot 2020.08.3 using uclibc 1.0.34

> > v2:
> >  - small correction to subject
> >  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
> >  - fix indentation in check function
> >  - removed empty lines (thanks to Petr Vorel)
> >  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
> >  - check only for name_to_handle_at (thanks to Petr Vorel)

> >  configure | 28 ++++++++++++++++++++++++++++
> >  lib/fs.c  | 25 +++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+)


> applied to iproute2-next.

Thanks a lot!

I guess, it'll be merged to regular iproute2 in next merge window (for 5.14).

Kind regards,
Petr

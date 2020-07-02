Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC92127AA
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgGBPVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbgGBPVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:21:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEEDC08C5E2
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 08:21:42 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc15so4209950pjb.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=85NgcoW6jBNBGz0tQzl+oqewL1I9o/iwYquf90s0iyI=;
        b=fz3Jh9EbW2QNq/2MyLiNywl+Bw+HpwfpGyCppJTlFpNOcSFS1TexJkrkG1UxqufMgU
         DTnt8qDgoR6kpc5Uov/N8ZFtF9gBkglTu3rbJlgEgXDnMffWLDd4jgcOStrGlPxU6l/S
         kAv+vOh2+5LMMHeltnDKRB/tSSiTCWUefTVYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=85NgcoW6jBNBGz0tQzl+oqewL1I9o/iwYquf90s0iyI=;
        b=Me/bFZZfH6OI7iH2KJ+g6/dsr19XmgUyNwC8W2bZA2qatLnACIW8tsR9I5X7Zat/aG
         E/jvGuBFuZiLg/el/gZc6wTjuASFIbmxqUopbLimXrHklq8O8fVG66kd1QXCyIEWdfiR
         j6PWnWs95MTExWfh9Y1qCU7oh7QtczD1lqXZtQ3iNkTSkAnOl1WgiVHRsn+Ov/fo2e36
         i1sWWcWdV2ZJpiDrxk+x2QvGpBNocXVpuLp/g+s5baRBqfA7Hy8acMXwDlaumhEU5KrP
         QYl0czinlKcdPsp0WnsJJcknK9HDbNXH5R4oT1M3MPgRTbVa2hQL5Vn2tHogxXIeDNgw
         unzQ==
X-Gm-Message-State: AOAM530ogFlOGLbD1tvshI9ybP6q/CCCHDzwU7CCcpV+YIV3UiFTky8c
        UwBPzKQG3+iAAQ36j7yqts1Ypw==
X-Google-Smtp-Source: ABdhPJyPnF33faJF3QEw2ElnpTvwp44zuiTBz6WWqS/hEjfBUUANHOACCnQyGoZR2gBcK7ir4/OsKg==
X-Received: by 2002:a17:90a:cb0e:: with SMTP id z14mr31267430pjt.140.1593703302136;
        Thu, 02 Jul 2020 08:21:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c19sm8151174pjs.11.2020.07.02.08.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 08:21:41 -0700 (PDT)
Date:   Thu, 2 Jul 2020 08:21:40 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2 08/16] spi: davinci: Remove uninitialized_var() usage
Message-ID: <202007020819.318824DA@keescook>
References: <20200620033007.1444705-1-keescook@chromium.org>
 <20200620033007.1444705-9-keescook@chromium.org>
 <20200701203920.GC3776@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701203920.GC3776@sirena.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 09:39:20PM +0100, Mark Brown wrote:
> On Fri, Jun 19, 2020 at 08:29:59PM -0700, Kees Cook wrote:
> > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > (or can in the future), and suppresses unrelated compiler warnings (e.g.
> > "unused variable"). If the compiler thinks it is uninitialized, either
> > simply initialize the variable or make compiler changes. As a precursor
> > to removing[2] this[3] macro[4], just remove this variable since it was
> > actually unused:
> 
> Please copy maintainers on patches :(

Hi! Sorry about that; the CC list was giant, so I had opted for using
subsystem mailing lists where possible.

> Acked-by: Mark Brown <broonie@kernel.org>

Thanks!

-- 
Kees Cook

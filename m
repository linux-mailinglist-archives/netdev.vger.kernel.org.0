Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6DE29FC20
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 04:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgJ3DWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 23:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJ3DWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 23:22:52 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AB1C0613CF;
        Thu, 29 Oct 2020 20:22:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so4013416pgb.10;
        Thu, 29 Oct 2020 20:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9STGJQi8a1xzdZYEEhl0ksIPPGpWDWskcupD6CiT7K0=;
        b=LveUchPbVi1koQW7bKPxDDHOqgNcdw++j1kJJT/288hBHAcCW9eTY/N6DKotpp6I5d
         4kwKicvd8PviMhSE1oo7tq9EgnDV/KUXiaRtGdk35u7nCC/AsVeoJEWlg+aKakP7Yxay
         U6QLpa3KZdUQWdTwtsz+Is2q0+jbVzFQ4lXSwigNsWkcJltZ/6Aln9NxiU6H/GiN/9GI
         xSzKhbPoQXY+m2ilqmg6gM96Nir9msMKNpXQa3UkLy9OtopOZE+xuCCTgCg/gmVB67hr
         zWCJH2xAX94cNiJYCLoRh3TAcMA0QUN1hTKArLNFjMImgMnkK+zKI3PolyFpGnSbgyI8
         lUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9STGJQi8a1xzdZYEEhl0ksIPPGpWDWskcupD6CiT7K0=;
        b=oTo5j6UFckwKMSbBMvb9wIT6dtT4nhNEwOrG0wdwOYz+HKS6ZkmrWuP/Xhsad2y5m0
         IfMyoUiF+d32oDqFjOz6otxSJlAvQT5Lkw+33lkkgcLMYOVgSOUBwFskkPOFCBvmJWtm
         4c5okXbBMn47WDggu0c6KUA/CLoLAqA+fI9PsljHCR4+oShNPxO4Ax4MHazlUMkmeYZL
         cyRhJCWs9Uh/bG8mMiXlhzeQGlcdNJXUSt0RNg0JvVPalLJ8mDC2UYikTQxpEgWtfgik
         7roMJUiPrNmEz1Ckj6/zB2833xZHhNyHl67LN+0k8azAicvxi0pjfBNw6QwV+xLe2YOv
         0kCg==
X-Gm-Message-State: AOAM5329ZdLtDqkeNKmKhCrJpq0kx1bgIhJ+FHsYkEB0NHTUK1OJcdeV
        xXH4HOPn4QeYVaIACO5WCIU=
X-Google-Smtp-Source: ABdhPJzQgMOq4ZzNF7YAn7j1F6iUJAwbfZIdjJV25dsV4gdUa17Loyaj4ME/CxIUiGaUuXS0fRaUCw==
X-Received: by 2002:a17:90a:f293:: with SMTP id fs19mr312500pjb.41.1604028172052;
        Thu, 29 Oct 2020 20:22:52 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:71de])
        by smtp.gmail.com with ESMTPSA id q123sm4370329pfq.56.2020.10.29.20.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 20:22:50 -0700 (PDT)
Date:   Thu, 29 Oct 2020 20:22:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize))
 to disable GCSE
Message-ID: <20201030032247.twch6rvnk6ql3zjb@ast-mbp.dhcp.thefacebook.com>
References: <20201028171506.15682-1-ardb@kernel.org>
 <20201028171506.15682-2-ardb@kernel.org>
 <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com>
 <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com>
 <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com>
 <20201028232001.pp7erdwft7oyt2xm@ast-mbp.dhcp.thefacebook.com>
 <CAKwvOd=Zrza=i54_=H3n2HkmMhg9EJ3Wy0kR5AXTSqBowsQV5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=Zrza=i54_=H3n2HkmMhg9EJ3Wy0kR5AXTSqBowsQV5g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 05:28:11PM -0700, Nick Desaulniers wrote:
> 
> We already know that -fno-asynchronous-unwind-tables get dropped,
> hence this patch.  

On arm64 only. Not on x86

> And we know -fomit-frame-pointer or
> -fno-omit-frame-pointer I guess gets dropped, hence your ask.  

yep. that one is bugged.

> We might not know the full extent which other flags get dropped with the
> optimize attribute, but I'd argue that my list above can all result in
> pretty bad bugs when accidentally omitted (ok, maybe not -fshort-wchar
> or -fmacro-prefix-map, idk what those do) or when mixed with code that

true.
Few month back I've checked that strict-aliasing and no-common flags
from your list are not dropped by this attr in gcc [6789].
I've also checked that no-red-zone and model=kernel preserved as well.

> has different values those flags control.  Searching GCC's bug tracker
> for `__attribute__((optimize` turns up plenty of reports to make me
> think this attribute maybe doesn't work the way folks suspect or
> intend: https://gcc.gnu.org/bugzilla/buglist.cgi?quicksearch=__attribute__%28%28optimize&list_id=283390.

There is a risk.
Is it a footgun? Sure.
Yet. gcc testsuite is using __attribute__((optimize)).
And some of these tests were added _after_ offical gcc doc said that this
attribute is broken.
imo it's like 'beware of the dog' sign.

> There's plenty of folks arguing against the use of the optimize
> attribute in favor of the command line flag.  I urge you to please
> reconsider the request.

ok. Applied this first patch to bpf tree and will get it to Linus soon.
Second patch that is splitting interpreter out because of this mess
is dropped. The effect of gcse on performance is questionable.
iirc some interpreters used to do -fno-gcse to gain performance.

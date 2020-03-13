Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CBA185241
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgCMXVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:21:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46428 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgCMXVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 19:21:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id y30so5864391pga.13
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 16:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A95DgrDqMmOsmX5x3yg554+ZL48y919uezXM/55G5PU=;
        b=Tm01rBRAW0ZFBG+QC4kIx4sT7VtjTtOvdeqqnUOMtr5fk7X/XRvK21M80wMnEBjSTz
         BeMbiTmLzTQPQvLBlbsDT0b1iSbaQGYJ2ocz1LrmI6XmVtQvFJBr0EDFI8CJ8bus+5Ny
         suzlLI6wmotK36hsxN0IVBQDYzBZAdrTqJE78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A95DgrDqMmOsmX5x3yg554+ZL48y919uezXM/55G5PU=;
        b=llU6gnhMXHbf3+H9l4LMz/MHHxi7BM3umRWFbrO4Z5Oi8CudjxiK5FT7eH5u0JJ3kt
         +zLGl4+W/r5ngl1XZI/p1rJ0BOK+HpMJBoFSULUP7vD1da7x7tiaslLeqt3GnNWmuFAI
         ij3gOj7aWwvx1JO/XXUpKdDPIFvO2NGz91T3qt1tijKpAdHW3F53IiOUoiFwhuNyOs1d
         lGTTZUQWIZkk1hyVb5Cl0UuVavHeb5MdMjOpiHGcbZEj3p5+K6CdnBP2+97BWqgrRMsD
         ks4emvcjiWADl00kucY4xUunQ3sUDaa0JRmKJxu7WQj/XZ+whla22vQiCAsFSBm0re+i
         dQhQ==
X-Gm-Message-State: ANhLgQ1u5zw8YApdvD/F0WrnoJxTYRuBkVGD6sjh8qYtkGiVnUOQMROX
        2iZdP1gC9a5fxu/Cf9DPUkkY5Q==
X-Google-Smtp-Source: ADFU+vtxfTt5P7ljGv+yhPJLm1Iy63R/IokK5uJEJb3cc78hlcgtgq5gd4+p5OZ4CkPf5ydgQepQwg==
X-Received: by 2002:aa7:9f47:: with SMTP id h7mr14276455pfr.292.1584141677871;
        Fri, 13 Mar 2020 16:21:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 3sm13216636pjg.27.2020.03.13.16.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 16:21:16 -0700 (PDT)
Date:   Fri, 13 Mar 2020 16:21:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/5] selftests/seccomp: use correct FIXTURE macro
Message-ID: <202003131620.651F12798@keescook>
References: <20200313031752.2332565-1-kuba@kernel.org>
 <20200313031752.2332565-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313031752.2332565-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 08:17:48PM -0700, Jakub Kicinski wrote:
> Quoting kdoc:
> 
> FIXTURE_DATA:
>  * This call may be used when the type of the fixture data
>  * is needed.  In general, this should not be needed unless
>  * the *self* is being passed to a helper directly.
> 
> FIXTURE:
>  * Defines the data provided to TEST_F()-defined tests as *self*.  It should be
>  * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
> 
> seccomp should use FIXTURE to declare types.

Yup, I ran into this while working on a totally separate series. I sent
a stand-alone patch for this already. (It's identical to this one.)
Shuah can take either one. :)

> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index ee1b727ede04..7bf82fb07f67 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -909,7 +909,7 @@ TEST(ERRNO_order)
>  	EXPECT_EQ(12, errno);
>  }
>  
> -FIXTURE_DATA(TRAP) {
> +FIXTURE(TRAP) {
>  	struct sock_fprog prog;
>  };
>  
> @@ -1020,7 +1020,7 @@ TEST_F(TRAP, handler)
>  	EXPECT_NE(0, (unsigned long)sigsys->_call_addr);
>  }
>  
> -FIXTURE_DATA(precedence) {
> +FIXTURE(precedence) {
>  	struct sock_fprog allow;
>  	struct sock_fprog log;
>  	struct sock_fprog trace;
> @@ -1509,7 +1509,7 @@ void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int status,
>  	EXPECT_EQ(0, ret);
>  }
>  
> -FIXTURE_DATA(TRACE_poke) {
> +FIXTURE(TRACE_poke) {
>  	struct sock_fprog prog;
>  	pid_t tracer;
>  	long poked;
> @@ -1817,7 +1817,7 @@ void tracer_ptrace(struct __test_metadata *_metadata, pid_t tracee,
>  		change_syscall(_metadata, tracee, -1, -ESRCH);
>  }
>  
> -FIXTURE_DATA(TRACE_syscall) {
> +FIXTURE(TRACE_syscall) {
>  	struct sock_fprog prog;
>  	pid_t tracer, mytid, mypid, parent;
>  };
> @@ -2321,7 +2321,7 @@ struct tsync_sibling {
>  		}							\
>  	} while (0)
>  
> -FIXTURE_DATA(TSYNC) {
> +FIXTURE(TSYNC) {
>  	struct sock_fprog root_prog, apply_prog;
>  	struct tsync_sibling sibling[TSYNC_SIBLINGS];
>  	sem_t started;
> -- 
> 2.24.1
> 

-- 
Kees Cook

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599711A4B24
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 22:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDJU3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 16:29:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46091 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgDJU3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 16:29:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id x2so993755plv.13
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 13:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HODoK6E8L/CuOaFGCg2iAC1rPoU/icSNRuY7o7sO8Ws=;
        b=m9o4HrWYGaPjCrKKUVeHWee1Rn5fs9FN8wu6WoU+bDI6noVqb5hinEVQokCBtuQJfT
         fLUO9wsv1VCMDI85blYzteeMqCT3bnQlg7kLwecAI+coZAI0xGeYB+rFd43a65241FI8
         E9vNhsauJMCTPS6vDrZki02VIpPoRwqpUc+7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HODoK6E8L/CuOaFGCg2iAC1rPoU/icSNRuY7o7sO8Ws=;
        b=hy4VXWwHqNXgDolsM/zKLrtNEiysMARFsXB5uJ5BbJ+5n5G4+2/5lYzdYHr4dufOIV
         cSbmMuHMJXryGJoZe62nBfvmNSnzpXt6Uj14SFN6SjMdgpJR+IdbErRr4adc9Fbdbsyw
         S0emlWxiuG1xQnsCu9sxycL1I2djt9rzVD6xuK6vas3nElBCFpfQi8RouoJzbZo72P01
         Dv8BInxP+D3+NHLKsSL3mCF3jJUVk8iCvHrvpO/wH4ZjzoN/kyAs5xdBgXVp+xNpoYP9
         ssjv9lWVQy+j7VcDOiBqaI7RE7A7XEt5rnVDqQYSTfZ4iGfD8k0PcdWUMLxjfu5uxTmx
         +Wvw==
X-Gm-Message-State: AGi0PuZmiOrXBj8MPQjVtmKQSMRFJfSjbY+qr3HHqaED3vncDLjJN/AV
        T166UNv+563oeAN5Y02D9Gu06w==
X-Google-Smtp-Source: APiQypKD8wYXfs/7EzdxX7L5G4cmdiNC+Ks7MIPw8kTtJLh6/UJnCEZ3fylDcudFSFjvfjyqm97q8A==
X-Received: by 2002:a17:902:bd45:: with SMTP id b5mr6008293plx.185.1586550545406;
        Fri, 10 Apr 2020 13:29:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u26sm2240496pga.3.2020.04.10.13.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 13:29:04 -0700 (PDT)
Date:   Fri, 10 Apr 2020 13:29:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org, shuah@kernel.org
Subject: Re: [PATCH] selftests/seccomp: allow clock_nanosleep instead of
 nanosleep
Message-ID: <202004101328.075568852D@keescook>
References: <20200408235753.8566-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408235753.8566-1-cascardo@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 08:57:53PM -0300, Thadeu Lima de Souza Cascardo wrote:
> glibc 2.31 calls clock_nanosleep when its nanosleep function is used. So
> the restart_syscall fails after that. In order to deal with it, we trace
> clock_nanosleep and nanosleep. Then we check for either.
> 
> This works just fine on systems with both glibc 2.30 and glibc 2.31,
> whereas it failed before on a system with glibc 2.31.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Actually, sorry, this should go via Shuah's tree. :) Shuah, do you have
anything going Linus's way already for -rc2?

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index 89fb3e0b552e..c0aa46ce14f6 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -2803,12 +2803,13 @@ TEST(syscall_restart)
>  			 offsetof(struct seccomp_data, nr)),
>  
>  #ifdef __NR_sigreturn
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 6, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 7, 0),
>  #endif
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 5, 0),
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 4, 0),
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 3, 0),
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 4, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 6, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 5, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 4, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 5, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_clock_nanosleep, 4, 0),
>  		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_restart_syscall, 4, 0),
>  
>  		/* Allow __NR_write for easy logging. */
> @@ -2895,7 +2896,8 @@ TEST(syscall_restart)
>  	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
>  	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
>  	ASSERT_EQ(0x100, msg);
> -	EXPECT_EQ(__NR_nanosleep, get_syscall(_metadata, child_pid));
> +	ret = get_syscall(_metadata, child_pid);
> +	EXPECT_TRUE(ret == __NR_nanosleep || ret == __NR_clock_nanosleep);
>  
>  	/* Might as well check siginfo for sanity while we're here. */
>  	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
> -- 
> 2.20.1
> 

-- 
Kees Cook

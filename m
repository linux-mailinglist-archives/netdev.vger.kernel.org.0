Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382CE2A6EC8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 21:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgKDUdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 15:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732027AbgKDUdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 15:33:50 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF77221E2;
        Wed,  4 Nov 2020 20:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604522029;
        bh=eqryOwvWfKvR3/KbsIRgMeNj6AdkLgoFQKRZP0OIy74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zmfGPfjJV/mSi+//pJ1ML1C9xWr/RpmyKnCLbcuDp8IaVorPKhzS+n5yDmu7QkzLE
         lclUfwisl0ZPw4O3MyuRVCodfO2RCLohUd7x0M3fKtaKWWt4dHR7CcKvnv8io4XKSU
         KuLxhunZxx4bxZ0kpYfZFuz+sMmP+hCveDCMH1l0=
Date:   Wed, 4 Nov 2020 22:33:39 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        Chen Yu <yu.chen.surf@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] compiler-clang: remove version check for BPF Tracing
Message-ID: <20201104203339.GA692084@kernel.org>
References: <20201104191052.390657-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104191052.390657-1-ndesaulniers@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:10:51AM -0800, Nick Desaulniers wrote:
> bpftrace parses the kernel headers and uses Clang under the hood. Remove
> the version check when __BPF_TRACING__ is defined (as bpftrace does) so
> that this tool can continue to parse kernel headers, even with older
> clang sources.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: commit 1f7a44f63e6c ("compiler-clang: add build check for clang 10.0.1")
> Reported-by: Chen Yu <yu.chen.surf@gmail.com>
> Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---

Thank you, resolved my issue.

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

>  include/linux/compiler-clang.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index dd7233c48bf3..98cff1b4b088 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -8,8 +8,10 @@
>  		     + __clang_patchlevel__)
>  
>  #if CLANG_VERSION < 100001
> +#ifndef __BPF_TRACING__
>  # error Sorry, your version of Clang is too old - please use 10.0.1 or newer.
>  #endif
> +#endif
>  
>  /* Compiler specific definitions for Clang compiler */
>  
> -- 
> 2.29.1.341.ge80a0c044ae-goog
> 
> 

/Jarkko

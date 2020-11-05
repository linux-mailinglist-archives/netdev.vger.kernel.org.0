Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1482A741C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387912AbgKEA4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgKEA4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:56:18 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD86C0613CF;
        Wed,  4 Nov 2020 16:56:16 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id 12so319910qkl.8;
        Wed, 04 Nov 2020 16:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=76+46/j8d+HhUpqLdqtrqj06kMZC9lIAszaftzrzrbA=;
        b=cCzrPQyEWo7u8s7NeF891HqdMDHyzf30LEvc6NJiR74N7Hs6dWqvJGrOKhOBI5E4/o
         IIUiN+USEvzVZcuT+LuG8quJqG0c6bJpx0QJaDl05Dd8fwPA6WnvMM4b1yAOeeup2pCj
         +M8RTZxT6A78NHzsxgDgyDWu4lITnyjl3CYrG0OQvrnQ7cDp+68oTtLyGfdpcn+NqzDt
         X/wQztuwyCPax/iPQEDlJMhHLJEWNAvvwqMaZE+xQwxF+wKhL/uAJXmKHPAAkYJidmxg
         KEnMvs1YJpHgZw9E30xt1obeFvWAEptcvnT8JS+hZ7ugkoRRcP1eoh/dWQVHam2VEVdH
         zkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=76+46/j8d+HhUpqLdqtrqj06kMZC9lIAszaftzrzrbA=;
        b=cmpH3hmSqB9WB6471wzSKqYw0H0MFXE1szZnP4g928hw8F0pPK16yAAXZUoYaf8ZeB
         ZI79qvyXqDzpTTWXjEU5VZgtjw/NDuAH3WDYJztsfyazAJ70gbJaTI8uFEOfonoyH7Mm
         4IkUthwjp6ei22zSwXmU3/QAA8GROrhAPNOpzyyrBIf9VMYL64pENtzTkdU1t28t3L3L
         Yydi5DYsP21T2f6KA79UD/Ua5fS7QoWIdFHjqo2/GZo9vSySGe3xuHmHPXsPvcYokgso
         x4VJhdMyJuhsYAgAX7uKV6ctWH3BxpR4QTy+pEn6qhN7dCpnihKxA6ovewTW8EnfjjtR
         W5Jg==
X-Gm-Message-State: AOAM531jxqUHWGGaJb1NkMmFJYhaIVxFdjyqvXmn4dqYOtJc+K7At/Lj
        E7bak8v85eMwJ67QmDe6/DI=
X-Google-Smtp-Source: ABdhPJxVkmSiQ9WCIF/VhMI7BfIsXAtPjTGcBrfOpLZax/EaPn7jdHV8n3BSlkhf+0NXyyPzpLJ21Q==
X-Received: by 2002:a37:e0e:: with SMTP id 14mr859793qko.455.1604537775951;
        Wed, 04 Nov 2020 16:56:15 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id n3sm1403764qta.10.2020.11.04.16.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 16:56:15 -0800 (PST)
Date:   Wed, 4 Nov 2020 17:56:13 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        Chen Yu <yu.chen.surf@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
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
Message-ID: <20201105005613.GA1840301@ubuntu-m3-large-x86>
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

Acked-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
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

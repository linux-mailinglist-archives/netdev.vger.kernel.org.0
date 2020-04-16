Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7721AD1BB
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgDPVLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725928AbgDPVLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 17:11:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E961C061A0C;
        Thu, 16 Apr 2020 14:11:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id h11so78485plr.11;
        Thu, 16 Apr 2020 14:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JgNWM1aYnGbkb2X8HnRnhj6nIzDH+KIfcoTiCAnJHzI=;
        b=RPEFx/idDUKN6eVizbqJIbc+HHwuAjKs7XkEg0SjHdtj8FSseypSBy0sbMg1tP5sSY
         4XnMz4dt8yCccFuO7xtcOOJSKf5NjtHQo/BowQIVqx7LqF68Rst3aA8RgsxHm7qLwXg2
         r0jAHaxyTcqGyUkX1joH9biRrue/Vyj7DyRYhl0LqeEmqHQB8xJ29Kg38+9gT67i++Dv
         tvyyE34V2hqp9CiDAelnJBBwwybhIt3dDA+98vjBD1C9aIC61Nz/w5mJRkhUENUHEzn0
         NkoBnw2EM5sdmmrY6jUe/PieMpeWcM+T5PjqJbtv4O15QSRJkiDU9+SEBFN/o8Ve/KVK
         9OBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JgNWM1aYnGbkb2X8HnRnhj6nIzDH+KIfcoTiCAnJHzI=;
        b=OHWF+BgSqF2zwkBHYQyPhGMx+5SnEDPGtUkupgoQAZjJXBNe0GYmcL8p+L3xpWpzbR
         vLSsQFPzKfN5a7/E40VNnQuBkF91xvXTEcdDicHIv3LoUVQHYoBK65MaIfz/mh77Uewh
         C4FuFYlN4Pxmlt3JzBy93ksVF890mXR6vtolM+STPxOzUYOyfkpDFNGGb1BeXDCKKNt+
         GrIXVGIO93UebshSoLh2ZO4CftGlkaV8kLU9OJKQV0P9g4wNQHU/SxLKW5qoqGqlEvtT
         m9+ePJ/h86gu7K9QkcX24l+P4AJIF4ZUPps94Ohg9XelW1etiU8RFDZPscYzJHZsCeDM
         BbJA==
X-Gm-Message-State: AGi0PuYyIcEb5tr6SJVq9LPNh3kEIH5Gpv/gQgpivEZhahIYsK5hmFWt
        QD7Sol5q6SghgtukdMVwWtc=
X-Google-Smtp-Source: APiQypKY7wJwCdg2nMNcpXBviUzXtYvdLHd99rlexcFiqa6y/n90IUcfAIqLH5pFyTBnz3bsxkYfLg==
X-Received: by 2002:a17:90a:25cb:: with SMTP id k69mr267975pje.93.1587071479736;
        Thu, 16 Apr 2020 14:11:19 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:fff8])
        by smtp.gmail.com with ESMTPSA id r13sm16719066pgj.9.2020.04.16.14.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 14:11:19 -0700 (PDT)
Date:   Thu, 16 Apr 2020 14:11:16 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jann Horn <jannh@google.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: Use pointer type whitelist for XADD
Message-ID: <20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com>
References: <20200415204743.206086-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415204743.206086-1-jannh@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 10:47:43PM +0200, Jann Horn wrote:
> At the moment, check_xadd() uses a blacklist to decide whether a given
> pointer type should be usable with the XADD instruction. Out of all the
> pointer types that check_mem_access() accepts, only four are currently let
> through by check_xadd():
> 
> PTR_TO_MAP_VALUE
> PTR_TO_CTX           rejected
> PTR_TO_STACK
> PTR_TO_PACKET        rejected
> PTR_TO_PACKET_META   rejected
> PTR_TO_FLOW_KEYS     rejected
> PTR_TO_SOCKET        rejected
> PTR_TO_SOCK_COMMON   rejected
> PTR_TO_TCP_SOCK      rejected
> PTR_TO_XDP_SOCK      rejected
> PTR_TO_TP_BUFFER
> PTR_TO_BTF_ID
> 
> Looking at the currently permitted ones:
> 
>  - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
>  - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
>    the BPF stack. It also causes confusion further down, because the first
>    check_mem_access() won't check whether the stack slot being read from is
>    STACK_SPILL and the second check_mem_access() assumes in
>    check_stack_write() that the value being written is a normal scalar.
>    This means that unprivileged users can leak kernel pointers.
>  - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
>  - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
>    tries to verify XADD on such memory, the first check_ptr_to_btf_access()
>    invocation gets confused by value_regno not being a valid array index
>    and writes to out-of-bounds memory.

> Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't make
> sense, and is sometimes broken on top of that.
> 
> Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> I'm just sending this on the public list, since the worst-case impact for
> non-root users is leaking kernel pointers to userspace. In a context where
> you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
> effective at the moment anyway.
> 
> This breaks ten unit tests that assume that XADD is possible on the stack,
> and I'm not sure how all of them should be fixed up; I'd appreciate it if
> someone else could figure out how to fix them. I think some of them might
> be using XADD to cast pointers to numbers, or something like that? But I'm
> not sure.
> 
> Or is XADD on the stack actually something you want to support for some
> reason, meaning that that part would have to be fixed differently?

yeah. 'doesnt make sense' is relative.
I prefer to fix the issues instead of disabling them.
xadd to PTR_TO_STACK, PTR_TO_TP_BUFFER, PTR_TO_BTF_ID should all work
because they are direct pointers to objects.
Unlike pointer to ctx and flow_key that will be rewritten and are not
direct pointers.

Short term I think it's fine to disable PTR_TO_TP_BUFFER because
prog breakage is unlikely (if it's actually broken which I'm not sure yet).
But PTR_TO_BTF_ID and PTR_TO_STACK should be fixed.
The former could be used in bpf-tcp-cc progs. I don't think it is now,
but it's certainly conceivable.
PTR_TO_STACK should continue to work because tests are using it.
'but stack has no concurrency' is not an excuse to break tests.

Also I don't understand why you're saying that PTR_TO_STACK xadd is leaking.
The first check_mem_access() will check for STACK_SPILL afaics.

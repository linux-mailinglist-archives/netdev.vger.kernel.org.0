Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E6F295512
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 01:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507080AbgJUXTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 19:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507075AbgJUXTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 19:19:10 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F7DC0613CE;
        Wed, 21 Oct 2020 16:19:10 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h196so3229925ybg.4;
        Wed, 21 Oct 2020 16:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ar6jrRsq8Jc9wwIORfLIFd8TWz+FT+7hcaKCO2a0axg=;
        b=Bht8XCzLsW9GF1oOUNGUzNfNEfuo0C/UqZS9GNUTTcV0jqdPbrCB4l4Bhwb29hqczb
         fwMxj6ukKrz/aE3JskJJFnRuSlcgZBsThy//MBFKNovno+8GcA2ku7ZWFhxDsFFQTeDp
         XkgtGmMPG+a1zFiMLfHBuyKG2zSbIbU+TCzBIPL5EJDtHeZKjq9RijhZKUJlxNndrUbD
         Kk9FutgdLx3TYxYMDaB24hLJotjdOhfKi8y3d43FaZ26+Qny6n1TzNYGXALToN/EAqiY
         aU/RO+JJiA2fYc4D59AkKb5Go3MnLDSoJZn25GVzfE/BpmozLC6VMHN3Mz9Byv0gYhQ0
         VWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ar6jrRsq8Jc9wwIORfLIFd8TWz+FT+7hcaKCO2a0axg=;
        b=VzPtl+PE1wYtW1xrJt7EDceJe2b2s5gHhd65QBUrWYcjQ9asH4YDiJ/IaHpEhJgKw4
         aXdSvUfkwshRYgfQ9T64Uqt7WW1j/Z4PwBp/7g8UF7WxOz+uG8iVzpbUJbya+ycX6DDo
         gf6obOyTeqFWYcrf0aOBRCrkpkmFdOsawnZyo5hlCYcLAdROm2eqMTJLR7iGI+QvBCbS
         C0Wb98hV4qLb1He/5/ptKQk1/EHc8adJRCVrhMsIDVOqeaE6xPzQ9lXnBQ8ul5+7I1sl
         DYxT8YruY7S2fzBEEQG3LvXnutEuO2L1OgEmRR6A38Lp7rrAm7JOml9qO9gChs1obkVS
         xGWA==
X-Gm-Message-State: AOAM530i1huX40u58QwyAkEjkf9zk5IU42gZ2u+1dYK55SAF9gmt92ri
        yr6htWXuY6mO8FJZ/7EJdsNY16GC5qfZ0S6pQbs=
X-Google-Smtp-Source: ABdhPJz+xR4Ocp6YRAtM17TpeO9OpSvhKGCP2Ynz7BNf3AoTKEBKoq9YfbLmF14Mim7YbsN5/9F4R5svw0wQadD+3FI=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr8878401ybl.347.1603322349082;
 Wed, 21 Oct 2020 16:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201021203257.26223-1-daniel@iogearbox.net>
In-Reply-To: <20201021203257.26223-1-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Oct 2020 16:18:58 -0700
Message-ID: <CAEf4Bzbvhv6v0X6w50N4LozMH5vvrHO7M776TyEO53iYsccOgg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, libbpf: guard bpf inline asm from bpf_tail_call_static
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Yaniv Agman <yanivagman@gmail.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 1:33 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Yaniv reported a compilation error after pulling latest libbpf:
>
>   [...]
>   ../libbpf/src/root/usr/include/bpf/bpf_helpers.h:99:10: error:
>   unknown register name 'r0' in asm
>                      : "r0", "r1", "r2", "r3", "r4", "r5");
>   [...]
>
> The issue got triggered given Yaniv was compiling tracing programs with native
> target (e.g. x86) instead of BPF target, hence no BTF generated vmlinux.h nor
> CO-RE used, and later llc with -march=bpf was invoked to compile from LLVM IR
> to BPF object file. Given that clang was expecting x86 inline asm and not BPF
> one the error complained that these regs don't exist on the former.
>
> Guard bpf_tail_call_static() with defined(__bpf__) where BPF inline asm is valid
> to use. BPF tracing programs on more modern kernels use BPF target anyway and
> thus the bpf_tail_call_static() function will be available for them. BPF inline
> asm is supported since clang 7 (clang <= 6 otherwise throws same above error),
> and __bpf_unreachable() since clang 8, therefore include the latter condition
> in order to prevent compilation errors for older clang versions. Given even an
> old Ubuntu 18.04 LTS has official LLVM packages all the way up to llvm-10, I did
> not bother to special case the __bpf_unreachable() inside bpf_tail_call_static()
> further.
>
> Fixes: 0e9f6841f664 ("bpf, libbpf: Add bpf_tail_call_static helper for bpf programs")
> Reported-by: Yaniv Agman <yanivagman@gmail.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Link: https://lore.kernel.org/bpf/CAMy7=ZUk08w5Gc2Z-EKi4JFtuUCaZYmE4yzhJjrExXpYKR4L8w@mail.gmail.com
> ---

LGTM!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/bpf_helpers.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 2bdb7d6dbad2..72b251110c4d 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -72,6 +72,7 @@
>  /*
>   * Helper function to perform a tail call with a constant/immediate map slot.
>   */
> +#if __clang_major__ >= 8 && defined(__bpf__)
>  static __always_inline void
>  bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
>  {
> @@ -98,6 +99,7 @@ bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
>                      :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
>                      : "r0", "r1", "r2", "r3", "r4", "r5");
>  }
> +#endif
>
>  /*
>   * Helper structure used by eBPF C program
> --
> 2.17.1
>

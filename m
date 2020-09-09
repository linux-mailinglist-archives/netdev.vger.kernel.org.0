Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A681B2635BE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgIISS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:18:54 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7473BC061573;
        Wed,  9 Sep 2020 11:18:54 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id p81so2354804ybc.12;
        Wed, 09 Sep 2020 11:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHN9J8vO/6FG0Tu/210yPV41VNHXVErg1oo0rjDScZM=;
        b=QlDKxfyFTgAqgjZz9oE+qH4hvikVkrhMa1kTKYuCqNuEfoEBRD87s5I0MurDMMxA6G
         NA3H2cIk/e8Su8tKDc0pOdndLJZHKvEiiDLfhiRoLEhKHZe2OLdExm6X/8jOUC8mIKEj
         KF0k9wnNZ3BvyPNAD5fpVaL7SjQIMwmnTz/vi0nAUboFfWO8UF0pWvECLhxvWVrsonAA
         8+VWgiVVPfuFkBDbbAVn3eHLqYOAuIOncFXvjqBXbjxLQJv1E+GGd7pDE0RvEuiToDpX
         ZVtBUEkFrR2Fj37CQQIwCa68OgDhIf+QfW9oumoRVThpV9bDthp0GDfhgbFFpUQmZQK/
         Mveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHN9J8vO/6FG0Tu/210yPV41VNHXVErg1oo0rjDScZM=;
        b=Cv7nLZn/vPDbnCjz7jMBdkwqq7CmJfpmPEKE0/4USdyG5s4nxVtMBSUx6OHYK7+tg3
         Y4xsPlSU2yOBC8FDIQVCme2yFeoGUWEkAQCvm/ii0NOSXQnHcdC2hc4SbaYTwgFBeYox
         3c/G7yngmrPhQp26EzFIzzw8K2I7Po8QD91ej7Rm/I5QGtG+AuveBKJH9vdGNLUNPQCh
         ghwTldT5IECkqkvLJ/m7xpLzr/fVOPa6fFB8BqKm1iNnJ9R0hkT/tdyrIzdqOjHLFS+L
         Qr+I3ZqgZO6qouYaVV7P/OiHND8rlJbGbYUj/EEsYRWcvO8loyOJwS0U2HHQYWtSvsVC
         YgLA==
X-Gm-Message-State: AOAM53204FViUxJGz9BkQmmgq6+WOf3TBkVYCjD0kVk1FLR4teulllI4
        ND9XCwBR3AbYkxNQ2rS27khA95mw6RlPhUyYcy0=
X-Google-Smtp-Source: ABdhPJzcVwBJM0cgfTn8gpFZmRXQppO4ULnkfP9+z0eBxUVJiLRrFOBGPoH3hCfNhFwV/WauPLdV3s2mj//sca7HJk4=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr7393134ybg.425.1599675533578;
 Wed, 09 Sep 2020 11:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200909171542.3673449-1-yhs@fb.com>
In-Reply-To: <20200909171542.3673449-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 11:18:42 -0700
Message-ID: <CAEf4Bza_1Q1Ym513JN4aDEunC49BaBHigJBKmj6N6snbChfwzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: fix test_sysctl_loop{1,2}
 failure due to clang change
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 10:16 AM Yonghong Song <yhs@fb.com> wrote:
>
> Andrii reported that with latest clang, when building selftests, we have
> error likes:
>   error: progs/test_sysctl_loop1.c:23:16: in function sysctl_tcp_mem i32 (%struct.bpf_sysctl*):
>   Looks like the BPF stack limit of 512 bytes is exceeded.
>   Please move large on stack variables into BPF per-cpu array map.
>
> The error is triggered by the following LLVM patch:
>   https://reviews.llvm.org/D87134
>
> For example, the following code is from test_sysctl_loop1.c:
>   static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>   {
>     volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>     ...
>   }
> Without the above LLVM patch, the compiler did optimization to load the string
> (59 bytes long) with 7 64bit loads, 1 8bit load and 1 16bit load,
> occupying 64 byte stack size.
>
> With the above LLVM patch, the compiler only uses 8bit loads, but subregister is 32bit.
> So stack requirements become 4 * 59 = 236 bytes. Together with other stuff on
> the stack, total stack size exceeds 512 bytes, hence compiler complains and quits.
>
> To fix the issue, removing "volatile" key word or changing "volatile" to
> "const"/"static const" does not work, the string is put in .rodata.str1.1 section,
> which libbpf did not process it and errors out with
>   libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
>   libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
>           in section '.rodata.str1.1'
>
> Defining the string const as global variable can fix the issue as it puts the string constant
> in '.rodata' section which is recognized by libbpf. In the future, when libbpf can process
> '.rodata.str*.*' properly, the global definition can be changed back to local definition.
>
> Defining tcp_mem_name as a global, however, triggered a verifier failure.
>    ./test_progs -n 7/21
>   libbpf: load bpf program failed: Permission denied
>   libbpf: -- BEGIN DUMP LOG ---
>   libbpf:
>   invalid stack off=0 size=1
>   verification time 6975 usec
>   stack depth 160+64
>   processed 889 insns (limit 1000000) max_states_per_insn 4 total_states
>   14 peak_states 14 mark_read 10
>
>   libbpf: -- END LOG --
>   libbpf: failed to load program 'sysctl_tcp_mem'
>   libbpf: failed to load object 'test_sysctl_loop2.o'
>   test_bpf_verif_scale:FAIL:114
>   #7/21 test_sysctl_loop2.o:FAIL
> This actually exposed a bpf program bug. In test_sysctl_loop{1,2}, we have code
> like
>   const char tcp_mem_name[] = "<...long string...>";
>   ...
>   char name[64];
>   ...
>   for (i = 0; i < sizeof(tcp_mem_name); ++i)
>       if (name[i] != tcp_mem_name[i])
>           return 0;
> In the above code, if sizeof(tcp_mem_name) > 64, name[i] access may be
> out of bound. The sizeof(tcp_mem_name) is 59 for test_sysctl_loop1.c and
> 79 for test_sysctl_loop2.c.
>
> Without promotion-to-global change, old compiler generates code where
> the overflowed stack access is actually filled with valid value, so hiding
> the bpf program bug. With promotion-to-global change, the code is different,
> more specifically, the previous loading constants to stack is gone, and
> "name" occupies stack[-64:0] and overflow access triggers a verifier error.
> To fix the issue, adjust "name" buffer size properly.
>
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 4 ++--
>  tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> Changelog:
>   v2 -> v3:
>     . using sizeof(tcp_mem_name) instead of hardcoded value for
>       local buf "name". (Andrii)
>   v1 -> v2:
>     . The tcp_mem_name change actually triggers a verifier failure due to
>       a bpf program bug. Fixing the bpf program bug can make test pass
>       with both old and latest llvm. (Alexei)
>

[...]

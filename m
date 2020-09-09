Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B662631F8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgIIQdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgIIQcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:32:39 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE5CC061755;
        Wed,  9 Sep 2020 09:32:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id q3so2161762ybp.7;
        Wed, 09 Sep 2020 09:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ukEjxfb+1NHDtvdcqh0sH5s3JNgB8HHy1ACIbDfp5WE=;
        b=nCTzEYiMneIdA9f1xe6gyc6JZtf86C8g7xesh9TO/Mr/HwHopBiGo6vS9x3b70uJ/1
         l0B2VP4FNTk+dNFM903kg36P9AOrrKHDoM08TT6RQUgW7O08jNP3Gu483QR7WARhCeeP
         XVm0yHBFHpLhCTF5J9w3SZhqXNyTOw58f/D0nZBZujDFhJbbcO+9YbFx4LM8F/ej6mLq
         a384k1pCLAp8oztq6ir9IrUrsjzaiQSCaTotL6Cff4zuthfROlGcshJb3ASmJIR5eQWA
         z6MhLNa9/9d4d84/G4q0ghC0rthbQHxWNQBFvnqVtC+4174cWLQdvMC1opFwaA+mLVz0
         LVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ukEjxfb+1NHDtvdcqh0sH5s3JNgB8HHy1ACIbDfp5WE=;
        b=XaCWps49j2fohKNOaPUpxetoue1U3rTSxBZJ2WFO2Y5DvFfWfFVrBw3DBBCfGEVulm
         iqm4SpFSvxNW7tU5H3Sy8XOts1RTyFIb0FyFuDcRAGhji7QYmIdpnLg+X3jDj4j0VVru
         yZyLvHL0p2moZxtemIOVOt0ADl6sgXyiTRlBUED4GaZ4vwjmFF0WLZ1B8agTLjZG/IVl
         9sTPkH6UZiT+SKXfxc4ScG2TQcwV98XpUim6BVZ6Z+cHVw7v1yCQxIv1vlOIOLlyg0FJ
         COKjmw2yD5uPTCf++Z4BtV8QEkB9KQERSjkkKBV+m6ahxpTgQ9BVjlErfppLjQwHecX7
         egSw==
X-Gm-Message-State: AOAM5322u5a5HSPVSHCp9ZIFhzkWLeaRlveQbukzum21WJqGDvPKH5Lh
        WHZjqHJAxYQAYV4k/nVb/C3FHi/XsV0RMEJb3oOI8mEs
X-Google-Smtp-Source: ABdhPJwF4jzCA2HNcfoVoMH5OA+I2c1B/FTKEPwKXm/kk9hSKzIlrOHcr/KyO9RctifcmGP2lrA9C1VOBYolpjQNn3s=
X-Received: by 2002:a25:7b81:: with SMTP id w123mr7138417ybc.260.1599669135410;
 Wed, 09 Sep 2020 09:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200909063943.1653670-1-yhs@fb.com>
In-Reply-To: <20200909063943.1653670-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:32:04 -0700
Message-ID: <CAEf4BzYRG=q_0BZwc+K89+OF9M4w7h2SoS3Qb_A6BiUNGPg4hg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix test_sysctl_loop{1,2}
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

On Tue, Sep 8, 2020 at 11:40 PM Yonghong Song <yhs@fb.com> wrote:
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
>  tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 2 +-
>  tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> Changelog:
>   v1 -> v2:
>     . The tcp_mem_name change actually triggers a verifier failure due to
>       a bpf program bug. Fixing the bpf program bug can make test pass
>       with both old and latest llvm. (Alexei)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
> index 458b0d69133e..4b600b1f522f 100644
> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
> @@ -18,9 +18,9 @@
>  #define MAX_ULONG_STR_LEN 7
>  #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>
> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>  static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>  {
> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>         unsigned char i;
>         char name[64];
>         int ret;
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> index b2e6f9b0894d..d01056142520 100644
> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> @@ -18,11 +18,12 @@
>  #define MAX_ULONG_STR_LEN 7
>  #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>
> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>  static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
>  {
> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>         unsigned char i;
> -       char name[64];
> +       /* the above tcp_mem_name length is 79, make name buffer length 80 */
> +       char name[80];


Wow, did you really count? Why not use sizeof(tcp_mem_name) and drop
the comment entirely?

>         int ret;
>
>         memset(name, 0, sizeof(name));
> --
> 2.24.1
>

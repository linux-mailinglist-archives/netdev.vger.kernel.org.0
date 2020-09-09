Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECFC2625D2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgIIDVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIIDVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:21:05 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7860AC061573;
        Tue,  8 Sep 2020 20:21:05 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s92so854818ybi.2;
        Tue, 08 Sep 2020 20:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HkaMjPuqqBlVyovV9k2WlJn07yO1Tb/QeX6I5/lXmzM=;
        b=A2zkjrkXC+4viCGD3Ttkbhiz8GoxCDQFE7zpWDJ+mNIwVstAbwVBKuRlUctm+KZTYC
         a3cYcUifYVcw852/m8WKqbdh8v144/taWjLZQST1Y2cpSce+DKt1uxEBMOhpnfl44VE6
         JmHYH+lb5y9Rh7yrwhaeUSzmj+kAsnDwM99YPjc5UtlrD+DwIDrO4ps+WVagskWU5uou
         vGfBWQ/KveLxTUIDmJDjqJ6yS2uU372Uzf4ELmGdti2U81HCtmL0amN5DSd+BBPcJS+V
         gwOJ4pxomDb6QxX+2FO8fYGlkX8YX0aaHRDwYfOTUyLgmaiYKYyQ2MkiXR9ez9SvpoDF
         NQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HkaMjPuqqBlVyovV9k2WlJn07yO1Tb/QeX6I5/lXmzM=;
        b=cS33vrj2LaYjT9nXbKxlGIHMgdFLY/hgPxCwhzFbT5zuVk/IYsctxUcuK4woeqoL2I
         EgygCOTVbwZ9qM6rlp+PyKlNRyxngdmxK6uLXYVCP0uTQrmBGdWW/wDKW/hPVXvmwqxx
         KYtfBmj2vOa7jWh7CZNwYY615AyYYaHnBH6Zgvpp71RHWXFu3UA3DE6JBzSetvipFWdN
         gTwwwv1xxqrAzK6jgRoGmnNpDsLzQTRzGVfshHRe1qGsKOhjGqLe//ngIW2ysiYzZTrp
         7DFB3damolpdKZF1WzCe3LsHWeu76dIivHXbSO4uUT5T7ofFQpkEQDZTTOVJJ5C6W/Xo
         nZqQ==
X-Gm-Message-State: AOAM531CNTS/UhkH8FTUU+k6C/qR92XFPtPfOTx06TVYoBjTxyGM7pOw
        x27pXibK/Jb3JVtgxWYghtseHA2UgS7Aq0riUIk=
X-Google-Smtp-Source: ABdhPJwT3wFFShKOGK1bCYsUn06fLCAFIvV0k/4yr2ihVGmLrsWDSGYEANgS2iFynbPXsYxSL0WLJJ+iUIrMykNjTCE=
X-Received: by 2002:a25:c049:: with SMTP id c70mr2947707ybf.403.1599621664648;
 Tue, 08 Sep 2020 20:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200909031227.963161-1-yhs@fb.com>
In-Reply-To: <20200909031227.963161-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 20:20:53 -0700
Message-ID: <CAEf4BzZmtd_5fu53ZR==KW4jGO2UpzaBJU62GqOqgE0BFCtvvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_sysctl_loop{1,2} failure
 due to clang change
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

On Tue, Sep 8, 2020 at 8:13 PM Yonghong Song <yhs@fb.com> wrote:
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

Yeah, those .str1.1 sections are becoming more prominent, I think I'll
be able to fix it soon, just need the right BTF APIs implemented
first.

>   libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
>   libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
>           in section '.rodata.str1.1'
>
> Defining the string const as global variable can fix the issue as it puts the string constant
> in '.rodata' section which is recognized by libbpf. In the future, when libbpf can process
> '.rodata.str*.*' properly, the global definition can be changed back to local definition.
>
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 2 +-
>  tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
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

Do you think we should put "volatile" there just in case Clang decides
to be very optimizing and smart?

>  static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>  {
> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>         unsigned char i;
>         char name[64];
>         int ret;
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> index b2e6f9b0894d..3c292c087395 100644
> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> @@ -18,9 +18,9 @@
>  #define MAX_ULONG_STR_LEN 7
>  #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>
> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>  static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
>  {
> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>         unsigned char i;
>         char name[64];
>         int ret;
> --
> 2.24.1
>

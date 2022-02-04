Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EEA4AA015
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiBDTa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiBDTa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:30:27 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8394BC061714;
        Fri,  4 Feb 2022 11:30:27 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n17so8646543iod.4;
        Fri, 04 Feb 2022 11:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G5Ev0pQLy6cGfkzqPa2EKK7EBgTL3yBveXxkgXkWG58=;
        b=QIHpeevj1hSBJC2VuQD9xeY4sT9WQmHx9UHF2tz7XKfUMT8671pTlJ/wfMvS//ICj5
         vOhtYC287DWcSSyM8RAzrzH3X5X/mfkNGu4CALu6+B7s3TUl9DIVzxslkih9HaKBaYZ5
         D3KmCxowlp/Nl0uU35wvUuwbzZUiZ/Srb65UgSphnBVMkX0D+iqLQAfrhs+H8ydjU3Pg
         e/chilgUWjiEtDrx5XQyRrymfd8uY5sI2jg/ZbzH9Sbgh4ueAtGaY6orgR8oB6J3nyug
         W6mcPIrgbbxC1VNH9ecdv6MK/Mclfl/+MUcnzacPlthZlpr2fT5X0ccueBJ9ToN8ZFRX
         DmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G5Ev0pQLy6cGfkzqPa2EKK7EBgTL3yBveXxkgXkWG58=;
        b=W/1u+F8oDd5nLYzTGxLHcsatk/VHu3UJ6rzp4Gae16TLVrSafwY9Ny9FQqIvkZvEQ9
         o3fIoGe437DChsuGd45h9A7+sh3y2RmdwhJp1tmH77Uv6BHZboiSsgay62gdrE5LI7a0
         4E6vFjFl7B8AgqQepaW+bIxmFFFDAlvh0s2Yjga8miez3a+O7rygDdyXB52m25PDlrXS
         /Q4QamUb7udqBu8lH5EwqED4h0x1PgmOUt+TxuM+Su7r7NjXNIqimO+FetlZHCW7cNaP
         fI3yP3X7LMtd+Q+jn1nDSuzcP2fEVlxTl0S6jkXliXyMek1aaFQbtUAEtHB9efNV/500
         1pdw==
X-Gm-Message-State: AOAM532QptVuwmLB0K7dDWOTWrgNqtiwRAECnMqr35cZAeirEfqzUGlN
        WMlIiNxAIvHzwr1WJZNxDzNYRSM9Ov8LNC4h0gg=
X-Google-Smtp-Source: ABdhPJwBHTOSKUOKMai6POYVC9JM+PuRJ4loEPKJ8ktl6qT7frFalloF3eVzYQo6z03JbYLhOyIIdIQSPi2ZX2m/Tlo=
X-Received: by 2002:a5d:88c1:: with SMTP id i1mr300035iol.154.1644003026553;
 Fri, 04 Feb 2022 11:30:26 -0800 (PST)
MIME-Version: 1.0
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-5-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1643645554-28723-5-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 11:30:15 -0800
Message-ID: <CAEf4BzZW6W6vVtsGEDyYcc=ZMon676r9NOAbnseZA1az2Heq3Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add tests for u[ret]probe
 attach by name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> add tests that verify attaching by name for
>
> 1. local functions in a program
> 2. library functions in a shared object; and
> 3. library functions in a program
>
> ...succeed for uprobe and uretprobes using new "func_name"
> option for bpf_program__attach_uprobe_opts().  Also verify
> auto-attach works where uprobe, path to binary and function
> name are specified, but fails with -ESRCH when the format
> does not match (the latter is to support backwards-compatibility).
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c        | 89 +++++++++++++++++++++-
>  .../selftests/bpf/progs/test_attach_probe.c        | 37 +++++++++
>  2 files changed, 123 insertions(+), 3 deletions(-)
>

[...]

>         if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
>                   "wrong uprobe res: %d\n", skel->bss->uprobe_res))
>                 goto cleanup;
> @@ -110,7 +179,21 @@ void test_attach_probe(void)
>                   "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
>                 goto cleanup;
>
> +       if (CHECK(skel->bss->uprobe_byname_res != 5, "check_uprobe_byname_res",
> +                 "wrong uprobe byname res: %d\n", skel->bss->uprobe_byname_res))
> +               goto cleanup;
> +       if (CHECK(skel->bss->uretprobe_byname_res != 6, "check_uretprobe_byname_res",
> +                 "wrong uretprobe byname res: %d\n", skel->bss->uretprobe_byname_res))
> +               goto cleanup;
> +       if (CHECK(skel->bss->uprobe_byname2_res != 7, "check_uprobe_byname2_res",
> +                 "wrong uprobe byname2 res: %d\n", skel->bss->uprobe_byname2_res))
> +               goto cleanup;
> +       if (CHECK(skel->bss->uretprobe_byname2_res != 8, "check_uretprobe_byname2_res",
> +                 "wrong uretprobe byname2 res: %d\n", skel->bss->uretprobe_byname2_res))
> +               goto cleanup;
> +

Please don't use CHECK()s for new code, only ASSERT_xxx() for new code.

>  cleanup:
> +       free(libc_path);
>         test_attach_probe__destroy(skel);
>         ASSERT_EQ(uprobe_ref_ctr, 0, "uprobe_ref_ctr_cleanup");
>  }
> diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> index 8056a4c..9942461c 100644
> --- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
> +++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> @@ -10,6 +10,10 @@
>  int kretprobe_res = 0;
>  int uprobe_res = 0;
>  int uretprobe_res = 0;
> +int uprobe_byname_res = 0;
> +int uretprobe_byname_res = 0;
> +int uprobe_byname2_res = 0;
> +int uretprobe_byname2_res = 0;
>
>  SEC("kprobe/sys_nanosleep")
>  int handle_kprobe(struct pt_regs *ctx)
> @@ -39,4 +43,37 @@ int handle_uretprobe(struct pt_regs *ctx)
>         return 0;
>  }
>
> +SEC("uprobe/trigger_func_byname")
> +int handle_uprobe_byname(struct pt_regs *ctx)
> +{
> +       uprobe_byname_res = 5;
> +       return 0;
> +}
> +
> +/* use auto-attach format for section definition. */
> +SEC("uretprobe//proc/self/exe:trigger_func2")
> +int handle_uretprobe_byname(struct pt_regs *ctx)
> +{
> +       uretprobe_byname_res = 6;
> +       return 0;
> +}
> +
> +SEC("uprobe/trigger_func_byname2")
> +int handle_uprobe_byname2(struct pt_regs *ctx)

this one is for malloc, so why SEC() doesn't reflect this?

It would be great to also have (probably separate) selftest for
auto-attach logic of skeleton for uprobes.
I'd add a separate uprobe-specific selftests, there is plenty to test
without having kprobes intermingled.

> +{
> +       unsigned int size = PT_REGS_PARM1(ctx);
> +
> +       /* verify malloc size */
> +       if (size == 1)
> +               uprobe_byname2_res = 7;
> +       return 0;
> +}
> +
> +SEC("uretprobe/trigger_func_byname2")
> +int handle_uretprobe_byname2(struct pt_regs *ctx)
> +{
> +       uretprobe_byname2_res = 8;
> +       return 0;
> +}
> +
>  char _license[] SEC("license") = "GPL";
> --
> 1.8.3.1
>

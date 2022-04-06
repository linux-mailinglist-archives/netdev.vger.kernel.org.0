Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563AB4F539A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2360174AbiDFEZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361123AbiDFDoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 23:44:14 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBB12F380;
        Tue,  5 Apr 2022 17:14:42 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x4so1151510iop.7;
        Tue, 05 Apr 2022 17:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SiOlR7FQJECBOngSYr/kuLzweA1EIkoBcnX8l6to9uQ=;
        b=le8BEi0VjD5Ae1R/wuwFFNbhuY9lw10ryYLA0FmZctLnyacLgCwJG1BIp4YgQcgAWV
         b0XVKd2LVvPs+4yMbmW8brHidFH5/0V2FS6fy3eA5plejZaNpluOcM4CzBf0qoLynrRR
         sqW3e7064QWMfAaz1WIFX0GBwrpJzwOs2lF5RWRX1pgBty6vVkm3YGJkeqJl30GVCobB
         QcE79C8lqLNmWt7f0hBNIWw4tXbvY8VK3ny6Ff39EQqVltNSCNCrTWyD9+N/X29MocMs
         b3dQeQl4T/FkbpxXmVDl/136PR7yInprTyLbXCsEMoCMMJTq2QxjDcTcki72HeOThrsD
         lEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SiOlR7FQJECBOngSYr/kuLzweA1EIkoBcnX8l6to9uQ=;
        b=nvuyNCJAOqnvAjDup11TxeUG2XnfQTUFtGVQvALUU4nT+5/04XyOAogBSOes0rbbFD
         ACpw1NDWLZKnK9oxk7aZ9KXD6q39fQIUrIxvvPUazicVQ2xeb+m8Q7walRu/U39cRMMh
         LPgT4lB5BnMm5XIP2bqq1C/p5AxGA+JKzVwLU6AAljRIOECYFfK9LrPxY0h8bC15WEdd
         /EMBYJ1kH8nz3PfeT8gxRgCp9yBXyMatIElT/+5ZPP7xzK8+IZRWZSdUmtWBoWBTc1zE
         qnCEBjKn+VnIQAgWxZe9IWlMmSLLX2AxuDVlgT9n/nwSM+QhRYp22dIVxTehdR9kjj7o
         2rVg==
X-Gm-Message-State: AOAM533Xdhmk65ObuKqiI8SP9MBy9sP2gSxgV+6oIJPjr1Eeft+sFSZM
        qiSJpX27lNFYJf5YNtAEek/3KemjFxOJ6hKpAak=
X-Google-Smtp-Source: ABdhPJwVu1DPW5n60puGM4lH9sfxPcoUjaEyTVOLV56L1dafDbbFbddC43gaFUKD9quqBOD2RIg+Pn3QQfX6b8Q9F5E=
X-Received: by 2002:a05:6638:2105:b0:323:68db:2e4e with SMTP id
 n5-20020a056638210500b0032368db2e4emr3423030jaj.234.1649204082111; Tue, 05
 Apr 2022 17:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com> <1649195156-9465-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1649195156-9465-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Apr 2022 17:14:31 -0700
Message-ID: <CAEf4Bza+E7A0T5hvKz9Thb7t4-WWdO0xPEYuFb0y1qe7v19Vvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: uprobe tests should verify
 param/return values
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 5, 2022 at 2:46 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> uprobe/uretprobe tests don't do any validation of arguments/return values,
> and without this we can't be sure we are attached to the right function,
> or that we are indeed attached to a uprobe or uretprobe.  To fix this
> validate argument and return value for auto-attached functions.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 16 ++++++++++----
>  .../selftests/bpf/progs/test_uprobe_autoattach.c   | 25 +++++++++++++++-------
>  2 files changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> index 03b15d6..ff85f1f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> @@ -5,14 +5,16 @@
>  #include "test_uprobe_autoattach.skel.h"
>
>  /* uprobe attach point */
> -static void autoattach_trigger_func(void)
> +static noinline int autoattach_trigger_func(int arg)
>  {
> -       asm volatile ("");

don't remove asm volatile, with static functions compiler can still do
function transformations and stuff. From GCC documentation for
noinline attribute ([0]):

  noinline

      This function attribute prevents a function from being
considered for inlining. If the function does not have side effects,
there are optimizations other than inlining that cause function calls
to be optimized away, although the function call is live. To keep such
calls from being optimized away, put

      asm ("");

  [0] https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes

So I suppose noinline + asm volatile is the most safe combination :)
for static functions

> +       return arg + 1;
>  }
>
>  void test_uprobe_autoattach(void)
>  {
>         struct test_uprobe_autoattach *skel;
> +       int trigger_val = 100;
> +       size_t malloc_sz = 1;
>         char *mem;
>
>         skel = test_uprobe_autoattach__open_and_load();

[...]

>
> -SEC("uretprobe/libc.so.6:free")
> +SEC("uretprobe/libc.so.6:getpid")
>  int handle_uretprobe_byname2(struct pt_regs *ctx)
>  {
> -       uretprobe_byname2_res = 4;
> +       if (PT_REGS_RC_CORE(ctx) == uretprobe_byname2_rc)
> +               uretprobe_byname2_res = 4;

Instead of checking equality on BPF side, it's more convenient to
record the actual captured value into global variable and let
user-space part check and log it properly. So if something goes wrong,
we don't just have matched/not matched flag, but we see an actual
value captured.


With that, let's better switch uretprobe from free to malloc (we
additionally check that uprobe and uretprobe can coexist properly on
the same function) and capture returned pointer from malloc(). We can
then compare that pointer to the mem variable. How cool is that? :)

>         return 0;
>  }
>
> --
> 1.8.3.1
>

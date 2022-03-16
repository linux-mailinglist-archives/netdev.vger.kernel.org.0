Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313D54DA95A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353517AbiCPEfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353552AbiCPEex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:34:53 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234335FF09;
        Tue, 15 Mar 2022 21:33:38 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b16so1118740ioz.3;
        Tue, 15 Mar 2022 21:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nj7++mQr1VsSCIl4hoUGgI8KuyiwCbbBVsbGPrUp2Gg=;
        b=MM23ovG9/DWuihHtBIHbgLysE/Ucu70zorw5l7PgJdshBcUfJF43vV8WGkMd0Q6V0n
         +tEXilxpnHjTwo4MTAlW1S0NwOMtvKA4r7SbDFGvCJW6MKVluswTLLsCtwRkj4RGHIA9
         B+EnUM9Qc4MDyv2oLJD5XL/h7skCb3lPNZE14AUuq99laUb42wWgz5Llr2hABeiBpbD1
         DKuS58iIdSivsy9qW4z5PCS4WUbLGHqc+55jkZk3EKBHB6D8j+g7ijAuzLCbVR6iZlrf
         0ywDtXajfBbSwk2C3JKMt6S748fAlAGiulrdz/yQ0GY2RD+lrE+QSJG6OKg2wQ9MhejT
         NYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nj7++mQr1VsSCIl4hoUGgI8KuyiwCbbBVsbGPrUp2Gg=;
        b=ygx8TVk5SDUDD5QudBSqTMKUvwXIn7i4R7dOTN6bLKpS2G1ZMpvHTxXeU75cqx9dkS
         +lpZzIxfsatQ75uo9tBiDJ7KPLINkERZeALw2rB7H8w/lPRvfiHjed56zBewmg0R2A/G
         O5GaH45wyuPW6yD9IqRP0zYZntWezsmtG1k5P/r+cGU0j7I1hHOjHxjtgNy2n7UyfsIP
         zQoalRUUfki16QhoKyD4n71xQ9GGG+QW1J26RgJkqMzQSEepNr2osKe4/sA6NcV2oti6
         4gpL0NTbxIYrO+czD+PGXmI9nw4CaAVCl3Y/ZER/8tFU0kuwWFZAtuKl6vrN26UXDBEE
         e51g==
X-Gm-Message-State: AOAM531MWib1UEjZy0bCKYd6nWlsTaeKSL6a1RzWxqIeDMLO9YwYYvfz
        SKdCR8IagMKYVVP0IoHr00KMWT2muWDX8reErqs=
X-Google-Smtp-Source: ABdhPJy0UWr0aWZI9zYcCrhaOOHqoZmpadDm0B2nACnlVR40YIiQutw07Tu1FphkdafXYpcGPyVYG9CQhYtiwQp+Ypc=
X-Received: by 2002:a6b:6f0c:0:b0:648:ea2d:41fe with SMTP id
 k12-20020a6b6f0c000000b00648ea2d41femr11659674ioc.63.1647405217520; Tue, 15
 Mar 2022 21:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com> <1647000658-16149-6-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1647000658-16149-6-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Mar 2022 21:33:26 -0700
Message-ID: <CAEf4Bzb+XRK3AX2s=Sg_4sxT0aVHKa2FAeGk9JMvXtunGBo3vg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/5] selftests/bpf: add tests for uprobe
 auto-attach via skeleton
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Fri, Mar 11, 2022 at 4:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> tests that verify auto-attach works for function entry/return for
> local functions in program, library functions in program and library
> functions in library.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 48 +++++++++++++++
>  .../selftests/bpf/progs/test_uprobe_autoattach.c   | 69 ++++++++++++++++++++++
>  2 files changed, 117 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> new file mode 100644
> index 0000000..57ed636
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022, Oracle and/or its affiliates. */
> +
> +#include <test_progs.h>
> +#include "test_uprobe_autoattach.skel.h"
> +
> +/* uprobe attach point */
> +static void autoattach_trigger_func(void)
> +{
> +       asm volatile ("");
> +}
> +
> +void test_uprobe_autoattach(void)
> +{
> +       struct test_uprobe_autoattach *skel;
> +       char *mem;
> +
> +       skel = test_uprobe_autoattach__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel_open"))
> +               return;
> +       if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
> +               goto cleanup;

no need to check skel->bss, a lot of tests will be broken if that doesn't work

> +
> +       if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
> +               goto cleanup;
> +
> +       /* trigger & validate uprobe & uretprobe */
> +       autoattach_trigger_func();
> +
> +       /* trigger & validate shared library u[ret]probes attached by name */
> +       mem = malloc(1);
> +       free(mem);
> +
> +       if (!ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uprobe_byname2_res, 3, "check_uprobe_byname2_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uretprobe_byname2_res, 4, "check_uretprobe_byname2_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uprobe_byname3_res, 5, "check_uprobe_byname3_res"))
> +               goto cleanup;
> +       if (!ASSERT_EQ(skel->bss->uretprobe_byname3_res, 6, "check_uretprobe_byname3_res"))
> +               goto cleanup;

same about goto cleanup, for such sequences of value checks it's nice
and succinct to just use unconditional sequence of ASSERT_EQ()s

> +cleanup:
> +       test_uprobe_autoattach__destroy(skel);
> +}

[...]

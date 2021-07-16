Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931063CB277
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 08:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhGPG1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 02:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhGPG1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 02:27:41 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08586C06175F;
        Thu, 15 Jul 2021 23:24:47 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id p22so13140524yba.7;
        Thu, 15 Jul 2021 23:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7nfECmLZFfHRGZDsMw/ZPjNyNfs5aoz82O3YRn+SIQ8=;
        b=J+IIvgAh7LguO7P4v1V9ISSphaHuWk0RI0A7G3iqNmsUgtrrTRLs+pRy0m3tyHM/hj
         k/L5Lh/0WQM/b7HEU3sERdIU33uPjjtdvKMWLVfc7FONmG0n9gZbs1Qj9SBLarytfyqv
         t/si0Z2fWO9OBVK8NiZ7eIZQYODUoRaXDHdby+jYgaUULG+ti+oy+1dor1SIf56Imm4r
         lkd09jFUiRImmDAGhgm45IFSKvauxG4bw0i4VxE1sZlF6LKQmCa52+pM+6SKY9CWUekW
         I5PZ8MS0KYrsHLrqXc35jTg4I2etmI+D5g35XA83nB0zJL6BtLopcsdK3Hnp6o+Q1uEU
         ELKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7nfECmLZFfHRGZDsMw/ZPjNyNfs5aoz82O3YRn+SIQ8=;
        b=GBLbYz7HLdxOWVlhhbRXR/t2sxzoV8E8JmyTGeyAg2OBavOL69+AwA/+Qfbr8pDFco
         +RjA0SZ/6Xy97xEE82kJ4X3hISw3We/NUT9CjRMvorJt/KG/huEJlIode1V+fUeSyyj7
         322pVOh8HaXQybgPt0dPuZkY0nni4HnU3h8A59WtaNw8IYTY7h0ZNCwgnLol2MW1HPr+
         JCkuLJGfuZ3CtYiRXXUKN4YIbLBiYyqdJ5YrUfPSUvJB70JMNeRt2M5aEQBlfdgLWtGV
         JKokVP5rJsgGoxaRk+msMboRo781FQQG8ILWBl+hGPYa4zlZo+0fR4vQqJ/sWlPDGlaZ
         Ee6Q==
X-Gm-Message-State: AOAM530spH6NJEbhYAcV6XTX8vWC7poUYCAg5Ss7fsUASWsYm6Wraz5H
        USkh2pSuA2YuOaDhvMtH2pc7+K6Frj+Fp0ApaaM=
X-Google-Smtp-Source: ABdhPJwVP9vmiOx97YfEbiQ+U9eLEVtRRhfIEstXpRfsJzRcqcufYlairRueZniEa8JvRbl/0jZD02whUq7o4caEc90=
X-Received: by 2002:a25:b741:: with SMTP id e1mr10850768ybm.347.1626416686326;
 Thu, 15 Jul 2021 23:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com> <1626362126-27775-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626362126-27775-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 23:24:35 -0700
Message-ID: <CAEf4Bzap=EHCRXwePxU+sW94DGFFOLqBnwtJyqhnFJ+s86D4qQ@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 3/3] selftests/bpf: add dump type data tests
 to btf dump tests
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 8:16 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Test various type data dumping operations by comparing expected
> format with the dumped string; an snprintf-style printf function
> is used to record the string dumped.  Also verify overflow handling
> where the data passed does not cover the full size of a type,
> such as would occur if a tracer has a portion of the 8k
> "struct task_struct".
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf_dump.c | 600 ++++++++++++++++++++++
>  1 file changed, 600 insertions(+)
>

[...]

> @@ -245,4 +815,34 @@ void test_btf_dump() {
>         }
>         if (test__start_subtest("btf_dump: incremental"))
>                 test_btf_dump_incremental();
> +
> +       btf = libbpf_find_kernel_btf();
> +       if (!ASSERT_NEQ(btf, NULL, "no kernel BTF found"))
> +               return;
> +
> +       d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
> +
> +       if (!ASSERT_NEQ(d, NULL, "could not create BTF dump"))

better use ASSERT_OK_PTR() for this, I'll adjust when applying


> +               return;
> +
> +       /* Verify type display for various types. */
> +       if (test__start_subtest("btf_dump: int_data"))
> +               test_btf_dump_int_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: float_data"))
> +               test_btf_dump_float_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: char_data"))
> +               test_btf_dump_char_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: typedef_data"))
> +               test_btf_dump_typedef_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: enum_data"))
> +               test_btf_dump_enum_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: struct_data"))
> +               test_btf_dump_struct_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: var_data"))
> +               test_btf_dump_var_data(btf, d, str);
> +       btf_dump__free(d);
> +       btf__free(btf);
> +
> +       if (test__start_subtest("btf_dump: datasec_data"))
> +               test_btf_dump_datasec_data(str);
>  }
> --
> 1.8.3.1
>

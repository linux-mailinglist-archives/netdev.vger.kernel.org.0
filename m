Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B205F3EF0DD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhHQR0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhHQR0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:26:21 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF9FC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:25:48 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w5so40127136ejq.2
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kx7QmZw4iZxxTYf+W99jsdNNiEagCc09H0bMfyWvOLk=;
        b=EiCVMhVMMEH50tyNHAT22U+zvE8qtJJTfa+8IZcr17JlTvCpC9/G0t0KgjAdtxVWik
         Nf+0zCw+Ulx1/fz3mxHZNxCxjPIF9ipB2+u7fBx47WGysW0wZhQ9gzKohCjfb4h8XIiJ
         YthVI/myMEvxil9iSk6RUwsJZlJliqOtrPhwE96CE2M81JCjO573qqqMbSXTVfMGZkj8
         A25PmZMoa6MYysR49mywQsXAEYhRXl3oujFD6kJ/aZrPvssWgej3o5BHlKdQoa1B0v1n
         qKa2OwE0be6VrgnlHNav29zQI3RVg5ruoR8h01UmKpHFFKzVqtDIoOBQVGmcE+BSYsMg
         +iuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kx7QmZw4iZxxTYf+W99jsdNNiEagCc09H0bMfyWvOLk=;
        b=YgREg9uDxCmZvOq3JsjgmkaWkYUVQdTk9Fsx00/d4vdIzkZPUnei0MWfl2uedSqrKD
         Sw5qjIV6rxDw8EuiYR/SddHDBv4fcOLNQdQ/J6H22k1rrGYeEWnX+0umrGxGXS9ktXzN
         pehkNR6752X5jVp4JKKMIWNbnF4IIqaYmhtNcQjqdegvFMO2QlR1ymveaMwwN2Exv2TA
         bUNiy083EwSJRwRpqtCNLT6+0Id6i+6Czo6KdKAofXPibxRPhuLMgv6EQxA/yfd+wcy6
         XULpkTJOYGKHG4o9MVr3YtuP1IW+5gXIAzLdjwzhVB3NXct1hhti+k+K+vIzVZCwotRK
         mhAQ==
X-Gm-Message-State: AOAM532rs1RgEMNXrjou+Rfu27JC7W9TihkL3BVWOMP/4C1N6icDixq8
        WR5H/V73EukNuMD2b+Ue9GCzlb0/ko3UpyV0Jf94gg==
X-Google-Smtp-Source: ABdhPJzG1YjgkQ26eaK7xT9UeHxrZinjLOTZHIibPT7kojx65/n/eQs/LKmzdN1nvWSopOfZus5nKD2Fn03nCfISfsc=
X-Received: by 2002:a17:906:388b:: with SMTP id q11mr5055729ejd.113.1629221146455;
 Tue, 17 Aug 2021 10:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210812003819.2439037-1-haoluo@google.com> <CAEf4Bzbhtty_XjpPxSjfe4zEHAfWuQ4th15eLgomT2BDHUQ7jw@mail.gmail.com>
In-Reply-To: <CAEf4Bzbhtty_XjpPxSjfe4zEHAfWuQ4th15eLgomT2BDHUQ7jw@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 17 Aug 2021 10:25:35 -0700
Message-ID: <CA+khW7i6KpzwB_U7KkYGnRoXfoYH9k5xU7qFmXcmymu+gmf8AQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: support weak typed ksyms.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 4:01 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Aug 11, 2021 at 5:40 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Currently weak typeless ksyms have default value zero, when they don't
> > exist in the kernel. However, weak typed ksyms are rejected by libbpf
> > if they can not be resolved. This means that if a bpf object contains
> > the declaration of a nonexistent weak typed ksym, it will be rejected
> > even if there is no program that references the symbol.
> >
> > Nonexistent weak typed ksyms can also default to zero just like
> > typeless ones. This allows programs that access weak typed ksyms to be
> > accepted by verifier, if the accesses are guarded. For example,
> >
> > extern const int bpf_link_fops3 __ksym __weak;
> >
> > /* then in BPF program */
> >
> > if (&bpf_link_fops3) {
> >    /* use bpf_link_fops3 */
> > }
> >
> > If actual use of nonexistent typed ksym is not guarded properly,
> > verifier would see that register is not PTR_TO_BTF_ID and wouldn't
> > allow to use it for direct memory reads or passing it to BPF helpers.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> Looks good, applied to bpf-next. For the future, please split libbpf
> and selftests changes into separate patches, it's nicer to have those
> logically separate.
>
> At some point we should probably also improve libbpf error reporting
> for such situations, for better user experience. We have a similar
> problem with CO-RE relocation, verifier doesn't know about those
> concepts, so verifier log is not very helpful, but libbpf can make
> sense out of it with some extra BPF verifier log parsing.
>

Thanks. Will split the tests in future.


> > Changes since v2:
> >  - Move special handling and warning from find_ksym_btf_id() to
> >    bpf_object__resolve_ksym_var_btf_id().
> >  - Removed bpf_link_fops3 from tests since it's not used.
> >  - Separated variable declaration and statements.
> >
> > Changes since v1:
> >  - Weak typed symbols default to zero, as suggested by Andrii.
> >  - Use ASSERT_XXX() for tests.
> >
> >  tools/lib/bpf/libbpf.c                        | 16 +++---
> >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 31 ++++++++++
> >  .../selftests/bpf/progs/test_ksyms_weak.c     | 56 +++++++++++++++++++
> >  3 files changed, 96 insertions(+), 7 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> >
>
> [...]

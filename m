Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391865F167D
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 01:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiI3XG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 19:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiI3XGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 19:06:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3961DBECE;
        Fri, 30 Sep 2022 16:06:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nb11so11920187ejc.5;
        Fri, 30 Sep 2022 16:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TO/Dnojuzy8y7EXQe0eM4OMKkAlOYJMLgdG0Hc9KCnw=;
        b=mMxmLiS28BO7HNjjP46LE3FvsEBOo3cO9Z8twoFtsONG2b2IUlqBlkP+Ff8MEtaqn6
         oqyIzuCr9pNvk3HgUnqU9APKvg8j5HDhhJr6S5Q9xxILZ8rmvjPJrPj7AQo7uBZUBI8d
         vkOEFcfeLyyAItbEi07hCs1pqjw+9gKcDtia1VqG1fP9ZzMTEkiF93E+tylnunDZc2N8
         3mRvWGnz/v5y76E+1zVWUArPlLLxQZfpoc9LJeO9XCXsfSQzv0MkH63M/6OfCCdkN0t+
         lv2Ikh/hAmdueqQCTs0FtBU77auTQQbGNa1UPY+WLrnNXWZboTdN/dUaMShdnQfaPEDy
         K0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TO/Dnojuzy8y7EXQe0eM4OMKkAlOYJMLgdG0Hc9KCnw=;
        b=MaFxpoB+pJcxhnK64qDzQEr7ABemzpWsI+Gh4WaDBsvH1gi44pXFE2a9iJJ5YPh4F6
         TG3aBPjgDkQixanZ6CSJ+/KObrMeX9gTvQl8rID1XwqeOM5m7Q8Kc5E20mxraFUAHtVT
         RlXlq+WlpWEku3ZVXhNx27UEBdVDvYoPW2o3mHtnnHDsPS/vrMrATw0UBW80U/WjFIOd
         MGTmjK4h/dpHggA1zo0SECinnrHHhXV3/UeQ24OPOTRZAXeEEQISwrj+jcUEyWSOX6Bv
         8b2QhQvFRfcZWMMdVV7vWTysAPSWIMI6EzDp1saL25wj8taX6I10UCqT0HQnv13UlRDt
         /qgA==
X-Gm-Message-State: ACrzQf1wiOmqDsBH2WTQ0OqnpgdyziMKSFXwz2OZFKvZsM1+PIq9kWKf
        SMrw+kXkLfpFdCJh2uMeHLV/ObmHq6lx9cCTpuw=
X-Google-Smtp-Source: AMsMyM49ySGZi4kBbux8WzUD5SxWEA4+kXCcbZ6LOv6hUP3ziyE0eR45WcANCyogza6tBQTsfdrsnkwdClJFG8u6t3Q=
X-Received: by 2002:a17:907:72c1:b0:783:34ce:87b9 with SMTP id
 du1-20020a17090772c100b0078334ce87b9mr8035561ejc.115.1664579213102; Fri, 30
 Sep 2022 16:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220930110900.75492-1-asavkov@redhat.com>
In-Reply-To: <20220930110900.75492-1-asavkov@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Sep 2022 16:06:41 -0700
Message-ID: <CAEf4BzZpkgXi9Y6x-_-6mDDW12GvTj0Y_e7cpQMqF3dtiBBhpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make libbpf_probe_prog_types
 testcase aware of kernel configuration
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 4:09 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> At the moment libbpf_probe_prog_types test iterates over all available
> BPF_PROG_TYPE regardless of kernel configuration which can exclude some
> of those. Unfortunately there is no direct way to tell which types are
> available, but we can look at struct bpf_ctx_onvert to tell which ones
> are available.
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---

Many selftests assume correct kernel configuration which is encoded in
config and config.<arch> files. So it seems fair to assume that all
defined program types are available on kernel-under-test.

If someone is running selftests under custom more minimal kernel they
can use denylist to ignore specific prog type subtests?


>  .../selftests/bpf/prog_tests/libbpf_probes.c  | 33 +++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c b/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
> index 9f766ddd946ab..753ddf79cf5e0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
> +++ b/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
> @@ -4,12 +4,29 @@
>  #include <test_progs.h>
>  #include <bpf/btf.h>
>
> +static int find_type_in_ctx_convert(struct btf *btf,
> +                                   const char *prog_type_name,
> +                                   const struct btf_type *t)
> +{
> +       const struct btf_member *m;
> +       size_t cmplen = strlen(prog_type_name);
> +       int i, n;
> +
> +       for (m = btf_members(t), i = 0, n = btf_vlen(t); i < n; m++, i++) {
> +               const char *member_name = btf__str_by_offset(btf, m->name_off);
> +
> +               if (!strncmp(prog_type_name, member_name, cmplen))
> +                       return 1;
> +       }
> +       return 0;
> +}
> +
>  void test_libbpf_probe_prog_types(void)
>  {
>         struct btf *btf;
> -       const struct btf_type *t;
> +       const struct btf_type *t, *context_convert_t;
>         const struct btf_enum *e;
> -       int i, n, id;
> +       int i, n, id, context_convert_id;
>
>         btf = btf__parse("/sys/kernel/btf/vmlinux", NULL);
>         if (!ASSERT_OK_PTR(btf, "btf_parse"))
> @@ -23,6 +40,14 @@ void test_libbpf_probe_prog_types(void)
>         if (!ASSERT_OK_PTR(t, "bpf_prog_type_enum"))
>                 goto cleanup;
>
> +       context_convert_id = btf__find_by_name_kind(btf, "bpf_ctx_convert",
> +                                                   BTF_KIND_STRUCT);
> +       if (!ASSERT_GT(context_convert_id, 0, "bpf_ctx_convert_id"))
> +               goto cleanup;
> +       context_convert_t = btf__type_by_id(btf, context_convert_id);
> +       if (!ASSERT_OK_PTR(t, "bpf_ctx_convert_type"))
> +               goto cleanup;
> +
>         for (e = btf_enum(t), i = 0, n = btf_vlen(t); i < n; e++, i++) {
>                 const char *prog_type_name = btf__str_by_offset(btf, e->name_off);
>                 enum bpf_prog_type prog_type = (enum bpf_prog_type)e->val;
> @@ -31,6 +56,10 @@ void test_libbpf_probe_prog_types(void)
>                 if (prog_type == BPF_PROG_TYPE_UNSPEC)
>                         continue;
>
> +               if (!find_type_in_ctx_convert(btf, prog_type_name,
> +                                             context_convert_t))
> +                       continue;
> +
>                 if (!test__start_subtest(prog_type_name))
>                         continue;
>
> --
> 2.37.3
>

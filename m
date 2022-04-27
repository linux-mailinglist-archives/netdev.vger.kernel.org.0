Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B128051254F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiD0Wgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiD0Wgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:36:44 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927F1266F;
        Wed, 27 Apr 2022 15:33:32 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id r11so887093ila.1;
        Wed, 27 Apr 2022 15:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ze1S9fJCbP+SQ+dCw4Iqsjhp3PBB+vQnP1mqNNiw9Yk=;
        b=jpne0KILeFpCLLGk/X4BHuWQlCaBxKpQ8nUBd3cSKrhCRauHUfDXp9NWtLmRg6HYCB
         PYZM0VIXHka2E0z4BLs/y5NUOol4SLgKQcwsygjSmmcEiwS2YdctRp7wT6YgkiqvpfRf
         eIvQooZ1PjdEXAHfL2EdxXfFz6qKNFCW3yLTaKJ+5nLVco6rgEk5z0qvXM0Yq7LH4MXs
         1dsi0ypR6StgahAXlewYA8dBFoSnsyF8zm34NIlOPewwuvzCowoMkqntubAiE9qfvoeN
         EmKh4s/ml7CbXrweaLfiXtFb7LpADS8LI3E9Ik2wDWVqQxzHs//nuohFmSnKKFdVlyEc
         DHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ze1S9fJCbP+SQ+dCw4Iqsjhp3PBB+vQnP1mqNNiw9Yk=;
        b=T09A7uKV/C/VaozzmqvwkHPXwKQqNFknWERpPI2umqEbCcy6sefW8n4O5kxVhFzdBE
         qkXqFTo0o6OQVCBmn5E6Ev4jHkhiKL5tY5O7pKDO+NmMpciAYkX7N3ndSJCw7qUGzpmj
         eVhJNXcjOa9bNxTTEHY4xpgiLIzCaruptu/Li+mGl4Vl0fKKZ1IsNTbf+UWATDJ+K7WH
         UxXiYB3EaIolUoQJHwW4X8PEXxDe9U02fjfRzUwcUJIBpgYMZ4zQSLMOHRymjo2qv5Qh
         mf1BLxbCq/neCWRw05BdTEXCiID7RWtqKSUcNeIVQbZIdMt0VCuSTAFyK5t6gB+MI6J6
         vsfw==
X-Gm-Message-State: AOAM530FcKcrImCpAUD4hFP0HpshYXwVVqOjA/xazSkwmyiGXyMQ+iaS
        1mPByBotwOZo5kfcHfxrb+Y71t7H2EaVDBs6B+0=
X-Google-Smtp-Source: ABdhPJwNjCiR1cOhJEbvgqBq1X2aGYcmfd1x1i8bvBKs2ZFHXF+g1U0Lf2gMZVMtgJM/Ibu4U4z2NasT4fTCmF5jq8E=
X-Received: by 2002:a05:6e02:1ba3:b0:2cc:4158:d3ff with SMTP id
 n3-20020a056e021ba300b002cc4158d3ffmr11902890ili.98.1651098811875; Wed, 27
 Apr 2022 15:33:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220426140924.3308472-1-pulehui@huawei.com> <20220426140924.3308472-2-pulehui@huawei.com>
In-Reply-To: <20220426140924.3308472-2-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 15:33:21 -0700
Message-ID: <CAEf4BzYvGaskrquK1hsKv6h7iz0NXWCNYn_zJEHvYUBYC=2UoA@mail.gmail.com>
Subject: Re: [PATCH -next 1/2] bpf: Unify data extension operation of
 jited_ksyms and jited_linfo
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, linux-riscv@lists.infradead.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
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

On Tue, Apr 26, 2022 at 6:40 AM Pu Lehui <pulehui@huawei.com> wrote:
>
> We found that 32-bit environment can not print bpf line info due
> to data inconsistency between jited_ksyms[0] and jited_linfo[0].
>
> For example:
> jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c
>
> We know that both of them store bpf func address, but due to the
> different data extension operations when extended to u64, they may
> not be the same. We need to unify the data extension operations of
> them.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  kernel/bpf/syscall.c                         |  5 ++++-
>  tools/lib/bpf/bpf_prog_linfo.c               |  8 ++++----
>  tools/testing/selftests/bpf/prog_tests/btf.c | 18 +++++++++---------

please split kernel changes, libbpf changes, and selftests/bpf changes
into separate patches

>  3 files changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index e9621cfa09f2..4c417c806d92 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3868,13 +3868,16 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>                 info.nr_jited_line_info = 0;
>         if (info.nr_jited_line_info && ulen) {
>                 if (bpf_dump_raw_ok(file->f_cred)) {
> +                       unsigned long jited_linfo_addr;
>                         __u64 __user *user_linfo;
>                         u32 i;
>
>                         user_linfo = u64_to_user_ptr(info.jited_line_info);
>                         ulen = min_t(u32, info.nr_jited_line_info, ulen);
>                         for (i = 0; i < ulen; i++) {
> -                               if (put_user((__u64)(long)prog->aux->jited_linfo[i],
> +                               jited_linfo_addr = (unsigned long)
> +                                       prog->aux->jited_linfo[i];
> +                               if (put_user((__u64) jited_linfo_addr,
>                                              &user_linfo[i]))
>                                         return -EFAULT;
>                         }
> diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
> index 5c503096ef43..5cf41a563ef5 100644
> --- a/tools/lib/bpf/bpf_prog_linfo.c
> +++ b/tools/lib/bpf/bpf_prog_linfo.c
> @@ -127,7 +127,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>         prog_linfo->raw_linfo = malloc(data_sz);
>         if (!prog_linfo->raw_linfo)
>                 goto err_free;
> -       memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
> +       memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info, data_sz);
>
>         nr_jited_func = info->nr_jited_ksyms;
>         if (!nr_jited_func ||
> @@ -148,7 +148,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>         if (!prog_linfo->raw_jited_linfo)
>                 goto err_free;
>         memcpy(prog_linfo->raw_jited_linfo,
> -              (void *)(long)info->jited_line_info, data_sz);
> +              (void *)(unsigned long)info->jited_line_info, data_sz);
>
>         /* Number of jited_line_info per jited func */
>         prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *
> @@ -166,8 +166,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>                 goto err_free;
>
>         if (dissect_jited_func(prog_linfo,
> -                              (__u64 *)(long)info->jited_ksyms,
> -                              (__u32 *)(long)info->jited_func_lens))
> +                              (__u64 *)(unsigned long)info->jited_ksyms,
> +                              (__u32 *)(unsigned long)info->jited_func_lens))

so I'm trying to understand how this is changing anything for 32-bit
architecture and I must be missing something, sorry if I'm being
dense. The example you used below

jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c

Wouldn't (unsigned long)0xffffffffb800067c == (long)0xffffffffb800067c
== 0xb800067c ?

isn't sizeof(long) == sizeof(void*) == 4?

It would be nice if you could elaborate a bit more on what problems
did you see in practice?

>                 goto err_free;
>
>         return prog_linfo;
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index 84aae639ddb5..d9ba1ec1d5b3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -6451,8 +6451,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>                   info.nr_jited_line_info, jited_cnt,
>                   info.line_info_rec_size, rec_size,
>                   info.jited_line_info_rec_size, jited_rec_size,
> -                 (void *)(long)info.line_info,
> -                 (void *)(long)info.jited_line_info)) {
> +                 (void *)(unsigned long)info.line_info,
> +                 (void *)(unsigned long)info.jited_line_info)) {
>                 err = -1;
>                 goto done;
>         }
> @@ -6500,8 +6500,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>         }
>
>         if (CHECK(jited_linfo[0] != jited_ksyms[0],
> -                 "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
> -                 (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
> +                 "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
> +                 jited_linfo[0], jited_ksyms[0])) {
>                 err = -1;
>                 goto done;
>         }
> @@ -6519,16 +6519,16 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>                 }
>
>                 if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
> -                         "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
> -                         i, (long)jited_linfo[i],
> -                         i - 1, (long)(jited_linfo[i - 1]))) {
> +                         "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
> +                         i, jited_linfo[i],
> +                         i - 1, (jited_linfo[i - 1]))) {
>                         err = -1;
>                         goto done;
>                 }
>
>                 if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
> -                         "jited_linfo[%u]:%lx - %lx > %u",
> -                         i, (long)jited_linfo[i], (long)cur_func_ksyms,
> +                         "jited_linfo[%u]:%llx - %llx > %u",
> +                         i, jited_linfo[i], cur_func_ksyms,
>                           cur_func_len)) {
>                         err = -1;
>                         goto done;
> --
> 2.25.1
>

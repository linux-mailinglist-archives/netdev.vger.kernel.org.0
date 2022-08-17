Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765DD597747
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241624AbiHQT7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbiHQT7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:59:41 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F27F816A2;
        Wed, 17 Aug 2022 12:59:40 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y187so7630493iof.0;
        Wed, 17 Aug 2022 12:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TVMZx3iuKyNmLm6/yTzgJkKKY7X6jM+H6bqdvtZaYSw=;
        b=W1wVRQEJH26dggPuH1cecKm6jqd5BJj3Szv1fKSgaU5HKucFq/BhhjghG7zy0P0Wf0
         d7nidKGp3M02AO2gbvExefPvklYu0U8b2/m5uKB850LwE3eYYPnmx/BFPOm6C3XQkxH7
         MTWBX2FMB7vFr7GOC/8vLvsvDjGWPiJO2h2mBusnqcyfkVJ94DlU99H5N7Dca7srhu7i
         5oO60SfH9IZpEZ19OfFVMlX26WnXrOllwjEAGJlmXuZSS2+agNIXtmhx/j+3OF9yj3N8
         UmJ5hkiLBAW9xwrriSMzfAt4qFB0MbSIiX36Q1H6v1no+dGljFxZ4jexPxOdmsl5amy3
         2oQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TVMZx3iuKyNmLm6/yTzgJkKKY7X6jM+H6bqdvtZaYSw=;
        b=wsaOTFqEuPfUWha0g9N4JhSFlzFZyI88+OGX10+6TLHFIVjwsJLsHDsFcG0/7YyWnq
         grwNX5jqtg9eP69FMq+pF3u2y2rO+OGS1An64aHcvp1RrpSAP38fn/l0f3Ub9ADucW4F
         meYPnLXv8cFyVfLClLXXdF2nEFXs37FBGZ2jJh32dnYPg66gy6N6WiK+JTFB4MayXa3S
         H66nyU42JpYtZX8ptVk+wr0y7HPsr7YyWI10JyXP0mJ1oUm262bb+4rD1VW9ipv7Bk4t
         0rYvRyf8ydTjaVn2vtORQavXFZld6AD1ptXzFCktzH/BQUSlO/8UiERZyYqchcDOg1DM
         r2EA==
X-Gm-Message-State: ACgBeo3ge3L1COSb972eClyZN5o+FcKsa7dmeqY3iUqfzaD3zcuKm3Pv
        X5RGg7ZgGuCth31kWVKcUGNAjTHtjUt8RwCSYkg=
X-Google-Smtp-Source: AA6agR6WEApibozSRGDmOEya9vr30Zl3Aeztco/LZh7dDE8HLOjv0p9Rqq6vZhg3lSCoMRTqeGXh7YYwPNBs8Xjk/wo=
X-Received: by 2002:a05:6638:2381:b0:346:c583:9fa0 with SMTP id
 q1-20020a056638238100b00346c5839fa0mr2258621jat.93.1660766379803; Wed, 17 Aug
 2022 12:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660761470.git.dxu@dxuuu.xyz> <7519a65ba6bd6e41ba0c580c81d4202c5982ea64.1660761470.git.dxu@dxuuu.xyz>
In-Reply-To: <7519a65ba6bd6e41ba0c580c81d4202c5982ea64.1660761470.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 17 Aug 2022 21:59:03 +0200
Message-ID: <CAP01T75r-K_AWK8k8+zpWEPgBMcjWzein9Ho+MbjSn+iJg4OGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] selftests/bpf: Add tests for writing to nf_conn:mark
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 17 Aug 2022 at 20:43, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Add a simple extension to the existing selftest to write to
> nf_conn:mark. Also add a failure test for writing to unsupported field.
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  1 +
>  tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  6 ++++--
>  .../testing/selftests/bpf/progs/test_bpf_nf_fail.c | 14 ++++++++++++++
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index 544bf90ac2a7..45389c39f211 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -17,6 +17,7 @@ struct {
>         { "set_status_after_insert", "kernel function bpf_ct_set_status args#0 expected pointer to STRUCT nf_conn___init but" },
>         { "change_timeout_after_alloc", "kernel function bpf_ct_change_timeout args#0 expected pointer to STRUCT nf_conn but" },
>         { "change_status_after_alloc", "kernel function bpf_ct_change_status args#0 expected pointer to STRUCT nf_conn but" },
> +       { "write_not_allowlisted_field", "no write support to nf_conn at off" },
>  };
>
>  enum {
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> index 2722441850cc..638b6642d20f 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -175,8 +175,10 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
>                        sizeof(opts_def));
>         if (ct) {
>                 test_exist_lookup = 0;
> -               if (ct->mark == 42)
> -                       test_exist_lookup_mark = 43;
> +               if (ct->mark == 42) {
> +                       ct->mark++;

Please also include a test for setting ct->mark on allocated but not
inserted nf_conn. For that you might have to add another check in the
btf_struct_access callback to also consider nf_conn___init equivalent
to nf_conn. We use a container type to deny operations that are not
safe for allocated ct, but the layout is same for both (since it just
embeds struct nf_conn inside it), so the rest of the logic should work
the same.

> +                       test_exist_lookup_mark = ct->mark;
> +               }
>                 bpf_ct_release(ct);
>         } else {
>                 test_exist_lookup = opts_def.error;
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
> index bf79af15c808..0e4759ab38ff 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
> @@ -69,6 +69,20 @@ int lookup_insert(struct __sk_buff *ctx)
>         return 0;
>  }
>
> +SEC("?tc")
> +int write_not_allowlisted_field(struct __sk_buff *ctx)
> +{
> +       struct bpf_ct_opts___local opts = {};
> +       struct bpf_sock_tuple tup = {};
> +       struct nf_conn *ct;
> +
> +       ct = bpf_skb_ct_lookup(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
> +       if (!ct)
> +               return 0;
> +       ct->status = 0xF00;
> +       return 0;
> +}
> +
>  SEC("?tc")
>  int set_timeout_after_insert(struct __sk_buff *ctx)
>  {
> --
> 2.37.1
>

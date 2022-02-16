Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3076B4B9357
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiBPVoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:44:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiBPVob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:44:31 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0B719FAEB;
        Wed, 16 Feb 2022 13:44:18 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id h5so1422268ioj.3;
        Wed, 16 Feb 2022 13:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RYNWyjsrJKUeGFVWAqHRDg1L8mbtW6CitmbokQnb4c4=;
        b=jzkcBdXiayCpqR1fD7fXSpPw4r6Dx8Mhmq6CkXr4jwujehq8fGGpoWUKV8NBlMEAaA
         0jz5nAdy5wJCsIYRT7GnLlJsyCPLVs93ojILFLrCnDOwi+P1E4Acf9TuzGLQ7dz8mTnl
         gBRMRNVXeJoDCSyN1nrVLKQEN60HXEsTRXg8MQWifV5Bl3BLXDqdZtWBgDfhU0NsuIPL
         QLCvAkewJB1KO62a3f9YKyptSAVEEM9oIAIY+ylaHA+HOaQO1eUdeWGhdh4Km/UfzAfy
         apkFB05gnvuusz4B8twRxpHjadwBjjv0qlbjF/cOXgzm9BCH+UOiwvuAOvdQGw0ldgAy
         FaVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RYNWyjsrJKUeGFVWAqHRDg1L8mbtW6CitmbokQnb4c4=;
        b=3UZkn1yyqy+jDxV+X7CL1b/FwN1pBRf++wmX1TKeaOMeR2s3lORiIv3sh0cfjfpGS9
         CvgOi8TuUDGcYiIO7atFH0S8jH+pHZva4kFrWkQ7n/f+RKpHq+Z1xivsB+Uu59njn78a
         MDH7FsJpyebmcBBSQXEONt1J3H42D+WYkV6hjOgyJFoRrx+UL/HaUYpI2X85/GY8XUco
         WWtjvyxKAxRUDyyLXJyAYBrBrFJbAcno3ge91KJlcu7MTgNIg5Hr4aWiSbe0EJPifJL1
         N4YBZBaB4QmdV3F4MIn+PadHcOkja9sXqOx2T1MEd2/KDJWbiZSVM4qyxDhowqwE5hSv
         2WpQ==
X-Gm-Message-State: AOAM533Y+BaVTstcNiu1CvpsB0SEnn4GKUILghfOz36DjSqwm5vf/QuO
        nG9ieQ6PzYuFGhATwcWd2vrrgWCN1udu1JQyQlY=
X-Google-Smtp-Source: ABdhPJxSWSDwAW7t7uEQ+tskmXGNqOJa7/JLTu86AFxLRnQ1Rw8XA+MPMRHr6kDz/edSffA65x32hySYMCSJ3UYa0e0=
X-Received: by 2002:a05:6638:1035:b0:306:e5bd:36da with SMTP id
 n21-20020a056638103500b00306e5bd36damr3097022jan.145.1645047858028; Wed, 16
 Feb 2022 13:44:18 -0800 (PST)
MIME-Version: 1.0
References: <20220209184333.654927-1-jakub@cloudflare.com> <20220209184333.654927-3-jakub@cloudflare.com>
In-Reply-To: <20220209184333.654927-3-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Feb 2022 13:44:07 -0800
Message-ID: <CAEf4BzaRNLw9_EnaMo5e46CdEkzbJiVU3j9oxnsemBKjNFf3wQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: Cover 4-byte load from
 remote_port in bpf_sk_lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Yonghong Song <yhs@fb.com>
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

On Wed, Feb 9, 2022 at 10:43 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Extend the context access tests for sk_lookup prog to cover the surprising
> case of a 4-byte load from the remote_port field, where the expected value
> is actually shifted by 16 bits.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/include/uapi/linux/bpf.h                     | 3 ++-
>  tools/testing/selftests/bpf/progs/test_sk_lookup.c | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index a7f0ddedac1f..afe3d0d7f5f2 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -6453,7 +6453,8 @@ struct bpf_sk_lookup {
>         __u32 protocol;         /* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
>         __u32 remote_ip4;       /* Network byte order */
>         __u32 remote_ip6[4];    /* Network byte order */
> -       __u32 remote_port;      /* Network byte order */
> +       __be16 remote_port;     /* Network byte order */
> +       __u16 :16;              /* Zero padding */
>         __u32 local_ip4;        /* Network byte order */
>         __u32 local_ip6[4];     /* Network byte order */
>         __u32 local_port;       /* Host byte order */
> diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> index 83b0aaa52ef7..bf5b7caefdd0 100644
> --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> @@ -392,6 +392,7 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
>  {
>         struct bpf_sock *sk;
>         int err, family;
> +       __u32 val_u32;
>         bool v4;
>
>         v4 = (ctx->family == AF_INET);
> @@ -418,6 +419,11 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
>         if (LSW(ctx->remote_port, 0) != SRC_PORT)
>                 return SK_DROP;
>
> +       /* Load from remote_port field with zero padding (backward compatibility) */
> +       val_u32 = *(__u32 *)&ctx->remote_port;
> +       if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
> +               return SK_DROP;
> +

Jakub, can you please double check that your patch set doesn't break
big-endian architectures? I've noticed that our s390x test runner is
now failing in the sk_lookup selftest. See [0]. Also CC'ing Ilya.

  [0] https://github.com/libbpf/libbpf/runs/5220996832?check_suite_focus=true

>         /* Narrow loads from local_port field. Expect DST_PORT. */
>         if (LSB(ctx->local_port, 0) != ((DST_PORT >> 0) & 0xff) ||
>             LSB(ctx->local_port, 1) != ((DST_PORT >> 8) & 0xff) ||
> --
> 2.31.1
>

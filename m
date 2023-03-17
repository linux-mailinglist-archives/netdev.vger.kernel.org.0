Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110056BF563
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 23:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCQWyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 18:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCQWyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 18:54:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC952D158;
        Fri, 17 Mar 2023 15:53:59 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id o12so25943876edb.9;
        Fri, 17 Mar 2023 15:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679093638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxcscQpEHLnaeOooSuH4y8zJ8+C4M9AWirRegKoe4TM=;
        b=CUejwAGLl3p9XzWIdfvqkCU6yFrRUFZ10jKtERMBcC5haMMNv2arAX/ovPoORwIrDz
         v9gXLjRkH0+P7Mt7bkBkFaWFiurFXqwC1OBC+XMhMDnCUZZCCGWZF0FkrTTsqT/A5rN1
         Ti+K5T3B+0UfaAgZP1PK0FqvWXjDoBQhJJOvL/hhGkM7RHtOxedA7JoKxtCN05ADHr75
         ACMl6yYvSIofCpVShO62+O8HTiATHy/rB70diaNMcf/EsrkdcP9zDLOM4TZiFvfb3aM3
         +N0cN7DlXNVP/fe+3tBwnIPwrXfWiRD5i9HBl4yZa43RaCMHeVma2QoRmDMbg8gqpuGx
         oCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679093638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxcscQpEHLnaeOooSuH4y8zJ8+C4M9AWirRegKoe4TM=;
        b=SNOt67oHN0y7p+C6rqIvec9vOCmVtafACQpZqgPCtf0ZP7SI4ongyDkdR2q40n8Atx
         pIRu/1VoarbdQfoxmDAEmoisgZ8SYKIAN62/3GlZlEwd+iWYx/o4070piw6dSN+EBL6I
         AYPD/y7UFXItLopAZnGDLELYcvmmIHbBlnA8JEDOoQvt7OI9pL0/bIngf2zEGsRVIylB
         GjJTwOSou/zVX76Ru/HGRofPqQiyfD5b0bQlrkBb5DD+Zscbu1R6cwFhcA67Z4GOd7Cg
         gTG1EmOXGNTtjFE6RksBbAtl2/rSOMIgoH8JMVU7lNYPRv2aHGFy4VDCZbq05UjcO/4H
         3NwA==
X-Gm-Message-State: AO0yUKWm4XrsOIVtsTnoBrT4KDidm3P0nSu0W1NvZ6ZS94HC8WSKOjXf
        8yjKJAH35tv/AW+L0VHBRS0iWp0lj1LltgAGaxw=
X-Google-Smtp-Source: AK7set+6O7oYBVrl6t06b5toEviMhXKmMCoPH07g+MtN2a/sh/c5A27nhjWefQ3SapEtDnCG4eqH4daGK9pfCQLPRG4=
X-Received: by 2002:a50:c408:0:b0:4fc:1608:68c8 with SMTP id
 v8-20020a50c408000000b004fc160868c8mr2624969edf.1.1679093637745; Fri, 17 Mar
 2023 15:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com> <20230317201920.62030-4-alexei.starovoitov@gmail.com>
In-Reply-To: <20230317201920.62030-4-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Mar 2023 15:53:45 -0700
Message-ID: <CAEf4BzaE=+5hSuJ238Amyd-1a+Qm89=KgBKi50EZkKC41+A9-A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: Introduce bpf_ksym_exists() macro.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 1:19=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce bpf_ksym_exists() macro that can be used by BPF programs
> to detect at load time whether particular ksym (either variable or kfunc)
> is present in the kernel.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/bpf_helpers.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 7d12d3e620cc..b49823117dae 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -177,6 +177,9 @@ enum libbpf_tristate {
>  #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
>  #define __kptr __attribute__((btf_type_tag("kptr")))
>
> +#define bpf_ksym_exists(sym) \
> +       ({ _Static_assert(!__builtin_constant_p(!!sym), #sym " should be =
marked as __weak"); !!sym; })
> +

I reformatted this to fit under 100 characters.

-#define bpf_ksym_exists(sym) \
-       ({ _Static_assert(!__builtin_constant_p(!!sym), #sym " should
be marked as __weak"); !!sym; })
+#define bpf_ksym_exists(sym) ({
                                 \
+       _Static_assert(!__builtin_constant_p(!!sym), #sym " should be
marked as __weak");       \
+       !!sym;
                         \
+})


Other than that, it looks great! Applied to bpf-next, thanks.



>  #ifndef ___bpf_concat
>  #define ___bpf_concat(a, b) a ## b
>  #endif
> --
> 2.34.1
>

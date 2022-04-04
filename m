Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D6A4F0D1F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376760AbiDDAEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiDDAEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:04:54 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FE532EDF;
        Sun,  3 Apr 2022 17:02:59 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id 14so5730001ily.11;
        Sun, 03 Apr 2022 17:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tIgHyqz4/1sXAHyLaXGAJ7Tj9MXYOswEHmYuO4dH3gU=;
        b=Px6/sfJAAtEoSKD0CVO1B4ZRLpKaIJHiDZoNGpmq+5Y5oHAehZsqm5OoKB4XKSzqA2
         HmQ455NW9KXiJp163PyBCcq2mGmwQPu6oZwkO8aqo3WKpOFaVUdvgxEZgtV5UcabAlSj
         eEKFVaLBNAw+FqL4aYqYLrMw9nWsY0BpJaZJnKUEDxPKuEB1cEEW1OIqgRhabwqb3lWy
         r1XYJD2+x3OaTcYqECEVZW3pqi2Z5jVV6nY8w7R2K3prpixyP7yIKMbWz3ZhqRmUMQ5Y
         NL7RK2NxveFQRc1fYLe0rEWYXt2WHlfbRnlp6ryJyIpDOLqLOgIIt5cuSmb9ZqQeEn7x
         ih9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tIgHyqz4/1sXAHyLaXGAJ7Tj9MXYOswEHmYuO4dH3gU=;
        b=IvuGLZwd3oZCKxsqxlFbjOXWD4mM2Ur1lDD+MsUmYmI1I7p4lhZlsUso7/dunN22RU
         DBTmXO7bDA3smLO/FhH8o1DSTEEWMwJf8KGPK2FWaVJOJ/WNp7C2IzelBW8lBEp1pimB
         z5Icb3KRlSjdzEqrAUquhRmGF9+0byXxHMBpG8UDGPXCFgvnuCsIUywPVF2+PDk3ROIT
         YDPsl+2HzXie2K/EnpVgWBkXWiTKz86yYmZn9t/tJ9ieRAVBeddqPKPgA05WFe7EVQ+n
         3AFe3kK9CWBqTbHaJD6YJWFCz+UwWN07S9mkZkSfoK8vrYqTvGpBKZf5zew/Oj071VPS
         jlIw==
X-Gm-Message-State: AOAM532NXFoyP8k9iZI3M7DGAKZ/DyIVjMIZ0qts1+KPs/mGDWoleci3
        8TMDz/+5FZkWOrsJlIR2urINLf4LBTgWpSk4PTGcZfhi
X-Google-Smtp-Source: ABdhPJyGeIL2M2pyJE/TM1f7L6G8mvS+ud9UGoXNIx14xnnd1qaOsX3Q2Rgwa69DBIPBCKANonkPpaa5aUIAnycD5e8=
X-Received: by 2002:a92:cd89:0:b0:2c9:bdf3:c5dd with SMTP id
 r9-20020a92cd89000000b002c9bdf3c5ddmr4035472ilb.252.1649030579155; Sun, 03
 Apr 2022 17:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220403135245.1713283-1-ytcoode@gmail.com>
In-Reply-To: <20220403135245.1713283-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 17:02:48 -0700
Message-ID: <CAEf4BzbcXAhRakTAvh8PC2QTnr+zO7U-NbL4VO+VY7QZd_8Ezw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix cd_flavor_subdir() of test_progs
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Sun, Apr 3, 2022 at 6:53 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> Currently, when we run test_progs with just executable file name, for
> example 'PATH=. test_progs-no_alu32', cd_flavor_subdir() will not check

First time seeing this PATH=. trick just to avoid
./test_progs-no_alu32, but sure, the fix makes sense. Applied to
bpf-next.

> if test_progs is running as a flavored test runner and switch into
> corresponding sub-directory.
>
> This will cause test_progs-no_alu32 executed by the
> 'PATH=. test_progs-no_alu32' command to run in the wrong directory and
> load the wrong BPF objects.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index 2ecb73a65206..0a4b45d7b515 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -761,8 +761,10 @@ int cd_flavor_subdir(const char *exec_name)
>         const char *flavor = strrchr(exec_name, '/');
>
>         if (!flavor)
> -               return 0;
> -       flavor++;
> +               flavor = exec_name;
> +       else
> +               flavor++;
> +
>         flavor = strrchr(flavor, '-');
>         if (!flavor)
>                 return 0;
> --
> 2.35.1
>

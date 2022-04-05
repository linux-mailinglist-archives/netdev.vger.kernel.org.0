Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F844F53BD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445842AbiDFEWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845804AbiDFCBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 22:01:20 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEF724B0B1;
        Tue,  5 Apr 2022 16:28:49 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e22so1024084ioe.11;
        Tue, 05 Apr 2022 16:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PUMn2pJdmTqU9T1LboNHqySso6NmNTYjmvIQ/4E+6jg=;
        b=gNe8qsL51ziO0gB71BLSIYx0dhQmBI6zDUfVHVMAec4jf0pQWeA1zZ2h4sxZU8GVXA
         gwUULa+cnWQ/VxFgfOj97piyqAh4IFJLybVUZPOCK9XmdbSbzVB2zd3tGNBgypwj1rPh
         9muXPJS+9ogRaxX9AaruMwEI28RqkVAL4VCFJBahhFKgRrqycnSZO67AiPJq57+Jg0hN
         rkbNi5jOgama1LtciEKjBZY0SR+ZZVR6qdmiR80UIKktan1Dvey1RiQ+ZlK3Zw+5Migj
         3daCkrMJ2AETNxGIOuJDRDH2L7/CvWH+q99dqTdC3xZ0VlLhj0MZAV5UWFtqFqID5Lo2
         fHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PUMn2pJdmTqU9T1LboNHqySso6NmNTYjmvIQ/4E+6jg=;
        b=rN3eEdp/SYNWmwvXGfgmKmKZsRrv4BzKOFEm4SxYML0J3qPzFiMoipP6baKEfG1JbN
         upXHLesc1oJ8+1XZwwRz2gT5tos+y48BVwhvoQDkPSLOws9RJ9bpnjvQJ+xmVALREHxy
         pxhix35DWiagjAu6foNxRXriCmMitlmBJ1NkdgYx6SjOY8YiCfRV5QfSPasqypMOLdU9
         7nIaWhU3sxAhUVE6EdLjsJw24eTUq7ZNBfkoDYoUbqmvF2N9TuyS8MVvQtYYA2wX0+/6
         ehZXep5Eq2U721KJ/pgYk25qEtR71tl8QnJGStJcXMQ44GnCCWtBdj6qmd2N/rCCbnvI
         Btsg==
X-Gm-Message-State: AOAM532HDWpEaATrBYEa+fP5TB21WjqzzdlZpzjVssOyoiV4qUE6oJ/j
        l3D439WzCFShQE4z7G2dTon4vGVGKfpmxD2dakw=
X-Google-Smtp-Source: ABdhPJyKqUsGJx3oQJikLMMo7nQ3XQuZBU6aXhgu0HkBIbtVmBQTJNGbQwnmNfviladdps3TCxWYY7vRUoJCBgdNSMY=
X-Received: by 2002:a6b:8bd7:0:b0:646:2804:5c73 with SMTP id
 n206-20020a6b8bd7000000b0064628045c73mr2711308iod.112.1649201328273; Tue, 05
 Apr 2022 16:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZrc=wr4FLkWkOSEeprzybA8JTipsnr_U1kYA0785WkTw@mail.gmail.com>
 <20220405062403.22591-1-ytcoode@gmail.com>
In-Reply-To: <20220405062403.22591-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Apr 2022 16:28:37 -0700
Message-ID: <CAEf4BzbSbMMoZM-3fkhZnbxk0bu5ySDO782WGbgcKUzs-u6N_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Fix issues in parse_num_list()
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
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

On Mon, Apr 4, 2022 at 11:24 PM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> There are some issues in parse_num_list():
>
> First, the end variable is assigned twice when parsing_end is true, it is
> unnecessary.
>
> Second, the function does not check that parsing_end is false after parsing
> argument. Thus, if the final part of the argument is something like '4-',
> parse_num_list() will discard it instead of returning -EINVAL.
>
> Clean up parse_num_list() and fix these issues.
>
> Before:
>
>  $ ./test_progs -n 2,4-
>  #2 atomic_bounds:OK
>  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>
> After:
>
>  $ ./test_progs -n 2,4-
>  Failed to parse test numbers.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
> v1 -> v2: add more details to commit message
>
>  tools/testing/selftests/bpf/testing_helpers.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
> index 795b6798ccee..82f0e2d99c23 100644
> --- a/tools/testing/selftests/bpf/testing_helpers.c
> +++ b/tools/testing/selftests/bpf/testing_helpers.c
> @@ -20,16 +20,16 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
>                 if (errno)
>                         return -errno;
>
> -               if (parsing_end)
> -                       end = num;
> -               else
> +               if (!parsing_end) {
>                         start = num;
> +                       if (*next == '-') {
> +                               s = next + 1;
> +                               parsing_end = true;
> +                               continue;
> +                       }
> +               }
>
> -               if (!parsing_end && *next == '-') {
> -                       s = next + 1;
> -                       parsing_end = true;
> -                       continue;
> -               } else if (*next == ',') {

I think the new structure of the code is actually harder to follow and
there is no need to change this code in the first place just to
optimize away parsing_end assignmet.

> +               if (*next == ',') {
>                         parsing_end = false;
>                         s = next + 1;
>                         end = num;
> @@ -60,7 +60,7 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
>                         set[i] = true;
>         }
>
> -       if (!set)
> +       if (!set || parsing_end)
>                 return -EINVAL;
>

this is a real fix, please submit just and drop the first part of the patch

>         *num_set = set;
> --
> 2.35.1
>

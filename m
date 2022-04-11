Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CDF4FB292
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 06:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbiDKEOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 00:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiDKEOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 00:14:21 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BED25F3;
        Sun, 10 Apr 2022 21:12:08 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e22so17274048ioe.11;
        Sun, 10 Apr 2022 21:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=28KDkHQg1bfu2ZxEsxkdsWjXzFVXknzOfbF/hqHTX2w=;
        b=MQJAvVg/2kkiy9VqbFyprvL49C2jBI5NaO9uGEd9e3rhZ4E35OIecK1sGK7Lavzsr1
         rVWMhTmXgEKb91xsKKXKWmoypfAGTTQrX+zTKK6CXvzb6A/4luxDKv5ezeHFtRRbrV4G
         2bLuX+D3HSpw+SLidB+yfy18LBn5hSbHgNLzQmY8ilTNyYFBKswZ5TtEFX3llpkDJrVN
         vi/35PI3ikz3T1KPQCQiQWS6jhSiszQ3RqS2m6yAyl3Z7D3Ugeog1KIU0gkEUwpeR7n5
         Ser4amr/fgWyIcg+4G3dT7bHvl04xihamLpPkg5PbfsNA0q+GVhDrh23Cc/+Ou24a29b
         kFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28KDkHQg1bfu2ZxEsxkdsWjXzFVXknzOfbF/hqHTX2w=;
        b=CetbRZqRGk2Mwe8ABvJhoNp//ozl+HbEClPYW8q1XN3itTVSxvRoFTmaO+PwlgQQwV
         dCnSPDyZ6OCyZP40d2cuh1nbS/s6phH7p/HF7MDcBvCGO8Odw/jvX9cg58CsXyHahpRJ
         g3RnpnbJ3w1b/+/9w7geBiKaYasgNJ895R9lZbjhv/u90DI6zXrjXHWX5X3XEboKfRmB
         2ULcbu+MrTMQzyDykzvHq83brDEgUg0r7yMmRm8Cj7Nm/sd1q3nBiJYDKocX9fZjBNDY
         O/63hjilO3wuVitI+PyWZ13Y39Vr58WEn0GHyM9zX+eM+cNDWiQM+UwMCPzjT9UiC2oN
         MfvQ==
X-Gm-Message-State: AOAM531OU3UXUIYwQ+OfJY3c7JMXry5DzfWW+GLa4QBMiQ8SCl4yxF43
        KCQQFKrMtYEhhf0xpwC+2PJrL3vzxn37pNbmExM2lSSD
X-Google-Smtp-Source: ABdhPJw8XS5jgq/4xkBkH9QjSRJA01n680HyviK/aMzVcJiaQk/kCT2IhGLM1dSHWErr0rmVx6X+DVNvWUwG0f+yS4Q=
X-Received: by 2002:a05:6638:772:b0:319:e4eb:adb with SMTP id
 y18-20020a056638077200b00319e4eb0adbmr14819500jad.237.1649650326068; Sun, 10
 Apr 2022 21:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com> <1649458366-25288-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1649458366-25288-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 10 Apr 2022 21:11:55 -0700
Message-ID: <CAEf4BzYVGOnLksE+UXoqUr5tgvd9gXthSzkWX7jqEgJ+oib1GA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: usdt aarch64 arg parsing support
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
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

On Fri, Apr 8, 2022 at 3:53 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Parsing of USDT arguments is architecture-specific; on aarch64 it is
> relatively easy since registers used are x[0-31], sp.  Format is
> slightly different compared to x86_64; forms are
>
> - "size @ [ reg[,offset] ]" for dereferences, for example
>   "-8 @ [ sp, 76 ]" ; " -4 @ [ sp ]"
> - "size @ reg" for register values; for example
>   "-4@x0"
> - "size @ value" for raw values; for example
>   "-8@1"
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/usdt.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
> index 0677bbd..6165d40 100644
> --- a/tools/lib/bpf/usdt.c
> +++ b/tools/lib/bpf/usdt.c
> @@ -1170,7 +1170,7 @@ static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note,
>
>  /* Architecture-specific logic for parsing USDT argument location specs */
>
> -#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__)
> +#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__) || defined(__aarch64__)
>
>  static int init_usdt_arg_spec(struct usdt_arg_spec *arg, enum usdt_arg_type arg_type, int arg_sz,
>                               __u64 val_off, int reg_off)
> @@ -1316,6 +1316,54 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>         return len;
>  }
>
> +#elif defined(__aarch64__)
> +
> +static int calc_pt_regs_off(const char *reg_name)
> +{
> +       int reg_num;
> +
> +       if (sscanf(reg_name, "x%d", &reg_num) == 1) {
> +               if (reg_num >= 0 && reg_num < 31)
> +                       return offsetof(struct user_pt_regs, regs[reg_num]);
> +       } else if (strcmp(reg_name, "sp") == 0) {
> +               return offsetof(struct user_pt_regs, sp);
> +       }
> +       pr_warn("usdt: unrecognized register '%s'\n", reg_name);
> +       return -ENOENT;
> +}
> +
> +static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
> +{
> +       char *reg_name = NULL;
> +       int arg_sz, len, ret;
> +       long off = 0;
> +
> +       if (sscanf(arg_str, " %d @ \[ %m[^,], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3 ||
> +           sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {

I'm not sure about the behavior here w.r.t. reg_name and memory
allocation. What if first sscanf() matches reg_name but fails at %ld,
will reg_name be allocated and then second sscanf() will reallocate
(and thus we'll have a memory leak).

We might have similar problems in other implementations, actually...

Either way, came here to ask to split two sscanfs into two separate
branches, so that we have a clear linear pattern. One sscanf, handle
it if successful, otherwise move on to next case.

Also a question about [a-z0-9] for register in one case and [^,] in
another. Should the first one be [a-z0-9] as well?

> +               /* Memory dereference case, e.g., -4@[sp, 96], -4@[sp] */
> +               ret = init_usdt_arg_spec(arg, USDT_ARG_REG_DEREF, arg_sz, off,
> +                                        calc_pt_regs_off(reg_name));
> +               free(reg_name);
> +       } else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
> +               /* Constant value case, e.g., 4@5 */
> +               ret = init_usdt_arg_spec(arg, USDT_ARG_CONST, arg_sz, off, 0);
> +       } else if (sscanf(arg_str, " %d @ %ms %n", &arg_sz, &reg_name, &len) == 2) {
> +               /* Register read case, e.g., -8@x4 */
> +               ret = init_usdt_arg_spec(arg, USDT_ARG_REG, arg_sz, 0, calc_pt_regs_off(reg_name));
> +               free(reg_name);
> +       } else {
> +               pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
> +               return -EINVAL;
> +       }
> +
> +       if (ret < 0) {
> +               pr_warn("usdt: unsupported arg #%d (spec '%s') size: %d\n",
> +                       arg_num, arg_str, arg_sz);
> +               return ret;
> +       }
> +       return len;
> +}
> +
>  #else
>
>  static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
> --
> 1.8.3.1
>

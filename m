Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DBC5FAA31
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJKBfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJKBfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:35:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E404D4FA;
        Mon, 10 Oct 2022 18:35:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m15so18042783edb.13;
        Mon, 10 Oct 2022 18:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I5pt7FCzRV0b8PQeZR2wM7TKOPnSu9bqmN2Ckrkc5X4=;
        b=TLjqhcNrPe2HVvu/RCTsgi2UDo/CwFiUw6t71gtgrmg5VVHEsnlVrs4e13cWpMbvN+
         mrMjxn9LnclWra6JWlaraRhbrs6Z+5MMIYpIZh/9Wyk6H9J9GOyxFMI6e/fh6+7SRGL+
         8BLNjT9ovgq3TqRo+/h/E6EYS0BBjb2TTJyYMThdfjjP8StsCuYXvMKtLXaK9VsJHUjv
         KNe7MQCZmP3uNbvceThRorYTBHvoc7JPOd83eYCACINsE0C/KisM9CjddSyzGE6Xqvxm
         ogwQgAalRNcSA3P7A8KQN6eTXkQUmbDF/47b5owUv5NMBzo0ERXHp44f5z6AKfoYjvyb
         G3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I5pt7FCzRV0b8PQeZR2wM7TKOPnSu9bqmN2Ckrkc5X4=;
        b=q+NU5oFNgbf+VEZbNkIVDowX2eY+aJZ5tiGJAZ6YYzJAKSYLh4T/eEPh0tJPqqyYNL
         kyKkL1f0MeGQ3gg4hHd3NlHfgbwmmiBhIkuEa73Aa6sWtmPgBQ/XIfrJJsE1Ul+hWsLI
         vwuh8JPyLiHYGr0xFxJWFBXpjAnLRi9Q7f8SOLDnPCjrwxzJZ8cKbQmnY9CoThps9xL/
         TRr2/XOEIRukU1ORiKbZq1IB82JEDgZ0HNIvDHAE/C7nMXwUZlRo6sdSHogb27iIUk5X
         a7+a/5Nb/4YBP0uoK85uZnTLTAF/TnU8Bi+PJnQ3ws1XzkU471lngMlBOUDLFF5+6brM
         CxNQ==
X-Gm-Message-State: ACrzQf3UHVNH60FpLpbCGOZTZNq9Gdt7WGmyWcKx6NI6a9A84FTcY6wY
        YsOrpW2EGjJm7Wo5F5/c3t0wV/wKtbnKcYBlMrI=
X-Google-Smtp-Source: AMsMyM7UhPSJoGLYLt7Qkkdgh6vwjCKobDB7NjqLiYv+KIyNV0V/99FjOewkNIK5qgx2JU8hNw2pCR6hoIgwmKGtf28=
X-Received: by 2002:a50:eb05:0:b0:457:c6f5:5f65 with SMTP id
 y5-20020a50eb05000000b00457c6f55f65mr19992113edp.311.1665452110881; Mon, 10
 Oct 2022 18:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221010142553.776550-1-xukuohai@huawei.com> <20221010142553.776550-5-xukuohai@huawei.com>
In-Reply-To: <20221010142553.776550-5-xukuohai@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Oct 2022 18:34:58 -0700
Message-ID: <CAEf4BzbOgHKfe0bq13qnuQ74TiwT6JW_4Rk3-+YvF2kthhdrcA@mail.gmail.com>
Subject: Re: [PATCH bpf v3 4/6] selftest/bpf: Fix memory leak in kprobe_multi_test
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
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

On Mon, Oct 10, 2022 at 7:08 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> The get_syms() function in kprobe_multi_test.c does not free the string
> memory allocated by sscanf correctly. Fix it.
>
> Fixes: 5b6c7e5c4434 ("selftests/bpf: Add attach bench test")
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../bpf/prog_tests/kprobe_multi_test.c          | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index d457a55ff408..07dd2c5b7f98 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -360,15 +360,14 @@ static int get_syms(char ***symsp, size_t *cntp)
>                  * to them. Filter out the current culprits - arch_cpu_idle
>                  * and rcu_* functions.
>                  */
> -               if (!strcmp(name, "arch_cpu_idle"))
> -                       continue;
> -               if (!strncmp(name, "rcu_", 4))
> -                       continue;
> -               if (!strcmp(name, "bpf_dispatcher_xdp_func"))
> -                       continue;
> -               if (!strncmp(name, "__ftrace_invalid_address__",
> -                            sizeof("__ftrace_invalid_address__") - 1))
> +               if (!strcmp(name, "arch_cpu_idle") ||
> +                       !strncmp(name, "rcu_", 4) ||
> +                       !strcmp(name, "bpf_dispatcher_xdp_func") ||
> +                       !strncmp(name, "__ftrace_invalid_address__",
> +                                sizeof("__ftrace_invalid_address__") - 1)) {
> +                       free(name);
>                         continue;
> +               }

it seems cleaner if we add if (name) free(name) under error: goto
label. And in the success case when we assign name to syms[cnt] we can
reset name to NULL to avoid double-free. WDYT?


>                 err = hashmap__add(map, name, NULL);
>                 if (err) {
>                         free(name);
> @@ -394,7 +393,7 @@ static int get_syms(char ***symsp, size_t *cntp)
>         hashmap__free(map);
>         if (err) {
>                 for (i = 0; i < cnt; i++)
> -                       free(syms[cnt]);
> +                       free(syms[i]);
>                 free(syms);
>         }
>         return err;
> --
> 2.30.2
>

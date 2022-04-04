Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACE24F0D69
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376858AbiDDB0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDB0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:26:42 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3831E27FDE;
        Sun,  3 Apr 2022 18:24:48 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r2so9544240iod.9;
        Sun, 03 Apr 2022 18:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kttXhxFVW25oGB7hxkgrkvDMxokbvCTSGIpjBrTqwVE=;
        b=X8lEnE5FQzDSgyF2kS6JzLVAFB/yVTeB0VI8vp7lE2mXsODS71xWMg1YevO/eAVRLE
         /wrs2bwJJCSdRIMxxK3pgsMs1wsus2ELO/hDqAzKV++vtMFNYKwPNFy6OWnp2m+ytJ0V
         pDQYT30hh0wLDB1ExySxAuDvC6YSIQp3qepGhrPTtzYr2dEj9mdRyvZ7r+1UP9D8sq5A
         neGkntoXHD68YmENKiRExztOIqOe9N8L0kCkXWYeZ4HYrGzthsk7bSRlJFaVE6T/Xn3Q
         vwgTVm3E5N3u5heXM0l9G7FOtykinE6+HgDuFw2NObMM2hTtoWvPSjX92N1alubv+11x
         nPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kttXhxFVW25oGB7hxkgrkvDMxokbvCTSGIpjBrTqwVE=;
        b=TFaxLPPVOlMANav7GVbC4udHXwVzE/N/y6JKrll8FyzS5expmWOxnmgH2iW81UViPO
         mIuWHOaNlyv5HQLbk5QebCfeYDxYs34PQ9gv8AtJXvah5TAO4fpmZNOujJIfCDboPgo/
         bnh6YAJZCRNCBIicVuhF4QIPqyr9qQlDCSOjB78CCk5sEzZI4hoPMGKa8y+JtDUrQu2M
         W50pz9CQ3ujRxYue0tg7Ate9mo26sX8/V8EaXriSenil3vH60TLhbAp9n8sOHq1VHa3W
         aOuzNOiKRgjUktsx1NFW729m1PDVLDttrwXiWlLlUKtdIZiw8I/uKXe98+Bcs18SOnSB
         Ffqw==
X-Gm-Message-State: AOAM532DGQzGzmpl8pcoYPqksy3uSwe3/92iLt56gGG2Z2xEnodWAeAh
        dd/ofIi1fYla0j9rMThr+Sg2VF7vNeXc3QMEDARQX5aY
X-Google-Smtp-Source: ABdhPJzvRhOn0uoorzdFNcPcHSeI7SdMpsAUwlBBGixJkBDejfm6x8nDAiZSTEddW0Mp2x+At/vypDYIUZQgIQLledQ=
X-Received: by 2002:a05:6638:2642:b0:323:756f:42a7 with SMTP id
 n2-20020a056638264200b00323756f42a7mr10903519jat.145.1649035487690; Sun, 03
 Apr 2022 18:24:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220403144300.6707-1-laoar.shao@gmail.com> <20220403144300.6707-2-laoar.shao@gmail.com>
In-Reply-To: <20220403144300.6707-2-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:24:37 -0700
Message-ID: <CAEf4BzZ2U=H-FEft3twSV7RCgTHHVJ8Dt6_RuYMdHdtC17WM1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/9] bpf: selftests: Use libbpf 1.0 API mode
 in bpf constructor
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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

On Sun, Apr 3, 2022 at 7:43 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> In libbpf 1.0 API mode, it will bump rlimit automatically if there's no
> memcg-basaed accounting, so we can use libbpf 1.0 API mode instead in case
> we want to run it in an old kernel.
>
> The constructor is renamed to bpf_strict_all_ctor().
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  tools/testing/selftests/bpf/bpf_rlimit.h | 26 +++---------------------
>  1 file changed, 3 insertions(+), 23 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_rlimit.h b/tools/testing/selftests/bpf/bpf_rlimit.h
> index 9dac9b30f8ef..d050f7d0bb5c 100644
> --- a/tools/testing/selftests/bpf/bpf_rlimit.h
> +++ b/tools/testing/selftests/bpf/bpf_rlimit.h
> @@ -1,28 +1,8 @@
>  #include <sys/resource.h>
>  #include <stdio.h>
>
> -static  __attribute__((constructor)) void bpf_rlimit_ctor(void)
> +static  __attribute__((constructor)) void bpf_strict_all_ctor(void)

well, no, let's get rid of bpf_rlimit.h altogether. There is no need
for constructor magic when you can have an explicit
libbpf_set_strict_mode(LIBBPF_STRICT_ALL).

>  {
> -       struct rlimit rlim_old, rlim_new = {
> -               .rlim_cur       = RLIM_INFINITY,
> -               .rlim_max       = RLIM_INFINITY,
> -       };
> -
> -       getrlimit(RLIMIT_MEMLOCK, &rlim_old);
> -       /* For the sake of running the test cases, we temporarily
> -        * set rlimit to infinity in order for kernel to focus on
> -        * errors from actual test cases and not getting noise
> -        * from hitting memlock limits. The limit is on per-process
> -        * basis and not a global one, hence destructor not really
> -        * needed here.
> -        */
> -       if (setrlimit(RLIMIT_MEMLOCK, &rlim_new) < 0) {
> -               perror("Unable to lift memlock rlimit");
> -               /* Trying out lower limit, but expect potential test
> -                * case failures from this!
> -                */
> -               rlim_new.rlim_cur = rlim_old.rlim_cur + (1UL << 20);
> -               rlim_new.rlim_max = rlim_old.rlim_max + (1UL << 20);
> -               setrlimit(RLIMIT_MEMLOCK, &rlim_new);
> -       }
> +       /* Use libbpf 1.0 API mode */
> +       libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
>  }
> --
> 2.17.1
>

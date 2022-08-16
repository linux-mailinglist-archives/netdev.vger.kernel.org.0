Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BBB596512
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiHPWBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbiHPWBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:01:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B408E9B6;
        Tue, 16 Aug 2022 15:01:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i14so21364116ejg.6;
        Tue, 16 Aug 2022 15:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=glKujlDWTCM7GpUOGv1USv4qrJLx0zvw0SY7KwEzbcM=;
        b=BzX0UoIIJ/wBB6w3gK0Ts7azlGH31tuckbFfy4pHVqxAAI7M9IAu5PVkBe02OiMifs
         Ksjfb7+r4G3AcxJpY4weDUk2e+wG+It07UiJqlp48oDuh6QRoo0dw8Wjdy/zbZaetFoe
         jDxyxNyggVD0XwGNoNLnr05vpRiT6WvpTuCLrkOuEHdBEE24uNq1IQY0EsvzvBw92eLT
         90Zd/FtMan8Hs0DYtDIeUUtvJsLG5I18UowxgkBw/pcNocIQ+zUUtM9NCJsjMxgFlvSa
         sq8wv9aQjMOFyqUFzL9n5ycJ7dJP41Ta17nw4q61eJ2XDa+RGCIr4SfeTJ/ISDNx8TFp
         ga/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=glKujlDWTCM7GpUOGv1USv4qrJLx0zvw0SY7KwEzbcM=;
        b=hu63z4+3LbwCueYbPcc/il6zaWASMGE0MCLIfQ+qgN+DdvC3M1qFnmJMEgCW6XBlsP
         HYUcor+affpF8uA6NOJlv/Ngcz3TaLXb3UZIPXYrVIUnPiOcMQA3RzJR2PxIfS4PKr7Q
         /UzKjNCVmiK6nqCgYClGZ3J2RxU8cOGKZFnIOTcFcGo5b0J1RDtI8PgACnCiJen8JipC
         Q5t6N919KyB9aZrfQVV+6dWUpDfHRnwU/E9kWAgtouZYrNdzyRDJzZDCqEbj58SVhDuT
         CZZEn8Kjjc5LHxxy1uM0FH74LWqk+WkcGAwGSQHS7gA1cM5DtfnIHuJP66tc9Pz+HteW
         vc5w==
X-Gm-Message-State: ACgBeo3LsruqLuXVfPwVHQRowkzx99IQ6DraEeakn3MOrp5OxqJhw53Q
        Kv5l2hxvfTq7NVZ93QzXE20N7vx1w2QmDq8EwpK8RN0c
X-Google-Smtp-Source: AA6agR6JJCUcLQiU+6/yUgoNeN8mRQvnkM9vtqJBRfdcnNy9xM0QfyZ2S1PHTqnAIJ5dVzarBMo1uT9Syb5ByLFffZE=
X-Received: by 2002:a17:907:3d90:b0:730:a937:fb04 with SMTP id
 he16-20020a1709073d9000b00730a937fb04mr15101754ejc.176.1660687268094; Tue, 16
 Aug 2022 15:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220816214945.742924-1-haoluo@google.com>
In-Reply-To: <20220816214945.742924-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Aug 2022 15:00:56 -0700
Message-ID: <CAEf4Bza1SMFvzofz4RkBF=pByFHp+Z1v16Z+TMAQZ6rD2m9Lxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: allow disabling auto attach
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Jiri Olsa <jolsa@kernel.org>
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

On Tue, Aug 16, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
>
> Add libbpf APIs for disabling auto-attach for individual functions.
> This is motivated by the use case of cgroup iter [1]. Some iter
> types require their parameters to be non-zero, therefore applying
> auto-attach on them will fail. With these two new APIs, Users who
> want to use auto-attach and these types of iters can disable
> auto-attach for them and perform manual attach.
>
> [1] https://lore.kernel.org/bpf/CAEf4BzZ+a2uDo_t6kGBziqdz--m2gh2_EUwkGLDtMd65uwxUjA@mail.gmail.com/
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  tools/lib/bpf/libbpf.c | 16 ++++++++++++++++
>  tools/lib/bpf/libbpf.h |  2 ++
>  2 files changed, 18 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index aa05a99b913d..25f654d25b46 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -417,6 +417,7 @@ struct bpf_program {
>
>         int fd;
>         bool autoload;
> +       bool autoattach;
>         bool mark_btf_static;
>         enum bpf_prog_type type;
>         enum bpf_attach_type expected_attach_type;
> @@ -755,6 +756,8 @@ bpf_object__init_prog(struct bpf_object *obj, struct bpf_program *prog,
>                 prog->autoload = true;
>         }
>
> +       prog->autoattach = true;
> +
>         /* inherit object's log_level */
>         prog->log_level = obj->log_level;
>
> @@ -8314,6 +8317,16 @@ int bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
>         return 0;
>  }
>
> +bool bpf_program__autoattach(const struct bpf_program *prog)
> +{
> +       return prog->autoattach;
> +}
> +
> +void bpf_program__set_autoattach(struct bpf_program *prog, bool autoattach)
> +{
> +       prog->autoattach = autoattach;
> +}
> +
>  const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog)
>  {
>         return prog->insns;
> @@ -12349,6 +12362,9 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
>                 if (!prog->autoload)
>                         continue;
>
> +               if (!prog->autoattach)
> +                       continue;
> +

nit: I'd combine as if (!prog->autoload || !prog->autoattach), they
are very coupled in this sense

>                 /* auto-attaching not supported for this program */
>                 if (!prog->sec_def || !prog->sec_def->prog_attach_fn)
>                         continue;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 61493c4cddac..88a1ac34b12a 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -260,6 +260,8 @@ LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
>  LIBBPF_API const char *bpf_program__section_name(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
>  LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
> +LIBBPF_API bool bpf_program__autoattach(const struct bpf_program *prog);
> +LIBBPF_API void bpf_program__set_autoattach(struct bpf_program *prog, bool autoattach);

please add these APIs to libbpf.map as well

it would be also nice to have a simple test validating that skeleton's
auto-attach doesn't attach program (no link will be created) if
bpf_program__set_autoattach(false) is called before. Can you please
add that as well?

>
>  struct bpf_insn;
>
> --
> 2.37.1.595.g718a3a8f04-goog
>

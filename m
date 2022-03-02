Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF54CB35E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 01:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiCCABR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiCCABI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:01:08 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019444FC6E;
        Wed,  2 Mar 2022 16:00:07 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id 185so2739074qkh.1;
        Wed, 02 Mar 2022 16:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s2VoxRcgzayXC4zVf8d2bV7EKQmBNoz4BFBzN6+8sx8=;
        b=irtUW00dYBE7kRhx89tLLgo+OiHCquwUTazjhPRpgra/Ng8ZdA8XxCmleB4NvxllKh
         4pKE6dlj50+3l1NtV4o9/4ebYa6MzILugoiY6A7PIbHurAxsmGNDq+Azak/YPX7TvXqp
         vWKgPbmVn8eSbnf0s0rlwVptu1i33O5KFWx6cgKlB1Iv/ADRAyqTCutf86BCCCum8X2/
         Bf0AFz6Uc9OqJ9+suUpqFsrW1IvnGHcoqc6V2ESgWgVivWiJrGD9dv/iy4uRrGM+OgIG
         JzhbU+mrHknnWfDH4bhT9zMXZNaDWIeBUzcbCDaaOTAZ4EeZTnnWYTbM3mDIlJ1KSgyy
         PikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s2VoxRcgzayXC4zVf8d2bV7EKQmBNoz4BFBzN6+8sx8=;
        b=wCLGp7OUJp/fLsZela7DxIvXWMqB8fMTaKGEFbVYBpJVhW5arTt6ymEBh+LPLVEJoB
         SBitD97j/9axjRTC5GzF8BYKe0LIwXvp+8KyFUx02QRApxCPyYgOy5yCJBzjSBDR6SEf
         tzAUuLR/0Dxip33xVNuSNyqvSr4CLSpBewlV4bMI2y8CR3ALVHsIRgnBJrZhjrzDHY4L
         4QQTfvAlGrKVe5C47SWMfAJBYoQzSMu+s4vXQRXGiG+futo0FRgWFpP5zX+uv9/EYBZv
         PV9OvMQmw8H+4EplRUvT2mGrKM7g+0Nq+2sILaHvIgXScDwjnhp8el0sXeOJ+NszTQfJ
         euow==
X-Gm-Message-State: AOAM530/h/YHG3cvh0tVvANRZMBksuBNc9m19b9MQE+GzLwZzjR/NQWO
        kfBELprPAxqy7sRyqyySHYOjoL5psvJ9dX7l2+qacind//ASHw==
X-Google-Smtp-Source: ABdhPJxo/W0o2SxPKcSkXdGg8CN8B7z5+TwZFM+qdHIf07npd47aBOy5NLnFlh9FXRccJ7EOY1O/tmylybId+gaV5XE=
X-Received: by 2002:a02:aa85:0:b0:314:c152:4c89 with SMTP id
 u5-20020a02aa85000000b00314c1524c89mr26976369jai.93.1646263965076; Wed, 02
 Mar 2022 15:32:45 -0800 (PST)
MIME-Version: 1.0
References: <20220301165737.672007-1-ytcoode@gmail.com>
In-Reply-To: <20220301165737.672007-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Mar 2022 15:32:34 -0800
Message-ID: <CAEf4BzYYaRyTh=W+ceb6V=Dj+SzoKNV_O24by4j8Fn4oG3gq2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add a check to ensure that page_cnt is non-zero
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Tue, Mar 1, 2022 at 8:57 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> The page_cnt parameter is used to specify the number of memory pages
> allocated for each per-CPU buffer, it must be non-zero and a power of 2.
>
> Currently, the __perf_buffer__new() function attempts to validate that
> the page_cnt is a power of 2 but forgets checking for the case where
> page_cnt is zero, we can fix it by replacing 'page_cnt & (page_cnt - 1)'
> with '!is_power_of_2(page_cnt)'.
>
> Thus we also don't need to add a check in perf_buffer__new_v0_6_0() to
> make sure that page_cnt is non-zero and the check for zero in
> perf_buffer__new_raw_v0_6_0() can also be removed.
>
> The code is cleaner and more readable.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index be6480e260c4..4dd1d82cd5b9 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -33,6 +33,7 @@
>  #include <linux/filter.h>
>  #include <linux/list.h>
>  #include <linux/limits.h>
> +#include <linux/log2.h>

we don't have this header implemented in Github repo, so this will be
unnecessary painful


>  #include <linux/perf_event.h>
>  #include <linux/ring_buffer.h>
>  #include <linux/version.h>
> @@ -10951,7 +10952,7 @@ struct perf_buffer *perf_buffer__new_raw_v0_6_0(int map_fd, size_t page_cnt,
>  {
>         struct perf_buffer_params p = {};
>
> -       if (page_cnt == 0 || !attr)
> +       if (!attr)
>                 return libbpf_err_ptr(-EINVAL);
>
>         if (!OPTS_VALID(opts, perf_buffer_raw_opts))
> @@ -10992,7 +10993,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
>         __u32 map_info_len;
>         int err, i, j, n;
>
> -       if (page_cnt & (page_cnt - 1)) {
> +       if (!is_power_of_2(page_cnt)) {

so let's instead just use `page_cnt == 0 || (page_cnt & (page_cnt -
1))` here explicitly

>                 pr_warn("page count should be power of two, but is %zu\n",
>                         page_cnt);
>                 return ERR_PTR(-EINVAL);
> --
> 2.35.1
>

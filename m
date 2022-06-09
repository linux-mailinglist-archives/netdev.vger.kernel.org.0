Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55895453D6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiFISNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344260AbiFISNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:13:23 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DD73AE826;
        Thu,  9 Jun 2022 11:13:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c2so19813542lfk.0;
        Thu, 09 Jun 2022 11:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nrob4dJ+ClPM90DZzze1TlX2UiKS1UeXsdDvkcnagJw=;
        b=q2ndAPUxqZB4EUjxYrakHR8sR2Y2KpSV3Gfd32qjlN+ecuDeE4/aFgT4DltPyTEwNh
         YmFDunw4MvRwLqzY6Vlu/MTR2ZrUboCXAfac9IfuMnxrSvLR4vqLiRpbh8Qqnhuu53yY
         3wZUl2NCLXhERJ7jeXJdX3j4ApRbBiAP50HcQz5Ma/1OjGoxhJEbzNm6aSVlg0mySoB9
         UqgI8yHK+8WqK0K1EIQJvAU5aGxSVNIbMyV2DQa2bhzlrmLkaCTF6srVG9EEID7iX7b7
         5YSIL+ISMiZIM1AbLSq2Npge4WzTxsFfEBStbYrQa3WGGgXojQT6fraC3Dv+VWgHNMRV
         fVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nrob4dJ+ClPM90DZzze1TlX2UiKS1UeXsdDvkcnagJw=;
        b=mUiR6NPD/Sx5kG0ImvNVfd4uRHze/ofODqHPxzz0jze2PTJVgcVHnn9dNAAbISp8y+
         H9N2JOeT+zKwtHMDMgfwKk8lzVwIMwJo/zpf8DD+843Fpo3kXKpLC8E73+HBtKsgX6RN
         l7W9nKqgOb0SXE4a19fYBKbRqMlUcM9a0CxDB2c/1/AM2rabe985dNH92AlbuDfhvKOv
         1xAFL/GGh+mB1RFuF47PQBZQyxCwnzDweuTAPbmzsMkva/guCGMA8nZBJzMg1BH6to26
         ghOkXAEWT5Jk69ySbijFF8tif50nZdeLarWlCE0f5mHCntTzA1wgpMPXFfR6Z4ookWJh
         yB+w==
X-Gm-Message-State: AOAM532Qk1JrU+oUULpenl5PHT2/aw2t5OeVV5w+HkphXVCvpTPye7sF
        o8fnO4oZyF4794Wu/fTUb/vO4B2EOPu1EeGMX2g=
X-Google-Smtp-Source: ABdhPJywoR8tMewppXrjcU/oGHzyHyh6LYfN0TR1A9shojoyvA6Bka0vdgjtBfHjdxh7zcne0/surTaBVqDcAt/3xR8=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr72050669lfa.681.1654798400337; Thu, 09
 Jun 2022 11:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062412.3950380-1-james.hilliard1@gmail.com>
In-Reply-To: <20220609062412.3950380-1-james.hilliard1@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 11:13:08 -0700
Message-ID: <CAEf4BzbL8ivLH=HZDFTNyCTFjhWrWLcY3K34Ef+q4Pr+oDe_Gw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] libbpf: fix broken gcc SEC pragma macro
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
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

On Wed, Jun 8, 2022 at 11:24 PM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> It seems the gcc preprocessor breaks unless pragmas are wrapped
> individually inside macros when surrounding __attribute__.
>
> Fixes errors like:
> error: expected identifier or '(' before '#pragma'
>   106 | SEC("cgroup/bind6")
>       | ^~~
>
> error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
>   114 | char _license[] SEC("license") = "GPL";
>       | ^~~
>
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
> Changes v2 -> v3:
>   - just fix SEC pragma
> Changes v1 -> v2:
>   - replace typeof with __typeof__ instead of changing pragma macros
> ---
>  tools/lib/bpf/bpf_helpers.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index fb04eaf367f1..66d23c47c206 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -22,11 +22,12 @@
>   * To allow use of SEC() with externs (e.g., for extern .maps declarations),
>   * make sure __attribute__((unused)) doesn't trigger compilation warning.
>   */
> +#define DO_PRAGMA(x) _Pragma(#x)
>  #define SEC(name) \
> -       _Pragma("GCC diagnostic push")                                      \
> -       _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")          \
> +       DO_PRAGMA("GCC diagnostic push")                                    \
> +       DO_PRAGMA("GCC diagnostic ignored \"-Wignored-attributes\"")        \
>         __attribute__((section(name), used))                                \
> -       _Pragma("GCC diagnostic pop")                                       \
> +       DO_PRAGMA("GCC diagnostic pop")                                     \
>

I'm not going to accept this unless I can repro it in the first place.
Using -std=c17 doesn't trigger such issue. Please provide the repro
first. Building systemd is not a repro, unfortunately. Please try to
do it based on libbpf-bootstrap ([0])

  [0] https://github.com/libbpf/libbpf-bootstrap

>  /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
>  #undef __always_inline
> --
> 2.25.1
>

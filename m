Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF64D102D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiCHGXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344558AbiCHGXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:23:05 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20503C72E;
        Mon,  7 Mar 2022 22:22:03 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id x4so4897861iop.7;
        Mon, 07 Mar 2022 22:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ny+bvQl15NDKzbnoc0IGUfL0sMnmAWtlGpGLQc9LX8=;
        b=SS6bErMDRYiSPKtXw5U5pHH1x/3RJ2xdKhyg3EkzpoOdpJl9tz7T1A2wGjZZFK2Yu4
         Kd5k1aOmqE7QJud+/DAZIWVqxYA0C0BBBU68cNcubRpw/LJkyyIUu+1mO2WkFAnccXCS
         N2j29qiSUzAqGbgWqmhHNP5jTbJpGcUas4ipMDaY8+x9N+rxJ+rtOnwkcBSWrRgadRLx
         1uucZStroA8Uj1MLLv1Vl/G0aSHOjooasvUFz05Zszm1pIAbgGXklnAjJnkeMwBQP1OB
         qCYBl3V2r+I76H9YL2h7jz7ikXKUG6/WEvfQL83m7UrxRRExxiBpdtf82zgK8jBbfGl4
         pnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ny+bvQl15NDKzbnoc0IGUfL0sMnmAWtlGpGLQc9LX8=;
        b=sTU56FMwSUAm97M6CilBVSqxX0hJSVd5onw435ZcJ3ea9fTml+oh8OlfvVVtDolMUG
         sMwPB7RNx9K7N3P4Y87OYl7+sYenFxuaT6/zPkV04gqPD8wGGfCNgP5hj2hztiJzKyf+
         1VD14T60BhDUwlRZGmTl6gAXssR7UWSnOQo971cTl0ZLU9Jk4IHl+tCbIfGE6bKT0ZTs
         Yz27kne23QmuNzlXDrMillH7RCEVSmgfVmCQOEvB3ndTrgEcPc8MKLH2Kf6NPuc1xJmJ
         tSPBqtuca1UbkCaZ6aSnwSq9WKZcK2Fx/tCJazWq1ylGK5N7BFbtc9CmI53foTAIE7Tl
         bbEw==
X-Gm-Message-State: AOAM5318OzOuiGANswwH6L5I59sAGCD8Zd+hcFZb8PH6Zw/SiFLjCSJB
        gw5f/wGhcP7D9IIGkFF/tJjk5AI5BvnuO2cW65Q=
X-Google-Smtp-Source: ABdhPJy8Lldrfb4Vhog14fmL5bR1TsOCIt+Og+6AojexAg+a9CpY/lGV7s5sR50zVj43NfzU2hYF7Ig3zTax2Mv3iF0=
X-Received: by 2002:a02:aa85:0:b0:314:c152:4c89 with SMTP id
 u5-20020a02aa85000000b00314c1524c89mr13900549jai.93.1646720523349; Mon, 07
 Mar 2022 22:22:03 -0800 (PST)
MIME-Version: 1.0
References: <56b9dab5-6a3d-58ff-69c9-7abaabf41d05@isovalent.com> <20220308044339.458876-1-ytcoode@gmail.com>
In-Reply-To: <20220308044339.458876-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 22:21:52 -0800
Message-ID: <CAEf4BzY-b_NfX4LPo87uB25XdWSQXEX=wYrGbDpihGBbcJaMKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: Clean up Makefile of bpf preload
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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

On Mon, Mar 7, 2022 at 8:45 PM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> The trailing slash in LIBBPF_SRCS is redundant, it should be removed.
>
> But to simplify the Makefile further, we can set LIBBPF_INCLUDE to
> $(srctree)/tools/lib directly, thus the LIBBPF_SRCS variable is unused
> and can be removed.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
> v1->v2: get rid of LIBBPF_SRCS
>

Oops, didn't notice v2. But I ended up pushing the same thing in your
v1, hope that's fine.

>  kernel/bpf/preload/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 167534e3b0b4..7284782981bf 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>
> -LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
> -LIBBPF_INCLUDE = $(LIBBPF_SRCS)/..
> +LIBBPF_INCLUDE = $(srctree)/tools/lib
>
>  obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o
>  CFLAGS_bpf_preload_kern.o += -I $(LIBBPF_INCLUDE)
> --
> 2.35.1
>

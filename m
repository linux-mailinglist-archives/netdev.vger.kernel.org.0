Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C262C4F1F0D
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbiDDWVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347142AbiDDWUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:20:42 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366372AE10;
        Mon,  4 Apr 2022 14:45:55 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p21so13032340ioj.4;
        Mon, 04 Apr 2022 14:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbs9fcy6lDcW1tCE9uYKKNhbnr1Z/YXZ62q7mBkw+1c=;
        b=UeAE3U3CTKW6k3yqp8bKs5G6U3tfXakM/JhxcWWsZnY49QOpMTm8SOo2Shls04fi7A
         EA9zCQqAku5o8m+PAzraf0VORzs3fE/q2Tiye5tkYEQxDHkurkpOwhfKkW3gs/LzDwDN
         ciJe8mswgvLuE0GV+Gsd6Kd0PqP0l3rG9WWukZDwkqAqtYeEjQYVpMvcTJNa4gNCTUOr
         dmKkgzgptwLuWHOI0G0eOWLqdGcP/NNKJFIxVN46qj2OQcnOhEEhAouXjqli8dPCDl3z
         3qA3asP6zJBSU8fR0JQWcItCnSvaF3dfp4EL1DKeHEHKbyr559BEyz/mmQXUSk/Dy2tH
         CwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbs9fcy6lDcW1tCE9uYKKNhbnr1Z/YXZ62q7mBkw+1c=;
        b=yxB5JwRRRV3sA7HNdb7GBgfjX8yCQo2UMksfYrbi3AjQTbltic3ZzqP/0qyC0Gxzz/
         O5quEUr4awhikVzLM3OokWPngRw4/HqdXJ48Wt4oFVlSvJHi6Be7Wcxg7fSU4mlIb79I
         MVp5/iXUCHNQr2p7DRSTlcFrFRPxYjyIwxR9VrxeJzhVIjPsWKspLnHRC8XG6RMJBRGe
         pKeShJykWQ7wbcOlZaXBUR3OtZJyEuJWVh7ElJ9RES9wWRPV2Xwt+s4UVHrWPBtZBXs7
         IdPnPzWid3PBKWGRhqE9H4kyvrjBzFgIijlfzdyUp6cFSkKRQB9YqsPiGrP1UeY/bAbc
         Eu1Q==
X-Gm-Message-State: AOAM530Q+x9PPV2aCQ36y2K4LyEH4u12OAnKGBH0d3foFwM/LdtnRlE7
        rXHQkjcJ+EZ+Y0RqrhdEbLcFs8zceumzzgFGznw=
X-Google-Smtp-Source: ABdhPJwgjhIIdV/CtMpPyoGgdp6J3HLxy5IScDzHXBBpBkHkK3q6PTM1CQDop/FBSww/YJrAHgsyPF5HkC8kBc4fqts=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr163158ioi.154.1649108754584; Mon, 04
 Apr 2022 14:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220404115451.1116478-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220404115451.1116478-1-alexandr.lobakin@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Apr 2022 14:45:43 -0700
Message-ID: <CAEf4BzbEQeq-_BhrKLSHW2xObQPtzGA7Hw-hTbfLZZ_S4gfVmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: fix linking xdp_router_ipv4 after migration
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Mon, Apr 4, 2022 at 4:57 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> Users of the xdp_sample_user infra should be explicitly linked
> with the standard math library (`-lm`). Otherwise, the following
> happens:
>
> /usr/bin/ld: xdp_sample_user.c:(.text+0x59fc): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5a0d): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5adc): undefined reference to `floor'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5b01): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5c1e): undefined reference to `floor'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5c43): undefined reference to `ceil
> [...]

I actually don't get these, but applied to bpf-next anyway.

>
> That happened previously, so there's a block of linkage flags in the
> Makefile. xdp_router_ipv4 has been transferred to this infra quite
> recently, but hasn't been added to it. Fix.
>
> Fixes: 85bf1f51691c ("samples: bpf: Convert xdp_router_ipv4 to XDP samples helper")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  samples/bpf/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index b4fa0e69aa14..342a41a10356 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -219,6 +219,7 @@ TPROGLDLIBS_xdp_redirect    += -lm
>  TPROGLDLIBS_xdp_redirect_cpu   += -lm
>  TPROGLDLIBS_xdp_redirect_map   += -lm
>  TPROGLDLIBS_xdp_redirect_map_multi += -lm
> +TPROGLDLIBS_xdp_router_ipv4    += -lm
>  TPROGLDLIBS_tracex4            += -lrt
>  TPROGLDLIBS_trace_output       += -lrt
>  TPROGLDLIBS_map_perf_test      += -lrt
> --
> 2.35.1
>

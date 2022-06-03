Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3553C3C6
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 06:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiFCEbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 00:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiFCEby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 00:31:54 -0400
Received: from mail-vs1-xe62.google.com (mail-vs1-xe62.google.com [IPv6:2607:f8b0:4864:20::e62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92162117B
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 21:31:53 -0700 (PDT)
Received: by mail-vs1-xe62.google.com with SMTP id 63so6338891vsx.5
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 21:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=TfOfY9nDE6EgdzK7eHo1wPWpr31B0AhtWoqNGscvDio=;
        b=hPcJnMFtLK4O8Qe2A84mzf4m4mvhCYLJmkm8ynvsA926wOYWedaguwv/cL80xSC7VO
         e0gilTU55NyCtw7dOAbV1WXIexLeufZ571cV+XuKVf4Iw5SbTKUxGmiTKOsEQKVbCrlB
         mY2PWDmYYRBaQznBbdNPDP0nB16OUQd8f7eRqRJcxyltvyBFzyyhwFE9CPHPBTXlfo2E
         6XFd53m66fLLcvY0WNlnfHN7IGp8GPCI/O0AYuJSmC0jLMxyay/lUCtZcu+b/6dIJama
         8xRE6imZ1MCbY72dVowgADVocqNW3EofM+9/VO1kubrHOZS+mlvFayvUZzwkoEJGcSlh
         F7AA==
X-Gm-Message-State: AOAM5327OCIEYUgUCKQ7si9JPq7+brgsJlmlZEtwNzU1CfKy8T+pq5aX
        OYga/qOHF0yi8LBR02Uwg2Pb73d3Abp4p9V3vUAv0rV/yEqChg==
X-Google-Smtp-Source: ABdhPJwcQvbgfTFkGRjJydEpUibMYFE+NeIkgGn0w1/2j4jk6atAqQcNlOP3CX3U3SV0sJkcjdv+FAchDXCu
X-Received: by 2002:a05:6102:a0c:b0:349:2d99:440f with SMTP id t12-20020a0561020a0c00b003492d99440fmr7593928vsa.22.1654230680776;
        Thu, 02 Jun 2022 21:31:20 -0700 (PDT)
Received: from netskope.com ([163.116.131.244])
        by smtp-relay.gmail.com with ESMTPS id g22-20020ab00e16000000b00368ea885f44sm958423uak.16.2022.06.02.21.31.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 21:31:20 -0700 (PDT)
X-Relaying-Domain: riotgames.com
Received: by mail-qv1-f69.google.com with SMTP id az18-20020ad45512000000b004645f3d2c36so4692724qvb.0
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 21:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfOfY9nDE6EgdzK7eHo1wPWpr31B0AhtWoqNGscvDio=;
        b=EB0xhxnrrBnHMP+Yw1n+L6/aBww/dvWK+IVeF09JEDipF5Hblr7ZZ3BsnJKTyT+ru6
         lMbAs+t8Vw0xSjQDS8SvPfKDDZ2fXhgGGIEZQvhFveC26VsbjQ68eNbjAgPCO5AovCG8
         mNwCZojcO25AASOYLNPvXo+S4c7KbmB7K9ies=
X-Received: by 2002:a05:620a:4154:b0:6a5:7577:3e1b with SMTP id k20-20020a05620a415400b006a575773e1bmr5309324qko.694.1654230678934;
        Thu, 02 Jun 2022 21:31:18 -0700 (PDT)
X-Received: by 2002:a05:620a:4154:b0:6a5:7577:3e1b with SMTP id
 k20-20020a05620a415400b006a575773e1bmr5309317qko.694.1654230678725; Thu, 02
 Jun 2022 21:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220603041701.2799595-1-irogers@google.com>
In-Reply-To: <20220603041701.2799595-1-irogers@google.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Thu, 2 Jun 2022 21:31:07 -0700
Message-ID: <CAC1LvL12oxCojWBxqCj=g+cC=UbAHoQ6kT4TQXSi1j78L5zn3g@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix is_pow_of_2
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuze Chi <chiyuze@google.com>
Content-Type: text/plain; charset="UTF-8"
x-netskope-inspected: true
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 9:17 PM Ian Rogers <irogers@google.com> wrote:
>
> From: Yuze Chi <chiyuze@google.com>
>
> There is a missing not. Consider a power of 2 number like 4096:
>
> x && (x & (x - 1))
> 4096 && (4096 & (4096 - 1))
> 4096 && (4096 & 4095)
> 4096 && 0
> 0
>
> with the not this is:
> x && !(x & (x - 1))
> 4096 && !(4096 & (4096 - 1))
> 4096 && !(4096 & 4095)
> 4096 && !0
> 4096 && 1
> 1
>
> Reported-by: Yuze Chi <chiyuze@google.com>
> Signed-off-by: Yuze Chi <chiyuze@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3f4f18684bd3..fd0414ea00df 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4956,7 +4956,7 @@ static void bpf_map__destroy(struct bpf_map *map);
>
>  static bool is_pow_of_2(size_t x)
>  {
> -       return x && (x & (x - 1));
> +       return x && !(x & (x - 1));

No idea if anyone cares about the consistency, but in linker.c (same directory)
the same static function is defined using == 0 at the end instead of using the
not operator.

Aside from the consistency issue, personally I find the == 0 version a little
bit easier to read and understand because it's a bit less dense (and a "!" next
to a "(" is an easy character to overlook).

>  }
>
>  static size_t adjust_ringbuf_sz(size_t sz)
> --
> 2.36.1.255.ge46751e96f-goog
>

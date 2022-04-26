Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A825510CD6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356203AbiDZXum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242818AbiDZXuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:50:40 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2CE3465E;
        Tue, 26 Apr 2022 16:47:29 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z26so687781iot.8;
        Tue, 26 Apr 2022 16:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TVUxqi683bzyBt7t+DtAalhlG18RTOSH9toaBLszxcI=;
        b=Zj7U8SZsjQnYd4RZbGkTxwK5lYYM3vf5hvVJiQ919eJQCf1p1r7KkFBY/Db6c4sSCR
         pJSS3W9Cqq9ixAJeviRAAESJ7kRBe9HNaS7dJaAukK/Rrk0MrTpf8z8hfGG/cwQBTbDs
         DC/CZvfZdAY7dR4J9xzwiu/L0g3rzw5TuD8sICuBdVmgY1JkkzDSp3sezcxdL2A9jtCN
         b/3/dsfSkUNxc4ueGPjZ5fmpKcjgyQDxhZM063arnmgdsTUAs6JkVYAJE2dHQq8bPBL5
         yQCtMDrOdgQ85kK3LNNatbv+IAU8OznBZA856hFEAoLr3jtwH6XPvDenJpFIRYvt3AII
         pRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TVUxqi683bzyBt7t+DtAalhlG18RTOSH9toaBLszxcI=;
        b=WNVwurCcqyUa967C5HgxHHxpgANtVYeg2E+TfQTgoeBK9jpI8XBPTcDk1cv1U9iQUT
         HxbalPNrCgEUpuDhFOXme6s95mYXQSfTLsN3bKTE6Me8r2zJbgBvvga5NPDaFqFHoB/y
         95pcUsDAA9qJXzFQdNe00XhTXkkwhMwLQVkreymXmEjubauV/haE9TOOwS+Rk9WEGE+1
         NPCqmkE4Y7CD+A2MzJlzzxbViMjr5Ki9ePB/OMjsfi5V2TuxS9x5OD1uamgKJkS/CHqn
         IPGgU+AYk9f+PxV1nYe5MjxGAcXYRh0CWq/duiXejTgEPNHtn88A3KygUEbc5bemLzDl
         LflQ==
X-Gm-Message-State: AOAM5324jU1fIq7ziwS9iUcRsXEkP76rLi549XLqNMQ2v4ESX5TZgPHT
        qsn/ptxyjudVD++xF9m8uTmieg7S+jti77m62cE=
X-Google-Smtp-Source: ABdhPJw1clGUVFT7SS0HCpbrNVi9wUrFWk7tf2/wy0wO8kSFDs0kmPe7OHBTKFafKYdcWhaduDoY3YBP3RfnCO+Y6EM=
X-Received: by 2002:a05:6638:3393:b0:32a:93cd:7e48 with SMTP id
 h19-20020a056638339300b0032a93cd7e48mr11022409jav.93.1651016849147; Tue, 26
 Apr 2022 16:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220422172422.4037988-1-maximmi@nvidia.com> <20220422172422.4037988-7-maximmi@nvidia.com>
In-Reply-To: <20220422172422.4037988-7-maximmi@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Apr 2022 16:47:18 -0700
Message-ID: <CAEf4BzaDw92rc2Z-9uG08rVrmg0VvWV6VkYYJ2LWCvzYWFv9zw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 6/6] bpf: Allow the new syncookie helpers to
 work with SKBs
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
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

On Fri, Apr 22, 2022 at 10:25 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> This commits allows the new BPF helpers to work in SKB context (in TC
> BPF programs): bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.
>
> The sample application and selftest are updated to support the TC mode.
> It's not the recommended mode of operation, because the SKB is already
> created at this point, and it's unlikely that the BPF program will
> provide any substantional speedup compared to regular SYN cookies or
> synproxy.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/filter.c                             |  10 ++
>  .../selftests/bpf/prog_tests/xdp_synproxy.c   |  53 +++++--
>  .../selftests/bpf/progs/xdp_synproxy_kern.c   | 141 +++++++++++++-----
>  tools/testing/selftests/bpf/xdp_synproxy.c    |  94 +++++++++---
>  4 files changed, 230 insertions(+), 68 deletions(-)
>

[...]

>
> -       return hdr.tcp->syn ? syncookie_handle_syn(&hdr, ctx, data, data_end) :
> -                             syncookie_handle_ack(&hdr);
> +       return hdr->tcp->syn ? syncookie_handle_syn(hdr, ctx, data, data_end, xdp) :
> +                              syncookie_handle_ack(hdr);
> +}
> +
> +SEC("xdp/syncookie")

SEC("xdp")? libbpf will reject SEC("xdp/syncookie") in strict libbpf 1.0 mode

> +int syncookie_xdp(struct xdp_md *ctx)
> +{
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       struct header_pointers hdr;
> +       int ret;
> +
> +       ret = syncookie_part1(ctx, data, data_end, &hdr, true);
> +       if (ret != XDP_TX)
> +               return ret;
> +
> +       data_end = (void *)(long)ctx->data_end;
> +       data = (void *)(long)ctx->data;
> +
> +       return syncookie_part2(ctx, data, data_end, &hdr, true);
> +}

[...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A085C435246
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhJTSDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhJTSD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:03:27 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B39C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 11:01:12 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so7085341ote.8
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 11:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cupflte1zq90gW1ccTXvlIjvbCfDXy0IhF6QWIY1PEY=;
        b=SoIXUOtE9Alqx2NxcYxBnCORgimBcYzGPaxU9ynyftblKa61YB/ndQGoTen5UDgcmN
         7jtHmWK6oixRhSjFI2RGkf9d0X+3sir1kSu3vonBsWs48uPRdFyfJpKkn5KW2pWJyHjf
         u3o5tAW7EU2Ry2/5ZPAmKLk4VFEi0ZS7Bsog7W3NV5Qqffs3RDaYVUVLIBcdskPzdJ56
         /oxKJKeD727mZWbMuRYFtMqBvVleAphudRBQMw+ss3F/qXueq1nhHXwsaIyXz8JTh3Bj
         TXcPNUlNUblzWCZc41FQhxexTUo8j1fraZQ+ReAHN9sYDc8ae8OKKyGBEpc6sIHM9b2B
         1LcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cupflte1zq90gW1ccTXvlIjvbCfDXy0IhF6QWIY1PEY=;
        b=ujHDa67ZE7u+yXedHpNVqFXphHIv+E+A/Dege7X+AcTeY7kNMCOxCQorfn0aFjriR8
         DRUBOXuLzh7d83RObTfrRKckuMNu/wWvYIXEp60RMf5l9cXwMCdsoQBKhuHwRLcjOU2Y
         BPJnLGH75R4TBxrhwmvK8pqBJtcj4o1RnA+AaOlcufNx7K9ClNN7zXwDf2C1LN+dmJrW
         4qAAa2CGf+WjkOyFMpXamME9ZmSmSlNeT95sFDqX8Qk1furZ0Gd1mm863L2wELeQuxky
         OWhuqTzWEFM4r2o21WR/QXs0vDt5n0n4I7FrSlrZ7SH601d7jqpEYE0jvWbbbk3vC8Xd
         +TIw==
X-Gm-Message-State: AOAM530wtYVGD0PV5wabtzhopZIJZLF4CZLTVRBJQ0A3yU6V+dAt3ndm
        ZR7kucoAo7MZG4p2IkxZ4AgcmYF7KkZnDKkB9e326A==
X-Google-Smtp-Source: ABdhPJw6/FSGoIjKPaOACQopMsh/iVUFBfAhKaMwlQW9gEuhr1NwS6g04TLnlV2BQd6juy/jlA8fFDatcMA2cDQ2ooQ=
X-Received: by 2002:a05:6830:3096:: with SMTP id f22mr620491ots.195.1634752872088;
 Wed, 20 Oct 2021 11:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211019144655.3483197-1-maximmi@nvidia.com> <20211019144655.3483197-11-maximmi@nvidia.com>
In-Reply-To: <20211019144655.3483197-11-maximmi@nvidia.com>
From:   Joe Stringer <joe@cilium.io>
Date:   Wed, 20 Oct 2021 11:01:01 -0700
Message-ID: <CADa=RyxEQwQp++1JD67h5_JZMokGhMi6ediGKjQSQeBR2-TeBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] bpf: Add sample for raw syncookie helpers
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,  just one comment related to the discussion on patch 7.

On Tue, Oct 19, 2021 at 7:49 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

<snip>

> +
> +       value = 0; // Flags.
> +       ct = bpf_ct_lookup_tcp(ctx, &tup, tup_size, BPF_F_CURRENT_NETNS, &value);
> +       if (ct) {
> +               unsigned long status = ct->status;
> +
> +               bpf_ct_release(ct);
> +               if (status & IPS_CONFIRMED_BIT)
> +                       return XDP_PASS;
> +       } else if (value != -ENOENT) {
> +               return XDP_ABORTED;
> +       }

Is this the only reason that you wish to expose conntrack lookup
functions to the API?

You should be able to find out whether the TCP session is established
by doing a TCP socket lookup and checking sk->state.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D630A3C9598
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 03:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhGOBcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 21:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhGOBcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 21:32:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D385C06175F;
        Wed, 14 Jul 2021 18:29:32 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f30so318370lfv.10;
        Wed, 14 Jul 2021 18:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIrqZksIMmPKofo2YI/CM7Y7uhVjsm4m1d1A6psKmus=;
        b=mIpaOtawBkufa1V984ifB1DmHJfImu0BJojRWJkJBVIELK7OtIS6yPSkK9l4Kgydt2
         QfO9A+v0KdItiGyXnt8CYiiPDM5DILxo+2HkL+kMLacq3j44FTGDHjsM2D2UtrDX/A5l
         LU+qAHfEXnaTzpodns90isa87u8xlgp3Yd6TE8CYiRjLUmza3wxZJ3ab2dIwPLiXw7s7
         AdYtWtoSFJST9EgbN89gEBB/N37RNvfAob96RQD8xREKHbeRRcyi37+cEHZCUKHoRCmD
         1NPeicerZAh07W77DLL9liXkoksB3pyMWJWOXC45zK7RBF0RR90XrKraDfDbqwIU+dzU
         WxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIrqZksIMmPKofo2YI/CM7Y7uhVjsm4m1d1A6psKmus=;
        b=rEtCaagZTPkkEFkii3qmmAyqMbWZH/xJHtud/fWOZON377VwSfUfbtdVQhVDYkK3PH
         vGjMj8fj/ruoD2cA7kkRnviAJT+klCxBDajBpPpWzelYaEpoJWGpusmb48DOu77iIwHD
         Vm9jD2thk9Fx1H2qMoKauZ4QOOEUjh+WkrOBW+vGDTVAltygAGeh193xTdchm9nuiX+7
         BmLLN0WBwkhbukIs24Kebjx0xaOEBO0785gPDDkrqeKm0qxZ8EVdEQ12yEVBjrUfcMpJ
         DvSKZvVZ3mUnAXIIkjX98eAKsGxkbSnic+Yv0YfJY6AgpASF3iHcfAR/PTpQaq1UO1MV
         Upsw==
X-Gm-Message-State: AOAM5313D8CYnLid9vQ39fDQHUa0cjSDshPH2zwv7GdOIMKWrO31c5AH
        VEgML4ag7LFeUamd7t5jPJWKG/DBT7zWLEXEcd8=
X-Google-Smtp-Source: ABdhPJzDIjPSjLiWhjxguWs3PQ2THFuULszYyA9uI2koytQD9ThtzsaXxepgOTFdas99lMUhOhnblbyKoZBlqx1qvDQ=
X-Received: by 2002:a05:6512:3f9a:: with SMTP id x26mr765428lfa.75.1626312570545;
 Wed, 14 Jul 2021 18:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210701200535.1033513-1-kafai@fb.com>
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Jul 2021 18:29:19 -0700
Message-ID: <CAADnVQ+Y4YFoctqKjFMgx1OXknAttup10npCEc1d1kjrQVp40w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 1:05 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
>
> With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> restarting the applications to pick up the new tcp-cc, this set
> allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
> It is not limited to TCP_CONGESTION, the bpf tcp iter can call
> bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
> into all the fields of a tcp_sock, so there is a lot of flexibility
> to select the desired sk to do setsockopt(), e.g. it can test for
> TCP_LISTEN only and leave the established connections untouched,
> or check the addr/port, or check the current tcp-cc name, ...etc.
>
> Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
>
> Patch 5 is to have the tcp seq_file iterate on the
> port+addr lhash2 instead of the port only listening_hash.
...
>  include/linux/bpf.h                           |   8 +
>  include/net/inet_hashtables.h                 |   6 +
>  include/net/tcp.h                             |   1 -
>  kernel/bpf/bpf_iter.c                         |  22 +
>  kernel/trace/bpf_trace.c                      |   7 +-
>  net/core/filter.c                             |  34 ++
>  net/ipv4/tcp_ipv4.c                           | 410 ++++++++++++++----

Eric,

Could you please review this set where it touches inet bits?
I've looked a few times and it all looks fine to me, but I'm no expert
in those parts.

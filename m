Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B87A3D013E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhGTR1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhGTRYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 13:24:45 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5E5C061762;
        Tue, 20 Jul 2021 11:05:18 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id v6so37129993lfp.6;
        Tue, 20 Jul 2021 11:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HjauFs/iZ+qHLTLckTAOC7vNzTkUwg8FGq/1wJ2o7ck=;
        b=Loerg9D3VEk4Vj8yWc1z5bfQ/D9FE+Plzs5pjHqmclBRLKxRT7DzcNxnQe2iSOrN2J
         NLGBYeUovhc8PpuKqDrmFteR/7ZkvUiK0UjZiMXqSYg8ODdIt4OB0syO5xRPCprXRPb6
         D0YDeROU9chkvx5VWdDn5Y2JQ2c+ok5gy0DQSmVyFdpo9MpiDUFN76u2pukI2c21qJRv
         l+K3VVp/kiDlqHktgE8xTZUSqyrWjfygQj24t/IMIGsS1dJx+0jwcBHI1VoiF5KfM4uV
         OvwIQSwu4n0h2X3ixioSKvrslL5dQbAbHxbMcteMbd8znmJJbft2mPVzWKI5yK05tH48
         Zgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HjauFs/iZ+qHLTLckTAOC7vNzTkUwg8FGq/1wJ2o7ck=;
        b=gcmBjYc9ueeAt279ddZxfr29KuE845ypcVBjL22sIXSl7PHTnmTy0dJkTAY0KfCeBt
         vG9nGYkkmHEn0az/RO+E921QevRw0KlLFNjGYVxVgBIIVQK94HkhdYTj+YJ1FgL6A8lD
         PY3MNjefKzmX4VYRvvgHxI+aKnpPsGEUZ4v6UAKzmp1zWQ3oZ6Vm2OM4y59/gzeiO9Ek
         Pf00+6tc2hQOYQev64DShM7d6UQhcNx6+3/4kyuvgh0QdPIkM41a31BPnMuWr4KbdF6E
         hmAHDqbpWi12VPVw2pD3n4B2CHO2hQt5RTtYCSdUxyHUDAQyPDsRJQlM2JJoERKwQnt6
         Jirg==
X-Gm-Message-State: AOAM5323DwBncst2qvv9by2s2HveuH36gMlrYpsE3AZoC7TfeANv4NbR
        I4CeSh3v3Dw5WRWoOMR7WKwNGqcKfP5C7eTijmo=
X-Google-Smtp-Source: ABdhPJwZs7FuCuBUtuqon1UNNvTjjYV47tar46irqKZJao+bwHkkoZwZwyA08h0fvHVW+p+FkF3ndYJiHX4SrrMAUqw=
X-Received: by 2002:ac2:5fe5:: with SMTP id s5mr10526338lfg.540.1626804313719;
 Tue, 20 Jul 2021 11:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210701200535.1033513-1-kafai@fb.com> <CAADnVQ+Y4YFoctqKjFMgx1OXknAttup10npCEc1d1kjrQVp40w@mail.gmail.com>
In-Reply-To: <CAADnVQ+Y4YFoctqKjFMgx1OXknAttup10npCEc1d1kjrQVp40w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 20 Jul 2021 11:05:02 -0700
Message-ID: <CAADnVQ+RYgHYO=aJwoh7C_=CeX+nwYopb+pk=Pp709Z-WwQnPw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt
To:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
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

On Wed, Jul 14, 2021 at 6:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 1, 2021 at 1:05 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
> >
> > With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> > restarting the applications to pick up the new tcp-cc, this set
> > allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
> > It is not limited to TCP_CONGESTION, the bpf tcp iter can call
> > bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
> > into all the fields of a tcp_sock, so there is a lot of flexibility
> > to select the desired sk to do setsockopt(), e.g. it can test for
> > TCP_LISTEN only and leave the established connections untouched,
> > or check the addr/port, or check the current tcp-cc name, ...etc.
> >
> > Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
> >
> > Patch 5 is to have the tcp seq_file iterate on the
> > port+addr lhash2 instead of the port only listening_hash.
> ...
> >  include/linux/bpf.h                           |   8 +
> >  include/net/inet_hashtables.h                 |   6 +
> >  include/net/tcp.h                             |   1 -
> >  kernel/bpf/bpf_iter.c                         |  22 +
> >  kernel/trace/bpf_trace.c                      |   7 +-
> >  net/core/filter.c                             |  34 ++
> >  net/ipv4/tcp_ipv4.c                           | 410 ++++++++++++++----
>
> Eric,
>
> Could you please review this set where it touches inet bits?
> I've looked a few times and it all looks fine to me, but I'm no expert
> in those parts.

Eric,

ping!
If you're on vacation or something I'm inclined to land the patches
and let Martin address your review feedback in follow up patches.

Thanks

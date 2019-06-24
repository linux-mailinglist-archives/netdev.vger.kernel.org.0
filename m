Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00EC518CB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbfFXQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:38:47 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42653 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfFXQir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:38:47 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so15119505qtk.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x5ur6j0Wd7tvFapbU5tFsrS0NC4M1KOOu737VXA4wPQ=;
        b=bA6QoiKike1D8v2DlowevmdxheD1x613pQCdLLhTdn3uoAI7jR+F8tMl5yhUDDplaZ
         lBF8do8d6BG6f1jnfKt2Ujwgd8peEklH0fghfld8ZyN+osvoL3iyAetE9wtaBjmSgGB9
         IduRvM8SLDEkthrSRFg9f6COgKYZeNXGAxEi5gRy9Mqt0FsNtpHN+pe5b9/QkFnMsuXG
         BE14rYN3ZbnZ2WF7DWxwDa+pSRmiN+vnnwNDX2+spcCAIsr69klwBNukTJ1K4c4pS6Pj
         gt1WG6buqvdsSklUNEoYTLD5f7ziPfoNYYdK0xSZorsEKWz5W7ZjhKwF4Q+zxhC1YZmW
         rX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x5ur6j0Wd7tvFapbU5tFsrS0NC4M1KOOu737VXA4wPQ=;
        b=JBiU5uDD9tP9GoB9Fi5IU6sbNwjfb/wSylXPm04DAfqSKDTBO8O9UDNo3js/YqPTGB
         fhHmTx7FBIFtkOgWVLfnIMy+iCiAM87TgTlxg8Bkt65IlMgyMIXRwNVY/4IW3bjiB0L7
         A6m/p8psrBQmizKZ3M3e3KCL2QMhOhRhnw2hGjSdR1m+moLTiAJoV2NWHqO8Ucb8B7G/
         MGZnIQJupmLoD8BlPR8+akrRkQYer6aG3AmyMf0Iw02sz7hGbFZr1QVmFyyrxFwccP1L
         wS/GdD4m1Z9edKru/Cky2Q4kDhSoYbDYFBjQQgcmnKVlWs6p1mbefD2hgQ5+dyY6DkPA
         G2Cw==
X-Gm-Message-State: APjAAAVdip9BDCe3bvTXf7kas0ENFnt7O8EgeAhEXhgfzIXEUnG8Vpwk
        UIlsAyTLZdxW4cWRyFDJn2MqoxfwlGYAQeW15Zo=
X-Google-Smtp-Source: APXvYqwUeLpEt7jSZ0F/sP8YATIou4qYZjl1x3PExYAROBUJb3x/kvfovm68e61e+2l+IlTNTZj8twoUg1mv1GpQR3Q=
X-Received: by 2002:a0c:9e02:: with SMTP id p2mr57495037qve.150.1561394326065;
 Mon, 24 Jun 2019 09:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
In-Reply-To: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jun 2019 09:38:35 -0700
Message-ID: <CAEf4BzYFCAp7yUU80ia=C5ywDBgepeaMmVPJW8VG4gLUT=ht=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/3] xdp: Allow lookup into devmaps before redirect
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 7:19 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> When using the bpf_redirect_map() helper to redirect packets from XDP, th=
e eBPF
> program cannot currently know whether the redirect will succeed, which ma=
kes it
> impossible to gracefully handle errors. To properly fix this will probabl=
y
> require deeper changes to the way TX resources are allocated, but one thi=
ng that
> is fairly straight forward to fix is to allow lookups into devmaps, so pr=
ograms
> can at least know when a redirect is *guaranteed* to fail because there i=
s no
> entry in the map. Currently, programs work around this by keeping a shado=
w map
> of another type which indicates whether a map index is valid.
>
> This series contains two changes that are complementary ways to fix this =
issue:
>
> - Moving the map lookup into the bpf_redirect_map() helper (and caching t=
he
>   result), so the helper can return an error if no value is found in the =
map.
>   This includes a refactoring of the devmap and cpumap code to not care a=
bout
>   the index on enqueue.
>
> - Allowing regular lookups into devmaps from eBPF programs, using the rea=
d-only
>   flag to make sure they don't change the values.
>
> The performance impact of the series is negligible, in the sense that I c=
annot
> measure it because the variance between test runs is higher than the diff=
erence
> pre/post series.
>
> Changelog:
>
> v5:
>   - Rebase on latest bpf-next.
>   - Update documentation for bpf_redirect_map() with the new meaning of f=
lags.
>
> v4:
>   - Fix a few nits from Andrii
>   - Lose the #defines in bpf.h and just compare the flags argument direct=
ly to
>     XDP_TX in bpf_xdp_redirect_map().
>
> v3:
>   - Adopt Jonathan's idea of using the lower two bits of the flag value a=
s the
>     return code.
>   - Always do the lookup, and cache the result for use in xdp_do_redirect=
(); to
>     achieve this, refactor the devmap and cpumap code to get rid the bitm=
ap for
>     selecting which devices to flush.
>
> v2:
>   - For patch 1, make it clear that the change works for any map type.
>   - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the retu=
rn
>     value read-only.
>
> ---
>
> Toke H=C3=B8iland-J=C3=B8rgensen (3):
>       devmap/cpumap: Use flush list instead of bitmap
>       bpf_xdp_redirect_map: Perform map lookup in eBPF helper
>       devmap: Allow map lookups from eBPF
>
>
>  include/linux/filter.h   |    1
>  include/uapi/linux/bpf.h |    7 ++-
>  kernel/bpf/cpumap.c      |  106 ++++++++++++++++++++--------------------=
---
>  kernel/bpf/devmap.c      |  113 ++++++++++++++++++++++------------------=
------
>  kernel/bpf/verifier.c    |    7 +--
>  net/core/filter.c        |   29 +++++-------
>  6 files changed, 123 insertions(+), 140 deletions(-)
>


Looks like you forgot to add my Acked-by's for your patches?

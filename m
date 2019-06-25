Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A3055862
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfFYUGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:06:20 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34449 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:06:19 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so13716887qkt.1;
        Tue, 25 Jun 2019 13:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RTShSTj5/FpTVgIWgu2/oFhLVrp3kVnO6Lz9E5kxwQM=;
        b=ha1vFqbT0ywZB5TXVQmocuAfoQKB6bgbEwlb/9v31UC05KTLDW/64Vt6sDEuDGQJD6
         JHYd3VesOiyHR54nqqx5gwy+zAKHLKPQT7Qw5ph/9dRiTaHImUYTSxKvT1I+faRUfNyt
         MlchwGAfPA3LXqNu1Cj/NPtjZh+IicgsxRPIiBj1w63qJb4DL4CA4reCdoStk6lCbjFc
         OtYm/Fa33A4RQq9tcAHUvKhiZwGxejaTTRcctLUaNbINFVbrtRCLRcgZ6uRQZ8YweRCn
         vCPiMl7CCTNZA99tGiSvr7566ekdX3Jn1kr0JtfXsvSwlNeO80BRu/UIYQCnscwoSKk0
         Mf5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RTShSTj5/FpTVgIWgu2/oFhLVrp3kVnO6Lz9E5kxwQM=;
        b=tcZNGfr/xYR1GfieuZ9+eiZ4H8Hv2XMmIqFhx7vhW41ysEVbU/wHjuDkox54GtE0al
         hcTsjN/bIxwoLvbcR91IgOz2mA9KogVUbfj3uNJcFcQhv51iUnoUtOWdzyqyeRHYvDmf
         ofHmnknnDQXhKSon5r5jg+6fbJij3f+96re+jK+98ZNV77QdcUXGKlOypvlxE3DVEVoO
         mzpuhXJ/Lu0xq2ywu1AyCLytxWAWKpXopZ78klGUarP5I1dbWBy/B2GaW9aCjeTz3vQA
         4JWy59gXdrIBSv2w1TNeN/WvVINMl6C4dXrCzpWUIX+GLrDSy1ij64PNP0kVT+OBfBya
         q5Wg==
X-Gm-Message-State: APjAAAVjMSxQ2dPuoglRHCTA2YI69mYNu3yU9o68QJfNjmlthu6CG5JE
        niv4KTTn3kCeJtgTQ0C+6Kv1y/1rr2SocYWinUY=
X-Google-Smtp-Source: APXvYqxeWqVcCu8K5tarpfqQUORIjT33whWFNGtEqVcnhnhnv5X5NRpa/EFyRR8lM9xD1bTiKdMoqUmA+n9yDx3QVSE=
X-Received: by 2002:a37:5cc3:: with SMTP id q186mr506709qkb.74.1561493178572;
 Tue, 25 Jun 2019 13:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190625172717.158613-1-allanzhang@google.com>
In-Reply-To: <20190625172717.158613-1-allanzhang@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 13:06:07 -0700
Message-ID: <CAPhsuW6+T4pgOhVFprqcfH5DqUmrq+d2sGX995MpvEVSVd-2rQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/2] bpf: Allow bpf_skb_event_output for more
 prog types
To:     allanzhang <allanzhang@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:45 PM allanzhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>
> Added socket_filter, cg_skb, sk_skb prog types to generate sw event.
>
> allanzhang (2):
>   bpf: Allow bpf_skb_event_output for a few prog types
>   bpf: Add selftests for bpf_perf_event_output

I am not sure whether this is caused by delay in the mailing list or something
else. But it appears to me that you are ignoring some of the feedback. Please
pay more attention to these feedback.

Please include changes "v1, xxx, v2, xxx, .." in the cover letter, but not the
commit log itself. In other words, include that in 0/2, but not in 1/2 or 2/2.

Thanks,
Song
>
>  net/core/filter.c                             |  6 ++
>  tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
>  .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
>  3 files changed, 132 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
>

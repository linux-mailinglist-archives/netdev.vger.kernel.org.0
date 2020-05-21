Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F1B1DDA58
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgEUWjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730041AbgEUWjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:39:23 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57719C061A0E;
        Thu, 21 May 2020 15:39:22 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id l3so3873517qvo.7;
        Thu, 21 May 2020 15:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fNYgEZ8Ck1KWFXKaH+w8+B6kwRdAiB9m4/sQS04laBE=;
        b=pEEqAU8ubBVIEPXrglB0kRBYDRIou7xH2r2Xh498buMIiZcrAH/WsvaMS12hKSIFoI
         3l9pTtvA0MOIwSBNKAfJsGkKPczvRJQDcvn5AGRu4fjCIArcmeOKbjGrqiNB+3Ahxcej
         1pShh6ida4YZDbjm6V2vbbKESkt9PTuhWaRVlkMsBROpKhX9LCaYyZxRWRVAU+ugmenw
         VoK91lCJ02ujk3JHIjqcqkemAQjkvyt2lKpVmg7r3x2Z3zxLWI6TGp+AR4Sn7m/+qPrM
         SPk7AuFhvVPPReyQbWcsGGB9ay7W1WbhWT4OB8pba4qfuWJi7VELsvB0k9MC8byzRBWS
         TvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fNYgEZ8Ck1KWFXKaH+w8+B6kwRdAiB9m4/sQS04laBE=;
        b=k4vULGWXVTnUav2VPI5+F5pYu7eHx9cUJuxCxjP+dcOTqYO6MrPe4otw1jvODA/Usx
         CS84/0YdhMYImUlYDTT6NzLTGBOYLO9UhH+kE4k8cm/3BEilEsoZsDjBeXypc2ZzEcpq
         V5JH6PVBczYnNAZIXExhDvChWHfApxbJCC4WqB/QGqQqgTvAZk7yhMipLEcThMgSbb0E
         +tG3r1KppaRo9TSaqUr2KEo3mC8IisImsx8EQFTSB1tY7y095ACB1bzUmqcCruFbF2km
         i/3+sdf9s0cleczdDN0LWulZvwnwdLVHSer3J9WCz1IEcJtTzl1NEbDuX+l3TwSlaPFc
         79vQ==
X-Gm-Message-State: AOAM533+RhI2D0tYZxpuMKw/1OFBjkJ7ww05Js39VX6MDXlfeVHb9h2O
        YRm5VZ35D/ZFHbuZ4oYevjdHZcGhqNMfmr0ieSw=
X-Google-Smtp-Source: ABdhPJxpKnDFesUo015MwUYJWJfyNHkFGr/MSVRcDqmV0uVhSicyPI93JHCNZPzTRQxAvv58chhQEyqFgAm6XFMTW0M=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr927337qva.247.1590100761503;
 Thu, 21 May 2020 15:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200521191752.3448223-1-kafai@fb.com>
In-Reply-To: <20200521191752.3448223-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 15:39:10 -0700
Message-ID: <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow inner map with different max_entries
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 12:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series allows the outer map to be updated with inner map in different
> size as long as it is safe (meaning the max_entries is not used in the
> verification time during prog load).
>
> Please see individual patch for details.
>

Few thoughts:

1. You describe WHAT, but not necessarily WHY. Can you please
elaborate in descriptions what motivates these changes?
2. IMO, "capabilities" is word that way too strongly correlates with
Linux capabilities framework, it's just confusing. It's also more of a
property of a map type, than what map is capable of, but it's more
philosophical distinction, of course :)
3. I'm honestly not convinced that patch #1 qualifies as a clean up. I
think one specific check for types of maps that are not compatible
with map-in-map is just fine. Instead you are spreading this bit flags
into a long list of maps, most of which ARE compatible. It's just hard
to even see which ones are not compatible. I like current way better.
4. Then for size check change, again, it's really much simpler and
cleaner just to have a special case in check in bpf_map_meta_equal for
cases where map size matters.
5. I also wonder if for those inner maps for which size doesn't
matter, maybe we should set max_elements to zero when setting
inner_meta to show that size doesn't matter? This is minor, though.


> Martin KaFai Lau (3):
>   bpf: Clean up inner map type check
>   bpf: Relax the max_entries check for inner map
>   bpf: selftests: Add test for different inner map size
>
>  include/linux/bpf.h                           | 18 +++++-
>  include/linux/bpf_types.h                     | 64 +++++++++++--------
>  kernel/bpf/btf.c                              |  2 +-
>  kernel/bpf/map_in_map.c                       | 12 ++--
>  kernel/bpf/syscall.c                          | 19 +++++-
>  kernel/bpf/verifier.c                         |  2 +-
>  .../selftests/bpf/prog_tests/btf_map_in_map.c | 12 ++++
>  .../selftests/bpf/progs/test_btf_map_in_map.c | 31 +++++++++
>  8 files changed, 119 insertions(+), 41 deletions(-)
>
> --
> 2.24.1
>

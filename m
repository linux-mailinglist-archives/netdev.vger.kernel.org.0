Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F481D0253
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgELW3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727899AbgELW3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:29:44 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E46C061A0C;
        Tue, 12 May 2020 15:29:44 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di6so7195855qvb.10;
        Tue, 12 May 2020 15:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CvrUFHk6EOjRtCzYLP60K2z4lXXKDu4oJKxA0w4pSVg=;
        b=I0P56yoeoBNsXj5onQI6DGW6xBtwZfHoaaHSjYirt0fkferxLFXSCO5hJiIUoQlFC2
         wSMAsbjC8z0drPVEjRnQf7joADICBdSQ5lIrzqAlxvkgNk5rE7Kphoqjtq0JLqGwVJWi
         /RnRWpaOdyrAPa1rkbGFaK4eciqmg/4o3tYJAgaxth6TFs9Q+XbI6SNvSEiFRR/LMT3B
         +/fu9hVKgUbp1sw5IVxgdBdPK2pG4Xebex3a2a/z0yt6GZ40a0V6GhHsjI1hXkZ3dWLC
         MpEEat8h2MQaWxb6C5tTAHC0MFiA79lWsX3X6ow7i81NU9OVQ8CqnH0c8T3+M4h9rJdF
         AaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvrUFHk6EOjRtCzYLP60K2z4lXXKDu4oJKxA0w4pSVg=;
        b=HqCbbBCTxSoeA5RTP3G88Y5nP+wVsrH3eKfrifkMEy96i88YqOSn+Y2U7qmEEk62Pd
         RMmjiEG2et7ORs27Vcv73iwWyjW4BmSAQePAhub0rRMxLZ12TRZCd1aYFPFN51GGdy5/
         vo0iUOGV68IxjMPM/VXDX5Baq0CUcAF3aNZyA6vodjW1wGFipiCEEoMTGmJIe0WvbYFB
         wRCOt3YbdQg5D6P+T3uTwT7SGX59vbPY6JYjBh3q4tek8lgonr4Yz5mJ0htiB/Prcsjs
         xbS0qLBZBy+0YW8EBgHcVfTIzuryNJ2FttTipm6e8Sc1LMY8rLwQI1YJbpvDj86RUM84
         C3LA==
X-Gm-Message-State: AGi0PuaYKu7eXZsJK0fVG0xRme/KtyS3cOuW/wnxgRHlE5qJcrizt7mM
        FLC34L+PiPQsw4YAg6HaoJBxJmFo/hWNKiMBhJfgqaAX
X-Google-Smtp-Source: APiQypKZHon0to6gVnAf7mfDqXROXVCmnLZQwl/PeAEn8f24mzl5pp07nsvl2lGxWPtt0kDrP0Z1ti3te/v4mbCodlQ=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr22686318qva.247.1589322583692;
 Tue, 12 May 2020 15:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155239.1080730-1-yhs@fb.com>
In-Reply-To: <20200512155239.1080730-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:29:32 -0700
Message-ID: <CAEf4BzYVnVYXT_QN4j_4qp=vY69nAoun-vumSfzVx-xE0CuJjQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] bpf: enable bpf_iter targets registering ctx
 argument types
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:54 AM Yonghong Song <yhs@fb.com> wrote:
>
> Commit b121b341e598 ("bpf: Add PTR_TO_BTF_ID_OR_NULL
> support") adds a field btf_id_or_null_non0_off to
> bpf_prog->aux structure to indicate that the
> first ctx argument is PTR_TO_BTF_ID reg_type and
> all others are PTR_TO_BTF_ID_OR_NULL.
> This approach does not really scale if we have
> other different reg types in the future, e.g.,
> a pointer to a buffer.
>
> This patch enables bpf_iter targets registering ctx argument
> reg types which may be different from the default one.
> For example, for pointers to structures, the default reg_type
> is PTR_TO_BTF_ID for tracing program. The target can register
> a particular pointer type as PTR_TO_BTF_ID_OR_NULL which can
> be used by the verifier to enforce accesses.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM. It's cleaner approach than btf_id_or_null_non0_off, of course.
Having field annotations would be even better, but BTF doesn't have
attributes (yet).

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h      | 12 +++++++++++-
>  include/net/ip6_fib.h    |  7 +++++++
>  kernel/bpf/bpf_iter.c    |  5 +++++
>  kernel/bpf/btf.c         | 15 ++++++++++-----
>  kernel/bpf/map_iter.c    |  5 +++++
>  kernel/bpf/task_iter.c   | 12 ++++++++++++
>  kernel/bpf/verifier.c    |  1 -
>  net/ipv6/ip6_fib.c       |  5 -----
>  net/ipv6/route.c         |  5 +++++
>  net/netlink/af_netlink.c |  5 +++++
>  10 files changed, 60 insertions(+), 12 deletions(-)
>

[...]

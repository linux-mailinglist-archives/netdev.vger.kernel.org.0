Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8699B205B2C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733276AbgFWSyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733170AbgFWSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:54:46 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67C5C061573;
        Tue, 23 Jun 2020 11:54:44 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f18so19870703qkh.1;
        Tue, 23 Jun 2020 11:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H3Kv5Cn6Gw8U/v9uCplQ7bnbpY87sHsbN9JyoRZpRIk=;
        b=opr8gGF0GD11wAKId2EKH6oSo5WjJP9l6wZeyyA/jpexoxwdIXX1wkUHOcIhkIHaEq
         EYlWbrj3gSAJ67IFETmUBeVxQKRPPE9ljydm8GhlU4e6reke6Ay1/BnnBvXEgI8QHue4
         eg6DwWBpzGcIDF/ZGx3YxX0yZ7ct3gMZUkj+jbbT/4hWnWRsQAeJ8EHzod1BKFbsdJcF
         94CJX7Epas69gfM33FK8hHUIsI3D748rzGJxjnjIpegUYVNn4/gCyWPgZpb9kuUKvcCb
         sCfe9/TXXHWs9Z8lNh6bF6LfnD2XpkQ1BHokEWI+wvQeG5auXQP8FLtxpXg2qrWekfsT
         A7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H3Kv5Cn6Gw8U/v9uCplQ7bnbpY87sHsbN9JyoRZpRIk=;
        b=LJSTvw42PzH0b7X730iJMc4oezxpkkxKHY15GTS+ijD64nAqrDnoc/jknh8s5LRVyz
         Y/5Um+QsMapC6En1ZYDwAqh0vuOTplo059tRhlsboGjs1ER+W0vm9Cw/DvQHB9ALzNeI
         +0LA7IkCvQbgZ96BqPOMv0E5WxYC7/qjOkvypGWhP0Fmq/GRbzz1d4oWTGSgRcOU8L8s
         jjHU1ZjByQdnykupDrLbnGtEUmd2uMRMINfbKlEbE/2cklwTHAksVuy076lpVlEflqSE
         v+ZeprNXOmWzGHNmUGH9ZXkDdgY2rtHydlzpW1fHGM2pAC2rvNCd6IfRQrcTU/tKC2w4
         3KNg==
X-Gm-Message-State: AOAM5305v6QtIZEPzxnGSuECnyg+eFKJCsjmmm2eCzbQIcRXAUdE8eGX
        3D0g5R3UoVtlfopTR+Lr9bvs4qkmYK+5N6uNkrI=
X-Google-Smtp-Source: ABdhPJzF6pWGxYiKZIbYK7BAeMh5SvgJXwwXGaK2fuSwIxkGqi6NWhh+3Otf3/tSqMGc8B3ZP5Lqqyu7t2jPVmJLLDw=
X-Received: by 2002:a37:d0b:: with SMTP id 11mr23105377qkn.449.1592938483918;
 Tue, 23 Jun 2020 11:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200623161749.2500196-1-yhs@fb.com> <20200623161803.2501574-1-yhs@fb.com>
In-Reply-To: <20200623161803.2501574-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:54:32 -0700
Message-ID: <CAEf4BzZ+m3gG-WSApdBkyk8G3Uws0VDUx=9-MjefM-Esx1RGJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 11/15] selftests/bpf: refactor some net macros
 to bpf_tracing_net.h
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 9:19 AM Yonghong Song <yhs@fb.com> wrote:
>
> Refactor bpf_iter_ipv6_route.c and bpf_iter_netlink.c
> so net macros, originally from various include/linux header
> files, are moved to a new header file
> bpf_tracing_net.h. The goal is to improve reuse so
> networking tracing programs do not need to
> copy these macros every time they use them.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/bpf_iter_ipv6_route.c    |  7 +------
>  .../selftests/bpf/progs/bpf_iter_netlink.c       |  4 +---
>  .../selftests/bpf/progs/bpf_tracing_net.h        | 16 ++++++++++++++++
>  3 files changed, 18 insertions(+), 9 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_tracing_net.h
>

[...]

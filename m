Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD2341411
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhCSEQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbhCSEPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:15:53 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD74C06174A;
        Thu, 18 Mar 2021 21:15:53 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id v107so4102220ybi.0;
        Thu, 18 Mar 2021 21:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gjpuME1q7jMrrX4TN68UeBFw2KeRypimn7z/8ID1ue0=;
        b=skHJYz+PMHSXnSso6Yd8Pt7+7pZScB5su1C7yM3iBynxPUXbmCYzL6lsn4v81a8mVf
         HEUaRT1jFdb6eK9QKxK/bufuRx6wCLZliI8Kf+M5welHIy51SdIgEeVnou3MoplbpCMd
         eLN1CYDwzkOy8tS9lisXVQANDO0WA/Qeii0ZJo9VC1SqHRvrwpY7VcEv3RLfn9BAs+6Y
         B2XvVBWiU5RIuwzlG8Yv8/+oYyEt00iQKKTfJkG+H8CgP4Qd9HrBDZqloxNpk9irmwB/
         Wsn1j9TF7Efq+QT1LXHEAUZKaZzWigd1UNsK3F4tvfMPHKYuiYRpVxqSAZy1x4BRIkiN
         DraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gjpuME1q7jMrrX4TN68UeBFw2KeRypimn7z/8ID1ue0=;
        b=l4cn4cSbexclN5I5vTdfxYSpPeyJbasMmHjTRzLqVcGbrHlVhYSdqZzGStJSGOtzMF
         TvNF6eUtK2YaC+QkXwwljcdRnO/8tLroJiJp2ZLjFKf5A4Vtl2NeYR3uxyQeyEODmU6p
         4YwlTyWf/NCh8CyYicu7jqvSplLxV4XZpmwYgIvRJYzj5PNLA9nGz1ee9XkdQBrPbY1a
         pGSvnfoR8TWqrXJUr58AI3kRe5/VPpkvj24/j615J+vIZBrHlNUopE9RFFuO6lklQ7UM
         LnxrMo4D2ZLMNs4NZTubqxQvXYEiqHl41vYwH11izkNyvELNycm0svke4L0oBgZbf60H
         Fo+g==
X-Gm-Message-State: AOAM532GjsCguwtyhkFzfeEAejDOYFebaGI1f6qo9jaWXAtQfmso242o
        bb7WxaYZ7NptQ9bkxX7/AWfI/C1Frbl3YmEG+mE=
X-Google-Smtp-Source: ABdhPJzjghqHQhMELyaM0yaKnn2Mo/vjGm4BNo7TNIAKcreUoMreUnU0klytMdgHKRvCOFdElYItPYbmuDTd8IUKeSw=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr3740266yba.459.1616127352489;
 Thu, 18 Mar 2021 21:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011503.4181087-1-kafai@fb.com>
In-Reply-To: <20210316011503.4181087-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 21:15:41 -0700
Message-ID: <CAEf4BzbiCx=5arwSZJEiwGuAKtu2JhOG+H=WObM++3VvEef+_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 14/15] bpf: selftest: bpf_cubic and bpf_dctcp
 calling kernel functions
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch removes the bpf implementation of tcp_slow_start()
> and tcp_cong_avoid_ai().  Instead, it directly uses the kernel
> implementation.
>
> It also replaces the bpf_cubic_undo_cwnd implementation by directly
> calling tcp_reno_undo_cwnd().  bpf_dctcp also directly calls
> tcp_reno_cong_avoid() instead.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

This is awesome.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 29 ++-----------------
>  tools/testing/selftests/bpf/progs/bpf_cubic.c |  6 ++--
>  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 22 ++++----------
>  3 files changed, 11 insertions(+), 46 deletions(-)
>

[...]

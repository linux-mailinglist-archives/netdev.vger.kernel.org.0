Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4944F9F3
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 19:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhKNSlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 13:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbhKNSlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 13:41:40 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740D5C061766;
        Sun, 14 Nov 2021 10:38:43 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id t21so12583892plr.6;
        Sun, 14 Nov 2021 10:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UvJGR+BpffWIpCuUyE/6KwF0J+HuYMAHzwfbQC6QDfI=;
        b=Cb5vGxDDHQzCi9s/bWP6YG7n1sv6nGdpmZFtXU0TScWjLJ33BnFyZXXtfJ3XCeqNjm
         u8rtR8oHnAMXGB8YJ7fXEpnIuISGA5/VPefcr3DRuIVJrsIMcnpvtPVev5C8N2Iy8RQF
         OrZIkLuCnUBe5dwCKuxpckMxXMxYaPxD+UYq0jdYsH0i0kxJC0dmrCDrAz2r2Wp3ObBr
         0tZoj5yEMsxNQPM5I51WRXfnzaZrcRwFOOK7ivBYb0wYpBxzV6Jy/BX26t91rc5rZn9J
         Lq9AobxpH1jeREAAs2N5kg5QZ/3AgnxjtCD9UjFj0NSxy0s395pMxaBA1kFY9vbEKX1J
         KGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UvJGR+BpffWIpCuUyE/6KwF0J+HuYMAHzwfbQC6QDfI=;
        b=7ihZ0GIT/PtXgP0iwpKUJhxhNP1g4KLFFtG+JeIIT80JTRutk2t1iPFhrRcH3SCZ0d
         kmZyxPaWva+qc7PB69aii1Cyz5gzTRbDhG0NLNw/9I9Oi6C63ssWkste/sXJgPqXcoRc
         iTGCx6LfxpfJayweAObISfjNFQ/hgU9AHLQfsG2njadLH95pL7HE60sz1bOXR7H9NNHY
         G7HYnvDWlxGUXxS+Q/tyOQSE4tgTWDDtOG9MO6orFrBaHwsZxUnwiB+eeDucTFY1spiS
         5djuetITRUdgPMqNSKsMtQ1pKxbDYwR2w23Nv0lxx+ejeiVCufVF7rVr50z+5jjcdWZQ
         32hA==
X-Gm-Message-State: AOAM531s6h4jcxJFXA266XL03x5850hIJ747Oqx8cllmbXwTf2fhyffI
        LGWGhrtzmCvfrNNjhcPicZAKbOGXFNPWCBv/xiM=
X-Google-Smtp-Source: ABdhPJxqbzHOq7RjUDX2Q+I0OsXBVQY90Fy5nsU2QByKzzmlFjlMo03dd8vMJ6s7khL9pNEK3IG/9jCcqwAgfKXREKQ=
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr39295068pjy.138.1636915122903;
 Sun, 14 Nov 2021 10:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20211113142227.566439-1-me@ubique.spb.ru>
In-Reply-To: <20211113142227.566439-1-me@ubique.spb.ru>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 14 Nov 2021 10:38:31 -0800
Message-ID: <CAADnVQ+zo-DMC=yqqphEno9pxwhBQ3soQzKd=2yLPNoLyBcFHw@mail.gmail.com>
Subject: Re: [PATCH bpf v2 0/2] Forbid bpf_ktime_get_coarse_ns and bpf_timer_*
 in tracing progs
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 13, 2021 at 6:22 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> Various locking issues are possible with bpf_ktime_get_coarse_ns() and
> bpf_timer_* set of helpers.
>
> syzbot found a locking issue with bpf_ktime_get_coarse_ns() helper executed in
> BPF_PROG_TYPE_PERF_EVENT prog type - [1]. The issue is possible because the
> helper uses non fast version of time accessor that isn't safe for any context.
> The helper was added because it provided performance benefits in comparison to
> bpf_ktime_get_ns() helper.
>
> A similar locking issue is possible with bpf_timer_* set of helpers when used
> in tracing progs.
>
> The solution is to restrict use of the helpers in tracing progs.
>
> In the [1] discussion it was stated that bpf_spin_lock related helpers shall
> also be excluded for tracing progs. The verifier has a compatibility check
> between a map and a program. If a tracing program tries to use a map which
> value has struct bpf_spin_lock the verifier fails that is why bpf_spin_lock is
> already restricted.
>
> Patch 1 restricts helpers
> Patch 2 adds tests
>
> v1 -> v2:
>  * Limit the helpers via func proto getters instead of allowed callback
>  * Add note about helpers' restrictions to linux/bpf.h
>  * Add Fixes tag
>  * Remove extra \0 from btf_str_sec
>  * Beside asm tests add prog tests
>  * Trim CC
>
> 1. https://lore.kernel.org/all/00000000000013aebd05cff8e064@google.com/

Applied. Thanks

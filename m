Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6A7314804
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 06:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBIFVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 00:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhBIFVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 00:21:46 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AF1C061786;
        Mon,  8 Feb 2021 21:21:06 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id d184so5663601ybf.1;
        Mon, 08 Feb 2021 21:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tDDxJunk/kSF01hHoPLEuIISQ65FfdAvSh+wL1JtR58=;
        b=QQXey0c/pbmhQjin9xj2kbG6a6GqGrvsozh+JiYGnPXPt3JgJurl/7RulJAFFRCDZJ
         WMDXBUYPAYjp1R7FRHSo0CaB3Je2Kisx+m429WKPq+W/YIw4uqfPi8DVA7BjMWsrvAu1
         Ew0Rw1R84WeZLW8Mv/AMcKavDbNw35Qg/NA9SivjBH2C0bIirPSIOjC/W3mO60p0R3qY
         IKDsCFgwizjnUQ1GiNallRXOw9a941RYrcAb/2pQADkwx/XPlqiQHZSz0FnrFe1aghzN
         1BTJBWlJ9106h2JpN5Y6v3HRA9zRBD7knFFVUh8OX7o20mpYEZVc60vzVFKD1niiqNqc
         AtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tDDxJunk/kSF01hHoPLEuIISQ65FfdAvSh+wL1JtR58=;
        b=q9GbYrT8P+WXCaMloAitQ7buzwAUIgOfXaPXAhVZGY6X9UzZm9UU3pcxtA9Jl9QvMI
         vHwPKEwbhuoMLin+5vWFL/+aVGqGIEIcr2RJJpUOl4dFH3tm9of2sFRXVQIxu/SQx66H
         81XThzWfajWNPrFRJkcXFaEkB1Y7iEdgeEq9f9XvRri6KvolXvziU02jSC+T3VlYGkTt
         V0hMT9ISGC6hMrNsMumOisXdXp62DY05LNHVL0Bqqe9usb+WJ/Eq/dBsoOQCuk5qVCrn
         1KwZmjvDZXUv2jIwchgvrkzu3J788DR/oI4prjrhDnbzES8p34UQIEEgWkKYk4Q8UfZd
         XxIg==
X-Gm-Message-State: AOAM5321PTIgxAUTtW62iYKueTUpt34IFXsUN+edfEtzHDfNRjxZbFR/
        9+oI/gVc9ORN89MAzL9sW6IYHmWEc5qKFu7Zjcs=
X-Google-Smtp-Source: ABdhPJyVHbOOCWvW6ym/iUDZC7/YZBh0FaawnQY6Nwi35FNLhwL2NGoCsRkgb40r1CCNuDValb7GcnFHoHRKFI34rGU=
X-Received: by 2002:a25:3805:: with SMTP id f5mr13211352yba.27.1612848065723;
 Mon, 08 Feb 2021 21:21:05 -0800 (PST)
MIME-Version: 1.0
References: <1612506439-56810-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612506439-56810-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Feb 2021 21:20:54 -0800
Message-ID: <CAEf4BzaMuMq0fwd6DvSx3VuHpMMDhs8tC-LhQ6q3RY-4W0w0zg@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Simplify the calculation of variables
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 10:27 PM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./tools/testing/selftests/bpf/xdpxceiver.c:954:28-30: WARNING !A || A &&
> B is equivalent to !A || B.
>
> ./tools/testing/selftests/bpf/xdpxceiver.c:932:28-30: WARNING !A || A &&
> B is equivalent to !A || B.
>
> ./tools/testing/selftests/bpf/xdpxceiver.c:909:28-30: WARNING !A || A &&
> B is equivalent to !A || B.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---

This doesn't apply cleanly onto bpf-next anymore. Please rebase and
re-submit. Make sure to include [PATCH bpf-next] prefix in your email
subject. Thanks!

>  tools/testing/selftests/bpf/xdpxceiver.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 1e722ee..98ad4a2 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -906,7 +906,7 @@ static void *worker_testapp_validate(void *arg)
>                         ksft_print_msg("Destroying socket\n");
>         }
>
> -       if (!opt_bidi || (opt_bidi && bidi_pass)) {
> +       if (!opt_bidi || bidi_pass) {
>                 xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
>                 (void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
>         }
> @@ -929,7 +929,7 @@ static void testapp_validate(void)
>         pthread_mutex_lock(&sync_mutex);
>
>         /*Spawn RX thread */
> -       if (!opt_bidi || (opt_bidi && !bidi_pass)) {
> +       if (!opt_bidi || !bidi_pass) {
>                 if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
>                         exit_with_error(errno);
>         } else if (opt_bidi && bidi_pass) {
> @@ -951,7 +951,7 @@ static void testapp_validate(void)
>         pthread_mutex_unlock(&sync_mutex);
>
>         /*Spawn TX thread */
> -       if (!opt_bidi || (opt_bidi && !bidi_pass)) {
> +       if (!opt_bidi || !bidi_pass) {
>                 if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
>                         exit_with_error(errno);
>         } else if (opt_bidi && bidi_pass) {
> --
> 1.8.3.1
>

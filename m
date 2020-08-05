Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597D523C594
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgHEGFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgHEGFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:05:52 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BA4C06174A;
        Tue,  4 Aug 2020 23:05:52 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q16so21015263ybk.6;
        Tue, 04 Aug 2020 23:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aF2mJ8jPe6CZaCSVysSg0lo7Mh5AeHIGVViaq2byJ4Q=;
        b=T2ejZSfPSAkd1WagrvHlSZriqh3LAW1SA0AFnDjapU3BETUIcy9nxpYs2tBjIoqTY5
         ATEWTsWNI+PCDnHaOvc0J7kyhJLYhZ6roiXOjHouU5R0HOF8sX9YSybdthhIB0bAV9WL
         aTAM5bu+4ogo6MTEYslMmS48HXy9TdPMJNfoceZOXbm0QsTJzS8oLMYdzW1r4fTbcc5k
         5/A+ghFgLhUUIowWzYL23uWr5NYg21jDjzXJrQFztwKyaAlj1j/kNG23GaTSNsN7X+7A
         i0oHeX1hp0DE0LmHK9JKewJmxoapgioHxexPxx9CHtTqNqBIMt3cabjI47BmjySNjOX3
         Qqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aF2mJ8jPe6CZaCSVysSg0lo7Mh5AeHIGVViaq2byJ4Q=;
        b=bdQMj93QAhKnjc9PzEuV+hM40fa0l9iF8sAF/+LmDwzfNlR/nEWauszwsyDx2z0qd+
         yuYuuQcb2DHpXJbc+c3PoYkjzNf0nAMhNvCB3/hPGISXLxJ2YMSXWmRM2/mHTVSwGZ01
         dVVOiIR8D+uBd56zO51Dw3gowCA/CwE1o0aMqcKv+e5kxSqwkzKjEuOiW6JwXG3Wkq0D
         BlExgI5+oBkBbUx6QjFq8W3sl1NFfBaCD6EEBF+6hyZsQLV7ziJjt+g7TH5Szjeh76Bw
         H265BLYRFmPuAumL6CYc9MkhCVIrZuYdV8Up1lDnA69vXSbaYri6wfsKI6+KaicVF1gt
         X4VA==
X-Gm-Message-State: AOAM530D0/jGEqDwXDdY10ra+zxLoihgCqE6GGgsQYV/Wd845/Kgbhsa
        pALENZuWdEWqOKv3/M0IOK8nH0YMbdGI5tb6s/k=
X-Google-Smtp-Source: ABdhPJxgpUOSF5dhU+hud1JhVyGJWbaiZcRr0Cx7lukHaLpRiyQ6ANVtIYiFGycocydMqx07uzY2Thuc04AAiWqnmM0=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr2546445ybg.347.1596607550899;
 Tue, 04 Aug 2020 23:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-6-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:05:40 -0700
Message-ID: <CAEf4BzaYBbUbd01sfOB5rCQ8xX7aoR3KBVOMSu1jXVboQREt+A@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 05/14] bpf: Add type_id pointer as argument to __btf_resolve_size
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding type_id pointer as argument to __btf_resolve_size
> to return also BTF ID of the resolved type. It will be
> used in following changes.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>

[...]

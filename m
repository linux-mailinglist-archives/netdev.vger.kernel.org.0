Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531CD3A7705
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhFOG0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOG0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:26:41 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2138C061574;
        Mon, 14 Jun 2021 23:24:37 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g38so18886189ybi.12;
        Mon, 14 Jun 2021 23:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R6CiRT39KoHnr4CfQvne5IWTcKQuw3ay+vt7NMCzJeM=;
        b=ar81s3ispK7Vqv3nWZANhPSHhOa1FenU5+qicdGEJA7WiYqZ1dWzJ0zl5yJ+9PQc3B
         wJLgI/xG6fWXIrbUWZFRDyUtiw045XJjV3qOntXmW8fTwbNUJ7wrGLEVaOIPHSnVzRIb
         MEk3FEo/9UcPH/dFoW7mIpFgxUE+z4umQMW3X/Y2dLMyq/fFqmHgMMiRXdZAnTiBAYt/
         DZ3behnClMuFnOLAtSSwubTjxZ0+1gakzQDGgE8kYfX49LLMqtUcEN4Ek8Vzq3lDX4hd
         Ftjo/SWR4Q5ZT5GHcbHRN0PsIZxODBZ6INrxFe2owJyWFQS2tfXCD4u2azT8DSLbdnQ2
         pjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R6CiRT39KoHnr4CfQvne5IWTcKQuw3ay+vt7NMCzJeM=;
        b=uiPIEmuiW7DuDchFfAbDM1GrUkiVZpD3wuU2IgPUo0JqRMUWKE5j3TXptl500jikrr
         4/GrU7WbDIqCfIsYfDi9DSwYDKE7ywW3HeKA77KS1ABxf2Gq/i0OQo3FlzRuzJ9jUNu0
         pEEYznbm8cABwiJ0fXxiLG6JcqQ/8lvwdIEkLE54IVhWixee+TjiP+UhOns1L+OLHWU6
         lgF0A6qxty+GRmOH4IXx8ECBws2/Qmz07sgy1WvO8riMTBRPcScuNcuuG+Y7yS9+zx34
         rtWzRpXOj/aeAJk4g7WjTrqgFu3+2siXKULs/zWodn/UlpOhyFBu2pzVjRzxMsTId1wU
         Ukyw==
X-Gm-Message-State: AOAM531Sv2A1hXrkyuw2BPaaN1XBYBUaSw1I0aRmMuUR0ZSLyhkVga5y
        EF0LMwlt4PHDb6YmUHpuBD8DNUk5q4gPJJkJRzI=
X-Google-Smtp-Source: ABdhPJw8oOAylhLqTP3LzbyzqE9zfDHDTMEt8wm8nddNSJDY2X+SQRcfJoPmoRjAm/vcMKurABZhqEz3pgHQWNcwaNU=
X-Received: by 2002:a25:6612:: with SMTP id a18mr30701018ybc.347.1623738277016;
 Mon, 14 Jun 2021 23:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210609115651.3392580-1-wanghai38@huawei.com> <34bd6047-2b4c-1218-7822-57aea059deb1@fb.com>
In-Reply-To: <34bd6047-2b4c-1218-7822-57aea059deb1@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Jun 2021 23:24:26 -0700
Message-ID: <CAEf4BzaxW-ZfOUvs--s1zt1YzTLrPWcvwG8W5FRejj1pNHWw5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: simplify the return expression of
 bpf_object__init_maps function
To:     Yonghong Song <yhs@fb.com>
Cc:     Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 8:21 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/9/21 4:56 AM, Wang Hai wrote:
> > There is no need for special treatment of the 'ret == 0' case.
> > This patch simplifies the return expression.
> >
> > Signed-off-by: Wang Hai <wanghai38@huawei.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied to bpf-next a few days ago. Seems like patchbot was off duty
at that time.

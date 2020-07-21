Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1713B22891C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgGUT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgGUT0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:26:55 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47A6C061794;
        Tue, 21 Jul 2020 12:26:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h22so25305430lji.9;
        Tue, 21 Jul 2020 12:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gdc7ompz7Y9cqUyclWX2LVzylrZVjLX5sJyGR822OiE=;
        b=ixobYwr9Hu55L7/IMZYbgTVz7Y4ber/W27KFrOwhFgubdTDMcWGsHcwACw/CssFszx
         Omdb5QzaSlFPrywNGeJJXTQj1b68rYfWzOcVLks90GO/C6Ck8s/UehdRnUdfgNU3oPSd
         OYk1GeMy43BFaf97qsqO2KS0f/4HUAdMfVQxrL+sqQNGOIIROBaVPy8GKLaTO7Z00spa
         QJ8aIvCzgLrCtIRrULp9NuMlDsfqGsCZW5OAOPM+CYo1zVA820fVVerhyCKJszf28bjR
         SjTIHc19Gwt/pn4x4J9rfPzJyCBautvtiJ9BjYbVEA40k+v/ZAMYw6w12dd8uQzN5TD2
         jBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gdc7ompz7Y9cqUyclWX2LVzylrZVjLX5sJyGR822OiE=;
        b=mTCb6KK0mWDDxdlnHhO8HwBC084vxAmu9dfqrD/Wet7ZHJz8y+WTyY7/FzVyh31Zav
         uk+5Xqln1cgoR9X4L6RJ8KfxA7AQID5UNQLkOT3aBDEwtCg7UjOH3UsihyafZxz4isAL
         0Vz9an5Kw1THidUeqeVlWio+ejkiFu1MzIVvDrKyDkL87EgZxjYghVxaNzPDNDlXdAf2
         SJTKXA2acOen23Om/pTwuczI/e50s/ZRFMHoJ01LHXrpg+smqdtYYqRQiuhJx63k77Wz
         5xWTDbXeKkKkg56vLaCz9tdGiyGU7kVdcNGQL4hEcRlsJw+qCaIXVn70+8jtKbCtrslo
         twJg==
X-Gm-Message-State: AOAM530XdZTLtNTBjte91fHFcP6npQtTaDAozSPwLZopKds8ahSAKVGG
        2SffGBpF7IDeykenBtfO7LYGM7IaDwyWtpQqZXM=
X-Google-Smtp-Source: ABdhPJxX4mPO5KiNJdpl9MzzWfLiVn9Dc2OODYLKlFKJWY/1q0/5jwoS/DQ/k+bj59gOhkHb8BL5accaZml2CJGRikY=
X-Received: by 2002:a2e:9a4d:: with SMTP id k13mr14223952ljj.283.1595359611149;
 Tue, 21 Jul 2020 12:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200720061741.1514673-1-irogers@google.com> <CAEf4BzaEJOV_eUtUEr6Q=E_fzU1d=jiN_ZwFQ-6=bdF9CYOgXg@mail.gmail.com>
In-Reply-To: <CAEf4BzaEJOV_eUtUEr6Q=E_fzU1d=jiN_ZwFQ-6=bdF9CYOgXg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 12:26:39 -0700
Message-ID: <CAADnVQLcr4ds1yydxph+MgGWJLKkoxk=EaTfbszxsXTxWTCYYQ@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf bpf_helpers: Use __builtin_offsetof for offsetof
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 11:21 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Jul 19, 2020 at 11:18 PM Ian Rogers <irogers@google.com> wrote:
> >
> > The non-builtin route for offsetof has a dependency on size_t from
> > stdlib.h/stdint.h that is undeclared and may break targets.
> > The offsetof macro in bpf_helpers may disable the same macro in other
> > headers that have a #ifdef offsetof guard. Rather than add additional
> > dependencies improve the offsetof macro declared here to use the
> > builtin that is available since llvm 3.7 (the first with a BPF backend).
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F5810B395
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfK0Qjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:39:42 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33556 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0Qjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:39:42 -0500
Received: by mail-lf1-f67.google.com with SMTP id d6so17720592lfc.0;
        Wed, 27 Nov 2019 08:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vmkegaf4vZvX2ziqVB5RPleLu7JAiT7hE0cpq3SxoSQ=;
        b=REPG81Qtq3lNOAL+04c29Gqfhs6hoxI9x9Bmws8ZTR3V99PKkY+OF1st8X4uBP4+EC
         i24A2tCrAPpdRJ+2h2zsAB18U2WiSgrWA67/0Mx5A+4Qr2CYxIKKq0l5eALsYfy16w2d
         hOJPxdff+EgcnL/vbeY1eGmbZNZjso+4Zz8MPUjrHrKA5Luwa+z9bh/FnOr7RsaNOCLW
         O6W2Ec9mjDdyuW/LS9UKPdipoMwDZoYqrjOU20jx/n96jpZNQO7ow5jyxT1Hab1mLH4M
         hBFZVxl40aCaqofV7YX/x9hJoisKCt52V6aN5SjuehrqOAewrinJBS9DIxH95sN0E3iY
         V51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vmkegaf4vZvX2ziqVB5RPleLu7JAiT7hE0cpq3SxoSQ=;
        b=s1fW+od24QD78tgxKCWhkme8i30SAC1DF30HyP9/RC+LToOGKqSbkQ51+4qMEmSkLU
         DjFOxm1uc72Ax4+Y6qqs3/4eCjsShpf7tziJS9PnYjpdcokQBU2J6rbU1eLcNwVqAdAq
         U9KgPohLL76xebY6icOzWIfYeYfWonNlrFAaR3QbtYBYMzFi0fGw5KmCqv033nf0OO8u
         wPQ96rYlLGpTxCT5ljdQkDJ/nxBQ+xTT2ZrdusoIXaDKmvmIUp+0P32kLCcNeHaonc6w
         gBzEMpBa4zTmNczf9YKvpkAYHEOJShhuBXbj6cDc72W0cF3FydycO+U+MBPQPB4ofryv
         eZFg==
X-Gm-Message-State: APjAAAUBw+OzFNdfCbFN69CXumnmK5SfKCtNjBQnYPQ+6awj6EWyDbak
        fizYkKQTZTM+0OUA3/kCaohhxpdnq5G7HP37LeY=
X-Google-Smtp-Source: APXvYqzq8UPRrJfJ0wmsZswTCjUyrB8oZvG2T0FT+puktIIEMekl/zT+YUHyiboaJFuSOcFVFmY7pDdhRQkmBDOdfQE=
X-Received: by 2002:ac2:5462:: with SMTP id e2mr19856735lfn.181.1574872780262;
 Wed, 27 Nov 2019 08:39:40 -0800 (PST)
MIME-Version: 1.0
References: <20191126183451.GC29071@kernel.org> <87d0dexyij.fsf@toke.dk>
 <20191126190450.GD29071@kernel.org> <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org> <20191127134553.GC22719@kernel.org>
In-Reply-To: <20191127134553.GC22719@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 08:39:28 -0800
Message-ID: <CAADnVQKkEqhdTOxytVbcm1QnBcf4MQ+q4KYaHzsuqkq3r=X-VA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use PRIu64 for sym->st_value to fix build on
 32-bit arches
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 5:45 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Another fix I'm carrying in my perf/core branch,

Why in perf/core?
I very much prefer all libbpf patches to go via normal route via bpf/net trees.
We had enough conflicts in this merge window. Let's avoid them.

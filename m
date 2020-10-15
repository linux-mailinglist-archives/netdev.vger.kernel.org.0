Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7CB28EBEA
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgJOEEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOEEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:04:32 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4150C061755;
        Wed, 14 Oct 2020 21:04:32 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j8so2616314ilk.0;
        Wed, 14 Oct 2020 21:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3Nz4+NRiWZSpGfngSIEbhq0xaLLJ0DBPC/UMfu3JFko=;
        b=ZZKZVQli6PhH4BkIu0+1SthiRqx0oUk9k+TO4ksycS4afu3NLDcKDgmaLWv2dzIuOH
         /ozyJ7BgqzKNl3YYVbk+XCJ3XfidatKhb2P9atlHmlgW4WLM4LDFs8h1R2cxBB/gcEL/
         Hm/Ifj+KyjXmILnJsbMIWeHka5BBFbKjaUm7H4unxbPMOlqWXwGWSMISp96uYOF86H5N
         ZcNVsUsbotft0XIcjpuXJLfTy02FO7DE39pSmT4FFN5ocQsyUnzZUCYzmLJ6ZOtIZrVS
         YCthy6glis96W8FpSVLndj5+KD0kqMwk5b95qhy1U1rNu2u0UVL53q8aHFJTJHJUPr4X
         rQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3Nz4+NRiWZSpGfngSIEbhq0xaLLJ0DBPC/UMfu3JFko=;
        b=OFQg6C9N/74kgwvrV8nLoI0CDBT2luo5F2zK2f9neBgaHYUmqJAt8f/W4HM3WelREc
         innZo9eg6SrZogW+EXKTa+tsWpXEQvZF5QxMXFMvR+kuFKKmAPMw4V/7bdQT+f6/bxHL
         mNJPRjVAVZr554/ILr3SidjNX2SEXvvH5NSqAbltoaeZJ8l6yC+hTF0O6+UFTSlqUTyY
         6yn2ETo7+0OMsXu72xjkROmzUrFZRoaHjG8saiE0WrQtHsZ4ZZdrFMVJIbbyJfYtR+pF
         ihfk6wIbPc8ZLEkttMY+kDOxPBGHcUoKiukY2om9gIY28okJEQ6P3bGwk31hiWAucE74
         EUbg==
X-Gm-Message-State: AOAM530IH8gZR1Kk3wIArxKFKgdYtTaE/vF60J1peq5Xs0KsV6CDMWBF
        l0oqXk8EDo+L7WLe+Ilnb0ng8Hs5boY=
X-Google-Smtp-Source: ABdhPJwePsAFP43/L6f92Gi67KXAda+ifzdwOLgXnnvDN8W+MNs+nOW7EpgjD6tjh4FUI3qAukZaTw==
X-Received: by 2002:a05:6e02:1283:: with SMTP id y3mr1746848ilq.305.1602734671920;
        Wed, 14 Oct 2020 21:04:31 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c9sm1704450iow.1.2020.10.14.21.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:04:31 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:04:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5f87ca47436f3_b7602088f@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
 <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Wed, Oct 14, 2020 at 10:59 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> > true or false branch. In the case 'if (reg->id)' check was done on the other
> > branch the counter part register would have reg->id == 0 when called into
> > find_equal_scalars(). In such case the helper would incorrectly identify other
> > registers with id == 0 as equivalent and propagate the state incorrectly.

One thought. It seems we should never have reg->id=0 in find_equal_scalars()
would it be worthwhile to add an additional check here? Something like,

  if (known_reg->id == 0)
	return

Or even a WARN_ON_ONCE() there? Not sold either way, but maybe worth thinking
about.

> > Fix it by preserving ID across reg_set_min_max().
> > In other words any kind of comparison operator on the scalar register
> > should preserve its ID to recognize:
> > r1 = r2
> > if (r1 == 20) {
> >   #1 here both r1 and r2 == 20
> > } else if (r2 < 20) {
> >   #2 here both r1 and r2 < 20
> > }
> >
> > The patch is addressing #1 case. The #2 was working correctly already.
> >
> > Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register assignments.")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> 
> Number of underscores is a bit subtle a difference, but this fixes the bug, so:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 

Nice catch,

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> >  kernel/bpf/verifier.c                         | 38 ++++++++++++-------
> >  .../testing/selftests/bpf/verifier/regalloc.c | 26 +++++++++++++
> >  2 files changed, 51 insertions(+), 13 deletions(-)
> >
> 
> [...]

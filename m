Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2639D348A46
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCYHkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhCYHjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 03:39:42 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F59C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 00:39:42 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id j17so683791qvo.13
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 00:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=55u5Yc65Bxv+UbNocPWeMvSZQF1sJaJoYpbFW9jy0Co=;
        b=kdEgL9YyR0l316YAq+cfnhXQ/w2pQuXgaci7bO2KBuJuvGIG6sWUqvtptKBdl6MxEA
         9bDTNsHw9Fr3hv1N/ShFznT5n2iTYeHhS6wQzVGOoNafc8rYOIbcUyEdotig+Qi+GrIb
         Om0KtglVQch7itYaG8xqr0me+fXgYRFkW2z0rynxNAkKXXXFpnYre+pFTFQ7/7ntkgE7
         A4fxsKqDb+CR5kYNKTxCbJ2BPYeShUQeHFEZdkfZRuSYEU3jxHtY0uVMOZTvRsrbM25+
         7wQIbKqQDSwRp6ZxfEIh3R7X387CBUhtBwa8kGI2WFhDuM9io3zzMke7BkEgSSjjKThq
         0OZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55u5Yc65Bxv+UbNocPWeMvSZQF1sJaJoYpbFW9jy0Co=;
        b=naWxYYGZRrZ0a50Fll/Bhjw8K134mHefUSBk/tyd1bkZ0IvwoqY1MCsuTK/m3dlMbX
         LrMKqGA3q4NJgCOMNIKDwPgrB2OpW+zUQDLcJppf/nAiyvDZ2rrLzFL4ubCLmZ2TNu0C
         ZIxGIsxHIyq9WvDsdCsTIcQxd7FQASSrDNGIYKYAC+6Imq76SOb9eqFXbNiJtniGmvGO
         oBzoa6N80p7Vib3TmF6NpYg0DxMgIA2HOeO4/Kgbwf5qiKQ8v4hplE5BBp+8G0GJlegF
         Tb3hUHvHHEFGgu8zma9rM9raBp7PqTZND7uSNKEUnhJizxCVKTRXLPanBItCTLAPnvUJ
         mnYw==
X-Gm-Message-State: AOAM533d/JSKg6LfYkKOd+KinxypQ1HoNoNbxmHy/xogeKJFLnFeqqhv
        Qs6SbQCwScGj3hj5PvW2vpcPQk6fc8rqHa7jU3q35w==
X-Google-Smtp-Source: ABdhPJx1jyA9I6ZZ0Y4L4xLi4PlTOW+KZzNs3iqB2RPUGRFZAX/86alVqHCIcCVm17Ic9/4vAu4Xy293EIREZJl/1pA=
X-Received: by 2002:ad4:410d:: with SMTP id i13mr6814280qvp.44.1616657981372;
 Thu, 25 Mar 2021 00:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210323064923.2098711-1-dvyukov@google.com> <CANn89iJOignHVg-QOtEB_RVqca=pMczJv-k=CEtPRH0d4fSdgA@mail.gmail.com>
In-Reply-To: <CANn89iJOignHVg-QOtEB_RVqca=pMczJv-k=CEtPRH0d4fSdgA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 25 Mar 2021 08:39:30 +0100
Message-ID: <CACT4Y+YjJBkbi-u6VTikhHO4OjXhdKnQTqDiHxB5BEZG2Qn7qg@mail.gmail.com>
Subject: Re: [PATCH v2] net: make unregister netdev warning timeout configurable
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 10:40 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Mar 23, 2021 at 7:49 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > netdev_wait_allrefs() issues a warning if refcount does not drop to 0
> > after 10 seconds. While 10 second wait generally should not happen
> > under normal workload in normal environment, it seems to fire falsely
> > very often during fuzzing and/or in qemu emulation (~10x slower).
> > At least it's not possible to understand if it's really a false
> > positive or not. Automated testing generally bumps all timeouts
> > to very high values to avoid flake failures.
> > Add net.core.netdev_unregister_timeout_secs sysctl to make
> > the timeout configurable for automated testing systems.
> > Lowering the timeout may also be useful for e.g. manual bisection.
> > The default value matches the current behavior.
> >
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=211877
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> >
> > ---
> > Changes since v1:
> >  - use sysctl instead of a config
> > ---
>
> >         },
> > +       {
> > +               .procname       = "netdev_unregister_timeout_secs",
> > +               .data           = &netdev_unregister_timeout_secs,
> > +               .maxlen         = sizeof(unsigned int),
> > +               .mode           = 0644,
> > +               .proc_handler   = proc_dointvec_minmax,
> > +               .extra1         = SYSCTL_ZERO,
> > +               .extra2         = &int_3600,
> > +       },
> >         { }
> >  };
> >
>
> If we allow the sysctl to be 0, then we risk a flood of pr_emerg()
> (one per jiffy ?)

My reasoning was that it's up to the user. Some spammy output on the
console for rare events is probably not the worst way how root can
misconfigure the kernel :)
It allows one to check (more or less) if we are reaching
unregister_netdevice with non-zero refcount, which may be useful for
some debugging maybe.
But I don't mind changing it to 1 (or 5) if you prefer. On syzbot we
only want to increase it.

> If you really want the zero value, you need to change pr_emerg() to
> pr_emerg_ratelimited()
>
> Also, please base your patch on net-next, to avoid future merge conflicts
> with my prior patch add2d7363107 "net: set initial device refcount to 1".

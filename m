Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8864108AB
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 23:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbhIRVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 17:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhIRVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 17:14:01 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B39C061757
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 14:12:36 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z24so22307547lfu.13
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 14:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVZJu4t/IugUGV+W6kU+ykKkbEaLVPP4RIQU42du5mE=;
        b=NO0esR917j83JwTOpZQWYClId3457L6NJIf6fJ7Evei4pDJ6w9tdhLXDN3IinOEvW+
         VMthkeYirKlrzLR7LCf4USQHGLJ9wmo5a/QkxpfY9+CPatz4XjsnDZX+q2dIqcXYIANe
         4/RbL5IIz9wKXWQ+bU6E9Y8mF2Wc3GAB8iq/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVZJu4t/IugUGV+W6kU+ykKkbEaLVPP4RIQU42du5mE=;
        b=VqOik6RFuNqYuxYwkyGN+fxLhJ+yOGl4xDYUwpn8Y1A7nQPoUC9aqOWrLCezxGAQsc
         o3g1VETM2YyFFbbYQoc5UB1Sh/+kV9HZDm6i54hqvayyXocWVeEqUyR2R81JCb52oe23
         BilZetQZL+dyFzqMW8JVm9i/U0nXqWnEIguZ6rLM6jIOFJPq+YoIC59QVHqGoo/6Robd
         olhvD8t7i1XTUR3nzQ0G1htiiztqeok4ZmeXHH2sQ/wI+Mb8dXOlowXRLvzhYiTuRAnt
         VIPAAvMyd/ldmCpDkbQ4gRkiqMi8o420r3gd2bYC3AJDdRH48zLDMkUV5PAZgXrwhIR0
         7Rwg==
X-Gm-Message-State: AOAM531mhLMi4/99wpHRbrHnWfTZElR+XHRSNm1bIPuXFRnb3bDke1be
        r3lg0tDQSTdod2oXdaGrzPUELNy0jdOpUIwr3Rk=
X-Google-Smtp-Source: ABdhPJzI3TZPCg/9LvihxBSodn2YPZA1wuMRDARv4+jK2/+AlmwvXOIiRwsm0eIcIT56HuZgaQ9Pww==
X-Received: by 2002:a2e:2201:: with SMTP id i1mr15321143lji.483.1631999554820;
        Sat, 18 Sep 2021 14:12:34 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id w16sm852927lfd.295.2021.09.18.14.12.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 14:12:33 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id z24so22307204lfu.13
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 14:12:32 -0700 (PDT)
X-Received: by 2002:a2e:8107:: with SMTP id d7mr16412051ljg.68.1631999551766;
 Sat, 18 Sep 2021 14:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com>
 <202109182026.18IKQLng003683@valdese.nms.ulrich-teichert.org> <CAHk-=wjZukwHDpm6PUP=cFTi8wWQs6Z5Np7xv7SRphNqvm0FPw@mail.gmail.com>
In-Reply-To: <CAHk-=wjZukwHDpm6PUP=cFTi8wWQs6Z5Np7xv7SRphNqvm0FPw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Sep 2021 14:12:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whswL8vPtdVphebUwdDd2Y-9j2d8XAd35bB+mqrhc0YTA@mail.gmail.com>
Message-ID: <CAHk-=whswL8vPtdVphebUwdDd2Y-9j2d8XAd35bB+mqrhc0YTA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Ulrich Teichert <krypton@ulrich-teichert.org>
Cc:     Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 1:46 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But your config shows _other_ errors with the IO functions, so I guess
> I'll need to look at that one too.

Oh, and all those games with

   #define __EXTERN_INLINE
   #include <asm/io.h>
   #include <asm/jensen.h>
   #undef  __EXTERN_INLINE

don't actually work, because there's the usual multiple-inclusion
protection on top of asm/jensen.h:

   #ifndef __ALPHA_JENSEN_H
   #define __ALPHA_JENSEN_H

and this include of <asm/jensen.h> is entirely unused, because we
ended up getting the one *without* that empty __EXTERN_INLINE #define
from an earlier include of

  #include <linux/interrupt.h>

that caused asm/io.h and asm/jensen.h to be included earlier.

The *other* machine files know to do their includes at the top of the file.

But then I end up getting

     ERROR: modpost: "__udiv_qrnnd" [lib/mpi/mpi.ko] undefined!

because CONFIG_MATHEMU wasn't set and the crypto stuff wants the MPI code.

So there seems to be other alpha Kconfig issues in there, and they
aren't all actually Jensen-specific.

Oh well. I guess can fix things up, since I did get tthe
cross-compiler environment..

          Linus

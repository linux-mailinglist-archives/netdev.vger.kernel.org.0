Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7B31EDE05
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgFDH1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgFDH1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 03:27:11 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A71C05BD1E;
        Thu,  4 Jun 2020 00:27:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so5209892iow.7;
        Thu, 04 Jun 2020 00:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=mGOxjTCdefrrnR0hBKEqLE+5+y5wUx6BcOT52JEiO/w=;
        b=ZS4bR5ylkA3qMyDfT9teREVYO+h3tibjnXyMJoJVX+G5mJ13iGtF5nRneHn2y4BXKk
         lbuA38DH8PUg7+NnR/cRrvaPdec+9VbV7j8bpXSIvpgF1JXXQjjbiwoR4VphfuiGExJt
         hLAd/KpHYlSGyG+SYPS4B4UqdSRoUABVvzmUhM84xdRr3+M7Ejw5zRXRHI9S7C4ge69w
         pHHApPVvaksuEjuQWJYGIZ58KDToZLKr1OfN8O/H8RmdIn0p+KhbEW4AU6+9mOsYqoG0
         i4HZ9VdbrqFEIkfk7P5p1r/q/z2DKw42yvXNm3xth1WgLu9BQ1Leo+hkaKoCcnQ7shWy
         D+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=mGOxjTCdefrrnR0hBKEqLE+5+y5wUx6BcOT52JEiO/w=;
        b=WBkGpG1JIPkpiRgZ/zPYX4aOJd0rsTgI+A8sH52mYb8Y6itTIY2Dbq3LbG0CVvyK8d
         7yeRCbcN+rivF4csTFIXvbi+gr7hWPpzyfZwL2PxM04ycVCFXbtpxNPt4h2V2bzuXUE8
         PcaY//RmkERKRY/6jh26rxI7sZw6to9isozf/71MdKKcD1M1LlulxXv46yL35S9B8QwG
         +ltyiwm2ubKPo+Bssw0jrCZRhzlbUTp2MPPgk5kL+KUU6gls5pUnyzui9mVhHqB5mkZ/
         Egk+dmWoRKME3fyNxQ4jD5e7XhDP2GPHYiAzaBxED/iW4KvGHMjKOKc5jHL/14+49F0F
         VQ/w==
X-Gm-Message-State: AOAM532k0J3AmCTtfrEaXOWyQ3SiwDSc5kEctZRh8wd4btl+fWuEuPla
        szJlYdGSIuS73EwThbuD14hmIlwjsOMYhoPwmgFg1/y3
X-Google-Smtp-Source: ABdhPJwrHY2BsggDHErpO1Iuf0ec8cSLwXn1wO03W9qrRj259eIfuSS5XQEsDKLZy/A8Pd7aPUbrd6qaIHCM8QmxBFo=
X-Received: by 2002:a5d:91cc:: with SMTP id k12mr2896278ior.135.1591255630008;
 Thu, 04 Jun 2020 00:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org> <20200604033347.GA3962068@ubuntu-n2-xlarge-x86>
In-Reply-To: <20200604033347.GA3962068@ubuntu-n2-xlarge-x86>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jun 2020 09:26:58 +0200
Message-ID: <CA+icZUU4Re5g3rRJ=WF3_KiCEc3CUmbH_PibTunuK_E1QskEjQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] Remove uninitialized_var() macro
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 5:33 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Wed, Jun 03, 2020 at 04:31:53PM -0700, Kees Cook wrote:
> > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > (or can in the future), and suppresses unrelated compiler warnings
> > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > either simply initialize the variable or make compiler changes.
> >
> > As recommended[2] by[3] Linus[4], remove the macro.
> >
> > Most of the 300 uses don't cause any warnings on gcc 9.3.0, so they're in
> > a single treewide commit in this series. A few others needed to actually
> > get cleaned up, and I broke those out into individual patches.
> >
> > -Kees
> >
> > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> >
> > Kees Cook (10):
> >   x86/mm/numa: Remove uninitialized_var() usage
> >   drbd: Remove uninitialized_var() usage
> >   b43: Remove uninitialized_var() usage
> >   rtlwifi: rtl8192cu: Remove uninitialized_var() usage
> >   ide: Remove uninitialized_var() usage
> >   clk: st: Remove uninitialized_var() usage
> >   spi: davinci: Remove uninitialized_var() usage
> >   checkpatch: Remove awareness of uninitialized_var() macro
> >   treewide: Remove uninitialized_var() usage
> >   compiler: Remove uninitialized_var() macro
>
> I applied all of these on top of cb8e59cc8720 and ran a variety of
> builds with clang for arm32, arm64, mips, powerpc, s390, and x86_64 [1]
> and only saw one warning pop up (which was about a variable being
> unused, commented on patch 9 about it). No warnings about uninitialized
> variables came up; clang's -Wuninitialized was not impacted by
> 78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized") so it
> should have caught anything egregious.
>
> [1]: https://github.com/nathanchance/llvm-kernel-testing
>
> For the series, consider it:
>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com> [build]
>

Hi Kees,

I tried with updated version (checkpatch) of your tree and see no
(new) warnings in my build-log.

Feel free to add my...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks.

Regards,
- Sedat -

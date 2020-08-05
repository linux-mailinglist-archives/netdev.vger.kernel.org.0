Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8EF23CDC1
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgHERsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbgHERon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:44:43 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF1BC06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 10:44:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f10so743984plj.8
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 10:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OeVarHB8PyC/4WrdMH1wOnZuquqBZq7uGaYiqaJ/H2s=;
        b=iYNRhBUE6a6QRqZgvap/7b6HfFiE6nn5SF6u9BZ45g4hcY5ly0Tddjzei52onqC+ua
         nPE6GMic/x8EdXYFlIZDbKtcad+icJvGX3GCSblD8YJnipnUimix3w1YUBEqJF7uNKIQ
         SyMZMMX9um2AZK0j+y258RYcKICG+Kr3q7aUuCTm8kL/G7cH+vGSy6AXxstJxKZCKiEA
         Avsvi2T6+glTOJKwv4M3c2hK/bf+NloSXGW66axtsQ6nRrPp0h0BKvQQFuA7UvBsSgCE
         2aXiKHiI/CVmpPlQN/pXwGB34/FyJBOpUQve7SYpYzOxBHlc/Uo6JETHMS2C1CWmXvzg
         9jtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OeVarHB8PyC/4WrdMH1wOnZuquqBZq7uGaYiqaJ/H2s=;
        b=oBvZplywv8UyNsTSdSKI5GjTsrJVSZI9oO1HJUwENSX2Hvjz0S+yj1dnKAAeX1oZgg
         bsJ5meUoNLEIRfPK/r6YrA+oN29MF4etGUK7Fmmrl/m1oUJCWbduhFpxYPD+KceWEWCq
         NmZF0AhKDPOcq4wpXjpViEQLtaQ+9IWOPQldoyKTZB2zXGJCQ13XZkvr59Y4sGU5yC1s
         9pw0XkEF0LGzbWYNz601lFrKNZE30sPIQ0NJPkyLix0CUTMyKZaSwN2jTPJ4E69qjSae
         mr8GOEnNuQESzSSugMHBIJ7fPb+TBO2XEbisaeBmaKQ22EJMT6//PjqhvNHh95WsFOUN
         Wkwg==
X-Gm-Message-State: AOAM532ekHkAnUbuM/upl0d+B3SMzaa2l8tBw0e4y/OtipPqMuSybpfS
        GY+aMhsAgm3gddaVILb2yGcA3pwHml0BW5APlITifQ==
X-Google-Smtp-Source: ABdhPJxYIH4X/KPPSVLO3TPfmhVajNLyAm6evVBVZ4ZWeH0jRb4W3Vq6aFy+xQJKcALm/osgPRjKbK+HjbIGlOk2hTY=
X-Received: by 2002:a17:90a:3ad1:: with SMTP id b75mr4123456pjc.25.1596649482146;
 Wed, 05 Aug 2020 10:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200708230402.1644819-1-ndesaulniers@google.com>
 <CAKwvOdmXtFo8YoNd7pgBnTQEwTZw0nGx-LypDiFKRR_HzZm9aA@mail.gmail.com>
 <CAKwvOdkGmgdh6-4VRUGkd1KRC-PgFcGwP5vKJvO9Oj3cB_Qh6Q@mail.gmail.com>
 <20200720.163458.475401930020484350.davem@davemloft.net> <CAKwvOdmU+Eh0BF+o4yqSBFRXkokLOzvy-Qni27DcXOSKv5KOtQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmU+Eh0BF+o4yqSBFRXkokLOzvy-Qni27DcXOSKv5KOtQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 5 Aug 2020 10:44:30 -0700
Message-ID: <CAKwvOd=YBL_igN-Z1V9bePdt9+GOqkKq-H4Wg8GBZvBsdOHeOw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2 net] bitfield.h cleanups
To:     David Miller <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 3:37 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Jul 20, 2020 at 4:35 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Nick Desaulniers <ndesaulniers@google.com>
> > Date: Mon, 20 Jul 2020 12:48:38 -0700
> >
> > > Hi David, bumping for review.
> >
> > If it's not active in my networking patchwork you can't just bump your original
> > submission like this.
> >
> > You have to submit your series entirely again.
> >
> > And if it is in patchwork, such "bumping" is %100 unnecessary.  It's
> > in my queue, it is not lost, and I will process it when I have the
> > time.
> >
> > Thank you.
>
> Hi David,
> Sorry, I'm not familiar with your workflow.  By patchwork, are you
> referring to patchwork.ozlabs.org?  If so, I guess filtering on
> Delegate=davem
> (https://patchwork.ozlabs.org/project/netdev/list/?series=&submitter=&state=&q=&archive=&delegate=34)
> is your queue?  I don't see my patches in the above query, but I do
> see my series here:
> https://patchwork.ozlabs.org/project/netdev/list/?series=188486&state=*
> but they're marked "Not Applicable".  What does that mean?

Hi David,
I read through https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-how-often-do-changes-from-these-trees-make-it-to-the-mainline-linus-tree
and noticed http://vger.kernel.org/~davem/net-next.html.  Since the
merge window just opened, it sounds like I'll need to wait 2 weeks for
it to close before resending? Is that correct? Based on:

> IMPORTANT: Do not send new net-next content to netdev during the period during which net-next tree is closed.

Then based on the next section in the doc, it sounds like I was
missing which tree to put the patch in, in the subject? I believe
these patches should target net-next (not net) since they're not
addressing regressions from the most recent cycle.

Do I have all that right?
-- 
Thanks,
~Nick Desaulniers

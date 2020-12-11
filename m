Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD72D6E32
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403757AbgLKCo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 21:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391211AbgLKCos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 21:44:48 -0500
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C00C0613D3;
        Thu, 10 Dec 2020 18:44:08 -0800 (PST)
Received: by mail-ua1-x941.google.com with SMTP id g3so2405245uae.7;
        Thu, 10 Dec 2020 18:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J8P6F/MPRjXhmhfFtWhPhGD5sWaokR/6E1g8IVrlW+s=;
        b=kKDsJfqoP4lCYTd9mGSPprIvcgP8+Ivmik1WhwzOXvRzK+QJd1JrfRexmaQGDW3+tQ
         BYVw6CttsSTYRv3umN2I9VJrd78/somUxDt46XTi8P4BYVZNo4wruJONZ3scaLEPLdbs
         09XgHyf1DE8zUw+xeUadADViNQE5WK9jaMmVKyy+5OwIZ7U2XF0qrq69r/KKvqHU3gie
         ZehdYdZCO5/yI3yxFu5JE3BRY4Zir8n/zgPM9Spy9g0KjZvYeYT1tdBfLqvTmFnvNwfZ
         IfNlU4FzpQ877jyjQKU00wq7Vh2i6ywDgdHI0IMNFtW04z6hQJBR7z2YX52v4PtKwP+q
         jcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J8P6F/MPRjXhmhfFtWhPhGD5sWaokR/6E1g8IVrlW+s=;
        b=Q9vEODlQxxdpni5SYC7VVsPPlPW06ApsIL3ZJZzwRLEZSwuJ7ym3CQNL2TuvX6hN5U
         M47Dqo0VynKsSgtI7CS5t8YErgnUFwoFhuI/2WKO/RLLPj6SlnZw8bB+pAI7GtF5eymW
         qH0LLrVRJe2WG6ZJnsFGkH7jSN23pxxlpDTEHvDE6Sn4srkNaRx647VmRebX33XRoc/G
         RJE9O3FdeZPDuWkcTYh+yzWstkFnQUiwjcSjH9/8JMhhQW5pcHNJR1gpPOXW353C3HqZ
         IcWpS1hXSgsVjhBN386El2IBwBXPh1Jdss28y+O2sHxQ8rstadxXSTG0oNco9XNoILx3
         aI4g==
X-Gm-Message-State: AOAM533mKyMYKr2uVsKxvDSM8+MblSf++TimEkXSg4JGKytbK5+cpxt5
        DnBlZR0u3zSuk+goa1h5mc80nS6KQIah0Q4EFvs=
X-Google-Smtp-Source: ABdhPJwmlbEuvXWwR3Os36WHrzXQXhn7Crjyzf9LXQgzOh3pHwA8UOR7Uw4y5RVnPBlsft7YPHhjdsWa2t4FcYZlXEA=
X-Received: by 2002:ab0:6aa:: with SMTP id g39mr11277392uag.71.1607654647395;
 Thu, 10 Dec 2020 18:44:07 -0800 (PST)
MIME-Version: 1.0
References: <1607592918-14356-1-git-send-email-yejune.deng@gmail.com> <CANn89iKW4cLMssB2zi8kvikddVHMXfQLDr9Gkg768Ou3H5VwiA@mail.gmail.com>
In-Reply-To: <CANn89iKW4cLMssB2zi8kvikddVHMXfQLDr9Gkg768Ou3H5VwiA@mail.gmail.com>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Fri, 11 Dec 2020 10:43:54 +0800
Message-ID: <CABWKuGVvh93zNYky_Lj2Hyenoerm+PBj38ocfYcw0k0_en=7Lg@mail.gmail.com>
Subject: Re: [PATCH] net: core: fix msleep() is not accurate
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does anyone else have a different opinion? If not=EF=BC=8CI will adopt it a=
nd resubmit.

On Thu, Dec 10, 2020 at 6:19 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Dec 10, 2020 at 10:35 AM Yejune Deng <yejune.deng@gmail.com> wrot=
e:
> >
> > See Documentation/timers/timers-howto.rst, msleep() is not
> > for (1ms - 20ms), There is a more advanced API is used.
> >
> > Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> > ---
> >  net/core/dev.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index d33099f..6e83ee03 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6726,9 +6726,9 @@ void napi_disable(struct napi_struct *n)
> >         set_bit(NAPI_STATE_DISABLE, &n->state);
> >
> >         while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
> > -               msleep(1);
> > +               fsleep(1000);
> >         while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
> > -               msleep(1);
> > +               fsleep(1000);
> >
>
> I would prefer explicit usleep_range().
>
> fsleep() is not common in the kernel, I had to go to its definition.
>
> I would argue that we should  use usleep_range(10, 200)  to have an
> opportunity to spend less time in napi_disable() in some cases.

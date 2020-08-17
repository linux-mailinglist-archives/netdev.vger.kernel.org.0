Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA6524786C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHQVAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHQU76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 16:59:58 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7FEC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:59:58 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q14so15755513ilj.8
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9+7ryfewV/sMdvnI5rjR7Ogd1o4iFOm+0RPUvIgqAk=;
        b=gAppyL6YqdbdEsKHuVpdXVrnXQyC4xMCLm6PjysdiEl67T99GrsV2nnJWYVpx+ID7T
         9ZhmVRGONukQmTQ3VDGS1xt8Z4tggeJ8zhiq2YRDvFaNP93EX7Qn/uPT4uUqdbPa/Gre
         fydiPkPy6pc+ba0Q0vhDUHb5JUNd44qVsaau9NSmHzwIqUsi9i1NyyfIsmuAUav+zFRH
         aeLWIZGXFTNCuly24d8+Gkdb8YEYdqOsFwrsVt/YiOu5k21fWVEHjHv+tXfR7PQxnP6f
         kCKO2sHRsfPXHNavNct8kzCMN03bQDaioRZ1J93AO4Vmxw/1T/dx/3ygeYgW+U16aIXB
         3XDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9+7ryfewV/sMdvnI5rjR7Ogd1o4iFOm+0RPUvIgqAk=;
        b=oHOsL4nuJszTbQz6fV+7a0WSLToRh+X13hgwlmZgPaNyWnRHHXR0tT3AwmHL+rFBrb
         AFvPX8WTH0r1fUt7zIv1pr/i6dea7FILAfxHjhPc2KyR8wP7pFawSlJibtw2NYZUwuPJ
         2lH48RNgQNyF8Io3eDl4Da5FBYYi0jnLTB42Dq9fgOin5Jd9stSaLINvh3N0lwNekBXl
         0vh2vypFDBmtS53cjOUB5nRrxHsA4z4EdsRrsTSKFSY+r+f51rBjDuEg9UQxvPaAQSKA
         52675OQwyagz7mPiT+XHSGMKquCsvTEO2QrivohViLRL/8CASemeplGgLNZ1D4UOmkti
         YDzg==
X-Gm-Message-State: AOAM530OAkF2TV55QocvlRGM1bZ0vemdHxqOZvJGZPdII0Mpclt1Ykj3
        G5ncTpddzgKPYkoxQ/wOkehTfCz1KkLTBO3ngTQ=
X-Google-Smtp-Source: ABdhPJxzPElVjQiTfyDbPRNyxFpzWFRwe/udtfWUZmEFJJOe/X26dIZnpBX02ZRk0A0cEqmiDZPMcqiw6as/bdYEtWI=
X-Received: by 2002:a92:9145:: with SMTP id t66mr4354942ild.305.1597697997549;
 Mon, 17 Aug 2020 13:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
 <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
 <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com>
 <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org> <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
 <1b45393f-bc09-d981-03bd-14c4088178ad@infradead.org> <CAM_iQpWOTLKHsJYDsCM3Pd1fsqPxqj8cSP=nL63Dh0esiJ2QfA@mail.gmail.com>
 <98214acb-5e9f-0477-bc97-1f3b2c690f14@infradead.org> <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
 <6d7aa56a-5324-87c9-4150-b73be7e3c0a6@infradead.org>
In-Reply-To: <6d7aa56a-5324-87c9-4150-b73be7e3c0a6@infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 13:59:46 -0700
Message-ID: <CAM_iQpUEjZzW-e=h30KZVvg02ZZMRHZn9JExxgn6E=XyWsjzNQ@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 1:43 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 8/17/20 1:29 PM, Cong Wang wrote:
> > On Mon, Aug 17, 2020 at 12:55 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> >>
> >> TIPC=m and IPV6=m builds just fine.
> >>
> >> Having tipc autoload ipv6 is a different problem. (IMO)
> >>
> >>
> >> This Kconfig entry:
> >>  menuconfig TIPC
> >>         tristate "The TIPC Protocol"
> >>         depends on INET
> >> +       depends on IPV6 || IPV6=n
> >>
> >> says:
> >> If IPV6=n, TIPC can be y/m/n.
> >> If IPV6=y/m, TIPC is limited to whatever IPV6 is set to.
> >
> > Hmm, nowadays we _do_ have IPV6=y on popular distros.
> > So this means TIPC would have to be builtin after this patch??
>
> No, it does not mean that. We can still have IPV6=y and TIPC=m.
>
> Hm, maybe I should have said this instead:
>
>   If IPV6=y/m, TIPC is limited _by_ whatever IPV6 is set to.
>                 (instead of    _to_ )
>
> Does that help any?
>
> The "limited" in Kconfig rules is a "less than or equal to"
> limit, where 'm' < 'y'.

Yeah, this is more clear now. If so, that means all the symbols
we have in ipv6_stub can be gone now, assuming module
dependency is automatically solved when both are modules.

Is this a new Kconfig feature? ipv6_stub was introduced for
VXLAN, at that time I don't remember we have such kind of
Kconfig rules, otherwise it would not be needed.

I also glanced at Documentation/kbuild/kconfig-language.txt,
I do not see such a rule, I guess the doc is not updated.


> > Still sounds harsh, right?
> >
> > At least on my OpenSUSE I have CONFIG_IPV6=y and
> > CONFIG_TIPC=m.
> >
> >> TIPC cannot be =y unless IPV6=y.
> >
> > Interesting, I never correctly understand that "depends on"
> > behavior.
> >
> > But even if it builds, how could TIPC module find and load
> > IPV6 module? Does IPV6 module automatically become its
> > dependency now I think?
>
> Sorry, I don't know about this.

You can check `modinfo tipc` output after compiling both as
modules. (Sorry that I only have CONFIG_MODULES=n here.)

Thanks.

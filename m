Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C790B515A78
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 06:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbiD3EaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 00:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiD3EaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 00:30:05 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C41986C8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 21:26:44 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id m62so8686706vsc.2
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 21:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zappem-net.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+7n9Htsl4dZnTSEtvFT6EWfjkE+SISVaWuljU97PP0=;
        b=W6lf/Q1U3dFSEH+SUKDXdDdRXt0mtzHkxHYVDwgoXf36pLuGatyxmgQXrH3gwyzv4U
         7V2uX+l58hVglhBlUBxqzQsU1mdo9QE4zFlvNuDpBDkesaDQ5lbmlZwIlnUArUX/lBw+
         3am5d3nvWF8MDXOvYoUhls1kSArpe+D9FJUwon8PGucEAUaEVxYE2dkSb2NULi3wmAV7
         bVi5MVG0ccAQBs3HY/tPbkPyemdz/HX+0S2Vq9Po6Oby30Hp3jkNv3ole8ef02aWiphn
         EFik1vOpA1jfW0Ewna+xeECpXtIEgOj0sjGGM02Yrg0aP5iNUzlwVLEZWgUtzGQgdA7W
         Q58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+7n9Htsl4dZnTSEtvFT6EWfjkE+SISVaWuljU97PP0=;
        b=5ghDj5m1VpIXQ4ss6jXNuqrSSblVzUgnTljEbjKDC7XKP5WZzzSFYziUX4UGniMWmY
         z1IWL4QWzI8H73RN3WE/9cUKKUbgFwAX2EtQxeNQ1hCTQ3t1tFDVdHSURhsWH/Fy/zmJ
         f3IU31Eo9laSMQHUkZCoFhEGkyeGMCe1ktNuXzs8Af6zDwilMgHvdwQjLdD43rVcTSK/
         EJz05KdbCQA1C90eBQaemi4kFVy38n7G3SeboyluktwIVkZtk7tdfSV/GZd3vO0GIJgy
         +vWLNN1RIdg5wyiGb+9rOo2dQ+p8OSDTMpYvtow/45TjaAk7UokZA3ZXMtK3JpfkkL8O
         Bhnw==
X-Gm-Message-State: AOAM5318eKNQnzbSdVwtMoQIq44fyJiH6vvteYhhtA6W0qZl6Yog46lo
        sLY/o/eXHWE7YEcWZNDrEIgnDGvJd33oL+CoiOteqcQDrxuMlA==
X-Google-Smtp-Source: ABdhPJxoPczWzXLluGfIllIQVBsOeYBglr1Zp+kD0Nz7jVx0NxdFLAsT4z8EpPyDu9JMjNUhmQaN+bjr04m2kEOlb0w=
X-Received: by 2002:a67:fe17:0:b0:32c:e77e:c3b4 with SMTP id
 l23-20020a67fe17000000b0032ce77ec3b4mr688426vsr.11.1651292803614; Fri, 29 Apr
 2022 21:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <CABCx3R0QbN2anNX5mO1iPGZNgS=wdWr+Rb=bYGwf24o6jxjnaQ@mail.gmail.com>
 <fac8b95ce32c4b57e7ea00596cbf01aaf966c7ef.camel@debian.org>
In-Reply-To: <fac8b95ce32c4b57e7ea00596cbf01aaf966c7ef.camel@debian.org>
From:   Tinkerer One <tinkerer@zappem.net>
Date:   Fri, 29 Apr 2022 21:26:32 -0700
Message-ID: <CABCx3R0qyFjt5KUUdJ+e_RPTyLUz264WXWxQ1ECZznq4Chb4LA@mail.gmail.com>
Subject: Re: Simplify ambient capability dropping in iproute2:ip tool.
To:     Luca Boccassi <bluca@debian.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 2:56 AM Luca Boccassi <bluca@debian.org> wrote:
>
> On Thu, 2022-04-28 at 20:17 -0700, Tinkerer One wrote:
> > Hi,
> >
> > This is expanded from https://github.com/shemminger/iproute2/issues/62
> > which I'm told is not the way to report issues and offer fixes to
> > iproute2 etc.
> >
> > [I'm not subscribed to the netdev list, so please cc: me if you need more info.]
> >
> > The original change that added the drop_cap() code was:
> >
> > https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=ba2fc55b99f8363c80ce36681bc1ec97690b66f5
> >
> > In an attempt to address some user feedback, the code was further
> > complicated by:
> >
> > https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=9b13cc98f5952f62b825461727c8170d37a4037d
> >
> > Another user issue was asked about here (a couple days ago):
> >
> > https://stackoverflow.com/questions/72015197/allow-non-root-user-of-container-to-execute-binaries-that-need-capabilities
> >
> > I looked into what was going on and found that lib/utils.c contains
> > some complicated code that seems to be trying to prevent Ambient
> > capabilities from being inherited except in specific cases
> > (ip/ip.c:main() calls drop_cap() except in the ip vrf exec case.). The
> > code clears all capabilities in order to prevent Ambient capabilities
> > from being available. The following change achieves suppression of
> > Ambient capabilities much more precisely. It also permits ip to not
> > need to be setuid-root or executed under sudo since it can now be
> > optionally empowered by file capabilities:
> >
> > diff --git a/lib/utils.c b/lib/utils.c
> > index 53d31006..681e4aee 100644
> > --- a/lib/utils.c
> > +++ b/lib/utils.c
> > @@ -1555,25 +1555,10 @@ void drop_cap(void)
> >  #ifdef HAVE_LIBCAP
> >         /* don't harmstring root/sudo */
> >         if (getuid() != 0 && geteuid() != 0) {
> > -               cap_t capabilities;
> > -               cap_value_t net_admin = CAP_NET_ADMIN;
> > -               cap_flag_t inheritable = CAP_INHERITABLE;
> > -               cap_flag_value_t is_set;
> > -
> > -               capabilities = cap_get_proc();
> > -               if (!capabilities)
> > -                       exit(EXIT_FAILURE);
> > -               if (cap_get_flag(capabilities, net_admin, inheritable,
> > -                   &is_set) != 0)
> > +               /* prevent any ambient capabilities from being inheritable */
> > +               if (cap_reset_ambient() != 0) {
> >                         exit(EXIT_FAILURE);
> > -               /* apps with ambient caps can fork and call ip */
> > -               if (is_set == CAP_CLEAR) {
> > -                       if (cap_clear(capabilities) != 0)
> > -                               exit(EXIT_FAILURE);
> > -                       if (cap_set_proc(capabilities) != 0)
> > -                               exit(EXIT_FAILURE);
> >                 }
> > -               cap_free(capabilities);
> >         }
> >  #endif
> >  }
>
> The current setup is necessary, as the commit message says:
>
> "Users have reported a regression due to ip now dropping capabilities
> unconditionally.
> zerotier-one VPN and VirtualBox use ambient capabilities in their
> binary and then fork out to ip to set routes and links, and this
> does not work anymore.
>
> As a workaround, do not drop caps if CAP_NET_ADMIN (the most common
> capability used by ip) is set with the INHERITABLE flag.
> Users that want ip vrf exec to work do not need to set INHERITABLE,
> which will then only set when the calling program had privileges to
> give itself the ambient capability."

That doesn't explain why my simplification isn't an improvement.

As I see it, there are 4 different ways 'ip' can get invoked that
could potentially relate to capabilities:

- the uid != 0 && euid !=0 test means the code is perfectly happy to
run via sudo or if the 'ip' program is setuid-root. The setuid-root
way is the workaround used in the stackoverflow post I referenced. In
this case, if you try it with sudo, or via setuid-root you'll find the
'ip' program runs without any Inheritable process capabilities at all.
I'm guessing this is why the code needs that if () { .. } protection
to not "harmstring root/sudo".

- the drop_cap() function isn't even called in the case of 'ip vrf
exec' so in that one case ambient capabilities (or any other form of
capability) are not dropped and ambient capabilities can be passed on
to any invoked child.

- should drop_cap() be called for a non-root user it can inherit
capabilities in one of two ways: via the ambient setup referred to in
that commit message (manually achievable by:

    $ sudo capsh --user=`whoami` --inh=cap_net_admin --addamb=cap_net_admin --
    $ ./ip ...
    $ exit       # needed to escape capsh's ambient setup after the test

), or if the 'ip' program is given a file-inheritable capabilities and
the invoker of 'ip' has the corresponding process-inheritable
capabilities (like this:

    $ sudo setcap cap_net_admin=ie ./ip
    $ sudo capsh --inh=cap_net_admin --user=`whoami` --
    $ ./ip ...
    $ exit      # needed to escape capsh's inheritable setup after the test

).

All three of the above are preserved by my simplification because
cap_reset_ambient() doesn't drop permitted or effective capabilities
from the running program, ip.

The fourth case, the one the upstream code doesn't support (which was
the case the stackoverflow poster cares about) is if the admin sets
permitted+effective file capabilities on their copy of 'ip' (inside
their docker container, or outside such a container for that matter).
In this case, the 'ip' program when run doesn't have any inheritable
capabilities, so in spite of the fact the 'ip' program starts running
with permitted and effective process capabilities (directly obtained
from those file capabilities) of CAP_NET_ADMIN, this particular code
inside drop_cap() causes the program to drop all capabilities and not
work.

What the code I am attempting to simplify does is permits ip to be set
via this fourth method with:

    $ sudo setcap cap_net_admin=ep ip

and it will then, just like the setuid-root case, run with permitted
and effective capabilities - which are the "real capabilities" after
all.

Dropping ambient capabilities with the cap_reset_ambient() call,
preserves the permitted and effective capabilities, but prevents any
process exec'd by 'ip' itself from passing any non-root real
capabilities on to such a child. I was thinking this was why that
capability dropping code was there at all. However, using this
simplification, "sudo setcap cap_net_admin=ep ip" can be used to make
ip work.

Is it really the intention that this fourth capability setup is not be
supported?

Thanks for helping me understand.

>
> Besides, giving setuid to ip itself would be very dangerous, and should
> definitely not be supported. I am not aware of any distribution that
> does it. If there is any, it should be removed. Even for the vrf exec
> case, on Debian/Ubuntu I've set it up so that the caps are not
> configured by default, but require admin action at install time to
> enable, with a clear warning about the possible risks and tradeoffs.
>
> --
> Kind regards,
> Luca Boccassi

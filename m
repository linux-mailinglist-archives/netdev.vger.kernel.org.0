Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12821526F3F
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiENFKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 01:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiENFKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 01:10:18 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D8813DFE
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 22:10:16 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id e144so5133566vke.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 22:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zappem-net.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=am2KApHZvCvnte7d2uFo4dA9WFvK9puOECj/ULVMy50=;
        b=GmiFygQXU+gjLKohNxmOYyTi3fO5NPt3JQzXEFcnX8AZRbYm9aPzvayuRG75fYEVT/
         p28ihmnEefFnhk1KnXRt6iEG5C/oVqIUlZbODiRPPOzwai8jNWXoqVVc1c7wsHmRZey7
         LFSvjNJSEQGBAgZwyaJsvSaSSwZfiNIfeqnuzgYgO+1J7APyhxGX0mZFVh4VBktKQoYF
         RKvsfEUDW5A4vVmicJXdeGtVIpEj2IQQvJ2CBnbEoM9v0ykP0QDMih94bPhyoLBysVdf
         HGjefZi4gpZ3D7+09ibpCLx7NHz7jma41pfusqdVW/wcyeAKd0fYhd4GHTC3KN7vz073
         hrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=am2KApHZvCvnte7d2uFo4dA9WFvK9puOECj/ULVMy50=;
        b=n01wYwqZ6b6KqYTxqL+C8FMHF8T/koTWQyPlEExsSVPhOdBk3ZMMiNw7yoDAKx3Hly
         SZc5bbyebEiMwwSdK2CN+AKQ9pQj2ZEAxMaU7G3qmGc/zjWgRVtXGtpqB6D7MSXos/uP
         GoElTxo5RyGUOoP1kE4SEYEwFoNQgQtfSLcv/Dqx/NKeJ/YjbQ9xjJp5IlFSPmbGM7rW
         YsS+3XQchVnvlFmFT62LpOisTQUA8sJNWnYBBPw3RbyjYWguaxP2Duuyv6xiXr7tY6Zl
         OsuN2ZogY3bvznWsZpfAixnZA3k8Md9BkJNspFUEC0khOh2iDjqm6UG/296ZjPWUEHZH
         LyZw==
X-Gm-Message-State: AOAM530R5b5UG2X7HojvhuI2sTwuYaPOqY9+dVmG5DXnjCCfsNew5XIA
        eXTpQQNP8Bd4hMn/mSBQMEig9s+EHPyD46WTQiV1kd7lrqY=
X-Google-Smtp-Source: ABdhPJxSZajqz/reul0kNezZy6zRnqKmFPbAjVOsPWJOBYlc5GNde7sevc9dsRfCA3EHSg+vwIu4Vff8u8IxNWowsik=
X-Received: by 2002:ac5:ca0b:0:b0:34d:82ac:27cf with SMTP id
 c11-20020ac5ca0b000000b0034d82ac27cfmr3253575vkm.13.1652505015949; Fri, 13
 May 2022 22:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <CABCx3R0QbN2anNX5mO1iPGZNgS=wdWr+Rb=bYGwf24o6jxjnaQ@mail.gmail.com>
 <fac8b95ce32c4b57e7ea00596cbf01aaf966c7ef.camel@debian.org> <CABCx3R0qyFjt5KUUdJ+e_RPTyLUz264WXWxQ1ECZznq4Chb4LA@mail.gmail.com>
In-Reply-To: <CABCx3R0qyFjt5KUUdJ+e_RPTyLUz264WXWxQ1ECZznq4Chb4LA@mail.gmail.com>
From:   Tinkerer One <tinkerer@zappem.net>
Date:   Fri, 13 May 2022 22:10:04 -0700
Message-ID: <CABCx3R3tCEcvnSC5ZvsYh=R0eZ5JMZJT0u-O4pkDmRzwY6hcJQ@mail.gmail.com>
Subject: Re: Simplify ambient capability dropping in iproute2:ip tool.
To:     Luca Boccassi <bluca@debian.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any further thoughts?

Thanks

On Fri, Apr 29, 2022 at 9:26 PM Tinkerer One <tinkerer@zappem.net> wrote:
>
> On Fri, Apr 29, 2022 at 2:56 AM Luca Boccassi <bluca@debian.org> wrote:
> >
> > On Thu, 2022-04-28 at 20:17 -0700, Tinkerer One wrote:
> > > Hi,
> > >
> > > This is expanded from https://github.com/shemminger/iproute2/issues/62
> > > which I'm told is not the way to report issues and offer fixes to
> > > iproute2 etc.
> > >
> > > [I'm not subscribed to the netdev list, so please cc: me if you need more info.]
> > >
> > > The original change that added the drop_cap() code was:
> > >
> > > https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=ba2fc55b99f8363c80ce36681bc1ec97690b66f5
> > >
> > > In an attempt to address some user feedback, the code was further
> > > complicated by:
> > >
> > > https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=9b13cc98f5952f62b825461727c8170d37a4037d
> > >
> > > Another user issue was asked about here (a couple days ago):
> > >
> > > https://stackoverflow.com/questions/72015197/allow-non-root-user-of-container-to-execute-binaries-that-need-capabilities
> > >
> > > I looked into what was going on and found that lib/utils.c contains
> > > some complicated code that seems to be trying to prevent Ambient
> > > capabilities from being inherited except in specific cases
> > > (ip/ip.c:main() calls drop_cap() except in the ip vrf exec case.). The
> > > code clears all capabilities in order to prevent Ambient capabilities
> > > from being available. The following change achieves suppression of
> > > Ambient capabilities much more precisely. It also permits ip to not
> > > need to be setuid-root or executed under sudo since it can now be
> > > optionally empowered by file capabilities:
> > >
> > > diff --git a/lib/utils.c b/lib/utils.c
> > > index 53d31006..681e4aee 100644
> > > --- a/lib/utils.c
> > > +++ b/lib/utils.c
> > > @@ -1555,25 +1555,10 @@ void drop_cap(void)
> > >  #ifdef HAVE_LIBCAP
> > >         /* don't harmstring root/sudo */
> > >         if (getuid() != 0 && geteuid() != 0) {
> > > -               cap_t capabilities;
> > > -               cap_value_t net_admin = CAP_NET_ADMIN;
> > > -               cap_flag_t inheritable = CAP_INHERITABLE;
> > > -               cap_flag_value_t is_set;
> > > -
> > > -               capabilities = cap_get_proc();
> > > -               if (!capabilities)
> > > -                       exit(EXIT_FAILURE);
> > > -               if (cap_get_flag(capabilities, net_admin, inheritable,
> > > -                   &is_set) != 0)
> > > +               /* prevent any ambient capabilities from being inheritable */
> > > +               if (cap_reset_ambient() != 0) {
> > >                         exit(EXIT_FAILURE);
> > > -               /* apps with ambient caps can fork and call ip */
> > > -               if (is_set == CAP_CLEAR) {
> > > -                       if (cap_clear(capabilities) != 0)
> > > -                               exit(EXIT_FAILURE);
> > > -                       if (cap_set_proc(capabilities) != 0)
> > > -                               exit(EXIT_FAILURE);
> > >                 }
> > > -               cap_free(capabilities);
> > >         }
> > >  #endif
> > >  }
> >
> > The current setup is necessary, as the commit message says:
> >
> > "Users have reported a regression due to ip now dropping capabilities
> > unconditionally.
> > zerotier-one VPN and VirtualBox use ambient capabilities in their
> > binary and then fork out to ip to set routes and links, and this
> > does not work anymore.
> >
> > As a workaround, do not drop caps if CAP_NET_ADMIN (the most common
> > capability used by ip) is set with the INHERITABLE flag.
> > Users that want ip vrf exec to work do not need to set INHERITABLE,
> > which will then only set when the calling program had privileges to
> > give itself the ambient capability."
>
> That doesn't explain why my simplification isn't an improvement.
>
> As I see it, there are 4 different ways 'ip' can get invoked that
> could potentially relate to capabilities:
>
> - the uid != 0 && euid !=0 test means the code is perfectly happy to
> run via sudo or if the 'ip' program is setuid-root. The setuid-root
> way is the workaround used in the stackoverflow post I referenced. In
> this case, if you try it with sudo, or via setuid-root you'll find the
> 'ip' program runs without any Inheritable process capabilities at all.
> I'm guessing this is why the code needs that if () { .. } protection
> to not "harmstring root/sudo".
>
> - the drop_cap() function isn't even called in the case of 'ip vrf
> exec' so in that one case ambient capabilities (or any other form of
> capability) are not dropped and ambient capabilities can be passed on
> to any invoked child.
>
> - should drop_cap() be called for a non-root user it can inherit
> capabilities in one of two ways: via the ambient setup referred to in
> that commit message (manually achievable by:
>
>     $ sudo capsh --user=`whoami` --inh=cap_net_admin --addamb=cap_net_admin --
>     $ ./ip ...
>     $ exit       # needed to escape capsh's ambient setup after the test
>
> ), or if the 'ip' program is given a file-inheritable capabilities and
> the invoker of 'ip' has the corresponding process-inheritable
> capabilities (like this:
>
>     $ sudo setcap cap_net_admin=ie ./ip
>     $ sudo capsh --inh=cap_net_admin --user=`whoami` --
>     $ ./ip ...
>     $ exit      # needed to escape capsh's inheritable setup after the test
>
> ).
>
> All three of the above are preserved by my simplification because
> cap_reset_ambient() doesn't drop permitted or effective capabilities
> from the running program, ip.
>
> The fourth case, the one the upstream code doesn't support (which was
> the case the stackoverflow poster cares about) is if the admin sets
> permitted+effective file capabilities on their copy of 'ip' (inside
> their docker container, or outside such a container for that matter).
> In this case, the 'ip' program when run doesn't have any inheritable
> capabilities, so in spite of the fact the 'ip' program starts running
> with permitted and effective process capabilities (directly obtained
> from those file capabilities) of CAP_NET_ADMIN, this particular code
> inside drop_cap() causes the program to drop all capabilities and not
> work.
>
> What the code I am attempting to simplify does is permits ip to be set
> via this fourth method with:
>
>     $ sudo setcap cap_net_admin=ep ip
>
> and it will then, just like the setuid-root case, run with permitted
> and effective capabilities - which are the "real capabilities" after
> all.
>
> Dropping ambient capabilities with the cap_reset_ambient() call,
> preserves the permitted and effective capabilities, but prevents any
> process exec'd by 'ip' itself from passing any non-root real
> capabilities on to such a child. I was thinking this was why that
> capability dropping code was there at all. However, using this
> simplification, "sudo setcap cap_net_admin=ep ip" can be used to make
> ip work.
>
> Is it really the intention that this fourth capability setup is not be
> supported?
>
> Thanks for helping me understand.
>
> >
> > Besides, giving setuid to ip itself would be very dangerous, and should
> > definitely not be supported. I am not aware of any distribution that
> > does it. If there is any, it should be removed. Even for the vrf exec
> > case, on Debian/Ubuntu I've set it up so that the caps are not
> > configured by default, but require admin action at install time to
> > enable, with a clear warning about the possible risks and tradeoffs.
> >
> > --
> > Kind regards,
> > Luca Boccassi

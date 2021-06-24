Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C6E3B3144
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhFXO2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhFXO2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:28:31 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651C2C061756
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 07:26:11 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x21so4905082qtq.9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 07:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eF2C5PKSwNIz1Hk6OjorU3qtEfdzoZ8f5y1ZncpfVq4=;
        b=NtirYk5GcJaWeM5Ci3cQMud1RkVXwj+O2x4lIiPhMHgPAe1npALe96C9De94N/JisN
         EiZG08HB7muGGuwAXT8p3NaNJmhtZ9FlARgfyYa/rq197xk7gMqTCEyE5OvRJ88/5xU2
         h1zzdwG/O0QABXt0U9jvA1bWAcj7bAZuD3+aEr3pmHE0ZhxyzH1XE7kBmF/zy2iq6uka
         eFNPo4G4b1t7u4ZYkjd8YrMH1WGAYRwo7nvV3OIODo5LXlnReW9ULwbDUGxhSuzSCSPa
         Oc/5G8hrdP5XPlxNeclr8GgJxMq/LAFwf6FUg1jtcDwuZGhiRypsFBW1/OC4iC9sbUmo
         uIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eF2C5PKSwNIz1Hk6OjorU3qtEfdzoZ8f5y1ZncpfVq4=;
        b=RaitHBw8v9Y1bumzU/MeVTe+8bEYQRDTRTIlPvCvG409zRSFyQzZLyuAt0lEA/6bvs
         j/idfgv3wZKmR/NLAi4rjDULR3MYgcnDp+AqLedoct88zCp7FnGhBQn71wgLhkIlx23y
         a2jybemms6yW53slLOHVOmCTAV+5h3TFdMbacy+yr12oDltJtoq+uTaGUNJaWWyStfUv
         /M7PMmkdojNLHsAROzoJthvr8jbEZwdlMXHMqWRSEzmM4Iyt/LFR2QE0VfSP6dzYWL4p
         J6Pjh6mNal6cTaXN08IotLh5l7BlJcdp9ryf1L9EP0SR275PaXDm4P8XKotSsDY38P4d
         zKvQ==
X-Gm-Message-State: AOAM531drH9vnXunGNoMvwD4lsmn5FnNkhYhP0NW0TqqBhofOjh1Ai95
        v1qIH4sTeXR0STKy99LsAhY7qVDtGgihMKLV4h73tg==
X-Google-Smtp-Source: ABdhPJxLgFfzXPHK6vcLL7zpNlT3Q675QmDxZBMaTP9WSGvZAsrzJrmYMlnoGrDXO+85MNogvb4YyEBwonpUcghFD0c=
X-Received: by 2002:ac8:57d2:: with SMTP id w18mr5097416qta.306.1624544770432;
 Thu, 24 Jun 2021 07:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210624082911.5d013e8c@canb.auug.org.au> <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
 <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain> <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
 <20210624185430.692d4b60@canb.auug.org.au>
In-Reply-To: <20210624185430.692d4b60@canb.auug.org.au>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 24 Jun 2021 16:25:57 +0200
Message-ID: <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

czw., 24 cze 2021 o 10:54 Stephen Rothwell <sfr@canb.auug.org.au> napisa=C5=
=82(a):
>
> Hi all,
>
> On Thu, 24 Jun 2021 11:43:14 +0530 Naresh Kamboju <naresh.kamboju@linaro.=
org> wrote:
> >
> > On Thu, 24 Jun 2021 at 07:59, Nathan Chancellor <nathan@kernel.org> wro=
te:
> > >
> > > On Thu, Jun 24, 2021 at 12:46:48AM +0200, Marcin Wojtas wrote:
> > > > Hi Stephen,
> > > >
> > > > czw., 24 cze 2021 o 00:29 Stephen Rothwell <sfr@canb.auug.org.au> n=
apisa=C5=82(a):
> > > > >
> > > > > Hi all,
> > > > >
> > > > > Today's linux-next build (x86_64 modules_install) failed like thi=
s:
> > > > >
> > > > > depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: A=
ssertion `is < stack_size' failed.
> >
> > LKFT test farm found this build error.
> >
> > Regressions found on mips:
> >
> >  - build/gcc-9-malta_defconfig
> >  - build/gcc-10-malta_defconfig
> >  - build/gcc-8-malta_defconfig
> >
> > depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> > depmod: ERROR: Found 2 modules in dependency cycles!
> > make[1]: *** [/builds/linux/Makefile:1875: modules_install] Error 1
> >
> > > > Thank you for letting us know. Not sure if related, but I just foun=
d
> > > > out that this code won't compile for the !CONFIG_FWNODE_MDIO. Below
> > > > one-liner fixes it:
> > > >
> > > > --- a/include/linux/fwnode_mdio.h
> > > > +++ b/include/linux/fwnode_mdio.h
> > > > @@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct =
mii_bus *bus,
> > > >          * This way, we don't have to keep compat bits around in dr=
ivers.
> > > >          */
> > > >
> > > > -       return mdiobus_register(mdio);
> > > > +       return mdiobus_register(bus);
> > > >  }
> > > >  #endif
> > > >
> > > > I'm curious if this is the case. Tomorrow I'll resubmit with above,=
 so
> > > > I'd appreciate recheck.
> >
> > This proposed fix did not work.
> >
> > > Reverting all the patches in that series fixes the issue for me.
> >
> > Yes.
> > Reverting all the (6) patches in that series fixed this build problem.
> >
> > git log --oneline | head
> > 3752a7bfe73e Revert "Documentation: ACPI: DSD: describe additional MAC
> > configuration"
> > da53528ed548 Revert "net: mdiobus: Introduce fwnode_mdbiobus_register()=
"
> > 479b72ae8b68 Revert "net/fsl: switch to fwnode_mdiobus_register"
> > 92f85677aff4 Revert "net: mvmdio: add ACPI support"
> > 3d725ff0f271 Revert "net: mvpp2: enable using phylink with ACPI"
> > ffa8c267d44e Revert "net: mvpp2: remove unused 'has_phy' field"
> > d61c8b66c840 Add linux-next specific files for 20210623
>
> So I have reverted the merge of that topic branch from linux-next for
> today.

Just to understand correctly - you reverted merge from the local
branch (I still see the commits on Dave M's net-next/master). I see a
quick solution, but I'm wondering how I should proceed. Submit a
correction patch to the mailing lists against the net-next? Or the
branch is going to be reverted and I should resubmit everything as v4?

Best regards,
Marcin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34BE3B3577
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhFXSRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhFXSRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:17:33 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A50C06175F
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:15:13 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o6so16369124qkh.4
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JzJBuslwkLHPNqksgBWPDVE4rBUHra0e4TjPjK87Jaw=;
        b=TvpxSU8R52dcR8I5BCAd4YsHAgys7Fq+7+bVYG+Mxc0+juKmNgHmf2yD0cfvo5jlx8
         86PFP1VAU0EUC8vCNNKB3R31d8oeVcxlVB1+jJxqIxrfSNkGjBz/rKHeUs8G9G7bpFH8
         oY6cHWgIDxv7+N9TJAkWCBa86Z4qp3DiwXLTZHvISUiUUndQ89JHvMKxPU9iRtDvJPFS
         pCgEWu73WJ5gfPUzKSICCEpYM5FENmx+/AFhy9gWcCzwCozwnnnmuufj1wWrQtyLnfeB
         o4YF3IjJqOs5IahnAq4lwjBYx79vGTNXfLeuMGCaqO27AM9hxslmU4UJog/EQVThkU+D
         FR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JzJBuslwkLHPNqksgBWPDVE4rBUHra0e4TjPjK87Jaw=;
        b=VmS+Ih1V5of8JVhCfF17Smz/25PeeFQoE6jLk+faIacIzH52rfaJj1yAwILDRCdoza
         NK9tmy1VPk6opYu2lOcVb1jeG65woHUUjy9OFrP2hr8YbuDFL38N7jy8XbqBOrilEqor
         WE/lj52QdW3ZQSQwrcmh85ctAJTfcnIEVSgFf1nWs0RFYCkRhb8FyQvsHLQiqSxjFhkk
         Dw8yVi2Ta+JZ4yRrl0BDR+xby0KGK3Kmm823H6ftswYYTqG1YM6Dgmzo8PdfGypEm0zB
         7iQ8dl/iuTcKR1ShrICaiMyh2+QM+uZntOfjVUoy5vKFboja3LV1JTgmxS5H0d6kyyNZ
         jRFw==
X-Gm-Message-State: AOAM532vh59SdYQBZuMQCuJwg0ZHPFq5sDzqNxiZoPaV2YvwcVrG5t53
        YOep70olUZL4vW8SFzJkGo4VlqlnYz3s7oaCcz0m7w==
X-Google-Smtp-Source: ABdhPJyPU3hpHd0oPNGuZHqtn+F2AjfqYyMNiVUhdShXNjjwWen/DvCI34a6HtIOXfMHSt4K7IKLbtNjyrWPUqaeSPU=
X-Received: by 2002:a05:620a:2230:: with SMTP id n16mr7036857qkh.155.1624558512954;
 Thu, 24 Jun 2021 11:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210624082911.5d013e8c@canb.auug.org.au> <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
 <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain> <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
 <20210624185430.692d4b60@canb.auug.org.au> <CAPv3WKf6HguRC_2ckau99d4iWG-FV71kn8wiX9r5wuK335EEFw@mail.gmail.com>
 <3d6ea68a-9654-6def-9533-56640ceae69f@kernel.org>
In-Reply-To: <3d6ea68a-9654-6def-9533-56640ceae69f@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 24 Jun 2021 20:15:00 +0200
Message-ID: <CAPv3WKdjE5ywVFB+94invSLg=jG5JHBdvLQLKDTPq13+8PjqmA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David & Jakub,

czw., 24 cze 2021 o 18:40 Nathan Chancellor <nathan@kernel.org> napisa=C5=
=82(a):
>
> Hi Marcin,
>
> On 6/24/2021 7:25 AM, Marcin Wojtas wrote:
> > Hi Stephen,
> >
> > czw., 24 cze 2021 o 10:54 Stephen Rothwell <sfr@canb.auug.org.au> napis=
a=C5=82(a):
> >>
> >> Hi all,
> >>
> >> On Thu, 24 Jun 2021 11:43:14 +0530 Naresh Kamboju <naresh.kamboju@lina=
ro.org> wrote:
> >>>
> >>> On Thu, 24 Jun 2021 at 07:59, Nathan Chancellor <nathan@kernel.org> w=
rote:
> >>>>
> >>>> On Thu, Jun 24, 2021 at 12:46:48AM +0200, Marcin Wojtas wrote:
> >>>>> Hi Stephen,
> >>>>>
> >>>>> czw., 24 cze 2021 o 00:29 Stephen Rothwell <sfr@canb.auug.org.au> n=
apisa=C5=82(a):
> >>>>>>
> >>>>>> Hi all,
> >>>>>>
> >>>>>> Today's linux-next build (x86_64 modules_install) failed like this=
:
> >>>>>>
> >>>>>> depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: As=
sertion `is < stack_size' failed.
> >>>
> >>> LKFT test farm found this build error.
> >>>
> >>> Regressions found on mips:
> >>>
> >>>   - build/gcc-9-malta_defconfig
> >>>   - build/gcc-10-malta_defconfig
> >>>   - build/gcc-8-malta_defconfig
> >>>
> >>> depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> >>> depmod: ERROR: Found 2 modules in dependency cycles!
> >>> make[1]: *** [/builds/linux/Makefile:1875: modules_install] Error 1
> >>>
> >>>>> Thank you for letting us know. Not sure if related, but I just foun=
d
> >>>>> out that this code won't compile for the !CONFIG_FWNODE_MDIO. Below
> >>>>> one-liner fixes it:
> >>>>>
> >>>>> --- a/include/linux/fwnode_mdio.h
> >>>>> +++ b/include/linux/fwnode_mdio.h
> >>>>> @@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct =
mii_bus *bus,
> >>>>>           * This way, we don't have to keep compat bits around in d=
rivers.
> >>>>>           */
> >>>>>
> >>>>> -       return mdiobus_register(mdio);
> >>>>> +       return mdiobus_register(bus);
> >>>>>   }
> >>>>>   #endif
> >>>>>
> >>>>> I'm curious if this is the case. Tomorrow I'll resubmit with above,=
 so
> >>>>> I'd appreciate recheck.
> >>>
> >>> This proposed fix did not work.
> >>>
> >>>> Reverting all the patches in that series fixes the issue for me.
> >>>
> >>> Yes.
> >>> Reverting all the (6) patches in that series fixed this build problem=
.
> >>>
> >>> git log --oneline | head
> >>> 3752a7bfe73e Revert "Documentation: ACPI: DSD: describe additional MA=
C
> >>> configuration"
> >>> da53528ed548 Revert "net: mdiobus: Introduce fwnode_mdbiobus_register=
()"
> >>> 479b72ae8b68 Revert "net/fsl: switch to fwnode_mdiobus_register"
> >>> 92f85677aff4 Revert "net: mvmdio: add ACPI support"
> >>> 3d725ff0f271 Revert "net: mvpp2: enable using phylink with ACPI"
> >>> ffa8c267d44e Revert "net: mvpp2: remove unused 'has_phy' field"
> >>> d61c8b66c840 Add linux-next specific files for 20210623
> >>
> >> So I have reverted the merge of that topic branch from linux-next for
> >> today.
> >
> > Just to understand correctly - you reverted merge from the local
> > branch (I still see the commits on Dave M's net-next/master). I see a
> > quick solution, but I'm wondering how I should proceed. Submit a
> > correction patch to the mailing lists against the net-next? Or the
> > branch is going to be reverted and I should resubmit everything as v4?
>
> As far as I am aware, net and net-next are not rebased so you would need
> to submit a fixup patch against the current net-next with a proper
> Fixes: tag.
>

TL;DR, we need to get rid of a helper routine (introduced so that to
address review comments of v1), as it causes a depmod cycles when
fwnode_/of_/acpi_mdio are built as modules.
It can be done twofold:
a. 3 commits, i.e:
  Revert "net: mdiobus: Introduce fwnode_mdbiobus_register()"
  Revert "net/fsl: switch to fwnode_mdiobus_register"
  net: mvmdio: resign from fwnode_mdiobus_register
b. Same diff but squashed.

Please let me know your preference, so that I can do it properly up front.

Thanks,
Marcin

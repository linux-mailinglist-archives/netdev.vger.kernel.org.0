Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC1D2B1C77
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 14:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgKMNut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 08:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbgKMNuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 08:50:35 -0500
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB51022265
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605275432;
        bh=D2NtaOuQKs5g2i+E2uLRxTS+4eNL0/n1mwzGDMn/RzU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2f2W/iX2m4djb8sffda4EKZ2Gi+B3coDjXWeZufGj1uPFyTQSfzR4cwE8eldP0sjv
         QKA6oH++1XN2jQz6J/c6/zFBu3qBtTOfBzxcc3X6wT1WDI06zM0S/CNaUq9IQ1lDbu
         z/FK58Zp3F4IUnLM58mxIJUHM6wBZS+0lfNFa6H8=
Received: by mail-ot1-f53.google.com with SMTP id n89so8963804otn.3
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 05:50:31 -0800 (PST)
X-Gm-Message-State: AOAM533Ruc3EcFtcfGGxlxacZf0rTMxtvCm1M4Rl24SHbGNT8S8TB5iR
        0aq1u+FL90AA1QozXmP5HsRpb7nSgdt7N4TTXg8=
X-Google-Smtp-Source: ABdhPJwG++BdEpLsCxWmDhVHOS+32Df0ftgsvv5C/7W0eZNs25ymSpWdm1vc1sMyUrIhNdd8lnGxZIOB5x5/tTGHOeM=
X-Received: by 2002:a9d:65d5:: with SMTP id z21mr1447852oth.251.1605275431275;
 Fri, 13 Nov 2020 05:50:31 -0800 (PST)
MIME-Version: 1.0
References: <20201017230226.GV456889@lunn.ch> <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home> <2697795.ZkNf1YqPoC@kista>
In-Reply-To: <2697795.ZkNf1YqPoC@kista>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 13 Nov 2020 14:50:14 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
Message-ID: <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 6:28 PM Jernej =C5=A0krabec <jernej.skrabec@gmail.co=
m> wrote:
> Dne =C4=8Detrtek, 29. oktober 2020 ob 15:46:44 CET je Ilias Apalodimas na=
pisal(a):
> > On Thu, Oct 29, 2020 at 03:39:34PM +0100, Andrew Lunn wrote:
> > > > What about reverting the realtek PHY commit from stable?
> > > > As Ard said it doesn't really fix anything (usage wise) and causes =
a
> bunch of
> > > > problems.
> > > >
> > > > If I understand correctly we have 3 options:
> > > > 1. 'Hack' the  drivers in stable to fix it (and most of those hacks=
 will
> take
> > > >    a long time to remove)
> > > > 2. Update DTE of all affected devices, backport it to stable and fo=
rce
> users to
> > > > update
> > > > 3. Revert the PHY commit
> > > >
> > > > imho [3] is the least painful solution.

There is also the option of patching the dtb in memory while booting one
of the affected machines.

> > > The PHY commit is correct, in that it fixes a bug. So i don't want to
> > > remove it.
> >
> > Yea I meant revert the commit from were ever it was backported, not on
> current
> > upstream. I agree it's correct from a coding point of view, but it neve=
r
> > actually fixes anything functionality wise of the affected platforms.
>
> Sadly, there is one board - Pine64 Plus - where HW settings are wrong and=
 it
> actually needs SW override. Until this Realtek PHY driver fix was merged,=
 it
> was unclear what magic value provided by Realtek to board manufacturer do=
es.
>
> Reference:
> https://lore.kernel.org/netdev/20191001082912.12905-3-icenowy@aosc.io/

I have merged the fixes from the allwinner tree now, but I still think we
need something better than this, as the current state breaks any existing
dtb file that has the incorrect values, and this really should not have bee=
n
considered for backporting to stable kernels.

       Arnd

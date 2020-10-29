Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163629EE92
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgJ2OnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgJ2OnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 10:43:05 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A4520732
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603982581;
        bh=tZ+4+v0KqDAMowKNWXKHIG7P39rC71mvzzlBfVot6ic=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=S2mMHnc13xr5mlEXVYqb4ozb7IM/ZVWBVQ+JC5xMnCxqVSl8qSSoEsqrk4QfuO981
         Tfjsqjbx8CtMi3Jv2Wv3vG59h08zTzSf6r97reZBA1uUCYTnJYb/rqKTzbXEYR/ERz
         Om3AY7dI5EI9gkCnmxHa32CJaZzsOXB4xR/OYxUc=
Received: by mail-ot1-f49.google.com with SMTP id h62so2438088oth.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:43:01 -0700 (PDT)
X-Gm-Message-State: AOAM533z0PFI5VA3MyYLH6KEAYos/REcLWzC4+PctlgQkBpKlXESOnxc
        uAWouTNYAKYpuhtxtTwtS4NK+PYY27HySxs5moM=
X-Google-Smtp-Source: ABdhPJwjd8acJdg8eIzmB0rAC4KOI2z9c2xyVVE5PkSvccxr+MKo0M9dTGsA9KqIiccZ0D/fwt2+9ricaoz8j5khkOc=
X-Received: by 2002:a05:6830:1f13:: with SMTP id u19mr3413662otg.108.1603982580292;
 Thu, 29 Oct 2020 07:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch> <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch> <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch> <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
 <20201025144258.GE792004@lunn.ch> <20201029142100.GA70245@apalos.home> <20201029143934.GO878328@lunn.ch>
In-Reply-To: <20201029143934.GO878328@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 29 Oct 2020 15:42:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHR0TmMacVt+YR1+9kQsoOk2GAXUmvYAF7ns=+yDVJAsg@mail.gmail.com>
Message-ID: <CAMj1kXHR0TmMacVt+YR1+9kQsoOk2GAXUmvYAF7ns=+yDVJAsg@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 at 15:39, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > What about reverting the realtek PHY commit from stable?
> > As Ard said it doesn't really fix anything (usage wise) and causes a bunch of
> > problems.
> >
> > If I understand correctly we have 3 options:
> > 1. 'Hack' the  drivers in stable to fix it (and most of those hacks will take
> >    a long time to remove)
> > 2. Update DTE of all affected devices, backport it to stable and force users to
> > update
> > 3. Revert the PHY commit
> >
> > imho [3] is the least painful solution.
>
> The PHY commit is correct, in that it fixes a bug. So i don't want to
> remove it.
>
> Backporting it to stable is what is causing most of the issues today,
> combined with a number of broken DT descriptions. So i would be happy
> for stable to get a patch which looks at the strapping, sees ID is
> enabled via strapping, warns the DT blob is FUBAR, and then ignores
> the requested PHY-mode. That gives developers time to fix their broken
> DT.
>

IIRC there is no public documentation for this PHY, right? So most
people that are affected by this are not actually able to implement
this workaround, even if they wanted to.

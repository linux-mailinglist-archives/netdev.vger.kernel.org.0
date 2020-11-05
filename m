Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5F2A84D1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbgKERZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKERZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 12:25:49 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8300FC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 09:25:48 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id o18so2384818edq.4
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 09:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G6KLYczBmQDCDwdwwvxjBSfM0Meh9BzTOZDXrvVlsRE=;
        b=YSVyP1zq/N6lC1ZvERYEqaj5tavK1jkeRJJ6aia9dTgteA9Di/OjmfbdDl0oKgTKKv
         WdysMhCO0n7bbcm5Lv7BWm5Nwhp1AppZvJe6IcLrhleAZje7IqcfxnN5LcthSQY6n+yL
         /TaCY1bLvErKZF2rUqa4RBq3PwiVvuyVNU/RreBE6fI9zuzsrzcbQKGO0u+gtq5Ytv4x
         9qu2++Ax/tYhydtLH53P30dGnAGkw0vj1cTNc4a9pXefNOVo3B+U/7fW5o/QHUnjfkjF
         VC+SXuadkwQF63JhZM7G8hRQjd2evngzdH7l7gqCxPBks1iXbUAxo9loGdt1fculChMs
         p95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6KLYczBmQDCDwdwwvxjBSfM0Meh9BzTOZDXrvVlsRE=;
        b=jIIDTDSVT86bdn4veCickZY0lxo8FeJbbO1Psa1YA524PwmHJMoCejP++agHqfFXA0
         XB7y2+Q62Jyk/tLaY+Cbs2oyRBDZpTCk52NgwR+B8xt2iDjxcVwuEvKDGlvBKFnw+0i1
         fWHdpY4KESRBIeSaQmpVUc9ZxO+NJuQ2BvyB9UMk/lHaS8JydMH4z7An5AxB8j0AhTke
         YA+UbO9u/iRTqqlgec+Lg7RfNdkABwAnBi2C9KI69luJWiEQRlBC0LWYVTXjOx1xIjID
         epIjpkGqxKOcmJ5TYE5NjXjV16OkZyAFN6TS9FcMvmcYKuc92mce53nscVrwYDpaOlNp
         /VrQ==
X-Gm-Message-State: AOAM5311OoiXgHmcrOfT4l6vcs0GPH5wHHegIg6mi3Q8IfYZSZNjxRQK
        csuqxrQ0d5Yi98GoYCOOJjk=
X-Google-Smtp-Source: ABdhPJyiC4NgYUzaB1RK3K7gTGY7/SYiTr8mM841svXuKVKH/cmljBJ9i+be4sys8y8h8igKxnP5mg==
X-Received: by 2002:a50:d615:: with SMTP id x21mr3843207edi.200.1604597147288;
        Thu, 05 Nov 2020 09:25:47 -0800 (PST)
Received: from kista.localnet (cpe1-5-97.cable.triera.net. [213.161.5.97])
        by smtp.gmail.com with ESMTPSA id k4sm1345393edq.73.2020.11.05.09.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 09:25:45 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
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
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
Date:   Thu, 05 Nov 2020 18:31:28 +0100
Message-ID: <2697795.ZkNf1YqPoC@kista>
In-Reply-To: <20201029144644.GA70799@apalos.home>
References: <20201017230226.GV456889@lunn.ch> <20201029143934.GO878328@lunn.ch> <20201029144644.GA70799@apalos.home>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Dne =C4=8Detrtek, 29. oktober 2020 ob 15:46:44 CET je Ilias Apalodimas napi=
sal(a):
> On Thu, Oct 29, 2020 at 03:39:34PM +0100, Andrew Lunn wrote:
> > > What about reverting the realtek PHY commit from stable?
> > > As Ard said it doesn't really fix anything (usage wise) and causes a=
=20
bunch of
> > > problems.
> > >=20
> > > If I understand correctly we have 3 options:
> > > 1. 'Hack' the  drivers in stable to fix it (and most of those hacks w=
ill=20
take=20
> > >    a long time to remove)
> > > 2. Update DTE of all affected devices, backport it to stable and forc=
e=20
users to
> > > update
> > > 3. Revert the PHY commit
> > >=20
> > > imho [3] is the least painful solution.
> >=20
> > The PHY commit is correct, in that it fixes a bug. So i don't want to
> > remove it.
>=20
> Yea I meant revert the commit from were ever it was backported, not on=20
current=20
> upstream. I agree it's correct from a coding point of view, but it never=
=20
> actually fixes anything functionality wise of the affected platforms.=20

Sadly, there is one board - Pine64 Plus - where HW settings are wrong and i=
t=20
actually needs SW override. Until this Realtek PHY driver fix was merged, i=
t=20
was unclear what magic value provided by Realtek to board manufacturer does.

Reference:
https://lore.kernel.org/netdev/20191001082912.12905-3-icenowy@aosc.io/

Best regards,
Jernej

> On the contrary, it breaks platforms without warning.
>=20
> >=20
> > Backporting it to stable is what is causing most of the issues today,
> > combined with a number of broken DT descriptions. So i would be happy
> > for stable to get a patch which looks at the strapping, sees ID is
> > enabled via strapping, warns the DT blob is FUBAR, and then ignores
> > the requested PHY-mode. That gives developers time to fix their broken
> > DT.
>=20
> (Ard replied on this while I was typing)
>=20
> >=20
> > 	  Andrew
>=20
> Cheers
> /Ilias
>=20
>=20



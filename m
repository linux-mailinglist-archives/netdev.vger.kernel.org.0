Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4411307BBF
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhA1RGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232885AbhA1RDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 12:03:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4070464E18
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853371;
        bh=gyyjNM6/jEterH2D5KPusoHhhsSWtGwLqn54TAHjYDk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gTnX5v60Iby64QyBgAegPNJ9+bOn51SK3co0flWvFZbxOvGjs/viWth5mBaD6Ulem
         AXVLr9hJ6ZFM7E4c5/2tV55iHnbsHM765UlTJubiDG2Kb2P15V3GOBKePlI3hgH+jH
         Pnm4J5IOj4MwuXADgfIiIWz5qXRmPd6GcwcgUSi9lo7iypaAZb80+UVZkDDj8hR1rO
         Y0nvkzZl18HNti/0dAbggAtkeYv/GSQnJcc6FLay3Gvst+WBnNkp1jzavNTKDxQp+c
         2D9ag0U4mm0OAEYVQwwRmIk2qYiMYbTTG5AJwSrd72zHvsJZsfGTo94MlDkEsuHA8R
         mw60V8d1OpH/w==
Received: by mail-ot1-f41.google.com with SMTP id d7so5820433otf.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 09:02:51 -0800 (PST)
X-Gm-Message-State: AOAM5321dPN+CWLbyOlrVekSf96XsOydf4k54sz4Qh1FyQmlRPr2D/Cv
        3JulRxdlvNdIkuck02frptbmTmCze2WKipvVJCI=
X-Google-Smtp-Source: ABdhPJwTIYssdFoEOM7eEAyYtwPH8SZnhvACPTcSNhD/jzCgL9/mpeJ9CKZB1Uc7vO3AFYw6TreKez3lAJEyZ30vKbc=
X-Received: by 2002:a9d:741a:: with SMTP id n26mr266255otk.210.1611853370259;
 Thu, 28 Jan 2021 09:02:50 -0800 (PST)
MIME-Version: 1.0
References: <20210128163338.22665-1-kurt@linutronix.de> <20210128163724.q7d2j57phwbmbh7w@skbuf>
In-Reply-To: <20210128163724.q7d2j57phwbmbh7w@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 28 Jan 2021 18:02:33 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2xpYcnzJiyWUBic34M1G_R3c_VOqjNkh0F5x9DNkhQ2g@mail.gmail.com>
Message-ID: <CAK8P3a2xpYcnzJiyWUBic34M1G_R3c_VOqjNkh0F5x9DNkhQ2g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 5:37 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 05:33:38PM +0100, Kurt Kanzenbach wrote:
> > Add missing dependency to TAPRIO to avoid build failures such as:
> >
> > |ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> > |ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> >
> > Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> Note that for sja1105, Arnd solved it this way. I am still not sure why.
>
> commit 5d294fc483405de9c0913ab744a31e6fa7cb0f40
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Fri Oct 25 09:26:35 2019 +0200
>
>     net: dsa: sja1105: improve NET_DSA_SJA1105_TAS dependency
>
>     An earlier bugfix introduced a dependency on CONFIG_NET_SCH_TAPRIO,
>     but this missed the case of NET_SCH_TAPRIO=m and NET_DSA_SJA1105=y,
>     which still causes a link error:
>

As I described in this commit, the problem here was that NET_DSA_SJA1105_TAS
is a 'bool' symbol with a dependency on a 'tristate', so you have to prevent
the option from getting enabled when it's part of a driver that gets built into
the kernel but the dependnecy is in a loadable module.

NET_DSA_HIRSCHMANN_HELLCREEK on the other hand is a 'tristate'
symbol itself, so the dependency takes care of it: you cannot set it to =y
when its dependency is =m.

         Arnd

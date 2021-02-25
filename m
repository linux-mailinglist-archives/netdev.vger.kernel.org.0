Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB53252A1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhBYPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233007AbhBYPoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 10:44:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B97864F1A;
        Thu, 25 Feb 2021 15:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614267797;
        bh=G8l3bZzpQKWdq/8HOkPtO+eDiTgygJ119U3fIxDi1vw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Dl5qQc0/QvST8TTSm9HZGTgDNhYqVrHHvdJTfPmhpfe/m6jPoDmonkiuikGGWVTzI
         zkObnC2tgc5J23DrWY2ILtSZJHZUi5eShfWEmvyIWw+unxffwT5Gucwg2PqCPyTYsN
         ySMAwdMdMGzvbitfiYkp3NA0B6fkdp24+rI13+NyadkwsJF4HXgH8xBIqmG/AKGPCA
         RKTUKECvVR2NMugWboiXrKXy23vjs8qoJB5sxz/i1XYyJUt6oJ1LAetibm2k8bnD/S
         uemLMdSx/Oj1RJCBJCqcA6NLWrINRB0Ael9hk/Ka5IkdJQs5RAZa7bng27YLRj0Fuk
         HEtny6NAWX14Q==
Received: by mail-ot1-f43.google.com with SMTP id s3so6073188otg.5;
        Thu, 25 Feb 2021 07:43:17 -0800 (PST)
X-Gm-Message-State: AOAM531oPWnEaElnmsjjKYl8Yrr9MTSRkF7QzAsTxSTWNd41GF3xr7rB
        LUndmBW46atltPceQRtXK6rJWYrzFQtV63aD4+8=
X-Google-Smtp-Source: ABdhPJy+ZUxf9o96g3cbdfc3BogkVmXsEengjnTbrzhUkL0Cmrc4xjOm8EW7vW3365FI159lULO0v0SjNdvamoGZQl4=
X-Received: by 2002:a9d:7f11:: with SMTP id j17mr2861108otq.251.1614267796208;
 Thu, 25 Feb 2021 07:43:16 -0800 (PST)
MIME-Version: 1.0
References: <20210225143910.3964364-1-arnd@kernel.org> <20210225143910.3964364-2-arnd@kernel.org>
 <20210225144341.xgm65mqxuijoxplv@skbuf> <CAK8P3a0W3_SvWyvWZnMU=QoqCDe5btL3O7PHUX8EnZVbifA4Fg@mail.gmail.com>
 <CAK8P3a1gQgtWznnqKDdJJK2Vxf25Yb_Q09tX0UvcfopKN+x0jw@mail.gmail.com> <20210225150715.2udnpgu3rs6v72wg@skbuf>
In-Reply-To: <20210225150715.2udnpgu3rs6v72wg@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Feb 2021 16:43:00 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1SeJNOs6G2dGZAP0FwfJRfhgv9UZZssZtLWefpOBCHPQ@mail.gmail.com>
Message-ID: <CAK8P3a1SeJNOs6G2dGZAP0FwfJRfhgv9UZZssZtLWefpOBCHPQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 4:07 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Feb 25, 2021 at 03:49:08PM +0100, Arnd Bergmann wrote:
> > On Thu, Feb 25, 2021 at 3:47 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > > On Thu, Feb 25, 2021 at 3:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > On Thu, Feb 25, 2021 at 03:38:32PM +0100, Arnd Bergmann wrote:
> > > > > From: Arnd Bergmann <arnd@arndb.de>
> > > > >
> > > > > When the ocelot driver code is in a library, the dsa tag
> >
> > I see the problem now, I should have written 'loadable module', not 'library'.
> > Let me know if I should resend with a fixed changelog text.
>
> Ah, ok, things clicked into place now that you said 'module'.
> So basically, your patch is the standard Kconfig incantation for 'if the
> ocelot switch lib is built as module, build the tagger as module too',
> plus some extra handling to allow NET_DSA_TAG_OCELOT_8021Q to still be y
> or m when COMPILE_TEST is enabled, but it will be compiled in a
> reduced-functionality mode, without MSCC_OCELOT_SWITCH_LIB, therefore
> without PTP.
>
> Do I get things right? Sorry, Kconfig is a very strange language.

Yes, that's basically correct. I tried to express it in Kconfig the way
I would explain it in English, which means it there are two options:

a) If MSCC_OCELOT_SWITCH_LIB is enabled (y or m) there is
    a direct dependency, so NET_DSA_TAG_OCELOT_8021Q cannot
    be built-in if MSCC_OCELOT_SWITCH_LIB=m
b) When compile-testing *and* MSCC_OCELOT_SWITCH_LIB is fully
    disabled, NET_DSA_TAG_OCELOT_8021Q can be anything (y/m/n)

As a side-effect, this also means that if we are not compile-testing
and MSCC_OCELOT_SWITCH_LIB is disabled, the option is
hdden.

         Arnd.

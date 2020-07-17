Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C1D223328
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 07:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgGQF4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 01:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgGQF4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 01:56:35 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0A8C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 22:56:34 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id p25so4278180vsg.4
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 22:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YT5ulD1C62iHSzwFmUXuInmgpJHHcpJ4tjpnxfV16As=;
        b=eRZeiVV1lS2kCMbllion0MY6bmQYZhTvHLOQz20eJJASEncRes0+isxAzZYt5Aniy+
         08ftQLFEf122B+esCMu1z4Kn1EKJU4AleMkKeqEh8dOE68TG6UhBI/bbCRk4ibJut3Go
         lufP4mMDQ0xYbcim7COReW1jh4pOXO1QAZjBnKTGPPQq3Oyz3ODFk113zfH3MYect2RI
         3bfCUn16/Mn8Q6k1LNTpL77e9HlMAQ1KuAYEKn33PnW6cIG1LiTfaIJQtkFiv0CiCC+o
         vc5aR+ewvmkOfDmvZLe+C5XLhuBuFmY77FzjXuY5bmXwkUKMilGGV28hnjvZP6da9QRO
         TMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YT5ulD1C62iHSzwFmUXuInmgpJHHcpJ4tjpnxfV16As=;
        b=jOfB3c45XYYe1vjRf6gyjtu4FeXUl/+hsVDp04pROHwUhpWDDSCP2Bd8cTooynTb+F
         /DBLTrSc4EPGFy/T2icA+DkSVnfveedMOfnQB73e1SW9sgLBVxNIaEDD10ZG5j5DKlV2
         87PhayfPPFyfm/5h2xjX2J432/zCMmb0iCIM9B0Z0oOsYa5FRbr6mxgw+7CeLCdJptUt
         9kuSoSLjtOL9ut7uzOkzoyaOi7FKIqjaV028zs8+9YdpAyPQxV1+4ggztFuLQpmZlasz
         ciHtF/rT8orv1x7cC/bk3fCH/kEIHDcvk0EnbNtgnSTMjfVM2eYpPFqym1K4YY8Dc/dF
         JhHA==
X-Gm-Message-State: AOAM5331S7/U+N0Ao2SGKoDsVBP/GgGHCsGgCnQ+WrhQce4EqeA3yPPo
        j5ksV2TpfFGeS5Vc7gxXLMUw5sf9wFZskEBSEnk=
X-Google-Smtp-Source: ABdhPJyOsA3Wjjn5vI64auxMKgEM51fxhQwzIntkzX3ZDYcwZ9KF0aXiHYMR2geetqyIH++QekKsq3KSOsGwHN7LiLA=
X-Received: by 2002:a05:6102:3188:: with SMTP id c8mr6327409vsh.61.1594965393976;
 Thu, 16 Jul 2020 22:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch> <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com> <20200712132554.GS1551@shell.armlinux.org.uk>
In-Reply-To: <20200712132554.GS1551@shell.armlinux.org.uk>
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Fri, 17 Jul 2020 05:56:22 +0000
Message-ID: <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 at 13:26, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> If you have machine A with address 192.168.2.1/24 on lan1 and machine B
> with address 192.168.2.2/24 on lan2, then they should be able to ping
> each other - the packet flow will be through the DSA switch without
> involving the CPU.

I can confirm that bridging the lan ports and connecting two physical
machines does allow me to ping between the two machines, with and
without the commit reverted.

> If it is a port issue, that should help pinpoint it - if it's a problem
> with the CPU port configuration, then ethtool can't read those registers
> (and the only way to get them is to apply some debugfs patch that was
> refused from being merged into mainline.)

It looks like this is the next step then. Do you have a link to the
patch? I'll give it a go. What outputs would be useful for me to
provide?

> > I'm now less confident about my git bisect...
> That seems really weird!

And ended up being unrelated to the current issue; I had other things
connected to the switch while I was testing it and I think STP was
getting involved. Either way, I've isolated it now and have confirmed
that 5.8-rc4 with that one commit reverted is working perfectly. Sorry
for the confusion.

Martin

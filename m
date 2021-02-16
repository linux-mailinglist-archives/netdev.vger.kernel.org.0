Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2185931D2E0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhBPW6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhBPW6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:58:06 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9110C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 14:57:25 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 80so1446948oty.2
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 14:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1V742lm2hRPBxq6o+nYhxza92vFAFUuIzcwbXv4ZQP0=;
        b=f69CBNh/sIHaMHnoXAu/YhZF8BI3BRzovMeplyyzhZNfJzSgdZszh39nehhEaflQko
         8V+mQB8GG1IvXHHn8JPVeftoeosdskkCp684bfAb2oTcmdrpU5qLkyg15FMd6VOhm5ju
         vbwZEiu1GUgiIAIVcJaWwM786kTozsdb/z1M2br6wnNT/sEDq/+NvjE6HXwz0FdEyJpM
         TfXS7XbBp8lGNA/p2CYZAyB+ZabVweHzIqx0NF4fE4kA1REFhx4e5/z8oXvndrYToGkA
         wqowjPPe9P8LKW637gxLorcejTysV1QQ/BtOtQdTIVye2ZrwCpDtR0Wt+aq852I/e219
         pqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1V742lm2hRPBxq6o+nYhxza92vFAFUuIzcwbXv4ZQP0=;
        b=FJJRBogo3D869EEyRDm8xnSa/qN7omnr78nZsDQT9ROznT7Pt3Vl9m1xygJbDnS/lE
         stGQ9pgAFSghgd4DeLJf8Rl3VNayabto/Ib/Pvp7ob7m8WYeLWpOA4+7YlDU4uzMGQr0
         HHUchb+jmbnGurnkS1e/8COse98Gx7VwWjIqijcNiPblCxJOc9cx8m/QT/+Eqz3RRUHA
         jFU3XEWL7JCqjKyNic+pBPvBbK79Qn00mGyiphLIO5z9eaSYwTfzFC1fYV0udGJVaAn0
         fNH26kgj3gZsccTiL5zrg9ZPtEZNoYF3MAX82KylU9p4MtDsxf7LVGfGBBnz3pEIPscs
         akcw==
X-Gm-Message-State: AOAM532HN3eW58BhEDVvVdTPdp3K2DkLMdu6X0AKQ25894ZyWlDIRUsm
        WILUz/9DGZkDDD00K4UQl9sS9NBRXI9BQv3uP7yCOQ==
X-Google-Smtp-Source: ABdhPJzdGTCBjkLQd1h7QhqLvZblsjLuB9J3/hQ91KD5HnKD3Ou2iF/JbOiJc17r6HHQesY+hZsvsczjs6Bt+FpD2aw=
X-Received: by 2002:a9d:721c:: with SMTP id u28mr2263797otj.359.1613516245158;
 Tue, 16 Feb 2021 14:57:25 -0800 (PST)
MIME-Version: 1.0
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
 <YCvDVEvBU5wabIx7@lunn.ch> <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
In-Reply-To: <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Wed, 17 Feb 2021 08:57:13 +1000
Message-ID: <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com>
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 at 03:50, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 2/16/2021 5:06 AM, Andrew Lunn wrote:
> > On Mon, Feb 15, 2021 at 07:02:18AM +0000, Nathan Rossi wrote:
> >> From: Nathan Rossi <nathan.rossi@digi.com>
> >>
> >> The documentation for MDIO bindings describes the "broken-turn-around",
> >> "reset-assert-us", and "reset-deassert-us" properties such that any MDIO
> >> device can define them. Other MDIO devices may require these properties
> >> in order to correctly function on the MDIO bus.
> >>
> >> Enable the parsing and configuration associated with these properties by
> >> moving the associated OF parsing to a common function
> >> of_mdiobus_child_parse and use it to apply these properties for both
> >> PHYs and other MDIO devices.
> >
> > Hi Nathan
> >
> > What device are you using this with?
> >
> > The Marvell Switch driver does its own GPIO reset handling. It has a
> > better idea when a hardware reset should be applied than what the
> > phylib core has. It will also poll the EEPROM busy bit after a
> > reset. How long a pause you need after the reset depends on how full
> > the EEPROM is.
> >
> > And i've never had problems with broken-turn-around with Marvell
> > switches.
>
> The patch does make sense though, Broadcom 53125 switches have a broken
> turn around and are mdio_device instances, the broken behavior may not
> show up with all MDIO controllers used to interface though. For the

Yes the reason we needed this change was to enable broken turn around,
specifically with a Marvell 88E6390.

> reset, I would agree with you this is better delegated to the switch
> driver, given that unlike PHY devices, we have no need to know the
> mdio_device ID prior to binding the device and the driver together.
>
> >
> > Given the complexity of an Ethernet switch, it is probably better if
> > it handles its own reset.

We are not using the reset assert, I included this as part of the
change to match the existing phy parsing behavior. I can update this
change to only handle broken turn around, or is it also preferred that
broken turn around is handled by the e.g. switch driver?

Thanks,
Nathan

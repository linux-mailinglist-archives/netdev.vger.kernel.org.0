Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66B12B9F19
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgKTALS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgKTALR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:11:17 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DC0C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:11:15 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id h23so8164228ljg.13
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Clrk8WAuDZaq9eqOlyszSWbtlAidCiQ/pqctCxtmCeM=;
        b=Jlwjh1HKMA3xftnW+dDq22JGh9afs4iZCYDNmyjL+oNg+RQV3p6THWM4vIvtRtkK4d
         GrB2LtXIJxcipyr1W/ptoRtL/RIIaaCno0YjvKPZNOIOvi1DWXZrYVZJ7U6+l/k7A21y
         6jhMcWkiVQ8MPlY2BbzaDhYP0vmt6ACdaXWxObFkWoQ7NVyRL01iIoIMWIJoPe/RtndN
         /FdfqAVqtMFnOIHruq1vWt/dFt93NFAq9cGdrjlq3FaJ1kt5dQzu4mTrfL9KNJE/Afsp
         TqikED9lNlHeFoqputsZtm6fAOpNtj2KPIDswBo2LJOzSlcQkrS5egWQA4GhGy8C5QIZ
         MrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Clrk8WAuDZaq9eqOlyszSWbtlAidCiQ/pqctCxtmCeM=;
        b=i3AKQZg3hjg2WsV5+zh6Mp+cY0tZ2O/l4mlf7Y07HC7qmGoRs+qg4rBqArNGFe0TAm
         K6h5vwRInlT/n5sI2pVe234uaNmTPEEar9l1ZWY0oULsHFfACrHwIfauu9qDVBkjgz8l
         dj4tlrixgoQV0aIsbTD1jG0YACuif7zSBWSBcuWlJVqMDW1fdQfY24yqGRfIwE85ejdl
         mab+m5KDAaLdTzEO0rpGl8BDeSngKJTYRyFELkDSY+OqG6MNMrnZ0ezX2Phqk4R1qpjM
         FETfqrI7tdUcU6aDTFLbeHgsJ8excU21nF7M0eV7QwIpZf143h+sJbJ+nTNyZLuI8xDE
         SIeQ==
X-Gm-Message-State: AOAM532sqwTqwZiXE5TvWULZw8KITaye/30UgTtOhSTRhIyc70Y5fL4X
        VEeLW5VN8JupZMcaMhaqMh0DOA==
X-Google-Smtp-Source: ABdhPJzHKrEagljT+wr7hl7Li5Pu+TdYLu889OzAws1ROlq27vd5EUEVgt08NkvSZ9JIh2Yqt3yd1w==
X-Received: by 2002:a2e:a17c:: with SMTP id u28mr7161458ljl.453.1605831073802;
        Thu, 19 Nov 2020 16:11:13 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id o3sm145174lfo.217.2020.11.19.16.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:11:13 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
In-Reply-To: <20201119231613.GN1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com> <20201119145500.GL1551@shell.armlinux.org.uk> <20201119162451.4c8d220d@bootlin.com> <87k0uh9dd0.fsf@waldekranz.com> <20201119231613.GN1551@shell.armlinux.org.uk>
Date:   Fri, 20 Nov 2020 01:11:12 +0100
Message-ID: <87eekoanvj.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 23:16, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Thu, Nov 19, 2020 at 11:43:39PM +0100, Tobias Waldekranz wrote:
>> On Thu, Nov 19, 2020 at 16:24, Maxime Chevallier <maxime.chevallier@bootlin.com> wrote:
>> > I don't think we have a way to distinguish from the DT if we are in
>> > SGMII-to-Fibre or in SGMII-to-{Copper + Fibre}, since the description is
>> > the same, we don't have any information in DT about wether or not the
>> > PHY is wired to a Copper RJ45 port.
>> >
>> > Maybe we should have a way to indicate if a PHY is wired to a Copper
>> > port in DT ?
>> 
>> Do you mean something like:
>> 
>> SGMII->SGMII (Fibre):
>> ethernet-phy@0 {
>>    sfp = <&sfp0>;
>> };
>> 
>> SGMII->MDI (Copper):
>> ethernet-phy@0 {
>>     mdi;
>> };
>> 
>> SGMII->Auto Media Detect
>> ethernet-phy@0 {
>>     mdi;
>>     sfp = <&sfp0>;
>> };
>
> This isn't something we could realistically do - think about how many
> DT files are out there today which would not have this for an existing
> PHY. The default has to be that today's DT descriptions continue to work
> as-is, and that includes ones which already support copper and fibre
> either with or without a sfp property.
>
> So, we can't draw any conclusion about whether the fiber interface is
> wired from whether there is a sfp property or not.
>
> We also can't draw a conclusion about whether the copper side is wired
> using a "mdi" property, or whether there is a "sfp" property or not.
>
> The only thing we could realistically do today is to introduce a
> property like:
>
> 	mdi = "disabled" | "okay";
>
> to indicate whether the copper port can be used, and maybe something
> similar for the fiber interface.  Maybe as you suggest, not "okay"
> but specifying the number of connected pairs would be a good idea,
> or maybe that should be a separate property?

Maybe you could have optional media nodes under the PHY instead, so that
you don't involve the SFP property in the logic (SGMII can be connected
to lots of things after all):

    ethernet-phy@0 {
        ...

        sgmii {
            status = "okay";
            preferred;
        };

        mdi {
           status = "okay";
           pairs = <2>;
        };
    };

In the absence of any media declarations, you fall back to the driver's
default behavior (keeping compatibility with older DTs). But you can
still add support for more configurations if the information is
available.

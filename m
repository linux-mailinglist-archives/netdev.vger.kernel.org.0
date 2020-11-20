Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBBA2BA7D8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 11:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgKTK7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 05:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKTK7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 05:59:19 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C003C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 02:59:19 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id x9so9591040ljc.7
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 02:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=VE3SKMnKAFGE067VakEXuJ8H9MwGwlsemZ4gpXwcpHI=;
        b=hOJ7S3VTOuFmgUr9f+dT4L4zn/tWYiucQplGT4vxNqAQxtjYhca2QPRrNlJUHfkGbT
         nH/ZFCkF988Ai7c6yHSKCcvJwCCFxfyv1YeSqtfF07nvvWKLkiU5ukOPWZRV7q9/kO+7
         o9SYMmXmIwBtndcXllA3L2LE7tnPijX4A+2GtKVyanThQ1jHQUf0x8IozRMJy0Pqyq/r
         aYCHbzP1RrW46ISCZLuEizPVsmChgJZIGAzsffSv/g2+Cfy7gRhcPxgMJ0xojlmhnWYQ
         vdhGkEvyo+Ka43Z3ydNyujZIZcKY9LFn5RdrtF4lVn/G4tqpxsQEqpxVGZ0s9uKBzriD
         l7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VE3SKMnKAFGE067VakEXuJ8H9MwGwlsemZ4gpXwcpHI=;
        b=ji3APWap3ovnRvpPmM6gG6SLm2C6hyz7sts3qggMOyuy59QUsmEIzPwVkqivALO+JP
         2jHVUD/A1zvjwiOwommwbO+JNKxEnalll4lEIk0+rdGjPQHWbgZ3O9XlmPgLole36PQa
         Vr6b4IJTzt78xvVJ/UjGNQKol1HuMxBS6nLxxlnKsmicwcOh/A1LxzCjsVhIrl9RvUQW
         iDtEtdkG+qW0J4rdZ6rCIYR42MZXHUwsphhhwyn7S2U7qGrL2DEYUXfWPNBlz0DKjtMv
         eCiwHytDFE4/pf8tclzt4eGNNK2ltkdD9AcSQb9ZInfM+chOsMxEPNf/Cng5slZ9l4AZ
         M7aA==
X-Gm-Message-State: AOAM53252en3Ax0M6PUy9bPA+d54LsXt1kjMNUyGA9+q2AKl0dYEiI7j
        PvxLDeiNcVoqvopLxPKTo5zhnaVkwZ1BGI+z
X-Google-Smtp-Source: ABdhPJzxNBVRuOSmrXTM7ICN6C7XrMyB/FroMhtdaC51kElsfjxb4NhyeKKncEuzZ6uSHUxObMykEQ==
X-Received: by 2002:a2e:240e:: with SMTP id k14mr8216666ljk.332.1605869957788;
        Fri, 20 Nov 2020 02:59:17 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r16sm304095lfi.121.2020.11.20.02.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 02:59:17 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
In-Reply-To: <20201120102538.GP1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com> <20201119145500.GL1551@shell.armlinux.org.uk> <20201119162451.4c8d220d@bootlin.com> <87k0uh9dd0.fsf@waldekranz.com> <20201119231613.GN1551@shell.armlinux.org.uk> <87eekoanvj.fsf@waldekranz.com> <20201120103601.313a166b@bootlin.com> <20201120102538.GP1551@shell.armlinux.org.uk>
Date:   Fri, 20 Nov 2020 11:59:16 +0100
Message-ID: <8736149tvf.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:25, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Fri, Nov 20, 2020 at 10:36:01AM +0100, Maxime Chevallier wrote:
>> So maybe we could be a bit more generic, with something along these lines :
>> 
>>     ethernet-phy@0 {
>>         ...
>> 
>>         mdi {
>>             port@0 {
>>                 media = "10baseT", "100baseT", "1000baseT";
>>                 pairs = <1>;
>> 	    };
>> 
>>             port@1 {
>>                 media = "1000baseX", "10gbaseR"
>>             };
>>         };
>>     };

Yeah that looks even better. Though "pairs" is redundant if you can
specify the list of supported link modes. I guess not specifying "media"
should mean "use all modes supported by the PHY". And if, for example,
media is set to 10-T+100-TX, that means that only two pairs will be
used.

> Don't forget that TP requires a minimum of two pairs. However, as
> Andrew pointed out, we already have max-speed which can be used to
> limit the speed below that which requires four pairs.

Maybe "max-speed" is how you solve this in the absense of explicit an
MDI declaration? Because in the multi-port case, the setting could be
different for the two ports, so you would source the information from
the "media" property instead.

> I have untested patches that allow the 88x3310 to be reconfigured
> between 10GBASE-R and 1000BASE-X depending on the SFP connected -
> untested because the I2C pull-ups on the Macchiatobin boards I have
> are way too strong and it results in SFP EEPROM corruption and/or
> failure to read the EEPROM.
>
>> I also like the idea of having a way to express the "preferred" media,
>> although I wonder if that's something we want to include in DT or that
>> we would want to tweak at runtime, through ethtool for example.
>
> I think preferred media should be configurable through ethtool -
> which is preferred will be specific to the user's application.

Yeah I half-regretted putting that in there right after I hit "send" :)
It should definitely be configurable from ethtool.

> However, there may be scope for DT to be able to specify the default
> preferred media.

This is where I was coming from. The vendor could potentially have more
information on what the default should be. But I guess you could also
argue that there is value in having Linux behave the same across all
devices.

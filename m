Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1E42BA59A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgKTJMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKTJMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:12:46 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E9EC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 01:12:45 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id p12so9280399ljc.9
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 01:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=9r5GOiFFo33h84co2LKPKA1Auxr9ykx71pUfOcoWfUM=;
        b=obIcuxbYxxNdSnj0Y8U9InyTQPsYhw2HyBe7eXDoNhz2gL662dNWjarBtQXWs5Ricr
         GkNravJu2GCQgg4j21fm9svNd/9PMgjz5I0xe0+JwOFCy1xjdNQ7Qwoy/IpDeYN5zFwg
         HMQsmcu6vlJbNFhWR9PbaC+3Cp62i0jBAYbjIBnNHzu28JyL/LxpWJ6ya6um4//aSL28
         tKt1rTxtI/RrXgkLekjnrcAqqmGfJUkqJ0+tVWx0oHChjS7ADgxyVwzOgDhTYOUHELpd
         Vpmn7J1RoTiYJyZBfryP9ufbOnpCEP3xxgM0mve0b4ptmnpf3ik2IsPTUEScqtEIlu3C
         X5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9r5GOiFFo33h84co2LKPKA1Auxr9ykx71pUfOcoWfUM=;
        b=QD6/OYYDF7MTvQ2Cr1qkjQpKt3vMIQPM1zhg7jqVQ+22I5NhUjgU56/JxHRvzdiWpW
         ChJa/EAjLieRgeyp3GD1UU28VAlL8QW6uqBKvh5jZ7GlfJA5tI50Z4vstyLLsivnrJSt
         6N/K8Y1bedguz2dx+aebBt/rjmSkUVb3h6akkCj7pFAg44+QYSmxhbtO0aAymIDocpfq
         atYmXYuglPkp6P9wqhSATFPce9VGmE7NXSif9OKwf1Ioqug7aiMTCon6bYgDr6vrp3hS
         J3h+7984Ffe6nHJrSdC91hEFdQ11vijRYYZZpt6P7CXFSNVrCrFLaGvakfgI8t6G5eSp
         kkZg==
X-Gm-Message-State: AOAM5331bFWZskg1Y1TRaZkboV8+2vbvxuFl70xr/47gBxttWDVEA4qY
        i8fSuZy2jzgkwTfef49LcsVFYg==
X-Google-Smtp-Source: ABdhPJw00H38Dgoi0uPcMvtPWsl6eW+ApGZttfsMzyOs2CiHH35SmQkw5kPIAphdK6zrgY8gAUtzcw==
X-Received: by 2002:a2e:9e87:: with SMTP id f7mr6922352ljk.358.1605863564270;
        Fri, 20 Nov 2020 01:12:44 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d29sm278567lfj.51.2020.11.20.01.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:12:43 -0800 (PST)
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
In-Reply-To: <20201120004048.GO1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com> <20201119145500.GL1551@shell.armlinux.org.uk> <20201119162451.4c8d220d@bootlin.com> <87k0uh9dd0.fsf@waldekranz.com> <20201119231613.GN1551@shell.armlinux.org.uk> <87eekoanvj.fsf@waldekranz.com> <20201120004048.GO1551@shell.armlinux.org.uk>
Date:   Fri, 20 Nov 2020 10:12:43 +0100
Message-ID: <875z609yt0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 00:40, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> I think you're advocating calling the fiber interface "SGMII", which
> would be totally wrong.
>
> SGMII is a Cisco modification of 802.3 1000base-X to allow 10M and 100M
> speeds to be used over a single serdes lane in each direction.
>
> 1000base-X is what you run over a fiber link. This is not SGMII. Using
> "SGMII" for 1000base-X is incorrect, but a common abuse of the term in
> industry. Abusing a term does not make it correct, especially when it
> comes to defining further standards.
>
> (This is one of my pet peaves, sorry.)

Nomenclature is very important, no excuse necessary.

You are right that SGMII is not the term I am looking for, but I am not
sure 1000base-X is either. I am looking for a word that describes the
serial interface that can run in either 1000base-X or 100base-FX mode
(and possibly other ancient/proprietary modes). Maybe just "serdes"?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301CF4A8827
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352054AbiBCP6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbiBCP6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:58:04 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E30CC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 07:58:04 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 132so2625584pga.5
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 07:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HoSzVnw2BnmdPeyLBLFwLkiFu/WEUrSX1fW/APCKZOY=;
        b=cd2BV91+mMMbRvTFi52N/AXl2Le0Z0r6nq7Hwm0XkcwA/V+wvhI3IYR4r9pu3PZhNx
         znnMByx9ZZbC3Ow7+Y1R1QaXxxrZpP2xutoU8bqJV+vh2zmxqkDT8fS21QPjbRb9ZqIs
         sXilpaCWjpil5pQ4l3CMpRhXlSz172P/vWX3nUKtkIAlzXMQHLnNH4EX/M6FPCDRA6lz
         trMymVwtJFAzZwduDXkWVWY2dnGBPrmtj50N2d5a/xHs8f4kcyqk/0r4R0gB0WPxnS+T
         gnL/71n2sSn6OBuXhbiRmvT5ZFlzFhILAdGGf3j3j4SUHp6ljLoGOzgRPHDTWLo6souz
         uVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HoSzVnw2BnmdPeyLBLFwLkiFu/WEUrSX1fW/APCKZOY=;
        b=ptsnYtJN4VzNp0XvzKboDtLUywj+QNOZsqHLrg1GHl2JsCTKA7gc12cf6s1mqYSwNH
         0iaALaQzMP78xAIkS+CC2xJKDR4ShJjXwFaUqMhzPbDZprGuTJb58Af8ZXfYzQSFLsjB
         KqUJ/CxRNFmktBLbzhW08JqqsJWUbJXOXoBxkkpyE/G4omF7U+dDDprPxKXMqmMCX+55
         CP8zBtH0rK5ArWEG4DrMhD7TyRk2+XLnICO2flw2Kgm86vXHk7uk0kchuvk/dzWllTX7
         ob+mnYbSs2y3Tc9Z5d5PTZbD9QXTthD6O3kopoYCEoZ3gvCatY1KOV7eTRLd21+kC726
         zAKA==
X-Gm-Message-State: AOAM531a3S3Ttu3am5C10FAfTXxEEscuilJ+VMP9Od9PF92GKLeviUVh
        uTHRELdv531PUFoCQdaeSJaB0TOJQ1wMXzJ4STxW8w==
X-Google-Smtp-Source: ABdhPJxswvJSQIq4vfMmqBKuKgFZf3co3KEwJmX9wgxoDzi5W34ig4hBca0frXKnmRvOtV8LKHrtEJubdOtroz07tTY=
X-Received: by 2002:a05:6a00:728:: with SMTP id 8mr34691382pfm.27.1643903883627;
 Thu, 03 Feb 2022 07:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de> <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch>
In-Reply-To: <YfspazpWoKuHEwPU@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 3 Feb 2022 07:57:52 -0800
Message-ID: <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 5:01 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > As a person responsible for boot firmware through kernel for a set of
> > boards I continue to do the following to keep Linux from mucking with
> > various PHY configurations:
> > - remove PHY reset pins from Linux DT's to keep Linux from hard resetting PHY's
> > - disabling PHY drivers
> >
> > What are your thoughts about this?
>
> Hi Tim
>
> I don't like the idea that the bootloader is controlling the hardware,
> not linux.
>
> There are well defined ways for telling Linux how RGMII delays should
> be set, and most PHY drivers do this. Any which don't should be
> extended to actually set the delay as configured.

Andrew,

I agree with the goal of having PHY drivers and dt-bindings in Linux
to configure everything but in the case I mention in the other thread
adding rgmii delay configuration which sets a default if a new dt
binding is missing is wrong in my opinion as it breaks backward
compatibility. If a new dt binding is missing then I feel that the
register fields those bindings act on should not be changed.

>
> LEDs are trickier. There is a slow on going effort to allow PHY LEDs
> to be configured as standard Linux LEDs. That should result in a DT
> binding which can be used to configure LEDs from DT.

Can you point me to something I can look at? PHY LED bindings don't at
all behave like normal LED's as they are blinked internally depending
on a large set of rules that differ per PHY.

>
> You probably are going to have more and more issues if you think the
> bootloader is controlling the hardware, so you really should stop
> trying to do that.
>

Trust me, I would love to stop trying to hide PHY config from Linux.
It's painful to bump to a new kernel and find something broken. In
this case I found that my LED configuration broke and in the other
patch I found that my RGMII delays broke.

Completely off topic, but due to the chip shortage we have had to
redesign many of our boards with different PHY's that now have
different bindings for RGMII delays so I have to add multiple PHY
configurations to DT's if I am going to support the use of PHY
drivers. What is your suggestion there? Using DT overlays I suppose is
the right approach.

Tim

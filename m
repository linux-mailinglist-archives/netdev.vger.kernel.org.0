Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A27425ABA
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbhJGS2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243666AbhJGS2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 14:28:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD7EC061570;
        Thu,  7 Oct 2021 11:26:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t16so4711437eds.9;
        Thu, 07 Oct 2021 11:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XxO0G2e2KmYJcacx8mK3ugFcVqSLBQrO6+A/auKa9jU=;
        b=e5/ad2VW9gTeNN5ykwIhjk3Jlfsa0J/DeVyNJ9vbRYREPGcdfym2x2Dr3AdlSKuR6w
         HZeGHGE9oFfaF19dy3XA4N9RsQbeTtMkVqdKaOfxxTjtxY6zK3ZzY1FkvI3BChM3mXoV
         H16zMtXpgzbkZCNwVuKO/JdUdkR60+Wz8c6Wl2q7VZJcZGKt9QaZUMvwql42GuNERb7S
         J2hRXsXCi4gwYQwepzqe6J6uMCdExEQMByjlpCVBfJm2E0Qvfu4zo7GROzZtdRgM/uQW
         rWBwknrRLfXCL1c/jOBPjzg9gu+HLgn8MEwCawKDdFIP4cwzfPvX2yBz2Gr3bx3WkBOl
         pZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XxO0G2e2KmYJcacx8mK3ugFcVqSLBQrO6+A/auKa9jU=;
        b=s+5BPHXDHXMm2zKdAsqLA45Abrv6CwYuB8/cuIINZtB+kE1Q+qg1upMJcZJnxuPkip
         yMElkEGMbPMcLwjNdT3XVR5m6WT7aH61JdqzAnGGin3EeVSIWDVzvb5PkEFsEfAEzP3M
         KStmgUAN64JWGx47QqxTvmUSnM2LWCG9Mt17FXOBbfexcMWD9uMqYsyd18HS9/X8eXix
         JEb/ON3NRWBQWqmjMnKZjZ2Poug565Aj92/votKGu0pF8hKYGGuoA+uLkClgwhrTmFCR
         RHqDVUMYlzsb69U+cp6dax7gnSQeGxwjQFIlfjQ/NVB9v+txrqLc6oXIwBXQg39IVnfk
         pr2A==
X-Gm-Message-State: AOAM530O2w3wBjxTL+CiVtXK4W7oC/iFI9BIoRl3AoTXkq37VVv8spgF
        hb/K9YrBPGNJe1183vnooDA=
X-Google-Smtp-Source: ABdhPJwwFSkWf0VXYApfSWngLNN1l82rZdK/8jkUlYfU7btRv+pwtOTqNt2NBPwUnL+CDCWd2YdS4w==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr7526535eje.112.1633631174384;
        Thu, 07 Oct 2021 11:26:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id j5sm57648ejb.96.2021.10.07.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 11:26:14 -0700 (PDT)
Date:   Thu, 7 Oct 2021 20:26:11 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 10/13] net: dsa: qca8k: add explicit SGMII PLL
 enable
Message-ID: <YV87w970EjDZqxk4@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-11-ansuelsmth@gmail.com>
 <YV4/ehy9aYJyozvy@lunn.ch>
 <YV73umYovC0wh5hz@Ansuel-xps.localdomain>
 <YV83BAmhHfmDyCjv@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV83BAmhHfmDyCjv@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 08:05:56PM +0200, Andrew Lunn wrote:
> 
> On Thu, Oct 07, 2021 at 03:35:54PM +0200, Ansuel Smith wrote:
> > On Thu, Oct 07, 2021 at 02:29:46AM +0200, Andrew Lunn wrote:
> > > On Thu, Oct 07, 2021 at 12:36:00AM +0200, Ansuel Smith wrote:
> > > > Support enabling PLL on the SGMII CPU port. Some device require this
> > > > special configuration or no traffic is transmitted and the switch
> > > > doesn't work at all. A dedicated binding is added to the CPU node
> > > > port to apply the correct reg on mac config.
> > > 
> > > Why not just enable this all the time when the CPU port is in SGMII
> > > mode?
> > 
> > I don't know if you missed the cover letter with the reason. Sgmii PLL
> > is a mess. Some device needs it and some doesn't. With a wrong
> > configuration the result is not traffic. As it's all messy we decided to
> > set the PLL to be enabled with a dedicated binding and set it disabled
> > by default. We enouncer more device that require it disabled than device
> > that needs it enabled. (in the order of 70 that doesn't needed it and 2
> > that requires it enabled or port instability/no traffic/leds problem)
> 
> What exactly does this PLL do? Clock recovery of the SGMII clock, and
> then using it in the opposite direction? What combinations of PHYs
> need it, and which don't?
>

I will quote from Documentation
bit 1: enable SGMII PLL (it's disabled by default)
bit 2: enable rx chain. By default it's disabled and CLK125M_RX and
DOUT_RX can be any logic of 1 or 0
bit 3: enable TX driver. By default is in idle and kept in 900mV
As you can see normally all these bit are disabled and I think forcing
them on seems wrong.
We can think about setting it based on the switch type and revision but
again we found some that needed it anyway and goes out of any logic.
The original idea is to add a biding to force the setting and make the
driver decide itself the correct option. But considering we found that
in 90% of the case, this is not needed, the switch default doesn't
enable it and that only 2-3 device require it, I see the binding the
only way to implement this and do not pollute the code with tons of
condition.

> > > Is it also needed for 1000BaseX?
> > > 
> > 
> > We assume it really depends on the device.
> 
> That i find surprising. 1000BaseX and SGMII are very similar. I would
> expect a device with requires the PLL enabled for SGMII also needs it
> for 1000BaseX.
> 

With assume I mean we have no device with 1000BaseX (and I honestly
don't know if it does exist) I think if it does require PLL for sgmii
then it does require it also for 1000BaseX

> > > DT properties like this are hard to use. It would be better if the
> > > switch can decide for itself if it needs the PLL enabled.
> > 
> > Again reason in the cover letter sgmii part. Some qca driver have some
> > logic based on switch revision. We tried that and it didn't work since
> > some device had no traffic with pll enabled (and with the revision set
> > to enable pll)
> 
> This is my main problem with this patchset. You are adding lots of
> poorly documented properties which are proprietary to this switch. And
> you are saying, please try all 2^N combinations and see what works
> best. That is not very friendly at all.

We have many device and we notice a common config for both qca8327 and
qca8337. Wonder if this would be improved by adding some hint in the
documentation on the correct configuration based on the switch model?
We waited so much to push this just to check if all this bad stuff was
actually needed or could be implemented differently, but we really find
any logic. So I think the only way is ""spam"" the documentation with
data on how to decide the correct option.

> 
> So it would be good to explain each one in detail. Maybe given the
> explanation, we can figure out a way to detect at runtime, and not
> need the option. If not, you can add it to the DT binding to help
> somebody pick a likely starting point for the 2^N search.
> 
> 	 Andrew

-- 
	Ansuel

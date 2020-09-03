Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1102025CCB4
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgICVuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729312AbgICVuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:50:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE978C061244;
        Thu,  3 Sep 2020 14:50:07 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gf14so2095832pjb.5;
        Thu, 03 Sep 2020 14:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r7Tgg9fh7R0oiGADlmNoq8hG+/+fXAk6S6qW0ozfjnY=;
        b=PFY/FTQSv4gn1ON7S+i7H5hdVNh34mvVfIbqZaJD4ekQof7nXBISRDQHHRDHmJ9gL7
         6LNnUzyaaG78Tw4DBGfFjBDH0Pzj3X3Ho6DPtQQsOg+LUINBF+gAKxkBGyNQ5i+FTqSs
         BGKtsDS0zLYBHqQAZdo7BNF3nDvwabTdvIzpc9qF++kk7rizN/2TYS6d8Z2vCqrECw5x
         E8uebwVgh7njY0Eqc/B/1A/tDexpikI2lqPZK28Y5Gm9jkqikz1Q/x/isNnrKprI84Uw
         uwFGR/HtjptWpCKJyX/oGr1UDxiwEDP+hPgFZpypwvvQwAlON1mmCmBIdHHUxK9f96FQ
         L/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r7Tgg9fh7R0oiGADlmNoq8hG+/+fXAk6S6qW0ozfjnY=;
        b=K3qzJnWKqD9STnW6DVE3woA+e429Jsvv3OSvC2KDsjqLumdJaGYt8iGhUt2DoPYLcH
         D3aW+pTEnUmo0sW8L4gcBPW86JZajODMNcE1WEwVtd2OsLlRtjRoD0HXSogRzedFV5ZQ
         vMqHA6LRVEnzwPodqzysDOJZJS7fzGInhKk7W+vtfxrwQMN/vizLcuab/voms+VE1xWb
         k9g1y56z9vaDHfGVD0uGfq3qgBjZGrMx0km0RV+RCfpAs6Fxevf8R/3NjqImij3rtlo1
         Nl4d4Dpw3mMs2XeG0wxpQSikKlBVdsVExxGUqhGDJZc70MLLboHHrESOvAywD9JFjBzv
         GgGg==
X-Gm-Message-State: AOAM531QjdCTgCAyW3UJTyH2ljDkqPZ0gdeZQpZfD4pyqC7ifQ5I+niR
        KnysAWMzizCTKjn7qFWePvM=
X-Google-Smtp-Source: ABdhPJwBNIZpP8HG3Au66qMjwtVggOKD6S/kSnpzZXyj19Qm7Gvanr8kpUr712HT2GiNdHee6SYz2w==
X-Received: by 2002:a17:90a:1fca:: with SMTP id z10mr5060502pjz.209.1599169807406;
        Thu, 03 Sep 2020 14:50:07 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t63sm3478502pgt.50.2020.09.03.14.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 14:50:06 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: Support enabling clocks prior to
 bus probe
To:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, adam.rudzinski@arf.net.pl,
        Marco Felsch <m.felsch@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        devicetree@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-2-f.fainelli@gmail.com>
 <CAL_JsqL=XLJo9nrX+AMs41QvA3qpW6zoyB8qNwRx3V-+U-+uLg@mail.gmail.com>
 <20200903214238.GF3112546@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <885abb40-cf1c-b464-bf09-08c7235410ef@gmail.com>
Date:   Thu, 3 Sep 2020 14:50:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903214238.GF3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 2:42 PM, Andrew Lunn wrote:
> On Thu, Sep 03, 2020 at 03:28:22PM -0600, Rob Herring wrote:
>> What if a device requires clocks enabled in a certain order or timing?
>> It's not just clocks, you could have some GPIOs or a regulator that
>> need enabling first. It's device specific, so really needs a per
>> device solution. This is not just an issue with MDIO. I think we
>> really need some sort of pre-probe hook in the driver model in order
>> to do any non-discoverable init for discoverable buses.
> 
> Hi Rob
> 
> How do you solve the chicken/egg of knowing what device specific init
> is needed before you can discover what device you have on the bus?

For MDIO since we have a fixed number of devices on the bus, we could 
pre-populate the MDIO map for all addresses, and free up the devices 
that we did not probe.

When using DT we can first parse the address, create a mdio_device 
there, and then turn on clocks/regulators/GPIOs whatever since we now 
have a device reference. Only then do we bind the device with its driver.

If we are using the DT scanning loop because the node did not provide a 
"reg" property, then the PHY must be in a functional state to be probed, 
we cannot guess what we do not know.

All of this uses MDIO implementation knowledge though.

> 
>> Or perhaps forcing probe when there are devices defined in DT if
>> they're not discovered by normal means.
> 
> The PHY subsystem has this. You came specify in DT the ID of the
> device which we would normally read during bus discovery. The correct
> driver is then loaded and probed. But it is good practice to avoid
> this. OEMs are known to change the PHY in order to perform cost
> optimisation. So we prefer to do discover and do the right thing if
> the PHY has changed.
> 
> As for GPIOS and regulators, i expect this code will expand pretty
> soon after being merged to handle those. There are users wanting
> it. We already have some standard properties defined, in terms of
> gpios, delay while off, delay after turning it on. As for ordering, i
> guess it would make sense to enable the clocks and then hit it with a
> reset? If there is a device which cannot be handled like this, it can
> always hard code its ID in device tree, and fully control its
> resources in the driver.
> 
> 	  Andrew
> 

-- 
Florian

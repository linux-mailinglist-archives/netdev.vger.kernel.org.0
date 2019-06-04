Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC10535175
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDU5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:57:06 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:39422 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDU5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:57:05 -0400
Received: by mail-pg1-f170.google.com with SMTP id 196so11053300pgc.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PbOrM3DiS1F8/w2vh3Cz/2+CErEVgQWOt5e/lTRSFOw=;
        b=k02Dg6nRhYRyd6vdae4sKFkGeSrTILEr34aKM3zDF7NMsFpuRbsEpdswTUNvMFLjpW
         G8E/1KXP7gx8LjVRVSFaeChHEXQk2wlo0ZTVmDXszOfdyjSzvDL7tMlz7eykLkyxfHvv
         wdlXgr6cn6D4gPUPkRAZYJx9cJZ/0Z/sv8sFxhIGpv1OacAl2dY/dAQp3YbvCvw1vlub
         VlJ5FeOrbnn7ToQEkzR1umG7pOLOiklLlgGjK8YKdYHurtSdiUBQjdjVzcbld4k3IOXg
         X1aCjldMwBDvqaxBm6tk4oyY+C5SWcfri1lOLhOEakGoiHHI5wYOdYm+/tkk5MmZ9Pez
         XnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PbOrM3DiS1F8/w2vh3Cz/2+CErEVgQWOt5e/lTRSFOw=;
        b=MiIngEy0Uy8dFv2bMxtQUqlpWZBssvCrpdcZe0zvzU9FozrH/H+ib5QQ/5ndCqEzxD
         bkP+k1OaAGGevUOEWusz+xZxG4Zy5P/JI1weFVsynedAL+jpjpUo/L6UTLpuZqvHJdoJ
         ju/n7PAue2LZLsF+mSiI4Lg/PlpvyzxpRJKy+FU325qd2jQgn+22855hHG0adS7iM48u
         gytD7lzmiwfOPCf//n6SgW2i4JWWD8vOJAVxr2Zm/notZAncg0TF1XW3akvZZ1exg+38
         ZvS9yq1VN6tykDXcbdnN3XzLzmqmdrH5OjUw1eH5++KJRaOq89YoFvvX4OkWH3OnT6Xm
         bzUA==
X-Gm-Message-State: APjAAAXBJkEcVn7+pEXzgI65y4ZUGciNa4jU2N0Z+5iD3g69H90Al2ao
        WCVATD4JO2Jd0iFe0+It20A=
X-Google-Smtp-Source: APXvYqzplWV+sqO9hZHQ75a62cq5mte1ajErS1RNHMoA1aNUr+8ZaJa2q6vYkTRyUqePOGWoyz5jEQ==
X-Received: by 2002:a63:e708:: with SMTP id b8mr744028pgi.168.1559681825019;
        Tue, 04 Jun 2019 13:57:05 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id 2sm14053147pfo.41.2019.06.04.13.57.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:57:04 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <13123dca-8de8-ac1d-9b21-4588571150f3@gmail.com>
Date:   Tue, 4 Jun 2019 13:57:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 1:42 PM, Vladimir Oltean wrote:
> On Tue, 4 Jun 2019 at 23:07, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Tue, Jun 04, 2019 at 10:58:41PM +0300, Vladimir Oltean wrote:
>>> Hi,
>>>
>>> I've been wondering what is the correct approach to cut the Ethernet link
>>> when the user requests it to be administratively down (aka ip link set dev
>>> eth0 down).
>>> Most of the Ethernet drivers simply call phy_stop or the phylink equivalent.
>>> This leaves an Ethernet link between the PHY and its link partner.
>>> The Freescale gianfar driver (authored by Andy Fleming who also authored the
>>> phylib) does a phy_disconnect here. It may seem a bit overkill, but of the
>>> extra things it does, it calls phy_suspend where most PHY drivers set the
>>> BMCR_PDOWN bit. Only this achieves the intended purpose of also cutting the
>>> link partner's link on 'ip link set dev eth0 down'.
>>
>> Hi Vladimir
>>
>> Heiner knows the state machine better than i. But when we transition
>> to PHY_HALTED, as part of phy_stop(), it should do a phy_suspend().
>>
>>    Andrew
> 
> Hi Andrew, Florian,
> 
> Thanks for giving me the PHY_HALTED hint!
> Indeed it looks like I conflated two things - the Ehernet port that
> uses phy_disconnect also happens to be connected to a PHY that has
> phy_suspend implemented. Whereas the one that only does phy_stop is
> connected to a PHY that doesn't have that... I thought that in absence
> of .suspend, the PHY library automatically calls genphy_suspend.

It does not fallback to genphy_suspend(), maybe we should change that,
setting BMCR.PDOWN is a good power saving in itself, if the PHY can do
more, you have to implement a .suspend() callback to get the additional
power savings.

> Oh well, looks like it doesn't. So of course, phy_stop calls phy_suspend
> too.
> But now the second question: between a phy_connect and a phy_start,
> shouldn't the PHY be suspended too? Experimentally it looks like it
> still isn't.
> By the way, Florian, yes, PHY drivers that use WOL still set
> BMCR_ISOLATE, which cuts the MII-side, so that's ok. However that's
> not the case here - no WOL.

I was just responding about what is IMHO sensible to do. There is an
additional caveat/use case to possibly consider which I am sure some
drivers intentionally support (or not), which is that bringing down the
interface does stop the PHY state machine and then you are free to issue
whatever SIO{S,G}MIIREG for diagnostics etc. Whether the MAC or PHYLIB
is responsible for taking the PHY out of power down mode, or if it is up
to the diagnostics software to do that is up for debate, I would go with
the latter, which would always work regardless of what you are trying to do.
-- 
Florian

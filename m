Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E019F18BCAE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgCSQgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:36:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39247 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbgCSQgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:36:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id a9so36154wmj.4
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 09:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Qi1/0g6HcBmMES4ToJIb52lGasb0+SC87qg08Z50n8=;
        b=HFOM/dc1KeqAQAZbap8pMR1caHgGyRFz8kk25Hq/uGxfz+xDJIeOIlSt8T0Alipf74
         nGpUt1gKCQ5SnVsVLx2AF40qz3ANx6CiTQPRALZYw1LcOCcbJi/cCxfIonELvZLTZewB
         7Ylmv6N9XuV/RQy4sYiMaEsI/qsW4r0O4umF8kX3SN536aqcZyW5+wzBnf4c9nKFpMsH
         /TUQY2L5wSQ+pdQOX5lrTSV/BlEEgyZZs4fkWz/YxnfEr9g41LZzN9BScbZ2o1RHZrK+
         e2+TMhwj3FAsI8LerhZujDRkX9dLHzdYHCZJ6C6isrzkTY7OHtOPUrmAaaF2vbBZRqHF
         xwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Qi1/0g6HcBmMES4ToJIb52lGasb0+SC87qg08Z50n8=;
        b=k182cNJACPa+m5VphwQMGhB+ysNnRx2h+rjNOisVJuesWIj6Tj35upAUsVJC7ZUlqi
         2etBN7VrY1XXrK0xJEtNs94mREm3bdVwJlXa0bmWabvu+FRdlbmx2GlyaXwvSZKZ0PLs
         R1hqctMDM6bLf8wekGUoLbOsDOjcGKa6/b7ifoy3vVslAHVFQKUr5lgq9cQGw8RdLoS1
         ORwKQVCxaHY/z0xhHxMCxRdamxKMhLQglH7ZXx2bxE3ha+63tWeXtbawY0wf/+5Ckdyo
         Cgf3RKsK7EjUAxtoLwROASbuuKh7TGfrvFINrUSye+4Ibiwi3sSrjzwemJKPHaNtH9B9
         7OGA==
X-Gm-Message-State: ANhLgQ2niSGH3Ph74A4/BGX66FcQgTWycCYFBegDD2f5YGfuqHwcrclM
        jrFS5XKhNQZDrW2xxERd8O3fpNl4
X-Google-Smtp-Source: ADFU+vsazLbt9DHJaWHa9ZrJYALyZp9an7OcuKR0NCUSHoApuZ0bf7uQccBpmwOwMNesPbIEcAsRaQ==
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr4664439wma.122.1584635796792;
        Thu, 19 Mar 2020 09:36:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:f482:8f51:2469:4533? (p200300EA8F296000F4828F5124694533.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f482:8f51:2469:4533])
        by smtp.googlemail.com with ESMTPSA id t1sm4425991wrq.36.2020.03.19.09.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 09:36:36 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
 <20200319112535.GD25745@shell.armlinux.org.uk>
 <20200319130429.GC24972@lunn.ch>
 <20200319135800.GE25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <92689def-4bbf-8988-3137-f3cfb940e9fc@gmail.com>
Date:   Thu, 19 Mar 2020 17:36:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319135800.GE25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.03.2020 14:58, Russell King - ARM Linux admin wrote:
> On Thu, Mar 19, 2020 at 02:04:29PM +0100, Andrew Lunn wrote:
>>> The only time that this helps is if PHY drivers implement reading a
>>> vendor register to report the actual link speed, and the PHY specific
>>> driver is used.
>>
>> So maybe we either need to implement this reading of the vendor
>> register as a driver op, or we have a flag indicating the driver is
>> returning the real speed, not the negotiated speed?
> 
> I'm not sure it's necessary to have another driver op.  How about
> this for an idea:
> 
> - add a flag to struct phy_device which indicates the status of
>   downshift.
> - on link-up, check the flag and report whether a downshift occurred,
>   printing whether a downshift occurred in phy_print_status() and
>   similar places.  (Yes, I know that there are some network drivers
>   that don't use phy_print_status().)
> 
> The downshift flag could be made tristate - "unknown", "not downshifted"
> and "downshifted" - which would enable phy_print_status() to indicate
> whether there is downshift supported (and hence whether we need to pay
> more attention to what is going on when there is a slow-link report.)
> 
> Something like:
> 
> For no downshift:
> 	Link is Up - 1Gbps/Full - flow control off
> For downshift:
> 	Link is Up - 100Mbps/Full (downshifted) - flow control off
> For unknown:
> 	Link is Up - 1Gbps/Full (unknown downshift) - flow control off
> 
> which has the effect of being immediately obvious if the driver lacks
> support.
> 
> We may wish to consider PHYs which support no downshift ability as
> well, which should probably set the status to "not downshifted" or
> maybe an "unsupported" state.
> 
> This way, if we fall back to the generic PHY driver, we'd get the
> "unknown" state.
> 

I'd like to split the topics. First we have downshift detection,
then we have downshift reporting/warning.

*Downshift detection*
Prerequisite of course is that the PHY supports reading the actual,
possibly downshifted link speed (typically from a vendor-specific
register). Then the PHY driver has to set phydev->speed to the
actual link speed in the read_status() implementation.

For the actual downshift detection we have two options:
1. PHY provides info about a downshift event in a vendor-specific
   register or as an interrupt source.
2. The generic method, compare actual link speed with the highest
   mutually advertised speed.
So far I don't see a benefit of option 1. The generic method is
easier and reduces complexity in drivers.

The genphy driver is a fallback, and in addition may be intentionally
used for PHY's that have no specific features. A PHY with additional
features in general may or may not work properly with the genphy
driver. Some RTL8168-internal PHY's fail miserably with the genphy
driver. I just had a longer discussion about it caused by the fact
that on some distributions r8169.ko is in initramfs but realtek.ko
is not.
On a side note: Seems that so far the kernel doesn't provide an
option to express a hard module dependency that is not a code
dependency.

*Downshift reporting/warning*
In most cases downshift is caused by some problem with the cabling.
Users like the typical Ubuntu user in most cases are not familiar
with the concept of PHY downshift and what causes a downshift.
Therefore it's not sufficient to just report a downshift, we have
to provide the user with a hint what to do.
Adding the "downshifted" info to phy_print_status() is a good idea,
however I'd see it as an optional addition to the mentioned hint
to the user what to do.
The info "unknown downshift" IMO would just cause confusion. If we
have nothing to say, then why say something. Also users may interpret
"unknown" as "there's something wrong".

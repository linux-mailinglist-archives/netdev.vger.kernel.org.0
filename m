Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3ED449B40
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhKHSBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbhKHSB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:01:28 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0120C061746;
        Mon,  8 Nov 2021 09:58:43 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id ee33so66251974edb.8;
        Mon, 08 Nov 2021 09:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=srUD56hRZ853dCNAA8H478OqvOJZOmArxFkb/7yRHBY=;
        b=ZahT6eC5GoZP1vUUjA79eyiXHRWM4BFchqqHcE6C+0lDIcmrY0xdkI4sxei6RiLm+K
         gtX0bmLenawNFbS874L+1EizCzeENWZA1kGJEBZHkCWs4QBADoPmHN1nMFmrIGuJ46jV
         GynFxEx/qEXSRyc6f9CVCU7ul0sCqbOKqQLcBr63Wp+yO/8Ce3iU2AcsMrz14hQNkfu8
         DAWd5C2zUh+rpaIRKVNadwc7JLHbLaPrfc9kzMs346zChUK3NbXNp1+zBhEjX+vw3Vxn
         OkO29r0BoEBnD1A5Oo53YOE13N1G9JNIqZCJftV+ov34sN+AEtYz0FVdSRtuNYeR5rT7
         Mzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=srUD56hRZ853dCNAA8H478OqvOJZOmArxFkb/7yRHBY=;
        b=i+ZB7FyVNnuWYRH9XHs99kY5Yht6nSsPY3VRfK6of9TE6CG5b/qCHDjVHdS4QsDJDu
         CWbEG1x+FXjNc3wXNLdlxSLUNhXHal+9Bihz8T9+AOAbYRyigTAjwUy4WkhvpNKnEM/k
         jryzA96BrZW219iTw92H6YIefiiMEIkv/MS5o2MxuI0uC74PMTo1RbwCxLaxWJN8Nf37
         Ks4cI6Wq6hl+484gkBWPMYG0kP/BMkwnxC3++yQbu/eJaF+jhlsqiiTX/YI1cYrG06XL
         iIFmajZL3VsSYIOCiHm0mN5las4/+JGo4TLnExEIeImDTHfVipLcgeZx08ypEHW1ALfD
         eIOA==
X-Gm-Message-State: AOAM533kzsLhFK9bR54kVwAV0wcu1Sgg64fHppl71YGDGgEn1N62rL6j
        ag3bfgivP/cqKsp/ZLbg7vQ=
X-Google-Smtp-Source: ABdhPJxHL/pTPbL/7t+qRgZYgaSboFBd/redJCVVhllPB9TFcyXiGz8/ZU9kOO1R4UBMsfNg2lRnEQ==
X-Received: by 2002:a05:6402:447:: with SMTP id p7mr1151040edw.261.1636394322131;
        Mon, 08 Nov 2021 09:58:42 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id h17sm11104339ede.38.2021.11.08.09.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 09:58:41 -0800 (PST)
Date:   Mon, 8 Nov 2021 18:58:38 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYllTn9W5tZLmVN8@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
 <YYlUSr586WiZxMn6@Ansuel-xps.localdomain>
 <20211108183537.134ee04c@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211108183537.134ee04c@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 06:35:37PM +0100, Marek Behún wrote:
> Dear Ansuel,
> 
> On Mon, 8 Nov 2021 17:46:02 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > > what is the purpose of adding trigger_offload() methods to LED, if you
> > > are not going to add support to offload the netdev trigger? That was
> > > the entire purpose when I wrote that patch.  
> > 
> > But the final step was adding LEDs support for PHY. The idea was to find
> > a clean way by passing the idea of offloading a trigger... But fact is
> > that LEDs in PHY operate by themself so it would add overhead selecting
> > a trigger that will use event/works just to then be ignored as the
> > trigger is offloaded.
> 
> I don't understand what kind of overhead in events/works are you
> talking about. If the trigger is successfully offloaded, there are no
> events/works. Everything is done in hardware. If you look at my last
> attempt
>   https://lore.kernel.org/linux-leds/20210601005155.27997-5-kabel@kernel.org/
> which adds the offloading support to netdev trigger, you can see
> 
>   if (!led_trigger_offload(led_cdev))
>     return;
> 
> so if the trigger is succesfully offloaded, the subsequen
> schedule_delayed_work() is not called and netdev trigger does not do anything.
> The blinking of the LED on rx/tx activity is done purely in hardware.
> No software overhead.
> 
> > Also I think we are missing the fact that most of PHY can operate in
> > software or in hardware. NOT BOTH. So the entire concept of offloading
> > some trigger won't work as we were not able to simulate with SW
> > unsupported trigger. (not the case with netdev as it does only support
> > link, rx/tx but that was to explain the concept that SW and HW mode are
> > mutually exclusive.)
> 
> I am not missing this fact, I know that there are LEDs that cannot be
> set into purely SW mode. Which brings another problem: Pavel currely
> isn't convinced that these LEDs should be exported via LED classdev
> API. We need to persuade him about this, because otherwise we would
> need to create another subsystem for this.
> 
> But there are PHYs which do allow purely SW LED control, i.e. I can set
> the LED to be just ON or OFF. These are for example marvell PHYs.
> 
> The fact that there are LEDs that can't be controlled purely in SW does
> not seem a good reason for to not implement it via netdev trigger.
> 
> Either these LEDs shouldn't be exported as LED classdevs, or they
> should somehow make use of existing trigger API (so netdev).
> 
> The fact that the LED cannot be controlled in SW can be simply
> implemented by refusing to disable the netdev trigger on the LED.
>

Are you aware of any device that can have some trigger offloaded and
still have the led triggered manually? Talking about mixed mode, so HW
and SW. Asking to understand as currently the only way to impement all
of this in netdev trigger is that:
IF any hw offload trigger is supported (and enabled) then the entire
netdev trigger can't work as it won't be able to simulate missing
trigger in SW. And that would leave some flexibility.

We need to understand how to operate in this condition. Should netdev
detect that and ""hide"" the sysfs triggers? Should we report error?

> > > 
> > > If you just want to create a new trigger that will make the PHY chip do
> > > the blinking, there is no need at all for the offloading patch.
> > >   
> > 
> > Again the idea here is that a LED can offer a way to run by HW and then
> > a trigger configure them and enables the mode. I see the offload and
> > configure function needed anyway side from the implementation.
> 
> There is already LED private trigger API for this. You don't need
> offloading of existing trigger if you are going to create a new trigger
> anyway.
> 
> > > And you will also get a NACK from me and also Pavel (LED subsystem
> > > maintainer).
> > >   
> > 
> > Can we try to find a common way to introduce this?
> > 
> > > The current plan is to:
> > > - add support for offloading existing LED triggers to HW (LED
> > >   controllers (PHY chips, for example))
> > > - make netdev trigger try offloading itself to HW via this new API (if
> > >   it fails, netdev trigger will blink the LED in SW as it does now)  
> > 
> > Can't be done. If in HW mode, we should just declare a trigger not
> > supported in SW if we really want to follow the netdev expanding path.
> > But still that would mean filling the netdev trigger with extra code and
> > condition that will only apply in HW mode. At this point just create a
> > dedicated trigger.
> 
> The netdev trigger already needs to be expanded with extra code: it
> doesn't allow indicating different link types, for example.
> 
> For offloading, the extra code can be quite small. So I don't think
> this is an argument.
> 
> > We can consider introducing the same sysfs used by netdev trigger but
> > nothing else.
> 
> Not true.
> 
> > > - create LED classdevices in a PHY driver that have the offload()
> > >   methods implemented. The offload method looks at what trigger is
> > >   being enabled for the LED, and it if it is a netdev trigger with such
> > >   settings that are possible to offload, it will be offloaded.
> > > 
> > >   This whole thing makes use of the existing sysfs ABI.
> > >   So for example if I do
> > >     cd /sys/class/net/eth0/phydev/leds/<LED>
> > >     echo netdev >trigger
> > >     echo eth0 >device_name  
> > 
> > How would this work in HW mode? The PHY blink only with packet in his
> > port. We can't tell the PHY to HW blink based on an interface.
> > That is the main problem by using netdev for PHYs, netdev is flexible
> > but an offload trigger is not and would work only based on some
> > condition. We should hardcode the device_name in HW and again pollute
> > the netdev trigger more.
> 
> netdev trigger does not need to be poluted by this much. All this can be
> implemented by one callback to offload method, and everything else can
> be done in the LED driver itself.
> 
> > An idea would be add tons of check to netdev on every event to check the
> > interface but that wouldn't go against any offload idea? The system will
> > be loaded anyway with all these checks.
> 
> The checks are done only at the moment of configuring the trigger.
> Surely you don't see that as "loaded system".
> 
> > 
> > >     echo 1 >rx
> > >     echo 1 >tx
> > >   The netdev trigger is activated, and it calls the offload() method.
> > >   The offload() method is implemented in the PHY driver, and it checks
> > >   that it can offload these settings (blink on rx/tx), and will enable
> > >   this.
> > > - extend netdev trigger to support more settings:
> > >   - indicate link for specific link modes only (for example 1g, 100m)
> > >   - ...
> > > - extend PHY drivers to support offloading of these new settings
> > > 
> > > Marek  
> > 
> > The rest of the implementation is very similar. Except we just NOT use
> > netdev. And to me it does seems the most sane way to handle offload for
> > a LED. (considering the specific situation of a PHY)
> > 
> > From what I can see we have 2 path:
> > - Pollute netdev trigger to add entire different function for HW. (that
> >   will end up in complex condition and more load/overhead)
> > - Introduce a new way to entirely offload some triggers.
> 
> The check conditions would be all in LED driver (PHY driver in this
> case). The code could be a little complicated, but it only needs to be
> written once, and the PHY drivers can reuse it. netdev trigger is not
> polluted, only a few calls to offload() method are done.
> 
> > Could be that here I'm just using the wrong word and I should use
> > hardware instead offload. But considering we are offloading some trigger
> > (example rx/tx/link) it's not that wrong.
> > 
> > The thing is why trying to expand a trigger that will just remove some
> > flexibility when we can solve the problem at the source with some
> > additional API that currently we lack any support (leds can be
> > configured to run by hw) and some dedicated trigger that will do the
> > task in a cleaner way (and without adding extra load/overhead by really
> > offloading the task) ?
> 
> As I explained above, there is no extra load/overhead. The only thing
> that is extra is that netdev trigger gets a little more new code, but
> that is already needed anyway.
> > 
> > Again hope I didn't seem rude in this message but I just want to find a
> > solution and proposing a new idea/explaining my concern.
> > 
> 
> I don't think you're rude, we are just discussing a topic for which we
> have different opinions.
> 
> Marek

-- 
	Ansuel

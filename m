Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB7A449A37
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241382AbhKHQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbhKHQsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:48:53 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92468C061570;
        Mon,  8 Nov 2021 08:46:08 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ee33so65378881edb.8;
        Mon, 08 Nov 2021 08:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xedSQEVlSyClwNPGq+vnoJrO6xwzphOPk9rShXZEipU=;
        b=ajHDPEg4f5u74ihZizwSNQInMIJ7wQzjLf4dBOROK47Bklnhpa/jdiWQvZSZghjZtg
         Sg1uOvnH5O4sIZ04kqELHq1f1v35SQG07qaCONeufU6koQy3pQavKwIN1q08VnvcH8Pb
         F65NJPnOUE+PfLppm6cQ3xf9A6dkmVgTm8JC6ETUoCitH2zrGGTfeizTaSxNDHOxFWnS
         WBHM21Eyk5Zzr5zgqHfXvzNWdkVUgzqeFqfhjwq/Tk4yzrG7RydXCFiFMO8TshYCs9xi
         ToUO25dkHY5UYvfOxvqX7FdOOwNFuQMLXIYjyXnR6AsXjZ3qYHcesfc1hsv1gHEO93fh
         0hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xedSQEVlSyClwNPGq+vnoJrO6xwzphOPk9rShXZEipU=;
        b=enHixdh+i3CeoCiTo/V1Me2BZ0cysVcnU8Srt0+w+W3dzdNjWGIPl+QNgO8vTch1RZ
         JIVYJiXbrqxc++CLrc1fMcx6zqUsVQPYdTdrTZAOsmF/2hybcJ9jizzVkVHldfUbE4rn
         wyToHIyzqd3aYAxXMJZIKZjSU/H6RDNC6dZjL4vQPPvbbkSQkq8qvoEac049FaY2lMWt
         9Xn6OyGdfz4t3usUT048ZHsP2e1TfUqrHEggjdN8d+z34JNXaNwkWHZu6tH44vCjAqeI
         FyqsqgyBXCytakhGSl5e6GW+ioDwytSOwp2oDyA+hwJyCCIVAGIGLc0ElupYw1xCJnbe
         wkGg==
X-Gm-Message-State: AOAM5316pMnNarHsZAZQeS9Sv7H84PWIT+Jmi6ngU+Fav1PtoZ0ON/YD
        JJqiEYAyL3RjywA3DdcPvpg=
X-Google-Smtp-Source: ABdhPJxYa4lZ31Igbzz8yv6WdGm3jqWYy7AzbOgvc6oMlUHs2B+bclKC2TDV4MfEaPx9GD4gHJbWIw==
X-Received: by 2002:a17:907:6da9:: with SMTP id sb41mr872569ejc.88.1636389966860;
        Mon, 08 Nov 2021 08:46:06 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id hb36sm5993344ejc.73.2021.11.08.08.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 08:46:06 -0800 (PST)
Date:   Mon, 8 Nov 2021 17:46:02 +0100
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
Message-ID: <YYlUSr586WiZxMn6@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211108171312.0318b960@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 05:13:12PM +0100, Marek Behún wrote:
> On Mon, 8 Nov 2021 16:16:13 +0100
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > On Mon, Nov 08, 2021 at 03:04:23PM +0100, Andrew Lunn wrote:
> > > > +static inline int led_trigger_offload(struct led_classdev *led_cdev)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (!led_cdev->trigger_offload)
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	ret = led_cdev->trigger_offload(led_cdev, true);
> > > > +	led_cdev->offloaded = !ret;
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static inline void led_trigger_offload_stop(struct led_classdev *led_cdev)
> > > > +{
> > > > +	if (!led_cdev->trigger_offload)
> > > > +		return;
> > > > +
> > > > +	if (led_cdev->offloaded) {
> > > > +		led_cdev->trigger_offload(led_cdev, false);
> > > > +		led_cdev->offloaded = false;
> > > > +	}
> > > > +}
> > > > +#endif  
> > > 
> > > I think there should be two calls into the cdev driver, not this
> > > true/false parameter. trigger_offload_start() and
> > > trigger_offload_stop().
> > >   
> > 
> > To not add too much function to the struct, can we introduce one
> > function that both enable and disable the hw mode?
> 
> Dear Ansuel,
>

(just to make sure, I don't want to look rude, I just want this feature
finally introduced and supported since AFAIK many tried to add support
for LEDs in PHY but everyone failed. For a reason or another, too
specific, not generic...)

> what is the purpose of adding trigger_offload() methods to LED, if you
> are not going to add support to offload the netdev trigger? That was
> the entire purpose when I wrote that patch.

But the final step was adding LEDs support for PHY. The idea was to find
a clean way by passing the idea of offloading a trigger... But fact is
that LEDs in PHY operate by themself so it would add overhead selecting
a trigger that will use event/works just to then be ignored as the
trigger is offloaded.
Also I think we are missing the fact that most of PHY can operate in
software or in hardware. NOT BOTH. So the entire concept of offloading
some trigger won't work as we were not able to simulate with SW
unsupported trigger. (not the case with netdev as it does only support
link, rx/tx but that was to explain the concept that SW and HW mode are
mutually exclusive.)

> 
> If you just want to create a new trigger that will make the PHY chip do
> the blinking, there is no need at all for the offloading patch.
> 

Again the idea here is that a LED can offer a way to run by HW and then
a trigger configure them and enables the mode. I see the offload and
configure function needed anyway side from the implementation.

> And you will also get a NACK from me and also Pavel (LED subsystem
> maintainer).
> 

Can we try to find a common way to introduce this?

> The current plan is to:
> - add support for offloading existing LED triggers to HW (LED
>   controllers (PHY chips, for example))
> - make netdev trigger try offloading itself to HW via this new API (if
>   it fails, netdev trigger will blink the LED in SW as it does now)

Can't be done. If in HW mode, we should just declare a trigger not
supported in SW if we really want to follow the netdev expanding path.
But still that would mean filling the netdev trigger with extra code and
condition that will only apply in HW mode. At this point just create a
dedicated trigger.
We can consider introducing the same sysfs used by netdev trigger but
nothing else.

> - create LED classdevices in a PHY driver that have the offload()
>   methods implemented. The offload method looks at what trigger is
>   being enabled for the LED, and it if it is a netdev trigger with such
>   settings that are possible to offload, it will be offloaded.
> 
>   This whole thing makes use of the existing sysfs ABI.
>   So for example if I do
>     cd /sys/class/net/eth0/phydev/leds/<LED>
>     echo netdev >trigger
>     echo eth0 >device_name

How would this work in HW mode? The PHY blink only with packet in his
port. We can't tell the PHY to HW blink based on an interface.
That is the main problem by using netdev for PHYs, netdev is flexible
but an offload trigger is not and would work only based on some
condition. We should hardcode the device_name in HW and again pollute
the netdev trigger more.
An idea would be add tons of check to netdev on every event to check the
interface but that wouldn't go against any offload idea? The system will
be loaded anyway with all these checks.

>     echo 1 >rx
>     echo 1 >tx
>   The netdev trigger is activated, and it calls the offload() method.
>   The offload() method is implemented in the PHY driver, and it checks
>   that it can offload these settings (blink on rx/tx), and will enable
>   this.
> - extend netdev trigger to support more settings:
>   - indicate link for specific link modes only (for example 1g, 100m)
>   - ...
> - extend PHY drivers to support offloading of these new settings
> 
> Marek

The rest of the implementation is very similar. Except we just NOT use
netdev. And to me it does seems the most sane way to handle offload for
a LED. (considering the specific situation of a PHY)

From what I can see we have 2 path:
- Pollute netdev trigger to add entire different function for HW. (that
  will end up in complex condition and more load/overhead)
- Introduce a new way to entirely offload some triggers.

Could be that here I'm just using the wrong word and I should use
hardware instead offload. But considering we are offloading some trigger
(example rx/tx/link) it's not that wrong.

The thing is why trying to expand a trigger that will just remove some
flexibility when we can solve the problem at the source with some
additional API that currently we lack any support (leds can be
configured to run by hw) and some dedicated trigger that will do the
task in a cleaner way (and without adding extra load/overhead by really
offloading the task) ?

Again hope I didn't seem rude in this message but I just want to find a
solution and proposing a new idea/explaining my concern.

-- 
	Ansuel

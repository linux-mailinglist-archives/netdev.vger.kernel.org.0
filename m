Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C9F3DAE90
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhG2VyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhG2VyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:54:23 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F01C061765;
        Thu, 29 Jul 2021 14:54:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h14so8576450wrx.10;
        Thu, 29 Jul 2021 14:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F4d3Q+YX4hIMX5R3XCD6YoaHmVahtJNm+RGt6+Zd6JI=;
        b=t7vhmSyOaN289xlNIdXtsrypMpo792p2n8D+Mi6fc1g9HySzWzzGfjygirddqRbeZB
         zrgFQLPh/fXfr1vrqTHvg/u/hFbDZ4nLZQgjA4kzmlcNbqRkJCYFvH7AIXsrTGZ4hNYt
         jKNCZdw5WRKsoKLzFhcb4Z+GAgK2Bqo7Ccgrt/LU8hY6QNsTDMasR+i/HoS8C55Hqv3t
         JTjPmot1VxnhuuOsa3nf4E4Yq1+BRwhSgPJVF0WMG7DZzcQr3BDgKGjXnW11H3H8YYfG
         C6/9fnXF2Hgjsu7aZeFkbPduKXI9pL+5lyVRO7jtZui1H3LVoJCpz8T+UCfYD6+9NjRO
         ta8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F4d3Q+YX4hIMX5R3XCD6YoaHmVahtJNm+RGt6+Zd6JI=;
        b=ovpL+T5CZNPEZmTJ7f+w2AcGB54NeQYL2cXghdy2VqJpkj2NKp8i4pg5gOz15p1NC6
         d2KIvsqxoX6d9CaEnZj6au9gvrxastZlZddvQnVnDK5+Ww464ZdlxJigcwi5bLp3xEpm
         Su97HfGndpU3sUJlXeIrSn682nQE84DpoFMPLych0NLGZGYhiFw/36SmbC1dXpeN2dtS
         NYB02LfHHNlYPhgF00brYsLOea8tyjk0CDF50FH9So16Ho4n9krHy+EfDxDUz3yla0L5
         Mxhp1JRpplMBe3RPsf1QLAPXtMb0pgjpoDZyhfh2QefQ+Ms1owUSpEwEVUcn/pAA3ugX
         Z7gA==
X-Gm-Message-State: AOAM530tSh4r62mEzZF+UszKuC9nl4U0f0qqrpLyFv31nMeFRJr7RJb3
        e3HogfKone1Ecv6Q8WAcDuc=
X-Google-Smtp-Source: ABdhPJytGtwkDESVFQ5Ickb7Usvqw2Vyv7Ab33QCHshvMs7AJdvZdauSCtrJ3kSgiA1zlwqJVL21sA==
X-Received: by 2002:a5d:6d89:: with SMTP id l9mr6879001wrs.371.1627595657289;
        Thu, 29 Jul 2021 14:54:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:f500:c522:8bd8:579:4483? (p200300ea8f3af500c5228bd805794483.dip0.t-ipconnect.de. [2003:ea:8f3a:f500:c522:8bd8:579:4483])
        by smtp.googlemail.com with ESMTPSA id k9sm4792887wrc.6.2021.07.29.14.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 14:54:16 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, pavel@ucw.cz, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc> <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
 <20210729105901.35a73431@thinkpad>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <3495aa83-75eb-bb89-f3c8-f6f829f3d243@gmail.com>
Date:   Thu, 29 Jul 2021 23:54:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729105901.35a73431@thinkpad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.07.2021 10:59, Marek Behún wrote:
> Hello Heiner,
> 
> On Wed, 28 Jul 2021 22:43:30 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> Did we come to any conclusion?
>>
>> My preliminary r8169 implementation now creates the following LED names:
>>
>> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led0-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led0-0300
>> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led1-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led1-0300
>> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led2-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led2-0300
>>
>> I understood that LEDs should at least be renamed to r8169-0300::link-0
>> to link-2 Is this correct? Or do we have to wait with any network LED support
>> for a name discussion outcome?
> 
> I would expect some of the LEDs to, by default, indicate activity.
> So maybe look at the settings BIOS left, and if the setting is to
> indicate link, use the "link" function, and if activity, use the
> "activity" function? 
> 

The function may be changed by the user. Then what? Rename the LED device?
A typical use case is also that one LED indicates both, link and activity.

>> For the different LED modes I defined private hw triggers (using trigger_type
>> to make the triggers usable with r8169 LEDs only). The trigger attribute now
>> looks like this:
>>
>> [none] link_10_100 link_1000 link_10_100_1000 link_ACT link_10_100_ACT link_1000_ACT link_10_100_1000_ACT
>>
>> Nice, or? Issue is just that these trigger names really should be made a
>> standard for all network LEDs. I don't care about the exact naming, important
>> is just that trigger names are the same, no matter whether it's about a r8169-
>> or igc- or whatever network chip controlled LEDs.
> 
> This is how I at first proposed doing this, last year. But this is
> WRONG!
> 
> First, we do not want a different trigger for each possible
> configuration. We want one trigger, and then choose configuration via
> other sysfs file. I.e. a "hw" trigger, which, when activated, would
> create sysfs files "link" and "act", via which you can configure those
> options.
> 
> Second, we already have a standard LED trigger for network devices,
> netdev! So what we should do is use the netdev trigger, and offload
> blinking to the LED controller if it supports it. The problems with
> this are:
> 1. not yet implemented in upstream, see my latest version
>    https://lore.kernel.org/linux-leds/20210601005155.27997-1-kabel@kernel.org/
> 2. netdev trigger currently does not support all these different link
>    functions. We have these settings:
>      device_name: network interface name, i.e. eth0
>      link: 0 - do not indicate link
>            1 - indicate link (ON when linked)
>      tx: 0 - do not blink on transmit
>          1 - blink on transmit
>      rx: 0 - do not blink on receive
>          1 - blink on receive
>      interval: duration of LED blink in ms
> 
> I would like to extend netdev trigger to support different
> configurations. Currently my ideas are as follows:
> - a new sysfs file, "advanced", will show up when netdev trigger is
>   enabled (and if support is compiled in)
> - when advanced is set to 1, for each possible link mode (10base-t,
>   100base-t, 1000base-t, ...) a new sysfs directory will show up, and

This leads to new questions like: How do you know what the possible
link modes are? In a spare minute you could have a look at enum
ethtool_link_mode_bit_indices. Even with standard multi-gig hw
meanwhile you have: 10M, 100M, 1G, 2.5G, 5G, 10G.
Supposedly the information about possible link modes would have to be
stored in led_classdev so that it can generate the appropriate sysfs
directories during registration.

>   in each of these directories the following files:
>     rx, tx, link, interval, brightness
>     multi_intensity (if the LED is a multi-color LED)
>   and possibly even
>     pattern
> With this, the user can configure more complicated configurations:
> - different LED color for different link speeds
> - different blink speed for different link speeds
> And if some of the configurations are offloadable to the HW, the drivers
> can be written to support such offloading. (Maybe even add a read-only
> file "offloaded" to indicate if the trigger was offloaded.)
> 

For a fully hw-offloaded LED like in my case then more or less the only
benefit of led_classdev + netdev trigger is the unified location of
link speed + tx/rx attributes. The brightness attribute has no meaning
because brightness can't be controlled.
Overall quite some overhead for a small functionality. At least in a
simple case like mine I'd use custom attributes under the net_dev like
this if I had to invent something on my own:
led0/speed: where you can say: "echo +100 > led0/speed" to enable 100M link indication
led0/activity: bool

> I will work on these ideas in the following weeks and will sent
> proposals to linux-leds.
> 

I don't want to be the one always saying: Nice framework, but heh:
How about my special case xyz?

I understand that it can be a frustrating job, that needs quite some
patience, to create a framework that you consider to be clean and
that covers the needs of (almost) everybody. I failed with some early
attempts to establish RGB LED support using the HSV color model.

>> And I don't have a good solution for initialization yet. LED mode is whatever
>> BIOS sets, but initial trigger value is "none". I would have to read the
>> initial LED control register values, iterate over the triggers to find the
>> matching one, and call led_trigger_set() to properly set this trigger as
>> current trigger.
> 
> You can set led_cdev->default_trigger prior registering the LED. But
> this is moot: we do not want a different trigger for each PHY interface
> mode.
> 
> Marek
> 

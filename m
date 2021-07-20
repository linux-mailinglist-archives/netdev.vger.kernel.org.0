Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB33D035A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhGTUJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbhGTTsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:48:54 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413DDC061574;
        Tue, 20 Jul 2021 13:29:32 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l17-20020a05600c1d11b029021f84fcaf75so2214944wms.1;
        Tue, 20 Jul 2021 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=spHWMCWbLPdVVzt/OhadKjOndhFAjh0EyUZxrZ8+tk4=;
        b=J/s3gZLWHQ3mDwvqzIXrn7/G6UBtRgMd+I/Q5wWpwg0CuLK+3aMi87D9SLXQgvRSKG
         2P1pAoPY1zFqIsze7J+tOM8CKtC8EBvD6YP0w1c4A1dtRcdY0vfRwnMGMw6qbb/9k3iF
         jeBfnHI1C1Y9y/o9a6kQtZGhzkUS7NXgCSyrqpZokKbTwCeeomSTIf1LjO50CMf3f/iT
         +KVNN4fkE3wjHXbNf9RQqF+feakK2BHj4iWoy4HjFp/ZUBJidEV0vkRcv0f1+WUqppA8
         Dg5ckNxTmxEzDylGtfvZX4CKU/BahIUJOWJUqSBlftLJ1F4oGMBrxZwySYMEc0S/g/us
         SJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=spHWMCWbLPdVVzt/OhadKjOndhFAjh0EyUZxrZ8+tk4=;
        b=awsEu0vYWwAEufXyCqoCMBkrMHRUbBczddd/sWnItGRY9QQIKBvVlljt1hSpjxhJ/N
         4j2iod2op+gDb6ViTNbWb7MkHf2CtnS4FwUXrGG9bZ/Bd06AR/t0Z/rSHks/V6XQPUZz
         YBkz/Sfa5nt0sbVNQL66avSZ4ZhkeluDAQ85sUTkF6PcpWahdbdOnyFm4c6smlS9MuIy
         rIA2Kjlpizx/nVhJ/mWeGdF1wKTKqt5xLk6wbGHrnG2aYmFzgWHifTBhzLpnsSAt0U3U
         QyS26GXfoHahvyukNp/6Gy33Q414qnlAvy7xocD455URzu4ufxzk8XLbaW2fvI75+ruS
         o2ZQ==
X-Gm-Message-State: AOAM532H/C3g47qKW0hfqMHO/wO6jtwJoRh3ukcu7iJ+gyEa/PK+vjuw
        WzgneWEfdu3mtOH3tgIeyGaXThx0MfR6dg==
X-Google-Smtp-Source: ABdhPJx9G8NnvhuQsujtp1RHaA7bEIedOgoEhkAIROwiSYVSHt4CzJ8R9BjMfmi007+tD8OQsnC0bA==
X-Received: by 2002:a05:600c:4304:: with SMTP id p4mr28984202wme.93.1626812970500;
        Tue, 20 Jul 2021 13:29:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:5da4:4158:494a:5076? (p200300ea8f3f3d005da44158494a5076.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:5da4:4158:494a:5076])
        by smtp.googlemail.com with ESMTPSA id d67sm3878215wmd.9.2021.07.20.13.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 13:29:29 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com> <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com> <YPbu8xOFDRZWMTBe@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
Date:   Tue, 20 Jul 2021 22:29:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPbu8xOFDRZWMTBe@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.07.2021 17:42, Andrew Lunn wrote:
>> I checked the LED subsystem and didn't find a way to place the LED
>> sysfs files in a place other than /sys/class/leds. Maybe Pavel can
>> comment on whether I just missed something.
> 
> https://lwn.net/ml/linux-kernel/20200908000300.6982-1-marek.behun@nic.cz/
> 
> It comments the sys files appear under
> /sys/class/net/<ifname>/phydev/leds/. phydev is a symbolic link to the
> phy devices, provided by the phydev subsystem. So they are actually
> attached to the PHY device. And this appears to be due to:
> 
> 	ret = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);
> 
> The LEDs are parented to the phy device. This has the nice side affect
> that PHYs are not part of the network name space. You can rename the
> interface, /sys/class/net/<ifname> changes, but the symbolic link
> still points to the phy device.
> 
> When not using phydev, it probably gets trickier. You probably want
> the LEDs parented to the PCI device, and you need to follow a
> different symbolic link out of /sys/class/net/<ifname>/ to find the
> LED.
> 
> There was talk of adding an ledtool, which knows about these
> links. But i pushed for it to be added to ethtool. Until we get an
> implementation actually merged, that is academic.
> 
>> For r8169 I'm facing a similar challenge like Kurt. Most family
>> members support three LED's:
>> - Per LED a mode 0 .. 15 can be set that defines which link speed(s)
>>   and/or activity is indicated.
>> - Period and duty cycle for blinking can be controlled, but this
>>   setting applies to all three LED's.
> 
> Cross LED settings is a problem. The Marvell PHYs have a number of
> independent modes. Plus they have some shared modes which cross LEDs.
> At the moment, there is no good model for these shared modes.
> 
> We have to look at the trade offs here. At the moment we have at least
> 3 different ways of setting PHY LEDs via DT. Because each driver does
> it its own way, it probably allows full access to all features. But it
> is very unfriendly. Adopting Linux LEDs allows us to have a single
> uniform API for all these PHY LEDs, and probably all MAC drivers which
> don't use PHY drivers. But at the expense of probably not supporting
> all features of the hardware. My opinion is, we should ignore some of
> the hardware features in order to get a simple to use uniform
> interface for all LEDs, which probably covers the features most people
> are interested in anyway.
> 

Thanks for the hint, Andrew. If I make &netdev->dev the parent,
then I get:

ll /sys/class/leds/
total 0
lrwxrwxrwx 1 root root 0 Jul 20 21:37 led0 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led0
lrwxrwxrwx 1 root root 0 Jul 20 21:37 led1 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led1
lrwxrwxrwx 1 root root 0 Jul 20 21:37 led2 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led2

Now the (linked) LED devices are under /sys/class/net/<ifname>, but still
the primary LED devices are under /sys/class/leds and their names have
to be unique therefore. The LED subsystem takes care of unique names,
but in case of a second network interface the LED device name suddenly
would be led0_1 (IIRC). So the names wouldn't be predictable, and I think
that's not what we want.
We could use something like led0_<pci_id>, but then userspace would have
to do echo foo > /sys/class/net/<ifname>/led0*/bar, and that's also not
nice.

> 	Andrew
> 
Heiner

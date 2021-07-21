Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FF3D1336
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhGUPWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhGUPWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:22:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38684C061757;
        Wed, 21 Jul 2021 09:03:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id w13so1635678wmc.3;
        Wed, 21 Jul 2021 09:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BFihmPhDKn1OhO3mdovxiKJBe1gvrjecydHMmuTPY9g=;
        b=kwZtja13WI2/q4mfIvW5354h8ruJssSuAAkwaZVJoXVvABDwlFcqV2MOubIYc02FHc
         lQ8VHn4Gc4DaiOSmpU3OWG2jgdPeaSJ2jWTsjUa89eI3vRitLNfU9wUUUUje3CWExULl
         ZvuK7ne48qMjDS3d4dfGCqKoeTzfSQ1psjlQXNZj4wOZmKJ64CfsHb5CYYIT6GQfU+8G
         ikoO3yNl+a+ymUCUwGvBjNch0/aLwzo68cOCb6TyaBiDl0SrC0whslDPS8CbEPyLrxfQ
         Ic2ISDgdPZPjZRK/KEAZPLKSPKzxFsMnj+kNgGBjSPL00NHUVHM3BAOdR8zVtEJUBnZt
         b2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BFihmPhDKn1OhO3mdovxiKJBe1gvrjecydHMmuTPY9g=;
        b=eckybjKL24z7mvnW4nZpRxmuUyQYIOo28gi+/Z2aG2PQIH23QLzF/h5/87p3GXOpb8
         Gx3aajIEuKnk40wBxgKgi0KbsmoWvjP7/fmxP0xJ5EunJ0U2nBvLBGlMm4rtshuwFqMs
         NUBFGfPhcqjeNs2XrbNQmc4w3WnEegAOPZYTT5fM2gw5Tx3mG3aLnZBPv7MFsAdr/3Xr
         SNWgDrVpIR8iQS3dzikUziFiI0iFfqRRmEnL/pjxqKCZXjkfuAPocgf7XaXESuT95klw
         vNjRvtkw1xCZwqHThYtMifAmpRnQEEOd3vgXXRaKGkuQrJr301e/thtLPQeNNiHTeBx2
         ZS3A==
X-Gm-Message-State: AOAM532QuPhM1E4eLy/85zBf5G+GXZl4UDhEYcxMHBf3zwokdpsloEoH
        fskZ3qObBlRT5qHscfAkm9YC6YV1sf3dcA==
X-Google-Smtp-Source: ABdhPJzTPKwkPCR5cofqigN5E9PkljO644M51V1sUYdA+G2BVYFnQ1pn7IjR0rsVZH0TI2sCtRESDw==
X-Received: by 2002:a1c:7e53:: with SMTP id z80mr1829898wmc.153.1626883385552;
        Wed, 21 Jul 2021 09:03:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:b167:4d03:da2:9d58? (p200300ea8f3f3d00b1674d030da29d58.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:b167:4d03:da2:9d58])
        by smtp.googlemail.com with ESMTPSA id q72sm20352272wme.14.2021.07.21.09.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 09:03:04 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
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
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com> <YPgwr2MB5gQVgDff@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <0bf24356-0090-a2d7-cd77-40cf04e05097@gmail.com>
Date:   Wed, 21 Jul 2021 18:02:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPgwr2MB5gQVgDff@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.07.2021 16:35, Andrew Lunn wrote:
>> Thanks for the hint, Andrew. If I make &netdev->dev the parent,
>> then I get:
>>
>> ll /sys/class/leds/
>> total 0
>> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led0 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led0
>> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led1 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led1
>> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led2 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led2
>>
>> Now the (linked) LED devices are under /sys/class/net/<ifname>, but still
>> the primary LED devices are under /sys/class/leds and their names have
>> to be unique therefore. The LED subsystem takes care of unique names,
>> but in case of a second network interface the LED device name suddenly
>> would be led0_1 (IIRC). So the names wouldn't be predictable, and I think
>> that's not what we want.
> 
> We need input from the LED maintainers, but do we actually need the
> symbolic links in /sys/class/leds/? For this specific use case, not
> generally. Allow an LED to opt out of the /sys/class/leds symlink.
> 

The links are created here:

led_classdev_register_ext()
-> device_create_with_groups()
   -> device_add()
      -> device_add_class_symlinks()

So it seems we'd need an extension to the device core to support
class link opt-out.

> If we could drop those, we can relax the naming requirements so that
> the names is unique to a parent device, not globally unique.
> 
>     Andrew
> 
Heiner

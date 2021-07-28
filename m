Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AAF3D96F6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhG1Unq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1Unp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 16:43:45 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59726C061757;
        Wed, 28 Jul 2021 13:43:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b9so4050685wrx.12;
        Wed, 28 Jul 2021 13:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hDY8a9+YulZovD1fV5VMUXC/vYFqsiVrR0JnYVPv0mg=;
        b=u2gi3puc8KP1F+Arcf5trlknzrG/TBDWKZRTjyTrRot1ZdjZaye1AuYW1FOLdHJrVb
         jiDFNwNT/XCDVe0u6jQSFavGh/Y0b1op/2AHK8ZaN51r5pDGrGwfvRhl5Xw4aIzsquR5
         Blg23T9XSOhamUKsJX6Db6+FEd2kWfpEPHLjbsOliYaBc1sTiEviqmKZgF2hnLQCR3sN
         N4OHYIeGO0yaQHAB/Xle18ogci3gecTQg1WfCFpbju6ZvXc6/jM6U/oRt+/ips1bwOlo
         nL8KXjLO6ZYLzO787VnLzWtPUnhyHaBHVUTSy8tC6APGzdMAi7EI/ARr5pn1pa7x+Mnm
         A44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hDY8a9+YulZovD1fV5VMUXC/vYFqsiVrR0JnYVPv0mg=;
        b=JJDOISw85b9qlD/KzjXbbH9FknvWd8BdYV0hXiO25cvPVMeyhDkiiXfvLo8tdaIo7i
         OyDTa8cAurXiaWJpy9e/u2Qa/Ke7wpR+lNDiYeCTyF9lKnzHnhW4XYV3yfETifWdnTE6
         I/VcutiNdCnhV0PxRN0Go1Pe69oF3dvJkvLFnaWP9V5YptZEccIcqLQQvlY6R5A3hXr2
         kgKbHyll3buMANLEp/3Fi0H2rAUFX94sRoTFbPFg3uHKTKTtVL7tSSXcxxQATNaVaTdC
         etWamo3+SvfU4EFgX2K4VvsaarmEIsvTqIoINWBzzEk5V8orXV0OZGGKn0GfFdaqPtsf
         F/SA==
X-Gm-Message-State: AOAM533MgA4DExRadTMuO3ts+HDMPAhTEz4geiW9tYOPyPHJNoc9yRVB
        WWhnA17B6mMdKMOzaKuMiYI=
X-Google-Smtp-Source: ABdhPJxQpoQWRVI6V/UXDYlOffLzYjsJksx6FpHCYeVP3FI4+37SUD3E6aKFI57l8pT9jY8YBhZ7MQ==
X-Received: by 2002:adf:d225:: with SMTP id k5mr1183907wrh.10.1627505021993;
        Wed, 28 Jul 2021 13:43:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:f500:f8ab:a87f:5739:a681? (p200300ea8f3af500f8aba87f5739a681.dip0.t-ipconnect.de. [2003:ea:8f3a:f500:f8ab:a87f:5739:a681])
        by smtp.googlemail.com with ESMTPSA id g7sm6575648wmq.22.2021.07.28.13.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 13:43:41 -0700 (PDT)
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com>
Date:   Wed, 28 Jul 2021 22:43:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727183213.73f34141@thinkpad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.07.2021 18:32, Marek Behún wrote:
> Hi,
> 
> On Tue, 27 Jul 2021 17:53:58 +0200
> Michael Walle <michael@walle.cc> wrote:
> 
>>> If we used the devicename as you are suggesting, then for the two LEDs
>>> the devicename part would be the same:
>>>   ledA -> macA -> ethernet0
>>>   ledB -> phyB -> ethernet0
>>> although they are clearly on different MACs.  
>>
>> Why is that the case? Why can't both the MAC and the PHY request a 
>> unique name from the same namespace?
> 
> So all the network related devices should request a unique network
> relate device ID? Should also wireless PHY devices do this? WWAN modems?
> And all these should have the same template for devicename part withing
> /sys/class/leds? What should be the template for the devicename, if
> wireless PHYs and WWAN modems could also be part of this? It cannot be
> "ethernet" anymore.
> 
> It seems a better idea to me to just some nice identifier for the LED
> controller.
> 
>> As Andrew pointed out, the names in
>> /sys/class/leds don't really matter. Ok, it will still depend on the
>> probe order which might not be the case if you split it between ethmac
>> and ethphy.
> 
> Yes, the LED name does not matter. But the LED subsystem requires names
> in a specific format, this is already decided and documented, we are
> not going to be changing this. The only reasonable thing we can do now
> is to choose a sane devicename.
> 
>> Sorry, if I may ask stupid questions here. I don't want to cause much
>> trouble, here. I was just wondering why we have to make up two different
>> (totally unrelated names to the network interface names) instead of just
>> one (again totally unrelated to the interface name and index).
> 
> It seems more logical to me from kernel's point of view.
> 
>> But I was actually referring to your "you see the leds in /sys/ of all
>> the network adapters". That problem still persists, right?
> 
> Yes, this still persists. But we really do not want to start
> introducing namespaces to the LED subsystem.
> 
> Marek
> 

Did we come to any conclusion?

My preliminary r8169 implementation now creates the following LED names:

lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led0-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led0-0300
lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led1-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led1-0300
lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led2-0300 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led2-0300

I understood that LEDs should at least be renamed to r8169-0300::link-0
to link-2 Is this correct? Or do we have to wait with any network LED support
for a name discussion outcome?

For the different LED modes I defined private hw triggers (using trigger_type
to make the triggers usable with r8169 LEDs only). The trigger attribute now
looks like this:

[none] link_10_100 link_1000 link_10_100_1000 link_ACT link_10_100_ACT link_1000_ACT link_10_100_1000_ACT

Nice, or? Issue is just that these trigger names really should be made a
standard for all network LEDs. I don't care about the exact naming, important
is just that trigger names are the same, no matter whether it's about a r8169-
or igc- or whatever network chip controlled LEDs.

And I don't have a good solution for initialization yet. LED mode is whatever
BIOS sets, but initial trigger value is "none". I would have to read the
initial LED control register values, iterate over the triggers to find the
matching one, and call led_trigger_set() to properly set this trigger as
current trigger. Most likely this would need some LED core extensions:
- enable iterating over all triggers with a particular trigger_type
- enable triggers to have private data
Quite some hassle for a small functionality.

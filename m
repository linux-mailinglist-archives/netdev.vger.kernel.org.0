Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0544A7C7E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348351AbiBCANN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiBCANF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:13:05 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291F8C061714;
        Wed,  2 Feb 2022 16:13:05 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id 60so2323956uae.1;
        Wed, 02 Feb 2022 16:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WE3FYXRTMr8gOJmLUsaEWHu/a3/TwrsQlzVcgzMphfA=;
        b=mg64niYcH127JPOcCpr/FR82HX1axSD6dL7JzoCRYuBJcm0VQEAJeGSU1Mb1DesEJQ
         WM8mR0zhLSzRyCJwkGK+DFHPPh6fgmqJgSt9E08MxdvM0xhklwFted6V92Vd5DC2gz8L
         LJbAF+HvKXm5+Qroi+fmxdVrxG+aTpqkvu4M85V8XIysZlibR49kH0xhXGRx+nc+lELw
         2W0gWKgzOQGrBbEz9HZM21IjGIZYihG1ZGlLr0EyWUqbfu6Iyzkh25jqSRkujJCn72mM
         nw/d1iSXciQ8V+E0SJGVTB9tq12QBjy1XIjhcV+grA45ArrF8F3enV0TazJX3nPKHxZ/
         +shw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WE3FYXRTMr8gOJmLUsaEWHu/a3/TwrsQlzVcgzMphfA=;
        b=qeEt/Geb9sSX22L94Mhx8eqaFNpOiiOjitlN3r0ZZgHUUxqU7CFmIxjpNDkl5NFAWD
         Krpykhg6HohflkCczjAGwflQ+Wyv4Ez30HiuP/cgNCjKEgPrPfqZTR/FCNfhCYxt77AR
         wByGp1ZVp4a5N86UVHz/0VodQA2xojyU+l/jUdiwQD04nx0yILUKQZT4sdCgEWJcGV4W
         37GxJgznNlAawzP2FFdL8jfQlaOOW+Mcmr6Xy8jXgxIlm1tKyeVzrybG8oG3rNCDWQrd
         RTSShkkPaaUhKGBx9u7+m4+keR+4nRsnwrgBg5jcEgBHWfhZdKpM+C7JQO4Roh7cGV2b
         0t3Q==
X-Gm-Message-State: AOAM532z/6NCc0QMrNdxlsHAyVL16QTrt58/vUID9nrQZJswP0jEYHd6
        XEjtGsfiKFbba/2rfzqwql67BiRRuKJylcDpvK0=
X-Google-Smtp-Source: ABdhPJyJgz7aszskFOJordkOXOc3LoKIsu4htlxuiMFEfWJ7zH6EvyBkVNZnK1cz2/3ItBmbkr0afZdBGim1OcU5ubE=
X-Received: by 2002:a05:6102:2e3:: with SMTP id j3mr12767824vsj.32.1643847184135;
 Wed, 02 Feb 2022 16:13:04 -0800 (PST)
MIME-Version: 1.0
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de> <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de> <YfKCTG7N86yy74q+@kroah.com>
 <20220127120039.GE9150@pengutronix.de> <YfKcYXjfhVKUKfzY@kroah.com> <6ef3a2bbae4ae92943cc66972c945a6543706883.camel@pengutronix.de>
In-Reply-To: <6ef3a2bbae4ae92943cc66972c945a6543706883.camel@pengutronix.de>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 3 Feb 2022 03:12:59 +0300
Message-ID: <CAHNKnsR_Hr3WUVoUy1YZeYqJmOduH8c4OcLdkEzV3=UumXk1Sw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from device tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Jan 28, 2022 at 5:57 AM Lucas Stach <l.stach@pengutronix.de> wrote:
> Am Donnerstag, dem 27.01.2022 um 14:21 +0100 schrieb Greg KH:
>> On Thu, Jan 27, 2022 at 01:00:39PM +0100, Oleksij Rempel wrote:
>>> On Thu, Jan 27, 2022 at 12:30:20PM +0100, Greg KH wrote:
>>>> On Thu, Jan 27, 2022 at 12:23:05PM +0100, Oleksij Rempel wrote:
>>>>> On Thu, Jan 27, 2022 at 11:57:26AM +0100, Greg KH wrote:
>>>>>> On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
>>>>>>> Similar to the option to set a netdev name in device tree for switch
>>>>>>> ports by using the property "label" in the DSA framework, this patch
>>>>>>> adds this functionality to the usbnet infrastructure.
>>>>>>>
>>>>>>> This will help to name the interfaces properly throughout supported
>>>>>>> devices. This provides stable interface names which are useful
>>>>>>> especially in embedded use cases.
>>>>>>
>>>>>> Stable interface names are for userspace to set, not the kernel.
>>>>>>
>>>>>> Why would USB care about this?  If you need something like this, get it
>>>>>> from the USB device itself, not DT, which should have nothing to do with
>>>>>> USB as USB is a dynamic, self-describing, bus.  Unlike DT.
>>>>>>
>>>>>> So I do not think this is a good idea.
>>>>>
>>>>> This is needed for embedded devices with integrated USB Ethernet
>>>>> controller. Currently I have following use cases to solve:
>>>>> - Board with one or multiple USB Ethernet controllers with external PHY.
>>>>>   The PHY need devicetree to describe IRQ, clock sources, label on board, etc.
>>>>
>>>> The phy is for the USB controller, not the Ethernet controller, right?
>>>> If for the ethernet controller, ugh, that's a crazy design and I would
>>>> argue a broken one.  But whatever, DT should not be used to describe a
>>>> USB device itself.
>>>>
>>>>> - Board with USB Ethernet controller with DSA switch. The USB ethernet
>>>>>   controller is attached to the CPU port of DSA switch. In this case,
>>>>>   DSA switch is the sub-node of the USB device.
>>>>
>>>> What do you mean exactly by "sub node"?  USB does not have such a term.
>>>
>>> Here are some examples:
>>>
>>>   - |
>>>     usb@11270000 {
>>>         reg = <0x11270000 0x1000>;
>>
>> How can a USB device have a register?
>>
>> And what does 11270000 mean?
>>
>>
>>>         #address-cells = <1>;
>>>         #size-cells = <0>;
>>>
>>>         ethernet@1 {
>>>             compatible = "usb424,ec00";
>>>             reg = <1>;
>>>             label = "LAN0";
>>
>> Where did that come from?  That should be added in userspace, not from
>> the kernel.
>>
>>>         // there is no internal eeprom, so MAC address is taken from
>>>         // NVMEM of the SoC.
>>>             local-mac-address = [00 00 00 00 00 00];
>>>
>>>             mdio {
>>>             ethernet-phy@4 {
>>>                     reg = <4>;
>>>                     // Interrupt is attached to the SoC or the GPIO
>>>                     // controller of the same USB devices.
>>>                     interrupts-extended = <&gpio1 28 IRQ_TYPE_LEVEL_LOW>;
>>>                     // same about reset. It is attached to the SoC
>>>                     // or GPIO controller of the USB device.
>>>                     reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
>>>                     reset-assert-us = <10000>;
>>>                     reset-deassert-us = <1000>;
>>>                     // some external clock provider
>>>                     clocks = <&clk>
>>>                     qca,smarteee-tw-us-1g = <24>;
>>>                     qca,clk-out-frequency = <125000000>;
>>
>> So this device does not follow the spec for this driver in that you have
>> to get the values for the phy from DT and not the device itself?  Why
>> not fix the firmware in the device to report this?
>>
>> Anyway, this feels really wrong, USB should not be involved in DT by
>> virtue of how the bus was designed.
>
> While one can argue about the kind of information provided here, it is
> well defined how DT can augment the information about a device on a
> runtime discoverable bus like USB. There is even a DT binding that
> lists you as the maintainer of this standard:
> Documentation/devicetree/bindings/usb/usb-device.yaml
>
> USB is not special here, PCI has the same way for DT to augment runtime
> discovered device information and that is even covered by the ancient
> IEEE 1275 Open Firmware standard.

Not to defend this particular patch, but to talk about USB in general.

USB is not stable at all in terms of the run-time device number, but
USB is perfectly stable in terms of connection ports. If you traverse
from a host controller through a sequence of connection ports then you
reach the same device. As for PCI or any other bus. The document
referenced by Lucas shows this.

Moreover, USB specification even allows you to mark a device connected
to a particular hub port as non-detachable. What means that such a
device will be just a block on a PCB. And in this case, FDT becomes a
good (only?) option to store a subordinated device configuration.
E.g. as in Oleksij's example with a DSA switch that is connected to an
Ethernet MAC controller with the USB interface.

-- 
BR,
Sergey

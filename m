Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB98641EB37
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 12:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353519AbhJAKyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 06:54:53 -0400
Received: from mail.fris.de ([116.203.77.234]:43232 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352922AbhJAKye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 06:54:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 363A0BFC32;
        Fri,  1 Oct 2021 12:52:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633085567; h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=6pYBgI+8NKm6cyLCUDJZUxM0MC4KtCLVKARxH3IY6YI=;
        b=M34EetMd2A5fYceHKi9nBMFj8eGcgra/MGvCQfMERj4Z5QnBX0dWDT389Qm7xjJ+Vmp9tM
        znCbQlnNxfBuGI0x1pQlGe/3fhFEIOx9XuiOAwkepLrrQG6Sg/iaLfi8AFLExiFqiNJzwM
        9Q7DoZcGcKo8cd2vjAsSlvdPcUO6EJz3KlxeenB7DBeSFdJz+0qDCyH/vY9UU/+x77Rvni
        zgCNzrFe2zYnGB7PEysknu/M7lmdCJIx6lk63DgSwiq/P2NX2IpC+0Vms9DAMHKdz85j00
        FA35Gdq532c7H4X7nJTjoyElqcSbDYNTHjqvO0Y+XIB5p4POk+dY/5VmVWabhQ==
Message-ID: <25f24602-e3b4-197f-338b-167b67308f2c@fris.de>
Date:   Fri, 1 Oct 2021 12:52:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 1/3] net: phy: mscc: Add possibilty to disable combined
 LED mode
Content-Language: en-GB
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        linux-leds@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
References: <20210930125747.2511954-1-frieder@fris.de>
 <YVZQuIr2poOfWvcO@lunn.ch> <18de5e10-f41f-0790-89c8-3a70d48539be@kontron.de>
 <20211001120952.6be6bb36@thinkpad>
From:   Frieder Schrempf <frieder@fris.de>
In-Reply-To: <20211001120952.6be6bb36@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On 01.10.21 12:09, Marek Behún wrote:
> On Fri, 1 Oct 2021 11:20:36 +0200
> Frieder Schrempf <frieder.schrempf@kontron.de> wrote:
> 
>> On 01.10.21 02:05, Andrew Lunn wrote:
>>> On Thu, Sep 30, 2021 at 02:57:43PM +0200, Frieder Schrempf wrote:
>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>>
>>>> By default the LED modes offer to combine two indicators like speed/link
>>>> and activity in one LED. In order to use a LED only for the first of the
>>>> two modes, the combined feature needs to be disabled.
>>>>
>>>> In order to do this we introduce a boolean devicetree property
>>>> 'vsc8531,led-[N]-combine-disable' and wire it up to the matching
>>>> bits in the LED behavior register.
>>>
>>> Sorry, but no DT property. Each PHY has its own magic combination of
>>> DT properties, nothing shared, nothing common. This does not scale.
>>>
>>> Please look at the work being done to control PHY LEDs using the Linux
>>> LED infrastructure. That should give us one uniform interface for all
>>> PHY LEDs.
>>
>> +Cc: Marek
>>
>> I guess you are referring to this: [1]?
>>
>> If so, the last version I could find is a year old now. Is anyone still
>> working on this?
> 
> Yes, I am still working on this.
> 
> Anyway the last version is not one year old, the last version to add
> this support is 4 months old:
> https://lore.kernel.org/netdev/20210602144439.4d20b295@dellmb/T/

Thanks for pointing out the latest patches. Good to know that you are 
still working on this.

> 
> This version does not add the code for ethernet PHYs, instead it just
> tries to touch only the LED subsystem by adding the API for offloading
> LED triggers and an example implementation for Turris Omnia LED
> controller.
> 
> I will probably send another version this weekend. Sorry this takes
> this long.

No worries, and thanks for the work!

> 
> 
>> I understand, that the generic approach is the one we want to have, but
>> does this really mean adding PHY led configuration via DT to existing
>> drivers (that already use DT properties for LED modes) is not accepted
>> anymore, even if the new API is not yet in place?
> 
> I don't know about Rob, but I would be against it.
> 
> But if you need to have your PHY LED configured with via devicetree
> ASAP, instead of proposing the vendor specific property, you can
> propose LED subnodes and properties that will be generic and compatible
> with the LED subsystem API, i.e. something like:
> 
>    ethernet-phy@1 {
>      .... eth phy properties;
> 
>      leds {
>        led@0 {
>          reg = <0>;
>          color = <LED_COLOR_ID_GREEN>;
>          /* this LED should indicate link/speed */
>          function = LED_FUNCTION_LINK;
>        };
>      };
>    }
> 
> Then make your PHY driver parse this, and make it so that if
> function is LED_FUNCTION_LINK or LED_FUNCTION_ACTIVITY, the driver will
> disable combined mode.
> 
> Afterwards, when LED subsystem has support for trigger offloading, you
> can update mscc driver so that instead of just disabling combined mode,
> it will register the LEDs via LED subsystem...

Good idea, but I'm not really in a hurry. Now knowing that work on the 
trigger offloading is still active, I guess I will just wait a bit until 
the dust has settled and maybe the bindings have been defined. Then I 
can try to implement this in the PHY driver.

Thanks
Frieder

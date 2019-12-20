Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4B5128258
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLTSqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:46:36 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44647 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfLTSqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:46:35 -0500
Received: by mail-ed1-f67.google.com with SMTP id bx28so9227115edb.11
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 10:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cDdg7DoZJFZqzJHHFLpI6OvgVvLpyyStfb5LoBy9tzc=;
        b=fwuMAp1XI0ydXxY4o3fDUjMMIlIaIvvxzjFKYiotfxrwisUajMqlfrgyWNYaqT+QKz
         vUdLtJjAxgkIKCt8Sm4wypU4syJJRomhRZj5OfBP8xWueqQ1zABYg5tEoQEel6Cn8FlM
         H7Bm4MxYDYEPx2CBEQ1J/zMEhYU399Z06kZkS/5AUDSHQEsmhpvHU66ivVp1/SXzsEnd
         G81Cx4OhA/YI0JGlbqlPXsBCZ2B5/muJIxmC7JPZZtn07A0Zq0gxmLeyRk7xx1FMmvUj
         WiB1m1jwCRnsqTRG2m8gEcHJ/zZujbcMQIXc7A0YQI11GVmwuvz3d872vntVf1lrAOzA
         MQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cDdg7DoZJFZqzJHHFLpI6OvgVvLpyyStfb5LoBy9tzc=;
        b=jvBCn4Gw420FZHdT2V1ZIpjc8DlIuvel2mSX7Wi+HWTAImXLh7fRsGPQyRHZ3U1LlL
         +hFakL4GuKbx8NL40zyehFxIkJCeClH8eBGS5dHZr/I9/1kGKpere8omuYFweeLPRW62
         dvV9d3cay8JIH4H3EAGSoT2qESQrUSVkxFBCabbmFKQykn8cVB3/BAsnRg+JhjTP6Z0L
         csCG4rmvg26py2liR8b/ualsZIkNHcxsrgIi+OLSeTJRH3dHJhiFQONMLTvzlIp8dFJt
         oPuxW8bSBlgKwcGcOM9j9vGQU/kJEHvojzB8ZSeWFiyIgS3YvlQMIDpr7rxn4E3WDcpF
         dItg==
X-Gm-Message-State: APjAAAVScf3XJKrCLvtNeIKfdw8ZEfPugOkjlBXUkmW3mbNXXqCmsWWT
        nOWGhT8k7wIuFTsZKyQIdtYjZlGh
X-Google-Smtp-Source: APXvYqx8Es0/appcTZeowfsebIF1UdOM/odaIr0oBQeZCHXpFK7WvPPoFweTXseVoJJPgsTNlx4wOg==
X-Received: by 2002:a05:6402:305b:: with SMTP id bu27mr17788582edb.191.1576867593013;
        Fri, 20 Dec 2019 10:46:33 -0800 (PST)
Received: from [10.67.50.49] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 11sm1191160ejw.34.2019.12.20.10.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 10:46:32 -0800 (PST)
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
 <20191217233436.GS25745@shell.armlinux.org.uk>
 <61f23d43-1c4d-a11e-a798-c938a896ddb3@gmail.com>
 <20191218220908.GX25745@shell.armlinux.org.uk>
 <8f7411c7-f420-4a31-38ef-6a2af6c56675@gmail.com>
 <20191219170641.GB25745@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <c5d0ea8b-beb9-5306-7e87-23f6fd730a01@gmail.com>
Date:   Fri, 20 Dec 2019 10:46:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219170641.GB25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 9:06 AM, Russell King - ARM Linux admin wrote:
> On Thu, Dec 19, 2019 at 08:10:21AM +0100, Heiner Kallweit wrote:
>> On 18.12.2019 23:09, Russell King - ARM Linux admin wrote:
>>> On Wed, Dec 18, 2019 at 09:54:32PM +0100, Heiner Kallweit wrote:
>>>> On 18.12.2019 00:34, Russell King - ARM Linux admin wrote:
>>>>> On Tue, Dec 17, 2019 at 10:41:34PM +0100, Heiner Kallweit wrote:
>>>>>> On 17.12.2019 13:53, Russell King wrote:
>>>>>>> phy_error() is called from phy_interrupt() or phy_state_machine(), and
>>>>>>> uses WARN_ON() to print a backtrace. The backtrace is not useful when
>>>>>>> reporting a PHY error.
>>>>>>>
>>>>>>> However, a system may contain multiple ethernet PHYs, and phy_error()
>>>>>>> gives no clue which one caused the problem.
>>>>>>>
>>>>>>> Replace WARN_ON() with a call to phydev_err() so that we can see which
>>>>>>> PHY had an error, and also inform the user that we are halting the PHY.
>>>>>>>
>>>>>>> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
>>>>>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>>>>>>> ---
>>>>>>> There is another related problem in this area. If an error is detected
>>>>>>> while the PHY is running, phy_error() moves to PHY_HALTED state. If we
>>>>>>> try to take the network device down, then:
>>>>>>>
>>>>>>> void phy_stop(struct phy_device *phydev)
>>>>>>> {
>>>>>>>         if (!phy_is_started(phydev)) {
>>>>>>>                 WARN(1, "called from state %s\n",
>>>>>>>                      phy_state_to_str(phydev->state));
>>>>>>>                 return;
>>>>>>>         }
>>>>>>>
>>>>>>> triggers, and we never do any of the phy_stop() cleanup. I'm not sure
>>>>>>> what the best way to solve this is - introducing a PHY_ERROR state may
>>>>>>> be a solution, but I think we want some phy_is_started() sites to
>>>>>>> return true for it and others to return false.
>>>>>>>
>>>>>>> Heiner - you introduced the above warning, could you look at improving
>>>>>>> this case so we don't print a warning and taint the kernel when taking
>>>>>>> a network device down after phy_error() please?
>>>>>>>
>>>>>> I think we need both types of information:
>>>>>> - the affected PHY device
>>>>>> - the stack trace to see where the issue was triggered
>>>>>
>>>>> Can you please explain why the stack trace is useful.  For the paths
>>>>> that are reachable, all it tells you is whether it was reached via
>>>>> the interrupt or the workqueue.
>>>>>
>>>>> If it's via the interrupt, the rest of the backtrace beyond that is
>>>>> irrelevant.  If it's the workqueue, the backtrace doesn't go back
>>>>> very far, and doesn't tell you what operation triggered it.
>>>>>
>>>>> If it's important to see where or why phy_error() was called, there
>>>>> are much better ways of doing that, notably passing a string into
>>>>> phy_error() to describe the actual error itself.  That would convey
>>>>> way more useful information than the backtrace does.
>>>>>
>>>>> I have been faced with these backtraces, and they have not been at
>>>>> all useful for diagnosing the problem.
>>>>>
>>>> "The problem" comes in two flavors:
>>>> 1. The problem that caused the PHY error
>>>> 2. The problem caused by the PHY error (if we decide to not
>>>>    always switch to HALTED state)
>>>>
>>>> We can't do much for case 1, maybe we could add an errno argument
>>>> to phy_error(). To facilitate analyzing case 2 we'd need to change
>>>> code pieces like the following.
>>>>
>>>> case a:
>>>> err = f1();
>>>> case b:
>>>> err = f2();
>>>>
>>>> if (err)
>>>> 	phy_error()
>>>>
>>>> For my understanding: What caused the PHY error in your case(s)?
>>>> Which info would have been useful for analyzing the error?
>>>
>>> Errors reading/writing from the PHY.
>>>
>>> The problem with a backtrace from phy_error() is it doesn't tell you
>>> where the error actually occurred, it only tells you where the error
>>> is reported - which is one of two different paths at the moment.
>>> That can be achieved with much more elegance and simplicity by
>>> passing a string into phy_error() to describe the call site if that's
>>> even relevant.
>>>
>>> I would say, however, that knowing where the error occurred would be
>>> far better information.
>>>
>> AFAICS PHY errors are typically forwarded MDIO access errors.
>> PHY driver callback implementations could add own error sources,
>> but from what I've seen they don't. Instead of the backtrace in
>> phy_error() we could add a WARN_ONCE() to __mdiobus_read/write.
>> Then the printed call chain should be more useful.
>> If somebody wants to analyze in more detail, he can switch on
>> MDIO access tracing.
> 
> I'm still not clear why you're so keen to trigger a kernel warning
> on one of these events.
> 
> Errors may _legitimately_ occur when trying to read/write a PHY. For
> example, it would be completely mad for the kernel to WARN and taint
> itself just because you've unplugged a SFP module just at the time
> that phylib is trying to poll the PHY on-board, and that caused an
> failure to read/write the PHY. You just need the right timing to
> trigger this.
> 
> When a SFP module is unplugged the three contacts that comprise the
> I2C bus (used for communicating with a PHY that may be there) and
> the pin that identifies that the module is present all break at about
> the same point in time (give or take some minor tolerances) so there
> is no way to definitively say "yes, the PHY is still present, we can
> talk to it" by testing something.
> 

For instance, here is a resume failure because of incorrect pinmuxing,
you can see that the piece of useful information is not from the stack
trace, but right under:

[   39.637976] ------------[ cut here ]------------
[   39.637995] WARNING: CPU: 0 PID: 29 at drivers/net/phy/phy.c:657
phy_error+0x34/0x6c
[   39.637998] Modules linked in:
[   39.638006] CPU: 0 PID: 29 Comm: kworker/0:1 Not tainted 5.5.0-rc2 #23
[   39.638007] Hardware name: Broadcom STB (Flattened Device Tree)
[   39.638013] Workqueue: events_power_efficient phy_state_machine
[   39.638015] Backtrace:
[   39.638021] [<4020df50>] (dump_backtrace) from [<4020e254>]
(show_stack+0x20/0x24)
[   39.638023]  r7:41ca90c8 r6:00000000 r5:60000153 r4:41ca90c8
[   39.638030] [<4020e234>] (show_stack) from [<40b98404>]
(dump_stack+0xb8/0xe4)
[   39.638035] [<40b9834c>] (dump_stack) from [<40226220>]
(__warn+0xec/0x104)
[   39.638038]  r10:ed7ab605 r9:4080ba38 r8:00000291 r7:00000009
r6:40da88ec r5:00000000
[   39.638039]  r4:00000000 r3:189dae12
[   39.638043] [<40226134>] (__warn) from [<402262f4>]
(warn_slowpath_fmt+0xbc/0xc4)
[   39.638045]  r9:00000009 r8:4080ba38 r7:00000291 r6:40da88ec
r5:00000000 r4:e9232000
[   39.638049] [<4022623c>] (warn_slowpath_fmt) from [<4080ba38>]
(phy_error+0x34/0x6c)
[   39.638051]  r9:41cb14b0 r8:fffffffb r7:e80d3400 r6:00000003
r5:e80d36dc r4:e80d3400
[   39.638055] [<4080ba04>] (phy_error) from [<4080ccc0>]
(phy_state_machine+0x114/0x1c0)
[   39.638056]  r5:e80d36dc r4:e80d36b0
[   39.638060] [<4080cbac>] (phy_state_machine) from [<40243ab4>]
(process_one_work+0x240/0x57c)
[   39.638063]  r8:00000000 r7:ed7ab600 r6:ed7a8040 r5:e90ff880 r4:e80d36b0
[   39.638065] [<40243874>] (process_one_work) from [<402442b0>]
(worker_thread+0x58/0x5f4)
[   39.638068]  r10:e9232000 r9:ed7a8058 r8:41c03d00 r7:00000008
r6:e90ff894 r5:ed7a8040
[   39.638069]  r4:e90ff880
[   39.638073] [<40244258>] (worker_thread) from [<4024b050>]
(kthread+0x148/0x174)
[   39.638076]  r10:e914be74 r9:40244258 r8:e90ff880 r7:e9232000
r6:00000000 r5:e9204e40
[   39.638077]  r4:e91940c0
[   39.638081] [<4024af08>] (kthread) from [<402010ac>]
(ret_from_fork+0x14/0x28)
[   39.638083] Exception stack(0xe9233fb0 to 0xe9233ff8)
[   39.638085] 3fa0:                                     00000000
00000000 00000000 00000000
[   39.638087] 3fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   39.638089] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   39.638092]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
r6:00000000 r5:4024af08
[   39.638093]  r4:e9204e40
[   39.638095] ---[ end trace 10eeee4f71649fc9 ]---
[   39.639134] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x64
returns -5
[   39.639139] PM: Device unimac-mdio-0:01 failed to resume: error -5


-- 
Florian

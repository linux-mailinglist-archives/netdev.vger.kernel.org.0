Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0751284DF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 23:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfLTW2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 17:28:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40235 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbfLTW2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 17:28:49 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so10835683wrn.7
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 14:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iPoMmyE1AD9IJ13NKw57GlXW3/kSC2f6S67CtosJn+Q=;
        b=WtE3F/JmQaurWAqd6p7K7u/vDBYMP1zqPsGbxpk767bpVMVTGo5OGIPzZFM/p5ZqDR
         +N0U89o47joIXOt9k+3kCxMCa8FPfi7U3RrgtpxckD64vLvVOgxUcv9LyexL2SbCNf10
         eXyxbZ9stgyNYLSSbhG7RaipYLowk7mAH+WajhAv+Kxi9Z+qn+AZ9YeRVBm36M6BZFPz
         eqAsi9COwBwFb3OaLc4nJobmqMnywaXbynyp16CWvETc0+jjfp/ginvi9DmPtwaEWEEc
         V0D7Y4qSmsCoLxDwWyVLCkfFr6Pl6orVUMutEoqd5fa0sDpgenuCwWSjD9rVtlOw/Pt1
         VpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iPoMmyE1AD9IJ13NKw57GlXW3/kSC2f6S67CtosJn+Q=;
        b=MCMq6ZlMVsVPJVV0L/AujpgdNy9/rTxTWL0FtG/GWhUTFjCMFhwKbAUX8jLd61uU+A
         B2nLNRGSaNxpWXxzII2cgp+molECh/IdSEjCirT9BovwrkQGcZORs/5rmS8saW14ilbx
         +YSGkMFFf9utbncYfydPov6c5qpLaMQoxe6NSPw3A19zl7v8ErCY9eM7lBPLXyHQ4uPQ
         91HMqPcytQyvQ+vCtJ536mIsZ6+lW4GIpnahLUlLz7IuKqHhO+TylI+2QHb+sJ8jC4HT
         ywK+kI14KTSKvRrXg086o2Qe6VKUFYY3xYP4g6DxwWFzni4LkLcJP72knd909iJR0TwJ
         +G7A==
X-Gm-Message-State: APjAAAX9s0dpBrRY9RMObqmt86tSLoR0qthENtUfsyyvth7qRpocC4dW
        odc/jBYFrHU69e/oLud5CVDmqnuj
X-Google-Smtp-Source: APXvYqzDsW7mtrj5hr/ZD4FpEMLpC9Fa+EKlG0AYHrg3prY8q1hFlDKTUblRnrvBqgRcqQbMsIJqwA==
X-Received: by 2002:adf:f052:: with SMTP id t18mr16995383wro.192.1576880925957;
        Fri, 20 Dec 2019 14:28:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:4c42:af33:8782:934b? (p200300EA8F4A63004C42AF338782934B.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:4c42:af33:8782:934b])
        by smtp.googlemail.com with ESMTPSA id t125sm8086982wmf.17.2019.12.20.14.28.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Dec 2019 14:28:45 -0800 (PST)
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
 <20191217233436.GS25745@shell.armlinux.org.uk>
 <61f23d43-1c4d-a11e-a798-c938a896ddb3@gmail.com>
 <20191218220908.GX25745@shell.armlinux.org.uk>
 <8f7411c7-f420-4a31-38ef-6a2af6c56675@gmail.com>
 <20191219170641.GB25745@shell.armlinux.org.uk>
 <c5d0ea8b-beb9-5306-7e87-23f6fd730a01@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ac9277e0-7141-a0ce-f516-cd596b00f10d@gmail.com>
Date:   Fri, 20 Dec 2019 23:28:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <c5d0ea8b-beb9-5306-7e87-23f6fd730a01@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.12.2019 19:46, Florian Fainelli wrote:
> On 12/19/19 9:06 AM, Russell King - ARM Linux admin wrote:
>> On Thu, Dec 19, 2019 at 08:10:21AM +0100, Heiner Kallweit wrote:
>>> On 18.12.2019 23:09, Russell King - ARM Linux admin wrote:
>>>> On Wed, Dec 18, 2019 at 09:54:32PM +0100, Heiner Kallweit wrote:
>>>>> On 18.12.2019 00:34, Russell King - ARM Linux admin wrote:
>>>>>> On Tue, Dec 17, 2019 at 10:41:34PM +0100, Heiner Kallweit wrote:
>>>>>>> On 17.12.2019 13:53, Russell King wrote:
>>>>>>>> phy_error() is called from phy_interrupt() or phy_state_machine(), and
>>>>>>>> uses WARN_ON() to print a backtrace. The backtrace is not useful when
>>>>>>>> reporting a PHY error.
>>>>>>>>
>>>>>>>> However, a system may contain multiple ethernet PHYs, and phy_error()
>>>>>>>> gives no clue which one caused the problem.
>>>>>>>>
>>>>>>>> Replace WARN_ON() with a call to phydev_err() so that we can see which
>>>>>>>> PHY had an error, and also inform the user that we are halting the PHY.
>>>>>>>>
>>>>>>>> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
>>>>>>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>>>>>>>> ---
>>>>>>>> There is another related problem in this area. If an error is detected
>>>>>>>> while the PHY is running, phy_error() moves to PHY_HALTED state. If we
>>>>>>>> try to take the network device down, then:
>>>>>>>>
>>>>>>>> void phy_stop(struct phy_device *phydev)
>>>>>>>> {
>>>>>>>>         if (!phy_is_started(phydev)) {
>>>>>>>>                 WARN(1, "called from state %s\n",
>>>>>>>>                      phy_state_to_str(phydev->state));
>>>>>>>>                 return;
>>>>>>>>         }
>>>>>>>>
>>>>>>>> triggers, and we never do any of the phy_stop() cleanup. I'm not sure
>>>>>>>> what the best way to solve this is - introducing a PHY_ERROR state may
>>>>>>>> be a solution, but I think we want some phy_is_started() sites to
>>>>>>>> return true for it and others to return false.
>>>>>>>>
>>>>>>>> Heiner - you introduced the above warning, could you look at improving
>>>>>>>> this case so we don't print a warning and taint the kernel when taking
>>>>>>>> a network device down after phy_error() please?
>>>>>>>>
>>>>>>> I think we need both types of information:
>>>>>>> - the affected PHY device
>>>>>>> - the stack trace to see where the issue was triggered
>>>>>>
>>>>>> Can you please explain why the stack trace is useful.  For the paths
>>>>>> that are reachable, all it tells you is whether it was reached via
>>>>>> the interrupt or the workqueue.
>>>>>>
>>>>>> If it's via the interrupt, the rest of the backtrace beyond that is
>>>>>> irrelevant.  If it's the workqueue, the backtrace doesn't go back
>>>>>> very far, and doesn't tell you what operation triggered it.
>>>>>>
>>>>>> If it's important to see where or why phy_error() was called, there
>>>>>> are much better ways of doing that, notably passing a string into
>>>>>> phy_error() to describe the actual error itself.  That would convey
>>>>>> way more useful information than the backtrace does.
>>>>>>
>>>>>> I have been faced with these backtraces, and they have not been at
>>>>>> all useful for diagnosing the problem.
>>>>>>
>>>>> "The problem" comes in two flavors:
>>>>> 1. The problem that caused the PHY error
>>>>> 2. The problem caused by the PHY error (if we decide to not
>>>>>    always switch to HALTED state)
>>>>>
>>>>> We can't do much for case 1, maybe we could add an errno argument
>>>>> to phy_error(). To facilitate analyzing case 2 we'd need to change
>>>>> code pieces like the following.
>>>>>
>>>>> case a:
>>>>> err = f1();
>>>>> case b:
>>>>> err = f2();
>>>>>
>>>>> if (err)
>>>>> 	phy_error()
>>>>>
>>>>> For my understanding: What caused the PHY error in your case(s)?
>>>>> Which info would have been useful for analyzing the error?
>>>>
>>>> Errors reading/writing from the PHY.
>>>>
>>>> The problem with a backtrace from phy_error() is it doesn't tell you
>>>> where the error actually occurred, it only tells you where the error
>>>> is reported - which is one of two different paths at the moment.
>>>> That can be achieved with much more elegance and simplicity by
>>>> passing a string into phy_error() to describe the call site if that's
>>>> even relevant.
>>>>
>>>> I would say, however, that knowing where the error occurred would be
>>>> far better information.
>>>>
>>> AFAICS PHY errors are typically forwarded MDIO access errors.
>>> PHY driver callback implementations could add own error sources,
>>> but from what I've seen they don't. Instead of the backtrace in
>>> phy_error() we could add a WARN_ONCE() to __mdiobus_read/write.
>>> Then the printed call chain should be more useful.
>>> If somebody wants to analyze in more detail, he can switch on
>>> MDIO access tracing.
>>
>> I'm still not clear why you're so keen to trigger a kernel warning
>> on one of these events.
>>
>> Errors may _legitimately_ occur when trying to read/write a PHY. For
>> example, it would be completely mad for the kernel to WARN and taint
>> itself just because you've unplugged a SFP module just at the time
>> that phylib is trying to poll the PHY on-board, and that caused an
>> failure to read/write the PHY. You just need the right timing to
>> trigger this.
>>

When the trace was added we didn't consider the fact that there may
me legitimate errors. And sure, WARNing just because a SFP has been
removed is inappropriate. Having said that I'm fine with removing the
trace. Then phy_error() should just be extended to also print the
errno of the failed operation and give a hint which operation failed.

>> When a SFP module is unplugged the three contacts that comprise the
>> I2C bus (used for communicating with a PHY that may be there) and
>> the pin that identifies that the module is present all break at about
>> the same point in time (give or take some minor tolerances) so there
>> is no way to definitively say "yes, the PHY is still present, we can
>> talk to it" by testing something.
>>
> 
> For instance, here is a resume failure because of incorrect pinmuxing,
> you can see that the piece of useful information is not from the stack
> trace, but right under:
> 
> [   39.637976] ------------[ cut here ]------------
> [   39.637995] WARNING: CPU: 0 PID: 29 at drivers/net/phy/phy.c:657
> phy_error+0x34/0x6c
> [   39.637998] Modules linked in:
> [   39.638006] CPU: 0 PID: 29 Comm: kworker/0:1 Not tainted 5.5.0-rc2 #23
> [   39.638007] Hardware name: Broadcom STB (Flattened Device Tree)
> [   39.638013] Workqueue: events_power_efficient phy_state_machine
> [   39.638015] Backtrace:
> [   39.638021] [<4020df50>] (dump_backtrace) from [<4020e254>]
> (show_stack+0x20/0x24)
> [   39.638023]  r7:41ca90c8 r6:00000000 r5:60000153 r4:41ca90c8
> [   39.638030] [<4020e234>] (show_stack) from [<40b98404>]
> (dump_stack+0xb8/0xe4)
> [   39.638035] [<40b9834c>] (dump_stack) from [<40226220>]
> (__warn+0xec/0x104)
> [   39.638038]  r10:ed7ab605 r9:4080ba38 r8:00000291 r7:00000009
> r6:40da88ec r5:00000000
> [   39.638039]  r4:00000000 r3:189dae12
> [   39.638043] [<40226134>] (__warn) from [<402262f4>]
> (warn_slowpath_fmt+0xbc/0xc4)
> [   39.638045]  r9:00000009 r8:4080ba38 r7:00000291 r6:40da88ec
> r5:00000000 r4:e9232000
> [   39.638049] [<4022623c>] (warn_slowpath_fmt) from [<4080ba38>]
> (phy_error+0x34/0x6c)
> [   39.638051]  r9:41cb14b0 r8:fffffffb r7:e80d3400 r6:00000003
> r5:e80d36dc r4:e80d3400
> [   39.638055] [<4080ba04>] (phy_error) from [<4080ccc0>]
> (phy_state_machine+0x114/0x1c0)
> [   39.638056]  r5:e80d36dc r4:e80d36b0
> [   39.638060] [<4080cbac>] (phy_state_machine) from [<40243ab4>]
> (process_one_work+0x240/0x57c)
> [   39.638063]  r8:00000000 r7:ed7ab600 r6:ed7a8040 r5:e90ff880 r4:e80d36b0
> [   39.638065] [<40243874>] (process_one_work) from [<402442b0>]
> (worker_thread+0x58/0x5f4)
> [   39.638068]  r10:e9232000 r9:ed7a8058 r8:41c03d00 r7:00000008
> r6:e90ff894 r5:ed7a8040
> [   39.638069]  r4:e90ff880
> [   39.638073] [<40244258>] (worker_thread) from [<4024b050>]
> (kthread+0x148/0x174)
> [   39.638076]  r10:e914be74 r9:40244258 r8:e90ff880 r7:e9232000
> r6:00000000 r5:e9204e40
> [   39.638077]  r4:e91940c0
> [   39.638081] [<4024af08>] (kthread) from [<402010ac>]
> (ret_from_fork+0x14/0x28)
> [   39.638083] Exception stack(0xe9233fb0 to 0xe9233ff8)
> [   39.638085] 3fa0:                                     00000000
> 00000000 00000000 00000000
> [   39.638087] 3fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [   39.638089] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [   39.638092]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
> r6:00000000 r5:4024af08
> [   39.638093]  r4:e9204e40
> [   39.638095] ---[ end trace 10eeee4f71649fc9 ]---
> [   39.639134] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x64
> returns -5
> [   39.639139] PM: Device unimac-mdio-0:01 failed to resume: error -5
> 
> 


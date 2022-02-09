Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495494B0135
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 00:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiBIX2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 18:28:23 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBIX2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 18:28:20 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFDAE055982
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 15:28:20 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id l19so1279194pfu.2
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 15:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PAWB6S6oKz18Nz5AwkPTG1Bmilhy71dnkX4UyxJAGJ0=;
        b=I78SihIYQzT3QGViEGtednscnWP88uoB8CTFfuKsPMnnPk7lGhqPrBjkl03XMZZ3mQ
         X4l/2aXqC9WQd70Hu9Y0HRgLha9EJCfYW23kml2OTRQ/HJwd+gELC1RFiXOKY+lL4nBi
         YngX08eXCfh8K9Af9E+U/kXd84uHzawluok96+TvIkx2MB62cJ0NwUvgwNloxOXJ74IJ
         wHXAzYyhAU8f6VP0HaG3gTryQMPbH1Jw7k9i4LtsVx7QKaZkvseXQTwzLs/0VqHOn0Vu
         gnSzHsWvy5tKhVdDXk+58vx6n2X0OM5e0DJbTEEY+wc4u+UgPwNULYaRNaaGIUI61GuL
         64xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PAWB6S6oKz18Nz5AwkPTG1Bmilhy71dnkX4UyxJAGJ0=;
        b=l4hDrXQYvWUBHf9FOlfS2lQIxSbD6OKGYq/M5JrsfTBuU6fNBws+O3BQmqd2M25QvH
         c5vcbZKlP/nljFKu3QDTH5przO8hSgpvFgZtn/RgtYc2ANML9bTwJS0ZFX/71y7UdeWI
         jcL97OR42uwAH9hRe9AgIjzM4nXdYM3YoIo8Zl5nMr6hU2NbuesVe5eL/uEBnMGyeo1J
         JLcgHkfGqnb8n7yFxYgp+Mm7pv25/C7wZhG1gSCuX9SRuOtCBIGRmnnxmndc4oODTCRw
         VY+E6/BKdVmMLMazE2RoNhbj5t9DGNSts+ntIU5KfhbC6mxD36NGeBVM2aYZMEmZfVKk
         +EdA==
X-Gm-Message-State: AOAM532Xz6CJGMVYqku4KvH+ggiJ8kho3AJHUsGjQMmMKyyYUd7DBwg3
        HglqEcKH+xFHxWwtOjv0RBhYo2NINuYL1VS7iyw=
X-Google-Smtp-Source: ABdhPJwmypDmrlagESN0OjIEn57POS054D1+FYjatqBmKfZo8+RVVTqJBWUWWivrbWO5T8Ng2rIdYZ4TG3BUs/yTlc4=
X-Received: by 2002:a05:6a00:170b:: with SMTP id h11mr4253950pfc.78.1644449299882;
 Wed, 09 Feb 2022 15:28:19 -0800 (PST)
MIME-Version: 1.0
References: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
 <878rukib4f.fsf@bang-olufsen.dk>
In-Reply-To: <878rukib4f.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 9 Feb 2022 20:28:08 -0300
Message-ID: <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
Subject: Re: net: dsa: realtek: silent indirect reg read failures on SMP
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'

> Hi Luiz,

Hi Alvin,

> Thanks very much for the bug report!

Thanks Alvin!

> > Arin=C3=A7 reported an issue with interfaces going down and up in a fix=
ed
> > interval (a little less than 40s). It happened with both SMI or MDIO
> > interfaces for two different rtl8365mb supported models.
>
> Is this using the Generic PHY driver or the Realtek RTL8365MB-VC PHY
> driver? If it's the latter then I would be interested to know whether
> the interrupt counters are going up too. Maybe the switch really has
> something to say?

Both are using 'Realtek RTL8365MB-VC PHY' but without interruptions.
In the mdio-connected device, the interrupt pin is not connected yet
(I suggested them to use it).
The other one is unknown if the pin is connected to a gpio port. I
suggested Arun=C3=A7 to export all available GPIO ports and check their
values with the interruption configured as both active high and low.
That's how I found the interrupt gpio in my device.
So, all affected SMP devices are using polling.

> I think the Generic PHY driver is based on polling of PHY registers,
> which seems more likely to trigger the issue you describe.

I didn't even know that 'Generic PHY' would work until yesterday when
I noticed I was missing the patch that added the phy_id.
Anyway, as I said, both drivers will work with polling while only
'RTL8365MB-VC PHY' can handle interruptions. It is not a good
indicator
whether it is using interruption or not. And MDIO also didn't support
interruption without a new patch I just sent.

https://patchwork.kernel.org/project/netdevbpf/patch/20220209224538.9028-1-=
luizluca@gmail.com/

> In any case, I think I can reproduce your issue. Using an SMI setup with
> just one cable attached to port 2, I did the following:
>
> 1. Enable ftrace event logging for regmap and mdio
> 2. Poll BSMR PHY register for my connected port; it should always read
>    the same (0x79ed).
> 3. Wait for 2 to read out something else.
>
> So I used this command:
>
>     while true; do phytool read swp2/2/0x01; sleep 0.1; done

I'll test it and report.

>
> After a couple of seconds I already read out 0x0000. And after checking
> the ftrace log I can see that this is because of some interleaved
> register access:
>
>      kworker/3:4-70      [003] .......  1927.139849: regmap_reg_write: et=
hernet-switch reg=3D1004 val=3Dbd
>          phytool-16816   [002] .......  1927.139979: regmap_reg_read: eth=
ernet-switch reg=3D1f01 val=3D0
>      kworker/3:4-70      [003] .......  1927.140381: regmap_reg_read: eth=
ernet-switch reg=3D1005 val=3D0
>          phytool-16816   [002] .......  1927.140468: regmap_reg_read: eth=
ernet-switch reg=3D1d15 val=3Da69
>      kworker/3:4-70      [003] .......  1927.140864: regmap_reg_read: eth=
ernet-switch reg=3D1003 val=3D0
>          phytool-16816   [002] .......  1927.140955: regmap_reg_write: et=
hernet-switch reg=3D1f02 val=3D2041
>      kworker/3:4-70      [003] .......  1927.141390: regmap_reg_read: eth=
ernet-switch reg=3D1002 val=3D0
>          phytool-16816   [002] .......  1927.141479: regmap_reg_write: et=
hernet-switch reg=3D1f00 val=3D1
>      kworker/3:4-70      [003] .......  1927.142311: regmap_reg_write: et=
hernet-switch reg=3D1004 val=3Dbe
>          phytool-16816   [002] .......  1927.142410: regmap_reg_read: eth=
ernet-switch reg=3D1f01 val=3D0
>      kworker/3:4-70      [003] .......  1927.142534: regmap_reg_read: eth=
ernet-switch reg=3D1005 val=3D0
>          phytool-16816   [002] .......  1927.142618: regmap_reg_read: eth=
ernet-switch reg=3D1f04 val=3D0
>          phytool-16816   [002] .......  1927.142641: mdio_access: SMI-0 r=
ead  phy:0x02 reg:0x01 val:0x0000
>      kworker/3:4-70      [003] .......  1927.143037: regmap_reg_read: eth=
ernet-switch reg=3D1001 val=3D0
>      kworker/3:4-70      [003] .......  1927.143133: regmap_reg_read: eth=
ernet-switch reg=3D1000 val=3D2d89
>      kworker/3:4-70      [003] .......  1927.143213: regmap_reg_write: et=
hernet-switch reg=3D1004 val=3Dbe
>      kworker/3:4-70      [003] .......  1927.143291: regmap_reg_read: eth=
ernet-switch reg=3D1005 val=3D0
>      kworker/3:4-70      [003] .......  1927.143368: regmap_reg_read: eth=
ernet-switch reg=3D1003 val=3D0
>      kworker/3:4-70      [003] .......  1927.143443: regmap_reg_read: eth=
ernet-switch reg=3D1002 val=3D6
>
> The kworker here is polling MIB counters for stats, as evidenced by the
> register 0x1004 that we are writing to (RTL8365MB_MIB_ADDRESS_REG).

At first I thought it was just two threads reading different indirect
registers. And there are really more than one kernel threads reading
port status in a SMP device.
If you disable the extra cores, it was working as expected. So, I
added a mutex to serialize that sequence. But it didn't fix the issue.
It looks like something deep down is broken.

> Sometimes I can even read out completely junk values if I tighten my
> phytool loop:
>
>     # while true; do phytool read swp2/2/0x01; done | uniq
>     0x79ed
>     0000
>     0x79ed
>     0000
>     0x79ed
>     0000
>     0x79ed
>     0x0014 <-- ?!

Yeah, just like what happens if you read that unused register. You
generally get 0x0000 instead of the good data but sometimes random
data.
I also added multiple udelay over and inside the regmap_read with no
success (while reading the unused register). I might test again with
phytool.

> This is just a preliminary investigation - I only checked your mail
> today - but I will follow up on this next week and try and make a
> fix. In the mean time could you and Arin=C3=A7 perhaps do some similar
> tracing and confirm that in your case it is a similar issue? You needn't
> use phytool if the issue reproduces itself every 40 seconds - in that
> case just enable ftrace events and inspect the register access sequence
> when a PHY read gives an unexpected value.

I'll try to enable ftrace but when I added a couple of printk, the
issue was gone.
Let's see what my device can handle.

The 40s is not a global cycle when everything falls apart. I added a
simple test that printed an error when the expected value wasn't
right. And each time a different port was failing in a fixed but
unsynchronized rhythm. Even with disconnected ports.
It looks like the switch "internal job queue" overflows and we get the
null or random data. And that gives the switch a little time to
process the queue. After that, the queue fills up again and we have
the same behavior. Accessing the unused register might simply consume
a lot of "extra loops". It looks like an exaggerated variant of the
same issue. Or not.

> Let's please restrict the investigation to registers which we expect to
> give well-defined values though - unused or otherwise inactive registers
> may very well give us junk, but it is harder to argue that this is a
> bug. Anyway, this seems pretty easy to reproduce, so I don't think you
> need to go down that path :-)

I also believe that we need to stick to registers that should return
good values. But while the indirect registers are failing, you can
also dump
some other switch registers and it should also return some junk data.
I didn't test it but I believe that's what will happen.

> Overall we probably need some stricter locking but I want to spend some
> time on this before just sending a big-fat-lock solution to the
> list. I didn't try your patch yet due to other items in my inbox today.

If nothing serializes the access to the indirect registers, the lock
is needed. Your traces show that two reads will collide.
The regmap also has its own lock by default and I also lock the mdio
during a regmap_read/write. I don't believe an extra lock will do.
I guess we'll need to slow the regmap access, although it wasn't enough for=
 me.

Maybe the switch is yelling an interruption we are ignoring. This is
another interesting thing to check.

---
Luiz

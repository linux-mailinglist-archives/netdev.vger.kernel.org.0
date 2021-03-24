Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224FB347D47
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhCXQHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbhCXQHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:07:12 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240DCC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 09:07:12 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b4so8831036lfi.6
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 09:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=6OTP6AYEcp0ThvqqZrl0u8pBJk8VQKM4rgfOg66QGaA=;
        b=12fFZCksmqtzZqa9vLrTrKpwT0zVBMdUpvwFtOEg3JYv18/yw2MimdIVqvhnxBa626
         iEGD7N7jgGO6VwnojNbb2zTOe0Bh/JbzSCaQcZQpXu3+IfOLxHoBuWkj2YL80pp1GLVj
         q++m+tMcZE5ncqb6FXRGfFsk8qGdmKqBz+0ggfMmypngdqD06j+S4SqgiC1qt8ApJt5/
         vJJW7l2/FTUop3TAZWImy5MwJ/5NRAW1IrvUstYf43IzmEfIiCSbYYamNzGLsEdI7cTe
         rI5AjR+zfy7KCvohnbGF+7jsGoGGSGMr9VjsgOrDoQ67FAAPtxVbepR0f4NcUwYG8EO2
         h/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6OTP6AYEcp0ThvqqZrl0u8pBJk8VQKM4rgfOg66QGaA=;
        b=f2jO7AODpnHSnSuw59LyxBn2vfrVlH9jhIbNJouSyIhzJrjsXPaXlHFNCu5gHqFLa0
         vil6i2Cf1JLjiARpfykuidbKST8Ht7qhTSDhWgeWhcQ/+5tzLcQafO++8KiprLQ60R5F
         6Zl38Lgc14eJ5vioiSaFdqUHWZ6uOFvud+q2l4IOf38IMRDAeHVZsaVSQ4aZtdxbnX6j
         KNLHGefLEdiEM5RoK6XNvtsRh8zDm2Bx0QP/LPgEQpKDqVapYlaa1LVYPzZ0ZiI6d/aD
         6argJSQE0Yu8IuAu5pS56+8zs3n3GfzY9XqU8RtYxBSk3k1RmAZA1gStr/ud7npanuG5
         KAnA==
X-Gm-Message-State: AOAM5319fCchcChZ5X2W6b1luM8kmq2jouzmAh57y2Fbml+jOitC5oiE
        1Ic6weRYLEMLz4bqztfrQSCm+o0a0+MH5k5z
X-Google-Smtp-Source: ABdhPJylMP4H+NQ/ACrjL1ExrGzgivB4SfFb6lQYRYKutn2wWjnH4xa+DCSW+qPgVUFD7bpKjsfpHg==
X-Received: by 2002:a05:6512:2192:: with SMTP id b18mr1011954lft.515.1616602030262;
        Wed, 24 Mar 2021 09:07:10 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id r23sm269879lfm.73.2021.03.24.09.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 09:07:09 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <20210324150807.f2amekt2jdcvqhhl@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <20210323113522.coidmitlt6e44jjq@skbuf> <87blbalycs.fsf@waldekranz.com> <20210323190302.2v7ianeuwylxdqjl@skbuf> <8735wlmuxh.fsf@waldekranz.com> <20210324140317.amzmmngh5lwkcfm4@skbuf> <87pmzolhlv.fsf@waldekranz.com> <20210324150807.f2amekt2jdcvqhhl@skbuf>
Date:   Wed, 24 Mar 2021 17:07:09 +0100
Message-ID: <87mtuslemq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 17:08, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 24, 2021 at 04:02:52PM +0100, Tobias Waldekranz wrote:
>> On Wed, Mar 24, 2021 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Tue, Mar 23, 2021 at 10:17:30PM +0100, Tobias Waldekranz wrote:
>> >> > I don't see any place in the network stack that recalculates the FCS if
>> >> > NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
>> >> > know how could the stack even tell a packet with bad FCS apart from one
>> >> > with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
>> >> > it's taken for granted as good.
>> >> 
>> >> Right, but there is a difference between a user explicitly enabling it
>> >> on a device and us enabling it because we need it internally in the
>> >> kernel.
>> >> 
>> >> In the first scenario, the user can hardly complain as they have
>> >> explicitly requested to see all packets on that device. That would not
>> >> be true in the second one because there would be no way for the user to
>> >> turn it off. It feels like you would end up in a similar situation as
>> >> with the user- vs. kernel- promiscuous setting.
>> >> 
>> >> It seems to me if we enable it, we are responsible for not letting crap
>> >> through to the port netdevs.
>> >
>> > I think there exists an intermediate approach between processing the
>> > frames on the RX queue and installing a soft parser.
>> >
>> > The BMI of FMan RX ports has a configurable pipeline through Next
>> > Invoked Actions (NIA). Through the FMBM_RFNE register (Rx Frame Next
>> > Engine), it is possible to change the Next Invoked Action from the
>> > default value (which is the hardware parser). You can choose to make the
>> > Buffer Manager Interface enqueue the packet directly to the Queue
>> > Manager Interface (QMI). This will effectively bypass the hardware
>> > parser, so DSA frames will never be sent to the error queue if they have
>> > an invalid EtherType/Length field.
>> >
>> > Additionally, frames with a bad FCS should still be discarded, as that
>> > is done by the MAC (an earlier stage compared to the BMI).
>> 
>> Yeah this sounds like the perfect middle ground. I guess that would then
>> be activated with an `if (netdev_uses_dsa(dev))`-guard in the driver,
>> like how Florian solved it for stmmac? Since it is not quite "rx-all".
>
> I think this would have to be guarded by netdev_uses_dsa for now, yes.
> Also, it is far from being a "perfect" middle ground, because if you
> disable the hardware parser, you also lose the ability to do frame
> classification and hashing/flow steering to multiple RX queues on that
> port, I think.

But even if the parser was enabled, it would never get anywhere since
the Ethertype would look like random garbage. Unless we have the soft
parser, but then it is not the middle ground anymore :)

I suppose you would like to test for netdev_uses_dsa_and_violates_8023,
that way you could still do RSS on DSA devices using regular 1Q-tags for
example. Do we want to add this property to the taggers so that we do
not degrade performance for any existing users?

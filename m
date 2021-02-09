Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581D0314E86
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBIL6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBIL5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:57:40 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84F2C06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 03:56:59 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id f2so21890198ljp.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 03:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+2vPllg638i7bZL/ckGFZ2O9Ryd2HDaaJ8+zMjONvJc=;
        b=Glov3sV1W5XM/v//oXnyHOBRT2Tj5BXllW9qOhxc/5F3wszh4BdaDP1vVXrHHBMXxY
         BGdrIuFcduDAfPCxg3t72C6yRlKJkHBbWYWvAWPsHAOOZMWWr3JAPJIC30FHRgqCT7R5
         ehFJaJjHHcsgmwszJHsZKuU40x19/bEOj7YO17SJVuHQwaeVO2fhde0r4aS8lP1V//Px
         P/mtk5iGk2wqNVRAus/anzQrzso51M8XuSwlP42cbnsr1uc7Vpa3GV+ufLrzQMy6/n7f
         3uXV5YsVx/2HyVGCizDvJZQUjNg764a/bz+A26MaM+kEtwgJfqDSR+Wxxvp58s3CPT0o
         OtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+2vPllg638i7bZL/ckGFZ2O9Ryd2HDaaJ8+zMjONvJc=;
        b=mEiBqtn9ffUqdMe3r5NNb3LJg39EXKnqPAQjqrzZO82jFU04FNDybrmAbFsIHAN73N
         b9TivSh3mrJTMLDb9xKxW+m/BCUIBEr/RNdDu5cPw4vxyX9nycmz6QoLMNOsMcll88ed
         ZxAuf+PxvOWIw94UGc9obD8dePVRnu+foykMTEmfFFC9Uet70rlTTeCYm24tP57m5vKk
         62DXWC/NDS7yPESK2ESYd178SPaLXEpFxzIHqIHx53J2wQcX1nV8zRxYESJKDlncKG3Z
         U1tZ0zhTKdEZeFfsbtXP/BRbJ62s+ED7vWTZP8G9vNWQFZJNP8eaW+fKo8ghpN+d6qwQ
         a+ZQ==
X-Gm-Message-State: AOAM533xLJAmUh2h3Gj52flm9o+GjG4kC8A01AbPrjlz1Qx/4RPEZTgL
        PsF/g2X467Jhfj6VxKK7Qtc2OQ==
X-Google-Smtp-Source: ABdhPJwo1RAjGZyXQvldYO/IGwX6wDH+pozZNHU1JbZ6cvp6u8L5hWK2M01dBPrz5uXWy0KiWSRFqA==
X-Received: by 2002:a2e:8654:: with SMTP id i20mr14117460ljj.362.1612871817208;
        Tue, 09 Feb 2021 03:56:57 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x1sm2439046ljh.62.2021.02.09.03.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 03:56:56 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
In-Reply-To: <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu> <20210203165458.28717-6-vadym.kochan@plvision.eu> <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87v9b249oq.fsf@waldekranz.com> <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 09 Feb 2021 12:56:55 +0100
Message-ID: <87pn194fp4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 13:05, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 08 Feb 2021 20:54:29 +0100 Tobias Waldekranz wrote:
>> On Thu, Feb 04, 2021 at 21:16, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Wed,  3 Feb 2021 18:54:56 +0200 Vadym Kochan wrote:  
>> >> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
>> >> 
>> >> The following features are supported:
>> >> 
>> >>     - LAG basic operations
>> >>         - create/delete LAG
>> >>         - add/remove a member to LAG
>> >>         - enable/disable member in LAG
>> >>     - LAG Bridge support
>> >>     - LAG VLAN support
>> >>     - LAG FDB support
>> >> 
>> >> Limitations:
>> >> 
>> >>     - Only HASH lag tx type is supported
>> >>     - The Hash parameters are not configurable. They are applied
>> >>       during the LAG creation stage.
>> >>     - Enslaving a port to the LAG device that already has an
>> >>       upper device is not supported.  
>> >
>> > Tobias, Vladimir, you worked on LAG support recently, would you mind
>> > taking a look at this one?  
>> 
>> I took a quick look at it, and what I found left me very puzzled. I hope
>> you do not mind me asking a generic question about the policy around
>> switchdev drivers. If someone published a driver using something similar
>> to the following configuration flow:
>> 
>> iproute2  daemon(SDK)
>>    |        ^    |
>>    :        :    : user/kernel boundary
>>    v        |    |
>> netlink     |    |
>>    |        |    |
>>    v        |    |
>>  driver     |    |
>>    |        |    |
>>    '--------'    |
>>                  : kernel/hardware boundary
>>                  v
>>                 ASIC
>> 
>> My guess is that they would be (rightly IMO) told something along the
>> lines of "we do not accept drivers that are just shims for proprietary
>> SDKs".
>> 
>> But it seems like if that same someone has enough area to spare in their
>> ASIC to embed a CPU, it is perfectly fine to run that same SDK on it,
>> call it "firmware", and then push a shim driver into the kernel tree.
>> 
>> iproute2
>>    |
>>    :               user/kernel boundary
>>    v
>> netlink
>>    |
>>    v
>>  driver
>>    |
>>    |
>>    :               kernel/hardware boundary
>>    '-------------.
>>                  v
>>              daemon(SDK)
>>                  |
>>                  v
>>                 ASIC
>> 
>> What have we, the community, gained by this? In the old world, the
>> vendor usually at least had to ship me the SDK in source form. Having
>> seen the inside of some of those sausage factories, they are not the
>> kinds of code bases that I want at the bottom of my stack; even less so
>> in binary form where I am entirely at the vendor's mercy for bugfixes.
>> 
>> We are talking about a pure Ethernet fabric here, so there is no fig
>> leaf of "regulatory requirements" to hide behind, in contrast to WiFi
>> for example.
>> 
>> Is it the opinion of the netdev community that it is OK for vendors to
>> use this model?
>
> I ask myself that question pretty much every day. Sadly I have no clear
> answer.

Thank you for your candid answer, really appreciate it. I do not envy
you one bit, making those decisions must be extremely hard.

> Silicon is cheap, you can embed a reasonable ARM or Risc-V core in the
> chip for the area and power draw comparable to one high speed serdes
> lane.
>
> The drivers landing in the kernel are increasingly meaningless. My day
> job is working for a hyperscaler. Even though we have one of the most
> capable kernel teams on the planet most of issues with HW we face
> result in "something is wrong with the FW, let's call the vendor".

Right, and being a hyperscaler probably at least gets you some attention
when you call your vendor. My day job is working for a nanoscaler, so my
experience is that we must be prepared to solve all issues in-house; if
we get any help from the vendor that is just a bonus.

> And even when I say "drivers landing" it is an overstatement.
> If you look at high speed anything these days the drivers cover
> multiple generations of hardware, seems like ~5 years ago most
> NIC vendors reached sufficient FW saturation to cover up differences
> between HW generations.
>
> At the same time some FW is necessary. Certain chip functions, are 
> best driven by a micro-controller running a tight control loop. 

I agree. But I still do not understand why vendors cling to the source
of these like it was their wallet. That is the beauty of selling
silicon; you can fully leverage OSS and still have a very straight
forward business model.

> The complexity of FW is a spectrum, from basic to Qualcomm. 
> The problem is there is no way for us to know what FW is hiding
> by just looking at the driver.
>
> Where do we draw the line? 

Yeah it is a very hard problem. In this particular case though, the
vendor explicitly said that what they have done is compiled their
existing SDK to run on the ASIC:

https://lore.kernel.org/netdev/BN6PR18MB1587EB225C6B80BF35A44EBFBA5A0@BN6PR18MB1587.namprd18.prod.outlook.com

So there is no reason that it could not be done as a proper driver.

> Personally I'd really like to see us pushing back stronger.

Hear, hear!

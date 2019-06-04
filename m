Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E4C351FD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFDVhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:37:34 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:38950 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:37:34 -0400
Received: by mail-pf1-f179.google.com with SMTP id j2so13477391pfe.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GVlAY4r+Sj3GOfMNJ8JGe2qVfSsSPK6RgNG7j0SVx4c=;
        b=ivgozN7sjBgVoc/A4JFmutE9Kqw0wXtqHkrXEGdTXxINohiAB33N9mtPsf+87Q9v9Z
         AjZn5CJGO8TyTYtvsssIYf4JRQbEDxJA8M2fHFCf6fHPoL8F7d+Ap6ZJzNPLrf4mXuQb
         KTP+fzeVy4w3rLFf+qzZS1Do9dRyzO0GnjjNsSRXGXO/zAaO1wC/gNu3beRerT2WeLyE
         dOgz92hT2pw5FUgT0e01ef6sMt1MmW2zZhUKs6/2EMpxwfayjNFkBFsIuO9jiWfD9xGG
         cwRbuogtW0iOD3ldLfgNfrJRCwAR0N3X5SIkzOo5e3L/3Z9YTmMCE2mQPD5xIfWRymmv
         Fs1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GVlAY4r+Sj3GOfMNJ8JGe2qVfSsSPK6RgNG7j0SVx4c=;
        b=oZCU91BXofkszAIUQ7OQ5sif8a4W8Gj80EeSo8/EdVtUWcQ5Bt+x4Etqfsot5OSQMr
         ZIIgd+e5O2ub6IXDPjIwpKWwNifa8ytywxH8QAI2/Yahk2CTroyH+DD0cJTIqNBXj2bi
         7zzwGXf25EqP9ExNV0MCJk3r9L0X2iCMV6rkpO3+nvqNL/5TC4ua5XP4SgZk8vt7hSAA
         XP/w1SKWL08z8u9RsbNU3t0bs/185raQZRxkF3D7PxCpt4mAsd52vDLRHAX1Ez/suGf2
         DQtLvzCJhifhK3gzVSJh95UP+oYaE1ulFHIhRgGg+/da3Rt0+uhbir3Dc1E124yySGdR
         e8sA==
X-Gm-Message-State: APjAAAXMNXdcR1XKvHPQjkG3rDsPdsxrMbBG8kKVEL/3Ojb5OKkQtGMS
        AKfe5dWvilKbg9LCOoVueBQ=
X-Google-Smtp-Source: APXvYqz9nixuMcv5voF4rSzKTpdAz6QEcyc2G0rOBE4qaA/Xm6CHQvvDDt0mxaucLPF17iBZoTGdWw==
X-Received: by 2002:a63:f957:: with SMTP id q23mr9854pgk.326.1559684253584;
        Tue, 04 Jun 2019 14:37:33 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i22sm18778097pfa.127.2019.06.04.14.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 14:37:32 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
 <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
Date:   Tue, 4 Jun 2019 14:37:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 2:29 PM, Vladimir Oltean wrote:
> On Wed, 5 Jun 2019 at 00:12, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>> But now the second question: between a phy_connect and a phy_start,
>>> shouldn't the PHY be suspended too? Experimentally it looks like it
>>> still isn't.
>>
>> This is not always clear cut. Doing auto-neg is slow. Some systems
>> want to get networking going as fast as possible. The PHY can be
>> strapped so that on power up it starts autoneg. That can be finished
>> by the time linux takes control of the PHY, and it can take over the
>> results, rather than triggering another auto-neg, which will add
>> another 3 seconds before the network is up.
>>
>> If we power the PHY down, between connect and start, we loose all
>> this.
>>
>> I don't remember anybody submitting patches because the PHY passed
>> frames to the MAC too early. So i don't think there is much danger
>> there.
>>
>>         Andrew
> 
> Hi Andrew,
> 
> Call me paranoid, but I think the assumption you're making is that
> every time you have an Ethernet link, you want it.
> Consider the case where you have an Ethernet switch brought up by
> U-boot (where it does dumb switching, with no STP, nothing) and the
> system power-cycles in a network with loops.
> If the operating system has no way to control whether the Ethernet
> ports are administratively up, anything can happen... I don't think
> it's a bad idea to err on the safe side here. Even in the case of a
> regular NIC, packets can go up quite a bit in the MAC, possibly even
> triggering interrupts on the cores, when the interface should have
> been otherwise "down".

The firmware/boot loader transition to a full fledged OS with a switch
is a tricky one to answer though, and there are no perfect answers
AFAICT. If your SW is totally hosed, you might want the switch to
forward traffic between all LAN ports (excluding WAN, otherwise you
expose your home devices to the outside world, whoops).

If your SW is fully operational, then the questions are:

- do you want a DSA like behavior in your boot loader, in that all ports
are separated but fully usable or do you want a dumb switch model where
any port can forward to the CPU/management port, without any tags or
anything (unmanaged mode)

- what happens during bootloader to OS handover, should the switch be
held in reset so as to avoid any possible indirect DMA into main memory
as much as power saving? Should nothing happen and let the OS wipe out
clean the setting left by the boot loader?

All of these are in the realm of policy and trade offs as far as
initializing/disruption goes, so there are no hard and fast answers.
-- 
Florian

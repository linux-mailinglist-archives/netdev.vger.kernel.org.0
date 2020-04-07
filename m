Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399421A0877
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 09:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgDGHi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 03:38:56 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:40940 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgDGHi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 03:38:56 -0400
Received: by mail-wm1-f42.google.com with SMTP id a81so708287wmf.5
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 00:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pr7q36LekD5HSs9VIgirNvVYbCgAxr6zMXHuJphM7LI=;
        b=sE1If181mgTtwZA10FzgX2xa7bUIzfba+NfZT8j6wEaomYyJj7Di9717G8aZqRXhdK
         XYf0Hhj+AjMM1VYoC4kI/Y0g+SRao+Cylq16+NsuHC1IV156oRjXaVUgOxl9zTGEbNek
         KiKcEQgMulHTzh9IWVDeRxJI0ns6gHpWaxegDFf6IdN9hcY0Yq/KPpVk9rZd/RCQaEhc
         Yl+BsYGlVM2fSmNnC1nBt/dF7pxJhvgiBbC1zhPrzw9W7wcvjOBtGFs/WZNgQg/MDJgo
         owR9+bujiE08ple5PKREpmhIl5cMyPLDPW9dpXK00nFxktAVzXBaXvMDEQKePwMrikLB
         J5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pr7q36LekD5HSs9VIgirNvVYbCgAxr6zMXHuJphM7LI=;
        b=ewdBMUlTMeodFLiWhAihIBJW9ExWk5Wy1eamu/VP4FuL6N79C8ZyBwijf6Sg+MhJGz
         f+zz8bc42e19DC2Zhf/u7rgeNkkMTaWH2C0khGRHOPqzo8BdHW1lEKADvXOrfx4GNNG9
         pPMTm8qqxKY52KiutKhfPR2MiUWcrj0rlzP1drTXYqkSf0K4usYfOVx1eOex282aBcYM
         mnjHj25Ai/YGKywf/WAw3CXTxANENDzM6iHUN7vCGIfUOsrNXP+WZTaEH+fiaEyMRCcr
         jrwFQLHelqcofAK2cAjJsTMPogwWm3e51rVORut3of1xyXDxiQIc4/QwlWof+0JOOhay
         MTIw==
X-Gm-Message-State: AGi0Pua/6CyvUDMiazHoLAYVuLHMA8UzSTB2zeayaOufdKUQCFOk2D+b
        yXl689g/7eehkfN3fkRoo/Zhgg==
X-Google-Smtp-Source: APiQypI3CSrAR2UP2GaLHHOlhA2DN45intu7mxCUFmXE1fqM8DVigxs8Kp36Rf17UtGrfC0iG9mexQ==
X-Received: by 2002:a1c:9912:: with SMTP id b18mr945706wme.76.1586245134057;
        Tue, 07 Apr 2020 00:38:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x11sm29053439wru.62.2020.04.07.00.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 00:38:53 -0700 (PDT)
Date:   Tue, 7 Apr 2020 09:38:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Changing devlink port flavor dynamically for DSA
Message-ID: <20200407073852.GF2354@nanopsycho.orion>
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
 <20200406180410.GB2354@nanopsycho.orion>
 <2efae9ae-8957-7d52-617a-848b62f5aca3@gmail.com>
 <20200406182002.GD2354@nanopsycho.orion>
 <176481d3-eeee-feae-095a-6a3023d986f5@gmail.com>
 <20200406190050.GE2354@nanopsycho.orion>
 <7e671174-a466-b8c8-64e6-d6ded3be37db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e671174-a466-b8c8-64e6-d6ded3be37db@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 06, 2020 at 09:52:03PM CEST, f.fainelli@gmail.com wrote:
>
>
>On 4/6/2020 12:00 PM, Jiri Pirko wrote:
>> Mon, Apr 06, 2020 at 08:41:25PM CEST, f.fainelli@gmail.com wrote:
>>>
>>>
>>> On 4/6/2020 11:20 AM, Jiri Pirko wrote:
>>>> Mon, Apr 06, 2020 at 08:11:18PM CEST, f.fainelli@gmail.com wrote:
>>>>>
>>>>>
>>>>> On 4/6/2020 11:04 AM, Jiri Pirko wrote:
>>>>>> Sun, Apr 05, 2020 at 10:42:29PM CEST, f.fainelli@gmail.com wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
>>>>>>> connect to separate Ethernet MACs that the host/CPU can control. In
>>>>>>> premise they are both interchangeable because the switch supports
>>>>>>> configuring the management port to be either 5 or 8 and the Ethernet
>>>>>>> MACs are two identical instances.
>>>>>>>
>>>>>>> The Ethernet MACs are scheduled differently across the memory controller
>>>>>>> (they have different bandwidth and priority allocations) so it is
>>>>>>> desirable to select an Ethernet MAC capable of sustaining bandwidth and
>>>>>>> latency for host networking. Our current (in the downstream kernel) use
>>>>>>> case is to expose port 5 solely as a control end-point to the user and
>>>>>>> leave it to the user how they wish to use the Ethernet MAC behind port
>>>>>>> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
>>>>>>> disabled. Port 5 of that switch does not make use of Broadcom tags in
>>>>>>> that case, since ARL-based forwarding works just fine.
>>>>>>>
>>>>>>> The current Device Tree representation that we have for that system
>>>>>>> makes it possible for either port to be elected as the CPU port from a
>>>>>>> DSA perspective as they both have an "ethernet" phandle property that
>>>>>>> points to the appropriate Ethernet MAC node, because of that the DSA
>>>>>>> framework treats them as CPU ports.
>>>>>>>
>>>>>>> My current line of thinking is to permit a port to be configured as
>>>>>>> either "cpu" or "user" flavor and do that through devlink. This can
>>>>>>> create some challenges but hopefully this also paves the way for finally
>>>>>>> supporting "multi-CPU port" configurations. I am thinking something like
>>>>>>> this would be how I would like it to be configured:
>>>>>>>
>>>>>>> # First configure port 8 as the new CPU port
>>>>>>> devlink port set pci/0000:01:00.0/8 type cpu
>>>>>>> # Now unmap port 5 from being a CPU port
>>>>>>> devlink port set pci/0000:01:00.0/1 type eth
>>>>>>
>>>>>> You are mixing "type" and "flavour".
>>>>>>
>>>>>> Flavours: cpu/physical. I guess that is what you wanted to set, correct?
>>>>>
>>>>> Correct, flavor is really what we want to change here.
>>>>>
>>>>>>
>>>>>> I'm not sure, it would make sense. The CPU port is still CPU port, it is
>>>>>> just not used. You can never make is really "physical", am I correct? 
>>>>>
>>>>> True, although with DSA as you may know if we have a DSA_PORT_TYPE_CPU
>>>>> (or DSA_PORT_TYPE_DSA), then we do not create a corresponding net_device
>>>>> instance because that would duplicate the Ethernet MAC net_device. This
>>>>> is largely the reason for suggesting doing this via devlink (so that we
>>>>> do not rely on a net_device handle). So by changing from a
>>>>> DSA_PORT_TYPE_CPU flavor to DSA_PORT_TYPE_USER, this means you would now
>>>>> see a corresponding net_device instance. Conversely when you migrate
>>>> >from DSA_PORT_TYPE_USER to DSA_PORT_TYPE_CPU, the corresponding
>>>>> net_device would be removed.
>>>>
>>>> Wait, why would you ever want to have a netdevice for CPU port (changed
>>>> to "user")? What am I missing? Is there a usecase, some multi-person
>>>> port?
>>>>
>>>
>>> I believe I explained the use case in my first email. The way the Device
>>> Tree description is currently laid out makes it that Port 5 gets picked
>>> up as the CPU port for the system. This is because the DSA layer stops
>>> whenever it encounters the first "CPU" port, which it determines by
>>> having an "ethernet" phandle (reference) to an Ethernet MAC controller node.
>>>
>>> The Ethernet MAC controller behind Port 5 does not have the necessary
>>> bandwidth allocation at the memory controller level to sustain Gigabit
>>> traffic with 64B packets. Instead we want to use Port 8 and the Ethernet
>>> MAC connected to it which has been budgeted to support that bandwidth.
>>>
>>> The reason why we want to have a representor (DSA_PORT_TYPE_USER) for
>>> port 5 of the switch is also because we need to set-up Compact Field
>>> Processor (CFP) rules which need to identify specific packets ingressing
>>> a specific port number and to be redirected towards another port (7) for
>>> audio/video streaming processing. The interface to configure CFP is
>>> currently ethool::rxnfc and that requires a net_device handle,
>>> cls_flower would be the same AFAICT.
>> 
>> But if you don't use port 5 as CPU port, you don't use if for anything.
>> Okay, you say that you need it for ethtool setup. But can't you use
>> other netdevs of another port (physical port) for that?
>
>Not really, the net_device gives you the physical port number, and there
>is no way for the user to specify something different. It would also be
>utterly confusing that you used whatever net_device exists to configure
>an ingress matching rule to another physical port...
>
>> 
>> My point is, port 5 would not ever become physical port, equivalent to
>> port 1 for example. Will still be CPU port. Only used/unused.
>
>This is a valid point and question. If we are to support dynamically
>changing DSA port flavor, there would be an expectation that when the
>CPU port becomes DSA_PORT_TYPE_USER, we would be creating a net_device
>representor for it at that time (since that is what would happen if we
>did let DSA create devices in the first place). Conversely, if being an
>USER port and being changed to a CPU port we would remove the net_device.

Ah, I think I understand. Port 5 will just become as any other port, it
is just CPU facing. But can be used in the same way as the physical
port, right? Just the traffic would not go to the wire but to CPU.

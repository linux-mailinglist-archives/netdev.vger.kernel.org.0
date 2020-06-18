Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6C91FFB6D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgFRTCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgFRTCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:02:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F14C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:02:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id jz3so2960919pjb.0
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D8Q+cZ3xdkqjQ3ErE65Qsa0F9awWvhgSFLwJBvuuhfA=;
        b=FrTpCyBNLEYRsyIa9EA2+9lkPcw1nDfMSQVMrperUKeIx7M62SznkKrvZ/YrCVroYQ
         a6FNGSzdDj30bCmBO8LjG/yGIRVmW7RB0GanMHjxh4fErgPFNTVC6nDvdy+//EBjn+Cb
         jmJah2UXc2xJTxpe+afqmmsFqr6RwV9imyWX3vwRD3AwFFllFZtfpqN+7UYQno1TCT0S
         xXDOalHVMHDjaboQKfhOPiYaM97kTmS2V05ldDvUWMtQ6XhOK02HZ0DQIHCqYfESc/Kt
         dS9llr9g9wlx0CKiL4scpb6FlGwsN+F3IxBlWywovVb+xPk9B0lk+5lC7aNPfsXpT7Cn
         2/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D8Q+cZ3xdkqjQ3ErE65Qsa0F9awWvhgSFLwJBvuuhfA=;
        b=lrCSE3I7qGWH0rV/as45ZKZzNxNd7e6ZpwT6oUYksU0MULDy8/OY3G5X7BpDMCDQEC
         8Cu5vBW8cuhGXwprbnOMK19TWSJs3IpTGvQwZuIFqfvpinugif/7cXkeLHqoP6drZKdj
         9BQO55oA/FQ5eSqskemDqOa8xlmoX1dYaxnOa1mK4TmQGbda8XzK0G+Siyow5f+deqxv
         /azvlBL1XJ8ldUPC7NwZQ8cSN4ZNzf7c2iCqdqccI3Zrszv2veI7wORwxiUmmP4Civ+D
         MzKvnDhKPQAsE49q44tF/CADCEcxI6yi6Rvni1iD8RLEi+nQMvASbiz89z7zqX3hwk4x
         v70g==
X-Gm-Message-State: AOAM531NGPZBercm3Ur+3rWvc0X8lHR6a86FX/ZoYmczmhmb2d8Tq9g+
        TARpeG0DJ4mfotQ/HMI9enkEO8aE
X-Google-Smtp-Source: ABdhPJyydkcAypq8KlP/vAs1TUV+nda3iJid971YtFRIqw+JGektplMZajElpJgw1yeBpKrhLC51UA==
X-Received: by 2002:a17:90a:950e:: with SMTP id t14mr5104564pjo.99.1592506937815;
        Thu, 18 Jun 2020 12:02:17 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j5sm3203812pgi.42.2020.06.18.12.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 12:02:17 -0700 (PDT)
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
 <20200618084554.GY1551@shell.armlinux.org.uk>
 <91866c2b-77ea-c175-d672-a9ca937835bd@gmail.com>
 <20200618184908.GH1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3eb49188-fb74-99fe-a9d9-7e295d2eaa8b@gmail.com>
Date:   Thu, 18 Jun 2020 12:02:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618184908.GH1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2020 11:49 AM, Russell King - ARM Linux admin wrote:
> On Thu, Jun 18, 2020 at 11:06:43AM -0700, Florian Fainelli wrote:
>>
>>
>> On 6/18/2020 1:45 AM, Russell King - ARM Linux admin wrote:
>>> On Thu, Jun 18, 2020 at 10:14:33AM +0200, Helmut Grohne wrote:
>>>> On Wed, Jun 17, 2020 at 02:08:09PM +0200, Russell King - ARM Linux admin wrote:
>>>>> With a fixed link, we could be in either a MAC-to-PHY or MAC-to-MAC
>>>>> setup; we just don't know.  However, we don't have is access to the
>>>>> PHY (if it exists) in the fixed link case to configure it for the
>>>>> delay.
>>>>
>>>> Let me twist that a little: We may have access to the PHY, but we don't
>>>> always have access. When we do have access, we have a separate device
>>>> tree node with another fixed-link and another phy-mode. For fixed-links,
>>>> we specify the phy-mode for each end.
>>>
>>> If you have access to the PHY, you shouldn't be using fixed-link. In
>>> any case, there is no support for a fixed-link specification at the
>>> PHY end in the kernel.  The PHY binding doc does not allow for this
>>> either.
>>>
>>>>> In the MAC-to-MAC RGMII setup, where neither MAC can insert the
>>>>> necessary delay, the only way to have a RGMII conformant link is to
>>>>> have the PCB traces induce the necessary delay. That errs towards
>>>>> PHY_INTERFACE_MODE_RGMII for this case.
>>>>
>>>> Yes.
>>>>
>>>>> However, considering the MAC-to-PHY RGMII fixed link case, where the
>>>>> PHY may not be accessible, and may be configured with the necessary
>>>>> delay, should that case also use PHY_INTERFACE_MODE_RGMII - clearly
>>>>> that would be as wrong as using PHY_INTERFACE_MODE_RGMII_ID would
>>>>> be for the MAC-to-MAC RGMII with PCB-delays case.
>>>>
>>>> If you take into account that the PHY has a separate node with phy-mode
>>>> being rgmii-id, it makes a lot more sense to use rgmii for the phy-mode
>>>> of the MAC. So I don't think it is that clear that doing so is wrong.
>>>
>>> The PHY binding document does not allow for this, neither does the
>>> kernel.
>>>
>>>> In an earlier discussion Florian Fainelli said:
>>>> https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-olteanv@gmail.com/#2149183
>>>> | fixed-link really should denote a MAC to MAC connection so if you have
>>>> | "rgmii-id" on one side, you would expect "rgmii" on the other side
>>>> | (unless PCB traces account for delays, grrr).
>>>>
>>>> For these reasons, I still think that rgmii would be a useful
>>>> description for the fixed-link to PHY connection where the PHY adds the
>>>> delay.
>>>
>>> I think Florian is wrong; consider what it means when you have a
>>> fixed-link connection between a MAC and an inaccessible PHY and
>>> the link as a whole is operating in what we would call "rgmii-id"
>>> mode if the PHY were accessible.
>>>
>>> Taking Florian's stance, it basically means that DT no longer
>>> describes the hardware, but how we have chosen to interpret the
>>> properties in _one_ specific case in a completely different way
>>> to all the other cases.
>>
>> How do you ensure that a MAC to MAC connection using RGMII actually
>> works if you do not provide a 'phy-mode' for both sides right now?
>>
>> Yes this is more of a DT now describes a configuration choice rather
>> than the hardware but given that Ethernet MACs are usually capable of
>> supporting all 4 possible RGMII modes, how do you propose to solve the
>> negotiation of the appropriate RGMII mode here?
> 
> This is actually answered by yourself below.
> 
>>>>> So, I think a MAC driver should not care about the specific RGMII
>>>>> mode being asked for in any case, and just accept them all.
>>>>
>>>> I would like to agree to this. However, the implication is that when you
>>>> get your delays wrong, your driver silently ignores you and you never
>>>> notice your mistake until you see no traffic passing and wonder why.
>>>
>>> So explain to me this aspect of your reasoning:
>>>
>>> - If the link is operating in non-fixed-link mode, the rgmii* PHY modes
>>>   describe the delay to be applied at the PHY end.
>>> - If the link is operating in fixed-link mode, the rgmii* PHY modes
>>>   describe the delay to be applied at the MAC end.
>>>
>>> That doesn't make sense, and excludes properly describing a MAC-to-
>>> inaccessible-PHY setup.
>>
>> The point with a fixed link is that it does not matter what is the other
>> end, it could be a MAC, it could be a PHY, it could go nowhere, it just
>> does not matter, the only thing that you can know is you configure your
>> side of the fixed link.
> 
> That is *exactly* my point.
> 
> Today, with a PHY on the other end, the four RGMII modes tell you how
> the PHY is to be configured, not the MAC.  The documentation states
> this.
> 
> So, why should a fixed-link be any different?

It should not, but that means that when you describe the fixed-link, the
'phy-mode' within the local fixed-link node is meant to describe how the
other side is configured not how you are configured. For some reason I
did not consider that to be intuitive when I sent out my response, but I
suppose spelling it out would greatly help.
-- 
Florian

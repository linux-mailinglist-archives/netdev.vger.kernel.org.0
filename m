Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA17B1FFAC3
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgFRSGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 14:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgFRSGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 14:06:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8B4C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:06:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e1so7049017wrt.5
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oKq1h9g/Bp2S1T/uqzpsZutIAGdyzQi0D0h6oAcA+vI=;
        b=TFEafZug0AODOjuchENXn0zIbbB6btFS+ERun0ePEqGjtfOYCPoPIHyqmj7Uqta20I
         hiXNXBS/mQ6hEJccOHY2CZnB5G5AwP/lD2rC0tCGkSjpCXbv7n/416pujUSVzeUQmK3w
         XR77S+qO8o1BLpE4kn1dwDArr07OM+PCXi6qzxvgUlqzxCrhy/GMuLlI97SrNrlfgj+b
         tAsp3nIg4MWHH8AcOgIA3oULEzRrt/88s98Cj2yUeaLFZfMXztPTQoh8HvhtovlYLCla
         yME+Yw5Ut0GsUvquzfB4Gq6yU/kqMLfe0/4GzDvhBA0Yzv6b6PbUMFCnuTV5OyD0Y0pS
         LJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oKq1h9g/Bp2S1T/uqzpsZutIAGdyzQi0D0h6oAcA+vI=;
        b=rlBpy7Z6yLZNTwdZASRFjTAun1yGAmqgcH3SGs7t6ZdHqikTpfyARhvgTwgRREwo/Q
         Pf5YCZOjWmtbN7oFw9K4hHs0bQ7gVhhiqh5z7DETLXyRf8VtiaLqYjuY5aDzxP83NZ8H
         K9FoiOUFD6hu2NaFCL1avzugpRcQgAUr98GV8IZg8QANdgTFMQyLiQmQqzQ53PM6BuYy
         QYV7Kbk5yTDQb1g2S3KgBy8Be99uSAkS52/q59tcSZfaCjv+K1I7K+7mZ82mqHTc0MnK
         z4aBVDWnfQu9eym0aXJRZDWruWV51kz3mqLk+GEoiqakBsOyaLD7I5YE++wECrUEeX7a
         8z4g==
X-Gm-Message-State: AOAM531kTI4+gVMeCrsLqa7gLz6/VVgwoApW1P38MqgYr5ZSTxJl1OjR
        EST2TCTj2hiNNtlooi46mzufVRke
X-Google-Smtp-Source: ABdhPJwb2sGvKFx4EpKJ0ZVPNWZdnBgLj83OfUHGsozMLtf0jvjkKPgAw9wt8JhGPcwNpEN9UC6SFw==
X-Received: by 2002:adf:e4d1:: with SMTP id v17mr5766788wrm.224.1592503607708;
        Thu, 18 Jun 2020 11:06:47 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g25sm4200391wmh.18.2020.06.18.11.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 11:06:46 -0700 (PDT)
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <91866c2b-77ea-c175-d672-a9ca937835bd@gmail.com>
Date:   Thu, 18 Jun 2020 11:06:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618084554.GY1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2020 1:45 AM, Russell King - ARM Linux admin wrote:
> On Thu, Jun 18, 2020 at 10:14:33AM +0200, Helmut Grohne wrote:
>> On Wed, Jun 17, 2020 at 02:08:09PM +0200, Russell King - ARM Linux admin wrote:
>>> With a fixed link, we could be in either a MAC-to-PHY or MAC-to-MAC
>>> setup; we just don't know.  However, we don't have is access to the
>>> PHY (if it exists) in the fixed link case to configure it for the
>>> delay.
>>
>> Let me twist that a little: We may have access to the PHY, but we don't
>> always have access. When we do have access, we have a separate device
>> tree node with another fixed-link and another phy-mode. For fixed-links,
>> we specify the phy-mode for each end.
> 
> If you have access to the PHY, you shouldn't be using fixed-link. In
> any case, there is no support for a fixed-link specification at the
> PHY end in the kernel.  The PHY binding doc does not allow for this
> either.
> 
>>> In the MAC-to-MAC RGMII setup, where neither MAC can insert the
>>> necessary delay, the only way to have a RGMII conformant link is to
>>> have the PCB traces induce the necessary delay. That errs towards
>>> PHY_INTERFACE_MODE_RGMII for this case.
>>
>> Yes.
>>
>>> However, considering the MAC-to-PHY RGMII fixed link case, where the
>>> PHY may not be accessible, and may be configured with the necessary
>>> delay, should that case also use PHY_INTERFACE_MODE_RGMII - clearly
>>> that would be as wrong as using PHY_INTERFACE_MODE_RGMII_ID would
>>> be for the MAC-to-MAC RGMII with PCB-delays case.
>>
>> If you take into account that the PHY has a separate node with phy-mode
>> being rgmii-id, it makes a lot more sense to use rgmii for the phy-mode
>> of the MAC. So I don't think it is that clear that doing so is wrong.
> 
> The PHY binding document does not allow for this, neither does the
> kernel.
> 
>> In an earlier discussion Florian Fainelli said:
>> https://patchwork.ozlabs.org/project/netdev/patch/20190410005700.31582-19-olteanv@gmail.com/#2149183
>> | fixed-link really should denote a MAC to MAC connection so if you have
>> | "rgmii-id" on one side, you would expect "rgmii" on the other side
>> | (unless PCB traces account for delays, grrr).
>>
>> For these reasons, I still think that rgmii would be a useful
>> description for the fixed-link to PHY connection where the PHY adds the
>> delay.
> 
> I think Florian is wrong; consider what it means when you have a
> fixed-link connection between a MAC and an inaccessible PHY and
> the link as a whole is operating in what we would call "rgmii-id"
> mode if the PHY were accessible.
> 
> Taking Florian's stance, it basically means that DT no longer
> describes the hardware, but how we have chosen to interpret the
> properties in _one_ specific case in a completely different way
> to all the other cases.

How do you ensure that a MAC to MAC connection using RGMII actually
works if you do not provide a 'phy-mode' for both sides right now?

Yes this is more of a DT now describes a configuration choice rather
than the hardware but given that Ethernet MACs are usually capable of
supporting all 4 possible RGMII modes, how do you propose to solve the
negotiation of the appropriate RGMII mode here?

> 
>>> So, I think a MAC driver should not care about the specific RGMII
>>> mode being asked for in any case, and just accept them all.
>>
>> I would like to agree to this. However, the implication is that when you
>> get your delays wrong, your driver silently ignores you and you never
>> notice your mistake until you see no traffic passing and wonder why.
> 
> So explain to me this aspect of your reasoning:
> 
> - If the link is operating in non-fixed-link mode, the rgmii* PHY modes
>   describe the delay to be applied at the PHY end.
> - If the link is operating in fixed-link mode, the rgmii* PHY modes
>   describe the delay to be applied at the MAC end.
> 
> That doesn't make sense, and excludes properly describing a MAC-to-
> inaccessible-PHY setup.

The point with a fixed link is that it does not matter what is the other
end, it could be a MAC, it could be a PHY, it could go nowhere, it just
does not matter, the only thing that you can know is you configure your
side of the fixed link. If you have visibility into the other side as
well, you can go one step further an put something in the other
fixed-link node that makes sense and will result in a working RGMII link.

> 
> It also means that we're having to conditionalise how we deal with
> this PHY mode in every single driver, which means that every single
> driver is going to end up interpreting it differently, and it's going
> to become a buggy mess.

Newsflash: it is already a buggy mess.

> 
>> In this case, I was faced with a PHY that would do rgmii-txid and I
>> configured that on the MAC. Unfortunately, macb_main.c didn't tell me
>> that it did rgmii-id instead.
> 
> The documentation makes it clear that "rgmii-*" (note the hyphen) are
> to be applied by the PHY *only*, and not by the MAC.
> 
>>> I also think that some of this ought to be put in the documentation
>>> as guidance for new implementations.
>>
>> That seems to be the part where everyone agrees.
>>
>> Given the state of the discussion, I'm wondering whether this could be
>> fixed at a more fundamental level in the device tree bindings.
>>
>> A number of people (including you) pointed out that retroactively fixing
>> the meaning of phy modes does not work and causes pain instead. That
>> hints that the only way to fix this is adding new properties. How about
>> this?
>>
>> rgmii-delay-type:
>>   description:
>>     Responsibility for adding the rgmii delay
>>   enum:
>>     # The remote PHY or MAC to this MAC is responsible for adding the
>>     # delay.
>>     - remote
>>     # The delay is added by neither MAC nor MAC, but using PCB traces
>>     # instead.
>>     - pcb
>>     # The MAC must add the delay.
>>     - local
> 
> Why do we need that complexity?  If we decide that we can allow
> phy-mode = "rgmii" and introduce new properties to control the
> delay, then we just need:
> 
>   rgmii-tx-delay-ps = <nnn>;
>   rgmii-rx-delay-ps = <nnn>;
> 
> specified in the MAC node (to be applied only at the MAC end) or
> specified in the PHY node (to be applied only at the PHY end.)
> In the normal case, this would be the standard delay value, but
> in exceptional cases where supported, the delays can be arbitary.
> We know there are PHYs out there which allow other delays.
> 
> This means each end is responsible for parsing these properties in
> its own node and applying them - or raising an error if they can't
> be supported.

And as we all know, RGMII is the most plug and play standard out there
so this is "just going to work".

> 
> With your "rgmii-delay-type" idea, if this is only specified at the
> MAC end, then the PHY code somehow needs to know what that setting is,
> which adds a lot of complexity - the PHY code has to go digging for
> the MAC node, we may even have to introduce a back-reference from the
> PHY node to the MAC node so the PHY can find it.  There are MAC drivers
> out there where there is one struct device, but multiple net devices,
> so digging inside struct net_device to get at the parent struct device,
> and then trying to parse "rgmii-delay-type" from the of-node won't work.
>-- 
Florian

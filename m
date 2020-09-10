Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6802652BE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgIJVXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgIJVXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:23:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2CAC061573;
        Thu, 10 Sep 2020 14:23:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so5521058pff.6;
        Thu, 10 Sep 2020 14:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p42GK/1yAT4UofPfzHmZqP5A3xOoTOo31CfmHw1wr1s=;
        b=XJPMVkAtCYpui67NZceYfBMv4kft64+VQ61b8ToUxUqpRj7O+mDKAi1zhdAqH8uIAx
         8V0tA+1LhRy9INyU5E1is/vRN9UbBnadHDX3msfBYZQsNr80RyeOp2fRZNwTRV4iR7zt
         2jilhJC66EIyD/W7lYh11bN+YhlV6hbZPaOc8GqIp32N+QQqgmYUFvzfnuxbgxqa9kMD
         3YFWhA7iNrJ+faqbkiqJTZGcQB39VE+CSCzHHcDHSiT+CddK5GifJftIXcgK9vVJAT4D
         xuj7UuBtHONDk7fkz3TfrMV2QADNFJ+vpvJUQDnF9fgKDqry0Zk1sIwwpLCYjK/otaGZ
         2qWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p42GK/1yAT4UofPfzHmZqP5A3xOoTOo31CfmHw1wr1s=;
        b=BSXfTVlOOjCJMfUSxFsfPCZgJ5U9aVPwxcyvoi0a5rRoJeq4dfx1Ldcs8AcU31KzqT
         SB2qdo9LUeKgNOrIJKKKZupwrGTFJuB3aXXGHsC2JaYM4CqHZmFt6+AcZKUD1sbcNhJp
         dtH0VT5e8kMyleRnz1rxxSom6Ckku78RJPexcXA1NRKN1cncCzUjaoUPazj4wK90mJsz
         l1i7kRFPXorTztZU6rbl+UptvvkKfSQqj219I8VwS3KBq9i+ipxBk/ybo+GtlMTtlRZy
         z/wqA+b6giNNt3YlquNRzqu9lA0UHmZo/tSI8FHTkLHFeRMSNYzrGnaTi4M838wXATK3
         10Uw==
X-Gm-Message-State: AOAM5329Qhs/BWOUnLbkF1ojsZLPEXePNI01NMAY6MJX0b4/G+vHowLK
        Vnl/ATqX850/tMpU8WG+4uk=
X-Google-Smtp-Source: ABdhPJz5mgjzJ5sEQqxOobpIPDE8NiSokM5hEZ5XV4ED7Vuj4RMc0fmRUi2BorHpt3CWmuEF4w59/A==
X-Received: by 2002:a62:fb05:: with SMTP id x5mr7322794pfm.121.1599773026080;
        Thu, 10 Sep 2020 14:23:46 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y126sm14224pfy.138.2020.09.10.14.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 14:23:45 -0700 (PDT)
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
 <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
 <20200910132835.1bf7b638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf127fssgiDEwYvv3rFW7iFFfKKZDE=oxDUbFBcwpz3yQkQ@mail.gmail.com>
 <a13199ce-0c73-920d-857d-3223144f41f0@gmail.com>
 <CAFCwf13ak5NPc2BTWoA2cwHB5AUJjq5i1jOucbsJnwyyQCfQ4w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
Message-ID: <91d6756d-8a0d-d230-7deb-3c6d6090f746@gmail.com>
Date:   Thu, 10 Sep 2020 14:23:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAFCwf13ak5NPc2BTWoA2cwHB5AUJjq5i1jOucbsJnwyyQCfQ4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 2:15 PM, Oded Gabbay wrote:
> On Fri, Sep 11, 2020 at 12:05 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 9/10/2020 1:32 PM, Oded Gabbay wrote:
>>> On Thu, Sep 10, 2020 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Thu, 10 Sep 2020 23:16:22 +0300 Oded Gabbay wrote:
>>>>> On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>> On Thu, 10 Sep 2020 19:11:11 +0300 Oded Gabbay wrote:
>>>>>>>    create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
>>>>>>>    create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
>>>>>>>    create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
>>>>>>>    create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
>>>>>>>    create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
>>>>>>>    create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
>>>>>>
>>>>>> The relevant code needs to live under drivers/net/(ethernet/).
>>>>>> For one thing our automation won't trigger for drivers in random
>>>>>> (/misc) part of the tree.
>>>>>
>>>>> Can you please elaborate on how to do this with a single driver that
>>>>> is already in misc ?
>>>>> As I mentioned in the cover letter, we are not developing a
>>>>> stand-alone NIC. We have a deep-learning accelerator with a NIC
>>>>> interface.
>>>>> Therefore, we don't have a separate PCI physical function for the NIC
>>>>> and I can't have a second driver registering to it.
>>>>
>>>> Is it not possible to move the files and still build them into a single
>>>> module?
>>> hmm...
>>> I actually didn't try that as I thought it will be very strange and
>>> I'm not familiar with other drivers that build as a single ko but have
>>> files spread out in different subsystems.
>>> I don't feel it is a better option than what we did here.
>>>
>>> Will I need to split pull requests to different subsystem maintainers
>>> ? For the same driver ?
>>> Sounds to me this is not going to fly.
>>
>> Not necessarily, you can post your patches to all relevant lists and
>> seek maintainer review/acked-by tags from the relevant maintainers. This
>> is not unheard of with mlx5 for instance.
> Yeah, I see what you are saying, the problem is that sometimes,
> because everything is tightly integrated in our SOC, the patches
> contain code from common code (common to ALL our ASICs, even those who
> don't have NIC at all), GAUDI specific code which is not NIC related
> and the NIC code itself.
> But I guess that as a last resort if this is a *must* I can do that.
> Though I would like to hear Greg's opinion on this as he is my current
> maintainer.
> 
> Personally I do want to send relevant patches to netdev because I want
> to get your expert reviews on them, but still keep the code in a
> single location.

We do have network drivers sprinkled across the kernel tree already, but 
I would agree that from a networking maintainer perspective this makes 
auditing code harder, you would naturally grep for net/ and drivers/net 
and easily miss arch/uml/ for instance. When you do treewide changes, 
having all your ducklings in the same pond is a lot easier.

There is a possible "risk" with posting a patch series for the 
habanalabs driver to netdev that people will be wondering what this is 
about and completely miss it is about the networking bits. If there is a 
NIC driver under drivers/net then people will start to filter or pay 
attention based on the directory.

> 
>>
>> Have you considered using notifiers to get your NIC driver registered
>> while the NIC code lives in a different module?
> Yes, and I prefered to keep it simple. I didn't want to start sending
> notifications to the NIC driver every time, for example, I needed to
> reset the SOC because a compute engine got stuck. Or vice-versa - when
> some error happened in the NIC to start sending notifications to the
> common driver.
> 
> In addition, from my AMD days, we had a very tough time managing two
> drivers that "talk" to each other and manage the same H/W. I'm talking
> about amdgpu for graphics and amdkfd for compute (which I was the
> maintainer). AMD is working in the past years to unite those two
> drivers to get out of that mess. That's why I didn't want to go down
> that road.

You are trading an indirect call for a direct call, and it does provide 
some nice interface, but it could be challenging to work with given the 
context in which the notifier is called can be problematic. You could 
still have direct module references then, and that would avoid the need 
for notifiers.

You are the driver maintainer, so you definitively have a bigger say in 
the matter than most of us, drive by contributors.
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571D82651EF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgIJVFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgIJVFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:05:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CA0C061573;
        Thu, 10 Sep 2020 14:05:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id jw11so644951pjb.0;
        Thu, 10 Sep 2020 14:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u3ZSYZIE11VVPHHcA2Umq2k8ZqXKEUiv80isAt4/Bxs=;
        b=YTfxPqUk4Uz3ZAivteNj8RKC2MZcFwnOy2aKX161D2TaIYwOPVmIBOWDSWCBj7JISC
         4QXuctBSeEKDdm5wwW3Be0f2VtGnnhPwD9Q1NyH8uoYYX5csEE/IjYSOuLHHRdpASFjP
         24JV4dJg8wg06CCbQBX9DaVoyRss1VkdmC9FrKW4rfdVU/stktfnlrIx7fHi+GJULkXn
         cT1XUM5hw6C0mg9CEX2KWQQsBV9pZ+ppcb7UewuWgmERLz0h8pEoTfJHzuvq6viD/S/s
         GHxlgd38hGFzDQeqJ8ARlQtyccMlDLsiea6E8+gBxOTBKnf9FBkcbJjDtpoqfT6wmK4W
         kCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u3ZSYZIE11VVPHHcA2Umq2k8ZqXKEUiv80isAt4/Bxs=;
        b=g7G/fQ73YAbNA/0Gudbzrjb2zx8aDIkydvi40d0P9k6pkDbMfe5M3hXcghThUamO6d
         dIZ6FzuIXqtxDC5Aa+jo3QmzE6HWO5CJJP0Gmh7sm0r2QiIdI65fhOhr5GkW+FpEqP96
         Rrg7V8nH8FWQFKs2dKPd6IEXFhU1WmOPpjlM6Da3TPEsUZ3d1UPL9YSTp1ykXrimRt87
         zb0ckEnVZe9MgnTjSIzwTnEwltvb8twq70B7IlyA9BVxttt9xMfhXJ0zTIC9r/suLDgQ
         g4zayxqn5WTA/tb1XTEzpJRhKn5gAuY9+hxEcn+tbRcmM+gWkSsxV26/Zxr/tjH7w8k5
         fkbw==
X-Gm-Message-State: AOAM533twWVLa3Eslu1k8W7BO3fVp4QULVYK+NtkRCrBaH7OcSq6lr6O
        rtEr8ppdZeWQS8VMV1+B3pWnqzYqD4E=
X-Google-Smtp-Source: ABdhPJxMgRg+FNEDbF7a6Czn58yBRVG6yMKsz5u5qFIEKnOBNR7j1B1hXHvuNjYaXEzpymcM82Hdgg==
X-Received: by 2002:a17:90a:481:: with SMTP id g1mr1663925pjg.157.1599771918100;
        Thu, 10 Sep 2020 14:05:18 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id in10sm2686145pjb.11.2020.09.10.14.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 14:05:17 -0700 (PDT)
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
To:     Oded Gabbay <oded.gabbay@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
 <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
 <20200910132835.1bf7b638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf127fssgiDEwYvv3rFW7iFFfKKZDE=oxDUbFBcwpz3yQkQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a13199ce-0c73-920d-857d-3223144f41f0@gmail.com>
Date:   Thu, 10 Sep 2020 14:05:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAFCwf127fssgiDEwYvv3rFW7iFFfKKZDE=oxDUbFBcwpz3yQkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 1:32 PM, Oded Gabbay wrote:
> On Thu, Sep 10, 2020 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu, 10 Sep 2020 23:16:22 +0300 Oded Gabbay wrote:
>>> On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>> On Thu, 10 Sep 2020 19:11:11 +0300 Oded Gabbay wrote:
>>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
>>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
>>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
>>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
>>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
>>>>>   create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
>>>>>   create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
>>>>
>>>> The relevant code needs to live under drivers/net/(ethernet/).
>>>> For one thing our automation won't trigger for drivers in random
>>>> (/misc) part of the tree.
>>>
>>> Can you please elaborate on how to do this with a single driver that
>>> is already in misc ?
>>> As I mentioned in the cover letter, we are not developing a
>>> stand-alone NIC. We have a deep-learning accelerator with a NIC
>>> interface.
>>> Therefore, we don't have a separate PCI physical function for the NIC
>>> and I can't have a second driver registering to it.
>>
>> Is it not possible to move the files and still build them into a single
>> module?
> hmm...
> I actually didn't try that as I thought it will be very strange and
> I'm not familiar with other drivers that build as a single ko but have
> files spread out in different subsystems.
> I don't feel it is a better option than what we did here.
> 
> Will I need to split pull requests to different subsystem maintainers
> ? For the same driver ?
> Sounds to me this is not going to fly.

Not necessarily, you can post your patches to all relevant lists and 
seek maintainer review/acked-by tags from the relevant maintainers. This 
is not unheard of with mlx5 for instance.

Have you considered using notifiers to get your NIC driver registered 
while the NIC code lives in a different module?
-- 
Florian

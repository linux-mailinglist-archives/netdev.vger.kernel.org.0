Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0575612F1FB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgACAFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:05:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32836 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:05:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id c13so18422872pls.0
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 16:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rKxWPh+e70dKrMIqz/401PUPXagNtvgBHDyynhKqrVg=;
        b=k4QLrzilyYOxNm95V1HEHl8jC5dmJ5kcNOvMwfR4cbpL4/PFjK+eI8etGwnVudruXv
         /czEVpZM2e69ELaIgnDBn4zEcXB4vClGxUaF2Wotvnq06FDfPE1UkEtDf+tzI7OMCxRs
         xXjgod3umqiIBIqf0GidJqZXqvC9p6P7bQ9Tje34LTHpEd5ddI/jXhe2mUstCRUDDK6r
         VE1AF833XbIQTTVuUK2cRyvIY0nHnFvI4KEzLLyxBvTlsm4J5UOy69t0MWpKfQ1kwjgN
         1Wb7el0dZeyioEW+olXSUY0kAYJ2KaCDqKnBro1pOzuu1qVLlWEwz8KVCvGF5QVHoGPJ
         BDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rKxWPh+e70dKrMIqz/401PUPXagNtvgBHDyynhKqrVg=;
        b=jAa7T+aPgmftiA3C+ggFvdlRoJiQCLfmjgOMLfy28kfiXN5pSCsbqNkztXWNfXl3ZU
         1EdoWi94Ixg+41O572W9FVEObypTlCjPAL/dUlgCyZq0oQ+ib+tDV2ew0j+69VfgWA10
         LlaZhEwbEgG11TrYdPvgLCSQn2ORc+bdA2/oljA0MqWbtiK/OQQAuG0xebmwGlvJcyHZ
         cf8Atfx1qC7StC7G/NoEYMkNqtvlJqSVoAce5QNQmf0ep0N1tAaIT0pV0Pe9V9+TS+vE
         ADwYwL8JSq8Ghmy8n79B6sePMsk7Dy6bh4EIG0rQeLU85ItaVOjD+gulaRmHUJWz+eQo
         SYaA==
X-Gm-Message-State: APjAAAVCWoi6EuJsvkqwxf02JJsC2x8MVWa2FEp19ys/VvKh4JGUquTI
        Vdky0o3RrFKme56TCdcxPUbQhg==
X-Google-Smtp-Source: APXvYqztp4Qfv06GE1rOCcuazyVobZ/FVJrMtNwmzkldoGp9sD/vPfgZTzW7t2RJF9rTU86a5HNafQ==
X-Received: by 2002:a17:902:44f:: with SMTP id 73mr32561844ple.81.1578009914968;
        Thu, 02 Jan 2020 16:05:14 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d3sm24301934pfn.113.2020.01.02.16.05.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jan 2020 16:05:14 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
To:     Parav Pandit <parav@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20191212003344.5571-1-snelson@pensando.io>
 <20191212003344.5571-3-snelson@pensando.io>
 <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
 <20191212115228.2caf0c63@cakuba.netronome.com>
 <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
 <20191212133540.3992ac0c@cakuba.netronome.com>
 <a135f5fa-3745-69f6-4787-1695f47f1df8@mellanox.com>
 <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
 <b957e025-499d-3a56-80cd-654f4e6bb13a@mellanox.com>
 <435da9c6-b801-951f-ef5a-1cec31ce6493@pensando.io>
 <94c9f6a9-cb9d-220c-6558-d7df4e146311@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <634dbe1c-4332-46f7-4a2c-b9c20a7f93b1@pensando.io>
Date:   Thu, 2 Jan 2020 16:05:13 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <94c9f6a9-cb9d-220c-6558-d7df4e146311@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 12:46 AM, Parav Pandit wrote:
> On 12/16/2019 11:32 AM, Shannon Nelson wrote:
>> On 12/15/19 8:47 PM, Parav Pandit wrote:
>>> On 12/13/2019 4:10 AM, Shannon Nelson wrote:
>>>> On 12/12/19 2:24 PM, Parav Pandit wrote:
>>>>> On 12/12/2019 3:35 PM, Jakub Kicinski wrote:
>>>>>> On Thu, 12 Dec 2019 11:59:50 -0800, Shannon Nelson wrote:
>>>>>>> On 12/12/19 11:52 AM, Jakub Kicinski wrote:
>>>>>>>> On Thu, 12 Dec 2019 06:53:42 +0000, Parav Pandit wrote:
>>>>>>>>>>      static void ionic_remove(struct pci_dev *pdev)
>>>>>>>>>>      {
>>>>>>>>>>          struct ionic *ionic = pci_get_drvdata(pdev);
>>>>>>>>>> @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
>>>>>>>>>>          if (!ionic)
>>>>>>>>>>              return;
>>>>>>>>>>      +    if (pci_num_vf(pdev))
>>>>>>>>>> +        ionic_sriov_configure(pdev, 0);
>>>>>>>>>> +
>>>>>>>>> Usually sriov is left enabled while removing PF.
>>>>>>>>> It is not the role of the pci PF removal to disable it sriov.
>>>>>>>> I don't think that's true. I consider igb and ixgbe to set the
>>>>>>>> standard
>>>>>>>> for legacy SR-IOV handling since they were one of the first (the
>>>>>>>> first?)
>>>>>>>> and Alex Duyck wrote them.
>>>>>>>>
>>>>>>>> mlx4, bnxt and nfp all disable SR-IOV on remove.
>>>>>>> This was my understanding as well, but now I can see that ixgbe and
>>>>>>> i40e
>>>>>>> are both checking for existing VFs in probe and setting up to use
>>>>>>> them,
>>>>>>> as well as the newer ice driver.  I found this today by looking for
>>>>>>> where they use pci_num_vf().
>>>>>> Right, if the VFs very already enabled on probe they are set up.
>>>>>>
>>>>>> It's a bit of a asymmetric design, in case some other driver left
>>>>>> SR-IOV on, I guess.
>>>>>>
>>>>> I remember on one email thread on netdev list from someone that in one
>>>>> use case, they upgrade the PF driver while VFs are still bound and
>>>>> SR-IOV kept enabled.
>>>>> I am not sure how much it is used in practice/or practical.
>>>>> Such use case may be the reason to keep SR-IOV enabled.
>>>> This brings up a potential corner case where it would be better for the
>>>> driver to use its own num_vfs value rather than relying on the
>>>> pci_num_vf() when answering the ndo_get_vf_*() callbacks, and at least
>>>> the igb may be susceptible.
>>> Please do not cache num_vfs in driver. Use the pci core's pci_num_vf()
>>> in the new code that you are adding.
>> I disagree.  The pci_num_vf() tells us what the kernel has set up for
>> VFs running, while the driver's num_vfs tracks how many resources the
>> driver has set up for handling VFs: these are two different numbers, and
>> there are times in the life of the driver when these numbers are
>> different.  Yes, these are small windows of time, but they are different
>> and need to be treated differently.
>>
> They shouldn't be different. Why are they different?

One simple case where they are different is when .sriov_config is first 
called and the driver hasn't set anything up for handling the VFs.  Once 
the driver has set up whatever resources it needs, then they definitely 
should be the same.  This works in reverse when tearing down the VFs: 
pci_num_vf() says 0, but the driver thinks it has N VFs configured until 
it has torn down its resources and decremented its own counter.  I'm 
sure there are some drivers that don't need to allocate any resources, 
but if they do, these need to be tracked for tearing down later.

In this ionic driver, after working through this and fixing all the 
places where ionic->num_vfs can/should be replaced by pci_num_vf(), I'm 
still left with this issue: since pci_num_vf() returns 0 when 
.sriov_configure() is called when disabling sr-iov, the driver doesn't 
know how many ionic->vf[] had been set up earlier and can't properly 
unmap the DMA stats memory set up for each VF.

I think the driver needs to keep its own resource count.

sln


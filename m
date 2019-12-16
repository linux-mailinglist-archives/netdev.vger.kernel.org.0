Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0411FE54
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfLPGCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:02:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42537 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfLPGCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:02:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so4980403pfz.9
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PIjYzBgwZoLYseVZUSgNwLSzKSOch3r1pyzKruFlQlk=;
        b=1eFH+mXMB6Dp54YuejaaQkLh+to2XeLW9w3+VGkJVDCRiLxCnnvvWpYIDZqI3TwiPs
         a5XAFz46p6T88WEjKYHrutALXFMynEH+xwvo+adDQQ1UpaJ3aTosSnq/6GhzABH2x5v9
         tTKRhrK+67QmrgDS6Ca3BAVR1a5wuXMApBhz/VGT/3Bkq1lZ/rztCkizd4rcthH36JFP
         0KiTM3S+WBwdD743gocBAQOjzlSYeJlZYpoKNXw2QDuAzMx5yP4FMdt0F3npWmz9T8vO
         FvcCas20idYuiNfvvMoogESd3uNQ5gEYhmgUJ2Ii846gA4zShWBeCix+9CSGFwLliBhx
         cmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PIjYzBgwZoLYseVZUSgNwLSzKSOch3r1pyzKruFlQlk=;
        b=TczbsBllgR73Gh2fLmCqV5YzPZhRkOJ46zcbXkLQTgqUKPIB7Pt8djK7GMeJ56ltIb
         aBADl0nyeT4susSN03nYdGA/VjsBqXTFwRTFYQNeaF/9Hf4eBYExBSbeNP+ha9uR6KZZ
         NzwbW+lZKHELV4MHgeLPShmCVJ4sghEMOLK7g5vNGgzAO2ZV6E648ULxUa1FC7Dio9Nd
         ud4WD6rz6pyvPJwnj5q/n4fLwCGwNB0ubH6xOrSj1AeI+4Ag9Gjpu1vLvYHIYaxFWzSu
         QYh8zy3EP5y9Xvi0KKYobm9z4A3js/yXii5q5jJKEtJbrBM0QcgdI6YWHn6GdC6yclas
         1BBQ==
X-Gm-Message-State: APjAAAVJla4QcFE8MQTNSNAlzNrPPGsJll2maakJ3ih02hHGnJA0TXZH
        XxBSy1aK7GHdNaqbBkP/h2fSUA==
X-Google-Smtp-Source: APXvYqwy68BfDn/elZNb6Vq9sc6szY0ep5Mj+STvZUD/OTXQ/63keIKc5JHoGFn4mIW86mb9Z+tkBQ==
X-Received: by 2002:a65:518b:: with SMTP id h11mr16018696pgq.133.1576476124137;
        Sun, 15 Dec 2019 22:02:04 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id o16sm19715701pgl.58.2019.12.15.22.02.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 22:02:03 -0800 (PST)
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
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <435da9c6-b801-951f-ef5a-1cec31ce6493@pensando.io>
Date:   Sun, 15 Dec 2019 22:02:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <b957e025-499d-3a56-80cd-654f4e6bb13a@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/19 8:47 PM, Parav Pandit wrote:
> On 12/13/2019 4:10 AM, Shannon Nelson wrote:
>> On 12/12/19 2:24 PM, Parav Pandit wrote:
>>> On 12/12/2019 3:35 PM, Jakub Kicinski wrote:
>>>> On Thu, 12 Dec 2019 11:59:50 -0800, Shannon Nelson wrote:
>>>>> On 12/12/19 11:52 AM, Jakub Kicinski wrote:
>>>>>> On Thu, 12 Dec 2019 06:53:42 +0000, Parav Pandit wrote:
>>>>>>>>     static void ionic_remove(struct pci_dev *pdev)
>>>>>>>>     {
>>>>>>>>         struct ionic *ionic = pci_get_drvdata(pdev);
>>>>>>>> @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
>>>>>>>>         if (!ionic)
>>>>>>>>             return;
>>>>>>>>     +    if (pci_num_vf(pdev))
>>>>>>>> +        ionic_sriov_configure(pdev, 0);
>>>>>>>> +
>>>>>>> Usually sriov is left enabled while removing PF.
>>>>>>> It is not the role of the pci PF removal to disable it sriov.
>>>>>> I don't think that's true. I consider igb and ixgbe to set the
>>>>>> standard
>>>>>> for legacy SR-IOV handling since they were one of the first (the
>>>>>> first?)
>>>>>> and Alex Duyck wrote them.
>>>>>>
>>>>>> mlx4, bnxt and nfp all disable SR-IOV on remove.
>>>>> This was my understanding as well, but now I can see that ixgbe and
>>>>> i40e
>>>>> are both checking for existing VFs in probe and setting up to use them,
>>>>> as well as the newer ice driver.  I found this today by looking for
>>>>> where they use pci_num_vf().
>>>> Right, if the VFs very already enabled on probe they are set up.
>>>>
>>>> It's a bit of a asymmetric design, in case some other driver left
>>>> SR-IOV on, I guess.
>>>>
>>> I remember on one email thread on netdev list from someone that in one
>>> use case, they upgrade the PF driver while VFs are still bound and
>>> SR-IOV kept enabled.
>>> I am not sure how much it is used in practice/or practical.
>>> Such use case may be the reason to keep SR-IOV enabled.
>> This brings up a potential corner case where it would be better for the
>> driver to use its own num_vfs value rather than relying on the
>> pci_num_vf() when answering the ndo_get_vf_*() callbacks, and at least
>> the igb may be susceptible.
> Please do not cache num_vfs in driver. Use the pci core's pci_num_vf()
> in the new code that you are adding.

I disagree.  The pci_num_vf() tells us what the kernel has set up for 
VFs running, while the driver's num_vfs tracks how many resources the 
driver has set up for handling VFs: these are two different numbers, and 
there are times in the life of the driver when these numbers are 
different.  Yes, these are small windows of time, but they are different 
and need to be treated differently.

> More below.
>> If the driver hasn't set up its vf[] data
>> arrays because there was an error in setting them up in the probe(), and
>> later someone tries to get VF statistics, the ndo_get_vf_stats callback
>> could end up dereferencing bad pointers because vf is less than
>> pci_num_vf() but more than the number of vf[] structs set up by the driver.
>>
>> I suppose the argument could be made that PF's probe should if the VF
>> config fails, but it might be nice to have the PF driver running to help
>> fix up whatever when sideways in the VF configuration.
>>
>> sln
>>
> I not have strong opinion on letting sriov enabled/disabled on PF device
> removal.
> But it should be symmetric on probe() and remove() for PF.
> If you want to keep it enabled on PF removal, you need to check on probe
> and allocate VF metadata you have by using helper function in
> sriov_configure() and in probe().
> This is followed by mlx5 driver.

Agreed, and this check at probe time is included in the v3 patch that I 
sent out on Friday.

sln



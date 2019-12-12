Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9E311D99D
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbfLLWkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:40:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36373 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbfLLWkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:40:03 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so174499pfb.3
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lWMTlD6OvtNUfkCzl9lv3EC9V9dT6AoR3kYT9zVRXdY=;
        b=mG015W57d/XcUIQUGh2uvnAOPyB1cWJIpIEwgBoBWYzHW1plZL7PIKgzZ/zcwrxQlN
         /dCRssI0qF69S1p6Y7HDHT+a/Wo3iLsLSzjHw5q1dGjzgyuc8lgtdKyKP2qroTsOGQBc
         59ntj67QC3MUioBD/EvedIeQ3cyZbfC37KuZcES5R+vAfvlGrks6Qs6ZCvh62NiFPgAq
         wGmUz/u6RjtBe4U7Q6FbTRG/phCcZl0kX+z7EJzVLpPb87is6NP39o9JC9Nhi5uXXLX7
         wylj6a65FxGFtbMmnTfgJlP1J0OhaaN6UMwmCQ7bIWRa1vIOksT39Llx4RLyZdA6pjZd
         5CjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lWMTlD6OvtNUfkCzl9lv3EC9V9dT6AoR3kYT9zVRXdY=;
        b=KYnmhLpEMGgOipRG/EGXb481Nwnh98jfExAGDSi/udHAJUpiXiMMQ5/yXm3hlVJYq2
         AKRUHwqVZ9Ijq9yviAs7JEwJiVTaex7FmZyIC1a+k9/9hAzd3e3EwJWVLObAnpgKeTX2
         V+Ghrglzt48NWixbdDu5z43ar5HQKf4Dji0whYDdxPIZ/PI5PJDfMXohUo7lYHpGAwLI
         X0jeladEuwgIA4DtBiRH4LnN1bNMjhN/Itbb/US61lZaUSH1szBZQmuS6oawbUo037ov
         v+JQbaQHTfuITmb2SfjRy4/gOK9vGMIynSOzQ62c0uXkc29F5qt0m1U5HH6PDDfDoGv1
         mTnQ==
X-Gm-Message-State: APjAAAVRgwHLy0xLc0NZ2flb/VEHggTi/AMOIC22Aot4A4psHDWDdD7J
        MSaCVtB/pOzvyEiefs/jxGdaSg==
X-Google-Smtp-Source: APXvYqyEbWKuMwISjr6MJngf+vHGY+bmIaVxskVBIwQDEu7JC7/maPJ00XLWTQ/hJL4fjfoMJezNSQ==
X-Received: by 2002:aa7:8699:: with SMTP id d25mr12339357pfo.139.1576190403266;
        Thu, 12 Dec 2019 14:40:03 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e25sm7733747pge.64.2019.12.12.14.40.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 14:40:02 -0800 (PST)
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
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e4f01388-8cc4-1ac5-8f8e-ef24cc1b45ad@pensando.io>
Date:   Thu, 12 Dec 2019 14:40:01 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <a135f5fa-3745-69f6-4787-1695f47f1df8@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/19 2:24 PM, Parav Pandit wrote:
> On 12/12/2019 3:35 PM, Jakub Kicinski wrote:
>> On Thu, 12 Dec 2019 11:59:50 -0800, Shannon Nelson wrote:
>>> On 12/12/19 11:52 AM, Jakub Kicinski wrote:
>>>> On Thu, 12 Dec 2019 06:53:42 +0000, Parav Pandit wrote:
>>>>>>    static void ionic_remove(struct pci_dev *pdev)
>>>>>>    {
>>>>>>    	struct ionic *ionic = pci_get_drvdata(pdev);
>>>>>> @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
>>>>>>    	if (!ionic)
>>>>>>    		return;
>>>>>>    
>>>>>> +	if (pci_num_vf(pdev))
>>>>>> +		ionic_sriov_configure(pdev, 0);
>>>>>> +
>>>>> Usually sriov is left enabled while removing PF.
>>>>> It is not the role of the pci PF removal to disable it sriov.
>>>> I don't think that's true. I consider igb and ixgbe to set the standard
>>>> for legacy SR-IOV handling since they were one of the first (the first?)
>>>> and Alex Duyck wrote them.
>>>>
>>>> mlx4, bnxt and nfp all disable SR-IOV on remove.
>>> This was my understanding as well, but now I can see that ixgbe and i40e
>>> are both checking for existing VFs in probe and setting up to use them,
>>> as well as the newer ice driver.  I found this today by looking for
>>> where they use pci_num_vf().
>> Right, if the VFs very already enabled on probe they are set up.
>>
>> It's a bit of a asymmetric design, in case some other driver left
>> SR-IOV on, I guess.
>>
> I remember on one email thread on netdev list from someone that in one
> use case, they upgrade the PF driver while VFs are still bound and
> SR-IOV kept enabled.
> I am not sure how much it is used in practice/or practical.
> Such use case may be the reason to keep SR-IOV enabled.

This brings up a potential corner case where it would be better for the 
driver to use its own num_vfs value rather than relying on the 
pci_num_vf() when answering the ndo_get_vf_*() callbacks, and at least 
the igb may be susceptible.  If the driver hasn't set up its vf[] data 
arrays because there was an error in setting them up in the probe(), and 
later someone tries to get VF statistics, the ndo_get_vf_stats callback 
could end up dereferencing bad pointers because vf is less than 
pci_num_vf() but more than the number of vf[] structs set up by the driver.

I suppose the argument could be made that PF's probe should if the VF 
config fails, but it might be nice to have the PF driver running to help 
fix up whatever when sideways in the VF configuration.

sln


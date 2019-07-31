Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6E07D12B
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfGaWb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:31:56 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:37386 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfGaWb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:31:56 -0400
Received: by mail-pg1-f182.google.com with SMTP id i70so22036094pgd.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pXH5GE2Tor3TKPsP6nqKUf18cs/dsSsv6Yk6A7HJd4U=;
        b=f8nxv9ZJJu8Trz3rsHR+9kuSGPSIiLtltsHUqJNoqLJT35sMtIkQfQPr0MOsa347GN
         5TgaESQLf4iwow41Q3zgm+dJp0Suz0+htWGbvCynPwSf3bkBqzl6vevy+ng3HpRVSCwW
         uhx4lIukX89WJ1Y5VseJtRA50w5BaSh7pjSvfBvI1chYzIu0I6XRgwMIodi8loYTtURn
         kL9Ssf5uEuzd9C+wXZPB0OqzMfh/Ug5GG8h+tbIJKem+pK3RlggVtvuX69mBAH+TFm0L
         sHsQ3/om9BNE8wKycnEm/sHImUpzJLd1wHllEBO+/T4B61mNxG5lc75+hhJtDmPhn05x
         1Hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXH5GE2Tor3TKPsP6nqKUf18cs/dsSsv6Yk6A7HJd4U=;
        b=jSR6t61pYpyYSIlwE7kBX4ne2NWo9K7PtMxSKbLSKIg5GPcxGIPWoKND8a/rOGJZG2
         RCBo7BvR1OP/dylJ4qHRYxOkUZVIclu7zLyvn8jryr/lX/zgXZt0lsJPygCruYmfGjBO
         FLpBd2u6ewzzLJo67tmuRsyMifIXYq4kEHHhPQhK1Cd4vdS9J8qpMwcWhJTQBTkdHt+V
         f20TUOrXOgGrPl3lrcGvmbJAaKstP+uhO/4y6/MXgbcp8vr66KNyJilBFrEsxIXDcZWW
         p1C/xO/ZxJtmA8G2cDimE7cblyIO0QpDv1JrIEbzvIZsqoEyuHFUqbn0ansXtlZLKOjx
         ZwZw==
X-Gm-Message-State: APjAAAWx54DNOF3uIeYpggQI0rfRHYzkLxdCAWSlkZrqdENb7AjSEfbD
        fLA3sGO95cTJbnYFqspFwEc=
X-Google-Smtp-Source: APXvYqz5jWTN/4wyiVe4m4CsekRnq2YQZATj3+qlzGipKJnPXBeRKVRG6sZnAaxQ1uBV5hgOApuklA==
X-Received: by 2002:a17:90a:d996:: with SMTP id d22mr5152605pjv.86.1564612315615;
        Wed, 31 Jul 2019 15:31:55 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l44sm2799417pje.29.2019.07.31.15.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 15:31:54 -0700 (PDT)
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190727094459.26345-1-jiri@resnulli.us>
 <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
 <20190730060817.GD2312@nanopsycho.orion>
 <8f5afc58-1cbc-9e9a-aa15-94d1bafcda22@gmail.com>
 <20190731150233.432d3c86@cakuba.netronome.com>
 <45803ed3-0328-9409-4351-6c26ba8af3cd@gmail.com>
 <20190731152805.4110ec41@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <de94a881-cb87-e251-d55c-9f40d24b08d5@gmail.com>
Date:   Wed, 31 Jul 2019 16:31:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190731152805.4110ec41@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 4:28 PM, Jakub Kicinski wrote:
> On Wed, 31 Jul 2019 16:07:31 -0600, David Ahern wrote:
>> On 7/31/19 4:02 PM, Jakub Kicinski wrote:
>>> Can you elaborate further? Ports for most purposes are represented by
>>> netdevices. Devlink port instances expose global topological view of
>>> the ports which is primarily relevant if you can see the entire ASIC.
>>> I think the global configuration and global view of resources is still
>>> the most relevant need, so in your diagram you must account for some
>>> "all-seeing" instance, e.g.:
>>>
>>>    namespace 1 |  namespace 2  | ... | namespace N
>>>                |               |     |
>>>   { ports 1 }  |   { ports 2 } | ... | { ports N }
>>>                |               |     |
>>> subdevlink 1   | subdevlink 2  | ... |  subdevlink N
>>>          \______      |              _______/
>>>                  master ASIC devlink
>>>   =================================================
>>>                    driver
>>>
>>> No?
>>
>> sure, there could be a master devlink visible to the user if that makes
>> sense or the driver can account for it behind the scenes as the sum of
>> the devlink instances.
>>
>> The goal is to allow ports within an asic [1] to be divided across
>> network namespace where each namespace sees a subset of the ports. This
>> allows creating multiple logical switches from a single physical asic.
>>
>> [1] within constraints imposed by the driver/hardware - for example to
>> account for resources shared by a set of ports. e.g., front panel ports
>> 1 - 4 have shared resources and must always be in the same devlink instance.
> 
> So the ASIC would start out all partitioned? Presumably some would
> still like to use it non-partitioned? What follows there must be a top
> level instance to decide on partitioning, and moving resources between
> sub-instances.
> 
> Right now I don't think there is much info in devlink ports which would
> be relevant without full view of the ASIC..
> 

not sure how it would play out. really just 'thinking out loud' about
the above use case to make sure devlink with proper namespace support
allows it - or does not prevent it.

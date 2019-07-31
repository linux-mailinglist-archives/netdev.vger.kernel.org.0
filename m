Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455607D073
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfGaWHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:07:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45062 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbfGaWHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:07:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so32731158pgp.12
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ghYK67tICO7YCbl/9NBAcj3xRAf1R0CQ7voW0Kxwbg=;
        b=dFVCj7gCNTwTT1d5uqThnusGFBF+paihQ+biRo12m451uRZvdQHcYr/MfGfryXrVuC
         1g9jcxo26rcRTGrdlBwPcuz0CiKsBjgyKzqs7iRY6T6OzazWqNutgiLNzC6oosIgOo2J
         aHvjn/1A77drc/UkPZeiqW5cU29LlCYzaIYoO7oIym2+jAydav7z41IV7iz5TigGpYYQ
         d+3snEKyO2xYuo46xbTZ+wAYywJqQZZmcod4D/v80eSs/NcvZGl+bvVToDuafWoUFmlq
         c62YDhLL4Tv5Gp4B69L882RlJsEyPL1TiOWseJATKQ5JGxX9jyhCF/JgXf9MPYYckjx3
         iPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ghYK67tICO7YCbl/9NBAcj3xRAf1R0CQ7voW0Kxwbg=;
        b=o/rJ4h1lC/9bOCUoHq5bYuCulHdyCCctAgR7nUBuil1PZqkGswC1L+isp7+LAYuTuH
         H2g3eQsEoIyg5InlczR/8+roA7cAKZtK1HbhInLCcJNZiHgD/QPsARZGv2tj9jZG0cVG
         C4jBK/b7hOuBXLcZ0EPMNQJ5yWSu8kCBMGvkTiQXf4xL7FIBHs9GImHiomtFCeLPAsZ+
         080rnLmk5Ae4MGXaSOUqfwPgTy4Y2hB+5NOCgS7Bz8Ladr7k9P1ilPll4ORcuv/YDYa+
         1bWFJL39tNoy1hWQcM4NNEoXsQFwtZr7EXA7JlcFMI4huZKxPrx+848PxSZovRV0YQSC
         cW6w==
X-Gm-Message-State: APjAAAU6NaQRDBeEgFHlFHqMfUEbkAQgcdMzrlwT7i3FyEJmY2oO4Anm
        ZImkE+oAfWtMdu+uOojnukdq//Jg
X-Google-Smtp-Source: APXvYqwz/ASKO4fNC4tDP1toHLWlZcXGE0p35hEhWrXbnR37GV/ItTrAMEJevg1gCzB4EMXePAqTbA==
X-Received: by 2002:a62:107:: with SMTP id 7mr50071086pfb.4.1564610854590;
        Wed, 31 Jul 2019 15:07:34 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l26sm79220992pgb.90.2019.07.31.15.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 15:07:33 -0700 (PDT)
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <45803ed3-0328-9409-4351-6c26ba8af3cd@gmail.com>
Date:   Wed, 31 Jul 2019 16:07:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190731150233.432d3c86@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 4:02 PM, Jakub Kicinski wrote:
> On Wed, 31 Jul 2019 15:50:26 -0600, David Ahern wrote:
>> On 7/30/19 12:08 AM, Jiri Pirko wrote:
>>> Mon, Jul 29, 2019 at 10:17:25PM CEST, dsahern@gmail.com wrote:  
>>>> On 7/27/19 3:44 AM, Jiri Pirko wrote:  
>>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>>
>>>>> Devlink from the beginning counts with network namespaces, but the
>>>>> instances has been fixed to init_net. The first patch allows user
>>>>> to move existing devlink instances into namespaces:
>>>>>  
>>>>
>>>> so you intend for an asic, for example, to have multiple devlink
>>>> instances where each instance governs a set of related ports (e.g.,
>>>> ports that share a set of hardware resources) and those instances can be
>>>> managed from distinct network namespaces?  
>>>
>>> No, no multiple devlink instances for asic intended.  
>>
>> So it should be allowed for an asic to have resources split across
>> network namespaces. e.g., something like this:
>>
>>    namespace 1 |  namespace 2  | ... | namespace N
>>                |               |     |
>>   { ports 1 }  |   { ports 2 } | ... | { ports N }
>>                |               |     |
>>    devlink 1   |    devlink 2  | ... |  devlink N
>>   =================================================
>>                    driver
> 
> Can you elaborate further? Ports for most purposes are represented by
> netdevices. Devlink port instances expose global topological view of
> the ports which is primarily relevant if you can see the entire ASIC.
> I think the global configuration and global view of resources is still
> the most relevant need, so in your diagram you must account for some
> "all-seeing" instance, e.g.:
> 
>    namespace 1 |  namespace 2  | ... | namespace N
>                |               |     |
>   { ports 1 }  |   { ports 2 } | ... | { ports N }
>                |               |     |
> subdevlink 1   | subdevlink 2  | ... |  subdevlink N
>          \______      |              _______/
>                  master ASIC devlink
>   =================================================
>                    driver
> 
> No?
> 

sure, there could be a master devlink visible to the user if that makes
sense or the driver can account for it behind the scenes as the sum of
the devlink instances.

The goal is to allow ports within an asic [1] to be divided across
network namespace where each namespace sees a subset of the ports. This
allows creating multiple logical switches from a single physical asic.

[1] within constraints imposed by the driver/hardware - for example to
account for resources shared by a set of ports. e.g., front panel ports
1 - 4 have shared resources and must always be in the same devlink instance.

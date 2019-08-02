Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7848F7EDBA
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbfHBHm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:42:28 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40285 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfHBHm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:42:27 -0400
Received: by mail-wr1-f53.google.com with SMTP id r1so76088507wrl.7
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 00:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pAWSIbCrCjtq4y+FrhfRJjEaYMCaL3guEYyEUzYaBx0=;
        b=VfLJO2zXmuTrsrtw5moqc8RMzRHTzSIYTtRxbZkU5USiUer972XzqcE5RA9PbR+Dvz
         pUEuJzezMtawzMTheZ6eIvXK5dwzDqgdP/PLO03HBJm9yyCSONKYMc/5SQc4yseu23oH
         5Dmbd/8pltRmaNqGwBx3q5aD/myo1huWhFZTiu+klz48imjG8mqmbGK87rQ1XiXvwqvY
         IDQOjHoc0vIv6hMvIxoh3vO//UUzlX53lt3+do+Vb2GbgNm69d5OUXZnZxadbkC9lhBY
         ObIQ+tqshaWhHIR5PNRmqq/RgEVSNcB7XZVKQcfFzsLidAoCAH+qKs1l1TQFKmV0MAlF
         vDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pAWSIbCrCjtq4y+FrhfRJjEaYMCaL3guEYyEUzYaBx0=;
        b=T2lVEjG4VpTcr1cMdIh2gALJ7GdbL4/KMBEqIu3JdNi1o69xT8NiU23S0n6pCVWdSL
         B5J1ZdqCQQBb7/Ts7tk07ZtJZcHwv8LRl3PE5Ls0BHilAhZr9Kfn+5vi2OdfpX+jNWph
         x0wohLF6C2FkoO7kO6wUeirGLQfMI2DLjvU2dOxDKjEvCdLC+yxyTeK5JeXTJ+Ym/8jZ
         WemnBicttQQHOm+Gond9scKCFcpp5TN5isZugUFAiQ1ydSJdKQZwqoUVYPSFBLdf1Fdi
         Lno53FCu6FFHUYBROpxblkjC7FLeBgSD17FZjq9RsZ6a1HkzhToUstE7X1qZZIoDGGXU
         vSuQ==
X-Gm-Message-State: APjAAAWcYfdWTGQ6XvUralmwcFEoxHnVMAArzvUk5I8chnZHaqCyggov
        hkbrem6v9ck8w3tdt45DrzI=
X-Google-Smtp-Source: APXvYqwTD4w/1Ny3yOslRM6UyO75X4KobtdgeIzFAlPji3aLKqzfnagzCpd6f4SzIBXFcf/Zln6Abg==
X-Received: by 2002:adf:c70e:: with SMTP id k14mr43829164wrg.201.1564731745615;
        Fri, 02 Aug 2019 00:42:25 -0700 (PDT)
Received: from localhost ([80.82.155.62])
        by smtp.gmail.com with ESMTPSA id v16sm61837708wrn.28.2019.08.02.00.42.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 00:42:24 -0700 (PDT)
Date:   Fri, 2 Aug 2019 09:42:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190802074219.GA2203@nanopsycho>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
 <20190730060817.GD2312@nanopsycho.orion>
 <8f5afc58-1cbc-9e9a-aa15-94d1bafcda22@gmail.com>
 <20190731150233.432d3c86@cakuba.netronome.com>
 <45803ed3-0328-9409-4351-6c26ba8af3cd@gmail.com>
 <20190731152805.4110ec41@cakuba.netronome.com>
 <de94a881-cb87-e251-d55c-9f40d24b08d5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de94a881-cb87-e251-d55c-9f40d24b08d5@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 01, 2019 at 12:31:52AM CEST, dsahern@gmail.com wrote:
>On 7/31/19 4:28 PM, Jakub Kicinski wrote:
>> On Wed, 31 Jul 2019 16:07:31 -0600, David Ahern wrote:
>>> On 7/31/19 4:02 PM, Jakub Kicinski wrote:
>>>> Can you elaborate further? Ports for most purposes are represented by
>>>> netdevices. Devlink port instances expose global topological view of
>>>> the ports which is primarily relevant if you can see the entire ASIC.
>>>> I think the global configuration and global view of resources is still
>>>> the most relevant need, so in your diagram you must account for some
>>>> "all-seeing" instance, e.g.:
>>>>
>>>>    namespace 1 |  namespace 2  | ... | namespace N
>>>>                |               |     |
>>>>   { ports 1 }  |   { ports 2 } | ... | { ports N }
>>>>                |               |     |
>>>> subdevlink 1   | subdevlink 2  | ... |  subdevlink N
>>>>          \______      |              _______/
>>>>                  master ASIC devlink
>>>>   =================================================
>>>>                    driver
>>>>
>>>> No?
>>>
>>> sure, there could be a master devlink visible to the user if that makes
>>> sense or the driver can account for it behind the scenes as the sum of
>>> the devlink instances.
>>>
>>> The goal is to allow ports within an asic [1] to be divided across
>>> network namespace where each namespace sees a subset of the ports. This
>>> allows creating multiple logical switches from a single physical asic.
>>>
>>> [1] within constraints imposed by the driver/hardware - for example to
>>> account for resources shared by a set of ports. e.g., front panel ports
>>> 1 - 4 have shared resources and must always be in the same devlink instance.
>> 
>> So the ASIC would start out all partitioned? Presumably some would
>> still like to use it non-partitioned? What follows there must be a top
>> level instance to decide on partitioning, and moving resources between
>> sub-instances.
>> 
>> Right now I don't think there is much info in devlink ports which would
>> be relevant without full view of the ASIC..
>> 
>
>not sure how it would play out. really just 'thinking out loud' about
>the above use case to make sure devlink with proper namespace support
>allows it - or does not prevent it.

I Don't see reason or usecase to have ports or other objects of devlink
in separate namespaces. Devlink and it's objects are one big item,
should be always together.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9051342E71
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 17:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCTQnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTQnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 12:43:04 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18D3C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 09:43:03 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so11575372ota.9
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 09:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TkNItopMnJPLDcqUfYehOqcAH438sPgLODJtMsLVzIA=;
        b=l74coyJPCLyPUAY1J9lNyW44xOUKJers5TnygmK4Twbf1bgCAfoIiipyIAG6B7h1EJ
         tP3/qgyJnZZyeAt0dvksP+WS9umze5sOYavBKcsKo9bsql2ZF1G6KBI1EZqDbecnu2vB
         xxbiAefDAg0G1FsWuYCN+PdvQ6/PrC52BtXTshZdCw1/VrHGZZu6AtjU8qj7a0mge4M3
         ccmIOfmTWqK3daJVScO7JcRrVavKtl3ebSFu08Ojck3XPV4++u8xQrp6SOLFp4V2kzRe
         HUn/hnKpSWrTa1yl5JVL9QO/0i67VtO3v5R4LYKQxfKf2nEd86+Y00gItkg9jbAdltDf
         PdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkNItopMnJPLDcqUfYehOqcAH438sPgLODJtMsLVzIA=;
        b=ZuTrI7dh0fASv3MPraDApKdddL5QQIv3fWf18WQAgqNRcsqo01AdiZbIJehS+WmQq3
         uiDZrBsmPduHzF1Ligd0tfEYs4gfM/anQIjwoPmFjcc/sxJddgeqGuXyZlZVd4t3AwIu
         0X54QPBUzcciZzBS+pHp4b+TlWcM+ceYHGTpfChvSlXHZMJmF3ICEqjgVAZuh8vCiVpK
         1hLI7wuqYMga5zO0qyvOih2S7dFTkKQgEXwXCMhlS485QmnIFO4nmnGqL9wtxEGMTbd4
         QdUehQBAlomzTxc8AuV2ysSbL1KgQr1P77vN9OZuGZ5mS/s7zcSRZUIuh97x4y+bP9Q/
         ngaQ==
X-Gm-Message-State: AOAM532rnK8Q4IFY2Z0y9VPlQub30L6yrt9vGK6PRg+5yo5YE1JpSwtN
        fCjODaKPkJDXr343y/spyW8=
X-Google-Smtp-Source: ABdhPJz6ijZvCZFZYruCViozlzDoEHrDy9QcAWKxnJ+/Cnk/zexzKofkqWeFvxCi0efwSIio2Vio/g==
X-Received: by 2002:a9d:19e8:: with SMTP id k95mr5475483otk.37.1616258583373;
        Sat, 20 Mar 2021 09:43:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:15d7:4991:5c5e:8e9d])
        by smtp.googlemail.com with ESMTPSA id 67sm2021620otv.5.2021.03.20.09.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 09:43:02 -0700 (PDT)
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dsahern@kernel.org
References: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
 <202103150433.OwOTmI15-lkp@intel.com>
 <72c4ccfc219c830f1d289c3d4c8a43aec6e94877.camel@gmail.com>
 <20210317.201948.1069484608502867994.davem@davemloft.net>
 <34107111-5293-2119-cfc7-8156c43ae555@gmail.com>
 <26d502c2efecf3ea1ffdd8784590697d02907e7a.camel@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <46640b57-350b-e616-ad96-03fda82eb86d@gmail.com>
Date:   Sat, 20 Mar 2021 10:43:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <26d502c2efecf3ea1ffdd8784590697d02907e7a.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/21 10:01 AM, Andreas Roeseler wrote:
> On Wed, 2021-03-17 at 21:24 -0600, David Ahern wrote:
>> On 3/17/21 9:19 PM, David Miller wrote:
>>> From: Andreas Roeseler <andreas.a.roeseler@gmail.com>
>>> Date: Wed, 17 Mar 2021 22:11:47 -0500
>>>
>>>> On Mon, 2021-03-15 at 04:35 +0800, kernel test robot wrote:
>>>> Is there something that I'm not understanding about compiling
>>>> kernel
>>>> components modularly? How do I avoid this error?
>>>
>>>>
>>> You cannot reference module exported symbols from statically linked
>>> code.
>>> y
>>>
>>
>> Look at ipv6_stub to see how it exports IPv6 functions for v4 code.
>> There are a few examples under net/ipv4.
> 
> Thanks for the advice. I've been able to make some progress but I still
> have some questions that I have been unable to find online.
> 
> What steps are required to include a function into the ipv6_stub
> struct? I've added the declaration of the function to the struct, but
> when I attempt to call it using <ipv6_stub->ipv6_dev_find()> the kernel
> locks up. Additionally, a typo in the declaration isn't flagged during
> compilation. Are there other places where I need to edit the ipv6_stub
> struct or include various headers? The examples I have looked at are
> <fib_semantics.c>, <nexthop.c>, and <udp.c> in the <net/ipv4> folder
> and they don't seem to do anything on the caller side of ipv6_stub, so
> I think I am not adding the function to ipv6_stub properly. I have been
> able to call other functions that currently exist in ipv6_stub, but not
> the one I  am attempting to add, so am I missing a step?

you probably did not add the default in net/ipv6/addrconf_core.c.

> 
> I've noticed that some functions such as <ipv6_route_input> aren't
> exported using EXPORT_SYMBOL when it is defined in
> <net/ipv6/af_inet6.c>, but it is still loaded into ipv6_stub. How can
> this be? Is there a different way to include symbols into ipv6_stub
> based on whether or not they are explicitly exported using
> EXPORT_SYMBOL?
> 

take a look at 1aefd3de7bc6 as an example of how to add a new stub.

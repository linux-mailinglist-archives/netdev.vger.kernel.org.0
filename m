Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84703465B8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhCWQyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbhCWQxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:53:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02062C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:53:39 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x126so14915048pfc.13
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vTQyC/+T6HDt7yeGsX0rkekS8X7jLhu45y96HCcvItE=;
        b=mFXHBt59tfi8gr47XFtcwTMKp5LaVAAYgcwe2v16PR/E1JYYvzHUWwopKrt8hEgn6l
         DYYzMSJZvejD9BbjghlY3EpvrdV+hjQj5ssV4Lbjo9HMpHmfsa0marXkM8UIe87jY06Q
         1b6Fe7eSffcZIibq/asT5pdUcmNTc0evmhEZcAJJodeCXghW0lpPEybt6kS//f60wHGy
         NYVoD2k+j66yqyjsKiBCk8UFer5iIufrQvF/27FyiGSx70TGloo4HvcnKcxSommYXdQ0
         bcAYiFtydEg29/0aTQ+iFOmrB2Nerh8mvI4ySc4roQP8l8O1o9xz7Whwo4sxWx1ZNwls
         TqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vTQyC/+T6HDt7yeGsX0rkekS8X7jLhu45y96HCcvItE=;
        b=GZyrg7tM7gZQNkNS1PWY8L6j5PnpCB/evLNCQGC2aly5+tIVoKqiPO1qOF3s7H6WCU
         YAWUCdjzWM0SYUQbHHRxsVW161Ldt+1sP2nqUT6ts+vc8MHAbTBDkPHMeSKEllo27Cng
         NYJZss8n6F7X+YaEJnqghm5ly64uO+6FLoZZo+oGNOLZLT6JX9G6KOlIkxEAr17B0U2l
         kwgwCUB+tEK5ve0HWBGJhrcU8Luuhxh+eJfuTNAUBf/LG6mEbcADESLcpXCFX2tjWjot
         3fDuBG8ESdgaSPpxzMhNiKHeOLU4Wdswt10p7QE25I546K4cYAHOghTxIeMhliwaBELO
         qKXg==
X-Gm-Message-State: AOAM5317u6wLWsdkGlI2ApqR8xiu3rOMi6POkfuNtxtyHJsZD297EJaT
        eL4IY/+gwXsDGN7KrdubqlbuSDB/k4Q=
X-Google-Smtp-Source: ABdhPJyxTaLU3xAUyvTWPcKnIHCGDWxaDUu6pJ1d9cQzQq8f0JcRpy4jM7XuEkUdH0PTdnB+23tX9w==
X-Received: by 2002:a17:902:780c:b029:e6:9193:56e2 with SMTP id p12-20020a170902780cb02900e6919356e2mr6616297pll.39.1616518417993;
        Tue, 23 Mar 2021 09:53:37 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v135sm2309407pgb.82.2021.03.23.09.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:53:37 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <YFnh4dEap/lGX4ix@lunn.ch> <87a6qulybz.fsf@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7dd44f34-c972-2b4f-2e71-ec25541feb46@gmail.com>
Date:   Tue, 23 Mar 2021 09:53:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87a6qulybz.fsf@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/2021 7:49 AM, Tobias Waldekranz wrote:
> On Tue, Mar 23, 2021 at 13:41, Andrew Lunn <andrew@lunn.ch> wrote:
>> On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
>>> All devices are capable of using regular DSA tags. Support for
>>> Ethertyped DSA tags sort into three categories:
>>>
>>> 1. No support. Older chips fall into this category.
>>>
>>> 2. Full support. Datasheet explicitly supports configuring the CPU
>>>    port to receive FORWARDs with a DSA tag.
>>>
>>> 3. Undocumented support. Datasheet lists the configuration from
>>>    category 2 as "reserved for future use", but does empirically
>>>    behave like a category 2 device.
>>>
>>> Because there are ethernet controllers that do not handle regular DSA
>>> tags in all cases, it is sometimes preferable to rely on the
>>> undocumented behavior, as the alternative is a very crippled
>>> system. But, in those cases, make sure to log the fact that an
>>> undocumented feature has been enabled.
>>
>> Hi Tobias
>>
>> I wonder if dynamic reconfiguration is the correct solution here. By
>> default it will be wrong for this board, and you need user space to
>> flip it.
>>
>> Maybe a DT property would be better. Extend dsa_switch_parse_of() to
>> look for the optional property dsa,tag-protocol, a string containing
>> the name of the tag ops to be used.
> 
> This was my initial approach. It gets quite messy though. Since taggers
> can be modules, there is no way of knowing if a supplied protocol name
> is garbage ("asdf"), or just part of a module in an initrd that is not
> loaded yet when you are probing the tree. Even when the tagger is
> available, there is no way to verify if the driver is compatible with
> it. So I think we would have to:
> 
> - Keep the list of protcol names compiled in with the DSA module, such
>   that "edsa" can be resolved to DSA_TAG_PROTO_EDSA without having the
>   tagger module loaded.
> 
> - Add (yet) another op so that we can ask the driver if the given
>   protocol is acceptable. Calling .change_tag_protocol will not work as
>   drivers will assume that the driver's .setup has already executed
>   before it is called.
> 
> - Have each driver check (during .setup?) if it should configure the
>   device to use its preferred protocol or if the user has specified
>   something else.
> 
> That felt like a lot to take on board just to solve a corner case like
> this. I am happy to be told that there is a much easier way to do it, or
> that the above would be acceptable if there isn't one.
> 

The other problem with specifying the tag within the Device Tree is that
you are half way between providing a policy (which tag to use) and
describing how the hardware works (which tag is actually supported).
FWIW, the b53/bcm_sf2 binding allows one to specify whether an internal
port should have Broadcom tags enabled because the accelerator behind
that port would require it (brcm,use-bcm-hdr).
-- 
Florian

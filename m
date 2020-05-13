Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5C01D0504
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgEMCeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgEMCeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:34:18 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0D8C061A0C;
        Tue, 12 May 2020 19:34:16 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s21so4756562ejd.2;
        Tue, 12 May 2020 19:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BexOOVKnmpIZZBC/fF1IctNE9PejBGFf+i7lz8tMfvI=;
        b=qJVRnMozR02uRYbcHAY4myTHw/6v7lxiXeviqG/u1qpDLCP4FUlmMSduxIR1eNgaIT
         v39sbfBf7+LjtWMxPZgwner7F4sUfQjfOr6zeHSXB9rg/2hrGLNxzU5mON8WIYoL5avP
         nBRE8rhrdq6BiXvSYmRBK7RqXKcCeQrVow4FyiBN+/o6K2It+3N8bTWOZB7Sk6M6BNgX
         z9JFBMBA1DhYSKojhR0dv5gVDXXx8tCGBZIDwD4EVwet4jsSjL9W+zcwgyHOXJgSOSuh
         w3ZAt31GbSp6r9QvW35QeIhV7lxFKECsEzDpN7Z24Hc1cMRQ7gubdQHRQDHQeigAMB3O
         n2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BexOOVKnmpIZZBC/fF1IctNE9PejBGFf+i7lz8tMfvI=;
        b=QMd/lLXOjajXFzVXprX39vXRhhNYOg8ATva3PXiKW5j7ZJG/7YDJho9Ta2CBF8d0cC
         uxASKL5Cznad2s7exq8RrLFiLAx38c1noiWJk6QtLJrGprGtcyqCCvphhO4u+q6dgwP/
         PKe6NdmqLoKaevD4Sg7LVfPpQykpKVN+VnLRHa8h3bv6SFxewnt8AWw23jwhk/PAk7jX
         1Nx9YSa+NHgNag6Ok84LBm67rkJ89uXnK8ojg3kQGPydFDi59D6Y0PAYba2xadidvUfq
         0sLd3i5n1iRTNHjXqu7+1r/cBwee5+/C0mIwu+mvbod5CsiwyJrqLkf3tMELGblENZ8i
         wdgQ==
X-Gm-Message-State: AOAM533kejYpkxNlCl18rFeh8F5ksowKCPTSbxwVHeu2gJGqyfQMVV0d
        /KVIVWMDMB5C9zXhrUan/4pQFTHm
X-Google-Smtp-Source: ABdhPJxS/cAdTAULmKC+4n5eVkxH1YppfmMQD0eJxw+FRmGrgRF1gWUgxjnaQ1Pob0HebGx7lXrNTw==
X-Received: by 2002:a17:906:8cf:: with SMTP id o15mr1392837eje.351.1589337254662;
        Tue, 12 May 2020 19:34:14 -0700 (PDT)
Received: from [192.168.219.16] (ip72-219-184-175.oc.oc.cox.net. [72.219.184.175])
        by smtp.gmail.com with ESMTPSA id g20sm791648ejx.85.2020.05.12.19.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 19:34:14 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
 <20200512190855.GB9071@lion.mk-sys.cz>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <2afd5ca8-c913-6b58-7085-365036098468@gmail.com>
Date:   Tue, 12 May 2020 19:37:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512190855.GB9071@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/2020 12:08 PM, Michal Kubecek wrote:
> On Tue, May 12, 2020 at 11:31:39AM -0700, Doug Berger wrote:
>> On 5/11/2020 5:47 PM, Andrew Lunn wrote:
>>> On Mon, May 11, 2020 at 05:24:07PM -0700, Doug Berger wrote:
>>>> A comment in uapi/linux/ethtool.h states "Drivers should reject a
>>>> non-zero setting of @autoneg when autoneogotiation is disabled (or
>>>> not supported) for the link".
>>>>
>>>> That check should be added to phy_validate_pause() to consolidate
>>>> the code where possible.
>>>>
>>>> Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")
>>>
>>> Hi Doug
>>>
>>> If this is a real fix, please submit this to net, not net-next.
>>>
>>>    Andrew
>>>
>> This was intended as a fix, but I thought it would be better to keep it
>> as part of this set for context and since net-next is currently open.
>>
>> The context is trying to improve the phylib support for offloading
>> ethtool pause configuration and this is something that could be checked
>> in a single location rather than by individual drivers.
>>
>> I included it here to get feedback about its appropriateness as a common
>> behavior. I should have been more explicit about that.
>>
>> Personally, I'm actually not that fond of this change since it can
>> easily be a source of confusion with the ethtool interface because the
>> link autonegotiation and the pause autonegotiation are controlled by
>> different commands.
>>
>> Since the ethtool -A command performs a read/modify/write of pause
>> parameters, you can get strange results like these:
>> # ethtool -s eth0 speed 100 duplex full autoneg off
>> # ethtool -A eth0 tx off
>> Cannot set device pause parameters: Invalid argument
>> #
>> Because, the get read pause autoneg as enabled and only the tx_pause
>> member of the structure was updated.
> 
> This would be indeed unfortunate. We could use extack to make the error
> message easier to understand but the real problem IMHO is that
> ethtool_ops::get_pauseparam() returns value which is rejected by
> ethtool_ops::set_pauseparam(). This is something we should avoid.
> 
> If we really wanted to reject ethtool_pauseparam::autoneg on when
> general autonegotiation is off, we would have to disable pause
> autonegotiation whenever general autonegotiation is disabled. I don't
> like that idea, however, as that would mean that
> 
>   ethtool -s dev autoneg off ...
>   ethtool -s dev autoneg on ...
> 
> would reset the setting of pause autonegotiation.
> 
> Therefore I believe the comment should be rather replaced by a warning
> that even if ethtool_pauseparam::autoneg is enabled, pause
> autonegotiation is only active if general autonegotiation is also
> enabled.
> 
> Michal
> 
Thanks for your reply.

I agree with your concerns and will remove this commit from the set when
I resubmit. I also favor replacing the comment in ethtool.h.

-Doug

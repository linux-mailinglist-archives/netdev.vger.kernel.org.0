Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9622B211721
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgGBA03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgGBA03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:26:29 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11E9C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:26:28 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l2so24107344wmf.0
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 17:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eb+0xe1x0DWf6rHKc0uuwr/+ETClzZPNOmh9ZaJWS0k=;
        b=X87BQhno8QfbhrzVhmdSE+hQJDJbHm0x+rH3YbCFqfwZETSAXbXY3KE8phHfjE/O6X
         a8060cIsYWLvyDpzyARCxIh6fhqbwH/zMrYbiNa+adod/wrNbiFvo/hPhuYvqeUeEIxV
         Ntih4wVGkfF5pyK/jEWLM1uSaZBNO3yzwKEOkNWrYxYcyDjrkpceuD6F2FRb2nzsKoLW
         oKffU9WNF15L7uvTjy7zUDPwiu0HdVlQbWwe6vipiFyrzTW7rzCcslia6SvZ9qfwYpuK
         G//vl4Gd/ZiUPOrEJ0ZUbhmx/5cfeIYV42XdltccYxxc/d/L3f6W4DpLT2EyLFCkcKKQ
         arOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eb+0xe1x0DWf6rHKc0uuwr/+ETClzZPNOmh9ZaJWS0k=;
        b=H8Mt79EYS4qpN5sqKhHB+ixfc9Dz3ct4Olyo2PYIgASKt6NSjy4b1+QjWAdnw4wt0T
         LxUTR4Iu4ey38Fi1iQfPq808cGHMxN0Hjmbv+3YyBKfhzTKQCELJX/+PsHzJ6Ww3cV65
         zagOA71o3FhiqsWOlZ/bOsgrnnZspCHzJYHKTqlwH82QVlootwicjqWNPKyn9L/GT6bC
         1dibvE1yiO8rpv09uT9L8sHvr5tBT2QDPJOaNRA3VD0+pmr/ARU1MFnaeT7zZZKlEkT5
         feGw75P0gLE+MoHW9ZeqgljN4pqhpbYw0C39wfFc70bhhgOTJlD5CcSyqLyByysbuaT0
         9d+A==
X-Gm-Message-State: AOAM53387PAmQAPT9742BYEgZVAw4nRnk+5Nze6Ay3g5/BUI/vNPb6o0
        bUmhNsHggm77MeBhBd9nhsM=
X-Google-Smtp-Source: ABdhPJz8+8Ovo84lph0atWEOgWqTDkZI9e8lr/lZYj7CKonaT7Xafzf48yn7zcqeptxvUfrDarP5lw==
X-Received: by 2002:a1c:c90a:: with SMTP id f10mr28819482wmb.121.1593649587470;
        Wed, 01 Jul 2020 17:26:27 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm10155661wrg.70.2020.07.01.17.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 17:26:26 -0700 (PDT)
Subject: Re: [PATCH net-next v4 03/10] net: ethtool: netlink: Add support for
 triggering a cable test
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, hkallweit1@gmail.com,
        cphealy@gmail.com, mkubecek@suse.cz
References: <20200510191240.413699-1-andrew@lunn.ch>
 <20200510191240.413699-5-andrew@lunn.ch>
 <20200701155621.2b6ea9b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200701.160014.637327748926165441.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <944f629f-97f1-61a4-e3ab-50219a1cd8a7@gmail.com>
Date:   Wed, 1 Jul 2020 17:26:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200701.160014.637327748926165441.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/2020 4:00 PM, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 1 Jul 2020 15:56:21 -0700
> 
>> On Sun, 10 May 2020 21:12:33 +0200 Andrew Lunn wrote:
>>> diff --git a/net/Kconfig b/net/Kconfig
>>> index c5ba2d180c43..5c524c6ee75d 100644
>>> --- a/net/Kconfig
>>> +++ b/net/Kconfig
>>> @@ -455,6 +455,7 @@ config FAILOVER
>>>  config ETHTOOL_NETLINK
>>>  	bool "Netlink interface for ethtool"
>>>  	default y
>>> +	depends on PHYLIB=y || PHYLIB=n
>>>  	help
>>>  	  An alternative userspace interface for ethtool based on generic
>>>  	  netlink. It provides better extensibility and some new features,
>>
>> Since ETHTOOL_NETLINK is a bool we end up not enabling it on
>> allmodconfig builds, (PHYLIB=m so ETHTOOL_NETLINK dependency 
>> can't be met) - which is v scary for build testing.
>>
>> Is there a way we can change this dependency? Some REACHABLE shenanigans?
>>
>> Or since there are just two callbacks maybe phylib can "tell" ethtool
>> core the pointers to call when it loads?
> 
> This has been discussed a few times and it's very irritating to me as well
> as allmodconfig is the standard test build I do for all new changes.

Yes this is annoying, I will have some patches posted tonight that
untangle the dependency.
-- 
Florian

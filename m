Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004F81B942A
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZVUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725996AbgDZVT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 17:19:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC28C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:19:59 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z1so6216628pfn.3
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oXEu0D/CG9Yfl70RSoo1Itj7KqLjK6tC2dP6u5kTPEY=;
        b=hVjbixCN95XIt2geyGI9R5ZutAJxoT2pvX/CoKiyxU0dqGroymhL1kHz57e854aTJ1
         rtnMFnm6krvj4VcY1BWSyfzKiVvp3a6d56ngGr8/Q7g9x4BNCSdQU2eo+IFvWTeqXXAj
         lfC+UGWMJl8fiwXOS2bTLXVJp6TfJPYTYHyfJnSKqZhHy2Z1vN85HQOWYPW73Qvv/Sdm
         D3SLDGetsLSej9nXbcZMchxakGWeqjITbIX7P0cNW37/b62sqCO1QrNlepkwyqksdqoe
         Fd+QuUe5BAy8SgUy16/CGGXZt++lu9E37w40Vn2dQMdYlRZGTvro3aDdYomncGsbIZiz
         tfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oXEu0D/CG9Yfl70RSoo1Itj7KqLjK6tC2dP6u5kTPEY=;
        b=Dtx69Ld56BGid92WU3Hajd/oQMNDFvXoXbVq2wOe/ZquO1HDjHeI3wMS8lPf0t/J+L
         kmjyrnDGKRwgUFAJ2gJrS0ER614wuNRlKKw47swXW6nLlbIk3xHISVlZF3vmMWKGcuLr
         qaYeG+YcZQcOhGzj8PmkhZVu787b4mM3HFTCD/3f51Sw2m606LHs4JwMRo/YvR8Yg61X
         UK5m3DU3PaSDQllEUA/AfawUT76swuCczNq+g4xuYJGaYR+8bWBzcBpXKMzQwE5e3rvn
         1iOY8nNfXSwacAp+O3ivE6iD1nwm9kaQoFaJEbyIbZ/x/bobBopFffwg0rJNQ+ocaJeo
         UMww==
X-Gm-Message-State: AGi0PuZHpgKXaq0EA9ZgKjGgHwQh5CRfAH0PEzpcnR3Tk2wevRibTNQw
        RW+wNQl9rXFg5mkhw5XVFRa4q+QL
X-Google-Smtp-Source: APiQypJt9sG4dR5d1C3TAY9EBcIXxp181EtLNzIBQp57USwJ5LB19JsWYfE9SYvuiNwn2yXGquDpnA==
X-Received: by 2002:a63:e841:: with SMTP id a1mr20816308pgk.64.1587935998783;
        Sun, 26 Apr 2020 14:19:58 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w30sm10724066pfj.25.2020.04.26.14.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 14:19:57 -0700 (PDT)
Subject: Re: [PATCH net-next v1 2/9] net: phy: Add support for polling cable
 test
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-3-andrew@lunn.ch>
 <7557316a-fc27-ac05-6f6d-b9bac81afd82@gmail.com>
 <20200425201014.GF1088354@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <52b62cec-cb65-03a4-f5c2-e36d0d0ff8d3@gmail.com>
Date:   Sun, 26 Apr 2020 14:19:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200425201014.GF1088354@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/25/2020 1:10 PM, Andrew Lunn wrote:
> On Sat, Apr 25, 2020 at 12:49:46PM -0700, Florian Fainelli wrote:
>> Hi Andrew,
>>
>> On 4/25/2020 11:06 AM, Andrew Lunn wrote:
>>> Some PHYs are not capable of generating interrupts when a cable test
>>> finished. They do however support interrupts for normal operations,
>>> like link up/down. As such, the PHY state machine would normally not
>>> poll the PHY.
>>>
>>> Add support for indicating the PHY state machine must poll the PHY
>>> when performing a cable test.
>>>
>>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>>
>> If you started a cable test and killed the ethtool process before the
>> cable diagnostics are available, the state machine gets stuck in that
>> state, so we should find a way to propagate the signal all the way to
>> the PHY library somehow.
> 
> Hi Florian
> 
> It should not matter if the user space tool goes away. As you read
> later patches you will see why. But:
> 
> ETHTOOL_MSG_CABLE_TEST_ACT is an action to trigger cable
> test. Assuming the driver supports it etc, the cable test is started,
> and user space immediately gets a ETHTOOL_MSG_CABLE_TEST_ACT_REPLY.
> The state is changed to PHY_CABLETEST.
> 
> Sometime later, the driver indicates the cable test has
> completed. This can be an interrupt, or because it is being polled.  A
> ETHTOOL_MSG_CABLE_TEST_NTF is multicast to user space with the
> results. And the PHY then leaves state PHY_CABLETEST. If there is no
> user space listening for the ETHTOOL_MSG_CABLE_TEST_NTF, it does not
> matter.
> 
> At least with the Marvell PHY, there is no documented way to tell it
> to abort a cable test. So knowing the user space has lost interest in
> the results does not help us.

The same is true with Broadcom PHYs, but I think we should be guarding
somehow against the PHY state machine being left in PHY_CABLETEST state
with no other way to recover than do an ip link set down/up in order to
recover it. We can try to tackle this as an improvement later on.
-- 
Florian

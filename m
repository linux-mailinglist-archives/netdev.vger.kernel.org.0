Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65EA1D1DC2
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390122AbgEMSpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732817AbgEMSpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:45:23 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54519C061A0C;
        Wed, 13 May 2020 11:45:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so14818674wmd.0;
        Wed, 13 May 2020 11:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PT0h38OrQXBZNljpCzZiDCJfv+srQ4T4K6VCcISjh+o=;
        b=NHowZjspfC1uKoskgjqurh5XM01XVemx028k1uB5QSSJGeckopvvuRfoP7Ph7C1Bae
         p6NNvDqJn3yPU7tYzSjUkLinU7xd4nIAluUncZ1HtOoyQfmDjfOpDb4y7rv6fWpGclVS
         HrEDNiMnSpu42yqpr7IWBM/Ol8YKYKl3rNbn4RzTOBnyDKL98MjdhSPckmZt2Vjsfrnu
         990+9LIyR9pJ/jhc3hexg9Ep0NfAB4dmIiAmqvyecmdeTWeFnseoMAJbHJvIX5IFxsMS
         Kztf6GncPinBZz5vvZanuk0XSst5splnVFrOUgHAZIpioL/RpVdGpyKHa4ebSZa5ErZP
         3SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PT0h38OrQXBZNljpCzZiDCJfv+srQ4T4K6VCcISjh+o=;
        b=K6qUd6TB27RGkZu+oV4RW+JCX2tE3CrN/uqoJfuUHwSICPtqPZH0hfK33zO1ezPfT6
         mia7u3jKIcvKTLfwCV3mHh6LixddwG5M+XRCjhUBHRYp5ORdcM1IO86qraeQKwYUQZnc
         5q7xSWszWgTrMDHnS4EikhXt6pEqfH3xBF0oERNlHrmCEkHi7Eqvhlh60p4Tza+GVUmm
         Tj1Obp4BNCeFRDcMtruEc7hsPvmmsA0yzBmuB8YRi/w6+oe1LwsHL7eB3Mxf81JbkZNI
         1kPGGWUEQ71z1btDPcVwyca+uLVWs7Lq2yBEuJe1k4Fmflq7yIdk8HcDldWCK3kgE2cM
         Hliw==
X-Gm-Message-State: AGi0PuacsiakkL573npox4/OI124zlXH3/TQDDGxEifRKN7Dat6W+RF7
        P0dO+tVyRYKJ+e2am4hgVQjcnbsw
X-Google-Smtp-Source: APiQypIK8q7L1drcKLYh9sEaASQ4rq35pqJ+J+If2G/yEeThC9w9wm9XnhpfjzopaeqgVblnzpPmLg==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr40509019wmb.156.1589395521755;
        Wed, 13 May 2020 11:45:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:f910:f6a0:7ae2:caf7? (p200300EA8F285200F910F6A07AE2CAF7.dip0.t-ipconnect.de. [2003:ea:8f28:5200:f910:f6a0:7ae2:caf7])
        by smtp.googlemail.com with ESMTPSA id v124sm37638214wme.45.2020.05.13.11.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 11:45:21 -0700 (PDT)
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200512184601.40b1758a@xhacker.debian>
 <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
 <20200513145151.04a6ee46@xhacker.debian>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a0aac85d-064f-2672-370b-404fd83e83f3@gmail.com>
Date:   Wed, 13 May 2020 20:45:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513145151.04a6ee46@xhacker.debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.05.2020 08:51, Jisheng Zhang wrote:
> Hi,
> 
> On Tue, 12 May 2020 20:43:40 +0200 Heiner Kallweit wrote:
> 
>>
>>
>> On 12.05.2020 12:46, Jisheng Zhang wrote:
>>> The PHY Register Accessible Interrupt is enabled by default, so
>>> there's such an interrupt during init. In PHY POLL mode case, the
>>> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
>>> calling rtl8211f_ack_interrupt().  
>>
>> As you say "it's not good" w/o elaborating a little bit more on it:
>> Do you face any actual issue? Or do you just think that it's not nice?
> 
> 
> The INTB/PMEB pin can be used in two different modes:
> INTB: used for interrupt
> PMEB: special mode for Wake-on-LAN
> 
> The PHY Register Accessible Interrupt is enabled by
> default, there's always such an interrupt during the init. In PHY POLL mode
> case, the pin is always active. If platforms plans to use the INTB/PMEB pin
> as WOL, then the platform will see WOL active. It's not good.
> 
The platform should listen to this pin only once WOL has been configured and
the pin has been switched to PMEB function. For the latter you first would
have to implement the set_wol callback in the PHY driver.
Or where in which code do you plan to switch the pin function to PMEB?
One more thing to consider when implementing set_wol would be that the PHY
supports two WOL options:
1. INT/PMEB configured as PMEB
2. INT/PMEB configured as INT and WOL interrupt source active

> 
>> I'm asking because you don't provide a Fixes tag and you don't
>> annotate your patch as net or net-next.
> 
> should be Fixes: 3447cf2e9a11 ("net/phy: Add support for Realtek RTL8211F")
> 
>> Once you provide more details we would also get an idea whether a
>> change would have to be made to phylib, because what you describe
>> doesn't seem to be specific to this one PHY model.
> 
> Nope, we don't need this change in phylib, this is specific to rtl8211f
> 
> Thanks,
> Jisheng
> 
Heiner

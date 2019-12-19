Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FB2125BE2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 08:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfLSHKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 02:10:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37448 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfLSHKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 02:10:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so4449263wmf.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 23:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9+eZhKfnhFTWqVU5yD68HbJomafqSVC49U1bxgXOn9g=;
        b=mGLl/tRvr/xBWHbqI4elK7Bff87u0Ld+1wTvW9yemQTfTSqwy5pRpdcleqEcIAewO9
         0T8ZOFvKDDDRe9esnQryFc3qlurEEn6nRcoE11eiUaEeqZkyLFL8guKXkREfNHikx6f7
         6JfpDErGfvq4htre6mi7Xzg4Nw0Wg6QVB+ExGpoqaN0GsT0oqCqYCyfasymDy/CNAc5b
         X7SwqABxGfTLzr6KHc4sDzZ5v75KHDKZ9BUqcHw4csyC/5u+K37oxGlmSzWfVD61vmSA
         o4zz2Aqn+nrIKdHfZM/Zuf7DBgpPmn0xcg2o5MROnR0tWpSbsMLvJtQk2L+hpybIKXqz
         47DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+eZhKfnhFTWqVU5yD68HbJomafqSVC49U1bxgXOn9g=;
        b=VJSR4ODQbmq/pITPOQ/s0p4t749jbcyvMF8Ouqa2Bn7nTJ6SE2muFugOL13gIbzLr2
         Uu054JyxZa7cR5maH14oGgWPAT/SVDBmUFCpovzTEantB1rv79T4Csp/YyIIkh7ec1Ch
         +26vLNvqg2/fgrfYTMhl8hjYcWDQOBO9GpE5nNMpsB/b6MKeo2l6eTJvg0SsDSLx0PD0
         eqfuIrFlR12eItKyYJM7jx9AkvaEl25RFEqfA1sor1uQ8+7/ot65wF38icEkiBlOIftp
         sXF9uIDGqMh5WWP3emWpaaMxpEM0jIefgYFd2nLTIKLZm/ppDLYNDDunqbGZrbAW9Dqy
         XN0w==
X-Gm-Message-State: APjAAAUPbEQ0hJJAGduOaSUWskBiAuNgKwjl1fPTqjb1u9CtLbltg3Ud
        zaFJX75xnRi4bTWal5OkkCBQOglB
X-Google-Smtp-Source: APXvYqz9bQwWwW+t2Gq6IJ+vTxdqjI5Vpv/qSK+XTF61HsVlSebM5QA307zZ+5dSlvEo/wCQ8u/uDQ==
X-Received: by 2002:a7b:cc98:: with SMTP id p24mr7910028wma.139.1576739430814;
        Wed, 18 Dec 2019 23:10:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:edcc:f13f:926c:a126? (p200300EA8F4A6300EDCCF13F926CA126.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:edcc:f13f:926c:a126])
        by smtp.googlemail.com with ESMTPSA id e18sm5420196wrw.70.2019.12.18.23.10.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 23:10:30 -0800 (PST)
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
 <20191217233436.GS25745@shell.armlinux.org.uk>
 <61f23d43-1c4d-a11e-a798-c938a896ddb3@gmail.com>
 <20191218220908.GX25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8f7411c7-f420-4a31-38ef-6a2af6c56675@gmail.com>
Date:   Thu, 19 Dec 2019 08:10:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191218220908.GX25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.12.2019 23:09, Russell King - ARM Linux admin wrote:
> On Wed, Dec 18, 2019 at 09:54:32PM +0100, Heiner Kallweit wrote:
>> On 18.12.2019 00:34, Russell King - ARM Linux admin wrote:
>>> On Tue, Dec 17, 2019 at 10:41:34PM +0100, Heiner Kallweit wrote:
>>>> On 17.12.2019 13:53, Russell King wrote:
>>>>> phy_error() is called from phy_interrupt() or phy_state_machine(), and
>>>>> uses WARN_ON() to print a backtrace. The backtrace is not useful when
>>>>> reporting a PHY error.
>>>>>
>>>>> However, a system may contain multiple ethernet PHYs, and phy_error()
>>>>> gives no clue which one caused the problem.
>>>>>
>>>>> Replace WARN_ON() with a call to phydev_err() so that we can see which
>>>>> PHY had an error, and also inform the user that we are halting the PHY.
>>>>>
>>>>> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
>>>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>>>>> ---
>>>>> There is another related problem in this area. If an error is detected
>>>>> while the PHY is running, phy_error() moves to PHY_HALTED state. If we
>>>>> try to take the network device down, then:
>>>>>
>>>>> void phy_stop(struct phy_device *phydev)
>>>>> {
>>>>>         if (!phy_is_started(phydev)) {
>>>>>                 WARN(1, "called from state %s\n",
>>>>>                      phy_state_to_str(phydev->state));
>>>>>                 return;
>>>>>         }
>>>>>
>>>>> triggers, and we never do any of the phy_stop() cleanup. I'm not sure
>>>>> what the best way to solve this is - introducing a PHY_ERROR state may
>>>>> be a solution, but I think we want some phy_is_started() sites to
>>>>> return true for it and others to return false.
>>>>>
>>>>> Heiner - you introduced the above warning, could you look at improving
>>>>> this case so we don't print a warning and taint the kernel when taking
>>>>> a network device down after phy_error() please?
>>>>>
>>>> I think we need both types of information:
>>>> - the affected PHY device
>>>> - the stack trace to see where the issue was triggered
>>>
>>> Can you please explain why the stack trace is useful.  For the paths
>>> that are reachable, all it tells you is whether it was reached via
>>> the interrupt or the workqueue.
>>>
>>> If it's via the interrupt, the rest of the backtrace beyond that is
>>> irrelevant.  If it's the workqueue, the backtrace doesn't go back
>>> very far, and doesn't tell you what operation triggered it.
>>>
>>> If it's important to see where or why phy_error() was called, there
>>> are much better ways of doing that, notably passing a string into
>>> phy_error() to describe the actual error itself.  That would convey
>>> way more useful information than the backtrace does.
>>>
>>> I have been faced with these backtraces, and they have not been at
>>> all useful for diagnosing the problem.
>>>
>> "The problem" comes in two flavors:
>> 1. The problem that caused the PHY error
>> 2. The problem caused by the PHY error (if we decide to not
>>    always switch to HALTED state)
>>
>> We can't do much for case 1, maybe we could add an errno argument
>> to phy_error(). To facilitate analyzing case 2 we'd need to change
>> code pieces like the following.
>>
>> case a:
>> err = f1();
>> case b:
>> err = f2();
>>
>> if (err)
>> 	phy_error()
>>
>> For my understanding: What caused the PHY error in your case(s)?
>> Which info would have been useful for analyzing the error?
> 
> Errors reading/writing from the PHY.
> 
> The problem with a backtrace from phy_error() is it doesn't tell you
> where the error actually occurred, it only tells you where the error
> is reported - which is one of two different paths at the moment.
> That can be achieved with much more elegance and simplicity by
> passing a string into phy_error() to describe the call site if that's
> even relevant.
> 
> I would say, however, that knowing where the error occurred would be
> far better information.
> 
AFAICS PHY errors are typically forwarded MDIO access errors.
PHY driver callback implementations could add own error sources,
but from what I've seen they don't. Instead of the backtrace in
phy_error() we could add a WARN_ONCE() to __mdiobus_read/write.
Then the printed call chain should be more useful.
If somebody wants to analyze in more detail, he can switch on
MDIO access tracing.

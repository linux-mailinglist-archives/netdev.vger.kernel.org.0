Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327B83166A7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBJM2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbhBJM1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:27:33 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9CDC061574;
        Wed, 10 Feb 2021 04:26:50 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id 7so2324551wrz.0;
        Wed, 10 Feb 2021 04:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zaAiccKhdYKohOThyxdMeY3++MflQDg2SHWrVMMBd28=;
        b=LPHkxIAI3gDdp6Ueq77noY/DMUiyP/+JJgM7kP7C69PDGGfOtxHg7VB45sTPBK06DW
         x38GIHGXK7RXOIsOTOard0/bGAF9FqA6AXhV7OZu14s+C8G9to8/ucDuZiTBuU+1Orfr
         Ekni9KtEe95a+xQ6mx6wx3phWYCMZFhakm0FDQgsXAUFFLdfHAYoKitDOdjEWhQbfzxS
         Fen2G2XLf31KY0wHxLleRRSoTWTFi+XOtvKuoLwQGB+1MbrFpxphcTGeTCpQu3r63qf/
         ctSNyEwBCfbcStRLKNrea5OaHMXh1ScCoNSCpf2ZOFgVeZ6K2Zl2vDogd0xcv2MKLfsn
         4S3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zaAiccKhdYKohOThyxdMeY3++MflQDg2SHWrVMMBd28=;
        b=HOC/vZMeCWLlIBW+/Ye3qzkrxpXtoI5o2PPwWLfDRebrATrLv1TqXUz8KvpwoTS+AF
         8Xc2F3sxdtgiXY6uZPMrrpRS2rdaamn/EyGYtZMu/s1LpJpDWrcCtKl/RxBSuvL3CrXj
         yD3uOJH+xAEiZJo84tyU6mZa3MaX0ZHCbwlx0F4GuA0iR0NTf1Xtgci/cvVVuAy9qO/i
         w3DV9btadTsjy8h8Z+w/Q2Oi5LpGhRb08Baq9uM+1GRbgVhpSlbi1E1MH9zJjaatpQWl
         dbGHmsN44eb9Ut4Fd0UtNiSpDE8Ce3pahZkaKVZOe9nmF8kCslPbP+LT4S7kdR1PDqYF
         g4PQ==
X-Gm-Message-State: AOAM533NcvrOTWL1Rf2kRWbzO8a9czG19oDAR/r1RQrsNOYJ4a6IBW3C
        N4KLeaaABpc7vBdIgsUVTWMsl9Ot/JmGeQ==
X-Google-Smtp-Source: ABdhPJygPtI7Q9Eo4HxNZO+kR+er3AOnJAkzNaby8gSmQGB/YhdvQ5NPiTJ+U7nGIAfVRQYb95i2sQ==
X-Received: by 2002:adf:fc88:: with SMTP id g8mr3314994wrr.259.1612960009449;
        Wed, 10 Feb 2021 04:26:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id w11sm2207089wmi.37.2021.02.10.04.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 04:26:49 -0800 (PST)
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
To:     Michael Walle <michael@walle.cc>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
 <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
 <20210210104900.GS1463@shell.armlinux.org.uk>
 <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
 <20210210114826.GU1463@shell.armlinux.org.uk>
 <1a751f7fe316d58b9846ecfa0dcdc02b@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c905d445-039f-ba98-9814-4e35546e1366@gmail.com>
Date:   Wed, 10 Feb 2021 13:26:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1a751f7fe316d58b9846ecfa0dcdc02b@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.2021 13:17, Michael Walle wrote:
> Am 2021-02-10 12:48, schrieb Russell King - ARM Linux admin:
>> On Wed, Feb 10, 2021 at 12:14:35PM +0100, Michael Walle wrote:
>>> Am 2021-02-10 11:49, schrieb Russell King - ARM Linux admin:
>>> The PHY doesn't support fiber and register 0..15 are always available
>>> regardless of the selected page for the IP101G.
>>>
>>> genphy_() stuff will work, but the IP101G PHY driver specific functions,
>>> like interrupt and mdix will break if someone is messing with the page
>>> register from userspace.
>>>
>>> So Heiner's point was, that there are other PHY drivers which
>>> also break when a user changes registers from userspace and no one
>>> seemed to cared about that for now.
>>>
>>> I guess it boils down to: how hard should we try to get the driver
>>> behave correctly if the user is changing registers. Or can we
>>> just make the assumption that if the PHY driver sets the page
>>> selection to its default, all the other callbacks will work
>>> on this page.
>>
>> Provided the PHY driver uses the paged accessors for all paged
>> registers, userspace can't break the PHY driver because we have proper
>> locking in the paged accessors (I wrote them.) Userspace can access the
>> paged registers too, but there will be no locking other than on each
>> individual access. This can't be fixed without augmenting the kernel/
>> user API, and in any case is not a matter for the PHY driver.
>>
>> So, let's stop worrying about the userspace paged access problem for
>> driver reviews; that's a core phylib and userspace API issue.
>>
>> The paged accessor API is designed to allow the driver author to access
>> registers in the most efficient manner. There are two parts to it.
>>
>> 1) the phy_*_paged() accessors switch the page before accessing the
>>    register, and restore it afterwards. If you need to access a lot
>>    of paged registers, this can be inefficient.
>>
>> 2) phy_save_page()..phy_restore_page() allows wrapping of __phy_*
>>    accessors to access paged registers.
>>
>> 3) phy_select_page()..phy_restore_page() also allows wrapping of
>>    __phy_* accessors to access paged registers.
>>
>> phy_save_page() and phy_select_page() must /always/ be paired with
>> a call to phy_restore_page(), since the former pair takes the bus lock
>> and the latter releases it.
>>
>> (2) and (3) allow multiple accesses to either a single page without
>> constantly saving and restoring the page, and can also be used to
>> select other pages without the save/restore and locking steps. We
>> could export __phy_read_page() and __phy_write_page() if required.
>>
>> While the bus lock is taken, userspace can't access any PHY on the bus.
> 
> That was how the v1 of this series was written. But Heiner's review
> comment was, what if we just set the default page and don't
> use phy_save_page()..phy_restore_page() for the registers which are
> behind the default page. And in this case, userspace _can_ break
> access to the paged registers.
> 

The comment was assuming that paging also applies to register 0..15,
like it is the case for Realtek PHY's. That's not the case for your
PHY, therefore the situation is slightly different.


> -michael


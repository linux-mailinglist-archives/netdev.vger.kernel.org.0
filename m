Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD54340DA1
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhCRS6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhCRS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:58:13 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B77C06174A;
        Thu, 18 Mar 2021 11:58:13 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v2so2049259pgk.11;
        Thu, 18 Mar 2021 11:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xBIgRnYWQtRwE9QtCvp+KHIBmP9kBbKy+SrEtU2y3qQ=;
        b=DbnBZS59P8ThzX9E3IqHqpcDFrNZShZyvnN0hUSOD3iXTBlA2hIu/71IHy/R4+F4kI
         JukEY8kd9za8ZpZxEtsexxi3DnykgF5P1/9KGlMf3tPqtZVJrnRvgRNpuMBCUyHyySNm
         O/Q6pdYBRv7YDtlBB9vB/jtBHSi7xEvFIQgSz4WhOez+ZCywFM4kWv0QbeNQm2iYXgEY
         qxSJiGtSlfCntmEnOJpCUCRO6k5jehp493N9jKQYUYGkBegDS1CmJKiLdMixU62zvsIu
         oNpdILs93EvvGW3PF0AA+kyaMQw/OXr96bhZE14Bsl83JeywqFiPGQjJrIy2+TAGnLNH
         sKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xBIgRnYWQtRwE9QtCvp+KHIBmP9kBbKy+SrEtU2y3qQ=;
        b=FPKB1/JttMVCcs2gUUS7VPUojcuoYr5f8zMIeoH8FbQNy0j+9dl4LkmTkHK5MTRFLH
         Q+iPiOyt7Dtc9G4vkd55ZDPIAdZD2PsUVuJNFuHVbqrg5Ixq4/iwwvclJ2HLLVFJdC7L
         +Md6sbsGvj2bCu5M0Zun+D6AHO2gOkZt+W+ismUA6YeejrTGtlYj/mGPPKuphhpqGqjq
         09JtLCvX0ib8pnYx86v1UvHI7ELIoNo3vAoKLVQbWTOd6Wq6DhT92F6NzxTYqE5tP9gi
         tcuafuy8wXB8J7AvzL8OB77J+5xgAMhL0fYOyv/A/xvK3CSTjbmPhnT2syQslaqwZkQp
         IzWA==
X-Gm-Message-State: AOAM531p/rarRAIFYZ6PiQlyDwlcT2HrMj1xaI1FrZ8cs5rN33w38Zbf
        ueLaXY2oX7XjrlBmSSpjPD8=
X-Google-Smtp-Source: ABdhPJz0OlEo8YsjOGPfoOqtFr3/5TRoo4H6GQaspwuyBcAls631WvdEBzHROZ61QqiHu6+N0YVMRA==
X-Received: by 2002:a65:5bc6:: with SMTP id o6mr7985950pgr.127.1616093892323;
        Thu, 18 Mar 2021 11:58:12 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b140sm3145269pfb.98.2021.03.18.11.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:58:11 -0700 (PDT)
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
 <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com> <YFOYclhA75hjmQHY@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <665e347d-b4fc-b893-0317-3d04624fc1ba@gmail.com>
Date:   Thu, 18 Mar 2021 11:58:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFOYclhA75hjmQHY@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 11:14 AM, Greg KH wrote:
> On Thu, Mar 18, 2021 at 09:02:22AM -0700, Florian Fainelli wrote:
>>
>>
>> On 3/18/2021 6:25 AM, Heiner Kallweit wrote:
>>> On 18.03.2021 10:09, Wong Vee Khee wrote:
>>>> When using Clause-22 to probe for PHY devices such as the Marvell
>>>> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
>>>> which caused the PHY framework failed to attach the Marvell PHY
>>>> driver.
>>>>
>>>> Fixed this by adding a check of PHY ID equals to all zeroes.
>>>>
>>>
>>> I was wondering whether we have, and may break, use cases where a PHY,
>>> for whatever reason, reports PHY ID 0, but works with the genphy
>>> driver. And indeed in swphy_read_reg() we return PHY ID 0, therefore
>>> the patch may break the fixed phy.
>>> Having said that I think your patch is ok, but we need a change of
>>> the PHY ID reported by swphy_read_reg() first.
>>> At a first glance changing the PHY ID to 0x00000001 in swphy_read_reg()
>>> should be sufficient. This value shouldn't collide with any real world
>>> PHY ID.
>>
>> It most likely would not, but it could be considered an ABI breakage,
>> unless we filter out what we report to user-space via SIOGCMIIREG and
>> /sys/class/mdio_bus/*/*/phy_id
>>
>> Ideally we would have assigned an unique PHY OUI to the fixed PHY but
>> that would have required registering Linux as a vendor, and the process
>> is not entirely clear to me about how to go about doing that.
> 
> If you need me to do that under the umbrella of the Linux Foundation,
> I'll be glad to do so if you point me at the proper group to do that
> with.
> 
> We did this for a few years with the USB-IF and have a vendor id
> assigned to us for Linux through them, until they kicked us out because.
> But as the number is in a global namespace, it can't be reused so we
> keep it :)

We would still be creating what is technically an user-space interface
breakage since prior to a given kernel version we would return 0 for
that PHY OUI, and after another point it would be something different. I
don't know what software out there may be expecting to find 0 and not
determine that the PHY was fixed already because it is under
/sys/class/mdio_bus/fixed-0
-- 
Florian

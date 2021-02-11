Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBC131872A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 10:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBKJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 04:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhBKJaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 04:30:14 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D31C0617A9;
        Thu, 11 Feb 2021 01:29:20 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id i8so8974629ejc.7;
        Thu, 11 Feb 2021 01:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i1O66Ccjl4B43kYPV7+BV+8IE3O9O9r+dKZxev6XqqY=;
        b=hFN/6x07i6rQCx8/3+ZvH9dIIjXAhCz2Nozp4CxECTqUedtUfWZMlXyW6/BG/s5Bsn
         Z0xWfdnQISSGc7iBT7y2I1IMGJ82Zobryuk02p/A9Y5cns46kUR8E+2az0ZjzXJdhefR
         bXGNsbfIrN7Ui3MkoTp5gheC2gb+sGPO/c7YOPNKJHooKmCGw2vCm9tNFTTqGLx1KKt8
         jTTMAp6Q6yE+jrkq2p8gIQRbAAcfqfdhmC9VTT4KU7FCbt7vE77fRbEiv3efz4UvGqcI
         2Q1mkZhVMBExNilFnbPb51yPma5ioav+0wTEod1sbbxI1G7bcxsidB9fZIFtY3vM+Se/
         Y6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i1O66Ccjl4B43kYPV7+BV+8IE3O9O9r+dKZxev6XqqY=;
        b=gNI4iNEh9t5SBPJHZhdsTKkwhgUn2PnoCGFVUiBx2V+JCyhH7FyGHhsJr5gthORb0U
         rpxYpjb5EQTQOYcFrrqaYo/qqhEEriW4fXR7BzoHpU3DU8+bEKuM3mjK2zYpOzUI7LrN
         0gOQpBkQAB5jPw2Jl9V2Uv6ix1bYptnvaR/Sd9JPuZ3Y8LOt5BF+8/PcPxVejGtUUziR
         hdQuVUzC4KJLXAZIpCDlz0VsbwgDab/81Vje3so4Npbxy3kRxjeyV6VaSeYrthKvIIxW
         pb9fZmXxf28VptdRW2YUXNvz3hjgRrq+PmJT9lp84o4qbrKMMD6AdavUL2fQi5/24WM/
         PERw==
X-Gm-Message-State: AOAM532/hAZw40Q9HxFeZhBtY6c54kL1bnZjU6J35uvZgfpHrhgpshC1
        ZLBNsHssQVFnj+FxJF3RmlE=
X-Google-Smtp-Source: ABdhPJwJMZ3mfrU7uAqpt2HceMgbtn6CQVzpynHlLmv6gQ+WoYZJBethIo3AH+fvGtqvDFsGVNFv3g==
X-Received: by 2002:a17:906:7687:: with SMTP id o7mr7664153ejm.209.1613035758926;
        Thu, 11 Feb 2021 01:29:18 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:60ca:853:df03:450e? (p200300ea8f1fad0060ca0853df03450e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:60ca:853:df03:450e])
        by smtp.googlemail.com with ESMTPSA id u21sm3728257ejj.120.2021.02.11.01.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 01:29:18 -0800 (PST)
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRjmpKjK0pxKTCP@lunn.ch>
 <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
 <4f0086ad-1258-063d-0ace-fe4c6c114991@gmail.com>
 <CAGETcx_9bmeLzOvDp8eCGdWtfwZNajCBCNSbyx7a_0T=FcSvwA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
Message-ID: <2c5c95d8-07f3-1617-f98e-8b0a57dd1c97@gmail.com>
Date:   Thu, 11 Feb 2021 10:29:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAGETcx_9bmeLzOvDp8eCGdWtfwZNajCBCNSbyx7a_0T=FcSvwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2021 09:57, Saravana Kannan wrote:
> On Wed, Feb 10, 2021 at 11:31 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 11.02.2021 00:29, Saravana Kannan wrote:
>>> On Wed, Feb 10, 2021 at 2:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>>>
>>>> On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
>>>>> Hi,
>>>>>
>>>>> This email was triggered by this other email[1].
>>>>>
>>>>> Why is phy_attach_direct() directly calling device_bind_driver()
>>>>> instead of using bus_probe_device()?
>>>>
>>>> Hi Saravana
>>>>
>>>> So this is to do with the generic PHY, which is a special case.
>>>>
>>>> First the normal case. The MDIO bus driver registers an MDIO bus using
>>>> mdiobus_register(). This will enumerate the bus, finding PHYs on
>>>> it. Each PHY device is registered with the device core, using the
>>>> usual device_add(). The core will go through the registered PHY
>>>> drivers and see if one can drive this hardware, based on the ID
>>>> registers the PHY has at address 2 and 3. If a match is found, the
>>>> driver probes the device, all in the usual way.
>>>>
>>>> Sometime later, the MAC driver wants to make use of the PHY
>>>> device. This is often in the open() call of the MAC driver, when the
>>>> interface is configured up. The MAC driver asks phylib to associate a
>>>> PHY devices to the MAC device. In the normal case, the PHY has been
>>>> probed, and everything is good to go.
>>>>
>>>> However, sometimes, there is no driver for the PHY. There is no driver
>>>> for that hardware. Or the driver has not been built, or it is not on
>>>> the disk, etc. So the device core has not been able to probe
>>>> it. However, IEEE 802.3 clause 22 defines a minimum set of registers a
>>>> PHY should support. And most PHY devices have this minimum. So there
>>>> is a fall back driver, the generic PHY driver. It assumes the minimum
>>>> registers are available, and does its best to drive the hardware. It
>>>> often works, but not always. So if the MAC asks phylib to connect to a
>>>> PHY which does not have a driver, we forcefully bind the generic
>>>> driver to the device, and hope for the best.
>>>
>>> Thanks for the detailed answer Andrew! I think it gives me enough
>>> info/context to come up with a proper fix.
>>>
>>>> We don't actually recommend using the generic driver. Use the specific
>>>> driver for the hardware. But the generic driver can at least get you
>>>> going, allow you to scp the correct driver onto the system, etc.
>>>
>>> I'm not sure if I can control what driver they use. If I can fix this
>>> warning, I'll probably try to do that.
>>>
>> The genphy driver is a last resort, at least they lose functionality like
>> downshift detection and control. Therefore they should go with the
>> dedicated Marvell PHY driver.
>>
>> But right, this avoids the warning, but the underlying issue (probably
>> in device_bind_driver()) still exists. Would be good if you can fix it.
> 
> Yeah, I plan to fix this. So I have a few more questions. In the
> example I gave, what should happen if the gpios listed in the phy's DT
> node aren't ready yet? The generic phy driver itself probably isn't
> using any GPIO? But will the phy work without the GPIO hardware being
> initialized? The reason I'm asking this question is, if the phy is
> linked to a supplier and the supplier is not ready, should the
> device_bind_driver() succeed or not?
> 

There may be situations where the gpio is used for the PHY reset and
default state is "reset assigned". If we can't control the reset signal
then PHY isn't usable. Therefore I'm inclined to say we should not
succeed. Let's see which opinions Andrew and Russell have.

However I have a little bit of a hard time to imagine how this scenario
can happen. device_bind_driver(), as part of phy_attach_direct(),
is typically called from ndo_open() of the net device, like in
your stmmac case. Means user space would open the network interface
before the gpio controller has even been probed.

> -Saravana
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E2C459DC7
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhKWIYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhKWIYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:24:48 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A40C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 00:21:40 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id i5so37528776wrb.2
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 00:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=AHtili3AkZEHsw5FXf9CwCm4+BoMIzMWq+3cdKIz2Jc=;
        b=HaKfzP6blZQwirRvICAqdG2bEtnUrynvFSbV8f+N/sHnFZO1EDaKUV8IFUoYaSEzy+
         P78KO7+nZZ6NvDXav2QsBGpeBQvUOCJISSyCxEwNY/8BlpEqQjXvLRG4LCvHoHSVgXsL
         p168QhxQuHm4dhz+KsO7p1VX2Rl8svKVHVlTH7ml5T7eKJYUEVJmVoURaQHlilxn4GkQ
         oUcAvOdbx5bf0zX6HtYKhyskL08EyyDYxsJcOqxjt2lcDuMRYe0ZDKIb6ccTDkd9Cs0m
         Hy4iy1bWrWdF6m93Dnvmx/OVKCBRYul7Y1mqGRvgvFnJpKApdk5f48e7QOoQoIY+reoT
         uukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=AHtili3AkZEHsw5FXf9CwCm4+BoMIzMWq+3cdKIz2Jc=;
        b=SdsyHxF00RKbukL6rjJghZpqsANFXLsgcPvCRy/WxMzPEvG3qk1XH/UGAx7IJrQiMi
         iM/drcfqBLSTDJh43VLt4pD4mr92sSIcziVD+bqleRiXK83yWvFKeP2oUgNDB/J3IVf4
         UXR7o3ENw2E129GwHJlXfNmWMh2mdUkBP2OurHzgtkTYGjYYQwrTExlZqqGiDPa6U2ut
         rmhBcJX3OLfhU89mW6kVKBVLkdSUILk8/BwTeGG9HLR2p2Xd8ZLwpdbg13Q5rwAhrHeR
         vrl1WEEOwky6Vfk9ksazG1NdTtS7i/ZmX7058okdbLafBIsBz20tfxO5mvzzdmegPl/B
         HbMg==
X-Gm-Message-State: AOAM531bAo8+xdElTKDV2r8fS4SLzuzgUx5Tctnsn0ueP0Zu4DzMSfBp
        dGu52qsL+nYV2srGVC2u9+Rwkse7bYY=
X-Google-Smtp-Source: ABdhPJyQ/ZZH8WiabcFj4vhWV4sTmn9VcSrOvcFHYi88yNoWcwMKelsqP6DgiyPNYlqN5T0Fxis56Q==
X-Received: by 2002:a5d:4b0f:: with SMTP id v15mr5280370wrq.264.1637655698998;
        Tue, 23 Nov 2021 00:21:38 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:69ea:13ce:242:8b5b? (p200300ea8f1a0f0069ea13ce02428b5b.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:69ea:13ce:242:8b5b])
        by smtp.googlemail.com with ESMTPSA id z6sm521963wmp.9.2021.11.23.00.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:21:38 -0800 (PST)
Message-ID: <017ea94f-7caf-3d4e-5900-aa23a212aa26@gmail.com>
Date:   Tue, 23 Nov 2021 09:21:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Alessandro B Maurici <abmaurici@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <20211122235548.38b3fc7c@work> <YZxrhhm0YdfoJcAu@lunn.ch>
 <20211123014946.1ec2d7ee@work>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
In-Reply-To: <20211123014946.1ec2d7ee@work>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.11.2021 05:49, Alessandro B Maurici wrote:
> On Tue, 23 Nov 2021 05:18:14 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>> On Mon, Nov 22, 2021 at 11:55:48PM -0300, Alessandro B Maurici wrote:
>>> From: Alessandro B Maurici <abmaurici@gmail.com>
>>>
>>> Releases the phy lock before calling phy_link_change to avoid any worker
>>> thread lockup. Some network drivers(eg Microchip's LAN743x), make a call to
>>> phy_ethtool_get_link_ksettings inside the link change handler  
>>
>> I think we need to take a step back here and answer the question, why
>> does it call phy_ethtool_get_link_ksettings in the link change
>> handler. I'm not aware of any other MAC driver which does this.
>>
>> 	 Andrew
> 
> I agree, the use in the lan743x seems related to the PTP, that driver seems
> to be the only one using it, at least in the Linus tree. 
> I think that driver could be patched as there are other ways to do it,
> but my take on the problem itself is that the PHY device interface opens
> a way to break the flow and this behavior does not seem to be documented,
> so, instead of documenting a possible harmful interface while in the callback,
> we should just get rid of the problem itself, and calling a callback without
> any locks held seems to be a good alternative.
> This is also a non critical performance path and the additional code
> would not impact much, of course it makes the stuff less nice to look at.
> The patch also has an additional check for the lock, since there is a 
> function that is not calling the lock explicitly and has a warn if the lock
> is not held at the start, so I put it there to be extra safe.
> 
> Alessandro
> 

Seeing the following code snippet in lan743x_phy_link_status_change()
I wonder why it doesn't use phydev->speed and phydev->duplex directly.
The current code seems to include unneeded overhead.

		phy_ethtool_get_link_ksettings(netdev, &ksettings);
		local_advertisement =
			linkmode_adv_to_mii_adv_t(phydev->advertising);
		remote_advertisement =
			linkmode_adv_to_mii_adv_t(phydev->lp_advertising);

		lan743x_phy_update_flowcontrol(adapter,
					       ksettings.base.duplex,
					       local_advertisement,
					       remote_advertisement);
		lan743x_ptp_update_latency(adapter, ksettings.base.speed);

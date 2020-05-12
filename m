Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AD11CFD3D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgELS2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELS2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:28:54 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5C8C061A0C;
        Tue, 12 May 2020 11:28:54 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k12so23081566wmj.3;
        Tue, 12 May 2020 11:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Af4bGh6gtdD7pFgluzOIxDyohAQ43tXoZI/ouHpfgk4=;
        b=YXatY7162TaR2O4dwbYzXB4nBixIw0sRf4Rtct59QCX9ikHgDCc7QuFlzE8WQtkGAT
         9ScoF19SGIo5TQ+B7A+xINhhfi7JQ/MZsgQm74YV6ZmOPo/x/ID8mrXyqCxP5bUEdVoB
         eRMK3aXRsSaaEyxOIoP4KD2Yvn1YGa7dWz+XYNEsaptHoc9TwxhfUQg115t8i5lpFfZh
         lS3XP9O1W+wVsurGU09pJoF5tnr2ZtaN02rbGioYDgriz02r0KUYP/5zlJHz1kshVqtJ
         a4iEOLMKFP5UPLAbiCES/4fyktkk8RAQ58kCgaNg/kZt1XW92btgUOu5Ibp9xXyCvNif
         4slQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Af4bGh6gtdD7pFgluzOIxDyohAQ43tXoZI/ouHpfgk4=;
        b=GNhE5tXV3ncfxRzvh5xmI+MJZRqSKS+XRe+y4hV5qSVrJypDzsk3/07aX1SjfBYhlc
         6crrj6cuecT3gsPq42KWc6R5YH6laGWzQ1njgJVHc+iKIxt0dHQixVdWEGC1087Xplb2
         Au7mwBVvPvpKUak+fofLYZGF7koANcguD+/sxSlaspbKB9qoZYT6yIgYoRr8huVx2zpm
         Oz1pJht0gtOO8XJgw/3GaEHZ2EyQrjHJc3GCV8h0tHI0byb3gsg7N/cRclMB9qCHU/2c
         0m7Z6N3K8maGBQDRXlhJ39cEGrjj24Dsy37Kev85tc7xDlQOUCNKAXyZKd489iGbl9yU
         wTXw==
X-Gm-Message-State: AGi0PuapGp+k7GIgm1yg+0axQ5ZvzwTmMQ73h/nxfHuROg7SITixj+CE
        Ll2kyNk2a6a2HYvd0Pm9E35PeDAb
X-Google-Smtp-Source: APiQypJXTA2B3RELbCGffY1yCVjXKQOBHLq9uffvdcCjn4pJN2pQKPuEPhpjC1WEgdESn8qN/qIH3g==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr36152580wmk.96.1589308132655;
        Tue, 12 May 2020 11:28:52 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v20sm26787183wrd.9.2020.05.12.11.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 11:28:51 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
Date:   Tue, 12 May 2020 11:31:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512004714.GD409897@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/2020 5:47 PM, Andrew Lunn wrote:
> On Mon, May 11, 2020 at 05:24:07PM -0700, Doug Berger wrote:
>> A comment in uapi/linux/ethtool.h states "Drivers should reject a
>> non-zero setting of @autoneg when autoneogotiation is disabled (or
>> not supported) for the link".
>>
>> That check should be added to phy_validate_pause() to consolidate
>> the code where possible.
>>
>> Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")
> 
> Hi Doug
> 
> If this is a real fix, please submit this to net, not net-next.
> 
>    Andrew
> 
This was intended as a fix, but I thought it would be better to keep it
as part of this set for context and since net-next is currently open.

The context is trying to improve the phylib support for offloading
ethtool pause configuration and this is something that could be checked
in a single location rather than by individual drivers.

I included it here to get feedback about its appropriateness as a common
behavior. I should have been more explicit about that.

Personally, I'm actually not that fond of this change since it can
easily be a source of confusion with the ethtool interface because the
link autonegotiation and the pause autonegotiation are controlled by
different commands.

Since the ethtool -A command performs a read/modify/write of pause
parameters, you can get strange results like these:
# ethtool -s eth0 speed 100 duplex full autoneg off
# ethtool -A eth0 tx off
Cannot set device pause parameters: Invalid argument
#
Because, the get read pause autoneg as enabled and only the tx_pause
member of the structure was updated.

The network driver could attempt to change one in response to the other,
but it might be difficult to reach consensus and it adds more
"worthless" code to the network driver in opposition to the intent.

I would like to get more feedback about the approach of the patch set as
a whole before I resubmit, and would be happy to drop this commit at
that time.

But there is still a question of how the comment "Drivers should reject
a non-zero setting of @autoneg when autoneogotiation is disabled (or not
supported) for the link" in ethtool.h should be interpreted.

Should that comment be removed?

Thanks for taking the time to look at this,
    Doug

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A03427F2FC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgI3UHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:07:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D563C061755;
        Wed, 30 Sep 2020 13:07:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id x16so1774949pgj.3;
        Wed, 30 Sep 2020 13:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CiaoK4+mqEdB3dJiBW8/B4ZNEaqA5Ou94gMaBqt4dy4=;
        b=DVg9yWyneung2LNG87yi+pqnv+sZky2FW0gpcUBlCYBROF+IZoK6lp00617x/eeAJ8
         tP6BgQ7voOH2GRBFWwUfQIyL/JFXS4ZATiAhz2YTicHnBoojC/K3e5pws3tYNd9TNDxo
         ZSA9ON5V1C+GV4PashAsbny5EuBJneLQIg44C8ZrSG6u77a7r1ofvR6bjhfaX6QnFF+N
         JWW6j9kzRC0UYMvf4QB91vJ79Rd2j84IsWre5P23qKg8hBwYSPyBki0vBfYPL2y9dO98
         0A5jeep1cT53B75sj0APE/5qf/YkP5o37Lb/eYSnt4F3feVMVLa4HSK/6X/W8sDqycEJ
         DXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CiaoK4+mqEdB3dJiBW8/B4ZNEaqA5Ou94gMaBqt4dy4=;
        b=bGWOMHZ2B7Zpv9rfeUKzTv2ZGXNOMEKaDlpDhB7SFdSSiUWSSIsnnzahRpiE+XWRoF
         ZkdNXc+O8OrHWb4gDWVUY2HxGBUGdavVPuJoXo7IJEKrIZQ4cHmL6q3v3yRjwfY/bIjd
         lRmTGhjr5Ulg2IcUcXuMmOtK2fQ59YNoHJkP3QIs56MrL2rGGLA9EvlUfTsxFH85W/p4
         vP7ZBzf0l/F1uf09YNOzyQ6LvOrvMRrKdBx3wUnZrWq7TRtTCZev0yawzhRiZzyc/c03
         CDIk4UcmpU03T6/aDx1lbcv4nkhbpuz9UU7gO4c9DOotNwZINDWZNUP8opIn9ird7kvv
         tyXw==
X-Gm-Message-State: AOAM530Ji3avO64vqC69pyw9MtfnKG4fQ5xjPoRxJzdEYYNPn5cXnLy9
        BeRPDzb/U9eakpx4t6Mh5HXIg8tSCVU8VQ==
X-Google-Smtp-Source: ABdhPJwqVI9oSZY/45Fzz7NHTw2uhYkEcU9uHhRFMc08HCFtwrcxDnHt8kMlZyB08dlENhBmuni8hg==
X-Received: by 2002:aa7:9850:0:b029:142:2501:34f0 with SMTP id n16-20020aa798500000b0290142250134f0mr3768267pfq.73.1601496443102;
        Wed, 30 Sep 2020 13:07:23 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u15sm3330448pjx.50.2020.09.30.13.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 13:07:22 -0700 (PDT)
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
To:     Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200930174419.345cc9b4@xhacker.debian>
 <20200930190911.GU3996795@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
Date:   Wed, 30 Sep 2020 13:07:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930190911.GU3996795@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2020 12:09 PM, Andrew Lunn wrote:
> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
>> Hi,
>>
>> A GE phy supports pad isolation which can save power in WOL mode. But once the
>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
>> the phy is "isolated". To make the PHY work normally, I need to move the
>> enabling isolation to suspend hook, so far so good. But the isolation isn't
>> enabled in system shutdown case, to support this, I want to add shutdown hook
>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
>> there any elegant solution?
> 
>> Or we can break the assumption: ethernet can still send/receive pkts after
>> enabling WoL, no?
> 
> That is not an easy assumption to break. The MAC might be doing WOL,
> so it needs to be able to receive packets.
> 
> What you might be able to assume is, if this PHY device has had WOL
> enabled, it can assume the MAC does not need to send/receive after
> suspend. The problem is, phy_suspend() will not call into the driver
> is WOL is enabled, so you have no idea when you can isolate the MAC
> from the PHY.
> 
> So adding a shutdown in mdio_driver_register() seems reasonable.  But
> you need to watch out for ordering. Is the MDIO bus driver still
> running?

If your Ethernet MAC controller implements a shutdown callback and that 
callback takes care of unregistering the network device which should 
also ensure that phy_disconnect() gets called, then your PHY's suspend 
function will be called.
-- 
Florian

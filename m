Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE6166DF47
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjAQNtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjAQNsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:48:50 -0500
Received: from www381.your-server.de (www381.your-server.de [78.46.137.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E7E3B655;
        Tue, 17 Jan 2023 05:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
        s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=zUXO5MQWynUldS0R2rs0QRnzYyd0wOp6rw/Wma8Gg9k=; b=IZSfPZP/+bpbkNFPHN7i5ARwH0
        VMkNbBOj8ibXEWe6H6Sxu0TWsikx7kApAYi1WzeODrsvAKrb/l4/KtiLdW4u+VL4xenRwYUZ5K+44
        eNP46WXpnOn1aEL8cZBTQG06uUN4SJNOcDC0Ny2drT6nDQwhQ1TYBmNp6j7vNQ/uAX/kvU8vmjwKU
        BJjbC7/ZrKSyGob+C+4HjA7vgTDxblv35QiUSwcJwIQBtyU6PnaA1HFdJ96YyK09D9tLD7d85XBRv
        dXhPRNxrV7eeaWzx42fL8gZXDrBUy966xHQV8T3X/88f7WUZ676IeLfxvfPezJbTStGyuYcFirMaN
        Km2Yiy2Q==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www381.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lars@metafoo.de>)
        id 1pHmKN-0000B7-EW; Tue, 17 Jan 2023 14:48:39 +0100
Received: from [2604:5500:c0e5:eb00:da5e:d3ff:feff:933b]
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1pHmKM-000MJd-RK; Tue, 17 Jan 2023 14:48:39 +0100
Message-ID: <54eb0ee4-7d9e-7025-f984-b1e026c18c3d@metafoo.de>
Date:   Tue, 17 Jan 2023 05:48:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch> <cc338014-8a2b-87e9-7684-20b57aae4ac3@metafoo.de>
 <Y8alV6FUKsN2x2XZ@lunn.ch>
From:   Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <Y8alV6FUKsN2x2XZ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.7/26784/Tue Jan 17 09:29:12 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/23 05:40, Andrew Lunn wrote:
>>> So compatible "ethernet-phy-ieee802.3-c45" results in is_c45 being set
>>> true. The if (is_c45 || is then true, so it does not need to call
>>> fwnode_get_phy_id(child, &phy_id) so ignores whatever ID is in DT and
>>> asks the PHY.
>>>
>>> Try this, totally untested:
>>>
>>> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
>>> index b782c35c4ac1..13be23f8ac97 100644
>>> --- a/drivers/net/mdio/fwnode_mdio.c
>>> +++ b/drivers/net/mdio/fwnode_mdio.c
>>> @@ -134,10 +134,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>>>           if (rc >= 0)
>>>                   is_c45 = true;
>>> -       if (is_c45 || fwnode_get_phy_id(child, &phy_id))
>>> +       if (fwnode_get_phy_id (child, &phy_id))
>>>                   phy = get_phy_device(bus, addr, is_c45);
>>>           else
>>> -               phy = phy_device_create(bus, addr, phy_id, 0, NULL);
>>> +               phy = phy_device_create(bus, addr, phy_id, is_c45, NULL);
>>>           if (IS_ERR(phy)) {
>>>                   rc = PTR_ERR(phy);
>>>                   goto clean_mii_ts;
>>>
>> I think part of the problem is that for C45 there are a few other fields
>> that get populated by the ID detection, such as devices_in_package and
>> mmds_present. Is this something we can do after running the PHY drivers
>> probe function? Or is it too late at that point?
> As i hinted, it needs somebody to actually debug this and figure out
> why it does not work.
>
> I think what i did above is part of the solution. You need to actually
> read the ID from the DT, which if you never call fwnode_get_phy_id()
> you never do.
>
> You then need to look at phy_bus_match() and probably remove the
>
> 		return 0;
> 	} else {
>
> so that C22 style ID matching is performed if matching via
> c45_ids.device_ids fails.

Sorry, I've should have been more clear. I did try your proposed change 
a while ago. The problem why it does not work is that there are other 
fields in the phy data structure that get initialized when reading the 
IDs for C45. Such as which MMD addresses are valid.


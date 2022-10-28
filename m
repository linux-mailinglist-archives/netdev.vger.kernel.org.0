Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CF5610E63
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJ1KZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiJ1KZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:25:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7704F3499F
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:25:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 284B3219D5;
        Fri, 28 Oct 2022 10:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666952710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2t8Wg2EZvoBBdbB41BivFF9HaJsv7fTs6VeE9Ct5QQ=;
        b=Oy2XsUpUU5lBOR4VyqGvZvT7LzdZE4mQwk4zx0BQCnC4cIhxE4/zlbJ7n6LA0MWv+7oL5c
        mWkKHJQ1IKnPoe/L7osFAgB+g/Qwr1/8xCVHgcHzb+DKqbTBKuMkRVoJfqWiuao4iou9Oc
        ALo77bG/ARlWVOu1BRVuTpa5pGN2lng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666952710;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2t8Wg2EZvoBBdbB41BivFF9HaJsv7fTs6VeE9Ct5QQ=;
        b=VbX8wEwfu1OWEyNiHFEJ93xwAMvIXRTgsbxJRzxdvMbc06IzKAL/SZMqteQBGCZHjCPOmA
        oGLrTt3nDxmUwqBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D2A8C13A6E;
        Fri, 28 Oct 2022 10:25:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sQjALwWuW2O9OAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Fri, 28 Oct 2022 10:25:09 +0000
Message-ID: <c0cc3503-ffd3-efd3-0994-2939a89bc7af@suse.de>
Date:   Fri, 28 Oct 2022 13:25:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [net-next] phy: convert to boolean for the mac_managed_pm flag
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
References: <4bca2d92-e966-81d7-d5a6-2c4240194ff4@suse.de>
 <67d3de52-54b6-e88f-f9b9-b87790d9c9a0@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <67d3de52-54b6-e88f-f9b9-b87790d9c9a0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/22 00:09, Heiner Kallweit wrote:
> On 27.10.2022 17:05, Denis Kirjanov wrote:
>> Signed-off-by: Dennis Kirjanov <dkirjanov@suse.de>
> 
> Commit message is missing.
> It should be "net: phy:" instead of "phy:".
> You state that you convert the flag to boolean but you convert only the users.

Yes, I've sent a v2. I've converted the flag to make it consistent across the users 

> 
>> ---
>>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>>  drivers/net/usb/asix_devices.c            | 4 ++--
> 
> This should be separate patches.
> 
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> index 98d5cd313fdd..4d38a297ec00 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -2226,7 +2226,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
>>  	fep->link = 0;
>>  	fep->full_duplex = 0;
>>  
>> -	phy_dev->mac_managed_pm = 1;
>> +	phy_dev->mac_managed_pm = true;
>>  
> Definition is: unsigned mac_managed_pm:1;
> Therefore 1 is the correct value, why assigning a bool to a bitfield member?
> 
>>  	phy_attached_info(phy_dev);
>>  
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index a73d061d9fcb..5bc1181f829b 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -5018,7 +5018,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>  		return -EUNATCH;
>>  	}
>>  
>> -	tp->phydev->mac_managed_pm = 1;
>> +	tp->phydev->mac_managed_pm = true;
>>  
>>  	phy_support_asym_pause(tp->phydev);
>>  
>> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
>> index 11f60d32be82..02941d97d034 100644
>> --- a/drivers/net/usb/asix_devices.c
>> +++ b/drivers/net/usb/asix_devices.c
>> @@ -700,7 +700,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>>  	}
>>  
>>  	phy_suspend(priv->phydev);
>> -	priv->phydev->mac_managed_pm = 1;
>> +	priv->phydev->mac_managed_pm = true;
>>  
>>  	phy_attached_info(priv->phydev);
>>  
>> @@ -720,7 +720,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>>  		return -ENODEV;
>>  	}
>>  
>> -	priv->phydev_int->mac_managed_pm = 1;
>> +	priv->phydev_int->mac_managed_pm = true;
>>  	phy_suspend(priv->phydev_int);
>>  
>>  	return 0;
> 

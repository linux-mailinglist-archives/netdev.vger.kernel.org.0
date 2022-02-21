Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065214BEAA4
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiBUS16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:27:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiBUS0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:26:14 -0500
Received: from mailserv1.kapsi.fi (mailserv1.kapsi.fi [IPv6:2001:67c:1be8::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A15C7F;
        Mon, 21 Feb 2022 10:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ext.kapsi.fi; s=20161220; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Seqw0zUcjmCmt2PCKp9l6scFXw8yrx43pqaz3xR+wNg=; b=Rvml0oZlH1IiF0bNfoYSutVSlG
        PXTBs92aGdAvMPiIHmUib/17nNihx6GIHgxBeSGR1KGQkcnE0z2JXnn4oiCFZHimDA6j7Dk306jAf
        B5cB1TEYmtuVdBJHMUZquFbNh9O7l6Tm+5MWzTOYfySK12HdUEYNE2GL9dQG8g1ty4JVD9W0WwDLO
        SalcxEPSfnw0711rJmu4cbqYNQQAeoZmhTm08+6c9K5TUPqvYknw6zP34AYGEoJXrU9Z+hQLtUv68
        1hZPKuGoCKfkdGYe99dHWJBPcZImLYuwTMwq5sRsQo9u7+aA8DmK5mWto+HI6ps4TyVivJcOrc7Fa
        ZolnBArw==;
Received: from 15-28-196-88.dyn.estpak.ee ([88.196.28.15]:54283 helo=[10.0.2.15])
        by mailserv1.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <maukka@ext.kapsi.fi>)
        id 1nMDMx-00029k-PM; Mon, 21 Feb 2022 20:25:08 +0200
Message-ID: <72041ee7-a618-85d0-4687-76dae2b04bbc@ext.kapsi.fi>
Date:   Mon, 21 Feb 2022 20:25:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
 <YhOD3eCm8mYHJ1HF@lunn.ch>
From:   Mauri Sandberg <maukka@ext.kapsi.fi>
In-Reply-To: <YhOD3eCm8mYHJ1HF@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 88.196.28.15
X-SA-Exim-Mail-From: maukka@ext.kapsi.fi
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: [PATCH] net: mv643xx_eth: handle EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mailserv1.kapsi.fi)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 21.02.22 14:21, Andrew Lunn wrote:
> On Mon, Feb 21, 2022 at 08:24:41AM +0200, Mauri Sandberg wrote:
>> Obtaining MAC address may be deferred in cases when the MAC is stored
>> in NVMEM block and it may now be ready upon the first retrieval attempt
>> returing EPROBE_DEFER. Handle it here and leave logic otherwise as it
>> was.
>>
>> Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
>> ---
>>   drivers/net/ethernet/marvell/mv643xx_eth.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
>> index 105247582684..0694f53981f2 100644
>> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
>> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
>> @@ -2740,7 +2740,10 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
>>   		return -EINVAL;
>>   	}
>>   
>> -	of_get_mac_address(pnp, ppd.mac_addr);
>> +	ret = of_get_mac_address(pnp, ppd.mac_addr);
>> +
>> +	if (ret == -EPROBE_DEFER)
>> +		return ret;
> Hi Mauri
>
> There appears to be a follow on issue. There can be multiple ports. So
> it could be the first port does not use a MAC address from the NVMEM,
> but the second one does. The first time in
> mv643xx_eth_shared_of_add_port() is successful and a platform device
> is added. The second port can then fail with -EPROBE_DEFER. That
> causes the probe to fail, but the platform device will not be
> removed. The next time the driver is probed, it will add a second
> platform device for the first port, causing bad things to happen.
>
> Please can you add code to remove the platform device when the probe
> fails.

I am looking at the vector 'port_platdev' that holds pointers to already 
initialised ports. There is this mv643xx_eth_shared_of_remove(), which 
probably could be utilised to remove them. Should I remove the platform 
devices only in case of probe defer or always if probe fails?



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42471187635
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732883AbgCPXaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:30:19 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35916 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732855AbgCPXaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:30:19 -0400
Received: by mail-pl1-f193.google.com with SMTP id g2so6214848plo.3
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 16:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GHqfg8GjsM+6tRPeuPn3lcHQS9mt7K0jNR/KAOWyv7A=;
        b=umWIr8pC2QgsRq5r4a2Sx3Y5HWcWGc88ibGuhqximyJUOkxrkRezDq7GbqTUV5TS+D
         2ieQcPVUonn+TZzV1+TfCh8lkNTpmv+CYhUlpDHjQjrLtiTqDK3CtFFzz0vCfVM0ZWEX
         rdaA+xUWBsam5Zk5WBT49G0Lbt2fCu8KnQ+J4WYWj3czWr/QZdG65g7OH+LsWMWm3qor
         CbWaGjvhMbXdINjnzejbMBbs6HwxsJyRFKtgfJZn84njMVKUiGRv7T0XNmQZX1pVLq5S
         iP23qTiozbbxwE8HSmA7XNxBHeKAgUf16rBbUs6spqRmfODLkueETrq2iAX0ez3zahoa
         rOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GHqfg8GjsM+6tRPeuPn3lcHQS9mt7K0jNR/KAOWyv7A=;
        b=twd2jpbjDJuqnaREr+nWBOZldrrRHP0Cno0TuMTTaOfv/bZsV1qAQFDt5pXz1qlMuH
         NABdvSCDgmi1zSID3AJe/XAAwWkaPq/6aXzp77OjVYqKnaSm6k4cBAqmayU3BR2HNEeR
         vUPYfuzziBwSJXSYzI9rGcBC3Y+2mlnJyyioVjfJ1t+RHiy6goPKQ/G699CTFJ39juAd
         kwFHHq6yYcaAJ8ZsJQBy00GUoFjLPnByplD7Qex97UJS7J6uN2M2InnEUzw/gozqZwFd
         7xLwh5NkeXeRmu9LllNzWvpEqZyta3UOeg08BoJEgM0rAp+DEO0qcmfTWASO24vJ+ar0
         tXgQ==
X-Gm-Message-State: ANhLgQ27KjctvWs3AI7cYP+iDwBBdS+jDwgJHw26+H2QpI12B71M4osE
        VMCGxddXyVtHK6ZOJxe1PnCh3Q==
X-Google-Smtp-Source: ADFU+vtu5roDXxZ8jOYgrUgk1vQD+iQMzUkA7Q0bxgvbPrYXAR1pc+QJ+sZropNYnlinFKtMM26dvg==
X-Received: by 2002:a17:90a:de0a:: with SMTP id m10mr2135402pjv.34.1584401417855;
        Mon, 16 Mar 2020 16:30:17 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y28sm898493pfp.128.2020.03.16.16.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 16:30:17 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/5] ionic: return error for unknown xcvr type
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200316193134.56820-1-snelson@pensando.io>
 <20200316193134.56820-5-snelson@pensando.io>
 <20200316150116.330e4d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <28e0b56c-68d1-3310-16c4-56355357e095@pensando.io>
Date:   Mon, 16 Mar 2020 16:30:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200316150116.330e4d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/20 3:01 PM, Jakub Kicinski wrote:
> On Mon, 16 Mar 2020 12:31:33 -0700 Shannon Nelson wrote:
>> If we don't recognize the transceiver type, return an error
>> so that ethtool doesn't try dumping bogus eeprom contents.
>>
>> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> index a233716eac29..3f92f301a020 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> @@ -694,7 +694,7 @@ static int ionic_get_module_info(struct net_device *netdev,
>>   	default:
>>   		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
>>   			    xcvr->sprom[0]);
>> -		break;
>> +		return -EINVAL;
>>   	}
>>   
>>   	return 0;
>> @@ -714,7 +714,19 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
>>   	/* The NIC keeps the module prom up-to-date in the DMA space
>>   	 * so we can simply copy the module bytes into the data buffer.
>>   	 */
>> +
>>   	xcvr = &idev->port_info->status.xcvr;
>> +	switch (xcvr->sprom[0]) {
>> +	case 0x03: /* SFP */
>> +	case 0x0D: /* QSFP */
>> +	case 0x11: /* QSFP28 */
> Please use defines from sfp.h

Yep, thanks, it's nice we have those now.

>
>> +		break;
>> +	default:
>> +		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
>> +			    xcvr->sprom[0]);
>> +		return -EINVAL;
> Isn't there _some_ amount of eeprom that we could always return?

It probably would be useful to return the first page (256 bytes) to help 
the reader figure out what's up with the data.

This only gets called it ionic_get_module_info() returns with no error, 
so possibly that function could set type to 0 or -1 and len to 256, more 
or less as default values for getting something printed.

I'll play with that a little.

Thanks,
sln


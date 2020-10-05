Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C32C283FFF
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgJET7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbgJET7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:59:43 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E84FC0613CE;
        Mon,  5 Oct 2020 12:59:43 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c6so54336plr.9;
        Mon, 05 Oct 2020 12:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v5MvUxw3ZB12lg7pYNQ9g8Q6+t1ltW3gSsaG6iUl7NA=;
        b=pBSnV8GHp99nHecDrhbFq2Q5/I3f9S/LZlX1Vus5qfyg1xT3yt6VO05moym/CfogKl
         8C76S1L9KdcZBWegnBP0XNzb4jEDVyxwCMHX4fiaN72HPWuzLF1pM6QYpT/cJC8mvS2A
         BtZSpQoVEWo+ivbmprv3wp3pbWWxd93OR5O9/GIojsUupswDGE0LcGwu1A4UpNtCTpd/
         BHoodD36Eer+wymMKfG8qCbO93ZeUizIIHoSEmH9iH46fgwCsdsf5vOTralNymeawi16
         akNRkAnXh3anwCpXdMhyoGhH5KmOSTYoXJ6eVKx+/yrOUVuyVQlZn9huOQwishNu5+R8
         dlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5MvUxw3ZB12lg7pYNQ9g8Q6+t1ltW3gSsaG6iUl7NA=;
        b=E6bMlJFgydfsUDUQ4NuLu++YS93QjcGI/pYm1dkMYQ/Aj2vaB5YbCAeUGi5pNfK9q9
         +hx77DFjn8mPpGBKiH00h2jJ8GYNRvaRRea27yZOoKkOmQh11Ui24hGnn3T3uo9uYxyG
         SJH2wwr9AJzhXgwzSLKzoDRPEgyw8WR7JLMzsjfi/9X1pWigpplD8gu3R6ag2ZREQHW8
         lkuQMqwMrrG9rwScAxXSfH98PjMalEQH8SuSggfWrtpYPT7zFqW/JtJ0OUEs5ST0kb3o
         ZDPfRjEW9/h3h10GCALuYT8sANUJV02l7TDWJlJ+LFltbzKrFJMmE/c5c1prhLJrqwGL
         Yr4g==
X-Gm-Message-State: AOAM533ask3tk8CSiPSY1xAObN6DOBvzKxKw0y1C2yAA/nXTNTIrT9/q
        Osj5MfjJvuMg6wveTt1W3MaqDBADp597aA==
X-Google-Smtp-Source: ABdhPJx9AWJfslURrqrpa2/s6kozXsl9A1u3rf3SFBpZ4BNZ8nUInlemdxkAR16VWwVxadlJPv8VRQ==
X-Received: by 2002:a17:90a:5d94:: with SMTP id t20mr1092379pji.20.1601927982179;
        Mon, 05 Oct 2020 12:59:42 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ne16sm401296pjb.11.2020.10.05.12.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 12:59:41 -0700 (PDT)
To:     Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201005160829.5607-1-ceggers@arri.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: microchip: fix race condition
Message-ID: <66fce8e0-f6ae-488d-25c8-648606703778@gmail.com>
Date:   Mon, 5 Oct 2020 12:59:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005160829.5607-1-ceggers@arri.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2020 9:08 AM, Christian Eggers wrote:
> Between queuing the delayed work and finishing the setup of the dsa
> ports, the process may sleep in request_module() and the queued work may
> be executed prior the initialization of the DSA ports is finished. In
> ksz_mib_read_work(), a NULL dereference will happen within
> netof_carrier_ok(dp->slave).
> 
> Not queuing the delayed work in ksz_init_mib_timer() make things even
> worse because the work will now be queued for immediate execution
> (instead of 2000 ms) in ksz_mac_link_down() via
> dsa_port_link_register_of().
> 
> Solution:
> 1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
> 2. Only queue delayed work in ksz_mac_link_down() if init is completed.
> 3. Queue work once in ksz_switch_register(), after dsa_register_switch()
> has completed.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org

This looks fine to me and the analysis appears to be correct, don't you 
need to pair the test for dev->mib_read_internal being non zero with 
setting it to zero in ksz_switch_unregister()?

You would also most likely want to add a Fixes: tag such that this can 
be back ported to stable trees?

> ---
> Call tree:
> ksz9477_i2c_probe()
> \--ksz9477_switch_register()
>     \--ksz_switch_register()
>        +--dsa_register_switch()
>        |  \--dsa_switch_probe()
>        |     \--dsa_tree_setup()
>        |        \--dsa_tree_setup_switches()
>        |           +--dsa_switch_setup()
>        |           |  +--ksz9477_setup()
>        |           |  |  \--ksz_init_mib_timer()
>        |           |  |     |--/* Start the timer 2 seconds later. */
>        |           |  |     \--schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
>        |           |  \--__mdiobus_register()
>        |           |     \--mdiobus_scan()
>        |           |        \--get_phy_device()
>        |           |           +--get_phy_id()
>        |           |           \--phy_device_create()
>        |           |              |--/* sleeping, ksz_mib_read_work() can be called meanwhile */
>        |           |              \--request_module()
>        |           |
>        |           \--dsa_port_setup()
>        |              +--/* Called for non-CPU ports */
>        |              +--dsa_slave_create()
>        |              |  +--/* Too late, ksz_mib_read_work() may be called beforehand */
>        |              |  \--port->slave = ...
>        |             ...
>        |              +--Called for CPU port */
>        |              \--dsa_port_link_register_of()
>        |                 \--ksz_mac_link_down()
>        |                    +--/* mib_read must be initialized here */
>        |                    +--/* work is already scheduled, so it will be executed after 2000 ms */
>        |                    \--schedule_delayed_work(&dev->mib_read, 0);
>        \-- /* here port->slave is setup properly, scheduling the delayed work should be safe */
> 
> static void ksz_mib_read_work()
> \--netif_carrier_ok(dp->slave);  dp->slave has not been initialized yet
> 
> 
>   drivers/net/dsa/microchip/ksz_common.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 8e755b50c9c1..a94d2278b95c 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -103,14 +103,8 @@ void ksz_init_mib_timer(struct ksz_device *dev)
>   
>   	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
>   
> -	/* Read MIB counters every 30 seconds to avoid overflow. */
> -	dev->mib_read_interval = msecs_to_jiffies(30000);
> -
>   	for (i = 0; i < dev->mib_port_cnt; i++)
>   		dev->dev_ops->port_init_cnt(dev, i);
> -
> -	/* Start the timer 2 seconds later. */
> -	schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
>   }
>   EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
>   
> @@ -143,7 +137,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
>   
>   	/* Read all MIB counters when the link is going down. */
>   	p->read = true;
> -	schedule_delayed_work(&dev->mib_read, 0);
> +	/* timer started */
> +	if (dev->mib_read_interval)
> +		schedule_delayed_work(&dev->mib_read, 0);
>   }
>   EXPORT_SYMBOL_GPL(ksz_mac_link_down);
>   
> @@ -446,6 +442,12 @@ int ksz_switch_register(struct ksz_device *dev,
>   		return ret;
>   	}
>   
> +	/* Read MIB counters every 30 seconds to avoid overflow. */
> +	dev->mib_read_interval = msecs_to_jiffies(30000);
> +
> +	/* Start the MIB timer. */
> +	schedule_delayed_work(&dev->mib_read, 0);
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL(ksz_switch_register);
> 

-- 
Florian

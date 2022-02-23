Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41F4C1A4C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243633AbiBWR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243628AbiBWR4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:56:16 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C9B255BA;
        Wed, 23 Feb 2022 09:55:32 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x18so16071638pfh.5;
        Wed, 23 Feb 2022 09:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g5MUiBUuvl2XFBhVkmzyntL4m7Jquw4ZA1vWQa16xCM=;
        b=PAn4/ZTO4UJZ88VUZ8mmuaGq+nBZ/AwiPcMbcNzrh/98L+ynTqdmamNg5VJ9fTs/yJ
         uNwxzx1I5pSr4afLtazdRCKtLAQFeC9t92OXdRmnsSj2E+G5S/romNseBkOXjbOqBCQV
         ZVZHSppa01U6wGzlEbKujerbZ9pum+exIjpQ9TzeTZw+x+q+gttqlgxnFW16f42xM7p0
         6FYzYCrMaX1XoLlckg7YMnbtDqsIgYFobi/V0IdC2UVWq86rlFKrYtzTItXMXOldQlIY
         8bfO5yg3gC5Pjgw4DsgkprOw1NMskzNit5RWbziHmArb0cLueK8g6TlhtlOAvq9MKzVd
         bZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g5MUiBUuvl2XFBhVkmzyntL4m7Jquw4ZA1vWQa16xCM=;
        b=p9nKxL2VIxPJlnPficlZT3NfdydcCO7/PK6vvDWG/THd4a7CzyEHkIR8hyB7N8jbXS
         aI3OAPkP3PzXBQu8XGXDGnu8g3wOj1llNDngbHcdZSQIyHY4cqNZ/xC3WO5R3rlKhE1D
         hvfz2uyI+zD5gZK0zUv+33tJXkhEQFWESqFmGu66ku5PmJ9yxf6ADKJBuAOT/ZPxIw8K
         PkAVUKOMt7VkIt9jnHkcZbAKqDScjSdi7a/ATVk/iwlfD3uSYclQvLRdi/ZX6SEW2Tzm
         UBtnQ/OAZUYnE+l6ADWi/2azLWXlxKJFrIaE8k5DVIWKdWy/N6nXvhETOjxst/lJZWqH
         Ck/w==
X-Gm-Message-State: AOAM533zzXASZaVjpissADm5M/cr9LU/4d6k4pVUewYTnSv13yckfGBv
        7pZisB5kyIV9BJaqiAvHn5c=
X-Google-Smtp-Source: ABdhPJwpiB5x5gfXIiuYRpt4Z4bvjryNs08dSMMPO9x3w0RDZAcHaHs6MKIYSt4MB5OksV4si1Kk+g==
X-Received: by 2002:a63:543:0:b0:374:62b7:8ab0 with SMTP id 64-20020a630543000000b0037462b78ab0mr591954pgf.384.1645638931892;
        Wed, 23 Feb 2022 09:55:31 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u25sm165880pfh.46.2022.02.23.09.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 09:55:31 -0800 (PST)
Message-ID: <91e2d4ad-7544-784b-defe-3a76577462f1@gmail.com>
Date:   Wed, 23 Feb 2022 09:55:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Content-Language: en-US
To:     Heyi Guo <guoheyi@linux.alibaba.com>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
 <20220223031436.124858-4-guoheyi@linux.alibaba.com>
 <1675a52d-a270-d768-5ccc-35b1e82e56d2@gmail.com>
 <5cdf5d09-9b32-ec98-cbd1-c05365ec01fa@linux.alibaba.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5cdf5d09-9b32-ec98-cbd1-c05365ec01fa@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/2022 3:39 AM, Heyi Guo wrote:
> Hi Florian,
> 
> 在 2022/2/23 下午1:00, Florian Fainelli 写道:
>>
>>
>> On 2/22/2022 7:14 PM, Heyi Guo wrote:
>>> DHCP failures were observed with systemd 247.6. The issue could be
>>> reproduced by rebooting Aspeed 2600 and then running ifconfig ethX
>>> down/up.
>>>
>>> It is caused by below procedures in the driver:
>>>
>>> 1. ftgmac100_open() enables net interface and call phy_start()
>>> 2. When PHY is link up, it calls netif_carrier_on() and then
>>> adjust_link callback
>>> 3. ftgmac100_adjust_link() will schedule the reset task
>>> 4. ftgmac100_reset_task() will then reset the MAC in another schedule
>>>
>>> After step 2, systemd will be notified to send DHCP discover packet,
>>> while the packet might be corrupted by MAC reset operation in step 4.
>>>
>>> Call ftgmac100_reset() directly instead of scheduling task to fix the
>>> issue.
>>>
>>> Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
>>> ---
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Joel Stanley <joel@jms.id.au>
>>> Cc: Guangbin Huang <huangguangbin2@huawei.com>
>>> Cc: Hao Chen <chenhao288@hisilicon.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Dylan Hung <dylan_hung@aspeedtech.com>
>>> Cc: netdev@vger.kernel.org
>>>
>>>
>>> ---
>>>   drivers/net/ethernet/faraday/ftgmac100.c | 13 +++++++++++--
>>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
>>> b/drivers/net/ethernet/faraday/ftgmac100.c
>>> index c1deb6e5d26c5..d5356db7539a4 100644
>>> --- a/drivers/net/ethernet/faraday/ftgmac100.c
>>> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>>> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct 
>>> net_device *netdev)
>>>       /* Disable all interrupts */
>>>       iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>>>   -    /* Reset the adapter asynchronously */
>>> -    schedule_work(&priv->reset_task);
>>> +    /* Release phy lock to allow ftgmac100_reset to aquire it, 
>>> keeping lock
>>
>> typo: acquire
>>
> Thanks for the catch :)
>>> +     * order consistent to prevent dead lock.
>>> +     */
>>> +    if (netdev->phydev)
>>> +        mutex_unlock(&netdev->phydev->lock);
>>> +
>>> +    ftgmac100_reset(priv);
>>> +
>>> +    if (netdev->phydev)
>>> +        mutex_lock(&netdev->phydev->lock);
>>
>> Do you really need to perform a full MAC reset whenever the link goes 
>> up or down? Instead cannot you just extract the maccr configuration 
>> which adjusts the speed and be done with it?
> 
> This is the original behavior and not changed in this patch set, and I'm 
> not familiar with the hardware design of ftgmac100, so I'd like to limit 
> the changes to the code which really causes practical issues.

This unlocking and re-locking seems superfluous when you could introduce 
a version of ftgmac100_reset() which does not acquire the PHY device 
mutex, and have that version called from ftgmac100_adjust_link(). For 
every other call site, you would acquire it. Something like this for 
instance:


diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
b/drivers/net/ethernet/faraday/ftgmac100.c
index 691605c15265..98179c3fd9ee 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1038,7 +1038,7 @@ static void ftgmac100_adjust_link(struct 
net_device *netdev)
         iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);

         /* Reset the adapter asynchronously */
-       schedule_work(&priv->reset_task);
+       ftgmac100_reset(priv, false);
  }

  static int ftgmac100_mii_probe(struct net_device *netdev)
@@ -1410,10 +1410,8 @@ static int ftgmac100_init_all(struct ftgmac100 
*priv, bool ignore_alloc_err)
         return err;
  }

-static void ftgmac100_reset_task(struct work_struct *work)
+static void ftgmac100_reset_task(struct ftgmac100_priv *priv, bool 
lock_phy)
  {
-       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
-                                             reset_task);
         struct net_device *netdev = priv->netdev;
         int err;

@@ -1421,7 +1419,7 @@ static void ftgmac100_reset_task(struct 
work_struct *work)

         /* Lock the world */
         rtnl_lock();
-       if (netdev->phydev)
+       if (netdev->phydev && lock_phy)
                 mutex_lock(&netdev->phydev->lock);
         if (priv->mii_bus)
                 mutex_lock(&priv->mii_bus->mdio_lock);
@@ -1454,11 +1452,19 @@ static void ftgmac100_reset_task(struct 
work_struct *work)
   bail:
         if (priv->mii_bus)
                 mutex_unlock(&priv->mii_bus->mdio_lock);
-       if (netdev->phydev)
+       if (netdev->phydev && lock_phy)
                 mutex_unlock(&netdev->phydev->lock);
         rtnl_unlock();
  }

+static void ftgmac100_reset_task(struct work_struct *work)
+{
+       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
+                                             reset_task);
+
+       ftgmac100_reset(priv, true);
+}
+
  static int ftgmac100_open(struct net_device *netdev)
  {
         struct ftgmac100 *priv = netdev_priv(netdev)
-- 
Florian

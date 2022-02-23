Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA81B4C1A9A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbiBWSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbiBWSGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:06:10 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4BE4474A;
        Wed, 23 Feb 2022 10:05:42 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w2so3892968pfu.11;
        Wed, 23 Feb 2022 10:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=wPKvdG9MiJl4UoPQrMZNghdi08S94Vr/cTBvfiJr0xQ=;
        b=atgWdBG06KiOZ+3oYOl+6hFMkIX+ANUyyqeaREhChcPH5YfUbtQUoon4XfXpPdNGYs
         bw3ZpNNClIoIApgcgVQn2I8ns0Lt/J5dTUVD3TJFlB2t9rVlOluo93+eI0mZesYpkfqL
         agUrapqO17vZTSQk7LxX34x+WZy58Kn+KslzroSVS3uSbTngD+CBSKkHphq6DUiqMcfH
         AJQ5dOEz4I3ucKLrA1xLERh3bchPGrCLxNSgRLAG+30kSWcxaXxlMJXSHC4cAS753LqS
         SIp1z5pmZ9+3oRePFdP8d03z5/BOKunThwb1khHEEpmNE6rIzzdQYAjlpFMA/9SXZlbr
         DKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=wPKvdG9MiJl4UoPQrMZNghdi08S94Vr/cTBvfiJr0xQ=;
        b=H7KIKSp7WKQ8nZyQYlWqC3H8lrXXjJmawq+lTNR3MJLtoKyXMEXJhVoI2x9gE3IPY0
         ljgjORhek8OCUMIoaDZwJKzsVfxtxKP+X/l47XCpvl286rsqNLy+PgCWsVXgoJgrP877
         8h/ApB7sQpM5kUqZ1av73YrHfOaUw8nH4B34vobI5CSds/n3lCSDWxPHNQG02zAHi3GA
         +FQjjsRMmgi0RKx5kP2NbiDVXXtN/HSOgUiUCP9NHIv1aRQd4RUJIvlJmaRdCusQkMlH
         cfse56NDry3J9ivdRCLExybTgv+L+Kk5/gNLMZsILcdJRmhw8tviU5bX2g6DnBGKPJX3
         kwyw==
X-Gm-Message-State: AOAM533Fy8C13T3pdbU7Gp2OKl9sqM30QzuAL4uthFWLrcnEYVCxTm7b
        3ciHLn/IbtuS+/3AnlFLhy4=
X-Google-Smtp-Source: ABdhPJx9f5FGyNqIZirZw9BaxyVnHr59J9ebvt0SancrJd+HwJdJChZIWngDR3CC8PemJr9S3dYLgQ==
X-Received: by 2002:a63:1456:0:b0:373:c08c:124d with SMTP id 22-20020a631456000000b00373c08c124dmr594328pgu.363.1645639542006;
        Wed, 23 Feb 2022 10:05:42 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m126sm136913pga.94.2022.02.23.10.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 10:05:40 -0800 (PST)
Message-ID: <3b14ad6f-f8a5-bc8c-f0be-d0fda8e908a1@gmail.com>
Date:   Wed, 23 Feb 2022 10:05:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
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
 <91e2d4ad-7544-784b-defe-3a76577462f1@gmail.com>
In-Reply-To: <91e2d4ad-7544-784b-defe-3a76577462f1@gmail.com>
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



On 2/23/2022 9:55 AM, Florian Fainelli wrote:
> 
> 
> On 2/23/2022 3:39 AM, Heyi Guo wrote:
>> Hi Florian,
>>
>> 在 2022/2/23 下午1:00, Florian Fainelli 写道:
>>>
>>>
>>> On 2/22/2022 7:14 PM, Heyi Guo wrote:
>>>> DHCP failures were observed with systemd 247.6. The issue could be
>>>> reproduced by rebooting Aspeed 2600 and then running ifconfig ethX
>>>> down/up.
>>>>
>>>> It is caused by below procedures in the driver:
>>>>
>>>> 1. ftgmac100_open() enables net interface and call phy_start()
>>>> 2. When PHY is link up, it calls netif_carrier_on() and then
>>>> adjust_link callback
>>>> 3. ftgmac100_adjust_link() will schedule the reset task
>>>> 4. ftgmac100_reset_task() will then reset the MAC in another schedule
>>>>
>>>> After step 2, systemd will be notified to send DHCP discover packet,
>>>> while the packet might be corrupted by MAC reset operation in step 4.
>>>>
>>>> Call ftgmac100_reset() directly instead of scheduling task to fix the
>>>> issue.
>>>>
>>>> Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
>>>> ---
>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>> Cc: "David S. Miller" <davem@davemloft.net>
>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>> Cc: Joel Stanley <joel@jms.id.au>
>>>> Cc: Guangbin Huang <huangguangbin2@huawei.com>
>>>> Cc: Hao Chen <chenhao288@hisilicon.com>
>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>> Cc: Dylan Hung <dylan_hung@aspeedtech.com>
>>>> Cc: netdev@vger.kernel.org
>>>>
>>>>
>>>> ---
>>>>   drivers/net/ethernet/faraday/ftgmac100.c | 13 +++++++++++--
>>>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
>>>> b/drivers/net/ethernet/faraday/ftgmac100.c
>>>> index c1deb6e5d26c5..d5356db7539a4 100644
>>>> --- a/drivers/net/ethernet/faraday/ftgmac100.c
>>>> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>>>> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct 
>>>> net_device *netdev)
>>>>       /* Disable all interrupts */
>>>>       iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>>>>   -    /* Reset the adapter asynchronously */
>>>> -    schedule_work(&priv->reset_task);
>>>> +    /* Release phy lock to allow ftgmac100_reset to aquire it, 
>>>> keeping lock
>>>
>>> typo: acquire
>>>
>> Thanks for the catch :)
>>>> +     * order consistent to prevent dead lock.
>>>> +     */
>>>> +    if (netdev->phydev)
>>>> +        mutex_unlock(&netdev->phydev->lock);
>>>> +
>>>> +    ftgmac100_reset(priv);
>>>> +
>>>> +    if (netdev->phydev)
>>>> +        mutex_lock(&netdev->phydev->lock);
>>>
>>> Do you really need to perform a full MAC reset whenever the link goes 
>>> up or down? Instead cannot you just extract the maccr configuration 
>>> which adjusts the speed and be done with it?
>>
>> This is the original behavior and not changed in this patch set, and 
>> I'm not familiar with the hardware design of ftgmac100, so I'd like to 
>> limit the changes to the code which really causes practical issues.
> 
> This unlocking and re-locking seems superfluous when you could introduce 
> a version of ftgmac100_reset() which does not acquire the PHY device 
> mutex, and have that version called from ftgmac100_adjust_link(). For 
> every other call site, you would acquire it. Something like this for 
> instance:
> 
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index 691605c15265..98179c3fd9ee 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1038,7 +1038,7 @@ static void ftgmac100_adjust_link(struct 
> net_device *netdev)
>          iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
> 
>          /* Reset the adapter asynchronously */
> -       schedule_work(&priv->reset_task);
> +       ftgmac100_reset(priv, false);
>   }
> 
>   static int ftgmac100_mii_probe(struct net_device *netdev)
> @@ -1410,10 +1410,8 @@ static int ftgmac100_init_all(struct ftgmac100 
> *priv, bool ignore_alloc_err)
>          return err;
>   }
> 
> -static void ftgmac100_reset_task(struct work_struct *work)
> +static void ftgmac100_reset_task(struct ftgmac100_priv *priv, bool 
> lock_phy)
>   {
> -       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
> -                                             reset_task);
>          struct net_device *netdev = priv->netdev;
>          int err;
> 
> @@ -1421,7 +1419,7 @@ static void ftgmac100_reset_task(struct 
> work_struct *work)
> 
>          /* Lock the world */
>          rtnl_lock();
> -       if (netdev->phydev)
> +       if (netdev->phydev && lock_phy)
>                  mutex_lock(&netdev->phydev->lock);
>          if (priv->mii_bus)
>                  mutex_lock(&priv->mii_bus->mdio_lock);
> @@ -1454,11 +1452,19 @@ static void ftgmac100_reset_task(struct 
> work_struct *work)
>    bail:
>          if (priv->mii_bus)
>                  mutex_unlock(&priv->mii_bus->mdio_lock);
> -       if (netdev->phydev)
> +       if (netdev->phydev && lock_phy)
>                  mutex_unlock(&netdev->phydev->lock);
>          rtnl_unlock();
>   }
> 
> +static void ftgmac100_reset_task(struct work_struct *work)
> +{
> +       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
> +                                             reset_task);
> +
> +       ftgmac100_reset(priv, true);
> +}
> +
>   static int ftgmac100_open(struct net_device *netdev)
>   {
>          struct ftgmac100 *priv = netdev_priv(netdev)

Well this whole patch series has been applied already so I guess those 
comments are partially or totally moot now.

I have not received my notification about these patches being applied, 
unless when Jakub applies them, so either it is another vger/gmail lag 
that is absolutely unnerving or it is a difference of process between 
David and Jakub, in which case it really ought to be fixed such that it 
is consistent.
-- 
Florian

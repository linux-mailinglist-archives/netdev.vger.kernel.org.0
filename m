Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C36D456B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDCNOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjDCNN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:13:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3CC1C1CE
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:13:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x3so117070818edb.10
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 06:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680527634;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6G+jonMAJ75poejdWqI9HN2AzOEp6UWvgAenLclr8tQ=;
        b=D5JNSHR3z2FKHqAY7m3chpf8A/WY2aMCq1VEAMkGDdHpDcitVH/43hhQPX2hQ5UNPH
         OBRttlfSZfHmy1CeqGvjmGTdViNqtHNdYI2n7p9fpDlvrcuN9jvZ+ZsTTvPA/ZmDzZTm
         3Hu9MuGcknrV0y92u+eEdgW/RAnKWrLux5lWGC5TWtlqRh2e8UWflPdYKeYjBHbbRd3j
         yhae5rRUYR+ji/FC4E+VVmeY/gosvQsl1KdPhafQ+pE9hvoR5Ijq9LDkXuSlbUW5YI9E
         JHWvmG44hil8aSB1ua+amKqPY4T6PGwtLdnhBIQoxQX19RmhFEcNzZOjY7uBZFxI4ivt
         aIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680527634;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6G+jonMAJ75poejdWqI9HN2AzOEp6UWvgAenLclr8tQ=;
        b=bZSqmtj/noMgxY0R7ToSqZ2mzFLXGFb0Ee8QQoeN/GT/tFYE5t8SxOATtMZQQV9d4t
         pFkjZaTNvUhw4wg9vMhYuhPTNKKCWPKntq1iruwC+U0KEZ7MNe8aey7Llfm5gcZzi1LO
         f4xTfkN91+7Jk6BUuRw0Oi2O9OPXBlYyEZCt6O3lnGPgUTxu4CrIQdfGsDDcrw4lMdta
         70aMZKUgQ2d4hPx8SNkeEF23P/aNkmYKVJpI71o7+TEYsQpz+o1YJO8nuKAq9u2hvVFg
         zBpE7ymo/Ga8KYH9ie40NBPiR+mMcxDEPuZh6E4tUwJMxit/vd2UZWUu/Lnnxd8nO5Z0
         IO/w==
X-Gm-Message-State: AAQBX9c3fQ2opbdhxxqaEDBgjCCGJRHjWtvJFaoJAa/QG3RQYTVDLEvW
        RuStvA4uY92yO0mKQ8KkEUI=
X-Google-Smtp-Source: AKy350Y1v2zmUsWCkjC0vghCacH0dBiMBICa4bU4TMs7zMDPQ+eArQ8BEyuYKKlBkDX+Zk+H2olb0w==
X-Received: by 2002:a17:906:6c88:b0:932:2282:dbd6 with SMTP id s8-20020a1709066c8800b009322282dbd6mr34311341ejr.5.1680527633902;
        Mon, 03 Apr 2023 06:13:53 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9a3:9100:1002:d829:faf:9d0c? (dynamic-2a01-0c23-b9a3-9100-1002-d829-0faf-9d0c.c23.pool.telefonica.de. [2a01:c23:b9a3:9100:1002:d829:faf:9d0c])
        by smtp.googlemail.com with ESMTPSA id r3-20020a170906350300b00930876176e2sm4520087eja.29.2023.04.03.06.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 06:13:53 -0700 (PDT)
Message-ID: <4f834fef-c932-cbad-92fc-88c08927c0be@gmail.com>
Date:   Mon, 3 Apr 2023 15:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092341.268964-1-vinschen@redhat.com>
 <45c43618-3368-f780-c8bb-68db4ed5760f@gmail.com>
 <ZCqfwxr2I7xt6zon@calimero.vinschen.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: stmmac: allow ethtool action on PCI devices
 if device is down
In-Reply-To: <ZCqfwxr2I7xt6zon@calimero.vinschen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.04.2023 11:43, Corinna Vinschen wrote:
> On Mar 31 12:48, Heiner Kallweit wrote:
>> On 31.03.2023 11:23, Corinna Vinschen wrote:
>>> So far stmmac is only able to handle ethtool commands if the device
>>> is UP.  However, PCI devices usually just have to be in the active
>>> state for ethtool commands.
>>>
>> What do mean with "active state" here? D0? Or, as you say "connected
>> to PCI" a few lines later, do you refer to hot-plugging?
>>
>> PCI being in D0 often isn't sufficient, especially if interface is down.
>> Then required resources like clocks may be disabled by the driver.
>>
>> A driver may runtime-suspend a device for multiple reasons, e.g.
>> interface down or link down. Then the device may be put to D3hot
>> to save power.
>> If we say that it's worth to wake a device for an ethtool command,
>> then I wonder whether this is something that should be done in net
>> core. E.g. calling pm_runtime_get_sync() in __dev_ethtool, similar to
>> what we do in __dev_open() to deal with run-time suspended and
>> therefore potentially detached devices.
> 
> Actually, I'm not sure how to reply to your question.  I replicated the
> behaviour of the igb and igc drivers, because that looked like the right
> thing to do for a PCIe device.  It seems a bit awkward that the UP/DOWN
> state allows or denies device settings.  
> 
My point is, whenever boilerplate code is copied from one driver to
another, then this may be something for the core. So, instead of solving
an issue for one driver, it might be solved in general.

> 
> Corinna
> 
> 
> 
>>
>>> Rename stmmac_check_if_running to stmmac_ethtool_begin and add a
>>> stmmac_ethtool_complete action.  Check if the device is connected
>>> to PCI and if so, just make sure the device is active.  Reset it
>>> to idle state as complete action.
>>>
>>> Tested on Intel Elkhart Lake system.
>>>
>>> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
>>> ---
>>>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 20 +++++++++++++++++--
>>>  1 file changed, 18 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
>>> index 35c8dd92d369..5a57970dc06a 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
>>> @@ -14,6 +14,7 @@
>>>  #include <linux/mii.h>
>>>  #include <linux/phylink.h>
>>>  #include <linux/net_tstamp.h>
>>> +#include <linux/pm_runtime.h>
>>>  #include <asm/io.h>
>>>  
>>>  #include "stmmac.h"
>>> @@ -429,13 +430,27 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
>>>  
>>>  }
>>>  
>>> -static int stmmac_check_if_running(struct net_device *dev)
>>> +static int stmmac_ethtool_begin(struct net_device *dev)
>>>  {
>>> +	struct stmmac_priv *priv = netdev_priv(dev);
>>> +
>>> +	if (priv->plat->pdev) {
>>> +		pm_runtime_get_sync(&priv->plat->pdev->dev);
>>> +		return 0;
>>> +	}
>>>  	if (!netif_running(dev))
>>>  		return -EBUSY;
>>>  	return 0;
>>>  }
>>>  
>>> +static void stmmac_ethtool_complete(struct net_device *dev)
>>> +{
>>> +	struct stmmac_priv *priv = netdev_priv(dev);
>>> +
>>> +	if (priv->plat->pdev)
>>> +		pm_runtime_put(&priv->plat->pdev->dev);
>>> +}
>>> +
>>>  static int stmmac_ethtool_get_regs_len(struct net_device *dev)
>>>  {
>>>  	struct stmmac_priv *priv = netdev_priv(dev);
>>> @@ -1152,7 +1167,8 @@ static int stmmac_set_tunable(struct net_device *dev,
>>>  static const struct ethtool_ops stmmac_ethtool_ops = {
>>>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>>>  				     ETHTOOL_COALESCE_MAX_FRAMES,
>>> -	.begin = stmmac_check_if_running,
>>> +	.begin = stmmac_ethtool_begin,
>>> +	.complete = stmmac_ethtool_complete,
>>>  	.get_drvinfo = stmmac_ethtool_getdrvinfo,
>>>  	.get_msglevel = stmmac_ethtool_getmsglevel,
>>>  	.set_msglevel = stmmac_ethtool_setmsglevel,
> 


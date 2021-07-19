Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBF93CD638
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbhGSNRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbhGSNRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:17:10 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D1C061762;
        Mon, 19 Jul 2021 06:21:34 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id b14-20020a1c1b0e0000b02901fc3a62af78so12908573wmb.3;
        Mon, 19 Jul 2021 06:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fHSWNGrkSNMuhKj8Y5R+6EmJuzKK0O4I+/H5FE1TxZI=;
        b=ehvH3h10VqLMU2d3VGggNensqAWDt36VXVH5tFmiAP2rYqogx9g5rn3sBXySowE2jz
         YqBF7ymr2swE3J9gm4/udp6mzcJPc8St+1m+29O1usWEyWqjHID7BUTkd/rgk4PNY4KW
         LfHsXs31hQ5SGUQ1N1qWm5vzPAAi1Y7OQsif0DqlgUhjc9jKZ/10ugFAHQDUfXFB5j9Y
         Z0HAbJkxeXBdbVSfVPtpYIniNE5fkq7kKi4Nq2X6cr+/nXFDiVmDUuD+IZ4XbwJCMLxa
         2VKmMeg5JioLqJxXkB9bv/6W1SEc5rFgQ6gkXfqRo0z0gRqisFCqQ6CpGOlEeWM6z36S
         ghxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fHSWNGrkSNMuhKj8Y5R+6EmJuzKK0O4I+/H5FE1TxZI=;
        b=cleZV7cL9Aex4zvXYAKKLGPJpKiv0oQOBAEVbHOQQcwmTO1PcXQcMFveVhFugGrzCM
         YqEQvM9beams9ojRI+THRK/TlO24l9JldIYjIkXjweGrj8iTUgqufEymghZfpalIb2YV
         C3s+NkLrDVZOZFz8gK72qGEO2bCz2FQi8GAro+5Np/r63T2hPJ6yx+Xs1ktWXRCr97B3
         N+uIg3MES0Cy9rEyULEsM0ACxX0m5pM7iVNElBIicsuZS0V9DE/xSlBjppU+YULQbonN
         Fr2A6V8Od0WdSUdMQANZyOwBUEMO4EuKNW0oWWlY07rm2SyTaus1DSPj6ixhJt4NgqZA
         QlLA==
X-Gm-Message-State: AOAM530HcZaRnG46yzeEO3/0OAL3Y3nqp4y7MK234fcmurr+pkZueqwq
        obq1eNZ69qB0BH00c6Qa/u4=
X-Google-Smtp-Source: ABdhPJxpZVyKzzV95B4qNAECc1RYoS1nhyoGQQlnOYEssfAtJiFFn2/iqqNnkBxzcHukNwvcPwR5EQ==
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr26635864wms.50.1626703068197;
        Mon, 19 Jul 2021 06:57:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:980:d4f8:8883:9389? (p200300ea8f3f3d000980d4f888839389.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:980:d4f8:8883:9389])
        by smtp.googlemail.com with ESMTPSA id e6sm23756165wrg.18.2021.07.19.06.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 06:57:47 -0700 (PDT)
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com
References: <20210719130845.2102-1-chenhaoa@uniontech.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v5] net: stmmac: fix 'ethtool -P' return -EBUSY
Message-ID: <b0c93757-dd32-9d85-6f9e-12956d766661@gmail.com>
Date:   Mon, 19 Jul 2021 15:57:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210719130845.2102-1-chenhaoa@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.07.2021 15:08, Hao Chen wrote:
> The permanent mac address should be available for query when the device
> is not up.
> NetworkManager, the system network daemon, uses 'ethtool -P' to obtain
> the permanent address after the kernel start. When the network device
> is not up, it will return the device busy error with 'ethtool -P'. At
> that time, it is unable to access the Internet through the permanent
> address by NetworkManager.

At first a few formal aspects:
- You don't get a lot of new friends when posting a new version every
  few hours. Consolidate feedback and then post a new version,
  typically not more than one version per day. Mileage of maintainers
  may vary here.
- When posting a new version include a change log.
- Properly annotate the patch as net vs. net-next.
- If you declare something to be a fix, add a Fixes tag.

> I think that the '.begin' is not used to check if the device is up, it's
> just a pre hook for ethtool. We shouldn't check if the device is up
> there.
> 

Supposedly the check is there for a reason. Your statement leaves the
impression that you're not aware of why the check exists.
Therefore: First understand this, and then explain why it's safe to
remove the check. This drivers uses runtime pm, so device
might be in PCI D3 if interface is down (don't know this driver in
detail). Therefore registers may not be accessible what may impact
certain ethtool ops.

> Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index d0ce608b81c3..8901dc9f758e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -410,13 +410,6 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
>  
>  }
>  
> -static int stmmac_check_if_running(struct net_device *dev)
> -{
> -	if (!netif_running(dev))
> -		return -EBUSY;
> -	return 0;
> -}
> -
>  static int stmmac_ethtool_get_regs_len(struct net_device *dev)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> @@ -1073,7 +1066,6 @@ static int stmmac_set_tunable(struct net_device *dev,
>  static const struct ethtool_ops stmmac_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_MAX_FRAMES,
> -	.begin = stmmac_check_if_running,
>  	.get_drvinfo = stmmac_ethtool_getdrvinfo,
>  	.get_msglevel = stmmac_ethtool_getmsglevel,
>  	.set_msglevel = stmmac_ethtool_setmsglevel,
> 


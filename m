Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4970A1C2530
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEBMV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727118AbgEBMV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:21:26 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E551C061A0F
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 05:21:25 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id b24so5841847lfp.7
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 05:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ceg32SJO0EfoqNJv2X/qLbUtrniOfXr61mP5NwTkMnU=;
        b=VVkqCu9RDWzq6YBs/j7mOw6q8qNZldPYjfP4UuI2Y4rWUHx4Ici/alROEbx5tk1pt2
         oIa9S2ePWl69sn0ufl+SZuQVtMeGSJNPIaDp9cqtdvFJLWkXC2NkY3nkx2vKH1JRuu9O
         jVsrQKte+hcB1DSDCuPb5gJXNSU+KQ1/o3yMLiqIHNEcnQVfwrX6HOAR421LY+I4Cr6L
         7863hIoMUdmSE1H7gUbE9oQTVt5n7tLHBjgZZZNqIoWlCttTRCbqKXrvSfYjrKJ2w6B4
         Nqki6Cwxnl5HWqNl4fWMDs+FPd7Wlxw4VViQeqDA5ZR/i4Ynr0qroqlkcu6BTvA+NuN3
         d0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ceg32SJO0EfoqNJv2X/qLbUtrniOfXr61mP5NwTkMnU=;
        b=QBpJDROXrcTifWMT17IZ8lQfFXX1IoVhcYO7v2PGcnc2AfRROJbwA6aYWEFWE7GlyU
         lFGtMqYLIuXo/+zFvsM2FXgL6SHsacUz75mqYpIw5tXH/UjhZpNPeSW8iYjx6canW78q
         NzjTe9hBmNEwK55eJUpILJ3LkdseazRCiPuqE9RKBcr8eNuZRvBAvheTJnBZauCGzQNG
         c0yH25EIQS2wvwM9NIIC6n32bkCXnpvH1ieQol5xbhEfzeUaR3dRJeVhrL7fgNEd03vd
         A8nu1kYwFBTHzxqMhkUfFE9BE0bCxmLmBm5HR97osvzCsxu5Gmyh/f46HUSxzypVDeuf
         1I9Q==
X-Gm-Message-State: AGi0PuYskbzMRGEVIcDZVXK4xHLjhqW2X0Wu9mejXouQ+LXReSu9yLMQ
        Yu5GUDYzkg3RZX9QYRZ50zTtQ4s76FU=
X-Google-Smtp-Source: APiQypK/eS7/y7LmA2plGuu3YKGMbgawTzyGOOoUslRJ6ZF24W0m4iEHUiqZ8X6omdaDwmTd0IR4Kw==
X-Received: by 2002:a19:10:: with SMTP id 16mr5486216lfa.145.1588422083405;
        Sat, 02 May 2020 05:21:23 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:44e2:b75:5482:ef8f:6eeb:f75c? ([2a00:1fa0:44e2:b75:5482:ef8f:6eeb:f75c])
        by smtp.gmail.com with ESMTPSA id h24sm4650568lji.99.2020.05.02.05.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 05:21:22 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: sja1105: fix speed setting for 10 MBPS
To:     Colin King <colin.king@canonical.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
References: <20200501134310.289561-1-colin.king@canonical.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <ccfa3bc1-cdbd-f990-321f-55555531d56d@cogentembedded.com>
Date:   Sat, 2 May 2020 15:21:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501134310.289561-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 01.05.2020 16:43, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The current logic for speed checking will never set the speed to 10 MBPS
> because bmcr & BMCR_SPEED10 is always 0 since BMCR_SPEED10 is 0. Also
> the erroneous setting where BMCR_SPEED1000 and BMCR_SPEED100 are both
> set causes the speed to be 1000 MBS.  Fix this by masking bps and checking
> for just the expected settings of BMCR_SPEED1000, BMCR_SPEED100 and
> BMCR_SPEED10 and defaulting to the unknown speed otherwise.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: ffe10e679cec ("net: dsa: sja1105: Add support for the SGMII port")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/dsa/sja1105/sja1105_main.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 472f4eb20c49..59a9038cdc4e 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -1600,6 +1600,7 @@ static const char * const sja1105_reset_reasons[] = {
>   int sja1105_static_config_reload(struct sja1105_private *priv,
>   				 enum sja1105_reset_reason reason)
>   {
> +	const int mask = (BMCR_SPEED1000 | BMCR_SPEED100 | BMCR_SPEED10);

    Why not declare it in the block it's used in? Also, () not needed here.

>   	struct ptp_system_timestamp ptp_sts_before;
>   	struct ptp_system_timestamp ptp_sts_after;
>   	struct sja1105_mac_config_entry *mac;
> @@ -1684,14 +1685,16 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
>   		sja1105_sgmii_pcs_config(priv, an_enabled, false);
>   
>   		if (!an_enabled) {
> -			int speed = SPEED_UNKNOWN;
> +			int speed;

    Why not the following?

		int mask = bmcr & (BMCR_SPEED1000 | BMCR_SPEED100 |
			   BMCR_SPEED10);			

>   
> -			if (bmcr & BMCR_SPEED1000)
> +			if ((bmcr & mask) == BMCR_SPEED1000)
>   				speed = SPEED_1000;
> -			else if (bmcr & BMCR_SPEED100)
> +			else if ((bmcr & mask) == BMCR_SPEED100)
>   				speed = SPEED_100;
> -			else if (bmcr & BMCR_SPEED10)
> +			else if ((bmcr & mask) == BMCR_SPEED10)
>   				speed = SPEED_10;
> +			else
> +				speed = SPEED_UNKNOWN;
>   
>   			sja1105_sgmii_pcs_force_speed(priv, speed);
>   		}

MBR, Sergei

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196CC41CE5A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhI2Vqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbhI2Vqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:46:49 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3884C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:45:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y35so14044064ede.3
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NslNUga1Uh3/vf9xg4WQyQUP9BolY9ZRqsj6zWmvwFU=;
        b=c+ZEe6mPU8NRDo+crLjKREcLHdkTGe7c+CSevv1i+/KmDWDOzu4UUepHU5sXIOgDCP
         QbXDIAMUOXAbv54X6vUoqWsTkBrRauhNbxzekaE8btmiYugxqSGvv5EGGJIe/a5rn958
         LgO8Z3M8zSnbCYcuPZvNRGybQLLrb1QQNbmUKYe+NA2NkjGWyJVDEpgEMFpt5RY297kt
         +FJh6j349xZhf2zQj5xs1xgMpsMqZWrXpFY9lBaEJyK3hA0fl52i4HolJnSoxDZ90kSR
         5fO/msezs0Tb6DKiIbEPpJ+w+3RYKwW1IXFkIiMQKUXQjhHblB9vn8azSGEAjd8Q+U11
         XQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NslNUga1Uh3/vf9xg4WQyQUP9BolY9ZRqsj6zWmvwFU=;
        b=y9PGcBiazvMovxTJvT5Ir3euzB5rW1ao4pmvMcNqetHyzIFLRQ5kTA0LYIL6Fk2gV4
         NTDxFCTTj9/5w5jIfCZutHnt4HMhVhDQdQPWKQ6JlgwxcxQQFEn6xSzsdxFhz8BisJ4o
         QnALO+iNjBjdazYxsSt1mrrN5BONo1P/jkSvRrE4n8AmjLtI9wguQOEHUz9ZMZvrGh1w
         O50+Vta0p5bmUQO/T67C1qdMyM5oHBsRCLrSu0Ao6UNdNBJmfeu9RLujK6VCkHKy213R
         98ZOwKOi+1tNUW9/mj96b+2WhEiT96FlRn5r90SoGOkEOIb2BaNi/o6FtuIkjB73Vbu7
         Fztw==
X-Gm-Message-State: AOAM532SzgfI7dzwwQI+PQ89qUuZSsUb2/QAvAZ/aZvUsnfCdlnZpx/R
        6zdsx8nbik010RoaZVETTcsDmCckxlM=
X-Google-Smtp-Source: ABdhPJzlQTPZff3fnFgeT1Ce4pebOtSbRAA3aJDfGJHCYUCAKqMb43gBxtSRZeB+NVwMg6RdV1SBOw==
X-Received: by 2002:a17:907:97d2:: with SMTP id js18mr2435777ejc.191.1632951906325;
        Wed, 29 Sep 2021 14:45:06 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id ky7sm548950ejc.75.2021.09.29.14.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:45:05 -0700 (PDT)
Date:   Thu, 30 Sep 2021 00:45:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 3/4 v4] net: dsa: rtl8366rb: Support fast aging
Message-ID: <20210929214504.gvrcx7lpl5apouwc@skbuf>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929210349.130099-4-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:03:48PM +0200, Linus Walleij wrote:
> This implements fast aging per-port using the special "security"
> register, which will flush any learned L2 LUT entries on a port.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v3->v4:
> - No changes, rebased on the other patches.
> ChangeLog v2->v3:
> - Underscore that this only affects learned L2 entries, not
>   static ones.
> ChangeLog v1->v2:
> - New patch suggested by Vladimir.
> ---
>  drivers/net/dsa/rtl8366rb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 52e750ea790e..748f22ab9130 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -1359,6 +1359,19 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static void
> +rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +
> +	/* This will age out any learned L2 entries */
> +	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
> +			   BIT(port), BIT(port));

Is there any delay that needs to be added between these two operations?

> +	/* Restore the normal state of things */
> +	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
> +			   BIT(port), 0);
> +}
> +
>  static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct realtek_smi *smi = ds->priv;
> @@ -1771,6 +1784,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.port_disable = rtl8366rb_port_disable,
>  	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
>  	.port_bridge_flags = rtl8366rb_port_bridge_flags,
> +	.port_fast_age = rtl8366rb_port_fast_age,
>  	.port_change_mtu = rtl8366rb_change_mtu,
>  	.port_max_mtu = rtl8366rb_max_mtu,
>  };
> -- 
> 2.31.1
> 

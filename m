Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAC035362F
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 04:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhDDC1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 22:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbhDDC1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 22:27:06 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252E7C061756;
        Sat,  3 Apr 2021 19:27:03 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so8367576otb.7;
        Sat, 03 Apr 2021 19:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2SDB3YU1ytBkqQbKe2z8gBexfClS4b7RI4flCaWJLjU=;
        b=gXmTrja5EDjkmbNYRR+MsdfXEFl9YpVk8uoEM1Dc2fOQBlLQe5M2f6A5ITTAr00QQ1
         zYRoaTMkbOoBupp0XWBsEJOYICjT4mWrsWaqrSBWWpZcm5eeeDZH6qGJXc1S0mZHTuKo
         GaGWNntbVrCUDbRb6Jt56wMei7NKiKH7earkYwFfcG1hzZr0eu3tmmM1Q+NDuapWevDX
         +PEzuQy3sfU9LxRZrxKJuFZiV0TijVGUs6r0S/YmCuEWcartdx6FsdoS///kuuvX1b/N
         4O3VOmTOsopgV2lFR3PGttjwYd567keeHMggZ7AUAkUWrgXCFRreb0JQT10+V864MO8o
         UAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2SDB3YU1ytBkqQbKe2z8gBexfClS4b7RI4flCaWJLjU=;
        b=kuiHXVtLW1zWs5BWysHefTge58YibXreMeI81uEESK/TVK9EGgcmmFr8MYPH6azkiu
         IQ5FCMxPP1XkptvtSYCsPITiqkRMjadFPzmhp0qlMR7k2wvwy0iXR4o9m0gBD0k1erTg
         sk8lpNEADtxK8jWeWZMQNsm0dOf+HXvkEaLHkMqZRzXns2KUIpbUeyaAoGTziWdUWL2M
         /t+BNT4wyslDt5IGW1NKfqdw04hmYc9SiQoFrSEi3CVJRm0zkzHO0uRppxjYPW48T4Xe
         Hwc7xJwSFsZHqj0ozYan8YvrHffjU4ArLWhqlbHfM9koEKFsQVZuD4w0TwHrsHQjZB3N
         pqHA==
X-Gm-Message-State: AOAM531V3yCZVaLycOyVbakq+pjExrKAsm8a4pdGpkphroCYtGqzNYUo
        63paEnG6VigQtUy7O4vFG7/+nADjCoU=
X-Google-Smtp-Source: ABdhPJxqOWbZegjcVGuey/gF6IxzAZaVf1I1AJI+o3eFy1rvE7DCTg1wqXnXOuH11kaJol70qhxXnA==
X-Received: by 2002:a05:6830:22f4:: with SMTP id t20mr17752372otc.45.1617503221968;
        Sat, 03 Apr 2021 19:27:01 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:d9ea:8934:6811:fd93? ([2600:1700:dfe0:49f0:d9ea:8934:6811:fd93])
        by smtp.gmail.com with ESMTPSA id t14sm2907073otj.50.2021.04.03.19.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 19:27:01 -0700 (PDT)
Subject: Re: [PATCH net-next v1 7/9] net: dsa: qca: ar9331: add bridge support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-8-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a9e70010-ed16-0f53-2e8a-47fa0050d87b@gmail.com>
Date:   Sat, 3 Apr 2021 19:26:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210403114848.30528-8-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/3/2021 04:48, Oleksij Rempel wrote:
> This switch is providing forwarding matrix, with it we can configure
> individual bridges. Potentially we can configure more then one not VLAN

s/then/than/

> based bridge on this HW.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>   drivers/net/dsa/qca/ar9331.c | 73 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 73 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index b2c22ba924f0..bf9588574205 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -40,6 +40,7 @@
>    */
>   
>   #include <linux/bitfield.h>
> +#include <linux/if_bridge.h>
>   #include <linux/module.h>
>   #include <linux/of_irq.h>
>   #include <linux/of_mdio.h>
> @@ -1134,6 +1135,76 @@ static int ar9331_sw_set_ageing_time(struct dsa_switch *ds,
>   				  val);
>   }
>   
> +static int ar9331_sw_port_bridge_join(struct dsa_switch *ds, int port,
> +				      struct net_device *br)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int port_mask = BIT(priv->cpu_port);
> +	int i, ret;
> +	u32 val;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_to_port(ds, i)->bridge_dev != br)
> +			continue;
> +
> +		if (!dsa_is_user_port(ds, port))
> +			continue;
> +
> +		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
> +		ret = regmap_set_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
> +		if (ret)
> +			goto error;
> +
> +		if (i != port)
> +			port_mask |= BIT(i);
> +	}
> +
> +	val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask);
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
> +				 AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, val);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);

This is not called more than once per port and per bridge join operation 
so I would drop the rate limiting here. With that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

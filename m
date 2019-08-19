Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8895894B79
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfHSRQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:16:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34508 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfHSRQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:16:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so1587050pgc.1
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 10:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FtCbMxdQQl/hfKoj36MFrFv8N0lEYgtbBL6OODrqr/Q=;
        b=rv/b3bKH020FzAIxOvLH3TMk0oAcjvSst7TLzLWUVDYSte34JRRXW/X7PIpXBs/Iwy
         xAMR5xhUuESXU1aABGPbLXuBztbqRmEeXCGH2gQ7lRsRIpWvOre2FeNq4AA4ChkTcQlS
         FgEToYiRTHfM58hDF7ahzWQ7zIR0EUIZlte28BX0YoBRP4jiV3P6CrzZOnJD9ODBQYdR
         bJ9etaK/8MhgAVu+/IlpZGi7blGtBTq1Qh0kWEwcNgCa/bzi5ZKRzO0E+RwQlo6Ej5GV
         +1FI069PVUObv0TxumDqF3paEu9oB1F2pT7T3mSbqlf7O8l5XngcqR4qTjbJRJwBsPLo
         Q3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FtCbMxdQQl/hfKoj36MFrFv8N0lEYgtbBL6OODrqr/Q=;
        b=nRJ39d59W14kWoOYtsaEQsmmj0xtCx4PMiBcgEWfPBjy8+9mBP6cMMb6DQm4sSKp6/
         b0XWmIedZme5ty2gYOoE7G0/3VqB9OqMsj73bZOymc4XO3sU585T+/x4tDjxuK8CcpZb
         NZc5CMhq5R4YQqJota0Rh70HoCQm3cNUeiPB/UpX94LIUMAa+K9gYV4PXW5dzKEf3XsX
         6NOnyJyN7b5ZK99+XZn6TmrVzV+L3ls8RuItMTVCGm+Id8nYMHZCsYdcv5/qMXOGuwHN
         uQn5VUcB2cQldx9MysfXamFbByzlzypn+veubQF+ZwZGvHl9FfPPCGZ+q5sXn1IF92Du
         7BrQ==
X-Gm-Message-State: APjAAAWs1en4fN9G2rWMSBtFl29GcmdalEjRoYxfVnsLR0NLNwU7aWNJ
        ZNacD0KAY6aaBRB7nPGIdpo=
X-Google-Smtp-Source: APXvYqw8jNvuTVYvxCYfW9FiYMvffpC0r7k91aUObWm7a/GxVSkD92Yb47ynPqSiCeA5UF3ISPeLHg==
X-Received: by 2002:a62:584:: with SMTP id 126mr25392485pff.73.1566234985581;
        Mon, 19 Aug 2019 10:16:25 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h20sm16793530pfq.156.2019.08.19.10.16.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 10:16:24 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: dsa: do not enable or disable non user
 ports
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, andrew@lunn.ch
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-3-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <14cac8d6-c134-733b-ac27-079061acfb0c@gmail.com>
Date:   Mon, 19 Aug 2019 10:16:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190818173548.19631-3-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/19 10:35 AM, Vivien Didelot wrote:
> The .port_enable and .port_disable operations are currently only
> called for user ports, hence assuming they have a slave device. In
> preparation for using these operations for other port types as well,
> simply guard all implementations against non user ports and return
> directly in such case.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---

[snip]

>
diff --git a/drivers/net/dsa/b53/b53_common.c
b/drivers/net/dsa/b53/b53_common.c
> index 907af62846ba..1639ea7b7dab 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -510,10 +510,15 @@ EXPORT_SYMBOL(b53_imp_vlan_setup);
>  int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
>  {
>  	struct b53_device *dev = ds->priv;
> -	unsigned int cpu_port = ds->ports[port].cpu_dp->index;
> +	unsigned int cpu_port;
>  	int ret = 0;
>  	u16 pvlan;
>  
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
> +	cpu_port = ds->ports[port].cpu_dp->index;
> +
>  	if (dev->ops->irq_enable)
>  		ret = dev->ops->irq_enable(dev, port);
>  	if (ret)
> @@ -547,6 +552,9 @@ void b53_disable_port(struct dsa_switch *ds, int port)
>  	struct b53_device *dev = ds->priv;
>  	u8 reg;
>  
> +	if (!dsa_is_user_port(ds, port))
> +		return;
> +
>  	/* Disable Tx/Rx for the port */
>  	b53_read8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), &reg);
>  	reg |= PORT_CTRL_RX_DISABLE | PORT_CTRL_TX_DISABLE;

For b53, the changes are correct, for bcm_sf2, see comments below:

> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 49f99436018a..3d06262817bd 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -157,6 +157,9 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
>  	unsigned int i;
>  	u32 reg;
>  
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
>  	/* Clear the memory power down */
>  	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
>  	reg &= ~P_TXQ_PSM_VDD(port);
> @@ -222,6 +225,9 @@ static void bcm_sf2_port_disable(struct dsa_switch *ds, int port)
>  	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
>  	u32 reg;
>  
> +	if (!dsa_is_user_port(ds, port))
> +		return;

in bcm_sf2_sw_suspend(), we do call bcm_sf2_port_disable() against the
user and CPU port.
-- 
Florian

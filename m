Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3D82B0514
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgKLMlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgKLMlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:41:15 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DB4C0613D1;
        Thu, 12 Nov 2020 04:41:13 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id e18so5996082edy.6;
        Thu, 12 Nov 2020 04:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HJB5SmUjhC5jU+2XmV720+ocrmw+lqXKj7zPIVAudI0=;
        b=gNa9aFZw2HycGZz0f9C1gY1o/BEAt0a4Np2P9+ZwpWR7nlXOEw/vi0bRRRQa84EstF
         AtZcUgtTHymUa6/TUxUyJsfnYUGUD6+K7QDuNdq0PwxK379xa9AV3lXtL/Ec2Tm5rZyF
         7cGxYazXpcGKN683f9BvRti1rhq5wWYYw6YdKQegr56EvCbXkb2fmlYKGtNC44iv5b0J
         QmqBepPOCmhad3+yzhNfwJiQYevnGRcGxE3Bt1I/B7MUDB29GaOpEA5jM9SZfivLWlKQ
         nOOs+TK85WIZfTpq9+RHqdKFEYWNiY+8/dWh3Wx4rw7hLt7IwkpdqojRaOMEtG6lzZcr
         RPsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HJB5SmUjhC5jU+2XmV720+ocrmw+lqXKj7zPIVAudI0=;
        b=fSYROIWX8+UC9IGiQqA+daUNEylqgh6xtdmSE/zjnKBsok2eULngrbmYciKpg8ag+1
         Sb6uGoSb49r3wrDN8wRmYJ/jXpmZ8ZrdnQSKfDyYUvPG6qozEkVZJ5c3m8ssJpslaCbd
         PSTNmhwoFBEYJna4jJPKoxJcJJnGKy9LGy49Im85s+R3B5KDFbcHKchKZ+ByS9l5pzPW
         HeaxtL2WHYyn51GBzeWwJIagJKEmdk/5W72IYrGAcQGh7NarTcCHkIbz/m/f/tPJmVj2
         XhDtIEuELvSTpnlinoyeZHwh9zLWESrp+wZpW7/KYk9jkYkFWfp8KkjXBvt26i+FR/9v
         XxDg==
X-Gm-Message-State: AOAM531xfboLM0jON9OT08HajOJYNU4rMlIbIJfeOMLmaaedXT8Inwf7
        ZeZhmxtOP9mu7EW2yTfJupk=
X-Google-Smtp-Source: ABdhPJyzX8xu8vaMssKReTg+hH/4WZ79lqx4sgAS1AKpFz+X6jBnSH1nuQ6dSNVbfI++zxYnkOjKhw==
X-Received: by 2002:a50:9b01:: with SMTP id o1mr4757758edi.364.1605184871837;
        Thu, 12 Nov 2020 04:41:11 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l20sm2098248eja.40.2020.11.12.04.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 04:41:11 -0800 (PST)
Date:   Thu, 12 Nov 2020 14:41:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: add missed
 clk_disable_unprepare() in gswip_gphy_fw_load()
Message-ID: <20201112124110.yhquvw2cptvh2oii@skbuf>
References: <1605179495-818-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605179495-818-1-git-send-email-zhangchangzhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 07:11:35PM +0800, Zhang Changzhong wrote:
> Fix missing clk_disable_unprepare() before return from
> gswip_gphy_fw_load() in the error handling case.
> 
> Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/dsa/lantiq_gswip.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 74db81d..8936d65 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1682,6 +1682,7 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
>  	if (ret) {
>  		dev_err(dev, "failed to load firmware: %s, error: %i\n",
>  			gphy_fw->fw_name, ret);
> +		clk_disable_unprepare(gphy_fw->clk_gate);
>  		return ret;
>  	}
>  
> @@ -1698,14 +1699,17 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
>  	} else {
>  		dev_err(dev, "failed to alloc firmware memory\n");
>  		release_firmware(fw);
> +		clk_disable_unprepare(gphy_fw->clk_gate);
>  		return -ENOMEM;
>  	}
>  
>  	release_firmware(fw);
>  
>  	ret = regmap_write(priv->rcu_regmap, gphy_fw->fw_addr_offset, dev_addr);
> -	if (ret)
> +	if (ret) {
> +		clk_disable_unprepare(gphy_fw->clk_gate);
>  		return ret;
> +	}
>  
>  	reset_control_deassert(gphy_fw->reset);
>  
> -- 
> 2.9.5
> 

gswip_gphy_fw_list
-> gswip_gphy_fw_probe
   -> gswip_gphy_fw_load
      -> clk_prepare_enable
      -> then fails

Then gswip_gphy_fw_list does this:
	for_each_available_child_of_node(gphy_fw_list_np, gphy_fw_np) {
		err = gswip_gphy_fw_probe(priv, &priv->gphy_fw[i],
					  gphy_fw_np, i);
		if (err)
			goto remove_gphy;
		i++;
	}

	return 0;

remove_gphy:
	for (i = 0; i < priv->num_gphy_fw; i++)
		gswip_gphy_fw_remove(priv, &priv->gphy_fw[i]);


Then gswip_gphy_fw_remove does this:
gswip_gphy_fw_remove
-> clk_disable_unprepare

What's wrong with this?

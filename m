Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABBC44358C
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhKBS3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhKBS3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:29:34 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E46C061714;
        Tue,  2 Nov 2021 11:26:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z20so612779edc.13;
        Tue, 02 Nov 2021 11:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5w8G3ePpRz8HjzM8/nM4qOryTyhiVY12B8UfXPbDks8=;
        b=ChQGfMCB1XRs8WrdGm6DcepGZjTv3OriROgs0wC2aIRyqN27CytNz32sRY4L0NiOcj
         E0Z5WwaaiZ5nUM6TO8evrr4mPeVOz4lrPXjNDnUstPg5zuMeekPpgBB8FEHMAjP4kG7Z
         kxAZKMCuWXWVp3KbpkJ4cYJI/X6mA8enltbKMeZHEBzUBabnAS1ooAwUfAyw981j+aDV
         0zblHf1k3JxksnrL5EtrTe1ids/V8pa6zwfpUDShwpfxTNRzDqKa8RQcxEgYU5J3RkWT
         jQHS3h1xraqNNqYv9PKEjanm+E4UHWlFdxnCA+jVmnFT+7TXkKCcZ3xnCHM1drLywNqk
         RBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5w8G3ePpRz8HjzM8/nM4qOryTyhiVY12B8UfXPbDks8=;
        b=dw0AHS8w0K6drGheUYDlAKYEpJ5zhTlcmAbo0QjjIUuAyNipBs0maLGw1eHyKFMMc8
         /EDnLbww9uaKKolBvZV4IvCiMPjb8ZYK0NnSNYBg6dMb6iAxslN+y7CeSdLOrLl0WqUk
         /VlXE9Tx5uqUZFbOmhz9czP6j0HuUKCwtHSu+X022NRP2/S+g5/2Nrux/8UVasaQaImn
         VDhqHvYWRVQEfkwzur6f2M6dxzuUolfb7KQsoElR4MuWZvYhRWAtTm3loafFxit5gRop
         EXgFNs5niIlNxuA03R+eU3jGMeifG2RfMkLpiVoASKDH9lWC4P+G4E871m+UHMpoaARr
         guIw==
X-Gm-Message-State: AOAM533S7Vd025IrLHh3tx6tygBODtvGOkowDJgA8rcAK4ECj0hsuF/A
        P/SmICDwTa/PwgPW1/t3y9c=
X-Google-Smtp-Source: ABdhPJzCrOMM0l99NEi2g6pj0OxiTt74GAugnIY6HOI0zvarOKDxlfb44oazo6DCGb/I/zPKKp1E6g==
X-Received: by 2002:a17:906:ad9a:: with SMTP id la26mr34255922ejb.266.1635877617778;
        Tue, 02 Nov 2021 11:26:57 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id cs15sm2882759ejc.31.2021.11.02.11.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 11:26:57 -0700 (PDT)
Date:   Tue, 2 Nov 2021 20:26:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: make sure PAD0 MAC06 exchange
 is disabled
Message-ID: <20211102182655.t74adxlw3q3ctlas@skbuf>
References: <20211102175629.24102-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102175629.24102-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 06:56:29PM +0100, Ansuel Smith wrote:
> Some device set MAC06 exchange in the bootloader. This cause some
> problem as we don't support this strange mode and we just set the port6
> as the primary CPU port. With MAC06 exchange, PAD0 reg configure port6
> instead of port0. Add an extra check and explicitly disable MAC06 exchange
> to correctly configure the port PAD config.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Since net-next has closed, please add

Fixes: 3fcf734aa482 ("net: dsa: qca8k: add support for cpu port 6")

and resend to the "net" tree.

>  drivers/net/dsa/qca8k.c | 8 ++++++++
>  drivers/net/dsa/qca8k.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> Some comments here:
> Resetting the switch using the sw reg doesn't reset the port PAD
> configuration. I was thinking if it would be better to clear all the
> pad configuration but considering that the entire reg is set by phylink
> mac config, I think it's not necessary as the PAD related to the port will
> be reset anyway with the new values. Have a dirty configuration on PAD6
> doesn't cause any problem as we have that port disabled and it would be
> reset and configured anyway if defined.
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index ea7f12778922..a429c9750add 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1109,6 +1109,14 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	/* Make sure MAC06 is disabled */
> +	ret = qca8k_reg_clear(priv, QCA8K_REG_PORT0_PAD_CTRL,
> +			      QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
> +	if (ret) {
> +		dev_err(priv->dev, "failed disabling MAC06 exchange");
> +		return ret;
> +	}
> +
>  	/* Enable CPU Port */
>  	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
>  			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index e10571a398c9..128b8cf85e08 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -34,6 +34,7 @@
>  #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
>  #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
>  #define QCA8K_REG_PORT0_PAD_CTRL			0x004
> +#define   QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN		BIT(31)
>  #define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
>  #define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
>  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
> -- 
> 2.32.0
> 

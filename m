Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72AF29DCCE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbgJ1W2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732794AbgJ1WYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:24:13 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17221C0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:24:13 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 184so810964lfd.6
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ni5RtrmRrO0ORtoRT4EUOx3xlARPZZPFkvNIrL6OgE0=;
        b=fvL1/yNaR+l9jgPVgcj0BIj/uZ7eMmSQEV3pz7EGeIYe52mNmCaMEFjR/3gJ9xeuTu
         grXJPOJOqk22epWGu+1nCUwNUtKKh7sMt7rfbjtWr3dE9F9X39Z6m09+PtB96XTGylTh
         GEUn0sBxhVjOrdrOPc9Jc0BuJktIwa12Rt+Y1HJ9f9Jt6syXca924FlIV1WuNfrDlWPX
         mB1qwpisEj0ohKkjekj7/K4e0eKAWRDjiXgq7ChxqGmyxg5H/YRHOB7hy15ferduOS3J
         Ct7X45FCUklr3MH+pqYSZPSg2r5mGQOJFK2n8DDp5jw+kZKfLkkqgr8+qSTmQ3nTQrnt
         9H4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ni5RtrmRrO0ORtoRT4EUOx3xlARPZZPFkvNIrL6OgE0=;
        b=mICtDHJrpFNcMPn7zbqCdsSShWB0hCq7XI5OVTXrEPzdmaH2OWY98pFkGQ2J58gptr
         uWUoKZdwK8N4PqULVYNyBl9aVu/9VDKV8lnPaZUsgpn36Irgn6MXnGfZlpE37/qbsQ+d
         UWeVbuiV4QtobUot3I3nZDCzgno0hrAzW6mMVvn2Pz+hVk+Lef/f4KcxbNsmVRkTg0go
         7RkgT+1FCsDzO7ZRm1ZNQO0zcLE8Cj8NPxEr9aLBzUVQZ5Rcg2wJrEwap/3jcnBKtafm
         UB52ecwN/W0bNfkSzPTGH+r+3BrMqbWIUVnY/bylbSJTsFldjjdnQO5X/x8l3QJwJYVc
         x69A==
X-Gm-Message-State: AOAM5309dmMSvWpLQelxwHhN0h0CQzF3lXDSJyOZ9azkjVL3gnZOTsBZ
        5xRnxroMNYXqtbXjS8DIzkpZStC3Wy0=
X-Google-Smtp-Source: ABdhPJwFtRJpbZfUuAGI3JyOaB2d4J9iwcsFRux3N5Rcaz5C4GWgsXX2SnjoyjIWdLKuyropxZKquw==
X-Received: by 2002:aa7:cd85:: with SMTP id x5mr261959edv.0.1603909893462;
        Wed, 28 Oct 2020 11:31:33 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id v14sm210349ejh.6.2020.10.28.11.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:31:32 -0700 (PDT)
Date:   Wed, 28 Oct 2020 20:31:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
Message-ID: <20201028183131.d4mxlqwl5v2hy2tb@skbuf>
References: <20201028181221.30419-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028181221.30419-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 02:12:21AM +0800, DENG Qingfang wrote:
> MT7530/7531 has a global RX packet length register, which can be used
> to set MTU.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Also, please format your patches with --subject-prefix="PATCH net-next"
in the future. Jakub installed some patchwork scripts that "guess" the
tree based on the commit message, but maybe sometimes they might fail:

https://patchwork.ozlabs.org/project/netdev/patch/e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com/

>  drivers/net/dsa/mt7530.c | 36 ++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/mt7530.h | 12 ++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index de7692b763d8..7764c66a47c9 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1021,6 +1021,40 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	int length;
> +
> +	/* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
> +	 * of the slave ports. Because the switch only has a global RX length register,
> +	 * only allowing CPU port here is enough.
> +	 */

Good point, please tell that to Linus (cc) - I'm talking about
e0b2e0d8e669 ("net: dsa: rtl8366rb: Roof MTU for switch"),

> +	if (!dsa_is_cpu_port(ds, port))
> +		return 0;
> +
> +	/* RX length also includes Ethernet header, MTK tag, and FCS length */
> +	length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
> +	if (length <= 1522)
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1522);
> +	else if (length <= 1536)
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1536);
> +	else if (length <= 1552)
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1552);
> +	else
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_JUMBO_MASK | MAX_RX_PKT_LEN_MASK,
> +			MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024)) | MAX_RX_PKT_LEN_JUMBO);
> +
> +	return 0;
> +}
> +
> +static int
> +mt7530_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return MT7530_MAX_MTU;
> +}
> +
>  static void
>  mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  {
> @@ -2519,6 +2553,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
>  	.get_sset_count		= mt7530_get_sset_count,
>  	.port_enable		= mt7530_port_enable,
>  	.port_disable		= mt7530_port_disable,
> +	.port_change_mtu	= mt7530_port_change_mtu,
> +	.port_max_mtu		= mt7530_port_max_mtu,
>  	.port_stp_state_set	= mt7530_stp_state_set,
>  	.port_bridge_join	= mt7530_port_bridge_join,
>  	.port_bridge_leave	= mt7530_port_bridge_leave,

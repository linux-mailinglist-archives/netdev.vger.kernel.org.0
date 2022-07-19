Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD950578FCA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiGSBST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiGSBSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:18:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922122B278;
        Mon, 18 Jul 2022 18:17:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b26so19474994wrc.2;
        Mon, 18 Jul 2022 18:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qyis9VjhvZ+cwdZeHMSeyxQAUdHKU4k0+2e3ElZLB6U=;
        b=pCInAUPK7vzH46AccJBJ45PfdMGerIGZicQd/EJYY7oRAbatbT4KZBB+vliHcl3q6e
         ZQ6HThJZOeFJkR8IeP/LgNbtniEIOTIYpgJbL4NarvihyNAQYYT7z0vYJmsRAIhJ16Ly
         ua7WaRykbxVmTOsJR9p5pVnU4iZrxL+ZXJMwjIO88KR4JZOHZLHX8ZCVaSmVba9phWOl
         XtklCxads/UbQ/UW7RvfajBcQwnttyLhCfFjnnxEFfM1L+eNaJScJomvlbtNVGQYRO7d
         6mdgR6JYCJLCMWAiLHpKF+KYxkOvtweGP72fGw+QZkVALPPL2koCLpzqnPtMJ2zmK7ML
         Stvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qyis9VjhvZ+cwdZeHMSeyxQAUdHKU4k0+2e3ElZLB6U=;
        b=0KppMvR375dokqk8YfM17bbglO134LTbSsWXawaOL7ZmsKvC8rX1Lt6tvcyUcR28OX
         LBmtwNy2GNuKBXB3zX0HyP3u2gozMvbdBmaQAHIGUdrk8f/umVhll0VCZ5nF4ulr8dRe
         2yylugSAU1NQ/PMHnE/ToFUonJteVm3Y6diWRA7/OqgPLO4kIX63V8tI0HEHBwnC3SL4
         rVxfh6NHQ9enkfu/GXRxd9yY7cUJKiCon4xLft4KcQ6+PBMXEoITpmvGRjkH+DUZfyt/
         Fg64Uug3XoiPUAF+Fxg/y6L5xycRCmMCUif103zztV7MXnHjN4jl7y02teCUFTwASSya
         mx2Q==
X-Gm-Message-State: AJIora8gB7QdODpEK1CAv4W+hFo/OE0KA1t1p2w51+y2O8qZhQq8YUwF
        OyGp9T50AtCPalbSxCeTk7k=
X-Google-Smtp-Source: AGRyM1su3XhjQWU6ukmMFO4CQo4TuUj9a2RM72b1NkQ2XvL2yDBnVMoVB7FpO86S7ulQAhAYiJjZeQ==
X-Received: by 2002:a5d:46c7:0:b0:21e:3c82:2df with SMTP id g7-20020a5d46c7000000b0021e3c8202dfmr215009wrs.519.1658193440662;
        Mon, 18 Jul 2022 18:17:20 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id d15-20020adffbcf000000b0020fff0ea0a3sm12024920wrs.116.2022.07.18.18.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:17:20 -0700 (PDT)
Message-ID: <62d60620.1c69fb81.42957.a752@mx.google.com>
X-Google-Original-Message-ID: <YtYCHZDs2zm9xGOj@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 03:00:13 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 03/15] net: dsa: qca8k: move
 qca8kread/write/rmw and reg table to common code
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-5-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:14AM +0200, Christian Marangi wrote:
> The same reg table and function are used by drivers based on qca8k family
> switch. Move them to common code to make it accessible also by other
> drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k-8xxx.c   | 42 ------------------------------
>  drivers/net/dsa/qca/qca8k-common.c | 39 +++++++++++++++++++++++++++
>  drivers/net/dsa/qca/qca8k.h        |  6 +++++
>  3 files changed, 45 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> index 3f6c1427734d..46c371f5decc 100644
> --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> @@ -133,24 +133,6 @@ qca8k_set_page(struct qca8k_priv *priv, u16 page)
>  	return 0;
>  }
>  
> -static int
> -qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> -{
> -	return regmap_read(priv->regmap, reg, val);
> -}
> -
> -static int
> -qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> -{
> -	return regmap_write(priv->regmap, reg, val);
> -}
> -
> -static int
> -qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> -{
> -	return regmap_update_bits(priv->regmap, reg, mask, write_val);
> -}
> -
>  static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
>  {
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data;
> @@ -483,30 +465,6 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
>  	return ret;
>  }
>  
> -static const struct regmap_range qca8k_readable_ranges[] = {
> -	regmap_reg_range(0x0000, 0x00e4), /* Global control */
> -	regmap_reg_range(0x0100, 0x0168), /* EEE control */
> -	regmap_reg_range(0x0200, 0x0270), /* Parser control */
> -	regmap_reg_range(0x0400, 0x0454), /* ACL */
> -	regmap_reg_range(0x0600, 0x0718), /* Lookup */
> -	regmap_reg_range(0x0800, 0x0b70), /* QM */
> -	regmap_reg_range(0x0c00, 0x0c80), /* PKT */
> -	regmap_reg_range(0x0e00, 0x0e98), /* L3 */
> -	regmap_reg_range(0x1000, 0x10ac), /* MIB - Port0 */
> -	regmap_reg_range(0x1100, 0x11ac), /* MIB - Port1 */
> -	regmap_reg_range(0x1200, 0x12ac), /* MIB - Port2 */
> -	regmap_reg_range(0x1300, 0x13ac), /* MIB - Port3 */
> -	regmap_reg_range(0x1400, 0x14ac), /* MIB - Port4 */
> -	regmap_reg_range(0x1500, 0x15ac), /* MIB - Port5 */
> -	regmap_reg_range(0x1600, 0x16ac), /* MIB - Port6 */
> -
> -};
> -
> -static const struct regmap_access_table qca8k_readable_table = {
> -	.yes_ranges = qca8k_readable_ranges,
> -	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
> -};
> -
>  static struct regmap_config qca8k_regmap_config = {
>  	.reg_bits = 16,
>  	.val_bits = 32,
> diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
> index 7a63e96c8c08..1c2169e98f10 100644
> --- a/drivers/net/dsa/qca/qca8k-common.c
> +++ b/drivers/net/dsa/qca/qca8k-common.c
> @@ -61,3 +61,42 @@ const struct qca8k_mib_desc ar8327_mib[] = {
>  	MIB_DESC(1, 0xa8, "RXUnicast"),
>  	MIB_DESC(1, 0xac, "TXUnicast"),
>  };
> +
> +int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> +{
> +	return regmap_read(priv->regmap, reg, val);
> +}
> +
> +int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> +{
> +	return regmap_write(priv->regmap, reg, val);
> +}
> +
> +int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> +{
> +	return regmap_update_bits(priv->regmap, reg, mask, write_val);
> +}
> +
> +static const struct regmap_range qca8k_readable_ranges[] = {
> +	regmap_reg_range(0x0000, 0x00e4), /* Global control */
> +	regmap_reg_range(0x0100, 0x0168), /* EEE control */
> +	regmap_reg_range(0x0200, 0x0270), /* Parser control */
> +	regmap_reg_range(0x0400, 0x0454), /* ACL */
> +	regmap_reg_range(0x0600, 0x0718), /* Lookup */
> +	regmap_reg_range(0x0800, 0x0b70), /* QM */
> +	regmap_reg_range(0x0c00, 0x0c80), /* PKT */
> +	regmap_reg_range(0x0e00, 0x0e98), /* L3 */
> +	regmap_reg_range(0x1000, 0x10ac), /* MIB - Port0 */
> +	regmap_reg_range(0x1100, 0x11ac), /* MIB - Port1 */
> +	regmap_reg_range(0x1200, 0x12ac), /* MIB - Port2 */
> +	regmap_reg_range(0x1300, 0x13ac), /* MIB - Port3 */
> +	regmap_reg_range(0x1400, 0x14ac), /* MIB - Port4 */
> +	regmap_reg_range(0x1500, 0x15ac), /* MIB - Port5 */
> +	regmap_reg_range(0x1600, 0x16ac), /* MIB - Port6 */
> +
> +};
> +
> +const struct regmap_access_table qca8k_readable_table = {
> +	.yes_ranges = qca8k_readable_ranges,
> +	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
> +};
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index 0c9b60555670..20cceac494eb 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -419,5 +419,11 @@ struct qca8k_fdb {
>  
>  /* Common setup function */
>  extern const struct qca8k_mib_desc ar8327_mib[];
> +extern const struct regmap_access_table qca8k_readable_table;
> +
> +/* Common read/write/rmw function */
> +int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
> +int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
> +int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
>  
>  #endif /* __QCA8K_H */
> -- 
> 2.36.1
> 

This slipped and was sent by mistake (and was just a typo fixed in the
title)

Please ignore. Sorry.

-- 
	Ansuel

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6B579F89
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbiGSNXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbiGSNW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:22:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501469DCA0;
        Tue, 19 Jul 2022 05:38:49 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t3so19436165edd.0;
        Tue, 19 Jul 2022 05:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iXiT+lfTOQjQAlCFzQdbaOj2TJCEbD12+nP+60n4lTk=;
        b=WW0bdeATk3ic5qrerzteEkrHfdgnUum+2vJQ8TQVzNN/ramO0G69cBn8JBWsnjIexl
         bQ33dGPUKuqKHxbqQbqBNut5lUAdlAzW6KB2KPnSZVzKV3YVg/d4GojrYxqmCTF4WrRd
         UEvO/ph2ziDE1eo/Lnp3Yh3J5HkmnRcE0do4mPXviAuxCnF0aovLikAMCuM2c9AL+yPC
         nRTEhJlDnKdo8UM/dN9S8DFsru3ttSRGGC9gZtEuTIZ2zSZgecSsgwdNEavCYKJ+yhdR
         UrHs/qWO9wp2/Bjv8HLJkMr0XdhQFJOmp2sEWjuo3fTrPk5QmzKvaU1gOajkfMjFsQVs
         3OJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iXiT+lfTOQjQAlCFzQdbaOj2TJCEbD12+nP+60n4lTk=;
        b=bm3yivSZgTcjI4OuaoRbZICJvyUmXz7LA8t0CSIuuqaIeokpN4A/a2DqjEnLG28gnM
         P237cmrdaHNPoKoAuEOHbUGtVdgYO9fdfozXiPsSqOW3HuGrVQ2kBMYduG8SsqjSo+c1
         /WrAiYPTOD4zjizHjXHYKIXjjxp+MdkVJTa2Pgo9KXmFGzrYL1djcimprl06MjZyJ5Yp
         6mlwQMUctew0pU+K7kl/ahMvkeyVPlI1nB3z2PMN+M+oJuHF0LypQ6xNGPn1fvoYIMyC
         qU+I3N+eh07pUx3pw6BDFKonaMJmekfW4BcoxDHOKjKFUtX7aZQ9bJ4TYUaum0z3D9we
         WBjA==
X-Gm-Message-State: AJIora9wY5SsoiZq3DOYJP77DvaamYyUs5QVGutRPqvQrJB/i/Oto7U7
        K62Jlfp6MhWIXqRKs4fDjqA=
X-Google-Smtp-Source: AGRyM1sOqo5ovjgteS1AeFV4ys5AZMgXkD0T/pOEM5m0qozb3EmzgQwmm5nUT558zVJqahYvsIorHw==
X-Received: by 2002:aa7:d60a:0:b0:43a:5795:b729 with SMTP id c10-20020aa7d60a000000b0043a5795b729mr43451374edr.230.1658234327338;
        Tue, 19 Jul 2022 05:38:47 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090631c400b0072ee9790894sm5931608ejf.197.2022.07.19.05.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:38:46 -0700 (PDT)
Date:   Tue, 19 Jul 2022 15:38:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 03/15] net: dsa: qca8k: move qca8k
 read/write/rmw and reg table to common code
Message-ID: <20220719123844.ie24cjg2xqg6cugs@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-4-ansuelsmth@gmail.com>
 <20220719005726.8739-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-4-ansuelsmth@gmail.com>
 <20220719005726.8739-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:13AM +0200, Christian Marangi wrote:
> The same reg table and read/write/rmw function are used by drivers
> based on qca8k family switch.
> Move them to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Note for this and future patches: I can't actually double-check what is
indeed common with ipq4019 and what isn't, I'll just review the
correctness of the movement.

In this case

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

with one comment below

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

Please delete the extra newline.

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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DB457A089
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbiGSOHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237926AbiGSOHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:07:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D37D481CE;
        Tue, 19 Jul 2022 06:22:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id fy29so26001325ejc.12;
        Tue, 19 Jul 2022 06:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YPNUgY1kE9wIacZb8+r7xMlbVf/7ZrOa4yRC3+Sdfro=;
        b=GIG0NyyaoN7JpTYLJMOdx6iKXzqtWi1+pXwj//PG98HsWTl3BTTe4ZWgLSsypzaNkv
         mA++RCz8dxJy6dSPDNwB/JUEW3RiAt4VlL0VihN/up9rELiqW/dX0+ZE6Eln9ZuYRfqe
         Q71TLqKGMkdpcS7RizA/hY94r4SyiOeD+Ictkj5SzBnZ5L0bPSP9dir20shJ442HKTzy
         4I8Ise1IRwhgI3vzQw/7mm8zajiO/AdnBwqrqmpRW87ZEZs+vdPCk0nVxIwfW4eDd8fJ
         NrN3LLxlmP5PUDizeuOglqW0ZrU3ENk+xCS4zuxL3nJzsWSOP87x9xLmGOdpJq9C2szU
         J4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YPNUgY1kE9wIacZb8+r7xMlbVf/7ZrOa4yRC3+Sdfro=;
        b=iyyfmd+rO3+a3dTMWLpq229r0Sfzfy5b73qoQesbfunt9g3tVGdxzK+6t4EebTIBHq
         RoQkcd2HzyUv+A6Pxx4m4VvDHNtGVJJnJtvEoDWEPqSTXWZQhtrIC0ofj//PHtZ6nF8Z
         gRswLUE5fKyW5Jqq/YekwZ+tXzE8RrJ+Yvq0WdIJpNV9d+ojdjoqOr7jzrXnVCZCEYjh
         CEWvd6TRHbxxud9pScOtrJXRtn2Gh5OgnUL8bgqlts2PbjRGcvI43tsMgBeXhwApJ90G
         GudC6gRScwwTAMi83cG5TIcjtT1wcEt+xNkTigjdz2M9NapDiY9jl/v8Yt8mJwoJFZsK
         IK6Q==
X-Gm-Message-State: AJIora/4Q0kneB/gUqJ/IfKzwWnGToumgzMn9MFOhA+XnsAkMvtx1K8R
        sDQEC+U2/10q7JsOKjo0FEM=
X-Google-Smtp-Source: AGRyM1skG4/CmEon3bwbiAkvCmKJqaNm/f7wq9KYVvgjS8K+uUgzEVuZULcbYZaZ54ctd77O0txlBA==
X-Received: by 2002:a17:907:7631:b0:72b:3a31:6cb8 with SMTP id jy17-20020a170907763100b0072b3a316cb8mr29687301ejc.372.1658236962742;
        Tue, 19 Jul 2022 06:22:42 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id kb3-20020a1709070f8300b00727c6da69besm6677313ejc.38.2022.07.19.06.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:22:42 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:22:39 +0300
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
Subject: Re: [net-next PATCH v2 08/15] net: dsa: qca8k: move fast
 age/MTU/port enable/disable functions to common code
Message-ID: <20220719132239.ubxzxvkzlbfi7xli@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-10-ansuelsmth@gmail.com>
 <20220719005726.8739-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-10-ansuelsmth@gmail.com>
 <20220719005726.8739-10-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:19AM +0200, Christian Marangi wrote:
> The same fast age, MTU and port enable/disable function are used by
> driver based on qca8k family switch.
> Move them to common code to make them accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> +int
> +qca8k_port_enable(struct dsa_switch *ds, int port,
> +		  struct phy_device *phy)
> +{
> +	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;

I think you can make slight tweaks to the code being moved (and document
them in the commit message). For example, in C, there is no type casting
necessary for void pointers (as evidenced by all other places which seem
to do just fine with "priv = ds->priv").

> +
> +	qca8k_port_set_status(priv, port, 1);
> +	priv->port_enabled_map |= BIT(port);
> +
> +	if (dsa_is_user_port(ds, port))
> +		phy_support_asym_pause(phy);
> +
> +	return 0;
> +}
> +
> +void
> +qca8k_port_disable(struct dsa_switch *ds, int port)
> +{
> +	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> +
> +	qca8k_port_set_status(priv, port, 0);
> +	priv->port_enabled_map &= ~BIT(port);
> +}
> +
> +int
> +qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	int ret;
> +
> +	/* We have only have a general MTU setting.
> +	 * DSA always set the CPU port's MTU to the largest MTU of the slave
> +	 * ports.
> +	 * Setting MTU just for the CPU port is sufficient to correctly set a
> +	 * value for every port.
> +	 */
> +	if (!dsa_is_cpu_port(ds, port))
> +		return 0;
> +
> +	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
> +	 * the switch panics.
> +	 * Turn off both cpu ports before applying the new value to prevent
> +	 * this.
> +	 */
> +	if (priv->port_enabled_map & BIT(0))
> +		qca8k_port_set_status(priv, 0, 0);
> +
> +	if (priv->port_enabled_map & BIT(6))
> +		qca8k_port_set_status(priv, 6, 0);
> +
> +	/* Include L2 header / FCS length */
> +	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
> +
> +	if (priv->port_enabled_map & BIT(0))
> +		qca8k_port_set_status(priv, 0, 1);
> +
> +	if (priv->port_enabled_map & BIT(6))
> +		qca8k_port_set_status(priv, 6, 1);
> +
> +	return ret;
> +}
> +
> +int
> +qca8k_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return QCA8K_MAX_MTU;
> +}
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index dd3072e2f23c..bc9078ae2b70 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -469,4 +469,17 @@ int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
>  void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
>  			     struct dsa_bridge bridge);
>  
> +/* Common fast age function */
> +void qca8k_port_fast_age(struct dsa_switch *ds, int port);
> +int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
> +
> +/* Common port enable/disable function */
> +int qca8k_port_enable(struct dsa_switch *ds, int port,
> +		      struct phy_device *phy);
> +void qca8k_port_disable(struct dsa_switch *ds, int port);
> +
> +/* Common MTU function */
> +int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
> +int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
> +
>  #endif /* __QCA8K_H */
> -- 
> 2.36.1
> 


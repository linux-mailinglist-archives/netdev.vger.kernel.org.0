Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998A44F6E6C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiDFXQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiDFXQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:16:20 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E081719F462
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:14:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bq8so7286898ejb.10
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 16:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IMVQ9I1FDSJfG7xBamQYu9vQ2K9W71jBSbwJdffj0jU=;
        b=Dt+LCTWvtJJ/DJNRQB7O72EimFf4tk2xDGFUIFLSx/fuPFGe+sZHdrdNdvdHCO53tZ
         WNfnp/oT2rTvF9Mgsvwdn2LTazNfet80uldzqqJY1dGM0tKDbwTSZK/+bAtfPX6J4VmA
         id4PVIr0nC7odWGwvnemZwOY8i4ZbHaNpxnkmZZAy0NRPhIeqC+bXa7Djy6cGm/vZpRM
         waKQEzrGzTzxtzRg0GiDqPGLSRE72a7wLzzl7A1yX6Tl6rJXViwCzAJBK5oJkhvjuGFe
         csHWuxVWnSCLTppJ3aVpCneQmvEjxAfFuxB/I/EDa7SRiaU/L4J7APsKLGpgYa/ymZX/
         VdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IMVQ9I1FDSJfG7xBamQYu9vQ2K9W71jBSbwJdffj0jU=;
        b=myYOvO/TffCkzrfb+hrtDBXuOIw5MpcDZc248O6zf5DOtDsMUBTY0aqK3KvXNJArFx
         elxt4IB1kdI5eDQz1NQcgYLnPsgYt5ZKtbtI5oPk6StncfV9DRdaeGa21Y0qzjCdkAo2
         7i3z5HYfgN6HaQr+k/XrKcLtHtE/RUTWzrAImiusKcX3YhtyXwYvdjHtuspEIQ6GK31D
         l0LYw75mqNbZJ41GesppuOPrLk9QpoffOVaG6daT3b9wh24Ivbt4S9/L/rKnyeFyEGvL
         +YgDMwgXs1qoPmiJsyh6Mn3UlrI1QdjjM1FAljboReuq5Jo7hXl4lgIts8YigErIaJuk
         seoA==
X-Gm-Message-State: AOAM530pSIuUSuJvEzZxdgDzrdF34Txp3l7O/QuvJTxcYKzklhi+fPdj
        m45FJI9+UYWrpFYQDoxrTG9IH4tDC7I=
X-Google-Smtp-Source: ABdhPJx1GPi4TzYvoFih0/Q3PkJ+Iozt5tFC85ZACOGfVaZYIit/jxm89VoeBBqJAnKXqE2V8R7WkA==
X-Received: by 2002:a17:906:7955:b0:6e8:a9b:8c7b with SMTP id l21-20020a170906795500b006e80a9b8c7bmr10616685ejo.691.1649286860443;
        Wed, 06 Apr 2022 16:14:20 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id j17-20020a05640211d100b00419357a2647sm8819725edw.25.2022.04.06.16.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:14:19 -0700 (PDT)
Date:   Thu, 7 Apr 2022 02:14:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: Implement tc offloading for
 drop target.
Message-ID: <20220406231418.sx2gybx5tbnp5iet@skbuf>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
 <20220404104826.1902292-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404104826.1902292-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Again, please use an adequate commit prefix. In this case that is
"net: dsa: mv88e6xxx: ".

On Mon, Apr 04, 2022 at 12:48:26PM +0200, Mattias Forsblad wrote:
> Add the ability to handle tc matchall drop HW offloading for Marvell
> switches.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 64f4fdd02902..84e319520d36 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1436,7 +1436,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>  	 * bridge group.
>  	 */
>  	dsa_switch_for_each_port(other_dp, ds)
> -		if (other_dp->type == DSA_PORT_TYPE_CPU ||
> +		if ((other_dp->type == DSA_PORT_TYPE_CPU && dp->bridge->local_rcv_effective) ||

In the light of the idea that we should keep dsa_bridge :: have_foreign
an independent variable, maybe there should be a static inline
dsa_bridge_local_rcv(const struct dsa_bridge *bridge) helper which
returns bridge->have_foreign || bridge->local_rcv. Then you could use
that here.

Also note that said dsa_bridge_local_rcv() function returns a loop
invariant, so you should consider caching the result before using it in
dsa_switch_for_each_port().

>  		    other_dp->type == DSA_PORT_TYPE_DSA ||
>  		    dsa_port_bridge_same(dp, other_dp))
>  			pvlan |= BIT(other_dp->index);
> @@ -6439,6 +6439,26 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
>  	mutex_unlock(&chip->reg_lock);
>  }
>  
> +static int mv88e6xxx_bridge_local_rcv(struct dsa_switch *ds, int port,
> +				      struct dsa_mall_drop_tc_entry *drop)

I think you should ask yourself some questions about passing the "drop"
argument to ->bridge_local_rcv then never using it...

> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct dsa_port *dp;
> +	int err;
> +
> +	dp = dsa_to_port(ds, port);
> +	if (!dp)
> +		return -EINVAL;
> +
> +	mutex_lock(&chip->reg_lock);
> +
> +	err = mv88e6xxx_bridge_map(chip, *dp->bridge);
> +
> +	mutex_unlock(&chip->reg_lock);
> +
> +	return err;
> +}
> +
>  static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  					   struct switchdev_brport_flags flags,
>  					   struct netlink_ext_ack *extack)
> @@ -6837,6 +6857,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.port_mdb_del           = mv88e6xxx_port_mdb_del,
>  	.port_mirror_add	= mv88e6xxx_port_mirror_add,
>  	.port_mirror_del	= mv88e6xxx_port_mirror_del,
> +	.bridge_local_rcv	= mv88e6xxx_bridge_local_rcv,
>  	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
>  	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
>  	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
> -- 
> 2.25.1
> 

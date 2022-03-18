Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC834DD89E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiCRLB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiCRLB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:01:57 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB912D7AB1;
        Fri, 18 Mar 2022 04:00:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b15so9814548edn.4;
        Fri, 18 Mar 2022 04:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vYU8KHDlhc9PWnkQzQUzeEkGlzVKxQ/lB8S8H2nuSmY=;
        b=k51RC3cBs2n8/v1VP9zbgubwk4Hu4+nLkm9BczUwv0aQyj88OnVumTdsacL4VwTbZ1
         n+4NtOVdNJhU+BItDSzIDMzIQlByVykE8U66vH3snu5XDqdcvgXmXQmQQRKf7/9BbICX
         BedKdiKQw2tr5D0eXgFP3M2KS0sBc0Viv33hFkZrycjmF7haREKifosOdSY/Bc36OTMi
         JQavZBk7uwLMR1FStwoCN2xZJaZB760cM3aCcMUW5pjCcoq4WR3FDZpbttpnQHh0lD71
         HU5eawZnGx/7qEKNUP1gand5qdAbHuvns/wRcRH2tlS8Rn9DQUt2tbv2L4hnANKpT80U
         DyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vYU8KHDlhc9PWnkQzQUzeEkGlzVKxQ/lB8S8H2nuSmY=;
        b=yUPKBwtEVj6JuRhqbqV48ZimTr164a9Pe6ZqXuATJ452BFMGcYO9EQ8eWTg+GUFJRw
         dXtrQGq+y6SuzwXWOJRryi5spRGLBfeDsUeNfM7B89N8m/JR+XfM1FhxaP37xl2PBpVp
         W73vZ+KbMwWJ1WYel3wvH52+tGQEp83j7sVyL10K1A5JPwbRP5wMJIT83tHiyeUP00Q6
         AHsWqckyx2acSNxSLHDJiuTu96v2BnT8I6Aq4mCCSvYGn2J7led5M00bJWQWPl1fgzc0
         nlg4jlT1tqYYJEbYrTgEuwGFBrKmtJE3y74qC6J/KoDTNafVRjYNwhiRnxlFuTcFWQXc
         vdRA==
X-Gm-Message-State: AOAM530dEmSInoRYvBnANctWjwtKtdYDnPWab6eyYP47hB7oOtHsPiHR
        fiLhQXU6UrlDA5ZSAcK4aws=
X-Google-Smtp-Source: ABdhPJzA/H9Q6ZuyDNrTOnqFx3nLBWtz3LjrWBNm5LmxAAO/ASdNyR5WFj7pI6SyWgxd0WfSrTFzag==
X-Received: by 2002:a05:6402:d69:b0:418:f7bd:b076 with SMTP id ec41-20020a0564020d6900b00418f7bdb076mr7928379edb.268.1647601236250;
        Fri, 18 Mar 2022 04:00:36 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id g21-20020a056402115500b00413c824e422sm3923863edw.72.2022.03.18.04.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 04:00:35 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:00:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 09/11] net: dsa: microchip: add support for
 port mirror operations
Message-ID: <20220318110033.nuwvrok6ywsagxwf@skbuf>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-10-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-10-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 02:25:38PM +0530, Prasanna Vengateshan wrote:
> Added support for port_mirror_add() and port_mirror_del operations
> 
> Sniffing is limited to one port & alert the user if any new
> sniffing port is selected
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 84 ++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index c54aba6a05b5..5a57a2ce8992 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -98,6 +98,88 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  	ksz_update_port_member(dev, port);
>  }
>  
> +static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
> +				   struct dsa_mall_mirror_tc_entry *mirror,
> +				   bool ingress)

This function gained a new extack argument yesterday => your patch
doesn't compile. Maybe you could even use the extack to propagate the
"existing sniffer port" error.

> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret, p;
> +	u8 data;
> +
> +	/* Limit to one sniffer port
> +	 * Check if any of the port is already set for sniffing
> +	 * If yes, instruct the user to remove the previous entry & exit
> +	 */
> +	for (p = 0; p < dev->port_cnt; p++) {
> +		/* Skip the current sniffing port */
> +		if (p == mirror->to_local_port)
> +			continue;
> +
> +		ret = lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (data & PORT_MIRROR_SNIFFER) {
> +			dev_err(dev->dev,
> +				"Delete existing rules towards %s & try\n",
> +				dsa_to_port(ds, p)->name);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	/* Configure ingress/egress mirroring */
> +	if (ingress)
> +		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
> +				       true);
> +	else
> +		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
> +				       true);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Configure sniffer port as other ports do not have
> +	 * PORT_MIRROR_SNIFFER is set
> +	 */
> +	ret = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
> +			       PORT_MIRROR_SNIFFER, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	return lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
> +}
> +
> +static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
> +				    struct dsa_mall_mirror_tc_entry *mirror)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	bool in_use = false;
> +	u8 data;
> +	int p;
> +
> +	/* clear ingress/egress mirroring port */
> +	if (mirror->ingress)
> +		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
> +				 false);
> +	else
> +		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
> +				 false);
> +
> +	/* Check if any of the port is still referring to sniffer port */
> +	for (p = 0; p < dev->port_cnt; p++) {
> +		lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
> +
> +		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
> +			in_use = true;
> +			break;
> +		}
> +	}
> +
> +	/* delete sniffing if there are no other mirroring rule exist */
> +	if (!in_use)
> +		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
> +				 PORT_MIRROR_SNIFFER, false);
> +}
> +
>  static void lan937x_config_cpu_port(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
> @@ -508,6 +590,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.port_bridge_leave = ksz_port_bridge_leave,
>  	.port_stp_state_set = lan937x_port_stp_state_set,
>  	.port_fast_age = ksz_port_fast_age,
> +	.port_mirror_add = lan937x_port_mirror_add,
> +	.port_mirror_del = lan937x_port_mirror_del,
>  	.port_max_mtu = lan937x_get_max_mtu,
>  	.port_change_mtu = lan937x_change_mtu,
>  	.phylink_get_caps = lan937x_phylink_get_caps,
> -- 
> 2.30.2
> 

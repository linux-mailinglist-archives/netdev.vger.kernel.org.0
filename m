Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A4B39BFF7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFDS6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:58:17 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:46906 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhFDS6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:58:17 -0400
Received: by mail-ej1-f48.google.com with SMTP id b9so15946360ejc.13;
        Fri, 04 Jun 2021 11:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jQxss9W9z+PjwFAYGpiBpTpIBJhFrK6OmD/R3If6Kd4=;
        b=kvG+e8OGp/zQVinembpycC35kPGVgqyc/RkgBMaCXYsOXnNE045Akx+bgm1pf2kiqP
         B/3aRObngGn+YQkHxwrzsb+Ig7h+WrfUUm0CZ51B4lUwUKqeYXF3j2mybBEUmfrD5/Qg
         3DdzHzlssY8POLhI1Ye2Ek29ygJhvWYXifilsr8le7MYVsE0E13B0SkTNqsWs4ptZ/OE
         UzVvqfQh2mK4JC681pynb1goana4SnQUbthtEo+oNMOZsT6XLfy1LzWplnhRTyA1XbRV
         ZLhUcfKpDOjKT02emxjBzmZML5aKHUNXs6hS8N9/hV7tk+IHe6mVlDunSQmNF4f4bxga
         mgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jQxss9W9z+PjwFAYGpiBpTpIBJhFrK6OmD/R3If6Kd4=;
        b=iqDgF28Hu5rmYgtOVpPkQEKhRBP4uqD2bzV/YIXTIOMUCim3Z9z/HKLEld9qebLhjN
         qb1IytmxyZQUYQzRsl7gGpZlthqCHcaBhIGflqvBtdCT4KYwojKYUcLkzbPosTHc2ya/
         ycRW2MufOF6vRdWeHHNX4nX/lNihtlywDHM+S9UDecT2fLlXIO1GZ8PHfdUldsZrVUx9
         JRSQ/0CsIBsWc/UXn0sKkfwW1DZPsRGtiDxOv31+IWJYcpX8sFNqHohDRZz3KkRVVmiT
         DVPDa9Eg2Dd7mawPGUxo0tdUqtNbcTa0QYJtsgIjCT6zuAhbFj4q0VnVqeyqVmavgOlG
         lTLQ==
X-Gm-Message-State: AOAM532CPgt+jfIBJxnRXJTrhYfbb1DbMo3UUYG4CCnACByzAOb/gFMd
        7sTtgoTXr+Lijjq5qzpv2FyJRAwnC34=
X-Google-Smtp-Source: ABdhPJySaUkzR/jA4D0SRCvG3DGYT0zo5BCG43/R3N7S3xTQf9ZxVN1Q+OU33kxraGBs52iD7eW1Nw==
X-Received: by 2002:a17:906:2892:: with SMTP id o18mr5483006ejd.124.1622832913156;
        Fri, 04 Jun 2021 11:55:13 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gx28sm3169204ejc.107.2021.06.04.11.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:55:12 -0700 (PDT)
Date:   Fri, 4 Jun 2021 21:55:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: xrs700x: allow HSR/PRP supervision
 dupes for node_table
Message-ID: <20210604185511.yi5zejpz37rklzfw@skbuf>
References: <20210604162922.76954-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604162922.76954-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 11:29:22AM -0500, George McCollister wrote:
> Add an inbound policy filter which matches the HSR/PRP supervision
> MAC range and forwards to the CPU port without discarding duplicates.
> This is required to correctly populate time_in[A] and time_in[B] in the
> HSR/PRP node_table. Leave the policy disabled by default and
> enable/disable it when joining/leaving hsr.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

What happens if duplicates are discarded for supervision frames and
time_in[A] or time_in[B] is not updated in the node table?

>  drivers/net/dsa/xrs700x/xrs700x.c | 67 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
> index fde6e99274b6..a79066174a77 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x.c
> @@ -79,6 +79,9 @@ static const struct xrs700x_mib xrs700x_mibs[] = {
>  	XRS700X_MIB(XRS_EARLY_DROP_L, "early_drop", tx_dropped),
>  };
>  
> +static const u8 eth_hsrsup_addr[ETH_ALEN] = {
> +	0x01, 0x15, 0x4e, 0x00, 0x01, 0x00};
> +

What if the user sets a different last address byte for supervision frames?

>  static void xrs700x_get_strings(struct dsa_switch *ds, int port,
>  				u32 stringset, u8 *data)
>  {
> @@ -329,6 +332,50 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
>  	return 0;
>  }
>  
> +/* Add an inbound policy filter which matches the HSR/PRP supervision MAC
> + * range and forwards to the CPU port without discarding duplicates.
> + * This is required to correctly populate the HSR/PRP node_table.
> + * Leave the policy disabled, it will be enabled as needed.
> + */
> +static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
> +{
> +	struct xrs700x *priv = ds->priv;
> +	unsigned int val = 0;
> +	int i = 0;
> +	int ret;
> +
> +	/* Compare 40 bits of the destination MAC address. */
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 40 << 2);
> +	if (ret)
> +		return ret;
> +
> +	/* match HSR/PRP supervision destination 01:15:4e:00:01:XX */
> +	for (i = 0; i < sizeof(eth_hsrsup_addr); i += 2) {
> +		ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 1) + i,
> +				   eth_hsrsup_addr[i] |
> +				   (eth_hsrsup_addr[i + 1] << 8));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Mirror HSR/PRP supervision to CPU port */
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_is_cpu_port(ds, i))
> +			val |= BIT(i);
> +	}
> +
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 1), val);
> +	if (ret)
> +		return ret;
> +
> +	/* Allow must be set prevent duplicate discard */
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 1), val);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  static int xrs700x_port_setup(struct dsa_switch *ds, int port)
>  {
>  	bool cpu_port = dsa_is_cpu_port(ds, port);
> @@ -358,6 +405,10 @@ static int xrs700x_port_setup(struct dsa_switch *ds, int port)
>  		ret = xrs700x_port_add_bpdu_ipf(ds, port);
>  		if (ret)
>  			return ret;
> +
> +		ret = xrs700x_port_add_hsrsup_ipf(ds, port);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	return 0;
> @@ -565,6 +616,14 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
>  			    XRS_PORT_FORWARDING);
>  	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
>  
> +	/* Enable inbound policy added by xrs700x_port_add_hsrsup_ipf()
> +	 * which allows HSR/PRP supervision forwarding to the CPU port without
> +	 * discarding duplicates.
> +	 */
> +	regmap_update_bits(priv->regmap,
> +			   XRS_ETH_ADDR_CFG(partner->index, 1), 1, 1);
> +	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 1);
> +
>  	hsr_pair[0] = port;
>  	hsr_pair[1] = partner->index;
>  	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> @@ -611,6 +670,14 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
>  			    XRS_PORT_FORWARDING);
>  	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
>  
> +	/* Disable inbound policy added by xrs700x_port_add_hsrsup_ipf()
> +	 * which allows HSR/PRP supervision forwarding to the CPU port without
> +	 * discarding duplicates.
> +	 */
> +	regmap_update_bits(priv->regmap,
> +			   XRS_ETH_ADDR_CFG(partner->index, 1), 1, 0);
> +	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 0);
> +
>  	hsr_pair[0] = port;
>  	hsr_pair[1] = partner->index;
>  	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> -- 
> 2.11.0
> 

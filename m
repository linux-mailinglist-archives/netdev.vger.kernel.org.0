Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3596368714
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhDVTTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbhDVTTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:19:41 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0EDC06174A;
        Thu, 22 Apr 2021 12:19:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c3so13622853pfo.3;
        Thu, 22 Apr 2021 12:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=38eT4zmx6So0dvrnVuRno8GmYgLrTi3eEBF9zw6nSv4=;
        b=h4ZMMWKToTUIAi/o4m8M+K3JmkeSuKzSTJJX1InSHg+px1GRl/CAZvH3YTfA6Y0h/y
         YR2EJpd76Qn8/MdmvRvLFtMctzEn/0d9kRMJizGtVlzTMyM3xC+GHofWUhXotlz4fUz6
         9Ig9sY33JoxPQGEMOv2cAFJ+i5LfC9h721uDhLcHrBjpI0JGpiMewEwPB9IzInSe5PS3
         KsEJ/Mt+Mi50IVdAHfQUnUmr+CbvHek/y/9e+7sEhLwdWraDGy+reaom58UljMSSSxr4
         8roJMJeAGZVLmPNgz9Ct4L4cyQTWa8mpupGl4o0PH2Och2ZjkLNf8EJ4zU8+O+AC2/2t
         hZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=38eT4zmx6So0dvrnVuRno8GmYgLrTi3eEBF9zw6nSv4=;
        b=DMivsZMYNLgGQGOCduq2tIhyr8vPqG5KL0/jvyBYJwyLyznd6mj+4czHDbT1iQqkC7
         84gliOvmpR2bwS9O2d3AgH9+GGnxAX/IXGwP9kg3VpMQIsHRvJk/G/2vlU+eTZZggm0d
         Nl98LAWoLl4Fk/f/kTnL7wSzRemKIMZ0GxT8dHD+52ni6CrGKQWbWNF5dXF2cqRdm8EN
         d5cuW0MebJWibxdXT2qXxD4ElST06BEhfe+VtSbMRbDKTHb0k7bcXlwte9zPRxmgqCuh
         HhXO2ZLIHfQEbiZctf65U5FlQt4E0X/mL29/AcpqSTcUk03LOOP6cwG2Fvz/aWDvvtMn
         yaDg==
X-Gm-Message-State: AOAM5316pkljBaWPgwf7AhsPpMnUd6vN9f8BKqkKTPQiiK/2+exW8mVN
        d+cKsbPpNvotB2AfYAuTp0A=
X-Google-Smtp-Source: ABdhPJxPzQ33nkd8N3tZMgrWd+CQkaFjCBDlXGTAnTnWQ9qO+F0/EFsBs2WPpKmVwGoRrLdtcrJw4Q==
X-Received: by 2002:aa7:9d81:0:b029:248:c39c:3f26 with SMTP id f1-20020aa79d810000b0290248c39c3f26mr241930pfq.55.1619119145846;
        Thu, 22 Apr 2021 12:19:05 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id h8sm2898642pjt.17.2021.04.22.12.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:19:05 -0700 (PDT)
Date:   Thu, 22 Apr 2021 22:18:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/9] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
Message-ID: <20210422191853.luobzcuqsouubr7d@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-4-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-4-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:12:51PM +0530, Prasanna Vengateshan wrote:
> The Microchip LAN937X switches have a tagging protocol which is
> very similar to KSZ tagging. So that the implementation is added to
> tag_ksz.c and reused common APIs
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  include/net/dsa.h |  2 ++
>  net/dsa/Kconfig   |  4 ++--
>  net/dsa/tag_ksz.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 507082959aa4..98c1ab6dc4dc 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -50,6 +50,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
>  #define DSA_TAG_PROTO_SEVILLE_VALUE		21
>  #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
> +#define DSA_TAG_PROTO_LAN937X_VALUE		23
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -75,6 +76,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_XRS700X		= DSA_TAG_PROTO_XRS700X_VALUE,
>  	DSA_TAG_PROTO_OCELOT_8021Q	= DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
>  	DSA_TAG_PROTO_SEVILLE		= DSA_TAG_PROTO_SEVILLE_VALUE,
> +	DSA_TAG_PROTO_LAN937X		= DSA_TAG_PROTO_LAN937X_VALUE,
>  };
>  
>  struct packet_type;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index cbc2bd643ab2..888eb79a85f2 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -97,10 +97,10 @@ config NET_DSA_TAG_MTK
>  	  Mediatek switches.
>  
>  config NET_DSA_TAG_KSZ
> -	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
> +	tristate "Tag driver for Microchip 8795/937x/9477/9893 families of switches"
>  	help
>  	  Say Y if you want to enable support for tagging frames for the
> -	  Microchip 8795/9477/9893 families of switches.
> +	  Microchip 8795/937x/9477/9893 families of switches.
>  
>  config NET_DSA_TAG_RTL4_A
>  	tristate "Tag driver for Realtek 4 byte protocol A tags"
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 4820dbcedfa2..a67f21bdab8f 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -190,10 +190,68 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
>  DSA_TAG_DRIVER(ksz9893_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
>  
> +/* For xmit, 2 bytes are added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * tag0 : represents tag override, lookup and valid
> + * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
> + *
> + * For rcv, 1 byte is added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * tag0 : zero-based value represents port
> + *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
> + */
> +#define LAN937X_INGRESS_TAG_LEN		2
> +
> +#define LAN937X_TAIL_TAG_OVERRIDE	BIT(11)

I had to look up the datasheet, to see what this is, because "override"
can mean many things, not all of them are desirable.

Port Blocking Override
When set, packets will be sent from the specified port(s) regardless, and any port
blocking (see Port Transmit Enable in Port MSTP State Register) is ignored.

Do you think you can name it LAN937X_TAIL_TAG_BLOCKING_OVERRIDE? I know
it's longer, but it's also more suggestive.

> +#define LAN937X_TAIL_TAG_LOOKUP		BIT(12)
> +#define LAN937X_TAIL_TAG_VALID		BIT(13)
> +#define LAN937X_TAIL_TAG_PORT_MASK	7
> +
> +static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
> +				    struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	__be16 *tag;
> +	u8 *addr;
> +	u16 val;
> +
> +	tag = skb_put(skb, LAN937X_INGRESS_TAG_LEN);

Here we go again.. why is it called INGRESS_TAG_LEN if it is used during
xmit, and only during xmit?

> +	addr = skb_mac_header(skb);

My personal choice would have been:

	const struct ethhdr *hdr = eth_hdr(skb);

	if (is_link_local_ether_addr(hdr->h_dest))

> +
> +	val = BIT(dp->index);
> +
> +	if (is_link_local_ether_addr(addr))
> +		val |= LAN937X_TAIL_TAG_OVERRIDE;
> +
> +	/* Tail tag valid bit - This bit should always be set by the CPU*/
> +	val |= LAN937X_TAIL_TAG_VALID;
> +
> +	*tag = cpu_to_be16(val);
> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops lan937x_netdev_ops = {
> +	.name	= "lan937x",
> +	.proto	= DSA_TAG_PROTO_LAN937X,
> +	.xmit	= lan937x_xmit,
> +	.rcv	= ksz9477_rcv,
> +	.overhead = LAN937X_INGRESS_TAG_LEN,
> +	.tail_tag = true,
> +};
> +
> +DSA_TAG_DRIVER(lan937x_netdev_ops);
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X);
> +
>  static struct dsa_tag_driver *dsa_tag_driver_array[] = {
>  	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
>  	&DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
>  	&DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
> +	&DSA_TAG_DRIVER_NAME(lan937x_netdev_ops),
>  };
>  
>  module_dsa_tag_drivers(dsa_tag_driver_array);
> -- 
> 2.27.0
> 

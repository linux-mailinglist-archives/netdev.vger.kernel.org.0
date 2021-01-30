Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AAD309409
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhA3KGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbhA3Crl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 21:47:41 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE812C0613ED;
        Fri, 29 Jan 2021 18:27:12 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id rv9so15646219ejb.13;
        Fri, 29 Jan 2021 18:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/zIlzJA6cZVoXgDPgMj1ake5C1AcGVFYjCYwFPPevRk=;
        b=mB//xN3arK4JzxactXvQ67BPCjlsQxiJECW6Nq42SKr58btLUU80Zw9H5Bmx7iNdi5
         ijDC6N6t+755D2HZQmMs5FUcwjsVD0rb5OcI7j2K+YQSI3lxXzgGp1w1trhdCwMHB2zV
         1eFL06P8EDSqGnh04CObGf9nAv+F2odVmHftMikvRvDpBY/9xm656g7Rn65bMKnyfm7+
         p9rtu6Ga35jM6Gyj++JB3npdMkRT584ER7jrRg7wt5q+0N2H0lZua2Lqg5bF2CvVz4kG
         KhM/81UymDZ+KcqufWOi/GxNh7r7HlSyA4QIK31kXebjDj1MPLjjiKm8UybXA+HwuuKu
         crag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/zIlzJA6cZVoXgDPgMj1ake5C1AcGVFYjCYwFPPevRk=;
        b=ldLk1OSm2mNgvqHYWMmrnzjlzclnkgE+VQQvs447UJwtfM3z9NkVQT8kpkZJA8LO7I
         q9MUvT28ZI8IeQAzEVbtsMHywwYUmEJeYVFHhZe5y51NhzoyCl4+CcgruUfLIq8CkO0E
         XpAg8vwQlX6oaKqbMipUKjvqdtaim/5UuT4QgTh76tl58SJgl4vIEJaq3jPhXg6+P2pD
         atBrl+koXcctUD9Y+figx2OisjY+tSICcSvHSHDTBidDun6gjPNIMHwcoofrdGSq/tQU
         KLCo7HBZpuVrRraSyJUtyrpzpet2eapCg6xcVuxgsfTTZv+orqeBmUfyrMWvWzHmZcHf
         njDw==
X-Gm-Message-State: AOAM532Lz/doOVhA+R4pgVQNTiQq/awc7FGX4a+oCgjkix1QM/lBz62K
        gAATs/qbVX706PB/r+0ofIY=
X-Google-Smtp-Source: ABdhPJyh9xBOCEhQHB8o3q/clHpYAgl0ckSoG3nSQ7HKv/wTd/QvPiOjK4f2/0w/P1re4Bn0P6Mo1A==
X-Received: by 2002:a17:906:4e47:: with SMTP id g7mr7342227ejw.480.1611973631377;
        Fri, 29 Jan 2021 18:27:11 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j18sm4525508ejv.18.2021.01.29.18.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 18:27:10 -0800 (PST)
Date:   Sat, 30 Jan 2021 04:27:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
Message-ID: <20210130022709.ai5kq7w52gpqrb4n@skbuf>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128064112.372883-3-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:11:06PM +0530, Prasanna Vengateshan wrote:
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 4820dbcedfa2..6fac39c2b7d5 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -190,10 +190,84 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
>  DSA_TAG_DRIVER(ksz9893_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
>  
> +/* For Ingress (Host -> LAN937x), 2 bytes are added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * tag0 : represents tag override, lookup and valid
> + * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
> + *
> + * For Egress (LAN937x -> Host), 1 byte is added before FCS.
> + * ---------------------------------------------------------------------------
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
> + * ---------------------------------------------------------------------------
> + * tag0 : zero-based value represents port
> + *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
> + */

You messed up the comment, right now it's as good as not having it.
The one-hot port encoding is for xmit. The zero-based encoding is for
rcv, not the other way around.

> +#define LAN937X_INGRESS_TAG_LEN		2
> +
> +#define LAN937X_TAIL_TAG_OVERRIDE	BIT(11)
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
> +	/* Tag encoding */

Do we really need this comment and the one with "Tag decoding" from rcv?

> +	tag = skb_put(skb, LAN937X_INGRESS_TAG_LEN);
> +	addr = skb_mac_header(skb);
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
> +static struct sk_buff *lan937x_rcv(struct sk_buff *skb, struct net_device *dev,
> +				   struct packet_type *pt)

You can reuse ksz9477_rcv.

> +{
> +	/* Tag decoding */
> +	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
> +	unsigned int port = tag[0] & LAN937X_TAIL_TAG_PORT_MASK;
> +	unsigned int len = KSZ_EGRESS_TAG_LEN;
> +
> +	/* Extra 4-bytes PTP timestamp */
> +	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
> +		len += KSZ9477_PTP_TAG_LEN;
> +
> +	return ksz_common_rcv(skb, dev, port, len);
> +}
> +
> +static const struct dsa_device_ops lan937x_netdev_ops = {
> +	.name	= "lan937x",
> +	.proto	= DSA_TAG_PROTO_LAN937X,
> +	.xmit	= lan937x_xmit,
> +	.rcv	= lan937x_rcv,
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
> 2.25.1
> 

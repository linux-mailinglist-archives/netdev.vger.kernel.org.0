Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53143D40A1
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 21:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhGWSnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 14:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWSnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 14:43:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E402BC061575;
        Fri, 23 Jul 2021 12:23:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nb11so5249680ejc.4;
        Fri, 23 Jul 2021 12:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0YuNEjQ93aY4JDiXzCp80bBY8qmnqhiZNHxqK7oA1no=;
        b=H5XcXggs0ZR4anlpkduQEe6r8V5VW2C77aCP9AXSeatrqgzQxhmkCqGcyOB316c24k
         1VGzfDMV6QS4k4V1ixs3IGmWrax4K2EI0Mt4pmHxcZ6ChNWRtvU28HEwH7dpzCQyIFzK
         /7jVfTGJUpoNafVtllOd51rQfo4EWMcjulTBXg31WUHofFFA0leg30GSb/ISME8uG3Z2
         DRhQ0217mfOpR+QHt/tiDYq+O4fJSORGLt83PeoVNbL+2tX0bOk1hBsrngqXk9wUZK5D
         u5UbDBXrtYHeCZDVBXrnEb6ibjgiEoxTVm3A1RdwC4ieJhZcKIpM9pwv+2D30hzdJvGn
         3c2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0YuNEjQ93aY4JDiXzCp80bBY8qmnqhiZNHxqK7oA1no=;
        b=G4Fe+6YDgUYEnKMXpuY+J4EfeXldXw4gL9TrzeNSwGx15DHDDVzPSn+sMXfIThZ+1T
         xtMzR+K4h+qL1DorxHG8xBfXn2EDwJ1lz9mACemnntvmylfOjvWwNEJsM7agA29spnvO
         HR5SR1apZ8RThN4dp26VQj+4cZkeQxQ2PX2Ma9vo/42y4E8SMrPUIalED3lPGW8wfJ3h
         bkc5Z+KzTYUeQStsQdIOLICfMwPjHfYrIK+XyoubMjWr/aFcetB6jQvOqgkDs85Hq27C
         5xoZp9zvd04XmlumNpkZ929mSxshDxfEehfEAfoZ4Wpl7tz3qTpXoQ3oVyoB1rfQ2oLw
         jD+A==
X-Gm-Message-State: AOAM532yR0QJqEn+W/NFiSjDm+0UzvCtbTyZpalJIq5ZjrE8Ny2CT16w
        ZvyoAQyX9Rqx08atUqsRHII=
X-Google-Smtp-Source: ABdhPJynTVca3YXsb1eqmVf75pMPhmJEmBzr9Bexg7rEK6fatJhXSZQYLJYoSiMlg541LoK3mUTOgg==
X-Received: by 2002:a17:906:2a8e:: with SMTP id l14mr6040777eje.321.1627068229318;
        Fri, 23 Jul 2021 12:23:49 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id v24sm14617420eds.44.2021.07.23.12.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 12:23:49 -0700 (PDT)
Date:   Fri, 23 Jul 2021 22:23:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 04/10] net: dsa: tag_ksz: add tag handling
 for Microchip LAN937x
Message-ID: <20210723192347.ykgszwjh53phvpcn@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:02PM +0530, Prasanna Vengateshan wrote:
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -187,10 +187,66 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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
> +#define LAN937X_EGRESS_TAG_LEN		2
> +
> +#define LAN937X_TAIL_TAG_BLOCKING_OVERRIDE	BIT(11)
> +#define LAN937X_TAIL_TAG_LOOKUP			BIT(12)
> +#define LAN937X_TAIL_TAG_VALID			BIT(13)
> +#define LAN937X_TAIL_TAG_PORT_MASK		7
> +
> +static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
> +				    struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	const struct ethhdr *hdr = eth_hdr(skb);
> +	__be16 *tag;
> +	u16 val;

There was a recent patch on net.git to fix an issue with DSA master
drivers which set NETIF_F_HW_CSUM in dev->vlan_features, which DSA
inherits.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=37120f23ac8998c250573ea3247ff77426551f69
Until we fix the issue at the DSA layer, could you also apply that fix
here please?

> +
> +	tag = skb_put(skb, LAN937X_EGRESS_TAG_LEN);
> +
> +	val = BIT(dp->index);
> +
> +	if (is_link_local_ether_addr(hdr->h_dest))
> +		val |= LAN937X_TAIL_TAG_BLOCKING_OVERRIDE;
> +
> +	/* Tail tag valid bit - This bit should always be set by the CPU*/
> +	val |= LAN937X_TAIL_TAG_VALID;

Please add an extra space here between "CPU" and the comment ending
delimiter.

> +
> +	*tag = cpu_to_be16(val);

This probably works for the arch you are testing on, but it is better to
avoid unaligned accesses when the skb->len is odd:
https://www.kernel.org/doc/Documentation/unaligned-memory-access.txt

You can use put_unaligned_be16().

> +
> +	return skb;
> +}

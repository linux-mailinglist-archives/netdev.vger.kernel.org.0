Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C12279C61
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgIZUdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:33:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgIZUdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 16:33:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMGsO-00GJSO-JW; Sat, 26 Sep 2020 22:33:00 +0200
Date:   Sat, 26 Sep 2020 22:33:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v3 net-next 06/15] net: dsa: add a generic procedure for
 the flow dissector
Message-ID: <20200926203300.GE3887691@lunn.ch>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
 <20200926193215.1405730-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926193215.1405730-7-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline void dsa_tag_generic_flow_dissect(const struct sk_buff *skb,
> +						__be16 *proto, int *offset)
> +{
> +#if IS_ENABLED(CONFIG_NET_DSA)
> +	const struct dsa_device_ops *ops = skb->dev->dsa_ptr->tag_ops;
> +	int tag_len = ops->overhead;
> +
> +	*offset = tag_len;
> +	*proto = ((__be16 *)skb->data)[(tag_len / 2) - 1];
> +#endif
> +}
> +

Do you actually need the IS_ENABLED()? There is only one caller of
this function, and it is already protected by
IS_ENABLED(CONFIG_NET_DSA). So i don't think it adds anything.

    Andrew

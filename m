Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3E3459C8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCWIej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhCWIeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:34:14 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA7C061574;
        Tue, 23 Mar 2021 01:34:14 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u9so25673855ejj.7;
        Tue, 23 Mar 2021 01:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tmrrCrm7e1zSN6hwhjd5NWevnLXHS1M8CpySj+eKpTU=;
        b=i6IibXJALrk7pV6yxzodjehS744kAzduD3Vb7WZmwSP5Wfjse4HPjNc5vxlEJsc6MC
         ycR7DpDdCrUMM6xYKKheYVCZWwWXs/aNGQQnaT9BYPvN08m5Nm4221WqrA4jumQMmtG2
         Tx3TWL+X9xN5AUhcpHhFoTAOm8Nz4tEnVgWpT3e/tr/bHem8+a+mBXVkecb4FxMO+m+c
         X8I2IwyK113CPOzoFn6FrHjWV+JqcymQjzxVzoEj39XUjew6SGwmT9X6OFDN6LZnj7D+
         pYQRVpN25TE3gEdLy15uTewZ/rQ9UP8uBFtjnxYuvt+yRa4hX9UJ9S89vB1+9MjNeBHS
         YCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tmrrCrm7e1zSN6hwhjd5NWevnLXHS1M8CpySj+eKpTU=;
        b=ePU0Snkscd/gLXPsNhQKrVyAHw52lUBPiuVv9+8livHNH9X7fQAAfGPlN6TLlNbXls
         GDTVzHtb6bRIjUa7/INPhgirov9LjEGYjhdtDLFKdpjYGwRSGmi5/yc/9SRQODvLHdiH
         NQANjKEK+WLS4EuOSrEQxSuZVddQ1nuYtNU7TkJdmk6ncG8bijyJ+bRQx/s0yG+unruB
         OsB1fA1hwT9VsBjooK3xlPpovwA/uVisyXeSSc8JY6dBeC6s9SkpQVTEoNwfHhQBVq8H
         UFQ05GM5HDC5zIwjajLoKZI0rrdsdm5rd6VNOg0gsaChrNSRlu1qRNtyoSoXU/lBT1d+
         6L6A==
X-Gm-Message-State: AOAM533DAr5LYEaARDYBAxA7iOp+LyJ23s/cdgB8HkNUvByelKuaggQC
        M5edAJ38pZdG1VAL0rqU7gwHtBpNnGM=
X-Google-Smtp-Source: ABdhPJwIALEKdLucqLbI6sSOHvuo1BJxTidEiRQ8Q5vk6hRRPsnBiTQnc0JOMtCv6ehQq48kd/ETyA==
X-Received: by 2002:a17:906:3b48:: with SMTP id h8mr3758493ejf.261.1616488453142;
        Tue, 23 Mar 2021 01:34:13 -0700 (PDT)
Received: from BV030612LT ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id q16sm10729363ejd.15.2021.03.23.01.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 01:34:12 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:34:09 +0200
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210323083409.GA1559969@BV030612LT>
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
 <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
 <YFkqYqgwDhV/bBlc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFkqYqgwDhV/bBlc@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 12:38:10AM +0100, Andrew Lunn wrote:
> > +static void owl_emac_set_multicast(struct net_device *netdev, int count)
> > +{
> > +	struct owl_emac_priv *priv = netdev_priv(netdev);
> > +	struct netdev_hw_addr *ha;
> > +	int index = 0;
> > +
> > +	if (count <= 0) {
> > +		priv->mcaddr_list.count = 0;
> > +		return;
> > +	}
> > +
> > +	netdev_for_each_mc_addr(ha, netdev) {
> > +		if (!is_multicast_ether_addr(ha->addr))
> > +			continue;
> 
> Is this possible?

I remember I've seen this in one of the drivers I have studied, but
I'm not really sure it is actually necessary. I added it to be on the
safe side..

> > +
> > +		WARN_ON(index >= OWL_EMAC_MAX_MULTICAST_ADDRS);
> > +		ether_addr_copy(priv->mcaddr_list.addrs[index++], ha->addr);
> > +	}
> > +
> > +	priv->mcaddr_list.count = index;
> > +
> > +	owl_emac_setup_frame_xmit(priv);
> > +}
> > +
> > +static void owl_emac_ndo_set_rx_mode(struct net_device *netdev)
> > +{
> > +	struct owl_emac_priv *priv = netdev_priv(netdev);
> > +	u32 status, val = 0;
> > +	int mcast_count = 0;
> > +
> > +	if (netdev->flags & IFF_PROMISC) {
> > +		val = OWL_EMAC_BIT_MAC_CSR6_PR;
> > +	} else if (netdev->flags & IFF_ALLMULTI) {
> > +		val = OWL_EMAC_BIT_MAC_CSR6_PM;
> > +	} else if (netdev->flags & IFF_MULTICAST) {
> > +		mcast_count = netdev_mc_count(netdev);
> > +
> > +		if (mcast_count > OWL_EMAC_MAX_MULTICAST_ADDRS) {
> > +			val = OWL_EMAC_BIT_MAC_CSR6_PM;
> > +			mcast_count = 0;
> > +		}
> > +	}
> > +
> > +	spin_lock_bh(&priv->lock);
> > +
> > +	/* Temporarily stop DMA TX & RX. */
> > +	status = owl_emac_dma_cmd_stop(priv);
> > +
> > +	/* Update operation modes. */
> > +	owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
> > +			    OWL_EMAC_BIT_MAC_CSR6_PR | OWL_EMAC_BIT_MAC_CSR6_PM,
> > +			    val);
> > +
> > +	/* Restore DMA TX & RX status. */
> > +	owl_emac_dma_cmd_set(priv, status);
> > +
> > +	spin_unlock_bh(&priv->lock);
> > +
> > +	/* Set/reset multicast addr list. */
> > +	owl_emac_set_multicast(netdev, mcast_count);
> > +}
> 
> I think this can be simplified. At least, you had me going around in
> circles a while trying to see if WARN_ON() could be triggered from
> user space.
> 
> If you have more than OWL_EMAC_MAX_MULTICAST_ADDRS MC addresses, you
> go into promisc mode. Can you then skip calling
> owl_emac_set_multicast(), which appears not to do too much useful when
> passed 0?

The main purpose of always calling owl_emac_set_multicast() is to ensure
the size of the mcaddr_list is correctly updated (either set or reset).
This prevents owl_emac_setup_frame_xmit() using obsolete data, when
invoked from different contexts (i.e. MAC address changed).

A conditional call involves splitting the mcaddr_list management logic
(i.e. moving the 'reset' operation from the callee to the caller), which
IMO would make the usage of a separate function less justified.

Thanks,
Cristi

> 
>        Andrew

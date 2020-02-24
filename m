Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF3A169D60
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 06:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgBXFGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 00:06:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgBXFGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 00:06:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D22A152F3D63;
        Sun, 23 Feb 2020 21:06:21 -0800 (PST)
Date:   Sun, 23 Feb 2020 21:06:20 -0800 (PST)
Message-Id: <20200223.210620.497537969860161356.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     rogerq@ti.com, t-kristo@ti.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        peter.ujfalusi@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/9] net: ethernet: ti: introduce am65x/j721e
 gigabit eth subsystem driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200222155752.22021-6-grygorii.strashko@ti.com>
References: <20200222155752.22021-1-grygorii.strashko@ti.com>
        <20200222155752.22021-6-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 21:06:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Sat, 22 Feb 2020 17:57:48 +0200

> +/**
> + * struct am65_cpsw_regdump_hdr - regdump record header
> + *
> + * @module_id: CPSW module ID
> + * @len: CPSW module registers space length in u32
> + */
> +
> +struct am65_cpsw_regdump_hdr {
> +	u32 module_id;
> +	u32 len;
> +} __packed;

I see no reason for this __packed attribute, please remove it.

> +void am65_cpsw_nuss_adjust_link(struct net_device *ndev)
> +{
> +	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +	struct phy_device *phy = port->slave.phy;
> +	u32 mac_control = 0;

Please order the local variables in reverse christmas tree order,
thank you.

> +static void am65_cpsw_nuss_ndo_slave_set_rx_mode(struct net_device *ndev)
> +{
> +	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +	u32 port_mask;
> +	bool promisc;

Likewise.

> +static int am65_cpsw_nuss_rx_push(struct am65_cpsw_common *common,
> +				  struct sk_buff *skb)
> +{
> +	struct cppi5_host_desc_t *desc_rx;
> +	struct am65_cpsw_rx_chn *rx_chn = &common->rx_chns;
> +	struct device *dev = common->dev;
> +	dma_addr_t desc_dma;
> +	dma_addr_t buf_dma;
> +	u32 pkt_len = skb_tailroom(skb);
> +	void *swdata;

Likewsie.

And so on, and so forth, for your entire submission.

Thank you.

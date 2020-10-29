Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0E229DCA5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388652AbgJ2Abm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:31:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgJ2Abk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:31:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXvqm-0043hO-06; Thu, 29 Oct 2020 01:31:32 +0100
Date:   Thu, 29 Oct 2020 01:31:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201029003131.GF933237@lunn.ch>
References: <20201028214012.9712-1-l.stelmach@samsung.com>
 <CGME20201028214016eucas1p19d2049a4edb4461b2424358e206dc59c@eucas1p1.samsung.com>
 <20201028214012.9712-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028214012.9712-4-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void
> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *_p)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	u16 *p = _p;
> +	int offset, i;

You missed a reverse christmass tree fix here.

> +static int comp;
> +static int msg_enable = NETIF_MSG_PROBE |
> +			NETIF_MSG_LINK |
> +			/* NETIF_MSG_TIMER | */
> +			/* NETIF_MSG_IFDOWN | */
> +			/* NETIF_MSG_IFUP | */
> +			NETIF_MSG_RX_ERR |
> +			NETIF_MSG_TX_ERR |
> +			/* NETIF_MSG_TX_QUEUED | */
> +			/* NETIF_MSG_INTR | */
> +			/* NETIF_MSG_TX_DONE | */
> +			/* NETIF_MSG_RX_STATUS | */
> +			/* NETIF_MSG_PKTDATA | */
> +			/* NETIF_MSG_HW | */
> +			/* NETIF_MSG_WOL | */
> +			0;

You should probably delete anything which is commented out.

> +
> +static char *no_regs_list = "80018001,e1918001,8001a001,fc0d0000";
> +unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsigned long) * 8)];
> +
> +module_param(comp, int, 0444);
> +MODULE_PARM_DESC(comp, "0=Non-Compression Mode, 1=Compression Mode");

I think you need to find a different way to configure this. How much
does compression bring you anyway?

> +module_param(msg_enable, int, 0444);
> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");

I know a lot of drivers have msg_enable, but DaveM is generally
against module parameters. So i would remove this.


> +static void ax88796c_set_hw_multicast(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	u16 rx_ctl = RXCR_AB;
> +	int mc_count = netdev_mc_count(ndev);

reverse christmass tree.

> +static struct sk_buff *
> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	struct sk_buff *skb, *tx_skb;
> +	struct tx_pkt_info *info;
> +	struct skb_data *entry;
> +	int headroom;
> +	int tailroom;
> +	u8 need_pages;
> +	u16 tol_len, pkt_len;
> +	u8 padlen, seq_num;
> +	u8 spi_len = ax_local->ax_spi.comp ? 1 : 4;

reverse christmass tree.

> +static int ax88796c_receive(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	struct sk_buff *skb;
> +	struct skb_data *entry;
> +	u16 w_count, pkt_len;
> +	u8 pkt_cnt;

Reverse christmass tree

> +
> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
> +{
> +	u16 isr;
> +	u8 done = 0;
> +	struct net_device *ndev = ax_local->ndev;

...

> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
> +{
> +	struct net_device *ndev = dev_instance;
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);

...

> +static int
> +ax88796c_open(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	int ret;
> +	unsigned long irq_flag = IRQF_SHARED;
> +	int fc = AX_FC_NONE;

...


> +static int ax88796c_probe(struct spi_device *spi)
> +{
> +	struct net_device *ndev;
> +	struct ax88796c_device *ax_local;
> +	char phy_id[MII_BUS_ID_SIZE + 3];
> +	int ret;
> +	u16 temp;

...

The mdio/phy/ethtool code looks O.K. now. I've not really looked at
any of the frame transfer code, so i cannot comment on that.

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC2031613C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhBJIjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:39:46 -0500
Received: from 6.mo179.mail-out.ovh.net ([46.105.56.76]:44202 "EHLO
        6.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhBJIgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:36:40 -0500
X-Greylist: delayed 36310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2021 03:36:40 EST
Received: from player773.ha.ovh.net (unknown [10.110.208.22])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 3B77018C4D6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 08:58:04 +0100 (CET)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player773.ha.ovh.net (Postfix) with ESMTPSA id 85E8E1AFFF6D6;
        Wed, 10 Feb 2021 07:57:51 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-104R00586a19810-fc92-4ea2-a265-0e6f67f37ab4,
                    4D22BEF75CFDE1719A9C318D5396F6FE99F55012) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 194.187.74.233
Subject: Re: [PATCH V3 net-next 2/2] net: broadcom: bcm4908_enet: add BCM4908
 controller driver
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <20210207222632.10981-2-zajec5@gmail.com>
 <20210209230130.4690-1-zajec5@gmail.com>
 <20210209230130.4690-2-zajec5@gmail.com> <YCNHU2g1m4dFahBd@lunn.ch>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <b13c82b5-49fb-533d-dfd6-dcc2f4c9f90d@milecki.pl>
Date:   Wed, 10 Feb 2021 08:57:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YCNHU2g1m4dFahBd@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10523786433230573199
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrheeigdduudehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomheptfgrfhgrlhcuofhilhgvtghkihcuoehrrghfrghlsehmihhlvggtkhhirdhplheqnecuggftrfgrthhtvghrnhepkeekgeefieeuhfdujeefgeektddujeekledvheehfeelfffhfeekjefhfeehuefhnecukfhppedtrddtrddtrddtpdduleegrddukeejrdejgedrvdeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjeefrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprhgrfhgrlhesmhhilhgvtghkihdrphhlpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.2021 03:39, Andrew Lunn wrote:
>> +static inline u32 enet_read(struct bcm4908_enet *enet, u16 offset)
>> +{
>> +	return readl(enet->base + offset);
>> +}
> 
> No inline functions in C files please. Let the compiler decide.

According to the kernel's coding style (coding-style.rst) inline should
*not* be used for 3+ LOC functions in general. According to that, I should
only fix my enet_maskset() which isn't 1 LOC indeed.

If that Documentation is outdated and/or inaccurate, could you propose a
change for it, please? That rule comes from 2006 (a771f2b82aa2), so I
understand it may need updating. We should have that officially documented
though, to avoid per-tree or per-maintainer rules for stuff like this.

Personally I don't have enough compiler knowledge to propose and/or discuss
such stuff. That's why I prefer following Documentation written by smarter
ones ;)


>> +static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
>> +				       struct bcm4908_enet_dma_ring *ring)
>> +{
>> +	int size = ring->length * sizeof(struct bcm4908_enet_dma_ring_bd);
>> +	struct device *dev = enet->dev;
>> +
>> +	ring->cpu_addr = dma_alloc_coherent(dev, size, &ring->dma_addr, GFP_KERNEL);
>> +	if (!ring->cpu_addr)
>> +		return -ENOMEM;
>> +
>> +	if (((uintptr_t)ring->cpu_addr) & (0x40 - 1)) {
>> +		dev_err(dev, "Invalid DMA ring alignment\n");
>> +		goto err_free_buf_descs;
>> +	}
>> +
>> +	ring->slots = kzalloc(ring->length * sizeof(*ring->slots), GFP_KERNEL);
>> +	if (!ring->slots)
>> +		goto err_free_buf_descs;
>> +
>> +	memset(ring->cpu_addr, 0, size);
> 
> It looks like dma_alloc_coherent() will perform a clear. See __dma_alloc_from_coherent()

Thanks!


>> +static void bcm4908_enet_dma_reset(struct bcm4908_enet *enet)
>> +{
>> +	struct bcm4908_enet_dma_ring *rings[] = { &enet->rx_ring, &enet->tx_ring };
>> +	int i;
>> +
>> +	/* Disable the DMA controller and channel */
>> +	for (i = 0; i < ARRAY_SIZE(rings); i++)
>> +		enet_write(enet, rings[i]->cfg_block + ENET_DMA_CH_CFG, 0);
>> +	enet_maskset(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_MASTER_EN, 0);
> 
> Is there a need to wait for any in flight DMA transfers to complete
> before you go further? Or is that what
> bcm4908_enet_dma_rx_ring_disable() is doing?

bcm4908_enet_dma_rx_ring_disable() checks for DMA to "confirm" it got stopped.


>> +
>> +	/* Reset channels state */
>> +	for (i = 0; i < ARRAY_SIZE(rings); i++) {
>> +		struct bcm4908_enet_dma_ring *ring = rings[i];
>> +
>> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_BASE_DESC_PTR, 0);
>> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_STATE_DATA, 0);
>> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_DESC_LEN_STATUS, 0);
>> +		enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_DESC_BASE_BUFPTR, 0);
>> +	}
>> +}
>> +
>> +static void bcm4908_enet_dma_tx_ring_ensable(struct bcm4908_enet *enet,
>> +					     struct bcm4908_enet_dma_ring *ring)
> 
> enable not ensable?

Absolutely :)


>> +static int bcm4908_enet_open(struct net_device *netdev)
>> +{
>> +	struct bcm4908_enet *enet = netdev_priv(netdev);
>> +	struct device *dev = enet->dev;
>> +	int err;
>> +
>> +	err = request_irq(netdev->irq, bcm4908_enet_irq_handler, 0, "enet", enet);
>> +	if (err) {
>> +		dev_err(dev, "Failed to request IRQ %d: %d\n", netdev->irq, err);
>> +		return err;
>> +	}
>> +
>> +	bcm4908_enet_gmac_init(enet);
>> +	bcm4908_enet_dma_reset(enet);
>> +	bcm4908_enet_dma_init(enet);
>> +
>> +	enet_umac_set(enet, UMAC_CMD, CMD_TX_EN | CMD_RX_EN);
>> +
>> +	enet_set(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_MASTER_EN);
>> +	enet_maskset(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_FLOWC_CH1_EN, 0);
>> +	bcm4908_enet_dma_rx_ring_enable(enet, &enet->rx_ring);
>> +
>> +	napi_enable(&enet->napi);
>> +	netif_carrier_on(netdev);
>> +	netif_start_queue(netdev);
>> +
>> +	bcm4908_enet_intrs_ack(enet);
>> +	bcm4908_enet_intrs_on(enet);
>> +
>> +	return 0;
>> +}
> 
> No PHY handling? It would be normal to connect the phy in open.

I believe so, this controller is integrated into SoC and is always connected
to the (internal) switch port. It uses a fixed link.

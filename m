Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176A817CC0E
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 06:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgCGFT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 00:19:27 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:54296 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgCGFT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 00:19:27 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0275JNH9096843;
        Fri, 6 Mar 2020 23:19:23 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583558363;
        bh=AfsS5+hg6Hu+GyG258LSZ5gkANqmTHspUdD/CKID+sI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=uDAYaSeJztSXS26tlDeQ0k7XAdiJFkQk7ygGWj/pucY1pzH0WSe9c2BArCDL0yoS4
         CO/3aP5HCkLobcLOmnrxQCllA8YDQ7i8L4SIPEdXvlr4bVBzX2ZOGGQBRJefc3ubky
         rKpszrT5isLiI9rxPHHVmmhNX1pHY2pr9DQVVTjM=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0275JNDN017485
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Mar 2020 23:19:23 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Mar
 2020 23:19:22 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Mar 2020 23:19:22 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0275JJ8N118512;
        Fri, 6 Mar 2020 23:19:20 -0600
Subject: Re: [PATCH net-next v2 5/9] net: ethernet: ti: introduce am65x/j721e
 gigabit eth subsystem driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
References: <20200306234734.15014-1-grygorii.strashko@ti.com>
 <20200306234734.15014-6-grygorii.strashko@ti.com>
 <20200306172027.18d88fb0@kicinski-fedora-PC1C0HJN>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <76009b01-2f02-41e8-aea2-16dd1cbddd93@ti.com>
Date:   Sat, 7 Mar 2020 07:19:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200306172027.18d88fb0@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for your review.

On 07/03/2020 03:20, Jakub Kicinski wrote:
>> +static void am65_cpsw_get_drvinfo(struct net_device *ndev,
>> +				  struct ethtool_drvinfo *info)
>> +{
>> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>> +
>> +	strlcpy(info->driver, dev_driver_string(common->dev),
>> +		sizeof(info->driver));
>> +	strlcpy(info->version, AM65_CPSW_DRV_VER, sizeof(info->version));
> 
> Please remove the driver version, use of driver versions is being deprecated upstream.

Hm. I can remove it np. But how do I or anybody else can know that it's deprecated

  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
  *	implemented, the @driver and @bus_info fields will be filled in
  *	according to the netdev's parent device.

  * struct ethtool_drvinfo - general driver and device information
..
  * @version: Driver version string; may be an empty string

It seems not marked as deprecated.

> 
>> +	strlcpy(info->bus_info, dev_name(common->dev), sizeof(info->bus_info));
>> +}
> 
>> +static void am65_cpsw_get_channels(struct net_device *ndev,
>> +				   struct ethtool_channels *ch)
>> +{
>> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>> +
>> +	ch->max_combined = 0;
> 
> no need to zero fields

[...]

> 
>> +	psdata = cppi5_hdesc_get_psdata(desc_rx);
>> +	csum_info = psdata[2];
>> +	dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
>> +
>> +	dma_unmap_single(dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
>> +
>> +	k3_udma_desc_pool_free(rx_chn->desc_pool, desc_rx);
>> +
>> +	if (unlikely(!netif_running(skb->dev))) {
> 
> This is strange, does am65_cpsw_nuss_ndo_slave_stop() not stop RX?

Net core will set __LINK_STATE_START = 0 before calling .ndo_stop() and there could some time gap
between clearing __LINK_STATE_START and actually disabling RX.
if NAPI is in progress it will just allow to complete current NAPI cycle by discarding unwanted packets
and without statistic update.


> 
>> +		dev_kfree_skb_any(skb);
>> +		return 0;
>> +	}
>> +
>> +	new_skb = netdev_alloc_skb_ip_align(ndev, AM65_CPSW_MAX_PACKET_SIZE);
>> +	if (new_skb) {
>> +		skb_put(skb, pkt_len);
>> +		skb->protocol = eth_type_trans(skb, ndev);
>> +		am65_cpsw_nuss_rx_csum(skb, csum_info);
>> +		napi_gro_receive(&common->napi_rx, skb);
>> +
>> +		ndev_priv = netdev_priv(ndev);
>> +		stats = this_cpu_ptr(ndev_priv->stats);
>> +
>> +		u64_stats_update_begin(&stats->syncp);
>> +		stats->rx_packets++;
>> +		stats->rx_bytes += pkt_len;
>> +		u64_stats_update_end(&stats->syncp);
>> +		kmemleak_not_leak(new_skb);
>> +	} else {
>> +		ndev->stats.rx_dropped++;
>> +		new_skb = skb;
>> +	}
> 
>> +static int am65_cpsw_nuss_tx_poll(struct napi_struct *napi_tx, int budget)
>> +{
>> +	struct am65_cpsw_tx_chn *tx_chn = am65_cpsw_napi_to_tx_chn(napi_tx);
>> +	int num_tx;
>> +
>> +	num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id,
>> +						 budget);
>> +	if (num_tx < budget) {
> 
> The budget is for RX, you can just complete all TX on a NAPI poll.

Then TX will block RX. Right? this is soft IRQs which are executed one by one.

> 
>> +		napi_complete(napi_tx);
>> +		enable_irq(tx_chn->irq);
>> +	}
>> +
>> +	return num_tx;
>> +}
> 
>> +static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
>> +						 struct net_device *ndev)
>> +{
>> +	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>> +	struct cppi5_host_desc_t *first_desc, *next_desc, *cur_desc;
>> +	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
>> +	struct device *dev = common->dev;
>> +	struct am65_cpsw_tx_chn *tx_chn;
>> +	struct netdev_queue *netif_txq;
>> +	dma_addr_t desc_dma, buf_dma;
>> +	int ret, q_idx, i;
>> +	void **swdata;
>> +	u32 *psdata;
>> +	u32 pkt_len;
>> +
>> +	/* frag list based linkage is not supported for now. */
>> +	if (skb_shinfo(skb)->frag_list) {
>> +		dev_err_ratelimited(dev, "NETIF_F_FRAGLIST not supported\n");
>> +		ret = -EINVAL;
>> +		goto drop_free_skb;
>> +	}
> 
> You don't advertise the feature, there is no need for this check.
> 
>> +	/* padding enabled in hw */
>> +	pkt_len = skb_headlen(skb);
>> +
>> +	q_idx = skb_get_queue_mapping(skb);
>> +	dev_dbg(dev, "%s skb_queue:%d\n", __func__, q_idx);
>> +	q_idx = q_idx % common->tx_ch_num;
> 
> You should never see a packet for ring above your ring count, this
> modulo is unnecessary.
> 
>> +	tx_chn = &common->tx_chns[q_idx];
>> +	netif_txq = netdev_get_tx_queue(ndev, q_idx);
>> +
>> +	/* Map the linear buffer */
>> +	buf_dma = dma_map_single(dev, skb->data, pkt_len,
>> +				 DMA_TO_DEVICE);
>> +	if (unlikely(dma_mapping_error(dev, buf_dma))) {
>> +		dev_err(dev, "Failed to map tx skb buffer\n");
> 
> You probably don't want to print errors when memory gets depleted.
> Counter is enough

Could you please help me understand what is the relation between "memory depletion"
and dma_mapping_error()?

> 
>> +		ret = -EINVAL;
> 
> EINVAL is not a valid netdev_tx_t..

Considering dev_xmit_complete() - this part was always "black magic" to me :(
Will fix.

> 
>> +		ndev->stats.tx_errors++;
>> +		goto drop_stop_q;
> 
> Why stop queue on memory mapping error? What will re-enable it?

it will not. I'm considering it as critical - no recovery.

> 
>> +	}
>> +
>> +	first_desc = k3_udma_desc_pool_alloc(tx_chn->desc_pool);
>> +	if (!first_desc) {
>> +		dev_dbg(dev, "Failed to allocate descriptor\n");
> 
> ret not set

It will return NETDEV_TX_BUSY in this  case - below.

> 
>> +		dma_unmap_single(dev, buf_dma, pkt_len, DMA_TO_DEVICE);
>> +		goto drop_stop_q_busy;
>> +	}
> 

[...]

> 
>> +static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
>> +{
>> +	struct device *dev = common->dev;
>> +	struct am65_cpsw_port *port;
>> +	int i, ret = 0;
>> +
>> +	port = am65_common_get_port(common, 1);
>> +
>> +	for (i = 0; i < common->tx_ch_num; i++) {
>> +		struct am65_cpsw_tx_chn	*tx_chn = &common->tx_chns[i];
>> +
>> +		netif_tx_napi_add(port->ndev, &tx_chn->napi_tx,
>> +				  am65_cpsw_nuss_tx_poll, NAPI_POLL_WEIGHT);
>> +
>> +		ret = devm_request_irq(dev, tx_chn->irq,
>> +				       am65_cpsw_nuss_tx_irq,
>> +				       0, tx_chn->tx_chn_name, tx_chn);
>> +		if (ret) {
>> +			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
>> +				tx_chn->id, tx_chn->irq, ret);
>> +			goto err;
> 
> If this fails half way through the loop is there something that'd call
> netif_tx_napi_del()?

free_netdev()

> 
>> +		}
>> +	}
>> +
>> +err:
>> +	return ret;
>> +}
> 
>> +	/* register devres action here, so dev will be disabled
>> +	 * at right moment. The dev will be enabled in .remove() callback
>> +	 * unconditionally.
>> +	 */
>> +	ret = devm_add_action_or_reset(dev, am65_cpsw_pm_runtime_free, dev);
>> +	if (ret) {
>> +		dev_err(dev, "failed to add pm put reset action %d", ret);
>> +		return ret;
>> +	}
> 
> Could you explain why you need this? Why can't remove disable PM?
> 
> In general looks to me like this driver abuses devm_ infra in ways
> which make it more complex than it needs to be :(

Sry, can't agree here. This allows me to keep release sequence in sane way and get
rid of mostly all goto for fail cases (which are constant source of errors for complex
initialization sequences) by using standard framework.

Regarding PM runtime
  -  many Linux core framework provide devm_ APIs this and other
drivers are happy to use them.
  - but, there is the problem: DD release sequence is

	drv->remove(dev);

	devres_release_all(dev);

and there is no devm_ API for PM runtime. So, if some initialization step is done with devm_ API and
It depends on device to be active - no way to solve it in .remove() callback easily.
For example, devm_of_platform_populate().

With above code I ensure that:

drv->remove(dev);
  |- pm_runtime_get()

devres_release_all(dev);
  |- devm_of_platform_populate_release()
  |- pm_runtime_put()
  |- pm_runtime_disable()


-- 
Best regards,
grygorii

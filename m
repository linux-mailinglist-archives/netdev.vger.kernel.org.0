Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741B050E5E4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiDYQfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiDYQfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:35:42 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20B9DB2D8
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:32:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j8so27660256pll.11
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SU4snmKXWtmqMgmf+YL3GPUxwYJ/zeZEVVxVgsxU6BE=;
        b=DCphld+PNkslqfr0tqpWckkYRCBJBfYn1HxPjNMV1cHZDuajJJl4THSXprXdfBDtQE
         HcKfKXDcbhVLFrF3RSseNXymTVK91tNXvqB0gc3m9b8oVl4g08XpB4HIC9h1dRwf2GZ8
         8QzModH5f1x4WvTDtAJJpax3uYDfRR/l9aTpGzyG+J01RDwOyCAmM+RkuezhIhcwnuvi
         RqnR+2vNVNn+Ksxxw3eff7sW8O/IXbjSuKfSoYrTzNxWPcYAnwzpPxRLVhewJ4KEA1HW
         5dgPgSQUf5VZMxPrkOtFMYY0774IXB1uwyCby7sJbVHS64x+Iya99TRZdI2x/vXvsufe
         +wXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SU4snmKXWtmqMgmf+YL3GPUxwYJ/zeZEVVxVgsxU6BE=;
        b=AbGgH24jXkQpNhnjTZ2BXf0s2C8hH440W3VLAKPRyxhZ77opdNNR92tLal5i2tayT+
         crWyYNd2NdsPf23CRzpqL9ddljvSct2US+EWWHYNHU3x1ycJ2PHQjso6vg5PWRaB24rG
         oXK4SuCbYPPI+oesaZwd+j15FqpoQls4xkaa6PDOzRCAGZJ4HehK7IvMGBo6SF32CNmo
         ed/Tp0ClrTga45hoj8NSBr/6Xif6kqCRXg5vEMSG8/jEn7EdGjUG501b5Wah14ZdFHCi
         tnVVC4L21PW7NTo3FpSR8wrPFyqthDgnvA9WFvXstw1Q87AyjNnjpqFvUkwmOvIoguUW
         L9cQ==
X-Gm-Message-State: AOAM531G8KBk8IoSupSJpqYdHp7Mf2WVABCMNoQ1+Kxj09NvhWfxJM7R
        H6iVn76Q3VlPsJyUKnvHtcAOhg==
X-Google-Smtp-Source: ABdhPJxDv9chIy+dHhAv0Uji/MbNlmLCS9A+a4nNPRo5jf8fX4zUUo491fyAtNCvtcFV4xzQ0BA2Fw==
X-Received: by 2002:a17:902:b586:b0:159:684:c522 with SMTP id a6-20020a170902b58600b001590684c522mr18713198pls.39.1650904357139;
        Mon, 25 Apr 2022 09:32:37 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x36-20020a056a000be400b0050a40b8290dsm11775416pfu.54.2022.04.25.09.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 09:32:36 -0700 (PDT)
Date:   Mon, 25 Apr 2022 09:32:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com, wells.lu@sunplus.com
Subject: Re: [PATCH net-next v9 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <20220425093234.0ab232ff@hermes.local>
In-Reply-To: <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
References: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
        <1650882640-7106-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 18:30:40 +0800
Wells Lu <wellslutw@gmail.com> wrote:

> +
> +int spl2sw_rx_poll(struct napi_struct *napi, int budget)
> +{
> +	struct spl2sw_common *comm = container_of(napi, struct spl2sw_common, rx_napi);
> +	struct spl2sw_mac_desc *desc, *h_desc;
> +	struct net_device_stats *stats;
> +	struct sk_buff *skb, *new_skb;
> +	struct spl2sw_skb_info *sinfo;
> +	int budget_left = budget;
> +	u32 rx_pos, pkg_len;
> +	u32 num, rx_count;
> +	s32 queue;
> +	u32 mask;
> +	int port;
> +	u32 cmd;
> +
> +	/* Process high-priority queue and then low-priority queue. */
> +	for (queue = 0; queue < RX_DESC_QUEUE_NUM; queue++) {
> +		rx_pos = comm->rx_pos[queue];
> +		rx_count = comm->rx_desc_num[queue];
> +
> +		for (num = 0; num < rx_count && budget_left; num++) {
> +			sinfo = comm->rx_skb_info[queue] + rx_pos;
> +			desc = comm->rx_desc[queue] + rx_pos;
> +			cmd = desc->cmd1;
> +
> +			if (cmd & RXD_OWN)
> +				break;
> +
> +			port = FIELD_GET(RXD_PKT_SP, cmd);
> +			if (port < MAX_NETDEV_NUM && comm->ndev[port])
> +				stats = &comm->ndev[port]->stats;
> +			else
> +				goto spl2sw_rx_poll_rec_err;
> +
> +			pkg_len = FIELD_GET(RXD_PKT_LEN, cmd);
> +			if (unlikely((cmd & RXD_ERR_CODE) || pkg_len < ETH_ZLEN + 4)) {
> +				stats->rx_length_errors++;
> +				stats->rx_dropped++;
> +				goto spl2sw_rx_poll_rec_err;
> +			}
> +
> +			dma_unmap_single(&comm->pdev->dev, sinfo->mapping,
> +					 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
> +
> +			skb = sinfo->skb;
> +			skb_put(skb, pkg_len - 4); /* Minus FCS */
> +			skb->ip_summed = CHECKSUM_NONE;
> +			skb->protocol = eth_type_trans(skb, comm->ndev[port]);
> +			netif_receive_skb(skb);
> +
> +			stats->rx_packets++;
> +			stats->rx_bytes += skb->len;
> +
> +			/* Allocate a new skb for receiving. */
> +			new_skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
> +			if (unlikely(!new_skb)) {
> +				desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +					     RXD_EOR : 0;
> +				sinfo->skb = NULL;
> +				sinfo->mapping = 0;
> +				desc->addr1 = 0;
> +				goto spl2sw_rx_poll_alloc_err;
> +			}
> +
> +			sinfo->mapping = dma_map_single(&comm->pdev->dev, new_skb->data,
> +							comm->rx_desc_buff_size,
> +							DMA_FROM_DEVICE);
> +			if (dma_mapping_error(&comm->pdev->dev, sinfo->mapping)) {
> +				dev_kfree_skb_irq(new_skb);
> +				desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +					     RXD_EOR : 0;
> +				sinfo->skb = NULL;
> +				sinfo->mapping = 0;
> +				desc->addr1 = 0;
> +				goto spl2sw_rx_poll_alloc_err;
> +			}
> +
> +			sinfo->skb = new_skb;
> +			desc->addr1 = sinfo->mapping;
> +
> +spl2sw_rx_poll_rec_err:
> +			desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +				     RXD_EOR | comm->rx_desc_buff_size :
> +				     comm->rx_desc_buff_size;
> +
> +			wmb();	/* Set RXD_OWN after other fields are effective. */
> +			desc->cmd1 = RXD_OWN;
> +
> +spl2sw_rx_poll_alloc_err:
> +			/* Move rx_pos to next position */
> +			rx_pos = ((rx_pos + 1) == comm->rx_desc_num[queue]) ? 0 : rx_pos + 1;
> +
> +			budget_left--;
> +
> +			/* If there are packets in high-priority queue,
> +			 * stop processing low-priority queue.
> +			 */
> +			if (queue == 1 && !(h_desc->cmd1 & RXD_OWN))
> +				break;
> +		}
> +
> +		comm->rx_pos[queue] = rx_pos;
> +
> +		/* Save pointer to last rx descriptor of high-priority queue. */
> +		if (queue == 0)
> +			h_desc = comm->rx_desc[queue] + rx_pos;
> +	}
> +
> +	wmb();	/* make sure settings are effective. */
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~MAC_INT_RX;
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +	napi_complete(napi);
> +	return 0;
> +}
> +
> +int spl2sw_tx_poll(struct napi_struct *napi, int budget)
> +{
> +	struct spl2sw_common *comm = container_of(napi, struct spl2sw_common, tx_napi);
> +	struct spl2sw_skb_info *skbinfo;
> +	struct net_device_stats *stats;
> +	int budget_left = budget;
> +	u32 tx_done_pos;
> +	u32 mask;
> +	u32 cmd;
> +	int i;
> +
> +	spin_lock(&comm->tx_lock);
> +
> +	tx_done_pos = comm->tx_done_pos;
> +	while (((tx_done_pos != comm->tx_pos) || (comm->tx_desc_full == 1)) && budget_left) {
> +		cmd = comm->tx_desc[tx_done_pos].cmd1;
> +		if (cmd & TXD_OWN)
> +			break;
> +
> +		skbinfo = &comm->tx_temp_skb_info[tx_done_pos];
> +		if (unlikely(!skbinfo->skb))
> +			goto spl2sw_tx_poll_next;
> +
> +		i = ffs(FIELD_GET(TXD_VLAN, cmd)) - 1;
> +		if (i < MAX_NETDEV_NUM && comm->ndev[i])
> +			stats = &comm->ndev[i]->stats;
> +		else
> +			goto spl2sw_tx_poll_unmap;
> +
> +		if (unlikely(cmd & (TXD_ERR_CODE))) {
> +			stats->tx_errors++;
> +		} else {
> +			stats->tx_packets++;
> +			stats->tx_bytes += skbinfo->len;
> +		}
> +
> +spl2sw_tx_poll_unmap:
> +		dma_unmap_single(&comm->pdev->dev, skbinfo->mapping, skbinfo->len,
> +				 DMA_TO_DEVICE);
> +		skbinfo->mapping = 0;
> +		dev_kfree_skb_irq(skbinfo->skb);
> +		skbinfo->skb = NULL;
> +
> +spl2sw_tx_poll_next:
> +		/* Move tx_done_pos to next position */
> +		tx_done_pos = ((tx_done_pos + 1) == TX_DESC_NUM) ? 0 : tx_done_pos + 1;
> +
> +		if (comm->tx_desc_full == 1)
> +			comm->tx_desc_full = 0;
> +
> +		budget_left--;
> +	}
> +
> +	comm->tx_done_pos = tx_done_pos;
> +	if (!comm->tx_desc_full)
> +		for (i = 0; i < MAX_NETDEV_NUM; i++)
> +			if (comm->ndev[i])
> +				if (netif_queue_stopped(comm->ndev[i]))
> +					netif_wake_queue(comm->ndev[i]);
> +
> +	spin_unlock(&comm->tx_lock);
> +
> +	wmb();			/* make sure settings are effective. */
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~MAC_INT_TX;
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +	napi_complete(napi);
> +	return 0;
> +}

This doesn't look like it is doing NAPI properly.

The driver is supposed to return the amount of packets processed.
If budget is used, it should return budget.

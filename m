Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780CE218E40
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgGHRd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGHRd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:33:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E45AC061A0B;
        Wed,  8 Jul 2020 10:33:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20B5812749957;
        Wed,  8 Jul 2020 10:33:55 -0700 (PDT)
Date:   Wed, 08 Jul 2020 10:33:54 -0700 (PDT)
Message-Id: <20200708.103354.707974548958033107.davem@davemloft.net>
To:     joyce.ooi@intel.com
Cc:     thor.thayer@linux.intel.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dalon.westergreen@linux.intel.com, ley.foon.tan@intel.com,
        chin.liang.see@intel.com, dinh.nguyen@intel.com,
        dalon.westergreen@intel.com
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708072401.169150-10-joyce.ooi@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 10:33:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ooi, Joyce" <joyce.ooi@intel.com>
Date: Wed,  8 Jul 2020 15:24:00 +0800

> +int msgdma_pref_initialize(struct altera_tse_private *priv)
> +{
> +	int i;
> +	struct msgdma_pref_extended_desc *rx_descs;
> +	struct msgdma_pref_extended_desc *tx_descs;
> +	dma_addr_t rx_descsphys;
> +	dma_addr_t tx_descsphys;

Reverse christmas tree please.

> +netdev_tx_t msgdma_pref_tx_buffer(struct altera_tse_private *priv,
> +				  struct tse_buffer *buffer)
> +{
> +	u32 desc_entry = priv->tx_prod % (priv->tx_ring_size * 2);
> +	struct msgdma_pref_extended_desc *tx_descs = priv->pref_txdesc;

Likewise.

> +u32 msgdma_pref_tx_completions(struct altera_tse_private *priv)
> +{
> +	u32 control;
> +	u32 ready = 0;
> +	u32 cons = priv->tx_cons;
> +	u32 desc_ringsize = priv->tx_ring_size * 2;
> +	u32 ringsize = priv->tx_ring_size;
> +	u64 ns = 0;
> +	struct msgdma_pref_extended_desc *cur;
> +	struct tse_buffer *tx_buff;
> +	struct skb_shared_hwtstamps shhwtstamp;
> +	int i;

Likewise.

> +u32 msgdma_pref_rx_status(struct altera_tse_private *priv)
> +{
> +	u32 rxstatus = 0;
> +	u32 pktlength;
> +	u32 pktstatus;
> +	u64 ns = 0;
> +	u32 entry = priv->rx_cons % priv->rx_ring_size;
> +	u32 desc_entry = priv->rx_prod % (priv->rx_ring_size * 2);
> +	struct msgdma_pref_extended_desc *rx_descs = priv->pref_rxdesc;
> +	struct skb_shared_hwtstamps *shhwtstamp = NULL;
> +	struct tse_buffer *rx_buff = priv->rx_ring;

Likewise.

> +	} else if (priv->dmaops &&
> +			   priv->dmaops->altera_dtype ==
> +			   ALTERA_DTYPE_MSGDMA_PREF) {

This is not properly formatted.

On a multi-line conditional, every subsequent line after the first should
align with the first column after the openning parenthesis of the first
line.

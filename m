Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96F46A7A4B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCBELU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBELS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:11:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A7A44A4
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 20:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26F41B811E7
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 04:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE2BC433D2;
        Thu,  2 Mar 2023 04:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677730274;
        bh=S2gJ30uMGN6X4eDYmNI6QvKciFskKb30Nn+Ht+9JRIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j5X81OAgEaTh0gXl2dTcJUJn/0JNXRsSINLTtHyRtf/gVmpoAPKRMtck+CEQw+ymQ
         kVss3iKkx4HHKRVRtazc1/rW9hVZZllKJ7dMVJr2fCR4zb046n5/Lq/rTWmzdjY/Qf
         7P/B9ASzzqLnS7DLJPenOikE36aZkW/bDmDghgb6V7g2qKtPzpVJINsSyuSfPyGCmo
         SbpslvQcmQTTlLnDIeA2TZlyS84XAnpC5LMv3dXScON8U6AQsSG6oB0GR8MQR9tIsK
         pZEdTbQ/EniabouHuEWQkZQ02ZV5vhiZeMVp9M5MVTqUtF37vobfwuEkZJHvhYw288
         bNsEBT0EqT67w==
Date:   Wed, 1 Mar 2023 20:11:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v1 net-next 5/5] net: ena: Advertise
 ETHTOOL_RING_USE_TX_PUSH_BUF_LEN support
Message-ID: <20230301201112.4a076ea4@kernel.org>
In-Reply-To: <20230301180213.1828060-1-shayagr@amazon.com>
References: <20230301175916.1819491-1-shayagr@amazon.com>
        <20230301180213.1828060-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Mar 2023 20:02:13 +0200 Shay Agroskin wrote:
> -static const struct ethtool_ops ena_ethtool_ops = {
> +static struct ethtool_ops ena_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
>  	.get_link_ksettings	= ena_get_link_ksettings,
> @@ -967,8 +967,18 @@ static const struct ethtool_ops ena_ethtool_ops = {
>  	.get_ts_info            = ethtool_op_get_ts_info,
>  };
>  
> -void ena_set_ethtool_ops(struct net_device *netdev)
> +void ena_set_ethtool_ops(struct ena_adapter *adapter)
>  {
> +	struct net_device *netdev = adapter->netdev;
> +
> +	ena_ethtool_ops.supported_ring_params = 0;
> +	if (adapter->ena_dev->tx_mem_queue_type ==
> +	    ENA_ADMIN_PLACEMENT_POLICY_HOST)
> +		goto no_llq_supported;
> +
> +	ena_ethtool_ops.supported_ring_params |= ETHTOOL_RING_USE_TX_PUSH_BUF_LEN;
> +
> +no_llq_supported:
>  	netdev->ethtool_ops = &ena_ethtool_ops;
>  }

Don't update the global structures based on caps of a single device.
The opt-in is to declare that the driver will act on the value, doesn't
necessarily mean that given device can support the feature.
Leave ETHTOOL_RING_USE_TX_PUSH_BUF_LEN always set and error out
appropriately in ena_set_ringparam().

Option #2 is to refactor the supported features into a struct
and add a callback for driver to "fix up" the caps at request time.
But that'd touch a lot of drivers.

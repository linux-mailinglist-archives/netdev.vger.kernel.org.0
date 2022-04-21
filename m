Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78578509E14
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388606AbiDUK5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbiDUK5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:57:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1812B18D;
        Thu, 21 Apr 2022 03:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650538457; x=1682074457;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=GnT4SrJqOLSZlKeeUebougUUm0THwO8n63ba7RH8Fhk=;
  b=LsKONnW53fDCZOBDG9VvwUu1bvni+pPgm5rnE1eD+3LWNs7NQoRX8fpT
   EkN4qkiV7UHrqIU8Py+hEMMeXwNAbDnjMa4XwlEEHjokKvLH3i9SMCQCY
   5IokTgBexKtfZ8PafdhW9gMzZ83IBoAShtmgd0lWg6GXdUsUHfIOt9TF7
   6yejlZ3lNGmbmf0WWVRQJyuHBnOWfTFndySPWnXZw/5bbMft6RXwTdQo1
   /F3ZJEG5vDDqCeDbeBQbioxp1uxHh/IwbcLG8WvBLRNEtERqXwtoV9Sr8
   rZCWC1ksREtXdhWvi6QILhd+B1n7aLBYvoSsqipKpyNx58GELlolw9tTu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="251628398"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="251628398"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 03:54:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="577160429"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 03:54:10 -0700
Date:   Thu, 21 Apr 2022 13:54:08 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 08/13] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <20220407223629.21487-9-ricardo.martinez@linux.intel.com>
Message-ID: <8ae9719c-296-6b8a-5ac8-776afe1a0a2@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-9-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-ID: <7f973260-38d4-46f7-a25b-7eed10268ecf@linux.intel.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> for initialization, ISR, control and event handling of TX/RX flows.
> 
> DPMAIF TX
> Exposes the 'dmpaif_tx_send_skb' function which can be used by the
> network device to transmit packets.
> The uplink data management uses a Descriptor Ring Buffer (DRB).
> First DRB entry is a message type that will be followed by 1 or more
> normal DRB entries. Message type DRB will hold the skb information
> and each normal DRB entry holds a pointer to the skb payload.
> 
> DPMAIF RX
> The downlink buffer management uses Buffer Address Table (BAT) and
> Packet Information Table (PIT) rings.
> The BAT ring holds the address of skb data buffer for the HW to use,
> while the PIT contains metadata about a whole network packet including
> a reference to the BAT entry holding the data buffer address.
> The driver reads the PIT and BAT entries written by the modem, when
> reaching a threshold, the driver will reload the PIT and BAT rings.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> +       if (txq->tx_skb_head.qlen >= txq->tx_list_max_len)
> +               goto report_full_state;
> +
> +       skb_cb = T7XX_SKB_CB(skb);
> +       skb_cb->txq_number = txq_number;
> +       skb_queue_tail(&txq->tx_skb_head, skb);
> +       wake_up(&dpmaif_ctrl->tx_wq);
> +       return 0;
> +
> +report_full_state:
> +       callbacks = dpmaif_ctrl->callbacks;
> +       callbacks->state_notify(dpmaif_ctrl->t7xx_dev, DMPAIF_TXQ_STATE_FULL, txq_number>
> +       return -EBUSY;
> +}

Should this actually report full earlier so that the queue can be stopped 
before NETDEV_TX_BUSY has to be returned (by the callers in 09/13)?
(see Documentation/networking/driver.rst)

> +		/* Wait for active Tx to be doneg */

doneg -> done

> +struct dpmaif_drb {
> +	__le32 header;
> +	union {
> +		struct {
> +			__le32 data_addr_l;
> +			__le32 data_addr_h;
> +			__le32 reserved;
> +		} pd;
> +		struct {
> +			__le32 msg_hdr;
> +			__le32 reserved1;
> +			__le32 reserved2;
> +		} msg;
> +	};
> +};

"reserved" and "reserved2" could be placed outside of the union
as they have the same offset.


-- 
 i.

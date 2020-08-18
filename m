Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145EB2480BA
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgHRIfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:35:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47122 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgHRIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:35:16 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AA0F060056;
        Tue, 18 Aug 2020 08:35:15 +0000 (UTC)
Received: from us4-mdac16-54.ut7.mdlocal (unknown [10.7.66.25])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A85D02009A;
        Tue, 18 Aug 2020 08:35:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2C6FC1C004F;
        Tue, 18 Aug 2020 08:35:15 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A9C01A80071;
        Tue, 18 Aug 2020 08:35:14 +0000 (UTC)
Received: from mh-desktop (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 09:35:09 +0100
Date:   Tue, 18 Aug 2020 09:35:00 +0100
From:   Martin Habets <mhabets@solarflare.com>
To:     Edward Cree <ecree@solarflare.com>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] sfc: check hash is valid before using it
Message-ID: <20200818083500.GA53535@mh-desktop>
Mail-Followup-To: Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <35c28344-605a-009b-70a0-6030cf88ed02@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35c28344-605a-009b-70a0-6030cf88ed02@solarflare.com>
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25610.003
X-TM-AS-Result: No-7.675500-8.000000-10
X-TMASE-MatchedRID: eVEkOcJu0F68rRvefcjeTfZvT2zYoYOwt3aeg7g/usDRLEyE6G4DRCL9
        eYit1Afo5qCOf03KiSYel8kvu+FiwB2k1vtl2oj3bDAXTGoHcQhGI9Mwxz8yaWMunwKby/AXCh5
        FGEJlYgHJ/hRSI+YUuoo243wxl3VEnMA3Sw1wynk/ApMPW/xhXkyQ5fRSh265rMb0wgp4b8Yjh4
        Zo7vvnhT7bK3LC+0qByNXz/w37FzA7SwmRzNKtvm1rAlJKwOBJb1d/zpzApVp2eq8K/F5vepKSC
        /uUhopuSLZYGytM40Dlrcu7pXm7G3aIbEjxkzvhnJ5tL+LbGON5dnPVq3ls7FbPmv09iE64Ahi7
        OfcU2xB9LQinZ4QefKbyPFGTn+O41GcRAJRT6PP3FLeZXNZS4CiM3WUt6LtFegXOITE6QLDW02b
        W1uIycmKPTFQuVDGpsnJbeVHLXswNMprR9M74eFg50sgUqlrR6XPxfjWxelyA0K9hAzuN7nZANG
        zsfWEeeYs2vBuSUrED45ScgFQaL1YoLoHDpo4KD68NliFVGko=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.675500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25610.003
X-MDID: 1597739715-dSkTeX5RpKv5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ed,

On Fri, Aug 14, 2020 at 01:26:22PM +0100, Edward Cree wrote:
> On EF100, the RX hash field in the packet prefix may not be valid (e.g.
>  if the header parse failed), and this is indicated by a one-bit flag
>  elsewhere in the packet prefix.  Only call skb_set_hash() if the
>  RSS_HASH_VALID bit is set.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/ef100_rx.c   | 5 +++++
>  drivers/net/ethernet/sfc/ef100_rx.h   | 1 +
>  drivers/net/ethernet/sfc/efx.h        | 8 ++++++++
>  drivers/net/ethernet/sfc/net_driver.h | 2 ++
>  drivers/net/ethernet/sfc/rx_common.c  | 3 ++-
>  5 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
> index 13ba1a4f66fc..012925e878f4 100644
> --- a/drivers/net/ethernet/sfc/ef100_rx.c
> +++ b/drivers/net/ethernet/sfc/ef100_rx.c
> @@ -31,6 +31,11 @@
>  #define ESF_GZ_RX_PREFIX_NT_OR_INNER_L3_CLASS_WIDTH	\
>  		ESF_GZ_RX_PREFIX_HCLASS_NT_OR_INNER_L3_CLASS_WIDTH
>  
> +bool ef100_rx_buf_hash_valid(const u8 *prefix)
> +{
> +	return PREFIX_FIELD(prefix, RSS_HASH_VALID);
> +}
> +
>  static bool check_fcs(struct efx_channel *channel, u32 *prefix)
>  {
>  	u16 rxclass;
> diff --git a/drivers/net/ethernet/sfc/ef100_rx.h b/drivers/net/ethernet/sfc/ef100_rx.h
> index f2f266863966..fe45b36458d1 100644
> --- a/drivers/net/ethernet/sfc/ef100_rx.h
> +++ b/drivers/net/ethernet/sfc/ef100_rx.h
> @@ -14,6 +14,7 @@
>  
>  #include "net_driver.h"
>  
> +bool ef100_rx_buf_hash_valid(const u8 *prefix);
>  void efx_ef100_ev_rx(struct efx_channel *channel, const efx_qword_t *p_event);
>  void ef100_rx_write(struct efx_rx_queue *rx_queue);
>  void __ef100_rx_packet(struct efx_channel *channel);
> diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
> index a9808e86068d..daf0c00c1242 100644
> --- a/drivers/net/ethernet/sfc/efx.h
> +++ b/drivers/net/ethernet/sfc/efx.h
> @@ -45,6 +45,14 @@ static inline void efx_rx_flush_packet(struct efx_channel *channel)
>  				__ef100_rx_packet, __efx_rx_packet,
>  				channel);
>  }
> +static inline bool efx_rx_buf_hash_valid(struct efx_nic *efx, const u8 *prefix)
> +{
> +	if (efx->type->rx_buf_hash_valid)

For this to take effect you still need to hook up efx->type->rx_buf_hash_valid
in the ef100_nic.c efx_nic_type structs.

Martin

> +		return INDIRECT_CALL_1(efx->type->rx_buf_hash_valid,
> +				       ef100_rx_buf_hash_valid,
> +				       prefix);
> +	return true;
> +}
>  
>  /* Maximum number of TCP segments we support for soft-TSO */
>  #define EFX_TSO_MAX_SEGS	100
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 7bb7ecb480ae..dcb741d8bd11 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1265,6 +1265,7 @@ struct efx_udp_tunnel {
>   * @rx_write: Write RX descriptors and doorbell
>   * @rx_defer_refill: Generate a refill reminder event
>   * @rx_packet: Receive the queued RX buffer on a channel
> + * @rx_buf_hash_valid: Determine whether the RX prefix contains a valid hash
>   * @ev_probe: Allocate resources for event queue
>   * @ev_init: Initialise event queue on the NIC
>   * @ev_fini: Deinitialise event queue on the NIC
> @@ -1409,6 +1410,7 @@ struct efx_nic_type {
>  	void (*rx_write)(struct efx_rx_queue *rx_queue);
>  	void (*rx_defer_refill)(struct efx_rx_queue *rx_queue);
>  	void (*rx_packet)(struct efx_channel *channel);
> +	bool (*rx_buf_hash_valid)(const u8 *prefix);
>  	int (*ev_probe)(struct efx_channel *channel);
>  	int (*ev_init)(struct efx_channel *channel);
>  	void (*ev_fini)(struct efx_channel *channel);
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index fb77c7bbe4af..ef9bca92b0b7 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -525,7 +525,8 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
>  		return;
>  	}
>  
> -	if (efx->net_dev->features & NETIF_F_RXHASH)
> +	if (efx->net_dev->features & NETIF_F_RXHASH &&
> +	    efx_rx_buf_hash_valid(efx, eh))
>  		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
>  			     PKT_HASH_TYPE_L3);
>  	if (csum) {

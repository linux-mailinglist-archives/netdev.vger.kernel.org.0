Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03114DD52A
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbfJRXFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:05:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39030 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfJRXFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:05:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so7765990ljj.6
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uj60F08O78+Mq/A6v9eYnL/gZuludYUbEC9Eimrh3oA=;
        b=rHKJrcS5M4QmN19/6LrPRyT+axPSTb+n+F0vLoIQpfzt8NxV+A65U0P9XGQiHVbJlX
         +AHRhOSfjCSmkU0ebYuV5K0vdGgKlN7uXdx4UT7TxbyrK4Smc5vaCryk1mcfAuRFZLQo
         Qq3puf+GAq8Wx4FHLkM6fVphQUq3l8ajA6dyWqvYQYv5eqUDGTU5n2psjMTqOKHShHff
         No3FscsLo+TWRNyIZkwAnyw/bnoZTRETudFHdxSaMu0kKyl5U7f+pcnF7uLapcF4NzCK
         KuRLaauSmaIty/u+v+G7JwuzbpntQeaDbXk9aVICy95CNK4KXIEGx/pL6LAC4Rxo9LIg
         RlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uj60F08O78+Mq/A6v9eYnL/gZuludYUbEC9Eimrh3oA=;
        b=AS65rqC4eCQKX0MHULGxFZg0B7Jco3j5GPNVAMY0k9Z6Dli1hDuzKQyyV6ZU6EsAy2
         8VP01HkmSKSe5wlrwOTMyOwxpNmIrx286iaDWTNgnZjugxPO6g75PCC93q4yFXVCRGV1
         PT3ynN0v2tHwdQFqwlfHW1DzZjGB2tbnTSCWa3R1n9airwRpYB14Zou/+F2DpjYAM/ib
         HdTEf1IbWup0WVyl7pF6bZq1cu1RLGuDoj2suy42ak6cNXHhMluABisBQBv9cvaVtc8b
         1q+p2IDVXM3HCsTxPv8QjhGPXEbIyN1vsg8wNlY/jrC/XTGF5T7NvvP/D5FrP/NE0ALd
         mkyg==
X-Gm-Message-State: APjAAAXN49ijatQhvJS70Vdi8b6Zl2qx9QKRFGQ9cG7Q4zCdR5vAd8lY
        wvWfyu9Iuku6lEFSxRvqUmaXXYzl87A=
X-Google-Smtp-Source: APXvYqxD7/BVVa1PGU2J5cO4S+GvNqG1CRnEWvhWA+B2+BQ3imjW7JjMychVNCmhAttDCz2ToKp/2g==
X-Received: by 2002:a05:651c:8b:: with SMTP id 11mr7708091ljq.100.1571439914962;
        Fri, 18 Oct 2019 16:05:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c26sm3317081ljj.45.2019.10.18.16.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 16:05:14 -0700 (PDT)
Date:   Fri, 18 Oct 2019 16:05:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Sasha Neftin <sasha.neftin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next v2 4/5] igc: Add Rx checksum support
Message-ID: <20191018160507.025c0918@cakuba.netronome.com>
In-Reply-To: <20191018211340.31885-5-jeffrey.t.kirsher@intel.com>
References: <20191018211340.31885-1-jeffrey.t.kirsher@intel.com>
        <20191018211340.31885-5-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 14:13:39 -0700, Jeff Kirsher wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> Extend the socket buffer field process and add Rx checksum functionality
> Minor: fix indentation with tab instead of spaces.
> 
> Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_defines.h |  5 ++-
>  drivers/net/ethernet/intel/igc/igc_main.c    | 43 ++++++++++++++++++++
>  2 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
> index 03f1aca3f57f..f3788f0b95b4 100644
> --- a/drivers/net/ethernet/intel/igc/igc_defines.h
> +++ b/drivers/net/ethernet/intel/igc/igc_defines.h
> @@ -282,7 +282,10 @@
>  #define IGC_RCTL_BAM		0x00008000 /* broadcast enable */
>  
>  /* Receive Descriptor bit definitions */
> -#define IGC_RXD_STAT_EOP	0x02    /* End of Packet */
> +#define IGC_RXD_STAT_EOP	0x02	/* End of Packet */
> +#define IGC_RXD_STAT_IXSM	0x04	/* Ignore checksum */
> +#define IGC_RXD_STAT_UDPCS	0x10	/* UDP xsum calculated */
> +#define IGC_RXD_STAT_TCPCS	0x20	/* TCP xsum calculated */
>  
>  #define IGC_RXDEXT_STATERR_CE		0x01000000
>  #define IGC_RXDEXT_STATERR_SE		0x02000000
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 7d2f479b57cf..c1aa2762dc87 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -1201,6 +1201,46 @@ static netdev_tx_t igc_xmit_frame(struct sk_buff *skb,
>  	return igc_xmit_frame_ring(skb, igc_tx_queue_mapping(adapter, skb));
>  }
>  
> +static inline void igc_rx_checksum(struct igc_ring *ring,

Sorry about the piecemeal review, but we don't really like static
inlines in C files :(

It's called once it will definitely get inlined.

> +				   union igc_adv_rx_desc *rx_desc,
> +				   struct sk_buff *skb)
> +{
> +	skb_checksum_none_assert(skb);
> +
> +	/* Ignore Checksum bit is set */
> +	if (igc_test_staterr(rx_desc, IGC_RXD_STAT_IXSM))
> +		return;
> +
> +	/* Rx checksum disabled via ethtool */
> +	if (!(ring->netdev->features & NETIF_F_RXCSUM))
> +		return;
> +
> +	/* TCP/UDP checksum error bit is set */
> +	if (igc_test_staterr(rx_desc,
> +			     IGC_RXDEXT_STATERR_TCPE |
> +			     IGC_RXDEXT_STATERR_IPE)) {

consider unlikely() on the error case? not sure the performance matter
that much for IGC, up to you

> +		/* work around errata with sctp packets where the TCPE aka
> +		 * L4E bit is set incorrectly on 64 byte (60 byte w/o crc)
> +		 * packets, (aka let the stack check the crc32c)

Looks like there is a loose comma towards the end there

> +		 */
> +		if (!(skb->len == 60 &&
> +		      test_bit(IGC_RING_FLAG_RX_SCTP_CSUM, &ring->flags))) {
> +			u64_stats_update_begin(&ring->rx_syncp);
> +			ring->rx_stats.csum_err++;
> +			u64_stats_update_end(&ring->rx_syncp);
> +		}
> +		/* let the stack verify checksum errors */
> +		return;
> +	}
> +	/* It must be a TCP or UDP packet with a valid checksum */
> +	if (igc_test_staterr(rx_desc, IGC_RXD_STAT_TCPCS |
> +				      IGC_RXD_STAT_UDPCS))
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +
> +	dev_dbg(ring->dev, "cksum success: bits %08X\n",
> +		le32_to_cpu(rx_desc->wb.upper.status_error));

This could be replaced with a well placed kprobe, but up to you..

> +}
> +
>  static inline void igc_rx_hash(struct igc_ring *ring,
>  			       union igc_adv_rx_desc *rx_desc,
>  			       struct sk_buff *skb)
> @@ -1227,6 +1267,8 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
>  {
>  	igc_rx_hash(rx_ring, rx_desc, skb);
>  
> +	igc_rx_checksum(rx_ring, rx_desc, skb);
> +
>  	skb_record_rx_queue(skb, rx_ring->queue_index);
>  
>  	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
> @@ -4391,6 +4433,7 @@ static int igc_probe(struct pci_dev *pdev,
>  		goto err_sw_init;
>  
>  	/* Add supported features to the features list*/
> +	netdev->features |= NETIF_F_RXCSUM;
>  	netdev->features |= NETIF_F_HW_CSUM;
>  	netdev->features |= NETIF_F_SCTP_CRC;

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0AD7F17
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389137AbfJOSdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:33:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38168 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfJOSda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:33:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id y18so15627919wrn.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7G18Uo2lnUlgoJo0AZSZnxFhXXuayWUPUI1mRK69AXQ=;
        b=KgpDUSawxKAZYZnryCd/829fGSLMqbzBfi8Lcrsh4OIXbtTHWsnxvzM9OY9tpdjZRF
         Jmr4f91ot9pJoRbg5iqpH/d+DI2RkQV8epQJAkwKEKqckKdrvpPBhYbPXUrFmw89YP4D
         Fg4jIw9aNxhb8DwRdLTsCdQk6PO0CNpxLlVLSNdQC46G146xPq2gUOPwLSt6edzPookE
         W7NE+sxhN8ZTVmqFk4B5VXE+L3vGdfP79PEnm3DlaX5GHp6zQoFRFyO8xz4+1qaUttGy
         lLskEa9UZ3YZsGbgpyaSHpLMdxHas8jJHvrUFN3H2jZpth5GIDzohb+0buftjkam/n1p
         sJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7G18Uo2lnUlgoJo0AZSZnxFhXXuayWUPUI1mRK69AXQ=;
        b=JHVetUMZCJtVxKCMs47AZ5CJi91I7X1sr6JCgE211C2DCKXWbptBHd2OAdQ9p4wZoF
         I4rG3OVD/tz+qDz22bZAxjLxULhhGc6i7FdulkAL5JRrVLFZLHnnnedWmAngoLHfX1/W
         YaTl3yKcju5GoaIUKNuIEQfwOdV4IC0cWZzUEv7I666wQUrZfBnOsleJFpIAVauHaTAB
         OIuQzn7jhzpwD+it/lh8OQuTRyGh/nwoxYgySQKM+bsk9laNX3C0d0cfz43pcT41B0om
         peL0gA9twKL/7H/Or6hefytDZHDugU++CiNpJG/o93QnB7LWbFjIm1qOaGE0kL0WkeTG
         Mucg==
X-Gm-Message-State: APjAAAXVMKk+fnu1XMdzd92M29yPAyF36nvbGNVOKaPZeS9bS1+n3szE
        32o9SKQCHhyMOustEvS0SGlrFw2iK+0=
X-Google-Smtp-Source: APXvYqwmeOxruMo0/gLbm2K5P3CC8zW/BCwA1qD6NMCkWukdIx/7aJ48p5J7tnRmPdDt4sg3qjt9aw==
X-Received: by 2002:adf:f547:: with SMTP id j7mr33837456wrp.26.1571164406402;
        Tue, 15 Oct 2019 11:33:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z15sm10728632wrr.19.2019.10.15.11.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 11:33:26 -0700 (PDT)
Date:   Tue, 15 Oct 2019 11:33:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net 2/4] net: aquantia: when cleaning hw cache it
 should be toggled
Message-ID: <20191015113317.6413f912@cakuba.netronome.com>
In-Reply-To: <d89180cd7ddf6981310179108b37a8d15c44c02f.1570787323.git.igor.russkikh@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
        <d89180cd7ddf6981310179108b37a8d15c44c02f.1570787323.git.igor.russkikh@aquantia.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Oct 2019 13:45:20 +0000, Igor Russkikh wrote:
> From HW specification to correctly reset HW caches (this is a required
> workaround when stopping the device), register bit should actually
> be toggled.

Does the bit get set by the driver or HW?

If it gets set by HW there is still a tiny race from reading to
writing.. Perhaps doing two writes -> to 0 and to 1 would be a better
option?  

Just wondering, obviously I don't know your HW :)

> It was previosly always just set. Due to the way driver stops HW this
> never actually caused any issues, but it still may, so cleaning this up.

Hm. So is it a cleanup of fix? Does the way code is written guarantee
it will never cause issues?

> Fixes: 7a1bb49461b1 ("net: aquantia: fix potential IOMMU fault after driver unbind")
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
> ---
>  .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 16 ++++++++++++++--
>  .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 17 +++++++++++++++--
>  .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  7 +++++--
>  .../atlantic/hw_atl/hw_atl_llh_internal.h     | 19 +++++++++++++++++++
>  4 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> index 30f7fc4c97ff..3459fadb7ddd 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> @@ -968,14 +968,26 @@ static int hw_atl_b0_hw_interrupt_moderation_set(struct aq_hw_s *self)
>  
>  static int hw_atl_b0_hw_stop(struct aq_hw_s *self)
>  {
> +	int err;
> +	u32 val;
> +
>  	hw_atl_b0_hw_irq_disable(self, HW_ATL_B0_INT_MASK);
>  
>  	/* Invalidate Descriptor Cache to prevent writing to the cached
>  	 * descriptors and to the data pointer of those descriptors
>  	 */
> -	hw_atl_rdm_rx_dma_desc_cache_init_set(self, 1);
> +	hw_atl_rdm_rx_dma_desc_cache_init_tgl(self);
>  
> -	return aq_hw_err_from_flags(self);
> +	err = aq_hw_err_from_flags(self);
> +
> +	if (err)
> +		goto err_exit;
> +
> +	readx_poll_timeout_atomic(hw_atl_rdm_rx_dma_desc_cache_init_done_get,
> +				  self, val, val == 1, 1000U, 10000U);

It's a little strange to toggle, yet wait for it to be of a specific
value..

> +
> +err_exit:
> +	return err;

Just return err instead of doing this pointless goto. It make the code
harder to follow.

>  }
>  
>  static int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self,
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
> index 1149812ae463..6f340695e6bd 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
> @@ -606,12 +606,25 @@ void hw_atl_rpb_rx_flow_ctl_mode_set(struct aq_hw_s *aq_hw, u32 rx_flow_ctl_mode
>  			    HW_ATL_RPB_RX_FC_MODE_SHIFT, rx_flow_ctl_mode);
>  }
>  
> -void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init)
> +void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw_s *aq_hw)
>  {
> +	u32 val;
> +
> +	val = aq_hw_read_reg_bit(aq_hw, HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_ADR,
> +				 HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_MSK,
> +				 HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_SHIFT);

hw_atl_rdm_rx_dma_desc_cache_init_done_get() ?

>  	aq_hw_write_reg_bit(aq_hw, HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_ADR,
>  			    HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_MSK,
>  			    HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_SHIFT,
> -			    init);
> +			    val ^ 1);
> +}
> +
> +u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw)
> +{
> +	return aq_hw_read_reg_bit(aq_hw, RDM_RX_DMA_DESC_CACHE_INIT_DONE_ADR,
> +				  RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSK,
> +				  RDM_RX_DMA_DESC_CACHE_INIT_DONE_SHIFT);
>  }
>  
>  void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
> index 0c37abbabca5..c3ee278c3747 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
> @@ -313,8 +313,11 @@ void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
>  					    u32 rx_pkt_buff_size_per_tc,
>  					    u32 buffer);
>  
> -/* set rdm rx dma descriptor cache init */
> -void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init);
> +/* toggle rdm rx dma descriptor cache init */
> +void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw_s *aq_hw);
> +
> +/* get rdm rx dma descriptor cache init done */
> +u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw);
>  
>  /* set rx xoff enable (per tc) */
>  void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw, u32 rx_xoff_en_per_tc,
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
> index c3febcdfa92e..35887ad89025 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
> @@ -318,6 +318,25 @@
>  /* default value of bitfield rdm_desc_init_i */
>  #define HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_DEFAULT 0x0
>  
> +/* rdm_desc_init_done_i bitfield definitions
> + * preprocessor definitions for the bitfield rdm_desc_init_done_i.
> + * port="pif_rdm_desc_init_done_i"
> + */
> +
> +/* register address for bitfield rdm_desc_init_done_i */
> +#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_ADR 0x00005a10
> +/* bitmask for bitfield rdm_desc_init_done_i */
> +#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSK 0x00000001U
> +/* inverted bitmask for bitfield rdm_desc_init_done_i */
> +#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSKN 0xfffffffe
> +/* lower bit position of bitfield  rdm_desc_init_done_i */
> +#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_SHIFT 0U
> +/* width of bitfield rdm_desc_init_done_i */
> +#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_WIDTH 1
> +/* default value of bitfield rdm_desc_init_done_i */
> +#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_DEFAULT 0x0
> +
> +

two empty lines here?

>  /* rx int_desc_wrb_en bitfield definitions
>   * preprocessor definitions for the bitfield "int_desc_wrb_en".
>   * port="pif_rdm_int_desc_wrb_en_i"


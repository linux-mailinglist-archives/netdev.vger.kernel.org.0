Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B21A5B1575
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiIHHOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiIHHOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:14:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E89D4BE1
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 00:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662621254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q98kU9J1tw12QX05BWjT6opI5b/MHRmgjnmkurSZ/FQ=;
        b=E3HrpAQNx0GLBylcEQdxEnAmX9ROqt9wEen7vvPW82W4OeZqHgS7NbrvATg10/byTpAJCH
        9FQObhhiuf+UifdXqTGvL9jG3kKgURKBtx0I2r+VtIRWvx51EA1IGw7KMbZbj8eEOFJ0rL
        ZriXexvSCXSAHQLv2abk4e4cb/0r/9I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-632-_uFndMZNNkG7c1KB_87sgA-1; Thu, 08 Sep 2022 03:14:12 -0400
X-MC-Unique: _uFndMZNNkG7c1KB_87sgA-1
Received: by mail-wm1-f72.google.com with SMTP id r10-20020a1c440a000000b003b3309435a9so282549wma.6
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 00:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Q98kU9J1tw12QX05BWjT6opI5b/MHRmgjnmkurSZ/FQ=;
        b=Wa1ZrAjaWV4ZK4GbJuuL5HyANerLCzXVWOmj/hTAKTFEfXk27qXwIHg1GOeVO7d9R7
         hJNbSVGozlSX9PteQzvSKaG/I9g/6c5HRIse8uGac+Lhx0a5HTetpVkfeosVyxO8F5N4
         W/9hz2xD6EHYnoBdco9I3Pt71ra2zomENamB47NbepqQLdQDSLqtsPUS0UDcUmjqH5JI
         nuAFpeS6wRzqEKPrmQJ/HeV1qdYjyao5EdQ88rlFxOlDDDjdoty7qQyjJObKgn37sCce
         9O12vxZaKtbP2cCib+44q7URa3QWhtHkssl2gj9MxcpnBMyvk/HZQapFQO0zc2qIk/pJ
         uuTQ==
X-Gm-Message-State: ACgBeo0L0OL4LgG4Zt4Oa6k+FSZC+7mrgG5Wtj5DCxqnT88e1oTDcUXn
        yDH5TyOtMwcb+3J3q7rTQ2bMbPvLp1nuNuYXwamjQB+cH1vDOcHakr1312AeE5RhFrsr7YM9YZp
        Aq0DOP5AcrjisXKnQ
X-Received: by 2002:a7b:cd14:0:b0:3a5:c5b3:508 with SMTP id f20-20020a7bcd14000000b003a5c5b30508mr1143699wmj.179.1662621251459;
        Thu, 08 Sep 2022 00:14:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5M0b9pxXCskAckbAn8Uh7X+PenALY1oVvKSSAngVKRbWejsiyr+aNAiofULRPKSI85HtyXTw==
X-Received: by 2002:a7b:cd14:0:b0:3a5:c5b3:508 with SMTP id f20-20020a7bcd14000000b003a5c5b30508mr1143682wmj.179.1662621251120;
        Thu, 08 Sep 2022 00:14:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id m123-20020a1ca381000000b003a83fda1dc5sm1632960wme.44.2022.09.08.00.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 00:14:10 -0700 (PDT)
Message-ID: <a9db17fe0b5a77e42afd3554b3bb5fd73153466b.camel@redhat.com>
Subject: Re: [PATCH net-next 01/02] net: ngbe: Initialize sw and reset hw
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     jiawenwu@net-swift.com
Date:   Thu, 08 Sep 2022 09:14:09 +0200
In-Reply-To: <20220905125933.2760-1-mengyuanlou@net-swift.com>
References: <20220905125933.2760-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 20:59 +0800, Mengyuan Lou wrote:
> Initialize ngbe adapter for bus info.
> Initialize ngbe adapter for mac phy oem type.
> Reset ngbe hw status for driver.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  51 ++-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   | 383 ++++++++++++++++
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |  18 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 198 ++++++++
>  .../net/ethernet/wangxun/ngbe/ngbe_osdep.h    |  31 ++
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 432 +++++++++++++++++-
>  7 files changed, 1110 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_osdep.h
> 
> diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
> index 0baf75907496..391c2cbc1bb4 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/Makefile
> +++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
> @@ -6,4 +6,4 @@
>  
>  obj-$(CONFIG_NGBE) += ngbe.o
>  
> -ngbe-objs := ngbe_main.o
> +ngbe-objs := ngbe_main.o ngbe_hw.o
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
> index f5fa6e5238cc..3d100c7ab22e 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
> @@ -4,6 +4,7 @@
>  #ifndef _NGBE_H_
>  #define _NGBE_H_
>  
> +#include "ngbe_osdep.h"
>  #include "ngbe_type.h"
>  
>  #define NGBE_MAX_FDIR_INDICES		7
> @@ -11,14 +12,62 @@
>  #define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
>  #define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
>  
> +/* TX/RX descriptor defines */
> +#define NGBE_DEFAULT_TXD		512 /* default ring size */
> +#define NGBE_DEFAULT_TX_WORK		256
> +#define NGBE_MAX_TXD			8192
> +#define NGBE_MIN_TXD			128
> +
> +#define NGBE_DEFAULT_RXD		512 /* default ring size */
> +#define NGBE_DEFAULT_RX_WORK		256
> +#define NGBE_MAX_RXD			8192
> +#define NGBE_MIN_RXD			128
> +
> +struct ngbe_mac_addr {
> +	u8 addr[ETH_ALEN];
> +	u16 state; /* bitmask */
> +	u8 pools;
> +};
> +
>  /* board specific private data structure */
>  struct ngbe_adapter {
>  	u8 __iomem *io_addr;    /* Mainly for iounmap use */
>  	/* OS defined structs */
>  	struct net_device *netdev;
>  	struct pci_dev *pdev;
> +
> +	/* structs defined in ngbe_hw.h */
> +	struct ngbe_hw hw;
> +
> +	/* Tx fast path data */
> +	int num_tx_queues;
> +	u16 tx_itr_setting;
> +	u16 tx_work_limit;
> +
> +	/* Rx fast path data */
> +	int num_rx_queues;
> +	u16 rx_itr_setting;
> +	u16 rx_work_limit;
> +
> +	struct ngbe_mac_addr *mac_table;
> +
> +	int num_q_vectors;      /* current number of q_vectors for device */
> +	int max_q_vectors;      /* upper limit of q_vectors for device */
> +
> +	u32 tx_ring_count;
> +	u32 rx_ring_count;
> +
> +#define NGBE_MAX_RETA_ENTRIES 128
> +	u8 rss_indir_tbl[NGBE_MAX_RETA_ENTRIES];
> +
> +#define NGBE_RSS_KEY_SIZE     40  /* size of RSS Hash Key in bytes */
> +	u32 *rss_key;
> +
> +	char eeprom_id[32];
> +	u16 eeprom_cap;
> +	u16 bd_number;
> +	u32 wol;
>  };
>  
>  extern char ngbe_driver_name[];
> -
>  #endif /* _NGBE_H_ */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> new file mode 100644
> index 000000000000..20c21f99e308
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> @@ -0,0 +1,383 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
> +
> +#include <linux/iopoll.h>
> +
> +#include "ngbe.h"
> +#include "ngbe_hw.h"
> +
> +u32 rd32m(struct ngbe_hw *hw, u32 reg, u32 mask)
> +{
> +	u32 val;
> +
> +	val = rd32(hw, reg);
> +	return val & mask;
> +}
> +
> +void wr32m(struct ngbe_hw *hw, u32 reg, u32 mask, u32 field)
> +{
> +	u32 val;
> +
> +	val = rd32(hw, reg);
> +	val = ((val & ~mask) | (field & mask));
> +	wr32(hw, reg, val);
> +}
> +
> +/**
> + * ngbe_hw_to_dev - Get device pointer from the hardware structure
> + * @hw: pointer to the device HW structure
> + *
> + * Used to access the device pointer
> + */
> +struct device *ngbe_hw_to_dev(struct ngbe_hw *hw)
> +{
> +	struct ngbe_adapter *adapter = container_of(hw, struct ngbe_adapter, hw);
> +
> +	return &adapter->pdev->dev;
> +}
> +
> +/**
> + *  ngbe_init_uta_tables - Initialize the Unicast Table Array
> + *  @hw: pointer to hardware structure
> + **/
> +static void ngbe_init_uta_tables(struct ngbe_hw *hw)
> +{
> +	int i;
> +
> +	for (i = 0; i < 128; i++)
> +		wr32(hw, NGBE_PSR_UC_TBL(i), 0);
> +}
> +
> +/**
> + *  ngbe_get_mac_addr - Generic get MAC address
> + *  @hw: pointer to hardware structure
> + *  @mac_addr: Adapter MAC address
> + *
> + *  Reads the adapter's MAC address from first Receive Address Register (RAR0)
> + *  A reset of the adapter must be performed prior to calling this function
> + *  in order for the MAC address to have been loaded from the EEPROM into RAR0
> + **/
> +static void ngbe_get_mac_addr(struct ngbe_hw *hw, u8 *mac_addr)
> +{
> +	u32 rar_high;
> +	u32 rar_low;
> +	u16 i;
> +
> +	wr32(hw, NGBE_PSR_MAC_SWC_IDX, 0);
> +	rar_high = rd32(hw, NGBE_PSR_MAC_SWC_AD_H);
> +	rar_low = rd32(hw, NGBE_PSR_MAC_SWC_AD_L);
> +
> +	for (i = 0; i < 2; i++)
> +		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
> +
> +	for (i = 0; i < 4; i++)
> +		mac_addr[i + 2] = (u8)(rar_low >> (3 - i) * 8);
> +}
> +
> +/**
> + *  ngbe_validate_mac_addr - Validate MAC address
> + *  @mac_addr: pointer to MAC address.
> + *
> + *  Tests a MAC address to ensure it is a valid Individual Address
> + **/
> +static int ngbe_validate_mac_addr(u8 *mac_addr)
> +{
> +	/* Make sure it is not a multicast address */
> +	if (is_multicast_ether_addr(mac_addr))
> +		return -EINVAL;
> +	/* Not a broadcast address */
> +	else if (is_broadcast_ether_addr(mac_addr))
> +		return -EINVAL;
> +	/* Reject the zero address */
> +	else if (is_zero_ether_addr(mac_addr))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/**
> + *  ngbe_set_rar - Set Rx address register
> + *  @hw: pointer to hardware structure
> + *  @index: Receive address register to write
> + *  @addr: Address to put into receive address register
> + *  @pools: "pool" index
> + *  @enable_addr: set flag that address is active
> + *
> + *  Puts an ethernet address into a receive address register.
> + **/
> +static int ngbe_set_rar(struct ngbe_hw *hw, u32 index, u8 *addr, u64 pools,
> +			u32 enable_addr)
> +{
> +	u32 rar_low, rar_high;
> +	u32 rar_entries = hw->mac.num_rar_entries;
> +
> +	/* Make sure we are using a valid rar index range */
> +	if (index >= rar_entries) {
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"RAR index %d is out of range.\n", index);
> +		return -EINVAL;
> +	}
> +
> +	/* select the MAC address */
> +	wr32(hw, NGBE_PSR_MAC_SWC_IDX, index);
> +
> +	/* setup VMDq pool mapping */
> +	wr32(hw, NGBE_PSR_MAC_SWC_VM, pools & 0xFFFFFFFF);
> +
> +	/* HW expects these in little endian so we reverse the byte
> +	 * order from network order (big endian) to little endian
> +	 */
> +	rar_low = ((u32)addr[5] |
> +		  ((u32)addr[4] << 8) |
> +		  ((u32)addr[3] << 16) |
> +		  ((u32)addr[2] << 24));
> +	rar_high = ((u32)addr[1] |
> +		   ((u32)addr[0] << 8));
> +	if (enable_addr != 0)
> +		rar_high |= NGBE_PSR_MAC_SWC_AD_H_AV;
> +
> +	wr32(hw, NGBE_PSR_MAC_SWC_AD_L, rar_low);
> +	wr32m(hw, NGBE_PSR_MAC_SWC_AD_H,
> +	      (NGBE_PSR_MAC_SWC_AD_H_AD(~0) |
> +	      NGBE_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
> +	      NGBE_PSR_MAC_SWC_AD_H_AV), rar_high);
> +
> +	return 0;
> +}
> +
> +/**
> + *  ngbe_init_rx_addrs - Initializes receive address filters.
> + *  @hw: pointer to hardware structure
> + *
> + *  Places the MAC address in receive address register 0 and clears the rest
> + *  of the receive address registers. Clears the multicast table. Assumes
> + *  the receiver is in reset when the routine is called.
> + **/
> +static void ngbe_init_rx_addrs(struct ngbe_hw *hw)
> +{
> +	u32 i;
> +	u32 rar_entries = hw->mac.num_rar_entries;
> +	u32 psrctl;
> +
> +	/* If the current mac address is valid, assume it is a software override
> +	 * to the permanent address.
> +	 * Otherwise, use the permanent address from the eeprom.
> +	 */
> +	if (ngbe_validate_mac_addr(hw->mac.addr) < 0) {
> +		/* Get the MAC address from the RAR0 for later reference */
> +		ngbe_get_mac_addr(hw, hw->mac.addr);
> +		dev_dbg(ngbe_hw_to_dev(hw),
> +			"Keeping Current RAR0 Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
> +			hw->mac.addr[0], hw->mac.addr[1],
> +			hw->mac.addr[2], hw->mac.addr[3],
> +			hw->mac.addr[4], hw->mac.addr[5]);
> +	} else {
> +		/* Setup the receive address. */
> +		dev_dbg(ngbe_hw_to_dev(hw), "Overriding MAC Address in RAR[0]\n");
> +		dev_dbg(ngbe_hw_to_dev(hw),
> +			"New MAC Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
> +			hw->mac.addr[0], hw->mac.addr[1],
> +			hw->mac.addr[2], hw->mac.addr[3],
> +			hw->mac.addr[4], hw->mac.addr[5]);
> +		ngbe_set_rar(hw, 0, hw->mac.addr, 0, NGBE_PSR_MAC_SWC_AD_H_AV);
> +	}
> +	hw->addr_ctrl.overflow_promisc = 0;
> +	hw->addr_ctrl.rar_used_count = 1;
> +	/* Zero out the other receive addresses. */
> +	for (i = 1; i < rar_entries; i++) {
> +		wr32(hw, NGBE_PSR_MAC_SWC_IDX, i);
> +		wr32(hw, NGBE_PSR_MAC_SWC_AD_L, 0);
> +		wr32(hw, NGBE_PSR_MAC_SWC_AD_H, 0);
> +	}
> +	/* Clear the MTA */
> +	hw->addr_ctrl.mta_in_use = 0;
> +	psrctl = rd32(hw, NGBE_PSR_CTL);
> +	psrctl &= ~(NGBE_PSR_CTL_MO | NGBE_PSR_CTL_MFE);
> +	psrctl |= hw->mac.mc_filter_type << NGBE_PSR_CTL_MO_SHIFT;
> +	wr32(hw, NGBE_PSR_CTL, psrctl);
> +	for (i = 0; i < hw->mac.mcft_size; i++)
> +		wr32(hw, NGBE_PSR_MC_TBL(i), 0);
> +
> +	ngbe_init_uta_tables(hw);
> +}
> +
> +static int ngbe_fmgr_cmd_op(struct ngbe_hw *hw, u32 cmd, u32 cmd_addr)
> +{
> +	u32 cmd_val = 0, val = 0;
> +
> +	cmd_val = (cmd << NGBE_SPI_CLK_CMD_OFFSET) |
> +		  (NGBE_SPI_CLK_DIV << NGBE_SPI_CLK_DIV_OFFSET) | cmd_addr;
> +	wr32(hw, NGBE_SPI_H_CMD_REG_ADDR, cmd_val);
> +
> +	return read_poll_timeout(rd32, val, (val & 0x1), 10, NGBE_SPI_TIME_OUT_VALUE,
> +				 false, hw, NGBE_SPI_H_STA_REG_ADDR);
> +}
> +
> +int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data)
> +{
> +	int ret = 0;
> +
> +	ret = ngbe_fmgr_cmd_op(hw, NGBE_SPI_CMD_READ_DWORD, addr);
> +	if (ret < 0)
> +		return ret;
> +	*data = rd32(hw, NGBE_SPI_H_DAT_REG_ADDR);
> +
> +	return 0;
> +}
> +
> +int ngbe_check_flash_load(struct ngbe_hw *hw, u32 check_bit)
> +{
> +	u32 reg = 0, status = 0;
> +
> +	/* if there's flash existing */
> +	if (!(rd32(hw, NGBE_SPI_H_STA_REG_ADDR) &
> +	      NGBE_SPI_STATUS_FLASH_BYPASS)) {
> +		/* wait hw load flash done */
> +		status = read_poll_timeout(rd32, reg, !(reg & check_bit), 1000, 400000,
> +					   false, hw, NGBE_SPI_ILDR_STATUS);
> +		if (status < 0)
> +			return -EBUSY;
> +	}
> +	return 0;
> +}
> +
> +/**
> + *  ngbe_get_pcie_msix_counts - Gets MSI-X vector count
> + *  @hw: pointer to hardware structure
> + *  @msix_count: number of MSI interrupts that can be obtained
> + *
> + *  Read PCIe configuration space, and get the MSI-X vector count from
> + *  the capabilities table.
> + **/
> +int ngbe_get_pcie_msix_counts(struct ngbe_hw *hw, u16 *msix_count)
> +{
> +	struct ngbe_adapter *adapter = hw->back;
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct device *dev = &pdev->dev;
> +	u16 max_msix_count;
> +	int pos;
> +
> +	*msix_count = 1;
> +	/* max_msix_count for emerald */
> +	max_msix_count = NGBE_MAX_MSIX_VECTORS;
> +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> +	if (!pos) {
> +		dev_err(dev, "Unable to find MSI-X Capabilities\n");
> +		return -EINVAL;
> +	}
> +	pci_read_config_word(pdev,
> +			     pos + PCI_MSIX_FLAGS,
> +			     msix_count);
> +	*msix_count &= NGBE_PCIE_MSIX_TBL_SZ_MASK;
> +	/* MSI-X count is zero-based in HW */
> +	*msix_count += 1;
> +
> +	if (*msix_count > max_msix_count)
> +		*msix_count = max_msix_count;
> +
> +	return 0;
> +}
> +
> +static int ngbe_reset_misc(struct ngbe_hw *hw)
> +{
> +	int i;
> +
> +	/* receive packets that size > 2048 */
> +	wr32m(hw, NGBE_MAC_RX_CFG, NGBE_MAC_RX_CFG_JE, NGBE_MAC_RX_CFG_JE);
> +	/* clear counters on read */
> +	wr32m(hw, NGBE_MMC_CONTROL,
> +	      NGBE_MMC_CONTROL_RSTONRD, NGBE_MMC_CONTROL_RSTONRD);
> +	wr32m(hw, NGBE_MAC_RX_FLOW_CTRL,
> +	      NGBE_MAC_RX_FLOW_CTRL_RFE, NGBE_MAC_RX_FLOW_CTRL_RFE);
> +	wr32(hw, NGBE_MAC_PKT_FLT, NGBE_MAC_PKT_FLT_PR);
> +	wr32m(hw, NGBE_MIS_RST_ST, NGBE_MIS_RST_ST_RST_INIT, 0x1E00);
> +	/* errata 4: initialize mng flex tbl and wakeup flex tbl */
> +	wr32(hw, NGBE_PSR_MNG_FLEX_SEL, 0);
> +	for (i = 0; i < 16; i++) {
> +		wr32(hw, NGBE_PSR_MNG_FLEX_DW_L(i), 0);
> +		wr32(hw, NGBE_PSR_MNG_FLEX_DW_H(i), 0);
> +		wr32(hw, NGBE_PSR_MNG_FLEX_MSK(i), 0);
> +	}
> +	wr32(hw, NGBE_PSR_LAN_FLEX_SEL, 0);
> +	for (i = 0; i < 16; i++) {
> +		wr32(hw, NGBE_PSR_LAN_FLEX_DW_L(i), 0);
> +		wr32(hw, NGBE_PSR_LAN_FLEX_DW_H(i), 0);
> +		wr32(hw, NGBE_PSR_LAN_FLEX_MSK(i), 0);
> +	}
> +
> +	/* set pause frame dst mac addr */
> +	wr32(hw, NGBE_RDB_PFCMACDAL, 0xC2000001);
> +	wr32(hw, NGBE_RDB_PFCMACDAH, 0x0180);
> +	if (hw->mac.type == ngbe_mac_type_rgmii)
> +		wr32(hw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
> +	if (hw->gpio_ctrl) {
> +		/* gpio0 is used to power on/off control*/
> +		wr32(hw, NGBE_GPIO_DDR, 0x1);
> +		wr32(hw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
> +	}
> +	return 0;
> +}
> +
> +/**
> + *  ngbe_reset_hw - Perform hardware reset
> + *  @hw: pointer to hardware structure
> + *
> + *  Resets the hardware by resetting the transmit and receive units, masks
> + *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
> + *  reset.
> + **/
> +int ngbe_reset_hw(struct ngbe_hw *hw)
> +{
> +	u32 reset_status = 0;
> +	u32 rst_delay = 0;
> +	int err;
> +
> +	/* Issue global reset to the MAC.  Needs to be SW reset if link is up.
> +	 * If link reset is used when link is up, it might reset the PHY when
> +	 * mng is using it.  If link is down or the flag to force full link
> +	 * reset is set, then perform link reset.
> +	 */
> +	if (hw->force_full_reset) {
> +		rst_delay = (rd32(hw, NGBE_MIS_RST_ST) &
> +			     NGBE_MIS_RST_ST_RST_INIT) >>
> +			     NGBE_MIS_RST_ST_RST_INI_SHIFT;
> +		if (hw->reset_type == NGBE_SW_RESET) {
> +			err = read_poll_timeout(rd32, reset_status,
> +						!(reset_status & NGBE_MIS_RST_ST_DEV_RST_ST_MASK),
> +						1000, rst_delay + 20000,
> +						false, hw,
> +						NGBE_MIS_RST_ST);
> +			if (!err)
> +				return err;
> +
> +			if (reset_status & NGBE_MIS_RST_ST_DEV_RST_ST_MASK) {
> +				err = -EBUSY;
> +				dev_err(ngbe_hw_to_dev(hw),
> +					"software reset polling failed to complete %d.\n",
> +					err);
> +				return err;
> +			}
> +			err = ngbe_check_flash_load(hw, NGBE_SPI_ILDR_STATUS_SW_RESET);
> +			if (err != 0)
> +				return err;
> +		}
> +	} else {
> +		wr32(hw, NGBE_MIS_RST, 1 << (hw->bus.func + 1) |
> +		     rd32(hw, NGBE_MIS_RST));
> +		ngbe_flush(hw);
> +		msleep(20);
> +	}
> +
> +	err = ngbe_reset_misc(hw);
> +	if (err != 0)
> +		return err;
> +
> +	/* Store the permanent mac address */
> +	ngbe_get_mac_addr(hw, hw->mac.perm_addr);
> +
> +	/* reset num_rar_entries to 128 */
> +	hw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
> +	ngbe_init_rx_addrs(hw);
> +	pci_set_master(((struct ngbe_adapter *)hw->back)->pdev);
> +
> +	return 0;
> +}
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
> new file mode 100644
> index 000000000000..c2c9dc186ad4
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * WangXun Gigabit PCI Express Linux driver
> + * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
> + */
> +
> +#ifndef _NGBE_HW_H_
> +#define _NGBE_HW_H_
> +
> +u32 rd32m(struct ngbe_hw *hw, u32 reg, u32 mask);
> +void wr32m(struct ngbe_hw *hw, u32 reg, u32 mask, u32 field);
> +struct device *ngbe_hw_to_dev(struct ngbe_hw *hw);
> +int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data);
> +int ngbe_check_flash_load(struct ngbe_hw *hw, u32 check_bit);
> +int ngbe_get_pcie_msix_counts(struct ngbe_hw *hw, u16 *msix_count);
> +/* mac ops */
> +int ngbe_reset_hw(struct ngbe_hw *hw);
> +#endif /* _NGBE_HW_H_ */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> index 7674cb6e5700..6ea06d6032c6 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> @@ -10,6 +10,7 @@
>  #include <linux/etherdevice.h>
>  
>  #include "ngbe.h"
> +#include "ngbe_hw.h"
>  char ngbe_driver_name[] = "ngbe";
>  
>  /* ngbe_pci_tbl - PCI Device ID Table
> @@ -56,6 +57,166 @@ static void ngbe_shutdown(struct pci_dev *pdev)
>  	}
>  }
>  
> +/**
> + *  ngbe_init_type_code - Initialize the shared code
> + *  @hw: pointer to hardware structure
> + **/
> +static void ngbe_init_type_code(struct ngbe_hw *hw)
> +{
> +	u8 wol_mask = 0, ncsi_mask = 0;
> +	u16 type_mask = 0;
> +
> +	type_mask = (u16)(hw->subsystem_device_id & NGBE_OEM_MASK);
> +	ncsi_mask = (u8)(hw->subsystem_device_id & NGBE_NCSI_MASK);
> +	wol_mask = (u8)(hw->subsystem_device_id & NGBE_WOL_MASK);
> +
> +	switch (type_mask) {
> +	case NGBE_SUBID_M88E1512_SFP:
> +	case NGBE_SUBID_LY_M88E1512_SFP:
> +		hw->phy.type = ngbe_phy_m88e1512_sfi;
> +		break;
> +	case NGBE_SUBID_M88E1512_RJ45:
> +		hw->phy.type = ngbe_phy_m88e1512;
> +		break;
> +	case NGBE_SUBID_M88E1512_MIX:
> +		hw->phy.type = ngbe_phy_m88e1512_unknown;
> +		break;
> +	case NGBE_SUBID_YT8521S_SFP:
> +	case NGBE_SUBID_YT8521S_SFP_GPIO:
> +	case NGBE_SUBID_LY_YT8521S_SFP:
> +		hw->phy.type = ngbe_phy_yt8521s_sfi;
> +		break;
> +	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
> +	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
> +		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
> +		break;
> +	case NGBE_SUBID_RGMII_FPGA:
> +	case NGBE_SUBID_OCP_CARD:
> +		fallthrough;
> +	default:
> +		hw->phy.type = ngbe_phy_internal;
> +		break;
> +	}
> +
> +	if (hw->phy.type == ngbe_phy_internal ||
> +	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
> +		hw->mac.type = ngbe_mac_type_mdi;
> +	else
> +		hw->mac.type = ngbe_mac_type_rgmii;
> +
> +	hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
> +	hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
> +			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
> +
> +	switch (type_mask) {
> +	case NGBE_SUBID_LY_YT8521S_SFP:
> +	case NGBE_SUBID_LY_M88E1512_SFP:
> +	case NGBE_SUBID_YT8521S_SFP_GPIO:
> +	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
> +		hw->gpio_ctrl = 1;
> +		break;
> +	default:
> +		hw->gpio_ctrl = 0;
> +		break;
> +	}
> +}
> +
> +/**
> + * ngbe_init_rss_key - Initialize adapter RSS key
> + * @adapter: device handle
> + *
> + * Allocates and initializes the RSS key if it is not allocated.
> + **/
> +static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
> +{
> +	u32 *rss_key;
> +
> +	if (!adapter->rss_key) {
> +		rss_key = kzalloc(NGBE_RSS_KEY_SIZE, GFP_KERNEL);
> +		if (unlikely(!rss_key))
> +			return -ENOMEM;
> +
> +		netdev_rss_key_fill(rss_key, NGBE_RSS_KEY_SIZE);
> +		adapter->rss_key = rss_key;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ngbe_sw_init - Initialize general software structures
> + * @adapter: board private structure to initialize
> + **/
> +static int ngbe_sw_init(struct ngbe_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ngbe_hw *hw = &adapter->hw;
> +	struct device *dev = &pdev->dev;
> +	u16 msix_count = 0;
> +	u32 ssid = 0;
> +	int err = 0;
> +
> +	/* PCI config space info */
> +	hw->vendor_id = pdev->vendor;
> +	hw->device_id = pdev->device;
> +	hw->revision_id = pdev->revision;
> +	hw->bus.device = PCI_SLOT(pdev->devfn);
> +	hw->bus.func = PCI_FUNC(pdev->devfn);
> +
> +	hw->oem_svid = pdev->subsystem_vendor;
> +	hw->oem_ssid = pdev->subsystem_device;
> +	if (pdev->subsystem_vendor == PCI_SUB_VID_WANGXUN) {
> +		hw->subsystem_vendor_id = pdev->subsystem_vendor;
> +		hw->subsystem_device_id = pdev->subsystem_device;
> +	} else {
> +		err = ngbe_flash_read_dword(hw, 0xfffdc, &ssid);
> +		if (err < 0) {
> +			dev_err(dev, "Read internal subdid err %d\n", err);
> +			return err;
> +		}
> +		hw->subsystem_device_id = swab16((u16)ssid);
> +	}
> +
> +	/* mac type, phy type , oem type */
> +	ngbe_init_type_code(hw);
> +
> +	hw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
> +	hw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
> +	hw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
> +	/* Set common capability flags and settings */
> +	adapter->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
> +
> +	err = ngbe_get_pcie_msix_counts(hw, &msix_count);
> +	if (err)
> +		dev_err(dev, "Do not support MSI-X\n");

You already logged an error in ngbe_get_pcie_msix_counts() and here the
error is just ignored. Unless you plan to extend this code path in
future patches, I think it would be better to just log an info or
warning in ngbe_get_pcie_msix_counts() and always return the
max_msix_vectors (1 when detection is not possible).


Cheers,

Paolo


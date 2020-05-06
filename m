Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8369E1C7A0C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgEFTQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgEFTQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:16:25 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB32C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 12:16:24 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j8so3330905iog.13
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 12:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leon-nu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2BREQKFKkM3lBFDmi6D/DgM3pZLpMTuf5Q5xQpkW+HU=;
        b=uVRCEpBJGjax8Yrf+BnIK8B4WvrCaMrli2am3yrB7RULCjqKgAkAi2hqSutrSJ9Vm4
         cWAlYo+Y4uqMUYyyWzlBvfB9HJgMgwCxT/m8dEb0HBhzNxvu1xZmVIsusTmRa97E5DfS
         40Tcd8M2lDadZnR57OgaA8MITiMAAO2HSpKZzbZIl82DF5uV880yTTgTblqv6wW6J1ex
         3SM2TeTB+nCLtSb4fOnfZwtpfmBdonWi4ne7swCBHzowDZ8lDpeVM2KAR93DCYkZPguH
         eyfyRdvKIalcE7a7oGp4CYB5LaxjSpAcg9k3ga+ogB+oaZLfWrtfkTo7RQEmdoNFC4V2
         WrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2BREQKFKkM3lBFDmi6D/DgM3pZLpMTuf5Q5xQpkW+HU=;
        b=aOvsOLaTw+misrWOU/O0ylSBzOAtD7c04VHVwoHjRA7TyDmExmCoPjRyhg2YChiZT2
         pd69TwCcgmRjHm31joXOHJtH7g9SxaIsmEbE8o9ijGl4Hz90G8jysRvPegfd/ETfZW53
         0pmx8HoYNIjr4OVSSIjRfOq5Jed0Cdiqg8qwUGAMa0EEGfIiRTKnFHoEe6k7ZM84EcT1
         cTbOkVucQ0NxX8NYA7teRbTPY7YDGP/ei/X7OCqDSq+yK/DODH+WwZBLSvmM8tnc351/
         Bz+bsclSCtOP92+au6OQKmskLAMjGKrG6WRH0V7vEFwTKF0qGpmxT/hl8cfNSRD4sq2v
         1TjA==
X-Gm-Message-State: AGi0Pua9pvyZMWT7kSquykfRMqjMRoeiShoeqP9A1zaAQFF8hq4Iu+Se
        LdpvTRd6zSti8o7OG/zbVYFo1Xx8Mk6uDDvvrai6zg==
X-Google-Smtp-Source: APiQypKNmzPbFgZsXLRLtOcB6KMjGzB6ugZE+C/7KiDo+J32mJmskruTd0pHBUKIVpPczztBOWUiEeLGNH1gMh6eGq0=
X-Received: by 2002:a02:cbc6:: with SMTP id u6mr10282390jaq.27.1588792583079;
 Wed, 06 May 2020 12:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-7-brgl@bgdev.pl>
In-Reply-To: <20200505140231.16600-7-brgl@bgdev.pl>
From:   Leon Romanovsky <leon@leon.nu>
Date:   Wed, 6 May 2020 22:16:11 +0300
Message-ID: <CALq1K=Lu0hv9UCgxgrwCVoOe9L7A4sgBEM=RW2d9JkizHmdBPQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 5:03 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> This adds the driver for the MediaTek Ethernet MAC used on the MT8* SoC
> family. For now we only support full-duplex.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/net/ethernet/mediatek/Kconfig       |    6 +
>  drivers/net/ethernet/mediatek/Makefile      |    1 +
>  drivers/net/ethernet/mediatek/mtk_eth_mac.c | 1476 +++++++++++++++++++
>  3 files changed, 1483 insertions(+)
>  create mode 100644 drivers/net/ethernet/mediatek/mtk_eth_mac.c
>
> diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
> index 5079b8090f16..5c3793076765 100644
> --- a/drivers/net/ethernet/mediatek/Kconfig
> +++ b/drivers/net/ethernet/mediatek/Kconfig
> @@ -14,4 +14,10 @@ config NET_MEDIATEK_SOC
>           This driver supports the gigabit ethernet MACs in the
>           MediaTek SoC family.
>
> +config NET_MEDIATEK_MAC
> +       tristate "MediaTek Ethernet MAC support"
> +       select PHYLIB
> +       help
> +         This driver supports the ethernet IP on MediaTek MT85** SoCs.
> +
>  endif #NET_VENDOR_MEDIATEK
> diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
> index 3362fb7ef859..f7f5638943a0 100644
> --- a/drivers/net/ethernet/mediatek/Makefile
> +++ b/drivers/net/ethernet/mediatek/Makefile
> @@ -5,3 +5,4 @@
>
>  obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
>  mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o
> +obj-$(CONFIG_NET_MEDIATEK_MAC) += mtk_eth_mac.o
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_mac.c b/drivers/net/ethernet/mediatek/mtk_eth_mac.c
> new file mode 100644
> index 000000000000..e6e796e65228
> --- /dev/null
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_mac.c
> @@ -0,0 +1,1476 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2020 MediaTek Corporation
> + * Copyright (c) 2020 BayLibre SAS
> + *
> + * Author: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> + */
> +
> +#include <linux/bits.h>
> +#include <linux/clk.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/etherdevice.h>
> +#include <linux/jiffies.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/mii.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/of.h>
> +#include <linux/of_mdio.h>
> +#include <linux/of_net.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm.h>
> +#include <linux/regmap.h>
> +#include <linux/spinlock.h>
> +#include <linux/workqueue.h>
> +
> +#define MTK_MAC_DRVNAME                                "mtk_eth_mac"
> +#define MTK_MAC_VERSION                                "1.0"

Please don't add driver version to new driver.

Thanks

> +
> +#define MTK_MAC_WAIT_TIMEOUT                   300
> +#define MTK_MAC_MAX_FRAME_SIZE                 1514
> +#define MTK_MAC_SKB_ALIGNMENT                  16
> +#define MTK_MAC_NAPI_WEIGHT                    64
> +#define MTK_MAC_HASHTABLE_MC_LIMIT             256
> +#define MTK_MAC_HASHTABLE_SIZE_MAX             512
> +
> +static const char *const mtk_mac_clk_names[] = { "core", "reg", "trans" };
> +#define MTK_MAC_NCLKS ARRAY_SIZE(mtk_mac_clk_names)
> +
> +/* PHY Control Register 0 */
> +#define MTK_MAC_REG_PHY_CTRL0                  0x0000
> +#define MTK_MAC_BIT_PHY_CTRL0_WTCMD            BIT(13)
> +#define MTK_MAC_BIT_PHY_CTRL0_RDCMD            BIT(14)
> +#define MTK_MAC_BIT_PHY_CTRL0_RWOK             BIT(15)
> +#define MTK_MAC_MSK_PHY_CTRL0_PREG             GENMASK(12, 8)
> +#define MTK_MAC_OFF_PHY_CTRL0_PREG             8
> +#define MTK_MAC_MSK_PHY_CTRL0_RWDATA           GENMASK(31, 16)
> +#define MTK_MAC_OFF_PHY_CTRL0_RWDATA           16
> +
> +/* PHY Control Register 1 */
> +#define MTK_MAC_REG_PHY_CTRL1                  0x0004
> +#define MTK_MAC_BIT_PHY_CTRL1_LINK_ST          BIT(0)
> +#define MTK_MAC_BIT_PHY_CTRL1_AN_EN            BIT(8)
> +#define MTK_MAC_OFF_PHY_CTRL1_FORCE_SPD                9
> +#define MTK_MAC_VAL_PHY_CTRL1_FORCE_SPD_10M    0x00
> +#define MTK_MAC_VAL_PHY_CTRL1_FORCE_SPD_100M   0x01
> +#define MTK_MAC_VAL_PHY_CTRL1_FORCE_SPD_1000M  0x02
> +#define MTK_MAC_BIT_PHY_CTRL1_FORCE_DPX                BIT(11)
> +#define MTK_MAC_BIT_PHY_CTRL1_FORCE_FC_RX      BIT(12)
> +#define MTK_MAC_BIT_PHY_CTRL1_FORCE_FC_TX      BIT(13)
> +
> +/* MAC Configuration Register */
> +#define MTK_MAC_REG_MAC_CFG                    0x0008
> +#define MTK_MAC_OFF_MAC_CFG_IPG                        10
> +#define MTK_MAC_VAL_MAC_CFG_IPG_96BIT          GENMASK(4, 0)
> +#define MTK_MAC_BIT_MAC_CFG_MAXLEN_1522                BIT(16)
> +#define MTK_MAC_BIT_MAC_CFG_AUTO_PAD           BIT(19)
> +#define MTK_MAC_BIT_MAC_CFG_CRC_STRIP          BIT(20)
> +#define MTK_MAC_BIT_MAC_CFG_VLAN_STRIP         BIT(22)
> +#define MTK_MAC_BIT_MAC_CFG_NIC_PD             BIT(31)
> +
> +/* Flow-Control Configuration Register */
> +#define MTK_MAC_REG_FC_CFG                     0x000c
> +#define MTK_MAC_BIT_FC_CFG_BP_EN               BIT(7)
> +#define MTK_MAC_BIT_FC_CFG_UC_PAUSE_DIR        BIT(8)
> +#define MTK_MAC_OFF_FC_CFG_SEND_PAUSE_TH       16
> +#define MTK_MAC_VAL_FC_CFG_SEND_PAUSE_TH_2K    0x800
> +
> +/* ARL Configuration Register */
> +#define MTK_MAC_REG_ARL_CFG                    0x0010
> +#define MTK_MAC_BIT_ARL_CFG_HASH_ALG           BIT(0)
> +#define MTK_MAC_BIT_ARL_CFG_MISC_MODE          BIT(4)
> +
> +/* MAC High and Low Bytes Registers */
> +#define MTK_MAC_REG_MY_MAC_H                   0x0014
> +#define MTK_MAC_REG_MY_MAC_L                   0x0018
> +
> +/* Hash Table Control Register */
> +#define MTK_MAC_REG_HASH_CTRL                  0x001c
> +#define MTK_MAC_MSK_HASH_CTRL_HASH_BIT_ADDR    GENMASK(8, 0)
> +#define MTK_MAC_BIT_HASH_CTRL_HASH_BIT_DATA    BIT(12)
> +#define MTK_MAC_BIT_HASH_CTRL_ACC_CMD          BIT(13)
> +#define MTK_MAC_BIT_HASH_CTRL_CMD_START                BIT(14)
> +#define MTK_MAC_BIT_HASH_CTRL_BIST_EN          BIT(31)
> +
> +/* TX DMA Control Register */
> +#define MTK_MAC_REG_TX_DMA_CTRL                        0x0034
> +#define MTK_MAC_BIT_TX_DMA_CTRL_START          BIT(0)
> +#define MTK_MAC_BIT_TX_DMA_CTRL_STOP           BIT(1)
> +#define MTK_MAC_BIT_TX_DMA_CTRL_RESUME         BIT(2)
> +
> +/* RX DMA Control Register */
> +#define MTK_MAC_REG_RX_DMA_CTRL                        0x0038
> +#define MTK_MAC_BIT_RX_DMA_CTRL_START          BIT(0)
> +#define MTK_MAC_BIT_RX_DMA_CTRL_STOP           BIT(1)
> +#define MTK_MAC_BIT_RX_DMA_CTRL_RESUME         BIT(2)
> +
> +/* DMA Address Registers */
> +#define MTK_MAC_REG_TX_DPTR                    0x003c
> +#define MTK_MAC_REG_RX_DPTR                    0x0040
> +#define MTK_MAC_REG_TX_BASE_ADDR               0x0044
> +#define MTK_MAC_REG_RX_BASE_ADDR               0x0048
> +
> +/* Interrupt Status Register */
> +#define MTK_MAC_REG_INT_STS                    0x0050
> +#define MTK_MAC_REG_INT_STS_PORT_STS_CHG       BIT(2)
> +#define MTK_MAC_REG_INT_STS_MIB_CNT_TH         BIT(3)
> +#define MTK_MAC_BIT_INT_STS_FNRC               BIT(6)
> +#define MTK_MAC_BIT_INT_STS_TNTC               BIT(8)
> +
> +/* Interrupt Mask Register */
> +#define MTK_MAC_REG_INT_MASK                   0x0054
> +#define MTK_MAC_BIT_INT_MASK_FNRC              BIT(6)
> +
> +/* Misc. Config Register */
> +#define MTK_MAC_REG_TEST1                      0x005c
> +#define MTK_MAC_BIT_TEST1_RST_HASH_MBIST       BIT(31)
> +
> +/* Extended Configuration Register */
> +#define MTK_MAC_REG_EXT_CFG                    0x0060
> +#define MTK_MAC_OFF_EXT_CFG_SND_PAUSE_RLS      16
> +#define MTK_MAC_VAL_EXT_CFG_SND_PAUSE_RLS_1K   0x400
> +
> +/* EthSys Configuration Register */
> +#define MTK_MAC_REG_SYS_CONF                   0x0094
> +#define MTK_MAC_BIT_MII_PAD_OUT_ENABLE         BIT(0)
> +#define MTK_MAC_BIT_EXT_MDC_MODE               BIT(1)
> +#define MTK_MAC_BIT_SWC_MII_MODE               BIT(2)
> +
> +/* MAC Clock Configuration Register */
> +#define MTK_MAC_REG_MAC_CLK_CONF               0x00ac
> +#define MTK_MAC_MSK_MAC_CLK_CONF               GENMASK(7, 0)
> +#define MTK_MAC_BIT_CLK_DIV_10                 0x0a
> +
> +/* Counter registers. */
> +#define MTK_MAC_REG_C_RXOKPKT                  0x0100
> +#define MTK_MAC_REG_C_RXOKBYTE                 0x0104
> +#define MTK_MAC_REG_C_RXRUNT                   0x0108
> +#define MTK_MAC_REG_C_RXLONG                   0x010c
> +#define MTK_MAC_REG_C_RXDROP                   0x0110
> +#define MTK_MAC_REG_C_RXCRC                    0x0114
> +#define MTK_MAC_REG_C_RXARLDROP                        0x0118
> +#define MTK_MAC_REG_C_RXVLANDROP               0x011c
> +#define MTK_MAC_REG_C_RXCSERR                  0x0120
> +#define MTK_MAC_REG_C_RXPAUSE                  0x0124
> +#define MTK_MAC_REG_C_TXOKPKT                  0x0128
> +#define MTK_MAC_REG_C_TXOKBYTE                 0x012c
> +#define MTK_MAC_REG_C_TXPAUSECOL               0x0130
> +#define MTK_MAC_REG_C_TXRTY                    0x0134
> +#define MTK_MAC_REG_C_TXSKIP                   0x0138
> +#define MTK_MAC_REG_C_TX_ARP                   0x013c
> +#define MTK_MAC_REG_C_RX_RERR                  0x01d8
> +#define MTK_MAC_REG_C_RX_UNI                   0x01dc
> +#define MTK_MAC_REG_C_RX_MULTI                 0x01e0
> +#define MTK_MAC_REG_C_RX_BROAD                 0x01e4
> +#define MTK_MAC_REG_C_RX_ALIGNERR              0x01e8
> +#define MTK_MAC_REG_C_TX_UNI                   0x01ec
> +#define MTK_MAC_REG_C_TX_MULTI                 0x01f0
> +#define MTK_MAC_REG_C_TX_BROAD                 0x01f4
> +#define MTK_MAC_REG_C_TX_TIMEOUT               0x01f8
> +#define MTK_MAC_REG_C_TX_LATECOL               0x01fc
> +#define MTK_MAC_REG_C_RX_LENGTHERR             0x0214
> +#define MTK_MAC_REG_C_RX_TWIST                 0x0218
> +
> +/* Ethernet CFG Control */
> +#define MTK_PERICFG_REG_NIC_CFG_CON            0x03c4
> +#define MTK_PERICFG_MSK_NIC_CFG_CON_CFG_MII    GENMASK(3, 0)
> +#define MTK_PERICFG_BIT_NIC_CFG_CON_RMII       BIT(0)
> +
> +/* Represents the actual structure of descriptors used by the MAC. We can
> + * reuse the same structure for both TX and RX - the layout is the same, only
> + * the flags differ slightly.
> + */
> +struct mtk_mac_ring_desc {
> +       /* Contains both the status flags as well as packet length. */
> +       u32 status;
> +       u32 data_ptr;
> +       u32 vtag;
> +       u32 reserved;
> +} __aligned(4) __packed;
> +
> +#define MTK_MAC_DESC_MSK_LEN                   GENMASK(15, 0)
> +#define MTK_MAC_DESC_BIT_RX_CRCE               BIT(24)
> +#define MTK_MAC_DESC_BIT_RX_OSIZE              BIT(25)
> +#define MTK_MAC_DESC_BIT_INT                   BIT(27)
> +#define MTK_MAC_DESC_BIT_LS                    BIT(28)
> +#define MTK_MAC_DESC_BIT_FS                    BIT(29)
> +#define MTK_MAC_DESC_BIT_EOR                   BIT(30)
> +#define MTK_MAC_DESC_BIT_COWN                  BIT(31)
> +
> +/* Helper structure for storing data read from/written to descriptors in order
> + * to limit reads from/writes to DMA memory.
> + */
> +struct mtk_mac_ring_desc_data {
> +       unsigned int len;
> +       unsigned int flags;
> +       dma_addr_t dma_addr;
> +       struct sk_buff *skb;
> +};
> +
> +#define MTK_MAC_RING_NUM_DESCS                 128
> +#define MTK_MAC_NUM_TX_DESCS                   MTK_MAC_RING_NUM_DESCS
> +#define MTK_MAC_NUM_RX_DESCS                   MTK_MAC_RING_NUM_DESCS
> +#define MTK_MAC_NUM_DESCS_TOTAL                        (MTK_MAC_RING_NUM_DESCS * 2)
> +#define MTK_MAC_DMA_SIZE \
> +               (MTK_MAC_NUM_DESCS_TOTAL * sizeof(struct mtk_mac_ring_desc))
> +
> +struct mtk_mac_ring {
> +       struct mtk_mac_ring_desc *descs;
> +       struct sk_buff *skbs[MTK_MAC_RING_NUM_DESCS];
> +       unsigned int head;
> +       unsigned int tail;
> +       unsigned int count;
> +};
> +
> +struct mtk_mac_priv {
> +       struct regmap *regs;
> +       struct regmap *pericfg;
> +
> +       struct clk_bulk_data clks[MTK_MAC_NCLKS];
> +
> +       void *ring_base;
> +       struct mtk_mac_ring_desc *descs_base;
> +       dma_addr_t dma_addr;
> +       struct mtk_mac_ring tx_ring;
> +       struct mtk_mac_ring rx_ring;
> +       struct work_struct tx_work;
> +
> +       struct mii_bus *mii;
> +       struct napi_struct napi;
> +
> +       struct device_node *phy_node;
> +       phy_interface_t phy_intf;
> +       struct phy_device *phydev;
> +       unsigned int link;
> +       int speed;
> +       int duplex;
> +
> +       /* Protects against concurrent descriptor access. */
> +       spinlock_t lock;
> +       unsigned long lock_flags;
> +
> +       struct rtnl_link_stats64 stats;
> +};
> +
> +static struct net_device *mtk_mac_get_netdev(struct mtk_mac_priv *priv)
> +{
> +       char *ptr = (char *)priv;
> +
> +       return (struct net_device *)(ptr - ALIGN(sizeof(struct net_device),
> +                                                NETDEV_ALIGN));
> +}
> +
> +static struct device *mtk_mac_get_dev(struct mtk_mac_priv *priv)
> +{
> +       struct net_device *ndev = mtk_mac_get_netdev(priv);
> +
> +       return ndev->dev.parent;
> +}
> +
> +static const struct regmap_config mtk_mac_regmap_config = {
> +       .reg_bits               = 32,
> +       .val_bits               = 32,
> +       .reg_stride             = 4,
> +       .fast_io                = true,
> +};
> +
> +static void mtk_mac_ring_init(struct mtk_mac_ring *ring,
> +                             struct mtk_mac_ring_desc *descs,
> +                             unsigned int start_count)
> +{
> +       memset(ring, 0, sizeof(*ring));
> +       ring->descs = descs;
> +       ring->head = 0;
> +       ring->tail = 0;
> +       ring->count = start_count;
> +}
> +
> +static int mtk_mac_ring_pop_tail(struct mtk_mac_ring *ring,
> +                                struct mtk_mac_ring_desc_data *desc_data)
> +{
> +       struct mtk_mac_ring_desc *desc = &ring->descs[ring->tail];
> +       unsigned int status;
> +
> +       dma_rmb();
> +       status = desc->status;
> +
> +       if (!(status & MTK_MAC_DESC_BIT_COWN))
> +               return -1;
> +
> +       desc_data->len = status & MTK_MAC_DESC_MSK_LEN;
> +       desc_data->flags = status & ~MTK_MAC_DESC_MSK_LEN;
> +       desc_data->dma_addr = desc->data_ptr;
> +       desc_data->skb = ring->skbs[ring->tail];
> +
> +       desc->data_ptr = 0;
> +       desc->status = MTK_MAC_DESC_BIT_COWN;
> +       if (status & MTK_MAC_DESC_BIT_EOR)
> +               desc->status |= MTK_MAC_DESC_BIT_EOR;
> +
> +       dma_wmb();
> +
> +       ring->tail = (ring->tail + 1) % MTK_MAC_RING_NUM_DESCS;
> +       ring->count--;
> +
> +       return 0;
> +}
> +
> +static void mtk_mac_ring_push_head(struct mtk_mac_ring *ring,
> +                                  struct mtk_mac_ring_desc_data *desc_data,
> +                                  unsigned int flags)
> +{
> +       struct mtk_mac_ring_desc *desc = &ring->descs[ring->head];
> +       unsigned int status;
> +
> +       dma_rmb();
> +       status = desc->status;
> +
> +       ring->skbs[ring->head] = desc_data->skb;
> +       desc->data_ptr = desc_data->dma_addr;
> +
> +       status |= desc_data->len;
> +       if (flags)
> +               status |= flags;
> +       desc->status = status;
> +
> +       dma_wmb();
> +       desc->status &= ~MTK_MAC_DESC_BIT_COWN;
> +
> +       ring->head = (ring->head + 1) % MTK_MAC_RING_NUM_DESCS;
> +       ring->count++;
> +}
> +
> +static void mtk_mac_ring_push_head_rx(struct mtk_mac_ring *ring,
> +                                     struct mtk_mac_ring_desc_data *desc_data)
> +{
> +       mtk_mac_ring_push_head(ring, desc_data, 0);
> +}
> +
> +static void mtk_mac_ring_push_head_tx(struct mtk_mac_ring *ring,
> +                                     struct mtk_mac_ring_desc_data *desc_data)
> +{
> +       static const unsigned int flags = MTK_MAC_DESC_BIT_FS |
> +                                         MTK_MAC_DESC_BIT_LS |
> +                                         MTK_MAC_DESC_BIT_INT;
> +
> +       mtk_mac_ring_push_head(ring, desc_data, flags);
> +}
> +
> +static bool mtk_mac_ring_full(struct mtk_mac_ring *ring)
> +{
> +       return ring->count == MTK_MAC_RING_NUM_DESCS;
> +}
> +
> +static bool mtk_mac_ring_descs_available(struct mtk_mac_ring *ring)
> +{
> +       return ring->count > 0;
> +}
> +
> +static void mtk_mac_lock(struct mtk_mac_priv *priv)
> +{
> +       spin_lock_irqsave(&priv->lock, priv->lock_flags);
> +}
> +
> +static void mtk_mac_unlock(struct mtk_mac_priv *priv)
> +{
> +       spin_unlock_irqrestore(&priv->lock, priv->lock_flags);
> +}
> +
> +static dma_addr_t mtk_mac_dma_map_rx(struct mtk_mac_priv *priv,
> +                                    struct sk_buff *skb)
> +{
> +       struct device *dev = mtk_mac_get_dev(priv);
> +
> +       /* Data pointer for the RX DMA descriptor must be aligned to 4N + 2. */
> +       return dma_map_single(dev, skb_tail_pointer(skb) - 2,
> +                             skb_tailroom(skb), DMA_FROM_DEVICE);
> +}
> +
> +static void mtk_mac_dma_unmap_rx(struct mtk_mac_priv *priv,
> +                                struct mtk_mac_ring_desc_data *desc_data)
> +{
> +       struct device *dev = mtk_mac_get_dev(priv);
> +
> +       dma_unmap_single(dev, desc_data->dma_addr,
> +                        skb_tailroom(desc_data->skb), DMA_FROM_DEVICE);
> +}
> +
> +static dma_addr_t mtk_mac_dma_map_tx(struct mtk_mac_priv *priv,
> +                                    struct sk_buff *skb)
> +{
> +       struct device *dev = mtk_mac_get_dev(priv);
> +
> +       return dma_map_single(dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
> +}
> +
> +static void mtk_mac_dma_unmap_tx(struct mtk_mac_priv *priv,
> +                                struct mtk_mac_ring_desc_data *desc_data)
> +{
> +       struct device *dev = mtk_mac_get_dev(priv);
> +
> +       return dma_unmap_single(dev, desc_data->dma_addr,
> +                               desc_data->len, DMA_TO_DEVICE);
> +}
> +
> +static void mtk_mac_nic_disable_pd(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_MAC_CFG,
> +                          MTK_MAC_BIT_MAC_CFG_NIC_PD, 0);
> +}
> +
> +static void mtk_mac_intr_unmask_all(struct mtk_mac_priv *priv)
> +{
> +       regmap_write(priv->regs, MTK_MAC_REG_INT_MASK, 0);
> +}
> +
> +static void mtk_mac_intr_mask_all(struct mtk_mac_priv *priv)
> +{
> +       regmap_write(priv->regs, MTK_MAC_REG_INT_MASK, ~0);
> +}
> +
> +static unsigned int mtk_mac_intr_read_and_clear(struct mtk_mac_priv *priv)
> +{
> +       unsigned int val;
> +
> +       regmap_read(priv->regs, MTK_MAC_REG_INT_STS, &val);
> +       regmap_write(priv->regs, MTK_MAC_REG_INT_STS, val);
> +
> +       return val;
> +}
> +
> +static void mtk_mac_dma_init(struct mtk_mac_priv *priv)
> +{
> +       struct mtk_mac_ring_desc *desc;
> +       unsigned int val;
> +       int i;
> +
> +       priv->descs_base = (struct mtk_mac_ring_desc *)priv->ring_base;
> +
> +       for (i = 0; i < MTK_MAC_NUM_DESCS_TOTAL; i++) {
> +               desc = &priv->descs_base[i];
> +
> +               memset(desc, 0, sizeof(*desc));
> +               desc->status = MTK_MAC_DESC_BIT_COWN;
> +               if ((i == MTK_MAC_NUM_TX_DESCS - 1) ||
> +                   (i == MTK_MAC_NUM_DESCS_TOTAL - 1))
> +                       desc->status |= MTK_MAC_DESC_BIT_EOR;
> +       }
> +
> +       mtk_mac_ring_init(&priv->tx_ring, priv->descs_base, 0);
> +       mtk_mac_ring_init(&priv->rx_ring,
> +                         priv->descs_base + MTK_MAC_NUM_TX_DESCS,
> +                         MTK_MAC_NUM_RX_DESCS);
> +
> +       /* Set DMA pointers. */
> +       val = (unsigned int)priv->dma_addr;
> +       regmap_write(priv->regs, MTK_MAC_REG_TX_BASE_ADDR, val);
> +       regmap_write(priv->regs, MTK_MAC_REG_TX_DPTR, val);
> +
> +       val += sizeof(struct mtk_mac_ring_desc) * MTK_MAC_NUM_TX_DESCS;
> +       regmap_write(priv->regs, MTK_MAC_REG_RX_BASE_ADDR, val);
> +       regmap_write(priv->regs, MTK_MAC_REG_RX_DPTR, val);
> +}
> +
> +static void mtk_mac_dma_start(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_TX_DMA_CTRL,
> +                          MTK_MAC_BIT_TX_DMA_CTRL_START,
> +                          MTK_MAC_BIT_TX_DMA_CTRL_START);
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_RX_DMA_CTRL,
> +                          MTK_MAC_BIT_RX_DMA_CTRL_START,
> +                          MTK_MAC_BIT_RX_DMA_CTRL_START);
> +}
> +
> +static void mtk_mac_dma_stop(struct mtk_mac_priv *priv)
> +{
> +       regmap_write(priv->regs, MTK_MAC_REG_TX_DMA_CTRL,
> +                    MTK_MAC_BIT_TX_DMA_CTRL_STOP);
> +       regmap_write(priv->regs, MTK_MAC_REG_RX_DMA_CTRL,
> +                    MTK_MAC_BIT_RX_DMA_CTRL_STOP);
> +}
> +
> +static void mtk_mac_dma_disable(struct mtk_mac_priv *priv)
> +{
> +       int i;
> +
> +       mtk_mac_dma_stop(priv);
> +
> +       /* Take back all descriptors. */
> +       for (i = 0; i < MTK_MAC_NUM_DESCS_TOTAL; i++)
> +               priv->descs_base[i].status |= MTK_MAC_DESC_BIT_COWN;
> +}
> +
> +static void mtk_mac_dma_resume_rx(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_RX_DMA_CTRL,
> +                          MTK_MAC_BIT_RX_DMA_CTRL_RESUME,
> +                          MTK_MAC_BIT_RX_DMA_CTRL_RESUME);
> +}
> +
> +static void mtk_mac_dma_resume_tx(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_TX_DMA_CTRL,
> +                          MTK_MAC_BIT_TX_DMA_CTRL_RESUME,
> +                          MTK_MAC_BIT_TX_DMA_CTRL_RESUME);
> +}
> +
> +static void mtk_mac_set_mac_addr(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       u8 *mac_addr = ndev->dev_addr;
> +       unsigned int high, low;
> +
> +       high = mac_addr[0] << 8 | mac_addr[1] << 0;
> +       low = mac_addr[2] << 24 | mac_addr[3] << 16 |
> +             mac_addr[4] << 8 | mac_addr[5];
> +
> +       regmap_write(priv->regs, MTK_MAC_REG_MY_MAC_H, high);
> +       regmap_write(priv->regs, MTK_MAC_REG_MY_MAC_L, low);
> +}
> +
> +static void mtk_mac_reset_counters(struct mtk_mac_priv *priv)
> +{
> +       static const unsigned int counter_regs[] = {
> +               MTK_MAC_REG_C_RXOKPKT,
> +               MTK_MAC_REG_C_RXOKBYTE,
> +               MTK_MAC_REG_C_RXRUNT,
> +               MTK_MAC_REG_C_RXLONG,
> +               MTK_MAC_REG_C_RXDROP,
> +               MTK_MAC_REG_C_RXCRC,
> +               MTK_MAC_REG_C_RXARLDROP,
> +               MTK_MAC_REG_C_RXVLANDROP,
> +               MTK_MAC_REG_C_RXCSERR,
> +               MTK_MAC_REG_C_RXPAUSE,
> +               MTK_MAC_REG_C_TXOKPKT,
> +               MTK_MAC_REG_C_TXOKBYTE,
> +               MTK_MAC_REG_C_TXPAUSECOL,
> +               MTK_MAC_REG_C_TXRTY,
> +               MTK_MAC_REG_C_TXSKIP,
> +               MTK_MAC_REG_C_TX_ARP,
> +               MTK_MAC_REG_C_RX_RERR,
> +               MTK_MAC_REG_C_RX_UNI,
> +               MTK_MAC_REG_C_RX_MULTI,
> +               MTK_MAC_REG_C_RX_BROAD,
> +               MTK_MAC_REG_C_RX_ALIGNERR,
> +               MTK_MAC_REG_C_TX_UNI,
> +               MTK_MAC_REG_C_TX_MULTI,
> +               MTK_MAC_REG_C_TX_BROAD,
> +               MTK_MAC_REG_C_TX_TIMEOUT,
> +               MTK_MAC_REG_C_TX_LATECOL,
> +               MTK_MAC_REG_C_RX_LENGTHERR,
> +               MTK_MAC_REG_C_RX_TWIST,
> +       };
> +
> +       unsigned int i, val;
> +
> +       for (i = 0; i < ARRAY_SIZE(counter_regs); i++)
> +               regmap_read(priv->regs, counter_regs[i], &val);
> +}
> +
> +static void mtk_mac_update_stat(struct mtk_mac_priv *priv,
> +                               unsigned int reg, u64 *stat)
> +{
> +       unsigned int val;
> +
> +       regmap_read(priv->regs, reg, &val);
> +       *stat += val;
> +}
> +
> +/* Try to get as many stats as possible from the internal registers instead
> + * of tracking them ourselves.
> + */
> +static void mtk_mac_update_stats(struct mtk_mac_priv *priv)
> +{
> +       struct rtnl_link_stats64 *stats = &priv->stats;
> +
> +       /* OK packets and bytes. */
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RXOKPKT, &stats->rx_packets);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_TXOKPKT, &stats->tx_packets);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RXOKBYTE, &stats->rx_bytes);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_TXOKBYTE, &stats->tx_bytes);
> +
> +       /* RX & TX multicast. */
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RX_MULTI, &stats->multicast);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_TX_MULTI, &stats->multicast);
> +
> +       /* Collisions. */
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_TXPAUSECOL, &stats->collisions);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_TX_LATECOL, &stats->collisions);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RXRUNT, &stats->collisions);
> +
> +       /* RX Errors. */
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RX_LENGTHERR,
> +                           &stats->rx_length_errors);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RXLONG, &stats->rx_over_errors);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RXCRC, &stats->rx_crc_errors);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RX_ALIGNERR,
> +                           &stats->rx_frame_errors);
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RXDROP, &stats->rx_fifo_errors);
> +       /* Sum of the general RX error counter + all of the above. */
> +       mtk_mac_update_stat(priv, MTK_MAC_REG_C_RX_RERR, &stats->rx_errors);
> +       stats->rx_errors += stats->rx_length_errors;
> +       stats->rx_errors += stats->rx_over_errors;
> +       stats->rx_errors += stats->rx_crc_errors;
> +       stats->rx_errors += stats->rx_frame_errors;
> +       stats->rx_errors += stats->rx_fifo_errors;
> +}
> +
> +static struct sk_buff *mtk_mac_alloc_skb(struct net_device *ndev)
> +{
> +       uintptr_t tail, offset;
> +       struct sk_buff *skb;
> +
> +       skb = dev_alloc_skb(MTK_MAC_MAX_FRAME_SIZE);
> +       if (!skb)
> +               return NULL;
> +
> +       /* Align to 16 bytes. */
> +       tail = (uintptr_t)skb_tail_pointer(skb);
> +       if (tail & (MTK_MAC_SKB_ALIGNMENT - 1)) {
> +               offset = tail & (MTK_MAC_SKB_ALIGNMENT - 1);
> +               skb_reserve(skb, MTK_MAC_SKB_ALIGNMENT - offset);
> +       }
> +
> +       /* Ensure 16-byte alignment of the skb pointer: eth_type_trans() will
> +        * extract the Ethernet header (14 bytes) so we need two more bytes.
> +        */
> +       skb_reserve(skb, 2);
> +
> +       return skb;
> +}
> +
> +static int mtk_mac_prepare_rx_skbs(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct mtk_mac_ring *ring = &priv->rx_ring;
> +       struct device *dev = mtk_mac_get_dev(priv);
> +       struct mtk_mac_ring_desc *desc;
> +       struct sk_buff *skb;
> +       dma_addr_t dma_addr;
> +       int i;
> +
> +       for (i = 0; i < MTK_MAC_NUM_RX_DESCS; i++) {
> +               skb = mtk_mac_alloc_skb(ndev);
> +               if (!skb)
> +                       return -ENOMEM;
> +
> +               dma_addr = mtk_mac_dma_map_rx(priv, skb);
> +               if (dma_mapping_error(dev, dma_addr)) {
> +                       dev_kfree_skb(skb);
> +                       return -ENOMEM;
> +               }
> +
> +               desc = &ring->descs[i];
> +               desc->data_ptr = dma_addr;
> +               desc->status |= skb_tailroom(skb) & MTK_MAC_DESC_MSK_LEN;
> +               desc->status &= ~MTK_MAC_DESC_BIT_COWN;
> +               ring->skbs[i] = skb;
> +       }
> +
> +       ring->count = MTK_MAC_NUM_RX_DESCS;
> +
> +       return 0;
> +}
> +
> +/* All processing for TX and RX happens in the napi poll callback. */
> +static irqreturn_t mtk_mac_handle_irq(int irq, void *data)
> +{
> +       struct mtk_mac_priv *priv;
> +       struct net_device *ndev;
> +       unsigned int status;
> +
> +       ndev = data;
> +       priv = netdev_priv(ndev);
> +
> +       if (netif_running(ndev)) {
> +               mtk_mac_intr_mask_all(priv);
> +               status = mtk_mac_intr_read_and_clear(priv);
> +
> +               /* RX Complete */
> +               if (status & MTK_MAC_BIT_INT_STS_FNRC)
> +                       napi_schedule(&priv->napi);
> +
> +               /* TX Complete */
> +               if (status & MTK_MAC_BIT_INT_STS_TNTC)
> +                       schedule_work(&priv->tx_work);
> +
> +               /* One of the counter reached 0x8000000 */
> +               if (status & MTK_MAC_REG_INT_STS_MIB_CNT_TH) {
> +                       mtk_mac_update_stats(priv);
> +                       mtk_mac_reset_counters(priv);
> +               }
> +
> +               mtk_mac_intr_unmask_all(priv);
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void mtk_mac_free_rx_skbs(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct mtk_mac_ring *ring = &priv->rx_ring;
> +       struct mtk_mac_ring_desc_data desc_data;
> +       struct mtk_mac_ring_desc *desc;
> +       int i;
> +
> +       for (i = 0; i < MTK_MAC_NUM_RX_DESCS; i++) {
> +               desc = &ring->descs[i];
> +
> +               if (!desc->data_ptr)
> +                       continue;
> +
> +               desc_data.dma_addr = desc->data_ptr;
> +               desc_data.skb = ring->skbs[i];
> +
> +               mtk_mac_dma_unmap_rx(priv, &desc_data);
> +               dev_kfree_skb(desc_data.skb);
> +       }
> +}
> +
> +static void mtk_mac_free_tx_skbs(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct mtk_mac_ring_desc_data desc_data;
> +       struct mtk_mac_ring_desc *desc;
> +       int i;
> +
> +       for (i = 0; i < MTK_MAC_NUM_TX_DESCS; i++) {
> +               desc = &ring->descs[i];
> +
> +               if (!desc->data_ptr)
> +                       continue;
> +
> +               desc_data.dma_addr = desc->data_ptr;
> +               desc_data.len = desc->status & MTK_MAC_DESC_MSK_LEN;
> +               desc_data.skb = ring->skbs[i];
> +
> +               mtk_mac_dma_unmap_tx(priv, &desc_data);
> +               dev_kfree_skb(desc_data.skb);
> +       }
> +}
> +
> +static void mtk_mac_phy_config(struct mtk_mac_priv *priv)
> +{
> +       unsigned int val;
> +
> +       if (priv->speed == SPEED_1000)
> +               val = MTK_MAC_VAL_PHY_CTRL1_FORCE_SPD_1000M;
> +       else if (priv->speed == SPEED_100)
> +               val = MTK_MAC_VAL_PHY_CTRL1_FORCE_SPD_100M;
> +       else
> +               val = MTK_MAC_VAL_PHY_CTRL1_FORCE_SPD_10M;
> +       val <<= MTK_MAC_OFF_PHY_CTRL1_FORCE_SPD;
> +
> +       val |= MTK_MAC_BIT_PHY_CTRL1_AN_EN;
> +       val |= MTK_MAC_BIT_PHY_CTRL1_FORCE_FC_RX;
> +       val |= MTK_MAC_BIT_PHY_CTRL1_FORCE_FC_TX;
> +       /* Only full-duplex supported for now. */
> +       val |= MTK_MAC_BIT_PHY_CTRL1_FORCE_DPX;
> +
> +       regmap_write(priv->regs, MTK_MAC_REG_PHY_CTRL1, val);
> +}
> +
> +static void mtk_mac_adjust_link(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct phy_device *phydev = priv->phydev;
> +       bool new_state = false;
> +
> +       if (phydev->link) {
> +               if (!priv->link) {
> +                       priv->link = phydev->link;
> +                       new_state = true;
> +               }
> +
> +               if (priv->speed != phydev->speed) {
> +                       priv->speed = phydev->speed;
> +                       new_state = true;
> +               }
> +       } else {
> +               if (priv->link) {
> +                       priv->link = phydev->link;
> +                       new_state = true;
> +               }
> +       }
> +
> +       if (new_state) {
> +               if (phydev->link)
> +                       mtk_mac_phy_config(priv);
> +               phy_print_status(ndev->phydev);
> +       }
> +}
> +
> +static void mtk_mac_init_config(struct mtk_mac_priv *priv)
> +{
> +       unsigned int val;
> +
> +       val = (MTK_MAC_BIT_MII_PAD_OUT_ENABLE |
> +              MTK_MAC_BIT_EXT_MDC_MODE |
> +              MTK_MAC_BIT_SWC_MII_MODE);
> +
> +       regmap_write(priv->regs, MTK_MAC_REG_SYS_CONF, val);
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_MAC_CLK_CONF,
> +                          MTK_MAC_MSK_MAC_CLK_CONF,
> +                          MTK_MAC_BIT_CLK_DIV_10);
> +}
> +
> +static void mtk_mac_set_mode_rmii(struct mtk_mac_priv *priv)
> +{
> +       regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG_CON,
> +                          MTK_PERICFG_MSK_NIC_CFG_CON_CFG_MII,
> +                          MTK_PERICFG_BIT_NIC_CFG_CON_RMII);
> +}
> +
> +static int mtk_mac_enable(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       unsigned int val;
> +       int ret;
> +
> +       mtk_mac_nic_disable_pd(priv);
> +       mtk_mac_intr_mask_all(priv);
> +       mtk_mac_dma_stop(priv);
> +       netif_carrier_off(ndev);
> +
> +       mtk_mac_set_mac_addr(ndev);
> +
> +       /* Configure the MAC */
> +       val = MTK_MAC_VAL_MAC_CFG_IPG_96BIT;
> +       val <<= MTK_MAC_OFF_MAC_CFG_IPG;
> +       val |= MTK_MAC_BIT_MAC_CFG_MAXLEN_1522;
> +       val |= MTK_MAC_BIT_MAC_CFG_AUTO_PAD;
> +       val |= MTK_MAC_BIT_MAC_CFG_CRC_STRIP;
> +       regmap_write(priv->regs, MTK_MAC_REG_MAC_CFG, val);
> +
> +       /* Configure flow control */
> +       val = MTK_MAC_VAL_FC_CFG_SEND_PAUSE_TH_2K;
> +       val <<= MTK_MAC_OFF_FC_CFG_SEND_PAUSE_TH;
> +       val |= MTK_MAC_BIT_FC_CFG_BP_EN;
> +       val |= MTK_MAC_BIT_FC_CFG_UC_PAUSE_DIR;
> +       regmap_write(priv->regs, MTK_MAC_REG_FC_CFG, val);
> +
> +       /* Set SEND_PAUSE_RLS to 1K */
> +       val = MTK_MAC_VAL_EXT_CFG_SND_PAUSE_RLS_1K;
> +       val <<= MTK_MAC_OFF_EXT_CFG_SND_PAUSE_RLS;
> +       regmap_write(priv->regs, MTK_MAC_REG_EXT_CFG, val);
> +
> +       /* Reset all counters */
> +       mtk_mac_reset_counters(priv);
> +
> +       /* Enable Hash Table BIST and reset it */
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_HASH_CTRL,
> +                          MTK_MAC_BIT_HASH_CTRL_BIST_EN,
> +                          MTK_MAC_BIT_HASH_CTRL_BIST_EN);
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_TEST1,
> +                          MTK_MAC_BIT_TEST1_RST_HASH_MBIST,
> +                          MTK_MAC_BIT_TEST1_RST_HASH_MBIST);
> +
> +       /* Setup the hashing algorithm */
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_ARL_CFG,
> +                          MTK_MAC_BIT_ARL_CFG_HASH_ALG |
> +                          MTK_MAC_BIT_ARL_CFG_MISC_MODE, 0);
> +
> +       /* Don't strip VLAN tags */
> +       regmap_update_bits(priv->regs, MTK_MAC_REG_MAC_CFG,
> +                          MTK_MAC_BIT_MAC_CFG_VLAN_STRIP, 0);
> +
> +       /* Setup DMA */
> +       mtk_mac_dma_init(priv);
> +
> +       ret = mtk_mac_prepare_rx_skbs(ndev);
> +       if (ret)
> +               goto err_out;
> +
> +       /* Request the interrupt */
> +       ret = request_irq(ndev->irq, mtk_mac_handle_irq,
> +                         IRQF_TRIGGER_FALLING, ndev->name, ndev);
> +       if (ret)
> +               goto err_free_skbs;
> +
> +       napi_enable(&priv->napi);
> +
> +       mtk_mac_intr_read_and_clear(priv);
> +       mtk_mac_intr_unmask_all(priv);
> +
> +       /* Connect to and start PHY */
> +       priv->phydev = of_phy_connect(ndev, priv->phy_node,
> +                                     mtk_mac_adjust_link, 0, priv->phy_intf);
> +       if (!priv->phydev) {
> +               netdev_err(ndev, "failed to connect to PHY\n");
> +               goto err_free_irq;
> +       }
> +
> +       mtk_mac_dma_start(priv);
> +       phy_start(priv->phydev);
> +       netif_start_queue(ndev);
> +
> +       return 0;
> +
> +err_free_irq:
> +       free_irq(ndev->irq, ndev);
> +err_free_skbs:
> +       mtk_mac_free_rx_skbs(ndev);
> +err_out:
> +       return ret;
> +}
> +
> +static void mtk_mac_disable(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +
> +       netif_stop_queue(ndev);
> +       napi_disable(&priv->napi);
> +       mtk_mac_intr_mask_all(priv);
> +       mtk_mac_dma_disable(priv);
> +       mtk_mac_intr_read_and_clear(priv);
> +       phy_stop(priv->phydev);
> +       phy_disconnect(priv->phydev);
> +       free_irq(ndev->irq, ndev);
> +       mtk_mac_free_rx_skbs(ndev);
> +       mtk_mac_free_tx_skbs(ndev);
> +}
> +
> +static int mtk_mac_netdev_open(struct net_device *ndev)
> +{
> +       return mtk_mac_enable(ndev);
> +}
> +
> +static int mtk_mac_netdev_stop(struct net_device *ndev)
> +{
> +       mtk_mac_disable(ndev);
> +
> +       return 0;
> +}
> +
> +static int mtk_mac_netdev_ioctl(struct net_device *ndev,
> +                               struct ifreq *req, int cmd)
> +{
> +       if (!netif_running(ndev))
> +               return -EINVAL;
> +
> +       return phy_mii_ioctl(ndev->phydev, req, cmd);
> +}
> +
> +static int mtk_mac_netdev_start_xmit(struct sk_buff *skb,
> +                                    struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct device *dev = mtk_mac_get_dev(priv);
> +       struct mtk_mac_ring_desc_data desc_data;
> +
> +       if (skb->len > MTK_MAC_MAX_FRAME_SIZE)
> +               goto err_drop_packet;
> +
> +       desc_data.dma_addr = mtk_mac_dma_map_tx(priv, skb);
> +       if (dma_mapping_error(dev, desc_data.dma_addr))
> +               goto err_drop_packet;
> +
> +       desc_data.skb = skb;
> +       desc_data.len = skb->len;
> +
> +       mtk_mac_lock(priv);
> +       mtk_mac_ring_push_head_tx(ring, &desc_data);
> +
> +       if (mtk_mac_ring_full(ring))
> +               netif_stop_queue(ndev);
> +       mtk_mac_unlock(priv);
> +
> +       mtk_mac_dma_resume_tx(priv);
> +
> +       return NETDEV_TX_OK;
> +
> +err_drop_packet:
> +       dev_kfree_skb(skb);
> +       ndev->stats.tx_dropped++;
> +       return NETDEV_TX_BUSY;
> +}
> +
> +static int mtk_mac_tx_complete(struct mtk_mac_priv *priv)
> +{
> +       struct mtk_mac_ring *ring = &priv->tx_ring;
> +       struct mtk_mac_ring_desc_data desc_data;
> +       int ret;
> +
> +       ret = mtk_mac_ring_pop_tail(ring, &desc_data);
> +       if (ret)
> +               return ret;
> +
> +       mtk_mac_dma_unmap_tx(priv, &desc_data);
> +       dev_kfree_skb_irq(desc_data.skb);
> +
> +       return 0;
> +}
> +
> +static void mtk_mac_tx_work(struct work_struct *work)
> +{
> +       struct mtk_mac_priv *priv;
> +       struct mtk_mac_ring *ring;
> +       struct net_device *ndev;
> +       bool wake = false;
> +       int ret;
> +
> +       priv = container_of(work, struct mtk_mac_priv, tx_work);
> +       ndev = mtk_mac_get_netdev(priv);
> +       ring = &priv->tx_ring;
> +
> +       for (;;) {
> +               mtk_mac_lock(priv);
> +
> +               if (!mtk_mac_ring_descs_available(ring)) {
> +                       mtk_mac_unlock(priv);
> +                       break;
> +               }
> +
> +               ret = mtk_mac_tx_complete(priv);
> +               mtk_mac_unlock(priv);
> +               if (ret)
> +                       break;
> +
> +               wake = true;
> +       }
> +
> +       if (wake)
> +               netif_wake_queue(ndev);
> +}
> +
> +static void mtk_mac_netdev_get_stats64(struct net_device *ndev,
> +                                      struct rtnl_link_stats64 *stats)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +
> +       mtk_mac_update_stats(priv);
> +
> +       memcpy(stats, &priv->stats, sizeof(*stats));
> +}
> +
> +static void mtk_mac_set_hashbit(struct mtk_mac_priv *priv,
> +                               unsigned int hash_addr)
> +{
> +       unsigned int val;
> +
> +       val = hash_addr & MTK_MAC_MSK_HASH_CTRL_HASH_BIT_ADDR;
> +       val |= MTK_MAC_BIT_HASH_CTRL_ACC_CMD;
> +       val |= MTK_MAC_BIT_HASH_CTRL_CMD_START;
> +       val |= MTK_MAC_BIT_HASH_CTRL_BIST_EN;
> +       val |= MTK_MAC_BIT_HASH_CTRL_HASH_BIT_DATA;
> +
> +       regmap_write(priv->regs, MTK_MAC_REG_HASH_CTRL, val);
> +}
> +
> +static void mtk_mac_set_rx_mode(struct net_device *ndev)
> +{
> +       struct mtk_mac_priv *priv = netdev_priv(ndev);
> +       struct netdev_hw_addr *hw_addr;
> +       unsigned int hash_addr, i;
> +
> +       if (ndev->flags & IFF_PROMISC) {
> +               regmap_update_bits(priv->regs, MTK_MAC_REG_ARL_CFG,
> +                                  MTK_MAC_BIT_ARL_CFG_MISC_MODE,
> +                                  MTK_MAC_BIT_ARL_CFG_MISC_MODE);
> +       } else if (netdev_mc_count(ndev) > MTK_MAC_HASHTABLE_MC_LIMIT ||
> +                  ndev->flags & IFF_ALLMULTI) {
> +               for (i = 0; i < MTK_MAC_HASHTABLE_SIZE_MAX; i++)
> +                       mtk_mac_set_hashbit(priv, i);
> +       } else {
> +               netdev_for_each_mc_addr(hw_addr, ndev) {
> +                       hash_addr = (hw_addr->addr[0] & 0x01) << 8;
> +                       hash_addr += hw_addr->addr[5];
> +                       mtk_mac_set_hashbit(priv, hash_addr);
> +               }
> +       }
> +}
> +
> +static const struct net_device_ops mtk_mac_netdev_ops = {
> +       .ndo_open               = mtk_mac_netdev_open,
> +       .ndo_stop               = mtk_mac_netdev_stop,
> +       .ndo_start_xmit         = mtk_mac_netdev_start_xmit,
> +       .ndo_get_stats64        = mtk_mac_netdev_get_stats64,
> +       .ndo_set_rx_mode        = mtk_mac_set_rx_mode,
> +       .ndo_do_ioctl           = mtk_mac_netdev_ioctl,
> +       .ndo_set_mac_address    = eth_mac_addr,
> +       .ndo_validate_addr      = eth_validate_addr,
> +};
> +
> +static void mtk_mac_get_drvinfo(struct net_device *dev,
> +                               struct ethtool_drvinfo *info)
> +{
> +       strlcpy(info->driver, MTK_MAC_DRVNAME, sizeof(info->driver));
> +       strlcpy(info->version, MTK_MAC_VERSION, sizeof(info->version));

And this line should be removed too.

Thanks

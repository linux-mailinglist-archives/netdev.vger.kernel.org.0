Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A73637720
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiKXLGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiKXLGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:06:42 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A5B5C0FC;
        Thu, 24 Nov 2022 03:06:40 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id CAA9E6602B26;
        Thu, 24 Nov 2022 11:06:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1669287998;
        bh=EAdJ8/Ctvli+18UrOl71S8MZLWWHbw1S0aNFi8PNlrI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=n78Ei8tpmc9P51fFKKo+xA6eTdu7aZsmZXGfLvF5EnX7tsx1OlZNqFA8/b7Wfuq5e
         d9fzF/CirGRNAlU6EfpZGJX/JKw2rsxmCsVJC83h7lmiJjIk+LAtekHWGtIM+ECcbJ
         ms+e7JsY6jEosoH2DmAXK3UX1AqQy4U08T5HbxqFTQ9qKZ1GwTrQoHBESEBydHUpGt
         xMvNUmSfalbcCUzFBEgVb1TxwXQ67hjDVmWaXz22w2XTkRPQzwfnwD4GmS5bRSpcgh
         KIZVapy7Y4fj36iCKYo7BwGXZXko4c3u49al1thgnaQkwABzsfzO67tjUYTPyW/m3Q
         8KeyNLcz+YoNA==
Message-ID: <1cca2790-5805-b4fc-f8e8-2c490db487f6@collabora.com>
Date:   Thu, 24 Nov 2022 12:06:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v1 01/13] net: wwan: tmi: Add PCIe core
Content-Language: en-US
To:     Yanchao Yang <yanchao.yang@mediatek.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
Cc:     MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>,
        MediaTek Corporation <linuxwwan@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
 <20221122111152.160377-2-yanchao.yang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221122111152.160377-2-yanchao.yang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 22/11/22 12:11, Yanchao Yang ha scritto:
> From: MediaTek Corporation <linuxwwan@mediatek.com>
> 
> Registers the TMI device driver with the kernel. Set up all the fundamental
> configurations for the device: PCIe layer, Modem Host Cross Core Interface
> (MHCCIF), Reset Generation Unit (RGU), modem common control operations and
> build infrastructure.
> 
> * PCIe layer code implements driver probe and removal, MSI-X interrupt
> initialization and de-initialization, and the way of resetting the device.
> * MHCCIF provides interrupt channels to communicate events such as handshake,
> PM and port enumeration.
> * RGU provides interrupt channels to generate notifications from the device
> so that the TMI driver could get the device reset.
> * Modem common control operations provide the basic read/write functions of
> the device's hardware registers, mask/unmask/get/clear functions of the
> device's interrupt registers and inquiry functions of the device's status.
> 
> Signed-off-by: Ting Wang <ting.wang@mediatek.com>
> Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>

Hello Yanchao,
thanks for the patch! However, there are some things to improve...

First of all, you have to signoff (in your name) all patches that you send.
Check below for more comments...

> ---
>   drivers/net/wwan/Kconfig                 |   11 +
>   drivers/net/wwan/Makefile                |    1 +
>   drivers/net/wwan/mediatek/Makefile       |   12 +
>   drivers/net/wwan/mediatek/mtk_common.h   |   30 +
>   drivers/net/wwan/mediatek/mtk_dev.c      |   50 +
>   drivers/net/wwan/mediatek/mtk_dev.h      |  503 ++++++++++
>   drivers/net/wwan/mediatek/pcie/mtk_pci.c | 1164 ++++++++++++++++++++++
>   drivers/net/wwan/mediatek/pcie/mtk_pci.h |  150 +++
>   drivers/net/wwan/mediatek/pcie/mtk_reg.h |   69 ++
>   9 files changed, 1990 insertions(+)
>   create mode 100644 drivers/net/wwan/mediatek/Makefile
>   create mode 100644 drivers/net/wwan/mediatek/mtk_common.h
>   create mode 100644 drivers/net/wwan/mediatek/mtk_dev.c
>   create mode 100644 drivers/net/wwan/mediatek/mtk_dev.h
>   create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.c
>   create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.h
>   create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_reg.h
> 


> diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> index 3960c0ae2445..198d8074851f 100644
> --- a/drivers/net/wwan/Makefile
> +++ b/drivers/net/wwan/Makefile
> @@ -14,3 +14,4 @@ obj-$(CONFIG_QCOM_BAM_DMUX) += qcom_bam_dmux.o
>   obj-$(CONFIG_RPMSG_WWAN_CTRL) += rpmsg_wwan_ctrl.o
>   obj-$(CONFIG_IOSM) += iosm/
>   obj-$(CONFIG_MTK_T7XX) += t7xx/
> +obj-$(CONFIG_MTK_TMI) += mediatek/
> diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
> new file mode 100644
> index 000000000000..ae5f8a5ba05a
> --- /dev/null
> +++ b/drivers/net/wwan/mediatek/Makefile
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: BSD-3-Clause-Clear
> +
> +MODULE_NAME := mtk_tmi
> +
> +mtk_tmi-y = \
> +	pcie/mtk_pci.o	\
> +	mtk_dev.o
> +
> +ccflags-y += -I$(srctree)/$(src)/
> +ccflags-y += -I$(srctree)/$(src)/pcie/
> +
> +obj-$(CONFIG_MTK_TMI) += mtk_tmi.o
> diff --git a/drivers/net/wwan/mediatek/mtk_common.h b/drivers/net/wwan/mediatek/mtk_common.h
> new file mode 100644
> index 000000000000..516d3d9e02cf
> --- /dev/null
> +++ b/drivers/net/wwan/mediatek/mtk_common.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: BSD-3-Clause-Clear
> + *
> + * Copyright (c) 2022, MediaTek Inc.
> + */
> +
> +#ifndef _MTK_COMMON_H
> +#define _MTK_COMMON_H
> +
> +#include <linux/device.h>
> +
> +#define MTK_UEVENT_INFO_LEN 128
> +
> +/* MTK uevent */
> +enum mtk_uevent_id {
> +	MTK_UEVENT_FSM = 1,
> +	MTK_UEVENT_MAX
> +};
> +
> +static inline void mtk_uevent_notify(struct device *dev, enum mtk_uevent_id id, const char *info)
> +{
> +	char buf[MTK_UEVENT_INFO_LEN];
> +	char *ext[2] = {NULL, NULL};
> +
> +	snprintf(buf, MTK_UEVENT_INFO_LEN, "%s:event_id=%d, info=%s",
> +		 dev->kobj.name, id, info);
> +	ext[0] = buf;
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, ext);
> +}
> +
> +#endif /* _MTK_COMMON_H */
> diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
> new file mode 100644
> index 000000000000..d3d7bf940d78
> --- /dev/null
> +++ b/drivers/net/wwan/mediatek/mtk_dev.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: BSD-3-Clause-Clear
> +/*
> + * Copyright (c) 2022, MediaTek Inc.
> + */
> +
> +#include "mtk_dev.h"
> +
> +int mtk_dev_init(struct mtk_md_dev *mdev)

Empty function: not needed.

I know that you're actually populating this one later, but each commit
must be fine, so please introduce this function in a later commit, where
you actually make use of it.

> +{
> +	return 0;
> +}
> +
> +void mtk_dev_exit(struct mtk_md_dev *mdev)
> +{

Same here.

> +}
> +
> +int mtk_dev_start(struct mtk_md_dev *mdev)
> +{

And same here, and for the remaining two functions in this file.

> +	return 0;
> +}
> +
> +int mtk_dma_map_single(struct mtk_md_dev *mdev, dma_addr_t *addr,
> +		       void *mem, size_t size, int direction)
> +{
> +	if (!addr)
> +		return -EINVAL;

Further comments on this one: you're not doing anything MediaTek specific here.
You're only doing

> +
> +	*addr = dma_map_single(mdev->dev, mem, size, direction);
> +	if (unlikely(dma_mapping_error(mdev->dev, *addr))) {
> +		dev_err(mdev->dev, "Failed to map dma!\n");
> +		return -ENOMEM;

I know that dma_mapping_error() either returns -ENOMEM or zero, but you should
*not* assume that it won't ever change (even if that's very unlikely).

ret = dma_mapping_error(...);
if (unlikely(ret)) {
	dev_err(...)
	return ret;
}

return 0;


...also, I'm not sure that you really need this helper, but that's for another day.

> +	}
> +
> +	return 0;
> +}
> +
> +int mtk_dma_map_page(struct mtk_md_dev *mdev, dma_addr_t *addr,
> +		     struct page *page, unsigned long offset, size_t size, int direction)

Same comments as mtk_dma_map_single() here too.

> +{
> +	if (!addr)
> +		return -EINVAL;
> +
> +	*addr = dma_map_page(mdev->dev, page, offset, size, direction);
> +	if (unlikely(dma_mapping_error(mdev->dev, *addr))) {
> +		dev_err(mdev->dev, "Failed to map dma!\n");
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
> new file mode 100644
> index 000000000000..bd7b1dc11daf
> --- /dev/null
> +++ b/drivers/net/wwan/mediatek/mtk_dev.h
> @@ -0,0 +1,503 @@
> +/* SPDX-License-Identifier: BSD-3-Clause-Clear
> + *
> + * Copyright (c) 2022, MediaTek Inc.
> + */
> +
> +#ifndef __MTK_DEV_H__
> +#define __MTK_DEV_H__
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/dmapool.h>
> +
> +#define MTK_DEV_STR_LEN 16
> +
> +enum mtk_irq_src {
> +	MTK_IRQ_SRC_MIN,
> +	MTK_IRQ_SRC_MHCCIF,
> +	MTK_IRQ_SRC_SAP_RGU,
> +	MTK_IRQ_SRC_DPMAIF,
> +	MTK_IRQ_SRC_DPMAIF2,
> +	MTK_IRQ_SRC_CLDMA0,
> +	MTK_IRQ_SRC_CLDMA1,
> +	MTK_IRQ_SRC_CLDMA2,
> +	MTK_IRQ_SRC_CLDMA3,
> +	MTK_IRQ_SRC_PM_LOCK,
> +	MTK_IRQ_SRC_DPMAIF3,
> +	MTK_IRQ_SRC_MAX
> +};
> +
> +enum mtk_user_id {
> +	MTK_USER_HW,
> +	MTK_USER_CTRL,
> +	MTK_USER_DPMAIF,
> +	MTK_USER_PM,
> +	MTK_USER_EXCEPT,
> +	MTK_USER_MAX
> +};
> +
> +enum mtk_reset_type {
> +	RESET_FLDR,
> +	RESET_PLDR,
> +	RESET_RGU,
> +};
> +
> +enum mtk_reinit_type {
> +	REINIT_TYPE_RESUME,
> +	REINIT_TYPE_EXP,
> +};
> +
> +enum mtk_l1ss_grp {
> +	L1SS_PM,
> +	L1SS_EXT_EVT,
> +};
> +
> +#define L1SS_BIT_L1(grp)     BIT(((grp) << 2) + 1)
> +#define L1SS_BIT_L1_1(grp)   BIT(((grp) << 2) + 2)
> +#define L1SS_BIT_L1_2(grp)   BIT(((grp) << 2) + 3)
> +
> +struct mtk_md_dev;
> +
> +/* struct mtk_hw_ops - The HW layer operations provided to transaction layer.

That's good documentation. You should fix some indentation and, after that, you
should actually make it kerneldoc.

/**
  * struct mtk_hw_ops - ....
  * (etc)

https://docs.kernel.org/doc-guide/kernel-doc.html

> + * @read32:         Callback to read 32-bit register.
> + * @write32:        Callback to write 32-bit register.
> + * @get_dev_state:  Callback to get the device's state.
> + * @ack_dev_state:  Callback to acknowledge device state.
> + * @get_ds_status:  Callback to get device deep sleep status.
> + * @ds_lock:        Callback to lock the deep sleep of device.
> + * @ds_unlock:      Callback to unlock the deep sleep of device.
> + * @set_l1ss:       Callback to set the link L1 and L1ss enable/disable.
> + * @get_resume_state:Callback to get PM resume information that device writes.
> + * @get_irq_id:     Callback to get the irq id specific IP on a chip.
> + * @get_virq_id:     Callback to get the system virtual IRQ.
> + * @register_irq:   Callback to register callback function to specific hardware IP.
> + * @unregister_irq: Callback to unregister callback function to specific hardware IP.
> + * @mask_irq:       Callback to mask the interrupt of specific hardware IP.
> + * @unmask_irq:     Callback to unmask the interrupt of specific hardware IP.
> + * @clear_irq:      Callback to clear the interrupt of specific hardware IP.
> + * @register_ext_evt:Callback to register HW Layer external event.
> + * @unregister_ext_evt:Callback to unregister HW Layer external event.
> + * @mask_ext_evt:   Callback to mask HW Layer external event.
> + * @unmask_ext_evt: Callback to unmask HW Layer external event.
> + * @clear_ext_evt:  Callback to clear HW Layer external event status.
> + * @send_ext_evt:   Callback to send HW Layer external event.
> + * @get_ext_evt_status:Callback to get HW Layer external event status.
> + * @reset:          Callback to reset device.
> + * @reinit:         Callback to execute device re-initialization.
> + * @get_hp_status:  Callback to get link hotplug status.
> + */
> +struct mtk_hw_ops {
> +	/* Read value from MD. For PCIe, it's BAR 2/3 MMIO read */

Compress all these comments in the kerneldoc description: you either document
the members here inline, or up there.
I prefer up there.

> +	u32 (*read32)(struct mtk_md_dev *mdev, u64 addr);

..snip..

> +
> +/* mtk_md_dev defines the structure of MTK modem device */

This structure is already partially documented: it takes 2 minutes to finish
the documentation as kerneldoc. Please do that.

> +struct mtk_md_dev {
> +	struct device *dev;
> +	const struct mtk_hw_ops *hw_ops; /* The operations provided by hw layer */
> +	void *hw_priv;
> +	u32 hw_ver;
> +	int msi_nvecs;
> +	char dev_str[MTK_DEV_STR_LEN];
> +};
> +
> +int mtk_dev_init(struct mtk_md_dev *mdev);
> +void mtk_dev_exit(struct mtk_md_dev *mdev);
> +int mtk_dev_start(struct mtk_md_dev *mdev);
> +
> +/* mtk_hw_read32() -Read dword from register.

Same here and everywhere else, this won't get parsed by kerneldoc: please fix.

/**
  * mtk_hw_read32() - Read dword from register
  *
  * @mdev .....etc

> + *
> + * @mdev: Device instance.
> + * @addr: Register address.
> + *
> + * Return: Dword register value.
> + */
> +static inline u32 mtk_hw_read32(struct mtk_md_dev *mdev, u64 addr)
> +{
> +	return mdev->hw_ops->read32(mdev, addr);
> +}
> +

..snip..

> +static inline void *mtk_dma_alloc_coherent(struct mtk_md_dev *mdev,
> +					   size_t size, dma_addr_t *addr, gfp_t flag)
> +{
> +	if (addr)
> +		return dma_alloc_coherent(mdev->dev, size, addr, flag);
> +	return NULL;

You're not doing anything special here: drop this function.

> +}
> +
> +static inline int mtk_dma_free_coherent(struct mtk_md_dev *mdev,
> +					size_t size, void *cpu_addr, dma_addr_t addr)
> +{
> +	if (!addr)
> +		return -EINVAL;
> +	dma_free_coherent(mdev->dev, size, cpu_addr, addr);

Same here.

> +	return 0;
> +}
> +
> +static inline struct dma_pool *mtk_dma_pool_create(struct mtk_md_dev *mdev,
> +						   const char *name, size_t size,
> +						   size_t align, size_t allocation)
> +{
> +	return dma_pool_create(name, mdev->dev, size, align, allocation);

Ditto.

> +}
> +
> +static inline void mtk_dma_pool_destroy(struct dma_pool *pool)
> +{
> +	dma_pool_destroy(pool);

Again...

> +}
> +
> +static inline void *mtk_dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags, dma_addr_t *addr)
> +{
> +	if (!pool || !addr)
> +		return NULL;
> +	return dma_pool_zalloc(pool, mem_flags, addr);

...and again...

> +}
> +
> +static inline int mtk_dma_pool_free(struct dma_pool *pool, void *cpu_addr, dma_addr_t addr)
> +{
> +	if (!pool || !addr)
> +		return -EINVAL;
> +	dma_pool_free(pool, cpu_addr, addr);

...this too..

> +	return 0;
> +}
> +
> +int mtk_dma_map_single(struct mtk_md_dev *mdev, dma_addr_t *addr,
> +		       void *mem, size_t size, int direction);
> +static inline int mtk_dma_unmap_single(struct mtk_md_dev *mdev,
> +				       dma_addr_t addr, size_t size, int direction)
> +{
> +	if (!addr)
> +		return -EINVAL;
> +	dma_unmap_single(mdev->dev, addr, size, direction);

and this

> +	return 0;
> +}
> +
> +int mtk_dma_map_page(struct mtk_md_dev *mdev, dma_addr_t *addr,
> +		     struct page *page, unsigned long offset, size_t size, int direction);
> +static inline int mtk_dma_unmap_page(struct mtk_md_dev *mdev,
> +				     dma_addr_t addr, size_t size, int direction)
> +{
> +	if (!addr)
> +		return -EINVAL;
> +	dma_unmap_page(mdev->dev, addr, size, direction);

...and this.

> +	return 0;
> +}
> +
> +#endif /* __MTK_DEV_H__ */
> diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
> new file mode 100644
> index 000000000000..5be61178d30d
> --- /dev/null
> +++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
> @@ -0,0 +1,1164 @@
> +// SPDX-License-Identifier: BSD-3-Clause-Clear
> +/*
> + * Copyright (c) 2022, MediaTek Inc.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/aer.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include "mtk_pci.h"
> +#include "mtk_reg.h"
> +
> +#define MTK_PCI_TRANSPARENT_ATR_SIZE	(0x3F)
> +
> +/* This table records which bits of the interrupt status register each interrupt corresponds to
> + * when there are different numbers of msix interrupts.
> + */

Whenever >= 80 columns is possible, please use that boundary: it doesn't really
make a lot of sense to have a 96 columns comment.

/*
  * This table records which bits of the interrupt status register
  * corresponds to which interrupt when there are different numbers
  * of MSI-X interrupts.
  */

> +static const u32 mtk_msix_bits_map[MTK_IRQ_CNT_MAX / 2][5] = {
> +	{0xFFFFFFFF, 0x55555555, 0x11111111, 0x01010101, 0x00010001},
> +	{0x00000000, 0xAAAAAAAA, 0x22222222, 0x02020202, 0x00020002},
> +	{0x00000000, 0x00000000, 0x44444444, 0x04040404, 0x00040004},
> +	{0x00000000, 0x00000000, 0x88888888, 0x08080808, 0x00080008},
> +	{0x00000000, 0x00000000, 0x00000000, 0x10101010, 0x00100010},
> +	{0x00000000, 0x00000000, 0x00000000, 0x20202020, 0x00200020},
> +	{0x00000000, 0x00000000, 0x00000000, 0x40404040, 0x00400040},
> +	{0x00000000, 0x00000000, 0x00000000, 0x80808080, 0x00800080},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x01000100},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x02000200},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x04000400},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x08000800},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x10001000},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x20002000},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x40004000},
> +	{0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x80008000},
> +};
> +
> +static u32 mtk_pci_mac_read32(struct mtk_pci_priv *priv, u64 addr)
> +{
> +	return ioread32(priv->mac_reg_base + addr);
> +}
> +
> +static void mtk_pci_mac_write32(struct mtk_pci_priv *priv, u64 addr, u32 val)
> +{
> +	iowrite32(val, priv->mac_reg_base + addr);
> +}
> +
> +static void mtk_pci_set_msix_merged(struct mtk_pci_priv *priv, int irq_cnt)
> +{
> +	mtk_pci_mac_write32(priv, REG_PCIE_CFG_MSIX, ffs(irq_cnt) * 2 - 1);
> +}
> +
> +static int mtk_pci_setup_atr(struct mtk_md_dev *mdev, struct mtk_atr_cfg *cfg)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	u32 addr, val, size_h, size_l;
> +	int atr_size, pos, offset;
> +
> +	if (cfg->transparent) {
> +		atr_size = MTK_PCI_TRANSPARENT_ATR_SIZE; /* No address conversion is performed */
> +	} else {
> +		if (cfg->src_addr & (cfg->size - 1)) {
> +			dev_err(mdev->dev, "Invalid atr src addr is not aligned to size\n");
> +			return -EFAULT;
> +		}
> +		if (cfg->trsl_addr & (cfg->size - 1)) {
> +			dev_err(mdev->dev, "Invalid atr trsl addr is not aligned to size, %llx, %llx\n",
> +				cfg->trsl_addr, cfg->size - 1);
> +			return -EFAULT;
> +		}
> +
> +		size_l = cfg->size & 0xFFFFFFFF;

You're using bitfields a lot, please use the macros that you can find in
include/linux/bitfield.h - that will simplify things a lot, other than adding
a couple of build-time checks that will help sanitizing in case something is
horribly wrong (or becomes horribly wrong in the future).

size_l = FIELD_PREP(SOME_FIELD, cfg->size);

Whenever it does not make sense to use bitfield macros, you should anyway never
use magic numbers, and you should actually make use of other kernel provided
bit macros, such as GENMASK() and others (which you *are* using later).

> +		size_h = cfg->size >> 32;
> +		pos = ffs(size_l);
> +		if (pos) {
> +			/* Address Translate Space Size is equal to 2^(atr_size+1)
> +			 * "-2" means "-1-1", the first "-1" is because of the atr_size register,
> +			 * the second is because of the ffs() will increase by one.
> +			 */
> +			atr_size = pos - 2;
> +		} else {
> +			pos = ffs(size_h);
> +			/* "+30" means "+32-1-1", the meaning of "-1-1" is same as above,
> +			 * "+32" is because atr_size is large, exceeding 32-bits.
> +			 */
> +			atr_size = pos + 30;
> +		}
> +	}
> +
> +	/* Calculate table offset */
> +	offset = ATR_PORT_OFFSET * cfg->port + ATR_TABLE_OFFSET * cfg->table;
> +	/* SRC_ADDR_H */
> +	addr = REG_ATR_PCIE_WIN0_T0_SRC_ADDR_MSB + offset;
> +	val = (u32)(cfg->src_addr >> 32);
> +	mtk_pci_mac_write32(priv, addr, val);
> +	/* SRC_ADDR_L */
> +	addr = REG_ATR_PCIE_WIN0_T0_SRC_ADDR_LSB + offset;
> +	val = (u32)(cfg->src_addr & 0xFFFFF000) | (atr_size << 1) | 0x1;
> +	mtk_pci_mac_write32(priv, addr, val);
> +
> +	/* TRSL_ADDR_H */
> +	addr = REG_ATR_PCIE_WIN0_T0_TRSL_ADDR_MSB + offset;
> +	val = (u32)(cfg->trsl_addr >> 32);
> +	mtk_pci_mac_write32(priv, addr, val);
> +	/* TRSL_ADDR_L */
> +	addr = REG_ATR_PCIE_WIN0_T0_TRSL_ADDR_LSB + offset;
> +	val = (u32)(cfg->trsl_addr & 0xFFFFF000);
> +	mtk_pci_mac_write32(priv, addr, val);
> +
> +	/* TRSL_PARAM */
> +	addr = REG_ATR_PCIE_WIN0_T0_TRSL_PARAM + offset;
> +	val = (cfg->trsl_param << 16) | cfg->trsl_id;
> +	mtk_pci_mac_write32(priv, addr, val);
> +
> +	return 0;
> +}
> +

..snip..

> +
> +static int mtk_pci_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type type)
> +{
> +	struct pci_dev *pdev = to_pci_dev(mdev->dev);
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	int ret, ltr, l1ss;
> +
> +	/* restore ltr */
> +	ltr = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_LTR);
> +	if (ltr) {
> +		pci_write_config_word(pdev, ltr + PCI_LTR_MAX_SNOOP_LAT,
> +				      priv->ltr_max_snoop_lat);
> +		pci_write_config_word(pdev, ltr + PCI_LTR_MAX_NOSNOOP_LAT,
> +				      priv->ltr_max_nosnoop_lat);
> +	}
> +	/* restore l1ss */
> +	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
> +	if (l1ss) {
> +		pci_write_config_dword(pdev, l1ss + PCI_L1SS_CTL1, priv->l1ss_ctl1);
> +		pci_write_config_dword(pdev, l1ss + PCI_L1SS_CTL2, priv->l1ss_ctl2);
> +	}
> +
> +	ret = mtk_pci_atr_init(mdev);
> +	if (ret)
> +		return ret;
> +
> +	if (priv->irq_type == PCI_IRQ_MSIX) {
> +		if (priv->irq_cnt != MTK_IRQ_CNT_MAX)
> +			mtk_pci_set_msix_merged(priv, priv->irq_cnt);
> +	}
> +
> +	mtk_pci_unmask_irq(mdev, priv->rgu_irq_id);
> +	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
> +
> +	/* In L2 resume, device would disable PCIe interrupt,
> +	 * and this step would re-enable PCIe interrupt.
> +	 * For L3, just do this with no effect.
> +	 */
> +	if (type == REINIT_TYPE_RESUME)
> +		mtk_pci_mac_write32(priv, priv->cfg->istatus_host_ctrl_addr, 0);
> +
> +	dev_info(mdev->dev, "PCIe reinit type=%d\n", type);

I'm not sure that this message provides any valuable information to the user,
this should be a dev_dbg().

> +
> +	return 0;
> +}
> +

..snip..

> +
> +static void mtk_mhccif_isr_work(struct work_struct *work)
> +{
> +	struct mtk_pci_priv *priv = container_of(work, struct mtk_pci_priv, mhccif_work);
> +	struct mtk_md_dev *mdev = priv->irq_desc->mdev;
> +	struct mtk_mhccif_cb *cb;
> +	unsigned long flag;
> +	u32 stat, mask;
> +
> +	stat = mtk_mhccif_get_evt_status(mdev);
> +	mask = mtk_pci_read32(mdev, priv->cfg->mhccif_rc_base_addr
> +		+ MHCCIF_EP2RC_SW_INT_EAP_MASK);
> +	dev_info(mdev->dev, "External events: mhccif_stat=0x%08X mask=0x%08X\n", stat, mask);

This print is going to be a bit spammy... dev_dbg().

> +
> +	if (unlikely(stat == U32_MAX && mtk_pci_link_check(mdev))) {
> +		/* When link failed, we don't need to unmask/clear. */
> +		dev_err(mdev->dev, "Failed to check link in MHCCIF handler.\n");
> +		return;
> +	}
> +
> +	stat &= ~mask;
> +	spin_lock_irqsave(&priv->mhccif_lock, flag);
> +	list_for_each_entry(cb, &priv->mhccif_cb_list, entry) {
> +		if (cb->chs & stat)
> +			cb->evt_cb(cb->chs & stat, cb->data);
> +	}
> +	spin_unlock_irqrestore(&priv->mhccif_lock, flag);
> +
> +	mtk_pci_clear_irq(mdev, priv->mhccif_irq_id);
> +	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
> +}
> +

..snip..

> +
> +static int mtk_pci_request_irq(struct mtk_md_dev *mdev, int max_irq_cnt, int irq_type)
> +{
> +	struct pci_dev *pdev = to_pci_dev(mdev->dev);
> +	int irq_cnt;
> +	int ret;
> +
> +	irq_cnt = pci_alloc_irq_vectors(pdev, MTK_IRQ_CNT_MIN, max_irq_cnt, irq_type);
> +	mdev->msi_nvecs = irq_cnt;
> +
> +	if (irq_cnt < MTK_IRQ_CNT_MIN) {
> +		dev_err(mdev->dev,
> +			"Unable to alloc pci irq vectors. ret=%d maxirqcnt=%d irqtype=0x%x\n",
> +			irq_cnt, max_irq_cnt, irq_type);
> +		ret = -EFAULT;
> +		goto err;


		return -EFAULT;


> +	}
> +
> +	ret = mtk_pci_request_irq_msix(mdev, irq_cnt);


	return mtk_pci_request_irq_msix(dev, irq_cnt);
}


> +err:
> +	return ret;
> +}
> +

Regards,
Angelo


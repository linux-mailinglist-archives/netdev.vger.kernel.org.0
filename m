Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC8697558
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjBOEWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjBOEWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:22:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF275FCD;
        Tue, 14 Feb 2023 20:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8E1B81F10;
        Wed, 15 Feb 2023 04:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37D3C433EF;
        Wed, 15 Feb 2023 04:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676434951;
        bh=9RFklybEaUQCRSm7AZF4dRJ8fp78b9j9QQOI0bJxijE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEctVT6iKodBlNPJ0zxVNQBDmc3iFsxN95yWTc3BImSEQWweWMrywn73u8rI5J72p
         MbxIAn458iekfmfj7UlQ5SVm5IPhegUlUQvnhz2eb/rWjRTWvBdnofQZt/ZMKIy2Z0
         3GqaZQf71f/YVb90Hxj+LZK4y1hWD+z9JnOEE68C7D400pS+AVwWLwXnig46/EnAMh
         MJ7STrBJkQ+707WSc5xj9npwTCFzFNr1IBzbxIuyQHSF5mAYqxqRgGDyrXcImAUrsR
         ahnEBND8SY0WkdIjPZljIm8KTPIxH/9KzLguvvwLlLp7wImN5p8Ij2yGKZ04NT8FyM
         ylvyCyDGnH7sg==
Date:   Tue, 14 Feb 2023 20:22:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yanchao Yang <yanchao.yang@mediatek.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>,
        Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
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
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: Re: [PATCH net-next v3 01/10] net: wwan: tmi: Add PCIe core
Message-ID: <20230214202229.50d07b89@kernel.org>
In-Reply-To: <20230211083732.193650-2-yanchao.yang@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
        <20230211083732.193650-2-yanchao.yang@mediatek.com>
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

On Sat, 11 Feb 2023 16:37:23 +0800 Yanchao Yang wrote:
> +ccflags-y += -I$(srctree)/$(src)/
> +ccflags-y += -I$(srctree)/$(src)/pcie/

Do you really need these flags?

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

What is this for? It's not used in this patch.

> +static int mtk_mhccif_register_evt(struct mtk_md_dev *mdev, u32 chs,
> +				   int (*evt_cb)(u32 status, void *data), void *data)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	struct mtk_mhccif_cb *cb;
> +	unsigned long flag;
> +	int ret = 0;
> +
> +	if (!chs || !evt_cb)
> +		return -EINVAL;

avoid defensive programming

> +	spin_lock_irqsave(&priv->mhccif_lock, flag);
> +	list_for_each_entry(cb, &priv->mhccif_cb_list, entry) {
> +		if (cb->chs & chs) {
> +			ret = -EFAULT;
> +			dev_err(mdev->dev,
> +				"Unable to register evt, chs=0x%08X&0x%08X registered_cb=%ps\n",
> +				chs, cb->chs, cb->evt_cb);
> +			goto err;
> +		}
> +	}
> +	cb = devm_kzalloc(mdev->dev, sizeof(*cb), GFP_ATOMIC);
> +	if (!cb) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	cb->evt_cb = evt_cb;
> +	cb->data = data;
> +	cb->chs = chs;
> +	list_add_tail(&cb->entry, &priv->mhccif_cb_list);
> +
> +err:
> +	spin_unlock_irqrestore(&priv->mhccif_lock, flag);
> +
> +	return ret;
> +}
> +
> +static int mtk_mhccif_unregister_evt(struct mtk_md_dev *mdev, u32 chs)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	struct mtk_mhccif_cb *cb, *next;
> +	unsigned long flag;
> +	int ret = 0;
> +
> +	if (!chs)
> +		return -EINVAL;

avoid defensive programming

> +	spin_lock_irqsave(&priv->mhccif_lock, flag);
> +	list_for_each_entry_safe(cb, next, &priv->mhccif_cb_list, entry) {
> +		if (cb->chs == chs) {
> +			list_del(&cb->entry);
> +			devm_kfree(mdev->dev, cb);
> +			goto out;
> +		}
> +	}
> +	ret = -EFAULT;
> +	dev_warn(mdev->dev, "Unable to unregister evt, no chs=0x%08X has been registered.\n", chs);
> +out:
> +	spin_unlock_irqrestore(&priv->mhccif_lock, flag);
> +
> +	return ret;
> +}

> +static void mtk_mhccif_clear_evt(struct mtk_md_dev *mdev, u32 chs)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +
> +	mtk_pci_write32(mdev, priv->cfg->mhccif_rc_base_addr
> +		+ MHCCIF_EP2RC_SW_INT_ACK, chs);

+ goes at the end of the previous line, and the continuation line
should be aligned to (
Please fix everywhere.

> +}
> +
> +static int mtk_mhccif_send_evt(struct mtk_md_dev *mdev, u32 ch)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	u32 rc_base;
> +
> +	rc_base = priv->cfg->mhccif_rc_base_addr;
> +	/* Only allow one ch to be triggered at a time */
> +	if ((ch & (ch - 1)) || !ch) {

is_power_of_2() ?

> +		dev_err(mdev->dev, "Unsupported ext evt ch=0x%08X\n", ch);
> +		return -EINVAL;
> +	}
> +
> +	mtk_pci_write32(mdev, rc_base + MHCCIF_RC2EP_SW_BSY, ch);
> +	mtk_pci_write32(mdev, rc_base + MHCCIF_RC2EP_SW_TCHNUM, ffs(ch) - 1);
> +
> +	return 0;
> +}
> +
> +static u32 mtk_mhccif_get_evt_status(struct mtk_md_dev *mdev)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +
> +	return mtk_pci_read32(mdev, priv->cfg->mhccif_rc_base_addr + MHCCIF_EP2RC_SW_INT_STS);
> +}
> +
> +static int mtk_pci_acpi_reset(struct mtk_md_dev *mdev, char *fn_name)
> +{
> +#ifdef CONFIG_ACPI
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	acpi_status acpi_ret;
> +	acpi_handle handle;
> +	int ret = 0;
> +
> +	handle = ACPI_HANDLE(mdev->dev);
> +	if (!handle) {
> +		dev_err(mdev->dev, "Unsupported, acpi handle isn't found\n");
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +	if (!acpi_has_method(handle, fn_name)) {
> +		dev_err(mdev->dev, "Unsupported, _RST method isn't found\n");
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +	acpi_ret = acpi_evaluate_object(handle, fn_name, NULL, &buffer);
> +	if (ACPI_FAILURE(acpi_ret)) {
> +		dev_err(mdev->dev, "Failed to execute %s method: %s\n",
> +			fn_name,
> +			acpi_format_exception(acpi_ret));
> +		ret = -EFAULT;
> +		goto err;
> +	}
> +	dev_info(mdev->dev, "FLDR execute successfully\n");
> +	acpi_os_free(buffer.pointer);
> +err:
> +	return ret;
> +#else
> +	dev_err(mdev->dev, "Unsupported, CONFIG ACPI hasn't been set to 'y'\n");
> +	return -ENODEV;

If driver needs ACPI it should be a dependency in Kconfig.

> +#endif
> +}

> +static irqreturn_t mtk_pci_irq_msix(int irq, void *data)
> +{
> +	struct mtk_pci_irq_desc *irq_desc = data;
> +	struct mtk_md_dev *mdev = irq_desc->mdev;
> +	struct mtk_pci_priv *priv;
> +	u32 irq_state, irq_enable;
> +
> +	priv = mdev->hw_priv;
> +	irq_state = mtk_pci_mac_read32(priv, REG_MSIX_ISTATUS_HOST_GRP0_0);
> +	irq_enable = mtk_pci_mac_read32(priv, REG_IMASK_HOST_MSIX_GRP0_0);
> +	dev_dbg(mdev->dev, "irq_state=0x%08X, irq_enable=0x%08X, msix_bits=0x%08X\n",
> +		irq_state, irq_enable, irq_desc->msix_bits);
> +	irq_state &= irq_enable;
> +
> +	if (unlikely(!irq_state) ||
> +	    unlikely(!((irq_state % GENMASK(priv->irq_cnt - 1, 0)) & irq_desc->msix_bits)))

Are you sure the modulo is correct here?

> +		return IRQ_NONE;
> +
> +	/* Mask the bit and user needs to unmask by itself */
> +	mtk_pci_mac_write32(priv, REG_IMASK_HOST_MSIX_CLR_GRP0_0, irq_state & (~BIT(30)));

parenthesis unnecessary

> +
> +	return mtk_pci_irq_handler(mdev, irq_state);
> +}
> +
> +static int mtk_pci_request_irq_msix(struct mtk_md_dev *mdev, int irq_cnt_allocated)
> +{
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	struct mtk_pci_irq_desc *irq_desc;
> +	struct pci_dev *pdev;
> +	int irq_cnt;
> +	int ret, i;
> +
> +	/* calculate the nearest 2's power number */
> +	irq_cnt = BIT(fls(irq_cnt_allocated) - 1);
> +	pdev = to_pci_dev(mdev->dev);
> +	irq_desc = priv->irq_desc;
> +	for (i = 0; i < irq_cnt; i++) {
> +		irq_desc[i].mdev = mdev;
> +		irq_desc[i].msix_bits = BIT(i);
> +		snprintf(irq_desc[i].name, MTK_IRQ_NAME_LEN, "msix%d-%s", i, mdev->dev_str);

please use pci_name() instead of your custom format stored in dev_str.

> +		ret = pci_request_irq(pdev, i, mtk_pci_irq_msix, NULL,
> +				      &irq_desc[i], irq_desc[i].name);
> +		if (ret) {
> +			dev_err(mdev->dev, "Failed to request %s: ret=%d\n", irq_desc[i].name, ret);
> +			for (i--; i >= 0; i--)
> +				pci_free_irq(pdev, i, &irq_desc[i]);
> +			return ret;
> +		}
> +	}
> +	priv->irq_cnt = irq_cnt;
> +	priv->irq_type = PCI_IRQ_MSIX;
> +
> +	if (irq_cnt != MTK_IRQ_CNT_MAX)
> +		mtk_pci_set_msix_merged(priv, irq_cnt);
> +
> +	return 0;
> +}
> +
> +static int mtk_pci_request_irq(struct mtk_md_dev *mdev, int max_irq_cnt, int irq_type)

irq_type is always PCI_IRQ_MSIX in this series
and max_irq_cnt is MTK_IRQ_CNT_MAX. Use those directly.

> +{
> +	struct pci_dev *pdev = to_pci_dev(mdev->dev);
> +	int irq_cnt;
> +
> +	irq_cnt = pci_alloc_irq_vectors(pdev, MTK_IRQ_CNT_MIN, max_irq_cnt, irq_type);
> +	mdev->msi_nvecs = irq_cnt;
> +
> +	if (irq_cnt < MTK_IRQ_CNT_MIN) {
> +		dev_err(mdev->dev,
> +			"Unable to alloc pci irq vectors. ret=%d maxirqcnt=%d irqtype=0x%x\n",
> +			irq_cnt, max_irq_cnt, irq_type);
> +		return -EFAULT;
> +	}
> +
> +	return mtk_pci_request_irq_msix(mdev, irq_cnt);
> +}
> +
> +static void mtk_pci_free_irq(struct mtk_md_dev *mdev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(mdev->dev);
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	int i;
> +
> +	for (i = 0; i < priv->irq_cnt; i++)
> +		pci_free_irq(pdev, i, &priv->irq_desc[i]);
> +
> +	pci_free_irq_vectors(pdev);
> +}
> +
> +static void mtk_pci_save_state(struct mtk_md_dev *mdev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(mdev->dev);
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	int ltr, l1ss;
> +
> +	pci_save_state(pdev);
> +	/* save ltr */
> +	ltr = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_LTR);
> +	if (ltr) {
> +		pci_read_config_word(pdev, ltr + PCI_LTR_MAX_SNOOP_LAT,
> +				     &priv->ltr_max_snoop_lat);
> +		pci_read_config_word(pdev, ltr + PCI_LTR_MAX_NOSNOOP_LAT,
> +				     &priv->ltr_max_nosnoop_lat);
> +	}
> +	/* save l1ss */
> +	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
> +	if (l1ss) {
> +		pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &priv->l1ss_ctl1);
> +		pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL2, &priv->l1ss_ctl2);
> +	}
> +}

> +	dev_info(mdev->dev, "Probe done hw_ver=0x%x\n", mdev->hw_ver);
> +	return 0;
> +
> +err_save_state:

Labels should be named after action they perform, not where they jump
from. Please fix this everywhere.

> +	pci_disable_pcie_error_reporting(pdev);
> +	pci_clear_master(pdev);
> +	mtk_pci_free_irq(mdev);
> +err_request_irq:
> +	mtk_mhccif_exit(mdev);
> +err_mhccif_init:
> +err_atr_init:
> +	mtk_pci_bar_exit(mdev);
> +err_bar_init:
> +err_set_dma_mask:
> +	pci_disable_device(pdev);
> +err_enable_pdev:
> +	devm_kfree(dev, priv);
> +err_alloc_priv:
> +	devm_kfree(dev, mdev);
> +err_alloc_mdev:
> +	dev_err(dev, "Failed to probe device, ret=%d\n", ret);

I believe core already prints this sort of a message. 
Please double check.

> +	return ret;
> +}
> +
> +static void mtk_pci_remove(struct pci_dev *pdev)
> +{
> +	struct mtk_md_dev *mdev = pci_get_drvdata(pdev);
> +	struct mtk_pci_priv *priv = mdev->hw_priv;
> +	struct device *dev = &pdev->dev;
> +	int ret;
> +
> +	mtk_pci_mask_irq(mdev, priv->mhccif_irq_id);
> +	pci_disable_pcie_error_reporting(pdev);

The explicit error reporting calls should be removed, please 
see f26e58bf6f54

> +	ret = mtk_pci_fldr(mdev);
> +	if (ret)
> +		mtk_mhccif_send_evt(mdev, EXT_EVT_H2D_DEVICE_RESET);
> +
> +	pci_clear_master(pdev);
> +	mtk_mhccif_exit(mdev);
> +	mtk_pci_free_irq(mdev);
> +	mtk_pci_bar_exit(mdev);
> +	pci_disable_device(pdev);
> +	pci_load_and_free_saved_state(pdev, &priv->saved_state);
> +	devm_kfree(dev, priv);
> +	devm_kfree(dev, mdev);

Why are you using devm_ if you call kfree explicitly anyway?
You can save some memory by using kfree() directly.

> +	u16 ltr_max_snoop_lat;
> +	u16 ltr_max_nosnoop_lat;
> +	u32 l1ss_ctl1;
> +	u32 l1ss_ctl2;

These 4 registers seem to be saved but never used.

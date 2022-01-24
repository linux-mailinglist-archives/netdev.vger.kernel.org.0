Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B944982B7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 15:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiAXOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 09:52:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:11372 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238118AbiAXOwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 09:52:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643035930; x=1674571930;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Em+uDtFQ1xy+UJ1YWOUziKlxo/BAsUhdsUWFlqz2R20=;
  b=XCpez04LvBEW+1w3sqwCN8RfAbSCZhXGy+KUWblPcmxTmgLws2a65KI1
   EIag949o4saAqwBsG684p5cDiJlIBD3h7lRFG1gxdqZ2sBeo1vxo5We6p
   Vons7YCgBZNa1qwo+xm6xv+pE7YGBaPKrLW3qjkkAjPHD6rIdgdqlNM2F
   WqCSFG18rWaaSHCw6Ch2SBK3RaIUxwBaBP6drxWERclWZbSwz4queijCq
   xfYd2gbrKPQxDxxz4OajVsA6u7hSEZ1AsQbIcuHdsec49cAauIJ216Tpn
   /ny8GB1gmro8VcE7IC0FjKb9C6cYTI2JnAzj2JGAwqyi0l7l6mZ9/mXjN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="243657190"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="243657190"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:52:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="534250722"
Received: from tlauxx-mobl1.ger.corp.intel.com ([10.251.221.57])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:52:03 -0800
Date:   Mon, 24 Jan 2022 16:51:53 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 03/13] net: wwan: t7xx: Add core components
In-Reply-To: <20220114010627.21104-4-ricardo.martinez@linux.intel.com>
Message-ID: <21cc8585-9bad-2322-44c2-fc99c4dccda0@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-4-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
> 
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

Some states in t7xx_common.h (MD_STATE_...) would logically belong to this 
patch instead of 02/. ...I think they were initally here but got moved 
with t7xx_skb_data_area_size(). And there was also things clearly related 
to 05/ in t7xx_common.h (at least CTL_ID_*).

> +static irqreturn_t t7xx_mhccif_isr_thread(int irq, void *data)
> +{
> +	struct t7xx_pci_dev *t7xx_dev = data;
> +	u32 int_sts, val;
> +
> +	val = L1_1_DISABLE_BIT(1) | L1_2_DISABLE_BIT(1);
> +	iowrite32(val, IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
> +
> +	int_sts = t7xx_mhccif_read_sw_int_sts(t7xx_dev);
> +	if (int_sts & t7xx_dev->mhccif_bitmask)

hccif_bitmask is set to a constant value and used only in this one place.
I'd also spell out sts to status.

> +static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct t7xx_pci_dev *t7xx_dev;
> +	int ret;
> +
> +	t7xx_dev = devm_kzalloc(&pdev->dev, sizeof(*t7xx_dev), GFP_KERNEL);
> +	if (!t7xx_dev)
> +		return -ENOMEM;
> +
> +	pci_set_drvdata(pdev, t7xx_dev);
> +	t7xx_dev->pdev = pdev;
> +
> +	ret = pcim_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_set_master(pdev);
> +
> +	ret = pcim_iomap_regions(pdev, BIT(PCI_IREG_BASE) | BIT(PCI_EREG_BASE), pci_name(pdev));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not request BARs: %d\n", ret);
> +		return -ENOMEM;
> +	}
> +
> +	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not set PCI DMA mask: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not set consistent PCI DMA mask: %d\n", ret);
> +		return ret;
> +	}
> +
> +	IREG_BASE(t7xx_dev) = pcim_iomap_table(pdev)[PCI_IREG_BASE];
> +	t7xx_dev->base_addr.pcie_ext_reg_base = pcim_iomap_table(pdev)[PCI_EREG_BASE];
> +
> +	t7xx_pcie_mac_atr_init(t7xx_dev);
> +	t7xx_pci_infracfg_ao_calc(t7xx_dev);
> +	t7xx_mhccif_init(t7xx_dev);
> +
> +	ret = t7xx_md_init(t7xx_dev);
> +	if (ret)
> +		return ret;
> +
> +	t7xx_pcie_mac_interrupts_dis(t7xx_dev);
> +
> +	ret = t7xx_interrupt_init(t7xx_dev);
> +	if (ret)
> +		return ret;

Some leaks?

> +/**
> + * t7xx_pcie_mac_clear_set_int() - Clear/set interrupt by type.
> + * @t7xx_dev: MTK device.
> + * @int_type: Interrupt type.
> + * @clear: Clear/set.
> + *
> + * Clear or set device interrupt by type.
> + */
> +static void t7xx_pcie_mac_clear_set_int(struct t7xx_pci_dev *t7xx_dev,
> +					enum pcie_int int_type, bool clear)
> +{
> +	void __iomem *reg;
> +	u32 val;
> +
> +	if (t7xx_dev->pdev->msix_enabled) {
> +		if (clear)
> +			reg = IREG_BASE(t7xx_dev) + IMASK_HOST_MSIX_CLR_GRP0_0;
> +		else
> +			reg = IREG_BASE(t7xx_dev) + IMASK_HOST_MSIX_SET_GRP0_0;
> +	} else {
> +		if (clear)
> +			reg = IREG_BASE(t7xx_dev) + INT_EN_HST_CLR;
> +		else
> +			reg = IREG_BASE(t7xx_dev) + INT_EN_HST_SET;
> +	}
> +
> +	val = BIT(EXT_INT_START + int_type);
> +	iowrite32(val, reg);
> +}
> +
> +void t7xx_pcie_mac_clear_int(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type)
> +{
> +	t7xx_pcie_mac_clear_set_int(t7xx_dev, int_type, true);
> +}
> +
> +void t7xx_pcie_mac_set_int(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type)
> +{
> +	t7xx_pcie_mac_clear_set_int(t7xx_dev, int_type, false);
> +}

...

> +#define PCIE_MAC_MSIX_MSK_SET(t7xx_dev, ext_id)	\
> +	iowrite32(BIT(ext_id), IREG_BASE(t7xx_dev) + IMASK_HOST_MSIX_SET_GRP0_0)

A near duplicate of t7xx_pcie_mac_clear_set_int()/t7xx_pcie_mac_set_int()?

> +enum pcie_int {
> +	DPMAIF_INT = 0,
> +	CLDMA0_INT,
> +	CLDMA1_INT,
> +	CLDMA2_INT,
> +	MHCCIF_INT,
> +	DPMAIF2_INT,
> +	SAP_RGU_INT,
> +	CLDMA3_INT,
> +};

A bit too generic name for a driver specific enum?
There were also some PCIE_ starting defines you might want to take a look 
at.

> +static void fsm_wait_for_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id,
> +			       enum t7xx_fsm_event_state event_ignore, int timeout)
> +{
> +	struct t7xx_fsm_event *event;
> +	unsigned long flags;
> +	bool ackd = false;
> +	int cnt = 0;

int retries = timeout / FSM_EVENT_POLL_INTERVAL_MS;
(Or move that divide into caller which then gets optimized away by the 
compiler).

> +
> +	while (cnt++ < timeout / FSM_EVENT_POLL_INTERVAL_MS) {
> +		if (kthread_should_stop())
> +			return;
> +
> +		spin_lock_irqsave(&ctl->event_lock, flags);
> +		event = list_first_entry_or_null(&ctl->event_queue,
> +						 struct t7xx_fsm_event, entry);
> +		if (event) {
> +			if (event->event_id == event_ignore) {
> +				fsm_del_kf_event(event);
> +			} else if (event->event_id == event_id) {
> +				ackd = true;
> +				fsm_del_kf_event(event);
> +			}
> +		}
> +
> +		spin_unlock_irqrestore(&ctl->event_lock, flags);
> +		if (ackd)
> +			break;
> +
> +		msleep(FSM_EVENT_POLL_INTERVAL_MS);

I wonder if an event gets ignored, is msleep() useful also in that case?

> +	}
> +}
> +
> +static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd,
> +				  enum t7xx_ex_reason reason)
> +{
> +	struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
> +
> +	dev_err(dev, "Exception %d, from %ps\n", reason, __builtin_return_address(0));

Is that address useful?

> +	if (ctl->curr_state != FSM_STATE_READY && ctl->curr_state != FSM_STATE_STARTING) {
> +		if (cmd)
> +			fsm_finish_command(ctl, cmd, -EINVAL);
> +
> +		return;
> +	}
> +
> +	ctl->curr_state = FSM_STATE_EXCEPTION;
> +
> +	switch (reason) {
> +	case EXCEPTION_HS_TIMEOUT:
> +		dev_err(dev, "BOOT_HS_FAIL\n");
> +		break;

...

> +	if (!md->core_md.ready) {
> +		dev_err(dev, "MD handshake timeout\n");
> +		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);

Perhaps one dev_err() would suffice for this case :-). ...The another
one is inside fsm_routine_exception() (shown in the fragment above) 
although there's some non-trivial state-based logic in between which you 
want to check before removing either of them.


> +int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id, unsigned int flag)

No callsite in this patch seems to care about the error code, is it ok?
E.g.:
> +int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
> +{
...
> +       t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
If this returns an error, does it mean init/probe stalls? Or is there
some backup to restart?

> +int t7xx_fsm_append_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id,
> +			  unsigned char *data, unsigned int length)
Again, none of the callsites care?


-- 
 i.


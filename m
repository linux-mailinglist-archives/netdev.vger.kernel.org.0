Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7070F672355
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjARQby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjARQbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:31:31 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882194C6D6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674059363; x=1705595363;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D8FskoXrnM92TFrvcK4aMcssGRhO2L1CtEhxcYSXEq0=;
  b=Z6vaF51wvg29/9dklvlVuZrB3K6GuxwoVyDirL15B914w9r303fA/zzL
   CU9/H/Iu3/2bU2nXg73ZbAX49JpsNZJHIRy+pDB0loYmEky0tC8FoeZBm
   byw/eyn+yF1Xcwahn9c2xMpiKG6xfViFNgpdXiJd6Eu1/qTuFNhpAS339
   +OGSTPQfrVxm1dGy9Ha1fCfTVQhDVcWJhWBp7/b5gXAPL/TtoA9uo8JHd
   UPNfHoWBJVHgHzwHhR0mDfyuTnug5L/x9D/AP2SsPzkDxrAjkriceNRvQ
   1Gj1jb3oEYXQ5IMWg4s28wFFyg8l/kMMklpAnRSDCxd+9FPU70Ynqyw14
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387374665"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387374665"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 08:28:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="690264677"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="690264677"
Received: from mayurpan-mobl1.gar.corp.intel.com (HELO [10.215.124.30]) ([10.215.124.30])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 08:28:01 -0800
Message-ID: <305d9f7e-ec2a-beea-fc25-a2a0073e0154@linux.intel.com>
Date:   Wed, 18 Jan 2023 21:57:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <cover.1673842618.git.m.chetan.kumar@linux.intel.com>
 <b4605932b28346ba81450f15f2790016c732e043.1673842618.git.m.chetan.kumar@linux.intel.com>
 <87c8edd-41e0-136-d1ac-168ceff5855@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <87c8edd-41e0-136-d1ac-168ceff5855@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilpo,
Thank you for the feedback.

On 1/17/2023 7:37 PM, Ilpo Järvinen wrote:
> On Mon, 16 Jan 2023, m.chetan.kumar@linux.intel.com wrote:
> 
>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>
>> Adds support for t7xx wwan device firmware flashing & coredump collection
>> using devlink.
>>
>> 1> Driver Registers with Devlink framework.
>> 2> Implements devlink ops flash_update callback that programs modem fw.
>> 3> Creates region & snapshot required for device coredump log collection.
>>
>> On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
>> tx/rx queues for raw data transfer and then registers to devlink framework.
>> On user space application issuing command for firmware update the driver
>> sends fastboot flash command & firmware to program NAND.
>>
>> In flashing procedure the fastboot command & response are exchanged between
>> driver and device. Once firmware flashing is success completion status is
>> reported to user space application.
>>
>> Below is the devlink command usage for firmware flashing
>>
>> $devlink dev flash pci/$BDF file ABC.img component ABC
>>
>> Note: ABC.img is the firmware to be programmed to "ABC" partition.
>>
>> In case of coredump collection when wwan device encounters an exception
>> it reboots & stays in fastboot mode for coredump collection by host driver.
>> On detecting exception state driver collects the core dump, creates the
>> devlink region & reports an event to user space application for dump
>> collection. The user space application invokes devlink region read command
>> for dump collection.
>>
>> Below are the devlink commands used for coredump collection.
>>
>> devlink region new pci/$BDF/mr_dump
>> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
>> devlink region del pci/$BDF/mr_dump snapshot $ID
>>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
>> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> --
>> v4:
>>   * cppcheck - reduce variableScope for
>>     - skb_ccci & ret var in t7xx_port_ap_msg_tx.
>>     - ret in t7xx_devlink_port_read.
>>     - len, skb & ret in t7xx_devlink_port_write.
>> v3:
>>   * No Change.
>> v2:
>>   * Remove devlink pointer inside the port state container.
>>   * Rename t7xx_devlink_region_list to t7xx_devlink_region_infos &
>>     use region index in initialization.
>>   * Change t7xx_devlink_region_infos to const.
>>   * Handle remaining packet data if the buffer is less than the skb data.
>>   * Drop t7xx_devlink_fb_send_buffer(), push fragmentation logic to
>>     t7xx_devlink_port_write().
>>   * Add "\n" to log message.
>>   * Move mrdump_region allocation to devlink initialization.
>>   * Drop snprintf for CTS command fill.
>>   * Drop intermediate mdata buffer & zipsize.
>>   * For mcmd use strcmp instead of strncmp.
>>   * Drop set_fastboot_dl instead use devlink param for fastboot operational mode.
>>   * Drop unnecessary logs.
>>   * Change t7xx_devlink_create_region to t7xx_devlink_create_regions.
>>   * Use BUILD_BUG_ON on array size checks.
>>   * Use ARRAY_SIZE inside loop.
>>   * Correct indentation.
>>   * Drop odd empty line.
>>   * Push common devlink initialization code to t7xx_devlink_init.
>>   * Use skb_queue_purge instead of running loop to free skbs.
>>   * Change t7xx_regions index to enums.
>>   * Remove dev in devlink container.
>>   * Refactor struct to separate out devlink static and dynamic data structs.
>>   * Use min_t.
>>   * Drop unnecessary var assginment during initialization.
>>   * Change while() to for().
>>   * Correct size check.
>>   * Rename result to ret.
>>   * Clean-up error handling path in t7xx_devlink_fb_get_core & t7xx_devlink_fb_dump_log.
>>   * Drop __func__ in log message.
>>   * Change NOTY to NOTIFY.
>>   * Push channel enable or disable cb to port proxy.
>>   * Use array index in t7xx_devlink_region_list initialization.
>>   * Drop t7xx_port_proxy_get_port_by_name() instead access port name directly via port_prox.
>>   * Drop udev based event reporting logic.
>>   * Drop get_core prefix in goto label.
>>   * Remove unnessary header files.
>>   * Allocate memory for mrdump_region->buf inside get_core.
>>   * Remove 'region->buf' in t7xx_devlink_region_snapshot.
>>   * Destroy workqueue on following error case in 'devlink_init'.
>>   * Remove useless checks(dl->mode) and condition(dl->wq).
>>   * Support devlink component versioning.
>>   * Kconfig changes to select devlink.
>> ---
>>   drivers/net/wwan/Kconfig                   |   1 +
>>   drivers/net/wwan/t7xx/Makefile             |   4 +-
>>   drivers/net/wwan/t7xx/t7xx_pci.c           |  16 +-
>>   drivers/net/wwan/t7xx/t7xx_pci.h           |   2 +
>>   drivers/net/wwan/t7xx/t7xx_port.h          |   2 +
>>   drivers/net/wwan/t7xx/t7xx_port_ap_msg.c   |  79 +++
>>   drivers/net/wwan/t7xx/t7xx_port_ap_msg.h   |  11 +
>>   drivers/net/wwan/t7xx/t7xx_port_devlink.c  | 669 +++++++++++++++++++++
>>   drivers/net/wwan/t7xx/t7xx_port_devlink.h  |  86 +++
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.c    |  32 +
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.h    |   4 +
>>   drivers/net/wwan/t7xx/t7xx_port_wwan.c     |  22 +-
>>   drivers/net/wwan/t7xx/t7xx_reg.h           |   6 +
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.c |  37 +-
>>   14 files changed, 945 insertions(+), 26 deletions(-)
>>   create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.c
>>   create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.h
>>   create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.c
>>   create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.h
>>
>> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
>> index 410b0245114e..dd7a9883c1ff 100644
>> --- a/drivers/net/wwan/Kconfig
>> +++ b/drivers/net/wwan/Kconfig
>> @@ -108,6 +108,7 @@ config IOSM
>>   config MTK_T7XX
>>   	tristate "MediaTek PCIe 5G WWAN modem T7xx device"
>>   	depends on PCI
>> +	select NET_DEVLINK
>>   	select RELAY if WWAN_DEBUGFS
>>   	help
>>   	  Enables MediaTek PCIe based 5G WWAN modem (T7xx series) device.
>> diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
>> index ba5c607404a4..c3f1520b3c49 100644
>> --- a/drivers/net/wwan/t7xx/Makefile
>> +++ b/drivers/net/wwan/t7xx/Makefile
>> @@ -18,7 +18,9 @@ mtk_t7xx-y:=	t7xx_pci.o \
>>   		t7xx_hif_dpmaif_rx.o  \
>>   		t7xx_dpmaif.o \
>>   		t7xx_netdev.o \
>> -		t7xx_pci_rescan.o
>> +		t7xx_pci_rescan.o \
>> +		t7xx_port_devlink.o \
>> +		t7xx_port_ap_msg.o
>>   
>>   mtk_t7xx-$(CONFIG_WWAN_DEBUGFS) += \
>>   		t7xx_port_trace.o \
>> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
>> index 3f5ebbc11b82..624f96b42775 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_pci.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_pci.c
>> @@ -40,6 +40,7 @@
>>   #include "t7xx_pci.h"
>>   #include "t7xx_pci_rescan.h"
>>   #include "t7xx_pcie_mac.h"
>> +#include "t7xx_port_devlink.h"
>>   #include "t7xx_reg.h"
>>   #include "t7xx_state_monitor.h"
>>   
>> @@ -107,7 +108,7 @@ static int t7xx_pci_pm_init(struct t7xx_pci_dev *t7xx_dev)
>>   	pm_runtime_set_autosuspend_delay(&pdev->dev, PM_AUTOSUSPEND_MS);
>>   	pm_runtime_use_autosuspend(&pdev->dev);
>>   
>> -	return t7xx_wait_pm_config(t7xx_dev);
>> +	return 0;
>>   }
>>   
>>   void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
>> @@ -704,16 +705,20 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   	t7xx_pci_infracfg_ao_calc(t7xx_dev);
>>   	t7xx_mhccif_init(t7xx_dev);
>>   
>> -	ret = t7xx_md_init(t7xx_dev);
>> +	ret = t7xx_devlink_register(t7xx_dev);
>>   	if (ret)
>>   		return ret;
>>   
>> +	ret = t7xx_md_init(t7xx_dev);
>> +	if (ret)
>> +		goto err_devlink_unregister;
>> +
>>   	t7xx_pcie_mac_interrupts_dis(t7xx_dev);
>>   
>>   	ret = t7xx_interrupt_init(t7xx_dev);
>>   	if (ret) {
>>   		t7xx_md_exit(t7xx_dev);
>> -		return ret;
>> +		goto err_devlink_unregister;
>>   	}
>>   
>>   	t7xx_rescan_done();
>> @@ -721,6 +726,10 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   	t7xx_pcie_mac_interrupts_en(t7xx_dev);
>>   
>>   	return 0;
>> +
>> +err_devlink_unregister:
>> +	t7xx_devlink_unregister(t7xx_dev);
>> +	return ret;
>>   }
>>   
>>   static void t7xx_pci_remove(struct pci_dev *pdev)
>> @@ -730,6 +739,7 @@ static void t7xx_pci_remove(struct pci_dev *pdev)
>>   
>>   	t7xx_dev = pci_get_drvdata(pdev);
>>   	t7xx_md_exit(t7xx_dev);
>> +	t7xx_devlink_unregister(t7xx_dev);
>>   
>>   	for (i = 0; i < EXT_INT_NUM; i++) {
>>   		if (!t7xx_dev->intr_handler[i])
>> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
>> index 112efa534eac..44a8a5034696 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_pci.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_pci.h
>> @@ -59,6 +59,7 @@ typedef irqreturn_t (*t7xx_intr_callback)(int irq, void *param);
>>    * @md_pm_lock: protects PCIe sleep lock
>>    * @sleep_disable_count: PCIe L1.2 lock counter
>>    * @sleep_lock_acquire: indicates that sleep has been disabled
>> + * @dl: devlink struct
>>    */
>>   struct t7xx_pci_dev {
>>   	t7xx_intr_callback	intr_handler[EXT_INT_NUM];
>> @@ -81,6 +82,7 @@ struct t7xx_pci_dev {
>>   #ifdef CONFIG_WWAN_DEBUGFS
>>   	struct dentry		*debugfs_dir;
>>   #endif
>> +	struct t7xx_devlink     *dl;
>>   };
>>   
>>   enum t7xx_pm_id {
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>> index 09acb1ef144d..dfa7ad2a9796 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>> @@ -42,6 +42,8 @@ enum port_ch {
>>   	/* to AP */
>>   	PORT_CH_AP_CONTROL_RX = 0x1000,
>>   	PORT_CH_AP_CONTROL_TX = 0x1001,
>> +	PORT_CH_AP_MSG_RX = 0x101E,
>> +	PORT_CH_AP_MSG_TX = 0x101F,
>>   
>>   	/* to MD */
>>   	PORT_CH_CONTROL_RX = 0x2000,
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_ap_msg.c b/drivers/net/wwan/t7xx/t7xx_port_ap_msg.c
>> new file mode 100644
>> index 000000000000..9621f013de5d
>> --- /dev/null
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_ap_msg.c
>> @@ -0,0 +1,79 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2022-2023, Intel Corporation.
>> + */
>> +
>> +#include "t7xx_port.h"
>> +#include "t7xx_port_ap_msg.h"
>> +#include "t7xx_port_devlink.h"
>> +#include "t7xx_port_proxy.h"
>> +#include "t7xx_state_monitor.h"
>> +
>> +int t7xx_port_ap_msg_tx(struct t7xx_port *port, char *buff, size_t len)
>> +{
>> +	const struct t7xx_port_conf *port_conf;
>> +	size_t offset, chunk_len = 0, txq_mtu;
>> +	struct t7xx_fsm_ctl *ctl;
>> +	enum md_state md_state;
>> +
>> +	if (!len || !port->chan_enable)
>> +		return -EINVAL;
>> +
>> +	port_conf = port->port_conf;
>> +	ctl = port->t7xx_dev->md->fsm_ctl;
>> +	md_state = t7xx_fsm_get_md_state(ctl);
>> +	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
>> +		dev_warn(port->dev, "Cannot write to %s port when md_state=%d\n",
>> +			 port_conf->name, md_state);
>> +		return -ENODEV;
>> +	}
>> +
>> +	txq_mtu = t7xx_get_port_mtu(port);
>> +	for (offset = 0; offset < len; offset += chunk_len) {
>> +		struct sk_buff *skb_ccci;
>> +		int ret;
>> +
>> +		chunk_len = min(len - offset, txq_mtu - sizeof(struct ccci_header));
>> +		skb_ccci = t7xx_port_alloc_skb(chunk_len);
>> +		if (!skb_ccci)
>> +			return -ENOMEM;
>> +
>> +		skb_put_data(skb_ccci, buff + offset, chunk_len);
>> +		ret = t7xx_port_send_skb(port, skb_ccci, 0, 0);
>> +		if (ret) {
>> +			dev_kfree_skb_any(skb_ccci);
>> +			dev_err(port->dev, "Write error on %s port, %d\n",
>> +				port_conf->name, ret);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	return len;
>> +}
>> +
>> +static int t7xx_port_ap_msg_init(struct t7xx_port *port)
>> +{
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +
>> +	port->rx_length_th = T7XX_MAX_QUEUE_LENGTH;
>> +	dl->status = T7XX_DEVLINK_IDLE;
>> +	dl->port = port;
>> +
>> +	return 0;
>> +}
>> +
>> +static void t7xx_port_ap_msg_uninit(struct t7xx_port *port)
>> +{
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +
>> +	dl->mode = T7XX_NORMAL_MODE;
>> +	skb_queue_purge(&port->rx_skb_list);
>> +}
>> +
>> +struct port_ops ap_msg_port_ops = {
>> +	.init = &t7xx_port_ap_msg_init,
>> +	.recv_skb = &t7xx_port_enqueue_skb,
>> +	.uninit = &t7xx_port_ap_msg_uninit,
>> +	.enable_chl = &t7xx_port_enable_chl,
>> +	.disable_chl = &t7xx_port_disable_chl,
>> +};
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_ap_msg.h b/drivers/net/wwan/t7xx/t7xx_port_ap_msg.h
>> new file mode 100644
>> index 000000000000..4838d87d86cf
>> --- /dev/null
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_ap_msg.h
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only
>> + *
>> + * Copyright (c) 2022-2023, Intel Corporation.
>> + */
>> +
>> +#ifndef __T7XX_PORT_AP_MSG_H__
>> +#define __T7XX_PORT_AP_MSG_H__
>> +
>> +int t7xx_port_ap_msg_tx(struct t7xx_port *port, char *buff, size_t len);
>> +
>> +#endif /* __T7XX_PORT_AP_MSG_H__ */
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_devlink.c b/drivers/net/wwan/t7xx/t7xx_port_devlink.c
>> new file mode 100644
>> index 000000000000..7786f8cc5e8e
>> --- /dev/null
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_devlink.c
>> @@ -0,0 +1,669 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2022-2023, Intel Corporation.
>> + */
>> +
>> +#include <linux/vmalloc.h>
>> +
>> +#include "t7xx_hif_cldma.h"
>> +#include "t7xx_pci_rescan.h"
>> +#include "t7xx_port.h"
>> +#include "t7xx_port_ap_msg.h"
>> +#include "t7xx_port_devlink.h"
>> +#include "t7xx_port_proxy.h"
>> +#include "t7xx_state_monitor.h"
>> +
>> +static struct t7xx_devlink_region_info t7xx_devlink_region_infos[] = {
>> +	[T7XX_MRDUMP_INDEX] = {"mr_dump", T7XX_MRDUMP_SIZE},
>> +	[T7XX_LKDUMP_INDEX] = {"lk_dump", T7XX_LKDUMP_SIZE},
>> +};
>> +
>> +static int t7xx_devlink_port_read(struct t7xx_port *port, char *buf, size_t count)
>> +{
>> +	struct sk_buff *skb;
>> +	int read_len;
>> +
>> +	spin_lock_irq(&port->rx_wq.lock);
>> +	if (skb_queue_empty(&port->rx_skb_list)) {
>> +		int ret = wait_event_interruptible_locked_irq(port->rx_wq,
>> +							      !skb_queue_empty(&port->rx_skb_list));
>> +		if (ret == -ERESTARTSYS) {
>> +			spin_unlock_irq(&port->rx_wq.lock);
>> +			return -EINTR;
>> +		}
>> +	}
>> +	skb = skb_dequeue(&port->rx_skb_list);
>> +	spin_unlock_irq(&port->rx_wq.lock);
>> +
>> +	read_len = min_t(size_t, count, skb->len);
>> +	memcpy(buf, skb->data, read_len);
>> +
>> +	if (read_len < skb->len) {
>> +		skb_pull(skb, read_len);
>> +		skb_queue_head(&port->rx_skb_list, skb);
>> +	} else {
>> +		consume_skb(skb);
>> +	}
>> +
>> +	return read_len;
>> +}
>> +
>> +static int t7xx_devlink_port_write(struct t7xx_port *port, const char *buf, size_t count)
>> +{
>> +	const struct t7xx_port_conf *port_conf = port->port_conf;
>> +	size_t actual = count, offset = 0;
>> +	int txq_mtu;
>> +
>> +	txq_mtu = t7xx_get_port_mtu(port);
>> +	if (txq_mtu < 0)
>> +		return -EINVAL;
>> +
>> +	while (actual) {
>> +		int len = min_t(size_t, actual, txq_mtu);
>> +		struct sk_buff *skb;
>> +		int ret;
>> +
>> +		skb = __dev_alloc_skb(len, GFP_KERNEL);
>> +		if (!skb)
>> +			return -ENOMEM;
>> +
>> +		skb_put_data(skb, buf + offset, len);
>> +		ret = t7xx_port_send_raw_skb(port, skb);
>> +		if (ret) {
>> +			dev_err(port->dev, "write error on %s, size: %d, ret: %d\n",
>> +				port_conf->name, len, ret);
>> +			dev_kfree_skb(skb);
>> +			return ret;
>> +		}
>> +
>> +		offset += len;
>> +		actual -= len;
>> +	}
>> +
>> +	return count;
>> +}
>> +
>> +static int t7xx_devlink_fb_handle_response(struct t7xx_port *port, char *data)
>> +{
>> +	char status[T7XX_FB_RESPONSE_SIZE + 1];
>> +	int ret = 0, index;
>> +
>> +	for (index = 0; index < T7XX_FB_RESP_COUNT; index++) {
>> +		int read_bytes = t7xx_devlink_port_read(port, status, T7XX_FB_RESPONSE_SIZE);
>> +
>> +		if (read_bytes < 0) {
>> +			dev_err(port->dev, "status read interrupted\n");
>> +			ret = -EIO;
> 
> First t7xx_devlink_port_read does -ERESTARTSYS -> -EINTR and then here you
> do -ERESTARTSYS -> -EIO.

Will drop return update inside t7xx_devlink_port_read &
return the same from t7xx_devlink_fb_handle_response.

Will correct it other places too.

> 
>> +			break;
>> +		}
>> +
>> +		status[read_bytes] = '\0';
>> +		dev_dbg(port->dev, "raw response from device: %s\n", status);
>> +		if (!strncmp(status, T7XX_FB_RESP_INFO, strlen(T7XX_FB_RESP_INFO))) {
>> +			break;
>> +		} else if (!strncmp(status, T7XX_FB_RESP_OKAY, strlen(T7XX_FB_RESP_OKAY))) {
>> +			break;
>> +		} else if (!strncmp(status, T7XX_FB_RESP_FAIL, strlen(T7XX_FB_RESP_FAIL))) {
>> +			ret = -EPROTO;
>> +			break;
>> +		} else if (!strncmp(status, T7XX_FB_RESP_DATA, strlen(T7XX_FB_RESP_DATA))) {
>> +			if (data)
>> +				snprintf(data, T7XX_FB_RESPONSE_SIZE, "%s",
>> +					 status + strlen(T7XX_FB_RESP_DATA));
>> +			break;
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int t7xx_devlink_fb_raw_command(char *cmd, struct t7xx_port *port, char *data)
>> +{
>> +	int ret, cmd_size = strlen(cmd);
>> +
>> +	if (cmd_size > T7XX_FB_COMMAND_SIZE) {
>> +		dev_err(port->dev, "command length %d is long\n", cmd_size);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (cmd_size != t7xx_devlink_port_write(port, cmd, cmd_size)) {
>> +		dev_err(port->dev, "raw command = %s write failed\n", cmd);
>> +		return -EIO;
>> +	}
>> +
>> +	dev_dbg(port->dev, "raw command = %s written to the device\n", cmd);
>> +	ret = t7xx_devlink_fb_handle_response(port, data);
>> +	if (ret)
>> +		dev_err(port->dev, "raw command = %s response FAILURE:%d\n", cmd, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int t7xx_devlink_fb_download_command(struct t7xx_port *port, size_t size)
>> +{
>> +	char download_command[T7XX_FB_COMMAND_SIZE];
>> +
>> +	snprintf(download_command, sizeof(download_command), "%s:%08zx",
>> +		 T7XX_FB_CMD_DOWNLOAD, size);
>> +	return t7xx_devlink_fb_raw_command(download_command, port, NULL);
>> +}
>> +
>> +static int t7xx_devlink_fb_download(struct t7xx_port *port, const u8 *buf, size_t size)
>> +{
>> +	int ret;
>> +
>> +	if (!size)
>> +		return -EINVAL;
>> +
>> +	ret = t7xx_devlink_fb_download_command(port, size);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = t7xx_devlink_port_write(port, buf, size);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return t7xx_devlink_fb_handle_response(port, NULL);
>> +}
>> +
>> +static int t7xx_devlink_fb_flash(struct t7xx_port *port, const char *cmd)
>> +{
>> +	char flash_command[T7XX_FB_COMMAND_SIZE];
>> +
>> +	snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
>> +	return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
>> +}
>> +
>> +static int t7xx_devlink_get_part_ver_fb_mode(struct t7xx_port *port, const char *cmd, char *data)
>> +{
>> +	char req_command[T7XX_FB_COMMAND_SIZE];
>> +
>> +	snprintf(req_command, sizeof(req_command), "%s:%s", T7XX_FB_CMD_GET_VER, cmd);
>> +	return t7xx_devlink_fb_raw_command(req_command, port, data);
>> +}
>> +
>> +static int t7xx_devlink_get_part_ver_norm_mode(struct t7xx_port *port, const char *cmd, char *data)
>> +{
>> +	char req_command[T7XX_FB_COMMAND_SIZE];
>> +	int len;
>> +
>> +	len = snprintf(req_command, sizeof(req_command), "%s:%s", T7XX_FB_CMD_GET_VER, cmd);
>> +	t7xx_port_ap_msg_tx(port, req_command, len);
>> +
>> +	return t7xx_devlink_fb_handle_response(port, data);
>> +}
>> +
>> +static int t7xx_devlink_fb_flash_partition(struct t7xx_port *port, const char *partition,
>> +					   const u8 *buf, size_t size)
>> +{
>> +	int ret;
>> +
>> +	ret = t7xx_devlink_fb_download(port, buf, size);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return t7xx_devlink_fb_flash(port, partition);
>> +}
>> +
>> +static int t7xx_devlink_fb_get_core(struct t7xx_port *port)
>> +{
>> +	u32 mrd_mb = T7XX_MRDUMP_SIZE / (1024 * 1024);
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +	char mcmd[T7XX_FB_MCMD_SIZE + 1];
>> +	size_t offset_dlen = 0;
>> +	int clen, dlen, ret;
>> +
>> +	dl->regions[T7XX_MRDUMP_INDEX].buf = vmalloc(dl->regions[T7XX_MRDUMP_INDEX].info->size);
>> +	if (!dl->regions[T7XX_MRDUMP_INDEX].buf)
>> +		return -ENOMEM;
>> +
>> +	set_bit(T7XX_MRDUMP_STATUS, &dl->status);
>> +	ret = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_MRDUMP, port, NULL);
>> +	if (ret) {
>> +		dev_err(port->dev, "%s command failed\n", T7XX_FB_CMD_OEM_MRDUMP);
>> +		goto free_mem;
>> +	}
>> +
>> +	while (dl->regions[T7XX_MRDUMP_INDEX].info->size > offset_dlen) {
>> +		clen = t7xx_devlink_port_read(port, mcmd, sizeof(mcmd) - 1);
>> +		mcmd[clen] = '\0';
> 
> What if clen < 0?

On safer note will add clen check.

> 
>> +		if (clen == strlen(T7XX_FB_CMD_RTS) && (!strcmp(mcmd, T7XX_FB_CMD_RTS))) {
> 
> How is this different from just !strcmp()?

Will drop the first condition.

> 
>> +			memset(mcmd, 0, sizeof(mcmd));
>> +			if (t7xx_devlink_port_write(port, T7XX_FB_CMD_CTS, strlen(T7XX_FB_CMD_CTS))
>> +						    != strlen(T7XX_FB_CMD_CTS)) {
> 
> Split into two lines using a variable for the result, it's much more
> readable then. Or perhaps create a helper?

Such change is present below as well. Will create a helper & use it.

> 
>> +				dev_err(port->dev, "write for _CTS failed:%zu\n",
>> +					strlen(T7XX_FB_CMD_CTS));
>> +				goto free_mem;
>> +			}
>> +
>> +			dlen = t7xx_devlink_port_read(port, dl->regions[T7XX_MRDUMP_INDEX].buf +
>> +						      offset_dlen, T7XX_FB_MDATA_SIZE);
>> +			if (dlen <= 0) {
>> +				dev_err(port->dev, "read data error(%d)\n", dlen);
>> +				ret = -EPROTO;
> 
> -RESTARTSYS/-EINTR -> -EPROTO ??? >
>> +				goto free_mem;
>> +			}
>> +			offset_dlen += dlen;
>> +
>> +			if (t7xx_devlink_port_write(port, T7XX_FB_CMD_FIN, strlen(T7XX_FB_CMD_FIN))
>> +						    != strlen(T7XX_FB_CMD_FIN)) {
>> +				dev_err(port->dev, "_FIN failed, (Read %05zu:%05zu)\n",
>> +					strlen(T7XX_FB_CMD_FIN), offset_dlen);
>> +				ret = -EPROTO;
> 
> Ditto.
> 
>> +				goto free_mem;
>> +			}
>> +			continue;
>> +		} else if ((clen == strlen(T7XX_FB_RESP_MRDUMP_DONE)) &&
>> +			   (!strcmp(mcmd, T7XX_FB_RESP_MRDUMP_DONE))) {
> 
> !strcmp()?

Will drop the first condition.

> 
>> +			dev_dbg(port->dev, "%s! size:%zd\n", T7XX_FB_RESP_MRDUMP_DONE, offset_dlen);
>> +			clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
>> +			return 0;
>> +		}
>> +		dev_err(port->dev, "getcore protocol error (read len %05d, response %s)\n",
>> +			clen, mcmd);
>> +		ret = -EPROTO;
>> +		goto free_mem;
>> +	}
>> +
>> +	dev_err(port->dev, "mrdump exceeds %uMB size. Discarded!\n", mrd_mb);
>> +
>> +free_mem:
>> +	vfree(dl->regions[T7XX_MRDUMP_INDEX].buf);
>> +	clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
>> +	return ret;
>> +}
>> +
>> +static int t7xx_devlink_fb_dump_log(struct t7xx_port *port)
>> +{
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +	struct t7xx_devlink_region *lkdump_region;
>> +	char rsp[T7XX_FB_RESPONSE_SIZE];
>> +	int datasize = 0, ret;
>> +	size_t offset = 0;
>> +
>> +	if (dl->status != T7XX_DEVLINK_IDLE) {
>> +		dev_err(&dl->t7xx_dev->pdev->dev, "Modem is busy!\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	set_bit(T7XX_LKDUMP_STATUS, &dl->status);
>> +	ret = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_LKDUMP, port, rsp);
>> +	if (ret) {
>> +		dev_err(port->dev, "%s command returns failure\n", T7XX_FB_CMD_OEM_LKDUMP);
>> +		clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
>> +		return ret;
>> +	}
>> +
>> +	ret = kstrtoint(rsp, 16, &datasize);
>> +	if (ret) {
>> +		dev_err(port->dev, "kstrtoint error!\n");
> 
> Maybe something looking more English than "kstrtoint" would make the user
> happier... :-)

Will correct it.

> 
>> +		clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
> 
> I'd goto into unroll path rather than sprinkle this clear_bit()
> everywhere in this function.
> 
>> +		return ret;
>> +	}
>> +
>> +	lkdump_region = &dl->regions[T7XX_LKDUMP_INDEX];
>> +	if (datasize > lkdump_region->info->size) {
>> +		dev_err(port->dev, "lkdump size is more than %dKB. Discarded!\n",
>> +			T7XX_LKDUMP_SIZE / 1024);
>> +		clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
>> +		return -EPROTO;
> 
> -EFBIG ?


Will -EPROTO to -EFBIG.

> 
>> +	}
>> +
>> +	lkdump_region->buf = vmalloc(lkdump_region->info->size);
>> +	if (!lkdump_region->buf) {
>> +		clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	while (datasize > 0) {
>> +		int dlen = t7xx_devlink_port_read(port, lkdump_region->buf + offset, datasize);
>> +
>> +		if (dlen <= 0) {
>> +			dev_err(port->dev, "lkdump read error ret = %d\n", dlen);
>> +			clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
>> +			return -EPROTO;
> 
> -ERESTARTSYS/-EINTR -> -EPROTO?
> 
>> +		}
>> +
>> +		datasize -= dlen;
>> +		offset += dlen;
>> +	}
>> +
>> +	dev_dbg(port->dev, "LKDUMP DONE! size:%zd\n", offset);
>> +	clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
>> +	return t7xx_devlink_fb_handle_response(port, NULL);
>> +}
>> +
>> +static int t7xx_devlink_flash_update(struct devlink *devlink,
>> +				     struct devlink_flash_update_params *params,
>> +				     struct netlink_ext_ack *extack)
>> +{
>> +	struct t7xx_devlink *dl = devlink_priv(devlink);
>> +	const char *component = params->component;
>> +	const struct firmware *fw = params->fw;
>> +	struct t7xx_port *port;
>> +	int ret;
>> +
>> +	if (dl->mode != T7XX_FB_DL_MODE) {
>> +		dev_err(&dl->t7xx_dev->pdev->dev, "Modem is not in fastboot download mode!\n");
>> +		ret = -EPERM;
>> +		goto err_out;
>> +	}
>> +
>> +	if (dl->status != T7XX_DEVLINK_IDLE) {
>> +		dev_err(&dl->t7xx_dev->pdev->dev, "Modem is busy!\n");
>> +		ret = -EBUSY;
>> +		goto err_out;
>> +	}
>> +
>> +	if (!component || !fw->data) {
>> +		ret = -EINVAL;
>> +		goto err_out;
>> +	}
>> +
>> +	set_bit(T7XX_FLASH_STATUS, &dl->status);
>> +	port = dl->port;
>> +	dev_dbg(port->dev, "flash partition name:%s binary size:%zu\n", component, fw->size);
>> +	ret = t7xx_devlink_fb_flash_partition(port, component, fw->data, fw->size);
>> +	if (ret) {
>> +		devlink_flash_update_status_notify(devlink, "flashing failure!",
>> +						   params->component, 0, 0);
>> +	} else {
>> +		devlink_flash_update_status_notify(devlink, "flashing success!",
>> +						   params->component, 0, 0);
> 
> One could use %s and !ret ? "success" : "failure"

Will change it as per your suggestion.

> 
>> +	}
>> +	clear_bit(T7XX_FLASH_STATUS, &dl->status);
>> +
>> +err_out:
>> +	return ret;
>> +}
>> +
>> +enum t7xx_devlink_param_id {
>> +	T7XX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
>> +	T7XX_DEVLINK_PARAM_ID_FASTBOOT,
>> +};
>> +
>> +static const struct devlink_param t7xx_devlink_params[] = {
>> +	DEVLINK_PARAM_DRIVER(T7XX_DEVLINK_PARAM_ID_FASTBOOT,
>> +			     "fastboot", DEVLINK_PARAM_TYPE_BOOL,
>> +			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
>> +			     NULL, NULL, NULL),
>> +};
>> +
>> +bool t7xx_devlink_param_get_fastboot(struct devlink *devlink)
>> +{
>> +	union devlink_param_value saved_value;
>> +
>> +	devlink_param_driverinit_value_get(devlink, T7XX_DEVLINK_PARAM_ID_FASTBOOT,
>> +					   &saved_value);
>> +	return saved_value.vbool;
>> +}
>> +
>> +static int t7xx_devlink_reload_down(struct devlink *devlink, bool netns_change,
>> +				    enum devlink_reload_action action,
>> +				    enum devlink_reload_limit limit,
>> +				    struct netlink_ext_ack *extack)
>> +{
>> +	struct t7xx_devlink *dl = devlink_priv(devlink);
>> +
>> +	switch (action) {
>> +	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
>> +		return 0;
>> +	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
>> +		if (!dl->mode)
>> +			return -EPERM;
>> +		return t7xx_devlink_fb_raw_command(T7XX_FB_CMD_REBOOT, dl->port, NULL);
>> +	default:
>> +		/* Unsupported action should not get to this function */
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +
>> +static int t7xx_devlink_reload_up(struct devlink *devlink,
>> +				  enum devlink_reload_action action,
>> +				  enum devlink_reload_limit limit,
>> +				  u32 *actions_performed,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	struct t7xx_devlink *dl = devlink_priv(devlink);
> 
> Add newline.

Ok.

> 
>> +	*actions_performed = BIT(action);
>> +	switch (action) {
>> +	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
>> +	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
>> +		t7xx_rescan_queue_work(dl->t7xx_dev->pdev);
>> +		return 0;
>> +	default:
>> +		/* Unsupported action should not get to this function */
>> +		return -EOPNOTSUPP;
>> +	}
>> +}
>> +
>> +static int t7xx_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>> +				 struct netlink_ext_ack *extack)
>> +{
>> +	struct t7xx_devlink *dl = devlink_priv(devlink);
>> +	char *part_name, *ver, *part_no, *data;
>> +	int ret, total_part, i, ver_len;
>> +	struct t7xx_port *port;
>> +
>> +	port = dl->port;
>> +	port->port_conf->ops->enable_chl(port);
>> +
>> +	if (dl->status != T7XX_DEVLINK_IDLE) {
>> +		dev_err(&dl->t7xx_dev->pdev->dev, "Modem is busy!\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	data = kzalloc(T7XX_FB_RESPONSE_SIZE, GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	set_bit(T7XX_GET_INFO, &dl->status);
>> +	if (dl->mode == T7XX_FB_DL_MODE)
>> +		ret = t7xx_devlink_get_part_ver_fb_mode(port, "", data);
>> +	else
>> +		ret = t7xx_devlink_get_part_ver_norm_mode(port, "", data);
>> +
>> +	if (ret < 0)
>> +		goto err_clear_bit;
>> +
>> +	part_no = strsep(&data, ",");
>> +	if (kstrtoint(part_no, 16, &total_part)) {
>> +		dev_err(&dl->t7xx_dev->pdev->dev, "kstrtoint error!\n");
> 
> More meaningful error msg.

Will correct it.

> 
>> +		ret = -EINVAL;
>> +		goto err_clear_bit;
>> +	}
>> +
>> +	for (i = 0; i < total_part; i++) {
> 
> The whole operation below is quite fancy, I'd add some comment telling the
> intent.

Device returns firmware name & version in string format. Using below 
logic to decode it.

Will add some comment.

> 
>> +		part_name = strsep(&data, ",");
>> +		ver = strsep(&data, ",");
> 
> Can ver become NULL here?

It should not be the case. As part of component fw version query device 
is expected to send the complete list for fw components.

On safer note will add NULL check.

> 
>> +		ver_len = strlen(ver);
>> +		if (ver[ver_len - 2] == 0x5C && ver[ver_len - 1] == 0x6E)
>> +			ver[ver_len - 4] = '\0';
> 
> Is ver_len guaranteed to be large enough?

fw version query response message will not cross 512 bytes.
It is aligned with device implementation.

> 
>> +		ret = devlink_info_version_running_put_ext(req, part_name, ver,
>> +							   DEVLINK_INFO_VERSION_TYPE_COMPONENT);
>> +	}
>> +
>> +err_clear_bit:
>> +	clear_bit(T7XX_GET_INFO, &dl->status);
>> +	kfree(data);
>> +	return ret;
>> +}
>> +
>> +/* Call back function for devlink ops */
>> +static const struct devlink_ops devlink_flash_ops = {
>> +	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
>> +	.flash_update = t7xx_devlink_flash_update,
>> +	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> +			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
>> +	.info_get = t7xx_devlink_info_get,
>> +	.reload_down = t7xx_devlink_reload_down,
>> +	.reload_up = t7xx_devlink_reload_up,
>> +};
>> +
>> +static int t7xx_devlink_region_snapshot(struct devlink *dl, const struct devlink_region_ops *ops,
>> +					struct netlink_ext_ack *extack, u8 **data)
>> +{
>> +	struct t7xx_devlink *t7xx_dl = devlink_priv(dl);
>> +	struct t7xx_devlink_region *region = ops->priv;
>> +	struct t7xx_port *port = t7xx_dl->port;
>> +	u8 *snapshot_mem;
>> +
>> +	if (t7xx_dl->status != T7XX_DEVLINK_IDLE)
>> +		return -EBUSY;
>> +
>> +	if (!strncmp(ops->name, "mr_dump", strlen("mr_dump"))) {
>> +		snapshot_mem = vmalloc(region->info->size);
>> +		memcpy(snapshot_mem, region->buf, region->info->size);
>> +		*data = snapshot_mem;
>> +	} else if (!strncmp(ops->name, "lk_dump", strlen("lk_dump"))) {
>> +		int ret;
>> +
>> +		ret = t7xx_devlink_fb_dump_log(port);
>> +		if (ret)
>> +			return ret;
>> +
>> +		*data = region->buf;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* To create regions for dump files */
>> +static int t7xx_devlink_create_regions(struct t7xx_devlink *dl)
>> +{
>> +	int ret, i;
>> +
>> +	BUILD_BUG_ON(ARRAY_SIZE(t7xx_devlink_region_infos) > ARRAY_SIZE(dl->regions));
>> +	for (i = 0; i < ARRAY_SIZE(t7xx_devlink_region_infos); i++) {
>> +		dl->regions[i].info = &t7xx_devlink_region_infos[i];
>> +		dl->regions[i].ops.name = dl->regions[i].info->name;
>> +		dl->regions[i].ops.snapshot = t7xx_devlink_region_snapshot;
>> +		dl->regions[i].ops.destructor = vfree;
>> +		dl->regions[i].dlreg = devlink_region_create(dl->ctx, &dl->regions[i].ops,
>> +							     T7XX_MAX_SNAPSHOTS,
>> +							     t7xx_devlink_region_infos[i].size);
>> +		if (IS_ERR(dl->regions[i].dlreg)) {
>> +			ret = PTR_ERR(dl->regions[i].dlreg);
>> +			dev_err(dl->port->dev, "devlink region fail,err %d\n", ret);
> 
> creating devlink region failed ?

Will change log message to "creating devlink region failed".

> 
>> +			for ( ; i >= 0; i--)
>> +				devlink_region_destroy(dl->regions[i].dlreg);
> 
> while (i >= 0) + ...regions[i--]... is simpler and equal.

Sure. will change it.

> 
>> +
>> +			return ret;
>> +		}
>> +
>> +		dl->regions[i].ops.priv = &dl->regions[i];
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int t7xx_devlink_register(struct t7xx_pci_dev *t7xx_dev)
>> +{
>> +	union devlink_param_value value;
>> +	struct devlink *dl_ctx;
>> +
>> +	dl_ctx = devlink_alloc(&devlink_flash_ops, sizeof(struct t7xx_devlink),
>> +			       &t7xx_dev->pdev->dev);
>> +	if (!dl_ctx)
>> +		return -ENOMEM;
>> +
>> +	t7xx_dev->dl = devlink_priv(dl_ctx);
>> +	t7xx_dev->dl->ctx = dl_ctx;
>> +	t7xx_dev->dl->t7xx_dev = t7xx_dev;
>> +	devlink_params_register(dl_ctx, t7xx_devlink_params, ARRAY_SIZE(t7xx_devlink_params));
>> +	value.vbool = false;
>> +	devlink_param_driverinit_value_set(dl_ctx, T7XX_DEVLINK_PARAM_ID_FASTBOOT, value);
>> +	devlink_set_features(dl_ctx, DEVLINK_F_RELOAD);
>> +	devlink_register(dl_ctx);
>> +
>> +	return 0;
>> +}
>> +
>> +void t7xx_devlink_unregister(struct t7xx_pci_dev *t7xx_dev)
>> +{
>> +	struct devlink *dl_ctx = t7xx_dev->dl->ctx;
>> +
>> +	devlink_unregister(dl_ctx);
>> +	devlink_params_unregister(dl_ctx, t7xx_devlink_params, ARRAY_SIZE(t7xx_devlink_params));
>> +	devlink_free(dl_ctx);
>> +}
>> +
>> +static void t7xx_devlink_work(struct work_struct *work)
>> +{
>> +	struct t7xx_devlink *dl;
>> +
>> +	dl = container_of(work, struct t7xx_devlink, ws);
>> +	t7xx_devlink_fb_get_core(dl->port);
>> +}
>> +
>> +/**
>> + * t7xx_devlink_init - Initialize devlink to t7xx driver
>> + * @port: Pointer to port structure
>> + *
>> + * Returns: 0 on success and error values on failure
>> + */
>> +static int t7xx_devlink_init(struct t7xx_port *port)
>> +{
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +	struct workqueue_struct *dl_wq;
>> +	int rc;
>> +
>> +	dl_wq = create_workqueue("t7xx_devlink");
>> +	if (!dl_wq) {
>> +		dev_err(port->dev, "create_workqueue failed\n");
>> +		return -ENODATA;
>> +	}
>> +
>> +	INIT_WORK(&dl->ws, t7xx_devlink_work);
>> +	port->rx_length_th = T7XX_MAX_QUEUE_LENGTH;
>> +
>> +	dl->mode = T7XX_NORMAL_MODE;
>> +	dl->status = T7XX_DEVLINK_IDLE;
>> +	dl->wq = dl_wq;
>> +	dl->port = port;
>> +
>> +	rc = t7xx_devlink_create_regions(dl);
>> +	if (rc) {
>> +		destroy_workqueue(dl->wq);
>> +		dev_err(port->dev, "devlink region creation failed, rc %d\n", rc);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void t7xx_devlink_uninit(struct t7xx_port *port)
>> +{
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +	int i;
>> +
>> +	vfree(dl->regions[T7XX_MRDUMP_INDEX].buf);
>> +
>> +	dl->mode = T7XX_NORMAL_MODE;
>> +	destroy_workqueue(dl->wq);
>> +
>> +	BUILD_BUG_ON(ARRAY_SIZE(t7xx_devlink_region_infos) > ARRAY_SIZE(dl->regions));
> 
> The same BUILD_BUG_ON again? Maybe just make a single static_assert()
> outside of the functions.

Should i change it as below ? please suggest.

static_assert(ARRAY_SIZE(t7xx_devlink_region_infos) ==
               (sizeof(typeof_member(struct t7xx_devlink, regions)) /
                sizeof(struct t7xx_devlink_region)));
static void t7xx_devlink_uninit(struct t7xx_port *port)
{
..

> 
>> +	for (i = 0; i < ARRAY_SIZE(t7xx_devlink_region_infos); ++i)
>> +		devlink_region_destroy(dl->regions[i].dlreg);
>> +
>> +	skb_queue_purge(&port->rx_skb_list);
>> +}
>> +
>> +static int t7xx_devlink_enable_chl(struct t7xx_port *port)
>> +{
>> +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
>> +
>> +	t7xx_port_enable_chl(port);
>> +	if (dl->mode == T7XX_FB_DUMP_MODE)
>> +		queue_work(dl->wq, &dl->ws);
>> +
>> +	return 0;
>> +}
>> +
>> +struct port_ops devlink_port_ops = {
>> +	.init = &t7xx_devlink_init,
>> +	.recv_skb = &t7xx_port_enqueue_skb,
>> +	.uninit = &t7xx_devlink_uninit,
>> +	.enable_chl = &t7xx_devlink_enable_chl,
>> +	.disable_chl = &t7xx_port_disable_chl,
>> +};
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_devlink.h b/drivers/net/wwan/t7xx/t7xx_port_devlink.h
>> new file mode 100644
>> index 000000000000..4074004110b8
>> --- /dev/null
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_devlink.h
>> @@ -0,0 +1,86 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only
>> + *
>> + * Copyright (c) 2022-2023, Intel Corporation.
>> + */
>> +
>> +#ifndef __T7XX_PORT_DEVLINK_H__
>> +#define __T7XX_PORT_DEVLINK_H__
>> +
>> +#include <net/devlink.h>
>> +#include <linux/string.h>
>> +
>> +#include "t7xx_pci.h"
>> +
>> +#define T7XX_MAX_QUEUE_LENGTH 32
>> +#define T7XX_FB_COMMAND_SIZE  64
>> +#define T7XX_FB_RESPONSE_SIZE 512
>> +#define T7XX_FB_MCMD_SIZE     64
>> +#define T7XX_FB_MDATA_SIZE    1024
>> +#define T7XX_FB_RESP_COUNT    30
>> +
>> +#define T7XX_FB_CMD_RTS          "_RTS"
>> +#define T7XX_FB_CMD_CTS          "_CTS"
>> +#define T7XX_FB_CMD_FIN          "_FIN"
>> +#define T7XX_FB_CMD_OEM_MRDUMP   "oem mrdump"
>> +#define T7XX_FB_CMD_OEM_LKDUMP   "oem dump_pllk_log"
>> +#define T7XX_FB_CMD_DOWNLOAD     "download"
>> +#define T7XX_FB_CMD_FLASH        "flash"
>> +#define T7XX_FB_CMD_REBOOT       "reboot"
>> +#define T7XX_FB_RESP_MRDUMP_DONE "MRDUMP08_DONE"
>> +#define T7XX_FB_RESP_OKAY        "OKAY"
>> +#define T7XX_FB_RESP_FAIL        "FAIL"
>> +#define T7XX_FB_RESP_DATA        "DATA"
>> +#define T7XX_FB_RESP_INFO        "INFO"
>> +#define T7XX_FB_CMD_GET_VER      "get_version"
>> +
>> +#define T7XX_FB_EVENT_SIZE      50
>> +
>> +#define T7XX_MAX_SNAPSHOTS  1
>> +#define T7XX_MRDUMP_SIZE    (160 * 1024 * 1024)
>> +#define T7XX_LKDUMP_SIZE    (256 * 1024)
>> +#define T7XX_TOTAL_REGIONS  2
>> +
>> +#define T7XX_FLASH_STATUS   0
>> +#define T7XX_MRDUMP_STATUS  1
>> +#define T7XX_LKDUMP_STATUS  2
>> +#define T7XX_GET_INFO       3
>> +#define T7XX_DEVLINK_IDLE   0
>> +
>> +#define T7XX_NORMAL_MODE    0
>> +#define T7XX_FB_DL_MODE     1
>> +#define T7XX_FB_DUMP_MODE   2
>> +
>> +/* Internal region indexes */
>> +enum t7xx_regions {
>> +	T7XX_MRDUMP_INDEX,
>> +	T7XX_LKDUMP_INDEX,
>> +};
>> +
>> +struct t7xx_devlink_region_info {
>> +	const char *name;
>> +	size_t size;
>> +};
>> +
>> +struct t7xx_devlink_region {
>> +	struct t7xx_devlink_region_info *info;
>> +	struct devlink_region_ops ops;
>> +	struct devlink_region *dlreg;
>> +	void *buf;
>> +};
>> +
>> +struct t7xx_devlink {
>> +	struct t7xx_devlink_region regions[T7XX_TOTAL_REGIONS];
>> +	struct t7xx_pci_dev *t7xx_dev;
>> +	struct workqueue_struct *wq;
>> +	struct t7xx_port *port;
>> +	struct work_struct ws;
>> +	struct devlink *ctx;
>> +	unsigned long status;
>> +	u8 mode;
>> +};
>> +
>> +bool t7xx_devlink_param_get_fastboot(struct devlink *devlink);
>> +int t7xx_devlink_register(struct t7xx_pci_dev *t7xx_dev);
>> +void t7xx_devlink_unregister(struct t7xx_pci_dev *t7xx_dev);
>> +
>> +#endif /*__T7XX_PORT_DEVLINK_H__*/
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> index b457e8da098e..5cc03a5a9bcc 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> @@ -40,6 +40,7 @@
>>   #define Q_IDX_CTRL			0
>>   #define Q_IDX_MBIM			2
>>   #define Q_IDX_AT_CMD			5
>> +#define Q_IDX_AP_MSG			2
>>   
>>   #define INVALID_SEQ_NUM			GENMASK(15, 0)
>>   
>> @@ -97,7 +98,18 @@ static const struct t7xx_port_conf t7xx_port_conf[] = {
>>   		.path_id = CLDMA_ID_AP,
>>   		.ops = &ctl_port_ops,
>>   		.name = "t7xx_ap_ctrl",
>> +	}, {
>> +		.tx_ch = PORT_CH_AP_MSG_TX,
>> +		.rx_ch = PORT_CH_AP_MSG_RX,
>> +		.txq_index = Q_IDX_AP_MSG,
>> +		.rxq_index = Q_IDX_AP_MSG,
>> +		.txq_exp_index = Q_IDX_AP_MSG,
>> +		.rxq_exp_index = Q_IDX_AP_MSG,
>> +		.path_id = CLDMA_ID_AP,
>> +		.ops = &ap_msg_port_ops,
>> +		.name = "ap_msg",
>>   	},
>> +
>>   };
>>   
>>   static struct t7xx_port_conf t7xx_early_port_conf[] = {
>> @@ -109,6 +121,8 @@ static struct t7xx_port_conf t7xx_early_port_conf[] = {
>>   		.txq_exp_index = CLDMA_Q_IDX_DUMP,
>>   		.rxq_exp_index = CLDMA_Q_IDX_DUMP,
>>   		.path_id = CLDMA_ID_AP,
>> +		.ops = &devlink_port_ops,
>> +		.name = "devlink",
>>   	},
>>   };
>>   
>> @@ -325,6 +339,24 @@ int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int
>>   	return t7xx_port_send_ccci_skb(port, skb, pkt_header, ex_msg);
>>   }
>>   
>> +int t7xx_port_enable_chl(struct t7xx_port *port)
>> +{
>> +	spin_lock(&port->port_update_lock);
>> +	port->chan_enable = true;
>> +	spin_unlock(&port->port_update_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +int t7xx_port_disable_chl(struct t7xx_port *port)
>> +{
>> +	spin_lock(&port->port_update_lock);
>> +	port->chan_enable = false;
>> +	spin_unlock(&port->port_update_lock);
>> +
>> +	return 0;
>> +}
>> +
>>   static void t7xx_proxy_setup_ch_mapping(struct port_proxy *port_prox)
>>   {
>>   	struct t7xx_port *port;
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> index 0f3fb53259b7..b86594ed0458 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> @@ -93,6 +93,8 @@ struct ctrl_msg_header {
>>   /* Port operations mapping */
>>   extern struct port_ops wwan_sub_port_ops;
>>   extern struct port_ops ctl_port_ops;
>> +extern struct port_ops devlink_port_ops;
>> +extern struct port_ops ap_msg_port_ops;
>>   
>>   #ifdef CONFIG_WWAN_DEBUGFS
>>   extern struct port_ops t7xx_trace_port_ops;
>> @@ -108,5 +110,7 @@ int t7xx_port_proxy_chl_enable_disable(struct port_proxy *port_prox, unsigned in
>>   void t7xx_port_proxy_set_cfg(struct t7xx_modem *md, enum port_cfg_id cfg_id);
>>   int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb);
>>   int t7xx_port_proxy_recv_skb_from_dedicated_queue(struct cldma_queue *queue, struct sk_buff *skb);
>> +int t7xx_port_enable_chl(struct t7xx_port *port);
>> +int t7xx_port_disable_chl(struct t7xx_port *port);
>>   
>>   #endif /* __T7XX_PORT_PROXY_H__ */
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> index 33fa8c22598a..183dc6e97760 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> @@ -134,24 +134,6 @@ static int t7xx_port_wwan_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
>>   	return 0;
>>   }
>>   
>> -static int t7xx_port_wwan_enable_chl(struct t7xx_port *port)
>> -{
>> -	spin_lock(&port->port_update_lock);
>> -	port->chan_enable = true;
>> -	spin_unlock(&port->port_update_lock);
>> -
>> -	return 0;
>> -}
>> -
>> -static int t7xx_port_wwan_disable_chl(struct t7xx_port *port)
>> -{
>> -	spin_lock(&port->port_update_lock);
>> -	port->chan_enable = false;
>> -	spin_unlock(&port->port_update_lock);
>> -
>> -	return 0;
>> -}
>> -
>>   static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int state)
>>   {
>>   	const struct t7xx_port_conf *port_conf = port->port_conf;
>> @@ -171,7 +153,7 @@ struct port_ops wwan_sub_port_ops = {
>>   	.init = t7xx_port_wwan_init,
>>   	.recv_skb = t7xx_port_wwan_recv_skb,
>>   	.uninit = t7xx_port_wwan_uninit,
>> -	.enable_chl = t7xx_port_wwan_enable_chl,
>> -	.disable_chl = t7xx_port_wwan_disable_chl,
>> +	.enable_chl = t7xx_port_enable_chl,
>> +	.disable_chl = t7xx_port_disable_chl,
>>   	.md_state_notify = t7xx_port_wwan_md_state_notify,
>>   };
>> diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
>> index 3b665c6116fe..d27ba45b12ec 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_reg.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_reg.h
>> @@ -101,10 +101,16 @@ enum t7xx_pm_resume_state {
>>   	PM_RESUME_REG_STATE_L2_EXP,
>>   };
>>   
>> +enum host_event_e {
>> +	HOST_EVENT_INIT = 0,
>> +	FASTBOOT_DL_NOTIFY = 0x3,
>> +};
>> +
>>   #define T7XX_PCIE_MISC_DEV_STATUS		0x0d1c
>>   #define MISC_RESET_TYPE_FLDR			BIT(27)
>>   #define MISC_RESET_TYPE_PLDR			BIT(26)
>>   #define MISC_LK_EVENT_MASK			GENMASK(11, 8)
>> +#define HOST_EVENT_MASK                        GENMASK(31, 28)
>>   
>>   enum lk_event_id {
>>   	LK_EVENT_NORMAL = 0,
>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> index 6e957d3c0490..ed00f8834c76 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>> @@ -37,6 +37,7 @@
>>   #include "t7xx_modem_ops.h"
>>   #include "t7xx_pci.h"
>>   #include "t7xx_pcie_mac.h"
>> +#include "t7xx_port_devlink.h"
>>   #include "t7xx_port_proxy.h"
>>   #include "t7xx_reg.h"
>>   #include "t7xx_state_monitor.h"
>> @@ -206,11 +207,22 @@ static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
>>   		fsm_finish_command(ctl, cmd, 0);
>>   }
>>   
>> +static void t7xx_host_event_notify(struct t7xx_modem *md, unsigned int event_id)
>> +{
>> +	u32 value;
>> +
>> +	value = ioread32(IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> +	value &= ~HOST_EVENT_MASK;
>> +	value |= FIELD_PREP(HOST_EVENT_MASK, event_id);
>> +	iowrite32(value, IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
>> +}
>> +
>>   static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int status)
>>   {
>>   	struct t7xx_modem *md = ctl->md;
>>   	struct cldma_ctrl *md_ctrl;
>>   	enum lk_event_id lk_event;
>> +	struct t7xx_port *port;
>>   	struct device *dev;
>>   
>>   	dev = &md->t7xx_dev->pdev->dev;
>> @@ -221,10 +233,21 @@ static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int
>>   		break;
>>   
>>   	case LK_EVENT_CREATE_PD_PORT:
>> +	case LK_EVENT_CREATE_POST_DL_PORT:
>>   		md_ctrl = md->md_ctrl[CLDMA_ID_AP];
>>   		t7xx_cldma_hif_hw_init(md_ctrl);
>>   		t7xx_cldma_stop(md_ctrl);
>>   		t7xx_cldma_switch_cfg(md_ctrl, CLDMA_DEDICATED_Q_CFG);
>> +		port = ctl->md->t7xx_dev->dl->port;
>> +		if (WARN_ON(!port))
>> +			return;
>> +
>> +		if (lk_event == LK_EVENT_CREATE_PD_PORT)
>> +			md->t7xx_dev->dl->mode = T7XX_FB_DUMP_MODE;
>> +		else
>> +			md->t7xx_dev->dl->mode = T7XX_FB_DL_MODE;
>> +
>> +		port->port_conf->ops->enable_chl(port);
>>   		t7xx_cldma_start(md_ctrl);
>>   		break;
>>   
>> @@ -271,13 +294,23 @@ static void fsm_routine_stopping(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comma
>>   	t7xx_cldma_stop(md_ctrl);
>>   
>>   	if (!ctl->md->rgu_irq_asserted) {
>> +		if (t7xx_devlink_param_get_fastboot(t7xx_dev->dl->ctx))
>> +			t7xx_host_event_notify(ctl->md, FASTBOOT_DL_NOTIFY);
>> +
>>   		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DRM_DISABLE_AP);
>>   		/* Wait for the DRM disable to take effect */
>>   		msleep(FSM_DRM_DISABLE_DELAY_MS);
>>   
>> -		err = t7xx_acpi_fldr_func(t7xx_dev);
>> -		if (err)
>> +		if (t7xx_devlink_param_get_fastboot(t7xx_dev->dl->ctx)) {
>> +			/* Do not try fldr because device will always wait for
>> +			 * MHCCIF bit 13 in fastboot download flow.
>> +			 */
>>   			t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DEVICE_RESET);
>> +		} else {
>> +			err = t7xx_acpi_fldr_func(t7xx_dev);
>> +			if (err)
>> +				t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DEVICE_RESET);
>> +		}
>>   	}
>>   
>>   	fsm_finish_command(ctl, cmd, fsm_stopped_handler(ctl));
>>
> 

-- 
Chetan

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D5252F47D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 22:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345820AbiETUhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 16:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiETUhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 16:37:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F31918540E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 13:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653079065; x=1684615065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TTbOtG5yRv5GAPi2uQocqyBI8VFgMPofyE1xWHBEWJs=;
  b=Fn9gpNoO9OaNTxIcllbD/wBnNLbhf5rk0CUVfFtKvY/jVeaJNOqoh0yi
   TSchHiH7gmO/H98UWZdrYlYpY0MFFLNfVFXf72WGx5H54ncdhe6WteO8y
   lC+x/jRRo0pAt4YhTW8mjhBukkLhUjL2NyliYf8K2NTAaoUkhfJTaiK3Y
   Hd4I9E6p6B6+n5wIYvDS3TKUwULEW7KE0HcvUUELes9mzvVRz6BVwLGmS
   iX3mRud67aAcDSOL0adJHBa/ucz4Wlhfn1oxlveub7XYPAj6QU/1gPlrr
   53CUijRMKmgfqXhHemxR6IlKAhXh2oGBSKxnQ3ugS1RPPqhz5YJ025xMY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="298044913"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="298044913"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 13:37:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="743666724"
Received: from vckummar-mobl.amr.corp.intel.com (HELO [10.209.85.227]) ([10.209.85.227])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 13:37:44 -0700
Message-ID: <72b815c4-0903-6d5e-c5a2-891fe16f884a@linux.intel.com>
Date:   Fri, 20 May 2022 13:37:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
Content-Language: en-US
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        linuxwwan <linuxwwan@intel.com>,
        "Liu, Haijun" <haijun.liu@mediatek.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
 <SJ0PR11MB50085483433229CC9E4BCED0D7D39@SJ0PR11MB5008.namprd11.prod.outlook.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <SJ0PR11MB50085483433229CC9E4BCED0D7D39@SJ0PR11MB5008.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/20/22 01:33, Kumar, M Chetan wrote:
>> -----Original Message-----
>> From: Moises Veleta <moises.veleta@linux.intel.com>
>> Sent: Thursday, May 19, 2022 11:57 PM
>> To: netdev@vger.kernel.org
>> Cc: kuba@kernel.org; davem@davemloft.net; johannes@sipsolutions.net;
>> ryazanov.s.a@gmail.com; loic.poulain@linaro.org; Kumar, M Chetan
>> <m.chetan.kumar@intel.com>; Devegowda, Chandrashekar
>> <chandrashekar.devegowda@intel.com>; linuxwwan
>> <linuxwwan@intel.com>; Liu, Haijun <haijun.liu@mediatek.com>;
>> andriy.shevchenko@linux.intel.com; ilpo.jarvinen@linux.intel.com;
>> ricardo.martinez@linux.intel.com; Kancharla, Sreehari
>> <sreehari.kancharla@intel.com>; Sharma, Dinesh
>> <dinesh.sharma@intel.com>; Moises Veleta
>> <moises.veleta@linux.intel.com>
>> Subject: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
>>
>> The Modem Logging (MDL) port provides an interface to collect modem logs
>> for debugging purposes. MDL is supported by debugfs, the relay interface,
>> and the mtk_t7xx port infrastructure. MDL allows user-space applications to
>> control logging via debugfs and to collect logs via the relay interface, while
>> port infrastructure facilitates communication between the driver and the
>> modem.
>>
>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> ---
>>   drivers/net/wwan/Kconfig                |   1 +
>>   drivers/net/wwan/t7xx/Makefile          |   3 +
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.c  |   2 +
>>   drivers/net/wwan/t7xx/t7xx_port.h       |   5 +
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.c |  22 +++
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.h |   4 +
>>   drivers/net/wwan/t7xx/t7xx_port_trace.c | 174
>> ++++++++++++++++++++++++
>>   7 files changed, 211 insertions(+)
>>   create mode 100644 drivers/net/wwan/t7xx/t7xx_port_trace.c
>>
>> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig index
>> 3486ffe94ac4..32149029c891 100644
>> --- a/drivers/net/wwan/Kconfig
>> +++ b/drivers/net/wwan/Kconfig
>> @@ -108,6 +108,7 @@ config IOSM
>>   config MTK_T7XX
>>   	tristate "MediaTek PCIe 5G WWAN modem T7xx device"
>>   	depends on PCI
>> +	select RELAY if WWAN_DEBUGFS
>>   	help
>>   	  Enables MediaTek PCIe based 5G WWAN modem (T7xx series)
>> device.
>>   	  Adapts WWAN framework and provides network interface like
>> wwan0 diff --git a/drivers/net/wwan/t7xx/Makefile
>> b/drivers/net/wwan/t7xx/Makefile index dc6a7d682c15..268ff9e87e5b
>> 100644
>> --- a/drivers/net/wwan/t7xx/Makefile
>> +++ b/drivers/net/wwan/t7xx/Makefile
>> @@ -18,3 +18,6 @@ mtk_t7xx-y:=	t7xx_pci.o \
>>   		t7xx_hif_dpmaif_rx.o  \
>>   		t7xx_dpmaif.o \
>>   		t7xx_netdev.o
>> +
>> +mtk_t7xx-$(CONFIG_WWAN_DEBUGFS) += \
>> +		t7xx_port_trace.o \
> Drop \
>
Will do, thanks.
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> index 0c52801ed0de..dcd480720edf 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
>> @@ -1018,6 +1018,8 @@ static int t7xx_cldma_late_init(struct cldma_ctrl
>> *md_ctrl)
>>   			dev_err(md_ctrl->dev, "control TX ring init fail\n");
>>   			goto err_free_tx_ring;
>>   		}
>> +
>> +		md_ctrl->tx_ring[i].pkt_size = CLDMA_MTU;
>>   	}
>>
>>   	for (j = 0; j < CLDMA_RXQ_NUM; j++) {
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h
>> b/drivers/net/wwan/t7xx/t7xx_port.h
>> index dc4133eb433a..e35efb18ea09 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>> @@ -122,10 +122,15 @@ struct t7xx_port {
>>   	int				rx_length_th;
>>   	bool				chan_enable;
>>   	struct task_struct		*thread;
>> +#ifdef CONFIG_WWAN_DEBUGFS
>> +	struct t7xx_trace		*trace;
>> +	struct dentry			*debugfs_dir;
>> +#endif
>>   };
>>
>>   struct sk_buff *t7xx_port_alloc_skb(int payload);  struct sk_buff
>> *t7xx_ctrl_alloc_skb(int payload);
>> +int t7xx_port_mtu(struct t7xx_port *port);
>>   int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb);  int
>> t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned int
>> pkt_header,
>>   		       unsigned int ex_msg);
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> index 7d2c0e81e33d..fb9d057d6a84 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> @@ -70,6 +70,18 @@ static const struct t7xx_port_conf
>> t7xx_md_port_conf[] = {
>>   		.name = "MBIM",
>>   		.port_type = WWAN_PORT_MBIM,
>>   	}, {
>> +#ifdef CONFIG_WWAN_DEBUGFS
>> +		.tx_ch = PORT_CH_MD_LOG_TX,
>> +		.rx_ch = PORT_CH_MD_LOG_RX,
>> +		.txq_index = 7,
>> +		.rxq_index = 7,
>> +		.txq_exp_index = 7,
>> +		.rxq_exp_index = 7,
>> +		.path_id = CLDMA_ID_MD,
>> +		.ops = &t7xx_trace_port_ops,
>> +		.name = "mdlog",
>> +	}, {
>> +#endif
> Why do you want keep mdlog port under flag ?
>
Modem logging will depends WWAN debugfs functions which also use this 
flag. Also, it should only be built on a debugging image with 
CONFIG_WWAN_DEBUGFS and not by default.

>>   		.tx_ch = PORT_CH_CONTROL_TX,
>>   		.rx_ch = PORT_CH_CONTROL_RX,
>>   		.txq_index = Q_IDX_CTRL,
>> @@ -194,6 +206,16 @@ int t7xx_port_enqueue_skb(struct t7xx_port *port,
>> struct sk_buff *skb)
>>   	return 0;
>>   }
>>
>> +int t7xx_port_mtu(struct t7xx_port *port) {
>> +	enum cldma_id path_id = port->port_conf->path_id;
>> +	int tx_qno = t7xx_port_get_queue_no(port);
>> +	struct cldma_ctrl *md_ctrl;
>> +
>> +	md_ctrl = port->t7xx_dev->md->md_ctrl[path_id];
>> +	return md_ctrl->tx_ring[tx_qno].pkt_size;
>> +}
>> +
>>   static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff
>> *skb)  {
>>   	enum cldma_id path_id = port->port_conf->path_id; diff --git
>> a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> index bc1ff5c6c700..81d059fbc0fb 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> @@ -87,6 +87,10 @@ struct ctrl_msg_header {  extern struct port_ops
>> wwan_sub_port_ops;  extern struct port_ops ctl_port_ops;
>>
>> +#ifdef CONFIG_WWAN_DEBUGFS
>> +extern struct port_ops t7xx_trace_port_ops; #endif
>> +
>>   void t7xx_port_proxy_reset(struct port_proxy *port_prox);  void
>> t7xx_port_proxy_uninit(struct port_proxy *port_prox);  int
>> t7xx_port_proxy_init(struct t7xx_modem *md); diff --git
>> a/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> b/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> new file mode 100644
>> index 000000000000..87529316b183
>> --- /dev/null
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> @@ -0,0 +1,174 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2022 Intel Corporation.
>> + */
>> +
>> +#include <linux/bitfield.h>
>> +#include <linux/debugfs.h>
>> +#include <linux/relay.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/wwan.h>
>> +
>> +#include "t7xx_port.h"
>> +#include "t7xx_port_proxy.h"
>> +#include "t7xx_state_monitor.h"
>> +
>> +#define T7XX_TRC_SUB_BUFF_SIZE		131072
>> +#define T7XX_TRC_N_SUB_BUFF		32
>> +#define T7XX_TRC_FILE_PERM		0600
>> +
>> +struct t7xx_trace {
>> +	struct rchan			*t7xx_rchan;
>> +	struct dentry			*ctrl_file;
>> +};
>> +
>> +static struct dentry *t7xx_trace_create_buf_file_handler(const char
>> *filename,
>> +							 struct dentry
>> *parent,
>> +							 umode_t mode,
>> +							 struct rchan_buf
>> *buf,
>> +							 int *is_global)
>> +{
>> +	*is_global = 1;
>> +	return debugfs_create_file(filename, mode, parent, buf,
>> +				   &relay_file_operations);
>> +}
>> +
>> +static int t7xx_trace_remove_buf_file_handler(struct dentry *dentry) {
>> +	debugfs_remove(dentry);
>> +	return 0;
>> +}
>> +
>> +static int t7xx_trace_subbuf_start_handler(struct rchan_buf *buf, void
>> *subbuf,
>> +					   void *prev_subbuf,
>> +					   size_t prev_padding)
>> +{
>> +	if (relay_buf_full(buf)) {
>> +		pr_err_ratelimited("Relay_buf full dropping traces");
>> +		return 0;
>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +static struct rchan_callbacks relay_callbacks = {
>> +	.subbuf_start = t7xx_trace_subbuf_start_handler,
>> +	.create_buf_file = t7xx_trace_create_buf_file_handler,
>> +	.remove_buf_file = t7xx_trace_remove_buf_file_handler,
>> +};
>> +
>> +static ssize_t t7xx_port_trace_write(struct file *file, const char __user *buf,
>> +				     size_t len, loff_t *ppos)
>> +{
>> +	struct t7xx_port *port = file->private_data;
>> +	size_t actual_len, alloc_size, txq_mtu;
>> +	const struct t7xx_port_conf *port_conf;
>> +	enum md_state md_state;
>> +	struct sk_buff *skb;
>> +	int ret;
>> +
>> +	port_conf = port->port_conf;
>> +	md_state = t7xx_fsm_get_md_state(port->t7xx_dev->md->fsm_ctl);
>> +	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state ==
>> MD_STATE_WAITING_FOR_HS2) {
>> +		dev_warn(port->dev, "port: %s ch: %d, write fail when
>> md_state: %d\n",
>> +			 port_conf->name, port_conf->tx_ch, md_state);
>> +		return -ENODEV;
>> +	}
> This means debugfs knob is available to application even before driver & device handshake
>   is complete. Is not possible to defer debugfs knob creation until handshake is complete ?
We can implement a "md_state_notify" method, like the one that is done 
for t7xx_port_wwan_md_state_notify, to remedy this issue.
>> +
>> +	txq_mtu = t7xx_port_mtu(port);
>> +	alloc_size = min_t(size_t, txq_mtu, len + sizeof(struct ccci_header));
> To keep it even we can drop +sizeof(struct ccci_header).
Ok, we can drop actual_len and just use alloc_size if we subtract the 
sizeof ccci_header, as such:

     alloc_size = min_t(size_t, txq_mtu - sizeof(struct ccci_header), len);

     skb = t7xx_port_alloc_skb(alloc_size);

This removes the need for actual_len altogether.

>> +	actual_len = alloc_size - sizeof(struct ccci_header);
>> +	skb = t7xx_port_alloc_skb(alloc_size);
> alloc_size contains the actual len and t7xx_port_alloc_skb() is considering alloc_size +
> sizeof(struct ccci_header); So actual_len calculation is redundant.
Should be addressed with the change mentioned above for alloc_size.
>> +	if (!skb) {
>> +		ret = -ENOMEM;
>> +		goto err_out;
> In skb failure case an attempt is made to free skb() by calling dev_kfree_skb().
> Better to add new label and simply return ?
No need for label, we can just return since its a skb allocation error.

     skb = t7xx_port_alloc_skb(alloc_size);
     if (!skb)

         return -ENOMEM;

This is similar to the skb error return in t7xx_port_ctrl_tx in 
t7xx_port_wwan.

>> +	}
>> +
>> +	ret = copy_from_user(skb_put(skb, actual_len), buf, actual_len);
>> +	if (ret) {
>> +		ret = -EFAULT;
>> +		goto err_out;
>> +	}
>> +
>> +	ret = t7xx_port_send_skb(port, skb, 0, 0);
>> +	if (ret)
>> +		goto err_out;
>> +
>> +	return actual_len;
> If len report is txq_mtu then actual_len is returning - sizeof(struct ccci_header);
> Instead return len.
>
Should be addressed with the change mentioned above for alloc_size.
>> +
>> +err_out:
>> +	dev_err(port->dev, "write error done on %s, size: %zu, ret: %d\n",
>> +		port_conf->name, actual_len, ret);
>> +	dev_kfree_skb(skb);
>> +	return ret;
>> +}
>> +
>> +static const struct file_operations t7xx_trace_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open = simple_open,
>> +	.write = t7xx_port_trace_write,
>> +};
>> +
>> +static int t7xx_trace_port_init(struct t7xx_port *port) {
>> +	struct dentry *debugfs_pdev = wwan_get_debugfs_dir(port->dev);
>> +
>> +	if (IS_ERR(debugfs_pdev))
>> +		debugfs_pdev = NULL;
>> +
>> +	port->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
>> debugfs_pdev);
>> +	if (IS_ERR_OR_NULL(port->debugfs_dir))
>> +		return -ENOMEM;
>> +
>> +	port->trace = devm_kzalloc(port->dev, sizeof(*port->trace),
>> GFP_KERNEL);
>> +	if (!port->trace)
>> +		goto err_debugfs_dir;
>> +
>> +	port->trace->ctrl_file = debugfs_create_file("mdlog_ctrl",
>> +						     T7XX_TRC_FILE_PERM,
>> +						     port->debugfs_dir,
>> +						     port,
>> +						     &t7xx_trace_fops);
>> +	if (!port->trace->ctrl_file)
>> +		goto err_debugfs_dir;
>> +
>> +	port->trace->t7xx_rchan = relay_open("relay_ch",
>> +					     port->debugfs_dir,
>> +					     T7XX_TRC_SUB_BUFF_SIZE,
>> +					     T7XX_TRC_N_SUB_BUFF,
>> +					     &relay_callbacks, NULL);
>> +	if (!port->trace->t7xx_rchan)
>> +		goto err_debugfs_dir;
> Even though trace resource is allocated using managed API good to call devm_kfree() in error paths ?
To my understanding, we not do need call "devm_kfree()" in error paths. 
If anyone can comment on this further, please do.
>> +
>> +	return 0;
>> +
>> +err_debugfs_dir:
>> +	debugfs_remove_recursive(port->debugfs_dir);
>> +	return -ENOMEM;
>> +}
>> +
>> +static void t7xx_trace_port_uninit(struct t7xx_port *port) {
>> +	struct t7xx_trace *trace = port->trace;
>> +
>> +	relay_close(trace->t7xx_rchan);
>> +	debugfs_remove_recursive(port->debugfs_dir);
>> +}
>> +
>> +static int t7xx_trace_port_recv_skb(struct t7xx_port *port, struct
>> +sk_buff *skb) {
>> +	struct t7xx_trace *t7xx_trace = port->trace;
>> +
>> +	if (!t7xx_trace->t7xx_rchan)
>> +		return -EINVAL;
> skb free not required is it considered by caller ?
>
We can change this to

     if (t7xx_trace->t7xx_rchan)
         relay_write(t7xx_trace->t7xx_rchan, skb->data, skb->len);

     dev_kfree_skb(skb);
     return 0;

This would drop skb if there is an issue with the relay channel that is 
out of our control.

>> +
>> +	relay_write(t7xx_trace->t7xx_rchan, skb->data, skb->len);
>> +	dev_kfree_skb(skb);
>> +	return 0;
>> +}

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B01B5998C1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347758AbiHSJ0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347832AbiHSJ0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:26:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040BBF43B8
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660901208; x=1692437208;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rpkf8DWCHVCTyICV74pbQ4Gsds06pRg+DkS+29Posv8=;
  b=USSsvzkvnNtWXtPiGF4k3jPHLU5Jgajb061ZJHn9WcRDi/fQ8NZLI5xM
   wgw3G7v3yApOx3XV6MfQHPqM1XsfN0Hk8qVKgyYl/Nqrq8h0FXkOOBZ73
   QxAkQMzMKKa0SvXnhHbyUMftVr1Bo3oYYRBfgN7Een0AxpFVrVsByJsWI
   N6S+L70y8r9oq4jjgd1MzL4Ra0Te6pNWCglQBPVNjHA3E17CtFFzfqFIZ
   pcNLpEmmGyEu0nT/UKCuqc2GD/75i/Ccdwhtq0RooJWm27oPouOttZy5J
   +h28hSlNwpUaah/+nf5BiRfNJhzkhNjTkOXUzIoZ5/Su8ZESRUl74PYk/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="291732507"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="291732507"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 02:26:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="637208270"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.66.88.86]) ([10.66.88.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 02:26:43 -0700
Message-ID: <4c5dbea0-52a9-1c3d-7547-00ea54c90550@linux.intel.com>
Date:   Fri, 19 Aug 2022 14:56:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     m.chetan.kumar@intel.com, Netdev <netdev@vger.kernel.org>,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
 <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
 <1ff95a2c-c648-aea2-be23-0d4bf8a9b3d7@linux.intel.com>
 <63bdb859-eda-5488-60b8-fc305ea39f31@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <63bdb859-eda-5488-60b8-fc305ea39f31@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/2022 4:18 PM, Ilpo Järvinen wrote:
> On Wed, 17 Aug 2022, Kumar, M Chetan wrote:
> 
>>
>> On 8/17/2022 5:40 PM, Ilpo Järvinen wrote:
>>> On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:
>>>
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>>> To support cases such as FW update or Core dump, the t7xx device
>>>> is capable of signaling the host that a special port needs
>>>> to be created before the handshake phase.
>>>>
>>>> This patch adds the infrastructure required to create the
>>>> early ports which also requires a different configuration of
>>>> CLDMA queues.
>>>>
>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>>>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>> ---
>>>
>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h
>>>> b/drivers/net/wwan/t7xx/t7xx_port.h
>>>> index 4a29bd04cbe2..6a96ee6d9449 100644
>>>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>>>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>>>> @@ -100,6 +100,7 @@ struct t7xx_port_conf {
>>>>    	struct port_ops		*ops;
>>>>    	char			*name;
>>>>    	enum wwan_port_type	port_type;
>>>> +	bool			is_early_port;
>>>>    };
>>>>      struct t7xx_port {
>>>> @@ -130,9 +131,11 @@ struct t7xx_port {
>>>>    	struct task_struct		*thread;
>>>>    };
>>>>    +int t7xx_get_port_mtu(struct t7xx_port *port);
>>>>    struct sk_buff *t7xx_port_alloc_skb(int payload);
>>>>    struct sk_buff *t7xx_ctrl_alloc_skb(int payload);
>>>>    int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb);
>>>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb);
>>>>    int t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb,
>>>> unsigned int pkt_header,
>>>>    		       unsigned int ex_msg);
>>>>    int t7xx_port_send_ctl_skb(struct t7xx_port *port, struct sk_buff *skb,
>>>> unsigned int msg,
>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>>>> b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>>>> index 62305d59da90..7582777cf94d 100644
>>>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>>>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>>>> @@ -88,6 +88,20 @@ static const struct t7xx_port_conf t7xx_md_port_conf[]
>>>> = {
>>>>    	},
>>>>    };
>>>>    +static struct t7xx_port_conf t7xx_early_port_conf[] = {
>>>> +	{
>>>> +		.tx_ch = 0xffff,
>>>> +		.rx_ch = 0xffff,
>>>> +		.txq_index = 1,
>>>> +		.rxq_index = 1,
>>>> +		.txq_exp_index = 1,
>>>> +		.rxq_exp_index = 1,
>>>> +		.path_id = CLDMA_ID_AP,
>>>> +		.is_early_port = true,
>>>> +		.name = "ttyDUMP",
>>>> +	},
>>>> +};
>>>> +
>>>>    static struct t7xx_port *t7xx_proxy_get_port_by_ch(struct port_proxy
>>>> *port_prox, enum port_ch ch)
>>>>    {
>>>>    	const struct t7xx_port_conf *port_conf;
>>>> @@ -202,7 +216,17 @@ int t7xx_port_enqueue_skb(struct t7xx_port *port,
>>>> struct sk_buff *skb)
>>>>    	return 0;
>>>>    }
>>>>    -static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct
>>>> sk_buff *skb)
>>>> +int t7xx_get_port_mtu(struct t7xx_port *port)
>>>> +{
>>>> +	enum cldma_id path_id = port->port_conf->path_id;
>>>> +	int tx_qno = t7xx_port_get_queue_no(port);
>>>> +	struct cldma_ctrl *md_ctrl;
>>>> +
>>>> +	md_ctrl = port->t7xx_dev->md->md_ctrl[path_id];
>>>> +	return md_ctrl->tx_ring[tx_qno].pkt_size;
>>>> +}
>>>> +
>>>> +int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff *skb)
>>>
>>> Why you removed static from this function here (+add the prototype into a
>>> header), I cannot see anything in this patch. Perhaps those changes belong
>>> to patch 4?
>>
>> Prototype is added in header file. Patch4 is using this func.
> 
> Thus, put those two changes (proto + static removal) into patch 4.

Patch is merged.
Please help to get it revert so that we could address review comments 
and post v2 series.

> 
>>>>    {
>>>>    	enum cldma_id path_id = port->port_conf->path_id;
>>>>    	struct cldma_ctrl *md_ctrl;
>>>> @@ -317,6 +341,26 @@ static void t7xx_proxy_setup_ch_mapping(struct
>>>> port_proxy *port_prox)
>>>>    	}
>>>>    }
>>>>    +static int t7xx_port_proxy_recv_skb_from_queue(struct t7xx_pci_dev
>>>> *t7xx_dev,
>>>> +					       struct cldma_queue *queue,
>>>> struct sk_buff *skb)
>>>> +{
>>>> +	struct port_proxy *port_prox = t7xx_dev->md->port_prox;
>>>> +	const struct t7xx_port_conf *port_conf;
>>>> +	struct t7xx_port *port;
>>>> +	int ret;
>>>> +
>>>> +	port = port_prox->ports;
>>>> +	port_conf = port->port_conf;
>>>> +
>>>> +	ret = port_conf->ops->recv_skb(port, skb);
>>>> +	if (ret < 0 && ret != -ENOBUFS) {
>>>> +		dev_err(port->dev, "drop on RX ch %d, %d\n", port_conf->rx_ch,
>>>> ret);
>>>> +		dev_kfree_skb_any(skb);
>>>> +	}
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>>    static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev
>>>> *t7xx_dev,
>>>>    						   struct cldma_queue *queue,
>>>> u16 channel)
>>>>    {
>>>> @@ -338,6 +382,22 @@ static struct t7xx_port
>>>> *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev
>>>>    	return NULL;
>>>>    }
>>>>    +struct t7xx_port *t7xx_port_proxy_get_port_by_name(struct port_proxy
>>>> *port_prox, char *port_name)
>>>> +{
>>>> +	const struct t7xx_port_conf *port_conf;
>>>> +	struct t7xx_port *port;
>>>> +	int i;
>>>> +
>>>> +	for_each_proxy_port(i, port, port_prox) {
>>>> +		port_conf = port->port_conf;
>>>> +
>>>> +		if (!strncmp(port_conf->name, port_name,
>>>> strlen(port_conf->name)))
>>>> +			return port;
>>>> +	}
>>>> +
>>>> +	return NULL;
>>>> +}
>>>> +
>>>>    /**
>>>>     * t7xx_port_proxy_recv_skb() - Dispatch received skb.
>>>>     * @queue: CLDMA queue.
>>>> @@ -358,6 +418,9 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue
>>>> *queue, struct sk_buff *s
>>>>    	u16 seq_num, channel;
>>>>    	int ret;
>>>>    +	if (queue->q_type == CLDMA_DEDICATED_Q)
>>>> +		return t7xx_port_proxy_recv_skb_from_queue(t7xx_dev, queue,
>>>> skb);
>>>> +
>>>
>>> So ->recv_skb() is per cldma but now you'd actually want to have a
>>> different one per queue?
>>
>> dump and download port uses different configuration (packet size is
>> different, received data doesn't contain header portion) so using q_type
>> to distinguish rx flow.
> 
> If you want to distinguish something by q_type and already have that func
> ptr for recv_skb() anyway, why not move the recv_skb() ptr to cldma_queue
> so you don't need to add any this kind of additional conditions to just
> call another kind of handler function?

Ok. We could push the recv_skb() from cldma_ctrl to cldma_queue and 
register queue specific handler function.

For dump/download port assoicated queue recv_skb() would be set to 
t7xx_port_proxy_recv_skb_from_queue() and t7xx_port_proxy_recv_skb() for 
rest. So with this cldma would directly push rx data to queue specific 
handler function.

> 
>>>>    	ret = port_conf->ops->recv_skb(port, skb);
>>>>    	/* Error indicates to try again later */
>>>> @@ -439,26 +503,58 @@ static void t7xx_proxy_init_all_ports(struct
>>>> t7xx_modem *md)
>>>>    	t7xx_proxy_setup_ch_mapping(port_prox);
>>>>    }
>>>>    +void t7xx_port_proxy_set_cfg(struct t7xx_modem *md, enum port_cfg_id
>>>> cfg_id)
>>>> +{
>>>> +	struct port_proxy *port_prox = md->port_prox;
>>>> +	const struct t7xx_port_conf *port_conf;
>>>> +	struct device *dev = port_prox->dev;
>>>> +	unsigned int port_count;
>>>> +	struct t7xx_port *port;
>>>> +	int i;
>>>> +
>>>> +	if (port_prox->cfg_id == cfg_id)
>>>> +		return;
>>>> +
>>>> +	if (port_prox->cfg_id != PORT_CFG_ID_INVALID) {
>>>
>>> This seems to be always true.
>>
>> In initialization flow it would be false.
>> Depending on boot stage, right port config would be chosen and
>> cfg_id reflects the chosen config.
> 
> Oh, I think I misunderstood the code here quite badly, so it depends on
> the initial value being 0?
> 
> But now I realize there's also the preceeding check that returns. ...So
> doesn't that then mean port_prox->cfg_id can only be PORT_CFG_ID_INVALID
> at this point or am I still missing something (making the whole block
> unnecessary)?

t7xx_port_proxy_set_cfg() is called from 2 different context.

1> t7xx_pci_probe() -> t7xx_md_init() -> t7xx_port_proxy_init() -> 
t7xx_proxy_alloc -> t7xx_port_proxy_set_cfg()
2> t7xx_pci_probe() -> t7xx_md_init()-> fsm_routine_start() -> 
t7xx_port_proxy_set_cfg()

In the first flow port_prox is allocated inside t7xx_proxy_alloc() and 
the port_prox->cfg_id is 0 (PORT_CFG_ID_INVALID) by default.

  	if (port_prox->cfg_id != PORT_CFG_ID_INVALID) {
		for_each_proxy_port(i, port, port_prox)
			port->port_conf->ops->uninit(port);

So at this point (above if statement) it will not enter if condition 
since port is not yet configured i.e port unit() is not required.

Since it is a early initalization phase, port is configured with early 
port configuration & port_prox->cfg_id is set to PORT_CFG_ID_EARLY.

Later fsm kicks in and device moves from boot phase to LINUX stage. At 
this point 2> port_prox->cfg_id will be having earlier value 
(PORT_CFG_ID_EARLY) so in this case it enters if condition and cleans up 
the early port.

Coming to below if block. This condition won't be met. On safer side 
will run few test around it and removed it in next patch.

if (port_prox->cfg_id == cfg_id)
	return;

> 
>>>> +		for_each_proxy_port(i, port, port_prox)
>>>> +			port->port_conf->ops->uninit(port);
> 
> This would be t7xx_port_proxy_uninit() I think.

Ya. We could replace it with t7xx_port_proxy_uninit().

> 
>>>> +		dev_err(dev, "invalid device status\n");
>>>> +		ret = -EINVAL;
>>>> +		goto finish_command;
>>>> +	}
>>>> +
>>>>    	ctl->curr_state = FSM_STATE_PRE_START;
>>>>    	t7xx_md_event_notify(md, FSM_PRE_START);
>>>>    -	ret = read_poll_timeout(ioread32, dev_status,
>>>> -				(dev_status & MISC_STAGE_MASK) == LINUX_STAGE,
>>>> 20000, 2000000,
>>>> -				false, IREG_BASE(md->t7xx_dev) +
>>>> T7XX_PCIE_MISC_DEV_STATUS);
>>>> -	if (ret) {
>>>> -		struct device *dev = &md->t7xx_dev->pdev->dev;
>>>> +	device_stage = FIELD_GET(MISC_STAGE_MASK, dev_status);
>>>> +	if (dev_status == ctl->prev_dev_status) {
>>>
>>> Maybe the local variables from need dev_ or device_ prefixes. They just
>>> makes them harder to read.
>>
>> Ok. will consider it.
> 
> I had quite bad English there, just to be sure we understood it anyway,
> I meant I don't think those prefixes benefit anything and could be
> removed.

Thanks for the clarification.
Will remove such prefixes in local variables.


-- 
Chetan

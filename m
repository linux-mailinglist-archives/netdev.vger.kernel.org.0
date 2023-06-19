Return-Path: <netdev+bounces-11948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4B0735675
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4C021C20A31
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A0AD536;
	Mon, 19 Jun 2023 12:07:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79A510944
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:07:46 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1612611D;
	Mon, 19 Jun 2023 05:07:43 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35JC7K2A099013;
	Mon, 19 Jun 2023 07:07:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1687176440;
	bh=vKaxUoT+OhES6xCDoeBwVBJgDkTE4k4YTgqOonwJPL4=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=jSS00dSeknNWOhd02gLDxY78GwOMkI0vxCZoU1/S2cdn9yCrGJmYXjJaoeHKAZlD0
	 2MA+EmlVcsr6cwucbD30j+fk+gjShI7UZUwlY8z1GdPWnnB3Yl6SLFJtS7ZfCdGj5s
	 9IlTzibPWzg5cTbNMKb/JvOENCG9R4x8R1LbTxAU=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35JC7Kdf126513
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Jun 2023 07:07:20 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 19
 Jun 2023 07:07:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 19 Jun 2023 07:07:20 -0500
Received: from [10.24.69.79] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35JC7G9K042205;
	Mon, 19 Jun 2023 07:07:17 -0500
Message-ID: <a93ff762-215b-fbc1-9e23-b186421cb176@ti.com>
Date: Mon, 19 Jun 2023 17:37:16 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 net-next] net: hsr: Disable promiscuous mode in offload
 mode
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>
CC: <kuba@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>,
        Vladimir
 Oltean <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <bigeasy@linutronix.de>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rogerq@kernel.org>
References: <20230614114710.31400-1-r-gunasekaran@ti.com>
 <20230615223736.0577fb11@kernel.org> <ZJA4fIH6vm9cO2VG@shredder>
From: Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <ZJA4fIH6vm9cO2VG@shredder>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/19/23 4:44 PM, Ido Schimmel wrote:
> On Thu, Jun 15, 2023 at 10:37:36PM -0700, Jakub Kicinski wrote:
>> On Wed, 14 Jun 2023 17:17:10 +0530 Ravi Gunasekaran wrote:
>>> When port-to-port forwarding for interfaces in HSR node is enabled,
>>> disable promiscuous mode since L2 frame forward happens at the
>>> offloaded hardware.
> 
> It's not clear to me why you want to disable promiscuous mode. I'm not
> familiar with HSR, but I assume you want the hardware to forward all the
> packets between the two ports and not only specific DMACs.
> 
> How does the underlying device implement "promiscuous mode" that you
> benefit from disabling it?

While creating an HSR interface using two slave nodes, the promiscuous mode
is set via dev_set_promiscuity() in hsr_portdev_setup() for both the ports.
And then in the HSR driver, a packet is forwarded to the other
slave port (physical port) and also the HSR master if it is intended for it.

Before forwarding, a check is done in 

static void hsr_forward_do(struct hsr_frame_info *frame)
{
...

if (hsr->proto_ops->drop_frame &&                                                       
    hsr->proto_ops->drop_frame(frame, port))               
         continue;     

...
}

And the drop_frame callback is as below

bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)                                
{                                                                       
        if (port->dev->features & NETIF_F_HW_HSR_FWD)                   
                return prp_drop_frame(frame, port);                     
                                                                        
        return false;                                                      
}  


The driver drops these packets and does not forward to any port at all.
But since promiscuous mode is enabled, CPU cycles are consumed. So benefit
of disabling promiscuous mode is saving CPU cycles.

So in this patch, I check for NETIF_F_HW_HSR_FWD and then take a
call to enable/disable the promiscuous mode during HSR interface creation.


> 
> Thanks
> 
>>>
>>> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>
>> Bridge folks any thoughts on this? Is this the behavior bridge has 
>> and if not should we try to align the two?
>>
>>> Changes from v1:
>>> ===============
>>> * Changed the data type of "fwd_offloaded" from "unsigned int" to "bool"
>>>   and moved it below "net_id" struct member as per Paolo's comment.
>>> * Collected Reviewed-by tag from v1 patch.
>>>
>>> v1: https://lore.kernel.org/all/20230612093933.13267-1-r-gunasekaran@ti.com/
>>>
>>>  net/hsr/hsr_device.c |  5 +++++
>>>  net/hsr/hsr_main.h   |  1 +
>>>  net/hsr/hsr_slave.c  | 15 +++++++++++----
>>>  3 files changed, 17 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
>>> index 5a236aae2366..306f942c3b28 100644
>>> --- a/net/hsr/hsr_device.c
>>> +++ b/net/hsr/hsr_device.c
>>> @@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
>>>  	if (res)
>>>  		goto err_add_master;
>>>  
>>> +	/* HSR forwarding offload supported in lower device? */
>>> +	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
>>> +	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
>>> +		hsr->fwd_offloaded = true;
>>> +
>>>  	res = register_netdevice(hsr_dev);
>>>  	if (res)
>>>  		goto err_unregister;
>>> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
>>> index 5584c80a5c79..6851e33df7d1 100644
>>> --- a/net/hsr/hsr_main.h
>>> +++ b/net/hsr/hsr_main.h
>>> @@ -208,6 +208,7 @@ struct hsr_priv {
>>>  	u8 net_id;		/* for PRP, it occupies most significant 3 bits
>>>  				 * of lan_id
>>>  				 */
>>> +	bool fwd_offloaded;	/* Forwarding offloaded to HW */
>>>  	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
>>>  				/* Align to u16 boundary to avoid unaligned access
>>>  				 * in ether_addr_equal
>>> diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
>>> index b70e6bbf6021..e5742f2a2d52 100644
>>> --- a/net/hsr/hsr_slave.c
>>> +++ b/net/hsr/hsr_slave.c
>>> @@ -131,9 +131,14 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
>>>  	struct hsr_port *master;
>>>  	int res;
>>>  
>>> -	res = dev_set_promiscuity(dev, 1);
>>> -	if (res)
>>> -		return res;
>>> +	/* Don't use promiscuous mode for offload since L2 frame forward
>>> +	 * happens at the offloaded hardware.
>>> +	 */
>>> +	if (!port->hsr->fwd_offloaded) {
>>> +		res = dev_set_promiscuity(dev, 1);
>>> +		if (res)
>>> +			return res;
>>> +	}
>>>  
>>>  	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
>>>  	hsr_dev = master->dev;
>>> @@ -152,7 +157,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
>>>  fail_rx_handler:
>>>  	netdev_upper_dev_unlink(dev, hsr_dev);
>>>  fail_upper_dev_link:
>>> -	dev_set_promiscuity(dev, -1);
>>> +	if (!port->hsr->fwd_offloaded)
>>> +		dev_set_promiscuity(dev, -1);
>>> +
>>>  	return res;
>>>  }
>>>  
>>

-- 
Regards,
Ravi


Return-Path: <netdev+bounces-10666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A836372FA10
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62EA7281399
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780EA6138;
	Wed, 14 Jun 2023 10:06:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D56AA6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:06:24 +0000 (UTC)
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD5D18C;
	Wed, 14 Jun 2023 03:06:23 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35EA63fU127468;
	Wed, 14 Jun 2023 05:06:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1686737163;
	bh=iFsvYPvQkajYLTBSl+GGXtHGsI9rPc41gAMCUtzgEHM=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=nTQcRXDu5YPj1KsBQnn2WQb2YHsKHQLRXwKOYwVpECkVYYVrzWEoIDKZoeKf71ztK
	 h31c9iUTerCplmwMWnUWKR7FxYPLXlU3Dpp1QPOgXgkg1P6ONfGiePo0nWB7bi8R7T
	 KVYM7xTVHv+GOGie5XqKqbmWRXlgI1BLFI02P6RY=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35EA62tu067285
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Jun 2023 05:06:03 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 14
 Jun 2023 05:06:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 14 Jun 2023 05:06:02 -0500
Received: from [10.24.69.79] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35EA5xFf015594;
	Wed, 14 Jun 2023 05:06:00 -0500
Message-ID: <527454c6-7516-c226-dae6-636eea698353@ti.com>
Date: Wed, 14 Jun 2023 15:35:59 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net: hsr: Disable promiscuous mode in offload mode
Content-Language: en-US
To: Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <bigeasy@linutronix.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rogerq@kernel.org>
References: <20230612093933.13267-1-r-gunasekaran@ti.com>
 <dffbf0474b1352f1eac63125a973c8f8cd7b3e8d.camel@redhat.com>
 <f50ad11eb5ca3cb777e7150ad6a8347e575f1667.camel@redhat.com>
From: Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <f50ad11eb5ca3cb777e7150ad6a8347e575f1667.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/14/23 3:14 PM, Paolo Abeni wrote:
> On Wed, 2023-06-14 at 11:42 +0200, Paolo Abeni wrote:
>> On Mon, 2023-06-12 at 15:09 +0530, Ravi Gunasekaran wrote:
>>> When port-to-port forwarding for interfaces in HSR node is enabled,
>>> disable promiscuous mode since L2 frame forward happens at the
>>> offloaded hardware.
>>>
>>> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
>>> ---
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
>>> index 5584c80a5c79..0225fabbe6d1 100644
>>> --- a/net/hsr/hsr_main.h
>>> +++ b/net/hsr/hsr_main.h
>>> @@ -195,6 +195,7 @@ struct hsr_priv {
>>>  	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
>>>  	struct timer_list	announce_timer;	/* Supervision frame dispatch */
>>>  	struct timer_list	prune_timer;
>>> +	unsigned int            fwd_offloaded : 1; /* Forwarding offloaded to HW */
>>
>> Please use plain 'bool' instead.
>>
>> Also there is an hole in 'struct hsr_priv' just after 'net_id', you
>> could consider moving this new field there.
> 
> Oops, I almost forgot! Please include the target tree (net-next in this
> case) in the subj prefix on your next submission.
> 

I will take care of this from next submission onwards.

> Thanks,
> 
> Paolo
> 

-- 
Regards,
Ravi


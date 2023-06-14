Return-Path: <netdev+bounces-10665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D46E772FA0C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A94D2813BE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8107E6138;
	Wed, 14 Jun 2023 10:05:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759AC539F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:05:39 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05461BC3;
	Wed, 14 Jun 2023 03:05:24 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35EA5Dur087996;
	Wed, 14 Jun 2023 05:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1686737113;
	bh=MF410LMBMeG59JXPDBqpizLFwoAlbffh/y3ciO6yGFI=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=jVD8IXmbC5LCmlPw4ETT54FKZj3brrIfK7NCraM+yK5kHMF+rk3SqCkH8DIXvAbUR
	 1EFU0Q1cwiH2MVEFeQEvydntgCkj9fRteLQAW+IACI0ilRPr8KsO7tlUkJ0ikf2bv4
	 H5CD5mhagYqaOKzFq2Vri7aWQXG5bFXQ9iqJrTgQ=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35EA5DrI115110
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Jun 2023 05:05:13 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 14
 Jun 2023 05:05:13 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 14 Jun 2023 05:05:13 -0500
Received: from [10.24.69.79] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35EA5AF9084782;
	Wed, 14 Jun 2023 05:05:11 -0500
Message-ID: <3a9fa101-a3f0-1982-b24d-d09a8b8d8a0e@ti.com>
Date: Wed, 14 Jun 2023 15:35:09 +0530
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
From: Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <dffbf0474b1352f1eac63125a973c8f8cd7b3e8d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/14/23 3:12 PM, Paolo Abeni wrote:
> On Mon, 2023-06-12 at 15:09 +0530, Ravi Gunasekaran wrote:
>> When port-to-port forwarding for interfaces in HSR node is enabled,
>> disable promiscuous mode since L2 frame forward happens at the
>> offloaded hardware.
>>
>> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
>> ---
>>  net/hsr/hsr_device.c |  5 +++++
>>  net/hsr/hsr_main.h   |  1 +
>>  net/hsr/hsr_slave.c  | 15 +++++++++++----
>>  3 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
>> index 5a236aae2366..306f942c3b28 100644
>> --- a/net/hsr/hsr_device.c
>> +++ b/net/hsr/hsr_device.c
>> @@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
>>  	if (res)
>>  		goto err_add_master;
>>  
>> +	/* HSR forwarding offload supported in lower device? */
>> +	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
>> +	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
>> +		hsr->fwd_offloaded = true;
>> +
>>  	res = register_netdevice(hsr_dev);
>>  	if (res)
>>  		goto err_unregister;
>> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
>> index 5584c80a5c79..0225fabbe6d1 100644
>> --- a/net/hsr/hsr_main.h
>> +++ b/net/hsr/hsr_main.h
>> @@ -195,6 +195,7 @@ struct hsr_priv {
>>  	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
>>  	struct timer_list	announce_timer;	/* Supervision frame dispatch */
>>  	struct timer_list	prune_timer;
>> +	unsigned int            fwd_offloaded : 1; /* Forwarding offloaded to HW */
> 
> Please use plain 'bool' instead.
> 
> Also there is an hole in 'struct hsr_priv' just after 'net_id', you
> could consider moving this new field there.
> 

Sure. I will use "bool" and insert it after "net_id" and send out v2

> 
> Thanks!
> 
> Paolo
> 

-- 
Regards,
Ravi


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512A35A67F7
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 18:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiH3QQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 12:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiH3QQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 12:16:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DFDAA3C9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:16:20 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UGFoa1005667;
        Tue, 30 Aug 2022 16:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rVlyFCRvXKwtkanqCaQFfBh9AtiMgYHY4ZbidDnbLFo=;
 b=dBKgrVJsf99iD1B8ZyFLL/mnZUjJzbBNgtiv+7FJYjH/bQqkAil1W21hFOG7OOMB2Rsh
 F0qixN3Ip3asYFJK7+uEVWV5D78CprYNxMJ8wSXOJqI/XWUVC+Bcax2bGVS3qobKVeP9
 zhWaxcdDkjOIIOr22X3rtk5mUqJXx+XvXLXQr5LWSIGoS+NwtdNIqzktMRnqnoEEnCF1
 09G3zIkJWaQf4ulEMvoz6Zgg+G4VbKYU+FtK99DPB7zd5+Ba6rDdtigKOBcYzssH0gcD
 dH9QzWUPJPix358G0cOefBbZdzgIENNCqVwn2LogTHcVOboc6/oyWnPu4KtS1lDizH7D 7g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9nww00f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 16:16:06 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UFxEO7001520;
        Tue, 30 Aug 2022 16:16:06 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3j7aw9t1hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 16:16:05 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UGG4MW59179444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 16:16:04 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 885286A05D;
        Tue, 30 Aug 2022 16:16:04 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50EAF6A058;
        Tue, 30 Aug 2022 16:16:04 +0000 (GMT)
Received: from [9.41.99.180] (unknown [9.41.99.180])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 16:16:04 +0000 (GMT)
Message-ID: <9c755650-8f61-6e20-691c-12f081e5bc1e@linux.vnet.ibm.com>
Date:   Tue, 30 Aug 2022 11:15:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] bnx2x: Fix error recovering in switch configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, aelior@marvell.com, davem@davemloft.net,
        manishc@marvell.com, skalluru@marvell.com
References: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
 <20220826184440.37e7cb85@kernel.org>
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
In-Reply-To: <20220826184440.37e7cb85@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GEUFNTbMJWpHLAe8vSFB0-z6rDCNEwqP
X-Proofpoint-GUID: GEUFNTbMJWpHLAe8vSFB0-z6rDCNEwqP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_07,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=873
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208300074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing it.

On 8/26/2022 8:44 PM, Jakub Kicinski wrote:
> On Thu, 25 Aug 2022 20:00:29 +0000 Thinh Tran wrote:
>> As the BCM57810 and other I/O adapters are connected
>> through a PCIe switch, the bnx2x driver causes unexpected
>> system hang/crash while handling PCIe switch errors, if
>> its error handler is called after other drivers' handlers.
>>
>> In this case, after numbers of bnx2x_tx_timout(), the
>> bnx2x_nic_unload() is  called, frees up resources and
>> calls bnx2x_napi_disable(). Then when EEH calls its
>> error handler, the bnx2x_io_error_detected() and
>> bnx2x_io_slot_reset() also calling bnx2x_napi_disable()
>> and freeing the resources.
>>
>> This patch will:
>> - reduce the numbers of bnx2x_panic_dump() while in
>>    bnx2x_tx_timeout(), avoid filling up dmesg buffer.
>> - use checking new napi_enable flags to prevent calling
>>    disable again which causing system hangs.
>> - cheking if fp->page_pool already freed avoid system
>>    crash.
> 
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> index 712b5595bc39..bb8d91f44642 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> @@ -1860,37 +1860,49 @@ static int bnx2x_setup_irqs(struct bnx2x *bp)
>>   static void bnx2x_napi_enable_cnic(struct bnx2x *bp)
>>   {
>>   	int i;
>> +	if (bp->cnic_napi_enable)
> 
> empty line between variables and code, pls
> 
Will correct it.

>> +		return;
>>   
>>   	for_each_rx_queue_cnic(bp, i) {
>>   		napi_enable(&bnx2x_fp(bp, i, napi));
>>   	}
>> +	bp->cnic_napi_enable = true;
> 
> The concept of not calling napi_enable() / disable()
> feels a little wrong. It's the state of the driver,
> not the NAPI that's the problem so perhaps you could
> a appropriately named bool for that (IDK, maybe
> nic_stopped) and prevent coming into the NAPI handling
> functions completely?
> > Is all other code in the driver on the path in question
> really idempotent?
> 

For the states of the driver, it already has bnx2x_netif_start()
and bnx2x_netif_stop() to handle NAPI functions.
But the bnx2x_nic_load() directly calls bnx2x_napi_enable() and 
_disable() in case of errors, and is being called from various functions 
while the driver in different states.

I will work with the suggestion.


>>   }
>>   
>>   static void bnx2x_napi_enable(struct bnx2x *bp)
>>   {
>>   	int i;
>> +	if (bp->napi_enable)
>> +		return;
>>   
>>   	for_each_eth_queue(bp, i) {
>>   		napi_enable(&bnx2x_fp(bp, i, napi));
>>   	}
>> +	bp->napi_enable = true;
>>   }
>>   
>>   static void bnx2x_napi_disable_cnic(struct bnx2x *bp)
>>   {
>>   	int i;
>> +	if (!bp->cnic_napi_enable)
>> +		return;
>>   
>>   	for_each_rx_queue_cnic(bp, i) {
>>   		napi_disable(&bnx2x_fp(bp, i, napi));
>>   	}
>> +	bp->cnic_napi_enable = false;
>>   }
>>   
>>   static void bnx2x_napi_disable(struct bnx2x *bp)
>>   {
>>   	int i;
>> +	if (!bp->napi_enable)
>> +		return;
>>   
>>   	for_each_eth_queue(bp, i) {
>>   		napi_disable(&bnx2x_fp(bp, i, napi));
>>   	}
>> +	bp->napi_enable = false;
>>   }
>>   
>>   void bnx2x_netif_start(struct bnx2x *bp)
>> @@ -2554,6 +2566,7 @@ int bnx2x_load_cnic(struct bnx2x *bp)
>>   	}
>>   
>>   	/* Add all CNIC NAPI objects */
>> +	bp->cnic_napi_enable = false;
>>   	bnx2x_add_all_napi_cnic(bp);
>>   	DP(NETIF_MSG_IFUP, "cnic napi added\n");
>>   	bnx2x_napi_enable_cnic(bp);
>> @@ -2701,7 +2714,9 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
>>   	 */
>>   	bnx2x_setup_tc(bp->dev, bp->max_cos);
>>   
>> +	bp->tx_timeout_cnt = 0;
>>   	/* Add all NAPI objects */
>> +	bp->napi_enable = false;
>>   	bnx2x_add_all_napi(bp);
>>   	DP(NETIF_MSG_IFUP, "napi added\n");
>>   	bnx2x_napi_enable(bp);
>> @@ -4982,7 +4997,14 @@ void bnx2x_tx_timeout(struct net_device *dev, unsigned int txqueue)
>>   	 */
>>   	if (!bp->panic)
>>   #ifndef BNX2X_STOP_ON_ERROR
>> -		bnx2x_panic_dump(bp, false);
>> +	{
>> +		if (++bp->tx_timeout_cnt > 3) {
>> +			bnx2x_panic_dump(bp, false);
>> +			bp->tx_timeout_cnt = 0;
>> +		} else {
>> +			netdev_err(bp->dev, "TX timeout %d times\n", bp->tx_timeout_cnt);
>> +		}
>> +	}
> 
> Please put this code in a helper function so that the oddly looking
> brackets are not needed.
> 
>>   #else
>>   		bnx2x_panic();
>>   #endif
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
>> index d8b1824c334d..7e1d38a2c7ec 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
>> @@ -1018,6 +1018,9 @@ static inline void bnx2x_free_rx_sge_range(struct bnx2x *bp,
>>   	if (fp->mode == TPA_MODE_DISABLED)
>>   		return;
>>   
>> +	if (!fp->page_pool.page)
>> +		return;
> 
> See, another thing that's not idempotent. Better to bail higher up,
> in the callee.
>

Will correct it.

>>   	for (i = 0; i < last; i++)
>>   		bnx2x_free_rx_sge(bp, fp, i);
>>   
> 


Thinh Tran

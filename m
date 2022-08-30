Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED74E5A6ED0
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 23:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiH3VCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 17:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiH3VCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 17:02:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4267C76C
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 14:02:12 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UKWfV8001621;
        Tue, 30 Aug 2022 21:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XFmGdVKbSB/Mhb/jv4F7f7Yw+f38h9pXMfDXqs40n1c=;
 b=lYa8uFRMstd28kLc5yNC46Uk4RoDuwkWbXofWznA4/HLvKaY0tm5zG4DBGInP9O5zSgG
 s3T+/3L1/qZK9Sd+pAS7npfQdb8lvnHsInDnAQYFfHUSL506ja9EKM4+k8r3ZA/fCwlQ
 SnHPTU9iiDWq3RMj1WYqp6YfPjzcea/sWFiEih9s40P9CC2ICuMqN9qvObJ6JOU+/M/L
 IjsuFr8BY3jx2tMEQkh1mbjc60AuK8G8Md77DdOkz2dtJnTYebNR8Sb3omumLVvsPMsQ
 7DTtGibYv2XVpr5GjdIQIu9YqDzJ6+fA8+5rjqj4ZmfjlAQCmq8fi4TOPL27nKY7oyCk hA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9sp4gmak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 21:01:59 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UKpEZQ025925;
        Tue, 30 Aug 2022 21:01:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3j7aw9ured-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 21:01:58 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UL1vxL63897914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 21:01:57 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC1AF6A047;
        Tue, 30 Aug 2022 21:01:56 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FA396A051;
        Tue, 30 Aug 2022 21:01:56 +0000 (GMT)
Received: from [9.41.99.180] (unknown [9.41.99.180])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 21:01:56 +0000 (GMT)
Message-ID: <b040e3b2-5fc0-cfb3-1501-cb1d21496d78@linux.vnet.ibm.com>
Date:   Tue, 30 Aug 2022 16:01:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [EXT] [PATCH] bnx2x: Fix error recovering in switch configuration
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Alok Prasad <palok@marvell.com>
References: <20220825200029.4143670-1-thinhtr@linux.vnet.ibm.com>
 <BY3PR18MB4612468FB0CFB6DB031F888CAB799@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
In-Reply-To: <BY3PR18MB4612468FB0CFB6DB031F888CAB799@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HV274qx4vKde5Nb4iFuYmFBs-gCgZ1WC
X-Proofpoint-GUID: HV274qx4vKde5Nb4iFuYmFBs-gCgZ1WC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_10,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/2022 4:19 AM, Manish Chopra wrote:
>> -----Original Message-----
>> From: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>> Sent: Friday, August 26, 2022 1:30 AM
>> To: kuba@kernel.org
>> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>;
>> davem@davemloft.net; Manish Chopra <manishc@marvell.com>; Sudarsana
>> Reddy Kalluru <skalluru@marvell.com>; Thinh Tran
>> <thinhtr@linux.vnet.ibm.com>
>> Subject: [EXT] [PATCH] bnx2x: Fix error recovering in switch configuration
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>> As the BCM57810 and other I/O adapters are connected through a PCIe
>> switch, the bnx2x driver causes unexpected system hang/crash while handling
>> PCIe switch errors, if its error handler is called after other drivers' handlers.
>>
>> In this case, after numbers of bnx2x_tx_timout(), the
>> bnx2x_nic_unload() is  called, frees up resources and calls
>> bnx2x_napi_disable(). Then when EEH calls its error handler, the
>> bnx2x_io_error_detected() and
>> bnx2x_io_slot_reset() also calling bnx2x_napi_disable() and freeing the
>> resources.
>>
>> This patch will:
>> - reduce the numbers of bnx2x_panic_dump() while in
>>    bnx2x_tx_timeout(), avoid filling up dmesg buffer.
>> - use checking new napi_enable flags to prevent calling
>>    disable again which causing system hangs.
>> - cheking if fp->page_pool already freed avoid system
>>    crash.
>>
>> Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>> ---
>>   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  4 ++++
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 24 ++++++++++++++++++-
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 +++
>>   3 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> index dd5945c4bfec..7fa23d47907a 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> @@ -1509,6 +1509,10 @@ struct bnx2x {
>>   	bool			cnic_loaded;
>>   	struct cnic_eth_dev	*(*cnic_probe)(struct net_device *);
>>
>> +	bool			napi_enable;
>> +	bool			cnic_napi_enable;
>> +	int			tx_timeout_cnt;
>> +
>>   	/* Flag that indicates that we can start looking for FCoE L2 queue
>>   	 * completions in the default status block.
>>   	 */
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> index 712b5595bc39..bb8d91f44642 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> @@ -1860,37 +1860,49 @@ static int bnx2x_setup_irqs(struct bnx2x *bp)
>> static void bnx2x_napi_enable_cnic(struct bnx2x *bp)  {
>>   	int i;
>> +	if (bp->cnic_napi_enable)
>> +		return;
>>
>>   	for_each_rx_queue_cnic(bp, i) {
>>   		napi_enable(&bnx2x_fp(bp, i, napi));
>>   	}
>> +	bp->cnic_napi_enable = true;
>>   }
>>
>>   static void bnx2x_napi_enable(struct bnx2x *bp)  {
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
>>   static void bnx2x_napi_disable_cnic(struct bnx2x *bp)  {
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
>>   static void bnx2x_napi_disable(struct bnx2x *bp)  {
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
>>   void bnx2x_netif_start(struct bnx2x *bp) @@ -2554,6 +2566,7 @@ int
>> bnx2x_load_cnic(struct bnx2x *bp)
>>   	}
>>
>>   	/* Add all CNIC NAPI objects */
>> +	bp->cnic_napi_enable = false;
>>   	bnx2x_add_all_napi_cnic(bp);
>>   	DP(NETIF_MSG_IFUP, "cnic napi added\n");
>>   	bnx2x_napi_enable_cnic(bp);
>> @@ -2701,7 +2714,9 @@ int bnx2x_nic_load(struct bnx2x *bp, int
>> load_mode)
>>   	 */
>>   	bnx2x_setup_tc(bp->dev, bp->max_cos);
>>
>> +	bp->tx_timeout_cnt = 0;
>>   	/* Add all NAPI objects */
>> +	bp->napi_enable = false;
>>   	bnx2x_add_all_napi(bp);
>>   	DP(NETIF_MSG_IFUP, "napi added\n");
>>   	bnx2x_napi_enable(bp);
>> @@ -4982,7 +4997,14 @@ void bnx2x_tx_timeout(struct net_device *dev,
>> unsigned int txqueue)
>>   	 */
>>   	if (!bp->panic)
>>   #ifndef BNX2X_STOP_ON_ERROR
>> -		bnx2x_panic_dump(bp, false);
>> +	{
>> +		if (++bp->tx_timeout_cnt > 3) {
>> +			bnx2x_panic_dump(bp, false);
>> +			bp->tx_timeout_cnt = 0;
>> +		} else {
>> +			netdev_err(bp->dev, "TX timeout %d times\n", bp-
>>> tx_timeout_cnt);
>> +		}
>> +	
> 
> Hello Trinh,
> bnx2x_panic_dump() dumps quite of some useful debug (fastpath, hw related) info to look at in the logs,
> I think they should be dumped at very first occurrence of tx timeout rather than waiting on next few tx timeout
> event (which may not even occur in some cases). One another way to prevent it could be by turning off the
> carrier (netif_carrier_off()) at very first place in bnx2x_tx_timeout() to prevent such repeated occurrences of tx timeout on the netdev.
> 
> Thanks,
> Manish

will do

Thanks,
Thinh Tran

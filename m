Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED0E5E543A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 22:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiIUUMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 16:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiIUUMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 16:12:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D050A3D74
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:12:04 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LK5Map011286;
        Wed, 21 Sep 2022 20:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0UFSu5DWVmwdUer8ZF5ex9ZP4C3HSYqpPdm/8IRREXY=;
 b=lI/sHUO5bnUheEHSYnjl3D/VZTA9uuoYUv57wwY7F6mrIZSuOtJ+JyWNvJuCI/BjS0rF
 MzZLOlxq9Ji4AliLu3WLFRoqwNoV8ogsq00bz5LP51t3UvPnWuHflq4FEZn3nIxM/ohA
 GxycZClXIOy/QgNrssiLDRoDGy8sJXFfkkfGao1kM9FOcq2ozRejiRGNzXzeu8H5eVdQ
 FyP7FGyFNNwTzilUtcBuWZ6plUV6EpBc7oxLm3BieKEf1LvHq0lHGMn9fbiCVUeSgdjz
 Rkj1n7S2SvNoTahrixSYqXFGM1JkIKwFgZFp4MkdCLCGiivkiKMxzwdfHPP01E+Mzc5q /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jr9be84tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 20:11:58 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28LK84oG022215;
        Wed, 21 Sep 2022 20:11:58 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jr9be84tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 20:11:58 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28LK6Jxl020904;
        Wed, 21 Sep 2022 20:11:57 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3jn5va42pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 20:11:57 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28LKBu1P2753114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 20:11:57 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFAC258056;
        Wed, 21 Sep 2022 20:11:55 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B89A35804C;
        Wed, 21 Sep 2022 20:11:55 +0000 (GMT)
Received: from [9.41.99.180] (unknown [9.41.99.180])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Sep 2022 20:11:55 +0000 (GMT)
Message-ID: <b9a87990-ae04-6cd2-7160-d9966770fc85@linux.vnet.ibm.com>
Date:   Wed, 21 Sep 2022 15:11:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch
 configuration
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Alok Prasad <palok@marvell.com>
References: <20220826184440.37e7cb85@kernel.org>
 <20220916195114.2474829-1-thinhtr@linux.vnet.ibm.com>
 <BY3PR18MB461200F00B27327499F9FEC8AB4D9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
In-Reply-To: <BY3PR18MB461200F00B27327499F9FEC8AB4D9@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tljv57KLN16e-9c6mzPqgcEYtgouXgCP
X-Proofpoint-ORIG-GUID: 6j0I3CpOdTq6TCrgJb6r8TnMlZKrGUCS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_11,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210134
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,
Thanks for reviewing the patch.


On 9/19/2022 8:53 AM, Manish Chopra wrote:
> Hello Thinh,
> 
>> -----Original Message-----
>> From: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>> Sent: Saturday, September 17, 2022 1:21 AM
>> To: kuba@kernel.org
>> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>;
>> davem@davemloft.net; Manish Chopra <manishc@marvell.com>; Sudarsana
>> Reddy Kalluru <skalluru@marvell.com>; pabeni@redhat.com;
>> edumazet@google.com; Thinh Tran <thinhtr@linux.vnet.ibm.com>
>> Subject: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch configuration
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
>> Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>>
>>   v2:
>>     - Check the state of the NIC before calling disable nappi
>>       and freeing the IRQ
>>     - Prevent recurrence of TX timeout by turning off the carrier,
>>       calling netif_carrier_off() in bnx2x_tx_timeout()
>>     - Check and bail out early if fp->page_pool already freed
>> ---
>>   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 +
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 27 +++++++++----
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 ++
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 38 +++++++++----------
>> .../net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 17 +++++----
>>   5 files changed, 53 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> index dd5945c4bfec..11280f0eb75b 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> @@ -1509,6 +1509,8 @@ struct bnx2x {
>>   	bool			cnic_loaded;
>>   	struct cnic_eth_dev	*(*cnic_probe)(struct net_device *);
>>
>> +	bool			nic_stopped;
>> +
> 
> There is an already 'state' variable which holds the NIC state whether it was opened or closed. > Perhaps we could use that easily in bnx2x_io_slot_reset() to prevent 
multiple NAPI disablement
> instead of adding a newer one. Please see below for ex -
> 
In my early debug, I did checked for bp->state variable but I was unsure 
what the NIC state was safe to disable the NAPI.
Thanks for the hint.

> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 962253db25b8..c8e9b47208ed 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -14256,13 +14256,16 @@ static pci_ers_result_t bnx2x_io_slot_reset(struct pci_dev *pdev)
>                  }
>                  bnx2x_drain_tx_queues(bp);
>                  bnx2x_send_unload_req(bp, UNLOAD_RECOVERY);
> -               bnx2x_netif_stop(bp, 1);
> -               bnx2x_del_all_napi(bp);
> 
> -               if (CNIC_LOADED(bp))
> -                       bnx2x_del_all_napi_cnic(bp);
> +               if (bp->state == BNX2X_STATE_OPEN) {
> +                       bnx2x_netif_stop(bp, 1);
> +                       bnx2x_del_all_napi(bp);
> 
> -               bnx2x_free_irq(bp);
> +                       if (CNIC_LOADED(bp))
> +                               bnx2x_del_all_napi_cnic(bp);
> +
> +                       bnx2x_free_irq(bp);
> +               }
> 
>                  /* Report UNLOAD_DONE to MCP */
>                  bnx2x_send_unload_done(bp, true);
> 
> Thanks,
> Manish

It requires a specific system setup, I will test with v3 patch when the 
system is available.

Thanks,
Thinh Tran

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58C05EE853
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiI1VeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiI1VeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:34:15 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A57F7754A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:34:14 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SJUGEw011406;
        Wed, 28 Sep 2022 21:34:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=73a4FpeLr/YlLJIc2YSbyiwqT2Ijeh1oJbu0yZCG4P8=;
 b=mluw5MzTPWJDDV/kBTl4cqLvm8b3pcGSYeSkrqGF4YAQE86+FmNYGLLpzbdfS+f98t6X
 tEoJue9xKWdoARYBWUEe4TtBqDqTu2Fu6GZ55b8acDlGm1OYvK7lT3qk8IRI4DTXPPL5
 L3wzhTkRwkn3AuqYtpPmtqS24lQ7f5UbQaCSlAZmcPfESZI1HnYd07LJqlLfb6NNkLQa
 +Se/kqxi0Oewe29OY1JRRykqDdeA0yGpo93CK1s6/QXP1fwtXxCQ4/8KoibAqmtv/FLz
 l8enyGhlk45JhKlEU34LnJXugtIIR6nakzBZIcVF/oA/n26nd2xxAWvw059hoXvBJCx1 pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvqxpcyah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 21:34:07 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28SLY7qJ031049;
        Wed, 28 Sep 2022 21:34:07 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvqxpcya9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 21:34:07 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SLLHI7005535;
        Wed, 28 Sep 2022 21:34:06 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3jssh9wp6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 21:34:06 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SLY5en16450252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 21:34:05 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66A595805A;
        Wed, 28 Sep 2022 21:34:05 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3336958051;
        Wed, 28 Sep 2022 21:34:05 +0000 (GMT)
Received: from [9.41.99.180] (unknown [9.41.99.180])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 21:34:05 +0000 (GMT)
Message-ID: <d2a9711b-21b1-6b0c-ae29-7cb6ee33da6c@linux.vnet.ibm.com>
Date:   Wed, 28 Sep 2022 16:33:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch
 configuration
Content-Language: en-US
From:   Thinh Tran <thinhtr@linux.vnet.ibm.com>
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
 <b9a87990-ae04-6cd2-7160-d9966770fc85@linux.vnet.ibm.com>
In-Reply-To: <b9a87990-ae04-6cd2-7160-d9966770fc85@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yV-K6Lh0YCC3r_L-F3_wqVRulZWcK5WR
X-Proofpoint-GUID: 6dRBowoDcSd5CGY-1jmdJyaqY8gK4cmn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_09,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280127
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

I think we need the extra variable, nic_stopped, or perhaps defining a 
different state to determine the disablement of NAPI and freed IRQs.
Since device gets the error, the NIC state is set to 
BNX2X_STATE_CLOSING_WAIT4_HALT (0x4000)

14132 static int bnx2x_eeh_nic_unload(struct bnx2x *bp)
14133 {
14134         bp->state = BNX2X_STATE_CLOSING_WAIT4_HALT;
14135

and stays in this state in EEH handler and driver reset code paths, when 
both trying to disabling the NAPI.

On 9/21/2022 3:11 PM, Thinh Tran wrote:
> Hi Manish,
> Thanks for reviewing the patch.
> 
> 
> On 9/19/2022 8:53 AM, Manish Chopra wrote:
>> Hello Thinh,
>>
>>> -----Original Message-----
>>> From: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>>> Sent: Saturday, September 17, 2022 1:21 AM
>>> To: kuba@kernel.org
>>> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>;
>>> davem@davemloft.net; Manish Chopra <manishc@marvell.com>; Sudarsana
>>> Reddy Kalluru <skalluru@marvell.com>; pabeni@redhat.com;
>>> edumazet@google.com; Thinh Tran <thinhtr@linux.vnet.ibm.com>
>>> Subject: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch 
>>> configuration
>>>
>>> External Email
>>>
>>> ----------------------------------------------------------------------
>>> As the BCM57810 and other I/O adapters are connected through a PCIe
>>> switch, the bnx2x driver causes unexpected system hang/crash while 
>>> handling
>>> PCIe switch errors, if its error handler is called after other 
>>> drivers' handlers.
>>>
>>> In this case, after numbers of bnx2x_tx_timout(), the
>>> bnx2x_nic_unload() is  called, frees up resources and calls
>>> bnx2x_napi_disable(). Then when EEH calls its error handler, the
>>> bnx2x_io_error_detected() and
>>> bnx2x_io_slot_reset() also calling bnx2x_napi_disable() and freeing the
>>> resources.
>>>
>>> Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>>>
>>>   v2:
>>>     - Check the state of the NIC before calling disable nappi
>>>       and freeing the IRQ
>>>     - Prevent recurrence of TX timeout by turning off the carrier,
>>>       calling netif_carrier_off() in bnx2x_tx_timeout()
>>>     - Check and bail out early if fp->page_pool already freed
>>> ---
>>>   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 +
>>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 27 +++++++++----
>>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 ++
>>>   .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 38 +++++++++----------
>>> .../net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 17 +++++----
>>>   5 files changed, 53 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> index dd5945c4bfec..11280f0eb75b 100644
>>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> @@ -1509,6 +1509,8 @@ struct bnx2x {
>>>       bool            cnic_loaded;
>>>       struct cnic_eth_dev    *(*cnic_probe)(struct net_device *);
>>>
>>> +    bool            nic_stopped;
>>> +
>>
>> There is an already 'state' variable which holds the NIC state whether 
>> it was opened or closed. > Perhaps we could use that easily in 
>> bnx2x_io_slot_reset() to prevent 
> multiple NAPI disablement
>> instead of adding a newer one. Please see below for ex -
>>
> In my early debug, I did checked for bp->state variable but I was unsure 
> what the NIC state was safe to disable the NAPI.
> Thanks for the hint.
> 
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c 
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> index 962253db25b8..c8e9b47208ed 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> @@ -14256,13 +14256,16 @@ static pci_ers_result_t 
>> bnx2x_io_slot_reset(struct pci_dev *pdev)
>>                  }
>>                  bnx2x_drain_tx_queues(bp);
>>                  bnx2x_send_unload_req(bp, UNLOAD_RECOVERY);
>> -               bnx2x_netif_stop(bp, 1);
>> -               bnx2x_del_all_napi(bp);
>>
>> -               if (CNIC_LOADED(bp))
>> -                       bnx2x_del_all_napi_cnic(bp);
>> +               if (bp->state == BNX2X_STATE_OPEN) {
>> +                       bnx2x_netif_stop(bp, 1);
>> +                       bnx2x_del_all_napi(bp);
>>
>> -               bnx2x_free_irq(bp);
>> +                       if (CNIC_LOADED(bp))
>> +                               bnx2x_del_all_napi_cnic(bp);
>> +
>> +                       bnx2x_free_irq(bp);
>> +               }
>>
>>                  /* Report UNLOAD_DONE to MCP */
>>                  bnx2x_send_unload_done(bp, true);
>>
Using the v2 patch, I checked the NIC state at places before and after 
disabling the NAPI,
         BNX2X_ERR("before state flag = 0x%x \n", bp->state);
         if (!bp->nic_stopped) {
                 BNX2X_ERR("after state flag = 0x%x \n", bp->state);
		bnx2x_netif_stop(bp, 1);
		bnx2x_del_all_napi(bp);
                 ....

the NIC state is always BNX2X_STATE_CLOSING_WAIT4_HALT (0x4000) when 
device get error injection.

1- When EEH handler code path was called first, the 
bnx2x_io_slot_reset() does disablement the NAPI and done.
    [28197.100795] bnx2x: [bnx2x_io_slot_reset:14212(eth3)]IO slot reset 
initializing...
    [28197.100959] bnx2x 0201:50:00.0: enabling device (0140 -> 0142)
    [28197.107249] bnx2x: [bnx2x_io_slot_reset:14228(eth3)]IO slot reset 
--> driver unload
    [28199.106281] bnx2x: [bnx2x_clean_tx_queue:1205(eth3)]timeout 
waiting for queue[1]: txdata->tx_pkt_prod(7270) != txdata->tx_pkt_cons(7269)
    [28201.106281] bnx2x: [bnx2x_clean_tx_queue:1205(eth3)]timeout 
waiting for queue[3]: txdata->tx_pkt_prod(10977) != 
txdata->tx_pkt_cons(10969)
    [28203.106280] bnx2x: [bnx2x_clean_tx_queue:1205(eth3)]timeout 
waiting for queue[4]: txdata->tx_pkt_prod(9532) != txdata->tx_pkt_cons(9514)
    [28205.106284] bnx2x: [bnx2x_clean_tx_queue:1205(eth3)]timeout 
waiting for queue[6]: txdata->tx_pkt_prod(2359) != txdata->tx_pkt_cons(2331)
    [28205.314280] bnx2x: [bnx2x_io_slot_reset:14246(eth3)]before -- 
state flag = 0x4000   <---- check NIC state
    [28205.314282] bnx2x: [bnx2x_io_slot_reset:14248(eth3)]after -- 
state flag = 0x4000         <---- check NIC state and disable the NAPI
    [28205.405009] PCI 0201:50:00.0#500000: EEH: bnx2x driver reports: 
'recovered'
........ snip ......
    [28213.525014] EEH: Finished:'slot_reset' with aggregate recovery 
state:'recovered'
    [28213.525016] EEH: Notify device driver to resume
    [28213.525017] EEH: Beginning: 'resume'
    [28213.525018] PCI 0201:50:00.0#500000: EEH: Invoking bnx2x->resume()
    [28225.115287] bnx2x 0201:50:00.0 eth3: using MSI-X  IRQs: sp 101 
fp[0] 103 ... fp[7] 110
    [28225.696425] PCI 0201:50:00.0#500000: EEH: bnx2x driver reports: 
'none'


2- When the driver reset code path was called first, the 
bnx2x_chip_cleanup() does the disablement the NAPI, but NIC is resumed 
after the EEH handler code path was called.
    [13376.774278] bnx2x: [bnx2x_state_wait:312(eth3)]timeout waiting 
for state 2
     [13376.774280] bnx2x: [bnx2x_func_stop:9118(eth3)]FUNC_STOP ramrod 
failed. Running a dry transaction
    [13376.774339] bnx2x: [bnx2x_chip_cleanup:9467(eth3)]before state 
flag = 0x4000
    [13376.774341] bnx2x: [bnx2x_chip_cleanup:9469(eth3)]after state 
flag = 0x4000
    [13376.774344] bnx2x: [bnx2x_igu_int_disable:891(eth3)]BUG! Proper 
val not read from IGU!
    [13391.774280] bnx2x: [bnx2x_fw_command:3044(eth3)]FW failed to respond!
    ........ snip .....
    [13442.118385] PCI 0201:50:00.0#500000: EEH: Invoking 
bnx2x->slot_reset()
    [13442.118388] bnx2x: [bnx2x_io_slot_reset:14212(eth3)]IO slot reset 
initializing...
    [13442.118509] bnx2x 0201:50:00.0: enabling device (0140 -> 0142)
    [13442.124825] bnx2x: [bnx2x_io_slot_reset:14228(eth3)]IO slot reset 
--> driver unload
    [13442.154290] bnx2x: [bnx2x_io_slot_reset:14246(eth3)]before -- 
state flag = 0x4000    <--- check NIC state
    [13442.274291] PCI 0201:50:00.0#500000: EEH: bnx2x driver reports: 
'recovered'
    ....... snip .........
    [13442.424290] EEH: Finished:'slot_reset' with aggregate recovery 
state:'recovered'
    [13442.424291] EEH: Notify device driver to resume
    [13442.424292] EEH: Beginning: 'resume'
    [13442.424293] PCI 0201:50:00.0#500000: EEH: Invoking bnx2x->resume()
    [13443.015280] bnx2x 0201:50:00.0 eth3: using MSI-X  IRQs: sp 61 
fp[0] 63 ... fp[7] 75
    [13443.616423] PCI 0201:50:00.0#500000: EEH: bnx2x driver reports: 
'none'


>> Thanks,
>> Manish
> 
> It requires a specific system setup, I will test with v3 patch when the 
> system is available.
> 
> Thanks,
> Thinh Tran

Any suggestions?
Thanks,
Thinh Tran

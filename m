Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE0361FCC8
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiKGSHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiKGSHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:07:09 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9577EBC;
        Mon,  7 Nov 2022 10:03:27 -0800 (PST)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A7H6Hwt008972;
        Mon, 7 Nov 2022 18:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=vlY5R6MmRKN2YVj+cne2KFRs5BK7uhZiZOPuPZOa/ZU=;
 b=CFfX/drgoVKlZzTA7DO5frY32DKvcP4Dwr/7nGGSC67Bf6gSMp8FAweDfJq96qYvnF7j
 8alEq/MlBCJDUc7OHTOOytnx0G6PIByORpIR4zf3OEuHgUK+St4rQwcyPTUKAVbDkIKe
 iWj5O84oDyOExDGqlZVKIRJ8YB12ZJpusqg3tW0qlEeLYorhYajd3mYCKLu2ouWgBcej
 2pnikMp7+9k0kTOxzpeg3TKmyqp8vbX7Et9D6vliKIA07aDhDqgNP+lM7IzD9er3P5CQ
 vIiN3J+wt9b1Cn/swNpj3YQhW7ix3db71dRz87itDMSED8fgUSMZLz3efoR3garjL0cP Tg== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kq5s388j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:02:36 +0000
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7I2Y0e028280;
        Mon, 7 Nov 2022 18:02:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 3kngwkr2qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:02:34 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7I2YgF028272;
        Mon, 7 Nov 2022 18:02:34 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 2A7I2Xh4028271
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 18:02:34 +0000
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 7 Nov 2022
 10:02:33 -0800
Message-ID: <4df381ef-5264-31d7-add4-37cccd6af4a8@quicinc.com>
Date:   Mon, 7 Nov 2022 11:02:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
Content-Language: en-US
To:     Robert Marko <robimarko@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>
CC:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <elder@linaro.org>,
        <hemantk@codeaurora.org>, <quic_qianyu@quicinc.com>,
        <bbhatt@codeaurora.org>, <mhi@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ansuelsmth@gmail.com>
References: <20221105194943.826847-1-robimarko@gmail.com>
 <20221105194943.826847-2-robimarko@gmail.com>
 <20221107174727.GA7535@thinkpad>
 <CAOX2RU5OZKpDUqB67kDBrqaG-gfJfYAcgUkmnebRZtVpWc3CEQ@mail.gmail.com>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <CAOX2RU5OZKpDUqB67kDBrqaG-gfJfYAcgUkmnebRZtVpWc3CEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: zFpxMuS-J-TK7VGrg0Augmmx-ucWquoD
X-Proofpoint-ORIG-GUID: zFpxMuS-J-TK7VGrg0Augmmx-ucWquoD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/2022 10:52 AM, Robert Marko wrote:
> On Mon, 7 Nov 2022 at 18:47, Manivannan Sadhasivam <mani@kernel.org> wrote:
>>
>> On Sat, Nov 05, 2022 at 08:49:43PM +0100, Robert Marko wrote:
>>> Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
>>> will cause a clash in the QRTR instance node ID and prevent the driver
>>> from talking via QMI to the card and thus initializing it with:
>>> [    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
>>> [    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22
>>>
>>
>> There is still an outstanding issue where you cannot connect two WLAN modules
>> with same node id.
> 
> Yes, but as far as I can understand QRTR that is never gonna be
> possible, node ID-s
> must be different, but I dont have any docs at all.
> 
>>
>>> So, in order to allow for this combination of cards, especially AHB + PCI
>>> cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
>>> QRTR instance ID offset by calculating a unique one based on PCI domain
>>> and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
>>> using the SBL state callback that is added as part of the series.
>>> We also have to make sure that new QRTR offset is added on top of the
>>> default QRTR instance ID-s that are currently used in the driver.
>>>
>>
>> Register BHI_ERRDBG2 is listed as Read only from Host as per the BHI spec.
>> So I'm not sure if this solution is going to work on all ath11k supported
>> chipsets.
>>
>> Kalle, can you confirm?
>>
>>> This finally allows using AHB + PCI or multiple PCI cards on the same
>>> system.
>>>
>>> Before:
>>> root@OpenWrt:/# qrtr-lookup
>>>    Service Version Instance Node  Port
>>>       1054       1        0    7     1 <unknown>
>>>         69       1        2    7     3 ATH10k WLAN firmware service
>>>
>>> After:
>>> root@OpenWrt:/# qrtr-lookup
>>>    Service Version Instance Node  Port
>>>       1054       1        0    7     1 <unknown>
>>>         69       1        2    7     3 ATH10k WLAN firmware service
>>>         15       1        0    8     1 Test service
>>>         69       1        8    8     2 ATH10k WLAN firmware service
>>>
>>> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
>>> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
>>>
>>> Signed-off-by: Robert Marko <robimarko@gmail.com>
>>> ---
>>>   drivers/net/wireless/ath/ath11k/mhi.c | 47 ++++++++++++++++++---------
>>>   drivers/net/wireless/ath/ath11k/mhi.h |  3 ++
>>>   drivers/net/wireless/ath/ath11k/pci.c |  5 ++-
>>>   3 files changed, 38 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
>>> index 86995e8dc913..23e85ea902f5 100644
>>> --- a/drivers/net/wireless/ath/ath11k/mhi.c
>>> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
>>> @@ -294,6 +294,32 @@ static void ath11k_mhi_op_runtime_put(struct mhi_controller *mhi_cntrl)
>>>   {
>>>   }
>>>
>>> +static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
>>> +                               void __iomem *addr,
>>> +                               u32 *out)
>>> +{
>>> +     *out = readl(addr);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
>>> +                                 void __iomem *addr,
>>> +                                 u32 val)
>>> +{
>>> +     writel(val, addr);
>>> +}
>>> +
>>> +static void ath11k_mhi_qrtr_instance_set(struct mhi_controller *mhi_cntrl)
>>> +{
>>> +     struct ath11k_base *ab = dev_get_drvdata(mhi_cntrl->cntrl_dev);
>>> +
>>> +     ath11k_mhi_op_write_reg(mhi_cntrl,
>>> +                             mhi_cntrl->bhi + BHI_ERRDBG2,
>>> +                             FIELD_PREP(QRTR_INSTANCE_MASK,
>>> +                             ab->qmi.service_ins_id - ab->hw_params.qmi_service_ins_id));
>>> +}
>>> +
>>>   static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
>>>   {
>>>        switch (reason) {
>>> @@ -315,6 +341,8 @@ static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
>>>                return "MHI_CB_FATAL_ERROR";
>>>        case MHI_CB_BW_REQ:
>>>                return "MHI_CB_BW_REQ";
>>> +     case MHI_CB_EE_SBL_MODE:
>>> +             return "MHI_CB_EE_SBL_MODE";
>>>        default:
>>>                return "UNKNOWN";
>>>        }
>>> @@ -336,27 +364,14 @@ static void ath11k_mhi_op_status_cb(struct mhi_controller *mhi_cntrl,
>>>                if (!(test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)))
>>>                        queue_work(ab->workqueue_aux, &ab->reset_work);
>>>                break;
>>> +     case MHI_CB_EE_SBL_MODE:
>>> +             ath11k_mhi_qrtr_instance_set(mhi_cntrl);
>>
>> I still don't understand how SBL could make use of this information during
>> boot without waiting for an update.
> 
> Me neither, but it works reliably as long as it's updated once SBL is live.
> Trying to do it earlier or later does nothing, it will just use the
> default node ID then.

If I recall correctly, PBL will write to the register at the end of the 
BHI process, even in the success case.  So, you have a race condition 
where you need to update the register after BHI is complete, but before 
SBL reads it.

If the value is just based on the BDF, I don't see why the device 
couldn't compute it without input from the host.  This whole mechanism 
seems pretty poorly designed, but sadly I don't have any brilliant ideas 
on how to fix it for you.

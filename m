Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132DD61087F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbiJ1C5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiJ1C5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:57:37 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA04C1DA2;
        Thu, 27 Oct 2022 19:57:35 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S2eLG8031432;
        Fri, 28 Oct 2022 02:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=8boYx5DMpSKCIKsl187S1xKyolTLlB5T0x9Z9MXfnZs=;
 b=k9dcFmdKKNBRCnfzGIOEDFvbb4KVFdgxN2HYJyAzSI9Whh+fShBAxgrqhoBx1Q7+fIA4
 5JimJD8e9erO6OzGEoAPntwsGOMIDJonLCthWM07uwRO5TBJpkXXEGzL4172oTvWqWR1
 3xjyTSYJeD1fMz4UIfCYYzdrPhlOmPn00zM77X6P9Jx3Q7rgnWvo9+Fx6OOpehwVs2Jo
 SO0BXlJ7J7KRwfeLqHtv6WDcgJ1Sq7M8T4SG7RNg64qeqjS8ZLY4xjv5zHfljDpQs0UY
 p96FgOCle3JOs9FvzbMf6yHGXQOxnI89pxKIMz5nA/wQWkTy9hW5S9pe6/0Acom8Kz54 Pw== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kfahvutrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 02:57:21 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 29S2vKiu020978
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 02:57:20 GMT
Received: from [10.249.8.186] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 27 Oct
 2022 19:57:17 -0700
Message-ID: <8c9bbcde-6dcb-2e31-d3d8-c51d8fe03035@quicinc.com>
Date:   Fri, 28 Oct 2022 10:57:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] Bluetooth: btusb: Fix enable failure for a CSR BT
 dongle
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <luiz.von.dentz@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, Zijun Hu <zijuhu@qti.qualcomm.com>
References: <1666868760-4680-1-git-send-email-quic_zijuhu@quicinc.com>
 <abb598cd-c849-33b8-34fa-4cedcf185138@molgen.mpg.de>
From:   quic_zijuhu <quic_zijuhu@quicinc.com>
In-Reply-To: <abb598cd-c849-33b8-34fa-4cedcf185138@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: jlFQDkb_UT7kRVqimgYsBYkuSvIYOhvG
X-Proofpoint-GUID: jlFQDkb_UT7kRVqimgYsBYkuSvIYOhvG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1011
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280017
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/2022 7:18 PM, Paul Menzel wrote:
> Dear Zijun,
> 
> 
> Thank you for the patch.
> 
> 
> Am 27.10.22 um 13:06 schrieb Zijun Hu:
>> From: Zijun Hu <zijuhu@qti.qualcomm.com>
> 
> I‘d be more specific in the summary/title. Maybe:
> 
> Correct quirk check to include BT 4.0
> 
>> A CSR BT dongle fails to be enabled bcz it is not detected as fake
> 
> I’d write *because*.
> 
>> rightly, fixed by correcting fake detection condition.
>>
>> below btmon error log says HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL is not set.
>>
>> < HCI Command: Set Event Filter (0x03|0x0005) plen 1        #23 [hci0]
>>          Type: Clear All Filters (0x00)
>>> HCI Event: Command Complete (0x0e) plen 4                 #24 [hci0]
>>        Set Event Filter (0x03|0x0005) ncmd 1
>>          Status: Invalid HCI Command Parameters (0x12)
>>
>> the quirk is not set bcz current fake detection does not mark the dongle
>> as fake with below version info.
>>
>> < HCI Command: Read Local Version In.. (0x04|0x0001) plen 0  #1 [hci0]
>>> HCI Event: Command Complete (0x0e) plen 12                 #2 [hci0]
>>        Read Local Version Information (0x04|0x0001) ncmd 1
>>          Status: Success (0x00)
>>          HCI version: Bluetooth 4.0 (0x06) - Revision 12576 (0x3120)
>>          LMP version: Bluetooth 4.0 (0x06) - Subversion 8891 (0x22bb)
>>          Manufacturer: Cambridge Silicon Radio (10)
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=60824
>> Signed-off-by: Zijun Hu <zijuhu@qti.qualcomm.com>
> 
> Please add a Fixes: tag.
> 
> 
> Kind regards,
> 
> Paul
> 
> 
>> ---
>>   drivers/bluetooth/btusb.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>> index 420be2ee2acf..727469d073f9 100644
>> --- a/drivers/bluetooth/btusb.c
>> +++ b/drivers/bluetooth/btusb.c
>> @@ -2155,7 +2155,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>>           is_fake = true;
>>         else if (le16_to_cpu(rp->lmp_subver) <= 0x22bb &&
>> -         le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_4_0)
>> +         le16_to_cpu(rp->hci_ver) >= BLUETOOTH_VER_4_0)
>>           is_fake = true;
>>         /* Other clones which beat all the above checks */

thank you Paul for your code review.
i am sorry, please Ignore this wrong fix.
the enable failure should be  caused that below fix is not be picked up
https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=b3cf94c8b6b2f1a2b94825a025db291da2b151fd


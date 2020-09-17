Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5126E763
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIQV0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:26:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23600 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbgIQV0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 17:26:16 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HKP3rg117206;
        Thu, 17 Sep 2020 16:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bD7vN8C1M66jXnnEpisnyvmrMx87gxF1UuPh8zxTyTU=;
 b=bUo3OyigwODZbQRPUse+o4TL2UKt3N9UkIBw5xVTpwp7Tvb8PY1DSPAA9n42knxX3wVH
 JCHYPliR08dsCQlmeHBIVB7IfO0xT3V3TSpgjHvtiT0kBlJG3hLZN7fFZd36c/7sb6Vx
 OeLQrGcB30JkTM2z01doIWsKXlA26uINDnfBROsG5cwYsfQYB1gqndaoT+6c0TfhORVD
 kNfWcyrIXNYGBWOi1JYrZs2UQiNTFkMo0ddclF9O8PqWlYYvbrH8PO8IodN2HvladKNe
 NpeMP8CQWNZNJtjhpPl5G2apIqJuJkNc6JcVHLraLGljWWa/QMQ7mL92pPxqp9KlT6QH Jw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33metq03nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 16:32:16 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HKVl5U004119;
        Thu, 17 Sep 2020 20:32:16 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 33k6q16y4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 20:32:16 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HKWFRu52953590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 20:32:15 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8EB5AE062;
        Thu, 17 Sep 2020 20:32:15 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 678FAAE05F;
        Thu, 17 Sep 2020 20:32:15 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.243.76])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 20:32:15 +0000 (GMT)
Subject: Re: [PATCH net] ibmvnic: Fix returning uninitialized return code
To:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org
References: <1600294357-19302-1-git-send-email-tlfalcon@linux.ibm.com>
 <0a335b1f7532fb6bd3d8e685a52d691760b1e226.camel@kernel.org>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <f49f90d6-3ecb-babc-a37d-0ad8ed2f4cff@linux.ibm.com>
Date:   Thu, 17 Sep 2020 15:32:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <0a335b1f7532fb6bd3d8e685a52d691760b1e226.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_17:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=994 spamscore=0
 clxscore=1011 mlxscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/17/20 1:07 AM, Saeed Mahameed wrote:
> On Wed, 2020-09-16 at 17:12 -0500, Thomas Falcon wrote:
>> If successful, __ibmvnic_open and reset_sub_crq_queues,
>> if no device queues exist, will return an uninitialized
>> variable rc. Return zero on success instead.
>>
>> Fixes: 57a49436f4e8 ("ibmvnic: Reset sub-crqs during driver reset")
>> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> ---
>>   drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
>> b/drivers/net/ethernet/ibm/ibmvnic.c
>> index 1b702a4..1619311 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -1178,7 +1178,7 @@ static int __ibmvnic_open(struct net_device
>> *netdev)
>>   	}
>>   
>>   	adapter->state = VNIC_OPEN;
>> -	return rc;
>> +	return 0;
> rc here is unconditionally assigned a couple of lines earlier,
> but anyway i don't mind this change as it explicitly states that this
> is a success path.
>
> But maybe you want to split the patch and send this hunk to net-next.
> I don't mind, up to you.

Thanks for catching that, I'll send a v2 with just the second hunk.

Tom

>
>>   }
>>   
>>   static int ibmvnic_open(struct net_device *netdev)
>> @@ -2862,7 +2862,7 @@ static int reset_sub_crq_queues(struct
>> ibmvnic_adapter *adapter)
>>   			return rc;
>>   	}
>>   
>> -	return rc;
>> +	return 0;
> This one though is fine,
>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>
>

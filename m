Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE06BF15C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCQTC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjCQTCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:02:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602B74B822
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 12:02:04 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HISKdQ022492;
        Fri, 17 Mar 2023 19:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g7RbY4ZezHj0RcoqLdQ7xVR/KOB//u1/NmbxazQ5Aa0=;
 b=RZQsK/BYKmZSgjNBapdqsBehjMCfyWfz7zEa82+Cagm5ohv7himlU8T+sdQ+vgqAofPk
 VTv2JIvhJ95Whi1nFRGk6G2W5CRaMUnCNEl1ftL4pGnFmdJSW1gCMWph7HZ71hoW0wnF
 7Dpl9KIZOlfI9Bp286apKE3NSq9E1Zp43ZxAqHItHM49GgK3S8844DIaXjcoJY7J2uMe
 cV0vctziKe3vBzLTOZ47ytTbqwCqGdfLWYM+I6z97kDSBwUBmlr2l7A7K2TSfdhyz0ir
 nUF4wyFZfgcASagejy2NJ5SazahTNmrSx2qr4zbqsX7mw1BH+BpNAzXD0bEequiuO6v8 uA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcwgwgq25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 19:02:01 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HH9RQF031014;
        Fri, 17 Mar 2023 19:02:00 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3pbs91a2jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 19:02:00 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HJ1xbb31916690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 19:02:00 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2BA25805A;
        Fri, 17 Mar 2023 19:01:59 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 238F758062;
        Fri, 17 Mar 2023 19:01:59 +0000 (GMT)
Received: from [9.65.227.169] (unknown [9.65.227.169])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 19:01:58 +0000 (GMT)
Message-ID: <d91cbe81-b71e-c20e-3604-7c45966ff5d1@linux.ibm.com>
Date:   Fri, 17 Mar 2023 14:01:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net 2/2] netdev: Enforce index cap in netdev_get_tx_queue
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     netdev@vger.kernel.org
References: <20230317181941.86151-1-nnac123@linux.ibm.com>
 <20230317181941.86151-2-nnac123@linux.ibm.com> <ZBS1OiIsv/ys/FE8@nimitz>
Content-Language: en-US
From:   Nick Child <nnac123@linux.ibm.com>
In-Reply-To: <ZBS1OiIsv/ys/FE8@nimitz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 77d1FBr45xvgwQRf31vlBdpJ7yqhs6fp
X-Proofpoint-ORIG-GUID: 77d1FBr45xvgwQRf31vlBdpJ7yqhs6fp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/23 13:45, Piotr Raczynski wrote:
> On Fri, Mar 17, 2023 at 01:19:41PM -0500, Nick Child wrote:
>> When requesting a TX queue at a given index, prevent out-of-bounds
>> referencing by ensuring that the index is within the allocated number
>> of queues.
>>
>> If there is an out-of-bounds reference then inform the user and return
>> a reference to the first tx queue instead.
>>
>> Fixes: e8a0464cc950 ("netdev: Allocate multiple queues for TX.")
>> Signed-off-by: Nick Child <nnac123@linux.ibm.com>
>> ---
>>   include/linux/netdevice.h | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 23b0d7eaaadd..fe88b1a7393d 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -2482,6 +2482,13 @@ static inline
>>   struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
>>   					 unsigned int index)
>>   {
>> +	if (unlikely(index >= dev->num_tx_queues)) {
>> +		net_warn_ratelimited("%s selects TX queue %d, but number of TX queues is %d\n",
>> +				     dev->name, index,
>> +				     dev->num_tx_queues);
>> +		return &dev->_tx[0];
> 
> Why return first queue here instead of NULL, wouldn't that confuse the
> caller instead of return proper (NULL) value?
> 

Thanks for reviewing Piotr.
netdev_get_tx_queue has over 300 callers, most of these calls
use the returned queue immediately without any checking on
the returned value. I don't expect all of these callers
to go and add conditionals to handle this case either.

So I opted for the warning message and a valid return value.
That being said, I am open to more opinions.


> Piotr.
>> +	}
>> +
>>   	return &dev->_tx[index];
>>   }
>>   
>> -- 
>> 2.31.1
>>

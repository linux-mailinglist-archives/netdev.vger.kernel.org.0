Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF12B4F0D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbgKPSSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:18:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730997AbgKPSSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:18:50 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGI5KiB087011;
        Mon, 16 Nov 2020 13:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q3KE73JwEBqDBq327i79QcPHjuhQ8RRfGDDQ1Wvr2Gg=;
 b=rs/b66hiVGbZiTt/BrnfODokL0IEzwX/ZwFgh2ImFbGF83ClqkmzeK4xjINknTaRJ805
 7UvOsUG4TJ7+Npk7JEmuLm4YRKl9ySjmHlROjt6lDHHV1lK0qITgCCI3SOZrSn6Q0o4L
 pUDapoE+Moy1oHUmoNpFbDYDNnJyRdmEKB0oI93/LyaQ0i3OjUvy88UbsyC7PpQinBEZ
 6VRZd4agD2NRKp2K0r4G6PcCvzNadfPdhwYAzvs7+9y4CvEmYKTtlwN5+2nKRsuNpaKL
 ITs27frAXu2eWsVgYd1dkaHBdcG6Z7KOIZSYKu0OH5OqKUdPztDk0F/ByBu8eFMqc6NL ew== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34uvwa2ux1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 13:18:44 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGI5Ajg018462;
        Mon, 16 Nov 2020 18:18:43 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 34t6v8rm14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 18:18:43 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGIIgbC10486316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 18:18:42 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D97B2066;
        Mon, 16 Nov 2020 18:18:42 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCE16B2065;
        Mon, 16 Nov 2020 18:18:41 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.39.145])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 18:18:41 +0000 (GMT)
Subject: Re: [PATCH net-next 02/12] ibmvnic: Introduce indirect subordinate
 Command Response Queue buffer
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605208207-1896-3-git-send-email-tlfalcon@linux.ibm.com>
 <20201114153501.66072756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <c5a1cf31-eab3-817b-917f-ee975681bac3@linux.ibm.com>
Date:   Mon, 16 Nov 2020 12:18:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201114153501.66072756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 mlxscore=0 bulkscore=0 clxscore=1011 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/14/20 5:35 PM, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 13:09:57 -0600 Thomas Falcon wrote:
>> This patch introduces the infrastructure to send batched subordinate
>> Command Response Queue descriptors, which are used by the ibmvnic
>> driver to send TX frame and RX buffer descriptors.
>>
>> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>> @@ -2957,6 +2963,19 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
>>   
>>   	scrq->adapter = adapter;
>>   	scrq->size = 4 * PAGE_SIZE / sizeof(*scrq->msgs);
>> +	scrq->ind_buf.index = 0;
>> +
>> +	scrq->ind_buf.indir_arr =
>> +		dma_alloc_coherent(dev,
>> +				   IBMVNIC_IND_ARR_SZ,
>> +				   &scrq->ind_buf.indir_dma,
>> +				   GFP_KERNEL);
>> +
>> +	if (!scrq->ind_buf.indir_arr) {
>> +		dev_err(dev, "Couldn't allocate indirect scrq buffer\n");
> This warning/error is not necessary, memory allocation will trigger an
> OOM message already.
Thanks, I can fix that in a v2.
>
>> +		goto reg_failed;
> Don't you have to do something like
>
>                          rc = plpar_hcall_norets(H_FREE_SUB_CRQ,
>                                                  adapter->vdev->unit_address,
>                                                  scrq->crq_num);
>
> ?

Yes, you're right, I will include that in a v2 also.

>> +	}
>> +
>>   	spin_lock_init(&scrq->lock);
>>   

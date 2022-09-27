Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61DD5EC1E5
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiI0Lyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiI0Lyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:54:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625DE32EC9;
        Tue, 27 Sep 2022 04:54:37 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RBroAh015071;
        Tue, 27 Sep 2022 11:54:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=xLsQWoQYEmSnbRzAfDyJ0GosO+ncb/MY/54nvuNAncY=;
 b=jvMOG30kZWLXWnxFa1bRIaAeEM+52Yms3ru2FpsOoeFuuuankwbnlwWwMxRFrLNoPZzO
 syvhWINRVewZZ2WFOEkI1GbFADfMTJn4Y7ffgDY9tRyqz6hQpaxN24cik9AP48rwvWPD
 5hmjH7n50yewRbJ/ALGVtNdn1S6bbR4iUHo3jTs+mjXQGkMqUFFshnyV2YVrIfIMCHf7
 /f8mmxRgwZKT0K4/DQCIGlHQ+Own5IInFqhc2zuf8PQvEU+0X/2fYNAO6MHauaUkzlSr
 65S1L0Lys4HeMBsgd4FOVEMOHZs4ag0qRlEAq4DSkK5I3o5GXciJe3rcd6jx1qyDAor3 UQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jv0pr00bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 11:54:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28RBoEuH031152;
        Tue, 27 Sep 2022 11:54:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3jssh8ttsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 11:54:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28RBoFkW46203376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Sep 2022 11:50:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64C9C4204B;
        Tue, 27 Sep 2022 11:54:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0944C42045;
        Tue, 27 Sep 2022 11:54:28 +0000 (GMT)
Received: from [9.152.224.236] (unknown [9.152.224.236])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Sep 2022 11:54:27 +0000 (GMT)
Message-ID: <23b905f8-2836-8879-fe9f-9521e0f8674e@linux.ibm.com>
Date:   Tue, 27 Sep 2022 13:54:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] s390/qeth: Split memcpy() of struct
 qeth_ipacmd_addr_change flexible array
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Cc:     Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20220927003953.1942442-1-keescook@chromium.org>
 <YzJO0f7v7N4Z+9Dk@work>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <YzJO0f7v7N4Z+9Dk@work>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RBvWxvqcdxstuJ3M2seMtC6vRdy9bNz0
X-Proofpoint-GUID: RBvWxvqcdxstuJ3M2seMtC6vRdy9bNz0
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270069
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.09.22 03:16, Gustavo A. R. Silva wrote:
> On Mon, Sep 26, 2022 at 05:39:53PM -0700, Kees Cook wrote:
>> To work around a misbehavior of the compiler's ability to see into
>> composite flexible array structs (as detailed in the coming memcpy()
>> hardening series[1]), split the memcpy() of the header and the payload
>> so no false positive run-time overflow warning will be generated.
>>
>> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/
>>
>> Cc: Alexandra Winter <wintera@linux.ibm.com>
>> Cc: Wenjia Zhang <wenjia@linux.ibm.com>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
>> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
>> Cc: Sven Schnelle <svens@linux.ibm.com>
>> Cc: linux-s390@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Thanks!
> --
> Gustavo
> 
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>

Thank you
Alexandra
>> ---
>>  drivers/s390/net/qeth_l2_main.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
>> index 2d4436cbcb47..0ce635b7b472 100644
>> --- a/drivers/s390/net/qeth_l2_main.c
>> +++ b/drivers/s390/net/qeth_l2_main.c
>> @@ -1530,8 +1530,8 @@ static void qeth_addr_change_event(struct qeth_card *card,
>>  	else
>>  		INIT_DELAYED_WORK(&data->dwork, qeth_l2_dev2br_worker);
>>  	data->card = card;
>> -	memcpy(&data->ac_event, hostevs,
>> -			sizeof(struct qeth_ipacmd_addr_change) + extrasize);
>> +	data->ac_event = *hostevs;
>> +	memcpy(data->ac_event.entry, hostevs->entry, extrasize);
>>  	queue_delayed_work(card->event_wq, &data->dwork, 0);
>>  }
>>  
>> -- 
>> 2.34.1
>>

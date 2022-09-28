Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE985ED79F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiI1IYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiI1IYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:24:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D526DE;
        Wed, 28 Sep 2022 01:24:38 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S81EL7018633;
        Wed, 28 Sep 2022 08:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mI+gFKOJAA7q2PrHJEp9qUHuwPBApdzVA7c154AlUmY=;
 b=Tp9CaJWAvUaBgtgg1bZDYx9VYszd5nzW7UTL4zDxLS8J2QNL/YacLWavhbS+hKe7gE5r
 qSMABX7TMHzD3QVPcn6IRiwVlP7/aoj3alEC4TYLKMACuy3kg+Dg84KkldY+TqC1omUN
 ZwYxtqMaWtbAR7p0qvyt7OH913SzQjqxzLnopdorfTzX4xXvpuQUPldJD84sf+8sxamr
 cManjfIhSLGFfh7jkpxJ6sy6Wo46OREjKzioFBN/L7mwa7+Bmec2hKfKBidcxUJ/8kcg
 mNW0nK4PL4wzAXKo6rkrmsCGm+GRlcfwqgKOc6INKbNnRYl7fLqMoDGHW++w4pYN9dIq jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjd0rprt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:24:36 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28S8F2b9016954;
        Wed, 28 Sep 2022 08:24:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjd0rpr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:24:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S8L0RE003738;
        Wed, 28 Sep 2022 08:24:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3jssh93pwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:24:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S8Owpj52953404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 08:24:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E40911C052;
        Wed, 28 Sep 2022 08:24:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD7B11C04A;
        Wed, 28 Sep 2022 08:24:29 +0000 (GMT)
Received: from [9.145.184.40] (unknown [9.145.184.40])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 08:24:29 +0000 (GMT)
Message-ID: <cfcc8d22-8efd-8b0b-d24f-cb734f9ef927@linux.ibm.com>
Date:   Wed, 28 Sep 2022 10:24:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 3/7] s390/qeth: Convert snprintf() to scnprintf()
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, Jules Irenge <jbi.octave@gmail.com>,
        borntraeger@linux.ibm.com
Cc:     svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        agordeev@linux.ibm.com
References: <YzHyniCyf+G/2xI8@fedora>
 <5138b5a347b79a5f35b75d0babf5f41dbace879a.camel@perches.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <5138b5a347b79a5f35b75d0babf5f41dbace879a.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WJUU4QSdAVgwLmyEbefhVoMAyFdUVnZR
X-Proofpoint-GUID: -rKPFWaD7l21EQy1DW8f_nJI7wJ6Tx7a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280048
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.09.22 16:27, Joe Perches wrote:
> On Mon, 2022-09-26 at 19:42 +0100, Jules Irenge wrote:
>> Coccinnelle reports a warning
>> Warning: Use scnprintf or sprintf
>> Adding to that, there has been a slow migration from snprintf to scnprintf.
>> This LWN article explains the rationale for this change
>> https: //lwn.net/Articles/69419/
>> Ie. snprintf() returns what *would* be the resulting length,
>> while scnprintf() returns the actual length.
> []
>> diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
> []
>> @@ -500,9 +500,9 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
>>  	struct qeth_card *card = dev_get_drvdata(dev);
>>  
>>  	if (card->info.hwtrap)
>> -		return snprintf(buf, 5, "arm\n");
>> +		return scnprintf(buf, 5, "arm\n");
>>  	else
>> -		return snprintf(buf, 8, "disarm\n");
>> +		return scnprintf(buf, 8, "disarm\n");
>>  }
> 
> Use sysfs_emit instead.
> 

Thank you Joe, that sounds like the best way to handle this. 
I propose that I take this onto my ToDo list and test it in the s390 environment.
I will add 
Reported-by: Jules Irenge <jbi.octave@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>


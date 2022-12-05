Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7066427AA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLELji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiLELjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:39:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C7D638A;
        Mon,  5 Dec 2022 03:39:06 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5AYPa1024248;
        Mon, 5 Dec 2022 11:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cNTI5SL4FvFIBg73KMltufSr5UaSr0nsmTr0Xfm/9fM=;
 b=YRA6DNdvetaLU3md5QqNpKTNGMUwbv6YONUxj8kdam7L7zdlV+Pch7K5WjjhG5IvrhkT
 DytnzmRYmdxWyZWRPWn/zqLBQQDvYdBOx7bVS0Wb2PYbYbYYX1iTlKw0KJ/LMesr/WV9
 jjjQJiiKYHBajh1lMQBnzVziPaCd/KOCh9b5Qu6BDcgOw+kDwyUmtHNkh4pwK1dMprMZ
 0RSqiUkcikHe6DheiDs1xrkRIMpi4swguIZ6AX/rf8tDIfxdlgKD9MJGetbyy1wNzP4F
 5huO7VjII//8BPlfrCZxtT/3CfcwMPoy3gUuG08sFevVWSjku4hh9tZ8QHeMR2oYl/Ul aA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g7chv2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 11:39:05 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B5BaGX5015280;
        Mon, 5 Dec 2022 11:39:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3m7x38syu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 11:39:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B5BcxBX29884770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Dec 2022 11:39:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D860242079;
        Mon,  5 Dec 2022 11:38:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D02842072;
        Mon,  5 Dec 2022 11:38:59 +0000 (GMT)
Received: from [9.145.92.128] (unknown [9.145.92.128])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Dec 2022 11:38:59 +0000 (GMT)
Message-ID: <bf5e2905-d37e-7f54-ea2c-b75f2b921679@linux.ibm.com>
Date:   Mon, 5 Dec 2022 12:38:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next] s390/qeth: use sysfs_emit() to instead of
 scnprintf()
Content-Language: en-US
To:     ye.xingchen@zte.com.cn
Cc:     wenjia@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <202212051152565871940@zte.com.cn>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <202212051152565871940@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2V1NuM6mhC6wgO3gev4b23XXAqmPAWab
X-Proofpoint-ORIG-GUID: 2V1NuM6mhC6wgO3gev4b23XXAqmPAWab
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=859
 clxscore=1011 impostorscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212050094
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.12.22 04:52, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/s390/net/qeth_l3_sys.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
> index 1082380b21f8..65eea667e469 100644
> --- a/drivers/s390/net/qeth_l3_sys.c
> +++ b/drivers/s390/net/qeth_l3_sys.c
> @@ -395,7 +395,7 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
>  	}
>  	mutex_unlock(&card->ip_lock);
> 
> -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> +	return str_len ? str_len : sysfs_emit(buf, "\n");
>  }
> 
>  static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
> @@ -614,7 +614,7 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
>  	}
>  	mutex_unlock(&card->ip_lock);
> 
> -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> +	return str_len ? str_len : sysfs_emit(buf, "\n");
>  }
> 
>  static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
There are more instances of scnprintf in s390/net that can be replaced by sysfs_emit. 
We are already working on that. 

But thanks for improving those two.
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>

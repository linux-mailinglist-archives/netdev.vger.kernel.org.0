Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407595E632D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiIVNH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiIVNH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:07:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEADEBBD9;
        Thu, 22 Sep 2022 06:07:52 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MC7s08040211;
        Thu, 22 Sep 2022 13:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=q7LEtkkgFV0njCg4g7kbXCJa8wesV8Ayt2anvsqHOas=;
 b=sXwzZnbOLXR/uT/ONZALao69gWV+4uP48hRtN5By1nyFojYAaSMBgGp2WxISI5NU3c1k
 m5/ZGD2OjKEqMlqRW12afDhs3ImWUok67RFGVcZ2q5R6wozn1rMv4e9sS/R/bL6uN4Vr
 W2eAYRCJuhnW1prVYbNv6GKu+V4HrUo76wSO6v8inNDymjP+IU5dN67Qe68F+raxKpu+
 JDbG4GCQtqinOfrEOCDHtFpeY7jgD/Mye6+m7diRGGyNp/1AqmqoIrk1aT8rOcseR1Sq
 vT30tmTYhgh2IS52He88usNnc0GbgPEAqLsP33UB5733H/wXZMpDNhvuWx3NJWWZAifl zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jrptcb7ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 13:07:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28MC8q2X003722;
        Thu, 22 Sep 2022 13:07:48 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jrptcb7k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 13:07:47 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28MD6PFt029854;
        Thu, 22 Sep 2022 13:07:42 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3jn5va8ycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 13:07:42 +0000
Received: from smtpav05.wdc07v.mail.ibm.com ([9.208.128.117])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28MD7fmE52822472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 13:07:41 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D54458063;
        Thu, 22 Sep 2022 13:07:41 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 344C358043;
        Thu, 22 Sep 2022 13:07:40 +0000 (GMT)
Received: from [9.163.12.13] (unknown [9.163.12.13])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Sep 2022 13:07:40 +0000 (GMT)
Message-ID: <2f6ba289-050a-f77b-3cd2-694317f070bb@linux.ibm.com>
Date:   Thu, 22 Sep 2022 15:07:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH net] net/smc: Stop the CLC flow if no link to map buffers
 on
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1663656189-32090-1-git-send-email-guwen@linux.alibaba.com>
 <cd996f1e-5ebf-c253-6a87-ce0e055b84c8@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <cd996f1e-5ebf-c253-6a87-ce0e055b84c8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JKHiD98_WXfXleaHOmMGugA6scgw81oZ
X-Proofpoint-ORIG-GUID: urIaQd7aj4pxtRKMF2gbw-9AIrixF_GO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_08,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220087
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.09.22 10:29, Wen Gu wrote:
> 
> 
> On 2022/9/20 14:43, Wen Gu wrote:
> 
>> There might be a potential race between SMC-R buffer map and
>> link group termination.
>>
>> smc_smcr_terminate_all()     | smc_connect_rdma()
>> --------------------------------------------------------------
>>                               | smc_conn_create()
>> for links in smcibdev        |
>>          schedule links down  |
>>                               | smc_buf_create()
>>                               |  \- smcr_buf_map_usable_links()
>>                               |      \- no usable links found,
>>                               |         (rmb->mr = NULL)
>>                               |
>>                               | smc_clc_send_confirm()
>>                               |  \- access conn->rmb_desc->mr[]->rkey
>>                               |     (panic)
>>
>> During reboot and IB device module remove, all links will be set
>> down and no usable links remain in link groups. In such situation
>> smcr_buf_map_usable_links() should return an error and stop the
>> CLC flow accessing to uninitialized mr.
>>
>> Fixes: b9247544c1bc ("net/smc: convert static link ID instances to 
>> support multiple links")
>> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
>> ---
>>   net/smc/smc_core.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index ebf56cd..df89c2e 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -2239,7 +2239,7 @@ static struct smc_buf_desc 
>> *smcr_new_buf_create(struct smc_link_group *lgr,
>>   static int smcr_buf_map_usable_links(struct smc_link_group *lgr,
>>                        struct smc_buf_desc *buf_desc, bool is_rmb)
>>   {
>> -    int i, rc = 0;
>> +    int i, rc = 0, cnt = 0;
>>       /* protect against parallel link reconfiguration */
>>       mutex_lock(&lgr->llc_conf_mutex);
>> @@ -2252,9 +2252,12 @@ static int smcr_buf_map_usable_links(struct 
>> smc_link_group *lgr,
>>               rc = -ENOMEM;
>>               goto out;
>>           }
>> +        cnt++;
>>       }
>>   out:
>>       mutex_unlock(&lgr->llc_conf_mutex);
>> +    if (!rc && !cnt)
>> +        rc = -EINVAL;
>>       return rc;
>>   }
> 
> Any comments or reviews are welcome and appreciated.
> 
> Thanks,
> Wen Gu

Sorry for the late answer!
Good catch! Thank you!

Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>

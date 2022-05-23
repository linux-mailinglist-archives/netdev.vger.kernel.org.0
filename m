Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF92530F0D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiEWMiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbiEWMiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:38:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C694B840;
        Mon, 23 May 2022 05:37:58 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NAxWEq017719;
        Mon, 23 May 2022 12:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qPKi7PxbNdFM6KxEjxyHEhorcc7red8WzM25mM1FXF0=;
 b=b6+dt3mmSqPsjYfoXCaxOMXF479b6KOn3fKcpXnQKe7ezjS3j/ChM7HZZCslBbpKGIcV
 EDA3vX6yq+UjUMoJxObVT2hNWALqup+YjeEeZv7780AJwlt1tnPkZ7fAtQWzboT6ihZi
 7nqul+gmOvMhaeNW3nLYmBgwfAKba6wWROaSVSPd2dGFx2pd+Hj+is0DFp0W79koMzwo
 io82Q/XOR/LdYkNF72JtAzbn+Y4EqF9SONNy5VzPswT9gMm1Aj/9lq20XFaiaLP95y01
 PFp1zjEhV54UgScKMOZ0kCAQRmh2PACX+pzsjg8At31s/MIz+OhxFlI1/fM/C/S1C+5v Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g72avah0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:37:51 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24NCHXBk010929;
        Mon, 23 May 2022 12:37:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g72avah01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:37:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NCDLA5029405;
        Mon, 23 May 2022 12:37:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9at86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:37:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NCb0Qv32047508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 12:37:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4B15A405B;
        Mon, 23 May 2022 12:37:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93F29A4054;
        Mon, 23 May 2022 12:37:46 +0000 (GMT)
Received: from [9.152.222.246] (unknown [9.152.222.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 12:37:46 +0000 (GMT)
Message-ID: <f35924c0-4691-3b11-c302-9d79f3e3c1c7@linux.ibm.com>
Date:   Mon, 23 May 2022 14:37:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net] net/smc: fix listen processing for SMC-Rv2
Content-Language: en-US
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ubraun@linux.ibm.com
References: <76eeb1b0-6e4f-986b-c32f-e7e4de3426a7@linux.ibm.com>
 <20220523121245.1910773-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220523121245.1910773-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2YoJIM-9Qej2PQjwFR3RDMYwiZLlEnrl
X-Proofpoint-ORIG-GUID: etNE7qNfI6mGmIT2aq6vjuS3_ElzQA5o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_04,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=977 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230067
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 14:12, liuyacan@corp.netease.com wrote:
>>> From: liuyacan <liuyacan@corp.netease.com>
>>>
>>> In the process of checking whether RDMAv2 is available, the current
>>> implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
>>> smc buf desc, but the latter may fail. Unfortunately, the caller
>>> will only check the former. In this case, a NULL pointer reference
>>> will occur in smc_clc_send_confirm_accept() when accessing
>>> conn->rmb_desc.
>>>
>>> This patch does two things:
>>> 1. Use the return code to determine whether V2 is available.
>>> 2. If the return code is NODEV, continue to check whether V1 is
>>> available.
>>>
>>> Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
>>> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
>>> ---
>>
>> I am not happy with this patch. You are right that this is a problem,
>> but the fix should be much simpler: set ini->smcrv2.ib_dev_v2 = NULL in
>> smc_find_rdma_v2_device_serv() after the not_found label, just like it is
>> done in a similar way for the ISM device in smc_find_ism_v1_device_serv().
>>
>> Your patch changes many more things, and beside that you eliminated the calls 
>> to smc_find_ism_store_rc() completely, which is not correct.
>>
>> Since your patch was already applied (btw. 3:20 hours after you submitted it),
>> please revert it and resend. Thank you.
> 
> I also have considered this way, one question is that do we need to do more roll 
> back work before V1 check? 
> 
> Specifically, In smc_find_rdma_v2_device_serv(), there are the following steps:
> 
> 1. smc_listen_rdma_init()
>    1.1 smc_conn_create()
>    1.2 smc_buf_create()   --> may fail
> 2. smc_listen_rdma_reg()  --> may fail
> 
> When later steps fail, Do we need to roll back previous steps?

That is a good question and I think that is a different problem for another patch.
smc_listen_rdma_init() maybe should call smc_conn_abort() similar to what smc_listen_ism_init()
does in this situation. And when smc_listen_rdma_reg() fails ... hmm we need to think about this.

We will also discuss this here in our team.


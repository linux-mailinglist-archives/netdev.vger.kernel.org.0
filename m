Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3035A614B36
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiKAMyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiKAMyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:54:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0150CE35;
        Tue,  1 Nov 2022 05:54:31 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1CDkiL017408;
        Tue, 1 Nov 2022 12:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qGscPiuX0QSOpKGT3WadhbemaYY5uvKETCqeHPJM4Qw=;
 b=dqMVCj8BPWTIPeP/atJBG8vJP7ymcVBrHOG5JuDnSfwQoVCBCrzcLfcKuDx6hZ2jiP6X
 /b5mChy/YNind0/qr9AChcVWOv2YyOKuFTGaSl4oq5cSTOlih91ai98ji3DEzw+yWzPg
 pZYYyqX+YMsGSUvbbUmWfvjvX+iWKkPUtRJT00w3K2tFsHQ1xdqHcP7+Sp9FiJV4mWE1
 sYwoZbHYX0ynHM0ZFhjzUs+E6AbWCyrrfk9qPVeGbGZl5C1sZ7yjVZvVL9Y7ZclajIvp
 8JK3DHtdPg/1tIclRkQvf00K7B1y54gFBGkJPuf/Og0imIpNTJaR4uhYWiFJUxsbBZFr Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjv4wnqrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 12:54:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A1CJPgZ009687;
        Tue, 1 Nov 2022 12:54:18 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjv4wnqre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 12:54:18 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A1Coibh012584;
        Tue, 1 Nov 2022 12:54:17 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3kguta12mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 12:54:17 +0000
Received: from smtpav01.wdc07v.mail.ibm.com ([9.208.128.113])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A1CsFQL20054620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Nov 2022 12:54:16 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 977945804B;
        Tue,  1 Nov 2022 12:54:15 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A5A258059;
        Tue,  1 Nov 2022 12:54:13 +0000 (GMT)
Received: from [9.163.9.174] (unknown [9.163.9.174])
        by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Nov 2022 12:54:13 +0000 (GMT)
Message-ID: <f51d6df1-4d85-8b65-2480-e626037287aa@linux.ibm.com>
Date:   Tue, 1 Nov 2022 13:54:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH] net/smc: Fix possible leaked pernet namespace in
 smc_init()
To:     Chen Zhongjin <chenzhongjin@huawei.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kgraul@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        guvenc@linux.ibm.com
References: <20221101093722.127223-1-chenzhongjin@huawei.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20221101093722.127223-1-chenzhongjin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l_8v8EMag4i2SDAfI6tWkerWUPzwWQPq
X-Proofpoint-ORIG-GUID: AELET7V63WL7xKhvzPDVeVOZbDR85vg8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_06,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211010095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.11.22 10:37, Chen Zhongjin wrote:
> In smc_init(), register_pernet_subsys(&smc_net_stat_ops) is called
> without any error handling.
> If it fails, registering of &smc_net_ops won't be reverted.
> And if smc_nl_init() fails, &smc_net_stat_ops itself won't be reverted.
> 
> This leaves wild ops in subsystem linkedlist and when another module
> tries to call register_pernet_operations() it triggers page fault:
> 
> BUG: unable to handle page fault for address: fffffbfff81b964c
> RIP: 0010:register_pernet_operations+0x1b9/0x5f0
> Call Trace:
>    <TASK>
>    register_pernet_subsys+0x29/0x40
>    ebtables_init+0x58/0x1000 [ebtables]
>    ...
> 
> Fixes: 194730a9beb5 ("net/smc: Make SMC statistics network namespace aware")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>

It looks good, thank you for the effort!

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> ---
>   net/smc/af_smc.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 3ccbf3c201cd..e12d4fa5aece 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -3380,14 +3380,14 @@ static int __init smc_init(void)
>   
>   	rc = register_pernet_subsys(&smc_net_stat_ops);
>   	if (rc)
> -		return rc;
> +		goto out_pernet_subsys;
>   
>   	smc_ism_init();
>   	smc_clc_init();
>   
>   	rc = smc_nl_init();
>   	if (rc)
> -		goto out_pernet_subsys;
> +		goto out_pernet_subsys_stat;
>   
>   	rc = smc_pnet_init();
>   	if (rc)
> @@ -3480,6 +3480,8 @@ static int __init smc_init(void)
>   	smc_pnet_exit();
>   out_nl:
>   	smc_nl_exit();
> +out_pernet_subsys_stat:
> +	unregister_pernet_subsys(&smc_net_stat_ops);
>   out_pernet_subsys:
>   	unregister_pernet_subsys(&smc_net_ops);
>   

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17045A8D76
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiIAFm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiIAFm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:42:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27701636D8;
        Wed, 31 Aug 2022 22:42:26 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2815Knm5013463;
        Thu, 1 Sep 2022 05:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VxX9Oo6hHzQu2ryj0KSNit0M7AodEHha8xtZmNiTRkw=;
 b=E3Vgj5GwSnQ0iUCA4aNe7HHx54/dk5cS9s2jw5Nx80owo0T5zlM5zF7gt9TgOiFFcDy2
 sZZKDvr0KyYJgLxzaSoY7CXO5JRhgmoWZlYka/8q0huWrlsgY0kfhkY5QJo853r7OUYz
 JinXzUHou2esBS7i5cv8/luCYiGdxgdmdvOVOrZgIvtN5eEGbiJxYE9tkQykd3YWOZXJ
 aZqVEXlxY8TXX4jnvhOM7B98V/ugIEGkexjMOKOui+nQz25aATKbO2RFFL/GUjMytORO
 ZN2D7YBJt8xwiS5sAf8nprema4U+T5pk3NnSZ3fV57QTPLXAqVRVdT1Zy23B3QgXZH6C 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3japgu0qba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 05:42:19 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815OfuJ026507;
        Thu, 1 Sep 2022 05:42:18 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3japgu0qag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 05:42:18 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2815bLIF006456;
        Thu, 1 Sep 2022 05:42:17 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3j7awa71cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 05:42:17 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2815gGsc53281264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 05:42:16 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDCA36E050;
        Thu,  1 Sep 2022 05:42:15 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34F636E04E;
        Thu,  1 Sep 2022 05:42:14 +0000 (GMT)
Received: from [9.211.148.222] (unknown [9.211.148.222])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 05:42:13 +0000 (GMT)
Message-ID: <a4c368d3-d293-10e8-1089-5a2654735e15@linux.ibm.com>
Date:   Thu, 1 Sep 2022 07:42:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net] net/smc: Remove redundant refcount increase
To:     liuyacan@corp.netease.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kgraul@linux.ibm.com, Jan Karcher <jaka@linux.ibm.com>
References: <20220829145329.2751578-1-liuyacan@corp.netease.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20220829145329.2751578-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y8lXAgL7LQRhyTSTLhdvj4uLloS8B8lC
X-Proofpoint-ORIG-GUID: 71GJMytkUj13sDviVduYsBG_y6u5Thhx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_03,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010022
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.08.22 16:53, liuyacan@corp.netease.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> For passive connections, the refcount increment has been done in
> smc_clcsock_accept()-->smc_sock_alloc().
> 
> Fixes: 3b2dec2603d5("net/smc: restructure client and server code in af_smc")
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> ---
>   net/smc/af_smc.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 79c1318af..0939cc3b9 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1855,7 +1855,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
>   {
>   	struct sock *newsmcsk = &new_smc->sk;
>   
> -	sk_refcnt_debug_inc(newsmcsk);
>   	if (newsmcsk->sk_state == SMC_INIT)
>   		newsmcsk->sk_state = SMC_ACTIVE;
>   
Good catch! Thank you for the patch! But fixes should go to the net-next 
tree.

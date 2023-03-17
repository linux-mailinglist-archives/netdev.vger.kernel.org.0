Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD066BF21A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCQUGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjCQUGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:06:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6F7C9268
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:02 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HIfrlK011181;
        Fri, 17 Mar 2023 20:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0e4LV/bUi6fTi4zYRyZo/Ul9W9PbkTK4Y9yIQnYDJ64=;
 b=F5wRcdO1Po9Lrm+NbIf7HIaPmVwvDfiVgDDFFEozJaWyJZcypNeLROvbThzRRFk+zSMe
 pRUvgKu/jbuyyKiTmj7+/yjDHRsiqtaTUHgoOftyet4SpxnP6M5zDthn66d8bEs5HisV
 P+VL4njgOdA95CmsiFwzHQJAW/pOyH8M8GrfO7O8za8ElVSE2PVEYcNaZfomXBMM5uYt
 0HijTujWTutQi9vDfo3x67Xrfy8D3Y33vOe2xVEdey+rO/bKDxEXlDBWfyL8mys1bURX
 ZsQeD45teGHcB9qh6ouEgq5S7562jn/13l/OF4VCKqLHoMyAgWFtg+NlqHbD2QxlNHk9 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcwq4hpr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 20:05:56 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HJpfni009767;
        Fri, 17 Mar 2023 20:05:55 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcwq4hpq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 20:05:55 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32HH6IuT002877;
        Fri, 17 Mar 2023 20:05:54 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3pbs53accs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 20:05:54 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HK5rDD42991974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 20:05:53 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69A1658061;
        Fri, 17 Mar 2023 20:05:53 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D9965805D;
        Fri, 17 Mar 2023 20:05:51 +0000 (GMT)
Received: from [9.211.72.37] (unknown [9.211.72.37])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 20:05:51 +0000 (GMT)
Message-ID: <13f4d846-f2bf-4800-d9ca-4174b586de4b@linux.ibm.com>
Date:   Fri, 17 Mar 2023 21:05:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 07/10] smc: preserve const qualifier in smc_sk()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-8-edumazet@google.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20230317155539.2552954-8-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jz8cx81UHoTXq5xTZFo083E7kIwPxlro
X-Proofpoint-ORIG-GUID: FDAg9T0wq6KPtdRvOLlKmXzYmV8IYB-N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_17,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 clxscore=1011 priorityscore=1501 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.03.23 16:55, Eric Dumazet wrote:
> We can change smc_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Cc: Wenjia Zhang <wenjia@linux.ibm.com>
> Cc: Jan Karcher <jaka@linux.ibm.com>

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

> ---
>   net/smc/smc.h | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 5ed765ea0c731a7f0095cd6a99a0e42d227eaca9..2eeea4cdc7187eed2a3b12888d8f647382f6f2ac 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -283,10 +283,7 @@ struct smc_sock {				/* smc sock container */
>   						 * */
>   };
>   
> -static inline struct smc_sock *smc_sk(const struct sock *sk)
> -{
> -	return (struct smc_sock *)sk;
> -}
> +#define smc_sk(ptr) container_of_const(ptr, struct smc_sock, sk)
>   
>   static inline void smc_init_saved_callbacks(struct smc_sock *smc)
>   {

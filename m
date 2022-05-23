Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660EC531042
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbiEWMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiEWMpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:45:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D2851E7A;
        Mon, 23 May 2022 05:45:35 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NB0CPW006797;
        Mon, 23 May 2022 12:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mxCJhyfwtRnUxKJYT0NEl4A8flEK2OpGdl7/wOUer3U=;
 b=tX07uIZEydCyxgxCV3e3W0M7CRVPlhtQXKvmFQHK7WD5Y02Xzxf3FRZlVNOt4n3oNSmn
 Xjxu/VRL5oBmOSRYWzDHb0wqdj8cZmfIeAeW/9gCXEcJxJhRoeKDiXS3ApNyDzIxwZPl
 zsuwdVvwDBq+8HlSJljumoC7xZdiNfOw8rm9DKg9oYQpsgZCRKx+gYQVkjhFMsULtSZf
 mtwznjHGeaguXn/sNC49KHryl/0+XbW/RaaVvrjUNa3UO8WfUyDOV5GKF7YmDNWkPsBh
 y/IxaYpQlXc7BuF+1psWYd+UG6EhmQ4DV/sVsOvp3dAXp2vZ9LZch+jdMZQQJahifFrH dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g87wjkyn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:45:31 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24NCXSEC013891;
        Mon, 23 May 2022 12:45:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g87wjkym9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:45:30 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NCjCKA017009;
        Mon, 23 May 2022 12:45:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3g6qq8tbj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:45:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NCjOvL33423818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 12:45:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2894A405F;
        Mon, 23 May 2022 12:45:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 762DBA405B;
        Mon, 23 May 2022 12:45:24 +0000 (GMT)
Received: from [9.152.222.246] (unknown [9.152.222.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 12:45:24 +0000 (GMT)
Message-ID: <5ce801b7-d446-ee28-86ec-968b7c172a80@linux.ibm.com>
Date:   Mon, 23 May 2022 14:45:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Content-Language: en-US
To:     liuyacan@corp.netease.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com
References: <20220523032437.1059718-1-liuyacan@corp.netease.com>
 <20220523045707.1704761-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220523045707.1704761-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XS6ue79_VJDWrIuVKCYHMQQeybYcJo7C
X-Proofpoint-ORIG-GUID: AYMnS93NXUhsfJM5lTDPzqC0LYAC7BbE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230069
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 06:57, liuyacan@corp.netease.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> Same trigger condition as commit 86434744. When setsockopt runs
> in parallel to a connect(), and switch the socket into fallback
> mode. Then the sk_refcnt is incremented in smc_connect(), but
> its state stay in SMC_INIT (NOT SMC_ACTIVE). This cause the
> corresponding sk_refcnt decrement in __smc_release() will not be
> performed.
> 
> Fixes: 86434744fedf ("net/smc: add fallback check to connect()")
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> ---
>  net/smc/af_smc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index fce16b9d6..45a24d242 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1564,9 +1564,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>  	if (rc && rc != -EINPROGRESS)
>  		goto out;
>  
> -	sock_hold(&smc->sk); /* sock put in passive closing */
>  	if (smc->use_fallback)
>  		goto out;
> +	sock_hold(&smc->sk); /* sock put in passive closing */
>  	if (flags & O_NONBLOCK) {
>  		if (queue_work(smc_hs_wq, &smc->connect_work))
>  			smc->connect_nonblock = 1;

This is a rather unusual problem that can come up when fallback=true BEFORE smc_connect()
is called. But nevertheless, it is a problem.

Right now I am not sure if it is okay when we NOT hold a ref to smc->sk during all fallback
processing. This change also conflicts with a patch that is already on net-next (3aba1030).

With the new patch on net-next it would also be possible to detect in __smc_release() that
the socket is in state sk->sk_state == SMC_INIT but the sock->state is SS_CONNECTING or 
SS_CONNECTED and call sock_put() in this case.
What do you think?

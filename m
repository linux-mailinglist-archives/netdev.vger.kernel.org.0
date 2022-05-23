Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5815F530FF7
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiEWM0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiEWMYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:24:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EC3FF8;
        Mon, 23 May 2022 05:24:22 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NB05Wc018754;
        Mon, 23 May 2022 12:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sPbcSMLiTyC+FojPdW6YPtd6GpURtaukKSOHCCyVt0s=;
 b=XHmxe9a7zLYoNQ7ZPTL7UtuNe5Br0FcxTaBDxloUyI3l2GjxoPME8uzlCiqo00lzXjBI
 F0eC74p3zdbGlwFGb9/sEa3ktJPGd+tMe28i8nZTcf1tIb4dJQ39EP7YNkXkafnaqhsP
 h1+7OvxpTstKOapgYEDb7w+EzxDTE5t91b82u4En7OHaVZUZ+FV7rjhdFMaFjI6lCyPG
 8CvEItQb0wdD1iwFdTGKF8Cr+1kblJbGurybDeY51W7q5OZIfTMJ6szNa7EZV/dQ6tg+
 OFSVlA3VF+WBSJzRvlZhd746n4y/DAkyxrzA6+U0w6Lk2ASgEMsfrf9+KqyNbRIajsFy Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79dacuwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:24:20 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24NCJ5n0026947;
        Mon, 23 May 2022 12:24:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79dacuvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:24:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NCDhZr029484;
        Mon, 23 May 2022 12:24:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9asnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 12:24:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NCNSI934603476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 12:23:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB425A405B;
        Mon, 23 May 2022 12:24:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D5ACA4054;
        Mon, 23 May 2022 12:24:14 +0000 (GMT)
Received: from [9.152.222.246] (unknown [9.152.222.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 12:24:14 +0000 (GMT)
Message-ID: <3f0405e7-d92b-e8d0-cc61-b25a11644264@linux.ibm.com>
Date:   Mon, 23 May 2022 14:24:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220513022453.7256-1-guangguan.wang@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220513022453.7256-1-guangguan.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: so5t1eKmlr4Qty5lH5TMnAdbyS8-KtDf
X-Proofpoint-GUID: EYEf62CSL_Hu094JC2PJpgd95vvnSRWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_04,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0 mlxscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230067
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2022 04:24, Guangguan Wang wrote:
> Connect with O_NONBLOCK will not be completed immediately
> and returns -EINPROGRESS. It is possible to use selector/poll
> for completion by selecting the socket for writing. After select
> indicates writability, a second connect function call will return
> 0 to indicate connected successfully as TCP does, but smc returns
> -EISCONN. Use socket state for smc to indicate connect state, which
> can help smc aligning the connect behaviour with TCP.
> 
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/af_smc.c | 50 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index fce16b9d6e1a..5f70642a8044 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1544,9 +1544,29 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>  		goto out_err;
>  
>  	lock_sock(sk);
> +	switch (sock->state) {
> +	default:
> +		rc = -EINVAL;
> +		goto out;
> +	case SS_CONNECTED:
> +		rc = sk->sk_state == SMC_ACTIVE ? -EISCONN : -EINVAL;
> +		goto out;
> +	case SS_CONNECTING:
> +		if (sk->sk_state == SMC_ACTIVE)
> +			goto connected;

I stumbled over this when thinking about the fallback processing. If for whatever reason
fallback==true during smc_connect(), the "if (smc->use_fallback)" below would set sock->state
to e.g. SS_CONNECTED. But in the fallback case sk_state keeps SMC_INIT. So during the next call
the SS_CONNECTING case above would break because sk_state in NOT SMC_ACTIVE, and we would end
up calling kernel_connect() again. Which seems to be no problem when kernel_connect() returns 
-EISCONN and we return this to the caller. But is this how it should work, or does it work by chance?

> +		break;
> +	case SS_UNCONNECTED:
> +		sock->state = SS_CONNECTING;
> +		break;
> +	}
> +
>  	switch (sk->sk_state) {
>  	default:
>  		goto out;
> +	case SMC_CLOSED:
> +		rc = sock_error(sk) ? : -ECONNABORTED;
> +		sock->state = SS_UNCONNECTED;
> +		goto out;
>  	case SMC_ACTIVE:
>  		rc = -EISCONN;
>  		goto out;
> @@ -1565,20 +1585,24 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>  		goto out;
>  
>  	sock_hold(&smc->sk); /* sock put in passive closing */
> -	if (smc->use_fallback)
> +	if (smc->use_fallback) {
> +		sock->state = rc ? SS_CONNECTING : SS_CONNECTED;
>  		goto out;
> +	}
>  	if (flags & O_NONBLOCK) {
>  		if (queue_work(smc_hs_wq, &smc->connect_work))
>  			smc->connect_nonblock = 1;
>  		rc = -EINPROGRESS;
> +		goto out;
>  	} else {
>  		rc = __smc_connect(smc);
>  		if (rc < 0)
>  			goto out;
> -		else
> -			rc = 0; /* success cases including fallback */
>  	}
>  
> +connected:
> +	rc = 0;
> +	sock->state = SS_CONNECTED;
>  out:
>  	release_sock(sk);
>  out_err:
> @@ -1693,6 +1717,7 @@ struct sock *smc_accept_dequeue(struct sock *parent,
>  		}
>  		if (new_sock) {
>  			sock_graft(new_sk, new_sock);
> +			new_sock->state = SS_CONNECTED;
>  			if (isk->use_fallback) {
>  				smc_sk(new_sk)->clcsock->file = new_sock->file;
>  				isk->clcsock->file->private_data = isk->clcsock;
> @@ -2424,7 +2449,7 @@ static int smc_listen(struct socket *sock, int backlog)
>  
>  	rc = -EINVAL;
>  	if ((sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) ||
> -	    smc->connect_nonblock)
> +	    smc->connect_nonblock || sock->state != SS_UNCONNECTED)
>  		goto out;
>  
>  	rc = 0;
> @@ -2716,6 +2741,17 @@ static int smc_shutdown(struct socket *sock, int how)
>  
>  	lock_sock(sk);
>  
> +	if (sock->state == SS_CONNECTING) {
> +		if (sk->sk_state == SMC_ACTIVE)
> +			sock->state = SS_CONNECTED;
> +		else if (sk->sk_state == SMC_PEERCLOSEWAIT1 ||
> +			 sk->sk_state == SMC_PEERCLOSEWAIT2 ||
> +			 sk->sk_state == SMC_APPCLOSEWAIT1 ||
> +			 sk->sk_state == SMC_APPCLOSEWAIT2 ||
> +			 sk->sk_state == SMC_APPFINCLOSEWAIT)
> +			sock->state = SS_DISCONNECTING;
> +	}
> +
>  	rc = -ENOTCONN;
>  	if ((sk->sk_state != SMC_ACTIVE) &&
>  	    (sk->sk_state != SMC_PEERCLOSEWAIT1) &&
> @@ -2729,6 +2765,7 @@ static int smc_shutdown(struct socket *sock, int how)
>  		sk->sk_shutdown = smc->clcsock->sk->sk_shutdown;
>  		if (sk->sk_shutdown == SHUTDOWN_MASK) {
>  			sk->sk_state = SMC_CLOSED;
> +			sk->sk_socket->state = SS_UNCONNECTED;
>  			sock_put(sk);
>  		}
>  		goto out;
> @@ -2754,6 +2791,10 @@ static int smc_shutdown(struct socket *sock, int how)
>  	/* map sock_shutdown_cmd constants to sk_shutdown value range */
>  	sk->sk_shutdown |= how + 1;
>  
> +	if (sk->sk_state == SMC_CLOSED)
> +		sock->state = SS_UNCONNECTED;
> +	else
> +		sock->state = SS_DISCONNECTING;
>  out:
>  	release_sock(sk);
>  	return rc ? rc : rc1;
> @@ -3139,6 +3180,7 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
>  
>  	rc = -ENOBUFS;
>  	sock->ops = &smc_sock_ops;
> +	sock->state = SS_UNCONNECTED;
>  	sk = smc_sock_alloc(net, sock, protocol);
>  	if (!sk)
>  		goto out;

-- 
Karsten

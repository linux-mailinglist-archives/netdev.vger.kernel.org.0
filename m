Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E9358331
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfF0NQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:16:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfF0NQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:16:25 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RDBj3D104183
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:16:24 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcwr3juxd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:16:22 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 27 Jun 2019 14:16:20 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 14:16:17 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RDGGqu45547578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 13:16:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31F9142054;
        Thu, 27 Jun 2019 13:16:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC7F74204C;
        Thu, 27 Jun 2019 13:16:15 +0000 (GMT)
Received: from [9.152.222.47] (unknown [9.152.222.47])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 13:16:15 +0000 (GMT)
Subject: Re: [PATCH] net/smc: common release code for non-accepted sockets
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
References: <20190627130452.15408-1-kgraul@linux.ibm.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Thu, 27 Jun 2019 15:16:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627130452.15408-1-kgraul@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062713-0020-0000-0000-0000034DEB7B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062713-0021-0000-0000-000021A16683
Message-Id: <8789853e-d715-1aee-627b-17cc68d8aca1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=997 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I forgot to add that this patch is intended for the net-next tree.


On 27/06/2019 15:04, Karsten Graul wrote:
> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> There are common steps when releasing an accepted or unaccepted socket.
> Move this code into a common routine.
> 
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/af_smc.c | 73 +++++++++++++++++++++---------------------------
>  1 file changed, 32 insertions(+), 41 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 7621ec2f539c..302e355f2ebc 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -123,30 +123,11 @@ struct proto smc_proto6 = {
>  };
>  EXPORT_SYMBOL_GPL(smc_proto6);
>  
> -static int smc_release(struct socket *sock)
> +static int __smc_release(struct smc_sock *smc)
>  {
> -	struct sock *sk = sock->sk;
> -	struct smc_sock *smc;
> +	struct sock *sk = &smc->sk;
>  	int rc = 0;
>  
> -	if (!sk)
> -		goto out;
> -
> -	smc = smc_sk(sk);
> -
> -	/* cleanup for a dangling non-blocking connect */
> -	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
> -		tcp_abort(smc->clcsock->sk, ECONNABORTED);
> -	flush_work(&smc->connect_work);
> -
> -	if (sk->sk_state == SMC_LISTEN)
> -		/* smc_close_non_accepted() is called and acquires
> -		 * sock lock for child sockets again
> -		 */
> -		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
> -	else
> -		lock_sock(sk);
> -
>  	if (!smc->use_fallback) {
>  		rc = smc_close_active(smc);
>  		sock_set_flag(sk, SOCK_DEAD);
> @@ -174,6 +155,35 @@ static int smc_release(struct socket *sock)
>  			smc_conn_free(&smc->conn);
>  	}
>  
> +	return rc;
> +}
> +
> +static int smc_release(struct socket *sock)
> +{
> +	struct sock *sk = sock->sk;
> +	struct smc_sock *smc;
> +	int rc = 0;
> +
> +	if (!sk)
> +		goto out;
> +
> +	smc = smc_sk(sk);
> +
> +	/* cleanup for a dangling non-blocking connect */
> +	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
> +		tcp_abort(smc->clcsock->sk, ECONNABORTED);
> +	flush_work(&smc->connect_work);
> +
> +	if (sk->sk_state == SMC_LISTEN)
> +		/* smc_close_non_accepted() is called and acquires
> +		 * sock lock for child sockets again
> +		 */
> +		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
> +	else
> +		lock_sock(sk);
> +
> +	rc = __smc_release(smc);
> +
>  	/* detach socket */
>  	sock_orphan(sk);
>  	sock->sk = NULL;
> @@ -964,26 +974,7 @@ void smc_close_non_accepted(struct sock *sk)
>  	if (!sk->sk_lingertime)
>  		/* wait for peer closing */
>  		sk->sk_lingertime = SMC_MAX_STREAM_WAIT_TIMEOUT;
> -	if (!smc->use_fallback) {
> -		smc_close_active(smc);
> -		sock_set_flag(sk, SOCK_DEAD);
> -		sk->sk_shutdown |= SHUTDOWN_MASK;
> -	}
> -	sk->sk_prot->unhash(sk);
> -	if (smc->clcsock) {
> -		struct socket *tcp;
> -
> -		tcp = smc->clcsock;
> -		smc->clcsock = NULL;
> -		sock_release(tcp);
> -	}
> -	if (smc->use_fallback) {
> -		sock_put(sk); /* passive closing */
> -		sk->sk_state = SMC_CLOSED;
> -	} else {
> -		if (sk->sk_state == SMC_CLOSED)
> -			smc_conn_free(&smc->conn);
> -	}
> +	__smc_release(smc);
>  	release_sock(sk);
>  	sock_put(sk); /* final sock_put */
>  }
> 

-- 
Karsten

(I'm a dude!)


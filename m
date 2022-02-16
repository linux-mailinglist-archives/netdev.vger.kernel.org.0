Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C4A4B85F0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiBPKdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:33:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBPKdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:33:12 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79489244668;
        Wed, 16 Feb 2022 02:33:00 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21G7dLBt010079;
        Wed, 16 Feb 2022 10:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WKGFS2Dym4YCdvosL5tbeaRC4dqjasH3ysUb6IM9hw8=;
 b=dOzNpovPubXxFp4YtjUQifQ84b/bgx55F51Q9y7t1kdTOUnkwaLVHujwYeH21cyHTATQ
 BfnvKCYj3IducCg/1WXAPGOKkaFXGnbEgzdnuBSBc8UsEofbL3IziddRaUHFU6uEkYGW
 7vdaWiUTXWUlUv8cHIAKAWZ3ccD719S77YVpgUvdRwWqEtfIkO9fPYRurVcWAdQ3E823
 QTHmqiiXQI1Fiy3TOn0yUP7iMy6iwblYnnXQ8vIDwv20gSrVvG+GpPEDk+hUW6cY8Bqg
 Xpz5tsoebHAi0o0kiMJiNeWtXbgxQpQSiwZqmUk11ill38A3PcQffe+BPECmoZeVovXK pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8thyehwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 10:32:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GABKqq003329;
        Wed, 16 Feb 2022 10:32:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8thyehvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 10:32:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GASf9O029564;
        Wed, 16 Feb 2022 10:32:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jy8r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 10:32:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GAWpLt35783114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 10:32:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FF2852052;
        Wed, 16 Feb 2022 10:32:51 +0000 (GMT)
Received: from [9.145.68.35] (unknown [9.145.68.35])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 22B8652050;
        Wed, 16 Feb 2022 10:32:51 +0000 (GMT)
Message-ID: <6e9c637c-50b0-394c-f405-8b98deafa2ef@linux.ibm.com>
Date:   Wed, 16 Feb 2022 11:32:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net/smc: Add autocork support
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220216034903.20173-1-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qluk1lMtjxyon00lA95mheW-dXK6TNGI
X-Proofpoint-ORIG-GUID: MaKi_P_07n-3-A8bYDYx7WqnvL95kq2v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_04,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 04:49, Dust Li wrote:
> This patch adds autocork support for SMC which could improve
> throughput for small message by x2 ~ x4.
> 
> The main idea is borrowed from TCP autocork with some RDMA
> specific modification:

Sounds like a valuable improvement, thank you!

> ---
>  net/smc/smc.h     |   2 +
>  net/smc/smc_cdc.c |  11 +++--
>  net/smc/smc_tx.c  | 118 ++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 114 insertions(+), 17 deletions(-)
> 
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index a096d8af21a0..bc7df235281c 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -192,6 +192,8 @@ struct smc_connection {
>  						 * - dec on polled tx cqe
>  						 */
>  	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
> +	atomic_t		tx_pushing;     /* nr_threads trying tx push */
> +

Is this extra empty line needed?

>  	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
>  	u32			tx_off;		/* base offset in peer rmb */
>  
> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 9d5a97168969..2b37bec90824 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -48,9 +48,14 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
>  		conn->tx_cdc_seq_fin = cdcpend->ctrl_seq;
>  	}
>  
> -	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr) &&
> -	    unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
> -		wake_up(&conn->cdc_pend_tx_wq);
> +	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr)) {
> +		/* If this is the last pending WR complete, we must push to
> +		 * prevent hang when autocork enabled.
> +		 */
> +		smc_tx_sndbuf_nonempty(conn);
> +		if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
> +			wake_up(&conn->cdc_pend_tx_wq);
> +	}
>  	WARN_ON(atomic_read(&conn->cdc_pend_tx_wr) < 0);
>  
>  	smc_tx_sndbuf_nonfull(smc);
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 5df3940d4543..bc737ac79805 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -31,6 +31,7 @@
>  #include "smc_tracepoint.h"
>  
>  #define SMC_TX_WORK_DELAY	0
> +#define SMC_DEFAULT_AUTOCORK_SIZE	(64 * 1024)
>  
>  /***************************** sndbuf producer *******************************/
>  
> @@ -127,10 +128,52 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
>  static bool smc_tx_is_corked(struct smc_sock *smc)
>  {
>  	struct tcp_sock *tp = tcp_sk(smc->clcsock->sk);
> -
>  	return (tp->nonagle & TCP_NAGLE_CORK) ? true : false;
>  }
>  
> +/* If we have pending CDC messages, do not send:
> + * Because CQE of this CDC message will happen shortly, it gives
> + * a chance to coalesce future sendmsg() payload in to one RDMA Write,
> + * without need for a timer, and with no latency trade off.
> + * Algorithm here:
> + *  1. First message should never cork
> + *  2. If we have pending CDC messages, wait for the first
> + *     message's completion
> + *  3. Don't cork to much data in a single RDMA Write to prevent burst,
> + *     total corked message should not exceed min(64k, sendbuf/2)
> + */
> +static bool smc_should_autocork(struct smc_sock *smc, struct msghdr *msg,
> +				int size_goal)
> +{
> +	struct smc_connection *conn = &smc->conn;
> +
> +	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
> +	    smc_tx_prepared_sends(conn) > min(size_goal,
> +					      conn->sndbuf_desc->len >> 1))
> +		return false;
> +	return true;
> +}
> +
> +static bool smc_tx_should_cork(struct smc_sock *smc, struct msghdr *msg)
> +{
> +	struct smc_connection *conn = &smc->conn;
> +
> +	if (smc_should_autocork(smc, msg, SMC_DEFAULT_AUTOCORK_SIZE))
> +		return true;
> +
> +	if ((msg->msg_flags & MSG_MORE ||
> +	     smc_tx_is_corked(smc) ||
> +	     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
> +	    (atomic_read(&conn->sndbuf_space)))
> +		/* for a corked socket defer the RDMA writes if
> +		 * sndbuf_space is still available. The applications
> +		 * should known how/when to uncork it.
> +		 */
> +		return true;
> +
> +	return false;
> +}
> +
>  /* sndbuf producer: main API called by socket layer.
>   * called under sock lock.
>   */
> @@ -177,6 +220,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		if (msg->msg_flags & MSG_OOB)
>  			conn->local_tx_ctrl.prod_flags.urg_data_pending = 1;
>  
> +		/* If our send queue is full but peer have RMBE space,
> +		 * we should send them out before wait
> +		 */
> +		if (!atomic_read(&conn->sndbuf_space) &&
> +		    atomic_read(&conn->peer_rmbe_space) > 0)
> +			smc_tx_sndbuf_nonempty(conn);
> +
>  		if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {
>  			if (send_done)
>  				return send_done;
> @@ -235,15 +285,12 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		 */
>  		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
>  			conn->urg_tx_pend = true;
> -		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc) ||
> -		     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
> -		    (atomic_read(&conn->sndbuf_space)))
> -			/* for a corked socket defer the RDMA writes if
> -			 * sndbuf_space is still available. The applications
> -			 * should known how/when to uncork it.
> -			 */
> -			continue;
> -		smc_tx_sndbuf_nonempty(conn);
> +
> +		/* If we need to cork, do nothing and wait for the next
> +		 * sendmsg() call or push on tx completion
> +		 */
> +		if (!smc_tx_should_cork(smc, msg))
> +			smc_tx_sndbuf_nonempty(conn);
>  
>  		trace_smc_tx_sendmsg(smc, copylen);
>  	} /* while (msg_data_left(msg)) */
> @@ -590,13 +637,26 @@ static int smcd_tx_sndbuf_nonempty(struct smc_connection *conn)
>  	return rc;
>  }
>  
> -int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
> +static int __smc_tx_sndbuf_nonempty(struct smc_connection *conn)
>  {
> -	int rc;
> +	int rc = 0;
> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);

Reverse Christmas tree style please.


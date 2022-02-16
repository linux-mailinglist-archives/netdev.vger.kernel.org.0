Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CAF4B8AE4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiBPN67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:58:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiBPN66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:58:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16957202079;
        Wed, 16 Feb 2022 05:58:46 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GDlbLf026846;
        Wed, 16 Feb 2022 13:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lNAPqqtCSuX/vsilg/MkAWsg1fNPHfwAijoZmnkTPT0=;
 b=nE3q0fdUEMjjGB+yzWiUpBAdxNMH/k0TTVFiqxj472yL3uRAOmZF7pl5JWkCQknsb/Og
 IjnOey72orijB7bYW7e0pUWE6gWs8UVrhxeWlxjRu4hEkqWy/NA0qrJSr/sDzP4OJBhQ
 SKZlIsAESvH8V2jp05L9bO6YPl47isKzKZEb+YoxAMD6TH97bbpfJNzIQfYJQQBvcvyb
 qDT918dAZ5/oUhjDzVFCm9PfQ1X3Vd9IKv3O4l9pS+KcUSiZ5vW2MUr+IWccCBJOLfMU
 5Er9iy/7PBa17Fk4GGrPuZlwbrsrI6TFO653yIyZgwqeK5QCXegz1qUeyD8qjEtw/RHg qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e92fdr5hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 13:58:38 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GDmvE3030543;
        Wed, 16 Feb 2022 13:58:38 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e92fdr5hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 13:58:38 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GDw8hg027471;
        Wed, 16 Feb 2022 13:58:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3e64ha7hvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 13:58:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GDwXSZ40501622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 13:58:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4781011C073;
        Wed, 16 Feb 2022 13:58:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E26B711C069;
        Wed, 16 Feb 2022 13:58:32 +0000 (GMT)
Received: from [9.171.78.213] (unknown [9.171.78.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Feb 2022 13:58:32 +0000 (GMT)
Message-ID: <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
Date:   Wed, 16 Feb 2022 14:58:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net/smc: Add autocork support
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20220216034903.20173-1-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lcJzRf0C21pzu8YaZKeQXBIOR9-fy569
X-Proofpoint-ORIG-GUID: NCwh-WFYscH0r4Qvu12aA1rtn5K9CP9x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_06,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202160078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 04:49, Dust Li wrote:
> This patch adds autocork support for SMC which could improve
> throughput for small message by x2 ~ x4.
> 
> The main idea is borrowed from TCP autocork with some RDMA
> specific modification:
> 1. The first message should never cork to make sure we won't
>     bring extra latency
> 2. If we have posted any Tx WRs to the NIC that have not
>     completed, cork the new messages until:
>     a) Receive CQE for the last Tx WR
>     b) We have corked enough message on the connection
> 3. Try to push the corked data out when we receive CQE of
>     the last Tx WR to prevent the corked messages hang in
>     the send queue.
> 
> Both SMC autocork and TCP autocork check the TX completion
> to decide whether we should cork or not. The difference is
> when we got a SMC Tx WR completion, the data have been confirmed
> by the RNIC while TCP TX completion just tells us the data
> have been sent out by the local NIC.
> 
> Add an atomic variable tx_pushing in smc_connection to make
> sure only one can send to let it cork more and save CDC slot.
> 
> SMC autocork should not bring extra latency since the first
> message will always been sent out immediately.
> 
> The qperf tcp_bw test shows more than x4 increase under small
> message size with Mellanox connectX4-Lx, same result with other
> throughput benchmarks like sockperf/netperf.
> The qperf tcp_lat test shows SMC autocork has not increase any
> ping-pong latency.
> 
> BW test:
>   client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
> 			-t 30 -vu tcp_bw
>   server: smc_run taskset -c 1 qperf
> 
> MsgSize(Bytes)        TCP         SMC-NoCork           SMC-AutoCork
>        1         2.57 MB/s     698 KB/s(-73.5%)     2.98 MB/s(16.0% )
>        2          5.1 MB/s    1.41 MB/s(-72.4%)     5.82 MB/s(14.1% )
>        4         10.2 MB/s    2.83 MB/s(-72.3%)     11.7 MB/s(14.7% )
>        8         20.8 MB/s    5.62 MB/s(-73.0%)     22.9 MB/s(10.1% )
>       16         42.5 MB/s    11.5 MB/s(-72.9%)     45.5 MB/s(7.1%  )
>       32         80.7 MB/s    22.3 MB/s(-72.4%)     86.7 MB/s(7.4%  )
>       64          155 MB/s    45.6 MB/s(-70.6%)      160 MB/s(3.2%  )
>      128          295 MB/s    90.1 MB/s(-69.5%)      273 MB/s(-7.5% )
>      256          539 MB/s     179 MB/s(-66.8%)      610 MB/s(13.2% )
>      512          943 MB/s     360 MB/s(-61.8%)     1.02 GB/s(10.8% )
>     1024         1.58 GB/s     710 MB/s(-56.1%)     1.91 GB/s(20.9% )
>     2048         2.47 GB/s    1.34 GB/s(-45.7%)     2.92 GB/s(18.2% )
>     4096         2.86 GB/s     2.5 GB/s(-12.6%)      2.4 GB/s(-16.1%)
>     8192         3.89 GB/s    3.14 GB/s(-19.3%)     4.05 GB/s(4.1%  )
>    16384         3.29 GB/s    4.67 GB/s(41.9% )     5.09 GB/s(54.7% )
>    32768         2.73 GB/s    5.48 GB/s(100.7%)     5.49 GB/s(101.1%)
>    65536            3 GB/s    4.85 GB/s(61.7% )     5.24 GB/s(74.7% )
> 
> Latency test:
>   client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
> 			-t 30 -vu tcp_lat
>   server: smc_run taskset -c 1 qperf
> 
>   MsgSize              SMC-NoCork           SMC-AutoCork
>         1               9.7 us               9.6 us( -1.03%)
>         2              9.43 us              9.39 us( -0.42%)
>         4               9.6 us              9.35 us( -2.60%)
>         8              9.42 us               9.2 us( -2.34%)
>        16              9.13 us              9.43 us(  3.29%)
>        32              9.19 us               9.5 us(  3.37%)
>        64              9.38 us               9.5 us(  1.28%)
>       128               9.9 us              9.29 us( -6.16%)
>       256              9.42 us              9.26 us( -1.70%)
>       512                10 us              9.45 us( -5.50%)
>      1024              10.4 us               9.6 us( -7.69%)
>      2048              10.4 us              10.2 us( -1.92%)
>      4096                11 us              10.5 us( -4.55%)
>      8192              11.7 us              11.8 us(  0.85%)
>     16384              14.5 us              14.2 us( -2.07%)
>     32768              19.4 us              19.3 us( -0.52%)
>     65536              28.1 us              28.8 us(  2.49%)
> 
> With SMC autocork support, we can archive better throughput than
> TCP in most message sizes without any latency tradeoff.
> 
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>   net/smc/smc.h     |   2 +
>   net/smc/smc_cdc.c |  11 +++--
>   net/smc/smc_tx.c  | 118 ++++++++++++++++++++++++++++++++++++++++------
>   3 files changed, 114 insertions(+), 17 deletions(-)
> 
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index a096d8af21a0..bc7df235281c 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -192,6 +192,8 @@ struct smc_connection {
>   						 * - dec on polled tx cqe
>   						 */
>   	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
> +	atomic_t		tx_pushing;     /* nr_threads trying tx push */
> +
>   	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
>   	u32			tx_off;		/* base offset in peer rmb */
>   
> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 9d5a97168969..2b37bec90824 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -48,9 +48,14 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
>   		conn->tx_cdc_seq_fin = cdcpend->ctrl_seq;
>   	}
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
>   	WARN_ON(atomic_read(&conn->cdc_pend_tx_wr) < 0);
>   
>   	smc_tx_sndbuf_nonfull(smc);
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 5df3940d4543..bc737ac79805 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -31,6 +31,7 @@
>   #include "smc_tracepoint.h"
>   
>   #define SMC_TX_WORK_DELAY	0
> +#define SMC_DEFAULT_AUTOCORK_SIZE	(64 * 1024)

Probably a matter of taste, but why not use hex here?

>   
>   /***************************** sndbuf producer *******************************/
>   
> @@ -127,10 +128,52 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
>   static bool smc_tx_is_corked(struct smc_sock *smc)
>   {
>   	struct tcp_sock *tp = tcp_sk(smc->clcsock->sk);
> -
>   	return (tp->nonagle & TCP_NAGLE_CORK) ? true : false;
>   }

Can you drop this line elimination?


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

I assume the 64k is incurred from IP as used by RoCEv2?


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

Are there any fixed plans to make SMC_DEFAULT_AUTOCORK dynamic...? 'cause 
otherwise we could simply eliminate this parameter, and use the define within 
smc_should_autocork() instead.


Ciao,
Stefan

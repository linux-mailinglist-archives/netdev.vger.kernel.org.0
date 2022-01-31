Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4FF4A4774
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377686AbiAaMp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:45:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237795AbiAaMp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:45:56 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VAW3Wd002646;
        Mon, 31 Jan 2022 12:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/OsTF9SJkYAu207G1ekmBdpbvs3JYQQljIoeEwnOH0I=;
 b=ih7UbMKTfMdaxx6qnN9sUkiX3IQvswa0xovzyAmdXTSCqQQzuCm1AzROuurZdzOUC5jd
 ++sjQ4oUFzR9sNRUaZl8Le9Q2Wh1FMYevj++DLIC24ufns1jYFbWUqn7ITxo6npo1o+v
 BgzhaCYDsSch7gQ3noe4c8CjZKWf+Yyd/rTuvWEI0BdknNsr2lYNCBrQAhxN+ebD24vA
 q9911/PqGxjdAEYeB4412Gfk1QvyDsrANwrUoNf6lyL3fpuCa2fRSHpcJFNSpR4IwSZU
 dAQOtYmIZNTmu8sUgWY4Y0MLW6EwJ5TDNMUVXI5fEFvVtsKAkGORgK+wce/j9jccabgt 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxe3ptm6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:45:45 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VCUIKl024511;
        Mon, 31 Jan 2022 12:45:45 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxe3ptm68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:45:45 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VCgM1K011710;
        Mon, 31 Jan 2022 12:45:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3dvw79aqjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 12:45:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VCjeHJ36635086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 12:45:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 805E411C05E;
        Mon, 31 Jan 2022 12:45:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27E2511C054;
        Mon, 31 Jan 2022 12:45:40 +0000 (GMT)
Received: from [9.145.79.147] (unknown [9.145.79.147])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 12:45:40 +0000 (GMT)
Message-ID: <0b99dc4d-319e-e4fa-b4bf-ddce5005be47@linux.ibm.com>
Date:   Mon, 31 Jan 2022 13:45:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/3] net/smc: Make smc_tcp_listen_work()
 independent
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        matthieu.baerts@tessares.net
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <53383b68f056b4c6d697935d2ea1c170618eebbe.1643380219.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <53383b68f056b4c6d697935d2ea1c170618eebbe.1643380219.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9IhOtLglKAFp9Wg4JeacZKxDFX1s9vHT
X-Proofpoint-ORIG-GUID: GIbkTT_ul5vJdf_bFZ6FkDf4fIh_j-iP
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2022 15:44, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> In multithread and 10K connections benchmark, the backend TCP connection
> established very slowly, and lots of TCP connections stay in SYN_SENT
> state.
> 
> Client: smc_run wrk -c 10000 -t 4 http://server
> 
> the netstate of server host shows like:
>     145042 times the listen queue of a socket overflowed
>     145042 SYNs to LISTEN sockets dropped
> 
> One reason of this issue is that, since the smc_tcp_listen_work() shared
> the same workqueue (smc_hs_wq) with smc_listen_work(), while the
> smc_listen_work() do blocking wait for smc connection established. Once
> the workqueue became congested, it's will block the accpet() from TCP
                                                      ^^^
                                                      accept()
> listen.
> 
> This patch creates a independent workqueue(smc_tcp_ls_wq) for
> smc_tcp_listen_work(), separate it from smc_listen_work(), which is
> quite acceptable considering that smc_tcp_listen_work() runs very fast.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  net/smc/af_smc.c | 13 +++++++++++--
>  net/smc/smc.h    |  1 +
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index d5ea62b..1b40304 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -59,6 +59,7 @@
>  						 * creation on client
>  						 */
>  
> +struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
>  struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>  struct workqueue_struct	*smc_close_wq;	/* wq for close work */
>  
> @@ -2124,7 +2125,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
>  	lsmc->clcsk_data_ready(listen_clcsock);
>  	if (lsmc->sk.sk_state == SMC_LISTEN) {
>  		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
> -		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
> +		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
>  			sock_put(&lsmc->sk);
>  	}
>  }
> @@ -2919,9 +2920,14 @@ static int __init smc_init(void)
>  		goto out_nl;
>  
>  	rc = -ENOMEM;
> +
> +	smc_tcp_ls_wq = alloc_workqueue("smc_tcp_ls_wq", 0, 0);
> +	if (!smc_tcp_ls_wq)
> +		goto out_pnet;
> +
>  	smc_hs_wq = alloc_workqueue("smc_hs_wq", 0, 0);
>  	if (!smc_hs_wq)
> -		goto out_pnet;
> +		goto out_alloc_tcp_ls_wq;
>  
>  	smc_close_wq = alloc_workqueue("smc_close_wq", 0, 0);
>  	if (!smc_close_wq)
> @@ -2992,6 +2998,8 @@ static int __init smc_init(void)
>  	destroy_workqueue(smc_close_wq);
>  out_alloc_hs_wq:
>  	destroy_workqueue(smc_hs_wq);
> +out_alloc_tcp_ls_wq:
> +	destroy_workqueue(smc_tcp_ls_wq);
>  out_pnet:
>  	smc_pnet_exit();
>  out_nl:
> @@ -3010,6 +3018,7 @@ static void __exit smc_exit(void)
>  	smc_core_exit();
>  	smc_ib_unregister_client();
>  	destroy_workqueue(smc_close_wq);
> +	destroy_workqueue(smc_tcp_ls_wq);
>  	destroy_workqueue(smc_hs_wq);
>  	proto_unregister(&smc_proto6);
>  	proto_unregister(&smc_proto);
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 3d0b8e3..bd2f3dc 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -264,6 +264,7 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
>  	return (struct smc_sock *)sk;
>  }
>  
> +extern struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */

I don't think this extern is needed, the work queue is only used within af_smc.c, right?
Even the smc_hs_wq would not need to be extern, but this would be a future cleanup.

>  extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>  extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
>  


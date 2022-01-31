Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C44A4F94
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243147AbiAaTk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:40:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64104 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbiAaTk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:40:57 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VJU1As030962;
        Mon, 31 Jan 2022 19:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1yjwJXH69A6OJPu4EaMuUsdQEykVrKv84jkBq4e/4oU=;
 b=ONYeTxY0jpFpIWQE9dAD8qxezRWp4SIqlHh5oBNpVrUzSCbyhB4P6AVDJQtbMlKT57lI
 8aNDHZ9u/T6HGGA8bi6WRqHJkoU3tjLrqb1ktbHREO8+736/90ASIO5oHVN5v2hCHBiJ
 B7qseAfBM7Cu1/bbHUCB53pHr3NgCZ0DqCpxqkOemkOEbMLeYDHO4XQxPTrfhyXkPwZt
 6naVG9XY9o7vI1u4IY3mUg/LJjuY6GZkZncERzi471Djjf8OIbvk1slYGnLcoGPl4Ncb
 PwQqP+NICUsC23v7l5Pj/IRrcJAUMQQgAB+bRPcwLC4jCh768fzupOaixo4q5jJKC8Yg 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxfduaah3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:40:53 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VJNsLW016766;
        Mon, 31 Jan 2022 19:40:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxfduaagj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:40:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VJMRKZ021916;
        Mon, 31 Jan 2022 19:40:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3dvw79ds5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:40:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VJV19Z45941042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 19:31:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ABB611C05B;
        Mon, 31 Jan 2022 19:40:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D09EC11C052;
        Mon, 31 Jan 2022 19:40:47 +0000 (GMT)
Received: from [9.171.28.92] (unknown [9.171.28.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 19:40:47 +0000 (GMT)
Message-ID: <becbfd54-5a42-9867-f3ac-b347b561985f@linux.ibm.com>
Date:   Mon, 31 Jan 2022 20:40:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 2/3] net/smc: Remove corked dealyed work
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-3-tonylu@linux.alibaba.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20220130180256.28303-3-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GkieSeVXFjA0d3o9V4xA9yXMOUGdLyBk
X-Proofpoint-ORIG-GUID: li5k-J7izJp8hqlJ1-O49wrMIL4i9Rhz
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201310125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/22 19:02, Tony Lu wrote:
> Based on the manual of TCP_CORK [1] and MSG_MORE [2], these two options
> have the same effect. Applications can set these options and informs the
> kernel to pend the data, and send them out only when the socket or
> syscall does not specify this flag. In other words, there's no need to
> send data out by a delayed work, which will queue a lot of work.
> 
> This removes corked delayed work with SMC_TX_CORK_DELAY (250ms), and the
> applications control how/when to send them out. It improves the
> performance for sendfile and throughput, and remove unnecessary race of
> lock_sock(). This also unlocks the limitation of sndbuf, and try to fill
> it up before sending.
> 
> [1] https://linux.die.net/man/7/tcp
> [2] https://man7.org/linux/man-pages/man2/send.2.html
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>   net/smc/smc_tx.c | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 7b0b6e24582f..9cec62cae7cb 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -31,7 +31,6 @@
>   #include "smc_tracepoint.h"
>   
>   #define SMC_TX_WORK_DELAY	0
> -#define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
>   
>   /***************************** sndbuf producer *******************************/
>   
> @@ -237,15 +236,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>   		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
>   			conn->urg_tx_pend = true;
>   		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
> -		    (atomic_read(&conn->sndbuf_space) >
> -						(conn->sndbuf_desc->len >> 1)))
> -			/* for a corked socket defer the RDMA writes if there
> -			 * is still sufficient sndbuf_space available
> +		    (atomic_read(&conn->sndbuf_space)))
> +			/* for a corked socket defer the RDMA writes if
> +			 * sndbuf_space is still available. The applications
> +			 * should known how/when to uncork it.
>   			 */
> -			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
> -					   SMC_TX_CORK_DELAY);
> -		else
> -			smc_tx_sndbuf_nonempty(conn);
> +			continue;

In case we just corked the final bytes in this call, wouldn't this 'continue' 
prevent us from accounting the Bytes that we just staged to be sent out later in 
the trace_smc_tx_sendmsg() call below?

> +		smc_tx_sndbuf_nonempty(conn);
>   
>   		trace_smc_tx_sendmsg(smc, copylen);



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773544A4F3E
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359248AbiAaTOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:14:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230501AbiAaTOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:14:03 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VGcNhf009118;
        Mon, 31 Jan 2022 19:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/clznWryst0rmQYx66ZluWia5b2RsqBFb0qilzlKL/s=;
 b=Aw3Lm7582v2ziy5vlAdfq4I8+p6hMKGaLR7LTptubUaa3/eaXRwhpacoSqMwgByTH0FS
 xkn8HxfKj1vzyXMEJo4tXGyXaUyETyvVzJCSim/cy0jwidcv3arynpFzFqysGAfzlQ5x
 qUoJmY+QRzW6ShBAVNd8kyJVSzuByaLeg8xBcOjFyljmCVJ+Jdg2Lc2eQms+KWZdN4m6
 DzBHQhsZSwKt/K61An6QxdseaQk0WBzcE+hk51mPI6EOYQ0B4HmAODwetLdGpsR6Ecy/
 68qjnDZiEGZDR2WG8BmzUxGdYpLkzjRyGsJgajTS9IorOEgEqjcJ5szCJje83sN4o6Rv dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dxk0nmjs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:13:58 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VIn2xT022913;
        Mon, 31 Jan 2022 19:13:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dxk0nmjrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:13:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VJ8U8p005457;
        Mon, 31 Jan 2022 19:13:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3dvw79eeh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 19:13:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VJDrlC30474712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 19:13:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB3EE11C04A;
        Mon, 31 Jan 2022 19:13:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9603911C050;
        Mon, 31 Jan 2022 19:13:53 +0000 (GMT)
Received: from [9.171.28.92] (unknown [9.171.28.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 19:13:53 +0000 (GMT)
Message-ID: <74aaa8ce-81a4-b048-cee2-b137279d13d5@linux.ibm.com>
Date:   Mon, 31 Jan 2022 20:13:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 1/3] net/smc: Send directly when TCP_CORK is
 cleared
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
 <20220130180256.28303-2-tonylu@linux.alibaba.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20220130180256.28303-2-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Br_g-0b0g3KL7vtmlrQPw7gdtTRtoyrS
X-Proofpoint-GUID: qmtZgZUE6-uDiiY1lg52DXSeXDlH2g3T
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/22 19:02, Tony Lu wrote:
> According to the man page of TCP_CORK [1], if set, don't send out
> partial frames. All queued partial frames are sent when option is
> cleared again.
> 
> When applications call setsockopt to disable TCP_CORK, this call is
> protected by lock_sock(), and tries to mod_delayed_work() to 0, in order
> to send pending data right now. However, the delayed work smc_tx_work is
> also protected by lock_sock(). There introduces lock contention for
> sending data.
> 
> To fix it, send pending data directly which acts like TCP, without
> lock_sock() protected in the context of setsockopt (already lock_sock()ed),
> and cancel unnecessary dealyed work, which is protected by lock.
> 
> [1] https://linux.die.net/man/7/tcp
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>   net/smc/af_smc.c |  4 ++--
>   net/smc/smc_tx.c | 25 +++++++++++++++----------
>   net/smc/smc_tx.h |  1 +
>   3 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index ffab9cee747d..ef021ec6b361 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2600,8 +2600,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
>   		    sk->sk_state != SMC_CLOSED) {
>   			if (!val) {
>   				SMC_STAT_INC(smc, cork_cnt);
> -				mod_delayed_work(smc->conn.lgr->tx_wq,
> -						 &smc->conn.tx_work, 0);
> +				smc_tx_pending(&smc->conn);
> +				cancel_delayed_work(&smc->conn.tx_work);
>   			}
>   		}
>   		break;
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index be241d53020f..7b0b6e24582f 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -597,27 +597,32 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
>   	return rc;
>   }
>   
> -/* Wakeup sndbuf consumers from process context
> - * since there is more data to transmit
> - */
> -void smc_tx_work(struct work_struct *work)
> +void smc_tx_pending(struct smc_connection *conn)

Could you add a comment that we're expecting lock_sock() to be held when calling 
this function?

Thanks,
Stefan

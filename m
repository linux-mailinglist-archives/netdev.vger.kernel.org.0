Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F794AF637
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbiBIQL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiBIQLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:11:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4297FC0613C9;
        Wed,  9 Feb 2022 08:11:58 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219ES2Hm008131;
        Wed, 9 Feb 2022 16:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/l7ubBnkdtozsCslZUfArhpZsA6rQOm09z1CLCWoRFk=;
 b=MQ1RRWhUHqSdBAbIQaqHqQ24QvwmWcUjEXNPSPnJgax0AlBl3skAiE/FKEWyjVcnyuIu
 OXnpNFccZXdOLYdBUFgwPk2wsKDsdzwoP+4zbWBEJ6XdG55BCyG5XWcH1XxyPLpg/NHX
 wLt+S2/+XQKAih9v4ZLQNXpjOZT6ob70n6FjalyTnJvM5afG4YzscUeA0eJrw6Dl6DE5
 iEaBNEx+vXtf47WyB1eQu55v10H1Z1kpi7ooGfi3tERYZj7vjbejsaw/ztMA2TEVNL2p
 blwwQY755Y79RsCROTWRJT0t1trjyVHVFkELUyzvv7jlpn3Uvrfa1sNcU/McPVa/ENhr xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e48t8kg1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:11:53 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219FlvLi005099;
        Wed, 9 Feb 2022 16:11:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e48t8kg1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:11:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219FvU7w027922;
        Wed, 9 Feb 2022 16:11:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygqdwky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:11:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219GBnSw45678866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 16:11:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CBB211C04C;
        Wed,  9 Feb 2022 16:11:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7D1E11C050;
        Wed,  9 Feb 2022 16:11:48 +0000 (GMT)
Received: from [9.145.0.171] (unknown [9.145.0.171])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 16:11:48 +0000 (GMT)
Message-ID: <5a7d20f9-2726-13a0-7bb9-ecb061de58c7@linux.ibm.com>
Date:   Wed, 9 Feb 2022 17:11:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v6 3/5] net/smc: Fallback when handshake
 workqueue congested
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
 <87d49c573a15e13a26314316692fccca91741042.1644413637.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <87d49c573a15e13a26314316692fccca91741042.1644413637.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G9SgjDEo3MjfaBlnUsAigZdJyAncc65L
X-Proofpoint-GUID: AuCOddg3WTyGmq8JJkOBJGwo_cheY4Q-
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 15:11, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch intends to provide a mechanism to allow automatic fallback to

I would like to avoid the wording fallback all over here. The term SMC fallback
is used for SMC connections that are in our socket list, but use TCP because 
something went wrong during handshake.
What you changes result in are TCP-only connections which are not handled by
the SMC module at all. So the comments should use a different naming for that.
What the patch actually does is to disable the SMC experimental TCP header option,
so the client receives no SMC indication and does not proceed with SMC.
Is this correct?

Please also see my comments below.

> TCP according to the pressure of SMC handshake process. At present,
> frequent visits will cause the incoming connections to be backlogged in
> SMC handshake queue, raise the connections established time. Which is
> quite unacceptable for those applications who base on short lived
> connections.
> 
> There are two ways to implement this mechanism:
> 
> 1. Fallback when TCP established.
> 2. Fallback before TCP established.
> 
> In the first way, we need to wait and receive CLC messages that the
> client will potentially send, and then actively reply with a decline
> message, in a sense, which is also a sort of SMC handshake, affect the
> connections established time on its way.
> 
> In the second way, the only problem is that we need to inject SMC logic
> into TCP when it is about to reply the incoming SYN, since we already do
> that, it's seems not a problem anymore. And advantage is obvious, few
> additional processes are required to complete the fallback.
> 
> This patch use the second way.
> 
> Link: https://lore.kernel.org/all/1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com/
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  include/linux/tcp.h  |  1 +
>  net/ipv4/tcp_input.c |  3 ++-
>  net/smc/af_smc.c     | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 78b91bb..1c4ae5d 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -394,6 +394,7 @@ struct tcp_sock {
>  	bool	is_mptcp;
>  #endif
>  #if IS_ENABLED(CONFIG_SMC)
> +	bool	(*smc_in_limited)(const struct sock *sk);

Better variable name: smc_hs_congested

>  	bool	syn_smc;	/* SYN includes SMC */
>  #endif
>  
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index af94a6d..e817ec6 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6703,7 +6703,8 @@ static void tcp_openreq_init(struct request_sock *req,
>  	ireq->ir_num = ntohs(tcp_hdr(skb)->dest);
>  	ireq->ir_mark = inet_request_mark(sk, skb);
>  #if IS_ENABLED(CONFIG_SMC)
> -	ireq->smc_ok = rx_opt->smc_ok;
> +	ireq->smc_ok = rx_opt->smc_ok && !(tcp_sk(sk)->smc_in_limited &&
> +			tcp_sk(sk)->smc_in_limited(sk));

Use new name here and elsewhere ...

>  #endif
>  }
>  
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index ebfce3d..8175f60 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -101,6 +101,22 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk, struct sk_buff
>  	return NULL;
>  }
>  
> +static bool smc_is_in_limited(const struct sock *sk)

Better function name: smc_hs_congested()

> +{
> +	const struct smc_sock *smc;
> +
> +	smc = (const struct smc_sock *)
> +		((uintptr_t)sk->sk_user_data & ~SK_USER_DATA_NOCOPY);
> +
> +	if (!smc)
> +		return true;
> +
> +	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
> +		return true;
> +
> +	return false;
> +}
> +
>  static struct smc_hashinfo smc_v4_hashinfo = {
>  	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
>  };
> @@ -2309,6 +2325,8 @@ static int smc_listen(struct socket *sock, int backlog)
>  
>  	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
>  
> +	tcp_sk(smc->clcsock->sk)->smc_in_limited = smc_is_in_limited;

Use new names here, too.

> +
>  	rc = kernel_listen(smc->clcsock, backlog);
>  	if (rc) {
>  		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;

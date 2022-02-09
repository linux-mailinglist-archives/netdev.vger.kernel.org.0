Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914B34AF66A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiBIQUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiBIQUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:20:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFDC0613C9;
        Wed,  9 Feb 2022 08:20:34 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219EWqIL001828;
        Wed, 9 Feb 2022 16:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zLOM4fUqZr3BHmfmezozAjQbhj9W1MV+S2I9gBFlRks=;
 b=gKPSGyUShYzoulj3hig625kH6MEKtvTkmErjltxWClkzBy2t369kU3pa+ML92L8ZBLLQ
 usFl5FwbzZmBbj6o3FtPrzjtss6yxkZUsJFKG9g12FKJboeRTc+mTUTRJxfzBgbRYSG5
 xsoPTasWjvTgPda5JC2/cJLxvrhMAS2D5jNJoIGBebCQkPzRs4JxmoPFuhIT+28ClM0j
 kRyduR5N1WUGJWA7WYPPTyCNG0K8I2GkERtaPR+8F20dbGQmGa38245r2BFFfWJ1SvJq
 z9OwW+wAnCFvtmn9HV9kCeiLZVlGL4jMb+DJzVYG2oNJqZl9HsOnxdX0hmiltxrSbBLt tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4fffjfxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:20:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219G0t8G019293;
        Wed, 9 Feb 2022 16:20:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4fffjfx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:20:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219FvV3M027929;
        Wed, 9 Feb 2022 16:20:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygqdyak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 16:20:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219GKMqY46727510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 16:20:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD9DD11C058;
        Wed,  9 Feb 2022 16:20:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6347E11C04C;
        Wed,  9 Feb 2022 16:20:22 +0000 (GMT)
Received: from [9.145.0.171] (unknown [9.145.0.171])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 16:20:22 +0000 (GMT)
Message-ID: <720d192e-7a42-aa65-f942-84e8f89994c5@linux.ibm.com>
Date:   Wed, 9 Feb 2022 17:20:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v6 4/5] net/smc: Dynamic control auto fallback by
 socket options
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
 <47e067deb658407bc68899ee9e6827f8159f11b4.1644413637.git.alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <47e067deb658407bc68899ee9e6827f8159f11b4.1644413637.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q2rX_i6xHLSwkMUjiO6VAFjs_DIwLgUk
X-Proofpoint-GUID: 011nBDfTQVMxyZRUxhg8RoOAF98rc-44
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202090090
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
> This patch aims to add dynamic control for SMC auto fallback, since we

Same here, we need a different wording. Maybe something like 
"SMC handshake limitation".

> don't have socket option level for SMC yet, which requires we need to
> implement it at the same time.
> 
> This patch does the following:
> 
> - add new socket option level: SOL_SMC.
> - add new SMC socket option: SMC_AUTO_FALLBACK.
> - provide getter/setter for SMC socket options.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  include/linux/socket.h   |  1 +
>  include/uapi/linux/smc.h |  4 +++
>  net/smc/af_smc.c         | 69 +++++++++++++++++++++++++++++++++++++++++++++++-
>  net/smc/smc.h            |  1 +
>  4 files changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 8ef26d8..6f85f5d 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -366,6 +366,7 @@ struct ucred {
>  #define SOL_XDP		283
>  #define SOL_MPTCP	284
>  #define SOL_MCTP	285
> +#define SOL_SMC		286
>  
>  /* IPX options */
>  #define IPX_TYPE	1
> diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
> index 6c2874f..9f2cbf8 100644
> --- a/include/uapi/linux/smc.h
> +++ b/include/uapi/linux/smc.h
> @@ -284,4 +284,8 @@ enum {
>  	__SMC_NLA_SEID_TABLE_MAX,
>  	SMC_NLA_SEID_TABLE_MAX = __SMC_NLA_SEID_TABLE_MAX - 1
>  };
> +
> +/* SMC socket options */
> +#define SMC_AUTO_FALLBACK 1	/* allow auto fallback to TCP */

One idea: SMC_LIMIT_HS ?

> +
>  #endif /* _UAPI_LINUX_SMC_H */
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 8175f60..c313561 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2325,7 +2325,8 @@ static int smc_listen(struct socket *sock, int backlog)
>  
>  	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
>  
> -	tcp_sk(smc->clcsock->sk)->smc_in_limited = smc_is_in_limited;
> +	if (smc->auto_fallback)
> +		tcp_sk(smc->clcsock->sk)->smc_in_limited = smc_is_in_limited;
>  
>  	rc = kernel_listen(smc->clcsock, backlog);
>  	if (rc) {
> @@ -2620,6 +2621,67 @@ static int smc_shutdown(struct socket *sock, int how)
>  	return rc ? rc : rc1;
>  }
>  
> +static int __smc_getsockopt(struct socket *sock, int level, int optname,
> +			    char __user *optval, int __user *optlen)
> +{
> +	struct smc_sock *smc;
> +	int val, len;
> +
> +	smc = smc_sk(sock->sk);
> +
> +	if (get_user(len, optlen))
> +		return -EFAULT;
> +
> +	len = min_t(int, len, sizeof(int));
> +
> +	if (len < 0)
> +		return -EINVAL;
> +
> +	switch (optname) {
> +	case SMC_AUTO_FALLBACK:
> +		val = smc->auto_fallback;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (put_user(len, optlen))
> +		return -EFAULT;
> +	if (copy_to_user(optval, &val, len))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int __smc_setsockopt(struct socket *sock, int level, int optname,
> +			    sockptr_t optval, unsigned int optlen)
> +{
> +	struct sock *sk = sock->sk;
> +	struct smc_sock *smc;
> +	int val, rc;
> +
> +	smc = smc_sk(sk);
> +
> +	lock_sock(sk);
> +	switch (optname) {
> +	case SMC_AUTO_FALLBACK:
> +		if (optlen < sizeof(int))
> +			return -EINVAL;
> +		if (copy_from_sockptr(&val, optval, sizeof(int)))
> +			return -EFAULT;
> +
> +		smc->auto_fallback = !!val;
> +		rc = 0;
> +		break;
> +	default:
> +		rc = -EOPNOTSUPP;
> +		break;
> +	}
> +	release_sock(sk);
> +
> +	return rc;
> +}
> +
>  static int smc_setsockopt(struct socket *sock, int level, int optname,
>  			  sockptr_t optval, unsigned int optlen)
>  {
> @@ -2629,6 +2691,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
>  
>  	if (level == SOL_TCP && optname == TCP_ULP)
>  		return -EOPNOTSUPP;
> +	else if (level == SOL_SMC)
> +		return __smc_setsockopt(sock, level, optname, optval, optlen);
>  
>  	smc = smc_sk(sk);
>  
> @@ -2711,6 +2775,9 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
>  	struct smc_sock *smc;
>  	int rc;
>  
> +	if (level == SOL_SMC)
> +		return __smc_getsockopt(sock, level, optname, optval, optlen);
> +
>  	smc = smc_sk(sock->sk);
>  	mutex_lock(&smc->clcsock_release_lock);
>  	if (!smc->clcsock) {
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 5e5e38d..a0bdf75 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -249,6 +249,7 @@ struct smc_sock {				/* smc sock container */
>  	struct work_struct	smc_listen_work;/* prepare new accept socket */
>  	struct list_head	accept_q;	/* sockets to be accepted */
>  	spinlock_t		accept_q_lock;	/* protects accept_q */
> +	bool			auto_fallback;	/* auto fallabck to tcp */

New variable name: limit_smc_hs ?

>  	bool			use_fallback;	/* fallback to tcp */
>  	int			fallback_rsn;	/* reason for fallback */
>  	u32			peer_diagnosis; /* decline reason from peer */

-- 
Karsten

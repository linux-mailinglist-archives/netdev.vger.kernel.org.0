Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F86B1C93
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCIHnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCIHna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:43:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9F95CC36;
        Wed,  8 Mar 2023 23:43:28 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3296wT6A005862;
        Thu, 9 Mar 2023 07:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f+okypfrBhCMW0veWlscnPlBgHW1r50FsgwFvZXv0IE=;
 b=XRZrQPtTt8tAA4Wj6JZ96lykLMZch6ehMb03TeaLa961bIPwRzn6uJ3var7DxHehnTtQ
 iT4VjSyIZgLnNZxrgrdBXsj+y0nwqBOBZ2+yvtTNbJYKfu8F93MC63iwa6Te+L4XvD66
 E4udwAu9p6VwipQ7gqnRIS2FtTE/Rq0PAlHAtHe0vZ7v0641AUMSmEZaiqB52U3kMk5H
 9pbQRhHFprM2G906nvG0IegedhOepgclOBvO/5OKTa3mK05VggLQ/esO6o6pK4Y3vIqy
 Orw2A7sf0rRoUkaM/0x039LbG7pQY2W0yeduG4YdTcwA00/5FZ2ZThezH+02LIj57FHE Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6pmxvvv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 07:43:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3297bD18012632;
        Thu, 9 Mar 2023 07:43:18 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6pmxvvuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 07:43:18 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3297b5ul016624;
        Thu, 9 Mar 2023 07:43:16 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3p6fhk809v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 07:43:16 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3297hEsO28443184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Mar 2023 07:43:15 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86BC258056;
        Thu,  9 Mar 2023 07:43:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03AC058052;
        Thu,  9 Mar 2023 07:43:13 +0000 (GMT)
Received: from [9.211.95.207] (unknown [9.211.95.207])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Mar 2023 07:43:12 +0000 (GMT)
Message-ID: <7f72fe0d-8385-0fae-070c-81507e4e9cb9@linux.ibm.com>
Date:   Thu, 9 Mar 2023 08:43:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net v2] net/smc: fix fallback failed while sendmsg with
 fastopen
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, simon.horman@corigine.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1678159426-72671-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1678159426-72671-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9ZK7k3nFnJBQhtq5iFRF29_ow9DdKpdb
X-Proofpoint-ORIG-GUID: 44Ttx19KAb1xUfgc_tCzllbkuUyPkF-4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_04,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.03.23 04:23, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Before determining whether the msg has unsupported options, it has been
> prematurely terminated by the wrong status check.
> 
> For the application, the general usages of MSG_FASTOPEN likes
> 
> fd = socket(...)
> /* rather than connect */
> sendto(fd, data, len, MSG_FASTOPEN)
> 
> Hence, We need to check the flag before state check, because the sock
> state here is always SMC_INIT when applications tries MSG_FASTOPEN.
> Once we found unsupported options, fallback it to TCP.
> 
> Fixes: ee9dfbef02d1 ("net/smc: handle sockopts forcing fallback")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 

Thanks for the fix!

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

> v2 -> v1: Optimize code style
> 
> ---
>   net/smc/af_smc.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index b233c94..1c580ac 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2659,16 +2659,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>   {
>   	struct sock *sk = sock->sk;
>   	struct smc_sock *smc;
> -	int rc = -EPIPE;
> +	int rc;
>   
>   	smc = smc_sk(sk);
>   	lock_sock(sk);
> -	if ((sk->sk_state != SMC_ACTIVE) &&
> -	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
> -	    (sk->sk_state != SMC_INIT))
> -		goto out;
>   
> +	/* SMC does not support connect with fastopen */
>   	if (msg->msg_flags & MSG_FASTOPEN) {
> +		/* not connected yet, fallback */
>   		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
>   			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
>   			if (rc)
> @@ -2677,6 +2675,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>   			rc = -EINVAL;
>   			goto out;
>   		}
> +	} else if ((sk->sk_state != SMC_ACTIVE) &&
> +		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
> +		   (sk->sk_state != SMC_INIT)) {
> +		rc = -EPIPE;
> +		goto out;
>   	}
>   
>   	if (smc->use_fallback) {

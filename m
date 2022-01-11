Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A348AAFE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 11:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiAKKED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 05:04:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234586AbiAKKEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 05:04:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B7cKTm015944;
        Tue, 11 Jan 2022 10:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5EBX0iufaeuC20EJe3BZZ7yAWIAZFPQsNZo3cADR32c=;
 b=NnouLr/FKt3FvOZQidKTVYXvIDD9p9JfAfe4ghZFC9qHUoadfZ8OqD76OIwIExuRtilw
 iorsEO5A3vbtmYoFW/NwNOdFVEyFCPoWBlh7MGwyN3MfhE9q79BsGwzDKJ0klZCEtL96
 agnt2wJf1ImBSzl1LnPcv88Z3sdVYvBhOr91hzpjTJculWTVtIOyx/lAp16ZB0IpHsfp
 /8hlXWfMn09X8OmWC2bCBfy6Ohpr95NaMXk31UYOJEDlct/Dr1kl6FAqJShLeDKntHiZ
 lIsrAqx1lPtHtBb7Vfnw20rJrT7m610gDG0djo8pjbPA8mskjtk8pd1sPzDlt7zdKuij Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh1b4r94g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 10:03:59 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20B9m8CV024690;
        Tue, 11 Jan 2022 10:03:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh1b4r93e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 10:03:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20B9xuUx028812;
        Tue, 11 Jan 2022 10:03:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vhw7n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 10:03:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BA3sXj47644964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 10:03:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F03474C04E;
        Tue, 11 Jan 2022 10:03:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A91304C05A;
        Tue, 11 Jan 2022 10:03:53 +0000 (GMT)
Received: from [9.145.30.70] (unknown [9.145.30.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 10:03:53 +0000 (GMT)
Message-ID: <ac977743-9696-9723-5682-97ebbcca6828@linux.ibm.com>
Date:   Tue, 11 Jan 2022 11:03:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o4NAAuT755QcREWKbu0Yr3z7sP43NDTm
X-Proofpoint-ORIG-GUID: lIp-rD-vBVU1p0y6TsXscFJqGOD0SsPx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_03,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 spamscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2022 10:38, Wen Gu wrote:
> We encountered a crash in smc_setsockopt() and it is caused by
> accessing smc->clcsock after clcsock was released.
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000020
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] PREEMPT SMP PTI
>  CPU: 1 PID: 50309 Comm: nginx Kdump: loaded Tainted: G E     5.16.0-rc4+ #53
>  RIP: 0010:smc_setsockopt+0x59/0x280 [smc]
>  Call Trace:
>   <TASK>
>   __sys_setsockopt+0xfc/0x190
>   __x64_sys_setsockopt+0x20/0x30
>   do_syscall_64+0x34/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7f16ba83918e
>   </TASK>
> 
> This patch tries to fix it by holding clcsock_release_lock and
> checking whether clcsock has already been released. In case that
> a crash of the same reason happens in smc_getsockopt(), this patch
> also checkes smc->clcsock in smc_getsockopt().
> 
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>  net/smc/af_smc.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 1c9289f..af423f4 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2441,6 +2441,11 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
>  	/* generic setsockopts reaching us here always apply to the
>  	 * CLC socket
>  	 */
> +	mutex_lock(&smc->clcsock_release_lock);
> +	if (!smc->clcsock) {
> +		mutex_unlock(&smc->clcsock_release_lock);
> +		return -EBADF;
> +	}
>  	if (unlikely(!smc->clcsock->ops->setsockopt))
>  		rc = -EOPNOTSUPP;
>  	else
> @@ -2450,6 +2455,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
>  		sk->sk_err = smc->clcsock->sk->sk_err;
>  		sk_error_report(sk);
>  	}
> +	mutex_unlock(&smc->clcsock_release_lock);

In the switch() the function smc_switch_to_fallback() might be called which also
accesses smc->clcsock without further checking. This should also be protected then?
Also from all callers of smc_switch_to_fallback() ?

There are more uses of smc->clcsock (e.g. smc_bind(), ...), so why does this problem 
happen in setsockopt() for you only? I suspect it depends on the test case.

I wonder if it makes sense to check and protect smc->clcsock at all places in the code where 
it is used... as of now we had no such races like you encountered. But I see that in theory 
this problem could also happen in other code areas.

>  
>  	if (optlen < sizeof(int))
>  		return -EINVAL;
> @@ -2509,13 +2515,21 @@ static int smc_getsockopt(struct socket *sock, int level, int optname,
>  			  char __user *optval, int __user *optlen)
>  {
>  	struct smc_sock *smc;
> +	int rc;
>  
>  	smc = smc_sk(sock->sk);
> +	mutex_lock(&smc->clcsock_release_lock);
> +	if (!smc->clcsock) {
> +		mutex_unlock(&smc->clcsock_release_lock);
> +		return -EBADF;
> +	}
>  	/* socket options apply to the CLC socket */
>  	if (unlikely(!smc->clcsock->ops->getsockopt))
>  		return -EOPNOTSUPP;
> -	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
> +	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
>  					     optval, optlen);
> +	mutex_unlock(&smc->clcsock_release_lock);
> +	return rc;
>  }
>  
>  static int smc_ioctl(struct socket *sock, unsigned int cmd,

-- 
Karsten

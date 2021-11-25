Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9D45D8BD
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 12:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhKYLHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 06:07:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14434 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238625AbhKYLFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 06:05:24 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AP9GnH4031295;
        Thu, 25 Nov 2021 11:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZDNHfmrIvKRHlBA/ZKTskcwekbGibMhbIs8GDRBBrFw=;
 b=aUuGGY8claDcn7YEcnfgeQ3zplCngMNRW7Uc3G5XinILSpd20696ST36y+k1xvSPBzT9
 QOXpGIHl8I0XQBCOvdfedORSfONuvm5X6rPQ7LsB1qxJeuSoXzvsdx7kSIEV6uH115nL
 ogB1N25/hgiZVCnoj2Ac/M1UGm3UiUBp8rb3kgR1Hy7plxx0jGia9Thf9qgLb/S1Wtmh
 UcJ/cJrCCHVDx3/6xFvvt9HEz4M6hEGdRWMF1nLOPUgUYyPVBGfOaqEVNx97UkYmuvMd
 sYUqwm0DTgXFuJRLMxCK1KsBVU0nLVEggylGMOTfpTmJxK4PY/Vzseq/cHoLHpudRPdi GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cj7qesygx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 11:02:10 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1APAjR3I004732;
        Thu, 25 Nov 2021 11:02:09 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cj7qesyg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 11:02:09 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1APAwYAv011406;
        Thu, 25 Nov 2021 11:02:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3cerna8c3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 11:02:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1APB25Bo56623614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 11:02:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2C184C064;
        Thu, 25 Nov 2021 11:02:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DFD94C058;
        Thu, 25 Nov 2021 11:02:04 +0000 (GMT)
Received: from [9.145.172.86] (unknown [9.145.172.86])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Nov 2021 11:02:04 +0000 (GMT)
Message-ID: <77c1be59-5e55-80f1-4fc6-16fb65846b7e@linux.ibm.com>
Date:   Thu, 25 Nov 2021 12:02:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net 2/2] net/smc: Don't call clcsock shutdown twice when
 smc shutdown
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211125061932.74874-1-tonylu@linux.alibaba.com>
 <20211125061932.74874-3-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211125061932.74874-3-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LanQC8F2OkSSDAiklfTs_icZ8c12_hDj
X-Proofpoint-ORIG-GUID: iqfOJxtPAoE_D0n1nefovhUQpAnDZwEn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_04,2021-11-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111250061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2021 07:19, Tony Lu wrote:
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 4b62c925a13e..7b04cb4d15f4 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2373,6 +2373,7 @@ static int smc_shutdown(struct socket *sock, int how)
>  	struct smc_sock *smc;
>  	int rc = -EINVAL;
>  	int rc1 = 0;
> +	int old_state;

Reverse Christmas tree formatting, please.

>  
>  	smc = smc_sk(sk);
>  
> @@ -2398,7 +2399,12 @@ static int smc_shutdown(struct socket *sock, int how)
>  	}
>  	switch (how) {
>  	case SHUT_RDWR:		/* shutdown in both directions */
> +		old_state = sk->sk_state;
>  		rc = smc_close_active(smc);
> +		if (old_state == SMC_ACTIVE &&
> +		    sk->sk_state == SMC_PEERCLOSEWAIT1)
> +			goto out_no_shutdown;
> +

I would prefer a new "bool do_shutdown" instead of a goto for this skip
of the shutdown. What do you think?

>  		break;
>  	case SHUT_WR:
>  		rc = smc_close_shutdown_write(smc);
> @@ -2410,6 +2416,8 @@ static int smc_shutdown(struct socket *sock, int how)
>  	}
>  	if (smc->clcsock)
>  		rc1 = kernel_sock_shutdown(smc->clcsock, how);
> +
> +out_no_shutdown:
>  	/* map sock_shutdown_cmd constants to sk_shutdown value range */
>  	sk->sk_shutdown |= how + 1;
>  
> 

-- 
Karsten

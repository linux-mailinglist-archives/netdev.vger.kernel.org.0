Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00AD3AF13D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhFURFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231182AbhFURFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:08 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LGXdmU068889;
        Mon, 21 Jun 2021 13:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ck4zrruLN6Q+BRtf9tzSXqr9rmK0Z63cbgwIx55ZHMo=;
 b=EnvEaTZn47OU9iO2JGhXrEhjlVH68fGraUezLiB51t6XBLOBD4DiawcZSXQyoKQMiVAR
 O33EmiJOzNYLAH0IKyqekPrNop3iK8yQF+a70sJmvZ1YaafiTnCPKfgopSoF9g3oLMWr
 nJhjPczCWNHHvZWdKjYCIH+nRFhgYa1tL7Wau0jLtFvJacM4WhTYxtWYNI8PACXfFzJl
 O/jXS3MfpsgR0cfvqLydwFMLTB35EihT+3/h7bH5WLR40kzdDfJJ5QkoYdUuStkAxYY2
 fit7Jtgwgi7eNJCh4qe8WGls6+7DrOByGkCq3BecAoX/Z+3+qePBV1is1xdcusKgfgy5 Lw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39avw740u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 13:02:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LH2dU3006246;
        Mon, 21 Jun 2021 17:02:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 39987951ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 17:02:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LH2koo8192850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 17:02:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B8A928058;
        Mon, 21 Jun 2021 17:02:46 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5074C2805C;
        Mon, 21 Jun 2021 17:02:45 +0000 (GMT)
Received: from [9.171.11.231] (unknown [9.171.11.231])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Jun 2021 17:02:45 +0000 (GMT)
Subject: Re: [PATCH net-next] net/smc: Fix ENODATA tests in
 smc_nl_get_fback_stats()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YM32HV7psa+PrmbV@mwanda>
From:   Guvenc Gulce <guvenc@linux.ibm.com>
Message-ID: <b3ba0dfa-6367-8e75-6348-f78e1cb7c7e1@linux.ibm.com>
Date:   Mon, 21 Jun 2021 19:02:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YM32HV7psa+PrmbV@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -dCY8FVOsiesYUhlt5CHYApnLmIcwxOd
X-Proofpoint-GUID: -dCY8FVOsiesYUhlt5CHYApnLmIcwxOd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 spamscore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106210097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/06/2021 15:50, Dan Carpenter wrote:
> These functions return negative ENODATA but the minus sign was left out
> in the tests.
>
> Fixes: f0dd7bf5e330 ("net/smc: Add netlink support for SMC fallback statistics")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   net/smc/smc_stats.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
> index 614013e3b574..e80e34f7ac15 100644
> --- a/net/smc/smc_stats.c
> +++ b/net/smc/smc_stats.c
> @@ -393,17 +393,17 @@ int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb)
>   			continue;
>   		if (!skip_serv) {
>   			rc_srv = smc_nl_get_fback_details(skb, cb, k, is_srv);
> -			if (rc_srv && rc_srv != ENODATA)
> +			if (rc_srv && rc_srv != -ENODATA)
>   				break;
>   		} else {
>   			skip_serv = 0;
>   		}
>   		rc_clnt = smc_nl_get_fback_details(skb, cb, k, !is_srv);
> -		if (rc_clnt && rc_clnt != ENODATA) {
> +		if (rc_clnt && rc_clnt != -ENODATA) {
>   			skip_serv = 1;
>   			break;
>   		}
> -		if (rc_clnt == ENODATA && rc_srv == ENODATA)
> +		if (rc_clnt == -ENODATA && rc_srv == -ENODATA)
>   			break;
>   	}
>   	mutex_unlock(&net->smc.mutex_fback_rsn);

Acked-by: Guvenc Gulce <guvenc@linux.ibm.com>

Thanks for preparing the fix.

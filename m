Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED7D32E671
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 11:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCEKa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 05:30:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229690AbhCEKa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 05:30:26 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125ATGfM002168;
        Fri, 5 Mar 2021 05:30:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4UbJnKh/rNouiIUUWZr3ZpULnYtu8wIcqi44QhFm7VQ=;
 b=cIManWSHycp6SdCZ1FadOLerR/MlP2K2WmPMGZqOEPQdpBCRT4vz3I9I+BZ48RZqdqls
 H8Tn11W9vC3fxm4ZMQgLzsMtb2G0EAlutXhwOxq51CBEF0sLuBEAqUFKTUYOU2PpXmDJ
 zG0f0m45HbwfCDk2yOHlmV1qv3r1S/A2MxAwUMZC7dCcq+ZWpClqDJ5ZUn8as8t8GkRe
 horv+n3OlO8e/dTrmRHxkotO9wADDUBlw1PoBPJGhn66hPW9vqKwC6qXPoSwdiG/MET+
 HQqrwFkDzIwoA+luD+7jxK4loDdtcgL5JTyM9Qop/uQWqeJn5g24oslKGaaNrzS2jwrK 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373jxdr13u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 05:30:24 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 125AUMqv012206;
        Fri, 5 Mar 2021 05:30:23 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373jxdr12e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 05:30:22 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 125AREnQ002959;
        Fri, 5 Mar 2021 10:30:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 37293fswbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 10:30:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 125AUIdc37683680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 10:30:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE74CA406F;
        Fri,  5 Mar 2021 10:30:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94C70A4053;
        Fri,  5 Mar 2021 10:30:17 +0000 (GMT)
Received: from [9.171.51.82] (unknown [9.171.51.82])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 10:30:17 +0000 (GMT)
Subject: Re: [PATCH] net: smc: fix error return code of smc_diag_dump_proto()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210305101351.14683-1-baijiaju1990@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <d1d50e39-e496-1060-2c71-2338c0572c55@linux.ibm.com>
Date:   Fri, 5 Mar 2021 11:30:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210305101351.14683-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_05:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2021 11:13, Jia-Ju Bai wrote:
> When the list of head is empty, no error return code of
> smc_diag_dump_proto() is assigned.
> To fix this bug, rc is assigned with -ENOENT as error return code.

Your change would break smc_diag_dump().
When there are no IPv4 sockets (SMCPROTO_SMC) in the list and -ENOENT 
is returned then smc_diag_dump() will not try to dump any IPv6 sockets
(SMCPROTO_SMC6). Returning zero is correct here.

> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/smc/smc_diag.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index c952986a6aca..a90889482842 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -201,8 +201,10 @@ static int smc_diag_dump_proto(struct proto *prot, struct sk_buff *skb,
>  
>  	read_lock(&prot->h.smc_hash->lock);
>  	head = &prot->h.smc_hash->ht;
> -	if (hlist_empty(head))
> +	if (hlist_empty(head)) {
> +		rc = -ENOENT;
>  		goto out;
> +	}
>  
>  	sk_for_each(sk, head) {
>  		if (!net_eq(sock_net(sk), net))
> 

-- 
Karsten

(I'm a dude)

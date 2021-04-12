Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45DB35BA56
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhDLGwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:52:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236591AbhDLGwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 02:52:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13C6YL3D029524;
        Mon, 12 Apr 2021 02:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hs+80Rrx3QSwoANWmAh8yIGN+d1ZBv6+ntO6ZN7RfjU=;
 b=enEnTn3+0L8hyjcGuA7syQTVcgbozH8763hhRRmB+otj/yPH+mcImdr0OllwqUkpfVzI
 MoZNuFykiN6IWyez5jSmR3eBUGUskjok5TJF9IeX/Zah9Oq16tzWkB9/lsXpKHQC6FCq
 /5BjaUtFPEpgHQQHVYHbP9D/m0jNECkEu99GTSZL8nHn+jQHKpFeeqH4G911F1CtSk9d
 jqVK8sQawLpBeFQLSeCmapglTrtk/RTraeYgk6+H1gqYM6UZAYCqB/9OLlPfl97bsv+u
 xy+chRlvQjm3Bb/1jGJj7/Bh5GLF1SIH28DpDy4yNQM0XCWu/zAJM1lxU78gmcVAwEkz PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ushvf3k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 02:52:05 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13C6ZKH7032850;
        Mon, 12 Apr 2021 02:52:05 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ushvf3jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 02:52:05 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13C6m8Ld006970;
        Mon, 12 Apr 2021 06:52:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 37u3n88td7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 06:52:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13C6q02j43647368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 06:52:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CA1BAE053;
        Mon, 12 Apr 2021 06:52:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C900AAE045;
        Mon, 12 Apr 2021 06:51:59 +0000 (GMT)
Received: from [9.171.87.9] (unknown [9.171.87.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 06:51:59 +0000 (GMT)
Subject: Re: [Patch net] smc: disallow TCP_ULP in smc_setsockopt()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>
References: <20210410181732.25995-1-xiyou.wangcong@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <f273fcd6-05e2-68d4-56e3-31cd228fab23@linux.ibm.com>
Date:   Mon, 12 Apr 2021 08:52:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210410181732.25995-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZucfamJoAzpgreVHHi3vYlmH8iBdrjeM
X-Proofpoint-ORIG-GUID: OS5lB1eGu93IlAT-q6hQ3LKfqDl524-m
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_04:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 mlxscore=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/04/2021 20:17, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> syzbot is able to setup kTLS on an SMC socket, which coincidentally
> uses sk_user_data too, later, kTLS treats it as psock so triggers a
> refcnt warning. The cause is that smc_setsockopt() simply calls
> TCP setsockopt(). I do not think it makes sense to setup kTLS on
> top of SMC, so we can just disallow this.
> 
> Reported-and-tested-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/smc/af_smc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 47340b3b514f..0d4d6d28f20c 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2162,6 +2162,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
>  	struct smc_sock *smc;
>  	int val, rc;
>  
> +	if (optname == TCP_ULP)
> +		return -EOPNOTSUPP;
> +
>  	smc = smc_sk(sk);
>  
>  	/* generic setsockopts reaching us here always apply to the
> @@ -2186,7 +2189,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
>  	if (rc || smc->use_fallback)
>  		goto out;
>  	switch (optname) {
> -	case TCP_ULP:

Should'nt it return -EOPNOTSUPP in that case, too?

>  	case TCP_FASTOPEN:
>  	case TCP_FASTOPEN_CONNECT:
>  	case TCP_FASTOPEN_KEY:
> 

-- 
Karsten

(I'm a dude)

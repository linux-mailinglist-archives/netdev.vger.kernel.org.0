Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D955E823B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 21:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiIWTBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIWTBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 15:01:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFC711C16E;
        Fri, 23 Sep 2022 12:01:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NHUNPa011217;
        Fri, 23 Sep 2022 19:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=FEmSAHpnGZZKPEHAy8wKFDjqwBbkabkHr/RfCgrZI5Q=;
 b=JbllU5j8LSZTV4E0jhztoGbI8Dshru3FDspozyZLDcyOBr7wMgZeUGWenxll+4qkIsCh
 LUJ9dennOlSBdxVIn6uyE898iVvrv3gW3QcEXnOMCesvFOz/zXQPTvdEAf3Q9ea/oWoF
 OjPZtwT0iffoa7EhWwy3WE/sPQ+YqecM6MjDSgIqWzf/iRkblrDdZ9VwBqNSFMgQ1ykD
 MOI2Q/MqZDdrI6CtlAzYdjNH7XxqvYqcPRQYPKj8WjVo7ZbONqQRZPaYlcHla88M2bEF
 GMiZH2wSDelSH8nWZ1ApoD0+lC+F2EiJ9rJjBCUn7n/WI688N0rQfR7JzjNDWSofBReC Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsau7wcxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 19:00:21 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NHsR5X029455;
        Fri, 23 Sep 2022 19:00:21 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsau7wcw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 19:00:20 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NIo5oJ015035;
        Fri, 23 Sep 2022 19:00:19 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 3jn5va1jdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 19:00:19 +0000
Received: from smtpav05.wdc07v.mail.ibm.com ([9.208.128.117])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NJ0I1O7078588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 19:00:19 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BDC958068;
        Fri, 23 Sep 2022 19:00:18 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C7295805D;
        Fri, 23 Sep 2022 19:00:16 +0000 (GMT)
Received: from [9.163.12.13] (unknown [9.163.12.13])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 19:00:16 +0000 (GMT)
Message-ID: <1e57129a-f937-b77d-795b-d0ba05ba17be@linux.ibm.com>
Date:   Fri, 23 Sep 2022 21:00:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH net-next] net/smc: Support SO_REUSEPORT
To:     Tony Lu <tonylu@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220922121906.72406-1-tonylu@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20220922121906.72406-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SOXLTJPZY7Kyn8L4L6QfYVfZ7ctvR51y
X-Proofpoint-ORIG-GUID: Tvob0PTbBengd4xsqA8Sw73iEiohWYjN
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209230120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.09.22 14:19, Tony Lu wrote:
> This enables SO_REUSEPORT [1] for clcsock when it is set on smc socket,
> so that some applications which uses it can be transparently replaced
> with SMC. Also, this helps improve load distribution.
> 
> Here is a simple test of NGINX + wrk with SMC. The CPU usage is collected
> on NGINX (server) side as below.
> 
> Disable SO_REUSEPORT:
> 
> 05:15:33 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 05:15:34 PM  all    7.02    0.00   11.86    0.00    2.04    8.93    0.00    0.00    0.00   70.15
> 05:15:34 PM    0    0.00    0.00    0.00    0.00   16.00   70.00    0.00    0.00    0.00   14.00
> 05:15:34 PM    1   11.58    0.00   22.11    0.00    0.00    0.00    0.00    0.00    0.00   66.32
> 05:15:34 PM    2    1.00    0.00    1.00    0.00    0.00    0.00    0.00    0.00    0.00   98.00
> 05:15:34 PM    3   16.84    0.00   30.53    0.00    0.00    0.00    0.00    0.00    0.00   52.63
> 05:15:34 PM    4   28.72    0.00   44.68    0.00    0.00    0.00    0.00    0.00    0.00   26.60
> 05:15:34 PM    5    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 05:15:34 PM    6    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 05:15:34 PM    7    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 
> Enable SO_REUSEPORT:
> 
> 05:15:20 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 05:15:21 PM  all    8.56    0.00   14.40    0.00    2.20    9.86    0.00    0.00    0.00   64.98
> 05:15:21 PM    0    0.00    0.00    4.08    0.00   14.29   76.53    0.00    0.00    0.00    5.10
> 05:15:21 PM    1    9.09    0.00   16.16    0.00    1.01    0.00    0.00    0.00    0.00   73.74
> 05:15:21 PM    2    9.38    0.00   16.67    0.00    1.04    0.00    0.00    0.00    0.00   72.92
> 05:15:21 PM    3   10.42    0.00   17.71    0.00    1.04    0.00    0.00    0.00    0.00   70.83
> 05:15:21 PM    4    9.57    0.00   15.96    0.00    0.00    0.00    0.00    0.00    0.00   74.47
> 05:15:21 PM    5    9.18    0.00   15.31    0.00    0.00    1.02    0.00    0.00    0.00   74.49
> 05:15:21 PM    6    8.60    0.00   15.05    0.00    0.00    0.00    0.00    0.00    0.00   76.34
> 05:15:21 PM    7   12.37    0.00   14.43    0.00    0.00    0.00    0.00    0.00    0.00   73.20
> 
> Using SO_REUSEPORT helps the load distribution of NGINX be more
> balanced.
> 
> [1] https://man7.org/linux/man-pages/man7/socket.7.html
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>   net/smc/af_smc.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 0939cc3b915a..d933a804c94b 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -427,6 +427,7 @@ static int smc_bind(struct socket *sock, struct sockaddr *uaddr,
>   		goto out_rel;
>   
>   	smc->clcsock->sk->sk_reuse = sk->sk_reuse;
> +	smc->clcsock->sk->sk_reuseport = sk->sk_reuseport;
>   	rc = kernel_bind(smc->clcsock, uaddr, addr_len);
>   
>   out_rel:

It looks good to me. Thank you!

Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>

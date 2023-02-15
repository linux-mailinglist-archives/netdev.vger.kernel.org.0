Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D076978FC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbjBOJ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbjBOJ2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:28:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0C3756D;
        Wed, 15 Feb 2023 01:28:11 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31F9QHts030084;
        Wed, 15 Feb 2023 09:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KtrD5MzuKc+1zQ4PbqZJg2u9nWvwjF3DPSp+E8uKgzw=;
 b=Ota31XnjbdKJ+TogdU3X/8ne65t+zLWMNEJ8I18RpGydlpNcm26kAsO1THgPv+THrfMc
 5GtmG5dXymkL9fKYNt6RwYKEUQRuhL0Yo31+ByMD97jFVDwdFSntba5XvC7Ox5P+pW/k
 UqMRP2le156ZB0jra7m8twX61IyTudp3uchfHKQr4RZ5MkCZJIETqQiNvoND7u680kMh
 qAzZ7VM6VbYJzTRzeq5IBR4SPVDh4xi2vF8XYHFEdCT5qRurJaT2YU0iBVugycS97b7f
 +R8jFMohyMhRLC8pLxQhutNxoS5TFMhDiA+qOdr+Lvtzbfp7Vlr4+xBCMbWEpvOL++xi Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrvrwr0yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 09:28:02 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31F9S14W005194;
        Wed, 15 Feb 2023 09:28:01 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrvrwr0yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 09:28:01 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31F7Y3Ap000883;
        Wed, 15 Feb 2023 09:28:00 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3np2n7h391-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 09:28:00 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31F9Rw4G36373128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 09:27:58 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F9025804E;
        Wed, 15 Feb 2023 09:27:58 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8DAD5803F;
        Wed, 15 Feb 2023 09:27:56 +0000 (GMT)
Received: from [9.211.88.109] (unknown [9.211.88.109])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 09:27:56 +0000 (GMT)
Message-ID: <ca058775-5fa2-e770-ef32-588bcb84ac6e@linux.ibm.com>
Date:   Wed, 15 Feb 2023 10:27:55 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net] net/smc: fix application data exception
To:     "D.Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669450950-27681-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1669450950-27681-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XXq6rq6IZce_4k7pOrl_nQv-ib0G2ZVr
X-Proofpoint-ORIG-GUID: N8dsmhw7uf8nBi2Py5czWTpiPtrMHxaX
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_05,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150077
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.11.22 09:22, D.Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> There is a certain probability that following
> exceptions will occur in the wrk benchmark test:
> 
> Running 10s test @ http://11.213.45.6:80
>    8 threads and 64 connections
>    Thread Stats   Avg      Stdev     Max   +/- Stdev
>      Latency     3.72ms   13.94ms 245.33ms   94.17%
>      Req/Sec     1.96k   713.67     5.41k    75.16%
>    155262 requests in 10.10s, 23.10MB read
> Non-2xx or 3xx responses: 3
> 
> We will find that the error is HTTP 400 error, which is a serious
> exception in our test, which means the application data was
> corrupted.
> 
> Consider the following scenarios:
> 
> CPU0                            CPU1
> 
> buf_desc->used = 0;
>                                  cmpxchg(buf_desc->used, 0, 1)
>                                  deal_with(buf_desc)
> 
> memset(buf_desc->cpu_addr,0);
> 
> This will cause the data received by a victim connection to be cleared,
> thus triggering an HTTP 400 error in the server.
> 
> This patch exchange the order between clear used and memset, add
> barrier to ensure memory consistency.
> 
> Fixes: 1c5526968e27 ("net/smc: Clear memory when release and reuse buffer")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   net/smc/smc_core.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index c305d8d..c19d4b7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1120,8 +1120,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
>   
>   		smc_buf_free(lgr, is_rmb, buf_desc);
>   	} else {
> -		buf_desc->used = 0;
> -		memset(buf_desc->cpu_addr, 0, buf_desc->len);
> +		/* memzero_explicit provides potential memory barrier semantics */
> +		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
> +		WRITE_ONCE(buf_desc->used, 0);
>   	}
>   }
>   
> @@ -1132,19 +1133,17 @@ static void smc_buf_unuse(struct smc_connection *conn,
>   		if (!lgr->is_smcd && conn->sndbuf_desc->is_vm) {
>   			smcr_buf_unuse(conn->sndbuf_desc, false, lgr);
>   		} else {
> -			conn->sndbuf_desc->used = 0;
> -			memset(conn->sndbuf_desc->cpu_addr, 0,
> -			       conn->sndbuf_desc->len);
> +			memzero_explicit(conn->sndbuf_desc->cpu_addr, conn->sndbuf_desc->len);
> +			WRITE_ONCE(conn->sndbuf_desc->used, 0);
>   		}
>   	}
>   	if (conn->rmb_desc) {
>   		if (!lgr->is_smcd) {
>   			smcr_buf_unuse(conn->rmb_desc, true, lgr);
>   		} else {
> -			conn->rmb_desc->used = 0;
> -			memset(conn->rmb_desc->cpu_addr, 0,
> -			       conn->rmb_desc->len +
> -			       sizeof(struct smcd_cdc_msg));
> +			memzero_explicit(conn->rmb_desc->cpu_addr,
> +					 conn->rmb_desc->len + sizeof(struct smcd_cdc_msg));
> +			WRITE_ONCE(conn->rmb_desc->used, 0);
>   		}
>   	}
>   }

Hi David,

Thank you for remembering me again about this patch. I did forget to 
answer you, sorry!

My consideration was if memzero_explicit() is necessary in this case. 
But sure, it makes sense, especiall when the dereferencing is in 
somewhere else.

Thank you for the fix!

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34326699644
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjBPNtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPNtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:49:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4898E39BBE;
        Thu, 16 Feb 2023 05:49:31 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GDP3eP000633;
        Thu, 16 Feb 2023 13:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=o9ifNvZeq5Hmh6hCJQ12e1ll1uFMGZJMBoeN7Fx7EbU=;
 b=i2GyNPJ7AuHmdRUsjkpJ7GXNN5oPZx5z7V9sa5hmexGqLdc/0F8N8VR8FL/XRQUlevRm
 lfxhUkUMxwyNvaw3KeiSwNsbyF26cPCsN67N20Mjj1dHmqsG/75reQqSBBA1nncqE5vp
 tgKk9p5+4g4aebsYnZdnWc+qbOHrrs8LAUTHc3JyJ5b2GZJA0xLH/MKz/QqTmDqrZxws
 NfYY85Uj6saZQT5sDx41knAGAHUUXcC2Heg4SDnQVbC37IKTtNaIoGY2rESYO+LHQ26V
 89Zglq/piFRyXONq/dNN2FBE14X0wVQ8dcPc06bnRdEK39CeA6JKiEhcsWJOCu5OAqFp EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nskd8kmd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 13:49:21 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GCUJ43017331;
        Thu, 16 Feb 2023 13:49:21 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nskd8kmcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 13:49:20 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31GCPfbJ020647;
        Thu, 16 Feb 2023 13:49:19 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3np2n7ar1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 13:49:19 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GDnH4N25166248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 13:49:18 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A204658055;
        Thu, 16 Feb 2023 13:49:17 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A7C75805E;
        Thu, 16 Feb 2023 13:49:16 +0000 (GMT)
Received: from [9.211.88.109] (unknown [9.211.88.109])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 13:49:15 +0000 (GMT)
Message-ID: <1b7c95be-d3d9-53c3-3152-cd835314d37c@linux.ibm.com>
Date:   Thu, 16 Feb 2023 14:49:15 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net v2] net/smc: fix application data exception
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1676529545-32741-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1676529545-32741-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0eYrr9OCv4_xy2wwfiGNOLZIRWHxU8Gu
X-Proofpoint-ORIG-GUID: alCmkdmknF4vh2rYTR5sZBPaZXXsTdxw
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_10,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160116
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.02.23 07:39, D. Wythe wrote:
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
> v2: rebase it with latest net tree.
> 

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

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



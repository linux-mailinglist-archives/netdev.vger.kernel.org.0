Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386A66B1C8D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCIHmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCIHml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:42:41 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DB8D23BF;
        Wed,  8 Mar 2023 23:42:40 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3296GsNW021127;
        Thu, 9 Mar 2023 07:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RoC+uC7saLpOIXp3icf+Szui9QrpVF5FNTNBBrnLy/w=;
 b=bTPGXh91b+jZft1LIhi9giAlDHM6mG/ZMCNMhMAyfl7qfmVDjwvDlnc8lELz7uJmktNs
 2Z7NIfGJhspo/QsSE+55WFdjot9/O/DcJ2DCUvmEukzfc7U5/49loVxCXAYRpoBnn+mY
 STWMaqlikDqN5ke49HBmbAoPFISoiwTr4/C/rf6BXBNc4TCvlOSJxT0OgzvX8xV3TDbt
 cbKaPiZ1oRgllcvkuy+Fqc29Tjjk/VB8VQc0Vos81S9Rhf5/NxzLmciWBtxpn24Kjr/y
 jyMdDuhx53ZP/SVTg9jO3k66cLX2Zsr2i0wyVWZqhwR2FRay0GAPKNYCUETPbCJo8TJN wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6suksssk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 07:42:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3297gRHw033166;
        Thu, 9 Mar 2023 07:42:27 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6suksss8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 07:42:27 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3297MgAg011849;
        Thu, 9 Mar 2023 07:42:26 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3p6gbv9pvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Mar 2023 07:42:26 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3297gOtP27460116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Mar 2023 07:42:24 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 565AA58062;
        Thu,  9 Mar 2023 07:42:24 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE07158056;
        Thu,  9 Mar 2023 07:42:22 +0000 (GMT)
Received: from [9.211.95.207] (unknown [9.211.95.207])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Mar 2023 07:42:22 +0000 (GMT)
Message-ID: <a25e7463-6998-03c0-01c8-4b5ec98a1cc9@linux.ibm.com>
Date:   Thu, 9 Mar 2023 08:42:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net v2] net/smc: fix NULL sndbuf_desc in
 smc_cdc_tx_handler()
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1678263432-17329-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1678263432-17329-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WHvSgYz6Ob9qDWXanNUrnVuHk5dKhgwR
X-Proofpoint-ORIG-GUID: COdodf5lJpnDLBB3t0aEQs6RG3uGH18l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_04,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.03.23 09:17, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> When performing a stress test on SMC-R by rmmod mlx5_ib driver
> during the wrk/nginx test, we found that there is a probability
> of triggering a panic while terminating all link groups.
> 
> This issue dues to the race between smc_smcr_terminate_all()
> and smc_buf_create().
> 
> 			smc_smcr_terminate_all
> 
> smc_buf_create
> /* init */
> conn->sndbuf_desc = NULL;
> ...
> 
> 			__smc_lgr_terminate
> 				smc_conn_kill
> 					smc_close_abort
> 						smc_cdc_get_slot_and_msg_send
> 
> 			__softirqentry_text_start
> 				smc_wr_tx_process_cqe
> 					smc_cdc_tx_handler
> 						READ(conn->sndbuf_desc->len);
> 						/* panic dues to NULL sndbuf_desc */
> 
> conn->sndbuf_desc = xxx;
> 
> This patch tries to fix the issue by always to check the sndbuf_desc
> before send any cdc msg, to make sure that no null pointer is
> seen during cqe processing.
> 
> Fixes: 0b29ec643613 ("net/smc: immediate termination for SMCR link groups")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> 

Thanks for the fix!

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

> v2 -> v1: change retval from EINVAL to ENOBUFS
> 
> ---
>   net/smc/smc_cdc.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 53f63bf..89105e9 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -114,6 +114,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
>   	union smc_host_cursor cfed;
>   	int rc;
>   
> +	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
> +		return -ENOBUFS;
> +
>   	smc_cdc_add_pending_send(conn, pend);
>   
>   	conn->tx_cdc_seq++;

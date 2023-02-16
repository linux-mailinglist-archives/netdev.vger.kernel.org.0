Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862DE69965A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBPNvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjBPNvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:51:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDAC3B230;
        Thu, 16 Feb 2023 05:51:21 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GD6nru026547;
        Thu, 16 Feb 2023 13:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cw8cpgMohgcs2pYrV5svNYime2zrotmPp5AIBjMfMCI=;
 b=koCh1p0D8KAJ2m5g1cjmEAsykj8byQVE2GXFRg7R4FO8okyM/p9KqOWNvJ/LNma9Y9OC
 tzPXdo2Fpcw9dLpRpcryoO9lr3lqBwjRONTxLtMjAj3MyJ5EXR8NIZivXeUeeGpsLND9
 F47zg5SDNmRWFci8AW9qEpu2aEYW66sXeaRwIqewFhErCh/WigE3Z7n3ZPPRMX/hBqH/
 w0SF0HtKNy+UbiCcR3tQSCR5U22g90ASSY6hE8/rqwpc6cNkhH5ze/AWmaGWe6X7hFkG
 fEtCzLyxSdk7NmNeZdfQ5ifbnLGY4cUBz9MhtDJfUC2uylfUuuX4MM06yfirXPg97F0/ cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nshmye9g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 13:51:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GDo15t010284;
        Thu, 16 Feb 2023 13:51:17 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nshmye9fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 13:51:17 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31GDlgn2000999;
        Thu, 16 Feb 2023 13:51:16 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3np2n7sakg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 13:51:16 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GDpEFr47251906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 13:51:14 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D82B58059;
        Thu, 16 Feb 2023 13:51:14 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E972A5805E;
        Thu, 16 Feb 2023 13:51:12 +0000 (GMT)
Received: from [9.211.88.109] (unknown [9.211.88.109])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 13:51:12 +0000 (GMT)
Message-ID: <d8df1ad3-2af7-a108-a9d2-4f471815d084@linux.ibm.com>
Date:   Thu, 16 Feb 2023 14:51:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net v2] net/smc: fix potential panic dues to unprotected
 smc_llc_srv_add_link()
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1676529456-30988-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1676529456-30988-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vni1doKeqggkk5tX7JVh0Ek3_zNoUXM3
X-Proofpoint-ORIG-GUID: LsKtJSbwkwcg3QFHUfvxmS56SAZsbcHB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_10,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160116
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.02.23 07:37, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> There is a certain chance to trigger the following panic:
> 
> PID: 5900   TASK: ffff88c1c8af4100  CPU: 1   COMMAND: "kworker/1:48"
>   #0 [ffff9456c1cc79a0] machine_kexec at ffffffff870665b7
>   #1 [ffff9456c1cc79f0] __crash_kexec at ffffffff871b4c7a
>   #2 [ffff9456c1cc7ab0] crash_kexec at ffffffff871b5b60
>   #3 [ffff9456c1cc7ac0] oops_end at ffffffff87026ce7
>   #4 [ffff9456c1cc7ae0] page_fault_oops at ffffffff87075715
>   #5 [ffff9456c1cc7b58] exc_page_fault at ffffffff87ad0654
>   #6 [ffff9456c1cc7b80] asm_exc_page_fault at ffffffff87c00b62
>      [exception RIP: ib_alloc_mr+19]
>      RIP: ffffffffc0c9cce3  RSP: ffff9456c1cc7c38  RFLAGS: 00010202
>      RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000004
>      RDX: 0000000000000010  RSI: 0000000000000000  RDI: 0000000000000000
>      RBP: ffff88c1ea281d00   R8: 000000020a34ffff   R9: ffff88c1350bbb20
>      R10: 0000000000000000  R11: 0000000000000001  R12: 0000000000000000
>      R13: 0000000000000010  R14: ffff88c1ab040a50  R15: ffff88c1ea281d00
>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>   #7 [ffff9456c1cc7c60] smc_ib_get_memory_region at ffffffffc0aff6df [smc]
>   #8 [ffff9456c1cc7c88] smcr_buf_map_link at ffffffffc0b0278c [smc]
>   #9 [ffff9456c1cc7ce0] __smc_buf_create at ffffffffc0b03586 [smc]
> 
> The reason here is that when the server tries to create a second link,
> smc_llc_srv_add_link() has no protection and may add a new link to
> link group. This breaks the security environment protected by
> llc_conf_mutex.
> 
> Fixes: 2d2209f20189 ("net/smc: first part of add link processing as SMC server")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
> v2: rebase it with lastest net tree
> 
>   net/smc/af_smc.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e12d4fa..d9413d4 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1826,8 +1826,10 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
>   	smc_llc_link_active(link);
>   	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
>   
> +	mutex_lock(&link->lgr->llc_conf_mutex);
>   	/* initial contact - try to establish second link */
>   	smc_llc_srv_add_link(link, NULL);
> +	mutex_unlock(&link->lgr->llc_conf_mutex);
>   	return 0;
>   }
>   

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

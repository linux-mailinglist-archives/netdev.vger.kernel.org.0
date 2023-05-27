Return-Path: <netdev+bounces-5874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37DC7133FC
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92F801C20F15
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0E1AD2D;
	Sat, 27 May 2023 10:23:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8032B53A6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 10:23:18 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651CBF7;
	Sat, 27 May 2023 03:23:16 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34RA9uZa031191;
	Sat, 27 May 2023 10:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K2RUSaLi7zWoDUyT8x+n3bY3PE0Wzvms/FkexrqLLmQ=;
 b=gqqISViuwrnAdZomoTdZVy5mxDXbLNdBETFlwJdcUTbaNFvGvhD/qI/h1zWSKEl4JYY1
 D4doZe73jCOi8i3YZE29hR/e5yGtyfjZisp13t07S1dF4nFZsN/7DbxFcOMu6bpj0oip
 Kx3FK0H1mUXYvJxWAVcUmDQWuPSi2bL+8VXwN3C6qmsMbgwo/lWxZnoGJUvczgEnUcXo
 UbRx0hNPl+e30rsRKbZMaU9Xktl/brzIK5v1594rUlEOdzzc9xxLjTp92P4faZks6m4L
 0M8sbOqQeDnlG2S11uIT7yM6VDxg7lFnaVA9gRFKPTnnMNCXx3KWBREQdiEcSzYGmfT9 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qudquswh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 27 May 2023 10:23:05 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34RAN43G030036;
	Sat, 27 May 2023 10:23:04 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qudquswgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 27 May 2023 10:23:04 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
	by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34R9U9Vn016816;
	Sat, 27 May 2023 10:23:04 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
	by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3qu9g5t1va-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 27 May 2023 10:23:03 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34RAN2Mv5767912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 May 2023 10:23:02 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 687A858052;
	Sat, 27 May 2023 10:23:02 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC8E658056;
	Sat, 27 May 2023 10:23:00 +0000 (GMT)
Received: from [9.61.61.159] (unknown [9.61.61.159])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 27 May 2023 10:23:00 +0000 (GMT)
Message-ID: <f134294c-2919-6069-d362-87a84c846690@linux.ibm.com>
Date: Sat, 27 May 2023 12:22:59 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH net 2/2] net/smc: Don't use RMBs not mapped to new link in
 SMCRv2 ADD LINK
To: Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
 <1685101741-74826-3-git-send-email-guwen@linux.alibaba.com>
From: Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1685101741-74826-3-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: abzRe9YmxH_8ONHzzF7HyWHNDn9OMNup
X-Proofpoint-GUID: wrhEsJJmeX1ZK0CTc4fPwmlR0RKrvCWp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-27_06,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=577
 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305270086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 26.05.23 13:49, Wen Gu wrote:
> We encountered a crash when using SMCRv2. It is caused by a logical
> error in smc_llc_fill_ext_v2().
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000014
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP PTI
>   CPU: 7 PID: 453 Comm: kworker/7:4 Kdump: loaded Tainted: G        W   E      6.4.0-rc3+ #44
>   Workqueue: events smc_llc_add_link_work [smc]
>   RIP: 0010:smc_llc_fill_ext_v2+0x117/0x280 [smc]
>   RSP: 0018:ffffacb5c064bd88 EFLAGS: 00010282
>   RAX: ffff9a6bc1c3c02c RBX: ffff9a6be3558000 RCX: 0000000000000000
>   RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000000a
>   RBP: ffffacb5c064bdb8 R08: 0000000000000040 R09: 000000000000000c
>   R10: ffff9a6bc0910300 R11: 0000000000000002 R12: 0000000000000000
>   R13: 0000000000000002 R14: ffff9a6bc1c3c02c R15: ffff9a6be3558250
>   FS:  0000000000000000(0000) GS:ffff9a6eefdc0000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000014 CR3: 000000010b078003 CR4: 00000000003706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    smc_llc_send_add_link+0x1ae/0x2f0 [smc]
>    smc_llc_srv_add_link+0x2c9/0x5a0 [smc]
>    ? cc_mkenc+0x40/0x60
>    smc_llc_add_link_work+0xb8/0x140 [smc]
>    process_one_work+0x1e5/0x3f0
>    worker_thread+0x4d/0x2f0
>    ? __pfx_worker_thread+0x10/0x10
>    kthread+0xe5/0x120
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork+0x2c/0x50
>    </TASK>
> 
> When an alernate RNIC is available in system, SMC will try to add a new
> link based on the RNIC for resilience. All the RMBs in use will be mapped
> to the new link. Then the RMBs' MRs corresponding to the new link will be
> filled into SMCRv2 LLC ADD LINK messages.
> 
> However, smc_llc_fill_ext_v2() mistakenly accesses to unused RMBs which
> haven't been mapped to the new link and have no valid MRs, thus causing
> a crash. So this patch fixes the logic.
> 
> Fixes: b4ba4652b3f8 ("net/smc: extend LLC layer for SMC-Rv2")
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>   net/smc/smc_llc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 8423e8e..7a8d916 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -617,6 +617,8 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
>   		goto out;
>   	buf_pos = smc_llc_get_first_rmb(lgr, &buf_lst);
>   	for (i = 0; i < ext->num_rkeys; i++) {
> +		while (buf_pos && !(buf_pos)->used)
> +			buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
>   		if (!buf_pos)
>   			break;
>   		rmb = buf_pos;
> @@ -626,8 +628,6 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
>   			cpu_to_be64((uintptr_t)rmb->cpu_addr) :
>   			cpu_to_be64((u64)sg_dma_address(rmb->sgt[lnk_idx].sgl));
>   		buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
> -		while (buf_pos && !(buf_pos)->used)
> -			buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
>   	}
>   	len += i * sizeof(ext->rt[0]);
>   out:

I'm wondering if this crash is introduced by the first fix patch you wrote.

Thanks,
Wenjia


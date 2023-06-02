Return-Path: <netdev+bounces-7315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 650C871FA05
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA7181C20D68
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2153D7A;
	Fri,  2 Jun 2023 06:22:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BED2187F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:22:17 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA7A195;
	Thu,  1 Jun 2023 23:22:16 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3525pDpF013692;
	Fri, 2 Jun 2023 06:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jh/p4dQmUfabXWYxGavPyEaY3XOY8kwt0BdtVT7uXik=;
 b=iDwb3BqDY+T2o80FU0bhdsOijNWuBGLcNOT8OUNm90EHWQOEvHUa/9jwojkk3zKRtjwT
 nclB1l7LztxtLNx3pXyh5C7by5VdOfONW+Lz/H5RVdrQP4k3Llv1ui/jeicd+YGTiQb/
 vjNElJn/lC8yjysmVdQ5vYEnqHaAqbFWbw4JJDlWlJ5GlUMRb6zqMo89+1wIhCMTgBaT
 CImWEuA0lfMdHOFt36tXqzmBb7TKqXcy6TEOaSFG/LTEyJO/ddQlYuP93sgGgv5ncPSf
 BS9y/fcvs96zjY0+UJPtD8uvuQAXGDZ80VVerJfMRRK2ys/w8IUvalU9AoGJRmhxSfv+ JA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyan3gmb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 06:22:11 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35268RZh032281;
	Fri, 2 Jun 2023 06:22:11 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyan3gmaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 06:22:11 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
	by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3524ijkZ016863;
	Fri, 2 Jun 2023 06:22:10 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
	by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3qu9g763b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 06:22:10 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3526M8N427001558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Jun 2023 06:22:08 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8ECF58056;
	Fri,  2 Jun 2023 06:22:08 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27E885805D;
	Fri,  2 Jun 2023 06:22:07 +0000 (GMT)
Received: from [9.171.8.37] (unknown [9.171.8.37])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Jun 2023 06:22:06 +0000 (GMT)
Message-ID: <4e4f539c-0c74-675c-74fe-52a64e3fb365@linux.ibm.com>
Date: Fri, 2 Jun 2023 08:22:06 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.1
Subject: Re: [PATCH net] net/smc: Avoid to access invalid RMBs' MRs in SMCRv1
 ADD LINK CONT
To: Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1685608912-124996-1-git-send-email-guwen@linux.alibaba.com>
From: Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1685608912-124996-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z_iAv_AAS-0_1IxPjPdD1rSDmZ9ng0p2
X-Proofpoint-GUID: 7N-ofvtFxjONRqBJYyn2LyCAxn3ZU4UC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_03,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=862 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 01.06.23 10:41, Wen Gu wrote:
> SMCRv1 has a similar issue to SMCRv2 (see link below) that may access
> invalid MRs of RMBs when construct LLC ADD LINK CONT messages.
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000014
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP PTI
>   CPU: 5 PID: 48 Comm: kworker/5:0 Kdump: loaded Tainted: G W   E      6.4.0-rc3+ #49
>   Workqueue: events smc_llc_add_link_work [smc]
>   RIP: 0010:smc_llc_add_link_cont+0x160/0x270 [smc]
>   RSP: 0018:ffffa737801d3d50 EFLAGS: 00010286
>   RAX: ffff964f82144000 RBX: ffffa737801d3dd8 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff964f81370c30
>   RBP: ffffa737801d3dd4 R08: ffff964f81370000 R09: ffffa737801d3db0
>   R10: 0000000000000001 R11: 0000000000000060 R12: ffff964f82e70000
>   R13: ffff964f81370c38 R14: ffffa737801d3dd3 R15: 0000000000000001
>   FS:  0000000000000000(0000) GS:ffff9652bfd40000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000014 CR3: 000000008fa20004 CR4: 00000000003706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    smc_llc_srv_rkey_exchange+0xa7/0x190 [smc]
>    smc_llc_srv_add_link+0x3ae/0x5a0 [smc]
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
> to the new link. Then the RMBs' MRs corresponding to the new link will
> be filled into LLC messages. For SMCRv1, they are ADD LINK CONT messages.
> 
> However smc_llc_add_link_cont() may mistakenly access to unused RMBs which
> haven't been mapped to the new link and have no valid MRs, thus causing a
> crash. So this patch fixes it.
> 
> Fixes: 87f88cda2128 ("net/smc: rkey processing for a new link as SMC client")
> Link: https://lore.kernel.org/r/1685101741-74826-3-git-send-email-guwen@linux.alibaba.com
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>   net/smc/smc_llc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 7a8d916..90f0b60 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -851,6 +851,8 @@ static int smc_llc_add_link_cont(struct smc_link *link,
>   	addc_llc->num_rkeys = *num_rkeys_todo;
>   	n = *num_rkeys_todo;
>   	for (i = 0; i < min_t(u8, n, SMC_LLC_RKEYS_PER_CONT_MSG); i++) {
> +		while (*buf_pos && !(*buf_pos)->used)
> +			*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
>   		if (!*buf_pos) {
>   			addc_llc->num_rkeys = addc_llc->num_rkeys -
>   					      *num_rkeys_todo;
> @@ -867,8 +869,6 @@ static int smc_llc_add_link_cont(struct smc_link *link,
>   
>   		(*num_rkeys_todo)--;
>   		*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
> -		while (*buf_pos && !(*buf_pos)->used)
> -			*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
>   	}
>   	addc_llc->hd.common.llc_type = SMC_LLC_ADD_LINK_CONT;
>   	addc_llc->hd.length = sizeof(struct smc_llc_msg_add_link_cont);

looks good to me! Thank you for fixing that!

Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>


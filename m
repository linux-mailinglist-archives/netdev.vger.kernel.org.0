Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4228E5A5E21
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 10:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiH3Ibt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 04:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiH3Ibr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 04:31:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92E272B5F;
        Tue, 30 Aug 2022 01:31:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27U82UBe030760;
        Tue, 30 Aug 2022 08:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cFArIjIZ2DH5VV3MmoOy/rFq9t2s5If/CjB7wMvFSGY=;
 b=UWNhRf7kSD2aMs91gR6ooZSgUonXs6MLcsneH1F/Bh79RsrGtThd308l1HV0q7e+mE9X
 3lJEaxrKrvOb5xH44UDdDSYyeytSeW3rpLCT3pCF3OAfi+1QuW0nALAdD7NKKh97eplo
 Tw+MDLRL6PRt6HPk5o2EebZaYBsJKxFiFEHbSj77svGEDa/BDaH9SqEaAc5tmhZppx35
 cTYQlAs4HtWsBrkElBqZ7/iRJnGwGiNDMD0v4y/qdeBQmSuNpKq7jNFREivkbeN0NpLm
 lrZWQircHRsd1M4+DeshHBUYbSUJVyg7e56RLUwGu0kIkQMipIGDhSCgeByxChOfBt8V yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9epn0xkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:31:37 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27U8635T007077;
        Tue, 30 Aug 2022 08:31:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9epn0xj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:31:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27U8LToW005270;
        Tue, 30 Aug 2022 08:31:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3j7aw8ue2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:31:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27U8VVcE30802248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 08:31:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56E30AE055;
        Tue, 30 Aug 2022 08:31:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01D31AE045;
        Tue, 30 Aug 2022 08:31:31 +0000 (GMT)
Received: from [9.152.224.131] (unknown [9.152.224.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 08:31:30 +0000 (GMT)
Message-ID: <b3245c33-125c-7483-318a-a78dfbdac5ee@linux.ibm.com>
Date:   Tue, 30 Aug 2022 10:31:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net v2] net/smc: fix listen processing for SMC-Rv2
Content-Language: en-US
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, tonylu@linux.alibaba.com, wenjia@linux.ibm.com
References: <20220830030555.373860-1-liuyacan@corp.netease.com>
 <20220830055806.1142343-1-liuyacan@corp.netease.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220830055806.1142343-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jkFWMC2VIkWF5WYIEeKr5TdS_UvJJ80W
X-Proofpoint-ORIG-GUID: b8zl8AWz5TZxnPbxUzbnxa-7VmWctDgz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.08.22 07:58, liuyacan@corp.netease.com wrote:
>>> From: liuyacan <liuyacan@corp.netease.com>
>>>
>>> After modifying the QP to the Error state, all RX WR would be
>>> completed with WC in IB_WC_WR_FLUSH_ERR status. Current
>>> implementation does not wait for it is done, but free the link
>>> directly. So there is a risk that accessing the freed link in
>>> tasklet context.
>>>
>>> Here is a crash example:
>>>
>>>  BUG: unable to handle page fault for address: ffffffff8f220860
>>>  #PF: supervisor write access in kernel mode
>>>  #PF: error_code(0x0002) - not-present page
>>>  PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
>>>  Oops: 0002 [#1] SMP PTI
>>>  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
>>>  Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
>>>  RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
>>>  Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
>>>  RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
>>>  RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
>>>  RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
>>>  RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
>>>  R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
>>>  R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
>>>  FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
>>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>  CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
>>>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>  Call Trace:
>>>   <IRQ>
>>>   _raw_spin_lock_irqsave+0x30/0x40
>>>   mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
>>>   smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
>>>   tasklet_action_common.isra.21+0x66/0x100
>>>   __do_softirq+0xd5/0x29c
>>>   asm_call_irq_on_stack+0x12/0x20
>>>   </IRQ>
>>>   do_softirq_own_stack+0x37/0x40
>>>   irq_exit_rcu+0x9d/0xa0
>>>   sysvec_call_function_single+0x34/0x80
>>>   asm_sysvec_call_function_single+0x12/0x20
>>>
>>> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
>>> ---
>>>  net/smc/smc_core.c |  2 ++
>>>  net/smc/smc_core.h |  2 ++
>>>  net/smc/smc_wr.c   | 12 ++++++++++++
>>>  net/smc/smc_wr.h   |  3 +++
>>>  4 files changed, 19 insertions(+)
>>>
>>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>>> index ff49a11f5..b632a33f1 100644
>>> --- a/net/smc/smc_core.c
>>> +++ b/net/smc/smc_core.c
>>> @@ -752,6 +752,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
>>>  	atomic_inc(&lnk->smcibdev->lnk_cnt);
>>>  	refcount_set(&lnk->refcnt, 1); /* link refcnt is set to 1 */
>>>  	lnk->clearing = 0;
>>> +	lnk->rx_drained = 0;
>>>  	lnk->path_mtu = lnk->smcibdev->pattr[lnk->ibport - 1].active_mtu;
>>>  	lnk->link_id = smcr_next_link_id(lgr);
>>>  	lnk->lgr = lgr;
>>> @@ -1269,6 +1270,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
>>>  	smcr_buf_unmap_lgr(lnk);
>>>  	smcr_rtoken_clear_link(lnk);
>>>  	smc_ib_modify_qp_error(lnk);
>>> +	smc_wr_drain_cq(lnk);
>>>  	smc_wr_free_link(lnk);
>>>  	smc_ib_destroy_queue_pair(lnk);
>>>  	smc_ib_dealloc_protection_domain(lnk);
>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
>>> index fe8b524ad..0a469a3e7 100644
>>> --- a/net/smc/smc_core.h
>>> +++ b/net/smc/smc_core.h
>>> @@ -117,6 +117,7 @@ struct smc_link {
>>>  	u64			wr_rx_id;	/* seq # of last recv WR */
>>>  	u32			wr_rx_cnt;	/* number of WR recv buffers */
>>>  	unsigned long		wr_rx_tstamp;	/* jiffies when last buf rx */
>>> +	wait_queue_head_t       wr_rx_drain_wait; /* wait for WR drain */
>>>  
>>>  	struct ib_reg_wr	wr_reg;		/* WR register memory region */
>>>  	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
>>> @@ -138,6 +139,7 @@ struct smc_link {
>>>  	u8			link_idx;	/* index in lgr link array */
>>>  	u8			link_is_asym;	/* is link asymmetric? */
>>>  	u8			clearing : 1;	/* link is being cleared */
>>> +	u8                      rx_drained : 1; /* link is drained */
>>>  	refcount_t		refcnt;		/* link reference count */
>>>  	struct smc_link_group	*lgr;		/* parent link group */
>>>  	struct work_struct	link_down_wrk;	/* wrk to bring link down */
>>> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
>>> index 26f8f240d..f9992896a 100644
>>> --- a/net/smc/smc_wr.c
>>> +++ b/net/smc/smc_wr.c
>>> @@ -465,6 +465,10 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
>>>  			case IB_WC_RNR_RETRY_EXC_ERR:
>>>  			case IB_WC_WR_FLUSH_ERR:
>>>  				smcr_link_down_cond_sched(link);
>>> +				if (link->clearing && wc[i]->wr_id == link->wr_rx_id) {
>>> +					link->rx_drained = 1;
>>> +					wake_up(&link->wr_rx_drain_wait);
>>> +				}
>>
>> I am wondering if we should wait for all the wc comes back?
> 
> I think yes, so other processes can safely destroy qp.
> 
>>
>>>  				break;
>>>  			default:
>>>  				smc_wr_rx_post(link); /* refill WR RX */
>>> @@ -631,6 +635,13 @@ static void smc_wr_init_sge(struct smc_link *lnk)
>>>  	lnk->wr_reg.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
>>>  }
>>>  
>>> +void smc_wr_drain_cq(struct smc_link *lnk)
>>> +{
>>> +	wait_event_interruptible_timeout(lnk->wr_rx_drain_wait,
>>> +					 (lnk->drained == 1),
>>> +					 SMC_WR_RX_WAIT_DRAIN_TIME);
>>> +}
>>
>> Should we wait for it with timeout? It should eventually be wake up
>> normally before freeing link. Waiting for SMC_WR_RX_WAIT_DRAIN_TIME (2s)
>> may also have this issue, although the probability of occurrence is
>> greatly reduced.
> 
> Indeed, there should logically probably be a perpetual wait here. I'm just worried if it 
> will get stuck for some unknown reason.
> 
>>
>> Cheers,
>> Tony Lu
> 
> Regards,
> Yacan
> 

Thank you very much for working on a fix, Yacan.

Some comments to make reviewers' lives easier:
Please use your real name for the Signed-Off tag and Mail sender (Is it Yacan Liu ?)
(Please use the same Mail address for all your posts. In April there was a post from yacanliu@163.com. Not this one)
Important: Add a Fixes tag, when sending fixes to NET
Is this mail really a reply to your v2? Or rather a reply to Tony's comments on v1?

Kind regards
Alexandra

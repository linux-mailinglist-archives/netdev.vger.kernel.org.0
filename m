Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EBC4F9FCE
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiDHW7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiDHW7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:59:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85854ECCA;
        Fri,  8 Apr 2022 15:57:26 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238MvCtU027938;
        Fri, 8 Apr 2022 15:57:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=mwg8nrvR6bBg0AS1xShfDivbVBIOnPBem0iVoU5AWNk=;
 b=ZEA5Ke1gilbW2RVFcK7wV1SDX+T8DHiH4f1qDTYbBjFkOByseGHIg0BBr9NGIYBKSDck
 cm2tV7tX+lDEv0B8T9ime9A/nBU+Ebyojxlikjy4W0g5oJPR+5vdyQc1y7Ho41uhS4Fv
 w+22eZBrAEyVwYym120d0O3mEb62kJ2BdSU= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fad7yxvta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:57:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIYo8QqT98rz3tQCAmQgRlrejeVbfT/wylo2wHp8uejNLp94clD1j1DNAEw30WXTq7+q/A/0uPOx5BUYpDvxfLN+opZc4lBzhoTajdxPXEMwLVVdF7ia73NRpGqy0f4ujCluio5srLEUQu8oBdPROXzPXKSoMgNNC8md3DlN6wG2MmMPTY+I7nL0AlB9AHS+74aRtVNimVEcUBa1XKQrjWVGquhvXN6dGlPMrUAjMhWT3uhGDKsxaxZ+HWsjmq6kswRyc6JwkIBdbM5aZqBGBPs9AuTn9Rxl5JfyTCCiO5sqhJcj4pkojtx21ENjFdyT5xkCjdFxve6UofgIpGUVTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwg8nrvR6bBg0AS1xShfDivbVBIOnPBem0iVoU5AWNk=;
 b=W9iaeZvCr5i8WvRIZiPnKdoQfWH9nQUys+75qP+KSFm9HlLhPXCQr444yCI1YH5/aN8O3pFBPCaZ/1dflyNPKvQJBN0iZRRYxmwGIx9uumd6jSDPrzJgmrn9z9HH5onjCKPMo4Ts8tZunVPGfdTJqC7NyaSjvur1xkfRg9fvCCmVIcWbORadhhyZ66EInZZUOzd2EG3glQIh1Yl4gpO2nIhCUh1zlHsdbHy2Tm5Xy22G5P3SUWMVupWroe8MnuWGYoeD76FiBosyEMRZ+bsyv5g/vKpg3GcMnBr9Whox7tyjftgUxJveJgDd8QDBw5auiZ/NcaXx+/xIcK5Sh2a+sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB3324.namprd15.prod.outlook.com (2603:10b6:5:16b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 22:56:31 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::bda3:5584:c982:9d44]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::bda3:5584:c982:9d44%3]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 22:56:31 +0000
Date:   Fri, 8 Apr 2022 15:56:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407223112.1204582-4-sdf@google.com>
X-ClientProxiedBy: BY5PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::39) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83a291a7-25a9-42dc-3778-08da19b30583
X-MS-TrafficTypeDiagnostic: DM6PR15MB3324:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB33243E1CC03C4545EFBED1C2D5E99@DM6PR15MB3324.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8lx5PZRZSeY9Wky2n1YS4+F6/ft6zF6QAhIqv618PoBoOioaZCKu5dJuLS6erqLHliUPAGj6DvcMyAd1liEEGjnTIkwFEY1QuUfWQPKKfiGjUuI86vN1D19rGIC0ApJBgfIeHWHuvTciWNia2187xuUgWCJP1+yqoinb79HuHlqN7dLDMWAJEvDEPrhwhD5J13L98UbQQpOZHuQdYTbpre9eZdev4NbAig835+HuQa8jQipnq9gB05n8z8VVHsJdQX8EwuXbRHx075ahHXjuZyJFQmDfyt1GTh135LbnjFOoRUgH+IE+VP6RPyjGxWJiC/fVyhN9jhZ1Uw2+VKu7Iwmk3GwbR+V2R0VAt4lWx2WsA9E2mT2Vya2dnCJgzaHFLVGBp9Md0LWuBBqGI93IIQ7qnnj82Hp6ELc78TgORCAC/VHHH7S7lR4JbQNQyble+JFk+znxLuIHRteOhgrr0Ehf8Zt26uKQVZbRJBF8MyBLqLuVn6h/NHVO5XyYHKcM4kdOCXsvHQDmxmQCISiuvF+3gUmxsVG2rno4Llyrfc3KDdp8iAzWCRl+rMfQ8hBEPcQlXosF+QcflQZx6TPYq7wtP9h36LvsTasZnT+U8yr0agoVqCCDYDycdkoTboZtKE8fqisW6r3LI8bHfnqFNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(6666004)(66476007)(66556008)(83380400001)(8676002)(86362001)(8936002)(6916009)(6486002)(4326008)(316002)(38100700002)(5660300002)(2906002)(186003)(1076003)(6506007)(508600001)(6512007)(9686003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R4QMzaA7qwqOAsrk9e5X1CCUO1yB2NGssN3d5doVOWv6190Y0a0ppOFZ2qrb?=
 =?us-ascii?Q?D87kzDi31qNrxwg8mipzceusW4jQeehOLxlVUKSK9v2iHChOnwyYIcYhewoa?=
 =?us-ascii?Q?aYad6afpyVHMkb2F3fnHUTEXoia1JLuvQ4kHDVTHTnW7CUFk05xyQa1Rz5eX?=
 =?us-ascii?Q?1c2AWhE1Vt2owmAt7QIfqdY3Eph4+9fSLFZgsCFAq4+Nt6eDX1Xg47XgWSZs?=
 =?us-ascii?Q?JREtc5/DrC5Cng4PDbg5DTESrA3UJjQiQnyMRd8rWcP1iroRfjnB0Wv4S+vZ?=
 =?us-ascii?Q?t4Z05QguucSRELehjJqkOHOHsCdeV8vLSxegOCyMrMEUw0vkrwVLzHuYcEOT?=
 =?us-ascii?Q?pIuulLNPXq6AnsKMWP+Qa9B69n4aGCcVUNh1aNPbpnVQBzWcil09iWFwZENM?=
 =?us-ascii?Q?frOnKFBOpZ0aoPLeSEBw1RJ6+Yo8u5xUXADf3tULAllRLSC+A/fsU9RC5f2u?=
 =?us-ascii?Q?ccHSQi7uI4rmtvWwLB1Eb8+AGYLm78zIZA2Kz5518hwmYyGuAmGS7OqRseD6?=
 =?us-ascii?Q?Pwb/XiqkeOKyz/ZrCFVoQXI5Ar3ouOp32UqpdN6eaLnnwRqVch8JE4Qt/UlI?=
 =?us-ascii?Q?+xHXJfZFNqlqeXEBOYQAzRhjHrZWBEpNKrG6g47oLQVBAHn0teG0tSHM4muG?=
 =?us-ascii?Q?BLNt9Fh2gyELrMTD9TXLYI1vYJVHb56bN1cZ8wmRt/Y+VmGe9zg1A9+U05jc?=
 =?us-ascii?Q?9PQHg+xG6OGpRNY4uGBzNJNp+ZTBra7T90fZ0C6qL5ntCPXp+RZeGA3S2j37?=
 =?us-ascii?Q?ZV1Ev12m9kRC7i34U8LGDgYOT/9tLHyFInK+5bRH7YhA4UNzWgrSC9HHcwj8?=
 =?us-ascii?Q?SvSOpEkeR2x6hT2IBo0p8ue4pi3aIDvKXc1qBPe6oChoK6pUfHTvMt3SRCFT?=
 =?us-ascii?Q?9uZQ1jTRwNTxeRmwZ7lhQd++n/ZUiu6wERD+naUSmoTMnQMtgFr2Q1E6MuB9?=
 =?us-ascii?Q?AlpJDud20iMOsBC1YjDmToynsCF38DHUYcm8jZrKJUmBmdRc79Ukt4tN4Kgf?=
 =?us-ascii?Q?gRuRlKqU+sTesf55X2myv5TuPYl+JLT98zLBIAnsU9JQr1Jo9ATB9ouK/VcH?=
 =?us-ascii?Q?LpQH0I0fn91WB4ogrq20caWgbOAXvtib6VGSKoGRKrjUYtC0iRaVH9O9BXWl?=
 =?us-ascii?Q?emFqknMnU+zAIk5KjDXgmz1g8SsceM4uwjHquHWpR+TE4WfkbMo6R5xWYCsg?=
 =?us-ascii?Q?duNTYUFLkSCNGyfE+3x1CvGVb6RpftS8o/12tLi4Pyxp/LfjjJWEoEH5FKiz?=
 =?us-ascii?Q?LefHMv37UkTDv2KkTZ+qF7nwSTIjxLEDCLkSubaaiNkf8Jkr5ug1/C/I6ApN?=
 =?us-ascii?Q?0QVFeq0u1mZOZJPWfbTAXzHe6IFT3TiqUHYge5VIydQ3Wczb/YRrg7FSbwOX?=
 =?us-ascii?Q?/E24/zyJfeMuXjzMxu2OK327ftt9bdb/uVtPQZEksafj6Smb2sh5z0viJvb0?=
 =?us-ascii?Q?e6SjL/vO3jdbgbHNEZU08DNE+iJHweZS4mDHrczCAhBeUNLoHFhw3pb76+mr?=
 =?us-ascii?Q?vuDxQeWK78U18AqXmm+kH04musl6oca32rxXE3+uEdY+gCBcLLW86nGaUqRy?=
 =?us-ascii?Q?nbkKsuFxHqWMPjpP7kcPvyb1NRy+rXJEnetyuyogupE7nwTXGmLt2vG8goJ3?=
 =?us-ascii?Q?rQe4CjOh2lOPQWV4jAPbGjCkoQV52excTF/XzRVUD73J5caCgrAtokPfiQb/?=
 =?us-ascii?Q?LMdeaEwEHhjQGum0L3rAzkijl5X4S4iJqBU0AmwF0KuAYbRka4wMrkZVz7/F?=
 =?us-ascii?Q?AsDi163D8ihiVc+7u0dEvl58kpAvKg8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a291a7-25a9-42dc-3778-08da19b30583
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 22:56:31.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9IhU4hucwBRWAo1MhC/Tx4A/K2Bm4BzhHli0fqspuYykK133f9ASgW4fE0DtDID
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3324
X-Proofpoint-ORIG-GUID: 3CxA8xwn_FdkmV53c9Hjg7fDiZRcmBd5
X-Proofpoint-GUID: 3CxA8xwn_FdkmV53c9Hjg7fDiZRcmBd5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_08,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> Previous patch adds 1:1 mapping between all 211 LSM hooks
> and bpf_cgroup program array. Instead of reserving a slot per
> possible hook, reserve 10 slots per cgroup for lsm programs.
> Those slots are dynamically allocated on demand and reclaimed.
> This still adds some bloat to the cgroup and brings us back to
> roughly pre-cgroup_bpf_attach_type times.
> 
> It should be possible to eventually extend this idea to all hooks if
> the memory consumption is unacceptable and shrink overall effective
> programs array.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup-defs.h |  4 +-
>  include/linux/bpf_lsm.h         |  6 ---
>  kernel/bpf/bpf_lsm.c            |  9 ++--
>  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
>  4 files changed, 90 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> index 6c661b4df9fa..d42516e86b3a 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -10,7 +10,9 @@
>  
>  struct bpf_prog_array;
>  
> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> + */
> +#define CGROUP_LSM_NUM 10
hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
a static 211 (and potentially growing in the future) is not good either.
I currently do not have a better idea also. :/

Have you thought about other dynamic schemes or they would be too slow ?

>  enum cgroup_bpf_attach_type {
>  	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> index 7f0e59f5f9be..613de44aa429 100644
> --- a/include/linux/bpf_lsm.h
> +++ b/include/linux/bpf_lsm.h
> @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
>  void bpf_inode_storage_free(struct inode *inode);
>  
>  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> -int bpf_lsm_hook_idx(u32 btf_id);
>  
>  #else /* !CONFIG_BPF_LSM */
>  
> @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  	return -ENOENT;
>  }
>  
> -static inline int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return -EINVAL;
> -}
> -
>  #endif /* CONFIG_BPF_LSM */
>  
>  #endif /* _LINUX_BPF_LSM_H */
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index eca258ba71d8..8b948ec9ab73 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
>  	if (unlikely(!sk))
>  		return 0;
>  
> +	rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
>  	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
>  	if (likely(cgrp))
>  		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
>  					    ctx, bpf_prog_run, 0);
> +	rcu_read_unlock();
>  	return ret;
>  }
>  
> @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
>  	/*prog = container_of(insn, struct bpf_prog, insnsi);*/
>  	prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
>  
> -	rcu_read_lock();
> +	rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
I think this is also needed for task_dfl_cgroup().  If yes,
will be a good idea to adjust the comment if it ends up
using the 'CGROUP_LSM_NUM 10' scheme.

While at rcu_read_lock(), have you thought about what major things are
needed to make BPF_LSM_CGROUP sleepable ?

The cgroup local storage could be one that require changes but it seems
the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
The current use case doesn't need it?  

>  	cgrp = task_dfl_cgroup(current);
>  	if (likely(cgrp))
>  		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> @@ -122,11 +124,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  	return 0;
>  }
>  
> -int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> -}
> -
>  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>  			const struct bpf_prog *prog)
>  {

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB7A53D5B3
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 08:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiFDGMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 02:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiFDGMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 02:12:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50246FD14;
        Fri,  3 Jun 2022 23:12:18 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2543OOqM031231;
        Fri, 3 Jun 2022 23:12:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FkSx53UfUAA+RNa2q6GHsC+Jc5Eg9No/NQYUyNM80vo=;
 b=p1oO0WLfSz/ncfqCZhf4i/8xWzC2S2x7a4MpSDCFTTKuH0UJnfOwDxHXvwOsGDxY46GM
 lPqlLCUjhlyw4So4lacmHD7ZbOKLNbiZf1RAhg6xAsY/SGeRGCb2C+nUIiN6rovnyuZ0
 lu+CbENPiqVRjHdTE40cxeArBd0kk4gvufU= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gfyesgc70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 23:12:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4BRRKW9tmW/P+ZtaY4gKtTCrg5bHyO8LpTjpZaYKOlsKbGo57A1Et78v/yy93fB7NHKohY5bQmZhNfVwclZLpdEwcKwdc3S4kFOg0M4uazop0UmlVlM7zo031Lx/mVYPts9eguguYd77O4mYM3xUJwgnw6cYNG+UZvpdsg6phvHWR99yVu5AfS0IAGr0cUJwqK79a03joFieMmxUSaDpqGCZpvcfy8j1OLXubLT4s6hfb+B7H014Xaibn0M4HAcBgKkCzUN8x4saMuejVf7aijPAvBje9Zh9HNozhFn44akE/+nw/F6YLQAc+CTttz27NAqm+NVYP427nOWtMotpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkSx53UfUAA+RNa2q6GHsC+Jc5Eg9No/NQYUyNM80vo=;
 b=ezsbTF4rojNacxya+uUTgq2V9y1hOSIevgafwAmLwR28mT/oCsQXNXknHGQDfzztXrmUT6Ubd5I37z/9Ht/a3xOQX0mx16B+s9UYXVLEyifnRvW3SpyX0J8OVt2l9wDc1UO6oSUgunVWcgvZoLX1Bs6Dt/J6MWVLU4+QOtyZYhPiBfw+fAqZpmL3ifSTmKfK2eHpk0AFJGjAKMo+LABgGHrxxUxC8ZJ0gaV4thQDAnQjwGD2OIeS8mIRZzMzjNQwj7ooE20/1PTjHQ55PA47phBmiFI9AO5kTmkEbRppwafUQU9RAUXqER5mwgrm7r+4PFifJ+KYGBD8OzygNcK38g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CO1PR15MB4939.namprd15.prod.outlook.com (2603:10b6:303:e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Sat, 4 Jun
 2022 06:11:58 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 06:11:58 +0000
Date:   Fri, 3 Jun 2022 23:11:54 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220604061154.kefsehmyrnwgxstk@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601190218.2494963-4-sdf@google.com>
X-ClientProxiedBy: MWHPR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:300:12b::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25dc90e0-a136-4722-50e6-08da45f12131
X-MS-TrafficTypeDiagnostic: CO1PR15MB4939:EE_
X-Microsoft-Antispam-PRVS: <CO1PR15MB49396D1C2C722AC7CD8A69BED5A09@CO1PR15MB4939.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33EbVqFf+nryczJ6vcjxiD+D6K9pmzV06h3fZIemjQbyl0hW0qmGWDPvCsI3Bx95fizKO1UOwg8IrJ1joSfs1+OHEuHXSruifOrqxd0hI49L8uw10Kh2WjdYAyNBi1em/MhpvYIWKJZMyI/4GTgcfRbMw97F8XvY26JNlag2jsfhvEnBjHOzVbYuxmYGduH99IT6Ecy9OIXh9VvOG62EKavBeHHI2oC6G+pjmJmzuXCMGoFfFCcHFb0EK04TH+XKeVnIZl02oa60fw6jmBuLS+RQWQ7WpKKDfemzLaIIcOGg3iA44g4sD+edCwSjSTCU5CJUE3riQu1FeqUlUv4C0jbxZ8kX+4GXoEqXVBnHBXNzYos9VlfCM7Iax8ok91gyZdOKOuw9bu+TM+2Nb+KIkLxaO1hQE47afvEEQBq5R0l2L2ZM3H/ZDHpIPigDv9BW4eMKVbWe3FzNWAiYHJ3mJbAjuGIygCpR+gl6yLC4GAmA2B7IdfZLEnaxUS8LfVr3QETHQuqnKK6N9xLjLJ3MADNnXPyHpy8vCZ29iwzgjT0WVfyzrj7DasPQFy0o4TNBDu/WRs23BshtyqNdfxi97dew1wk6kT3HDzK41ErUu+YreaAUHxQpVTkNkvsmjRn8fjawv/OYv5cIUSieIaImbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(5660300002)(1076003)(186003)(8936002)(83380400001)(8676002)(3716004)(6486002)(30864003)(508600001)(2906002)(66946007)(66556008)(9686003)(6506007)(4326008)(6916009)(66476007)(6512007)(38100700002)(52116002)(86362001)(33716001)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J4c8dY1lVKQcRuDJ4NAW9oyfcJtv1zSfLDPPbTvvUZ2xA5iLb/uVPzOPcfkr?=
 =?us-ascii?Q?Fb+JHKmGS7O6lSB5y0CtGi0nAn8WnRBsrdqoNWtagnI4kVkE8IsYVNsFmcnq?=
 =?us-ascii?Q?/YP+JW2/9NWRUdGTlBEwlt0NVdii4deL9YocRR8cJ5arA7rSff64gXlXA2Kj?=
 =?us-ascii?Q?WaI5r1zQQF18WgovUdy8232qrXj/cG3asjsyIN+vLPh+jJUKJsZ6hzH8SR6Q?=
 =?us-ascii?Q?8zXVw1q0D6TClnN9aILuo1xIifSUT8CGuboa37zDaNYibafCbaHBijXYsAaK?=
 =?us-ascii?Q?0Fgl1dA9/xHoeNlwea0LRMRsVrs7RSKymjUI4OQNJ7b9RgNnsrCbsVBfkA2J?=
 =?us-ascii?Q?PWBm7kPdu3YGB7j58PR29ft5JEFmeacaFLNAaYaGZrAWCki7BIg5dmqjiKfA?=
 =?us-ascii?Q?006s34Gb82XUhzgwyQL+Caq+oAsFIf2uygccViEUjYIuzz9n0UDWVuePp+Wr?=
 =?us-ascii?Q?LvISvMKKLMJCk+ggw6hJuQjPuCSlB6umsSAFsZWBxH0BbWZp3m/NtND+l2jT?=
 =?us-ascii?Q?bVt2tD9CMjiNUlCdLpob17SjTL0FPG6D4VwXUTcLJBUTs1Y6X66wZrmmrTfR?=
 =?us-ascii?Q?QqdM6AtvuwRb2I+03QBaNDFyonIkb0gxNa37MwRFx1O3BIPIfD3UmoK1Z0+u?=
 =?us-ascii?Q?HOwjUcaZEoXR6AtxyW+/nG5s8+BVPCq2oWrSNd3QrrHm/Ace3uHPpYuQBjiH?=
 =?us-ascii?Q?hRzeIC7NHGKdrQs8eeNvFrrdgluf1CXAHYnYIoywFaVpL+fex/buQiQUIRkA?=
 =?us-ascii?Q?2TRiwY1m7NSW3ZKwSC0MDfBynf0vvBEp95kQeNvSfg1siGWF9mlOcCA5U2R3?=
 =?us-ascii?Q?9sdZgLEA/VGtKQ7ysHv/C3npn++EtAbEU6h8zA+qjF290m/wKOQSaBcJVXea?=
 =?us-ascii?Q?EOATi+hjWc5RBKECDHyeRZRb6ZF3mBNzQ3QyH6Blun3S4WCRObZhh305kghW?=
 =?us-ascii?Q?x1wAkoA05B0zTgaopxqdStcteuRSb/Da5WPteKpsS2ruc2W2eltRWsE4EIwk?=
 =?us-ascii?Q?VXXn8CA7gBm5/TIzLL188yRG4V7SNb1yM8gMDkwS0SSLXWLdyaw4He28atiD?=
 =?us-ascii?Q?ZFFC1vfhF+igjh0/ECv+ALkBRUFe3FdASPN5PCQm4LMreRfR5/V4BHJs+Ls7?=
 =?us-ascii?Q?af/CCIUZRY6eztWc6rDZjdEiQh7KXkfO/YTNbkrfMdKxxwPjnRP1w5mq2pGS?=
 =?us-ascii?Q?dJZWYe9cfsslA8G6A2RksW79nFxCmgJvzE77QlIDnfIEEpNghgj+PwZC+pmc?=
 =?us-ascii?Q?UcYOxnhAsiki6S0foU+Y4K9QC5OKCzSPY9s24uR2de0CLK/aiQtbiH3Wp3FL?=
 =?us-ascii?Q?2BT2mORtMU2xV2uHmav1wT+bfrhF36lwjtywQ3N6W7rt00+66UGZgXNO9Lql?=
 =?us-ascii?Q?XoKyX0GQPG/mmdk1KOEc7gmh4YQM9m1QZCAGcomNP111sbwtYZ5rIfwGB+X+?=
 =?us-ascii?Q?W9s5Vfso9W8SCKuALvjZlxCw1Q1AC1Kg9C4cTXzFiNYDxkbCPGTrtjEH5tOx?=
 =?us-ascii?Q?f/SJtG1GqTu6oYbqG7tA5qNDaLanXlNAOlDgkrXr4cTQ1XeXAcUfAOGP870y?=
 =?us-ascii?Q?+oTMKylzy8XmYH0NQCgqcNTe5sTHhMN3SiGpq+wq5zhdOct+79SZlc5kIxfP?=
 =?us-ascii?Q?041jMVfIjDsogZ8NPgfgWxaL3MQNBY04l2gyuBGvmntO3Vbp9cVVaGCVURqo?=
 =?us-ascii?Q?2DdWZdyNLfXTpEwwe3JXKErb5Emll2X6k2Fts4uN/yh4/U9fkzgUaKX32E8D?=
 =?us-ascii?Q?QpwmSJL5s8gj4WbFOxCzOgGg37HR7SU=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25dc90e0-a136-4722-50e6-08da45f12131
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 06:11:57.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+S0K+nxCeWhtQjLuwvvFKAVL3MccVuHZ9YxEm+uvWSXI2icq1BjCA69EAkF7Z/x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4939
X-Proofpoint-GUID: Mi_ii_-lQj8Ha-DkCpa5X_cLMP7YFpDf
X-Proofpoint-ORIG-GUID: Mi_ii_-lQj8Ha-DkCpa5X_cLMP7YFpDf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_08,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:02:10PM -0700, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 4adb4f3ecb7f..66b644a76a69 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -14,6 +14,9 @@
>  #include <linux/string.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf-cgroup.h>
> +#include <linux/btf_ids.h>
This should not be needed ?

> +#include <linux/bpf_lsm.h>
> +#include <linux/bpf_verifier.h>
>  #include <net/sock.h>
>  #include <net/bpf_sk_storage.h>
>  
> @@ -61,6 +64,88 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>  	return run_ctx.retval;
>  }
>  
> +unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
> +				       const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct sock *sk;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +	u64 *args;
> +
> +	args = (u64 *)ctx;
> +	sk = (void *)(unsigned long)args[0];
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	return ret;
> +}
> +
> +unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> +					 const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct socket *sock;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +	u64 *args;
> +
> +	args = (u64 *)ctx;
> +	sock = (void *)(unsigned long)args[0];
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	cgrp = sock_cgroup_ptr(&sock->sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	return ret;
> +}
> +
> +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> +					  const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	rcu_read_lock();
> +	cgrp = task_dfl_cgroup(current);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +#ifdef CONFIG_BPF_LSM
> +static enum cgroup_bpf_attach_type
> +bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> +{
> +	if (attach_type != BPF_LSM_CGROUP)
> +		return to_cgroup_bpf_attach_type(attach_type);
> +	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> +}
> +#else
> +static enum cgroup_bpf_attach_type
> +bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
> +{
> +	if (attach_type != BPF_LSM_CGROUP)
> +		return to_cgroup_bpf_attach_type(attach_type);
> +	return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_BPF_LSM */
> +
>  void cgroup_bpf_offline(struct cgroup *cgrp)
>  {
>  	cgroup_get(cgrp);
> @@ -163,10 +248,16 @@ static void cgroup_bpf_release(struct work_struct *work)
>  
>  		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
>  			hlist_del(&pl->node);
> -			if (pl->prog)
> +			if (pl->prog) {
> +				if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
nit.  Check expected_attach_type == BPF_LSM_CGROUP like
other places ?

> +					bpf_trampoline_unlink_cgroup_shim(pl->prog);
>  				bpf_prog_put(pl->prog);
> -			if (pl->link)
> +			}
> +			if (pl->link) {
> +				if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
Same here.

> +					bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
>  				bpf_cgroup_link_auto_detach(pl->link);
> +			}
>  			kfree(pl);
>  			static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>  		}
> @@ -479,6 +570,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> +	struct bpf_prog *new_prog = prog ? : link->link.prog;
> +	struct bpf_attach_target_info tgt_info = {};
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> @@ -495,7 +588,20 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  		/* replace_prog implies BPF_F_REPLACE, and vice versa */
>  		return -EINVAL;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> +	if (type == BPF_LSM_CGROUP) {
> +		if (replace_prog) {
> +			if (replace_prog->aux->attach_btf_id !=
> +			    new_prog->aux->attach_btf_id)
> +				return -EINVAL;
> +		}
This is no longer needed if it does not reuse the
replace_prog's cgroup_atype.

If old_prog is not NULL, it must have the same attach_btf_id.

This should still be true even bpf_cgroup_atype_find() return
a new cgroup_atype.  In that case, 'pl = find_attach_entry();'
must be NULL.

WDYT?

> +		err = bpf_check_attach_target(NULL, new_prog, NULL,
> +					      new_prog->aux->attach_btf_id,
> +					      &tgt_info);
If the above attach_btf_id check in unnecessary,
this can be done in bpf_trampoline_link_cgroup_shim() where
it is the only place that tgt_info will be used.
This should never fail also because this had been done
once during the prog load time, so doing it later is fine.

Then this whole "if (type == BPF_LSM_CGROUP)" case can be removed
from __cgroup_bpf_attach().

> +		if (err)
> +			return -EINVAL;
> +	}
> +
> +	atype = bpf_cgroup_atype_find(type, new_prog->aux->attach_btf_id);
>  	if (atype < 0)
>  		return -EINVAL;
>  
> @@ -549,9 +655,15 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	bpf_cgroup_storages_assign(pl->storage, storage);
>  	cgrp->bpf.flags[atype] = saved_flags;
>  
> +	if (type == BPF_LSM_CGROUP && !old_prog) {
hmm... I think this "!old_prog" test should not be here.

In allow_multi, old_prog can be NULL but it still needs
to bump the shim_link's refcnt by calling
bpf_trampoline_link_cgroup_shim().

This is a bit tricky.  Does it make sense ?

> +		err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
> +		if (err)
> +			goto cleanup;
> +	}
> +
>  	err = update_effective_progs(cgrp, atype);
>  	if (err)
> -		goto cleanup;
> +		goto cleanup_trampoline;
>  
>  	if (old_prog)
Then it needs a bpf_trampoline_unlink_cgroup_shim(old_prog) here.

>  		bpf_prog_put(old_prog);
> @@ -560,6 +672,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>  	bpf_cgroup_storages_link(new_storage, cgrp, type);
>  	return 0;
>  
> +cleanup_trampoline:
> +	if (type == BPF_LSM_CGROUP && !old_prog)
The "!old_prog" test should also be removed.

> +		bpf_trampoline_unlink_cgroup_shim(new_prog);
> +
>  cleanup:
>  	if (old_prog) {
>  		pl->prog = old_prog;
> @@ -651,7 +767,13 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
>  	struct hlist_head *progs;
>  	bool found = false;
>  
> -	atype = to_cgroup_bpf_attach_type(link->type);
> +	if (link->type == BPF_LSM_CGROUP) {
> +		if (new_prog->aux->attach_btf_id !=
> +		    link->link.prog->aux->attach_btf_id)
> +			return -EINVAL;
This should be no longer needed also.
It will return -ENOENT later.

> +	}
> +
> +	atype = bpf_cgroup_atype_find(link->type, new_prog->aux->attach_btf_id);
>  	if (atype < 0)
>  		return -EINVAL;
>  
> @@ -803,9 +925,15 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	struct bpf_prog *old_prog;
>  	struct bpf_prog_list *pl;
>  	struct hlist_head *progs;
> +	u32 attach_btf_id = 0;
>  	u32 flags;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> +	if (prog)
> +		attach_btf_id = prog->aux->attach_btf_id;
> +	if (link)
> +		attach_btf_id = link->link.prog->aux->attach_btf_id;
> +
> +	atype = bpf_cgroup_atype_find(type, attach_btf_id);
>  	if (atype < 0)
>  		return -EINVAL;
>  
> @@ -832,6 +960,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  		purge_effective_progs(cgrp, old_prog, link, atype);
>  	}
>  
> +
> +	if (type == BPF_LSM_CGROUP)
> +		bpf_trampoline_unlink_cgroup_shim(old_prog ? : link->link.prog);
For the '!old_prog' case (link case), do the
bpf_trampoline_unlink_cgroup_shim() in bpf_cgroup_link_release().

For the old_prog case (non-link case),
the bpf_trampoline_unlink_cgroup_shim() can be done
under the same 'if (old_prog)' check a few lines below.

Then for both cases shim unlink will be closer to where bpf_prog_put()
will be done and have similar pattern as in __cgroup_bpf_attach() and
cgroup_bpf_release(), so easier to reason in the future:
shim unlink and then prog put.

[ ... ]

> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 5466e15be61f..45dfcece76e7 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -11,6 +11,8 @@
>  #include <linux/rcupdate_wait.h>
>  #include <linux/module.h>
>  #include <linux/static_call.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf_lsm.h>
>  
>  /* dummy _ops. The verifier will operate on target program's ops. */
>  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> @@ -496,6 +498,169 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
>  	return err;
>  }
>  
> +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> +static void bpf_shim_tramp_link_release(struct bpf_link *link)
> +{
> +	struct bpf_shim_tramp_link *shim_link =
> +		container_of(link, struct bpf_shim_tramp_link, link.link);
> +
> +	if (!shim_link->trampoline)
> +		return;
> +
> +	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline));
> +	bpf_trampoline_put(shim_link->trampoline);
> +}
> +
> +static void bpf_shim_tramp_link_dealloc(struct bpf_link *link)
> +{
> +	struct bpf_shim_tramp_link *shim_link =
> +		container_of(link, struct bpf_shim_tramp_link, link.link);
> +
> +	kfree(shim_link);
> +}
> +
> +static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
> +	.release = bpf_shim_tramp_link_release,
> +	.dealloc = bpf_shim_tramp_link_dealloc,
> +};
> +
> +static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> +						     bpf_func_t bpf_func,
> +						     int cgroup_atype)
> +{
> +	struct bpf_shim_tramp_link *shim_link = NULL;
> +	struct bpf_prog *p;
> +
> +	shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
> +	if (!shim_link)
> +		return NULL;
> +
> +	p = bpf_prog_alloc(1, 0);
> +	if (!p) {
> +		kfree(shim_link);
> +		return NULL;
> +	}
> +
> +	p->jited = false;
> +	p->bpf_func = bpf_func;
> +
> +	p->aux->cgroup_atype = cgroup_atype;
> +	p->aux->attach_func_proto = prog->aux->attach_func_proto;
> +	p->aux->attach_btf_id = prog->aux->attach_btf_id;
> +	p->aux->attach_btf = prog->aux->attach_btf;
> +	btf_get(p->aux->attach_btf);
> +	p->type = BPF_PROG_TYPE_LSM;
> +	p->expected_attach_type = BPF_LSM_MAC;
> +	bpf_prog_inc(p);
> +	bpf_link_init(&shim_link->link.link, BPF_LINK_TYPE_UNSPEC,
> +		      &bpf_shim_tramp_link_lops, p);
> +
> +	return shim_link;
> +}
> +
> +static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
> +						    bpf_func_t bpf_func)
> +{
> +	struct bpf_tramp_link *link;
> +	int kind;
> +
> +	for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> +		hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
> +			struct bpf_prog *p = link->link.prog;
> +
> +			if (p->bpf_func == bpf_func)
> +				return container_of(link, struct bpf_shim_tramp_link, link);
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +				    struct bpf_attach_target_info *tgt_info,
> +				    int cgroup_atype)
> +{
> +	struct bpf_shim_tramp_link *shim_link = NULL;
> +	struct bpf_trampoline *tr;
> +	bpf_func_t bpf_func;
> +	u64 key;
> +	int err;
> +
> +	key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> +					 prog->aux->attach_btf_id);
Directly get tgt_info here instead of doing it
in __cgroup_bpf_attach() and then passing in.
This is the only place needed it.

	err = bpf_check_attach_target(NULL, prog, NULL,
				prog->aux->attach_btf_id,
				&tgt_info);
	if (err)
		return err;

> +
> +	bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> +	tr = bpf_trampoline_get(key, tgt_info);
> +	if (!tr)
> +		return  -ENOMEM;
> +
> +	mutex_lock(&tr->mutex);
> +
> +	shim_link = cgroup_shim_find(tr, bpf_func);
> +	if (shim_link) {
> +		/* Reusing existing shim attached by the other program. */
> +		atomic64_inc(&shim_link->link.link.refcnt);
Use bpf_link_inc() instead to pair with bpf_link_put().

> +		/* note, we're still holding tr refcnt from above */
It has to do a bpf_trampoline_put(tr) after mutex_unlock(&tr->mutex).
shim_link already holds one refcnt to tr.

> +
> +		mutex_unlock(&tr->mutex);
> +		return 0;
> +	}
> +
> +	/* Allocate and install new shim. */
> +
> +	shim_link = cgroup_shim_alloc(prog, bpf_func, cgroup_atype);
> +	if (!shim_link) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = __bpf_trampoline_link_prog(&shim_link->link, tr);
> +	if (err)
> +		goto out;
> +
> +	shim_link->trampoline = tr;
> +	/* note, we're still holding tr refcnt from above */
> +
> +	mutex_unlock(&tr->mutex);
> +
> +	return 0;
> +out:
> +	mutex_unlock(&tr->mutex);
> +
> +	if (shim_link)
> +		bpf_link_put(&shim_link->link.link);
> +
> +	bpf_trampoline_put(tr); /* bpf_trampoline_get above */
Doing it here is because mutex_unlock(&tr->mutex) has
to be done first?  A comment will be useful.

How about passing tr to cgroup_shim_alloc(..., tr)
which is initializing everything else in shim_link anyway.
Then the 'if (!shim_link->trampoline)' in bpf_shim_tramp_link_release()
can go away also.

Like:

static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
						     bpf_func_t bpf_func,
						     struct bpf_trampoline *tr)

{
	/* ... */
	shim_link->trampoline = tr;

	return shim_link;
}

int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
				    int cgroup_atype)
{

	/* ... */

	/* Allocate and install new shim. */

	shim_link = cgroup_shim_alloc(prog, bpf_func, cgroup_atype, tr);
	if (!shim_link) {
		err = -ENOMEM;
		goto error;
	}

	err = __bpf_trampoline_link_prog(&shim_link->link, tr);
	if (err)
		goto error;

	mutex_unlock(&tr->mutex);

	return 0;

error:
	mutex_unlock(&tr->mutex);
	if (shim_link)
		bpf_link_put(&shim_link->link.link);
	else
		bpf_trampoline_put(tr);

	return err;
}

[ ... ]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index aedac2ac02b9..caa5740b39b3 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7264,6 +7264,18 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>  				reg_type_str(env, regs[BPF_REG_1].type));
>  			return -EACCES;
>  		}
> +		break;
> +	case BPF_FUNC_set_retval:
> +		if (env->prog->expected_attach_type == BPF_LSM_CGROUP) {
> +			if (!env->prog->aux->attach_func_proto->type) {
> +				/* Make sure programs that attach to void
> +				 * hooks don't try to modify return value.
> +				 */
> +				err = -EINVAL;
nit. Directly 'return -EINVAL;' after verbose() logging.

> +				verbose(env, "BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
> +			}
> +		}
> +		break;
>  	}
>  
>  	if (err)
> @@ -10474,6 +10486,23 @@ static int check_return_code(struct bpf_verifier_env *env)
>  	case BPF_PROG_TYPE_SK_LOOKUP:
>  		range = tnum_range(SK_DROP, SK_PASS);
>  		break;
> +
> +	case BPF_PROG_TYPE_LSM:
> +		if (env->prog->expected_attach_type == BPF_LSM_CGROUP) {
> +			if (!env->prog->aux->attach_func_proto->type) {
nit. Check 'if ( ... != BPF_LSM_CGROUP) return 0;' first to remove
one level of indentation.

> +				/* Make sure programs that attach to void
> +				 * hooks don't try to modify return value.
> +				 */
> +				range = tnum_range(1, 1);
> +			}
> +		} else {
> +			/* regular BPF_PROG_TYPE_LSM programs can return
> +			 * any value.
> +			 */
> +			return 0;
> +		}
> +		break;
> +
>  	case BPF_PROG_TYPE_EXT:
>  		/* freplace program can return anything as its return value
>  		 * depends on the to-be-replaced kernel func or bpf program.
> @@ -10490,6 +10519,8 @@ static int check_return_code(struct bpf_verifier_env *env)
>  
>  	if (!tnum_in(range, reg->var_off)) {
>  		verbose_invalid_scalar(env, reg, &range, "program exit", "R0");
> +		if (env->prog->expected_attach_type == BPF_LSM_CGROUP)
> +			verbose(env, "BPF_LSM_CGROUP that attach to void LSM hooks can't modify return value!\n");
This is not accurate to verbose on void-return only.
For int-return lsm look, the BPF_LSM_CGROUP prog returning
neither 0 nor 1 will also trigger this range check failure.

>  		return -EINVAL;
>  	}
>  
> @@ -14713,6 +14744,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
>  		fallthrough;
>  	case BPF_MODIFY_RETURN:
>  	case BPF_LSM_MAC:
> +	case BPF_LSM_CGROUP:
>  	case BPF_TRACE_FENTRY:
>  	case BPF_TRACE_FEXIT:
>  		if (!btf_type_is_func(t)) {

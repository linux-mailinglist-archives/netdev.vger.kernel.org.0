Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5998C53D5E8
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 09:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347363AbiFDG76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 02:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiFDG75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 02:59:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB05393C3;
        Fri,  3 Jun 2022 23:59:56 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2546FCS3011498;
        Fri, 3 Jun 2022 23:59:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DbvJLoEiSagii7Hhl44PbF+xNLSs1HUzumK5CIqWk6E=;
 b=aSrkcSsdIlWOEYlahdZlfEx4i/b0DROXKJ3eBJmqCpiw7XPuKbkjVyGD8W2Rcs8tVE08
 zHRLt2IzAaGdPeRvW849faNjgjaGdN8PXq8x7nsXqnlaUP6TZPmFo2FDy5enHnxl+ozP
 NTLBaRM3QHFw77h2bYqsVfoEkzqZUcIFiBY= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gfyjvgewy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 23:59:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmPKLXFroUXDAa4pwwqg3KrhPw25MLDGhSdyF+CoaKBHFLfEhmHU27e1Ld0JEdknG3XwFUq9VVDDvoGRGLsrAC1gIbr80NgDK7RWkAdImHGdEdwRJgIn4cFhvty9VMkLtuhknGiMHVf56NCtzhyzQYoUBl/84BRoQUNW9fCWBy2PkMjgpkgtxBTKCkU23jx15UJZpoG7yXOLODmCm8veSupwUuTLV4K6ex/WKepb/KjI/8OrFQq9ZqBnKVs1zP+DqZf4KNaePhtahzN4FWD/9/9bD75elP65mo2BsheAEwBgYd7nLbrw4fFwgsdOaG5TtmmGgTmZJK+iSuBTviztlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbvJLoEiSagii7Hhl44PbF+xNLSs1HUzumK5CIqWk6E=;
 b=ijbJfRj43a0STkVDrF9AM2IQoUNTzqepsSENM7k6OqJcfxEQTvTyGyyxXajcBvVtmW9wQVlYGgBG+sxn8797qMi9D5Zk8/kzIu/8dxaKQZs/xxJ/NgBHjs1OPNUyO9vKSbeInXIi6kvUPZNSgUZel9cDubV9OW8Exy6M0blPqxsv7/QCGvZi0EVDt/9r5IzOu9I/mn5TwECiNhFq1iGVpY/JJkTsc0lmOtErPo0CkY9hZdKyhXVthOIoilNxP3y9xh82j8ZsK77AV28xzAxbSGDXNNV9hgyzNtlO3sVG5yvvJOjdKSWZUoR0t/VM67k5P20pES4BBaS0xp+aBeBUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN7PR15MB2227.namprd15.prod.outlook.com (2603:10b6:406:89::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 4 Jun
 2022 06:59:38 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 06:59:38 +0000
Date:   Fri, 3 Jun 2022 23:59:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220604065935.lg5vegzhcqpd5laq@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-6-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601190218.2494963-6-sdf@google.com>
X-ClientProxiedBy: MWHPR14CA0039.namprd14.prod.outlook.com
 (2603:10b6:300:12b::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d67d7bf-7dba-4b1b-1484-08da45f7ca3f
X-MS-TrafficTypeDiagnostic: BN7PR15MB2227:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB2227AA0628AB0E82121C994BD5A09@BN7PR15MB2227.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8VZjfD4QX4HwQu8xynGdy1Gbq60KABxkHwdoXGTNUQVF2ogq7vb/faubFL8R0l9IHS5HjdHJuN/qqaOZPr13lWtO4Yzihm4S5R5x0n9QIUk3Jh9++94n2MyiN5K9aJjxZeW6PZDl/Qs+1rCk6QOutM8wiD3pcrbrQuiZUwuICfUyhkQCRv9q0XT1Uw8u85WWe3PY5mA6/RRVIVbezewZwk9bs9l+F781zOHor9FXJNYUnkBw07IukRkaVTbMxJziyM522+E/2lnkdWkZnLkqbR6AnnMTA4QcSlwaPJKzU33IE5WJDHIqpzbivs4tzIwBdPRv8ajzuXYDHZ1KCY7bcleIKCRYY+Y3+yeo/se6p1Yidd9uUuXFSrxMjxaX5kphGfGjoYZXBECU4vdrsK1XJymsNqMT8PZQGUjM23mCXu9ZFCcTkoqqJPYxTCN9I0pgX12zy3xoe4jghk2l9M63+uf0j9V1mDuEDD0RNUizFHn9No62pxZxkPDf1iWWmzyisYhax5HlpyDXrE4pkh0BcqYgwY9pav1pRAL5HxhiuS3WBYKw2w+iGh92+JJUFk2it6/lhZxq0wzs8+u7tC8EK/ZiUk9q89yHm5sVLCWFIsVNE6sCNxhucMLCxY4Hzi/Nsv9qp7OqMAl9eHbJY7VAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(1076003)(2906002)(186003)(9686003)(8936002)(5660300002)(6486002)(6506007)(52116002)(83380400001)(508600001)(6512007)(86362001)(6666004)(8676002)(316002)(33716001)(6916009)(66556008)(38100700002)(66476007)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PUrg1tiDWuwjKGOTjqWWdbmHQssdWe3gKtvUkubc9lrpXLLEvt9N/OVyUF7k?=
 =?us-ascii?Q?rUSiEdr3dcnIoWf6kQto53FpC1/8lWcP7Jx6HwpHGbADPMEy626b2Ia6avqz?=
 =?us-ascii?Q?mkPX/fBOn/v6pvGGZhr/oLfzOtdOMD3iiJNUNOKDtjfdldyUmsRXL+Pmejrg?=
 =?us-ascii?Q?aXHUIUy5v5lecyAggiwRWYZUdkHH+gLGMVZgksyioyyJNWIW/V6/7Lcm0XLM?=
 =?us-ascii?Q?ky/g4iALUmf5LOVpQ1yYE0aU7MD+eNB916Wbdv95YHiF8gZV83aohrAOMIgo?=
 =?us-ascii?Q?R6JwXPv3q0pyp0uIOqDjfbNZKfLo1jP4rJVTCwkPz8v7+zVvrU0Gn+7l6cZx?=
 =?us-ascii?Q?xRDrAwkZT+tIoa9FZ3bg7/fpCj9CcoNq1Kj2SUzhG73T0rJ1DeHe3M7WyghN?=
 =?us-ascii?Q?op9zL2P/kAS7ATyCT1Rd1K0cbEoF9tUzCIh4tD5M/wXRjSh70+2k7Ti7/nan?=
 =?us-ascii?Q?yBGJiv7cah54JrLGBn3LsEPHA12PmRtOt6hMhKKrjQGfF1b/0NW7SxgAe9aQ?=
 =?us-ascii?Q?UVpf1jZUKr4XtJNi+v2vIN0lkzQ3cWheAjjgCilEVHwfnq7SAhOdV3EsljiZ?=
 =?us-ascii?Q?slP+GYMnC3djDYBuc567NxmH0t5erp9vmhqqMIsGWrTtkOhzHCHgFBHfIveN?=
 =?us-ascii?Q?TA1QIIIA4LhKoV1lb9tqmY7MFtLwz5GCXVojZYO59nkPIwK0v2EQuEWTtA6j?=
 =?us-ascii?Q?Q79hTqmLnJFjZeKVUQN6RTxbjIBtPrhgCDlOwOVC6RUF4yK33348zuKnewdC?=
 =?us-ascii?Q?cYbJ2d3CwU2+rp7lDQ/I5JOWGCdUqN+TGTl/rgpgXGFp9yx/tnIJuY+4oi3c?=
 =?us-ascii?Q?ADtxJdkE3rx2gskOCeAi4S8fkhBAr2nxBRam9pa0GBnoB1lnFO05xjYbIrkA?=
 =?us-ascii?Q?sYGKyhuoJUWFh9D8dH8jfWLqiheTc5KjLq8Bx6LZXlNkpuz2c9Sxmj2d3zqx?=
 =?us-ascii?Q?0SS2aFRPc5OOx5gI6+qC8NpTqKO22pJGBkHKuSpIhJIzFgH5Av3JSfMPRLvk?=
 =?us-ascii?Q?0cCrr1Q0yj/VnJ27MXeOP/1BYMyZbiFqalO7lb8up8sWKacePs8KycWaGpyJ?=
 =?us-ascii?Q?cZAGgweYpWXAvL9zeFiWzrQdysrCo6DTfkaDg13b2lmtBxQ9Eu52tR6xngzX?=
 =?us-ascii?Q?arcom/15MSBxeyXW5IGCOqUtzbG/i7wpAgzuo+6VcLdvNjOKelZcgWLvHe+A?=
 =?us-ascii?Q?wkbh4LRMawWMFaOn2xDnwNHrOdnTvHSLuNg3z/cxpqlFK9QlCM0YpGzBZ0Cm?=
 =?us-ascii?Q?6+f+6Ozluu1GGy8AGhvJ3ZobMwBls+U1QtPv2zeuOTjrI83bUhmIPivUManX?=
 =?us-ascii?Q?2SHMuddFpKArNJTSWqpzz9Cr81XbBuCDifkcoL7K9hTYJhvkl56GWQstPziK?=
 =?us-ascii?Q?bO0G27d5BfK/k/XUOjw63EOc3v3V/X4fNyw7ElOW5VzSnPqJyYiJLfdSAqEG?=
 =?us-ascii?Q?/egCnPhk/FHNatPHTC9DCuVlPKtznUnU3lL9wFZAyUS8VqtTdfkDv6VyBiKw?=
 =?us-ascii?Q?nnOQDtOYntywtWENT4Azod8Yy6vexO7uZrwPJDx/kOT1PQZpwcXEU5ET88Ss?=
 =?us-ascii?Q?YCH1uWgX20u2pxPAgZeWAi2CtVFON30hRnIe95WQWULj4rIEmLytxnsRtJ3a?=
 =?us-ascii?Q?LhKXWuiJJIIrrzTvUIJAFzkQhaKa2ZCzhmZR0YoFUpuxumUqrBOxqcCC1h1H?=
 =?us-ascii?Q?fMO/QkbPDypx93Q+EeXPu7PucNjCgMq/40n+NpXnzD5ohgTfQ9WtrAul4pNr?=
 =?us-ascii?Q?H/TqEvtmAGIttPMj7CvPzrLyrFPiCuM=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d67d7bf-7dba-4b1b-1484-08da45f7ca3f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 06:59:38.0748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 453KadYh0XxxCvL98tI1EburnfC+X6M7Ikn+NG/fOjvxLlQsygpYFqJ2rUbOFrQW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2227
X-Proofpoint-ORIG-GUID: kfZ2uXWHtbjg05EPF-S6JPV7e3YT3wFn
X-Proofpoint-GUID: kfZ2uXWHtbjg05EPF-S6JPV7e3YT3wFn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-04_01,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:02:12PM -0700, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index a27a6a7bd852..cb3338ef01e0 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1035,6 +1035,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  			      union bpf_attr __user *uattr)
>  {
> +	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
>  	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>  	enum bpf_attach_type type = attr->query.attach_type;
>  	enum cgroup_bpf_attach_type atype;
> @@ -1042,50 +1043,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  	struct hlist_head *progs;
>  	struct bpf_prog *prog;
>  	int cnt, ret = 0, i;
> +	int total_cnt = 0;
>  	u32 flags;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	enum cgroup_bpf_attach_type from_atype, to_atype;
>  
> -	progs = &cgrp->bpf.progs[atype];
> -	flags = cgrp->bpf.flags[atype];
> +	if (type == BPF_LSM_CGROUP) {
> +		from_atype = CGROUP_LSM_START;
> +		to_atype = CGROUP_LSM_END;
Enforce prog_attach_flags for BPF_LSM_CGROUP:

		if (total_cnt && !prog_attach_flags)
			return -EINVAL;
			
> +	} else {
> +		from_atype = to_cgroup_bpf_attach_type(type);
> +		if (from_atype < 0)
> +			return -EINVAL;
> +		to_atype = from_atype;
> +	}
>  
> -	effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> -					      lockdep_is_held(&cgroup_mutex));
> +	for (atype = from_atype; atype <= to_atype; atype++) {
> +		progs = &cgrp->bpf.progs[atype];
> +		flags = cgrp->bpf.flags[atype];
>  
> -	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> -		cnt = bpf_prog_array_length(effective);
> -	else
> -		cnt = prog_list_length(progs);
> +		effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> +						      lockdep_is_held(&cgroup_mutex));
nit. This can be done under the BPF_F_QUERY_EFFECTIVE case below.

>  
> -	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> -		return -EFAULT;
> -	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> +			total_cnt += bpf_prog_array_length(effective);
> +		else
> +			total_cnt += prog_list_length(progs);
> +	}
> +
> +	if (type != BPF_LSM_CGROUP)
> +		if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> +			return -EFAULT;
nit. Move this copy_to_user(&uattr->query.attach_flags,...) to the
'if (type == BPF_LSM_CGROUP) { from_atype = .... } else { ... }' above.
That will save a BPF_LSM_CGROUP test.

I think the '== BPF_LSM_CGROUP' case needs to copy a 0 to user also.

> +	if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
>  		return -EFAULT;
> -	if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> +	if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
>  		/* return early if user requested only program count + flags */
>  		return 0;
> -	if (attr->query.prog_cnt < cnt) {
> -		cnt = attr->query.prog_cnt;
> +
> +	if (attr->query.prog_cnt < total_cnt) {
> +		total_cnt = attr->query.prog_cnt;
>  		ret = -ENOSPC;
>  	}
>  
> -	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> -		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> -	} else {
> -		struct bpf_prog_list *pl;
> -		u32 id;
> +	for (atype = from_atype; atype <= to_atype; atype++) {
> +		if (total_cnt <= 0)
nit. total_cnt cannot be -ve ?
!total_cnt instead ?
and may be do it in the for-loop test.

> +			break;
>  
> -		i = 0;
> -		hlist_for_each_entry(pl, progs, node) {
> -			prog = prog_list_prog(pl);
> -			id = prog->aux->id;
> -			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> -				return -EFAULT;
> -			if (++i == cnt)
> -				break;
> +		progs = &cgrp->bpf.progs[atype];
> +		flags = cgrp->bpf.flags[atype];
> +
> +		effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> +						      lockdep_is_held(&cgroup_mutex));
nit. This can be done under the BPF_F_QUERY_EFFECTIVE case below.

> +
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> +			cnt = bpf_prog_array_length(effective);
> +		else
> +			cnt = prog_list_length(progs);
> +
> +		if (cnt >= total_cnt)
> +			cnt = total_cnt;
nit. This seems to be the only reason that
the "if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)"
need to be broken up into two halves.  One above and one below.
It does not save much code.  How about repeating this one line
'cnt = min_t(int, cnt, total_cnt);' instead ?

> +
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> +			ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> +		} else {
> +			struct bpf_prog_list *pl;
> +			u32 id;
> +
> +			i = 0;
> +			hlist_for_each_entry(pl, progs, node) {
> +				prog = prog_list_prog(pl);
> +				id = prog->aux->id;
> +				if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> +					return -EFAULT;
> +				if (++i == cnt)
> +					break;
> +			}
>  		}
> +
> +		if (prog_attach_flags)
> +			for (i = 0; i < cnt; i++)
> +				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> +					return -EFAULT;
> +
> +		prog_ids += cnt;
> +		total_cnt -= cnt;
> +		if (prog_attach_flags)
> +			prog_attach_flags += cnt;
nit. Merge this into the above "if (prog_attach_flags)" case.

>  	}
>  	return ret;
>  }
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index a237be4f8bb3..27492d44133f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>  	}
>  }
>  
> -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
>  
>  static int bpf_prog_query(const union bpf_attr *attr,
>  			  union bpf_attr __user *uattr)
> @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
>  	case BPF_CGROUP_SYSCTL:
>  	case BPF_CGROUP_GETSOCKOPT:
>  	case BPF_CGROUP_SETSOCKOPT:
> +	case BPF_LSM_CGROUP:
>  		return cgroup_bpf_prog_query(attr, uattr);
>  	case BPF_LIRC_MODE2:
>  		return lirc_prog_query(attr, uattr);
> @@ -4066,6 +4067,9 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>  
>  	if (prog->aux->btf)
>  		info.btf_id = btf_obj_id(prog->aux->btf);
> +	info.attach_btf_id = prog->aux->attach_btf_id;
> +	if (prog->aux->attach_btf)
> +		info.attach_btf_obj_id = btf_obj_id(prog->aux->attach_btf);
Need this also:

	else if (prog->aux->dst_prog)
		info.attach_btf_obj_id = btf_obj_id(prog->aux->dst_prog->aux->attach_btf);

>  
>  	ulen = info.nr_func_info;
>  	info.nr_func_info = prog->aux->func_info_cnt;
> -- 
> 2.36.1.255.ge46751e96f-goog
> 

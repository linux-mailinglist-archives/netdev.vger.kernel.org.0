Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9171BD1BF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgD2Bc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:32:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50694 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbgD2Bc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:32:56 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1Ousk004542;
        Tue, 28 Apr 2020 18:32:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=krNNozXBOQwCzGOu0ANkTpnCQ1a7Pm80Ien8ddpUhrg=;
 b=Rbg8n16Uk6GnFaPPtVx5wZMybu7go7A+0iKR27zUhdAbspU3QB9Lf8nco3SfuZ+U8RXn
 5Wl2dAboWp6TrdLBRjlS1NtMkMOuqFT2y0nuJkD13MRi+cGyywDb52B8bX5Gog8d9fvd
 Kq4YfNVHDuZfHyTlnsJ3VPT+4n1x04qWOeg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53x9vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 18:32:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F14A4OGfU3tTGBQJ4tk7quDHaMjsCxiKapMMG6xlq/qmmVCO8oMtZt+kS6dv+5dDN8On+/dSGZ/rbPsS5yOa3Rx/Niw2W+p8w3dLiwXSikBwqw6KZUhqAH1lbEwXfSeo5h7pjkCGBXvx+4UlfGQhJ3BTp/2NAd0vXdLVhpGtC8vIbucTfZLolCS4y45vIfLRjpCOljP/zQeFWUPZA+bS8u3f8o6TM8bf7svRyOa+M0kDVFh5A6IapK75+/Tjso7tMnwlpCCBggFw64yvP19uVBi0nk07p5SOHddjrRzEckW13t3IwyM2rMLNDYrWOmTX95iXZ8ey4TdEs0H3ho5FFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krNNozXBOQwCzGOu0ANkTpnCQ1a7Pm80Ien8ddpUhrg=;
 b=ZYFxX1L3/LekN57wFjA7cA0cv3U9Q81ax/ByzrYA1FXb6/IaueKOM8yj5uYVuvq9QR9lqL3UMOlQ8TxDx/L2ccA36lGQ2HitOWlRWiwzj0NcgLG/ZP+f4xrdQhafEAD+obo/nXQmU2EEgR5vJuMDaXobw8InGaC2P1T5kHNEjmP6+Hj5UNoqr/jJPZfW16/SAOdhdRdYsINrL4FI0kLM+/nveU/ctKBxVdEgYH1Q/WnU4L0BaHqshMnLJ4JjrYn/x7Czhffmrv4TLR+10yFaNyESxy6zysGH3LMyGQ7XfRU1mLxae4rb9tWFCiiNYce+WYSYLx1xCk307bO7NbeIQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krNNozXBOQwCzGOu0ANkTpnCQ1a7Pm80Ien8ddpUhrg=;
 b=KEAaIRWwWXO/ZkAo1sBYfvz9Pp4bX2RFUVNQ7c6BCU6DKGXQ47Ftq+1vCRblKIqXL1JUD5hVawxi9lctWW2gmoQi2U6tN6x6ZuXAGOp6rHbacSmgiSX+jG5bb54R4iORu9LMG84zCu44yDvK/vAzVg+2YH7pJ7v12Ls8W4ZEfSQ=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3756.namprd15.prod.outlook.com (2603:10b6:303:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 01:32:41 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 01:32:41 +0000
Date:   Tue, 28 Apr 2020 18:32:39 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 06/19] bpf: support bpf tracing/iter programs
 for BPF_LINK_UPDATE
Message-ID: <20200429013239.apxevcpdc3kpqlrq@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201241.2995075-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201241.2995075-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:300:12b::13) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:950c) by MWHPR14CA0027.namprd14.prod.outlook.com (2603:10b6:300:12b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 01:32:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:950c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38cad773-7b98-4eeb-7c75-08d7ebdd3522
X-MS-TrafficTypeDiagnostic: MW3PR15MB3756:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3756D68D0914C9F82239AE14D5AD0@MW3PR15MB3756.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(376002)(346002)(396003)(39860400002)(16526019)(8936002)(186003)(55016002)(5660300002)(8676002)(9686003)(6496006)(6636002)(1076003)(52116002)(2906002)(66556008)(66946007)(66476007)(316002)(33716001)(86362001)(54906003)(478600001)(4326008)(6862004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E4YxSzZVc/FhmEOjRninidJ+edXuKV6gBfomzUHysp81/hCVo6DFmj8qWl5Hktlx291QLVY9Wjx5bavbJ0AD7oK7hZGQFYH5+C5bb7XxhrWkWqzeRcFyqdvlvmzZm/h2gFrlbwUn3AtbUm22fEyD1Rn4Ga4xAKeJMMZu2ICxTW0rbF4EXPIFQAUnIlLwbmtx16TD9ONCXWl5CpYDxflQW1qPT5iAgxnhgAAPpSsX+XU9tQsQuz57wOuNDpn/sLI0mgdc5bl0Y2OsCN7CDpx1w2VmPtPoDKEMkERHH4ShynD2dKZidSWOyveuzhOa+k/MST5/cZjwkN4Aij/KQKOaSX3W/tirl3EeDmMlSIRcEBhslv/qLS+JzJrFI2y1/K1oeoca3afHorBKIdfooAERkMlGKXu0zau7pNK299l/AxHP/SUZn4jFie82M3VlhNQu
X-MS-Exchange-AntiSpam-MessageData: SAWjXmIJuGNi8dB1CnpKAfYqJz+6vrjRd9w74ZtsJGegBcV5/l6m0ou4KF/+uRPqHP2v1H8jZsu1fs4tMKMlZqAtIGXiR16HzdEtr902mV/ErXCHa2t8TsEqUjsR2Jcao704A0XNjZV2Vr+TbrS6wKQuLFcxoR37byRWafEA/K6bRtuVUqvls8PzN675vy5bU6zEL+sH0U7Cx5xJMQ8t+DoFvCM2Xj+ne59wA+WMHSG3L1HuQMf7Xrx0zpt6w4crWr1f7Z7ACRaGOF2n/w2uqghmgK+qP0B+QFt3OHWv/bIzppV0oIpLhZLWAy9nyk6gdqQ5sSyTi5jkEH4x8KwwolEi+tb7uS8ar6Xq4HP13EbOzrx2eb7fqsK+asZiMKCM3LZ9ZgO0+PGRJb2qpEjTbtivTbWaxd7BEpPzOlIKSC6ta8JQxQu/wZ1kFc94ZEZc+1KCyIubzkYZADCanldJHD5uTNZ1HHrj8wd5cYHblWnmY76Hgy8Jk9J8NffAxqaWdXe9urJDv9B17qkk3xg/LnjOIfhL2UtGO3656EO9N/EAyit1WWcbAzEUaAtFTT2hyB6b4IHDHNWuTVUFgka05K8UNbxy0GhztfCWZQI3oFw0VMigsbXd0Q/ewnEx4xRTEK2TE0EHx8zW2qBVvBUCx3K4bmFCh/ApUsS+PjCsaEthK1wUP4J2Lb9Xt85R5XrE4jXiw/q0eYLIcYEtgXEGmi9/A0WMfoDctx4lfaAGtJ+r5WYgBNp5qkIdyOEq+m1lwQ5D2YXPu6DYPBref71+lkUPekQMRUqsTcqNvND6mm/CBv8CcUZvr9AvYbc3ND1HIi+b0OrkUVkOTw48GrMTwg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 38cad773-7b98-4eeb-7c75-08d7ebdd3522
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 01:32:41.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApDxAFavWxLZ/oA9xdRJ1AW9dhDxXZYEH1N6dws+s0JL+KIXbxt3unF2ZIOVVPI6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3756
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:12:41PM -0700, Yonghong Song wrote:
> Added BPF_LINK_UPDATE support for tracing/iter programs.
> This way, a file based bpf iterator, which holds a reference
> to the link, can have its bpf program updated without
> creating new files.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/bpf_iter.c | 29 +++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c  |  5 +++++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 60ecb73d8f6d..4fc39d9b5cd0 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1131,6 +1131,8 @@ struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>  				   u64 *session_id, u64 *seq_num, bool is_last);
>  int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>  int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> +			  struct bpf_prog *new_prog);
>  
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 9532e7bcb8e1..fc1ce5ee5c3f 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -23,6 +23,9 @@ static struct list_head targets;
>  static struct mutex targets_mutex;
>  static bool bpf_iter_inited = false;
>  
> +/* protect bpf_iter_link.link->prog upddate */
> +static struct mutex bpf_iter_mutex;
> +
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  {
>  	struct bpf_iter_target_info *tinfo;
> @@ -33,6 +36,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  	if (!bpf_iter_inited) {
>  		INIT_LIST_HEAD(&targets);
>  		mutex_init(&targets_mutex);
> +		mutex_init(&bpf_iter_mutex);
>  		bpf_iter_inited = true;
>  	}
>  
> @@ -121,3 +125,28 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  		kfree(link);
>  	return err;
>  }
> +
> +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> +			  struct bpf_prog *new_prog)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&bpf_iter_mutex);
> +	if (old_prog && link->prog != old_prog) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +
> +	if (link->prog->type != new_prog->type ||
> +	    link->prog->expected_attach_type != new_prog->expected_attach_type ||
> +	    strcmp(link->prog->aux->attach_func_name, new_prog->aux->attach_func_name)) {
Can attach_btf_id be compared instead of strcmp()?

> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	link->prog = new_prog;
Does the old link->prog need a bpf_prog_put()?

> +
> +out_unlock:
> +	mutex_unlock(&bpf_iter_mutex);
> +	return ret;
> +}

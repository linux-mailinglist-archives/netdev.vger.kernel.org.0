Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AFF26BBDE
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 07:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgIPFhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 01:37:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbgIPFhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 01:37:45 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G5K5IK017919;
        Tue, 15 Sep 2020 22:37:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8CaQ+IKqF2UlxZj6FX5+BW3GTlnADwzDP3qEldeYyR4=;
 b=P6DNe++C/M0MNxVf3UmbrYYu3wJumhP0Agp3FgeQuw3Fokpuiv5GXQfPA2TKBIU6hKPm
 ggS4r//fP7zBE3ftq+KzB5m6Yov0ha6IUHsNLojmpyEPtPQ6wKNBQc3563Flc73jrgYv
 vsneKlaKwj6KiBZwOKx7N4CxPrEwvUaWxs4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5nbhrjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 22:37:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 22:37:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMvTOldKX+TxIMo4BRPrx70RLrOvLv1eILEbaOH1+AbUOIp4C0r1nwQvz+Bz8+/MTkUOkNNfWq6d/KRgrUdX1R4/9aCkPx4t6CSQYyc32GoPicOp1xFuLHEXTdJms+M7MqXaeFIvJPwfvav1K2v0bvZthYrTLl03XFzvkaJVuwv6neyuwQuIpgSQthoRyunLvG65ERb26tCOu9RRI630YR8DSTnnWOy6eG8yHyOmaTwonLNVx94u5M2NfVqcwaVhOiJ1g21oSi4v5wYX5Frm3P7muU71t+UAxUbdP0q3YsOYsZVAVN+8PUxNCZTxLoEqrxryySWbND5lGKjZlf8UVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CaQ+IKqF2UlxZj6FX5+BW3GTlnADwzDP3qEldeYyR4=;
 b=nqqcSjjqLb2wK8S7JHQGsSIBt5d/qkYSr1a7ffcQupjlJWhsKClEp1t0hPN9j2SqsQWwHTkS4apX7HHENEujSgET6stj++5yUCD+k12lRUtWXVYyDmwym9EVVJEcLLPhr0C/LX85/s63YUA3U2HG3EEfOYIz1/s2424ZGtcmmXCQr4XhAm1t5MLYA8h+KwAIVWMHYgvIiM/Vqul2nDnI6Clfe9GmMLs9ndBCe3bZWrgnQhZDSuWg/f/Qxe8Wj+F2XrEDS3mVuw3VuEjUFGnwEU/C+CErBxsfGs/7j+KeeO1NnmG3cirI00ADuzTQfjp2yRSC683CkQLd3tCK5KSu5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CaQ+IKqF2UlxZj6FX5+BW3GTlnADwzDP3qEldeYyR4=;
 b=QVE+7isvj4yL7eKWfF5vJCenq56og1vC9JQCxjhkIcbueqcHoc2mu0p4bPSIsP8vGCUTNgFqqVGcxFbPeUe0n2Wf/YaPTB4VqQDYEQYWq1Yf7zYDek/z9rvicsvXL74Ve3lUGhQfRjFkybHaVCdX0F+/UnnwKnDSa5uU3DSXhzE=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4120.namprd15.prod.outlook.com (2603:10b6:a02:c4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 16 Sep
 2020 05:37:27 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 05:37:27 +0000
Date:   Tue, 15 Sep 2020 22:37:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next v2] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
Message-ID: <20200916053720.zzdaasvxoqptyb2a@kafai-mbp>
References: <20200915223507.3792641-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915223507.3792641-1-yhs@fb.com>
X-ClientProxiedBy: MWHPR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:300:95::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:5643) by MWHPR13CA0034.namprd13.prod.outlook.com (2603:10b6:300:95::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Wed, 16 Sep 2020 05:37:26 +0000
X-Originating-IP: [2620:10d:c090:400::5:5643]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83713523-a2fd-40fa-0ebd-08d85a0298a3
X-MS-TrafficTypeDiagnostic: BYAPR15MB4120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4120C77B2217BBA36494BCE1D5210@BYAPR15MB4120.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pi1t/4jFL/1ZWKQNY6iu0lKQVWXYACI4e31a5wfotGhLdye60SA4LSECMWYpQ8XDPap0FxmaoSWAQ7L1opzsCmUaYtZuAdl7SorBWfzaxtEOPblyJLOCLktuULfK26K2Pb+ZUQeckIMTzjJk+Mo45hpafsFvr/GV3YcB+GrJTpWH1lovr/Dq9QQjluqG0BiaJAYCyFcgJZL7F6Qg/PZOx6gFnbuKKQJyu1W4qp2YV0Xuk5lEORWmQlYMCeC8TuZVFLYda+ZjxREZonjZ7kv1JPeMW5JfsZqogrejpulqo77yceOmmtT/aeuADVPTBAfpZWu1gZcgNgMCpYP9fdBldNeawuDYrfJUhKg1tOwHTOxMpMEN+o8l5n5Ra4VEKFkQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(376002)(136003)(396003)(4326008)(478600001)(33716001)(6862004)(9686003)(55016002)(5660300002)(6496006)(2906002)(52116002)(316002)(1076003)(186003)(16526019)(6666004)(8676002)(6636002)(54906003)(8936002)(66476007)(66556008)(66946007)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AjagOWaPtJMooWrhQ9Kv+rl68lKwWIaGCdBuMasAJsWNx4sCfLTS9xvV+GWhb7UDCF/mT//2XkOoyucDQzsyuTdOaqBAFn/2kA7BUTTnQn0a9FMbcqq99r54SKb7PxgTih5uKFi6SIgYXbRu9rY0ra8QnkhZqYca4vbnyckYHdK/2XeLiBj+AihNq+CjzsR6F74ApmPsfiOqUpr4oqmr9TogNMQhx6XBl8lO8Icsd//ZwLqCjZDAdKoAzphnhFsJaX3dVJJWIjb0GxFO9J5A9ZHku/X0z0IKVivoPWIuWWRAR5iPZnGIKY2twKXtDQGETa3dw6b256RPFZep9t7nmJJJrskhESyj6Nq5BiGFaC3KwR0Kz81D6UuAg4OVxA86vbB9fKpIceg78+HpaJ/lYOH8JXrwhRXYkSrV5zBG8NScLiypGnRSCJg1e3BPV69gF6AN/ZV7KVb24ODoI+b1LWcaVYHpEYKI5ttAssuPh5l4FkAcPf8c29s96gcWPZrwvQ8hZpF7PvYnEVHaGnXxsDixEcYnn9CELVByf9eW9ehuJgHsVTk6e4Xe9eCXsoH8O8fb7ctiKm5ezNZNlmr1cwkpcyhoNrHstUkr/nFfllQbBjHbsnm3SIG2NzfuIEdbEBrCFxPwU6vaKW+TyR6ZXRh1v0MbqjU2Kxm8I15Tmi8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83713523-a2fd-40fa-0ebd-08d85a0298a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 05:37:27.6209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSmQtHeViZiTvZGQGC3Cdkh220Y2om8XLlQvw0sJigcslJSs41jz/k5AOpVuVuCV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4120
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_02:2020-09-15,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 03:35:07PM -0700, Yonghong Song wrote:
> If a bucket contains a lot of sockets, during bpf_iter traversing
> a bucket, concurrent userspace bpf_map_update_elem() and
> bpf program bpf_sk_storage_{get,delete}() may experience
> some undesirable delays as they will compete with bpf_iter
> for bucket lock.
> 
> Note that the number of buckets for bpf_sk_storage_map
> is roughly the same as the number of cpus. So if there
> are lots of sockets in the system, each bucket could
> contain lots of sockets.
> 
> Different actual use cases may experience different delays.
> Here, using selftest bpf_iter subtest bpf_sk_storage_map,
> I hacked the kernel with ktime_get_mono_fast_ns()
> to collect the time when a bucket was locked
> during bpf_iter prog traversing that bucket. This way,
> the maximum incurred delay was measured w.r.t. the
> number of elements in a bucket.
>     # elems in each bucket          delay(ns)
>       64                            17000
>       256                           72512
>       2048                          875246
> 
> The potential delays will be further increased if
> we have even more elemnts in a bucket. Using rcu_read_lock()
> is a reasonable compromise here. It may lose some precision, e.g.,
> access stale sockets, but it will not hurt performance of
> bpf program or user space application which also tries
> to get/delete or update map elements.
> 
> Cc: Martin KaFai Lau <kafai@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  net/core/bpf_sk_storage.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> Changelog:
>  v1 -> v2:
>    - added some performance number. (Song)
>    - tried to silence some sparse complains. but still has some left like
>        context imbalance in "..." - different lock contexts for basic block
>      which the code is too hard for sparse to analyze. (Jakub)
> 
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 4a86ea34f29e..4fc6b03d3639 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -678,6 +678,7 @@ struct bpf_iter_seq_sk_storage_map_info {
>  static struct bpf_local_storage_elem *
>  bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>  				 struct bpf_local_storage_elem *prev_selem)
> +	__acquires(RCU) __releases(RCU)
>  {
>  	struct bpf_local_storage *sk_storage;
>  	struct bpf_local_storage_elem *selem;
> @@ -701,7 +702,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>  		if (!selem) {
>  			/* not found, unlock and go to the next bucket */
>  			b = &smap->buckets[bucket_id++];
> -			raw_spin_unlock_bh(&b->lock);
> +			rcu_read_unlock();
>  			skip_elems = 0;
>  			break;
>  		}
> @@ -715,7 +716,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>  
>  	for (i = bucket_id; i < (1U << smap->bucket_log); i++) {
>  		b = &smap->buckets[i];
> -		raw_spin_lock_bh(&b->lock);
> +		rcu_read_lock();
>  		count = 0;
>  		hlist_for_each_entry(selem, &b->list, map_node) {
hlist_for_each_entry_rcu()

>  			sk_storage = rcu_dereference_raw(selem->local_storage);
Does lockdep complain without "_raw"?

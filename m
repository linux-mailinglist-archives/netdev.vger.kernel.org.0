Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9924B3A341C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFJTfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:35:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8766 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhFJTfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:35:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AJP5eP012181;
        Thu, 10 Jun 2021 12:33:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=QXGtkAohf/WkVK9iJqIYeYMwcRQxkBp93G/IjcXr72I=;
 b=JFB7M6DjU4ibtmbYlMnbNz4KLH89g9bqpvATQQEY+AZZ7SVP8fV+v9A11lUIOCEm3nLO
 S7q5GzKo5sEO8HtzemNUE0scT6tYcdz323mrF0mbO/bSHVH89p5oY3Xot3hPpSs59KN/
 7kpFsuuBDDzeqPVXs45avSK42/oFyb1Dj+o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39379g5s2s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 12:33:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 12:33:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ej1HydkJgK2GkM9WYAXj8uoxJRuuol4+32stgCkuNq985O89QBo2vhvZ+Er50IGktHkzavaizMQ/JjzU0zMpnhyI48qxziZGxiHwBX409b6zu6QQPdHmb96y2qBd7CssqlDzZjiWHEnlmYvBFh0ADfcLYJmpMcDC1OVkMQa037+IU0aKw9SHVf3HhLFIBjLhZy0AcbFUiXL0JvlH+7vBSvl/7rn+osZGxyC6WAX55Zf4i5zhycjCe2AVOyXERbFl4J3ap1FkagVmWiJlawTsykp01djyzt6j26JepW9ujSaUCiXTEYzuFIrEw8MzhjphQymTSePgta5XGI+i1kpitA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDRD5tu7pBRpk3BylzSLItkGE7EeJd2YbH9WzmYTXHI=;
 b=DRi2JwFfscs19lifRJLxclMPvIC+R38IBnsW3JHAP+rC7JJH4NBBgWQSPTV3yN87Ll7tzlEJmBRHQpylIMV5ugWVUfGv6KlN/KCs7aCGU+0RBMEEa0yO/i27T2UkQNfm15O9BSSTaWrPNc2D2uMqjc435K0EykCKvN3mlpieB4Um9HzfeMDpDUbz7/rClgdNAU4U7IDUcYyCsGDvnPd8oXCaUXY4Hl66qbX20noKiYgpv2U7+CQIEa3niAiJJZOagHF/ZZ9TQcHQh6/PTXAg5TiTKMTj2cFYQzLgsnbvJDrN/2D6kDnURfgRsHs0DMi+3CMw0D0RSuAgsMf0sDHKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2398.namprd15.prod.outlook.com (2603:10b6:805:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 10 Jun
 2021 19:33:30 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.031; Thu, 10 Jun 2021
 19:33:30 +0000
Date:   Thu, 10 Jun 2021 12:33:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 02/17] bpf: allow RCU-protected lookups to
 happen from bh context
Message-ID: <20210610193326.p6x3t2c26jitsjob@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-3-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609103326.278782-3-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:6314]
X-ClientProxiedBy: CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:6314) by CO2PR04CA0139.namprd04.prod.outlook.com (2603:10b6:104::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 19:33:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bc935b7-d64b-43fb-4e5e-08d92c46a04f
X-MS-TrafficTypeDiagnostic: SN6PR15MB2398:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2398FE4C965E5DD2CFDDBF21D5359@SN6PR15MB2398.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRVEZRL0wrNaFreKF9wqCVKGQ2TfoCnF66gaNv+rKVyzKU3prn0IN1qAEntxvnarQ02vIT/CobVEyHNhLOPBL+vRNvua74+ZecncFvXWICdtySMwT2BKGrkTgavjFDF+DeHFvxf9exNdrr48pM6O90cYq0PLWKhMo0/zqzfQ1OZUntkQZM7bjZw9VkYhA+0p+CIxpooBPVMVbu0Z3A/wDyc0Ofx2b9l+oBOhhFb+eVWbBxGvq34Ms1hovK3UpJIpm6ZJrPRfjgydSO/IAmrgjKMei9C+vACiiFxJIMwdmJjb/ZQQ3YkwAr9oB6/CvM9XKCIDLBG8JFLE9MXcdFfSo8hzYpw6lzvZ3+bqxoAwel/zaEKHlBHAzUdG8Jw8WeuTjpSznVgaRLX33aSDDBjDwHSm1KAD++M4YY/MvuPL5HfX/Wx95Awc6DWjhNn0h/SLOQViNb013ZQnwgjSqGLaoe00/n1fIQ/9TwgcAqvpNdp2QZFC/6JT+0xQhlJTJ5rkXInbBuxuspxyxdZOBFviQrFxYjofqDmtSPxwDb/wbRhQQf9L12TdvK/n12C2wGviKfE5fJNIoaP5D36+1IA+LR+IKrxSKce0xOlB92y7Z0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(38100700002)(83380400001)(55016002)(4326008)(2906002)(86362001)(6496006)(9686003)(316002)(1076003)(33716001)(8676002)(478600001)(66476007)(66946007)(52116002)(16526019)(6916009)(66556008)(5660300002)(66574015)(8936002)(186003)(54906003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?gjl6SGQtlYT7CJd2f4yYFMzIlplpOBmfXq1xeQna1a2rmSyJiJtghgP8nK?=
 =?iso-8859-1?Q?VO83oog2Bp/5goXqfuKuexXpIsGXxoIXDMyUncpNnN2FR1n2zunZMX7enS?=
 =?iso-8859-1?Q?JGbtKCMG6VzTW6jcrSzbYBrSHfOnrw8Wyjq01zEke15iDal5upOnKBaImo?=
 =?iso-8859-1?Q?HoN2HxeIQHhhRqLlhZ9g78gbDvs4PXXc8wGZ0Cg/8bRva0V9eBcWxJZqWZ?=
 =?iso-8859-1?Q?V/qb8KyTlR6tN4UILEopqQfgTe0IGzGlzSB+roQPCFBfMNOSd1Y16N5aVV?=
 =?iso-8859-1?Q?jz/Nl4kKCwsWDRe9+P/KF+MGmcLUlKkDTX7gBbXMkWLov2IKp1BpcYDUu8?=
 =?iso-8859-1?Q?HGGfvulQ7SULThwPJLpKHQ2FZvltqbPukA1Lwcg621OLUinLkrh9Kv8qFD?=
 =?iso-8859-1?Q?+d9dEd0YOXrTrXKO35kJLQiBAh/KOgz1wcHGd+y/MfyCzIJ+NicXZT6soN?=
 =?iso-8859-1?Q?WeGgdmMZkBC0Uw5FJgaTx2HaKESVanQ9SpXWWU6ucG/RTgzXM/9vQc1Vg0?=
 =?iso-8859-1?Q?tRR6UF4aXCPA7pthmY3/mBoQH+ANXTWXOVpzrsJCtAI3k4btpdvwGPdxkd?=
 =?iso-8859-1?Q?6QmNGs5WWmPsxPHJzLyceOT67EK8MQ4QU8AC1wDmU7Y+AS15kIaCU+VQvZ?=
 =?iso-8859-1?Q?f530slxXIRMLOo9Jax8CQg36SahQAMV9XOZpxhjglrb5vn1U+PPkBVufu3?=
 =?iso-8859-1?Q?86SiALMiU6jtSUT6/tO9uIo9UhH3boxSdZU377OOwdoAl/E1zPUfiNa4Ju?=
 =?iso-8859-1?Q?UGb8kImfS/XTwJ2ZROkoLKm8M6pcupfOK6ilbZ8DGM3Dk22hlp2y9M9pcr?=
 =?iso-8859-1?Q?INDufqnLtEKIt8CHa4uK+YLcg0CT5l/4egI9MtZdwhkihaRgvB8BK9aHjw?=
 =?iso-8859-1?Q?HDbqPNxv8PS64HqG+pKcqbP8UzD5ODk9ouJRqwPoG07/WMD85WQum9FKs7?=
 =?iso-8859-1?Q?JCDyveu6WlBqZnDC9pgSP2REcbpJbTHuh86TtinKA5lmyT01PJO5jRoYeO?=
 =?iso-8859-1?Q?OQlCirzMRR7uX6/Wp+GB8nFzE2YyW4xREYgfK23/M19RykGiEeMTv1PvCH?=
 =?iso-8859-1?Q?Uqzlf+IZx22f9PAee6lAnvMDEdNZpSoNoGuSN8qYKF/7tEa18IuppBuRz5?=
 =?iso-8859-1?Q?szYxCmPryYEnf5qoSFIRATQT1pja9oTIWCBUC6xPpnr9APRtOYLUFWBfUL?=
 =?iso-8859-1?Q?PKUG8EE2TTlX7TjteKh1lzh2cJJyVsvJ60ruWlnwCaLRpgO/IGMrLsr0tF?=
 =?iso-8859-1?Q?NZnaWcc+STIZTkgW6Ll8rLfeH8pn14p0EaTvHTmo9rBk1WNl82L/p01+CM?=
 =?iso-8859-1?Q?/aVdkIHyIYhVQvg6tp8GBEcBnZPclqMe9qIf1Vi4UPlKON8li/m4ReTnhx?=
 =?iso-8859-1?Q?71ew6vBweBug/RKYHf/1080xzmBr85iQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc935b7-d64b-43fb-4e5e-08d92c46a04f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 19:33:30.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5EbzTfIAt677yH0cOGPFD1DHxeWWkEr5Bqjrg1QZKBz0lTCqYgQSykrkRt81wy8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2398
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: la8GdHwdtQjNgjpPq9nFjcoJtN6KGVtx
X-Proofpoint-ORIG-GUID: la8GdHwdtQjNgjpPq9nFjcoJtN6KGVtx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_13:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:33:11PM +0200, Toke Høiland-Jørgensen wrote:
> XDP programs are called from a NAPI poll context, which means the RCU
> reference liveness is ensured by local_bh_disable(). Add
> rcu_read_lock_bh_held() as a condition to the RCU checks for map lookups so
> lockdep understands that the dereferences are safe from inside *either* an
> rcu_read_lock() section *or* a local_bh_disable() section. This is done in
> preparation for removing the redundant rcu_read_lock()s from the drivers.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/hashtab.c  | 21 ++++++++++++++-------
>  kernel/bpf/helpers.c  |  6 +++---
>  kernel/bpf/lpm_trie.c |  6 ++++--
>  3 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 6f6681b07364..72c58cc516a3 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -596,7 +596,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
>  	struct htab_elem *l;
>  	u32 hash, key_size;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> @@ -989,7 +990,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>  		/* unknown flags */
>  		return -EINVAL;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> @@ -1082,7 +1084,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
>  		/* unknown flags */
>  		return -EINVAL;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> @@ -1148,7 +1151,8 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
>  		/* unknown flags */
>  		return -EINVAL;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> @@ -1202,7 +1206,8 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
>  		/* unknown flags */
>  		return -EINVAL;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> @@ -1276,7 +1281,8 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
>  	u32 hash, key_size;
>  	int ret;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> @@ -1311,7 +1317,8 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
>  	u32 hash, key_size;
>  	int ret;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
> +		     !rcu_read_lock_bh_held());
>  
>  	key_size = map->key_size;
>  
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 544773970dbc..e880f6bb6f28 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -28,7 +28,7 @@
>   */
>  BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
>  {
> -	WARN_ON_ONCE(!rcu_read_lock_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
There is a discrepancy in rcu_read_lock_trace_held() here but
I think the patch_map_ops_generic step in the verifier has skipped
these helper calls.  It is unrelated and can be addressed later
until it is needed.

Acked-by: Martin KaFai Lau <kafai@fb.com>

>  	return (unsigned long) map->ops->map_lookup_elem(map, key);
>  }
>  
> @@ -44,7 +44,7 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
>  BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
>  	   void *, value, u64, flags)
>  {
> -	WARN_ON_ONCE(!rcu_read_lock_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
>  	return map->ops->map_update_elem(map, key, value, flags);
>  }
>  
> @@ -61,7 +61,7 @@ const struct bpf_func_proto bpf_map_update_elem_proto = {
>  
>  BPF_CALL_2(bpf_map_delete_elem, struct bpf_map *, map, void *, key)
>  {
> -	WARN_ON_ONCE(!rcu_read_lock_held());
> +	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
>  	return map->ops->map_delete_elem(map, key);
>  }

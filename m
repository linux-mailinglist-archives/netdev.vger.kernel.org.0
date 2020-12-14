Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBC12DA1D9
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503218AbgLNUmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:42:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52440 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503465AbgLNUm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:42:29 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEKdrqh030817;
        Mon, 14 Dec 2020 12:41:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UZm3JKGtWaE+taU7YYgTDLo1FQpIfWs7INQjzXdF9A8=;
 b=LBF7fFgB5rPGxqmMwtLA4ca5KvDTa/nPsJcl7D+qt5hjAMuHiQsonh096EQWFyognoNq
 5OtTKYoqYXeEGtEiMeqIaAMRM+nq8TsbvwLLwMxaVog9jPc+w5no5fKc6mCOz42D3kA6
 QyhL0Q6/cTIOVIJdZh1Yoh+W1fdJmaknnbI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35cv8st4th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Dec 2020 12:41:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Dec 2020 12:41:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGP0BSUv7OfEhpkKat/JzJfcxThYOKKpIYGxe4whuobyP0Q7YrvvuMHlZJGH62CtfC0UUTCqzey7Yc3UTuu7/2ZAylTHix/41iWqu0Izf6jzB2ViwFaw9vynjGfSobk+TLdQFIy3IlSmxr2E5c7K2ywmUMKITF/ew7TbTyVzvrQik4HfLT2rI/YVbwgm+op0IfhBKMYgZAK/eUWVAdHNJclBbUHtGCBI3X7OCpjvU083+6vuKRslhburQgBc90G87nxvf+hDhge5QYIVyDYgwdruWKlzsMBF312ZE7/bQZoXg3atwtQw3obGDQv/SYH+VZ+IiWPUr8YFicuMw2Hc3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZm3JKGtWaE+taU7YYgTDLo1FQpIfWs7INQjzXdF9A8=;
 b=etT2AHfQmrD+lX8j+qlER9516MsV6cOxK3JKt/NejJMqekZ2upCbiNQDLQc8rIYfOWB/GMB5/fTegDzEkKFtwaDYynkm95BShK5FShDMxgC3hgLmieY60oJvZu65+4TnCCry/wBNdpRD/cQ8AAXohUlNjsDvZJTWrWLp399v/8GJPHNVWTqne3boNJLK4HIQlvKFNdKIbCmMobFnruNToj3hDdsYHQ8IXi43eOEqQdhXeeQ1ZBBB4+wQidILliQ1fWiY8unkzJAU+EPRLznS8N6wwjK73gs6h1Bbf9nM5oDwKursRwC+PEudhCUg5R3NKR5MERG4HbvLrszE/odfqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZm3JKGtWaE+taU7YYgTDLo1FQpIfWs7INQjzXdF9A8=;
 b=VLJHVtuoUP63aGE3ubW5UDfOLWQloV6hERbMN8Xtf56aQwabdw3DkmcyJyKSj3jQ2W6ifXAU/h3RVVH4tev5G/BThGQEEc4cQg6sQkp+ccjQCmAuhXoU1Tntl2GJ5WsuI+PgvkU8zR0HGIm2SzdSj4pTmj6ZBoPQl0021zsUk4Q=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BY5PR15MB3668.namprd15.prod.outlook.com (2603:10b6:a03:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Mon, 14 Dec
 2020 20:41:33 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 20:41:33 +0000
Date:   Mon, 14 Dec 2020 12:41:31 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: Re: [Patch bpf-next v2 5/5] selftests/bpf: add timeout map check in
 map_ptr tests
Message-ID: <X9fN+wQkSpYGuCfl@rdna-mbp.dhcp.thefacebook.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-6-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214201118.148126-6-xiyou.wangcong@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:f622]
X-ClientProxiedBy: CO2PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:104:6::22) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:f622) by CO2PR04CA0096.namprd04.prod.outlook.com (2603:10b6:104:6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 20:41:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e03df2c3-76cf-43b8-35d4-08d8a070a4a7
X-MS-TrafficTypeDiagnostic: BY5PR15MB3668:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3668FD9055754097622BAC5EA8C70@BY5PR15MB3668.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AqnEpXUIuMH4TgdGoIKprfAeXSnAQ2Ek3F1grx6GCC4ANl6IGihFKpGxU26fskt7o+qyNxF8CnYuWasVXeLRzg+qKOhaKpnyTivrdrDSHXZHpUoXYGnB3pF72ACDXJudwUWogLMLfOFu/EMUZ4ooi28SWBnLTQSCZYX8T9SnGgiMKEVjL5E5pyIaYyZtFPdD8WHJJegJzQ5YuEYLzdg8U3rjEPtmrww2/vnUbOmUQl8YyiD1LIEeEZ9uXs2OSrtACp7By8Fd4Y0DoEImJIgpuZD1TOhEqtmC0we1aIDQFKAI0EeIYcoLr49hwpdkQr1OQZqF4uTsnKX3u1EyxzeqY4ubzly+88naaaWQ0h8rr+Al7d5qGH2uILKS00WIrhFI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(5660300002)(2906002)(6496006)(66556008)(54906003)(66476007)(66946007)(86362001)(186003)(4326008)(508600001)(16526019)(4001150100001)(52116002)(8676002)(8936002)(83380400001)(9686003)(6916009)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OU9GSXlBWlVBYUZORFcvZ3dNbVRuNml6blJLWmlySWRoZ0VQQmYvbXZRY2cr?=
 =?utf-8?B?OWRyL3pGY203ZHMvYSsxelhJNnZ0MnNiRmRnVjJOTDg5RkwrU0VSWFdsNFNR?=
 =?utf-8?B?emdDb3grRmtTd3lNdGFVQUlyR2tOUnJqaXhSTUhMdEI0TGt5WVNNSjdXcUF6?=
 =?utf-8?B?T1c1c01rUE5iay9sNi9pakphcUpRbnByV2s1ZmtXZlM4MlBzQk5LNHE2anIr?=
 =?utf-8?B?Q2ZybS9VNkF6YUVlQkZWMWR3REd2RlJITHUyMktBbDNwZ3g1TnpONmR1cmpt?=
 =?utf-8?B?TS9SOUJJVG5vQzNNbnI5Syt5RHJKdW5HcW1jeHgwc2t3UFpNZDBvMzExR1RS?=
 =?utf-8?B?STlFNnV0TEMwOGxZYmdvZlJraVNwaFpNRFhXUjR2SUZ4MU85TDlIWFMxTjhZ?=
 =?utf-8?B?MEJ4ZzdHODFBZUc0UUtveVczSEFOaGVrdzQzNUxZUUZtS0hqYVBtNmZFTVl1?=
 =?utf-8?B?Z2s3VVlvWUREUmt1aklNQk41WU9KS0RYeGMwUEJRUTFVU1V3NFpBRHZMN3BM?=
 =?utf-8?B?Mkl0dDN5SUZ6c2FLMDVReTdZZHo2MzZGQ1YxWTZDMVBRRDhtUmNxdnZiZDYw?=
 =?utf-8?B?LzJEblZOWFJISmNsRFd6NzJTU21qQkZCL2NTN3loY08rTnpVZFhsSkNIQnYr?=
 =?utf-8?B?aEVidUtTTXlSNGcyYmsvV2l5Z1lZeTNESDI0QU43MTM3TlQrTG52QnNNeHRo?=
 =?utf-8?B?aVRJNkozempTUi84TGJMdGNiRVZXVDg4eHRLM2Z0MkZycTVCNFFqek9KNFV0?=
 =?utf-8?B?UkhaNUwvYjZlbDd6ZndBV3NPYW1aZjZuRS84U1FCcFNqTU56VFo3cWdFZXRV?=
 =?utf-8?B?K1NrcVAwV0xQOWVEOGYxM0NOSUhYRXE4YWpCcytYSG9tNFFYa0lYQ2VHci9M?=
 =?utf-8?B?ZDdmdGZ3VGt1S2YyNkJQUStPYzhVMk45V2JNSVZJQzJFbUdEaDNzVkNWTUF4?=
 =?utf-8?B?L0tmcElDWm5NNUZtclJBcmp3VFlmSkRreElSdDBUWnRxdnZGckkzSkp2OC9Z?=
 =?utf-8?B?ZFRCS25aakwvUitrekNuYmRpMXQ2YmtHb1R6aVFKUEw3cjdQbForZU5veW5U?=
 =?utf-8?B?KzJaM21qYkFCT0s3eE1SSFZMOU5Dek9zc2p3amYrV1VOOVBTb1pCZjhKVUhz?=
 =?utf-8?B?eWR6a0o3S0loeGF2bUpacmk2WitjTTJ1WXU0bFV1clRqcVBrM0xaTU5hQWND?=
 =?utf-8?B?TnpoaVJXeksvT1ZoVUpaYWhsYldWcVBjbmFUbm95YzlsanlEQVhiSmZ3QVdq?=
 =?utf-8?B?N3NhcnA1aWVaM01GaWllNy9OUG1qbm9rWndTeUkwYW9jM3Y3WGtHcWoxMDk4?=
 =?utf-8?B?Nm9kRFMrYlBjQ2JEZDJDTzNkcXE0WTAzb2JiTDA1VVVUNnc0a0Izak9NMGhx?=
 =?utf-8?B?OGRROUFwVmlUd3c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 20:41:33.1708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: e03df2c3-76cf-43b8-35d4-08d8a070a4a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N13z6NKegoXgeTGqMOoqQJpHse+Eg5PNHNCWG6Fk69/A8dTH7u+EEs0a4U1Oq8lH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3668
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_11:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> [Mon, 2020-12-14 12:11 -0800]:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Similar to regular hashmap test.
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Thanks.

Acked-by: Andrey Ignatov <rdna@fb.com>

> ---
>  .../selftests/bpf/progs/map_ptr_kern.c        | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> index 34f9880a1903..f158b4f7e6c8 100644
> --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> @@ -648,6 +648,25 @@ static inline int check_ringbuf(void)
>  	return 1;
>  }
>  
> +struct {
> +	__uint(type, BPF_MAP_TYPE_TIMEOUT_HASH);
> +	__uint(max_entries, MAX_ENTRIES);
> +	__type(key, __u32);
> +	__type(value, __u32);
> +} m_timeout SEC(".maps");
> +
> +static inline int check_timeout_hash(void)
> +{
> +	struct bpf_htab *timeout_hash = (struct bpf_htab *)&m_timeout;
> +	struct bpf_map *map = (struct bpf_map *)&m_timeout;
> +
> +	VERIFY(check_default(&timeout_hash->map, map));
> +	VERIFY(timeout_hash->n_buckets == MAX_ENTRIES);
> +	VERIFY(timeout_hash->elem_size == 72);
> +
> +	return 1;
> +}
> +
>  SEC("cgroup_skb/egress")
>  int cg_skb(void *ctx)
>  {
> @@ -679,6 +698,7 @@ int cg_skb(void *ctx)
>  	VERIFY_TYPE(BPF_MAP_TYPE_SK_STORAGE, check_sk_storage);
>  	VERIFY_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, check_devmap_hash);
>  	VERIFY_TYPE(BPF_MAP_TYPE_RINGBUF, check_ringbuf);
> +	VERIFY_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, check_timeout_hash);
>  
>  	return 1;
>  }
> -- 
> 2.25.1
> 

-- 
Andrey Ignatov

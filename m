Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56804306339
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343971AbhA0SZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:25:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42928 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343918AbhA0SZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:25:33 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RIFTUH018281;
        Wed, 27 Jan 2021 10:24:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=eb5LjODtRqPySZzlDVLd7vp5QeN4OeBiKkynQWTsg1I=;
 b=NBC/LgMl62xZjfKYUVdISdZ0z177vJxciegbNTSsqHwv/kXkEEMtojmhKGUGpXT92ddc
 BOdKks8rIfoIzUqDjmk8CsN8kMmy/WvsWU/yzYxRIxuJ5b5hPUu+bJtbcFeMNUdqaGK4
 g6t7YAehw4589mUrdQIxW1E8/AQra4C66cA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36adeu1x3e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Jan 2021 10:24:35 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 10:24:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVNNoRrLArZO1yv1yINpV1WxpSTr1L1FU2KCr+CLShLPPrLU9ZheF2NGKa4nRX2w5QlMGRSHInL5sc8pXj61iF7YghJbiDFUA8UCLN0sYaFFwhTbUTL0gLZLbXi0e8xuyTErN+v0d2kT0QBl+AZcj0Z019dApkf4Bx9cI8gQFpM4T5dlz0jzYbLiRA7oxlrkVAju1zvILpcP0j03kYfU2Szl0TFsKEQELhSju0/kUkTrhmVd7VLSrNb9mH9SLvxXOPlzixSrGe/cuejn4Xc4ziWpiXJRtOYKC6WqM/qymMWo6xt8I5q9fBCiV1ZE/OoZgOJljrm6X6j3XoW0yAZ+Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eb5LjODtRqPySZzlDVLd7vp5QeN4OeBiKkynQWTsg1I=;
 b=k8fjGZ3WsBTKkLiaI04wjQTzCuK/kGhm1ArMvZN0xWJq+Qc5DhC00eSBU3+ha4vO6DE+thp0hA/NeOFlxjUFnYFnZdbdwOihT9dUS9UJpFSbDOTNCeBAWtxsMFhpzTccVHLc2UeIKsg3eeH2L7z2lqIULOWAGqQ5zd+U7unxm0/OMEqnrk+oZaRw/6Q8viKVJSYkwfjKvVFcnnRSG3yH5wttolu48MmPGwv57rGlX4KxG4soUW2demq6GGxY9NdEC6DIQiowwOYV263QZ0SCXTvBijISEZXgIvyJFiWPQTGD8w8NSusw+65UsU+H2HEMoZu0dpQ9g+Kfi5s6MasjEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eb5LjODtRqPySZzlDVLd7vp5QeN4OeBiKkynQWTsg1I=;
 b=AfhHVWmo/X404uTWfh3DuL0ByJq+iG0oBgbb8sfhNoyStEcMjIE+5C5Bm83huOaUOZypdZ/PLLLULFjFPvnwti99BvmMUy/d+N965vPoxAkYroFhZMJDtI5oqAsp5hg4zA2UOaoh+5zxJda26ElrkpxkgYJxZXqgaXOwU1wDtqk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 18:24:32 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26%6]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 18:24:32 +0000
Date:   Wed, 27 Jan 2021 10:24:29 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <YBGv3eYgNQrYBuEl@rdna-mbp.dhcp.thefacebook.com>
References: <20210126193544.1548503-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210126193544.1548503-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:485e]
X-ClientProxiedBy: MWHPR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:320:31::15) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:485e) by MWHPR18CA0029.namprd18.prod.outlook.com (2603:10b6:320:31::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 18:24:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a516a203-1e01-4017-62e3-08d8c2f0ca9e
X-MS-TrafficTypeDiagnostic: BY5PR15MB3620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3620BC68C9042496350A1AF6A8BB9@BY5PR15MB3620.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/M87XGiu4dMZWEaEZsQPtpD+bhN7DUBEWX1+G5YT413QRb3fQO/s8zgbQ3nE5Ge3dVxhidtlgSkHYFNS3M/2GIqw2HS3T1TvPaZEggR2cvz1dOGIMqkpNSp+WoSHjfQfk7lMi2Jr2EjI48k4FDlazXo6Pj/+eAMqJuA3IWfVJK2C82g6GNwTw+hy65JcXOlebyQzkRTJXLyjBGPawMSYg5pxpmT8t4uVCLMaCDpfwcobdwb7FU/0ZU73T9zLSc1EokCsgraG2CTr0EMkhQWuNF6AVnn0CllsvTjLYJ/wtNme8Xf70OXS1yb06KMxxDJmAM5T3OyshETlfl1GQ7KCKdkjeyav93PYalM6HKIhfr7i6gTUOaWMqH0qU/BgazkI6xrpQzJzQ0wqmF9s5jTOxusSwBXo470ZRuL/yR7uxowpCPDg1Wb2edbsqO1RffgzhaP78nWWdOpQSCChXB82pArfsoqYMUlnkDQMww+OV6WusVMCqNNgBYFgYS/7BYGykfGKp3TDOkKTVdAUwzXVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(186003)(9686003)(8936002)(4326008)(66946007)(83380400001)(478600001)(6496006)(8676002)(86362001)(66476007)(316002)(5660300002)(6486002)(2906002)(66556008)(52116002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?amtTTlYweE95cVJTVExIUEt6dHk1VFo2NEUwbWZsL3pENkx0VnVIWGNBSitB?=
 =?utf-8?B?U1k2U3JJMWxBTWZCS0JvQmF1TW83WmxvM1VMT296N1BKZmV5ZzV6eDdncnNa?=
 =?utf-8?B?aWRuM2ZZUitZMWt0dlVSN0MyVEFIenlpMDMvcnA1RWhaMzhQN2tkbjdKRmQ0?=
 =?utf-8?B?RmJrYWtXTnVjN0wvb2RUQitoZlBPdCtRNHZZeWtHczExOTFQbE5kWDhUelRa?=
 =?utf-8?B?MVVlVGlkOFBDdmlaUVpIVmZuQkxUbEkxL1h2eEZNbGNnRkt2ZHFjcC94OVQr?=
 =?utf-8?B?aVBNS1EvMDEzQWVqc29pbm1meVRIYmFuWE5YQ1FPRnFRaldUMHlqT3ZvM3l2?=
 =?utf-8?B?NTluZkRhTFQrWncwY21LWDAwKzhDQ3hoSXlxYkh0QW9kcnloc3RNeWJWMzZ5?=
 =?utf-8?B?VThjN3c5TksrZlBlQVplaElWNGVnZndxQjgyTmJ3dENuOW1WY3RjTFhRTWtN?=
 =?utf-8?B?K0hpb1k3Wlk3QWkyclB2ZDBxMHN0MEY5cmErdTM4NXlWMXl5eEhIOXNNcU9v?=
 =?utf-8?B?S1BJQWNCWTNrUWtKNDQwOUc4a2pOcndLWG9sc2NZU0ZrVDhuVWtYY3dHWFZt?=
 =?utf-8?B?QllsRmxRZ0pvVkJBV2M4c0lMaTNhRzh4TVlNRldLaVpqcUJOVXd2USthN1M4?=
 =?utf-8?B?WEtsOGltWGVWSndaNXRjQzhLZXRZSmFTd1BNVGM2bDdoRFUzUG1WdXEvZDV5?=
 =?utf-8?B?Zi9SSjNnVmZVZXRvSHc2ZVJMcnNhMTJ3UTlJOGdkblNzZ2J0NGdjRGxWNTgr?=
 =?utf-8?B?aXg4ck5iZmNnR3EvKzg5R2J4ak5pcWs3KzI1THB2cjl4TW9ocEYycEYxbjFV?=
 =?utf-8?B?Mk4rcWs1WjFZZGdVTC9JTm14dGJOTng0MVZnYWU5SGUzM1Z6MFFnVlNiUktE?=
 =?utf-8?B?WUhtNFF6NVlJVDhDSzBOVXNjWG9PUW1zWFlXcFM2U3M4QXJremF4QkZpN29S?=
 =?utf-8?B?Wk41bVl0TmZqQWdFMGd3MHRZTUlPRXU4TGtMdW5NL1J5eDhPOEZTVHRNcjdC?=
 =?utf-8?B?a1I1QnFuT0RLVC9qaDFuYldNaU1OQ2pWb1ZyTGJ5NlVmcS96R2NhNUcyN0FE?=
 =?utf-8?B?aU1VWEhGU0lLV2Fkc0gxM2MwSVB0VGlabWtRTlFRWGJUYXhZUi9HdngzVHk5?=
 =?utf-8?B?UkNiNkNIeTRsQ2JvZDMxbGZIcXFmSmpWUlpwZ2lXS2pEdXVhNjFGb29MSHhq?=
 =?utf-8?B?eXUyUWZ0YzkwK04wWUQwTkEwQklaeXpnMTgrd2s1OGRaRi9tRnJjRlVRZTRD?=
 =?utf-8?B?QlhLUGNDMkVvU2NEem9XckN1UGVuL042WDZFUHJhUFB1TmF2S0hoSE95OWs0?=
 =?utf-8?B?WHduWmdoZFRBbXBTWUNiMm9Bb01uUXZaaDUvRktNclpVL3cxUWMrMlRDKzJa?=
 =?utf-8?B?UFZzZCtscGUySGI0c3h2N3czdlh4L0p1Zi9KTXpTVzRQeUxCdE1WVDhhSVV4?=
 =?utf-8?B?cCtUc3FmSnE1OEt1c1VPL1FnbkNSTjg4ZFVhbk5KYmJ6ZHNxL2hFTmxhVjJX?=
 =?utf-8?Q?IdqiY4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a516a203-1e01-4017-62e3-08d8c2f0ca9e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 18:24:32.4120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nP+CIXYz9No/PuqhMMFAhCmCYdcBgnRRt4A4QF/XrYNL8uP6TOQYTCQrjIpHyDA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_06:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270091
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Tue, 2021-01-26 11:36 -0800]:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
> 
> Let's add another return value to indicate that CAP_NET_BIND_SERVICE
> check should be ignored. Use the same idea as we currently use
> in cgroup/egress where bit #1 indicates CN. Instead, for
> cgroup/bind{4,6}, bit #1 indicates that CAP_NET_BIND_SERVICE should
> be bypassed.
> 
> v4:
> - Add missing IPv6 support (Martin KaFai Lau)
> 
> v3:
> - Update description (Martin KaFai Lau)
> - Fix capability restore in selftest (Martin KaFai Lau)
> 
> v2:
> - Switch to explicit return code (Martin KaFai Lau)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Explicit return code looks much cleaner than both what v1 did and what I
proposed earlier (compare port before/after).

Just one nit from me but otherwide looks good.

Acked-by: Andrey Ignatov <rdna@fb.com>

...
> @@ -231,30 +232,48 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>  
>  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, type)				       \
>  ({									       \
> +	u32 __unused_flags;						       \
>  	int __ret = 0;							       \
>  	if (cgroup_bpf_enabled(type))					       \
>  		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> -							  NULL);	       \
> +							  NULL,		       \
> +							  &__unused_flags);    \
>  	__ret;								       \
>  })
>  
>  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, type, t_ctx)		       \
>  ({									       \
> +	u32 __unused_flags;						       \
>  	int __ret = 0;							       \
>  	if (cgroup_bpf_enabled(type))	{				       \
>  		lock_sock(sk);						       \
>  		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> -							  t_ctx);	       \
> +							  t_ctx,	       \
> +							  &__unused_flags);    \
>  		release_sock(sk);					       \
>  	}								       \
>  	__ret;								       \
>  })
>  
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)			       \
> -	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
> -
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
> -	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
> +/* BPF_CGROUP_INET4_BIND and BPF_CGROUP_INET6_BIND can return extra flags
> + * via upper bits of return code. The only flag that is supported
> + * (at bit position 0) is to indicate CAP_NET_BIND_SERVICE capability check
> + * should be bypassed.
> + */
> +#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags)	       \
> +({									       \
> +	u32 __flags = 0;						       \
> +	int __ret = 0;							       \
> +	if (cgroup_bpf_enabled(type))	{				       \
> +		lock_sock(sk);						       \
> +		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> +							  NULL, &__flags);     \
> +		release_sock(sk);					       \
> +		if (__flags & 1)					       \
> +			*flags |= BIND_NO_CAP_NET_BIND_SERVICE;		       \

Nit: It took me some time to realize that there are two different
"flags": one to pass to __cgroup_bpf_run_filter_sock_addr() and another
to pass to __inet{,6}_bind/BPF_CGROUP_RUN_PROG_INET_BIND_LOCK that both carry
"BIND_NO_CAP_NET_BIND_SERVICE" flag but do it differently:
* hard-coded 0x1 in the former case;
* and BIND_NO_CAP_NET_BIND_SERVICE == (1 << 3) in the latter.

I'm not sure how to make it more readable: maybe name `flags` and
`__flags` differently to highlight the difference (`bind_flags` and
`__flags`?) and add a #define for the "1" here?

In anycase IMO it's not worth a respin and can be addressed by a
follow-up if you agree.

> +	}								       \
> +	__ret;								       \
> +})
>  
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)				       \
>  	((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||		       \

-- 
Andrey Ignatov

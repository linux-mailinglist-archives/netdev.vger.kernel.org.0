Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52BB373494
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 07:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhEEFPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 01:15:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62758 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhEEFP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 01:15:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1455DnuX010110;
        Tue, 4 May 2021 22:14:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=sPev1atoLTo2uG5Dnjfy5JyLb4Mc9qvBwF6AA0RKHBE=;
 b=gBCDY9uDoPIFeILQPwI1FBqsg6V5bhWdY88t8FyGTK+UmUoyqiCx2175tLgWfvNT70su
 6uD4TpSzv/LKuDvnN4H5/0hOREjUyUeefZOMVk1E2VWaIjleHOZ2VjEoRIlq3n/AbPMA
 KWzkGUsNpHUqSwqUKZwYjyR0jMrF7ttREJI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38bedqsp6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 May 2021 22:14:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 4 May 2021 22:14:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGE3wwKSitrXur45pTRZ0Q9Vj8+x6FJIOybpaXSrc1m7PhPQQlmlPDeehan/wiADyYqUtoALEI0YpKRdl6K/HuxWK9+b2+qtpCFQC9XuFDhVgKizwyIz8qf48yoj2j17dahRUa5C6+oPTPZqXN/Jh9Xl8UpsMwEf/u6fczEXbufisk5cGFGaipNh2JnKDe9GLgzVKIq1iT0mR0Vh4oQsCY2MMlNsTZZbGooMqxvwHSmy4tNOu1HJbKU71VfkRneqITtFMFFx0R3O220oPZqxSeq4At4emwZR4mVXhsWRKcznWvZRLCm/ypt0eXKoSUoe4QSJP8EQ0Nney+xawzriwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPev1atoLTo2uG5Dnjfy5JyLb4Mc9qvBwF6AA0RKHBE=;
 b=FjlT5/zScK87KcUtXwY/hs5ihsE0jZIvwcNds8xKxfP3ctEkjy7cHEcnJBrVE/ESuFrDr1LMXxMHDeNe0vGnk615xtwqDfENoS2lsSxgxDt82wEZ/n3a+mK6UDLA9crJCOQrZgZ33Qi3T1vcrrQ4BAVxVPm026/s8nn+Wwy5sdzHgueRgmZxhVlTYtB4fLH7Nh8zqTcoo3HJOtF6YzRPrHFsdeWhxqI/xH/jGLIbpBpNJdCgoNfjE/QROivo3YEIW+4qeiw06Jd9HyeeELx+bFWCdzgj2q6q+tlQDGZHKt3K439XnnVS0LqAAuZ6pAGiDMz0s8+OypsBVRUlVx1QmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Wed, 5 May
 2021 05:14:11 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 05:14:11 +0000
Date:   Tue, 4 May 2021 22:14:08 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 11/11] bpf: Test
 BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Message-ID: <20210505051408.5q6xmafbogghkrfz@kafai-mbp.dhcp.thefacebook.com>
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
 <20210427034623.46528-12-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210427034623.46528-12-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:5bbb]
X-ClientProxiedBy: MW4PR04CA0242.namprd04.prod.outlook.com
 (2603:10b6:303:88::7) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5bbb) by MW4PR04CA0242.namprd04.prod.outlook.com (2603:10b6:303:88::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Wed, 5 May 2021 05:14:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72d84b36-6b3b-4ddc-67d1-08d90f849e29
X-MS-TrafficTypeDiagnostic: BYAPR15MB3256:
X-Microsoft-Antispam-PRVS: <BYAPR15MB325685BF1A6D63450930121CD5599@BYAPR15MB3256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsQqUOC0PbA+i14ASL/sp7YoR8xxSXmEF6iSaSv1Jt7j4ruhOd0SyGS7dQkLsdYAhXYXmYKj5mWlSnuhNxPqDgSB7oZ8mmi3+CRLAzJc2tfAxYNIAB0Xwjro5ATap5KhfX9xgOAcM7IoJuq6bHTZ4DXGlYWiO0v0gAbOBxHOGX1Sf4CxNkCTG2179mC8wP/CBNjNBnP/P3v2j4WcUfLbkCEXJjJXmCenodDR6ijMmKRv7zzodoCcQSaW0V18ViaEBMXD54Qmvl1xH6iMk0PzY13jlTXBjwxVdMJh5RoUT9i6kno/60MEKY7BBJL0rro+ZDNnhyvH/qkmi/lLOmUvaK+XHAqAB5UEKDSlP9NJ7lMNCGbuetSTMEDvDAbVOR6vUmUyjfXM6ggQqxHCwcAgAYR71pxJAh5voBC0XKNGbI4OPCQsckcK9RktGkKWbCIyKIy64RbbYWMdE8o4wo/tyZj6gWa7iyTmktM60JoxO3oJoDO2n7P20U/rK60ptLtgH40NtMzElUi0iirVQEWb+M3fvOMKLBJSiEjd/ERcCR0uZZjQ13/8VVkw/igsOfznZDnKEdMAAOtQ59SvHxwq1F0E5dttc7kCQr5+rGa6hJM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(16526019)(4326008)(7416002)(6506007)(2906002)(186003)(316002)(54906003)(478600001)(55016002)(38100700002)(6916009)(5660300002)(1076003)(66556008)(66476007)(7696005)(9686003)(86362001)(8676002)(52116002)(8936002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EvHhTAh3O6fbkvgj3ljIdXyZWqPSllRVT47ufAUb91LO0aiA9iRzJKYDUx8y?=
 =?us-ascii?Q?i7ij7SJjOCOJwXoafOn7fCdrSWppufssM+qzEjUmcBDLKM9lWFNM+RHJPUDO?=
 =?us-ascii?Q?bSh+W2FfJtNyZqIR6ktsvcvneI1WPkINMpQja6LUP4tcJwzV8q2+6ySBQlQ0?=
 =?us-ascii?Q?006rRgnPcX3b/Mugin9WUgPYTpPw5JBgogecH/LZKtdRIitCYRqQUxgSlYuy?=
 =?us-ascii?Q?/94DPW5dZz3umGTBTFGYvGM97silxV569jMYPcbaS+C94Q2vabycHFplmQdv?=
 =?us-ascii?Q?JVG5fq0Czn9FfCDqbLa1KS4RdEEviYcFMF1WW7EXQzyi46odt0vGtiHo95+e?=
 =?us-ascii?Q?8sz8/uy+ZaRnM0F0GsC9MA1BdKG8zApTctRpe7PqB3QimsW2sk9iQdDcQOX2?=
 =?us-ascii?Q?ecneNElGXZxp6Rc4z9CEvKPy7Pd55d58YxJHGuCEgcJBT2IYhoe0wDjcsg1A?=
 =?us-ascii?Q?7dHaXm4RQJx2xzT8QrnnziTBfeYYuteN1Nm3XnNWAux6OdwkeAFKr+P4ojGM?=
 =?us-ascii?Q?l1N8TxtOFi/ly7PlFB9luQ8lx+UO+QYMUjh1MgAcdVs3Tp9uq9I351louTSX?=
 =?us-ascii?Q?lknNwGxXxdImubX/FzEL9iBL3hyUszDK9Lwh4U5FrLQNqcsyWyTQP3ptRWtn?=
 =?us-ascii?Q?4m2u6r9eSpbbh/GwG3STxPpVvXtu61u3NryfcaTgCcvF9XWqFW+Iexfl8BnK?=
 =?us-ascii?Q?Si5sEM4944HlRHGjwX5Kd+UbRVswn/m3T35iXY1twL5c/8UxjO63lKtEnqZB?=
 =?us-ascii?Q?4m3gMYbWymQHPn5HXHFMbv1M0npbPNkDZUhpfkYdhCKYBB0M1VPeMYXlqXZs?=
 =?us-ascii?Q?4hZNUr4i+y0dA4PuvEEmeASyKqd3djxrslOVkbqHpFdAsC950OB+VTqzk27C?=
 =?us-ascii?Q?T8SCmlEZfVR9Acbqm/awIT+0mv//dGngos5eWje0aFMSFjgEWYs9z21Hdw21?=
 =?us-ascii?Q?uIbnMzqTqhmvubTXiTLAjM4uzh8K7EFtk8YXxIIu7DlTFvHeRkdEpcLJWhcb?=
 =?us-ascii?Q?TR67v8+DdFFgmIMOBtgVmLWJye00+qCGy1TIO8VMZjRJNSsi2myukBFu3y1s?=
 =?us-ascii?Q?+I9MYTxv92Bi2RU26TiYyM9210gDh1EbtHJTkTj/bjeUXJ/V6PSXvfX4AT1A?=
 =?us-ascii?Q?XD7XhirfAZ0HalKVg7oyrL6RzsgaHk+EycafoNceBQXqubfRlnuA6Z2mPozi?=
 =?us-ascii?Q?0nzBg1LoWPItm3Bcl3bqGqGe55vV62oe5qdSX2N16b0JBP9OmQT4NqcJzrxU?=
 =?us-ascii?Q?bjFC7Vz0nUS5UMSNS0D52pfafs1QG585pE9PWSd++C/JFLORD+XuZWBXMlAj?=
 =?us-ascii?Q?pSAsrMkSI+A5vRB0Xxjf8z//iirnSQ7nWkTsSPysngSqyQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d84b36-6b3b-4ddc-67d1-08d90f849e29
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 05:14:11.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8y2EFGSWKHHZyEBPRvAUVOxCs7DqSPIIOD17sJBowJp+K1qo9niglFzEHbZ/ZXNi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: vLsHl0i9P2Odro6OcBmtGnQ4-NhQP_HH
X-Proofpoint-GUID: vLsHl0i9P2Odro6OcBmtGnQ4-NhQP_HH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_01:2021-05-04,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050035
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 12:46:23PM +0900, Kuniyuki Iwashima wrote:
[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> new file mode 100644
> index 000000000000..d7136dc29fa2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Check if we can migrate child sockets.
> + *
> + *   1. If reuse_md->migrating_sk is NULL (SYN packet),
> + *        return SK_PASS without selecting a listener.
> + *   2. If reuse_md->migrating_sk is not NULL (socket migration),
> + *        select a listener (reuseport_map[migrate_map[cookie]])
> + *
> + * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> + */
> +
> +#include <stddef.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
> +	__uint(max_entries, 256);
> +	__type(key, int);
> +	__type(value, __u64);
> +} reuseport_map SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__uint(max_entries, 256);
> +	__type(key, __u64);
> +	__type(value, int);
> +} migrate_map SEC(".maps");
> +
> +SEC("sk_reuseport/migrate")
> +int prog_migrate_reuseport(struct sk_reuseport_md *reuse_md)
> +{
> +	int *key, flags = 0;
> +	__u64 cookie;
> +
> +	if (!reuse_md->migrating_sk)
> +		return SK_PASS;
> +

It will be useful to check if it is migrating a child sk or
a reqsk by testing the migrating_sk->state for TCP_ESTABLISHED
and TCP_NEW_SYN_RECV.  skb can be further tested to check if it is
selecting for the final ACK.  Global variables can then be
incremented and the user prog can check that, for example,
it is indeed testing the TCP_NEW_SYN_RECV code path...etc.

It will also become a good example for others on how migrating_sk
can be used.


> +	cookie = bpf_get_socket_cookie(reuse_md->sk);
> +
> +	key = bpf_map_lookup_elem(&migrate_map, &cookie);
> +	if (!key)
> +		return SK_DROP;
> +
> +	bpf_sk_select_reuseport(reuse_md, &reuseport_map, key, flags);
> +
> +	return SK_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> -- 
> 2.30.2
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D9A529689
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiEQBIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiEQBH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:07:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A8F403F4;
        Mon, 16 May 2022 18:07:58 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIXhHS030656;
        Mon, 16 May 2022 18:07:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4HLDE/toiKMr7Q7POvnbLeJhXlfn5kGFoU/zv4nD1ik=;
 b=hDBe5m2pV0DiI0ojd4GUeAmsNHqkXWinb51CDHUtGr2Z3rMVyHvKe6nRamS7pyTYF2fX
 VsKFk+HioGahFr0exJnqSV24HLDIFxlvFR6AwPDgwSR2RShw1RSSr1wr8IaIpCBIU8Py
 7gaDfQ7CKi2b8jxN3zKSJ0wc4tX8BMLLJxc= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a4nwvf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:07:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw0AQBTOYTkbGctkdkmLfedCn7RpE3Jix3Eq+UWSZMcOmqXbvt/EPmSxAc3fP3qXH1FWSphMhtF6fZvGtateVGhzmcX0bx/ssU4Z9IaHP8bIo7EvRvZO+FH0sk74nZTFuJSjwlECONkhm+emjHiUSaOfFL72t8tif8R9oOChpo9PPzmg6toJWJQ5wbnzU6OTHK6Oj8hFxu6mRKiO7yeptQ/xZeJC4o5rUevpoq9RaNbaC4ql4/XEV0GDca8mFMkXxNGgBW3xCmxaLbfKv8Jz3utNZVBnBJn3UKQEaEpGQMExSZJNRGWLWRXFNhV2DC2sTWVh0q+RPNlup/qilHAX7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HLDE/toiKMr7Q7POvnbLeJhXlfn5kGFoU/zv4nD1ik=;
 b=OXYhzhL67XHSNZkBlwN0fbnAnJ8rifWM2orln7Uj6j9Rp4P01d/KPbZZE86JP2acwxrU1en4xKWYRx6pMtIh2yUr7W4vIO4FB7GHy9r7u5SUiOsweG0MkHy7AjW7j0gQ6kWvIjju0y070Z7r2cPU/jgh8wnBE9yQV3Y7HKsu8RFSQ70P8SeeT+p43TNY7FafIk48RNVRcVqoXvS00mNwfbouVMK5FLnrijQhYMUswbDOk6E5TFoeUE+Zf6gwP2RCcIM8VkbJMCLLsVugQLtpqucvvzhxdiT9fHq79/RYuoIYky3NGMUUDIvh0+k0kCnOUz+6J3WYqXNFAWuDYKyVaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2253.namprd15.prod.outlook.com (2603:10b6:805:20::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 01:07:33 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:07:33 +0000
Date:   Mon, 16 May 2022 18:07:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v4 1/7] bpf: add bpf_skc_to_mptcp_sock_proto
Message-ID: <20220517010730.mmv6u2h25xyz4uwl@kafai-mbp.dhcp.thefacebook.com>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-2-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513224827.662254-2-mathew.j.martineau@linux.intel.com>
X-ClientProxiedBy: SJ0PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::17) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e5d70df-3624-4ceb-dcc1-08da37a19f86
X-MS-TrafficTypeDiagnostic: SN6PR15MB2253:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB225338E04D3AA0BFE471CAC6D5CE9@SN6PR15MB2253.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54lnSxPc/dOoYUxLg347zCQTeH1y5An/1S8Ih8g8/ERwnetul58nBh7EdarlqMQG95XMNa7zMfWDTLYJVJnU/FxKKADMebCSk5LpDVxI8US1OhHw1CE09mpJR6ij40LtwA2rpsA/b6+pvMFnn6ckm8aEqCPGgPJgEn2A0Um0PW1YYfLjMcnQM/Bpe7FXyzNmw9gSK0VCgow2vJRsbi/kg3LePTyJdg7g61CMLQkzpQtqjwtDCEOq58QMHKiVw9lvelI1GWGAiApOKemq/gz8P6P4eELhDO4OOGnG6qhxxMxusGekMZB4DbaqyGQsi2lJ0Sdfrv8YN8X3JZGvzN8P6XmyXTfnqNSISQVsC8LFKrPeHVFB8lloMmn0IpMwwrUqrTMroYnLdfyc4UBhcs24H3T17ltIQN/6gvIn1QvvYYXTUbNjwyW/PwoDQ9qpaedC8cIdd0iLNDrxfMd464V/qWMbHjwUFL5Ztl9jKFqPCpzIJhhVpYKTycQcnzLrn3uT+bBr8fMPaL7tnTdDha2z4wzt9C/DE8l6asnoA0mm4OOQ2T6Fj8VJgklF229rk1NHmEOJV0ikdtbyhKccJ4tYosAohOFawWupSXXAiSljqbSREL8NRui1D6rtagfsB47KpGwpFxj6k5sZNpL7gWkT/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(316002)(6512007)(6506007)(9686003)(110136005)(2906002)(52116002)(6486002)(508600001)(8936002)(86362001)(8676002)(66476007)(66556008)(66946007)(4326008)(1076003)(186003)(38100700002)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RwCV2onb2JIIrbpUTiyJ04OW2ZaQx25wEdGlHEDcHuuM5i0v94W/1rgJe4qo?=
 =?us-ascii?Q?s5ZSEkyjqKOjbmhaCXtcCpwOpird16plIKZW9ZrqQDOwsdamC4lVLOurKiab?=
 =?us-ascii?Q?b4I0C+NWZZjZ2Kooxw/wEOjvlot2EXUWrf5fvDP9O7zXxJL0JpuE2db9GaB7?=
 =?us-ascii?Q?pYbwdGo35vzi2bym5q4JcMYpKRLu8qtzRYVVf9zR8jj46W342/+m2+SQi2aX?=
 =?us-ascii?Q?wNC2nRsohiFVOHeNapFEUNbrsWYl9dV9hVD/EfwmVdmEWK0gcwRBXAgwEuik?=
 =?us-ascii?Q?ocmvrS/I1yaRnmIgbnoUz1iKPdZC0SWn5UkXwzINKLl+p9cwFcbmND90OYGE?=
 =?us-ascii?Q?xX5rBQ0XyIC8TS9gId328l8sPQdFTY4hCqoyq1LnzU0AsdJVYT0VsPI0bdOE?=
 =?us-ascii?Q?yyEt1O7UqL1GaloO73cvcfqIVPdDLbQa7I5jZulvSj/q3QgpV3Tn23fw0de9?=
 =?us-ascii?Q?eIUmTlFpFoq3C2Bbqb8vBMu98erRUXlwTQuQB3BkHPXoEaAKLwPP+xDdicb/?=
 =?us-ascii?Q?WqWU4SRdunubjiAsSyuEjaLCXZiNfqzbjkalNVGFuPNv3VuYnIhynItEZePw?=
 =?us-ascii?Q?/76mIdUvkFff60zvxN8i2GJz+tKeJrIzG2/YA4VZNudF7IzuQttpt/uqaA7p?=
 =?us-ascii?Q?ViERFr8N/Wm3xogzKire6P3MrWf9uT0TSXJ3maUIpFDiI/zkwSHjsECY0pm7?=
 =?us-ascii?Q?K0iV74lZfEw7XXFIZrhS26K8HXQLD7vg7mL9rnu3aY3fCC6xlpxHa0JEE0Ii?=
 =?us-ascii?Q?xHwMNA8z38d7bcbObVwVoRxulc7jtmFH02VD7RB6N1deCLT0/L4ACWTdFtCE?=
 =?us-ascii?Q?sLjqqZbpoTzxLhaV43GWY0m2rfMFpGPM1X9MmB3rqb0otUBPVeNoMBIqe/Zq?=
 =?us-ascii?Q?57SPR+d8BtrAY/QS3BUSssSbVVDico1RmjKheC8PJ+oAqECf702TL6It64i1?=
 =?us-ascii?Q?7mfrzGVbR4P+y/P/7CfNV+n09Zx4Bv4NzYhFWqyTF/paMPu242GRwMTWOLTB?=
 =?us-ascii?Q?LTne59WE0mBB7QlGI+l9YkRxgYcMfZ3/IXPa4DeZHDX/z73n//N6YexTtENv?=
 =?us-ascii?Q?1dIoxEssEA4+lclKv7Xusus2dqp8FvOuE41I4CZ4ok0qiLNuvg680t3ViZrt?=
 =?us-ascii?Q?OPafl4Na2+0fvsQ3oZQU7sXGxO42kmENxwgFrf8bUnf9oJ9YaT2RZHnC0E0H?=
 =?us-ascii?Q?TozjtBSAq8F2mqsYMOw8lSjTqiWtdC7xNn6YjLBgRFRlBtqEuOuMTlvPKJU0?=
 =?us-ascii?Q?syUyPBvi2jB+Lymps5050TD7gdNTlCVww7EjnqqcRgdILDwXcC9HeSc1SRFI?=
 =?us-ascii?Q?5DSAtb4jOpYZ5BwQq6EuYugfjd6ChlwRG6CUW7Fgqgn4tBCwjFruEnrzzTq1?=
 =?us-ascii?Q?fN07HZ/YNFYa7SMBfDIVBNwfYlPznDqKBsB9TrswADzxbD3Rc8xp1qBZTV1n?=
 =?us-ascii?Q?J+faAnIkSHDtp2aO+PIMSjZh8hfi4JsZABk91dX8lrtSv5WQvEKxtOoOu0OI?=
 =?us-ascii?Q?/zfI6sPJhvMtJJm0sR35gQ7Qop4OO1ptrv8v/KfvOvs5JMTbbnnBJDANkkRi?=
 =?us-ascii?Q?sD4lJFDJViq/jvm+bPZw/0XLRcCxjtUdRVdbUQA6BoNXwSY29HLqRNuOGCEq?=
 =?us-ascii?Q?P1y3ihV+t3/6HI2E1TgGQrcr5UbrwxL8dbTvwWU1hIWNo/9OUQnU37hNRzPB?=
 =?us-ascii?Q?tfc3dRIBJyvu2dCKSWJYsUIwIeVUW33xRuyv2+k8rZiZtSEq/gtN9khdkggj?=
 =?us-ascii?Q?NeQekNRifjIiHJKsJflaNe+HEzmUVAg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5d70df-3624-4ceb-dcc1-08da37a19f86
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:07:33.3586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aplhdQKAw33DTkmuyFV433YXB/pAI/u6crX4nYbJNIwJ/G3iMnNXzM+0mHV/QfFK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2253
X-Proofpoint-GUID: RIVwVk4m_2poLDBfiGwvTvJOMrM_tD0C
X-Proofpoint-ORIG-GUID: RIVwVk4m_2poLDBfiGwvTvJOMrM_tD0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_16,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:48:21PM -0700, Mat Martineau wrote:
[ ... ]

> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index 8b1afd6f5cc4..2ba09de955c7 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -284,4 +284,10 @@ static inline int mptcpv6_init(void) { return 0; }
>  static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped) { }
>  #endif
>  
> +#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_SYSCALL)
> +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
Can this be inline ?

> +#else
> +static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk) { return NULL; }
> +#endif
> +
>  #endif /* __NET_MPTCP_H */

[ ... ]

> diff --git a/net/mptcp/bpf.c b/net/mptcp/bpf.c
> new file mode 100644
> index 000000000000..535602ba2582
> --- /dev/null
> +++ b/net/mptcp/bpf.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Multipath TCP
> + *
> + * Copyright (c) 2020, Tessares SA.
> + * Copyright (c) 2022, SUSE.
> + *
> + * Author: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> + */
> +
> +#define pr_fmt(fmt) "MPTCP: " fmt
> +
> +#include <linux/bpf.h>
> +#include "protocol.h"
> +
> +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk)
> +{
> +	if (sk && sk_fullsock(sk) && sk->sk_protocol == IPPROTO_TCP && sk_is_mptcp(sk))
> +		return mptcp_sk(mptcp_subflow_ctx(sk)->conn);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(bpf_mptcp_sock_from_subflow);
Is EXPORT_SYMBOL needed ?

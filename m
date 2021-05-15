Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6D3814E5
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 03:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhEOBSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 21:18:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhEOBSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 21:18:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F1H3K8005356;
        Fri, 14 May 2021 18:17:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8g7m+KSnXWEI1xKffa66NcfCCdHf3oJQQfQuwuSJi4U=;
 b=gqPCDhcs+Q2P8u9iAg7bU8fmDkGdYkceq5TTQFD5DrkHmW5CnV2DiOzwraZcxmpY8p71
 pS//ceID7e8juYl9rlR5RefZQIe7vtRWbTlpPzXkHXulRCtH2nrLWdLKwznrAv3S3zA0
 BMrHcAiwq46GCQlzNfy3mxvCRNowRDYm3v4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38hnvfcjee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 May 2021 18:17:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 18:17:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6i2BmFcolefx/dtAu5r9LpBJ8fnsPS01+Khu5N3FqtRMkSmJSvwO5R3x11YrDv4g0y3KFVQlTHDkP9d0OIiZOmsHorALShxBqt5XvK3YHyG45FGIhTx9nlYwMJMm1s8nfIXikA7Go92IUoH4oNPIac+KrqJLKNv6aVk5wumLroTRXLtGS7+/qggvp35qcPKi8zd1NPqB+Lv3QkwW5ElvKVGT7pI7mP2tUBRJQME+aKSewjeXAfwm36ovE7JvacWxinJ8poAwTl24ReGJLEECA3ZBtr+9kUOS3GgAQbPwr2jviLuAsaZSYE4+Hq+WHaXflSA2pvhsNBprJuWuIgdJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8g7m+KSnXWEI1xKffa66NcfCCdHf3oJQQfQuwuSJi4U=;
 b=NUt+rYJSzbbXFFWe4RffKOT5hJz93hBIUjy/4ZsGH+coBLl6r1Aiy1D9I/wVrkVOFCRpbeERPVXhOy6U/Jvihtb8Pe4usKvJ0DZjrTs9G1XxG5/NClYSBDOlqwPXyS1EPFWlLQohAwrATSZB4vNbrwyMF0kBqlA7NvZ9eWLdZEEXo75zRaXxMgrtX1+GbonJJkRObb+8/z5vfCsw3NRtNd7hGRVSdJlhIZk8iDimb5t4DqQv9XqhngH+Qv45Psf+05sdJf7zpRJ4p7lajhPWHRmi4YIF2I5aGs+l1aEmn3Ps2Le4gamYO/dsko4OnyNsq6jOWXo+3l4rakiqIqxdeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3367.namprd15.prod.outlook.com (2603:10b6:a03:105::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Sat, 15 May
 2021 01:16:59 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 01:16:59 +0000
Date:   Fri, 14 May 2021 18:16:55 -0700
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
Subject: Re: [PATCH v5 bpf-next 08/11] bpf: Support
 BPF_FUNC_get_socket_cookie() for BPF_PROG_TYPE_SK_REUSEPORT.
Message-ID: <20210515011655.q5v7nnbonvo3a7wg@kafai-mbp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
 <20210510034433.52818-9-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210510034433.52818-9-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:717c]
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:717c) by MW4PR03CA0079.namprd03.prod.outlook.com (2603:10b6:303:b6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Sat, 15 May 2021 01:16:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22a64a7d-b2b3-4266-7dc6-08d9173f235b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3367:
X-Microsoft-Antispam-PRVS: <BYAPR15MB336752E157384012B1F3A681D52F9@BYAPR15MB3367.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AniX2j6GulIC8Ag3peDegFNzCKHDhC+IFSgt79/fQjG4ZhWyRDuvCDd5NAUNeF6kr4RAc00XYU0Qdqit+N/ZS9XcC/Y0ceoqd3X6mMXXOpMIaKfSDiGmWkwW76VkCboLBXATHU/OEfBoA6I1YNOKSz7gikz+QzGVtegyTmKesWI59ZZJksr9esFqDb/Ax7Yc2IyMgrXzGhl7TUbhmWzigfEFuq/Rp5kpziuIKqeMDRXsts/vgxXPKWG6ZrFSwJGzJ9MhUbq/flZy6MX3U75A9jtrQZpIsE1VjwWwpJIGssvpontY8Q5VO9bySLBOVf59IdOfWfSrL5DhiVeR/9uGvUcO8Xd0QYMHiYqe4AF4j7g7cXFoDL9eC1B09L60lL86Zl3ieE7wFmz8nXPgqfL6BqwDSP/QP+82z+IUt7oiNNyxEKR5giQXFXsRiafFKvoH6wH0/Y/6CcfV2YiOjoq4gPJIfmQDd5c2+M6FTLcOisU+W1JM42E9I5XmIn5dGfnt+YxFuGMvn7nvQ5/MPqWnQV0rWc7Af+QgeujvIAdtTZb8sTIBTUYcwOG1tUEEJOXPzSFfTTRr6kI9m6AjwiglKoY7DyrPjmgUiltPdniWoR8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(1076003)(83380400001)(52116002)(16526019)(38100700002)(6916009)(478600001)(4326008)(6496006)(2906002)(186003)(54906003)(7416002)(6666004)(8936002)(86362001)(55016002)(33716001)(5660300002)(8676002)(66946007)(66556008)(316002)(9686003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gICnCAwe7L+iQ/l3PD4/jlmIRPQhX0PH3M70PD0JDW2R3Th04gvZD46f7tEH?=
 =?us-ascii?Q?vcXaexeeR/u6l1zO+J3ccMIuKYraSumfIwga41Y2huZZE2OkTpg5uTHBlLJW?=
 =?us-ascii?Q?rFcKk0k+Y8WbEVBbZB2rYw9twawubF2cQQGW/4wy43kHFDt7TMu9HpldOVOJ?=
 =?us-ascii?Q?R6j7zP+83vMoX1mz7oaND+6wmejhpNRXwGvKKcdfgcQ7B5iJTdedQQOBFhME?=
 =?us-ascii?Q?CNsf5R+5xuI2bCithPkdiSwvUtYRAH+AnfIcHWUyaWrkcf3a3eZ8vvpDziz/?=
 =?us-ascii?Q?LrcuHdM3b35Hpskg+ukBP9GL+RjZK63oMy4pqkz5DwkMIGomQsN9tv8kYaCV?=
 =?us-ascii?Q?y+woJhOiE78eLl1JNNx0PTgIR8fPc0cnYUXCTggAqbFCT+Dxz3upokz5NKEk?=
 =?us-ascii?Q?cVeYwxso0uJgBlzjv3jqc1qU57lKvumsMqcXfRqahRztVhlBearv5Tg+5T9Y?=
 =?us-ascii?Q?yvJDkvc1qKJb+7O0hXqko0oDF/t1csHrJjf0naB1W+AFRi6LbIhfI7cybHz+?=
 =?us-ascii?Q?1ToIqgzl1M4s/WcZf2RFKFm9nTMAqc1rO0mTyANcHOrW2GkOSJjedM9RnYAT?=
 =?us-ascii?Q?+44rLqZGtTHszGdw3JxHnfwSczqhZ1C99y1wqouMnEJmra4HKF8VFWnr8ymf?=
 =?us-ascii?Q?UcJDgrSkn10BCRW0Yb9ZM2JYqvDOZZYscTDuqU93Gxs9KXWqH4UIFvmo9CbZ?=
 =?us-ascii?Q?sF9eBb/rukTAfylOcBZErfiVmeRHkPFq1U+6ceHpbxVrBlpwKqqHca9zLrUC?=
 =?us-ascii?Q?8lY35v97OCOpQDjt8CrI4XOglyK07HAf3IVjc7dx1e3jbwqngFDAXcmsaJF3?=
 =?us-ascii?Q?k+R7MwFirZOPq9rDotgtkYQ0dNKPDgKZSqcnllgujA8Xlg2/7wwvqhj/jHjZ?=
 =?us-ascii?Q?ZkPAMr6oCpxleSGoSbr3zo0kXPKEo7nr9NC9k9pX+LaOchAyvVwpK8Q+vi3v?=
 =?us-ascii?Q?d0nGJtc5GS73ycdy0NuFr7xfyeaPji5bYTb0NDG9r6ecf7QtU7bnwtsqhjN4?=
 =?us-ascii?Q?WYy0ncrBPMpt3fEEse/9r2pI/XAgaPI61mD9+B1WKjrJuCbfcDj6O34MRrb5?=
 =?us-ascii?Q?NT5TUy2qb05ex9poVhKZe/PWlJ3cVyae7XxMVuHSRunmCxhgxg62FYLPGA2p?=
 =?us-ascii?Q?au8vsdPArzcSWATJsoIlffEis9lelckTQcEuheHbb4XBOJMUqW7y3SvzcLJU?=
 =?us-ascii?Q?YyjoZrm96qwS8TbCts4Ovl/Nr9Do4ORkqiz4IBMPOMKjay1tllDn21ATV48I?=
 =?us-ascii?Q?+W9M0FxstVku21ffuFl3aSQkj1r+MlVdu9Db1dWC7BWPGp1tdfabmzc99Ce7?=
 =?us-ascii?Q?OqJyq2DBQKfDaBkwhKnW1ItfrKM2FUuswseR1my76vovkQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a64a7d-b2b3-4266-7dc6-08d9173f235b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 01:16:59.4442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JutPrhO1QPQBF1Frzlx3ADdaaOU0vLcYH+kCnUCreoNroYxbG8FWwlksT6HWFw1d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: g7otgmcNBeR2sSi4Gl01qS86eqWFDnG7
X-Proofpoint-GUID: g7otgmcNBeR2sSi4Gl01qS86eqWFDnG7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_11:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 mlxscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105150003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:44:30PM +0900, Kuniyuki Iwashima wrote:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cae56d08a670..3d0f989f5d38 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -10135,6 +10135,8 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
>  		return &sk_reuseport_load_bytes_proto;
>  	case BPF_FUNC_skb_load_bytes_relative:
>  		return &sk_reuseport_load_bytes_relative_proto;
> +	case BPF_FUNC_get_socket_cookie:
> +		return &bpf_get_socket_ptr_cookie_proto;
>  	default:
>  		return bpf_base_func_proto(func_id);
>  	}
> @@ -10164,6 +10166,10 @@ sk_reuseport_is_valid_access(int off, int size,
>  	case offsetof(struct sk_reuseport_md, hash):
>  		return size == size_default;
>  
> +	case offsetof(struct sk_reuseport_md, sk):
> +		info->reg_type = ARG_PTR_TO_SOCKET;
s/ARG_PTR_TO_SOCKET/PTR_TO_SOCKET/

> +		return size == sizeof(__u64);
> +
>  	/* Fields that allow narrowing */
>  	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
>  		if (size < sizeof_field(struct sk_buff, protocol))

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917C24816E5
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 22:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhL2VF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 16:05:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43440 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229754AbhL2VF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 16:05:57 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BTHDo9X029961;
        Wed, 29 Dec 2021 13:05:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=zxThjScKoMT2zVaDhRFl+IF7yIhxJLoiTHJ//62EDxI=;
 b=DcmowtxQ2fe+yjyF1VbKw1Cmd8vCZnSyQEKmLQKW2ZAYbmcEcSet++5AOWNn2WL+0U/Y
 5VU0lO0jBtYl/tCh+g1LOFMgHdtkTxTaFDIY3uZnNwNHs5rdWYrVRwOYuRJwuTYudLhV
 q+WurGcTGDxY6UOrZ4iqaJkhYIhu61tk674= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d885apy7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Dec 2021 13:05:55 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 13:05:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y85rH//Z1PT6dirzftAG51HYhtjvw2V3gT3DyoweaWvd9ke5XNJS33TbVoUkXfjCBMVWg4LQrtIG2dWh85poWhSlOYDtH4QkW2cyZVch0YcPL0ZK1S79Bl3IM8ejMq5V/gXYEpvTV53bRtXNQ4oJ1QjiGeaZ2lvUMPbX1Nayfp0uhQpsHSO9S8zBQ7G1tb3FcwogA98jKfZG4mJ3s2ugYqz4CI79UDIp4Gs3hNq5uEhyqAvf1tl1dCzj76U2SJoOE2GT/YtPd08vMjUIB2TYsDIlhb2e2+ZWjx2Bz+J1uOJ7P2jDcYNbr0jz1hEIvtywgpdSnTVj8N18F5kqm+BCGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxThjScKoMT2zVaDhRFl+IF7yIhxJLoiTHJ//62EDxI=;
 b=ColXuJBHPGDvng1KjM3QSi/bvZsqW/mo9eFHZMqbFt/5UHmSoX6uRDB6raCIZTAu6UZQItuv8FDE0xdfVIC+ovJfSJCBCKenBhf8IDztKiUu/1WqvT/xoDKYpThgwvSkcdZAcFgza89PLPgdByVGqfr1xvh+NXbwECXoAU9xk98UPryf0UL5DG25eUMbOnWuUAKCRx1YwsFzmPruZwSIdQX9zLXbiF9KhxiYQK7JR4LqecaecMmd/8WA9VWg/pkiRX0bQ81V/XXeenFfi8FVqrX3lcHlC+CschQVOMYXEE+V/3oq9odlORLvBRIWdbocsub6sa+kwUeTFQntogaQgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4570.namprd15.prod.outlook.com (2603:10b6:806:199::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Wed, 29 Dec
 2021 21:05:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4823.023; Wed, 29 Dec 2021
 21:05:52 +0000
Date:   Wed, 29 Dec 2021 13:05:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tyler Wear <twear@quicinc.com>
CC:     Yonghong Song <yhs@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Message-ID: <20211229210549.ocscvmftojxcqq3x@kafai-mbp.dhcp.thefacebook.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
X-ClientProxiedBy: MWHPR14CA0049.namprd14.prod.outlook.com
 (2603:10b6:300:81::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7499b993-d9fd-44e8-5aa0-08d9cb0eff6b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4570:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4570FA28BABB1C5E597E68EAD5449@SA1PR15MB4570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20M+lj59Rg0tZ8H+hXxBLi7FzlBpS4cnIj/fDh2Apyv1RXJhzXmxhPVGQCXTB6jhejcEFNBJVxtAw1oJNZvfe5H/gKHGBVudMtfcX5EIaUt8yHcfGlQ6/bcFeq5YZFPTCm1IcgPqE0MRHK6IA+daGWKvLXtXFwQvTvP5q9Fp3tFLeGepYbJXHba5oA001OdnRGr3wre9xhe1oOrOnBgKu3h4U1Mfwn2uwKDncyQNk03EmTiWIyrnmvGHyJ8jzf+Np4YKndVCCp2hsUINYpprPePGRIPChBEbCRmYbYE+7DRmFdm113D7HTWcwSxby4Y7SQWOkvnwsCgjFaykDp2bb5np6H0BCSuIyYnLJZf2hxjs3cKFdxyO1eQ2ZnZ+mQjw71FApRIZ3LAa9j64dbibiGWrtctvE+4KbWNZvQiYIQW0FrJgyVsyTVm/dikchrYOOGAdvrBM/lBJe1+bPJftvR5RcAzCiGek0/2p5vzBc7697RjVvXDdwzx0XyGZSZ01PZMnIzxmMyjt7xRS6deHv/btqbYJmwN44uO2uss4hmYxfnTeIIF4/QbWl/mKHrNRHK2HsfO5hsAPKNqn93zO9f0ZKJL8Y5QX7B/chwBW0rmkWgAJ7u2EJmLe96MQUF+2Ojx6TyLxEKkn36+eJAQ0rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(5660300002)(66946007)(508600001)(4326008)(6512007)(86362001)(9686003)(38100700002)(4744005)(6486002)(6916009)(316002)(66556008)(1076003)(66476007)(186003)(52116002)(6506007)(8676002)(2906002)(8936002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yCPkcEJKSq7isDHv/i7sbR1xmtsFcLuNmgl4MTvaSwNTHcMUrilCQtQLbgj3?=
 =?us-ascii?Q?ev19IGoEPW5B0dlAa+BfD4y+VofrHFdUBRlANCxiGHN18t9OK1pe55e1yasz?=
 =?us-ascii?Q?AK+Ymvz8/2xZrnF/I5x3pAH9ZryMRGZl/J8uDnSZTlqAI7hby6+1A/l6Rd0z?=
 =?us-ascii?Q?gCkfO0gAyBg7EaaqvyRFbGtEUpeNt/dUQuwrHNOTr8dojE664Fu7aQxaj+wO?=
 =?us-ascii?Q?qXSTtU6m0cPen00caTpXu9423ll5/Yp8K/AUAhl5cRK4TY4/wIiltozGqukA?=
 =?us-ascii?Q?8hMpljsNttusXV4qk7/3ZZNRp+sp1t8XTxS/VAkfkWSMrnAnkGJBZ+tmy39j?=
 =?us-ascii?Q?T5pjhq3JfSdOUZagSBcfsiMRAtQnpAU8IsV55U3x3n8MTecTTnYIDdnIUDde?=
 =?us-ascii?Q?om2/RdF4wAK169lgywA83hBv4EqHxbrimeHlbHr6YK9eU4GsLrzpZj2rwfYP?=
 =?us-ascii?Q?4DKiypyCjn4Ezmfb4vXFCO8tbKowys9RflSZ0F0P/+4QHT2xMQkAVBTeuiJR?=
 =?us-ascii?Q?Rakcgv5HRIUBxrWyfS31O3b1OPQOtZwkuuYWYW+JqrQ4j1TssrEhvfssAn1k?=
 =?us-ascii?Q?DMViOWIQ8kGhL0HOqJjjI5hOCz/i+TO2PT+AYHKloKe12E0R7+9HSE4Qykge?=
 =?us-ascii?Q?bAvSAZvUtEpc0KTn31DkYphJbt8dsQ2EwD4wxRqz/3sEdQhhk6BetpppoKh8?=
 =?us-ascii?Q?PJ7rk3+4ThWhum8iacEtBPDKDE3KLNZnHamFOezp8L/N353JxhJpha64GLDo?=
 =?us-ascii?Q?HuYAVvblFGlAG859/znsUDHxQAqXiLUTMCK9KcEdctEsJXrYQCIUiv8FbaQz?=
 =?us-ascii?Q?dykdyzi29aYsAOZucmnQjNccWj9C+WqmgMSKGP/UeAcfMj4lo1xTJe/43YAg?=
 =?us-ascii?Q?EKUIly6FBo3yVNFH73QvnPfgfbMTAEipnHhj7e2wagz7N/YmF4kwinmtc3yS?=
 =?us-ascii?Q?mS0LW39gIhK7mkZq1KxB3+VArKp7GQWu3EGNW5qkor/cXjnEiNCwcoP9zCS+?=
 =?us-ascii?Q?iKPUNqYgTfIC8I6Ne21FpPF1wnv8AxgdRv+U51ynjsm2C9pgL6mzBis4x3XH?=
 =?us-ascii?Q?sZj9B9rK/90rBq/oC+XXvKxBQ9vmhm8eKXXyMqdXfRXNEDNYgrEclN8gWYVW?=
 =?us-ascii?Q?3Zdc2ggxGWz4z9ooBw0mrUYpX7bwlMjImX3tlgr/vlkYXJ2652xp5CAAIDl/?=
 =?us-ascii?Q?CEjzWn16yfzrwN42H+OR3IWSds6ktrbE9F5Hbp0I5R4CxzH72z5YCUgqC6eH?=
 =?us-ascii?Q?O/bJkbWSP2eT4mchvoSORZ8BuSOjPJtRqjMXcKgzYDY/JsOvfld3IrtJmdUZ?=
 =?us-ascii?Q?ZpOVCFE3pYQhTNUO9OWtjOVhQba7OWE2s9SS9oDtm5M1e3d1PYD/M4+NTQZc?=
 =?us-ascii?Q?jTliuCxHc+ByhtkgH7PwFANMzVCXPuPt8MpRwe2va3GNb+J2JGSUGLaOW61n?=
 =?us-ascii?Q?T7k79Z9VXTLYRW+FZpTGs5CYYkusrHhEirYUkQ5fTnm3/J1vtH0W2gKBvtTz?=
 =?us-ascii?Q?AEDfCsnM8clYnSS0ZNOzhLNZOSd70LBoOJQXnqg4yUxrOmqdt7LY76K7qCiU?=
 =?us-ascii?Q?W3PLhVtYpdx0A9iG7qZQJQ5ZyKnAZNeztrth4wWm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7499b993-d9fd-44e8-5aa0-08d9cb0eff6b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 21:05:52.6803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKyAM4Xx+uKQpGmfbf0xw66izU7r1GFEQp0OEYJZN3UTMPXJGo9XHdbHQagSNRj5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4570
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: nD6pa61hoZYtbeRrMnQXvtLO1ASHq_Nj
X-Proofpoint-GUID: nD6pa61hoZYtbeRrMnQXvtLO1ASHq_Nj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 06:29:05PM +0000, Tyler Wear wrote:
> Unable to run any bpf tests do to errors below. These occur with and without the new patch. Is this a known issue?
> Is the new test case required since bpf_skb_store_bytes() is already a tested function for other prog types?
> 
> libbpf: failed to find BTF for extern 'bpf_testmod_invalid_mod_kfunc' [18] section: -2
> Error: failed to open BPF object file: No such file or directory
> libbpf: failed to find BTF info for global/extern symbol 'my_tid'
> Error: failed to link '/local/mnt/workspace/linux-stable/tools/testing/selftests/bpf/linked_funcs1.o': Unknown error -2 (-2)
> libbpf: failed to find BTF for extern 'bpf_kfunc_call_test1' [27] section: -2
tools/testing/selftests/bpf/README.rst has details on these.

Ensure the llvm and pahole are up to date.
Also take a look at the "Testing patches" and "LLVM" section
in Documentation/bpf/bpf_devel_QA.rst.

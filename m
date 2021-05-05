Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B807737351A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 08:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhEEGzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 02:55:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhEEGzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 02:55:39 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1456p7B4004911;
        Tue, 4 May 2021 23:54:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=92wK79h1yjyq8+eBNcYyYKAiSTXACcmP1TGuqzvPBW8=;
 b=RjnAC3RzLeteDBY/pREPI/nTNKSYAjfXqp9lZ6AcPJVOwTQnqArw60p+ax8stB5rdCZ/
 1RDSCzYJloayb8VFJISBoDdgscu4Yz2A01MWZoFyD52c/GyaW/eHJMlOaIaEMR+8kMw9
 RbYJSOPpBOEQYAQrnC+9tUJhbdCBi4gV4yk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38bebdj08d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 May 2021 23:54:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 4 May 2021 23:54:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrfSrCAYyaC8j6Or8n9kMaMWk20kxr3o1ACfcR815BUvcjwbakH64FVCvh2eK4n7SzWW0ODFfSm5vv83ofGuY3Ok+eKXXhed7NZHzgQLB8nbqAmWXKbtIjXI1HbztV3pO6gpDgThlDz65cQyMMbpE4qAY5rXy8PzbuB1XIRpGkwWXf2eDS0ZaPuyKfY6mY3gWoIZUbEEEqawmU47FT3QjjHqJ7ycTjQ35qulVD8HcjYZm37m+qhFAtptJBKjOtcRfuTfigdHIsKLNFmUHVKo917ULxV9ZmdN2mEkgB3+ngA5xlLh2MBBFlnb02jzpK0Nf7/z2uRwlptRwSTLQmbstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92wK79h1yjyq8+eBNcYyYKAiSTXACcmP1TGuqzvPBW8=;
 b=SBxMWWEStAbR39KSxRR0GTzuf8FIDVRPpEdMDKviGZonHkhx/1XNxQHlnOH0ylPnpf0fnxuM1gMRhw8p/X2z8SnUy6yVQ5K01GrbSPybgTV42XPsgibwz9kc2CRwBDacwWK4tYHsSHTdq4q6SiTmhHP6wd5eRmL96tLrcoUR/GrCo71YHbnmryZYNgRv/1ovIssxAGXtygMtoutCrdtvTbvbFl2nk4dQm4/QrNLCjUa9ujwjBzDDEIbpjydhvg51IYKiaRvMOHzk4iK0mU/p5lZBstNu+Brgpkje12YqBSBd530bMWlaeP6xKCTQI/E94MCQSvunvfqW2tZKBYo8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Wed, 5 May
 2021 06:54:22 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 06:54:22 +0000
Date:   Tue, 4 May 2021 23:54:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, <edumazet@google.com>,
        <jbaron@akamai.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Message-ID: <20210505065418.uqfmyy5es3y5zw2d@kafai-mbp.dhcp.thefacebook.com>
References: <CANn89iK2Wy5WJB+57Y9JU24boy=bb4YQCk6DWD4BvhsM3ZVSdQ@mail.gmail.com>
 <20210429031609.1398-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210429031609.1398-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:5bbb]
X-ClientProxiedBy: MW4PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:303:8f::14) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5bbb) by MW4PR03CA0009.namprd03.prod.outlook.com (2603:10b6:303:8f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 06:54:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c989ac5d-565d-4650-bd7c-08d90f929c5f
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:
X-Microsoft-Antispam-PRVS: <BY5PR15MB37168388762152615EC71751D5599@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6QaAWDowuFuSeOlibLSCz7prVmkpWOnYu9ragfC7lS/ngBzU1GbWGLLAZF9PolvxBqqtdmvF6Xc86yMXIlXVAaj/dF6tWeTfaYmAtK9zYtjIuz99wI4ROdk9ube5BY9jcMlNgcDVRTfEFTCMVwQ1zUQDMcdyE0CxIs6BMYIKuRs1dFtw9fc4TysWaQJ8j3Voueo9+DjSw33BtiW9z8ungZJmYo5qKTh4mun3qUUdFqiMxaunKXsyWCY5EUj6k29EYMKPI5fHgbyPRzOsaAYpPkc7OveHF/A1c6If48hCwAUR5QQWZ0XcXuhsY0LqiKPPERBOkg1sa0UMLCVNHguasmN2ZhayZIZ7RP0AkoyUGclu/nMb7YxKle2MJyYe/Y3czt86DZlkSZZq90H9jltFFkaxt+qEGuhovMk9xBuFQNvRAvpcXdOVoTW2cTIv+mmqN+2aOITtHo10YF1OfEpltjWVsE5YddJCHYoJ4PUF8TBSdb/1c0vx797gy7NSTJykYYs8KBy5psIqJjTUYwn34TxnLUXyzp2Qk1cNf/xSx2k3Aj7H133ExVz8O14EHQtzryEsheOwyMAmHm/yittFGTjU+TKEomtO4hcHsuG/30=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(316002)(6506007)(52116002)(7696005)(86362001)(186003)(38100700002)(7416002)(2906002)(55016002)(9686003)(66476007)(5660300002)(16526019)(4326008)(1076003)(83380400001)(66556008)(478600001)(8676002)(66946007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NW5fZ4mNdLFPLWWUHpgLyn269jV83DwStsGKgnyyYAFo3mxOJuMrq9w4cLr3?=
 =?us-ascii?Q?kzawfRI2B4bUMr6YXJTfNIzao9KTNt/O4HQGOnlb4uIzAZ5LCI7Sjh1qJddE?=
 =?us-ascii?Q?7V62JyGi0r9hPUZM0uS3mtJq4hbVg5c8HMGfuR+riwxcN2Y5wHy1zqgTEzS7?=
 =?us-ascii?Q?+mV65oKM0dpLSqUsEAuHBfLrwJJZ37KEYd8B40QurIgPU5ZU4j5/M6tjESee?=
 =?us-ascii?Q?TwZcJHN0xYKoPe/JISIpPyuj9e5i5Z/rqabFdMmTovCHEi8OZeBkxv+sTMmS?=
 =?us-ascii?Q?oh8h/1LA3Z/+1abE0+GObMnSCMhoSxXO5KmVUYfViiNhvbQijP9xvpo4axqw?=
 =?us-ascii?Q?oMzZkVA1hTwCGPkiZ/yUhG8e3PAb3ThtB79xtwfdUf7RRV8dOuf213lIRmfl?=
 =?us-ascii?Q?kHhUEm2ig5G2vEmrv8XFhxc/ZvHctKFcEIQ9EWU9e5rSW85rXjpwQ1NsgdsT?=
 =?us-ascii?Q?gZm/glj3SoyXvstcNlEJPy7vnCYCw8cim38SF4A3sIdj/2Ilj3J6CcPpcIXR?=
 =?us-ascii?Q?yIXggwz2Zo7IpbaBhKhIQWaTqU7lXY04w2Iglf2OCGaf+LR0wQ2D5Xh2z1kM?=
 =?us-ascii?Q?xIYKD/nol4WSfZyaM+2AKHkRRFJcKwOyQDgy/xDM9dsCIaxVCPHFwR47ZHv7?=
 =?us-ascii?Q?m5EgueP9xoZOCJO7WrbiE7OWi5hJb59nQZ/0Kuetw4RtTCGOkWl81v7oQGbS?=
 =?us-ascii?Q?Tg81fzj5cJxomRHObBNoes3a5/FLWmz39JPHUIhZ6Dov7gpNvLOBm0eDksKo?=
 =?us-ascii?Q?ecQVWZ9aIURE9Gmc3Q+ocQrXKNKU927jRTahOZX1JwyW9h9ReizCmRiGo54s?=
 =?us-ascii?Q?Jo95NF3H2VyPsqLN95kOnR4DjMpoTlLwe1insYWEjNLwK4cilABBz9znya55?=
 =?us-ascii?Q?epDn6h7qkzu/miyxY26b8+gg4HzpAUwEftOed/f6StqDV3W10k2ggi6hdwr3?=
 =?us-ascii?Q?RXPqVtKSVvq3VD2nQK28dE1gGn32CM72k3BjGYqQyo0iGZ+NMaMnvCQmxPNo?=
 =?us-ascii?Q?QhDR7u0buGyRZJoBTE1MfgnyzSBdcNQUQVIGBWvfCDyDGHNaRxkaFp/YrEJt?=
 =?us-ascii?Q?VdW/U1+eJmRxkhXRMbGDU4MyG1oI3KjIIhna6emcoZlUaqPX+ay+NxVz/7PJ?=
 =?us-ascii?Q?8U+QtEqm+AmV9wj7NpUMS8GFdSBgTqfOZOlP6xUuOG613ToRykUbQfjaMiko?=
 =?us-ascii?Q?1Z+6yZ8R1PlaYKK4xcQr2jOhiCMR/qV3rv5nIOym+/yRSCt4Z0QvLBlQo13n?=
 =?us-ascii?Q?+qNTm18XsD6q5NtZg1W4/XDvgf/HAGcb2U9BxeyS34pQYL/K0hNFR9pNArF0?=
 =?us-ascii?Q?yKGvcDDs4o/9dEKYlkm10RmlV8ck4x6/M8nBTlSM3jLJbQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c989ac5d-565d-4650-bd7c-08d90f929c5f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 06:54:21.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13X8DarATIzpYBghXRbbUfXM5ZFIbI/63wjEX9gSlG3la3LN2vBTOkpfvP/8z20Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 6sLbz50zmzH8521vnR0dZkG6bVOH22_i
X-Proofpoint-GUID: 6sLbz50zmzH8521vnR0dZkG6bVOH22_i
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_02:2021-05-04,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050048
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 12:16:09PM +0900, Kuniyuki Iwashima wrote:
[ ... ]

> > > > It may be but perhaps its more flexible? It gives the new server the
> > > > chance to re-use the existing listen fds, close, drain and/or start new
> > > > ones. It also addresses the non-REUSEPORT case where you can't bind right
> > > > away.

> > > If the flexibility is really worth the complexity, we do not care about it.
> > > But, SO_REUSEPORT can give enough flexibility we want.
> > >
> > > With socket migration, there is no need to reuse listener (fd passing),
> > > drain children (incoming connections are automatically migrated if there is
> > > already another listener bind()ed), and of course another listener can
> > > close itself and migrated children.
> > >
> > > If two different approaches resolves the same issue and one does not need
> > > complexity in userspace, we select the simpler one.

> > 
> > Kernel bloat and complexity is _not_ the simplest choice.
> > 
> > Touching a complex part of TCP stack is quite risky.

> 
> Yes, we understand that is not a simple decision and your concern. So many
> reviews are needed to see if our approach is really risky or not.

If fd passing is sufficient for a set of use cases, it is great.

However, it does not work well for everyone.  We are not saying
the SO_REUSEPORT(+ optional bpf) is better in all cases also.

After SO_REUSEPORT was added, some people had moved from fd-passing
to SO_REUSEPORT instead and have one bpf policy to select for both
TCP and UDP sk.

Since SO_REUSEPORT was first added, there has been multiple contributions
from different people and companies.  For example, first adding bpf
support to UDP, then to TCP, then a much more flexible way to select sk
from reuseport_array, and then sock_map/sock_hash support.  That is another
perspective showing that people find it useful.  Each of the contributions
changed the kernel code also for practical use cases.

This set is an extension/improvement to address a lacking in SO_REUSEPORT
when some of the sk is closed.  Patch 2 to 4 are the prep work
in sock_reuseport.c and they have the most changes in this set.
Patch 5 to 7 are the changes in tcp.  The code has been structured
to be as isolated as possible.  It will be most useful to at least
review and getting feedback in this part.  The remaining is bpf
related.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5283F6C52
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhHXXsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:48:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17176 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231552AbhHXXs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 19:48:29 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ONkPqf030234;
        Tue, 24 Aug 2021 16:47:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yeXha5ys7CLyTP3W5bMxH34s63JyvxYBPZ7PqUi2UxI=;
 b=P9M/yvb+ojYIoooYON9LksQHmqecLQbyVygFVKoT1y9oVicp7gYbZiX54QXtRyNK44rv
 1ZW4EzUNhVKTXcGKeBbH8pwvJp1xSOoUjOECmcGUARrxNBUjO3YpnZRfjBjl17VX2qgJ
 lnArcH/QrvXqOMz5FXA0dH4Au0+VCbza8Zw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3an9dugfpw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Aug 2021 16:47:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 24 Aug 2021 16:47:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hl8zokl1rkLxt4fhYFZgqBN1ahuUAmBqRiykcxOk5PGA54FI4TK2Yc0EnzoVkdbKdnZPS8b//pMlKl/pSuC4Jkpr5krrFgxK+Ct7unEfJ0UusDeGvLfASwBQ4Q6bF9aYZresNeibYqSucq5t3XEM0L5ds40tlq6PW/dhwTlEtBCfJFuVawH/VyccrcqupyX2URVZvuMpOgzkEGlzNCOtMi3JLBQPF1JPcEH0qeE5lPG6PqA9Iu04lV8bflkbsA4r7FFuNtdkvqF4GhYKnePFGbIc2vRVQUrF+hPvvU0AVkQOAK1filZKnAYLypKvfQkc3+KgpbuWpvijch5iOOOgCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44Xt99maZMYeoKUIN4MONCAspSJrvZMK93cQF2iX2NE=;
 b=k6loTLkaSha9tk1we8tJvje9mtDTiEzqO3alxM3XDiTDXbJ62rQt7c7XU06jpYBa10WX6fWT9Fr/IiV4r0vGivT3rZfpOJKr0qfcc8a9q4KSOttmHS5M5RXLsIDHxhQBCLr+GMyYxqSmmCHWyfire0HiRQ0/bJys1iFtAKLYIfEGn6dVhEF5N/iwjl4PmE7i3T12kq+z8Qvs1WpM9FqPgnWxLpuw9VhrSXLzWouDNlnmYYhY+uAHfvVtvtisqOYtPpVbQg3ZaX91zZsAEbsiJswh5LUxGDtYX2ISl3A+8C6fINa2zmYxIaROjvqtWHzF54aaKgTTDvmQFoMAVhGuIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3854.namprd15.prod.outlook.com (2603:10b6:806:80::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 23:47:03 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f%4]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 23:47:03 +0000
Date:   Tue, 24 Aug 2021 16:47:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <toke@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Message-ID: <20210824234700.qlteie6al3cldcu5@kafai-mbp>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
X-ClientProxiedBy: BYAPR05CA0075.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::16) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:90bf) by BYAPR05CA0075.namprd05.prod.outlook.com (2603:10b6:a03:e0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 23:47:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fdedc22-7590-43af-24c9-08d9675978ee
X-MS-TrafficTypeDiagnostic: SA0PR15MB3854:
X-Microsoft-Antispam-PRVS: <SA0PR15MB38549B7611064E556A92FE97D5C59@SA0PR15MB3854.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N571flFi59GYLdmRf4BIOgqHiSa2aDafQBxQROko4lspLormkmJPnqVmRservBH+Mb2e4LeXmQigQfTLRDx38SYkRzTBZuJ/lGzXJ0jolCCwPuQieFep8wFZY9eouBXKLISulXWwv/N+YZceNFKU2gYzzVuI/rLA3cdHjs6lhyJY/369WuIVDMG56gZQ7ZW9hABccs8qzYNn59n3REpbyOe2/AXauuqCE5tbvZoBdVBdJ3hxS+2FD7fbzPgrYRw8F/0nJ9Xabsjw4ACOiLqhrRrPcEt20cM/WVnz5N1PPaIBULvpWvXKuAE2BQcJc3DqqDn+LbIAP1wefo7SUYN6r770wVOb6RLesMxEKqF5nbybZ2ye8LJk2xjDvmITd3E37ZfurQey7eTaaLuDCXTnkqvyCJpZxTJTkuZIbLAw+XekjXKpi2NSXJy7caYKkDoCIuoz2pPnbJkVbM6XDHmXDZA2eCX9r2v5YggXAdzhT6q+PtAShYpRavAD770ev63ghZ1Fq/qHQNe0HEYkZjMD/ve/YfKrsW0Evv+EMOe3j3XhiOVi4IUybbawQwT3/MXUW5gnn1xufkYGtqSXIyiPP1CITUipQKk0ogwtvaxrHi0wo4BpEK7uJMQ0JtD0XJw5IC9NrSn5jBVtWmTskctJo0q/sHaGY1uZ4GeYxX/ANrid5VUjPxRFsYpCNQJDK4JiwEZsnXLtmhxdSlVNmaTYigpynAaX3cJooHhxyBmsLnM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(1076003)(55016002)(2906002)(9686003)(86362001)(54906003)(6496006)(52116002)(4326008)(316002)(5660300002)(8676002)(66946007)(38100700002)(966005)(66476007)(66556008)(186003)(8936002)(478600001)(6916009)(83380400001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xg+ksCL+s5yaAyU8FyQWcAlqYLx7EmBLVeyJL1HQjSLy5FkE86AXOHyTsTf+?=
 =?us-ascii?Q?/T2I/Xg7E8jhvUMRY9sJXTGpxGtvF1DC95W58OYjcjmH3XctQxBeN+iDYwvc?=
 =?us-ascii?Q?GlcEGlOxLfwUV8SOHx30TPaUCoTnLzDNr8uZ73Gh+DtBF49iVD5ik4NMcgMc?=
 =?us-ascii?Q?iwgfxzBbrGHNp/ZamFoeImq8rew2c51NH+ixQ0MOGrOjEYKHISRfHLzCrxQb?=
 =?us-ascii?Q?SoFcW2DX3PuHNSacWiEW1yJXdkg0Y0LK56UIJ+d1WeTM7hEUMgEUtKXwRR8V?=
 =?us-ascii?Q?ckEbNfy0qFDeUFJOWNthx1DpaKE6mQ1GwFGTeIigxkTbFyYT3rsjupKghxvt?=
 =?us-ascii?Q?731Cb6ZhXOKvX3c1V4tS0p7nzB94OKqmsB6FY9qMx21fYhtn9rmwOlMa+vtj?=
 =?us-ascii?Q?bWjDCiyKqkKZqXAGzyTEINis5JXC0yCeCnptkB4PiTtpzo5yoa+LWvNy/3qA?=
 =?us-ascii?Q?w3NhmgOwwkAi2YNJkko2elMh5Hzrlq1wDHXdZJ0Dt8H7Jlso/Lmt40sEq9Ie?=
 =?us-ascii?Q?ZSIqVMnOAXAKXzCxvWS4nSchmX0VG3jAMvynSsbAjWVqozRRLj2oRBI6B/UC?=
 =?us-ascii?Q?ktWJwjWGP7Y/TJ4Uf1bdIRwLvbd0BIwK/jUS7/9zSGeCYR+385qb8ILlmvPv?=
 =?us-ascii?Q?SuEbvg83SyMOSnOMB9rDB6hOwY/DxuPye7f+z07SPK58z6UWb359nL80677g?=
 =?us-ascii?Q?J15C+BZWpZegApie7basOm/bXGuufwp57WbD68h//ykuvPXh69ZA6AoT20cE?=
 =?us-ascii?Q?3SmkPg0DYal+/MxKyjCNKAngV4EUHci5MkfzMFSuaCs5LroslGErnr9GdNfo?=
 =?us-ascii?Q?z+OY0ePsqfR/rFtP0zNnk/yZRZ8ZNJ4tWkSovlah/s6CQGv4GgDj/tc5Vk+V?=
 =?us-ascii?Q?5EVkz7lOW31qUeFJHyzL9vA56AtD94qMndzehgmJoM9J1lLxsIUpyWq0QlUo?=
 =?us-ascii?Q?lop/mz+wGreOShkzY5OP2CaOjXGWegB5UcBP3BDdNhbIAMO2jMaJBtqIBsNF?=
 =?us-ascii?Q?Bf7y/KDtDkOitSchmjYfNqTXnMSm3xL2doOHGBdgl3FlEoCUit7kIzJV6dSJ?=
 =?us-ascii?Q?YgnZQGDsrgCxgx7i/7rhZSxwotSFwnuvh1Yq4XuLoA/FlFDktmRq03fyJhF/?=
 =?us-ascii?Q?kAR/2kWDYsNgVJ2f8qZhT5//+x9GCOkph6I1p2CEy2yCoiXy8kybgiu9EHqU?=
 =?us-ascii?Q?+4tG2ewyg12hrv/l5pu6fIY9s85xIP97/IlIlPZSiiXGbPdHeQJp9hFFJgAC?=
 =?us-ascii?Q?x9TCyPL4R2e73ZHWpj5nCPEna7nuEiDPh+rccfFP/bNY8BWtFuVu85x1khcp?=
 =?us-ascii?Q?MZCPw0g2yRahxWs50LCmmIABgBg4EuFICcp/9mSKe3sszg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fdedc22-7590-43af-24c9-08d9675978ee
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 23:47:03.0947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MsMNP+dcw9qugKq4d13eg5I9D7qQNr4eciISsLoorhuwJ3o+xAZFMPjBGyonEA2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3854
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: kKg0KMi16ByxD3b4_6mlJ26tf8wo-msr
X-Proofpoint-ORIG-GUID: kKg0KMi16ByxD3b4_6mlJ26tf8wo-msr
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_07:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108240148
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 06:02:40PM -0700, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This *incomplete* patch introduces a programmable Qdisc with
> eBPF.  The goal is to make Qdisc as programmable as possible,
> that is, to replace as many existing Qdisc's as we can. ;)
> 
> The design was discussed during last LPC:
> https://linuxplumbersconf.org/event/7/contributions/679/attachments/520/1188/sch_bpf.pdf 
> 
> Here is a summary of design decisions I made:
> 
> 1. Avoid eBPF struct_ops, as it would be really hard to program
>    a Qdisc with this approach.
Please explain more on this.  What is currently missing
to make qdisc in struct_ops possible?

> 2. Avoid exposing skb's to user-space, which means we can't introduce
>    a map to store skb's. Instead, store them in kernel without exposure
>    to user-space.
> 
> So I choose to use priority queues to store skb's inside a
> flow and to store flows inside a Qdisc, and let eBPF programs
> decide the *relative* position of the skb within the flow and the
> *relative* order of the flows too, upon each enqueue and dequeue.
> Each flow is also exposed to user as a TC class, like many other
> classful Qdisc's.
> 
> Although the biggest limitation is obviously that users can
> not traverse the packets or flows inside the Qdisc, I think
> at least they could store those global information of interest
> inside their own map and map can be shared between enqueue and
> dequeue. For example, users could use skb pointer as key and
> rank as a value to find out the absolute order.
> 
> One of the challeges is how to interact with existing TC infra,
> for instance, if users install TC filters on this Qdisc, should
> we respect this by ignoring or rejecting eBPF enqueue program
> attached or vice versa? Should we allow users to replace each
> priority queue of a class with a regular Qdisc?
> 
> Any high-level feedbacks are welcome. Please do not review any
> coding details until RFC tag is removed.
> 
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164235844C6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiG1RU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiG1RU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:20:27 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C322BD2;
        Thu, 28 Jul 2022 10:20:26 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SH6gOB009939;
        Thu, 28 Jul 2022 10:20:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=sIaJzdV4bm586uWQeLz0WfzpZUVP5K5fdDbmiXk6gmc=;
 b=BTim4RCXOOxAeByxCDa+vWpHHe7BryTUDet21W7EIgyk80rClO6GjtlGzSFeegcrqiqw
 hBu+9GuPI2F3HTJ1gY7F12lbyDnEt7hMmxdYiHqHXyyAwYyk8kBvL8MgmsLfmOWVvsLj
 Yntsy8PDJJLz79gOtgNfdPpOCXHpDnjzC6A= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hkxjj83rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 10:20:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzNFdgVYXnixqfAO38MfaNgXMh7oZQFE+9+ggmFgm3ZYC/7Ksu+lkuxQnmnNEQo249+GWGcZ5epU5lmKPgrGUJaV3rDJG1125Y7/ErwnL0F2sXFRZYNzdjDV67peiOnJe6FIPtvYWf6eHKtmfkSQwX9xR6/KG0l7Syu5QHOwCNXERdR1Q9zIh+Gba8dhE/Jj3sf1dDIuhsBPbl9h8hJ4EeM92TjtkteGuO9+sb0KYAGnIFjFGrBl0gTxbscPVGQSHXdhwUjurxCVMZ/m26s3hUyVKFwEgoaison9FIKY+0Fy5B1MenfjSbKJX0wXhPhNgdmaZ6nsv1F80L3yiEo0MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIaJzdV4bm586uWQeLz0WfzpZUVP5K5fdDbmiXk6gmc=;
 b=Z2mU07u93KU/nApmSlqEWtx5U7fvBQY0igMPnOCPIG83sZqC+05KABpQAhI/us5zjrUFPU2BOUcBOl4fu8+FWLER8TObnk2NFCnNX9pJcyjkzPOBNX/rGGfSqQQF4ugH5N3bD0oMq3/6K2YdWQor53GKLez7PcT6XDXdZkhcQVazKGQLMBG6nrGlU4hMh933x7vhf4+/GDt+JwAwogmz0TvsxCxPkcU7O86+0iYs8KKyKZIRL7bYlhkl+hijmN/wGZ4NIWLkXuj0B8p6RU6IunBrpsktWYrCgCfAPA7LZoh4d4PwNO0Oa+E9aKUQBMXS9s5rh6XX2rhJr++eXEZAOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MW4PR15MB4442.namprd15.prod.outlook.com (2603:10b6:303:103::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 17:20:06 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Thu, 28 Jul 2022
 17:20:06 +0000
Date:   Thu, 28 Jul 2022 10:20:04 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220728172004.6mpkycl52sszuudc@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com>
 <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
 <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
 <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
 <20220727184903.4d24a00a@kernel.org>
 <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
 <20220728095629.6109f78c@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728095629.6109f78c@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0183.namprd05.prod.outlook.com
 (2603:10b6:a03:330::8) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3d83d5b-bf3e-40a8-b95c-08da70bd6a32
X-MS-TrafficTypeDiagnostic: MW4PR15MB4442:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuU4ui4OyFLjJfuMU0U3cxw/X7aGw/tn1tHOsHSOpXAKNC07Wc6hPMcaWqCF0PQDXCXelfRiaQ2IAB/N8pm846pYUFKSrzNzHDV1D/69o8k5TvwdV7xaaL++AZpeg2C1KpBodIsEcZiqD2BmgwKVzKNgbk/gssEvwc66GBjwRAqhM8IJzMixRK72tqRCDV/xdg3nq+B3PMV6hsNdQ97/TGpVK9vObXgwUG+YYv2WzJo46bptRtK1G+BM4MDi2raRudLervRBGLkoA5P6Z/ut8+8/++ZJ7vquawVe4wygWaq418k8QBXRi9DBQyio3vJr5ZfsiKMGD9ICC3qqAVY81ckaqabP0iMVy8CZ3JQcsNDrCa7OyIhNhucqoFie+EXD+U2Yb+lz2ZchCbPDTDTDYhKkpVeoiHuOipssePiIDEgCfFiGEUXuyt08JO+VOh/nLY01BAE9KUSlqftF5p38j5COhank1MCWYcH+WsYw2jj+uUJvM8GKJ+bqR8yfRw2sA2EKDujg9tQRbv760pSGG3Cn3XO6OzdznqYWev91rjBJ5RrZ9CB7UcM66FDkSDHfSrd9r/24/++68KD3AhmfsbIdWlqDL7OK/vBsugsH1E3zz8AY7fzx8HE8g2XBLLr3MLnckk6khZeT4FgBGYgr4Ynm9Us2eur0UJxFRDI4r2rmtGHskItg6GkD7qTgUk5/pRnIWToB1r/eA/wTEzeJ9bsYUXm95XABy+6wsUrVFMJ/UicVYBuGLD4hzEr+WBBe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(66946007)(1076003)(2906002)(83380400001)(186003)(38100700002)(66556008)(7416002)(6916009)(86362001)(8676002)(54906003)(4326008)(6512007)(41300700001)(5660300002)(52116002)(8936002)(6486002)(66476007)(478600001)(316002)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A/oBy2i7rKDO5X/MwP6JW91CmGqX/ODQSfZtAnSJUa6AHn/S0amoePoWX5kw?=
 =?us-ascii?Q?RFhwGOj1CSEwUAHlPYMPs1J5XqPSt3lklZ4vBxW3slkvucqz6jPkQxzed+ds?=
 =?us-ascii?Q?uhXvkjbPGsc052A6KvTAHpzb6cDbbrUkjVJz/2cxWLXXs3xSWeSeo756WgRW?=
 =?us-ascii?Q?qLP9A3eanrBA5RRXZE2aKPoYp75ECff3H7O/YmIIjw+x6VAioCNIQUPgUjE2?=
 =?us-ascii?Q?JfPt5nmz16OSd/c4Y7wWrMFwH57bE+IAeJLlG7ZjRcc9M1bwzC8Lu0dJYXW8?=
 =?us-ascii?Q?DLR0JYUaEkjLet8VYo4eR1LJHJz8LBLSOOAyefiAyrImzi2ipvPU1GiIgWhp?=
 =?us-ascii?Q?9P/z5fV0nzCUWICLM5HDgF9d00jotkmwmUk9Fm/1QgtRcCTkzmWyBOBczQ3e?=
 =?us-ascii?Q?P37d1yNR6esf9noyoFW6z7hes4X4/m2vGb9j7X0sr6UygbZyOXZPLhZuFPFj?=
 =?us-ascii?Q?Y0NEWs8ZKJUfsFHmkXoN6+xBmLk8zqpOMsrNytDHMz0Ty6Wz8QGPc8IjL9U+?=
 =?us-ascii?Q?UMBV7vIkvk4KDHzyrSkG9SEwxzAqzrj/QvJcl9OatbzRAsN8qmAPwF0/9Hw9?=
 =?us-ascii?Q?aDmvPi+1++QCsHhVewr1rqlvfa1p14Wa49Cx/0K694ACX4HXylxf2UvVz20w?=
 =?us-ascii?Q?4fC6fK0UioewDpvTFfP75FyIq64mIjV97u+8cnfl9ahlFb8vjfeGyFuYDtHO?=
 =?us-ascii?Q?P3QOL1OoBcKNqH3Ocr4r75214YaaU3JnQk1F0aXeh+vLwgLGGDkv4/xER7Td?=
 =?us-ascii?Q?a0dbLqIys78Xcy9f18Mo9bh0UkbeLo2qtTbM17exoEF4eQN2noXq7G0rgVzR?=
 =?us-ascii?Q?FOeJ5IFnoOENN/CK6Dp1y/HNExkbvlC/6dEHZJHuoqWmjNGGMhdxoKwwLImb?=
 =?us-ascii?Q?OVwop5FjP73dAcNQ1OEd3SJ5Q6CIZqC+Q+dWpggXpcUITWeFJqDwv0FHD6tj?=
 =?us-ascii?Q?Bk5wUcXUei5KuZapsOS1aqxgjN8PC1MRu802RmsL6iRoxPxOJUbuwIkXhuJV?=
 =?us-ascii?Q?XgaME7KiK/7V5bqxym7NZUJF4T0KQoVdfj/tTzAYrcmlHITtOwXa1QmbPJ5E?=
 =?us-ascii?Q?i3Zi6aRb5GQ08EB8vptJbz5Pe9U0ilC2xoiV4hpXbIMWo5zWFsqVnWpgxd+w?=
 =?us-ascii?Q?q4SBLO7q7Cot8sp1w7OHRDMmGm7YhycoPdAkQAvMymeTTDyCzL84qUS12smI?=
 =?us-ascii?Q?TBduSohEq51dAJKjuWheciaqx9fmXLagtGswYFqDZ3ZUHpmLFre6YdoF597v?=
 =?us-ascii?Q?MZv4cZYAbkjA6fTRHdwO+Afr9SLc4j0uQexJ7Rhoz9tFoxrUa/V9tWNKtErS?=
 =?us-ascii?Q?u77y/qwmG/aEH3qtkPItImT7RAPF8Mb1XgI/yOHmncLOA08IcYYn1Bz+ZPzY?=
 =?us-ascii?Q?AeoyOiWoDd4g77xgtu2gvdj0EN3tBs6mTBiaBNQlOvCXDTmcmZxw7UZpFF5J?=
 =?us-ascii?Q?fcsptZBejfFgO97bRNvRCPoT2onZJDvHEuMi0/gI2dURCE1awpzxsVD4C6Sa?=
 =?us-ascii?Q?9jrKJD01AfxauHuP0Za43XOHCRqlal1JxT7BtDr7DXVoa1DzMwh1zhC/QYgr?=
 =?us-ascii?Q?m6OhyVXXhIySzg0rFy6C2DeoZ2UiLjTOF3pfmSh0iGYrVv/+VC8/zQlI1sxR?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d83d5b-bf3e-40a8-b95c-08da70bd6a32
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 17:20:06.0435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDZtEAvliqOfKj7s4v4LCJXpGy2tIYqT17f1D6MezfRh0QVUJSEykgTcLaHXmPJT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4442
X-Proofpoint-GUID: e0SghST5ujCTfdmb8Ao4pvh3mHIiAZjv
X-Proofpoint-ORIG-GUID: e0SghST5ujCTfdmb8Ao4pvh3mHIiAZjv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 09:56:29AM -0700, Jakub Kicinski wrote:
> On Thu, 28 Jul 2022 09:31:04 -0700 Martin KaFai Lau wrote:
> > If I understand the concern correctly, it may not be straight forward to
> > grip the reason behind the testings at in_bpf() [ the in_task() and
> > the current->bpf_ctx test ] ?  Yes, it is a valid point.
> > 
> > The optval.is_bpf bit can be directly traced back to the bpf_setsockopt
> > helper and should be easier to reason about.
> 
> I think we're saying the opposite thing. in_bpf() the context checking
> function is fine. There is a clear parallel to in_task() and combined
> with the capability check it should be pretty obvious what the code
> is intending to achieve.
> 
> sockptr_t::in_bpf which randomly implies that the lock is already held
> will be hard to understand for anyone not intimately familiar with the
> BPF code. Naming that bit is_locked seems much clearer.
> 
> Which is what I believe Stan was proposing.
Yeah, I think I read the 'vote against @in_bpf' in the other way. :)

Sure. I will do s/is_bpf/is_locked/ and do the in_bpf() context
checking before ns_capable().

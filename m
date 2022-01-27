Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E4449DB1D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiA0HBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:01:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5170 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237047AbiA0HBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:01:44 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QL1jep021570;
        Wed, 26 Jan 2022 23:01:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Lvu2xLcl/rVm2R8pDdFaZsCGPDRXV8uvTq4ma3k6yRg=;
 b=IXFJhREmfdWduStbOs7XrU1wSw3forWAxwOx8FtuSiXKlA+cIP5e1GwvyY/ZQY0euv2v
 o+nSbHHCJFYtlNdwk3oBe0Zxk4wcVHNVcVD4ZDNSvP68m3mqmMnwHoJUOeWhsVJNNZD+
 5BoIbCLQJYZKGfXSGIt5maj0kkN6ZBE5Dy4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ducnv32u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jan 2022 23:01:39 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 23:01:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9R+9VYYTRXIwHWyaRTRs8SzHpsiWnC465Lg9F4GFZFuY8dumbzlXOl8tDueZsVqjhFuLarny2ttRVb7m4LxERV/FiWVFW/YPEUETnmKTTs1uKQ2b62gh07kWEwNOgkRdyqJMJtqAME4G6g2znl9KO/CXO8lHUV74UaSuYExHD3z9a5x5Jf4hRmuv0Bvxdz7GfE2WhrcKuREIxfUsm/SCDoo+9pes2b8IkGI/4/9xULyHLvLcfvps7D0Da6dXfcrKtnbeOucAItK2oYUt4umkbJU3gjh+b8Rq9OVmdlPCgpAqsDqDFtVzRCvW3oWiCaM9558FfKKc2HMHkDZhafY8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lvu2xLcl/rVm2R8pDdFaZsCGPDRXV8uvTq4ma3k6yRg=;
 b=Ejgh2QreB+w2jHpyGnUL+zWwkU7xPhF21xXOt0dKt13zT6XbtqHNd2x1UoCqn+nJGRU7If3MjDkarEsH292GZ60/MtL8HqiDS8Bcb8b+SFfjnmV8X1lJtt6G4ZV3PCInC68qaxImv9Ael6LxUsc+4ZB5LVJG8Ket65S9noKiV+Dc8Ug6FwEndhqvf3LFQY6r27r9kYniOgZixv7p+iMKPfJ92jd8iQzPNNtHaQpRa7iN9qKE9JCntchR9XSvlAIO534ZU/WSEmxf4dCyZROn3G36PEvOhTggk8p9e+SvfXa5cnL7l397jFnIqZEWf2Xsnu3siobk4itETdpZ/QU+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN8PR15MB3218.namprd15.prod.outlook.com (2603:10b6:408:75::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 07:01:37 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 07:01:37 +0000
Date:   Wed, 26 Jan 2022 23:01:35 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH for-next v4] cgroup/bpf: fast path skb BPF filtering
Message-ID: <20220127070135.l64zjm4mwo2cqog3@kafai-mbp.dhcp.thefacebook.com>
References: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
 <20220126203055.3xre2m276g2q2tkx@kafai-mbp.dhcp.thefacebook.com>
 <fbc8acbe-4c12-9c68-0418-51e97457d30b@gmail.com>
 <CAADnVQ+p0B-2_b8hYHEW4UGJ7-T0RMfnZ8cZ4NgpvjMiTo6YKA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAADnVQ+p0B-2_b8hYHEW4UGJ7-T0RMfnZ8cZ4NgpvjMiTo6YKA@mail.gmail.com>
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6f2e860-0894-489f-bfae-08d9e162dc8a
X-MS-TrafficTypeDiagnostic: BN8PR15MB3218:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB3218722D6E02D1CFD7AA811ED5219@BN8PR15MB3218.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDIBQsKVkn5e5KA79T/KXE9JH+vQyQGM+TgAzT6FIZc1QQ8iU6JgiXoyueXRmwP3187Sv+n8h6hUT5GNHfXEhy6b/cIAcGK7aQMTJyr6Dd3hyVrlD4QvLVFKuU1pw28Cc25UOLgAbIyZ9IZMjAjEHNxf902wyFbZQ5+wTsaZab8p4AwjE3UHqluF5WyjQOYaml2LDr1TT5uxPN11zQuIF2ZvhI624mLtgfLzCKSxxDeIM9BN87phZhTGc+OQQCXq/FzWEHMcG89LBUzB9Yn+DmgvEbKLKleC1DePp/+yb7XnjtUROezs35iCRGXfP9uGQQuK4TJBb95ooiIiViCYjOPlcDtepsaTrryHnDCZWOjBwtav0V+CmMfiLBtOS7TWZM9aZgLZdj/u0inPMTjfRz7hC8zOL9YHbcBKe5i4Bpyt7wyVl7mKeCe0dYPUVmP/BlfGB9i10SC+LkY6txAzmcOqf3nkyCKyn5XoPlPGddO5XPZ0HYpVAS8FrvmpQNPQ/bldpj9ome4cMBNBdNeUnu4lAaPL+f7EgAcJ/YoM4kSra5+8be593SRu9uaUdHvEaI9n0jeJ2nlubjiM0pH7CN6qGuuXfRvoLCXgVK+SFT6mfts+t2vS8sFfgkxrUsekxtJmDXDasR1YPVUdpMTGIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(8936002)(8676002)(5660300002)(316002)(508600001)(6916009)(86362001)(54906003)(4326008)(6486002)(1076003)(83380400001)(186003)(38100700002)(2906002)(6512007)(9686003)(53546011)(6506007)(52116002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZdPQHWd6Y9O8FOI6KgUGLHlrJo0tNcGqXSmsHzqZq0fEza9g38LF6B+V0Q3g?=
 =?us-ascii?Q?ryLhjY8wcSOQewpXa1vjz0CLGlfugfmhSc9zW89zgDDWo7yC5FPYDYB4b+kG?=
 =?us-ascii?Q?AUS17XLJvnQVtMB8Tza2mAQ1vEugP7REilOFn0MUDcwxclVeRGbcqrCMyg3v?=
 =?us-ascii?Q?iwx2hA2a5mSYCTsO+FpK0eOfSEtOqqeHlqxXR9S+qrYVI8Wa1t5g4HFnkO+0?=
 =?us-ascii?Q?gT8AecNydnjmY5sQHhNsSPb/QlfLCRf9iATuGcXuaRUmdjoyjra6acgvI04O?=
 =?us-ascii?Q?Cllo+H4tScSSm1Dg2dk637Rd4BHTQS4WbjEro2gUNh/MT+zMx62EVTAARHys?=
 =?us-ascii?Q?bk4WO3QRo6YRjarfaXsTwih1huOdjekHqqNS1SsV+yigRdMmGQpU1+5CRqq5?=
 =?us-ascii?Q?sbycWn9yPks7Es1r1OW1l41KWyz2jCcoZxHyBcqsmkJp4D77arcqcJg5jSbv?=
 =?us-ascii?Q?0wZhnaeVQPBIGxUrKUfBAC1x019TtCdyWTj3oRuNiU0qSRod+mxNXPF2ofo9?=
 =?us-ascii?Q?srGPhkXZ40mI91VRT9/mbw8vDBH+SIqiZ1CcIlfK8Ul0oKmtAhXupR7d3cF1?=
 =?us-ascii?Q?vr/YxAzFjvGuMTY+6vbNeYZOistbBPua2ODmQfyOS7xkLbMcdTB4/pRg1pZ/?=
 =?us-ascii?Q?P4I69jwrZI5wzVSbh1SYTCsQ3bA9/eVKIr2NvfdqF3DQlox/jscD+Ro/mB39?=
 =?us-ascii?Q?vFS9J/qR/tQNpbGQke+SryBx/gNFuPGMZZpPJQ/VL1Lc0lWqIdXzZI3raOzu?=
 =?us-ascii?Q?kVhKYwwup8xR9yWDOGOOXkThjAkOn4FKfg4kiE7WBJLgWLjs3BYE2lKVuvPG?=
 =?us-ascii?Q?NUh60M07p+GzFXv2Mn48aR4/wvFfEY8S6RALGk4R8INRxkUXkKAKKPbQZf7r?=
 =?us-ascii?Q?Ep9tbmV9jOZq9DcGqPhR23xKggiA0Z9RIWCjzaSPH9sneMYt7TAl8dEDTEKO?=
 =?us-ascii?Q?9NYBsCaprIFWTLT7CsfH/4y6k3fhgsPOhKuwQdhukVtGfPVkpxIyhsVbwofr?=
 =?us-ascii?Q?ZxU/tpq9hekcoYndM+575C/03ABoua9Qyr3qqcNy/TdRgGAWSwQlKnYTLXvl?=
 =?us-ascii?Q?avTQJlpvVpqtMWXykkWPt2QuW3O/J4Ewgr5eREy4JNoNW7VjiG/C0laj9GGx?=
 =?us-ascii?Q?17drRb81FqQ0gNHB3xSJlhCm6zL633eyEgW1uZiRiE5L/N3zr3ybuavM+bfx?=
 =?us-ascii?Q?8jD0ZHRdkoSVJhrPAiGiYnao9SjqqLtAvSGMhH32Esfct5NYGzKI/l1Thkba?=
 =?us-ascii?Q?HQ5L9ccRy1rtjQbmy/d9PAHYKDR5L/zLyOlM1+gDlcmWl2oNVeZMAUn61Kc7?=
 =?us-ascii?Q?7ffIMCw03XdGVLlfnRKKzRUcZBIAptbqYCw7P7ZSxmoSsSyGwW1U2K359qM3?=
 =?us-ascii?Q?Ui8Mk7qSynd1XqLA6IMftAjTrhSsXx2gJI+HysT+kOp+QcwMTmewfDYkYHpz?=
 =?us-ascii?Q?9pRp0sP25yZPEG4NafXUjILXznN39HiWKqfxzXSfq/Mi9B24jHoGjE8V2UL/?=
 =?us-ascii?Q?mUfC5mfrzO5tAXvqxgpbnFjmmts7W1fT0Y6vElSq+zKfkY3hbPJzn2wNyIGD?=
 =?us-ascii?Q?BWC4fXgQfNjG81DQ8ljise8hA6YEJkwHybLYzGhy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f2e860-0894-489f-bfae-08d9e162dc8a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 07:01:37.4479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VcVLCUWs2Xv1+6SsKR8dJ3cswAVQSa7K/hfFtfbsEphb+/Tiv4hpN3X6JIiTRRy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3218
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: RRngLX712D8ilBJU87OE6QFIbi5ekvg3
X-Proofpoint-GUID: RRngLX712D8ilBJU87OE6QFIbi5ekvg3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_02,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=645 bulkscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201270040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 09:08:24PM -0800, Alexei Starovoitov wrote:
> On Wed, Jan 26, 2022 at 1:29 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >
> > On 1/26/22 20:30, Martin KaFai Lau wrote:
> > > On Wed, Jan 26, 2022 at 12:22:13AM +0000, Pavel Begunkov wrote:
> > >>   #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)                        \
> > >>   ({                                                                       \
> > >>      int __ret = 0;                                                        \
> > >> -    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))                  \
> > >> +    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&                  \
> > >  From reading sk_filter_trim_cap() where this will be called, sk cannot be NULL.
> > > If yes, the new sk test is not needed.
> >
> > Well, there is no sane way to verify how it's used considering
> >
> > EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);
> 
> BPF_CGROUP_RUN_PROG_INET_INGRESS() is used in one place.
> Are you folks saying that you want to remove !sk check
> from __cgroup_bpf_run_filter_skb()?
I meant to remove the newly added "&& sk" test in this patch
instead of the existing "!sk" test in __cgroup_bpf_run_filter_skb().
I think it may be where the confusion is.

There is little reason to add a new unnecessary test.

> Seems like micro optimization, but sure why not.
The whole "if (!sk || !sk_fullsock(sk))" test can probably be
removed from __cgroup_bpf_run_filter_skb().  It would be
a nice clean up but I don't think it has to be done together
with this no-bpf-prog to run optimization-patch.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1491445C75
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 23:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhKDW7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 18:59:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27002 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232025AbhKDW7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 18:59:46 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4LJ4U2015012;
        Thu, 4 Nov 2021 22:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zpB8o/I5M/a7pwKpJ2DEEeRalPb2ju+EsU9C+XS8PUI=;
 b=ncPqHm8FpYckwsI+En7kDCnNi7tmCt2GCcMC0qyf4XLj54D3WG/x3EgTMGE8dPvLPGK1
 xFFdH1oukAHhfN1JB/c4XLK7emWzyTYPX+QGGkvVOmtTX0q/jNXm1KhA+B1f5z97S3Ni
 1KzxAB5THiduxBjxHN3NszMAiMQ2TPAEmKTGe/kceNYvnQrlcnKdh5Yq0eV6KzgbJ6BL
 XNg121O/JenlBLlubQm4a4APoLkAKE4LEeYxmebQA5UvEbVuZHHaMXxQpK9kttCchBS7
 dOiTvuBTIjJHtZ031Bhm48YbJwIWiMDTAtFt7aoGkJNctm40N47OQ+OhpbuGo5GP8ZpB 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxhbsx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 22:56:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4Mjkpx134257;
        Thu, 4 Nov 2021 22:56:25 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3030.oracle.com with ESMTP id 3c3pg0w8nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 22:56:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7b6vuAOe/N3NRoqXXRDoNsZ3ob73q9Kc7POkJw92M51Jr5f1+kUYx2XvQiA5VEx+6q7inePmEOmm6/f3CsLO7L3lnOcg8P/sF9bZBzID2oivTe1xFu0sAtKCOjFky3hVM0I12M80xVmMjaoV252lJp3+iw0kZpyy3+khchRwAEQZMLkfKw3WTLAVq+sEeLzccSqXoCYnm9R288WVxjpYC2lrUXGWVrziL4dXqRRlYd6QLpJ2KWQdX8KB8JwRmgSLm8XP551ucpCguuvpf2uLeP/Twd0+1W4z+IJR1DFvEvW/lkK7Ef0wEp121E1tptGEd8BG7rI14OjJ9AyYrvmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpB8o/I5M/a7pwKpJ2DEEeRalPb2ju+EsU9C+XS8PUI=;
 b=dLzSrRW1Ayv4zfRnH6nUJTsTFiX7im6huAmkYGrh2T6rSsjr1mQWW+f+bj0GSBsHRtgJa+QmhkorlMCHzBvLgyh3sPrVXiY8o44rSkDJvuOddtHmtMjMbzwG0z5QrCNKSaGv+f29CcAiGsnz71CjHtxByC9Y+AceLLHieqRe0ERd0j86AhyEOSHJ6VdshBhEO1kMb+36UyKgU//aYw1KDRBgiICpuZy4FG65UHawkDLw3Ogrhd31QngIv6kWBzGH7I6HgYHBeEZO8YEx1d+Q//Yk3FrFskZs06+CZktT2RnmSvJXLoN1YxDwlVaPR6F7j5L42POLLSEPP7A+r2YCGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpB8o/I5M/a7pwKpJ2DEEeRalPb2ju+EsU9C+XS8PUI=;
 b=JXdr1G67PU6WitQGKCPuXMiHYjrekGatcMKVIehNke0QBLUBYF0e2VqqlQY+p/xfZFyl3bxx2E/lK9DYQlcDUPgn2sf+aXmwTSucs3hLz7jc1ag6DioiTQf9RMq7klSkJHK4yICQYTAUCmTrX6sq3za+YKabO2Xz4HmmlLG3A+c=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3229.namprd10.prod.outlook.com (2603:10b6:208:12a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Thu, 4 Nov
 2021 22:56:22 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334%7]) with mapi id 15.20.4669.013; Thu, 4 Nov 2021
 22:56:15 +0000
Date:   Thu, 4 Nov 2021 22:56:03 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ardb@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, Mark Rutland <mark.rutland@arm.com>,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        Tian Tao <tiantao6@hisilicon.com>, pcc@google.com,
        Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org,
        Jisheng.Zhang@synaptics.com, liu.hailong6@zte.com.cn,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add exception handling
 selftests for tp_bpf program
In-Reply-To: <CAEf4BzadDy006mGCZac4kySX_re7eFe6VY0cHgkpY3fQNRuASg@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2111042248360.7576@localhost>
References: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com> <1635932969-13149-3-git-send-email-alan.maguire@oracle.com> <CAEf4BzadDy006mGCZac4kySX_re7eFe6VY0cHgkpY3fQNRuASg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO2P265CA0152.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
Received: from localhost.localdomain (2a02:6900:8208:1848::16ae) by LO2P265CA0152.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 22:56:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc0f8ca6-72af-40e6-71b3-08d99fe64e0d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3229:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3229E77A9A1254F84BBF0897EF8D9@MN2PR10MB3229.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LH+8m7+yPKAg+MSXjaUUssDkZEuX46uSSzvtlIXMROsbSJB9CFh5scNjRNvLuf6ozCe0LyWRnoe1Wmd08TGDq78hAn87/us5nhRj0Z1oGfMP8+FgBiR6VWXIrrnCS9yJ8NkjyLJH5HeVQ07nWNmV1w+M/O618feScIsMpRxggTmeOWaMfFdPaFrzX5m1vaISRu4FnXjui6PoBZ+9AdpB2HfwSiuzjl9Ss0UCD6k8NrhpcIv6Qile1SpZ91RS8KIhiZwMapExRVlMGe40cnsBC1H/RrfQrfW1xoLoYrEhP06TLu/RWhdm6HpadmDd9RpLddsrtrCp3sbGD4YLpEjZxIZ3N9EDrXGhR/bs8KuEX2Q+YIpHix/OTBTnSkmOg4t+PY57c8cRG05etgAw1db93pXyEYyAbkLf5T6C/VcUYjyf+hSEDA3Mg1SImeGqhIluCo5ApK0zacMSavwnw8N8yAp3y2IhLjMt3z+wvFnGLbyvgow+C+GZzxymw2ivliG5YnBnRLt15W1SMzxlO7s7xIk+TxGuNdNMrHizr5wGVNobn0OeUlUuVNQzeusWFN5dTRzDXdfa7D351OVyQKJCpKHwiSpkqxMrKolBwL/pvpkBd9blQafaZlhMTHrPq8oZ5a5S+Ok+msDslNd63V2+bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(6512007)(66556008)(5660300002)(86362001)(9686003)(66946007)(44832011)(2906002)(66476007)(6666004)(7416002)(9576002)(53546011)(186003)(54906003)(8676002)(6486002)(316002)(83380400001)(38100700002)(8936002)(6506007)(7406005)(33716001)(52116002)(508600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NrPUdh3oo1Jtd+BW75ogkcTN83iXXK6ONbdmBrJPZefeNQ1mklylqe8MRpS?=
 =?us-ascii?Q?QwoQZ3vtWI3YT9lWxZ2Wut6V7hVBmtKMMYcFUp6xYGyQ0NNL8TzBCl7bGMIe?=
 =?us-ascii?Q?L5u7n2ucy5LE+P3TsJ+A4Mz69yDL0WoWgXctLNVxxPMautpqXlYESs43zCzu?=
 =?us-ascii?Q?7S6D2yGIGpc1r2f8VSw9h5NbtuSjGsfUiMI5pHeVOTjBbjflur89puZbJieH?=
 =?us-ascii?Q?VQPAw/lZacoojhf0eyAvrNFNGJj0S19yCMsfAwDXFKYHg/f2i9a7RAUQqf3a?=
 =?us-ascii?Q?k60HCm5TzBg60evtH656VHRgE+EpJ2Fbk0VND/uthWFmq8uncH99wp9w2vtP?=
 =?us-ascii?Q?8zWpo42vD0j0xkl6+YNqTDDrzdaDHQq0V6r6kziTIxn4kvJty8cX2B1CTDU6?=
 =?us-ascii?Q?GvU86n75vQtlA+Za9hXe3D1vd5YQRV53qvfaGpYNpEu4oT6VReaLMMXywmcR?=
 =?us-ascii?Q?y8SlsQNaA3h2lLGil/4MfoVDJtYdqM1EvnoITjrYGHJv3xfG41qmZC1HIcQo?=
 =?us-ascii?Q?3vmFWC0V8LWyefGZBGjuXxkBBjIaODGGGqHBqF8WP1XCorBBBU6GPxz9CiyJ?=
 =?us-ascii?Q?98ryWiOovYDdW3jQ/CgBVoiJreIvji+jqSD5vUoPvF5N+1d0MHHntobjVGCK?=
 =?us-ascii?Q?WBCZoWCRHPpUSObqSi2QA57lzhYPnuJJVk2otRGcMq+IaUfHfMIJBqBDGxtK?=
 =?us-ascii?Q?q5fZvMt5VFikonfW0o6dKQv2LdbETPYjbN0rZUHntGgGL3yhwgr/0HpF/tU4?=
 =?us-ascii?Q?scvb7EnN1oCyoxzZ1f0+HWLkz+M4DRy38YjArViDxxWdpFZngntwF8jTq8cv?=
 =?us-ascii?Q?ErsVzW4PrXSQxlmEE85eKv9o6XN8Fk56Nd0BzPT77XiczMney9LGZpyT/8qI?=
 =?us-ascii?Q?32tFz7sLytXcHMCvgmv1tIKuBk5FSGw3EHtwmOHqvCfgQKGn+v2OjEqpuSmo?=
 =?us-ascii?Q?INDottV0dI/qxrHXKJyMCuIoUUDPW9LCAANHEPYS561cO14b+apG5lPTiBOQ?=
 =?us-ascii?Q?Ai9GtyznTmoBydZKZKJpzokU4eINf2KhiFQnlpWcXrr2fly0XbMj5uTqZplB?=
 =?us-ascii?Q?Xzn45DBNOBXBNecBZHdWxoXYihMDtwghq4xD8nCaUhX1e63BW7RUGyn39fIV?=
 =?us-ascii?Q?4PiOpm58DyTwwkLEmzQ73DgTjAoAQKH6wgN5CHTNxvYbeAynto3UUIzS5kDg?=
 =?us-ascii?Q?Ae6u6VRkI+3GKFpo6zGttY4jdNgHuMpXpZT2EGPhlP27bEHE/fvzYhOQE2/s?=
 =?us-ascii?Q?A/AnzQEiiyTyxCTITAl4x6Duf4GdO4B2g1e6/8/6SX3D88XV4qo+0tiWbYtG?=
 =?us-ascii?Q?+JbcxcKIaA6U0OIQTfyTnoLusVfGbpmmvzJuV2+GxgTlNv953bYIjLnxZfb8?=
 =?us-ascii?Q?bWU+fPk4N5q7+2+8FjvW4yF9i6v8GMo1dxQtV1hx44Lo0iyHV9z1SiJ6miI4?=
 =?us-ascii?Q?yqSS8rIt4D0E6VzuDHws280LAJGVwYwin653wl8sboXrKJejOUyqTtgaxlDX?=
 =?us-ascii?Q?BrakGiaMJnk6KteUqRA6JIysLnFY0mc4XCJ3/LQjjVkdv+WsuYb/YamKEBUN?=
 =?us-ascii?Q?BbfZbOcSsMyEbP5GkkeP2MhhooWSTRNUwEduch2SZoBohEbGKGyyWSgmSanA?=
 =?us-ascii?Q?pMntlCSjQ48MegUPtkxz9TSvzs3+k18j4G8Mys30eX3E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0f8ca6-72af-40e6-71b3-08d99fe64e0d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 22:56:15.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WygAbl9fFlBKfQKyYmyKNHY8tvGkVkajCHdYnKm6Z2YJScW1vJ/yhk8DlzwJFSloYwwO58Xb3uazfCcDGw2sEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3229
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040089
X-Proofpoint-ORIG-GUID: BDNHQcGejeT-TE95Q7ijSxiO78gcLul6
X-Proofpoint-GUID: BDNHQcGejeT-TE95Q7ijSxiO78gcLul6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 3 Nov 2021, Andrii Nakryiko wrote:

> On Wed, Nov 3, 2021 at 2:50 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Exception handling is triggered in BPF tracing programs when
> > a NULL pointer is dereferenced; the exception handler zeroes the
> > target register and execution of the BPF program progresses.
> >
> > To test exception handling then, we need to trigger a NULL pointer
> > dereference for a field which should never be zero; if it is, the
> > only explanation is the exception handler ran.  The skb->sk is
> > the NULL pointer chosen (for a ping received for 127.0.0.1 there
> > is no associated socket), and the sk_sndbuf size is chosen as the
> > "should never be 0" field.  Test verifies sk is NULL and sk_sndbuf
> > is zero.
> >
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/exhandler.c | 45 ++++++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/exhandler_kern.c | 35 +++++++++++++++++
> >  2 files changed, 80 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/exhandler.c b/tools/testing/selftests/bpf/prog_tests/exhandler.c
> > new file mode 100644
> > index 0000000..5999498
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/exhandler.c
<snip>
> > +
> > +       bss = skel->bss;
> 
> nit: you don't need to have a separate variable for that,
> skel->bss->exception_triggered in below check would be just as
> readable
>

sure, will do.
 
> > +
> > +       err = exhandler_kern__attach(skel);
> > +       if (CHECK(err, "attach", "attach failed: %d\n", err))
> > +               goto cleanup;
> > +
> > +       if (CHECK(SYSTEM("ping -c 1 127.0.0.1"),
> 
> Is there some other tracepoint or kernel function that could be used
> for testing and triggered without shelling out to ping binary? This
> hurts test isolation and will make it or some other ping-using
> selftests spuriously fail when running in parallel test mode (i.e.,
> sudo ./test_progs -j).

I've got a new version of this working which uses a fork() in
combination with tp_btf/task_newtask ; the new task will have
a NULL task->task_works pointer, but if it wasn't NULL it
would have to point at a struct callback_head containing a
non-NULL callback function. So we can verify that
task->task_works and task->task_works->func are NULL to ensure
exception triggered instead.  That should interfere
less with other parallel tests hopefully?
 
> 
> > +                 "ping localhost",
> > +                 "ping localhost failed\n"))
> > +               goto cleanup;
> > +
> > +       if (CHECK(bss->exception_triggered == 0,
> 
> please use ASSERT_EQ() instead, CHECK()s are kind of deprecated for new tests
>


sure, will do.
 
> > diff --git a/tools/testing/selftests/bpf/progs/exhandler_kern.c b/tools/testing/selftests/bpf/progs/exhandler_kern.c
> > new file mode 100644
> > index 0000000..4049450
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/exhandler_kern.c
> > @@ -0,0 +1,35 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021, Oracle and/or its affiliates. */
> > +
> > +#include "vmlinux.h"
> > +
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +#include <bpf/bpf_core_read.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +unsigned int exception_triggered;
> > +
> > +/* TRACE_EVENT(netif_rx,
> > + *         TP_PROTO(struct sk_buff *skb),
> > + */
> > +SEC("tp_btf/netif_rx")
> > +int BPF_PROG(trace_netif_rx, struct sk_buff *skb)
> > +{
> > +       struct sock *sk;
> > +       int sndbuf;
> > +
> > +       /* To verify we hit an exception we dereference skb->sk->sk_sndbuf;
> > +        * sndbuf size should never be zero, so if it is we know the exception
> > +        * handler triggered and zeroed the destination register.
> > +        */
> > +       __builtin_preserve_access_index(({
> > +               sk = skb->sk;
> > +               sndbuf = sk->sk_sndbuf;
> > +       }));
> 
> you don't need __builtin_preserve_access_index(({ }) region, because
> vmlinux.h already annotates all the types with preserve_access_index
> attribute
>

ah, great, I missed that somehow. Thanks! 

Alan

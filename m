Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6603428DC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCSWqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:46:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37014 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230218AbhCSWpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:45:49 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12JMchHu031821;
        Fri, 19 Mar 2021 15:45:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YFGx2WWG5YQ4r3/fCJSSBlhYcwPJ8k32DGcAIiZIdKY=;
 b=M2uXdsWkyomy6ZCct1hpNfRNYyC1hECCc+AWioD6Pgbnn2pqlbZeT5JXSX7oEuu2HbS+
 XeownLJjij2AFQE6LzLJ3UKcTZbnxJe7xRLOXCOzWGMgUzVnO8Sfj0YkpWan4Cn8Gcn2
 5FKdHBvNZHjo2qYN+zSgvmPNbKfvUQ276b8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37crcwv647-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 15:45:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 15:45:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zaw+qqA5sLfpTHACmdUf6RO98BUQx/rbkM3qW31vhpwsvX3fUqCBV81cGhM0iUq78kE+4RlaI27TuvnZP8BmXmESoTtdRqaKyQRdnrR9CQoOmpDWPtlgA60/MZoRzp1lAtyTfwnniAxslQ8tR8SbaSaoZeoLHg0ctK12ZUHRmdQkp+sAQhmEqPJ9Fm44pEvUepL42kysnwLCniCTstWfTWIrxJhJR1uFbRoRBthNy5cwEhtYRBRmC9r6VmOsrN+pwbaJxSMQnzyDQtWEuPsP7WRsC9PLlYPLzPH6Rui+1KtEiNJ/K/ZmNuOj1OZ6BkgRjfsKDXOR+GtF4wEagSzAnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3RohyZNST1fzLoDSeTYPzKTgO55Nt+fNh/1rXNC4ho=;
 b=Hxx15iIwccw98lY0xYw8PfRd5ARpiiFGPo8uJAPP9eFgaQoBN0iDRfhQtCedoWtQZa4jaTBfljKmKa4Vco4vL3ouBBxRGRDq4EWINQMbNTcGvJBZdEtS3p8E5lyufW35sSyKC3wOFPHmWZKWnwNsXIVxJR4cLHtPb2HaPp+Phn9iBoUPH1oYHB954YYugpZzPthjO1h4kOtxwxpTgvh0ySPKXbsVhuAXumQapmcL/hIMFh6zk1fxh18v3xCH6xrAHTcz3ccDMzuZ+r1but+5tmCAiNzYLrZH7HApn8if5VgNbDDdrjh5xmNIsRqk8GBdYEFAF/oskZKALqWkbBU6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 22:45:33 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.024; Fri, 19 Mar 2021
 22:45:33 +0000
Date:   Fri, 19 Mar 2021 15:45:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Message-ID: <20210319224532.7wlmhrgtrvkwqmzg@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
 <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
 <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
 <20210319221950.5cd3ub3gpjcztzmt@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza6Fiv+AFJc9-L=S6Duvm7wyyjvqoDGEED3TDTmwiZvVQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4Bza6Fiv+AFJc9-L=S6Duvm7wyyjvqoDGEED3TDTmwiZvVQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:d22b]
X-ClientProxiedBy: SJ0PR05CA0125.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::10) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d22b) by SJ0PR05CA0125.namprd05.prod.outlook.com (2603:10b6:a03:33d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Fri, 19 Mar 2021 22:45:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0669c5c4-59e3-4a7f-eb1f-08d8eb28b4ba
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3570530DB981FCB9F206C28CD5689@BY5PR15MB3570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+zopY7q4xuRxW8tx+BpAG5cuR/mgCPkXfMtb+X3xXlKUsMwKm0X5qS/CSsjpB+cwegdYpJ2FZDHfLWqOQC8FuT7bd20wm4SYWdEX9m/RgYSrMht+rZswWjtpsrYv/dGtEaWcKqbEtCSxeZMxEZjTRVRcMgGnchSEl4LC6KqYQjyMUmsa3bPCKtT+0tDIPAyPdEbVMj4XATQXBt1gsgnUlN0gkehQBmxNukgQ06587SPP0ek/XuJkP2yc0zXFULd5sGcBAbCNhxkWmqOC7jMSS+fh+L291JRVZkzPaB+N4ksbkzz//vPb0IRr2Hrv6Z/2ep9wLR0esjtFaDrr7l089eZjDtUtjlEnn7OYzUXxJl7iq+ebJ+91VKND0KUHUO0iamsnTD8BxgbtduNuwD2Ore0/juAo0ZVMio6dH01FOM4Yzv1rdn3mFeZzvseRYdCM7hgk16Nf8iOEFY4SJiBwBGVHufXbplOSE5kiGaf02y+aCWu0Tl8YH7jb+3CSJEZHrZ2B/aXzr0WWQVLW6+/k/Dua9xwnTssJlT59vh7GRxU9peml+z8TE1bAZQwzeW6WfDBAHPq4XoyyNdLwViqmx5Na2wUfWgz1FDWxCLCNZmTKdLmfPiJYpQs+MUWUl3zwWgJ0k2qUzK6UjJDwmS3Ni1Wz0NLT2XryFK5RrOVb+HS1z4BRvwAiozx8LWsUCBaIRNhnbQoKF8n+H7tCVqip6ndxTpiBqjNmMKYugSDBvUglzJp/9V7+LBSEkrekVCC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(9686003)(55016002)(86362001)(4326008)(8936002)(6916009)(54906003)(1076003)(186003)(16526019)(316002)(2906002)(52116002)(8676002)(83380400001)(66556008)(66476007)(478600001)(5660300002)(6506007)(53546011)(38100700001)(966005)(7696005)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1JjTBZogGEB9+ueselufua7SLWm/dpBkemwGtRlNwKJU6G5+ciWIwolZbEOs?=
 =?us-ascii?Q?uR/3nepbVQSZc9IdFsqw1KrZD9PPwy5arPNRWp8MlJBMVv3W+t0cCy9GV5M+?=
 =?us-ascii?Q?5MeHUzSkP2yt02amjZL6dSeQfPhsAFBgkatIdzL/y1BUpCgMLoDiFsmPU4fz?=
 =?us-ascii?Q?GR6aVvk2kg6GxEKcZQLO0R69p0Pieutv5u7hdW6FFM4RN+y2yFmlNijGfWM0?=
 =?us-ascii?Q?OA62gH9aKkVgAXJQUQ3t75Y9IiPnFHJLujYb08sCDUiuCXjEfxsjErkQJg3H?=
 =?us-ascii?Q?SxLNmG2uCjh4dJ3vUMnEcPLhIkjw27gfmmD5ih5c7Dcg9KRQRi0UgCVJQIX+?=
 =?us-ascii?Q?YlAVt9ws7m9wj4SXINCxMrbfU8iH1xTXr5Yczk7PUYBJpSfMzzsho3EElI9r?=
 =?us-ascii?Q?cmJlO6Hkrm6njnI7Sn9N2JUivbWhO62HPk3h2ZXa81sJ5kukUJoGFNaF/yF0?=
 =?us-ascii?Q?nUw12D85MPkHyT+d2147jQC7hyOhMtb3bFYs+1W1C/u+SG8kfmA0AFtnMJ2A?=
 =?us-ascii?Q?lAwtBr55/9KHOKnEISo0IC2RKkGvML+4zRRgdOFdVpatSZ4a2TjVQOhZFeoP?=
 =?us-ascii?Q?KXBtS0xu4VuAopBQVKk6fR1WElgkPzMn2MVww9FfzqEXXYADhofr4lrYy5V2?=
 =?us-ascii?Q?akDVxcTTZtgSAX5BOYR3T7Y+Qu1Nrlf7sZEjvyUbvre7Oqo4eixuQOliw8X8?=
 =?us-ascii?Q?iuTrKrML8bHKiJ/CHO0eryI+dZ0aN1rXWFsIJkvJVkbTh66u6wcy0vjPL19i?=
 =?us-ascii?Q?20+0GZWn93DjvQmpAM0dKurplKLhJ4N75uJj+VH563yGpA5TfJGhBTK6r016?=
 =?us-ascii?Q?+dgZkyBpGbLjVtoQlLpQtlf420mtlh1uolYCcRw3t4pgVikLEuuWInbwJ7JQ?=
 =?us-ascii?Q?QPY3Rg27qKSJoczmkW59t36UcrZO2xCUaW9c7FWo4kKzHNED5zcfyW8+mkHB?=
 =?us-ascii?Q?d2fORMtXnqnelYfBD+vHZf/eMmzVz4bPOATW+SgPjtjAHF27PhBmgPnMO1zV?=
 =?us-ascii?Q?BcJsMvxAiSxja0HZ5Wb0szNLiiqaKRVW/j0C5psoi6v3YHFJzaThq1wjYBWl?=
 =?us-ascii?Q?kKWgiag47VUV6nwx9gi4RN9sJs0TZKWyOcHXkjFABp4U35VBbaYJuzwqKbKP?=
 =?us-ascii?Q?X0dg+sdTXSjtdYg5E0OxM1iPS6gp99y/W9zA6paOSSMkIx98cqaTd4ZrkIXg?=
 =?us-ascii?Q?WS8iJwrM+F9+ywQ4CVJIgdz1oRLEHRcEWfqdWhho878FA+go2ZDNJBZU32PF?=
 =?us-ascii?Q?OqAE0fWVk/fz242Mn3VVn+4gMCP7phyodLjyiQZ8LI6IsVR7Uzu56cvhrlAu?=
 =?us-ascii?Q?nLP4SgmXpQifddfCFl8/uVLSBiuVf+V9DqWX8RhH3D95yEa8GhCiRKh/9iyM?=
 =?us-ascii?Q?3+v3K2w=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0669c5c4-59e3-4a7f-eb1f-08d8eb28b4ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 22:45:33.7352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6u40F+Eh9hhIsmij6JeRlwjkzX4qGR2JvrGwpwHvVeaSHdJbYwl45Q8MQ/uO6t+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190156
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:29:57PM -0700, Andrii Nakryiko wrote:
> On Fri, Mar 19, 2021 at 3:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 02:27:13PM -0700, Andrii Nakryiko wrote:
> > > On Thu, Mar 18, 2021 at 10:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Thu, Mar 18, 2021 at 09:13:56PM -0700, Andrii Nakryiko wrote:
> > > > > On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > > > > > > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > This patch makes BTF verifier to accept extern func. It is used for
> > > > > > > > allowing bpf program to call a limited set of kernel functions
> > > > > > > > in a later patch.
> > > > > > > >
> > > > > > > > When writing bpf prog, the extern kernel function needs
> > > > > > > > to be declared under a ELF section (".ksyms") which is
> > > > > > > > the same as the current extern kernel variables and that should
> > > > > > > > keep its usage consistent without requiring to remember another
> > > > > > > > section name.
> > > > > > > >
> > > > > > > > For example, in a bpf_prog.c:
> > > > > > > >
> > > > > > > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > > > > > > >
> > > > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > > > >         '(anon)' type_id=18
> > > > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > > > [ ... ]
> > > > > > > > [33] DATASEC '.ksyms' size=0 vlen=1
> > > > > > > >         type_id=25 offset=0 size=0
> > > > > > > >
> > > > > > > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > > > > > > The current "btf_datasec_check_meta()" assumes everything under
> > > > > > > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > > > > > > The non-zero size check is not true for "func".  This patch postpones the
> > > > > > > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > > > > > > "btf_datasec_resolve()" which has all types collected to decide
> > > > > > > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > > > > > > differently.
> > > > > > > >
> > > > > > > > If the datasec only has "func", its "t->size" could be zero.
> > > > > > > > Thus, the current "!t->size" test is no longer valid.  The
> > > > > > > > invalid "t->size" will still be caught by the later
> > > > > > > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > > > > > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > > > > > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > > > > > > "last_vsi_end_off > t->size" test.
> > > > > > > >
> > > > > > > > The LLVM will also put those extern kernel function as an extern
> > > > > > > > linkage func in the BTF:
> > > > > > > >
> > > > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > > > >         '(anon)' type_id=18
> > > > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > > >
> > > > > > > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > > > > > > Also extern kernel function declaration does not
> > > > > > > > necessary have arg name. Another change in btf_func_check() is
> > > > > > > > to allow extern function having no arg name.
> > > > > > > >
> > > > > > > > The btf selftest is adjusted accordingly.  New tests are also added.
> > > > > > > >
> > > > > > > > The required LLVM patch: https://reviews.llvm.org/D93563 
> > > > > > > >
> > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > ---
> > > > > > >
> > > > > > > High-level question about EXTERN functions in DATASEC. Does kernel
> > > > > > > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > > > > > > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > > > > > > FUNCs in BTF.
> > > > > > >
> > > > > > > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > > > > > > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > > > > > > care?
> > > > > > Although the kernel does not need to know, since the a legit llvm generates it,
> > > > > > I go with a proper support in the kernel (e.g. bpftool btf dump can better
> > > > > > reflect what was there).
> > > > >
> > > > > LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
> > > > > replacing it with fake INTs.
> > > > Yep. I noticed the loop in collect_extern() in libbpf.
> > > > It replaces the var->type with INT.
> > > >
> > > > > We could do just that here as well.
> > > > What to replace in the FUNC case?
> > >
> > > if we do that, I'd just replace them with same INTs. Or we can just
> > > remove the entire DATASEC. Now it is easier to do with BTF write APIs.
> > > Back then it was a major pain. I'd probably get rid of DATASEC
> > > altogether instead of that INT replacement, if I had BTF write APIs.
> > Do you mean vsi->type = INT?
> 
> yes, that's what existing logic does for EXTERN var
There may be no var.

> 
> >
> > >
> > > >
> > > > Regardless, supporting it properly in the kernel is a better way to go
> > > > instead of asking the userspace to move around it.  It is not very
> > > > complicated to support it in the kernel also.
> > > >
> > > > What is the concern of having the kernel to support it?
> > >
> > > Just more complicated BTF validation logic, which means that there are
> > > higher chances of permitting invalid BTF. And then the question is
> > > what can the kernel do with those EXTERNs in BTF? Probably nothing.
> > > And that .ksyms section is special, and purely libbpf convention.
> > > Ideally kernel should not allow EXTERN funcs in any other DATASEC. Are
> > > you willing to hard-code ".ksyms" name in kernel for libbpf's sake?
> > > Probably not. The general rule, so far, was that kernel shouldn't see
> > > any unresolved EXTERN at all. Now it's neither here nor there. EXTERN
> > > funcs are ok, EXTERN vars are not.
> > Exactly, it is libbpf convention.  The kernel does not need to enforce it.
> > The kernel only needs to be able to support the debug info generated by
> > llvm and being able to display/dump it later.
> >
> > There are many other things in the BTF that the kernel does not need to
> 
> Curious, what are those many other things?
VAR '_license'.
deeper things could be STRUCT 'tcp_congestion_ops' and the types under it.

> 
> > know.  It is there for debug purpose which the BTF is used for.  Yes,
> > the func call can be discovered by instruction dump.  It is also nice to
> > see everything in one ksyms datasec also during btf dump.
> >
> > If there is a need to strip everything that the kernel does not need
> > from the BTF, it can all be stripped in another "--strip-debug" like
> > option.
> 
> Where does this "--strip-debug" option go? Clang, pahole, or bpftool?
> Or am I misunderstanding what you are proposing?
Could be a libbpf option during load? or it can be done during gen skel?

> 
> >
> > To support EXTERN var, the kernel part should be fine.  I am only not
> > sure why it has to change the vs->size and vs->offset in libbpf?
> 
> vs->size and vs->offset are adjusted to match int type. Otherwise
> kernel BTF validation will complain about DATASEC size mismatch.
make sense. so if there is no need to replace it with INT,
they can be left as is?

> 
> >
> >
> > >
> > > >
> > > > > If anyone would want to know all the kernel functions that some BPF
> > > > > program is using, they could do it from the instruction dump, with
> > > > > proper addresses and kernel function names nicely displayed there.
> > > > > That's way more useful, IMO.

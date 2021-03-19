Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11BF3414DC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 06:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhCSFaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 01:30:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233866AbhCSFaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 01:30:01 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J5PwIb011496;
        Thu, 18 Mar 2021 22:29:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qr4CjM/ng/2vSzsJCZ9eIPnTfSIQaryqU0XaUyYktWA=;
 b=HiJD0Snqhs18+WFRcB4vHPKJziGa97gM8iHquTdw4kdPLsy9DsVD6KGIEniRrRRGgD/n
 Gf6YT6sNV/5o8LG6ZzML8M7Et8ftbMIkt/nnoppv4z5UxPVjhuat9o6AZI3pzOyc4fis
 JtcqrsQ5PTYowTOF+pi4g9Ce1Xv82zV6MvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1w8tu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Mar 2021 22:29:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 22:29:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1swT7YLamVDs+Bpidx/Jmw+nydVKYo4qIjidxg/L8Q3GNFfYOVYVSpV3vRYg/tcYb0cKOWbuYy0J5BeQ42Z2Ri2pvn3GZWeufLKFlU2XlDjD5wbR3r+htp4DGqKhpja4WwDr8FUXr+VJ/kepo9FGXX7Ur3Egw+gfgK/LOHiOXH1xilu4axMCFlc+SeLQ8AmldeWOSakc0qfUuXnY+V3KHDwNwTKVFU4YdewgVQBgvgWZaMPs+3LUKxTBQW31fLW7JL8KwpbYcuCnfN7SKJC7NplTv02jSJHKkFNYVDIo5XXzfnUGwpBFlC3YG7wC3InrguFeDtH9XMzqjuUrXUVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXCxIBJCESWcbMUpYL1gwhZKknWmSNr9e4KrVI1dyKw=;
 b=aYYnQ0wD5RtIBiiAMNB8nopumwqxbkvPiYLZfTKfuUchXzDiLVyUfw6E5ofZA0yByI7S6taKXzZ5ytkruZ71nIskzNc2KcUbS8QnhQizLilM1fdle5PxAe1ojZT1oBXr56j0Xcbz6PxAsF/+WcOpquU24JN0V/5zyFdvZQtACuCXdxTLCg/N3jT5p+3IbcmeRmjYbEKcd+VgGvoafWH6nDhX3v5wnZ2cLIB7sPaHAcuAFX1wmkSk9xJHmtyVlpUzUKeq7IN0TYXHI8rs9z2sjGE82OnS5xVz9D70NOEo9nJuZDbXApXrzminRET4obdeHe+wqUdziyAA2FzToG2gDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3414.namprd15.prod.outlook.com (2603:10b6:a03:10f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 19 Mar
 2021 05:29:45 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 05:29:45 +0000
Date:   Thu, 18 Mar 2021 22:29:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Message-ID: <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
 <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:2c43]
X-ClientProxiedBy: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2c43) by BYAPR07CA0086.namprd07.prod.outlook.com (2603:10b6:a03:12b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 05:29:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cf4b74a-05ce-4fc5-f2f2-08d8ea980140
X-MS-TrafficTypeDiagnostic: BYAPR15MB3414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB341409A2AABFBE312664E641D5689@BYAPR15MB3414.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a15qxrEu9ivxfY2Q7HrhW9FenOabaX9bSrWJ/mS1en716NjFNCUkOUNOE1c5Mrl/TwSLdmWEGYxyTA1jd+p+t3u8oajqQuF90whmECmD1mjrzFuNQmq3ItmUSiD7H5TtZOJjvPqoXq0tERnHe5TdpiGwYVEvRluyXHD+v79guHVE9CthDwU0vb2tI2f/ehY5X0dQv+9K6hfdjD3xYzAnoy99JoqvxeLSBpOIVduoqo6ZnX+nLHguxMCddQ9+UHBfqIaXJ/Hsh353ql4VIkcEzEuA0Z4uUPgw85F2ZLEvHAkqA13x83oa4EJKUs5S+94QmfaC+fn3N6rlUh59qMC9BQ8MnEgk/cX+S2vM/mh5eiQP+fjIXAHt4bq5Q8Uked9agLd/UboLjeYkxjEokHZaeKKuyqHsTy40lNBKJquPUr+eu61tyYJSPJWdT9VvXuFEaKsfJtXc851GxRX8pPWv3zuPv3iDLdx/aI0GA+IM0aeD5BO3QIWqAPUl9Orma8BbkmYfWeTjbM996W9b01VxPkxht9jgLrikrvWgLk+y8gwffgXDmX+ggCxsOmY0r5Dh+inum+nppzqADhoRVg4LwNMEXfPZ67pE0DAe/Pe7/iLdm7yL49yiKNFyLbQZPyO1Uaa0ejnddaAwgC4fJcmJUqc+HkkAGfkTWAsok91fJTrfkrKe8cC2AOGNssaQxiCy0MvNAhoIC7f2NT6Jfy+LQZYStJgp9BzsG4KNXLa/OUJd1KOgxf69mx8h0/u2WvM9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(136003)(376002)(396003)(86362001)(8676002)(966005)(186003)(5660300002)(1076003)(316002)(6506007)(4326008)(54906003)(2906002)(55016002)(8936002)(478600001)(66476007)(53546011)(6916009)(16526019)(66946007)(7696005)(9686003)(52116002)(66556008)(38100700001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9UO49CLFwrD9z/qt/zgcNNXslnWOUnPjl2sWIWkSm4ngVPIV2cB+TZzBD8sZ?=
 =?us-ascii?Q?bnipD5jBvQaDrMoq+qYki7PE8S99S5bnXqY3GfvB4LjSxd4H2lYv5pSxI5/o?=
 =?us-ascii?Q?pzPyJxQ4+mhbn4xXckCcXMJ8OV7xS5sofQqHz3OXRd5/jXch0uta92Fa0Lpk?=
 =?us-ascii?Q?rOfR118+xO0y9HURQFgio8Ib7+/J4TePiN1JLX2MZlT11YBFzyqwWyMFxGrw?=
 =?us-ascii?Q?oDtRyRXC3YwAx1Qo+2sd+2VnwWdrPbuOLTpVCjiRye0M5jisYvQXGwHjil0s?=
 =?us-ascii?Q?M5LgfAl1bxSddmfSBGa0jbVuCfQFr0CmuQxnuuIOImsptw1L+MuZwF17BcpV?=
 =?us-ascii?Q?iAHR2w0X4JJPEZde8zHVe7HybO+/MDjiDAVj4Di+1zU1gXl9j5fsSjkpFgWj?=
 =?us-ascii?Q?qHRRoVc++5av3Z7r0skfZ3enyWdJbTw/WnQER5JoXYkMc828em8iSjwaglO/?=
 =?us-ascii?Q?6n1WicmFF1VuQCumSBGTIgTrJBGN8Ux5TnRHoipYx9obXKVPLQh1Vw2cU7jn?=
 =?us-ascii?Q?bMNiZP+S+iZV7ljZt6GVuZ4GMBtKufhiFhZ9zFMz54POhFJpCLQgnobXvj32?=
 =?us-ascii?Q?9eZOuyKRBHDtKnIKNwwDWHe1LpPLYGWHM3KnOyxyaOiuBodwmTh3QLIW/wjM?=
 =?us-ascii?Q?Kixv7YrgMHXGz093gF1m2EMHCpSMve70BZclZ5mDVLZYiJ8Cr7tWwfDFywDO?=
 =?us-ascii?Q?ltO6u6pGZbeJ4k05jh5PJ8WrOhzHNzVmpT6nVAwZ69kb8os9+DEdutFlpQ1C?=
 =?us-ascii?Q?YtGwezVjsOPlOIJLciEC9rt0sxA5IqW5yIrQ9WADK+zTnPgBTmUwCbOPJ+P4?=
 =?us-ascii?Q?5jZkOTd4YSdxyp4AlDvSIMgUC5jCS0ayLQX3uoR5UzLB4XBxh6KLXlnFSrq6?=
 =?us-ascii?Q?/kYfign2kMROVR6kzccKBZNMbeJIVe7qBn0LzxmvgMygcqaeUQ3+pgMIej9Q?=
 =?us-ascii?Q?OqL93ZfL4yvCg3y1WpoizXQoB6HkybEjtV5cjFTdKU+Twf8n6uLzF1vaVyeD?=
 =?us-ascii?Q?kcjdq6QIkALndP+eHNDvhk2gAydBB1VTWjcCkUdEiGLEmQsO0ucz09dkgAUJ?=
 =?us-ascii?Q?8v3a0uG5hWvxwuLHfB3+/DRlIRD16uWVsaU6nLUZw+Hu8EXp/TdpXo5kRSk/?=
 =?us-ascii?Q?kBr0knJEmZ54jS3qNpwj08iqlm//glioPLv/B4hZE1l8TBOxqFw9n9Qki4jj?=
 =?us-ascii?Q?06YUjXPouqC90U0ofpHtEwkKSA3HcI4rsY1PAGTaJURiK7o7Pxx24fZummds?=
 =?us-ascii?Q?72qBkeERZynkV/agGrcccdJ69nfBIQvElXn5/tZwllSBbq7AgylP/7UTzjUI?=
 =?us-ascii?Q?9KP2BbZHuA9qseLImfvUUv4RWaTZjvvNAoXQ/457WGYlyiPRogeXcgsNAlAF?=
 =?us-ascii?Q?++pEgRk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf4b74a-05ce-4fc5-f2f2-08d8ea980140
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 05:29:45.0896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03+C9n0s2JHzYxLwha75J2MwLx/taQWl/JbwDS2AWfUOau5QAPxHKwQK3sRWarp6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3414
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_01:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190039
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 09:13:56PM -0700, Andrii Nakryiko wrote:
> On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > This patch makes BTF verifier to accept extern func. It is used for
> > > > allowing bpf program to call a limited set of kernel functions
> > > > in a later patch.
> > > >
> > > > When writing bpf prog, the extern kernel function needs
> > > > to be declared under a ELF section (".ksyms") which is
> > > > the same as the current extern kernel variables and that should
> > > > keep its usage consistent without requiring to remember another
> > > > section name.
> > > >
> > > > For example, in a bpf_prog.c:
> > > >
> > > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > > >
> > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > >         '(anon)' type_id=18
> > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > [ ... ]
> > > > [33] DATASEC '.ksyms' size=0 vlen=1
> > > >         type_id=25 offset=0 size=0
> > > >
> > > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > > The current "btf_datasec_check_meta()" assumes everything under
> > > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > > The non-zero size check is not true for "func".  This patch postpones the
> > > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > > "btf_datasec_resolve()" which has all types collected to decide
> > > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > > differently.
> > > >
> > > > If the datasec only has "func", its "t->size" could be zero.
> > > > Thus, the current "!t->size" test is no longer valid.  The
> > > > invalid "t->size" will still be caught by the later
> > > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > > "last_vsi_end_off > t->size" test.
> > > >
> > > > The LLVM will also put those extern kernel function as an extern
> > > > linkage func in the BTF:
> > > >
> > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > >         '(anon)' type_id=18
> > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > >
> > > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > > Also extern kernel function declaration does not
> > > > necessary have arg name. Another change in btf_func_check() is
> > > > to allow extern function having no arg name.
> > > >
> > > > The btf selftest is adjusted accordingly.  New tests are also added.
> > > >
> > > > The required LLVM patch: https://reviews.llvm.org/D93563 
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > >
> > > High-level question about EXTERN functions in DATASEC. Does kernel
> > > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > > FUNCs in BTF.
> > >
> > > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > > care?
> > Although the kernel does not need to know, since the a legit llvm generates it,
> > I go with a proper support in the kernel (e.g. bpftool btf dump can better
> > reflect what was there).
> 
> LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
> replacing it with fake INTs.
Yep. I noticed the loop in collect_extern() in libbpf.
It replaces the var->type with INT.

> We could do just that here as well.
What to replace in the FUNC case?

Regardless, supporting it properly in the kernel is a better way to go
instead of asking the userspace to move around it.  It is not very
complicated to support it in the kernel also.

What is the concern of having the kernel to support it?

> If anyone would want to know all the kernel functions that some BPF
> program is using, they could do it from the instruction dump, with
> proper addresses and kernel function names nicely displayed there.
> That's way more useful, IMO.

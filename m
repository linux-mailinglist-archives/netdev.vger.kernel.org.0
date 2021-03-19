Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15C34289C
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCSWUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:20:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230453AbhCSWUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:20:08 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JMIbju007581;
        Fri, 19 Mar 2021 15:19:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hNXDUmtyDB2PghrgJDjhnJ0RjQjuFXS2qH7xgQocGGQ=;
 b=auZExSoqTDXVYFl+sr0+sC/YJH4DNwo8m4UPXTgar/14iwiEatVNScJHk2v4JGU4QfNr
 IpvLoc1WW+Dpud/w5RN+qHzVvItoFBbSXSiF5TgRX74tQ89ayURRa96cWyhPJ6DqG5qV
 SESQL2TpPGa1AOvY+xP6IZIonCscn5UyL4g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1ewdmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 15:19:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 15:19:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ1n/C0zZ5S6HgqbbqfYfj9xtTOXEfBiFk4QAxog8pZh7VnDqSo+rkhAkZwP9ffmpyw28M9hfzyHj/+BqsViqX2vaLpw/FWe8/BAZIaRoek4Sc5X/874bbHinzgDM4AyCvkTU9DFYu5E0JvCB01OuTgKeVhjyjLMPS8+afGKBogXBceR2wDhjLBqxCVaYQGHg83O+qLWp6oKAqpSzLHsI+PrlpPkIzQQSaCKB9euwtOyMvxPoU8SoSQaZOblxWalJqymdhGfqnDXuSnW422s3OFeeEUxXPqc6FaoPKxKsvsYVwaQX++t86x7smsNMWsKs58xKk4CG2GS4k4CVsMJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQmUs9iXxNd3WBGDa3PaWV2DWDJ+kmfpVAuWrNu1hqA=;
 b=AlJV3Ft76GsxQj97wrQAsCH+WhGd+N5B+3P7+pea3IS3ekczlYYEw5R353Ow2b83ckgXxOL0Aej15qD9rgYO8JY3IQopFhbOirWh/xmgh46nD11fL5/yE97eFDycbdhcKlO8Ag7D1Lopvb6Jbt4OKCRxEnHJyWJLGnemnjkA1jU4BVJKOmOOUdhocggvX4WJaNjybOmqpxxWVFCpEGWhbDL+wqrMRAp3UUQpdM/5uXlNmKgBb7FZUfG29WviSWd/ENaSf07ynuPQCmWGt+7A9CpJ2uBVa5BG+JUsCRnrvXiMhWJ/lV3UnWABnREk28oh2poTr+U9uniDrfEVxsIqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 22:19:52 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.024; Fri, 19 Mar 2021
 22:19:52 +0000
Date:   Fri, 19 Mar 2021 15:19:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Message-ID: <20210319221950.5cd3ub3gpjcztzmt@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
 <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
 <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:d22b]
X-ClientProxiedBy: BYAPR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:40::41) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d22b) by BYAPR04CA0028.namprd04.prod.outlook.com (2603:10b6:a03:40::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 22:19:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e416ce5-e71f-4cdf-d962-08d8eb251de9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2693AFAF0E3C83E4E932412AD5689@BYAPR15MB2693.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CyuJ8DR0bPYlrpGiaLU6XA13d3ft5utLhurFKodu6UibCXLjQuLpSRMD4p0aa/H7Mc9EWj/ru13mL0DNW6pbysLd5uTO4e85VV6p5uShQZw99KD6GSntLAPNH+hC9zgajkSJnEuyZqwUfBtOQHewwPmZxlHW3VdIXDa3ndHNnc0xgl5ievMte2watrVDYCwkQhDs5t1fWmgrPSRmZ9qEklxSfl7/fujNoDHQcde04WSVqGHAlmoNNohyyUxFHcCqPYJBnXLQHdpjjCbsuHQfvuVKMETcg3DwM4DQaJ7nljti7qUz+c5jbXzUbI8mk8UPmtlVW9kErghnMFyj4KmF80gtZgaRSgoymo+Z6mfq5p9ZP6pGuKgF7eRj+aUrgl10BNMWa4N+2Qn7GY1oGBWyjdbpARI0Z/t2HMNAPWkiDUulqZri4spAqt8s6oEvB2GMJfHYK9HzMvWGulbvCz6me6uBjVyM6zwbc0Y8o9yCwdrGxH4t3Og1ise7BNrRoKZcYLrDNJApkpAe+w2aNesmeBf5YFDrv/btlyuqlmYEmG8B2ZFFqAluLTKGQIyOS/DSczVOsfxMP1092PIQLqdYiIgODXZBmRauwhKYJf1zhTM63Yez5riFEH/AwxXRoZpCYB1xOovq77zsVO6iJ1lVoJYLlc1PnkMwl98K9YRyLb5Nf0oCX4WIlLywdGkoTcmz9Bsv5VrqL2BIiykp+Yv723T/uwNF+lCtPwczvLNorRY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(136003)(39860400002)(966005)(38100700001)(5660300002)(53546011)(9686003)(8676002)(55016002)(8936002)(83380400001)(6506007)(4326008)(2906002)(478600001)(54906003)(6916009)(7696005)(186003)(66476007)(16526019)(86362001)(66946007)(66556008)(316002)(52116002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?azjXk3wpn0I+WskzrMRthQ3zIafasUn31RT7tO/d/2DPshBfsgAAirycg7vp?=
 =?us-ascii?Q?5T9WrDz91w+T+FleTml3aBdWiaAFfwnt019DABAZwcnoR+RW2MDISFOzQofY?=
 =?us-ascii?Q?5aDY1FpdjehJvViC0rWn33o3eBXG2FRtg4k103v8TJFpylCJgXHguelU03Oy?=
 =?us-ascii?Q?3ZfhXKnQGYZOsjJvfETasBp2hbG1r3jBIB4Qihmwkz/l0LnR8CFtMA+IMOdg?=
 =?us-ascii?Q?cU4uVbuNEvgvuUpJkWgA45o2zlLs7L2YV3/ARc+RBqxKwxbU8tO4A3wpKW6o?=
 =?us-ascii?Q?bXpAdcnK7Itqz0nMWE4qeVUDsG+BT5OpnSFqlfiUFnXsCfsvOr3vtktHMqfP?=
 =?us-ascii?Q?stQSB1MGhhbkqcLCjPDv3iY3C9RSAfyU/G62nFcleukNpXJllzpazYiZwDN1?=
 =?us-ascii?Q?5mPOFArjbiaXjA34mr0DnLZgjLn8BEppsILww/N/mKmMxU+T8LxN7WQFCj3q?=
 =?us-ascii?Q?HI05jryOzxpoHCmW4zPPiSfSxem6dKsl7KOyK6cHtlJEK4PJgSQ/tun9uk+S?=
 =?us-ascii?Q?LMMFWi3Zc5ojyOD3OE+PC+V7rFSPBvV8SzBf3o272GLTkpCAOCH5nzN6+DUj?=
 =?us-ascii?Q?ao8U/jUODJ23W1pZaSuQGHXc3sZ9vZnSYhsSfZ0yG8lVt2k4rOE7TK1I2J2J?=
 =?us-ascii?Q?Kt3QRiTEAJW7nd4+plzJEdQG6Bl122xdWt1r18Fe/EcCvy8oht3EM79xEDaH?=
 =?us-ascii?Q?3+gu0BHRHAphIH6LklrN8gPtZoYixAt7dw7CXNeI0OjdFLRhjn9bIOpdskS7?=
 =?us-ascii?Q?5bG6NFtrhWGroNjJFTsqOj/ByPswLgp/4F5WQYez6S0RO1hB0ZqbZ6lQvej3?=
 =?us-ascii?Q?YrxkA6+WdGOn0lChjHagMK4WlS7a44TV9CPWdwk0cQNYvRyoens9dVUVv0yY?=
 =?us-ascii?Q?lqbaxxN0jX52CsWmSOdcjD2Y4FqX+uc+oV+e8rG8c0087uyVsq7AqMOnBI8E?=
 =?us-ascii?Q?3msmusGOwlHHEvOspMKLafFEi9RJaM5+1Ejq6Of+h2AT9Xf3ZcMdnVeCNIjb?=
 =?us-ascii?Q?k1x3mBvZBarwlAUpZ1zZq5tuIhTpgoVFjKhHqBLm7XSwMar3/ViGHbnenofH?=
 =?us-ascii?Q?c1+7aw8z/RGfeqpOyts8RPLv2DW1ImFw1xpWlTyaB2lTdGF/Yb1tUj54u0QA?=
 =?us-ascii?Q?rwFZMY2OyIB1BYPg/Jh8YmZrN0N0ezu90iqLFOIFs5ZsKcdfR0wb+oy7mNU0?=
 =?us-ascii?Q?gMndnptsuDG3We2ankBVxPEN2cg73crX6pLFrLKzHbyQMHja6AI/FfwJv/kv?=
 =?us-ascii?Q?JNlfw5I+MlIT28kcY00VjXZog9rWZypXSE1eYEG8KjMwnPIsZbeSD0iVOpml?=
 =?us-ascii?Q?rOuir8PFkvgDnJ81zQo5hEBBpNjOwFPBjPM2K2K4Ro7Glw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e416ce5-e71f-4cdf-d962-08d8eb251de9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 22:19:52.3166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIEqqiSmvWGjBPCKmG+Mes0anx1aRrb0GFxqilTFtjp5nwtKlZyZFfjnAdBwKQq2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 02:27:13PM -0700, Andrii Nakryiko wrote:
> On Thu, Mar 18, 2021 at 10:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Mar 18, 2021 at 09:13:56PM -0700, Andrii Nakryiko wrote:
> > > On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > > > > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > This patch makes BTF verifier to accept extern func. It is used for
> > > > > > allowing bpf program to call a limited set of kernel functions
> > > > > > in a later patch.
> > > > > >
> > > > > > When writing bpf prog, the extern kernel function needs
> > > > > > to be declared under a ELF section (".ksyms") which is
> > > > > > the same as the current extern kernel variables and that should
> > > > > > keep its usage consistent without requiring to remember another
> > > > > > section name.
> > > > > >
> > > > > > For example, in a bpf_prog.c:
> > > > > >
> > > > > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > > > > >
> > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > >         '(anon)' type_id=18
> > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > [ ... ]
> > > > > > [33] DATASEC '.ksyms' size=0 vlen=1
> > > > > >         type_id=25 offset=0 size=0
> > > > > >
> > > > > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > > > > The current "btf_datasec_check_meta()" assumes everything under
> > > > > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > > > > The non-zero size check is not true for "func".  This patch postpones the
> > > > > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > > > > "btf_datasec_resolve()" which has all types collected to decide
> > > > > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > > > > differently.
> > > > > >
> > > > > > If the datasec only has "func", its "t->size" could be zero.
> > > > > > Thus, the current "!t->size" test is no longer valid.  The
> > > > > > invalid "t->size" will still be caught by the later
> > > > > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > > > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > > > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > > > > "last_vsi_end_off > t->size" test.
> > > > > >
> > > > > > The LLVM will also put those extern kernel function as an extern
> > > > > > linkage func in the BTF:
> > > > > >
> > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > >         '(anon)' type_id=18
> > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > >
> > > > > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > > > > Also extern kernel function declaration does not
> > > > > > necessary have arg name. Another change in btf_func_check() is
> > > > > > to allow extern function having no arg name.
> > > > > >
> > > > > > The btf selftest is adjusted accordingly.  New tests are also added.
> > > > > >
> > > > > > The required LLVM patch: https://reviews.llvm.org/D93563 
> > > > > >
> > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > ---
> > > > >
> > > > > High-level question about EXTERN functions in DATASEC. Does kernel
> > > > > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > > > > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > > > > FUNCs in BTF.
> > > > >
> > > > > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > > > > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > > > > care?
> > > > Although the kernel does not need to know, since the a legit llvm generates it,
> > > > I go with a proper support in the kernel (e.g. bpftool btf dump can better
> > > > reflect what was there).
> > >
> > > LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
> > > replacing it with fake INTs.
> > Yep. I noticed the loop in collect_extern() in libbpf.
> > It replaces the var->type with INT.
> >
> > > We could do just that here as well.
> > What to replace in the FUNC case?
> 
> if we do that, I'd just replace them with same INTs. Or we can just
> remove the entire DATASEC. Now it is easier to do with BTF write APIs.
> Back then it was a major pain. I'd probably get rid of DATASEC
> altogether instead of that INT replacement, if I had BTF write APIs.
Do you mean vsi->type = INT?

> 
> >
> > Regardless, supporting it properly in the kernel is a better way to go
> > instead of asking the userspace to move around it.  It is not very
> > complicated to support it in the kernel also.
> >
> > What is the concern of having the kernel to support it?
> 
> Just more complicated BTF validation logic, which means that there are
> higher chances of permitting invalid BTF. And then the question is
> what can the kernel do with those EXTERNs in BTF? Probably nothing.
> And that .ksyms section is special, and purely libbpf convention.
> Ideally kernel should not allow EXTERN funcs in any other DATASEC. Are
> you willing to hard-code ".ksyms" name in kernel for libbpf's sake?
> Probably not. The general rule, so far, was that kernel shouldn't see
> any unresolved EXTERN at all. Now it's neither here nor there. EXTERN
> funcs are ok, EXTERN vars are not.
Exactly, it is libbpf convention.  The kernel does not need to enforce it.
The kernel only needs to be able to support the debug info generated by
llvm and being able to display/dump it later.

There are many other things in the BTF that the kernel does not need to
know.  It is there for debug purpose which the BTF is used for.  Yes,
the func call can be discovered by instruction dump.  It is also nice to
see everything in one ksyms datasec also during btf dump.

If there is a need to strip everything that the kernel does not need
from the BTF, it can all be stripped in another "--strip-debug" like
option.

To support EXTERN var, the kernel part should be fine.  I am only not
sure why it has to change the vs->size and vs->offset in libbpf?


> 
> >
> > > If anyone would want to know all the kernel functions that some BPF
> > > program is using, they could do it from the instruction dump, with
> > > proper addresses and kernel function names nicely displayed there.
> > > That's way more useful, IMO.

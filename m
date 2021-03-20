Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB42342960
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTAO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:14:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48722 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229708AbhCTAOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:14:00 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12K0BBJw028387;
        Fri, 19 Mar 2021 17:13:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=t+Wp1LByNnWslMY/LK72CKYO1/ndhSe5XGuzWNkvH90=;
 b=ep7fnO7843tH7yCli8iw8IIodoKAayHRmOsoH1aPRniAJ3E4yxHW2pQ1aZfnsOoxzgsg
 pSqhkix0pwxp11GURpXsWan5/jTgB1EXgM64VV00nnH13Bj/AzMd4VXLeegVvYL7Y9GG
 8T3DhoU4/PpM1CFREjNxDGmIIho0hVN+Dwg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37c4vnjntc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 17:13:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 17:13:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1nuan6kDQwSW8z0Z6q4FHjTMdcUQAmodn6PddUd4MTfL3gekP23+iDZ7hOt3Io+JamWEouhBFplFkRgQ7Qq5qmOP2K1Y8ksCcqrmF5YSOcw8cIf4oTtRG4BXUVdaLV68Hcl0nwuHHKZADRUSLFpQEgniofMD2tbXRWCxCyF1P4WRu3ecg6OWWre9NW/niGg7ach1kR21ta+Wm9oWdRspe2dVuN6PBkGDe0rPES8DqjNHl6ZJjNQp+Hj/4jw2fN+/i+Ab+MFpj1fXkUajazqURS8sUgQRkYISdNlmrylLEvMRvDwbwxLE5jGhJ7YA6RRhKf/LnsVyr01+VWW42CRyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wh1f4WJFKTRDxGQtk2t/UyDdDdwpqljPjn32BDWPdU=;
 b=LnhJZFIK8ET2+TvK0g0gH1BXp1KUa8i3QUJoOW2Acv2rmzM6CM9aO42ZAazS31dZ7wAcWOF8HQHib5SmdeOtv70ilDNItsUCwzPgBq7k+zj8vxFgtx05EAywwqIPUNvGCDU6WWp5m6EmhoTADVIrMC4MLpGlZG0V0ZgiUIopoPR7uS9T8pKBA7iwMO/OOaZvDy3ky4vgQ06WjibJAcVP0b3Wi/FzRi6AWpNYGyd02msLKqj5emfB8VVO638JBL5ALIZ6R6eX0Q8tIJZzBhh+UYuUUHFesFouuvrWFTUukunh2nV/pY0qjEqELT3h+0hBEkgg79tzdsggzOeOThEEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Sat, 20 Mar
 2021 00:13:16 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.024; Sat, 20 Mar 2021
 00:13:16 +0000
Date:   Fri, 19 Mar 2021 17:13:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Message-ID: <20210320001313.xhwiia46qsjh2k7k@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
 <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
 <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
 <20210319221950.5cd3ub3gpjcztzmt@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza6Fiv+AFJc9-L=S6Duvm7wyyjvqoDGEED3TDTmwiZvVQ@mail.gmail.com>
 <20210319224532.7wlmhrgtrvkwqmzg@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZm1o-ZqXTpUcVnbZDX57pGqARwjHjm_=aspgj3ahHZLg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZm1o-ZqXTpUcVnbZDX57pGqARwjHjm_=aspgj3ahHZLg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:d22b]
X-ClientProxiedBy: SJ0PR13CA0096.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::11) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d22b) by SJ0PR13CA0096.namprd13.prod.outlook.com (2603:10b6:a03:2c5::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Sat, 20 Mar 2021 00:13:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a442a3be-40a6-4b17-94af-08d8eb34f56d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB34646886396B2875D90A17E3D5679@BYAPR15MB3464.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zABQMyLkwR33OD206pSt4BypANj4w3nLo+RR6cAGunUmiCRxqTOLfgr5VjbOf2ztfmmJAda/yj9WhYSGJHqu/D58k/+JRKNCP3AZPz7DLhzSNU8YDr616gUgv9LSA3HA4jVGcoQfs6Aatzk9OWOqqRDCcinTEow8SUZFYi9tdcNcdLqPSQmyZ/ylH9j0LFnOXpV+WyBy1iy9wXAJtbKaPjkd2q15pe70lbtQRV9qHZd8CN//tTd7akfAgDXbc0EPgi0eDIvWh37WEsuvB0pP/MaMwU27UcV7tcu7/msJd2zfExt5Xhsx0rMR/dMKp6RfYs6INM472vlf7fACar0m4VuFKN/Ed27p/C6lDDj63iidxn+KVDwQW9Fmn6/g0x6OTaw8z5CqEfEeuY+Jh5BJ0n8kl1c33HxfC5Acp5X/u2IX4sdTnqoii4LSPN1FSd4X1MDTxuOdxX8ecH8y1bgf9wQIO6PslV6tEbdeCEvDPAetdkKTemi8Y1sm7w30LrNVebrbCNi/UVWKWF6NLNt5qhRdV5XXkoMKv9ppvrHepQ1Td8c8ubwEKSNXRXUGSkXk9tT4LaD145BLQhIMVdCZv0vCWI+taYgi+CQpiorZtqj2tTlb87c4WZkGV9IJw5qqy8i/1G+FCZxU8zmOeORvk5ET6Se//7Bv2vSMm/mKHUrcedTkCxbBNAWvpiDpKND+LyZyFKuTdr5pz7xZLXjDOBvLkE7IVpbTqsdzJgW8Gc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(346002)(39860400002)(4326008)(8936002)(316002)(1076003)(86362001)(478600001)(38100700001)(186003)(55016002)(9686003)(966005)(54906003)(66946007)(7696005)(66556008)(52116002)(5660300002)(8676002)(53546011)(6916009)(16526019)(6506007)(83380400001)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aPj1JZpboW6g14Egh5RxEBMT+mz+Gus7PeCcN7FOKUmrgTDrXLmHpHSHuVmj?=
 =?us-ascii?Q?cZPH/LO2biVgOFx41ykmrKid3jzVsnJghDYUxc7hlGv07xMXBVqB5R/ruxBi?=
 =?us-ascii?Q?vFL3lrxBPcYJMY1sjTl5hm1uJsZeUr6TCa7818onb+aO9rCJvMUhJZGX0wku?=
 =?us-ascii?Q?lJu5gjYswOQ60ERrVmkbPbRVuVNm1Z8u+U5ZTToC3bxzmmNMW3P9QVJfY/n9?=
 =?us-ascii?Q?j5isVR7G4u/5n8ZC1f7/LNHJvYPlEl9ia6gR5z4NpSCfgL+H2hzuXwp4ZEVf?=
 =?us-ascii?Q?EeC8n9ski3Fa0NKh+y2ascH18v91eOgH6A22Gl/d7jDPVe+++zphpVdMLxUN?=
 =?us-ascii?Q?bWwtPeTOPEnissdk/liOj/wv7KNycGOgA4QMhZqP0mISIzOC0PXzSZ32WGOv?=
 =?us-ascii?Q?redKYKzVHio//uttN0Dyp7gpzetV6+noHWwgh1gIJxrpDWPMD7YEpOQ/1WGz?=
 =?us-ascii?Q?nB48G8fFgmst4ZfiQ9AUo7q67KLIT6tN5dEVYVFNnu3wvPvXxXMng6aweeTI?=
 =?us-ascii?Q?M/rmriiPB7s89zMhee8hPfjVnq/d4vyXTpZF+2or4wbcQ09VWtgXKw9JFwFX?=
 =?us-ascii?Q?PeMS56RGkI7CNm9oBAAFLS12pg/ts6BCIGxdnQCL026yU/H1FyuNNDcEzclQ?=
 =?us-ascii?Q?tzsL2lvhcH5g50naVGOQtiYpf28qZOif8ZZKCBfSGROloIYkh1DT79lJXGUA?=
 =?us-ascii?Q?wMZkUNuoUu092Sen/EjxW2gsBsgXEKvkscrLzIY3anhbva9HmEM/eXhP9cKV?=
 =?us-ascii?Q?7EbmbzsJMumdwq048oRLI6tcQA0z/kz85pbgcwcQ0ZAjGCmOzT18YBGe7Kei?=
 =?us-ascii?Q?pxtOPTyJXh+smqFLQ5fu1mYFFtcghbeHLu+MVFN/NQ4nwtykqGzw9s4iDwCu?=
 =?us-ascii?Q?BN3p7BEMvavTSvVlNRu/E5W8J1+jHXpeiuX8IqKNsSVoOVRlk+HHUslC7gZT?=
 =?us-ascii?Q?Cw1PO+v6WbOb2Wh0MUxpmO/3ICkKNzCNiHh9yeiT7N4+TUQBC2ghylhsL4MD?=
 =?us-ascii?Q?YmBA2k5zTyR5uYz6gh8r3trYIVhMo0wBxqc5IAYvlJWR6oMNUOb1oiyHRgau?=
 =?us-ascii?Q?IaSEISZrSHQwre2FInAFw6330S8T2TB6Ouegx6NWW5dRJYIa4qCFY41PDays?=
 =?us-ascii?Q?5plOTnJlv3UKDJUhAq00RC+CWLg1BBbtmm2SojLwhV5CUJmgAL2xmaEJmXsd?=
 =?us-ascii?Q?6p7UDkO8FGoXxLvsRRwnVxtCq6d5IIlreEynKKBZESE/nQ0wVZopDhIqa6M+?=
 =?us-ascii?Q?X5/z0OyaX5RuphcCfgX7+KtoWPELXyLm5oXfm4k81g5oZDvq2aZE4cCHbuJK?=
 =?us-ascii?Q?1QclR7wMgIdCg+kdTGaorrQsKOX5FOlbz8zTCQqrFEjBGQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a442a3be-40a6-4b17-94af-08d8eb34f56d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2021 00:13:16.2740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3zEKd4o6BJLut/3H8mfC53YRjwt5Qhb0FGTqZDPTi7jMNqOj2gAbtUaw0eNJBtx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103200000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 04:02:27PM -0700, Andrii Nakryiko wrote:
> On Fri, Mar 19, 2021 at 3:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 03:29:57PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Mar 19, 2021 at 3:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Fri, Mar 19, 2021 at 02:27:13PM -0700, Andrii Nakryiko wrote:
> > > > > On Thu, Mar 18, 2021 at 10:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Thu, Mar 18, 2021 at 09:13:56PM -0700, Andrii Nakryiko wrote:
> > > > > > > On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > > > > > > > > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > > >
> > > > > > > > > > This patch makes BTF verifier to accept extern func. It is used for
> > > > > > > > > > allowing bpf program to call a limited set of kernel functions
> > > > > > > > > > in a later patch.
> > > > > > > > > >
> > > > > > > > > > When writing bpf prog, the extern kernel function needs
> > > > > > > > > > to be declared under a ELF section (".ksyms") which is
> > > > > > > > > > the same as the current extern kernel variables and that should
> > > > > > > > > > keep its usage consistent without requiring to remember another
> > > > > > > > > > section name.
> > > > > > > > > >
> > > > > > > > > > For example, in a bpf_prog.c:
> > > > > > > > > >
> > > > > > > > > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > > > > > > > > >
> > > > > > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > > > > > >         '(anon)' type_id=18
> > > > > > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > > > > > [ ... ]
> > > > > > > > > > [33] DATASEC '.ksyms' size=0 vlen=1
> > > > > > > > > >         type_id=25 offset=0 size=0
> > > > > > > > > >
> > > > > > > > > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > > > > > > > > The current "btf_datasec_check_meta()" assumes everything under
> > > > > > > > > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > > > > > > > > The non-zero size check is not true for "func".  This patch postpones the
> > > > > > > > > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > > > > > > > > "btf_datasec_resolve()" which has all types collected to decide
> > > > > > > > > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > > > > > > > > differently.
> > > > > > > > > >
> > > > > > > > > > If the datasec only has "func", its "t->size" could be zero.
> > > > > > > > > > Thus, the current "!t->size" test is no longer valid.  The
> > > > > > > > > > invalid "t->size" will still be caught by the later
> > > > > > > > > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > > > > > > > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > > > > > > > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > > > > > > > > "last_vsi_end_off > t->size" test.
> > > > > > > > > >
> > > > > > > > > > The LLVM will also put those extern kernel function as an extern
> > > > > > > > > > linkage func in the BTF:
> > > > > > > > > >
> > > > > > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > > > > > >         '(anon)' type_id=18
> > > > > > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > > > > >
> > > > > > > > > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > > > > > > > > Also extern kernel function declaration does not
> > > > > > > > > > necessary have arg name. Another change in btf_func_check() is
> > > > > > > > > > to allow extern function having no arg name.
> > > > > > > > > >
> > > > > > > > > > The btf selftest is adjusted accordingly.  New tests are also added.
> > > > > > > > > >
> > > > > > > > > > The required LLVM patch: https://reviews.llvm.org/D93563 
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > > > ---
> > > > > > > > >
> > > > > > > > > High-level question about EXTERN functions in DATASEC. Does kernel
> > > > > > > > > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > > > > > > > > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > > > > > > > > FUNCs in BTF.
> > > > > > > > >
> > > > > > > > > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > > > > > > > > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > > > > > > > > care?
> > > > > > > > Although the kernel does not need to know, since the a legit llvm generates it,
> > > > > > > > I go with a proper support in the kernel (e.g. bpftool btf dump can better
> > > > > > > > reflect what was there).
> > > > > > >
> > > > > > > LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
> > > > > > > replacing it with fake INTs.
> > > > > > Yep. I noticed the loop in collect_extern() in libbpf.
> > > > > > It replaces the var->type with INT.
> > > > > >
> > > > > > > We could do just that here as well.
> > > > > > What to replace in the FUNC case?
> > > > >
> > > > > if we do that, I'd just replace them with same INTs. Or we can just
> > > > > remove the entire DATASEC. Now it is easier to do with BTF write APIs.
> > > > > Back then it was a major pain. I'd probably get rid of DATASEC
> > > > > altogether instead of that INT replacement, if I had BTF write APIs.
> > > > Do you mean vsi->type = INT?
> > >
> > > yes, that's what existing logic does for EXTERN var
> > There may be no var.
> >
> 
> sure, but we have btf__add_var(), if we really want VAR ;)
> 
> > >
> > > >
> > > > >
> > > > > >
> > > > > > Regardless, supporting it properly in the kernel is a better way to go
> > > > > > instead of asking the userspace to move around it.  It is not very
> > > > > > complicated to support it in the kernel also.
> > > > > >
> > > > > > What is the concern of having the kernel to support it?
> > > > >
> > > > > Just more complicated BTF validation logic, which means that there are
> > > > > higher chances of permitting invalid BTF. And then the question is
> > > > > what can the kernel do with those EXTERNs in BTF? Probably nothing.
> > > > > And that .ksyms section is special, and purely libbpf convention.
> > > > > Ideally kernel should not allow EXTERN funcs in any other DATASEC. Are
> > > > > you willing to hard-code ".ksyms" name in kernel for libbpf's sake?
> > > > > Probably not. The general rule, so far, was that kernel shouldn't see
> > > > > any unresolved EXTERN at all. Now it's neither here nor there. EXTERN
> > > > > funcs are ok, EXTERN vars are not.
> > > > Exactly, it is libbpf convention.  The kernel does not need to enforce it.
> > > > The kernel only needs to be able to support the debug info generated by
> > > > llvm and being able to display/dump it later.
> > > >
> > > > There are many other things in the BTF that the kernel does not need to
> > >
> > > Curious, what are those many other things?
> > VAR '_license'.
> > deeper things could be STRUCT 'tcp_congestion_ops' and the types under it.
> >
> 
> kernel is aware of DATASEC in general, it validates variable sizes and
> offsets, and datasec size itself. 
Yeah, the kernel still thinks it is data only now.
With func in datasec, I think the name "data"sec may be a bit out-dated.

> DATASEC can be assigned as
> value_type_id for maps. So I guess technically you are correct that it
> doesn't care about VAR _license specifically, but it has to care about
> DATASEC/VARs in general. Same applies to STRUCT 'tcp_congestion_ops'.
> 
> I'm fine with extending the kernel with EXTERN funcs, btw. I just
> don't think it's necessary. But then also let's support EXTERN vars
> for consistency.
cool. lets explore EXTERN vars support.

> > > >
> > > > To support EXTERN var, the kernel part should be fine.  I am only not
> > > > sure why it has to change the vs->size and vs->offset in libbpf?
> > >
> > > vs->size and vs->offset are adjusted to match int type. Otherwise
> > > kernel BTF validation will complain about DATASEC size mismatch.
> > make sense. so if there is no need to replace it with INT,
> > they can be left as is?
> 
> If kernel start supporting EXTERN vars, yes, we won't need to touch
> it.
From test_ksyms.c:
[22] DATASEC '.ksyms' size=0 vlen=5
     type_id=12 offset=0 size=1
     type_id=13 offset=0 size=1

For extern, does it make sense for the libbpf to assign 0 to
both var offset and size since it does not matter?
In the kernel, it can ensure a datasec only has all extern or no extern.
array_map_check_btf() will ensure the datasec has no extern.

> But of course to support older kernels libbpf will still have to
> do this. EXTERN vars won't reduce the amount of libbpf logic.

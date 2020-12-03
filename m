Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC02CCDE9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgLCEZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:25:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726412AbgLCEZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:25:17 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B34KmCR011336;
        Wed, 2 Dec 2020 20:24:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Xn4yQ/GX/hvLEQWmhzNI/knir9RmbsfsR/NA4m9CUac=;
 b=dCyAup3TLJ27iV6AL1rs9T/u4M5aLDw8e3dFQ/0woXB8aty0qg2TxX5DdB0u2uybzQNj
 yc7G4CboAp4t8V522MQ9XIYvol3jJ0kPEBFWBCcJTEBhB8IXeG/TBCo/X0aWK2MinXqK
 JrCZE9omni2AmRvniflhZcNvWkkIyRjVN/Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3560xg0r1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Dec 2020 20:24:16 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 20:24:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyVTUYCqulA+P01AmRe9N56M5Rhg5U3sUSK/ikDlpoJlSSSmhEpRsspRIGv1eULH6NHsUYrrvGIw832klZu/POe38iMqRaYzJGfPB6XHNbe8XJwjF3fLvgW4pPpFJpFXIoyrBKzxYDVqDq3aLu2uiYUqkelFD108hm+1v/P3kXPOp1RBs1v9t51hpt7ooIratpylecjQo/SJE1B0XGXdOE+mFqdm05FTJBpyDlbe0jRI6urVX3cNYrQnVZekhAVBdttZmOhhAg2u435HWWiR9ncIHXNhOe8E8ZR7MrYt7hkkUQ23YbVCr886MuRTz1b5nKIXv3N5VOxRHBz/rXdBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xn4yQ/GX/hvLEQWmhzNI/knir9RmbsfsR/NA4m9CUac=;
 b=nUIrVfqputMmB0MyvLYpA0m4xgejFMHBqrGBP9DnDUQzZITIgA8G1GVOG2KOi48sHZn6XKBkQMn4MBDKDtLgXiEAzR/7AhxQjphC816wY25x02qLoWNleNPSobHNF8zct2kE0kqjxhfAjX1EHlA6Pp4ut0cESGsHkgpoSPLV15o3LXZdmmdqpqij0jcNR5ZcSDuEO/rl85jC40/mGpWTo1vpGulOCXUnBRseiME+HRKDVqNQVKzU/ZGAwkB1fltDakwPZJPliz6GQoZr2+pAbaKSwX4vwEI4jzRHi22M0x8OcrH7rNjCOfvML7Q2PcoAdisDljjW/NgiHkkHvEtXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xn4yQ/GX/hvLEQWmhzNI/knir9RmbsfsR/NA4m9CUac=;
 b=aHypO6x8pqAsrV2lyzUDDZiTCYG8e0Ghg4L27zcPXeVJDp5U2eGmOvVBRRx0XuehrsuCQ7xCwSqpC4pbrCEK14PJR70IEXF9xAY+4swolSbp6X4nOm7Ba5nkqfEl9bZ096/7YGDb+HyOGQhIkDYPX0MLPg1dCyFSEjC6ZC0Jw7A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2327.namprd15.prod.outlook.com (2603:10b6:a02:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Thu, 3 Dec
 2020 04:24:10 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.020; Thu, 3 Dec 2020
 04:24:10 +0000
Date:   Wed, 2 Dec 2020 20:24:02 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for
 BPF_PROG_TYPE_SK_REUSEPORT.
Message-ID: <20201203042402.6cskdlit5f3mw4ru@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-7-kuniyu@amazon.co.jp>
 <CAEf4Bza2K9zPqPWTFp+yUN+najdjqY-sNtZ7T5=V=s66bqDavg@mail.gmail.com>
 <20201202191756.otne62dsmfxxfgsz@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202191756.otne62dsmfxxfgsz@kafai-mbp.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:222f]
X-ClientProxiedBy: MW4PR03CA0172.namprd03.prod.outlook.com
 (2603:10b6:303:8d::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:222f) by MW4PR03CA0172.namprd03.prod.outlook.com (2603:10b6:303:8d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 04:24:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85f1cf0d-cef9-4dfd-bc14-08d8974347d9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2327:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2327B2826B331C9DF26726EFD5F20@BYAPR15MB2327.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a/ZpKrYRAAb32tA/ERr1qQaSaXqFhNxHf32+FtUJne6io5a+hxPgRIA0ClQbTmkZjJ+eVQB3J7GEb7cDREqFlCZozuir/MvPpj7IjLTtaK652N3TDELwBnYOikzWr45TK4q+YkgQpFgxikLfvmECU0e1XeEpgHaUCR3iGGT2eLpKnA1W4m4w0ny2iVqgODY1YzVe03YJYARmy3lP/JmUbNsnLVmsZRfHZyHojwcrXeSgLGQvff3yRzDnuiFTKGXAQENNDBoqzXwoj2KbritfhXGhAvMD+FrEHo0/Kozbi12OT5x7D8CjSlXjiO+VbBSTt6ZhHagYfFNSZs0RWrWsD6+fI224hjzhuW3C//jmssyE5f3o5ZlmV4PXo+r/Q0yA+54XyhadD4LCGqDc85PHGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(7696005)(966005)(9686003)(1076003)(2906002)(8676002)(5660300002)(316002)(8936002)(55016002)(7416002)(6506007)(110136005)(66556008)(83380400001)(4326008)(54906003)(52116002)(186003)(16526019)(478600001)(53546011)(86362001)(66476007)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+duj4tcq27sNZu+lwTjwQKfDB1IjpeH6wmB8xCntFQ/inyZsUE8a3s/IFGvv?=
 =?us-ascii?Q?MPKyvwqrSoSEJ/gTnmfI+7LoaKdNj84Lvdfev9mL1RGZCBBrZHz8UUVWOfx4?=
 =?us-ascii?Q?C5EwzvuteopUckcdH9j2FfDiN3mE+2OOD6dGS7hEwsXNeQYcToi9VxBgbV3t?=
 =?us-ascii?Q?U2hT1++fhfUwwKwyjZs+WW8rN0kSCI9g1Obv9aRgi82Fc3cklyzGPRnBibiV?=
 =?us-ascii?Q?Iz+CvFS9yqG2gc7ps/UCvqNu5CWK63NNvR2WAf0dver3EBeaY6Iwz00X8WfV?=
 =?us-ascii?Q?YevD3P+guOKuUqZyv+EDcE5inrJEteR+vh7a3Fx67SBDZlhFPL4R3zai6uVN?=
 =?us-ascii?Q?yPB0ceYvLUGh8aseoZIXShD420GA4OyoaGlk/SzQxbGnoeZS65xhMjEARBH+?=
 =?us-ascii?Q?qm1nvc0teSiimugpwRgNQmdzAwqWVpB0xofFawvu61KC0MlCq6UmpGJJgS6q?=
 =?us-ascii?Q?ECEReSFayaoDHGyoyKlkEdFJQn2TwQooB7hdvjp2yutoAAsr2rpUHGlZEKTO?=
 =?us-ascii?Q?GFxtSdIledw2pysKRVWokNo6pvdRse8UoZQs6jjyHhX1PKAnW54w5BxNsmVy?=
 =?us-ascii?Q?P8VCYAUV3Rzqf/wCdkQn2+UILb7CiNwL581/Z+EbFT/vU7v+s5vrmhsgfauh?=
 =?us-ascii?Q?VE3bpBYZU30RnhqeLTrDyXCMKmcnDtzvfqjjyY8xj6mWf7eWqYGbrCAPahKr?=
 =?us-ascii?Q?mGBVRtU4S177oj99l94/KIgY5JLA8a4NtehMAcAy9sJVHDBawktm3heEjIBa?=
 =?us-ascii?Q?vu8T3HnQz9Ij5Bwtwx6VaPpVA04FPeAiPYKlaj6H2WRMetLfaTiYm31dA/qx?=
 =?us-ascii?Q?V95Zj8Pc1//VEftITuK1vz0peXUObGDJP5gyBWY2AUn037AgOLKh0/Q8tUgA?=
 =?us-ascii?Q?F8Haq2aQelFBr3PRf33ipZJXWj7UUjBDki0NCIKKyde+cqxaST2W2VnNJ8cH?=
 =?us-ascii?Q?B9e4U2l4AMfuMAdDMDiTvvqP5JB6h3nviIPqabn0wdIcRIdF+rjGO4VBy0fj?=
 =?us-ascii?Q?Qoq4ck9Zw1RcrMmOXLQZBUSubg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f1cf0d-cef9-4dfd-bc14-08d8974347d9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 04:24:10.0158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTi1q8iyMOoFT1U9aDwmKtc90bDTGv42YmRudLfP/i3yniAUqQV38MrnouOvGKDw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2327
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 11:19:02AM -0800, Martin KaFai Lau wrote:
> On Tue, Dec 01, 2020 at 06:04:50PM -0800, Andrii Nakryiko wrote:
> > On Tue, Dec 1, 2020 at 6:49 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
> > > check if the attached eBPF program is capable of migrating sockets.
> > >
> > > When the eBPF program is attached, the kernel runs it for socket migration
> > > only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> > > The kernel will change the behaviour depending on the returned value:
> > >
> > >   - SK_PASS with selected_sk, select it as a new listener
> > >   - SK_PASS with selected_sk NULL, fall back to the random selection
> > >   - SK_DROP, cancel the migration
> > >
> > > Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
> > > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > ---
> > >  include/uapi/linux/bpf.h       | 2 ++
> > >  kernel/bpf/syscall.c           | 8 ++++++++
> > >  tools/include/uapi/linux/bpf.h | 2 ++
> > >  3 files changed, 12 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 85278deff439..cfc207ae7782 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> > >         BPF_XDP_CPUMAP,
> > >         BPF_SK_LOOKUP,
> > >         BPF_XDP,
> > > +       BPF_SK_REUSEPORT_SELECT,
> > > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> > >         __MAX_BPF_ATTACH_TYPE
> > >  };
> > >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index f3fe9f53f93c..a0796a8de5ea 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> > >                 if (expected_attach_type == BPF_SK_LOOKUP)
> > >                         return 0;
> > >                 return -EINVAL;
> > > +       case BPF_PROG_TYPE_SK_REUSEPORT:
> > > +               switch (expected_attach_type) {
> > > +               case BPF_SK_REUSEPORT_SELECT:
> > > +               case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
> > > +                       return 0;
> > > +               default:
> > > +                       return -EINVAL;
> > > +               }
> > 
> > this is a kernel regression, previously expected_attach_type wasn't
> > enforced, so user-space could have provided any number without an
> > error.
> I also think this change alone will break things like when the usual
> attr->expected_attach_type == 0 case.  At least changes is needed in
> bpf_prog_load_fixup_attach_type() which is also handling a
> similar situation for BPF_PROG_TYPE_CGROUP_SOCK.
> 
> I now think there is no need to expose new bpf_attach_type to the UAPI.
> Since the prog->expected_attach_type is not used, it can be cleared at load time
> and then only set to BPF_SK_REUSEPORT_SELECT_OR_MIGRATE (probably defined
> internally at filter.[c|h]) in the is_valid_access() when "migration"
> is accessed.  When "migration" is accessed, the bpf prog can handle
> migration (and the original not-migration) case.
Scrap this internal only BPF_SK_REUSEPORT_SELECT_OR_MIGRATE idea.
I think there will be cases that bpf prog wants to do both
without accessing any field from sk_reuseport_md.

Lets go back to the discussion on using a similar
idea as BPF_PROG_TYPE_CGROUP_SOCK in bpf_prog_load_fixup_attach_type().
I am not aware there is loader setting a random number
in expected_attach_type, so the chance of breaking
is very low.  There was a similar discussion earlier [0].

[0]: https://lore.kernel.org/netdev/20200126045443.f47dzxdglazzchfm@ast-mbp/

> 
> > 
> > >         case BPF_PROG_TYPE_EXT:
> > >                 if (expected_attach_type)
> > >                         return -EINVAL;
> > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > > index 85278deff439..cfc207ae7782 100644
> > > --- a/tools/include/uapi/linux/bpf.h
> > > +++ b/tools/include/uapi/linux/bpf.h
> > > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> > >         BPF_XDP_CPUMAP,
> > >         BPF_SK_LOOKUP,
> > >         BPF_XDP,
> > > +       BPF_SK_REUSEPORT_SELECT,
> > > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> > >         __MAX_BPF_ATTACH_TYPE
> > >  };
> > >
> > > --
> > > 2.17.2 (Apple Git-113)
> > >

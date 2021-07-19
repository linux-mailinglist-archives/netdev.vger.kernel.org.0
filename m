Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145613CD663
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbhGSNfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:35:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52358 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239393AbhGSNfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:35:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JEASI7032454;
        Mon, 19 Jul 2021 14:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iMzFhaIJ5lb0SSwfYQi460v4qviKQKIlHfViSJIX43k=;
 b=cuYheodqbSFLDf0A9J4y+klxlah+Y8A7djWIV/7i/o8n78MX3GZGc00u96ig16AJd01r
 EluAbLKHjmpm8e73Aw6+20Prrk+6aR/KBELG8lsFduayjASQMg5ZbU8kQNpNSZ7V3CQx
 E5YYe8wEdmwgVjaOy0DyJ3hhNND1kSDQnIYtTOy/FlWXS1b/+AmBuKFuowXyRfO7xMxk
 8DDP7KHM66MNjmfKzg4g5mW+rz7cicVNZ+qvGvOqNe9dC0vOT67ubcLO+TDFVTdYYf0S
 nPZhohjgp/A7Bsx13HRlNS+7H+SsUyGNXGX+Q8R+ZCqaChIM4sAuXevwLF4OUbUw7+94 bQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=iMzFhaIJ5lb0SSwfYQi460v4qviKQKIlHfViSJIX43k=;
 b=ILX1QZxvxSQlbvy6L1mI06lgcsa6Bz8R1J0JyMJFKJMeuH5D0ZRFlojwgaZ1wjm3il2q
 +xr2qkxA3TIE/OwB0ePvIV9aN4Edf1uVwwMfL7P5bP2jV7t+bLHcEkyZ47bvSqHW/Ztt
 Z42jXTDaqeoIIl7KxCCxmJiWy/y4iHtsOGFZJGgaW0MtBTHIy12MVv/KEZe1v3JfOnlo
 hj7UCkdSrpiQnQ1pSJah4kXG6KrHw1F4VwPFtHIBKITBiALP4r3o1mPjAraVeE9OoTdR
 23IlZZuNpacLJ7DZogyOE66Om8lvlTlM7B8GyFLOp/vPwjr7n824tEmdtwWk8z9BTRSc BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w8p0ravy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 14:15:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JEBDgL064857;
        Mon, 19 Jul 2021 14:15:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 39upe8c56h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 14:15:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnxEwBEi+DpS8+u8fo5tBvI1lmPYqu2t3MxVh7SMaOSqMBFBF02G7GpyAwLzr4gpWUfD1M/2g6fumsOfRbqbJFvc50u2PP0GdfcqBMj+ie7PFYh2KjwmpWqfgMJCVPTuBWWmZpnZ2wz3gulfniX1t148WEOzUqXnFRjqirsIPvftSLVPSAyhLBS94Dd3pFHPQhRBzKJvA5wC3PFsRnHzUe0KIn0qowTsm+8RasVM6eK4Uot54ciQvH4nJg++4KGV64D97CBmv14Dvq4+XuoVPttt+ZREk9MreeUQkeM48CNcWE1K04JPemLUXsWjsRvORAHzndS0bnUjEBczXdvM7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMzFhaIJ5lb0SSwfYQi460v4qviKQKIlHfViSJIX43k=;
 b=I+KiFRQvRZjQX2+/duOWVNP3NfDi6jAzT99VuVniMNxJz6beXb4G4M9AblOrBez2k0L7vQB4BFIelbwU2VcOgfq6naNEH2P9nYKiVeRjdR4n9uFyQVbsR2PMMFjcRj0blI2DDzJ3dws0ErC75Cwpdi4jesdILuNQaoXTyHM1F3hKwCvWAo0YeDEvefb7F1kTGLIk1DzgvkKZq3FI9JoUq8qe1GGmwKsYqzIW39zCL+lnqQCP0zuRe8XCDNHDnHi0pPRZNKBm+zPS7SIeGi+BaArYlfnWKLt/k4NkNYXHIyLdwmQFbofKJLJOsxMpIZCOM1sLYNZe4/R2s3JRbAZN2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMzFhaIJ5lb0SSwfYQi460v4qviKQKIlHfViSJIX43k=;
 b=IEO0pEQmdlvdHTwIVN+smSRsIV4QrBOsMGitfTbdCWhr5m3YCh24/3VLDuSXuBrmq4WyjFlQCqMGQZZ61zCTZcVLr7HvxVUUmmiP7v+x/3o+M6f5B5GeO5Ual3CjVeXCbJL3FSH2tQ/LjY0m4sSvGVvZ4UpHpq+Qsa5Ci6jFemA=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3647.namprd10.prod.outlook.com (2603:10b6:208:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 14:15:48 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 14:15:48 +0000
Date:   Mon, 19 Jul 2021 15:15:06 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Naresh Kamboju <naresh.kamboju@linaro.org>, andrii@kernel.org
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH v6 bpf-next 1/3] libbpf: BTF dumper support for typed
 data
In-Reply-To: <CA+G9fYtqga+zMop8Ae3+fa1ENP2T8fwfFfwWmvfRWZSYB7cPDw@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2107191506130.18107@localhost>
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com> <1626362126-27775-2-git-send-email-alan.maguire@oracle.com> <CA+G9fYtqga+zMop8Ae3+fa1ENP2T8fwfFfwWmvfRWZSYB7cPDw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: DB6PR07CA0174.eurprd07.prod.outlook.com
 (2603:10a6:6:43::28) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2001:bb6:18f3:2e58:2fc8:ca6f:4a81:b0d) by DB6PR07CA0174.eurprd07.prod.outlook.com (2603:10a6:6:43::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.12 via Frontend Transport; Mon, 19 Jul 2021 14:15:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98208b06-6430-4b12-6ec2-08d94abfb4de
X-MS-TrafficTypeDiagnostic: MN2PR10MB3647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB364791295CABB6D909C83230EFE19@MN2PR10MB3647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCMDb6/1wBMplb4gTQMlBEn/6WjubchLpW3lQPrj6o4DcHqdbPEJCBFtXzo24pspgzzGDnBe/XPeF5Y249BTH2jGtefvnoG3jLaiCjkTD6Dr2/aspsWckLI0RqqI9BlwrGowpEWXgz+HjHlSftLCFK1s7yO3/hj8g/Fqydt/H01fgyqdjiBT6VX8oehAz/9FlHSRC990C1l5fHJc2iSiW6w5F1IlR4ebEthgXiNX2MyK/XxIHsTS3SNSGZD6uEXE0vfbWSv5RJGSbSeemZdBk1Fe390WKFEI6zHSL6ArBqh3H4cp00siND4oYP59ED5WZagP0rpF7PJyqEw/g+DB6tp/cDLnO8W4xzp5QF35SyVfjrvSYSOtmv4zj3XEXgIM5IZSpThgtez+gF3SDbETKdpeiGNTBuV6oMX1ryDHiSFUGVJ6yQgP01bnqSQiucpi2Ip5o48shCvc6+IR/2541DVE3sqcAB1BE7lDMZB3sfYLBASnw2avweFGwq3yIsLgjBJz1Tt8bi6o/ZnxiaqSSeYANLB39qy++goqkgDophQp9k2YJ103rNE528OZXBsSzOdBXwbyW6U8GO6OlmoRAp96r6vdEqmo0YBKjYGCrTNL2fFBYkuqe5Xy82rohaNR5HRxTaoJB3F0W1SpGtL32QWR/dqrXp0PoPOrpBOZK9TR6U2JGvmc+XI2FTVK4ej+2sY1UmwBYNBjOuXP7TcjFl7OxH8lk3++QOtBqADL1jY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(83380400001)(9576002)(966005)(8936002)(54906003)(2906002)(478600001)(186003)(7416002)(6506007)(8676002)(66556008)(316002)(6486002)(6512007)(66946007)(33716001)(86362001)(4326008)(5660300002)(38100700002)(52116002)(9686003)(66476007)(6666004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZHEmfPIsmBKILUr5VZhEHI37+/+AohkSKoR+6ZUHqSF0F/phxQee67vJnay?=
 =?us-ascii?Q?OMBF3JY2Iaj34loZiMYh1aFuj+BujLjJKL3xwvhurK0ym52i5eeGd/uYs00B?=
 =?us-ascii?Q?/v/z3/+om4puG7SBwMGOMpGOtl2dztztpohtoFPlfffRuBwC66CU5XfAh3yC?=
 =?us-ascii?Q?bHaLlQvWG8TdWvXCOgAvAFgS0YWtC691DhoRd/50VXRIefbIAJNKnrom+hnq?=
 =?us-ascii?Q?QFPlr84X/uakfI2OmfeimLvppZ7EA0qGczRKTes1TDaHfmsqosJFX1tW5xJJ?=
 =?us-ascii?Q?ZubjulEw9RvViETTJMu28YAhoI6SqF40DihaQBsK7ThPlRCKkrDrB8DP9831?=
 =?us-ascii?Q?Q8H6p4OIJX41MYuE4kGjv8jQw0/m/rRnsHzyKUoctCvT0TlEymrpCDn0UoGM?=
 =?us-ascii?Q?RpIXkUdiBjDncYfyYvgjGcRtajoJi4Dqpskccl7V7mTS/5jcK4iBmzQRkmRG?=
 =?us-ascii?Q?oTJZED1Zgyna1qJCBdNICVroci8ttoswoQCmhMAjB6FDXndQIIyz44QSmzTI?=
 =?us-ascii?Q?HcIoryGm4XKqz6X6RvIFoD6/H70lM1svE/MKDHZJbLCE6ysIo796gnsGhkH3?=
 =?us-ascii?Q?eJH0tGSNvvanrIPnnRr0IWMhxrijLd42Mki+2l84ufS+DbX1JH0BVsvJ1mya?=
 =?us-ascii?Q?X03VxackicM2Urwex2apeKyF5ezUA6I5R+++lm9F0uawXJtvmvJ9zHePgf6T?=
 =?us-ascii?Q?2VG/I4yhykKHpzKpsDtxD/dGO8dG4gXV+0lLmcKlwxTCqG0AZY0bH0WDdGGM?=
 =?us-ascii?Q?5GDnBHl0Ad+l/QLpD22gdM/qLjelY68RL/PDTX8YOgQA5I+eHaVYZqB6dguA?=
 =?us-ascii?Q?fgJQNJHDZ6567kDvDDTiencCp6P//SkuygG9kKh9wP6QolW/oGegzp1DCnrZ?=
 =?us-ascii?Q?TujystLwMdKGpnY+KC3n91bcdwH2BW4I4VPqZZpp7AxEnkaxgD5ysEAfInTU?=
 =?us-ascii?Q?eZhU+GwR6wFmz4jqfUCzNRxXQZegHM6PBSIWkzEDCiFA/6R3VVotYdDkGUZ3?=
 =?us-ascii?Q?WY0bIQj8ucQYdF8Ry2no95SqQjEgRA65zcqrdv2M8u1v80mhSNSU6+mNezq3?=
 =?us-ascii?Q?uWgD8aEdprIR9vGJbrY/qNzsQJoFXkrI/q+orgkRY3Q5UKuIJaEZZesSYeiw?=
 =?us-ascii?Q?enPeL2YKgV/jDslHFoNxVEZJSRE/A7anuv+urP6PK3Qa2hSudarAGGl1vpLG?=
 =?us-ascii?Q?xaa8z3YO+7EbVTKRv28LLnbG0tp6nFEcGABr57SbbWDBWDZqg3OpXyKrtZH6?=
 =?us-ascii?Q?DuwlBzvhuY7643sDSChuvfL7yrmOiTknVMkupEdDfF4wtmKDBPXcHIzgc8QN?=
 =?us-ascii?Q?uLvGE6rX7MrfWSnlNWlj+yChVx32CrXJVdqhPWR/p4A5zAGmgvWejvJLXOil?=
 =?us-ascii?Q?oPCJrCWunbm9OqzN6XGJpd2wjobp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98208b06-6430-4b12-6ec2-08d94abfb4de
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 14:15:48.6068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrngnHhAZdKZdD0lIitkoD2Q+xxWtYWnUzA9rqrMf+I3CvTkE3u2D+vlhDdeN0HDi8zzFuDh2NZx0De2xHJFwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190083
X-Proofpoint-GUID: qVd9thlyKLsbkNH1e6W91qPa3hSCASLR
X-Proofpoint-ORIG-GUID: qVd9thlyKLsbkNH1e6W91qPa3hSCASLR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 19 Jul 2021, Naresh Kamboju wrote:

> On Thu, 15 Jul 2021 at 20:46, Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Add a BTF dumper for typed data, so that the user can dump a typed
> > version of the data provided.
> 
> <trim>
> 
> > diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> > index 5dc6b517..929cf93 100644
> > --- a/tools/lib/bpf/btf_dump.c
> > +++ b/tools/lib/bpf/btf_dump.c
> 
> 
> Following perf build errors noticed on i386 and arm 32-bit architectures on
> linux next 20210719 tag with gcc-11.
> 
> metadata:
> --------------
>    git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>    git_short_log: 08076eab6fef ( Add linux-next specific files for 20210719 )
>    toolchain: gcc-11
>    target_arch: arm and i386
> 
> 
> > +static void btf_dump_int128(struct btf_dump *d,
> > +                           const struct btf_type *t,
> > +                           const void *data)
> > +{
> > +       __int128 num = *(__int128 *)data;
> 
> 
> btf_dump.c: In function 'btf_dump_int128':
> btf_dump.c:1559:9: error: expected expression before '__int128'
>  1559 |         __int128 num = *(__int128 *)data;
>       |         ^~~~~~~~
> btf_dump.c:1561:14: error: 'num' undeclared (first use in this function)
>  1561 |         if ((num >> 64) == 0)
>       |              ^~~
> btf_dump.c:1561:14: note: each undeclared identifier is reported only
> once for each function it appears in
> btf_dump.c: At top level:
> btf_dump.c:1568:17: error: '__int128' is not supported on this target
>  1568 | static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
>       |                 ^~~~~~~~
> btf_dump.c: In function 'btf_dump_bitfield_get_data':
> btf_dump.c:1576:18: error: '__int128' is not supported on this target
>  1576 |         unsigned __int128 num = 0, ret;
>       |                  ^~~~~~~~
> btf_dump.c: In function 'btf_dump_bitfield_check_zero':
> btf_dump.c:1608:9: error: expected expression before '__int128'
>  1608 |         __int128 check_num;
>       |         ^~~~~~~~
> btf_dump.c:1610:9: error: 'check_num' undeclared (first use in this function)
>  1610 |         check_num = btf_dump_bitfield_get_data(d, t, data,
> bits_offset, bit_sz);
>       |         ^~~~~~~~~
> btf_dump.c: In function 'btf_dump_bitfield_data':
> btf_dump.c:1622:18: error: '__int128' is not supported on this target
>  1622 |         unsigned __int128 print_num;
>       |                  ^~~~~~~~
> btf_dump.c: In function 'btf_dump_dump_type_data':
> btf_dump.c:2212:34: error: '__int128' is not supported on this target
>  2212 |                         unsigned __int128 print_num;
>       |                                  ^~~~~~~~
> 
>

Thanks for the report Naresh! Andrii, I'm thinking the best
approach might be to remove use of int128 and have the bitfield
computations operate on a __u64 representation instead.  With
that change, we would only lose the ability to handle int128
bitfields; what do you think? I hope to have something ready
shortly covering that, the non-propogation of return values
and the endianness issues with enum handling - in fact the
latter goes away if the bitfield computations are done for
64-bit values.

Thanks!

Alan

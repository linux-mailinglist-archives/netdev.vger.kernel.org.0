Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7766E48D5C1
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiAMKad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:30:33 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44720 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231269AbiAMKa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 05:30:29 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20D8Mbg5031717;
        Thu, 13 Jan 2022 10:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zz+sZCEHgTqlKkNzG73vvPKElm+fx6zlm6qlzjFhqwo=;
 b=iKgfODjmJmhG7cyvjoCFpf8FXY2A2glJ1Ef04kTpnKzXAtFgJe1MtYBIgpwSs/xSluPT
 HurnlPR6K4EJwXeb3LiukVcTvMl4E1Rmpc859arBI3/2Yw9XCh0Y5fNtZyy1qDTLVEhS
 dHbOCCVeEQT5JZZ6lAV55AX9OPUyDCyyT9kc1h1q6BIoCuzskBNRYjnpODVOBJykwIS2
 4jPwEOEfW3TdU2DxDVXvpGJOe7LW09T/JWYko7UzLm5+gM2CCGraxuVAPoQU5nEXUoUj
 i9MOg1MH4zzpVmyAKOvHdGMjafUGYzPPyBL+RkDqkm0498madrXnKIWSErkqryywewU2 Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk9grnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 10:30:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20DAFjAx030505;
        Thu, 13 Jan 2022 10:30:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 3df42ra4dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 10:30:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msbYT63X3XMUO/DXVz6tcQTTgTqQYAZcxBhaEYviCdu5WKn9LMR+yOVHsCSUQlxhQp7dlfsB0MpSpuMyn7RCjRFYfZfX1vxE5LpPXQ6pA+BGMPj60SyZJLB5wyQ/35T8cXlbHymrJJjIRecjB2Qd/eLesyOjWgeufguyHXgOiZHR+ZA2BBKNXlNtW7vAwlFlKEYXTb9dcfyC/KqgnxcPTYQ9Q+4R4q9GCjCLsdmvj/ujxmqF7UVmQCSFAAm8yWwBYF0At4S0ye0y1uo2oySePDtGH8z1UuteVXnNdszA+0HxZuADlurVvbMeBRBs719cOlRBIFib3vI6f39NHeVoYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zz+sZCEHgTqlKkNzG73vvPKElm+fx6zlm6qlzjFhqwo=;
 b=f/6LQic4AY7035FVS5DraaTPPcTdqPaKE+RSvWEzXaKY+yoLHqfpJK0i8ilEnPOsHaTaqXU9yYvhqgkfS/RdpK+O2ebYxkC14EbS+lgb6VI6vH7WNBN0eZiq3AJkkEinqrfVkbnJbisnQhYjP6q8TDzrIG5LCfS8UlGplSLdGgyRnbyw7s0C+S0JeZ/RYhdbtISUo4x23qEQjG+qSH20I2QuyEGOtPU9oEPV4ywP0bgfyj6FkyR3XHqiKrvYsJtiPnYbSQ3XyRZRo62iujJhe+++1B4EbbD8c44Iy/Hu+1NHa5I5r/nD3i7q+rAwG/sn08kdLALoFXDeQWMKQby/LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz+sZCEHgTqlKkNzG73vvPKElm+fx6zlm6qlzjFhqwo=;
 b=hjKoXcbJdASS/YAf5AcZ4HhDJuxGVo6b6V26ysw7+c+jWbPK9pNZV15F7TCocLx3LSsNitcFUlTfD8FCsJEspZlsFDkGlBVql6jQzML+1nsym6ESng6joEX6pGrYSKNWg/0WA/lUSmz1qgpNV+5tVjFHsBbGhoY3sAty7h58T38=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB3546.namprd10.prod.outlook.com (2603:10b6:5:17d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 10:30:08 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 10:30:08 +0000
Date:   Thu, 13 Jan 2022 10:29:35 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/4] libbpf: userspace attach by name
In-Reply-To: <CAEf4BzYRLxzVHw00DUphqqdv2m_AU7Mu=S0JF0PZYN40hBvHgA@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2201131025380.13423@localhost>
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com> <CAEf4BzYRLxzVHw00DUphqqdv2m_AU7Mu=S0JF0PZYN40hBvHgA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: SG2PR06CA0094.apcprd06.prod.outlook.com
 (2603:1096:3:14::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eb7e2df-4718-4d06-2f3b-08d9d67fabec
X-MS-TrafficTypeDiagnostic: DM6PR10MB3546:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3546CB54DFFEF52DE2C11DEAEF539@DM6PR10MB3546.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tjBZq4AdazVHlpHM0l7iwlsNRxTsTz2p50k1n9sK/Dxu7Zpe50whY6MTQb5IsXVbGo7V+quXLBuh3ZGoKRMBRYatsYP3cz5zxcSyh38HAkHKXI6CtrufBqYJzHM28Lx8hzJTjKDe1eUna3VjfHb+HE+sYUMtBpLvfy5ewlp22vTlHLVz/0/sDbtFgPYyo1rRIEAPLlpv+pKZHo7w/qjc3L4rsGaZ8+i9lcaGeMl8mVr3o4jsqd2NalnmCNXACF1EviczQ3qf1570HyAEGx4/yC//FS01rz7X9NX7ScYUdIxvRxgaXZlPMBaRn75PmSFypcIw++ltcCudLhZyNXaisbIFpywTfVqmDGl7lwPPTsjdxefyFjYVMMiOEsA6Pt6y6CiQDr8XPtiinIWOmlGCQCngShN8x0koDrm9snABo0CokyWPqexvXvBW9+0AMFztfdx7/5caMQJbh1QknqviCJqyIKDwrUQ1NS5TOXMe5cwnMyRj9mE0yot88ufiuH1lP0O8nkjOlPbhlCabGhc2b8GbMcLtwb39jnLQtGwkmwF4uYw7ZkxlCXvkg4n4Gbm3LdZmnf4YinK2ntMpJvVfs8i0AZPPxJACX6je/hZBHFi7Z2sG0nER8BR/2SYde0I0MP2bXGQhw7CMkER8XoqKaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(44832011)(6666004)(6512007)(9686003)(66946007)(4326008)(5660300002)(66476007)(66556008)(7416002)(186003)(508600001)(2906002)(6486002)(86362001)(54906003)(316002)(8936002)(52116002)(53546011)(6506007)(8676002)(38100700002)(33716001)(6916009)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p21KMk1a3+BR1K+tA+H+79lLZHcL3WG7W7ZUPEKGAdRWvYo2UoxXG23I/PYy?=
 =?us-ascii?Q?uiowXLx6FXtG1y/wJsoQCtZn8rEYLulJubdksLezsTfxtAj57DYVQf2wl6yp?=
 =?us-ascii?Q?3++NtWOksuEfini+8LsPh9oKzpPC0DaFB9MHARBUPCpAaJKgIeJEh6lbO4a6?=
 =?us-ascii?Q?ZuT7LrAS41SfLIrSZmjmBnXtPKOja7nrZo8hrDCH4BZH9q48eJZw/y+u06EQ?=
 =?us-ascii?Q?D6jiIwWOX79QfHXhjSdY0cThvx1j4utP44YT5bTMT9hNQSBORp5axdVas683?=
 =?us-ascii?Q?l5zTNFXB7zgYcocGcjwULi/bvy34lYlcuSa0pab17f+nvNUdBgpLDvUA1rnB?=
 =?us-ascii?Q?VhVsPNrHg35/phVvlvBfilMMCiQMNiSebzo9KEg84/8JdY5N6YK494LFncNf?=
 =?us-ascii?Q?H+SRv8oKoJWnI+5XXU5UzBokfCvgjV7PdhvE5qCl5epsYaPkGfN8Jscq5cGM?=
 =?us-ascii?Q?tjGvKoqrtInSXKOMoqlp3xJqqsVyBm0lCBBZfQoA6N4ErvFHLqq9yeDg/+ZA?=
 =?us-ascii?Q?/MZK+pofyBZ+8Nz4vqUlmgCkhF2XiXu0s32eH3I3TE3FK8WvDz/c93TSJeGM?=
 =?us-ascii?Q?CZsLDiNlV5kkyQEScUmlb0nrjSXSCBhS5IZ9PnsCvZP/QYuzRUpexTqOngkJ?=
 =?us-ascii?Q?Q8BUMmJftPaemSbq67k0jtnZLxaj+bKva394kBIJ8xFxj3xOfSoPPrdIuq2K?=
 =?us-ascii?Q?OEpBjJTeIyK3Uh2QzE5vKktFvp+sO43qnibL4jpmACDewGDjQhiE1mSthZlO?=
 =?us-ascii?Q?qBS9bfYdiYrCJnyPuLJInrHqoDG29HN/+g17Xfr9vuPnS2gcvi63wptzUaPH?=
 =?us-ascii?Q?sOoNGR6Xy1JdKRjVTFSwqv9lEgzcnxfcQYO5npBLxXZYzKSotReYzhOBwnf6?=
 =?us-ascii?Q?KximYwfgWEDKNdBZyv+RsK11wVDfckOMRcCA3qhJfyIGWkCf2QiBnQJM/NOP?=
 =?us-ascii?Q?e6ocaI8D+9/jfB7Vdfyky/UcGJyT7nI8ogE0jP7M+xnLAr49X0tekHikYx+t?=
 =?us-ascii?Q?afcwOEfve3+0pYrGmMozo3MXuj+fho6tygfr6S7kG2GZFyuPFbOSj4zw6JFP?=
 =?us-ascii?Q?MmkJx3O2Q6DfEZy629/ydjocI8OGULty8YdamwJ7NBVS2kBbyAl28DPeOYu0?=
 =?us-ascii?Q?ALpbxAuNvQBNjQJDWVN9YNHl5PUf8oiYRwtf/REobQQJHcmqzJcbLYllU1X0?=
 =?us-ascii?Q?2gnOQ/acnYeur5ANdLW5n2YtsU8hsyDedeZFnj3fzK5WMGUaRDppOBzGO0Hf?=
 =?us-ascii?Q?f1MeAVtX0teADpgENwE+CV0vXdIyFHIvBvtEDE9TjfHcYAhZBU4T2XnHtg+g?=
 =?us-ascii?Q?lsaNZqhCFHDyaAFigoMNvMenqIgcOccq1sTd+bUJ8N8zsX0rg0RREmJ6MWyN?=
 =?us-ascii?Q?OmviY14fjenJe37bE2O3ph/f+ycH/Zu1UpsDuEK6tOd/1EzYx4ysG8vQBtax?=
 =?us-ascii?Q?sFTjEWr806vZH4gX4Ximox6ME1l+z2Mi7tjE3jiqBKJImPABIQjPWGloJTUz?=
 =?us-ascii?Q?r2jnJOlSBq7EMG5e5ctSrj/LWNWGuWz4gcb2JqsQMVISfrmtGoCJDks7FcgS?=
 =?us-ascii?Q?ww6+ElJ1chE9zh0DHqBdRGEFuxBrL81lT6kRWICU9zfzNeuIkmLOjuofT/kt?=
 =?us-ascii?Q?9Sy6RVpTilNffDJFReUTwVr9X/c2vJsosFPoHEn5E7Wp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb7e2df-4718-4d06-2f3b-08d9d67fabec
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 10:30:08.5396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jk+9WAUUFzUJnx3/k3aVYitU1RmvZkurJpWlFTHFt4oGmlN385CY13GKxVFJBcMxPlWOPLSlV6NrHNDhrCjsbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3546
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130061
X-Proofpoint-GUID: UhPjIv_cr_aOTQ6Sy5GR_ZrJOacY0eDJ
X-Proofpoint-ORIG-GUID: UhPjIv_cr_aOTQ6Sy5GR_ZrJOacY0eDJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022, Andrii Nakryiko wrote:

> On Wed, Jan 12, 2022 at 8:19 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > This patch series is a rough attempt to support attach by name for
> > uprobes and USDT (Userland Static Defined Tracing) probes.
> > Currently attach for such probes is done by determining the offset
> > manually, so the aim is to try and mimic the simplicity of kprobe
> > attach, making use of uprobe opts.
> >
> > One restriction applies: uprobe attach supports system-wide probing
> > by specifying "-1" for the pid.  That functionality is not supported,
> > since we need a running process to determine the base address to
> > subtract to get the uprobe-friendly offset.  There may be a way
> > to do this without a running process, so any suggestions would
> > be greatly appreciated.
> >
> > There are probably a bunch of subtleties missing here; the aim
> > is to see if this is useful and if so hopefully we can refine
> > it to deal with more complex cases.  I tried to handle one case
> > that came to mind - weak library symbols - but there are probably
> > other issues when determining which address to use I haven't
> > thought of.
> >
> > Alan Maguire (4):
> >   libbpf: support function name-based attach for uprobes
> >   libbpf: support usdt provider/probe name-based attach for uprobes
> >   selftests/bpf: add tests for u[ret]probe attach by name
> >   selftests/bpf: add test for USDT uprobe attach by name
> >
> 
> Hey Alan,
> 
> I've been working on USDT support last year. It's considerably more
> code than in this RFC, but it handles not just finding a location of
> USDT probe(s), but also fetching its arguments based on argument
> location specification and more usability focused BPF-side APIs to
> work with USDTs.
> 
> I don't remember how up to date it is, but the last "open source"
> version of it can be found at [0]. I currently have the latest
> debugged and tested version internally in the process of being
> integrated into our profiling solution here at Meta. So far it seems
> to be working fine and covers our production use cases well.
> 

This looks great Andrii! I really like the argument access work, and the
global tracing part is solved too by using the ELF segment info instead
of the process maps to get the relative offset, with (I think?) use of
BPF cookies to disambiguate between different user attachments.

The one piece that seems to be missing from my perspective - and this may 
be in more recent versions - is uprobe function attachment by name. Most of 
the work is  already done in libusdt so it's reasonably doable I think - at a 
minimum  it would require an equivalent to the find_elf_func_offset() 
function in my  patch 1. Now the name of the library libusdt suggests its 
focus is on USDT of course, but I think having userspace function attach 
by name too would be great. Is that part of your plans for this work?

Thanks!

Alan

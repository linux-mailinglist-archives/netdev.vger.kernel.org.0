Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BE7493BA9
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355008AbiASOEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:04:35 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6634 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350177AbiASOEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:04:34 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JE46CV001398;
        Wed, 19 Jan 2022 14:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nVgVWf3NQdjICpH+1nK7UKw9aDiZl+xnD2Ld4StXi3w=;
 b=aYgU0sM0TVvE54taSdzeCMI22YuslrxDV2IzkgrjCBeNSXGPeR9pkqaJMlTSpxG+3ZJb
 M0IlLlREFwxB9wu6/rKottfUuuHAqpI9hDmla5Qw8GrqtemcqqtnivNXx74kVlfSwm4S
 x75qSOA2icaw4o0lzM+In5C/R56tmeG1kz1NxKv39tAFmmZXgGK8xoVVPLrngp5bS4FB
 1g/a+ypVh0zqWc5UXuVYAEFMNPesmmH72leOIIpGf5hkxIjXd3vMAYU6APsQZ7li4iD9
 UQvclo6DeuRMZ77ReMI78fmpXMsaqNQzAop38Jm/IqMxdq94wztYCvIatffLiIVoCOmV 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f538b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 14:04:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JDuuga042901;
        Wed, 19 Jan 2022 14:04:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 3dkmadp9cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 14:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irQzDN2Cpf1QHotPSKl7En32MgKslDXD90RCPfjTtHglj+bsThKLfDOaYWyZL/lCljds+iP2w9p7/XFDvvn/kxwpiCqiJv8LcoyCUPVv0VLpw0Dm0glB3JL/SJkdyBBTedwV5GrvcrI3fHHMtiKzLqGShH9YVrVpvIMRE17v7FS0BwoPoV6Lqz7/OJqb9r3KZ7UcMUJMFRojo6COAkjlWYY8BXWxZIXoWzOCm8KxZW0c99e7FWDRG2kEFZ7G05MX8Kceq/QXbVuEsR+9GrE8DwFuBC1VVedVKM2T0r0sTnSbogI4kpCnU9b2LG7SfwjgzIh0qTs71GyJHoRa98dhpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVgVWf3NQdjICpH+1nK7UKw9aDiZl+xnD2Ld4StXi3w=;
 b=benK1ZouRg8RSmLLATIF0+r91zGqAwqT4G3Xf6U//oUB55Op4DGCv0UDAGkzOGMucXlTmNqsJ8impKAhwacAWBSr212twjPGEIpY6JEz7AshaGmdC02cE2xkEtKkJke1hefy0R5MX65U/pVlEIr49YMP9Ieluxj36JhO+rZVbfPTHAhPvxroYezcScAhXDgNgnGo6O/FZp/hsPlcb+8XDdzn4yt8HP/vf5HuyGzJlK2NCnp224t32lvSV5fUOImphgAWhJLH1U0ptvbit3lpzLkq4LfYO/sLRV2oiQeiC6Sl5MbES08Iosz/X/3+ogZAg2/MKOdYdwRr6m8V9MVpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVgVWf3NQdjICpH+1nK7UKw9aDiZl+xnD2Ld4StXi3w=;
 b=L6ZMSQ6Ky+USJrbfQn0s8hpwJP62ER/SjZykH+CGg5DadaOtfw3Ed84XkOob5kFOudU3VoiqVtTda0JhBv/hdJnwMU/IweC03jl+a6KTJZsVd7dqL/AUbJLmMi4tcYC9aq+T+Hx5j2txMDbfZrOUsKVLSqE5aKZgXj5Hx0lT9yQ=
Received: from DS7PR10MB5278.namprd10.prod.outlook.com (2603:10b6:5:3a5::9) by
 DM6PR10MB2746.namprd10.prod.outlook.com (2603:10b6:5:b3::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Wed, 19 Jan 2022 14:04:14 +0000
Received: from DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c58:bd9:948:3c28]) by DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c58:bd9:948:3c28%2]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 14:04:14 +0000
Date:   Wed, 19 Jan 2022 14:03:43 +0000 (GMT)
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
In-Reply-To: <CAEf4BzaX70Ze2mdLuQvw8kNqCt7fQAOkO=Akm=T9Pjxf4eDpLA@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2201191341380.10931@localhost>
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com> <CAEf4BzYRLxzVHw00DUphqqdv2m_AU7Mu=S0JF0PZYN40hBvHgA@mail.gmail.com> <alpine.LRH.2.23.451.2201131025380.13423@localhost>
 <CAEf4BzaX70Ze2mdLuQvw8kNqCt7fQAOkO=Akm=T9Pjxf4eDpLA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO4P123CA0031.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::18) To DS7PR10MB5278.namprd10.prod.outlook.com
 (2603:10b6:5:3a5::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faba71e2-8cd5-4168-a0f8-08d9db5492d7
X-MS-TrafficTypeDiagnostic: DM6PR10MB2746:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2746B3E55E2C2AC2848FFF95EF599@DM6PR10MB2746.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzsapVeOrEp2TN5ExuapZs0OoNPieeq4jn4NV7T6C4zFZKgZYLmQ+yESOvnxgt9KZm25lez2AcdbGctzqmIln/bldAT+Gs3ezK3ikmdZ705/ROnTrRR23FuX3e3Ci+QzgpYEM4T8HKgqFQQlGRnEdTGcxJwqGYFqTL0T1b4Fb4K80k7HvxCROhQhNS+UUjRUwRkXLAKPhU+EnLLSeLAMJK+ce+/hwsiwSpYIT6tdA2ZOPdO3liGaiC65B1RCmxvxlFY/Gh+ILe+6h3LIo+xuA9GwrENTIFfHdFsXEb6E0Q2RDUxllyanBMY++sJ8u3r5f8e/oKP+cywoxqaBifcSUbCebumVFg1ui5aJSWKrsgeJtpegHxwCN5E3MTNzo+rhfeOH3RbTzh/FxANuRXOlo25PQX2sRg0PEMR+s5ITWDEdODAUObrINRvtZc2j5YDEAC2tBcml+GDiCLJT+sqoeSSPkvyTR+xZCmW0V7ZHUmxIhzqG18CyPlXbNuWl4hilcha2BrvJFuU3V3tjL+tk32gZ9YyK41DNwP5DLc5d1H/r6WuR54JdUicWuUGOaTGgfsXBsw/QfYiq9SZ7G7rPQWjq0Et4OBEzxR4qgkQyV+5JE8VrrZN5+GVED734sYxNcvxjB0NDEHOxTqJSHzFOlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5278.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(44832011)(4326008)(54906003)(186003)(2906002)(8676002)(86362001)(38100700002)(6506007)(7416002)(508600001)(6666004)(33716001)(5660300002)(6512007)(9686003)(6486002)(6916009)(316002)(52116002)(66476007)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TckCfE1dK22xnAU3ujzHOF734aCvS94RL/O/1zH5JM3W9Hi8/ZKzip5hIyyZ?=
 =?us-ascii?Q?grcy81rSIWY7xPgDoptke3e1ayZYB7h4kRpML6Gg18jcZCmEm6/R73SaWHY6?=
 =?us-ascii?Q?n2H9pDfCvMMrtBYQsdEfwMIgp590sNSsvB1Tvt2QqgJOMQ9nmno6MGXgaN/P?=
 =?us-ascii?Q?hjXYNK84jFPpoeRCjxEVn0RC+mNdkoUli23+ssm0iarVaObmP7fZits7eqvo?=
 =?us-ascii?Q?va/XOFZKKzmlgQc+WVTrcg5SBstT8bytfNdyu0hf0ROG5G8wY+iA5qLBmv1X?=
 =?us-ascii?Q?Df8Ga8DyaMBCebFZhLP97Y+RrQfJ42gNSqfZfLqFQQ1oXacncAPQbR/zyI/X?=
 =?us-ascii?Q?3/LAAmjltJdsV2gEraQzkE+I2EqKR9BWfdv9fK91T2CprYRPBoqqb8XG/Yt7?=
 =?us-ascii?Q?Q6RFpmDwuDxv+Lvf7DRMXjWi6bSNsZQ3dPrszKgXhITXI6RNDYS3cjWlO/pN?=
 =?us-ascii?Q?0PxkP1GL3C0pgtr3aE10BDA9HO5sE8i7QbpqNiEaNaXLfkhEZUmUVrTEZKZa?=
 =?us-ascii?Q?bppse/KdjAlZ9cOJTkpUaAZ/HFpWe6KwqFFH1jTeIyOTBspYrHtQSmN0jAUL?=
 =?us-ascii?Q?XyNqRnr2nKno9N09Pxwx0x7NGMvpVfh0numEAdgmjnjic6Lo9UMFq9RXKHcR?=
 =?us-ascii?Q?En33XZuuQUdZYbUOtXgCmRVAWUPxM9/gdmAbqIwmyrVw5WfpQdd4MeOZOtTB?=
 =?us-ascii?Q?CMb6SmfyJncZwxsWhzj8Rk4sm+XUuxhCCe3gpEB+pnaRTc3q3rk7nzxbBzv8?=
 =?us-ascii?Q?ABN6ZjzjjEtTAaWfdG2kTMssdscKuzUE+kr5nIe8iRaZPK3Dj1jLF6bA58Sx?=
 =?us-ascii?Q?NNAH6RFXN0uTs8LiDZwRz9lnfJMGBlaZT2a1nCC3GGgLjGQ330ofYuHuvmke?=
 =?us-ascii?Q?KdtfIxbVmwvlw6JMb191wR6LA1VV+dRMHulQrlVZMaEewnj/Ma9sxhJFeZ5l?=
 =?us-ascii?Q?JWarWQR5GxjcSUuBQk2IZvygDTBnzkmuEmuZMnz0LakdnI/33xp6Ef3EypzS?=
 =?us-ascii?Q?PjKDsCgKZLHBIaxYYJb9UPZo+uC84MHhcVERFFSuLdH1Dy8Soq7j034T3tqX?=
 =?us-ascii?Q?bvfMtnLmVE21gQpDhYC3llrY68JQM2Mop+l5IQIwzSASSNwEZppJ2ODPaGJa?=
 =?us-ascii?Q?G9v/hJvrhwQqpf6A5JabS5lzjhfn/Ixfj01Zk1obeHZHSDy2UHHWCKKNnQ2/?=
 =?us-ascii?Q?W3kxwd2oDMjr8YvadxFx/+RBItAFJdDLTRMTmFGMI4OlmYTGkBQV9KEgrkE2?=
 =?us-ascii?Q?H1xkrcHkrln+GGJSfI71f5JrfqD/s15qKI+Bib5qAmZpHGFhIDprEvm5o7x7?=
 =?us-ascii?Q?RdsJZ73CiTh35oKsiSSxvSf0n0va9TMcQnxt4pD3qMpzREntxA6yriq6MC5/?=
 =?us-ascii?Q?QvreK5GhwGmJhQAhLRlCKgsisbOmzJyQgjmW41k34Y9hddIQSqHbBYbyWYoO?=
 =?us-ascii?Q?dUVW5sVfhz+bT0iHlXSyOGHNcNjG/y2OIYVWjgPueoF1inLwakYe+0HB5YDL?=
 =?us-ascii?Q?th0XF5HrWtEYPPzWndFjYsN4J19cxTcR9nYbYjzYPkOwCi/CwsDN7/9dIhJF?=
 =?us-ascii?Q?SoJxEVtf8LbfjZCHCj0OpDTn1eETudFEVEAFeZzoWMAatEJoLLrC8AlJQ2jJ?=
 =?us-ascii?Q?g0ow97li1xmwhLncSQkoWwDp/B97TT9J1isltPEQqF6iy/aKFHh3siW43ez+?=
 =?us-ascii?Q?GL4Hj26BebRr0hlaiJv2UYLA+UA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faba71e2-8cd5-4168-a0f8-08d9db5492d7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5278.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 14:04:14.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8M33iods0cox43dEjhI4EJCRKJWw7Y7b48w/0uCSl0zFNwlzJBvoYttKAOGHkqjGuyVrQGFE17U7SToGIMviQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2746
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201190081
X-Proofpoint-GUID: rbnpbv1UW7vp0PKHjXBxltcFzCzo6B_1
X-Proofpoint-ORIG-GUID: rbnpbv1UW7vp0PKHjXBxltcFzCzo6B_1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022, Andrii Nakryiko wrote:

> > The one piece that seems to be missing from my perspective - and this may
> > be in more recent versions - is uprobe function attachment by name. Most of
> > the work is  already done in libusdt so it's reasonably doable I think - at a
> > minimum  it would require an equivalent to the find_elf_func_offset()
> > function in my  patch 1. Now the name of the library libusdt suggests its
> > focus is on USDT of course, but I think having userspace function attach
> > by name too would be great. Is that part of your plans for this work?
> 
> True, uprobes don't supprot attaching by function name, which is quite
> annoying. It's certainly not a focus for libusdt (or whatever it will
> end up being called when open-sources). But if it's not much code and
> complexity we should probably just add that to libbpf directly for
> uprobes.
>

I've been looking at this, and I've got the following cases working:

- local symbols in a binary. This involves symbol table lookup and 
  relative offset calcuation.
- shared object symbols in a shared object.  In this case, the symbol 
  table values suffice, no adjustment needed.

The former works using the program headers (instead of /proc/pid/maps for
offset computation), so can be run for all processes, lifting the 
limitation in the RFC which only supported name lookup for a specific 
process. Around a hundred lines for this makes it worthwhile I think.

There is one more case, which is a shared library function in a binary -
where I specify "malloc" as the function and /usr/bin/foo as the binary
path.  In this case, for dynamic symbols we can't just look up the symbol 
table in the binary, since the associated values are 0.  Ideally it would 
be nice if the user could just specify "malloc" and not need to use libc 
as the binary path argument, but getting this working is proving to be 
trickier. I've tried making use of PLT section information but no luck 
yet (the idea being we try to use the trampoline address of malloc@@PLT
instead, but I'm still trying to figure out how to extract that).

So I'm wondering if we just fail lookup for that case, assuming the user 
will specify the shared library path if they want to trace a shared library 
function. What do you think? Thanks!

Alan

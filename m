Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF349EE4D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiA0WzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:55:18 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30622 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbiA0WzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 17:55:17 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RL3p8X029295;
        Thu, 27 Jan 2022 22:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IqQTZnk1a47OSHcJxtSUu1/+O8gY7cshsLNRKJNQwuE=;
 b=N9IxOcbW2JWmn7cZuqpCyHRMfUl5HWRipjvMA5hxOKPSXA+08RCK1OrnPSjH/DnrzWS7
 FqBcc/AyRsDLLJng31hfSVY8Pk+znuKd5XhA0abpoK2s/emX5yWeJm9ixMYQN30pkr7H
 9XdSSLJkiG/M7vAqP6nbBkiABuhW86aluDlun4spIy0xVW2/KdhXvGShHOV4XoQcPaD4
 2WlBfw7nqcQbFUUCYMK9HP4Z6/HfDmqHlKZCn0vYgH9l793hDI/+roWrvSube5Vp/d8C
 2f187taS1TfutDIJTGXonH5QiiUi0lxmyGLRdvNqUydlOjzlISDqrLkR1R+ZjdENYwMl 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3duvquskuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 22:55:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20RMVAuo162071;
        Thu, 27 Jan 2022 22:55:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 3dtaxbcc7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 22:55:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg6xNHZn6bO3O+KZmtNx5NJoj1HuY1HJgoRcuz6cPbrrt2iVMG1Y9VQ0WWdy97aJvwuAsAAUGEPG3F9jd7ySyIpWrXta/ve71pFp+VEFtXCy4/0zBF1P/eb0XF0knr9wwX6+q69wgGYzPU4tjfBtCzytjqM3DN0LXZUNdu4X1umt1vbiU4QgTqeLGTak0ypHyDN1sF7RcLGVUjJjyTOK7od73k9KxcNoU0wnG7IdCu+/CnB688ghNhLTqCB+tmcfGyNexMg0Gjmbe9AH7f7mlKHNc5W4+C8aozc5XsvOVZrvVA2chxGdrYZisqJUEF6Fo7Kq4GA/ET0yq1Wkqw+BIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqQTZnk1a47OSHcJxtSUu1/+O8gY7cshsLNRKJNQwuE=;
 b=WHQGeqHCQRL3mqN6ZX1DZDQoHigoUVZUQ8Q+ZQ53iP5qdYsSnbGCW/IC4MvqB/mtxxTdo7YtIoqDRgA3UdfDT6yjwXXhsYkv6/ER0eVoG9pW1CyuevNBt6XiuYtDqcQLhBxWx8NwTPwf9uboMFmI8hfS9Qobn64KUzMIsPjSQNw0LETfrLeGZEmjUClLyPt2jpSteXW2eGIAVM8KMj1Nq3awPE5g77Ebi8xag4HsvqSO/mQ56+50mRGRB3wgUwF0bfpH+sk2q13fU/Ye5f9NJlhMHzS166v/cs8AzWNHdbMH7Bxkkx7t54PkWtW9jerACAP3nmMwplhkeyUjX4r6vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqQTZnk1a47OSHcJxtSUu1/+O8gY7cshsLNRKJNQwuE=;
 b=U3D9bc/7DWTviy54nhYk5Jk5RaljOE8hycq/CoLlzNqhwBqvzV/uo1ka2i+jzeUpW8gnNHL/R45qfVo2U1VsUlrjQDHE/munqULHENpQJLB5LMJk0fbNXH3a/ShzUC1t9MoxbFRUZIHmmDNbBTgkS28raxR4HcR0KWNRrJj+pGw=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR10MB1754.namprd10.prod.outlook.com (2603:10b6:4:10::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 22:54:58 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 22:54:58 +0000
Date:   Thu, 27 Jan 2022 22:54:44 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
In-Reply-To: <CAEf4BzZ4Xzhybhw_e1Q3rBNvSvdLBF7JFMex=mg_dUf_Eza5TQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2201272217470.8195@MyRouter>
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com> <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com> <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com> <alpine.LRH.2.23.451.2201241348550.28129@localhost>
 <CAEf4BzZ4Xzhybhw_e1Q3rBNvSvdLBF7JFMex=mg_dUf_Eza5TQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61a4aa39-8f3f-4180-9663-08d9e1e80b0e
X-MS-TrafficTypeDiagnostic: DM5PR10MB1754:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB17541A894DB5E16FBDAA05CBEF219@DM5PR10MB1754.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kEd7HT/XVki4HO7h2GL7l1lDyUAvt1y2FDc3qd0ih9dbDSUYvwkMMWL/GhtvwV9nYepKZ1qvK4YlVTHKonH711v2dFtA/v2J+eImh9MydoqPYOMUB6GK0Zup3OtqdBfzFvrauXGfvrR//ceXM+XNpH6B6KPLrT5BjGQ6m+nBRYW7nSQpwSuZhZFUDppJ8ar3f0htkZmPjDcoVE92qjejWoTTGZHoRbozxFSJGUjQ5qvWtY8ZQwhkpeI9aALNJDUC/2dMKoOZY9eK0uacLcIMNwQ7OMuMv8ScRXErnSejVEjbwRgD1zVaEkhTRzyTr3MaRYkriJT2sU7Huc4+bXR5Fi3PSbTFuEfURejb1Uf4T+qv17GTsWG3Ubn/psDZdbvIODLKYN25pZkCA/Hbyaj/1A44unMbpKHDfeleoiiCQFFuwob7hr40mUjrvzwYv4VysDVIk1M+C7pEP3rTqa6qWYZt96hKNmm9xVXK0WLBYyfNjtfAUC1w/QqxdSYIvqlYIELG5vstT/I2A6xSjgJZmE2LbjOD233fRYtmqHLQFmmcY4R08Leo/lMslH8dLdMBMMmgRRz7IxqT7Wqi33Ep08gjSM1ip6nuZ59lsF3dmjjJ4qSxePtDt54073g6RQjEIwQDwVaHRpCsIGJ9YMHI9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(54906003)(6666004)(66556008)(4326008)(186003)(5660300002)(2906002)(6916009)(83380400001)(8936002)(9686003)(53546011)(6506007)(52116002)(7416002)(508600001)(38100700002)(33716001)(66946007)(66476007)(6486002)(86362001)(44832011)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJl5mkvPQUnSeExIbeLjOG3EslrVbGxTMG7Ux73tf/acPh5QpV0Ib9gdD/Ff?=
 =?us-ascii?Q?gzsnO5S8hRTq3hO8Nzp8zesTWE8UknH7IPOI+yvkme45tf5mge7e7zjlXT07?=
 =?us-ascii?Q?vC2wouNdmM+DkC4WkKyFstAPgXgDaJnVb5IQK3zbFy97jaHq+mXCkl3+HYwy?=
 =?us-ascii?Q?rVmHqUo74NH5t0Gi/mydBDVbzoe5Qn3FY/0MjLSE8pHUtKP+XQgGTOeV9lX/?=
 =?us-ascii?Q?Xfkc1YoowVra4l1fM3F1XGY3HgE0pdQAjAv/lAbQIt1P5d+RCKBNqdysOqO9?=
 =?us-ascii?Q?pGByMFyXoM+rdpzv/kycV+83VNLCX93kcxMdc5LY23jvGVemZVWpKwN/dgiP?=
 =?us-ascii?Q?CYB2JetJnd+qSyWZHwIFJBFBKL524lb32lpXHBNMvaSuO4PYrmN+3Tz7W7Cg?=
 =?us-ascii?Q?6imXiwiERe6HHuMcfF/EwEUY7oeNWyXB4BNmsQs18zlmjYhpbwOFexBrFk/6?=
 =?us-ascii?Q?1ZTfpc8xbNFXViIddhWwNfYKNirZeT9tF9/EuCyWI5zByxNHZ+sEJrRIm7Dy?=
 =?us-ascii?Q?oAqL88Dn/Vb8lXMPS4FfFLr69qm9e54xapJG2ghPmE0EDEqTh0rxtlxY3KCI?=
 =?us-ascii?Q?jL6rNpdo0TnZs8iJfXh1qoqI5ytUsDpHKPEQtx81QTGUEAx3ErHx1l1/rXo7?=
 =?us-ascii?Q?GHU4NAx+OXk8bXipSHX0F7X37j0IfbcJ0jD90SMyMNF+E4WUXAtalpPW2RiN?=
 =?us-ascii?Q?GAyo4dVSjWx8QulHzMX/D0/v6Adz4S+JC/XdXuUYBAUACNx9fMZayUOXl5sr?=
 =?us-ascii?Q?Vf3f8KwyBf2VvEVK/rl7BOjdjLvaM3on8PF+BJnYXtHSyvyVWMVuXMfVz80g?=
 =?us-ascii?Q?vf2W+DEijoANs9gxnBVvvIe7UapzZ6N7ToIzGAZfoMinCcShtxbbIKtRvE8P?=
 =?us-ascii?Q?WAzzkxWpuU+a7y9RHSLo1ZsZqwQy7+NZfguEKT6hYp89QT6Mss68dQuF/aJ3?=
 =?us-ascii?Q?0Pyw6qfufYGESutJc0zqKcpYD/vV83InO3utWbFwpjROMa1XdjSVxcWKzkDL?=
 =?us-ascii?Q?boMDvMQ/bD9zDWa5WdjJ8dLLfrcwKuDMBgIB6I27OG4wQ7bbGT8R/o1Zo3bz?=
 =?us-ascii?Q?Qe/ufm63veV+NggvKhUxQvfABEj7Yt4X3DLot1RqS1VtaQrfgeMxgve25NiX?=
 =?us-ascii?Q?ejfl6LR2RhkQs7GgGMiwPg3GNHkhfVcFKTiJBVgxSg56xjiQBHaKx+38YJuf?=
 =?us-ascii?Q?Nfjl0GKoQI+VFBVZRYZL3W2zI2WphMtPTM4Uj260ygxvqBEpZ54bKUzeabMu?=
 =?us-ascii?Q?4m2G6k14l/Ia+7pV8zbwGdR5QeC4Ll2/DczRwCavE/JmNVRT7maxnUcje6vM?=
 =?us-ascii?Q?q57hpMA9045ZQ+CGUzfWaKFDS4G3wtTIBaZMI0kKfTjgYs3JU6Al+6fM303M?=
 =?us-ascii?Q?oMg0xCSDboTzXEDNDGcBBSCNBwHmFtG7b3w/6UAruRnyCNoaOawY3nXSEtHv?=
 =?us-ascii?Q?gG777WvHOFaCg2TgfYvBZrk5fhhPSJ5R44+Rw4NHlF0Zm2bps4tD4YszL1Qq?=
 =?us-ascii?Q?Rw26ilKcP7SNcUj8SR53xja2BMXMoIXW6QzYlO+TpbQ6cDH5r5tO8U+l/AJj?=
 =?us-ascii?Q?OkOwYn3FyCh83eLJ1vBDyLpWQyYTX9yfRb31vkAgktcdd1luYroxQtRH61wv?=
 =?us-ascii?Q?1p30xJQjoZWptuHUvL8n28QjO/sWePuiLEhaKAVjUJ7Zx2A5l6xxKpRlKIM1?=
 =?us-ascii?Q?Sv58sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a4aa39-8f3f-4180-9663-08d9e1e80b0e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 22:54:58.5365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYUeainyiMCxX7GIdyZlIqlv6Ehnu3h0yVsfeh8c4c2j44OOpZXI+mC1MFZQucF0pZdYgv0dnxKdIul8VuiCwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1754
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10240 signatures=669575
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270128
X-Proofpoint-GUID: U5MIZd1XaSYpNRihWOKzsPjohT6W_Iuf
X-Proofpoint-ORIG-GUID: U5MIZd1XaSYpNRihWOKzsPjohT6W_Iuf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022, Andrii Nakryiko wrote:

> On Mon, Jan 24, 2022 at 6:14 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > I think for users it'd be good to clarify what the overheads are. If I
> > want to see malloc()s in a particular process, say I specify the libc
> > path along with the process ID I'm interested in.  This adds the
> > breakpoint to libc and will - as far as I understand it - trigger
> > breakpoints system-wide which are then filtered out by uprobe perf handling
> > for the specific process specified.  That's pretty expensive
> > performance-wise, so we should probably try and give users options to
> > limit the cost in cases where they don't want to incur system-wide
> > overheads. I've been investigating adding support for instrumenting shared
> > library calls _within_ programs by placing the breakpoint on the procedure
> > linking table call associated with the function.  As this is local to the
> 
> You mean to patch PLT stubs ([0])?

Yep, the .plt table, as shown by "objdump -D -j .plt <program>"

Disassembly of section .plt:

000000000040d020 <.plt>:
  40d020:	ff 35 e2 5f 4b 00    	pushq  0x4b5fe2(%rip)        # 
8c3008 <
_GLOBAL_OFFSET_TABLE_+0x8>
  40d026:	ff 25 e4 5f 4b 00    	jmpq   *0x4b5fe4(%rip)        # 
8c3010 
<_GLOBAL_OFFSET_TABLE_+0x10>
  40d02c:	0f 1f 40 00          	nopl   0x0(%rax)

000000000040d030 <inet_ntop@plt>:
  40d030:	ff 25 e2 5f 4b 00    	jmpq   *0x4b5fe2(%rip)        # 
8c3018 
<inet_ntop@GLIBC_2.2.5>
  40d036:	68 00 00 00 00       	pushq  $0x0
  40d03b:	e9 e0 ff ff ff       	jmpq   40d020 <.plt>

In the case of inet_ntop() the address would be 40d030 - which we
then do the relative address calcuation on, giving the address to
be uprobe'd as 0xd030.

> One concern with that is (besides
> making sure that pt_regs still have exactly the same semantics and
> stuff) that uprobes are much faster when patching nop instructions (if
> the library was compiled with nop "preambles". Do you know if @plt
> entries can be compiled with nops as well?

I haven't found any way to do that unfortunately.

> The difference in
> performance is more than 2x from my non-scientific testing recently.
> So it can be a pretty big difference.
> 

Interesting! There may be a cleaner way to achieve the goal of
tracing shared library calls in the local binary, but I'm not seeing
an alternate approach yet unfortunately.  To me the key thing is
to ensure we have an alternative to globally tracing in libc. I'll send 
out the v2 addressing the things you found in the RFC shortly (and that 
uses the .plt instrumentation approach). Thanks!

Alan 

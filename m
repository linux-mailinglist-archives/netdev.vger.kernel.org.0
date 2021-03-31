Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CBF34F827
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 06:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhCaE4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 00:56:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64302 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233601AbhCaEzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 00:55:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12V4qaDI026214;
        Tue, 30 Mar 2021 21:55:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/2tCJdXv65c0UPbJGV9JTwwP31Hd740w+YvTbadv8z8=;
 b=RYTHBHVG1D1V47ZkLojCy7mv1atDqlEIWI4EVGBeCPYKl0Pg8V866kIkHHKDxzE0KkYw
 c/oZyRxeKt01otDVGBgKZb6AX4mXzWAvjLN0DbfzqqsD3tenW+ler/rB6zTW15SGAJcb
 JAh6WxdV7n+CRECFuAgAXi75Ka5ckhiRz8k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37mabmj45n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Mar 2021 21:55:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 21:55:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/SvGAVrMdhOuebZ6IEkpW+guFujHjXmvZJ6Kx5kjY2VkJ75SxFfLuQQQHk4m0e2gEqwiBh/CgXGCZX4qS7Q4OvCEYgYz8VldnY8xio1zPZcJbiFbMoa+lf6HAgqPiZeMo9fqaQ3fBxoPcepMkGuqGwS0OcBNEUv+tXP2SrWCSQ0wevD9akRlZx/fTcUz1jyAM3LAnLQ/WpC7Sa2mhSXPuM2XYlSSnMyufGWv63UxfhyZLuXSAy8mPsewHyDZcoTbEBlcqKS8wnBCctBWYsEItks7oIoZPJ4UNOmPLtqfaoxESJz6XcT+zA4LMa5eckcZIHRw6RQ3N++VISNoz0ZDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3rN8q/unHDmtbsEqF4NgXPuMI2wr3G19Nup8MUOeOI=;
 b=bhgoeZNm+wP2DginAY2QcTEArKMRKDtTlWg6WsklJVmYTwU1Yl9eeDPaYG6vquZnNNEhrAH3GEfZUJdAiHmq5UTBGA6AdiaT5T+idpY9UswU6R3Ju7d/g7XDcPWjbC9S/RwdNOGtQoHXBf1nlrO6R99hpFPLrs7JTwOQAKuaUngZabubSVbHC/FNsLY+uMBYcxOp86znA3+fURpacY8gS5PtBH39uMeuPkmH8NfIxkvjKsTeReJmo+0Dwm132VXjz0/p/IxddJ35L3Dph7m1DSUH7+Y/ESEZ4auyvI3xIiK2/jTTVZJNmQ7ROxnZ0y772xwRDWle6wt9wR9BJmcpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB4296.namprd15.prod.outlook.com (2603:10b6:610:10::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 31 Mar
 2021 04:55:27 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::fd38:6d99:bf87:c3e4]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::fd38:6d99:bf87:c3e4%3]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 04:55:27 +0000
Date:   Tue, 30 Mar 2021 21:55:22 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     "Jiang Wang ." <jiang.wang@bytedance.com>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [External] Re: [PATCH v2 bpf-next 00/14] bpf: Support calling
 kernel function
Message-ID: <20210331045522.5gigzyheib5zk2r2@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
 <CAADnVQ+H1bHMeUtxNbes_-fUQTBP5Pdaqq7F5aVfW5QY+gi1bw@mail.gmail.com>
 <CAM_iQpXKQ6WDgoExX=9D2gXcuYtUD4xLsPOSKX=BnQ-0KpBZpg@mail.gmail.com>
 <20210330214301.ssskul54hyh67o77@kafai-mbp.dhcp.thefacebook.com>
 <CAP_N_Z_+agZz4oBaGvOQY0AKxaZB=oqpU7WMEugAEftOkx45eA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAP_N_Z_+agZz4oBaGvOQY0AKxaZB=oqpU7WMEugAEftOkx45eA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1041]
X-ClientProxiedBy: MWHPR2001CA0019.namprd20.prod.outlook.com
 (2603:10b6:301:15::29) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1041) by MWHPR2001CA0019.namprd20.prod.outlook.com (2603:10b6:301:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Wed, 31 Mar 2021 04:55:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8b077f5-4c59-4b0a-aa4a-08d8f40133af
X-MS-TrafficTypeDiagnostic: CH2PR15MB4296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB42963B1043E605C5DFB84615D57C9@CH2PR15MB4296.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eo+VhaSUo7O6vx6t5y5xZmwCS/EGV0DFinpF5m6R1SBI61CJOvl34K3Y6nhNDFVC+Y2x7690ArmpBYoX8EnNwYIqDMs29UJ60ndhjnj0AmN4gljLTcBP4jIbmO6QeRmD1Cqns7hqzEjJGCev3ZN86I/nq5EnoO2svGS0bYluzUZlUyu/BnPGcnG9F3/G+pgO/VK8XXr683rzEONbvwgnlWYfFU8UBdLpOnvddCx+e3jhTRTamXtIxAg/uXyYKc6zvUPRohIC8497N3eoJp3RRc7OM2ZA7MuPULDh/w4oBonCXZG0BlUijoUuV1fZ9nJKdjroefx8Qgw5aNk+3S4p9GlAm+iUjyGig4njT+qO3u9nlc5XrbLU1AOxQobYmyrAxbenkEMzp7cz8+RydGDd9E/tgA5aod2LkL6XP4B13vNTduZoCVbc17+R7J/j+QzMbVWNb+Qs8fhcdl8B/s1sQelB208PSKK0quPW1tU6BwDw8lxbijqQmmEnEQ4UttNdVH1SZb8yvt5+eiZN64AEY6k+tIZN46+zG6CPIkth8c7yzrQyFjt8TTRnECuQLp+J5+t8957DIyNv+CvsK4zF/2bEthJ/dDemcQ61mxgWj+WoYncSMJl0CYOJzj3AUyL0XOCRhkFj7QmkXZQvcIWFg8uhjVIG3rw7dp5zJFL14ShPJef7HBaMOrOuwsGF5Fn2arbrZ/cBAo6SFzYaRIUDge5mUux3tclyhh6a8SEQiaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(366004)(39860400002)(6506007)(83380400001)(52116002)(1076003)(7696005)(4326008)(55016002)(86362001)(5660300002)(966005)(53546011)(9686003)(54906003)(6666004)(6916009)(66476007)(16526019)(8936002)(66946007)(478600001)(2906002)(66556008)(186003)(38100700001)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K7zF4SXuUmKR9CooOKzygD+0gcSJvyEp9sErS8xarMMosa9RrE1i+uZKXBQn?=
 =?us-ascii?Q?IkhLwEjVgtHyH3voEkCbeYI0NLhoRy8whri6dYl1x0ZBIXTUQvMMZ0RjWgfO?=
 =?us-ascii?Q?I7ob5vdXXPimTjx+ARBfuh51/Ia9GOUi6O+PTZQyz5+okEcXfXgoFTkwAsKQ?=
 =?us-ascii?Q?nyxP0KRo2gNyd6dqE9oQtUcpJqbRgBbSgEXMYu5yMo0fO4NxmtQ3PBknTE6Y?=
 =?us-ascii?Q?rsKuioHAQkLiEvb6U3KMfjdyDGgEkWuryhR9LmF6U5qttWO2/EgDBTS7kcMl?=
 =?us-ascii?Q?RrhvjJ3C030+9px/diMEJqo83fru0tZUMTPBiUUpEfUuFgiGPRmSHF8s2b//?=
 =?us-ascii?Q?ePxOArQB5CJSXcMxM7zuvElxcryI4M0yo/ZvfPBR0OI+GLWozNE6LKqj+VrI?=
 =?us-ascii?Q?COXPV+6oZhKV0r5uP4jR93l1DgKcpyVMpfkbgig2XZrEcR/Yz6q9Uc29Xw36?=
 =?us-ascii?Q?PN3jHEcKCvz0q9pkjoXxwu+z9srC+aNy+JXsG/omOl03DOIJkDGeYWOSjvJM?=
 =?us-ascii?Q?IzdBfVNGlYdpUCoyM29Z9HQDenjbozUGEv6RiOB/ExAy8xsPzulAi75cUZEY?=
 =?us-ascii?Q?P+cu/Ps340+6ZffCVHsEIe6HE92ZQk66fapwSniPzurAK3XsaxUBuZZcAnSt?=
 =?us-ascii?Q?VZS/0Qmtei/A4avuT8BUpDs/ukAm8/yO5K5kn0Wz0c7oOZrYBDmpbXzixk8b?=
 =?us-ascii?Q?uigGbxCNrsRxkfnolJooEHhe7N5yW7ykn/lFUrxOJGaQZzj5tPjB9YGcID+o?=
 =?us-ascii?Q?wQvioA3rsmN80cQmRQtzW+lKPuVKw7dL2hpBwBHUeJmy4C0HXlnh8rOWaPCI?=
 =?us-ascii?Q?7NHsblLEASRYkZufkS9uw2l+hGeNmtKH4MO7qoVJlWkLbKJCgON8Dz6lJQnR?=
 =?us-ascii?Q?yQhO9XGJf/12gmFDKhYah/FKsnYEqRTF6gimme8uDIaoN6Bf6Bijzocm9YpZ?=
 =?us-ascii?Q?co5wVwb5O2CrtC7p+XMgxe8Gu/vB/SVHRpL0FYBQwEPZMgQU76oaf6QcBUVd?=
 =?us-ascii?Q?0fZ+gnER9R61PDkdY3SWU32rGFAX/u2ySlMubQ4+AxOoAelzQGjIIuBpxyGq?=
 =?us-ascii?Q?ndJZqxH6qWyeVdgqrGSj+bJD7XVQYDb/Riaega0GQJoFkjKVX064mCLLYKbV?=
 =?us-ascii?Q?p4dR+nv+lfIvidwVUXnpG1n/6fEEIV2typIS6s3STJBd0e/cg16puvLXvLGO?=
 =?us-ascii?Q?wgGN7CZ+z20ZF/SuC0djc6qn+eAAOpjhmKTMoiSvU2N8skaXWfP7dNfx/H6C?=
 =?us-ascii?Q?5XbXFevsW/+qk2h0Fuad3owDjVE8hjLEL0PPqm4GT9BOwIa/KD0JF5pyJprq?=
 =?us-ascii?Q?itia7xbG2cKPLRO+oNtcMP2Emr2EULvgYx/Ssul7nqLC1w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b077f5-4c59-4b0a-aa4a-08d8f40133af
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 04:55:27.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1yEkuTOAR8UDDWHspxGqDUrxepoBpKFinv/JXEw5d6HwpI/uNv4x+oUDeD/8ZIc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB4296
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PzIyDS4Mihk0e1II_Gx6tduGqtrGGqxH
X-Proofpoint-ORIG-GUID: PzIyDS4Mihk0e1II_Gx6tduGqtrGGqxH
X-Proofpoint-UnRewURL: 3 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_01:2021-03-30,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 08:28:34PM -0700, Jiang Wang . wrote:
> I am working with Cong to get Clang/LLVM-13 to test. But I am confused
> whether CLANG/LLVM-13 is released or not.
> 
> From https://apt.llvm.org/  , I saw llvm-13 was released in Feb, but it
> does not have the diff you mentioned.
I haven't used the Debian/Ubuntu nightly packages, so don't know.

> 
> From the following links, I am not sure if LLVM-13 was really released
> or still in the process.
> https://llvm.org/docs/ReleaseNotes.html#external-open-source-projects-using-llvm-13 
> https://github.com/llvm/llvm-project/releases
AFAIK, it is not released, so please directly clone from the llvm-project
as also suggested earlier by Pedro.

Please refer to the "how do I build LLVM" in Documentation/bpf/bpf_devel_QA.rst.

[ Please do not top post.  Reply inline instead.
  It will be difficult for others to follow. ]

> On Tue, Mar 30, 2021 at 2:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Mar 30, 2021 at 12:58:22PM -0700, Cong Wang wrote:
> > > On Tue, Mar 30, 2021 at 7:36 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Mar 30, 2021 at 2:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > >
> > > > > On Thu, 25 Mar 2021 at 01:52, Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > This series adds support to allow bpf program calling kernel function.
> > > > >
> > > > > I think there are more build problems with this. Has anyone hit this before?
> > > > >
> > > > > $ CLANG=clang-12 O=../kbuild/vm ./tools/testing/selftests/bpf/vmtest.sh -j 7
> > > > >
> > > > >   GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
> > > > > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > > > >   GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
> > > > > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > > > >   GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
> > > > >   GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
> > > > >   GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
> > > > > libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
> > > > > Error: failed to open BPF object file: No such file or directory
> > > >
> > > > The doc update is on its way:
> > > > https://patchwork.kernel.org/project/netdevbpf/patch/20210330054156.2933804-1-kafai@fb.com/
> > >
> > > We just updated our clang to 13, and I still get the same error above.
> > Please check if the llvm/clang has this diff
> > https://reviews.llvm.org/D93563 

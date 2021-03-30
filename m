Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FA34F3A6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhC3Vnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:43:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhC3VnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:43:22 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ULNfna024640;
        Tue, 30 Mar 2021 14:43:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uORNtjBdWthrGzJVq3UeIWgf6i69yyj+qTJwg+Wt8sM=;
 b=aWSaJRdRRYZM+uUuavbIPq5iRxLpTO/SAM/xN1gefQbg4H0Z9WACflMUvCA/Bm4x0HFR
 33GNUHX+N1Ip8KnX0ATijM31t+vunlDqoabLv49l7XqnU0LSLwMTtkqG7i/mvXruKqkg
 miV40Xfrj380jtOV3sfPUhjHtBShuFjrpR0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37mab68kcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Mar 2021 14:43:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 14:43:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0ww9siAnlpOUJLuDl8VzTHI0AFrLLj7utfkEzx79scYAoAvFqqXG41MB4YAWYvIZjVNLZAuMDNZ9Fjx0Z9oMzO/FpBEBpV6wj7o4n6dLapEOcnOJvdarvdWL2SKz2KLuvlwiTLF30JEupdnWpOa2pvzcM7fcgoTdzr1zxQ5pRh6HjbqQfxFLah6JWcL9XqU84wMjHLQfInteLfkwOLkXUZuYZPy7xAEm/QpwPHcDLYPmgfYx4e3UleLl2hxgn01u1V9o6FVmC8Q0zgCzrnlLDCUUcSlQU7Zbd5Xxm30UjBF04PQW9LDJndGQQ9J0Uw2yJnuSt8wFBQS1/+ernD6cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uORNtjBdWthrGzJVq3UeIWgf6i69yyj+qTJwg+Wt8sM=;
 b=Jp62nm/ux82F2hPR65ryq0nnh4K1Oa6B0B5XzuJNC6GS/On12n/BaE1Tn85WEbEAEsKcfH8/DSDIoVs95Cqy9RVV1ICziz+SwfGZkfqnqLjWtuvjf0dY1NMMx50WIMPSEuU0NoznXpuuFc9XDA08qQyQzD2U8evQUS3audnfqiqD1xicB6KGZa+B5WhhB1OMvX9NyIrV5aJ4nT0RwOnbbksjqoMTZXnWaT+cN3u6oCXTqj0qBM9M9/A14flp9kQWrn1472vlRLqO23QgWZNmZSnjKRYEWePiKPo6JwJHuL/adpNiokmU+dVEt7RVhj4KTFlmJPUhTVHjWN8U6GuK0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 21:43:04 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 21:43:04 +0000
Date:   Tue, 30 Mar 2021 14:43:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
Message-ID: <20210330214301.ssskul54hyh67o77@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <CACAyw9-N6FO67JVJsO=XTohf=4-uMwsSi+Ym2Nxj0+GpofJJHQ@mail.gmail.com>
 <CAADnVQ+H1bHMeUtxNbes_-fUQTBP5Pdaqq7F5aVfW5QY+gi1bw@mail.gmail.com>
 <CAM_iQpXKQ6WDgoExX=9D2gXcuYtUD4xLsPOSKX=BnQ-0KpBZpg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM_iQpXKQ6WDgoExX=9D2gXcuYtUD4xLsPOSKX=BnQ-0KpBZpg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:ad83]
X-ClientProxiedBy: MW4PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:303:85::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ad83) by MW4PR04CA0160.namprd04.prod.outlook.com (2603:10b6:303:85::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 21:43:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4b69dce-290b-4dd3-730e-08d8f3c4cc8d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3666FB8CCB5640684B66947ED57D9@BY5PR15MB3666.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KMQ5gHI5HF0PljtqUfIhnn94/2n0d180RTpV+tQNKXrR0gBgZBLwCkj6ElX4GEZL/tAAZ6MnSvAUam3eqm6QnjnqFubftQXiVBjxLPhyhgxbidg60m9gvjZFSKeSwGSIiP95IDCALp+lWs9cChsZqlXH1XB/kzFNC32nfSABNT4K0fIKJe1Hd71x5yzgiI9/SmLr4c1s1vjtJNulwGhyLmdxKQSD/ZCBGNXtyGUq8TdDEamCEwLrbWgdJLj1QcZOuRipLk4+0lgt5J1Ma4f7dq0l/4HhzrfTvOf49JT4Kkfk21/lYwkl70me7PQvHWY5/OXMia1d/WvAwuzlbT/b+Z6X7qQzI48ySKCUZWaR3caN8PxzdsROTaqCyVbNwEpCiVVorvRQVTCSG0YhJFUhiWT59i+4vzABl+3wmevmouKybPR+jiviTx7k246YRbPJrykduy0aocuMAZfb1ktsP9LK7EkaJhpM8xjDUIpwJJYVmuaIcPnGyqRSA9HUT/4IbTFY3iqkt29FOSYIlES6K8cKiUJlEVmF9Hy7mdADHJEy+d9Xttv1qyz2DZ9TDUiO+oeU+qz7DAnnJUxPDvZTjsvOnMtRzq2fPlagbFLXHE5LcUFvw3o3LGVZSBAU4tiyohVTwco4iKSbk0bSs+KGkp58XsNZLfxLyYTsN3KkY0MgDQ+o8kGt2+BkTCLNKyLwCFtCty0HCN6TEM/LMua9iom7JEfWsHwXl21qlcFHWFs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(136003)(396003)(346002)(54906003)(86362001)(52116002)(7696005)(5660300002)(66556008)(316002)(9686003)(8936002)(38100700001)(83380400001)(4326008)(6506007)(2906002)(55016002)(16526019)(966005)(66946007)(478600001)(6916009)(186003)(53546011)(1076003)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lgLWwL26YNvkRW8Qj02viBS4WQ1e7l9s28geY1/xzn93T/j9TQ+/a8cSMGta?=
 =?us-ascii?Q?9tOiynzqk2KBC0AkuVD1HoHLhmoLfvDGX81hofGBsNVvQyt6hkGNgy7BKH1z?=
 =?us-ascii?Q?oMUn98248EiuuYMvHt7ROzRuwOZgnBWVT37XVxtTQpMmEm+MsYdXjMLx/5fO?=
 =?us-ascii?Q?gzer6jHkAROLoWqDLkn+VQM9IX/eMY05ofrq96MUahV59DsONk8VFCcTNouw?=
 =?us-ascii?Q?5z3YnhFD+aq+SXRL0F2nQQRV6Eoc1UYUOmsrdPtfzUcb2hJZyDS7f56dBYMK?=
 =?us-ascii?Q?kP4/NGQvCeNzhkcUH+HiO9LpfGV8xOnsn3ZXAqa/Lq+atMjTDbrY6vbODBYo?=
 =?us-ascii?Q?fWhOq741WHUaIYIGFdBYgmaL36Sc0kPFYOODbQTuzuTNqoH1wmqg6I1HcQQf?=
 =?us-ascii?Q?r2Eci2ORMK3/qw44K9HeeAz/ge+tzBk/lGogVCuGd585K3aQjc+m+4ty0Kny?=
 =?us-ascii?Q?uK/GJtbE6MMsgG2NrD5Wvdmveg2X207HX+YXUJB3I0BGq9QKFJvhqc9fKoZa?=
 =?us-ascii?Q?JTXpyv02/h77Xnua2EujA7YHWByXwGTa7gt0jSaf7qd/RoIgAj//hvPSb2Nt?=
 =?us-ascii?Q?KW9abXtFI6YqD/N4u/+x1yOYw8yALNJ6dPcRlUNazksysz1Oh8w2aRDkDsRj?=
 =?us-ascii?Q?b/TjfAqGUKgdzBMgvtfnGCju/+jR8n+N1WJ5OXRgTrwJ9NyXkHU/gmU9UfEC?=
 =?us-ascii?Q?CGucjvpbj4QZ34ynJ+PCnrZDbx5hR0BitWjGlnh4Qz7sXK6j4jFk5M5SFc1n?=
 =?us-ascii?Q?HwWt+cJKlUUi0JyxBaeVAFIbVIpx9sderZtCtXflGIrJEw1up05hfpX3jC/1?=
 =?us-ascii?Q?6F3gcjGrvYpbC70ftQ0UqCBMGwLElnrcSOEfseYLfzOneB9klKxP9zGOx0Wg?=
 =?us-ascii?Q?OnbxHE6KKO+9gdVGj4CaJ9AztbzuwTBGYlrr+omSBf/acI+ftot8WWe1JsH7?=
 =?us-ascii?Q?H9ANQD8eYWyvb8YIN8PFGomGewOIbtEe9Fu+dNscsWNlN8eIC32qWYnPokZg?=
 =?us-ascii?Q?0e44cC5v1WEGAiNAJtGuNhL8rNIOY67psbEhAjH6zMc9FFPVUzCY388bGW6Q?=
 =?us-ascii?Q?aPiO2zp8ZHYBs5NxtpkaBVaLMoLAV3LMY5p+kkdErCp8vPQmftrRKrYjMeOu?=
 =?us-ascii?Q?pRAzxlW2rpaYNrGKI1iuzTueZ530FzaUsLw4+IlY9jipbWY6F3A+35/iLdYU?=
 =?us-ascii?Q?fYLVtMFKFCH6RE+yeMJSAAD6ovWedwS5vby7OMpiAriXimAd2Amg+e/cTMFB?=
 =?us-ascii?Q?5PqSwWJyoUN44038XvTUH3Exs3wrvKXzyYlgWN7VmK9wtghM7w5WbTISow9S?=
 =?us-ascii?Q?4ZsQnjNaM5rte9Vum1l2cRwwcHQou/Os7/BhvCpcUWrjAQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b69dce-290b-4dd3-730e-08d8f3c4cc8d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 21:43:04.7194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwgB3G0cBhZx9nn4+5EVM4BFljB7MtlDLsx8ebz4/UwuHiEILtZKoVXWba+NYD3s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: bd9733IyroJTf6Fwwk5byL0G71CKo-ii
X-Proofpoint-GUID: bd9733IyroJTf6Fwwk5byL0G71CKo-ii
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_12:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103300000 definitions=main-2103300156
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 12:58:22PM -0700, Cong Wang wrote:
> On Tue, Mar 30, 2021 at 7:36 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Mar 30, 2021 at 2:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Thu, 25 Mar 2021 at 01:52, Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > This series adds support to allow bpf program calling kernel function.
> > >
> > > I think there are more build problems with this. Has anyone hit this before?
> > >
> > > $ CLANG=clang-12 O=../kbuild/vm ./tools/testing/selftests/bpf/vmtest.sh -j 7
> > >
> > >   GEN-SKEL [test_progs-no_alu32] bind6_prog.skel.h
> > > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > >   GEN-SKEL [test_progs-no_alu32] bind_perm.skel.h
> > > libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > >   GEN-SKEL [test_progs-no_alu32] bpf_cubic.skel.h
> > >   GEN-SKEL [test_progs-no_alu32] bpf_dctcp.skel.h
> > >   GEN-SKEL [test_progs-no_alu32] bpf_flow.skel.h
> > > libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
> > > Error: failed to open BPF object file: No such file or directory
> >
> > The doc update is on its way:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210330054156.2933804-1-kafai@fb.com/
> 
> We just updated our clang to 13, and I still get the same error above.
Please check if the llvm/clang has this diff
https://reviews.llvm.org/D93563

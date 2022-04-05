Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18EE4F3C35
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiDEMGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbiDEKyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 06:54:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B4AA03B;
        Tue,  5 Apr 2022 03:28:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2359olWL000849;
        Tue, 5 Apr 2022 10:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=deQDVArEahFNwkCI0oaQdFp8yjOmj2TfsvnRZkT+Wl0=;
 b=VyCXGjXf6FiEzAc+C+1kxEvXGlk0UJU0Bq1xaX0lzBD0MaKbOF+dsWeRG54lX2ZkUvA9
 DitgaPYtHLFYf5GnWh2GMalOKD8FM8WNkJb9mI3FuCZtKz18tMmnWyP7aeMb7ZVBErEv
 GCtjp5KjxK28pfDAGpLNkUeni9xzm6mVgOgCKiUGHtuWdgD+cIH9JU+phv1oUZaLNZiw
 XrpQ68KBCvflvRiz9jcqy+iUc8wMAoR8/TD3MFr3KIC6vnX9bc6bgCgw4RZ0iiOtPngV
 r/Qac2p8bds07+ngQhcStKpd78ulb8/YXfaOYCyZNnQ2OfxlerXpopp8YEf/ygCfxEu6 ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3snmbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 10:27:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235ABbCa020067;
        Tue, 5 Apr 2022 10:27:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx3k9ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 10:27:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fl41v9rDuA2cxnZMSdfnije7WZI6hnNB7nNP+MforTMz0ZiQXKwNCCHLV368tHup9JNX93a8exDa+VsWYKaH4vri8+JPvtTaz5ppRlooU+yPPaVV0eepoKBtCvMD7+3I/4i12K/3PTYcYR87k3FEhy5zdI44iYb0Ta0A5SLG+Cjr+Fr/wfveHpqhmCAtgXReGS9XcFq8xthlNllB59Wn1PB2OEUhuxBNhfCs0M5Qg1a80OFSOz5ibz4gMTWKWaciQfi5+cehpPOqW55ZLo2iSoLuA6lXUrlzBtsuKtcTX27wTmJhYFyej1h7hmmCZNRCqsTAvt440U4e5bztH/0J6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deQDVArEahFNwkCI0oaQdFp8yjOmj2TfsvnRZkT+Wl0=;
 b=giE3TdyQLYZa+ee7Z0quN1+S3eT8EREowuiD+tgvpPKPwOpKi2yaB5bX8KeK2w8fEXE9AvfRfzBAfixDjVEF5Dn09/tGVxTRAyjMpknmmHDwXyLcKjAXem9xnsde1y+MtZ5GW2GFQ6oUsUlN2ARwCO35dEZbqu9SX6+6w1ZOwRHeLblOWjk7NUv3WCwoizRm+DcZCJH7j+nnAwrm/OM/OjVgK0+ISDRS9VwXdsfXxwz340N4CcnzekI/wIIPCWeNbx1qWnGWDW4YILnzSO8p9oQwDtlqaZyy1u4vwDM6SYhvTE1cmwD42M8YYRb1j7xON5I6b59c+1Cztp1nnKGkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deQDVArEahFNwkCI0oaQdFp8yjOmj2TfsvnRZkT+Wl0=;
 b=DqzzkK5Y1Dgac2+A1MyQEbpthWY8dgAEehdZK3vCnPI3hm6FOO8U3vnrlu5uvxmyj9mSEUoFy9N3bATRuGYDcFUMEMNuXpv7C/9syzXBQ0tI2cm67/YiA7yEKRgGJS1QaRSBM/dc9gQa7TerdG1vfnAmJBvMKzbir1qxrFwixgo=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SN4PR10MB5543.namprd10.prod.outlook.com (2603:10b6:806:1ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 10:27:56 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 10:27:56 +0000
Date:   Tue, 5 Apr 2022 11:27:40 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 0/5] libbpf: name-based u[ret]probe attach
In-Reply-To: <CAEf4BzZdV60ZeNt1YfS8qoB69pggSe+=gjnDZ1tZy00L4Quazw@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2204051116110.9651@MyRouter>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com> <CAEf4BzZdV60ZeNt1YfS8qoB69pggSe+=gjnDZ1tZy00L4Quazw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 245672bb-f196-4a6a-fa95-08da16eef2d7
X-MS-TrafficTypeDiagnostic: SN4PR10MB5543:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB5543DA32A86739AE209DF177EFE49@SN4PR10MB5543.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: me1QBcVkZsFA/YlWuy5pa9Z7X+xvzZx16LyZiHCtBPk9yNi/lapVu1uVEG1LONrvD7jC1JTm3AIeOyPFYk8dMMZAjETpHjcCHUN6uS/VS1MXZuPhtZxJ+yx60RvZTkHGwc+GGWo8Rf4y1LikK9zSzjTf7I3nkb3i08PhH2ho7oXD99r6ULohKIQmyl6xrv+9nq/yNLgdseA6GwQOppLe+KX7Q0RsbpY9FVvm/TzbwON7DM+4cmhAZ/BIq2jpF7rbhoTw9pIZEtg23zDp0Lc9j06ap7PrxwPNPXefgBEQ4kdWXr1S0U2mO9gLUYdLRLIC8ha5rFKpSmCEWqnwTuJtqwg3i0tLSGwXLhNlDXpnOCQXtb91ue82O6NSV2eWA6SVSwxV+AFPUGo9YLsUYxhJHBTVWhkKo7fb4PhgJhjtTa5XQaI8KbC02cdFxc0f0AAEaUxkc4SWBKWhYnuhi4vPJFT9jxUgCu05ITemwVHa/PcHA3wQeAIee4dUqd4sIkwBIF8+N7tgYaHx2lfQg/7xdfNI8lNyVoawkS8+6O3iFYcEl+AzLnaw/dybIXNEkgDTzDi3zhUPNDCW0yC7h7OVBQKmZW9Jy7jvnjeeuivgJKp4TMMwAq7k78iArowm73JN8jqvmQKZKRV0ok1exY9qlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(66476007)(66556008)(66946007)(186003)(5660300002)(86362001)(38100700002)(7416002)(4326008)(8676002)(44832011)(83380400001)(9686003)(52116002)(6916009)(54906003)(8936002)(508600001)(2906002)(6486002)(6512007)(6666004)(316002)(53546011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zQbG6o49C/i8uh/nVNDcv08zbpBypTDGJWsS2i23k3ncxHM2kexglDU5PMZF?=
 =?us-ascii?Q?RwPWl2N3RLWYTdTlZ+3QHtTWeQOx2FBDzdXA0WNox/V7HwXxNr1TKK93yX+v?=
 =?us-ascii?Q?oLgbmfY4E84DKwmwKMs+0ICSfSfdCWVMR/S8ij+B9SWzSXFiXT3CXdFzCbv6?=
 =?us-ascii?Q?9hWPGtLNOVq6UfW+lF1eh1e8R1RdfhPIUx3TFWQGDw9lI4T+VDo6r+4oNYzj?=
 =?us-ascii?Q?vXHQ+wmrXX0Vn02Uqd6jD+bGXE7N7Ov8lXg+nSnRcfAv6p+qo/7ryoB8iiEm?=
 =?us-ascii?Q?RRgL6k/zFZD7km29yybXrYz6HG0M0YnNAVcTNjPWot6Pb+fncBGclrdMtuEl?=
 =?us-ascii?Q?zys8ZT6/0UciR94CSHu4iF0PJ5EOlUmA4VPW+4CyIwlW7l9GwSfG0j04BUXC?=
 =?us-ascii?Q?JLqEVgZ+zVIHPSSyCbVLXWswO5dmvTBFzn///lp8nNbH+6ibXp18kGoQc5e7?=
 =?us-ascii?Q?yOPf6H07a/9XfUcneGvxKR9hRI7PGcE6ckilxq7zTyl9Nsnuf9HvbvXA/V8G?=
 =?us-ascii?Q?FRUNUUlSg11Cvt4N3g0Me+gn6mXgHK5QpV68XBAumiEJOLvWNkEcj3/ZPxGN?=
 =?us-ascii?Q?O6OrBmNf2s7QOGqvS2GNjMYAKd7F0jGbJqpC/JVijFEpvlhV4cuJDgFF/CvK?=
 =?us-ascii?Q?MZAgIAFmibsTpDHEEt4MtkFgXZRZ2gcmoXELfhzh920p+vDMnR4FlH9lG4Qa?=
 =?us-ascii?Q?FQzRuqZgqxCEAUhb/qE1jdcVCfuxMVjL6PJYw9lCrUlbJcldpCts7Nh+2Jmf?=
 =?us-ascii?Q?F1jW4N6YU919xn5/iC2txWLIfG66iirB0Hz2AuR8uCyqMJnz4HueRuYV+LHa?=
 =?us-ascii?Q?PDWqJ3cLjKtBP9+kr3GCz6KK7ogWa+ZEJZfN1KfESnusEtW+kyMjygNPsTic?=
 =?us-ascii?Q?s9vCpNcKBwhWzgvWFlhgX+13pCPYzysr6ZAA9Z+laOURrWZVRyFMxC5M3lYu?=
 =?us-ascii?Q?KhPCP5KHP4Q+bDZ+yWOJQhFbvR4gNr1QCDpVvYmsBPlUnuqnjSb9/FM2X+3H?=
 =?us-ascii?Q?ZYVA5FnZm6+tqIoCJh6BhEWztooT3CCm+JOJco0/efl0yr9qF+G8jXVb/cNp?=
 =?us-ascii?Q?0R9AmXgN355SHCiKhr6Vcud65cIP9V/Ma0n3keN6xo8sQ5yhmXO5YhjQOv7k?=
 =?us-ascii?Q?c6hCcKjemFkJLgkFjfp/jVXdakFZmIhEE8jqaPp/yYsnCdUQ9Vj6aqq6a85D?=
 =?us-ascii?Q?jYaxaj5jzGPsc2+gV/hpszrO/2WBgSAiwdJaGbqvqpObo6XbDkAq9KL5mqcz?=
 =?us-ascii?Q?Z1Xj9HlltMQf7SKHeyHXAWb4100usCampzCxdE8oOML5gXbNjCrKpT4PW5Ys?=
 =?us-ascii?Q?lyxysNkctYVS9APEVqEfYBIqWjj2osDvT2iN/+XOS1Mpj7NuV9MDsf76BT5O?=
 =?us-ascii?Q?/P7qhTZuwz9+vUpvuJX0NN0FFYhXneAQ3OYpd7p+bCs87/XuEll8doB5nZyB?=
 =?us-ascii?Q?Yn3Xq3f9LgR280hDcI5HcIykSzK7weGaXzU+ZKUiuts6ZH4+6+rQ7G7OYXMk?=
 =?us-ascii?Q?+rGJFQLnEFyNDm4KNRzpE5cQEd/2FnrJVX0Qj5cBefUASbKndwpgXh92Bhn2?=
 =?us-ascii?Q?p7vKu4VLxO0t6gk0KD9KaFTdQSW77aSLiTyiuMNKu0+KCwdTggk6yAwBGWNl?=
 =?us-ascii?Q?U3kWN/JROg0mzikQU9HvKyCgzhtxvlRYW5cdEMFw6RbfjJApZ+kmHqvdCm3m?=
 =?us-ascii?Q?u0FrTJ7mWwWIKYvJnf/imcfI1AJupaaJUR4wFETvF38Q96CLgTNAqGDj0a5t?=
 =?us-ascii?Q?WBJA9vOurUVcMGpVozw8m5dG06uSQOfM+EF8tFq2xR3A4csxgoA9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 245672bb-f196-4a6a-fa95-08da16eef2d7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 10:27:56.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TzTVr40oYPzOoh4xA8USUENsH4KfM1x45Xd+dNEr2sL4MlLQbERsUjXIawVASPMfX9DjQD6hdFfBDPvQ/p6Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5543
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_01:2022-04-04,2022-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050061
X-Proofpoint-ORIG-GUID: tYg-sQ9sBmCM7PWcTvVabIAW1vIzsrVg
X-Proofpoint-GUID: tYg-sQ9sBmCM7PWcTvVabIAW1vIzsrVg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Apr 2022, Andrii Nakryiko wrote:

> On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > This patch series focuses on supporting name-based attach - similar
> > to that supported for kprobes - for uprobe BPF programs.
> >
> > Currently attach for such probes is done by determining the offset
> > manually, so the aim is to try and mimic the simplicity of kprobe
> > attach, making use of uprobe opts to specify a name string.
> > Patch 1 supports expansion of the binary_path argument used for
> > bpf_program__attach_uprobe_opts(), allowing it to determine paths
> > for programs and shared objects automatically, allowing for
> > specification of "libc.so.6" rather than the full path
> > "/usr/lib64/libc.so.6".
> >
> > Patch 2 adds the "func_name" option to allow uprobe attach by
> > name; the mechanics are described there.
> >
> > Having name-based support allows us to support auto-attach for
> > uprobes; patch 3 adds auto-attach support while attempting
> > to handle backwards-compatibility issues that arise.  The format
> > supported is
> >
> > u[ret]probe/binary_path:[raw_offset|function[+offset]]
> >
> > For example, to attach to libc malloc:
> >
> > SEC("uprobe//usr/lib64/libc.so.6:malloc")
> >
> > ..or, making use of the path computation mechanisms introduced in patch 1
> >
> > SEC("uprobe/libc.so.6:malloc")
> >
> > Finally patch 4 add tests to the attach_probe selftests covering
> > attach by name, with patch 5 covering skeleton auto-attach.
> >
> > Changes since v4 [1]:
> > - replaced strtok_r() usage with copying segments from static char *; avoids
> >   unneeded string allocation (Andrii, patch 1)
> > - switched to using access() instead of stat() when checking path-resolved
> >   binary (Andrii, patch 1)
> > - removed computation of .plt offset for instrumenting shared library calls
> >   within binaries.  Firstly it proved too brittle, and secondly it was somewhat
> >   unintuitive in that this form of instrumentation did not support function+offset
> >   as the "local function in binary" and "shared library function in shared library"
> >   cases did.  We can still instrument library calls, just need to do it in the
> >   library .so (patch 2)
> 
> ah, that's too bad, it seemed like a nice and clever idea. What was
> brittle? Curious to learn for the future.
> 

On Ubuntu, Daniel reported selftest failures which corresponded to the 
cases where we attached to a library function in a non-library - i.e. used 
the .plt computations.  I reproduced this failure myself, and it seemed
that although we were correctly computing the size of the .plt initial
code - 16 bytes - and each .plt entry - again 16 bytes - finding the 
.rela.plt entry and using its index as the basis for figuring out which
.plt entry to instrument wasn't working. 
 
Specifically, the .rela.plt entry for "free" was 146, but the actual .plt 
location of free was the 372 entry in the .plt table.  I'm not clear on 
why, but the the correspondence betweeen .rela.plt and .plt order 
isn't present on Ubuntu.  

> The fact that function+offset isn't supported int this "mode" 
seems
> totally fine to me, we can provide a nice descriptive error in this
> case anyways.
> 

I'll try and figure out exactly what's going on above; would be nice if we 
can still add this in the future.

> Anyways, all the added functionality makes sense and we can further
> improve on it if necessary and possible. I've found a few small issues
> with your patches and fixed some of them while applying, please do a
> follow up for the rest.

Yep, will do, thanks for the fix-ups! Ilya has fixed a few of the issues 
too, so I'll have some follow-ups for the rest shortly. I'll take a look
at adding aarch64 to libbpf CI too, that would be great.

> Thanks, great work and great addition to
> libbpf!
> 

Thanks again!

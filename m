Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3F5184D2C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgCMRCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:02:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44476 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbgCMRCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:02:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DGhs1t030966;
        Fri, 13 Mar 2020 10:02:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WPqF5g9L8BlWqg1YTJ4847230XIXZ1hiTmUkHJFbWhY=;
 b=Fy6iK8uSBwXan498ZuVVJ8slWNvOfgWFrGozaeOMQ5zToWONulAVSH4hbl54srIWMCEs
 HIYDJbjjSEyd72lXmvLsgyNxusOqo+Fcu8hyR61X+zEoz9r26RJ+m3Ohk5CEVGaAhrNy
 KrDlqk2GuqGdg+I9u4gh7nr853wCaO3H+ig= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt96w3c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 10:02:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:02:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2VMLIFLlUlLP7YUUSx+89Mb88Lgm/AO9qiAdpv8s6gxvbcgrFkXI1hfHIrmGhL/spKskI3RLb1iUHvy7FShpdyMmLU/oXsYJE0F+9PUlqi2l6JG9OExWg4Dale9MOxQsjECjbHfIoh89UBKyojFXpO+WfAkH3rXtECpbTSXCGG7rAJ/BiZtScCdE67TAxa1Afl3fzv/QOz2vNK8jZwLWHnA88DM8dt4dy1Ven18EhlUZI+POEwEF+X3EKbk2p24oJPZq3xk9W6xJrHL1puvjEmVIUII1jAakjaKeSPXXDK81ZZWzopaJwNvdN6HNCwtUDD3o8bzOnwXgLqTzgPqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPqF5g9L8BlWqg1YTJ4847230XIXZ1hiTmUkHJFbWhY=;
 b=nuvf9V26/zidigeSAEkppkiv3Tb0C9WulR/5pbOz8uM8caik/pGTmhSftrJ2itUbsiQcXBnUs2OvBOpsEWRhf2AIVNfc1AP5juImExlvRLUGUKzdISq5+i8IfSTwqLempl2146tcupfsRu/D0kXWCQJOvw4vMDYbmiGTCCczvhid/yicfqrJHjZa2yKTtla1lPJdhF+zC4yPEzzRr8aZL5LCuMQERK2lllD2bKTA9uDSxtMNbYg9fIbNJc3X9Tcaky4ziyuUNvHs45DolFCGFYKop5AWPBNafOTreXj+Z1Eudvky5x6UrNL7x/ca2mvBZ0Zp/0nPKkpCuZhbBOJAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPqF5g9L8BlWqg1YTJ4847230XIXZ1hiTmUkHJFbWhY=;
 b=hQnsO7gB+26j4xa46AssyXdMaA01Iamr1/lplpFd39RZHNK5Kwly+UxvI+K73PLMee2y3kc8PmYDV80r6fPBtPzyl5Iu2hd460UE0aEGF2Sxn6HGG98t7k7e0k4xDvjQu8t/PtewYqhobKy0tiFruSXpUsKQccBxgvMzt7/HaxY=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3158.namprd15.prod.outlook.com (2603:10b6:a03:104::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Fri, 13 Mar
 2020 17:02:16 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 17:02:16 +0000
Date:   Fri, 13 Mar 2020 10:02:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 4/4] selftests/bpf: add
 vmlinux.h selftest exercising tracing of syscalls
Message-ID: <20200313170212.lf4lnljwtvhypkew@kafai-mbp>
References: <20200313075442.4071486-1-andriin@fb.com>
 <20200313075442.4071486-5-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313075442.4071486-5-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR19CA0058.namprd19.prod.outlook.com
 (2603:10b6:300:94::20) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR19CA0058.namprd19.prod.outlook.com (2603:10b6:300:94::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Fri, 13 Mar 2020 17:02:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74887bcf-88a8-462c-5888-08d7c7704852
X-MS-TrafficTypeDiagnostic: BYAPR15MB3158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31588DB10D02078354F70B8FD5FA0@BYAPR15MB3158.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:159;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(6636002)(6862004)(52116002)(316002)(4326008)(6496006)(9686003)(66946007)(66556008)(66476007)(16526019)(186003)(33716001)(478600001)(8936002)(6666004)(2906002)(8676002)(86362001)(5660300002)(55016002)(81156014)(1076003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3158;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XXs3bjhOaV0dKeLZEeF5+XnoCkrxqquJLLgM4f+uqbgNKT0b/DCadCfiB4FjwWNNtDt5424MwyAyYNZuzPcCeJvcdTX33OcEqtrj185u/iCFn+UDaA6PWVcbLiiVxt0yvNas7j/TcW1Ebn6sWfWxFAODYLAsUVTPeaMiIae7mRI1G4m8EVXfNvbySI5xiwcSSqdiLR9etHxJoydpQS5DU2isitPZJ+YKpnf84toKsXvRLVO1ekTzr7BTwZKbtgIhXJv6LN3Bgvb/cY+vgGutfXjmIoU1u3fylV307l8HFR/U1C2LSi63u9KLMrP/htnByZvX54aOmqtPbKQHICodYkkqiW6SlH5g/W1M3Su6Djf0UZCD28kFqZnaLFmvUmKp0QHCYtAn3fs1C4Z/vxHkv96bPHoWuQ20gK4X94wfAaUJufMtSiLt0QVIMy7WZbm/
X-MS-Exchange-AntiSpam-MessageData: ATMaN9XrDPlFQ8mlNQOfXbO3AIcdQGGYpFH9wQVpVE9aJoJC6vB7J6Tak83epKP0ROC7G80dmBnuauaWRv3fZw0WmkYyaxyBNNzzDkP5XMbQRyIzUjTCQ7BcW3Gblp4mAKR6PayhhMjh++EPGZ5D2tieXc7TKjYsNNyi6LmsSTWbbvWkicm88N8Xf5wUtl4X
X-MS-Exchange-CrossTenant-Network-Message-Id: 74887bcf-88a8-462c-5888-08d7c7704852
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 17:02:16.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OX15guXb25CRrPEZlPJVR4nSqtHYOzSjqUZCy9UEKUC41X0BwvXoavniSBYUhVgR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3158
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130084
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 12:54:41AM -0700, Andrii Nakryiko wrote:
> Add vmlinux.h generation to selftest/bpf's Makefile. Use it from newly added
> test_vmlinux to trace nanosleep syscall using 5 different types of programs:
>   - tracepoint;
>   - raw tracepoint;
>   - raw tracepoint w/ direct memory reads (tp_btf);
>   - kprobe;
>   - fentry.
> 
> These programs are realistic variants of real-life tracing programs,
> excercising vmlinux.h's usage with tracing applications.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/vmlinux.c b/tools/testing/selftests/bpf/prog_tests/vmlinux.c
> new file mode 100644
> index 000000000000..04939eda1325
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/vmlinux.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +
> +#include <test_progs.h>
> +#include <time.h>
> +#include "test_vmlinux.skel.h"
> +
> +#define MY_TV_NSEC 1337
> +
> +static void nsleep()
> +{
> +	struct timespec ts = { .tv_nsec = MY_TV_NSEC };
> +
> +	(void)nanosleep(&ts, NULL);
> +}
> +
> +void test_vmlinux(void)
> +{
> +	int duration = 0, err;
> +	struct test_vmlinux* skel;
> +	struct test_vmlinux__bss *bss;
> +
> +	skel = test_vmlinux__open_and_load();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		return;
> +	bss = skel->bss;
> +
> +	err = test_vmlinux__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	/* trigger everything */
> +	nsleep();
> +
> +	CHECK(!bss->tp_called, "tp", "not called\n");
> +	CHECK(!bss->raw_tp_called, "raw_tp", "not called\n");
> +	CHECK(!bss->tp_btf_called, "tp_btf", "not called\n");
> +	CHECK(!bss->kprobe_called, "kprobe", "not called\n");
> +	CHECK(!bss->fentry_called, "fentry", "not called\n");
> +
> +cleanup:
> +	test_vmlinux__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c b/tools/testing/selftests/bpf/progs/test_vmlinux.c
> new file mode 100644
> index 000000000000..5cc2bf8011b0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
> @@ -0,0 +1,98 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +
> +#include "vmlinux.h"
> +#include <asm/unistd.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_core_read.h>
> +
> +#define MY_TV_NSEC 1337
> +
> +bool tp_called = false;
> +bool raw_tp_called = false;
> +bool tp_btf_called = false;
> +bool kprobe_called = false;
> +bool fentry_called = false;
> +
> +SEC("tp/syscalls/sys_enter_nanosleep")
> +int handle__tp(struct trace_event_raw_sys_enter *args)
> +{
> +	struct __kernel_timespec *ts;
> +
> +	if (args->id != __NR_nanosleep)
> +		return 0;
> +
> +	ts = (void *)args->args[0];
> +	if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
> +		return 0;
> +
> +	tp_called = true;
> +	return 0;
> +}
> +
> +static bool __always_inline handle_probed(struct pt_regs *regs, long id)
It is not used, may be removing it?

> +{
> +	struct __kernel_timespec *ts;
> +
> +	if (id != __NR_nanosleep)
> +		return false;
> +
> +	ts = (void *)PT_REGS_PARM1_CORE(regs);
> +	if (BPF_CORE_READ(ts, tv_nsec) != MY_TV_NSEC)
> +		return false;
> +
> +	return true;
> +}

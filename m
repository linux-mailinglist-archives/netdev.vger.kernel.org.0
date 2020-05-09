Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370E1CC34C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgEIRoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:44:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40184 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgEIRoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:44:00 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HeZfD029964;
        Sat, 9 May 2020 10:43:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v/gJtZ9oFEQKBP8aavSZ7jyb059t2JMRJWz21sy7z2o=;
 b=IR1HNKOnvNBstfv3Ms3geBC4c0wxJnsO6dmsldwsXtxdq9MDQXGLUvHT3xKSomrUo4xg
 QHCc0qvXIGOvi+EzL8JFEFPu2M6auGftRej8fogbhWuUZ+9BFhcX7MgRoai2Fq/Pi4T9
 YLFIn+tQAeVgdeZ6JK8vkmLWT9JnUsRE+qo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30wt8ssbq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 10:43:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:43:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVldp3G2v9ATz8CerPXO8yMIeB+UCKJK5/EpY1r5Rpu5uRG00vMbp64x2CdPv2EK4vhHIFbsManBvfpPBlSTpBL4hYQM6GJCGL508uNENbU0W6yto2pVnvzsVBYrdapo0+4ExBYh4o0c9CHW9X5Ig9KYhMmcHbzS18CD4SYpjWs1cmrfxOfS8Ctf3lBKbbE0UqCOKjI0VSOkYYWa4DcgS05n6nxaup/WGtZmt0Wh11NmWzniU1go2dQF+U1ckxElOuLUVLJxNCwfNg+qimOedSLxeluc3ngrtQcA0witjivMo/bG4dWGR60Ot0AzfSNYhLWeVHOnMmVDaOyFmOLPjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/gJtZ9oFEQKBP8aavSZ7jyb059t2JMRJWz21sy7z2o=;
 b=niGbeaXmDdQjhEEE8ogouwrEbQAn/xDkEMfAEk6DhD1a4DFOfyKwehjIoWzSkMIWFT0r0w3+b/dKuXl/WI31M97RikAB67whYW+I7Fo+SNIX4o2dLXsPhasQhM/tdeWKhtgFKExB6j5HQABZ+/5Hw+o63mf1BydrNugeIpmLR08ffvxNKaPHPQ7hZeeJ1Qz368LlhhD8wsfFSyhB0fk6WH+m/yrgez2NnAaMrSVimZRf8H4KYKUyyQ6X99uA7edSDTgJ8qlT9eurIF4zw8KqZDG8YAdzHVR3uo8mYPULyKLMSHKgHcPB+WxYqK4pU3f6HDMZhHW+lhF26KJwurcizA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/gJtZ9oFEQKBP8aavSZ7jyb059t2JMRJWz21sy7z2o=;
 b=XwhiifViVERldLKGiKNmpeJXBDBkHWiaDjoOr4qucrdw6ThVDXeWOZaiYt7nK002BNghZL4iGKjJVAoMMOtSXmG3Q35A2hKXnmOkWzTYN00gWDA7sZhDBIXDHci+Wygs85RM71tzB+BvIozB6XpuKkMXRBRFplCYl1EuZWAp72A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Sat, 9 May
 2020 17:43:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 17:43:45 +0000
Subject: Re: [PATCH v2 bpf-next 3/3] selftest/bpf: add BPF triggering
 benchmark
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200508232032.1974027-1-andriin@fb.com>
 <20200508232032.1974027-4-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <69dffc45-a6e1-d422-0a78-9553ed87ab15@fb.com>
Date:   Sat, 9 May 2020 10:43:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200508232032.1974027-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:217::8) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sprihad-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e112) by BY3PR04CA0003.namprd04.prod.outlook.com (2603:10b6:a03:217::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Sat, 9 May 2020 17:43:44 +0000
X-Originating-IP: [2620:10d:c090:400::5:e112]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e343cf4-a26f-4987-e00b-08d7f440856b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30321E0AE122AFE569C33626D3A30@BYAPR15MB3032.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKVJv1l/o6Y8SIFMtGVX8v8YuZ+WIx0b8CkrSgY6DcL94CXXPy9KBva5jOc/wjpGGZOKQa3BhriyD2+N+1tN26GsZcuXJ0s0gWcFhYLs6+KN2+epa8lqHf08txkZjxRhczTh88oTXq6iFajQXqtj/IMf/dxudXA4L1kzDX4CX7oVbz1RKp3kpwzhXBLETbtWkzocD2XRb5a191QHDSCiT35c9beYtVZO2W8rLabbSObefrUabCqk3G5GHPZYeqNGF5lCuMGEKZdqGB44VB8FB8VHwBwwY48csUBnbNBlDmLz6SkyPrIViZR+RJ4U+HAGfs8Ne/6SIcxdZtLofWyHmGubRw7gZD23jrA1ad1vn9Ir8KApOXkiXNzO9na/uiLbq6S4MsFejXTwhGo7alXaPk9QFpbe+5Uq8rlQK5XOXuyWuuij95OtwcvpPZUaZZz2YE7MESlmA+oXGEjLAA2gBe/cqkkMNMasqGmbv3/AYYn6U/6KiK19FJB/KqHyB6ibS4hPuXz7+/AsHxAbFLtKrkIHxQYd4b5spgaW61gAcM/RMRw0VeALzU8QmL1t5C7K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(33430700001)(8676002)(2906002)(86362001)(2616005)(66946007)(66476007)(186003)(52116002)(4326008)(66556008)(316002)(6506007)(53546011)(31696002)(31686004)(478600001)(5660300002)(8936002)(6486002)(36756003)(16526019)(33440700001)(6512007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SZJCTIADbOB6T/boyCbWoMWhfulHYE969vok/ao6YqyB+wNE1h0IXlqaNyU5YuVzfMmXHUUsVt+TYXqdqdzSInDZGMi1d6U9oeSmkBQVcEma/qvPp/4GFDhlrLg/DE9QPo+H9nR4bVuJaq2H32HAr7ch7jsylHqXFZFNeqrLaHA3LuvO3dh1nhC53ZHocAoGRc0kskQ4lCRt+FDhe6hAA7f3wmvPGvvCxb3ZxBcBd1MzgkWRWI6wCsG0mvwGvmQoDm6PLTOPKk+q4jH1SN9euX1C6QTpEdQw5hlfzOXQ841Wyo+p0u/1jGQFDgM4LCbzo4gfYirlmy4F5nXqve6WWFHgoY/+Vtb/UjPZ2uPB5VCK6Xug1eHstCHPBf4H1qv09guVmMtFr58k8PhrIWA1u1DQXheRQGSdTV+rfXio+/LWdBshR3WWTG4NQFMfu+akostkouzbBULboaWwQOzykvdSMDzUt75kZM3Eou9ni5e0S1n/gsvIRSlO5u6gi3tDhir6h/kveMAyq/8o91VPLg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e343cf4-a26f-4987-e00b-08d7f440856b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 17:43:45.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15bmo+quMCZXQuAdSP1BNglFmaDH4mObImpkoag9vpOCQiWtC6xojyLtCU3Gudlx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3032
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=962 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
> It is sometimes desirable to be able to trigger BPF program from user-space
> with minimal overhead. sys_enter would seem to be a good candidate, yet in

Probably "with minimal external noise"? Typically, overhead means the 
overhead from test infrastructure itself?

> a lot of cases there will be a lot of noise from syscalls triggered by other
> processes on the system. So while searching for low-overhead alternative, I've
> stumbled upon getpgid() syscall, which seems to be specific enough to not
> suffer from accidental syscall by other apps.
> 
> This set of benchmarks compares tp, raw_tp w/ filtering by syscall ID, kprobe,
> fentry and fmod_ret with returning error (so that syscall would not be
> executed), to determine the lowest-overhead way. Here are results on my
> machine (using benchs/run_bench_trigger.sh script):
> 
>    base      :    9.200 ± 0.319M/s
>    tp        :    6.690 ± 0.125M/s
>    rawtp     :    8.571 ± 0.214M/s
>    kprobe    :    6.431 ± 0.048M/s
>    fentry    :    8.955 ± 0.241M/s
>    fmodret   :    8.903 ± 0.135M/s

The relative ranking of different approaches is still similar to patch 
#2. But this patch reinforces that benchmarking really needs to reduce 
the noise to get highest number.

> 
> So it seems like fmodret doesn't give much benefit for such lightweight
> syscall. Raw tracepoint is pretty decent despite additional filtering logic,
> but it will be called for any other syscall in the system, which rules it out.
> Fentry, though, seems to be adding the least amoung of overhead and achieves
> 97.3% of performance of baseline no-BPF-attached syscall.
> 
> Using getpgid() seems to be preferable to set_task_comm() approach from
> test_overhead, as it's about 2.35x faster in a baseline performance.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/Makefile          |   4 +-
>   tools/testing/selftests/bpf/bench.c           |  12 ++
>   .../selftests/bpf/benchs/bench_trigger.c      | 167 ++++++++++++++++++
>   .../selftests/bpf/benchs/run_bench_trigger.sh |   9 +
>   .../selftests/bpf/progs/trigger_bench.c       |  47 +++++
>   5 files changed, 238 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/bpf/benchs/bench_trigger.c
>   create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_trigger.sh
>   create mode 100644 tools/testing/selftests/bpf/progs/trigger_bench.c
> 
[...]

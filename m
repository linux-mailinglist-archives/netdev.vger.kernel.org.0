Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF902C9821
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 08:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgLAH1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 02:27:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31042 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgLAH1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 02:27:22 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B17Ox50018079;
        Mon, 30 Nov 2020 23:26:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hUu6PG/rk0nN+DTsg2ac1YdNw7QG/9Wp1reI7JYw8IY=;
 b=oa+9fk0CK02oVp0daukqTsRCnb2XPuKSpW1f9OSm1h5l9lW/J/5czypeqwWZgZlcJKqW
 v+Yn5x78fqlOthR1g+9wTlytd3Zcy7ClhsIm5jxg1UoyZSZjO6SdVcgZdnBYL7Xn6saM
 8Pu420K8y/pSCZ4YkUXbJf1LJpKcEIR2lXQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3547psj4e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Nov 2020 23:26:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 23:26:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5fLEXDXTkMcUZ+YNnF8+2aE+z9bIC2RRK9q8LC2o3Vrgdgf4AUIAPciA7qkxPyoiRWvqDlFwawUO4pTOCJt04IfW8EkKxoTCkK+8X5IW2yef1LJ5cBB36YVa0PecIhEQRBVRcN6vxL+/lnMRZW8mR3bn38xaq6qculE6IQ/ig5kb2HfWMo841QsapbtuYEhLCmoH/9hwcavTlFysEw20nYWyQKH8j63qwCLEtW1aWZhAgVm10b/wnHSIRKLhEnrblpD+j6/r3lq9TQOGDfRRRgDdC0NjrXCZ4T1L+OcG2WCiMKYbaFjefW2LgfYE6dFdIAEmmBm9VBLfA2SUvYePw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUu6PG/rk0nN+DTsg2ac1YdNw7QG/9Wp1reI7JYw8IY=;
 b=lRYKMzQdUNNTIDRhwqmVbJgF+Gx0SniRy+zN1Gcf+F23OngCnB1O7co8AzeOXUEufPQWrrV6FrF+1JkRFsWzBbCNV8lHNiRf2piAv+Um7603e08tuCRUWk4grap7RO2dTGGRleQNf/4KithGm1lx8dnTG7gI6Hovg09Sm1eg5QbKN7YdI6gxAt5M0bW53thdPR/Oyyk1RbkqvGNvThCjn209gqky4nFeEGEmbQk/hOLB2TACOnp6z2OwDr9IB0QGKfh9CV+BUkpF6k9UENJMiXyUVCXfsEN69yjYbL7qIP75N2F+Fxk01GXN6IHKaQYHaioZaIQIAUQjsL+mW4D+5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUu6PG/rk0nN+DTsg2ac1YdNw7QG/9Wp1reI7JYw8IY=;
 b=heDGEIJXgIthCDC4ooEr05mg/09kDVN1eBA4ELZvbiChbY3FwvgU//LZ088FVnUWV/WU0GYT61nxqMt+NGK9ebeX8QbhyxCGeES+p/7dCGqm1b4I4Dk6NpxkaDfYfWbl6Mum/HdeuWwch+aVN+SID4Ty3Fw2DtqptmEKuzwIgkY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3665.namprd15.prod.outlook.com (2603:10b6:a03:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Tue, 1 Dec
 2020 07:26:24 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 07:26:24 +0000
Subject: Re: [PATCH v2 bpf-next 0/8] Support BTF-powered BPF tracing programs
 for kernel modules
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20201201035545.3013177-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b29b91dd-a69c-30d3-59ca-4fa15b86492b@fb.com>
Date:   Mon, 30 Nov 2020 23:26:19 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <20201201035545.3013177-1-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:3a76]
X-ClientProxiedBy: MWHPR1401CA0006.namprd14.prod.outlook.com
 (2603:10b6:301:4b::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1841] (2620:10d:c090:400::5:3a76) by MWHPR1401CA0006.namprd14.prod.outlook.com (2603:10b6:301:4b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 07:26:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a079ba8-2b4d-4cde-7719-08d895ca683d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3665:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3665E2343491CCD22D9B55D8D3F40@BY5PR15MB3665.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EpX1RM2pK0OCyAvWVcHlgQE2TAXER7S5/3FpLn0hanwZuqdovFnlmATMx5ZrxYFQun+1j4UjtcCnvgrvYQvuHo/Mrwqfj7bzZ8+221kG/6NFrrh8ZhI6CYetp3OmmNBWWef3ToWPnqFb09mmKG+jBEeEGCIC/+1wqzKKiV92IngejW09Xeo5l1ciVZNhyjOLiCidCQo8EeKiLQ2yGIWUIChhKmn3A+rn/skQL1gT5tyArOHstPu5okGI+JmNSmk32+xDgaLNca3inKJZdmY6Iynv82+V37XLdLTmHxRsar/LkWh2Fm7MyCFa6brpkXkBRLuUX5n3qJgFWfwemQAozhxTSpK1CIFd11wVq3+TtTloB9MNCw1e9U0uNvloCszaB7Epeoh82OcsLAvRL6OTJwU+tUjWwPyR24ui+sdq8en0p2XypQgoH1LPzNQ3qxmJCIYvzV3DtclU7KdwG/8AFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(39860400002)(376002)(186003)(6666004)(966005)(16526019)(316002)(31696002)(66556008)(53546011)(36756003)(8676002)(8936002)(66946007)(5660300002)(31686004)(66476007)(52116002)(83380400001)(2616005)(86362001)(2906002)(478600001)(4326008)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MHhOU0l0Z1FSOFFWK3ZtSmYwM1ZJOTN0eEVCV1dQalRlNG96R3FiZmtsSG5Y?=
 =?utf-8?B?WWY2bklPY21vb284NUErQjU1VGQ4MS9JU1QwYjVPV2NQZDY2Y215dkE4emxT?=
 =?utf-8?B?MjdQSkxUWXk5b0lBR0FLZkMzazZqODIrRHI2T2xHcWJnMktIdUlrQmpJalFH?=
 =?utf-8?B?NXRPbGVvUm14M2hRSjh4Ui9CdkJQaHlEamptMFdpOTdxZGpURDNiT0ZzTlp1?=
 =?utf-8?B?TURlbFhXVTlzd2lzbE5PVXI2SUN1TGFTenBpR1gxK3M5RGQ5N0VqTUhyK2s5?=
 =?utf-8?B?TXFtbFc3alZvdDlyMWdENzR5TTB2U2xuMlFyUDlQWjNOYlRydEJQc0xGdVNC?=
 =?utf-8?B?eDJJWVB5R3loRENHejlhU0NnTUFTYm1QVHVDbXJkZndXM3JSWnBSRkZ3UGQr?=
 =?utf-8?B?Q0ZxM0Q1T3lLV1NmZTlackxzOTBlcVRXSzhwK3ZhMDlxRUpZL1d0eHpRZDhm?=
 =?utf-8?B?bDNuT0IyZE5CYUhINmFLM25yb1c0T2kwVDU1U3QvdGxaLzhSaEVseWt3WGNT?=
 =?utf-8?B?TlhDR2hEcDcxVjVlK2lQTkR6T1MxaWtaRVpoaW05VURuRWhIVG1rV2pWVjBq?=
 =?utf-8?B?eTZWanFMaVkxU0tIZ2Jkd09xVTFEZU9WTzRLNTJScEhhS0NmNzJ2aXpHMm9v?=
 =?utf-8?B?Z3BuUXE0dlhxZ2hWTFdLbUljVzJoeksxL0g5bG1FNFZRU0NhWGZCemlXWGZp?=
 =?utf-8?B?MHJBUTZlYnp6L29hNWJ6VEFBSitBUVJ4MnROR05mUnlqVWlUUXJ5WVR5d1Jy?=
 =?utf-8?B?dTR6UVc5ZWxCL2x1VkZqWDdud1UyZ2NkMGxXNHJ5RzFPZDB1VFRYRUNpUWJE?=
 =?utf-8?B?TDFUczZFN2x3cW9CSlZjaENFQVRpMENmMmxHV2dhaDV2Nnh6Vy9rQnFnNU80?=
 =?utf-8?B?bXdzck92R092d21kaUk5cVZhd2NtYzYvaHpYT0RhN1ptcjdMREtxSWM5dFE3?=
 =?utf-8?B?WUw5czlNTEdObUszZURkd3JpVjVCWHduQUxlbVAxcWFWTmEzeVVWZjUwTWts?=
 =?utf-8?B?ZXdrWWttblA0dGRiQkoxVHpFSlVNSHMrRkt6OWRMVzkrYXJ1ak5iS0ROd2pw?=
 =?utf-8?B?a2dLN1l3MVNxN1FoMyt1N1pBT3VycTNyTHZxb2ZMRE9KL2drQ2V5MWNSSXdC?=
 =?utf-8?B?QzJCVWpDdlNRTnB2Y2ZCOFJjdlZPUnFzR1lFbFhCMHBxdVB6MTBBamRldDVi?=
 =?utf-8?B?RFlnVVVCVzloMzRLdk1xYVNCQ0hQMUJ3SFRaOWhpSVBDbWxlS3BOdFg1bStp?=
 =?utf-8?B?VUtmL1pTRXYxSnIvMlBNdWVFK3ZXZVJmdThwZ2NvV2RFRXB2eENMbmcvZmo3?=
 =?utf-8?B?cUNDZ2I0b0dFL2Q4S2hKeWRVSVBHR2c5ekJXZ2UwbEc2dW5kaUxEQVBkY2oy?=
 =?utf-8?B?NjF5Qis2dksyZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a079ba8-2b4d-4cde-7719-08d895ca683d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 07:26:24.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rO78Yr97L7ck1liEhF13RAM1c43c8WQ0vfKeiStyGSR0dKvb/N/WQgSdg5iMmhdY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3665
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010048
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/20 7:55 PM, Andrii Nakryiko wrote:
> Building on top of two previous patch sets ([0] and not yet landed [1]), this
> patch sets extends kernel and libbpf with support for attaching BTF-powered
> raw tracepoint (tp_btf) and tracing (fentry/fexit/fmod_ret/lsm) BPF programs
> to BPF hooks defined in kernel modules.
> 
> Kernel UAPI for BPF_PROG_LOAD is extended with extra parameter
> (attach_btf_obj_id) which allows to specify kernel module BTF in which the BTF
> type is identifed by attach_btf_id.
> 
>  From end user perspective there are no extra actions that need to happen.
> Libbpf will continue searching across all kernel module BTFs, if desired
> attach BTF type is not found in vmlinux. That way it doesn't matter if BPF
> hook that user is trying to attach to is built-in into vmlinux image or is
> loaded in kernel module.
> 
> Currently pahole doesn't generate BTF_KIND_FUNC info for ftrace-able static
> functions in kernel modules, so expose traced function in bpf_sidecar.ko. Once

bpf_sidecar.ko => bpf_testmod.ko

> pahole is enhanced, we can go back to static function.
> 
>    [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=380759&state=*
>    [1] https://patchwork.kernel.org/project/netdevbpf/list/?series=393677&state=*
> 
> v1->v2:
>    - avoid increasing bpf_reg_state by reordering fields (Alexei);
>    - preserve btf_data_size in struct module;
>    - rebase on top of v3 of patch [1].
> 
> Andrii Nakryiko (8):
>    bpf: keep module's btf_data_size intact after load
>    bpf: remove hard-coded btf_vmlinux assumption from BPF verifier
>    bpf: allow to specify kernel module BTFs when attaching BPF programs
>    libbpf: factor out low-level BPF program loading helper
>    libbpf: support attachment of BPF tracing programs to kernel modules
>    selftests/bpf: add tp_btf CO-RE reloc test for modules
>    selftests/bpf: make bpf_testmod's traceable function global
>    selftests/bpf: add fentry/fexit/fmod_ret selftest for kernel module
> 
>   include/linux/bpf.h                           |  13 +-
>   include/linux/bpf_verifier.h                  |  28 +++-
>   include/linux/btf.h                           |   7 +-
>   include/uapi/linux/bpf.h                      |   1 +
>   kernel/bpf/btf.c                              |  90 +++++++----
>   kernel/bpf/syscall.c                          |  44 +++++-
>   kernel/bpf/verifier.c                         |  77 ++++++----
>   kernel/module.c                               |   1 -
>   net/ipv4/bpf_tcp_ca.c                         |   3 +-
>   tools/include/uapi/linux/bpf.h                |   1 +
>   tools/lib/bpf/bpf.c                           | 101 ++++++++----
>   tools/lib/bpf/libbpf.c                        | 145 +++++++++++++-----
>   tools/lib/bpf/libbpf_internal.h               |  30 ++++
>   .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   3 +-
>   .../selftests/bpf/prog_tests/core_reloc.c     |   3 +-
>   .../selftests/bpf/prog_tests/module_attach.c  |  53 +++++++
>   .../bpf/progs/test_core_reloc_module.c        |  32 +++-
>   .../selftests/bpf/progs/test_module_attach.c  |  66 ++++++++
>   18 files changed, 546 insertions(+), 152 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/module_attach.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_module_attach.c
> 

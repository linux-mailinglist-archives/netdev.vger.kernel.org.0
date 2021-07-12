Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0833C5FB9
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhGLPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:52:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230228AbhGLPwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 11:52:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CFcOHM001103;
        Mon, 12 Jul 2021 08:49:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gXa6YarNdkdgzWOJzZ54dN7P9gcfLTR3ITNrVhj5PzE=;
 b=HV5CFVRjQMJo/De5FErtIvUaChxe38qE/4w1MI3G5xSn4Y+Gp6SO299V9DDX0w3t3vRz
 tPEUWa1cCDr/alFXSsmDFLvlTDJgyLo509IIq3Srq2b/jxl7HEdg8Wn+//hmMFvcrG9c
 3r+1Y9OJSw2u9W84iJOp8FpuQa9ZqVOcqto= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39qav8tgbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Jul 2021 08:49:23 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 08:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ouw05ovoQ4EGQUgouv3MVKBt24LzhSDTAmc3H7e8+TmkosCqTi3vCzOAgsquBkvNRGb3ggxwXqnDzI82zDbOg3fMvUXzmgNlHhshlzMvYMKBMrB73dy5ustvgL8es9duAgh/0r5OyLfFDfP39ykOjlP8w9OSR/HtCFvAKvi9ijY0TZ6xlj3KPeT3aMGRUtNQ6JoTT3aj4qpSt163kF6oUIj56OENU5emdE94vmAZ0R/JDmipyZuOkNCeN7b/LJWOsp3WKh18GvRwEpWwzbuOVYBjZU/T8oCg3AXQD845e5PhzDjlTk/UaBSDS2M9H6W0TLlw7RppNgcLGI1p39rJNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXa6YarNdkdgzWOJzZ54dN7P9gcfLTR3ITNrVhj5PzE=;
 b=FSWjtEh1/I56pRurMRNBg1nWDaBiEPnaSYkWFjuEzY3JDlO4GQEEK5oxcrunrsZkJD3sIwiosGSiFXmXVfIQpW35FEWLkT9HN95pxeD+LJHiRMWJWvtT8yX0b2G/OSuIZT40Ke7lUe6z0x8pbnc7m+SzyqWFVTJ2lnaX7Va3lvmaVmpUnuALenq7+dhwjYMLHwI4P4GY1GmRPFuMcwSsSoZw2qHhFYlSJMDRYGGySPQWDkrKGRtlcOX5MaciXN+vXQlD+tckeLdI3WupekpAqcwCjusN8dGWR/y7O654l6a/Z/DaJhAVXvr5qmCeCD7SC5UcTrL7Cj35F3UkKF+gkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2336.namprd15.prod.outlook.com (2603:10b6:805:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Mon, 12 Jul
 2021 15:49:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4308.027; Mon, 12 Jul 2021
 15:49:21 +0000
Subject: Re: [PATCH bpf-next] bpf: add ambient BPF runtime context stored in
 current
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>
CC:     <kernel-team@fb.com>
References: <20210710011117.1235487-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <333ffa5f-5875-3870-4933-1ee23b68fb87@fb.com>
Date:   Mon, 12 Jul 2021 08:49:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210710011117.1235487-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: BY5PR17CA0072.namprd17.prod.outlook.com
 (2603:10b6:a03:167::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1156] (2620:10d:c090:400::5:9a8b) by BY5PR17CA0072.namprd17.prod.outlook.com (2603:10b6:a03:167::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Mon, 12 Jul 2021 15:49:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fa429b1-fb77-4449-6e19-08d9454c9d87
X-MS-TrafficTypeDiagnostic: SN6PR15MB2336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2336390379498EEBC344E75AD3159@SN6PR15MB2336.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RGiFvbCiEjrPf0yYlziigWz+IKU30BJm0INNWaDawZ9mK0is38U6tKZV2my1fPlplYpp4xje5m9YWYwbk+OWiiDZP+t/sC2K+wqWO+tINXtcLdT5BRcUJEJXQmRXe6w8cmGtpbsqy70wrnXx022w2rvd0CNlkRRt02P6cxLWMoc49DLxZjtd7UIiPp4RUxhBQdcI6hcYBSs/TwlYc7GCeMAciijKQmZz4sl9i5zo03YY0Wpmh1uwZC8ijv6xX2D016Ck/qpwH4LDbSfP5qJslLXLwqOOw3lfOPf4X/yN6TXHWNJW4RcomIhsPCHsjf24sa4YPKLhKDkHW0xgGQOPgdHIBQY/GtQsuFpNSZOcdvdyO3OIDCGqVG+D3hm1or0q3pE2nL7RJB3IKjWmevbKsG3N1QlYQLdCYDkXDKBQRwPCVuYmM8cTeXIR/bF+40M40rI+SUfPTY13M6rHk6OYzJCMLc0e/ofQczajxFiLSyStzq6SbYW++saPjjB0qpk7apfTSuwWEa4SMj19m83YY/sGmFihME8FxXKs8wnsE4IpYdAu6gempGLJSRp8j0wEDPhWdU3H/3Wxq5P/tE6Tmuv2LAZhjPOB2DgLPKC0YxEOMXpYJzlX7WeMF8rI/w0bCNtb4HFnQkI7yVPeRDPQ0hnv6p8TTdakeiA9Syi4ObzqDZoZ8yUE8qAAzVKV5DQFba86ZdCviurgTtAJng+n4SkubGG9hZWzVIE4DXyaIf9qUc8Q0VIAqMi218nwje3VglMHLrTQjNg/bZwKKf5QihbubZnL+Ee8RZfRm8+m01ytw+xqX51AFV6GaVMGzhn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(66946007)(8936002)(31686004)(38100700002)(36756003)(66556008)(86362001)(5660300002)(31696002)(53546011)(478600001)(6486002)(966005)(83380400001)(4326008)(8676002)(2616005)(186003)(316002)(2906002)(52116002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlVoV0RjMXBQc294ZjdFcXZLUFVGWlBYdGFJWWVOWUk1eXUzTFFjalBxOW1I?=
 =?utf-8?B?N2VTcVN1aGJ5enNHSlNYV0Z4SmttanVibjVzRURWZFFvSFQyb3hTQ3pta1ZN?=
 =?utf-8?B?VHhOOXFCWjhHY25GcWR3N2IrcTErZUlDblZEQ3FMbHVQNEQ2SkpGcUx0cE1Y?=
 =?utf-8?B?TnRwRHFMUFBmTGxhWW1DSm1OZXRNN2IrOE45dEFiMGdneE5hUHF5WGVCeGV2?=
 =?utf-8?B?VUxKK2pHL0UwRTlkVHQzZ0Iyb09Celhkakh1cXh3cnovVFJsaG5FbnlDZVRC?=
 =?utf-8?B?WTdSd0w0RUx3dEdnV0wramxXVjhXYzltbjhIc0JvNmo3aUxDN3l6NFVnMjND?=
 =?utf-8?B?TU81YjVnekI3T1REQXdLL2Q1VHQ5Q3VrOW9iR0FVZVd3R1Z4YTQybkFJZVZU?=
 =?utf-8?B?YXZGUW01eXQzUFFnMEhFQ3l4T3JpTzRBSVdaOU1qZGJRNEY5ZE9IeDkvU1Jp?=
 =?utf-8?B?QzF1MFBiN0FabUNWbTE1R2VQOEI5TEdxNDBqQk5Gby82TVJRNzFMOUcxRUJ6?=
 =?utf-8?B?M3ZZSGN4YXVjVUhZVklCc2JOU2dnc2JKYk5rWDVyd1puNGpxOE9MNittaVp6?=
 =?utf-8?B?cXlKRUl6cWJ0WEsyYmRGNHorcUM5aENGc3h5aUVCZXM5NzE5YnBvNHdzR0Ur?=
 =?utf-8?B?MFpRTW83OVZKb29OQmNveEFjZnVoMmJXL1JTQ1grd0llbVVrcWpvUHZBZytE?=
 =?utf-8?B?K0hjQTF3NXdyQkw4S21uRlk2ZGM1dVBvcWUrSmR5NjBLd2hLRHVVSk1LVHZ0?=
 =?utf-8?B?K2JBaFZidk5UTWtTeHZrUWJxaUJCMU9wQlUySHU1VmxkMW03U0RjUnpCYlA5?=
 =?utf-8?B?M2xTQmo5RThhVUpkU3RNUExnMGZ1elVITjlCdy9vcVpTVWJXTUt5N1FvSElP?=
 =?utf-8?B?K0RzbEdoc0tzUGxpK2lhb3NYbi9VZGE0azBMLzE2NmZRU0Z6YUpFTnRqNW54?=
 =?utf-8?B?UkxDWGNnZDd5eDU2UTh3UGJERDdRZEFCVjVtdWVqL1BYRUxlZUJoWGxtNEUr?=
 =?utf-8?B?c1lmUjZVdUxTNHovOThGU2tSak92dFR4eU9YTTBldHByaktaWEl3b2VUa3k0?=
 =?utf-8?B?c3ltOVVZOXVUZ0RMQ0hlS2wrRTJJeHRPMzUwS0hvWS9DQkUvd3luSEE3Y2xr?=
 =?utf-8?B?T3NBbFRncEhHcGF5NGtpb3lMeW10Slh5UStkbWpkb1NOS2E0VmZNem9LV2tE?=
 =?utf-8?B?OWdZeEpzSThwMFc0R05VWFNQZ21LY2hZTTZLMEJMNkh4dXhhVUVHSjNrbC9E?=
 =?utf-8?B?YjkvY0JSSTg2WVVINm9PcXBJcmtqU0Z3VktFZlFiTml5K0pBa1JhazhOUmpo?=
 =?utf-8?B?dE5DMDQvT2tWR0F4ZW9QOGpOM0p1VC9HSXlzbldiQTVwV3RyOGpJUWpOQ2h1?=
 =?utf-8?B?QjhjZHZOZStlQUZKd2RhVHcvSSs4ZTFJOWFMSzlSdU5hak0zUWJnZG5wbzVo?=
 =?utf-8?B?dWY3OHVOSVhOTjdHekV2ZllTQnozQ3lNNi90dzl6MVRDVGVoVFNDTE9nZ2tN?=
 =?utf-8?B?UDJ2TFE0cFk5MkhzUVVaUjVwQ3ZLMXdRS214NWoxTk1VenM5TlVNU3U0ZTdB?=
 =?utf-8?B?WS9WMnVUdU85SXRuc2Z3OWpwZ0VUZ0tNQU00THVhNXk0bDF4bzNmVTUzazVj?=
 =?utf-8?B?TlF3M1BDbEVWVkE4bmNsTHQ3MWxTei9ydHdvRWQ4T0p2SGN5K2pHT3ZzNUJZ?=
 =?utf-8?B?WDhhdHFOS1pzK3M1dzlLM0tRNEU3K1RVRmNMSS8ycHhIa0N5UkNVMUVNQnNv?=
 =?utf-8?B?NzVPV2xoSnNIMXJjMUQxTVBFSHZFYlZQWXA1NWpQcllVRlNTbnhnZU1nYmxX?=
 =?utf-8?B?cld6VGJtOWUyZFVuVk8wZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa429b1-fb77-4449-6e19-08d9454c9d87
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:49:21.4134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUsqGYOc4J20O7eayq/C358rdJnGFH0tq5LfLIVeWiOtQPitCEX0IJUvzfTaI0uo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2336
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: g-fhdDZXSsP90SzFsrLKQvwVoiQ3dXPN
X-Proofpoint-GUID: g-fhdDZXSsP90SzFsrLKQvwVoiQ3dXPN
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_09:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/21 6:11 PM, Andrii Nakryiko wrote:
> b910eaaaa4b8 ("bpf: Fix NULL pointer dereference in bpf_get_local_storage()
> helper") fixed the problem with cgroup-local storage use in BPF by
> pre-allocating per-CPU array of 8 cgroup storage pointers to accommodate
> possible BPF program preemptions and nested executions.
> 
> While this seems to work good in practice, it introduces new and unnecessary
> failure mode in which not all BPF programs might be executed if we fail to
> find an unused slot for cgroup storage, however unlikely it is. It might also
> not be so unlikely when/if we allow sleepable cgroup BPF programs in the
> future.
> 
> Further, the way that cgroup storage is implemented as ambiently-available
> property during entire BPF program execution is a convenient way to pass extra
> information to BPF program and helpers without requiring user code to pass
> around extra arguments explicitly. So it would be good to have a generic
> solution that can allow implementing this without arbitrary restrictions.
> Ideally, such solution would work for both preemptable and sleepable BPF
> programs in exactly the same way.
> 
> This patch introduces such solution, bpf_run_ctx. It adds one pointer field
> (bpf_ctx) to task_struct. This field is maintained by BPF_PROG_RUN family of
> macros in such a way that it always stays valid throughout BPF program
> execution. BPF program preemption is handled by remembering previous
> current->bpf_ctx value locally while executing nested BPF program and
> restoring old value after nested BPF program finishes. This is handled by two
> helper functions, bpf_set_run_ctx() and bpf_reset_run_ctx(), which are
> supposed to be used before and after BPF program runs, respectively.
> 
> Restoring old value of the pointer handles preemption, while bpf_run_ctx
> pointer being a property of current task_struct naturally solves this problem
> for sleepable BPF programs by "following" BPF program execution as it is
> scheduled in and out of CPU. It would even allow CPU migration of BPF
> programs, even though it's not currently allowed by BPF infra.
> 
> This patch cleans up cgroup local storage handling as a first application. The
> design itself is generic, though, with bpf_run_ctx being an empty struct that
> is supposed to be embedded into a specific struct for a given BPF program type
> (bpf_cg_run_ctx in this case). Follow up patches are planned that will expand
> this mechanism for other uses within tracing BPF programs.
> 
> To verify that this change doesn't revert the fix to the original cgroup
> storage issue, I ran the same repro as in the original report ([0]) and didn't
> get any problems. Replacing bpf_reset_run_ctx(old_run_ctx) with
> bpf_reset_run_ctx(NULL) triggers the issue pretty quickly (so repro does work).
> 
>    [0] https://lore.kernel.org/bpf/YEEvBUiJl2pJkxTd@krava/
> 
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: b910eaaaa4b8 ("bpf: Fix NULL pointer dereference in bpf_get_local_storage() helper")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Except a config related issue reported by kernel test robot, the
patch looks good to me.

Acked-by: Yonghong Song <yhs@fb.com>

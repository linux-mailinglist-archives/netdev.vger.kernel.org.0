Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCAE211B6B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 07:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGBFNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 01:13:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60340 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgGBFNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 01:13:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0625AFx7031770;
        Wed, 1 Jul 2020 22:13:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=p87tnxmRObfW1YR8VuT0bfHWgB7NBqTopJwKfNGszr0=;
 b=A54AF8klu7PWP5y9nwiNr1zq3lGSGBkpaS2jvpUwTIqG2R1zNhoC8VG0q0t1ddNBPuzS
 Kwd+Er1PEF2OPwyoFvLJNTC+edda7nnnCLSoVWkIe0w0/ZCL5n+kaHulzZfTzKydhhMC
 5dCmD3Rdqk4Jq2VhqDJeG8ipWNM0uQ9x7Gk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntc361t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Jul 2020 22:13:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 22:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRrbLrouZSAzGyDBU+0+ZZwqlY6B0ICyAQMNPLWsciOOxBTN/SgASdpVqUh8sN7K7xKPNwf8JZE2a7iF6XWAU4K/Kfur/xM9rYBh/dATfHqT2ErVn5PQPzI2ZBHSkpe4JWtnG/HgLaI1GebQ/3RdVpgYoBqP+ISEVQ3b39nU8ECdzNGzI29d/wKYQH1sRn47OyIz0SrHK/onIjSfQynhqDfv/N4uVlFVHT8YTCgQOtd0PvLPu6H9chIxKoi0oV5mKq9GTwgp7IHkMzawrQoP9T+kuDkK/hxrzmtVDf0f2Qsi+66IXNJnVIF2gYidcAstFeKt+koc8bXCyvcVd7Hwfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p87tnxmRObfW1YR8VuT0bfHWgB7NBqTopJwKfNGszr0=;
 b=GV/3egGrro5i95jVw3kJmYTzkyy6eWV8oC01Vh0qOAcnRCNvpNBQxl51/9FLj8l5kp8hrHbyNTMNX+4M55zVHfhLiGUHQHRY8nznfRLMeqn70XXIjMcBdhsn79dyRuiJfa20VXaGoPoiuP7h3767DP4r+wZ1LZHE351nkmGN6Aj7tHmz/FgeNU2RvHNI0Ez4abSL8YNyNhnemq6bAtwgi1O7rQ4479jsXMh74rLN4DarjfN3C887gAWtdHPpIJ3dG/IvpJTT179ZcTzfKuaQHVtJDrIEbOnGKA9K9R+Z4rKdSI6A/k3VTNZiobZQWN2Z0JH7wSKpyPKjw526DpXvbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p87tnxmRObfW1YR8VuT0bfHWgB7NBqTopJwKfNGszr0=;
 b=IJuE8Sw6eRgQcv8QtkjF8+YfHLzjYjmmmYqcWN2UknzbL1dMm1U6jHBYw70xT7kwZAdU3C4q7yo9bNzPLmdRMfEx+CLvPoKAO6AnX2ueHCAm50JIdmtGycSBfDYDh5ir1MROogZ2c3Rkbp4rva9Q5LZvX65y+v4bN2zmq9SSqYQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3414.namprd15.prod.outlook.com (2603:10b6:a03:10f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Thu, 2 Jul
 2020 05:13:01 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Thu, 2 Jul 2020
 05:13:01 +0000
Subject: Re: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
Date:   Wed, 1 Jul 2020 22:12:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200702021646.90347-2-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::12c7] (2620:10d:c090:400::5:6a0e) by BY5PR20CA0010.namprd20.prod.outlook.com (2603:10b6:a03:1f4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Thu, 2 Jul 2020 05:12:59 +0000
X-Originating-IP: [2620:10d:c090:400::5:6a0e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 927e0673-ce1e-45c7-2884-08d81e469707
X-MS-TrafficTypeDiagnostic: BYAPR15MB3414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3414C758E1A31F812A84F8B0D36D0@BYAPR15MB3414.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBn90Rtt1RhrJp7TftltMy0/Jzlh2KiPrfUx0tXj5gCZ6pVKF09ctb8CbH7k/i9unOK6DQ9Kh1qrO1L86qbDr0I/9Z15MKs3ESF8ajgENquUinSrfXOOfZ9Twl5EJMs9RBKjL5jVWFi6vC6NbcHnSrwpCeqW0uNGuIa9Yr7rAvSOSogcVynDq7bXx7uBXD595gPqZiiK7a3k+aPQ+Z+KQhhpTkGwy3+3DOwLYa94xNVZ2yi0kIoKipfHdbSfEhpqD6CbM627fCoxwAwkVymwrU++l5PyLZq6/eIgA+JVNHvO/ffYytPyUDTPgY1kk7W0qUCOE8TKcA9DBjJZflT53dpbI2vFuVQE8vNDFcN+HkalTECfvLG5gc5EzeQmhaUw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(39860400002)(366004)(396003)(346002)(2906002)(66476007)(66556008)(16526019)(478600001)(8936002)(186003)(6636002)(66946007)(4326008)(52116002)(36756003)(31686004)(31696002)(8676002)(316002)(86362001)(53546011)(83380400001)(5660300002)(2616005)(6486002)(110136005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: f357kJmX2B/b+hqt0fXSyu4WudLWgOCHfyy3p5H/WV4k5uzRodqbFa6yPtKYrZHvbIuKPTc0jGTMbEE1skdwAMjZ/DVsLMgg1Gj3HxOgPRUUjnSvgX/dAGgAUfjImBOnG19tqlk7LZ5jRMm7HvtQRKHM9HrvFf5WTqvDgBr96OnWl5SkGY9yhOK8znjOnJbIhKqVoG7xvFdAS4N1dAAYMbLUUfTMyKoWrJWlHS5kPaT+PIfoXA9j+8Bt0GjG40YqzbGUeuUBfdMqJm1Edn74lNwk6j3uksZHNKAk8afEtMWIOgJGE8pF/XDhjvDhmYOZmr1/Rqrdqvauakewj4cmZrqLVIzm6i51T+Yu5zNf9fylrzSPEx7/8lCZ/qxJSXELA7g1CiKU+tCLOeSMQqKa9SL3Boc9R4E4rpasModOwqytfa/IDmRHT0f0n9B9gFNn74MZibpXQTR+c6KqMjpo1kUSvZbVExgl2o62ebdpK7OVBkEawbkPafT+HCVdnnYTuWjF+IptHlj0A4QQI/qHSA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 927e0673-ce1e-45c7-2884-08d81e469707
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 05:13:00.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBgXny7maO0Ol2ChWv1Y+RRu8qkoh+bhzyIVhMlbHvAbvXSlztkAWxZEqJRDIKXZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3414
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_02:2020-07-01,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/20 7:16 PM, Daniel T. Lee wrote:
> Currently, BPF programs with kprobe/sys_connect does not work properly.
> 
> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> This commit modifies the bpf_load behavior of kprobe events in the x64
> architecture. If the current kprobe event target starts with "sys_*",
> add the prefix "__x64_" to the front of the event.
> 
> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> solution to most of the problems caused by the commit below.
> 
>      commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
>      pt_regs-based sys_*() to __x64_sys_*()")
> 
> However, there is a problem with the sys_connect kprobe event that does
> not work properly. For __sys_connect event, parameters can be fetched
> normally, but for __x64_sys_connect, parameters cannot be fetched.
> 
> Because of this problem, this commit fixes the sys_connect event by
> specifying the __sys_connect directly and this will bypass the
> "__x64_" appending rule of bpf_load.

In the kernel code, we have

SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
                 int, addrlen)
{
         return __sys_connect(fd, uservaddr, addrlen);
}

Depending on compiler, there is no guarantee that __sys_connect will
not be inlined. I would prefer to still use the entry point
__x64_sys_* e.g.,
    SEC("kprobe/" SYSCALL(sys_write))

> 
> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>   samples/bpf/map_perf_test_kern.c         | 2 +-
>   samples/bpf/test_map_in_map_kern.c       | 2 +-
>   samples/bpf/test_probe_write_user_kern.c | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
> index 12e91ae64d4d..cebe2098bb24 100644
> --- a/samples/bpf/map_perf_test_kern.c
> +++ b/samples/bpf/map_perf_test_kern.c
> @@ -154,7 +154,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
>   	return 0;
>   }
>   
> -SEC("kprobe/sys_connect")
> +SEC("kprobe/__sys_connect")
>   int stress_lru_hmap_alloc(struct pt_regs *ctx)
>   {
>   	char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
> diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
> index 6cee61e8ce9b..b1562ba2f025 100644
> --- a/samples/bpf/test_map_in_map_kern.c
> +++ b/samples/bpf/test_map_in_map_kern.c
> @@ -102,7 +102,7 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
>   	return result ? *result : -ENOENT;
>   }
>   
> -SEC("kprobe/sys_connect")
> +SEC("kprobe/__sys_connect")
>   int trace_sys_connect(struct pt_regs *ctx)
>   {
>   	struct sockaddr_in6 *in6;
> diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
> index 6579639a83b2..9b3c3918c37d 100644
> --- a/samples/bpf/test_probe_write_user_kern.c
> +++ b/samples/bpf/test_probe_write_user_kern.c
> @@ -26,7 +26,7 @@ struct {
>    * This example sits on a syscall, and the syscall ABI is relatively stable
>    * of course, across platforms, and over time, the ABI may change.
>    */
> -SEC("kprobe/sys_connect")
> +SEC("kprobe/__sys_connect")
>   int bpf_prog1(struct pt_regs *ctx)
>   {
>   	struct sockaddr_in new_addr, orig_addr = {};
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0211445840
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhKDR1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:27:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36614 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233478AbhKDR1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:27:36 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A49k5P6001465;
        Thu, 4 Nov 2021 10:24:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=spZ9uKAxOZ7D8uYcU7x2eFKfnSVRCXNHywCbafo4PcE=;
 b=IXc6Wa8g14G7xgoVlydv6h46/QTvPOOsJHR4qOkr5h/3CmER+E1sJxFSP5OOwn4hUgRT
 kDZZfkdEmluukLKoDsf9vIfwjXw5gU0sv2AtKoEnfPdtvNK5QGi0c+YBPj//nCoIC3UI
 Y72ZFFfb0GtgDHSYxzoBgB26vwHvsjCvy1A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c4d5uk8kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 10:24:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 10:24:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtcuFreOqDS/H1W/0tPXYO8BFe7aBN7CH3Eo5SMN34sri65n6jzeDBpjNPx+0rWa2IzCh/28vCqWPczmfVRN8fckvm1wskx0JDp6NwB+xRQmzbbmN+cQGCa0RhPJEGF2rw5ls5NoZwbHJIAtzELY/lHYDNc05rqIBUPipOXlpdvJSOuUDxpXtKs70I+meFf6W2EOSEpEJRZ2dYeKNvl8521N5UrftF2GcnYyIQ34aD7hdJ9OWUvQmezsAjFm10G16VdXi+kEUkdNrEKx0OUx9PC13tM88Bk11pcYr1Uv8/VRLsjLciGAQ6r8Gdr9xZLU46BRkA0SsOzDnXj/bgoj0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spZ9uKAxOZ7D8uYcU7x2eFKfnSVRCXNHywCbafo4PcE=;
 b=cwHjPijOIS3Z36orbGl+a7XPxVgZl5o7FogB02IqhQee/DatiV/MdrrhBULoen5NIDC/Xdg7IRavuWH1tHEtLCcn7iSm1IoQXw7jjDHuvq5vi3Ev8jOyQqfx0inZp0QsNj+KM11dltxY+0APkQmIQZvkiUsaqJ+9ANYQGJd+wzWPw5x6y85U3HhhI5GnASsUViaefxWSxX+7GGwQ1y8F43ZZvsjXs+5Vmlgj3d1tm0CTYNSoLnKkA4TKnjuEm2XLtkLRw5nZZ4UuNbjfld1GXSJbX6KiQ9eyjkjCcIbFJMOTvdJzhvyTATWYi9vjCEglldoQJ4E4bsorc3ul8BfnAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4707.namprd15.prod.outlook.com (2603:10b6:806:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 17:24:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 17:24:41 +0000
Message-ID: <bf627fc3-7a89-2184-0f6e-e2bd8016759e@fb.com>
Date:   Thu, 4 Nov 2021 10:24:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
References: <20211104070016.2463668-1-songliubraving@fb.com>
 <20211104070016.2463668-3-songliubraving@fb.com>
 <21d8587f-4a27-2966-167b-fa20b68c1fec@fb.com>
 <10CD7450-873D-4136-819B-A1C8F6473E4D@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <10CD7450-873D-4136-819B-A1C8F6473E4D@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:303:8f::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1253] (2620:10d:c090:400::5:e407) by MW4PR03CA0012.namprd03.prod.outlook.com (2603:10b6:303:8f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 17:24:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fe908e0-d64f-4b85-d24a-08d99fb7fcb5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4707:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4707A12D59548A5ED86AEF9AD38D9@SA1PR15MB4707.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHiDvAGr4tT1y3llDBQlqEBqOD+f+sZfgfCUilgpWM5xZ1dtYJcLujtYdI612yafSWXBdLCrHZFofegLKNj1Ci1vBSugeonblcReBn1BLJjMRR2zWwlyfnuPVC3jhtHyOEEfLajB8P2rOmCGHq7ZhPewVN9z1Qv98YAWRWin5rMFh3s+4oJsyyUdLmVZfxAjE+8OHRW4NndirNxh1iwpPSxgLlqx1Hugg5DHvCpmt4QcDhtcw0M03waVMxjgmrS/DWV3D+RNHJKigZ+s1flEEc8SnAp6a9r2bUokALbzg5PJqudlZUc2PeIr2NrdUYnL4aUq30xdSiu4Vf9MX0QWRXiz7t9HvJB9ubXgmtIPr81Xvd0B+LZQOYsU/YU9j5p3KF6t/1eVgBOh05Mf65XZj3QFchVGPBPR2Rn3gjk9Nh9Rqku69f5eFUZ1bwBErvCuVPoLVyvo5JDNoXRdSBqHdKMokUSpub2A1z+rlKKGinUK7g3XXhqeDAKmNWtKZfVZiodydR6T5m5ywk58cG8MfvVu55o3ms56Y9HGHHZ67DVOgSrc8HYNVvlxKNK5vRo/cCATsJblI0mJTJtEeg/WKwiVioA8IEAmzRI7LrVZbXQ7lUMjZ3pkVS/yQcj3f2lUcf64K/a0rgKv07jIYRlAYv8d0vvI6f33zXYVLOCQ1cLrY/PWiVuV1Zyob3RKLLBFYF7npskqShurR2fVfos7vVc2XUbX7B3CJ4xF4xAKqdTG67+UH92bfqU9KQYZVwYl80CADLyFEnZkh/aTEznCgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(508600001)(4326008)(5660300002)(66476007)(2616005)(52116002)(66556008)(66946007)(8936002)(6862004)(316002)(6636002)(8676002)(186003)(36756003)(83380400001)(2906002)(38100700002)(31686004)(37006003)(6486002)(53546011)(54906003)(31696002)(60764002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0JKMkF4YlRERS9CZGRsOWYycE5SVHVLblk5VVBrSlAyYWU0ZFVSU1RIZENR?=
 =?utf-8?B?bnFSMElvUlhQOEVhcVkyclFJNnhuVEREZmV1UU05OXFMME85cEVMNGF3WDRR?=
 =?utf-8?B?Nk1WcXQ4WG5hVHJhMXFZb2djOWFaTklSSDFrUHdnS0VtNFdHeHJycjFYTGcv?=
 =?utf-8?B?Sy95d0tkMk1SVGJtYnZZL2hoTEdIUExQd0tJMWIzNUJuN2tHSVFjcWJZZyty?=
 =?utf-8?B?L2NEVzM1d2RJYjhWakNZcFQ4VW1mdU45ZTAvd1dhMmdlcHJ0WHBSNFJpVUVy?=
 =?utf-8?B?OXF3S3R4WTkwZno2OFJTanQ3MW96RlhTSmk5QnFQWjQzOGlUUjkxRGRHOUN6?=
 =?utf-8?B?Qm9RSERTZFIrTTQxVHpNNnVrVUZVSmlUSzJQWWJ4azhDdlMwSlJRbk5tbzBp?=
 =?utf-8?B?aEJQQlkvL0hJK0YxZ0lodGtXMXI5eEtRQjJvUUk0NnlFWDlGZXpSMEEwTGlU?=
 =?utf-8?B?RFFKclNGTkZnK1pzU0RuKy8vYmRFK2dPYzBocjdnQ25NaUZOR2kyZ1lLelM0?=
 =?utf-8?B?RGtyTFhwRzZFK09pTnZHZXN0bGFqSXJNWXNYRHYzRVhIL3FMay9Wb1NIalNw?=
 =?utf-8?B?WWtMa3pXckRCQThvTnE5YlZBQXZtb3Jvb092aGFOaWZPV09vK3BmZ0pLRmdF?=
 =?utf-8?B?ZUxEaUxoYlBSNzA1M3NjUGN6THFLdy9IWVIxd3ZMN2llRVovUjlMVkJxNVNt?=
 =?utf-8?B?SVhoZ3VRdUYyd1VOdXU5b2VYV0s4MysvQUxVVjBKQVJ5YUhGTlNoTER1c2M2?=
 =?utf-8?B?S0tqR0NBRlFXL1RYNCtLOEM1b2hlYm5QdUxYeENscDZhTjBrMllKc2JBOG1B?=
 =?utf-8?B?K1l3S2ZaY21Id2lkM3o1Z3daWFdmVkV5ZVRBRXVkTVVXZUx2NFQ1THQzVlNh?=
 =?utf-8?B?d3kxang5SmovTVM5ajdVMnVlbWVFdDU4WWgzODA0cWFFQVFuTkFPektmTU56?=
 =?utf-8?B?WUpQeVNJYnVyd2JPL1hiY3dRZHA0UmNZUWZtL0I2WkliWmZ5UE1CWEhZaXpN?=
 =?utf-8?B?UFUwb1BsejBCdEpmc082QWloUmc3cVpEYXZSdGV4aGVhaEgvRll2bCsrMEcr?=
 =?utf-8?B?SlkwcmZVa0cydHNTOWtGUGorMFp4d1Rienh6cVpxTjJGV2IvTTdKYUdlcDds?=
 =?utf-8?B?akJnalR5TkhuNk92OG50WXlMakpzU3VObW9sVGgza3NHbjB6bms1c3gxWEl6?=
 =?utf-8?B?WDNUNS9FeWs1dWNNUUJDU0xwTWVqclc3aE5LTDhGcHAyeFZIU1VNNHhhQTVi?=
 =?utf-8?B?em5ndW9BUXpXZlRYaWIxZjR0Smg2TFB0TExpQjdWc3BTTTBnUWE1VXJ1aGEy?=
 =?utf-8?B?TldRU3E2Yi8rU2lXQmJNcm9PWGhIUDRMTXZCMXg2aU9SZ1JaTS9iUndIeXNu?=
 =?utf-8?B?Z29KR3ZTVW5FOHMxRHZreHFYc1ZTMHo2Um5uRnc2Y0pmRDJMUXNCQlA0VnlI?=
 =?utf-8?B?ZW9NL1FrOGJiNkxyMnBJdVA2Ny9oYXdGU2NMbGo0bnBmaUZwUjFoTDlPVFMz?=
 =?utf-8?B?MWVoY2w3SENrY0trR1RIdllkenZOWTlxb2MzcFlaS3dSdE9qVXZ6WVU0OEZE?=
 =?utf-8?B?QUFiZXVMRHF6N1p1aGpsL1czWDJYQUpMV3lSVEsxTnVqWGc2QUFUZ3RuOVlz?=
 =?utf-8?B?TjA3NHhYZjVYT1h6d2doRE1ZVGFnS0ViWnhORkFKbFJWcGNvdG1OUGM1dTJC?=
 =?utf-8?B?WWp2S2syRUlBSVVnZlMyeEMvc0dOaUN3RndLOFVPZ0g3NWxoTkhhaW5GUkR3?=
 =?utf-8?B?blBGcFFQSE1NZktwN3AyRTlDNkF0eHJBYkR6anExbjBqcUUxWTdRTklhSG9u?=
 =?utf-8?B?YUM1MmtmTE9xK0pTYkdVZGZsZm5Ka3dqbjRIRkJaNjdlQzdGNXo1VlcwaFhs?=
 =?utf-8?B?QjFoUVg2S29Wd284RUhWSVRoV3g5MGVEWi9tNUJPaVp1cWUzZHpadlc2ZEJD?=
 =?utf-8?B?dkFUMmgweWI5R1FpSnlyb00zNThlUVBvRThHY2lYa1dOU3ViNXpZUkdrUU15?=
 =?utf-8?B?TURHNEVYWC93TWxMNEJSYWkrTkN2Yi9RaEt1QXlRS3lHK3FiOWlDRWh6MGcz?=
 =?utf-8?B?TWY1VU41cE9UTVJTQzJIQ21kWExRcUdGVURtVUtIMElqOEVzT3ZTd3d3SFhX?=
 =?utf-8?B?Q1dqbVNSVmlOSksyQ05MaEhBRyt3RXlka1NiYmRHRUgrSDcvMGIvTUVNUjFB?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe908e0-d64f-4b85-d24a-08d99fb7fcb5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 17:24:41.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: muodXXMWXqGNy/RK8CZvlTDdXwSBaVBOG73OjhMdFVp93FSDKqIwpSHTEW3BfJtj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4707
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0-mwpwSb-wXAOWE3AjxIkAUn1_adyJ_R
X-Proofpoint-ORIG-GUID: 0-mwpwSb-wXAOWE3AjxIkAUn1_adyJ_R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=974 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040066
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 10:17 AM, Song Liu wrote:
> 
> 
>> On Nov 4, 2021, at 10:07 AM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 11/4/21 12:00 AM, Song Liu wrote:
>>> Add tests for bpf_find_vma in perf_event program and kprobe program. The
>>> perf_event program is triggered from NMI context, so the second call of
>>> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
>>> on the other hand, does not have this constraint.
>>> Also add test for illegal writes to task or vma from the callback
>>> function. The verifier should reject both cases.
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> [...]
> 
>>> +static void test_find_vma_pe(struct find_vma *skel)
>>> +{
>>> +	struct bpf_link *link = NULL;
>>> +	volatile int j = 0;
>>> +	int pfd = -1, i;
>>> +
>>> +	pfd = open_pe();
>>> +	if (pfd < 0) {
>>> +		if (pfd == -ENOENT || pfd == -EOPNOTSUPP) {
>>> +			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
>>> +			test__skip();
>>> +		}
>>> +		if (!ASSERT_GE(pfd, 0, "perf_event_open"))
>>> +			goto cleanup;
>>> +	}
>>> +
>>> +	link = bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
>>> +	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
>>> +		goto cleanup;
>>> +
>>> +	for (i = 0; i < 1000000; ++i)
>>> +		++j;
>>
>> Does this really work? Compiler could do
>>   j += 1000000;
> 
> I think compiler won't do it with volatile j?

Ya. volatile j should be fine.

> 
>>
>>> +
>>> +	test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
>>> +cleanup:
>>> +	bpf_link__destroy(link);
>>> +	close(pfd);
>>> +	/* caller will clean up skel */
>>
>> Above comment is not needed. It should be clear from the code.
>>
[...]
>>
>>> +int handle_getpid(void)
>>> +{
>>> +	struct task_struct *task = bpf_get_current_task_btf();
>>> +	struct callback_ctx data = {0};
>>> +
>>> +	if (task->pid != target_pid)
>>> +		return 0;
>>> +
>>> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
>>> +
>>> +	/* this should return -ENOENT */
>>> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
>>> +	return 0;
>>> +}
>>> +
>>> +SEC("perf_event")
>>> +int handle_pe(void)
>>> +{
>>> +	struct task_struct *task = bpf_get_current_task_btf();
>>> +	struct callback_ctx data = {0};
>>> +
>>> +	if (task->pid != target_pid)
>>> +		return 0;
>>
>> This is tricky. How do we guarantee task->pid == target_pid hit?
>> This probably mostly okay in serial running mode. But it may
>> become more challenging if test_progs is running in parallel mode?
> 
> This is on a per task perf_event, so it shouldn't hit other tasks.

I see. we have the following parameters for perf_event open.

        pid == 0 and cpu == -1
               This measures the calling process/thread on any CPU.

So yes, we are fine then.

> 
>>
>>> +
>>> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
>>> +
>>> +	/* In NMI, this should return -EBUSY, as the previous call is using
>>> +	 * the irq_work.
>>> +	 */
>>> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
>>> +	return 0;
>>> +}
[...]

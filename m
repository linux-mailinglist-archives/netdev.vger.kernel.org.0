Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6785F44B98C
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 01:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhKJALw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 19:11:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhKJALu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 19:11:50 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA07Tm4024293;
        Tue, 9 Nov 2021 16:08:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NDRCj+RN7cMQE1w3IkuPpICzi5VTnTuAscNCT+1egvM=;
 b=PkY2b+GBHss3bdD3iH46mAG9Kv/tdq6tLSLz1KMRY+wnZnEmuW1tNB6t+dtBhCsYffqI
 YvmQvPlR7Ph7yHvlpJAU1AKgFupZQr+wvIP/LZytKkqCebfodpx88kHxoUYauZB6tuRk
 w/jUqd4rlj1AheJjC+7hkYwP2/W2swceon4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c7vm9k2bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Nov 2021 16:08:46 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 9 Nov 2021 16:08:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlk0RQQdf+BGktaNgpMcLBCg49/GGvTOSDd+l72XBdson05Acx/3LKsQ9qTbKfmCu/5zxMh43XGw1/q38X9farBVGEGMO5Kq6o0mcnF9RcJsPqVesxa+/XZjPgCtamAsvfCf6EcIBfvziHQLXLUxNOxI/bjOMjkY9drPOwl3InVy23jZcY/xKU9WswfxUiSW3FhYDrS+WBnxbmnM3WzCdjWNYv8kp0a4N+BEKAcybyndVGLdDRcjV0RzF597ex0AqYRV5a63z1ZH9A4d/xYVo9ArunfbcpihHh0e0jANrS2ZkvfOi7aCtziamXVNI+Kf2+WW/QB266qQ+5yH4nvXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDRCj+RN7cMQE1w3IkuPpICzi5VTnTuAscNCT+1egvM=;
 b=KT9gWwp8/7URbgSVoItHJa6W35Gw/mhSmNQp3XcGfttMwcL6dRE5OxZJWYRyKHS++GJNiZUiHnuqDTIsBePA3QUBpeuqAGlzz0Qq2RzU7/GReRBzr3IcahhQJGqz/BleEypoTszvyhphf3T3XvDrj9P+m22PeLOS8LVXlIuztDErJBIXpakhty2gxD60e9Igs1hUdEKiw3T+yGmNmV1eELTqJQXu2K3E1KKwMvT4igocqG8I4VdnPFuiuOEW4animqlPsLMXZP6sAlYR5MpcMvfUQ/Aw+H8hvwlgHnifPGqu6+gI+hoSUfUBfP9N6BLddecsu7G9/R3vCv0gxHeNvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4658.namprd15.prod.outlook.com (2603:10b6:806:19d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 00:08:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 00:08:44 +0000
Message-ID: <47eb9d22-23bd-2ff8-0639-ed27574e0bdd@fb.com>
Date:   Tue, 9 Nov 2021 16:08:40 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next] bpf: fix btf_task_struct_ids w/o
 CONFIG_DEBUG_INFO_BTF
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20211109222447.3251621-1-songliubraving@fb.com>
 <CANn89iLULCxZ+p-zkZVTLObLvJ+z34nEqS-e3nmA8MK0cKzi=g@mail.gmail.com>
 <F9CC386F-9598-41EA-8B15-D2DF4EB4EC01@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <F9CC386F-9598-41EA-8B15-D2DF4EB4EC01@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:303:6b::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21cf::1709] (2620:10d:c090:400::5:4cd0) by MW4PR04CA0076.namprd04.prod.outlook.com (2603:10b6:303:6b::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 10 Nov 2021 00:08:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3293af1-27d9-4a8f-7977-08d9a3de4243
X-MS-TrafficTypeDiagnostic: SA1PR15MB4658:
X-Microsoft-Antispam-PRVS: <SA1PR15MB465878239F06EC68C8961C4DD3939@SA1PR15MB4658.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koFQoMLOINIG3ucyrhN+YOA8tIIS3X2qV/7C/GRwiZ074jShrKo23+08eYfqvr5SbDjNG9Jqx1ExxweueS+M1vOy+DIUDt+OD7dyXz8yo+oAirAASto67TEkRyIi2xpSQA36KC5yhZVn+zWgjnjPhtvYHEFaCodpOJ2tcZAFCmpqW9wNHVCSQtCpP0FKQWPxzViJPcZC+yudY+CGAPG1KTmHRHAAvKh0Fo45xBHuZXSBC1GjcD0z/ZOFchiiqf4mBeLNkNPlaumHmGBpwjAR96Rt4KV0OoepdKVwr3NchBGyBdApoXVJw0ihoJGPijf0xJ9ZbUDOylA9O2yH9jfZHKHmBdWUerx1AJLz7dF3lQ2KIjN8JIceZj0hmiTaIJgPWlRjBsx6RzB93HReuCTcaUWZ3uGv0do0KpVDKzYRJMucqqaWH86IBlJ+apu5gpNGQD88nOXa7WaMPvXrr/8Vm0h5KWbB8BCXm8PXK79IUJhlo/2NjTh8kieSlRcdgJlvGFWEV3KaTnsBY6XSG3S+/yofF+r/0FZ/yBr4iPq03cDoELO06Owi7ZpFTC5biONsogKe4hAA+VJAF2Z3hSzwMej0a5b36T/ksvMPZEnev8DlDEImXbRmiEF/CRiJM+at3I51xBgSDBo2eYzaPcX9V6bWI8Y0etSbJxkO/vM2baRNC1jgfacSNrvN0MhaDWdBwC2g4ja6E7h+5V0UjkhgeGNcyRrfb19YURtoe/ZNSnTQthOQCz0VNizm49tAfcG1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(53546011)(52116002)(5660300002)(31696002)(186003)(4326008)(54906003)(31686004)(110136005)(8936002)(6486002)(508600001)(36756003)(86362001)(38100700002)(66476007)(66556008)(316002)(2906002)(2616005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjY4dFBBSDlJK29OeERiZ1hOR2V0YjkydE5LTEZjR0Q2aERGQkd0MFZXVito?=
 =?utf-8?B?V3cvWGl6bGhtZnRIeWpXOCtGL0dFVVdTbDNGRXFqMGE1cnU3WmdKWFBOWDNW?=
 =?utf-8?B?Zjdrc0pnb29mcHBycW5NemRsMHhwbEFsaExDOWlreFpuYkpRNlRaczgzV0ZW?=
 =?utf-8?B?SDFjL1hjbVpCMWswSStLV3pRUGJIcy9Rb29QUG5wclhLNncvc1d5d2hETlJL?=
 =?utf-8?B?NEV5VVl0S0VPWGxXeXFWSURuMXdBeUc2SzZDaWoycnRuNnBqZ1pkMWFvWXhT?=
 =?utf-8?B?VGdzY1cvcThlajFHZmVPeFZTMVpMaktlZEwyLzIwZnRVTVJrbFA2c01yK3ZG?=
 =?utf-8?B?Y3pqRXJoRDcwellBOGVGZENzdUVITWpjVGYzUEUrYTdsd1JUOWhSei90aWlJ?=
 =?utf-8?B?MU54eU91VUNjbzJRYzBoY3VwUW14VWI4V0RyVWRUMVJIcktWeUNOMnVpcFFi?=
 =?utf-8?B?ZVhlMGdBUmdrOVFNMXM3VzR4VER5bjdRbkpmaWpuZEMzcVhtK0lUOG1sdzI0?=
 =?utf-8?B?eVppV3RKYzk5bWt6aHBrWlVkem9EaXNNYy83MVVIbHVkc0pmUXFCaldoSitW?=
 =?utf-8?B?akE2aXVwZ1RFUFljNC9xeFVSckFDRU9rS3d2bVgyb1lSRnlnajUyb0FtRGp1?=
 =?utf-8?B?YTRGZHdveTA1K0liRDFMdzBtSjVYYjQ1ZWVTUVExTW1TNGszKy9tZEVuOW9W?=
 =?utf-8?B?SkdtQVBOaXZOdld3eWpVNzBWWEQyZ3Z1T1ZRSWdIMDJqRHorVVBLbDVVdGpa?=
 =?utf-8?B?U2RReGorajE3RFpEYkFidHdEOTkxWkFFb3BYajIweS84Und2WnY5TkZxRGpV?=
 =?utf-8?B?NkV5UlZLVlFPRC9lTzEyMHBnUkdiMUQzQ25MRVIrSldtNnloZnRBZGhGc3d0?=
 =?utf-8?B?M1kvVkJ1a2tyNm9ia3lMdzZ3Z0YrenNqWElROEVIdDhURWZxZ1BUaTJBWmVo?=
 =?utf-8?B?NVdMWXM3bS9QZi9rWk92SEFqdERzUnM5ZkdqNlJaN1lSM0xTYUxEZFZ2ZUp3?=
 =?utf-8?B?ZmwwcGVKeWhRTDhxWUZUZVhVcElVSmYrUkZ2ZzdSK2lXTGRsUk1YY0lURDVo?=
 =?utf-8?B?L0k4TFZKcUZreXB5bnRiZWdTc2hIVjN3REFEYzl0NmFnQ2RMUUZzNWJLSzVz?=
 =?utf-8?B?cWp2T1hkMkszVUErSnJWbnUzQ3owdXR5N1ZyeWNtSm5PMGdZWWpjMytMMzRL?=
 =?utf-8?B?MVBCSXl5c2pYcTVNV0Q2Q0RwM1VPUzlPNnJNVFNZL21XSUhIN25SQ3RsbHZh?=
 =?utf-8?B?WU1oS3dZWWlXdXdkM0lPcU44WjE4Vmxob2dmd1Q3M0NwQ0REZGF4V0VXeUUz?=
 =?utf-8?B?WWVKZy9qS2dzZUJjcHhZaDlieFg1Qy9udmZsU0N0ejcydnhRNnJiaFErR1B2?=
 =?utf-8?B?TlVGMFJkWElqU2JUNmx0ZEdZQkFINFlSRWdNRVdyZUswYVU0aWU2Z0dOYVpo?=
 =?utf-8?B?SUlZM0l1a2lhL0tMZkF1NzlsSmhKeVFVYTc0NjZOeUNVQ3dvNkZnT0FaemlM?=
 =?utf-8?B?QnRPTEtvZG4rL2wyUURoOElKMGdzaHFQNi9lOTNtYUJtM3o2RjU4Z1FaSTN2?=
 =?utf-8?B?SkZ2Yy93TC9QeWZRck5mcmVTWDBRbWR2RURXWUJaMXk5OWtoMG1obDAzU1cy?=
 =?utf-8?B?TjRRSUFPSUdUTTFXb2VFMHI4ck0zVXNYbUx0UkxZZnN1aDV2MEM3VTQ3Wndq?=
 =?utf-8?B?Z29HaU5ZL2ROUkE4QXU0bERxNjBRT2J3UjFnb0wwZkQ3TTZqVjBXNGtSRGEy?=
 =?utf-8?B?N2JvMnd2WWdIT0xWcWtiL3Y1eTlZWTMzTHhFT3JKUlgzNzdyQWw0bzRJWXFV?=
 =?utf-8?B?aktJRE8zdEdMRER0TmRRNnhhalVSVUxmalNNbGRZcW5IWEhJYTEzZzhWcHdK?=
 =?utf-8?B?Z2JVSU1wYUplOGpIaW1OM3VJU0s0eDBuVWwxOUhzMS9DMEI4cDhNMGtHRFVS?=
 =?utf-8?B?U3VhYmZwTUFqVU9WOEZTWUZtejNqN1hHbnYwM01hUmFHVzJYTUhMQXVoL2xw?=
 =?utf-8?B?elkwRTZpU3grLzk4cW5YTytPVFIxaDFlVXVxVEpRR1pnaUl6R3Q0c09RbEFl?=
 =?utf-8?B?YXNtMGVGZEZsaEwwMVNLL1J3b0N3UUdQNkhjNjQyMElMcE8wWFZYMHdVdVpC?=
 =?utf-8?B?WTFBYkdkVi9yM0tQdEJxWVRIekoyNTZlT0FuVUQ0cjEzbDRkNFdYWXZ3U2tI?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3293af1-27d9-4a8f-7977-08d9a3de4243
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 00:08:44.0770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXMwkzhOdC8fFRm9765oIaOeTiVJWr/idEHI6Vqfz0IKhDWYzgY5RlqIuu7rdc2y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4658
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Pdxo62PEq2Iw_WuKUhYogyhTl8XCI85i
X-Proofpoint-ORIG-GUID: Pdxo62PEq2Iw_WuKUhYogyhTl8XCI85i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/21 2:56 PM, Song Liu wrote:
> 
> 
>> On Nov 9, 2021, at 2:38 PM, Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Tue, Nov 9, 2021 at 2:25 PM Song Liu <songliubraving@fb.com> wrote:
>>>
>>> This fixes KASAN oops like
>>>
>>> BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
>>> Read of size 4 at addr ffffffff90297404 by task swapper/0/1
>>>
>>> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
>>> Hardware name: ... Google Compute Engine, BIOS Google 01/01/2011
>>> Call Trace:
>>> <TASK>
>>> __dump_stack lib/dump_stack.c:88 [inline]
>>> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>> print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
>>> __kasan_report mm/kasan/report.c:442 [inline]
>>> kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>>> task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
>>> do_one_initcall+0x103/0x650 init/main.c:1295
>>> do_initcall_level init/main.c:1368 [inline]
>>> do_initcalls init/main.c:1384 [inline]
>>> do_basic_setup init/main.c:1403 [inline]
>>> kernel_init_freeable+0x6b1/0x73a init/main.c:1606
>>> kernel_init+0x1a/0x1d0 init/main.c:1497
>>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>>> </TASK>
>>>
>>
>> Please add a Fixes: tag
> 
> Will add it in v2.
> 
>>
>> Also you can add
>>
>> Reported-by: syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com
>>
>>
>>> Reported-by: Eric Dumazet <edumazet@google.com>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>> kernel/bpf/btf.c | 4 ++++
>>> 1 file changed, 4 insertions(+)
>>>
>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>> index cdb0fba656006..6db929a5826d4 100644
>>> --- a/kernel/bpf/btf.c
>>> +++ b/kernel/bpf/btf.c
>>> @@ -6342,10 +6342,14 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>>>         .arg4_type      = ARG_ANYTHING,
>>> };
>>>
>>> +#ifdef CONFIG_DEBUG_INFO_BTF
>>> BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>>> BTF_ID(struct, task_struct)
>>> BTF_ID(struct, file)
>>> BTF_ID(struct, vm_area_struct)
>>> +#else
>>> +u32 btf_task_struct_ids[3];
>>> +#endif
>>
>> What about adding to  BTF_ID_LIST_GLOBAL() another argument ?
>>
>> BTF_ID_LIST_GLOBAL(btf_task_struct_ids, 3)
>>
>> This would avoid this #ifdef
>>
>> I understand commit 079ef53673f2e3b3ee1728800311f20f28eed4f7
>> hardcoded a [5] value, maybe we can do slightly better with exact
>> boundary checks for KASAN.
> 
> I like this idea.
> 
> Yonghong, I believe you added BTF_ID_LIST_GLOBAL. What do you think
> about this proposal?

I think this is better, so we can have a single place (btf_ids.h) to
have #ifdef CONFIG_DEBUG_INFO_BTF.

> 
> Thanks,
> Song
> 

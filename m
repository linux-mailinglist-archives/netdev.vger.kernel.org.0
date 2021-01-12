Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB4D2F2581
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbhALB00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:26:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7836 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbhALB0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 20:26:25 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C1PSEv010820;
        Mon, 11 Jan 2021 17:25:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QJA/BXItb0HnPtMiRGwD6AHcb2Z99nxR1d6aLfprVtA=;
 b=MAOVo+Jvb/JLX5K3JDHQmT16EomCwF/0/fNBuyT+tw6mXfUuznrsi93vLTEL1s2mXeS7
 vPGnCKeny5tT0gZa220uwDehQS5O14PSqc3kGpgZFRlFOM6NfPuxgN07xk4zt0oQK0Uk
 wV5UeJkkuIEcd+LRw8gerust8U4F418voeY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywp982xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 17:25:28 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 17:25:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGV5LG3WhW2ddQtwGCEyae0bFMijc44SnJAx0RkUeWOTVEk6UGgixQGQnvShOYZ9xMtY9h3HdLnjBQZBJh7OfsM5kN6k5GNvDQm2pMGJfQvWzsoTTGfWTR61o3tKbpZ7SqA/vecnKCI4p+kUDNRa87Z+IuXcYXsmb/PAn5kiNc3ZTiM1mrpui0IqaRp0E36JgK97l/krqQhancncHYwtErC3oWJTsUwqOkJxadobM7Vqpd0e8hcmZhVnTJM1mPSUA37MiIWCbULmHfclimSAnD+2DeevZ2TXSkuTEyZzPnR99xJk6yjR8VfWJGokUzralAkVmJwoY9PYqqhlWdouhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJA/BXItb0HnPtMiRGwD6AHcb2Z99nxR1d6aLfprVtA=;
 b=I/PjwTNJV8wXYkxwO5OKL/Hr4P0kpJcTRBeKaUmhnZJkT0CsncIalTXZL3mYbphnS559IvPS9e8bUbHqROQj9onDVwgrjJS5UUnruqm6g4evqzg/d9th+I7Bh06pezs5rrJ98n5QL6nOXyy8e2odVUKpYf1CwvEoIDyAKjt2kQ7dCAZyGGSvlcXrLho3EYo4FVe+VD45MNN8YnQMcIiTqG7VunaOp8CxyKghStidVp9MN86u3ccMCiFwRsxIMxggK/WHtABVOJxiiOja5wn7pQ1OZm8WDHRtAPrdLsfC7xo88S9WVY1gvNVcfGaBaPKJ6Th67VLBvEHgGd5rBOjUpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJA/BXItb0HnPtMiRGwD6AHcb2Z99nxR1d6aLfprVtA=;
 b=ELXGhcXQ6vQfW6TcqhXmQwQee7xpQZZVR8C/+Y5NwJPHBSTMN5GI+SUFEbWGCweFy5CWCHUnPkrFuCaVlMy4rcZM9Xewq1xO2BsJm7fs9udwwtSBxLBbebSdIK/EfHcxOx+FC9XTN6oUiuaqzxau01rS/0uHBf1py/vmKBhqOFU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3302.namprd15.prod.outlook.com (2603:10b6:a03:10f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Tue, 12 Jan
 2021 01:25:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 01:25:19 +0000
Subject: Re: [PATCH v2 bpf-next 5/7] bpf: support BPF ksym variables in kernel
 modules
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-6-andrii@kernel.org>
 <b301f6b8-afed-6d55-42d3-6587b75fadb9@fb.com>
 <CAEf4BzYtBXr_8HnQEcHn9nQfmMzq_wfdF3jFWzFtOpSF1Uwfug@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bf8a6fb9-40fd-7037-dcfd-24595b691c8f@fb.com>
Date:   Mon, 11 Jan 2021 17:25:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <CAEf4BzYtBXr_8HnQEcHn9nQfmMzq_wfdF3jFWzFtOpSF1Uwfug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7b7c]
X-ClientProxiedBy: BYAPR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:7b7c) by BYAPR05CA0084.namprd05.prod.outlook.com (2603:10b6:a03:e0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Tue, 12 Jan 2021 01:25:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9aa13622-8284-4b85-0299-08d8b698ec8f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33027EF4F0B6E2305AF28332D3AA0@BYAPR15MB3302.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06154sv42FvA3AbDOWvCb8zLELQ4+6JysvFjjokrPNt+8CXM53xcnPqdhQUnCMY2qiLv5tcHhE/OeoxcF59rg5I2S37DolwaHF7OQGDAULTevHncE9vprcZxsuAFcZw3YVZ29Af2boTgsG/Bwvf0iE/Pjc+a+McJ3dx1bz8IjT1p8auA8hPZUHNRW9xrmAYyyCCmubh3zGVLv7v7JL8WKy6nfHGFP9BTRGvyxvL5zp0PzXxin/n2AXI6itb30cor//asFbsKhaeSUor7acegFhHOkUGmQBrehwqHPKFafImHBXyPUbXeR0znPnimWphIsDcP+a9oj19zAoIMKPFj+/p0Rf+U1L3PkrU6yQgaNtelNRM8V94hSGLFJir1dPjlJcAc45WbAeKK5S+9x3hgI5nYKp0o5sufzxEIkj+q2NDKDc5nZnKS1P4zjqbUzY2ABjPW9k0c/FL2NfrzC5JmXPgMLnSHCgGp0S/WbCdBLKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(376002)(346002)(366004)(83380400001)(5660300002)(8676002)(52116002)(6916009)(2616005)(186003)(86362001)(36756003)(53546011)(31696002)(66946007)(316002)(66476007)(6486002)(54906003)(31686004)(4326008)(2906002)(66556008)(16526019)(8936002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Rjg4OS9zYjNzYkJqR1NKQUhMSktrZjUvVzUvbndZUFVZS2YwZkZFckt0eE1T?=
 =?utf-8?B?WVhUS3hJZFpXOUl6by9oLy9PTFpYVXh3MFp3TlRtVzhFUmVPbGZXWjllSktF?=
 =?utf-8?B?ZFBiUXlFcHR0N0paTlh0VjhXU1RlSFRNV2xzV3ZHakxZNVRyYk4wZ2s2SDhL?=
 =?utf-8?B?SEYxSExQeDJpSGlCdzFQWjhRTWVVSGJpekNMNGM1WlJmdXpWWUtqSU5MVkVN?=
 =?utf-8?B?cjQ2VU52dnJrVWM0K2VlWndaL3VNckNPTFU3VG94VTZsVEJ6ay8zdFBzS05S?=
 =?utf-8?B?Z3hibk9hd2FUUHZBZWw2MFhNWFBhVi9xckNBTmhxTFdQTWpaZFdlTUFVbUFU?=
 =?utf-8?B?NzNZQzl0bDVYNDhJZ2VJVWdsRzZwNFBnckp6Zk1RTnhTbzB6MkFrSnZvcVdk?=
 =?utf-8?B?OXRqbmROcWtyL2RPRWh2dXZjRnFZZVZiTktxNmtNQ2piem9sM2hpV2hBNlI4?=
 =?utf-8?B?UUNFQ0hTaTdWNmR5TDFjY0VUa1VuYXlFanpnS0xtbFc5Y0M4REExRmpTRnpU?=
 =?utf-8?B?ZUxBdTkxd3AzSi8vS293cGZMT2Nabm8wdDd2ZVF1YVptaUdHNVR0SnBQbE1E?=
 =?utf-8?B?LzN6ZnVGRS95NDJaTHNWNmJHUklKWDkxZEtYQ0V1NmVrYVlybVFlVHV2aytU?=
 =?utf-8?B?ZUVzdHJVZ2dMY0MvUnpUSGpmejY0WVRoWDc4OHh1SXJhekpvdGd4aDgyUFhK?=
 =?utf-8?B?V0dkRC9SRm9IRzVVamlOV3I4ZU9mVXFBS1VEL1lRTzRCNHlDcXN5eVlEYUJS?=
 =?utf-8?B?RTZzWVVsN1NNc0lnUXMzOGplcEt0TzI5M1VrZDYwQ0VlWi9Cbk5waERSL3Z4?=
 =?utf-8?B?THJYeXRFSzVFMm1sOU8vMk9sOHhnekJ0RkI0RE1jVWtFV2RlTDFrYldyOWNx?=
 =?utf-8?B?ak04d01yTXVzTzFoTVd0bUFOQnM4K3NHYU9GUE5vTlpsRnZyeU9xT3p6a1Vm?=
 =?utf-8?B?UXVYa0dHZWVSeTRUVkVzTS92SmZmMExGWS9BbnRwWURnMm5BVHF0VUpybGhk?=
 =?utf-8?B?RGtwblNXZGRpKzBoWUJRMGpxTHNENWcvZ2ZKd0M1YkRNdmdDWm03WG9VWkox?=
 =?utf-8?B?MVZxb1dqa0lZNkszTjgxRktjZWVocDhEN2RUMmhWUjBNdFpBb1g2NFl1SUEv?=
 =?utf-8?B?NjdENkQ0VUF3a2JoZnJWdEQ5MUlieXpjV2hxWEdLWDlwWmJ1ZjUyOS8vVlVw?=
 =?utf-8?B?MUFPbEdWWDNqM2YvZWZZV2VJTW5jZHVlUSt2L0MyWWhBTDlvcVd1c2RyeHhW?=
 =?utf-8?B?RU1pbWRMR3hJVGt6QU16QnR2QjNQU2wzdVhya01pa1lEMlkxVXcyMFlNdkZC?=
 =?utf-8?B?OUtrcytHR2pXb0RXejNyRFZGaDhUSGwyUVhySE95aUFTVTg0RURTZmduNW9R?=
 =?utf-8?B?Y3BIa2JMVHJCZWc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 01:25:19.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa13622-8284-4b85-0299-08d8b698ec8f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcdChA7ps9/V/DW9msI80Zdhc+suWfJ3UUBS7HQlE1+o55VI5ngoKuIwHNbMDZpV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3302
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 1:29 PM, Andrii Nakryiko wrote:
> On Sun, Jan 10, 2021 at 8:13 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
>>> Add support for directly accessing kernel module variables from BPF programs
>>> using special ldimm64 instructions. This functionality builds upon vmlinux
>>> ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
>>> specifying kernel module BTF's FD in insn[1].imm field.
>>>
>>> During BPF program load time, verifier will resolve FD to BTF object and will
>>> take reference on BTF object itself and, for module BTFs, corresponding module
>>> as well, to make sure it won't be unloaded from under running BPF program. The
>>> mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
>>>
>>> One interesting change is also in how per-CPU variable is determined. The
>>> logic is to find .data..percpu data section in provided BTF, but both vmlinux
>>> and module each have their own .data..percpu entries in BTF. So for module's
>>> case, the search for DATASEC record needs to look at only module's added BTF
>>> types. This is implemented with custom search function.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>
>> Ack with a minor nit below.
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>>
>>> ---
>>>    include/linux/bpf.h          |  10 +++
>>>    include/linux/bpf_verifier.h |   3 +
>>>    include/linux/btf.h          |   3 +
>>>    kernel/bpf/btf.c             |  31 +++++++-
>>>    kernel/bpf/core.c            |  23 ++++++
>>>    kernel/bpf/verifier.c        | 149 ++++++++++++++++++++++++++++-------
>>>    6 files changed, 189 insertions(+), 30 deletions(-)
>>>
>> [...]
>>>    /* replace pseudo btf_id with kernel symbol address */
>>>    static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>>>                               struct bpf_insn *insn,
> 
> [...]
> 
>>>        } else {
>>>                aux->btf_var.reg_type = PTR_TO_BTF_ID;
>>> -             aux->btf_var.btf = btf_vmlinux;
>>> +             aux->btf_var.btf = btf;
>>>                aux->btf_var.btf_id = type;
>>>        }
>>> +
>>> +     /* check whether we recorded this BTF (and maybe module) already */
>>> +     for (i = 0; i < env->used_btf_cnt; i++) {
>>> +             if (env->used_btfs[i].btf == btf) {
>>> +                     btf_put(btf);
>>> +                     return 0;
>>
>> An alternative way is to change the above code as
>>                          err = 0;
>>                          goto err_put;
> 
> I didn't do it, because it's not really an error case, which err_put
> implies. If in the future we'll have some more clean up to do, it
> might make sense, I suppose.

You can change label err_put to btf_put, so this way, btf_put() will
only show up in one place. But I won't insist on this.

> 
>>
>>> +             }
>>> +     }
>>> +
>>> +     if (env->used_btf_cnt >= MAX_USED_BTFS) {
>>> +             err = -E2BIG;
>>> +             goto err_put;
>>> +     }
>>> +
>>> +     btf_mod = &env->used_btfs[env->used_btf_cnt];
>>> +     btf_mod->btf = btf;
>>> +     btf_mod->module = NULL;
>>> +
>>> +     /* if we reference variables from kernel module, bump its refcount */
>>> +     if (btf_is_module(btf)) {
>>> +             btf_mod->module = btf_try_get_module(btf);
>>> +             if (!btf_mod->module) {
>>> +                     err = -ENXIO;
>>> +                     goto err_put;
>>> +             }
>>> +     }
>>> +
>>> +     env->used_btf_cnt++;
>>> +
>>>        return 0;
>>> +err_put:
>>> +     btf_put(btf);
>>> +     return err;
>>>    }
>>>
>> [...]

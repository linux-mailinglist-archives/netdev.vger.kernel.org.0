Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873F9369C13
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbhDWVhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:37:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11880 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhDWVhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 17:37:40 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NLT8u2018955;
        Fri, 23 Apr 2021 14:36:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=l9w2uH6A9LaeKYAsyEL3WcdMJqDrfl0PttUMCwzRlCE=;
 b=MDzJZ4NdSQn+o8+/jC142rEaSbysPAFvFVLwb2Q5Bkl83QHj7b6pSO1vrGd/GaYKBGLb
 AecVe+LmeHsNe/SGdTJhunmMs5G2Db2JVfPAD0VY6cFFEsSFcZdoMeUGNjXEd0o7CHCX
 WHM7J20JJ9CnaD/IB0k920VBZMBdosBhK2Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3839ussk60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 14:36:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 14:36:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK+MriZCVogtqXC70UqN17Sgqn+ZwCR6xaofY86fmXr+oE+eQvRQCB66mPnFMtc1uoJh9PPjKvsrs0jWzvfrAAgqj6mr3s0PW+j7MB+YurNvX/UtRCFiIfTLSugvIE21gNPfzOIw+/+Igpwo0mY/uOAjiE39JHDP5tU7BRI/9R/6P2oU11/SSBgj0MWjR+ipu52BwRTEhaTM6yqf870sF6UorBuw6/TmCuol7L0LWWu18MUjI3xaHivwBAWtC/DMIvuCgFo0bGJO5aPOuuONmtxegZhckpHq7SU6ooC0arnP/Q5ah25vSlYZrh70MLeD1Qrkdpmp0MLY4w9ybP4rUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9w2uH6A9LaeKYAsyEL3WcdMJqDrfl0PttUMCwzRlCE=;
 b=YMU3anMutVwkunFRSfbqh+GWqD55e/0cnzpDK7ZwL3LLvdalYXOHcHx+U3hF9vGnpeHvfm7jMjm+izBQO7eKlk1ch/KHAU2a5HeoOIEq9OEpOqYE3ir+k+V776IzhCV69VlrVKTkdbiTXL7ZXmAAMlzWUJcTQq8HQuCv59OfW0u0PlgK5mPkJ3g8zk4k115XIzfb+XM13kIcmBXQriaEBeW9NUfaHhkHDkiHM1r0EG7KTKPV3OvktWjXxez529F0gBJ16vq528nuZYs5zVnO+R6c30bDay/57zw9MjBlEtGoAhQ0UhT01Tq1VRBQzjvHkofTaKBffGDmJ3aVBvsq0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4224.namprd15.prod.outlook.com (2603:10b6:806:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 21:36:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 21:36:46 +0000
Subject: Re: [PATCH v2 bpf-next 00/16] bpf: syscall program, FD array, loader
 program, light skeleton.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4142514b-3a0f-f931-9a8c-fb72be9c66b3@fb.com>
Date:   Fri, 23 Apr 2021 14:36:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d0ec]
X-ClientProxiedBy: CO2PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:104:6::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:d0ec) by CO2PR04CA0094.namprd04.prod.outlook.com (2603:10b6:104:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 21:36:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b7579c-a99e-4209-31ad-08d9069fe552
X-MS-TrafficTypeDiagnostic: SN7PR15MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB422415EE12673DA890E58EC2D3459@SN7PR15MB4224.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ARw32N+JoDk+x1qoCR/cPSay1AqY8JiFWnILctPaE9hLwSpwxL1IFFpCfbDqESI6EUqC11ntqmgomGyAhbL8yr2JvLDgHxvC5sSMMG0FGHMHiyr3Yf3axJVr0HLPvua/aDj0RXAbdvO3rfB4mKOsItk1cw3REmGCurzB6YpcCOFjcwWbEWi2IEsNxh08uUCcCukXB+E3JJiwam4VwAqoUTD4yUFMRxlUGWRuWpBiRt5qx/eskhzb1s42xh/OH0IY2BoBQiFNDSQ1mrxuU/XNX6CjwfzQk5m6J9JHxM2CBaMpvqQNF+CT3ZsL7+8KEPwy94J4zWl7wEZaZUDy+7/Bh4KHH31XG53Q/bjFp8TnCjmUhW9vazkuPC/nOE8CIWB+JwmEhRHrPmqYjj+oygdmuabh/1bR4gRhpsdQaUeB57ljHO6xnApC4/EUQVWzMa5Ba1oJNwT5ex7Ln6yfUf4eBLhVFdkOCTfooz8B80d37Bgnioz/lKlfcpek/zfbQJ4QME6oD4pBY7NkYEA/HLB1poozr4g7Z9Hmybo2puemf1XUjIkXCspYKMBY7VKtaBJ8llfQ3jEW8BqJNIp5W4rjvpWu2Ans+R9sRTkgNHsGHiTURkXe4cuTuHEF+hU2onKcko1Vs4MxAHXFB0yLwbh5hYFabYM7TDvrykAhLjMD9TD6P1kRRDFVhCb6Mka6S1wQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(16526019)(316002)(8936002)(186003)(31686004)(5660300002)(4326008)(36756003)(6486002)(2906002)(8676002)(53546011)(31696002)(2616005)(478600001)(66556008)(83380400001)(66946007)(52116002)(86362001)(66476007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RmRFSlAzU2VhRE1LVEdiS1IvWFBtNVpYRnpUUUMvZW9yMkJhWFgzYkhtSlhP?=
 =?utf-8?B?TDdSSS9LbWI3NHhIWGU4MmIyZmtnU2RDeUtjc0Fubk9IRjdMbWRDUGt5THVs?=
 =?utf-8?B?ZXJzWEJTdjJqOXVFWHI3eDFpeVNqaVdtY0VVdW9vL3lUMnRDbnc1ZzhFdHhM?=
 =?utf-8?B?R2VyRFdxQjZ2L0NHNWtyeW02WHM3VS9sVHhHODhPNW5keXZLUGxMeFc0RDB1?=
 =?utf-8?B?cnBtN0ozSzAyOFZXYTQ1N3Y5R095NHlkN2FPa042QTVLbEJNV1JxM0F3K2VY?=
 =?utf-8?B?cm5RQUdGT2VNRzJxUW5sS2MyMDhOSFlWQ0hEYlIzRnMwTHJtRmhyeGZLaUto?=
 =?utf-8?B?Vi9yaFFqMGxrYUZGRkN2VG5IYnFvU1g0Sk5pTTNpRTIzYyt4WmQzdHZTUU94?=
 =?utf-8?B?b2hHOEV3Y29YSUpjSjI0SGxYdlptYlpBSTU4N2R4NUJlZll3enNndER4ejJM?=
 =?utf-8?B?R0Q4Zy93d3lRbUtWZkswb2UrL0pCYmZPK3QxTUtWR0VMRkc2emtnRjlTYjRL?=
 =?utf-8?B?cUt1bllHamNIVVVsYTlGbjJiRXUyeFdqYkRmOXpJVDZldGdaT2RnbEU4Ymto?=
 =?utf-8?B?YXBQa29EcSt4WGN1YjVGWkhHeWtSd2ZDZ00vOWFpMnJkeFFLdGhaWnZYTitE?=
 =?utf-8?B?L1lRUzBXUmtGMGhnemIyQVI5enNTMDNwMGNKYUZPek5Jci9vNmxUZnhObXln?=
 =?utf-8?B?cUFmYlM0U21jTVVOdU5BSDNjbWVTTnZWa3B2L0xtOVMrTGRRbk1XY1RRWTMw?=
 =?utf-8?B?OHpyc1NUNEdQRm04dG4wZ3QyT2NyeUdjUzdYYVo1NS8zMlVHK3g5VmJNWDA0?=
 =?utf-8?B?SHJldTVTT1g3QmVuMnlSL0ljeGFrbTdvbFgwQlBpek1JdFI0dTJHaHM3aG8v?=
 =?utf-8?B?M0RLTk80cFZJTlBRaFY4QytvdTMwRGFZRHU3WXBKc2l1alUzOGtHQzByNjRo?=
 =?utf-8?B?cDhwaW1nOHgyNmU2WE9CMEQ1MFpRRDlHWGVXRmJYNExuVjZocUNHbEpQNGJE?=
 =?utf-8?B?TTNqL2ZRTk9Ib2FEdnIzaDJielpXekt6NVBlcUVIblgxMzlWV2gxbWYzV2RD?=
 =?utf-8?B?akR4MkZzeTYwVFBLTndKZHBzbDh4SURMeWV1bkhyLzd3SUdkQjM2ZDFiY1Ro?=
 =?utf-8?B?dmRaY09VcllsTDI2bmJNNWlCV1R6dkNTMXM3dUx1eWZGMEc3T1dNZkFWWTA0?=
 =?utf-8?B?ck5DOTlCZFhiWmt0NnE4aWtvdkdaem8yd2htZUhyYlV5ejhmRnNBczhNWnJz?=
 =?utf-8?B?TW5MOXFhU1ZpZ1BYVWR5VTJpUjJGUllhZUQ4Z3AxUFZIN1pVSFlGendab0Rl?=
 =?utf-8?B?RGIvQTlaVXNXYUNVdC9VT0lWMVROSlBhdjF0QmxPcXRuQjduSUREZTIrY0JV?=
 =?utf-8?B?NzJiNEVJc2htOWhoZ3RIS3RwNEJRMUdiZFprQTZkWUhYeUJOUHcrWVpDVURY?=
 =?utf-8?B?eGdXV1ZDNWhIYndoMUZLMk05cFl3RkF6L25wQVJhUjgzRk5UdVBPc3QvUW9N?=
 =?utf-8?B?bmRDZXoybVVsRVZjYXcvVDdOUnV3Q0xUTVRiWkgvalk5MEJkVFQvM3FRaFdQ?=
 =?utf-8?B?YmFkTG5DWmxTazZablZRSXJJSE8vQzhlM1dVT1lJOUwraXRhL25GWUhaTUt6?=
 =?utf-8?B?RmMzdVIwZFVhSVdFbVlTOHAzeVVTREJQTzBaL1M2R2kzSTV3eXAwTjJJd3ho?=
 =?utf-8?B?RHkvdCtzTjNkbUxCRU9ZNEE2YlpnZkh2clFMWVRjSE9HSGRQd0luQlhhRmxF?=
 =?utf-8?B?Y00xSms3TVFGeER3MEtaZjdURG9XMUJYRDhGVlYvNDJmdVFVb24rQnIrcWFT?=
 =?utf-8?Q?fbAZ8a0N1o8zIXnvTRKGbX9wbasUo/Ufnd7sU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b7579c-a99e-4209-31ad-08d9069fe552
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 21:36:46.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5E0tiJhTtpRHA2ho6U+rLT/AtRPEWvgrUy54RAtiWnxl4nZIlHWX/4li7sHAObH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4224
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 8PSIs7ZBr1AB9522ZetyF703PyNI0h9a
X-Proofpoint-ORIG-GUID: 8PSIs7ZBr1AB9522ZetyF703PyNI0h9a
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_13:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 5:26 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v1->v2: Addressed comments from Al, Yonghong and Andrii.
> - documented sys_close fdget/fdput requirement and non-recursion check.
> - reduced internal api leaks between libbpf and bpftool.
>    Now bpf_object__gen_loader() is the only new libbf api with minimal fields.
> - fixed light skeleton __destroy() method to munmap and close maps and progs.
> - refactored bpf_btf_find_by_name_kind to return btf_id | (btf_obj_fd << 32).
> - refactored use of bpf_btf_find_by_name_kind from loader prog.
> - moved auto-gen like code into skel_internal.h that is used by *.lskel.h
>    It has minimal static inline bpf_load_and_run() method used by lskel.
> - added lksel.h example in patch 15.
> - replaced union bpf_map_prog_desc with struct bpf_map_desc and struct bpf_prog_desc.
> - removed mark_feat_supported and added a patch to pass 'obj' into kernel_supports.
> - added proper tracking of temporary FDs in loader prog and their cleanup via bpf_sys_close.
> - rename gen_trace.c into gen_loader.c to better align the naming throughout.
> - expanded number of available helpers in new prog type.
> - added support for raw_tp attaching in lskel.
>    lskel supports tracing and raw_tp progs now.
>    It correctly loads all networking prog types too, but __attach() method is tbd.
> - converted progs/test_ksyms_module.c to lskel.
> - minor feedback fixes all over.
> 
> One thing that was not addressed from feedback is the name of new program type.
> Currently it's still:
> BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */

Do you have plan for other non-bpf syscalls? Maybe use the name
BPF_PROG_TYPE_BPF_SYSCALL? It will be really clear this is
the program type you can execute bpf syscalls.

> 
> The concern raised was that it sounds like a program that should be attached
> to a syscall. Like BPF_PROG_TYPE_KPROBE is used to process kprobes.
> I've considered and rejected:
> BPF_PROG_TYPE_USER - too generic
> BPF_PROG_TYPE_USERCTX - ambiguous with uprobes

USERCTX probably not a good choice. People can write a program without
context and put the ctx into a map and use it.

> BPF_PROG_TYPE_LOADER - ok-ish, but imo TYPE_SYSCALL is cleaner.

User can write a program to do more than loading although I am not sure
how useful it is compared to implementation in user space.

> Other suggestions?
> 
> The description of V1 set is still valid:
> ----
[...]

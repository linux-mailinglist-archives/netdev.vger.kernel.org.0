Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C282F259B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbhALBfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:35:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbhALBfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 20:35:36 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C1Sp2t003312;
        Mon, 11 Jan 2021 17:34:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HvahM3fa5WSOlHWkSGgQoQ8WrdUSl11vrnutixj2pDU=;
 b=A4N3L+PKCVkeSTuULoos+NKFwRGrDYUzIwWZzOw8M3It4RJ7rBPd+7vGFBZKBmrxu6y3
 /ifa0HK0sMdHNUn9tFlgUKL0WmCd5T+k4q9M50bNPR8FKPhhhdqs9DAcR+MsOZ0+iWhC
 PY4p/jBGu0bOc1UsPwFBOUcSqVBC8Cpna0k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywdbr7fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 17:34:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 17:34:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV0sdolxwENXhDZZBJzZUHzVoJh40zXCQImmQHpAqtq9/JYtLPmioDxArkEdKbhFuIeGqFCrGnpra9bTpubERdOyxrSJ9RWFZCB0xpO7yrlljoootZ8P+RSRmJ2avXWbN0+LMuz7UVcDXHBMPW2dzx23VgEdld6H9gB9Hi7wM7d2i9aA2quLZ4aoUCJ9FOyCLhUD9m4UapmONs5mRMpPQeefSmmoZPCqzJSRoON6q4PQ+Zcj8aGmX9w63NTm/B3I38NSTEHOZpsYWOmxaTSEmSE8kYtKdM0x0Qab7AIIsIvUBBB3HJvzgTiRch1zDzKe5tCMAP3NjaOOgFCe7E6LEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvahM3fa5WSOlHWkSGgQoQ8WrdUSl11vrnutixj2pDU=;
 b=CeZCblV75NsvOJZxBz1FWkQRQT+8N0xxyWnEnsMjik97v9M2Sqt3zogujC1C1s4C9oWai/i1tjBO6yCmroir1L+BE8wGUpEjtF5T/DUDAH+ULJ3dHK+NTgwB8E7Ze44ZFJDP+OAK7cYWpFV1wOeIA4R3ryKKB4WTYt6wpWd7GMtiX3B82GNPpzrsrCrfWOdV0T9SElOPOKCt7knURnQKod2sYZoYeVb4MYTz1aHepAhV5zBlXf0yY9yD+wHAU12J4/Peh4gpYov6nx0Xr4AQ5rFiKibyl/dpBHuF2lcbuPYfSF1F03/Cw/Guf3Teck+d37BXY3asaFYdnibEsyo4jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvahM3fa5WSOlHWkSGgQoQ8WrdUSl11vrnutixj2pDU=;
 b=g60a+x08wmU1OPGhg0ZAOSlssDlBCBK39Xqch3kczPBoUz2XpGGNAkcdwYGW7lBGygAlO+1vIUnDl0e89doFf6qToP4aKODc7ezhOVMWoNwPLISupm2MI7ob+3k3c2XKGRoE7dp9tvnfr7xuqGeumUcYrI//oZwpd297JXEis1o=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3413.namprd15.prod.outlook.com (2603:10b6:a03:10b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 01:34:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 01:34:32 +0000
Subject: Re: [PATCH v2 bpf-next 6/7] libbpf: support kernel module ksym
 externs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-7-andrii@kernel.org>
 <dc1a06fe-f957-deb8-772c-b4c65042c3b3@fb.com>
 <CAEf4BzZGm9=XGWrj_1Q8ZpxZVhcogZVqb=5yCop2mNgdoTT0zA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b9e91dbb-03df-e7d2-8fd9-25bbc77c5188@fb.com>
Date:   Mon, 11 Jan 2021 17:34:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <CAEf4BzZGm9=XGWrj_1Q8ZpxZVhcogZVqb=5yCop2mNgdoTT0zA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7b7c]
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:7b7c) by BYAPR02CA0055.namprd02.prod.outlook.com (2603:10b6:a03:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 01:34:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecbde767-6565-4bd2-bc51-08d8b69a3613
X-MS-TrafficTypeDiagnostic: BYAPR15MB3413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3413187E397790705FF35F6ED3AA0@BYAPR15MB3413.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tETmS0diSN0ONLuhbtAh+CeH9RxYiee93V92BkX9tuFF5DuTONbcr9AenBNfWjGZCginqUXJEVrbpECUwGGXqmu3xktE0xZk216xW+Y/BZmkR3JZsCiv2bBFE33ShibvLUCFMmnBtnwdBu2TSngjeAo8gzW08soNjak+resoIYhzr70rVXT0yFiLtDGK7hrBcJYfKBg5S3hW1WmyE9PVqDcthKweeMw2OzlKcK6QK5tWiPap9Vezgof0Z/n1h5mwJVRlDS4ZUExI9C/H8CKxQpnRKz1AS6A3NTAtpuaQmG7Czljz6UZT2Htwlo7RUG+JNycfqUaFz1hNtvjWzch8O7sO0AlHlBSaZrI4svNAV0x3PBmM5WBVKMpRpFP1lhGvpcaU3SHKs+/iPk7Kcr03L3BOK6kBKBSa/VxMcLcEtogtacA19FlxNiydICrmNLNKa5uBRiU9LAkVs+7E7FkIirlpvAx0gIj7I7q2pU4GeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(54906003)(16526019)(8676002)(31696002)(86362001)(8936002)(31686004)(52116002)(6916009)(36756003)(186003)(2906002)(4326008)(5660300002)(66476007)(66946007)(6486002)(53546011)(2616005)(316002)(478600001)(66556008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RzVlaU1tYmxKUzYyOFJWcXUvQWJYSlF2by9DQ2tlL0V6T2NZTUJXUXRWbGNm?=
 =?utf-8?B?SXBNcUhYU1laVXRlQjR3ajVlMzRYY2l4aDBSNS9UK3FScTIySXBmR09hS296?=
 =?utf-8?B?ODFCYnNoQnk2L0MzSjMyR3poRWNUL1ZsRmxOaUhXRSt0cTVWWmMzNWp4YUI1?=
 =?utf-8?B?VlNoZ3EzTUMrZTQ1c1RIUERBRjFQSXVwaVE0RlNNWFFOZTh3MmI4MlBMV2pU?=
 =?utf-8?B?MVRNTU5hZURubXRrazZFMzdrN1ZBSDJyaDB5RmoxVGFtNitRL1VuclFUN29R?=
 =?utf-8?B?eWNLNjc4NEQ5WU01Q2NDeE9kbHI1QkhlVFZXNHVLVlJEMHlHYm1pZzhSNDJ6?=
 =?utf-8?B?VUVITTNNdzAvTjM5Q0FwTFBYM3M3ekZZZVNoTC85aytlWW13RkhhRG0vc09u?=
 =?utf-8?B?M2xXYlBwdjFqaW5NNGFxQmUrR1pUaWozTWZhYm5BbzJtOSsxZFN4Q2d4R1Nm?=
 =?utf-8?B?NHREcEw3dUw4ZGdvd3lOcmQ1MFo3T0xiVFN6cVJHRHVDWHJXMThNVHZwVVVx?=
 =?utf-8?B?anB1TDU0T0dlVndHWDRmT0R3N205VWpsN3pLQ1QrbzhQMThQcWkzYkVzWkxI?=
 =?utf-8?B?WHc0eFVHb1BLZ25XRHZVdUdJSVE4d3JiQVZDQVdRTjhscDRHaWRkRzVsWHlU?=
 =?utf-8?B?TTY2TXh4SUV4ZXVlYlZiY0dTcE1Qdm9GTXBJV1AzN05oY1RYK1U2NExScXha?=
 =?utf-8?B?Nis2bzR0bWNiT0JoOXZraHVubEhLejg0WWxYWHU4T1p0ZjMzbnJSYWFtL3NO?=
 =?utf-8?B?QXhnVE91Y2prUDRpQXMyTDF5U2R3c0pDR3QyRHg2emtPN3UvQzhNUkpENzVH?=
 =?utf-8?B?c2tucnIvUFJPS1ZadTFicnJGb0NxWU5BYmdTT2lGWnN3emF4ZE41RnJsUndj?=
 =?utf-8?B?akRNTkJIaTBFK24vK3JZR0tucWpyMndYbEdGYlNMM1dLc0l2RGdBK3pqWFJC?=
 =?utf-8?B?R1JIR2I1Zy8xWi8vL0taamFTU2Y1cHRyVEJMeE9DbEJDN2ZROUpNL3Z1VEtU?=
 =?utf-8?B?UXlFVTY4SGo2SDEwaVQwYU90dytJVWVsRGVBazBpdy9Ha2d3eHBUdWw1UWw0?=
 =?utf-8?B?M29FZC9ieFVnRmVZQSs0d3J4MThKYkRsZGw2RUJPQzgwb1dmdWtPd284eUpZ?=
 =?utf-8?B?c2k5QkdESGt4ck5mVkdVeUV1WmVNWUNFbDl0L00zUG9UZ2ZOVU53akc2d3Uw?=
 =?utf-8?B?SmtpWGNVZjM4K0E2Mm1FdHdOaXMwb0RlbWpBbGhZODA0SnRtQlVyU0YyRWtp?=
 =?utf-8?B?MEdvblV6RXUxYUVOalJ5aUZFYWRubC94dDBhMXlxQnUyQ0RyK0JaQTcxemJ4?=
 =?utf-8?B?aDB1SXdBWm9sdU5BTXE2Vkt5M0VoMngrR1FaSG1xNXFJUVJxdlVZZDAxSkVV?=
 =?utf-8?B?Vkt0cEtIam5YdkE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 01:34:32.0817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbde767-6565-4bd2-bc51-08d8b69a3613
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NddtFwbjwv19BAQ2Wj9OFUFU6CRkPNS2eYzKpKBNy/Z8iCQXI4m6i4PdBwxrmclR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3413
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 1:37 PM, Andrii Nakryiko wrote:
> On Sun, Jan 10, 2021 at 8:15 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
>>> Add support for searching for ksym externs not just in vmlinux BTF, but across
>>> all module BTFs, similarly to how it's done for CO-RE relocations. Kernels
>>> that expose module BTFs through sysfs are assumed to support new ldimm64
>>> instruction extension with BTF FD provided in insn[1].imm field, so no extra
>>> feature detection is performed.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>    tools/lib/bpf/libbpf.c | 47 +++++++++++++++++++++++++++---------------
>>>    1 file changed, 30 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>> index 6ae748f6ea11..57559a71e4de 100644
>>> --- a/tools/lib/bpf/libbpf.c
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -395,7 +395,8 @@ struct extern_desc {
>>>                        unsigned long long addr;
>>>
>>>                        /* target btf_id of the corresponding kernel var. */
>>> -                     int vmlinux_btf_id;
>>> +                     int kernel_btf_obj_fd;
>>> +                     int kernel_btf_id;
>>>
>>>                        /* local btf_id of the ksym extern's type. */
>>>                        __u32 type_id;
>>> @@ -6162,7 +6163,8 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>>>                        } else /* EXT_KSYM */ {
>>>                                if (ext->ksym.type_id) { /* typed ksyms */
>>>                                        insn[0].src_reg = BPF_PSEUDO_BTF_ID;
>>> -                                     insn[0].imm = ext->ksym.vmlinux_btf_id;
>>> +                                     insn[0].imm = ext->ksym.kernel_btf_id;
>>> +                                     insn[1].imm = ext->ksym.kernel_btf_obj_fd;
>>>                                } else { /* typeless ksyms */
>>>                                        insn[0].imm = (__u32)ext->ksym.addr;
>>>                                        insn[1].imm = ext->ksym.addr >> 32;
>>> @@ -7319,7 +7321,8 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>>>    static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>>>    {
>>>        struct extern_desc *ext;
>>> -     int i, id;
>>> +     struct btf *btf;
>>> +     int i, j, id, btf_fd, err;
>>>
>>>        for (i = 0; i < obj->nr_extern; i++) {
>>>                const struct btf_type *targ_var, *targ_type;
>>> @@ -7331,8 +7334,22 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>>>                if (ext->type != EXT_KSYM || !ext->ksym.type_id)
>>>                        continue;
>>>
>>> -             id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
>>> -                                         BTF_KIND_VAR);
>>> +             btf = obj->btf_vmlinux;
>>> +             btf_fd = 0;
>>> +             id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
>>> +             if (id == -ENOENT) {
>>> +                     err = load_module_btfs(obj);
>>> +                     if (err)
>>> +                             return err;
>>> +
>>> +                     for (j = 0; j < obj->btf_module_cnt; j++) {
>>> +                             btf = obj->btf_modules[j].btf;
>>> +                             btf_fd = obj->btf_modules[j].fd;
>>
>> Do we have possibility btf_fd == 0 here?
> 
> Extremely unlikely. But if we are really worried about 0 fd, we should
> handle that in a centralized fashion in libbpf. I.e., for any
> operation that can return FD, check if that FD is 0, and if yes, dup()
> it. And then make everything call that helper. So in the context of
> this patch I'm just ignoring such possibility.
Maybe at least add some comments here to document such a possibility?

> 
>>
>>> +                             id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
>>> +                             if (id != -ENOENT)
>>> +                                     break;
>>> +                     }
>>> +             }
>>>                if (id <= 0) {
>>>                        pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
>>>                                ext->name);
>>> @@ -7343,24 +7360,19 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>>>                local_type_id = ext->ksym.type_id;
>>>
>>>                /* find target type_id */
>>> -             targ_var = btf__type_by_id(obj->btf_vmlinux, id);
>>> -             targ_var_name = btf__name_by_offset(obj->btf_vmlinux,
>>> -                                                 targ_var->name_off);
>>> -             targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
>>> -                                                targ_var->type,
>>> -                                                &targ_type_id);
>>> +             targ_var = btf__type_by_id(btf, id);
>>> +             targ_var_name = btf__name_by_offset(btf, targ_var->name_off);
>>> +             targ_type = skip_mods_and_typedefs(btf, targ_var->type, &targ_type_id);
>>>
>>>                ret = bpf_core_types_are_compat(obj->btf, local_type_id,
>>> -                                             obj->btf_vmlinux, targ_type_id);
>>> +                                             btf, targ_type_id);
>>>                if (ret <= 0) {
>>>                        const struct btf_type *local_type;
>>>                        const char *targ_name, *local_name;
>>>
>>>                        local_type = btf__type_by_id(obj->btf, local_type_id);
>>> -                     local_name = btf__name_by_offset(obj->btf,
>>> -                                                      local_type->name_off);
>>> -                     targ_name = btf__name_by_offset(obj->btf_vmlinux,
>>> -                                                     targ_type->name_off);
>>> +                     local_name = btf__name_by_offset(obj->btf, local_type->name_off);
>>> +                     targ_name = btf__name_by_offset(btf, targ_type->name_off);
>>>
>>>                        pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s, but kernel has [%d] %s %s\n",
>>>                                ext->name, local_type_id,
>>> @@ -7370,7 +7382,8 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
>>>                }
>>>
>>>                ext->is_set = true;
>>> -             ext->ksym.vmlinux_btf_id = id;
>>> +             ext->ksym.kernel_btf_obj_fd = btf_fd;
>>> +             ext->ksym.kernel_btf_id = id;
>>>                pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
>>>                         ext->name, id, btf_kind_str(targ_var), targ_var_name);
>>>        }
>>>

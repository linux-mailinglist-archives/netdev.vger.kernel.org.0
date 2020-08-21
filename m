Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E7D24E24E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHUUxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:53:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgHUUxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:53:15 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LKjniC032100;
        Fri, 21 Aug 2020 13:53:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=h3sGQ4baB5CFEZqQ1skGN17fVmBRgSy3IrOHQ/2KEB4=;
 b=n8NzQ8XeBQV3W4eIGeFNhZ9UxATT7bVBaU9VUEPAhxeGLhRJmhQhk76EidrkCq3iwe+r
 UJtiga6u3XqYkrCw42vB6WbB1B1gSs/1zswAazkUy6/8td03tv0KKswoExCzNGTNO0ad
 bbLuESapJyJoJAuzEHZPSZImoeEDf9sjU2U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m3f6aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 13:53:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 13:53:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1ry1Ahsb1d2WTrSZX6czNHVDQvvQJ+RXj0CfkrKkeml/f18FRbcqtLfI49OBai5liCTAsyFx9vDwtP7RMojRbFVu4+n82gLyQT1bcf1tM+6BZmXg11SXAlBhVTikcyvqipHEw4Wyu1pVxh0YwHjSsVZJthxloz0efKxP0rdGKBpmS7ulhUBsiHl8XbRb9+33/9sQIuev7gGli5O2bDP6GlYBPs4BHEfdGPYS3Z3oI9KjmCBbrHvDOEypqS9m1G1HdfmfjdE8KpLKZ6uco1UQMEdXHsiUOfx+bhgG4yCDmaPYq++dYJcz5aSECGR1Yw5GsEdlXVb2dlVYxkGbmD/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3sGQ4baB5CFEZqQ1skGN17fVmBRgSy3IrOHQ/2KEB4=;
 b=UjOwuCMH4qK/jZ6xmlAGAjLacLyk2ThVn0wTCYLeyYGccEVngmafErWGjYlcQZ8C3KFaSX4x5De1jofoixAmijAFkObtTVEI//DJudVh+6uBr+4dl6rTTvdL8Iu4REj55+cqJGBBfmuRfBS5C2dPODPOF+wnTGyvVSbYvdNBMBnyW+JVUzByONvXDQq07XADZaoaKET54uA+4/0ldykumEnP2Md8FZ1cQ4Hw3Ts3xetuwq6LNPVrCTMF8e6+P4/O0OyiVFT6aXX1hfojuZMNFvPOmlbb4/dxTUVMcnibjA5JR6QCEa09196P9SFJ8cdsDW9luxk+KYuoUZ/BUWbBzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3sGQ4baB5CFEZqQ1skGN17fVmBRgSy3IrOHQ/2KEB4=;
 b=e7T/equ8Csbn57yC131+VgVucz249RSEbXWEXrWDJqiVjzlFX7QPvjOd9WHVWxHF3kHPvs3CxPrdGr/Fj3qXlE2dm8Xlvk2zsyKLOVoH6GtSlgPjznIMSv3hohylHmtUFUMyO2KYKccCIJyMHVExPDUM12WtV5Lft6WeExJukJU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2408.namprd15.prod.outlook.com (2603:10b6:a02:85::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Fri, 21 Aug
 2020 20:53:10 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 20:53:10 +0000
Subject: Re: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access
 based on target prog
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200821002804.546826-1-udippant@fb.com>
 <9e829756-e943-e9a8-82f2-1a27a55afeec@fb.com>
 <d9df934c-4b64-1e28-cc7e-fb03939d687d@fb.com>
 <F6EEEFF4-F749-4D51-9366-1B1845EF0526@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <732c9be0-cccd-c180-1c18-e7cfce24ac88@fb.com>
Date:   Fri, 21 Aug 2020 13:53:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <F6EEEFF4-F749-4D51-9366-1B1845EF0526@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR20CA0037.namprd20.prod.outlook.com
 (2603:10b6:208:235::6) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR20CA0037.namprd20.prod.outlook.com (2603:10b6:208:235::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 20:53:08 +0000
X-Originating-IP: [2620:10d:c091:480::1:8457]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 802e99f0-935f-4fab-894f-08d8461436a0
X-MS-TrafficTypeDiagnostic: BYAPR15MB2408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24089BE21296A819EBA6AC0DD35B0@BYAPR15MB2408.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4t3YsIx/P6uNqvMb6f4I1rdF1cxOuTFRFt8UTvnNI8plCBqoVKtdULczcrfMeJWtV4zE5A/k4C/QR5oRbOK2D8ogTN8pdYJOMIqVOIz//IlAsu1SazdgVYppyRxh44ooxJY8OTxpB2WxquP/Rs33anH2TP+A5+i0Ad2kOQ5tdzzIWMzIZjFCDfRayJzYCJc4WaNspL8xExb1TAepRKIbPBQ27X10EQwPSd2ZP3TTlg2ht2eqvCmVQLdg3ROi5GcZNChRWzD6nxPJDCsthFSwisYrmTBTF5WEghSBriGO5ki89y2rl/PDuay9qMEbBPjQ4xgtA49fdmj6RXZANS5IYofY3WxYe35fqTgAKRP76AF816Q3Twl6hGpUVEEpsts4dF3sSYWtxi4luImFxTVueQqjwErcSty25S/Y55VKZg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(136003)(39860400002)(186003)(316002)(16576012)(31696002)(2906002)(478600001)(53546011)(8936002)(54906003)(110136005)(6666004)(8676002)(52116002)(2616005)(4326008)(31686004)(956004)(86362001)(6486002)(36756003)(110011004)(5660300002)(66946007)(66556008)(83380400001)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sI/Xr3vpImmNbPSwjc50EF+SZyMFmBVBVrN9V6Mlr6YWQxgBkAt4+vKZvWO8nFTRdkciX2z2Chc/RSdJ58YmpnH9DjBm6WmBUO2002fzDi+mXF0x9bpejkUvQ7URfzA2o+CkyuzddxYAnyV1ZIIoK1POLtFmy6y/sdFSx4Iz5iyUoRBZeZhNmgji8bEDi6XS/fpQJmyd2q9n3VeeV0kbSZihUIeaRaRo6Mh2mZF/tCvUVQe/DP9TsZVr8horbd0i1jmgvPLMhfAF7g5ZumC3cUTW4P7ityARwZfDJmx5oXYqQYLh++VvSExLWTq2D6kOJekiTUzYv6PPtKun45fPCzJNdFIG/70nntQTSHdojE2kwPU3m1PtoQbs7k5BVERwhgVUY2t2ENFyvTJ3mzLEEdV8ginYrT8Nj6AEw9cUaeqmKP5CcKRmnD3/M8LoUuVDB4v68AQJOLtVsVbG5jYCGTdUDjYIIMnu4AX3c+ookNNuzrvUBHNrAV2uQjMJ+lQLobRxoLD//IlYu7xExMMna7AXG6loHRhOXBu9hTvvYxf2p/p8sIWM8cBZh+jLV8Oa89y2S3qpHlxrPGCRg9Tl/9MJ21RABdo3sWY9R6rw1JtOIdndieMdYGVNab0ZfqWEqY3f4uhU0vNNSohWQO49MmLIHUS7VDCPhGkrsCnfVBKaBGDIHjuD0VoMbnR4oHeB
X-MS-Exchange-CrossTenant-Network-Message-Id: 802e99f0-935f-4fab-894f-08d8461436a0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 20:53:10.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voOdLEYRnWadcevgdbqZ926zwkL/wOpoEKalPkkU8bkUkOr26FK9jAxs51ICC6/Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_10:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210194
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 12:07 PM, Udip Pant wrote:
> 
> 
> ﻿> On 8/20/20, 11:17 PM, "Yonghong Song" <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/20/20 11:13 PM, Yonghong Song wrote:
>>>
>>>
>>> On 8/20/20 5:28 PM, Udip Pant wrote:
>>>> While using dynamic program extension (of type BPF_PROG_TYPE_EXT), we
>>>> need to check the program type of the target program to grant the read /
>>>> write access to the packet data.
>>>>
>>>> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
>>>> and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
>>>> placeholder for those, we need this extended check for those target
>>>> programs to actually work while using this option.
>>>>
>>>> Tested this with a freplace xdp program. Without this patch, the
>>>> verifier fails with error 'cannot write into packet'.
>>>>
>>>> Signed-off-by: Udip Pant <udippant@fb.com>
>>>> ---
>>>>    kernel/bpf/verifier.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index ef938f17b944..4d7604430994 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -2629,7 +2629,11 @@ static bool may_access_direct_pkt_data(struct
>>>> bpf_verifier_env *env,
>>>>                           const struct bpf_call_arg_meta *meta,
>>>>                           enum bpf_access_type t)
>>>>    {
>>>> -    switch (env->prog->type) {
>>>> +    struct bpf_prog *prog = env->prog;
>>>> +    enum bpf_prog_type prog_type = prog->aux->linked_prog ?
>>>> +          prog->aux->linked_prog->type : prog->type;
>>>
>>> I checked the verifier code. There are several places where
>>> prog->type is checked and EXT program type will behave differently
>>> from the linked program.
>>>
>>> Maybe abstract the the above logic to one static function like
>>>
>>> static enum bpf_prog_type resolved_prog_type(struct bpf_prog *prog)
>>> {
>>>       return prog->aux->linked_prog ? prog->aux->linked_prog->type
>>>                         : prog->type;
>>> }
>>>
> 
> Sure.
> 
>>> This function can then be used in different places to give the resolved
>>> prog type.
>>>
>>> Besides here checking pkt access permission,
>>> another possible places to consider is return value
>>> in function check_return_code(). Currently,
>>> for EXT program, the result value can be anything. This may need to
>>> be enforced. Could you take a look? It could be others as well.
>>> You can take a look at verifier.c by searching "prog->type".
>>
> 
> Yeah there are few other places in the verifier where it decides without resolving for the 'extended' type. But I am not too sure if it makes sense to extend this logic as part of this commit. For example, as you mentioned, in the check_return_code() it explicitly ignores the return type for the EXT prog (kernel/bpf/verifier.c#L7446).  Likewise, I noticed similar issue inside the check_ld_abs(), where it checks for may_access_skb(env->prog->type).
> 
> I'm happy to extend this logic there as well if deemed appropriate.

Thanks. I would like to see the verifier parity between original program 
and replace program. That is, if the original program and the replace
program are the same, they should be both either accepted or rejected
by verifier. Yes, this may imply more changes e.g., check_return_code()
or check_ld_abs() than your original patch.
Alexei or Daniel, what is your opinion on this?

> 
>> Note that if the EXT program tries to replace a global subprogram,
>> then return value cannot be enforced, just as what Patch #2 example shows.
>>
>>>
>>>> +
>>>> +    switch (prog_type) {
>>>>        /* Program types only with direct read access go here! */
>>>>        case BPF_PROG_TYPE_LWT_IN:
>>>>        case BPF_PROG_TYPE_LWT_OUT:
>>>>
> 

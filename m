Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC81CCC86
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgEJRFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 13:05:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42486 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgEJRFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 13:05:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04AH4g4E005543;
        Sun, 10 May 2020 10:05:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lTZww3TioHM+rb2AkvKBp9rbDJqFWbvd58QnQmlyAac=;
 b=elDyNOqpKlV8prKrHZTihMze1dktBvFTXFo4lexWwJ0BgjhCRfaJicmiHbixoABx2BVn
 LB212D1jeb0yeY3qH30ofkE15xNPtlbh2955nYSLL7rEj/EL+WrbAGxOu4nAfqzXIGau
 dUFwZ0usqVZmJ7Cf6KyuSgNyaDZ1cQRWZ+8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wtbfw3cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 May 2020 10:05:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 10 May 2020 10:05:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT9+blXp9Bj/q79Op8p+sEUdkX/qoT9BuCmCsEElyXoUzD4Vu6Ux+iGLOXGmwMaQTF+1Wy6osW3be6ZY/GYpZmOUXMUN+M6LXbV8yu1W2+UP4kWHtNJQENOd1lx36zxUAZxzApKhpzwe4zKzBwjb3zvF/bq6i0sSUPvDoCSJfKXfu83Un2Cp0JPoarDJu9pRvdtCrW5BHVBUolyKMmv3x3rkFwZqxQY7KF7v/Y+a7aXHrZdOd/bko717kE/UfPizXknw9oMFMdIduDpjWW8kPlIYZUpKyyoPZKAIlD484BVCYDs9Z3OuFKK6jTeoMiPUocdm+8w9HCB/o68iEs/DMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTZww3TioHM+rb2AkvKBp9rbDJqFWbvd58QnQmlyAac=;
 b=DquSQaFYG78plzHuV7FWafMBJidpK4X2rp8Dhge5glwSMFlv7YWxQDSDjvZSx3V/iJPcIl5tcz0AUcJpzx/DZlXKm3dfG4XoanJdluBc7iU30BZx0tD1pnhSvUERv+DDOcRhnpA7wc1wmVT/7Yh2gs+O063BkfnBMoT8Hd65+r/YlxzC++KIm5xK5Y5X2KSEPQTMGzr0UApKX6xQILoW1w//c7Q6lEyruWqGR8QQXv4DVjtK3mjLw+HZh4sgXY6QOKYX6t6VobnrtC+t2LjBbfsYcj16V3O4eVqQx/fLC1y9b05njZp2V72XEwNApnekBNb9WaLk8yGpimras/VYEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTZww3TioHM+rb2AkvKBp9rbDJqFWbvd58QnQmlyAac=;
 b=aIKQ7xfuN4AL8ara72eqWzjeusL3gZ1Oge+J/pv1mL7GhwQmwj7NQAVItlLz93xX7E6/dYPbXAiNjLWC4fSca2fEWDSbwqXx1/8y5QmxW+Hrm1w0wa7Ng6UxmeC4890pc64Cto1zZR/UdfgrdgSFQJ+UO8izz9rtDrmpXgADjfc=
Received: from DM6PR15MB4090.namprd15.prod.outlook.com (2603:10b6:5:c2::18) by
 DM6PR15MB2553.namprd15.prod.outlook.com (2603:10b6:5:1a8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.26; Sun, 10 May 2020 17:05:20 +0000
Received: from DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::1def:a038:5c9a:eef5]) by DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::1def:a038:5c9a:eef5%3]) with mapi id 15.20.2979.033; Sun, 10 May 2020
 17:05:20 +0000
Subject: Re: [PATCH bpf-next v4 12/21] bpf: add PTR_TO_BTF_ID_OR_NULL support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175912.2476576-1-yhs@fb.com>
 <20200510005059.d3zocagerrnsspez@ast-mbp>
 <d5b04ac9-3e3c-3e32-4058-afc29e3d34ce@fb.com>
 <CAADnVQKzhbFe4MQ0G4ZuPnjXbbzEfQMjvTwba4MkhyXQAuNP+Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6541b3ff-98ea-f004-0c14-54688c65c902@fb.com>
Date:   Sun, 10 May 2020 10:05:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAADnVQKzhbFe4MQ0G4ZuPnjXbbzEfQMjvTwba4MkhyXQAuNP+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:40::36) To DM6PR15MB4090.namprd15.prod.outlook.com
 (2603:10b6:5:c2::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro.fios-router.home.dhcp.thefacebook.com (2620:10d:c090:400::5:b70e) by BYAPR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Sun, 10 May 2020 17:05:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:b70e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cad97829-cf72-4b08-d73d-08d7f504520e
X-MS-TrafficTypeDiagnostic: DM6PR15MB2553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB25534B79E2C9F44140BB63B2D3A00@DM6PR15MB2553.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zNZ3z0vt+7y1+PP61W8WfzOL2brF0mlGdrNMXtwt74/ezWMx4fnmXp80Ih5IdMhY4BUM21iBkK440xfTV4UwxdToJlRAIjlWAXa7IhWo41LHto1LYqicy7lX/4m+flaFqCZxxH1vW8JiXzbmbh6BohUea75R2+jQM9PGPuaniMbvd/7bc8xlzaknf2SP0IA6jMbjFN9EJYXCM9kAaOBQAyvJU90g19yAiinsdt/l6/isobHbKfCBzEVw13/OWJD5v0zgjuVipuWlKilNK112N9OxNuXfuPxs+0T+Qar1fm8yrCMQdaxudPMrJyhh8/dtpR5V6A5KXz5UwBsSYBn/FkQA8DQHcVEiU1XrGiCGGt1aVPtKuRXvk7H3SVXUy05nTOQAd+goL36f+WXvDWeOac4GnHmzoDS03CdwghRDyVjOJWusnIvfPynhmxyLe1KOiNg+txXjMtukiJov9303hmXUVlS06Dly1IoSgQqrbQdCKtOrGIbxswSfMNurCWPB0oa/AzxHtIOwvC8y6OaRsEkhM7kEiq6y6kGdNGGc0u6vpwBwoe2AuGNHibuU8QOp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4090.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(33430700001)(8676002)(33440700001)(36756003)(31686004)(2616005)(54906003)(316002)(2906002)(5660300002)(8936002)(186003)(16526019)(478600001)(6916009)(86362001)(53546011)(6506007)(6486002)(31696002)(66476007)(4326008)(66946007)(66556008)(6512007)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: trmmA5ON6QjfVtcq4SHeJRDkInTH8UPuQTYMqTQir7pCd6wvgccQqVcsPKPNj8cA8ifaer6vOTOlBEjiS6za8dLqkeGXh/iSDA2bmeo+Yzc3Lw8dt4I8G3eDtpr4XurQUrdAstaxiAFfs71nSvA01Z+7KLAFOQSB8L2iMOz38mW7nqhkAZ/6+zLbyFvHBwfF5NrPs5segPkaWsYo4Xpq0qe9/6lQkvrqRB+21K0CDZnT17RfUtdK+xj5Wcm+u50obC1iYnThalcMrMvZVxfHszs5/31hnNkC2v5jU48TrJnE/4+87ZmpEgX76RIpUskL0MTOZAFxAl5oMzCGfjPT/4Nzm9yRhhefUhkPjvI3Z6afNYLqoe82laljn51QkAYZtv1dmn3UNh+S4klXfeBrDpzHwd52HDc9rV6K8jRt1LIcBBaaHmcWXnD+yuJa8X4u84/p0Om92G6wIOJ6TWsNUawb9mN377JEPAKV/8Vk85xkONpUmyw+7OMU5Hu29fuvrAbXzdNhZYGAo24gpwKcpA==
X-MS-Exchange-CrossTenant-Network-Message-Id: cad97829-cf72-4b08-d73d-08d7f504520e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 17:05:20.3472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVYv0tN6VJ4RY2Y9YsosdnsTsL3l+5NgatV0MWH+dK7zTRdjvTy3mankuk/M3MAF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2553
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_08:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005100158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/10/20 9:11 AM, Alexei Starovoitov wrote:
> On Sat, May 9, 2020 at 10:19 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/9/20 5:50 PM, Alexei Starovoitov wrote:
>>> On Sat, May 09, 2020 at 10:59:12AM -0700, Yonghong Song wrote:
>>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>>> index a2cfba89a8e1..c490fbde22d4 100644
>>>> --- a/kernel/bpf/btf.c
>>>> +++ b/kernel/bpf/btf.c
>>>> @@ -3790,7 +3790,10 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>>>>               return true;
>>>>
>>>>       /* this is a pointer to another type */
>>>> -    info->reg_type = PTR_TO_BTF_ID;
>>>> +    if (off != 0 && prog->aux->btf_id_or_null_non0_off)
>>>> +            info->reg_type = PTR_TO_BTF_ID_OR_NULL;
>>>> +    else
>>>> +            info->reg_type = PTR_TO_BTF_ID;
>>>
>>> I think the verifier should be smarter than this.
>>> It's too specific and inflexible. All ctx fields of bpf_iter execpt first
>>> will be such ? let's figure out a different way to tell verifier about this.
>>> How about using typedef with specific suffix? Like:
>>> typedef struct bpf_map *bpf_map_or_null;
>>>    struct bpf_iter__bpf_map {
>>>      struct bpf_iter_meta *meta;
>>>      bpf_map_or_null map;
>>>    };
>>> or use a union with specific second member? Like:
>>>    struct bpf_iter__bpf_map {
>>>      struct bpf_iter_meta *meta;
>>>      union {
>>>        struct bpf_map *map;
>>>        long null;
>>>      };
>>>    };
>>
>> I have an alternative approach to refactor this for future
>> support for map elements as well.
>>
>> For example, for bpf_map_elements iterator the prog context type
>> can be
>>       struct bpf_iter_bpf_map_elem {
>>          struct bpf_iter_meta *meta;
>>          strruct bpf_map *map;
>>          <key type>  *key;
>>          <value type> *val;
>>      };
>>
>> target will pass the following information to bpf_iter registration:
>>      arg 1: PTR_TO_BTF_ID
>>      arg 2: PTR_TO_BTF_ID_OR_NULL
>>      arg 3: PTR_TO_BUFFER
>>      arg 4: PTR_TO_BUFFER
>>
>> verifier will retrieve the reg_type from target.
> 
> you mean to introduce something like 'struct bpf_func_proto'
> that describes types of helpers, but instead something similar
> to clarify the types in ctx ? That should work. Thanks

Yes, this is what I think will be extensible.

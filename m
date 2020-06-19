Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5D201AC8
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgFSS4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:56:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53974 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbgFSS43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:56:29 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JIta6q003635;
        Fri, 19 Jun 2020 11:56:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y07klkIjwOqlVomK4DXxUyWIHezlC5/bWkJAxL/B67g=;
 b=SN62O+3xxoL9LcePrS1ildU+35qM69nOl8HhPk0ClTuZz1fBzEBhq79cbOhtopn3R8lN
 YaCfBVHYrjWw77QSJJJIHQQX/2NOMeI88rJs2Z4PvcGhEWQcpBlaFAX8Nxi8Q++JakFT
 KHjP0bLrTTnKjJu+IsTwTecj5Sr33B/Bwsk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31rvjcb9vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Jun 2020 11:56:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Jun 2020 11:56:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9n/O80k8e9AOxPN30BRW1MXkcHnPvtYZmD6a9jrrl6ENZK/9dZfsGBg3azG/myyNbqoS8lhq7iYsGI+iS5AmVj+VcSn7NdWkAac26xCnnY2/tBwqtEdIO8O5RikhsHf23ElXOT2W1QXI0pULO9BMIpOAJFi+0k3bJlPMEiVIPzFctoXdWKRtnk8xS1AqzMx40VT6pdN4+mek+/E5aoxKpSQ2RF8XJAbVzBWIcCdhiYb77cO9lUpcFH3OgyH7TnTHB2lgQiEylalhsVfq1ROpnluNhIDKavRlmNVjGngRrMiv35b1had/lYBt0XXSU5/ruztJq6nUEtlcEs9CCHbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y07klkIjwOqlVomK4DXxUyWIHezlC5/bWkJAxL/B67g=;
 b=YEhOLLyX0WGTpYvpX5V5A8Y0oQl1Rh/XWyQu+Wjrq/e/rxOMRRVFBneF21hlhA7Ca2wNsejEqmsefSh8EGH2ryYiviYIZ7imhbcKaty7I8UE971ZgzbE1K2xMwJTg0XmeO1fuW3NPZKQcOLiy+9IgdYbGjs8lo7L3rLNz7UYgA+kumFxceo7OFvbilAPTDNHffuu7zEkkuQ99xSYupS95ltej47OaAdw/9k6PWiKz1Rtezszi2qAbTe1/h5OgmvaPCMexXHhHTjnKb9kENEJK56wP+LDjvTj6LsXkzKUsx1/i1iY72nJqWJAsCkcmHWtD3eJqrpCMSf6BUcLvW6N9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y07klkIjwOqlVomK4DXxUyWIHezlC5/bWkJAxL/B67g=;
 b=QHtBF2q570ptBoke+eq5b/p7hUn6OFkXnNX3tqlYd4+1mozJUTV3OHQtmxuxU4tA2a02UzAj0AntkEFORimWUpV7rUOfgsRT7MeAbEDgsuLZpKHg4eizgra6okx9uCg2yqF8yrj4hzEqmV1LizhJRNt0X31e290LOT+YBR/hh3g=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4118.namprd15.prod.outlook.com (2603:10b6:a02:bf::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Fri, 19 Jun
 2020 18:56:10 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 18:56:10 +0000
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
 <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
 <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com>
 <5eec061598dcf_403f2afa5de805bcde@john-XPS-13-9370.notmuch>
 <CAADnVQLGNUcDWmrgUBmdcgLMfUNf=-3yroA8a+b7s+Ki5Tb4Jg@mail.gmail.com>
 <4aec5fb8-9f9d-d01b-dd58-f15d50c5e827@fb.com>
 <5eecf98ba643c_137b2ad09f64a5c458@john-XPS-13-9370.notmuch>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4a82d587-0ca0-d04d-76c8-e83e9e5076f8@fb.com>
Date:   Fri, 19 Jun 2020 11:56:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <5eecf98ba643c_137b2ad09f64a5c458@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1477] (2620:10d:c090:400::5:a1ad) by BYAPR07CA0008.namprd07.prod.outlook.com (2603:10b6:a02:bc::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Fri, 19 Jun 2020 18:56:09 +0000
X-Originating-IP: [2620:10d:c090:400::5:a1ad]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0ff9e28-2eb8-4c3e-b5fb-08d814826e2f
X-MS-TrafficTypeDiagnostic: BYAPR15MB4118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB41185DE3B98F062F4FBC717CD3980@BYAPR15MB4118.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bh9syBvyxuX6M/DR0R89aTuNh4UrEyJKOmV6dsVjYjVtaWuZUAs1qWynbebiPISmzGHiLYv9Qn9CnMu8+v8AF/m2bgUvSjlm6DEBanL7+FbITdW3MvkSTO5GvNy3fVt5m5Gk5hKt++iMyLrMY+uBrDvYC+Fas879pkfp68NEWhYHuvoRb4tYwUiJrjkIX3EH3HfkmfdUUX3p1Ii1FJo/kSiANHM6cbDvxO6Js7hGMH5hxOBNY+e5HU7u9BD4TmDmS7cI1ZG0NNbjRYYTt8kXzTlUjNyeudt7nSITfkRJ0h/lDIVpiVGvJgA0axtbaPvO0lWGBT4cb3sGZHI6qyUIGMCKEUKAvlcU+BkUvMEJZtK28WyXO970Tahb0VY38hmC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(53546011)(8676002)(31696002)(83380400001)(36756003)(8936002)(31686004)(5660300002)(16526019)(186003)(66556008)(110136005)(7416002)(54906003)(86362001)(2906002)(4326008)(478600001)(316002)(52116002)(66946007)(6486002)(2616005)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Te+6z5Q/sQLiCzNh92Zl9hzlpKJ6J5pBO5GQ7kKpoMfxrVAGnai7+VEqTNFBiA9G8DtmE/xdajz8nSQ0i/UNJlAMD3zvw2HUQB5q5GuQVPuWajdurrYYEo7aaUhoGKdbZHdGJrlK/y2ME4Hd4Z2x5PLoMfcfNqoPSjh2crytdBxawVR0iuczuUC0g6AvlJwbkQSKef2Xk9YECIj10p4ooZnFz5FThlvyc/Gt0MSMtQ0t1io9Y58P7Xkkwqm4WdsdaSaM/XNDU0zcQjvhDDn7kOWO8wVfyC/BieF91Axu18j2N4AuGnz+uUPykuwsNr7ofYYkWN+TG5Go4xv/3b/t2lk+Lh3zAqxGhhCYR+Zq0hh/a5TgciHqmXzxehH9xj5M1hshLvpJyfpw5IaoFfn32RA29QHpdbgd1+lrh/NAJY/IKr4tgaPjM/Gvq+UxLZT1y56DLb+6mYPDe1yQekBzHkwl6U8Iy2xWyXu6oN/Mmc7Vw4RuYnp4b4BtqbRUAppJrLPwx6s05hmadBLe4zEFlw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ff9e28-2eb8-4c3e-b5fb-08d814826e2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 18:56:10.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78Tkx5STx5mwELohI2wN7BRSdaR7TKE6rNrkPXSwvcdXyCqjB/xtbHM7A0C4dGt6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_21:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/20 10:44 AM, John Fastabend wrote:
> Yonghong Song wrote:
>>
>>
>> On 6/18/20 7:04 PM, Alexei Starovoitov wrote:
>>> On Thu, Jun 18, 2020 at 5:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>>>
>>>>    foo(int a, __int128 b)
>>>>
>>>> would put a in r0 and b in r2 and r3 leaving a hole in r1. But that
>>>> was some old reference manual and  might no longer be the case
>>
>> This should not happen if clang compilation with -target bpf.
>> This MAY happen if they compile with 'clang -target riscv' as the IR
>> could change before coming to bpf backend.
> 
> I guess this means in order to handle __int128 and structs in
> btf_ctx_access we would have to know this did not happen. Otherwise
> the arg to type mappings are off because we simply do
> 
>   arg = off / 8

Yes, btf_ctx_access already disqualified struct type, so a refined
check to ensure int width <= 64 should be sufficient.

> 
>>
>>>> in reality. Perhaps just spreading hearsay, but the point is we
>>>> should say something about what the BPF backend convention
>>>> is and write it down. We've started to bump into these things
>>>> lately.
>>>
>>> calling convention for int128 in bpf is _undefined_.
>>> calling convention for struct by value in bpf is also _undefined_.
>>
>> Just to clarify a little bit. bpf backend did not do anything
>> special about int128 and struct type. It is using llvm default.
>> That is, int128 using two argument registers and struct passed
>> by address. But I do see some other architectures having their
>> own ways to handle these parameters like X86, AARCH64, AMDGPU, MIPS.
>>
>> int128 is not widely used. passing struct as the argument is not
>> a good practice. So Agree with Alexei is not really worthwhile to
>> handle them in the place of arguments.
> 
> Agree as well I'll just add a small fix to check btf_type_is_int()
> size is <= u64 and that should be sufficient to skip handling the
> int128 case.

Agree.

> 
>>
>>>
>>> In many cases the compiler has to have the backend code
>>> so other parts of the compiler can function.
>>> I didn't bother explicitly disabling every undefined case.
>>> Please don't read too much into llvm generated code.
>>>
> 
> 

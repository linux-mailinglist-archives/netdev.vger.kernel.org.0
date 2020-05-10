Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE61CCC84
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgEJREu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 13:04:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgEJREu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 13:04:50 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04AH3GJA031304;
        Sun, 10 May 2020 10:04:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AXaHK+ehpU/YM46i7Q6fMcLZwGH6k1znord7tRQJTy0=;
 b=AIPfbo2Td+eWiDHtX7NMlFRPfBNG5aFQKmTrottewPUa5kpfpGQxn6ZI/0WrgDxFXsmu
 sy5i3MuXgtyHwfISLmwDXJCHcpre++SD8RrcdFziXvrzZqZJNwZT8eva8UGVB9ZCQAfA
 kBupOGK/xLbPw200kN2TVeD2eg8NoyJY/bs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xc7dstar-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 May 2020 10:04:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 10 May 2020 10:04:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exlkwUhaBiknYESHtt3FQTbv4g5jOl4oy783di6nKvmEUBzJX0+4rWfkjMUd2CX+tUJebKpMVSy2ej4ISLMb6TYqNajtiDxskgniRL10rKf/2ApiCo7oG6UWpwY8Mldqmpv4J6Id87qP4kEa7JiRwvljBxjM5VwrT/Xb54VFSz3MUPSiZVf0IZHE9D1RcyBy7fTDEosLU12nbtup5Ydx2HrNOrJvBQjAiFgJsiJXb3SX13YUlGwu115gYjTKwUwNrN+THFMZtCQxIRS3SHQPHLtDlFfQFM4Mc09ko5m/BFZm5HH5xvDGQdBR9ZdLenC8hVHou43fQlyl8zY+0akVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXaHK+ehpU/YM46i7Q6fMcLZwGH6k1znord7tRQJTy0=;
 b=gSC8EypHEzwNAkOGqRWs7SlXf7wELL+qEThhL8qpY9N+lNwMWxTiRry8UbN3wPzI7wPskaAV65teXOupnu9BHa/9dIlSzz4byDRJOpRgk1m9JQ8FpKn2BP4azRIagrzUGnZ+/C2/bxCplPD6YQolYr1vZRza3nnQECS2eNYOUjR4j63fTvqdszCZUgSugF9RJKjWJqxLYFmO1PKXY/RmMDWEkFaWy3D4tfF1SzE4UBxYS9hx4Rxeyb0fWNNunD7kLmTsVCcyDwPbDQJoVX2V689tAx4zobu2M0GVUoifs50MPP2WELH+RwKD3qF+TJr+4HCTwvOM9PEt9502oRFZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXaHK+ehpU/YM46i7Q6fMcLZwGH6k1znord7tRQJTy0=;
 b=QnI5bAC1bb2pVhFMIC8PCy9kN4W7NYtv475bc7ldLaiijHoyt1+QsS7yh0LGyEk95ObGLzukGgFpZD4/CXM3L4IAwpWabKa1qEkLf4GYN6TJRlHIoSh4vJ11T3u3zJpWAnC5N+YS3ffiyiMX5d8rutmK4QankgHt3V9YwhSfTAE=
Received: from DM6PR15MB4090.namprd15.prod.outlook.com (2603:10b6:5:c2::18) by
 DM6PR15MB2553.namprd15.prod.outlook.com (2603:10b6:5:1a8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.26; Sun, 10 May 2020 17:04:25 +0000
Received: from DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::1def:a038:5c9a:eef5]) by DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::1def:a038:5c9a:eef5%3]) with mapi id 15.20.2979.033; Sun, 10 May 2020
 17:04:25 +0000
Subject: Re: [PATCH bpf-next v4 16/21] tools/libbpf: add bpf_iter support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175917.2476936-1-yhs@fb.com>
 <20200510003535.rfnwiuunxst6lqe5@ast-mbp>
 <51a07f55-6117-58c2-e1f4-a1f38130976d@fb.com>
 <CAADnVQ+90UtuXVj8sCmyQQZCxFFfmcUq05w5DBybWxSN_0AL4A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <330c779c-0a0d-58ec-2516-14d82169e76d@fb.com>
Date:   Sun, 10 May 2020 10:04:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAADnVQ+90UtuXVj8sCmyQQZCxFFfmcUq05w5DBybWxSN_0AL4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To DM6PR15MB4090.namprd15.prod.outlook.com
 (2603:10b6:5:c2::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro.fios-router.home.dhcp.thefacebook.com (2620:10d:c090:400::5:b70e) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Sun, 10 May 2020 17:04:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:b70e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41749b59-29a6-4b63-6bd0-08d7f5043136
X-MS-TrafficTypeDiagnostic: DM6PR15MB2553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB25535041D9E66E91F841BC27D3A00@DM6PR15MB2553.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EVddnPoFZP6Nc+vVgfMjs5eh/lYAQMdRDrp3q11injkt+f4AFPBsutEZlIMgYKH+Crc8SB083V9qrCsxLIFb9qvcDgluC2sRNGtOwPYelWQaQMI5WGvySgEm8Zo4i98ZNjc8IYCsOppX3mriu7vBCEE2/qL0Iw7fFhajMxkFw249Tx3HLMhwe382yKCsIVpgWHca7E6HIeNwrlpC17zmie0aDfXqLbyhfLDi9v75NTHv9AqDk0lwe4RcGGmX3tFO3T0UmSU52CcIZh3IS1yzy9ey/CGqsgz5nrztoePjcc/oFg2PIXZCKL/k+qhTZeQzaBCtAAql+PAKM3nGh5EydfWUWQoXfQEjMsohURYiiS7Kg/as9JVNmmhdxNnUaVHw9L9o0tangkergDrbpw6hVsHBVm712e82W4uqwwtuJXePMmNpUh4+/BGVQT0gGtOZPRn+QvuT9cWLBDABbUIK7iVw9YsIihJ4QU5v38mcIyc5DloC928zttPj0tj7nszFy69xoc2uDiGryapi/70twZFSlxPqc5ZprEC64pNvjd/gnwIZPJ9E3HpBbIP7hWST
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4090.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(33430700001)(8676002)(33440700001)(36756003)(31686004)(2616005)(54906003)(316002)(2906002)(5660300002)(6666004)(8936002)(186003)(16526019)(478600001)(6916009)(86362001)(53546011)(6506007)(6486002)(31696002)(66476007)(4326008)(66946007)(66556008)(6512007)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tGi2d7FY7aIggHLkAjwwZxrthJy/wd/oNf4mc3u9sR71nOpApqge2koSwhgMDZSgQB9BvJ2sTiIJ3LmtQ8M2lTKATBBPOEubaF3oHulFH3Dq9YAEqeOSO7CbfKaC+sNkQSsmS7HIj8wk4DQ3lLpLWOCkIrxWEhU9oa4JElcRzkMOipt5MiyTynHudu6o2PymwAxlTr8D8tgZqf4x7Wpyqy7ZAoQ5nn4xOp8Ot1lKFfr5DlVcfHGRnfBhoZ37mQJqlqT1jbo9Qczmpp2ZbhGP9jzUR0+xQx8JO7gx7mq71IRbAG7IdO6wyzskjrvds+oRWuVKvrZXH+o/R6PsVaqTJayvwheL8tN4qZX3TySa2HynDgfQ5Kw/+aC7bGHeIHFbyCueU0RpnE+4Th7z19fHnXu8O1HOEMKCPnj7HJzn9ryUzQ+vHXhKcwB1/yJxXD6yXIbgageOu8bpn/rsrW8PVRFQy546LMIvSUBCb+P7vdZkGFKJD0WZGo8Idv3MifNoXZqBK++GkcfDT83aS7BxJg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 41749b59-29a6-4b63-6bd0-08d7f5043136
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 17:04:25.2837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9skZ3kzVq7ETKc5CRJ3dkf0J3m6aQm0zW4hEi7PVSnkxnr6Jp0MlOc2Rv2T2o90
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2553
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_08:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005100158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/10/20 9:09 AM, Alexei Starovoitov wrote:
> On Sat, May 9, 2020 at 10:07 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/9/20 5:35 PM, Alexei Starovoitov wrote:
>>> On Sat, May 09, 2020 at 10:59:17AM -0700, Yonghong Song wrote:
>>>> @@ -6891,6 +6897,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
>>>>
>>>>    #define BTF_TRACE_PREFIX "btf_trace_"
>>>>    #define BTF_LSM_PREFIX "bpf_lsm_"
>>>> +#define BTF_ITER_PREFIX "__bpf_iter__"
>>>>    #define BTF_MAX_NAME_SIZE 128
>>>
>>> In the kernel source the prefix doesn't stand out, but on libbpf side it looks
>>> inconsistent. May be drop __ prefix and keep one _ in the suffix?
>>
>> Currently, I have context type as
>>      struct bpf_iter__bpf_map
>> Based on the above proposal, we will have function name as
>>      bpf_iter_bpf_map
>> It is quite similar to each other. My current usage to have
>>       __bpf_iter__bpf_map
>> intends to make func name and struct type name quite different.
>> Or maybe
>>       bpf_iter__bpf_map vs. bpf_iter_bpf_map
>> just fine as user should not care about func name
>> bpf_iter_bpf_map at all?
> 
> Type names bpf_iter_bpf_map and bpf_iter_foo don't look
> unique, but I don't see why they should.
> If code really required type name uniqueness __bpf_iter__ prefix
> wouldn't provide that property anyway.
> I think bpf_iter_ falls into the same category of prefixes like
> those used by lsm, trace, struct_ops. Or I could be missing
> why iter has to be different.

I will change to bpf_iter_ prefix then. This is hidden from
user anyway.

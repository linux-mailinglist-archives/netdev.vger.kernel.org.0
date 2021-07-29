Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1E3DAFA9
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 00:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhG2Wyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 18:54:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234000AbhG2Wyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 18:54:53 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TMjL5s030422;
        Thu, 29 Jul 2021 15:54:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bk1wXgmNn0fZ/gRbUDTC+y/dCgHqSQi9QW0sqQ86Nbc=;
 b=G/VLr7JjyOytXPkalkt9Vo2nakUHdhsPhg0/FEXVyWDMoBFusgt3ASaZLxXHNpUkfFie
 1phNaV7CCtA5mdPVIjuJ4K6sx5fAl3lkB04YedADy0ASWCYOVhUY8bfeIpQgFHct23Jt
 dAao3x3zrPU1L0pYcEeU84A5Z5RvbappIJ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3vrtc1ew-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 15:54:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 15:54:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c27ZTQY627Nt+hkobyvXJbi2HGlpJNGgHAbRvgbDHTUmLiYbXYDKmNsmoGTM/HK5KQiitBXdJnbzoVEVXWjox1beWvcvvPe38gDTY+tByUm2OaFYrheSXpHkUIrODyiaeRlA9OaNmj+Xkzone/5uAGcA4bsdIjClj21midqIEW8H10PWUF+VwUwYaf5V5/rMhAYdjHt4TuweggFiHQbxetHnyeQhQ4kmbO82ONqK893BbADgn0THtD09y7LyfT8mCDAKND3DwJc3eVpKBYN1p7/UEreW6QP9LpCm8MTwiGXY7Zf8vmxH6nDINrFcBO+iYYwlGuC2ifp7A+fxd0XUsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bk1wXgmNn0fZ/gRbUDTC+y/dCgHqSQi9QW0sqQ86Nbc=;
 b=UPzWqcomI8uMpUjedOKWwTICkKQF20cU60mEKX6IQX6wVygnjEU8tbgRLkuSAtgQWZPrdI/dUyukhb1uXUCyGNn9jc74/ffNfQueMLUH+bmWB2fujZ7fDT6LwuAPb44BjN2KrJphgLSI9gWwc64PQ6TLn1dWtZrS/UuxMVz6BuoXp0LKZJgYV1BNy/bkR5Jgb9sUC+Ky3zEEcD40sT3csPvBFC2Cmqg2WNXcgz1dlTToyaktHlJldoVQ3Ys4YXb9nkhL9D9oDdc0SUa6i1hCv3XHqF2LiHCYNJg3NefTFCjKGOu23WQtuLWJF311JI1xRfrvFgpwQHcRULZmUCZMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4839.namprd15.prod.outlook.com (2603:10b6:806:1e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 22:54:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 22:54:31 +0000
Subject: Re: [PATCH 08/14] bpf/tests: Add tests for ALU operations implemented
 with function calls
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-9-johan.almbladh@anyfinetworks.com>
 <ba3656eb-500b-9f14-1c97-d27868f1c3e6@fb.com>
 <CAM1=_QQRuH2K3fMDJCYJuDtTmziqcmtcr31hQeQe-kCkXVC4gA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a492ce4f-4fc6-b6d6-74a5-9ded35d84608@fb.com>
Date:   Thu, 29 Jul 2021 15:54:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <CAM1=_QQRuH2K3fMDJCYJuDtTmziqcmtcr31hQeQe-kCkXVC4gA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0037.namprd15.prod.outlook.com
 (2603:10b6:300:ad::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1130] (2620:10d:c090:400::5:9d36) by MWHPR15CA0037.namprd15.prod.outlook.com (2603:10b6:300:ad::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Thu, 29 Jul 2021 22:54:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6734a9a3-32f7-467d-c6f8-08d952e3d3cc
X-MS-TrafficTypeDiagnostic: SA1PR15MB4839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB483943F40B1DF63F51AFAA7CD3EB9@SA1PR15MB4839.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afbkYWJPbjd8OBaTIbgc5Qt1PcgvTkCA9pcExMYKoGPoZcZtqsKd6UIeQHbWkbdIZM7lF5nuFkEjciqLz2kDAMjEWKgfKgibxlVqQ2at7C2LRDQpxo7zstkbl2ogbPL1YOUTpOLf9QmrUZz8kLurqlS9voqPg1F5pMgb6AfoKk5pQvcgbKBRqdfU1BLEHrA93AmT8ZwdGHSQKOfWWtCSmmg2CZFLZqqDdoopa0Kq4YfgLovYNVBv5H838A9L35KF1qegsu9FbPEtxdvMfAbjYmeuywaLRttPCZAFTHezfpsXaLs7KiEBlnU1H8di5A+AuEZnbNflG9wN+5u5rTilOD1htQy+CefrWuXyUk+aG7+puTBHUkmTirkXglpT4P6oOeI2cewqULnnA9M8tu/pxYpRKBRHjKpiJw+7Gq2/5bPfpsJ6bNEE8KqP1qfrG24C9V+TnfOBxziXux1F17exvQ2MRyvnz1Rsqsg8Kp1QPoky4E1+GdFLt59M0zOWt8gzXH+KPRFlhOklU/yPwrkDpVHXg/Uvzh7caN3s+DGZeXTVfBlcXaxLuLADkj3uYif1Miq6K2qv9OheiMgqxBBLVJl57ITaJifxtWXa9RxgHrXt+BJjPtYUucY1KAiqqJV04WoBBgbwyhhI07+r+Dfa9VDFInWzF5Wwmq4SZ/xt39nA3PyoGTBMBu7wDAbp0t0P/2dn8+O20smuyMs4hCRmv+isNCpn35I1j08Lg1XFa88=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(31696002)(6486002)(86362001)(6666004)(53546011)(2906002)(38100700002)(52116002)(478600001)(8676002)(36756003)(186003)(2616005)(83380400001)(31686004)(6916009)(4326008)(66476007)(66556008)(66946007)(54906003)(5660300002)(316002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjhhZzZyVnp3Kyt2ZmRTRmgySjZHVk5xKzhDc1dXQ2lzNlJqNDhtNTMyT3Yw?=
 =?utf-8?B?WXB6WHZobjE2M3JBNHpVOXRKU3V6a1pEcUNlTFRGVzZzL1JwRFh1R3NOK2ZR?=
 =?utf-8?B?VHFoNGVLdStUekNFWHVibDVQaFd1ekNLR2tjKytXaXZ5WTE1Q3IvOEhuV0JQ?=
 =?utf-8?B?ZzdnbTVZSlAyUkpITmluWDlGcXpqV3ZpbkZsTzJQUDhtRFBrYUZ1Z0tvUG5S?=
 =?utf-8?B?OVZSQ0VlNGV0cm1EMk9TWkZXVVIzQ0t3M09hN2RFRlkvMGRwRm9lQ0NiSVJZ?=
 =?utf-8?B?WjBvNCtUTGVWZHY5ZFFKZ1lRQ1V4QkUvWWx5VDhJVVgvOXVMNDdFYlFteFN0?=
 =?utf-8?B?bE5EdzlJekEwV3JMam4xMnlXQ3hHWFZ3VzBKVEhiMWlpeEhjWWlqay9XVjFq?=
 =?utf-8?B?czFYU0tuNlhLREhnNHZaWGJLdmxFdnZieEw4UFgzb09NRGV4UCtGNHVLT1Bj?=
 =?utf-8?B?UyszRGRHbTgwNENPaEZUeWxyWjQvb1RPVmJPRm1jM2ZQUUdwYmlyZDZrSkEr?=
 =?utf-8?B?NzlQQ21FaXFCZ0lKN3BGbWdOTEhUV2IydFdZWXdjVURRYmlMajU0STJQdjNR?=
 =?utf-8?B?K2Nab3MwaXk4ZkRENDNQWUVVNGZtZ3QyNHhlbDJiQytMZlV0d0ZnMGxjL3p4?=
 =?utf-8?B?WGFveXd5QjZmNlhoSkVNa3Q3c0Rod3l1Zlg3a2g1OFlPNGJDaWVUWHlJbExo?=
 =?utf-8?B?VnAwTFZlNzQyWDloN29mdi9TNzhLOFhYS1NRVmZ0ZlFybm1yME1UczVLcE9r?=
 =?utf-8?B?QVN1SnRQbUlSayt1R3ZXOWhCNkRzTkEvOWl6azBjVnlrNzJTNlZjYWE1N1Mz?=
 =?utf-8?B?MGpuM3lOL1pETGRGNFZHYko4VU9JZzRXd2JGZ2trbUx6clRYYUxZNUtXMDZD?=
 =?utf-8?B?OURNamF0TkxaaFk3aHNTSnQ4Yk9tSnhwY0E2VHRUK2M3SHNqaXRrRjJEc1RL?=
 =?utf-8?B?NFBTeGl5bGo2emdJbDBNN2g1SEp0U05GRC9QZGR3NDM4SkxKdkF1MVVRVkp6?=
 =?utf-8?B?QUw4TGRsYlhEcUtRdzdmVmVMK0VWYms4WW9nZFpPVTcrbUU1VFJZOHh4WDNG?=
 =?utf-8?B?YWdpTTlkcFkrUHZTNkdwQitHdnRmZ0YyS0JXZWtlbVBEd0dmZ3B5VVhsdVdW?=
 =?utf-8?B?clRqNFp2dTMzampmc0kwYWVRVjVUNzRobGp5cnpHY1hTUmFxTHFrRWMwYkdp?=
 =?utf-8?B?aklQbk9zNFdyK05JNWtUblBNZnFWRmF0KzQ5bFF5ck5SWUMwNTRHN3hJU2Yw?=
 =?utf-8?B?WGVSUEJTK2x5Q2JEeldFVm13ZTY0bllKNjRmcjl3NkNURnJVNDlnais4c0VQ?=
 =?utf-8?B?aU1ueHQyaUljMll2L1FPQ2hIVVpyQUk4cjkwN0tlVnBHVmtMNjh6TnNhTHVZ?=
 =?utf-8?B?bnVFWUNSa1lCanovWlBzMUk5MjFpOEgvWjEzT2pOTGZZckw4aDhIWFhlU1FM?=
 =?utf-8?B?eC9hQXRqakRYU0hkVnVQRGVnaFFVYzdnTWpsQnNNQWpNckhCaFNUYVoreW9p?=
 =?utf-8?B?TFJLbE5zek12c040M1BpNmJ1K3NIRFFQRVljRmdjRlZRNVk4QVVvTlZxR09G?=
 =?utf-8?B?VVdyUVU1V3BjNkpUR0EvNVc1U3JIa21DcmN2RWsyalluMnNnM3pjL2lRMFJK?=
 =?utf-8?B?MktmUTR6YWVNRUJwY1E1Qi9vempxbVBLV01ST0FycmNBN1dtR2NQdDFIcm5K?=
 =?utf-8?B?eEJreUhJUzNNVTZLYytZWjhwdmE3VFV1Zk5BcGZWZ1MzNmZ3aUhZYkxTQzRj?=
 =?utf-8?B?RUpiUGtuU3duaWJTM1EwU2c3YnhDdEZmcjBybHFFYm5yTndNT3g4WFRuZkN0?=
 =?utf-8?Q?1n8wqrx17o89CQy7tcNWCDuLWdnxcudXZLJqg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6734a9a3-32f7-467d-c6f8-08d952e3d3cc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 22:54:31.5501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8qIpf1+pmThxtRKBBheu+CLWis57CobHCOEu8Se/ktvCn25uEa2TRIJN8fHfN+b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4839
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HDzTgD_RHEw9b9sX9za1tLA-F4mUyzWK
X-Proofpoint-GUID: HDzTgD_RHEw9b9sX9za1tLA-F4mUyzWK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_17:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 2:17 PM, Johan Almbladh wrote:
> On Thu, Jul 29, 2021 at 1:52 AM Yonghong Song <yhs@fb.com> wrote:
>>> +             /*
>>> +              * Register (non-)clobbering test, in the case where a 32-bit
>>> +              * JIT implements complex ALU64 operations via function calls.
>>> +              */
>>> +             "INT: Register clobbering, R1 updated",
>>> +             .u.insns_int = {
>>> +                     BPF_ALU32_IMM(BPF_MOV, R0, 0),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R1, 123456789),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R2, 2),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R3, 3),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R4, 4),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R5, 5),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R6, 6),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R7, 7),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R8, 8),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R9, 9),
>>> +                     BPF_ALU64_IMM(BPF_DIV, R1, 123456789),
>>> +                     BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
>>> +                     BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
>>> +                     BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
>>> +                     BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
>>> +                     BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
>>> +                     BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
>>> +                     BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
>>> +                     BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
>>> +                     BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
>>> +                     BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R0, 1),
>>> +                     BPF_EXIT_INSN(),
>>> +             },
>>> +             INTERNAL,
>>> +             { },
>>> +             { { 0, 1 } }
>>> +     },
>>> +     {
>>> +             "INT: Register clobbering, R2 updated",
>>> +             .u.insns_int = {
>>> +                     BPF_ALU32_IMM(BPF_MOV, R0, 0),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R1, 1),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R2, 2 * 123456789),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R3, 3),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R4, 4),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R5, 5),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R6, 6),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R7, 7),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R8, 8),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R9, 9),
>>> +                     BPF_ALU64_IMM(BPF_DIV, R2, 123456789),
>>> +                     BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
>>> +                     BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
>>> +                     BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
>>> +                     BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
>>> +                     BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
>>> +                     BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
>>> +                     BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
>>> +                     BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
>>> +                     BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
>>> +                     BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R0, 1),
>>> +                     BPF_EXIT_INSN(),
>>> +             },
>>> +             INTERNAL,
>>> +             { },
>>> +             { { 0, 1 } }
>>> +     },
>>
>> It looks like the above two tests, "R1 updated" and "R2 updated" should
>> be very similar and the only difference is one immediate is 123456789
>> and another is 2 * 123456789. But for generated code, they all just have
>> the final immediate. Could you explain what the difference in terms of
>> jit for the above two tests?
> 
> When a BPF_CALL instruction is executed, the eBPF assembler have
> already saved any caller-saved registers that must be preserved, put
> the arguments in R1-R5, and expects a return value in R0. It is just
> for the JIT to emit the call.
> 
> Not so when an eBPF instruction is implemented by a function call,
> like ALU64 DIV in a 32-bit JIT. In this case, the function call is
> unexpected by the eBPF assembler, and must be invisible to it. Now the
> JIT must take care of saving all caller-saved registers on stack, put
> the operands in the right argument registers, put the return value in
> the destination register, and finally restore all caller-saved
> registers without overwriting the computed result.
> 
> The test checks that all other registers retain their value after such
> a hidden function call. However, one register will contain the result.
> In order to verify that all registers are saved and restored properly,
> we must vary the destination and run it two times. It is not the
> result of the operation that its tested, it is absence of possible
> side effects.
> 
> I can put a more elaborate description in the comment to explain this.

Indeed, an elaborate description as comments will be great.

> 
>>
>>> +     {
>>> +             /*
>>> +              * Test 32-bit JITs that implement complex ALU64 operations as
>>> +              * function calls R0 = f(R1, R2), and must re-arrange operands.
>>> +              */
[...]

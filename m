Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBB9445811
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhKDROd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:14:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51264 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232504AbhKDROb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:14:31 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4Gge00021958;
        Thu, 4 Nov 2021 10:11:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZLUQTW5BGL+ViybwR8l1N5k7HApSMVT5s5NPj2Qd/6o=;
 b=BsgOJ9t6MX713aZwQA1LsKjygWDCAq/nvJhbxL/P7e5m9VVqH2vO/WRTQ9rWfZyvQBsU
 x7jjf9UZDDfp91ML9CaEM/WYGxyO5L8O9ZCvSCjPVQfLyaj9/pmUseHSLiryBYqAJHbB
 zNFpUHT5nQsH5/W56uUAdnXJR4IwH+AlrKw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c43a4puuq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 10:11:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 10:11:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rd5cXOxhxr/I3vKQHliQ2RqRQTmZpLZGLSi+KMcw+bapAAnW94Ex2ERrVpZjv57v4Dona+mn7XNpyOHUXmhvyVUSwGjIGHtqs6E1OPanUUlAu1FmYTpmidkIdB9CKMoRPOfpbN2DM/bJvSivOZsYeHWmG4EiWZ4pIMGA7xX4tdmuL6utvLtHTkLViXgDevbY7lHTBHJXb4U+LlOQ0i14mrzFpK/br18nLOuaPqUCOA801crUi51d/C64n4MlQsEd+QzAhb3igSxR9VFSw2zaxy0mFPeUQF2vwCrg83qZ+abEE0RUX3hsaxKQN28rQr/oGG86UtUAqj7n2UiNPXhKxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLUQTW5BGL+ViybwR8l1N5k7HApSMVT5s5NPj2Qd/6o=;
 b=PgHpWf61CJLZ28M7SeTZMkusrbwZYM9yoG0NEnm7haVxt92Mb9DvvcLq6ETYbhRTXyeOoHcJNKAR63FJR+CYgSD060ZAdWixOuAsvgnrHeJ/B8+48LDYRxl/P9FNbtOiEOnar4DdG7392NTcW44VIZ276xJ3DyjvFIHGcjG1JbKiAVtE9F/Hjd6Tg/BueXdIv+dRjR2dF1p6jA1GJOSR4vD3wgIqoDldtHra4SLASbYOsFKFZAeRxepT4b8690iWjfLxdCohY3geWrFpd2G56p37eUxFk5kHWCyN7hHdjK3kHDy/dZFzeETj7ULM1viWcl/W4kVEE34CvzyVLFHrFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4660.namprd15.prod.outlook.com (2603:10b6:806:19f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 17:11:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 17:11:35 +0000
Message-ID: <71771c37-5e97-54e6-0d98-73878f3b74d5@fb.com>
Date:   Thu, 4 Nov 2021 10:11:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
 <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com>
 <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
 <CAADnVQJ_ger=Tjn=9SuUTES6Tt5k_G0M+6T_ELzFtw_cSVs83A@mail.gmail.com>
 <55c95c15-ccad-bb31-be87-ad17db7cb02a@fb.com>
 <CAADnVQK6kMbX379dy5XOo1s7DricX1z9WZ04PhUD6DoEPO+jsg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAADnVQK6kMbX379dy5XOo1s7DricX1z9WZ04PhUD6DoEPO+jsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:300:4b::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1253] (2620:10d:c090:400::5:e407) by MWHPR02CA0007.namprd02.prod.outlook.com (2603:10b6:300:4b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 17:11:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d089b27-7258-4f02-53e5-08d99fb62822
X-MS-TrafficTypeDiagnostic: SA1PR15MB4660:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4660A3A8B850EB2F2B760B93D38D9@SA1PR15MB4660.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/9CWkRQdHBM4ien8H+vSmRCTvicGAfGoMTJS6UXZLSxgIz++gNCt2wqy1tCDpIdTECmKrNomqaNybIrGV1YAUiPDG0CocuoiQJj7UwLUs7m992U8BfLZv5Yi0BbIXtkroiEVOZdmy4fnMZ137z+iTf6vEzoPDe90lSr28vBamhqph+rgBJKDG6rrp7qeVdi9yO323eG4/pHwBkcbgqJ9uoYsqIRGtdxt0rvYNKWzVFtRydf3XUmZ/zFNshOg4z6kh189YuJbHdLVLHpTN73gyTglIHtFocDYLd2yFolbQeZB81OHbtNO5Feb44itD8XfPx22pB6Ud0LXOfcPda2ROtTf/4U0tAzxa6OfYVGVZyqHy+nJWyUotsuugs6WUp/p6wA+4No/Bgf6bY96USgk+i46MPRozeVs8jXqhe0kf4lMjuVDJZbWREppvPBYiJX2sbc5f4REDtVbFMKwERQyyjpFdDD2Vix6LAc9v8/9jnBjauOcX8musoRQIbzDGJ2YHfGK/Mr49EThlD2aLcmSslW7Sd+Ym8frTwIB83I6DuznMaTYEJPBHLaZPLIhC2VfYAdATSNnzP43rEWBV2cUxSY6RC4QsQwyJRVlzoVy+S0iXVvil5ZlhdEyeDYm2MPuykjAEVO5etDqTTgANue6x1ZsgmBmOF6V9YgvjV0BDP1BARssUhITH1bc7EER/phUhoqbtPetEUXGCOALVAxFT8IXiTbqC4XAZYvhjLICVY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(53546011)(2906002)(31686004)(186003)(8676002)(66556008)(508600001)(4326008)(66476007)(86362001)(66946007)(7416002)(316002)(2616005)(31696002)(38100700002)(8936002)(6486002)(54906003)(6916009)(52116002)(36756003)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1ZrQjR3WFduZEdQNEkwaUl0OVFYcWFVbm05Syt6b1FNMHY5dzdmOUhvMTVy?=
 =?utf-8?B?bEQyUGhzbEh1T3U0RHI3VmQ5RGI4anJLcUMycFNhZDIvcElyN2lYNUJ2MGJJ?=
 =?utf-8?B?Y3VrTzJUQzFVejZuMkxVcENPMkNqNTJseWNFYUw3QlJRSmh1YVNCZ2JYNmdw?=
 =?utf-8?B?NU1tQi93UEZDT096dXlDL2FOS3Q0anBPWlVVam4rb252dmMrcy9FYzUwOEk2?=
 =?utf-8?B?TEUwblUxRG5BdE1wMzJ5cFREMENnSjRIbEUzb1J3UGpyN0xNTDVTMU5jSVZB?=
 =?utf-8?B?cXN2SXgvZXpFL1h6MUxqQVZqK3A5NmJ0Wm92SHZpTS9wUFh6MmU2MWVLcnl0?=
 =?utf-8?B?RldhMzlkcklzVUQ0MmlVWCt3d1dGTy9JdTN6TFEzY1FzT3FhdUFrZno5Q0RY?=
 =?utf-8?B?MGkzd1dkSkJqN2dudlMrc052K0NMbmhkOUZqaEEybWRsVHdNem45c2loNkkw?=
 =?utf-8?B?UGJhekhGNnpaT25sU0plMitjcGRTN01DZG40Z0F6c3MyQWVxbzRKOTVIOVNL?=
 =?utf-8?B?SU50cEdrYkNsb1N2RW5jY2ZScDFsTjBESXpzYlc3YlRNazVYRk9iOGZ6b2FB?=
 =?utf-8?B?T0N6OTE3bDlsRlZZT0ZNN3dnaEVzQUJpTmVVSW5PU2c3YWt3VGE4dDdLamRF?=
 =?utf-8?B?U2FiaXhibGRQdDRacGwxR3hrQktQdld4dkZmUnlMMHc4ZmYxQTF2UkpZZ2RH?=
 =?utf-8?B?OGVhMTVWNTdvTm1CMTdBNy9tV0F6QzhwalphWGF4dXZoTjJTaDBJbjEyTlB6?=
 =?utf-8?B?TDk1eGM0d09jK0U4QXRXTGQ0N0NBd1YwRDcwVkFPSTVZVDJOM1JQNm1uZytR?=
 =?utf-8?B?T1U0U1NzbkkxOFM3QldRLzhQYmcwZzFteVRBaGxxNHRsYkNFNmNnYVlXNXZV?=
 =?utf-8?B?dGFNenVjK2JzSjJxc0dHeS84ZWNWT0VOY25SQlplajN2TmxFNWdJQ1JQWWhM?=
 =?utf-8?B?M1grL0ZqTFZWWlV1WWtnSXZtbXFOZ0lzeHRjeE41dGV1ajRSZTFjUDdaMjdV?=
 =?utf-8?B?cWxlLzR1OHk4TDdrOWQyU2orSEhxY2hiYWFBLytERlJXZU1jSG1ud1Zhakdo?=
 =?utf-8?B?NFJwdTQyR3k0ZCtVK3VnY0NEMm5rWG1QY3FUODZNbUxHdGt3Wkt3YmZ0V0w2?=
 =?utf-8?B?UmFSZW9XQ1ZYK3VaSnpPZ041M0h4UnpXSjIrUTN1OGNwbzFUdS9MUEljb1pX?=
 =?utf-8?B?VGNaTGgvOE9vYXIvcnBGWDVmWG9nWjVxOE1yb3FqcU1HazZUelFUQnNXNGJj?=
 =?utf-8?B?cmx3SzhkeXBaeDFjcTFGVDVLVDdNRG1COXdTQnA2czlOWmt6QkgydEdsUHo0?=
 =?utf-8?B?dVQ1cG5xMDNNcVNWVStWSVZrZ3M4RkZzNmlXZUxKMkJ5WHMzTWhOWThUdFh6?=
 =?utf-8?B?YUtxK1hWYkxJcXcvbDM5QWV1Q0UxWC9Tbnk1T0Z6T0poaWsyaUdhVmxOY3Vp?=
 =?utf-8?B?RW9aZjVYeEZHQVBGbVlPZzdBYkN0bnBVM1kzU0NnbDJ4bVJKTm1HclVENjhu?=
 =?utf-8?B?N1Q3Uko0dkdHNmFab1ZMSm15b1lnVzdqZXZDR2F2aStDM2hXQllWSVJTU1dC?=
 =?utf-8?B?VU9JS1c3M3B0M2UzT0ozMWpUbC8yTzVpeXVyK2pibE5VdE5OWnRtTkhOSlYr?=
 =?utf-8?B?VVBWazA2UGVvUUJ0enVuY1dncFRxM2JnMS9QajU2cVJYRHJ1TnNJVC8zV3hz?=
 =?utf-8?B?VU1qN3o3SFBONUU0MmpXRlhJNkt2WTZ5RlYrcjBzOGdmYUF4MW9IdE1hTm1s?=
 =?utf-8?B?YWI4RmJRZWNUQk9mbkdDd05TaUNVdDlOOU40QWlhL0VjdWZKRktEdVRWY2hT?=
 =?utf-8?B?VUVWbHJrS0NJM2xLZEl0MzFXeCtDOUlNVnZRR3NraTJJM3dqUTNyd0VZVkxF?=
 =?utf-8?B?V3BQWVRXcC9jUlljWWZBeGtFWnNtUzZlbk9meXV5MmNnc0lyU2FtUXBxNDJK?=
 =?utf-8?B?VnZEQmQrYndGaU54T0lHWUhEZi9XcWtLSUh4djlzYjdqcll5V003VmE5TmRC?=
 =?utf-8?B?OUxQbjd2V1ZBcUZMOE9ZcnFCVlp5QTk0RFFxV2NuS2VMNzEwQUFOa2lKdWtC?=
 =?utf-8?B?QWZTaklQM1lpU3Yxb0srNjBLblQ3SHV2UnlVM2xoUnRYN0ZudHpjSzdBdE0x?=
 =?utf-8?B?eTc4bU5aUGZqNFdpWGhneVRjblVBaktyd2ZpMEN4V2VhY0Q1U3ZhWXNpMmtW?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d089b27-7258-4f02-53e5-08d99fb62822
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 17:11:35.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UD6+2Ycwem9ZxvgQ9VTrvY3EgyHQvcpqGrBxgiBa8SuOkmrI2wZgdRA7rAksXK8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4660
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ATIhmelw1AUcnIBitqLCVY9VaIa7sw9v
X-Proofpoint-GUID: ATIhmelw1AUcnIBitqLCVY9VaIa7sw9v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=913
 impostorscore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040065
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 9:14 AM, Alexei Starovoitov wrote:
> On Wed, Nov 3, 2021 at 9:23 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> asm("") indeed helped preserve the call.
>>
>> [$ ~/tmp2] cat t.c
>> int __attribute__((noinline)) foo() { asm(""); return 1; }
>> int bar() { return foo() + foo(); }
>> [$ ~/tmp2] clang -O2 -c t.c
>> [$ ~/tmp2] llvm-objdump -d t.o
>>
>> t.o:    file format elf64-x86-64
>>
>> Disassembly of section .text:
>>
>> 0000000000000000 <foo>:
>>          0: b8 01 00 00 00                movl    $1, %eax
>>          5: c3                            retq
>>          6: 66 2e 0f 1f 84 00 00 00 00 00 nopw    %cs:(%rax,%rax)
>>
>> 0000000000000010 <bar>:
>>         10: 50                            pushq   %rax
>>         11: e8 00 00 00 00                callq   0x16 <bar+0x6>
>>         16: e8 00 00 00 00                callq   0x1b <bar+0xb>
>>         1b: b8 02 00 00 00                movl    $2, %eax
>>         20: 59                            popq    %rcx
>>         21: c3                            retq
>> [$ ~/tmp2]
>>
>> Note with asm(""), foo() is called twice, but the compiler optimization
>> knows foo()'s return value is 1 so it did calculation at compiler time,
>> assign the 2 to %eax and returns.
> 
> Missed %eax=2 part...
> That means that asm("") is not enough.
> Maybe something like:
> int __attribute__((noinline)) foo()
> {
>    int ret = 0;
>    asm volatile("" : "=r"(var) : "0"(var));

asm volatile("" : "=r"(ret) : "0"(ret));

>    return ret;
> }

Right. We should prevent compilers from "inlining" return values.

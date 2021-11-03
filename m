Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73554444716
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhKCRc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:32:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8762 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhKCRc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:32:29 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A3H5x7R009946;
        Wed, 3 Nov 2021 10:29:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2bZYraPw+SzXk9wnc3JvPJ/VuR7ii66vuKzpWHYz4Xc=;
 b=RyPXGH8GH1jP/GHGJlQELnkwNuqVbBJDfhKl5Z7JafsiZUMHg54D1prcxHwo18Dhvc0v
 f+AAowTp+SDgqWBrsE6olHtSSuaQ4E+Q1uMGJdSy/A36B4IOP87G2uZmEwJxaeqd9Wiu
 oJ2mx4xHwg6gRr3Nd7kBxXlEr/K+C69Dmb0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c3dch6tum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Nov 2021 10:29:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 3 Nov 2021 10:29:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNrCaTJSPQLBOuKbV9A9L4bqCRksunwSC+89+Q+lgX0DWoIh4wvuAQb6ThWgBCHZyLjv6qKo6SVtvvmkyjvBYlZxK5/6vZk0P1naQPFVl02Nn2lQ9BeU7alMmM8LhS0DNiJxxf8pg/E3Nn7PNWXd6yM/RffR1H3sMbO9DBwOin/v04bq2KxBDYCgyrjj3QPdNhDcVIk9YYSpckPnpWtnnNkmDaRP0XUadPb2XL4MI1vwvPMmckUuaTdUwSUdKivnqDxAiZETFiJw5wV8OcV73mremXGY4gIaGxpJne89GBlLTlkXW6cBumW5PHOuORzWQVUYUqiqhXGZwgGivH5OxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bZYraPw+SzXk9wnc3JvPJ/VuR7ii66vuKzpWHYz4Xc=;
 b=hsE506WDJfzyYfr/sNDSaHtYp/xybhr+7BBGjSGcjGCR1SddO67jQtXbKpT2rY2hfAK4k+VuDBHIZFRSdygiLbdd+5UqYVKXx/x/a2tcXIw0W23QrWpQSYbOm0TMOSJRLMZjHczPCJzVF/C3y1dcXfrlN733qy4PEPqMd3Ft6jd3/IKXtloLN6FuGNc4FkVwb4VswIjOi+UQCGPnVj864l8DfVJoBk2UTApMIoFxnyeiVGwZX77HNZSNAp3y3D5vB4ykCGfUbXUFdFpjpvfzdy0pamN5eAcBVgqbhx8U52bljUOOhrPLj1EqIJDp3L6ZAJzfUsnYFrunaIIGpGK/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4451.namprd15.prod.outlook.com (2603:10b6:806:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 17:29:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 17:29:32 +0000
Message-ID: <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com>
Date:   Wed, 3 Nov 2021 10:29:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joe Burton <jevburton.kernel@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0069.namprd04.prod.outlook.com
 (2603:10b6:102:1::37) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1066] (2620:10d:c090:400::5:bc20) by CO2PR04CA0069.namprd04.prod.outlook.com (2603:10b6:102:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 17:29:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 672bc8d5-05f3-4145-d2f3-08d99eef7f97
X-MS-TrafficTypeDiagnostic: SA1PR15MB4451:
X-Microsoft-Antispam-PRVS: <SA1PR15MB44514C0AE83FF09DE8BD6090D38C9@SA1PR15MB4451.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uU/Y18tsTstw5L1FTZyrMLkumK9wP1Dqcb4rktl+aI3pCnj6uN5kr4YCp9A1DZTteUOab5277mXs6EhdOhmFDCW97NHPgAKcMk3Sss2vpiFcnUPGyREsV2pInkBJh6K7ytq9TQ3rOsFWSWJdWbubwz3cFYExfxDxeTRYLI6e5r7LbvgDXaeFRPaiT/4QrqW39ba8ZqLvthVQi4AR+gRDxIU0PTLmnhcOfD+PXzD0oe4dprQfG1HWWssaBu1DZwE2FYsyfx3lpe+uYlR02YEmQ5DwLcYztkJLXy5ruHj/JTaFpxatnh4bbeddBHXtoBxbAfELBeKCT/y4WR+UhjidRZbdBWo47WZAXCUq2KIwUVqTJ3NaU7BUYsWZO2CTmnjgGt7xQBo9ky0UXbXC9tHXFFMd8ZSP+Iwm2c/WvipMA4ebyuUdTX4c1ksNOgChomt4l8wKVmxLcRGuxnbvnqn/PFi6SrUI0ognNawnFmyWEd9sCraLro/MQc6qLJ284jVQu3gthrnGTKehg15HwoTYPVoDtCcSRHEE6lnUTXShjBEwq3DcVyPf9awfWa2xgXKCe8EGLP4KW8EVX4bBf2jEtEykX26ZWiFgVmHYTsergO16q9LAIGWLYOSFY6gI3arSHeLtwAAppuBuVZIOb7q7eVfhPQVZv7pwkkRpZHlMpHOovn+2ShbtOU1OIKIjtUTuHjIyeDHcgLym9TNRygDtXego7RTQgqn6/tBAuqFX/8o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(36756003)(508600001)(38100700002)(5660300002)(54906003)(31696002)(31686004)(4326008)(186003)(2906002)(316002)(66946007)(66476007)(66556008)(83380400001)(7416002)(6666004)(52116002)(8936002)(6486002)(2616005)(8676002)(86362001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1p3eGVXYUtpRHZDY0VEeVA0T2doRG5ZVDJSdWw3VHlEdno3MWNNcjg2aFIx?=
 =?utf-8?B?S1hmTlh2TU9ua0M2VWthTXJoVlVTNm9DNEU0MzcreE50bGk5V3pFSVk3bUQ1?=
 =?utf-8?B?Vm1iWVhuZEVrTit5RzlkVk1jQTJlZEpCbEE5aDZUak82aitnZVhiSlIrRFJM?=
 =?utf-8?B?UHgzaDVPSEFmYWhvdWMvQ0czU0NrNC83anlackxuUG9RVFg0ZDBGQld3ZllX?=
 =?utf-8?B?QXRhU1o4cmZkY3V2dGFjVTE2TUxocS8vUlFFRVVFQ0xLeWxrYVEzdmZOQkZM?=
 =?utf-8?B?RDIwcHd1ZkhUNmhJdTlVdy9yR3IrcVR3ZVMySkxGY1BiR3I2NE54OEVaSDQ0?=
 =?utf-8?B?U20wQm1ZdEI0dkRRU2pQbGVrTE4rMExZRDZBTGJNNm01N1dVRVdCYy8veTFr?=
 =?utf-8?B?YXBMTVVKQkp6K0swWGlZWFc5emxFTXpmM010NDRHM2ZhcTdvcUhnckhEc1lI?=
 =?utf-8?B?Q3N0WU1xUUNFcmFMc3hwR0pPMTNTdnYzQ0hrOGdMd0FNVmpROEhZM25OcFRx?=
 =?utf-8?B?bkVzODNKUlAxbXFqNFIzZHNZM1BpQ010QzhXQ2UxakIyQmc5TnFNdEQraTJP?=
 =?utf-8?B?Rjd3T0FJbjhkalB6R0tJV3Z1aTh0eXRIZy9uL2lDejVVSFdIMk9qTjNSblFv?=
 =?utf-8?B?OFBCK0pjdzVzZXEzcUY4TS81dGJnZzl1dWxkZUhCY1RKQ3dZa09YYjMxZkp4?=
 =?utf-8?B?bFF1aXk2czQvc2I0ckdGU0JDeVZKcENqWnZxS2dwSkorV2cyN1lqN0doQko4?=
 =?utf-8?B?M2tCaG9ScWNtV2J2bzJBUzdnNU14ZUFOMlp2SzlTQmhqek1HUDFza21PbERI?=
 =?utf-8?B?VTUwOGFDaHRpQ1lsMUpXWDdRSGNJSDAwT2gxUll2Ylk5QTFFSUtpWG5QOHFD?=
 =?utf-8?B?b0d0TkQzNkEwcHhaZkZIOTFvUHVMS1ZrUThzWmc4bFo0bG9YS1J4Tm1wUFha?=
 =?utf-8?B?SXBSUmw0MTRLNk11dmdVK3VJdm8zSzgvOHRXcmtPWWJ5L1pVelFYQ2dLODNO?=
 =?utf-8?B?NzhuT1VFcE5wSGUrTEYvZGRKVjg2ZWRHS3lXMndvMEFrVXV6eCtIWVhYbTQv?=
 =?utf-8?B?Z1VqbE44OVdWZEx1MmtwbzNiUXpLeW1XS290cXR5YjF3QUNxcHM2UnFJd3li?=
 =?utf-8?B?aWpoV0ZKL2x4Zk5PVzhtZVFFaGRTeXpCRzRub3FWVDVLZ0czVEc1UGNyM09Q?=
 =?utf-8?B?NXUyQVZLdE1xZk8wSGE5OG1JMEJQUTdrendjMkJkbUt4OWlySkk3eUlXck9k?=
 =?utf-8?B?dURleVVaSTI0OUxWSzV2OWNCWFZCY2NodFE3RTVuR3MxWlBVNllzelo2SVdl?=
 =?utf-8?B?TktBT2lsMjFZSjBoakhuNjZYZ1A0NlJvcDNIWitReUlLQWtuMXdjTms0V1pB?=
 =?utf-8?B?NGdOZ0VUclEvNjJxT3JSYXZ1dEpqeTBlbHhuZ1NvZkduRkNKV1Jxa1g4QVpQ?=
 =?utf-8?B?bGdwOHlubnY0ZUlveVZjenFROWVCdXhISTdPY2lFdWFKSGhqS2Q2Q0NIOWNL?=
 =?utf-8?B?bmlEeExMWWpSa1dXNnhVSlJzVlhOY2FFTmdVRWttWm1jZ0d2T2R4VHdwdGU4?=
 =?utf-8?B?Q2xOVG10WVhsdXpqNDV5emxoQzBzcC9kektxdGRuTkJlb0RxdHJpT2h3STRp?=
 =?utf-8?B?Q0pURitPSXJEUjlIdmROZ3ZKeXRKUHM5cThMc0E1TUk1b1VMSzIzQ1cwbnFB?=
 =?utf-8?B?WUJ4dnd0MXg5dmxmelI5YzVJSkMyeDFPbGFqbkxPRHJhZm5Wc3pia3FGazBq?=
 =?utf-8?B?anEzd0dqeUZHcFF3SkpZMHRLQTNIMGdEL2EzeEJkM0pVbFdibXNOQ0hqdk9J?=
 =?utf-8?B?eU1xRmRKZjliR3FvdEY5UERPQW1sSkdDS2NNaW1BY0FQdW9LUW9uVTVjNS9R?=
 =?utf-8?B?L0FnNVNlRDNUamE3TUpKdjA3N2c1YU93N2VjbnR2bE9KRlZyZkpKRWEyUXBU?=
 =?utf-8?B?eFdVUzlkVFlJekhXMUlOVEFITTd0NGxGZHVINXVSdVAwaEtIRGt1MmtmbTBT?=
 =?utf-8?B?bWVSWk13dGw0eko2SmFnbjJuV3UxeGprU211d0xDNGtLRVJpNVIwR3lvQ2hq?=
 =?utf-8?B?TVpBeWlpWEpvenpkUjVhWUpDbGkwNERxRkdjT3QvV0hGQ0tNQTlSa3VaV2xT?=
 =?utf-8?Q?wtLKxJ4q+BtC4FKBaXq+mvCxb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 672bc8d5-05f3-4145-d2f3-08d99eef7f97
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 17:29:32.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvkvNDngVgwK7tYBxnZmW/zAyKUgHEQLy1hcv5WkvPxkcBOAT1dNSznHJjguyiW8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4451
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: A4TNFC3lK0jC9hpt2Kj8vaVoui4Atma4
X-Proofpoint-ORIG-GUID: A4TNFC3lK0jC9hpt2Kj8vaVoui4Atma4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-03_06,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111030094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/21 5:12 PM, Alexei Starovoitov wrote:
> On Tue, Nov 02, 2021 at 02:14:29AM +0000, Joe Burton wrote:
>> From: Joe Burton <jevburton@google.com>
>>
>> This is the third version of a patch series implementing map tracing.
>>
>> Map tracing enables executing BPF programs upon BPF map updates. This
>> might be useful to perform upgrades of stateful programs; e.g., tracing
>> programs can propagate changes to maps that occur during an upgrade
>> operation.
>>
>> This version uses trampoline hooks to provide the capability.
>> fentry/fexit/fmod_ret programs can attach to two new functions:
>>          int bpf_map_trace_update_elem(struct bpf_map* map, void* key,
>>                  void* val, u32 flags);
>>          int bpf_map_trace_delete_elem(struct bpf_map* map, void* key);
>>
>> These hooks work as intended for the following map types:
>>          BPF_MAP_TYPE_ARRAY
>>          BPF_MAP_TYPE_PERCPU_ARRAY
>>          BPF_MAP_TYPE_HASH
>>          BPF_MAP_TYPE_PERCPU_HASH
>>          BPF_MAP_TYPE_LRU_HASH
>>          BPF_MAP_TYPE_LRU_PERCPU_HASH
>>
>> The only guarantee about the semantics of these hooks is that they execute
>> before the operation takes place. We cannot call them with locks held
>> because the hooked program might try to acquire the same locks. Thus they
>> may be invoked in situations where the traced map is not ultimately
>> updated.
>>
>> The original proposal suggested exposing a function for each
>> (map type) x (access type). The problem I encountered is that e.g.
>> percpu hashtables use a custom function for some access types
>> (htab_percpu_map_update_elem) but a common function for others
>> (htab_map_delete_elem). Thus a userspace application would have to
>> maintain a unique list of functions to attach to for each map type;
>> moreover, this list could change across kernel versions. Map tracing is
>> easier to use with fewer functions, at the cost of tracing programs
>> being triggered more times.
> 
> Good point about htab_percpu.
> The patches look good to me.
> Few minor bits:
> - pls don't use #pragma once.
>    There was a discussion not too long ago about it and the conclusion
>    was that let's not use it.
>    It slipped into few selftest/bpf, but let's not introduce more users.
> - noinline is not needed in prototype.
> - bpf_probe_read is deprecated. Pls use bpf_probe_read_kernel.
> 
> and thanks for detailed patch 3.
> 
>> To prevent the compiler from optimizing out the calls to my tracing
>> functions, I use the asm("") trick described in gcc's
>> __attribute__((noinline)) documentation. Experimentally, this trick
>> works with clang as well.
> 
> I think noinline is enough. I don't think you need that asm in there.

I tried a simple program using clang lto and the optimization 
(optimizing away the call itself) doesn't happen.

[$ ~/tmp2] cat t1.c 
 

__attribute__((noinline)) int foo() { 
 

   return 0; 
 

} 
 

[$ ~/tmp2] cat t2.c 
 

extern int foo(); 
 

int main() { 
 

   return foo(); 
 

} 
 

[$ ~/tmp2] cat run.sh 
 

clang -flto=full -O2 t1.c t2.c -c 
 

clang -flto=full -fuse-ld=lld -O2 t1.o t2.o -o a.out 
 

[$ ~/tmp2] ./run.sh 
 

[$ ~/tmp2] llvm-objdump -d a.out
...
0000000000201750 <foo>:
   201750: 31 c0                         xorl    %eax, %eax
   201752: c3                            retq
   201753: cc                            int3
   201754: cc                            int3
   201755: cc                            int3
   201756: cc                            int3
   201757: cc                            int3
   201758: cc                            int3
   201759: cc                            int3
   20175a: cc                            int3
   20175b: cc                            int3
   20175c: cc                            int3
   20175d: cc                            int3
   20175e: cc                            int3
   20175f: cc                            int3

0000000000201760 <main>:
   201760: e9 eb ff ff ff                jmp     0x201750 <foo>

I remember that even if a call is marked as noinline, the compiler might 
still poke into the call to find some information for some optimization.
But I guess probably the callsite will be kept. Otherwise, it will be
considered as "inlining".

Joe, did you hit any issues, esp. with gcc lto?

> 
> In parallel let's figure out how to do:
> SEC("fentry/bpf_map_trace_update_elem")
> int BPF_PROG(copy_on_write__update,
>               struct bpf_map *map,
>               struct allow_reads_key__old *key,
>               void *value, u64 map_flags)
> 
> It kinda sucks that bpf_probe_read_kernel is necessary to read key/values.
> It would be much nicer to be able to specify the exact struct for the key and
> access it directly.
> The verifier does this already for map iterator.
> It's 'void *' on the kernel side while iterator prog can cast this pointer
> to specific 'struct key *' and access it directly.
> See bpf_iter_reg->ctx_arg_info and btf_ctx_access().
> 
> For fentry into bpf_map_trace_update_elem it's a bit more challenging,
> since it will be called for all maps and there is no way to statically
> check that specific_map->key_size is within prog->aux->max_rdonly_access.
> 
> May be we can do a dynamic cast helper (simlar to those that cast sockets)
> that will check for key_size at run-time?
> Another alternative is to allow 'void *' -> PTR_TO_BTF_ID conversion
> and let inlined probe_read do the job.
> 

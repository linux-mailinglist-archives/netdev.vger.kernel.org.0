Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE21E240BC1
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 19:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgHJRQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 13:16:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48422 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbgHJRQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 13:16:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07AHF1cN030258;
        Mon, 10 Aug 2020 10:16:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=A30uZxhQvE/fIeytdjmukUZjtjROkQlUwAZh3FWqa5U=;
 b=HsuX3SO8r55w9/EHTzdWCulXUJMNCrnrBH8yiR+sBqrGkxNTWkINcCuHsk+vvEjQJ4SH
 7KrbRaHJwQ1rg2x+BJGarLjE9B7Bsg+D41Zdt9mvjfJ60el3+RTRVCEYeJsxCsXyduDY
 GEenetjkSaazu65HFEk6wASbb4QdQr89ZaQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32ssjk87wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Aug 2020 10:16:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 10 Aug 2020 10:16:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yl0G3v81HPsTTK2dx7a0hchMEE+WsR78G8Ba/9l7fR6DKRVMW/UfnZo0+62857nEmAtJYdymiZBWzkwqt0/bahxOLK3kFuuE8fR9qHCKIpPa62FXzqLzww6Dmk2vUhiIlzVDpeFUBVGTZp53de/2yx6/dcrM/C19mjXiQ2efYDm+jwE+C5AD6VfOUq3WAiDUAMd8jKKe+SzjvM716+CDhB5BG4qN4mIebOglHQGxXFFYxif6VJgIb0n5IHoB0Y2g8ZJFf3f+SIRkkMRCPCoO88ukE+zpjNdY9hnK+J83bhdU95BQXaD2BJAbxVK2peFn/01Z1lryBU9mJUxq6yZWuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A30uZxhQvE/fIeytdjmukUZjtjROkQlUwAZh3FWqa5U=;
 b=E3SWjMUNW17MQQmgloCCsyeMXc0hgN+Y6U5ru5+UkW2OMq1oOjBj2EvpUGnYfVa3OZXIrcpYdhFQMGpyrxY58SDSRU8UmORDoHjGJ/ZpkqGsEtYNgrJlf535c8J2JEp70KR3ojHZO2nyPP2Ab+IOHIGoI5elzp9FCE/2nSevsuCSPDMNDJr1n+Oy9TUuyIajxVsljZsSxcjecz/9lLqYrvvajQdkWYn3DHspt5uvQQ8nsyYc5Pco2U74naXRvrMhE4euGk1KyFByVPsSyc0ZeJdz2/ZFMq/W5O6B06/GlOfFSIg4pFLim0FMWxTFOynLEYFXSvyc32/zVtzqH6dQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A30uZxhQvE/fIeytdjmukUZjtjROkQlUwAZh3FWqa5U=;
 b=NgLUAjgbjiBUg49cpgvyhOFO3rl4BPbzdK/tL0S0dbulUTp5NQdcQOHnVDuo3io2b3Ka+dgqZEAiv0WiL6cQ9ye48spM/pnhxlyf3nrTqA9fSAg08To/8KtM4FewMuGbg89YORJAshTB7U0n+SBQcrlxWmKWXcxXFO/wrDjoGHI=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Mon, 10 Aug
 2020 17:16:14 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 17:16:14 +0000
Subject: Re: [RFC] bpf: verifier check for dead branch
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200807173045.GC561444@krava>
 <f13fde40-0c07-ff73-eeb3-3c59c5694f74@fb.com> <20200810135451.GA699846@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e4abe45b-2c80-9448-677c-e352f0ecb24e@fb.com>
Date:   Mon, 10 Aug 2020 10:16:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200810135451.GA699846@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::10bf] (2620:10d:c090:400::5:e527) by BYAPR06CA0007.namprd06.prod.outlook.com (2603:10b6:a03:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Mon, 10 Aug 2020 17:16:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:e527]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddafcca4-21c3-45b5-097b-08d83d5115a8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26951BE8C2E06F35D6E47226D3440@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKfqJSRCOqvbGc7mtTvuTMOgu6rVOqUwuwif8aIZCqxUTJhvSMSkPlKbS9f5S2AAmamvGDyr65psxWC/fVB+CI9DEM54sC9pF2WcO2tmhtD+ofgDeUPAHAVa3VSsrZdzBqWL3qKGL6x4mV5JrPyBVjtjz03Yv2OeoramNnSHxT8oLriJI6/mzHPA72K6Ohe6qfsuSWh/+AtCOt09UeJgh+yXUBIMWKgst6E6xquMoZMhB5tvNmWnoxw+J2XyYaH8Ykaw6bMiCUNUn5WlVLqczQeQIVp+uaDz8kop2L60JuyBqgJj7qA3m2VmF7y4pS4nn+6AcJ+fsBd/+T1xM8b6XFpjm61+ylihCNRpbW8PNkkNcdmHpVFaGQuuxsevHx0c4Hr/LK63kOTEmW9iYfx7IJTFft538+WwLE0fuxisJ+BCB/sq10hg2cpVlJ+K71fVFwskFolGmp3lIIzCNfumlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(31696002)(52116002)(4326008)(66946007)(66476007)(66556008)(2616005)(5660300002)(186003)(16526019)(31686004)(2906002)(6916009)(83380400001)(53546011)(86362001)(54906003)(8936002)(316002)(6486002)(36756003)(478600001)(966005)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kTENkhYFEh/nzabYLY10frtkSC2UV/mcuJohgn4jZOU8awlpw1cjM2CHIIAqrxEmZg3HQdioHx/cbHEIyvxIQ3nwqyqtsg4EiHPOP8DvKtTa9muCCPvD28I5qGJb8C9KnpR0seB9jzouCCuFt0wcwrQ2UKPC560O3EqZvmvf99SJL2Vf3RsGNcbAcOhXdVROIj/J3aNepiMv3twpSPeSsikFC5o5+CvR72MaGc+Vkiq4YjNGGSGwQYWt3ILqU73gETCn+gAmu5CjtqmH7IrqLUlVugYaF5TW/0KcffeWIRfbPdZ9k3scvmHcsHE6AxMSXOsfpG2eSM3pOujnf0sx4qspxexisiRp5qwEAzxbvZTKONKQv8ZDPLtDDyqCHUzqirSeFlRFVDwHWHGSU35gcjMs1p/15uyvq+Y1G1ZTCLHIWXv8EoQOeVtFWEoXwB6AdzT1NSY9+vemgP+jFpjGmcKOVTgBbYpNqG//lRGEN25DeS/1O7x5FcmakHvl2ZRJHCat98RECYoqFmaG3I9jt9tjsfNFBH5P5PNHGDe8Lp36cwkRVGVrgB4gQYBYj+Ceja374wS4oFhkkOU0V+hA0FRhTuxl/0JEQI0FLhga6aM5Kbrd2lmBg5Ur/z7lcH+2ZhAK4Ucw7M+8cT9tDLksGjpTsqL6SU84+bhndA26QVt+gWVXSmyht01FKK1CreiV
X-MS-Exchange-CrossTenant-Network-Message-Id: ddafcca4-21c3-45b5-097b-08d83d5115a8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 17:16:14.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGmpYWQmNV/mcNMywux4y5vrSGkMgaGMz+0rSO2dEopV/P/w80iUeBPX1SziZ2xo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-10_14:2020-08-06,2020-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/20 6:54 AM, Jiri Olsa wrote:
> On Sun, Aug 09, 2020 at 06:21:01PM -0700, Yonghong Song wrote:
>>
>>
>> On 8/7/20 10:30 AM, Jiri Olsa wrote:
>>> hi,
>>> we have a customer facing some odd verifier fails on following
>>> sk_skb program:
>>>
>>>      0. r2 = *(u32 *)(r1 + data_end)
>>>      1. r4 = *(u32 *)(r1 + data)
>>>      2. r3 = r4
>>>      3. r3 += 42
>>>      4. r1 = 0
>>>      5. if r3 > r2 goto 8
>>>      6. r4 += 14
>>>      7. r1 = r4
>>>      8. if r3 > r2 goto 10
>>>      9. r2 = *(u8 *)(r1 + 9)
>>>     10. r0 = 0
>>>     11. exit
>>>
>>> The code checks if the skb data is big enough (5) and if it is,
>>> it prepares pointer in r1 (7), then there's again size check (8)
>>> and finally data load from r1 (9).
>>>
>>> It's and odd code, but apparently this is something that can
>>> get produced by clang.
>>
>> Could you provide a test case where clang generates the above code?
>> I would like to see whether clang can do a better job to avoid
>> such codes.
> 
> I get that code genrated by using recent enough upstream clang
> on the attached source.

Thanks for the test case. I can reproduce the issue. The following
is why this happens in llvm.
the pseudo IR code looks like
    data = skb->data
    data_end = skb->data_end
    comp = data + 42 > data_end
    ip = select "comp" nullptr "data + some offset"
          <=== select return one of nullptr or "data + some offset" 
based on "comp"
    if comp   // original skb_shorter condition
       ....
    ...
       = ip

In llvm, bpf backend "select" actually inlined "comp" to generate proper
control flow. Therefore, comp is computed twice like below
    data = skb->data
    data_end = skb->data_end
    if (data + 42 > data_end) {
       ip = nullptr; goto block1;
    } else {
       ip = data + some_offset;
       goto block2;
    }
    ...
    if (data + 42 > data_end) // original skb_shorter condition

The issue can be workarounded the source. Just check data + 42 > 
data_end and if failure return. Then you will be able to assign
a value to "ip" conditionally.

Will try to fix this issue in llvm12 as well.
Thanks!


> 
> 	/opt/clang/bin/clang --version
> 	clang version 11.0.0 (https://github.com/llvm/llvm-project.git 4cbfb98eb362b0629d5d1cd113af4427e2904763)
> 	Target: x86_64-unknown-linux-gnu
> 	Thread model: posix
> 	InstalledDir: /opt/clang/bin
> 
> 	$ llvm-objdump -d verifier-cond-repro.o
> 
> 	verifier-cond-repro.o:  file format ELF64-BPF
> 
> 	Disassembly of section .text:
> 
> 	0000000000000000 my_prog:
> 	       0:       61 12 50 00 00 00 00 00 r2 = *(u32 *)(r1 + 80)
> 	       1:       61 14 4c 00 00 00 00 00 r4 = *(u32 *)(r1 + 76)
> 	       2:       bf 43 00 00 00 00 00 00 r3 = r4
> 	       3:       07 03 00 00 2a 00 00 00 r3 += 42
> 	       4:       b7 01 00 00 00 00 00 00 r1 = 0
> 	       5:       2d 23 02 00 00 00 00 00 if r3 > r2 goto +2 <LBB0_2>
> 	       6:       07 04 00 00 0e 00 00 00 r4 += 14
> 	       7:       bf 41 00 00 00 00 00 00 r1 = r4
> 
> 	0000000000000040 LBB0_2:
> 	       8:       2d 23 05 00 00 00 00 00 if r3 > r2 goto +5 <LBB0_5>
> 	       9:       71 12 09 00 00 00 00 00 r2 = *(u8 *)(r1 + 9)
> 	      10:       56 02 03 00 11 00 00 00 if w2 != 17 goto +3 <LBB0_5>
> 	      11:       b4 00 00 00 d2 04 00 00 w0 = 1234
> 	      12:       69 11 16 00 00 00 00 00 r1 = *(u16 *)(r1 + 22)
> 	      13:       16 01 01 00 d2 04 00 00 if w1 == 1234 goto +1 <LBB0_6>
> 
> 	0000000000000070 LBB0_5:
> 	      14:       b4 00 00 00 ff ff ff ff w0 = -1
> 
> 	0000000000000078 LBB0_6:
> 	      15:       95 00 00 00 00 00 00 00 exit
> 
> 
> thanks,
> jirka
> 
> 
> ---
> // Copyright (c) 2019 Tigera, Inc. All rights reserved.
> //
> // Licensed under the Apache License, Version 2.0 (the "License");
> // you may not use this file except in compliance with the License.
> // You may obtain a copy of the License at
> //
> //     https://urldefense.proofpoint.com/v2/url?u=http-3A__www.apache.org_licenses_LICENSE-2D2.0&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=bsFf5gOsaXXCIBYvnl6AK78aRCaFS1zhqvVCYbn4JBA&s=5MVLZXPlXMo2B2K5wDP5P3Lmn4-TQTKHvQfvZupEFvs&e=
> //
> // Unless required by applicable law or agreed to in writing, software
> // distributed under the License is distributed on an "AS IS" BASIS,
> // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> // See the License for the specific language governing permissions and
> // limitations under the License.
> 
> #include <stddef.h>
> #include <string.h>
> #include <linux/bpf.h>
> #include <linux/if_ether.h>
> #include <linux/if_packet.h>
> #include <linux/ip.h>
> #include <linux/ipv6.h>
> #include <linux/in.h>
> #include <linux/udp.h>
> #include <linux/tcp.h>
> #include <linux/pkt_cls.h>
> #include <sys/socket.h>
> #include <bpf/bpf_helpers.h>
> #include <bpf/bpf_endian.h>
> 
> #include <stddef.h>
> 
> #define INLINE inline __attribute__((always_inline))
> 
> #define skb_shorter(skb, len) ((void *)(long)(skb)->data + (len) > (void *)(long)skb->data_end)
> 
> #define ETH_IPV4_UDP_SIZE (14+20+8)
> 
> static INLINE struct iphdr *get_iphdr (struct __sk_buff *skb)
> {
> 	struct iphdr *ip = NULL;
> 	struct ethhdr *eth;
> 
> 	if (skb_shorter(skb, ETH_IPV4_UDP_SIZE))
> 		goto out;
> 
> 	eth = (void *)(long)skb->data;
> 	ip = (void *)(eth + 1);
> 
> out:
> 	return ip;
> }
> 
> int my_prog(struct __sk_buff *skb)
> {
> 	struct iphdr *ip = NULL;
> 	struct udphdr *udp;
> 	__u8 proto = 0;
> 
> 	if (!(ip = get_iphdr(skb)))
> 		goto out;
> 
> 	proto = ip->protocol;
> 
> 	if (proto != IPPROTO_UDP)
> 		goto out;
> 
> 	udp = (void*)(ip + 1);
> 
> 	if (udp->dest != 1234)
> 		goto out;
> 
> 	if (!udp)
> 		goto out;
> 
> 	return udp->dest;
> 
> out:
> 	return -1;
> }
> 

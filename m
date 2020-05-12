Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8821CFC9A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgELRsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:48:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgELRsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:48:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04CHmJEA005109;
        Tue, 12 May 2020 10:48:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ijpcBx7GXvV3BVLhl8Ib/KAUxIJt4kNXlMhwN6lJn0M=;
 b=RNRjBAcQmvfMTN0M4zwgkdB9n/XT023ekWSAE15H/24oiYmFFdlsAutdykunUtBYprfv
 GWCOYoz9Uw/bYheygO226e8w2ALAUA33jyzY3umTmV/AIghrVUjbSsQbfHb82RK9qLe9
 CVRIAGvovAlfxrQ2T0DNy2oCydLE8k0obSQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30ws21hety-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 10:48:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 10:47:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmIqb9fNuJuMMqGu5W2CHShkaZkL8wbHApbwC9qDXsFmJEIXXQp4pJPZKYLwww+JZ8G47VhoSsg4c+pJiaCG78hIOFwghwcuH/qkeT+X4hYrMDDSUjC9Wlfyfeu8qtmlNPntlIatB8jz2QvNL6Nh4ph4ruDaWtlS8sOjjAF/oFeXD5ijMwnMMY59KCFVtJzYWIDWXxf/1fbA4SY1u3ghIA9MM9WtKrocZiaIvmkWGFPZUbV3aUd8A8RUOqC/1SFXN9z5866NB6ab3wgo8sX88UfB1GLz5+xpfyKRE08h2rmU9I2hbw72Vv1dPSv9HZ6YO3N7XiLXsZKPTxTkigFTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijpcBx7GXvV3BVLhl8Ib/KAUxIJt4kNXlMhwN6lJn0M=;
 b=abIVxQ+xRwVjj6ZxpQ1Tu/baYHwb7mJZyNXivAOArelkJwA384z/eOFjmvGngM5dTThwVmubQGZ3K4Ee6w53GlMN/JW6cjzjvNO64ejqZ1NqWLBxVzp9Ew9o+ovWJWqnGhLPNrMl8mcApBwk7VpqcrOb9Z+P4qsxHV6l/LstmrnnI2PS05VoTyzntm85Za0f6mlPEIBjMlLzg2XYPhn/ORIYPEzapeNSIjo6Tf5rfg7lwglhgqUswJC03PDhhen0Tp6pg+eS7HS9dHijp1MX0H669RQIBKV1ZaXrynP1cjo/6JOI2AAuULtlnFo0ZEkAplkqqgs+MZABrPWwyXQrzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijpcBx7GXvV3BVLhl8Ib/KAUxIJt4kNXlMhwN6lJn0M=;
 b=J8wV+Rfh8mwHNRVM1B5rGMCTX2Xax+Aw2pm6tOQHyFVxA/awwEYx7heclv/IxheinEHkmJsQpb2K6/9s2ue9aZ4oexkVoq0o6lTnHCwmL5llLizym1vLNW1pnRDPvdo6tQZizlTnFffTStrh7CIhG5TNIqayy4kDi41pmEFCHdU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2597.namprd15.prod.outlook.com (2603:10b6:a03:158::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Tue, 12 May
 2020 17:47:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 17:47:42 +0000
Subject: Re: [PATCH v2 bpf-next 2/3] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200508232032.1974027-1-andriin@fb.com>
 <20200508232032.1974027-3-andriin@fb.com>
 <c2fbefd2-6137-712e-47d4-200ef4d74775@fb.com>
 <CAEf4BzaXUwgr70WteC=egTgii=si8OvVLCL9KCs-KwkPRPGQjQ@mail.gmail.com>
 <b06ff0a8-2f44-522f-f071-141072d6f62b@fb.com>
 <CAEf4BzY71QEmq74B8y-AmW1LFhFZ35TwO5vLn4AOiJPOSVqtjw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f06414a3-cd74-2223-8d15-bed62744b891@fb.com>
Date:   Tue, 12 May 2020 10:47:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzY71QEmq74B8y-AmW1LFhFZ35TwO5vLn4AOiJPOSVqtjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0064.namprd07.prod.outlook.com
 (2603:10b6:a03:60::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d0f0) by BYAPR07CA0064.namprd07.prod.outlook.com (2603:10b6:a03:60::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 17:47:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17396c0e-de35-4aea-1eab-08d7f69c9256
X-MS-TrafficTypeDiagnostic: BYAPR15MB2597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB259734F1D4B13DEC6FBE10B3D3BE0@BYAPR15MB2597.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f0Mu8f5yQJaQ11WJZsNtPTqkguU9Xst4UL1DX3bJk/yN/Gm0yQRQOkBOh/HE+xEJA/q4125/jW1/BF83UJZsUWj85oyyUeAn1cxDn3gWe3+rhU1j1WRHpzRu10HSauvYOcx/WMcPBe7wHabeJi3hq8UA2ZMD0U3MZxZ67zyjQTMT4lhYwwFmaEl0rFGepzNWnSPgNtcX3/rDVyzaAEj4IIokh1Ee6uGyG9sXSpB1txrfyBtJtnKydqm485MLL0pMKZcesYA0I3XuzfCChHflCRQKuojq0OxEuHGW0ZdmfXdWyH7BJFgqSlieV2Qz3Ng3CEVuM8dx6YtsS8+1MShLQBuyQfsWIFbuE3f87xtGV4BaZMruHwc0pfTwDouLrmPf4ZBSuX8KDCV7iWbIWAsgZrkN9p0fKWcIq/dgmwzTahKppJO0WUyvFdvIMZ5MYbfjaNM1JmNL/Sk2z9sJE2k1fzZWqrcIvIcRRf9lSSo6kW/CEtomlg3bJj2Vf7aWZQqANo6pxHDnwKvpjhUWTv/l0KViXumBnGXfPGLudwpOjReP9SumdGCUU2fkyaisuSYy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(33430700001)(31686004)(186003)(16526019)(36756003)(66476007)(4326008)(86362001)(66556008)(66946007)(2906002)(54906003)(33440700001)(31696002)(478600001)(5660300002)(6512007)(2616005)(316002)(6506007)(6916009)(6486002)(53546011)(8676002)(52116002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XdxPj7FekPa3P6T/NsZGfETE0xrLR6PRV4RHknq9XxOjABfDfxsJVTzOAEhmIHelaCPr2OM+PsjYiGSYWp5YYWK3ly2TUMQYgkx5iOXau7BYV7GGDhUY0Ok3dvkbDAnpkqJKMb1CwepikmmS7tlOqkMi93hiVtqmXlsrDzrPDwfc7xWFVncBZJBNrVnXmOmk7c0K1PzXdBsqj1V09UUymwyKaLV4UIPvEZ3ngdOltKA5OqTZkOUl9U4S0yK6ePtNpURyAx4hDMr2cgEgKO7RJgDqm6jEfkmE35Rn1iz1xpH64yqJ798pxKgWu+rsX4P5ejqmWGpDJUqdSQl/EPAXu7AdjG5BgrGpZqR5xnKSEJY9gAvqW/8yW8RPMG3F8pBovfmNEapvzUeTC2gT/gl5nwPefWuRo9rc/nlV/bKUvnEpY8Q5ABL35YoPDsA3FQtpYJPJ1n0M5+dGRjM6qjMVq2BL1ndRhLzCoh+ALc/kL2FEzhSiy6z0hNUMWtDdbfvGDXkoqFn4TbCbpJAT4jbBXQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 17396c0e-de35-4aea-1eab-08d7f69c9256
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 17:47:42.8202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: or6Oq+eZt/ziXZ5sTDrE1ZtnFdR/EFT3vR8pX5Mf7us6qvMl3SqPgbh5LrUbo34+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2597
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_06:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 10:23 AM, Andrii Nakryiko wrote:
> On Tue, May 12, 2020 at 8:11 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/11/20 9:22 PM, Andrii Nakryiko wrote:
>>> On Sat, May 9, 2020 at 10:24 AM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
>>>>> Add fmod_ret BPF program to existing test_overhead selftest. Also re-implement
>>>>> user-space benchmarking part into benchmark runner to compare results.  Results
>>>>> with ./bench are consistently somewhat lower than test_overhead's, but relative
>>>>> performance of various types of BPF programs stay consisten (e.g., kretprobe is
>>>>> noticeably slower).
>>>>>
>>>>> run_bench_rename.sh script (in benchs/ directory) was used to produce the
>>>>> following numbers:
>>>>>
>>>>>      base      :    3.975 ± 0.065M/s
>>>>>      kprobe    :    3.268 ± 0.095M/s
>>>>>      kretprobe :    2.496 ± 0.040M/s
>>>>>      rawtp     :    3.899 ± 0.078M/s
>>>>>      fentry    :    3.836 ± 0.049M/s
>>>>>      fexit     :    3.660 ± 0.082M/s
>>>>>      fmodret   :    3.776 ± 0.033M/s
>>>>>
>>>>> While running test_overhead gives:
>>>>>
>>>>>      task_rename base        4457K events per sec
>>>>>      task_rename kprobe      3849K events per sec
>>>>>      task_rename kretprobe   2729K events per sec
>>>>>      task_rename raw_tp      4506K events per sec
>>>>>      task_rename fentry      4381K events per sec
>>>>>      task_rename fexit       4349K events per sec
>>>>>      task_rename fmod_ret    4130K events per sec
>>>>
>>>> Do you where the overhead is and how we could provide options in
>>>> bench to reduce the overhead so we can achieve similar numbers?
>>>> For benchmarking, sometimes you really want to see "true"
>>>> potential of a particular implementation.
>>>
>>> Alright, let's make it an official bench-off... :) And the reason for
>>> this discrepancy, turns out to be... not atomics at all! But rather a
>>> single-threaded vs multi-threaded process (well, at least task_rename
>>> happening from non-main thread, I didn't narrow it down further).
>>
>> It would be good to find out why and have a scheme (e.g. some kind
>> of affinity binding) to close the gap.
> 
> I don't think affinity has anything to do with this. test_overhead
> sets affinity for entire process, and that doesn't change results at
> all. Same for bench, both with and without setting affinity, results
> are pretty much the same. Affinity helps a bit to get a bit more
> stable and consistent results, but doesn't hurt or help performance
> for this benchmark.
> 
> I don't think we need to spend that much time trying to understand
> behavior of task renaming for such a particular setup. Benchmarking
> has to be multi-threaded in most cases anyways, there is no way around
> that.

Okay. This might be related to kernel scheduling of main thread vs. 
secondary threads? This then indeed beyond this patch.

I am fine with the current mechanism as is. Maybe put the above
experimental data in commit message? If later other people
want to do further investigation, they have some data to
start with.

> 
>>
>>> Atomics actually make very little difference, which gives me a good
>>> peace of mind :)
>>>
>>> So, I've built and ran test_overhead (selftest) and bench both as
>>> multi-threaded and single-threaded apps. Corresponding results match
>>> almost perfectly. And that's while test_overhead doesn't use atomics
>>> at all, while bench still does. Then I also ran test_overhead with
>>> added generics to match bench implementation. There are barely any
>>> differences, see two last sets of results.
>>>
>>> BTW, selftest results seems bit lower from the ones in original
>>> commit, probably because I made it run more iterations (like 40 times
>>> more) to have more stable results.
>>>
>>> So here are the results:
>>>
>>> Single-threaded implementations
>>> ===============================
>>>
>>> /* bench: single-threaded, atomics */
>>> base      :    4.622 ± 0.049M/s
>>> kprobe    :    3.673 ± 0.052M/s
>>> kretprobe :    2.625 ± 0.052M/s
>>> rawtp     :    4.369 ± 0.089M/s
>>> fentry    :    4.201 ± 0.558M/s
>>> fexit     :    4.309 ± 0.148M/s
>>> fmodret   :    4.314 ± 0.203M/s
>>>
>>> /* selftest: single-threaded, no atomics */
>>> task_rename base        4555K events per sec
>>> task_rename kprobe      3643K events per sec
>>> task_rename kretprobe   2506K events per sec
>>> task_rename raw_tp      4303K events per sec
>>> task_rename fentry      4307K events per sec
>>> task_rename fexit       4010K events per sec
>>> task_rename fmod_ret    3984K events per sec
>>>
>>>
>>> Multi-threaded implementations
>>> ==============================
>>>
>>> /* bench: multi-threaded w/ atomics */
>>> base      :    3.910 ± 0.023M/s
>>> kprobe    :    3.048 ± 0.037M/s
>>> kretprobe :    2.300 ± 0.015M/s
>>> rawtp     :    3.687 ± 0.034M/s
>>> fentry    :    3.740 ± 0.087M/s
>>> fexit     :    3.510 ± 0.009M/s
>>> fmodret   :    3.485 ± 0.050M/s
>>>
>>> /* selftest: multi-threaded w/ atomics */
>>> task_rename base        3872K events per sec
>>> task_rename kprobe      3068K events per sec
>>> task_rename kretprobe   2350K events per sec
>>> task_rename raw_tp      3731K events per sec
>>> task_rename fentry      3639K events per sec
>>> task_rename fexit       3558K events per sec
>>> task_rename fmod_ret    3511K events per sec
>>>
>>> /* selftest: multi-threaded, no atomics */
>>> task_rename base        3945K events per sec
>>> task_rename kprobe      3298K events per sec
>>> task_rename kretprobe   2451K events per sec
>>> task_rename raw_tp      3718K events per sec
>>> task_rename fentry      3782K events per sec
>>> task_rename fexit       3543K events per sec
>>> task_rename fmod_ret    3526K events per sec
>>>
>>>
>> [...]

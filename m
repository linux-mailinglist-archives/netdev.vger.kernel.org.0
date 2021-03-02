Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71AC32B39F
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449849AbhCCEEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61097 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1574036AbhCBRVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 12:21:19 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 122HDFg5004669;
        Tue, 2 Mar 2021 09:19:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9K8d3OKl7wwGuFCQbRxMDix+2RTH/XjX831XjYnj04E=;
 b=U/aw/62g9VCc8LWl9Jwp631hGoEQcx/CuXsnhxY9bAzy0k2aFhw08wMi0S3dargKjkcH
 v9G4smV3gFoB4RdY2YvBC7ILaguVZbKd601nEgSGyhZEgXGfObj3d0ub3BbP5kDM3gEL
 WQyvy5oLW0Bv+YnSRJyrsijkHiQaigIcEQY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 36yjmufqbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 09:19:56 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 09:19:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayTspV6wiYjrNusMyzox99yIzxrhopWjXmDwcTfC6eFAKkI2HFUNg8Az4WQGA16HVrPpDINFEHK0Q5S6siIAINuq3GE3/nw0+yFa7K5J+Qx62nFvIm/sLTrf3RNCXcumGk7mcNNlja4AaP5MRy/RFpMnaSktzfTZOKonwNG4jB6kidRbkre8p3GoDmLNS4BvtAt+EiTFwms6sKXdsVgqcN+qJCGodejcUIAYi9YZRw8DOPHU4NM/EktMb+UTfR+AR7iWD8qfFsGuXdlcnZraWyZOUCtyZuJ71CFlDTsHI7aPEWy6IBnSmj3DulJ3U6FORC6xmW1w8uLilyHu5igLdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9K8d3OKl7wwGuFCQbRxMDix+2RTH/XjX831XjYnj04E=;
 b=Civ3+vut8sWvblMjYnqhPLizHJ0530DN5tETTWD2Edclq0VZYMTUkIrhfDkFY9BjPfs4yNQQ7LH1dmCQ98R6cfrIKIX2nIPRPlBhI72luiGc8W0pGnpildYmqS70PT9BW+P2YvYCV9Ygwgle5vODJjNfXzZDfjgEVxalAR9E/2TRdKduQVxJqvPKx9tELm/91vgV9u3MzXYzGMn9Lzqhd/vgzcpJvoBjQ2SatOHhxwCJu8ap0V3FAdkl9gZFLIAV8MMmYB6mXxkxLjklaDjD8n6ZLVbI1eupZTO63evHpFZFxQuUfaDFuRFN1DuouhGr+i9Hyu671wxpbu1hrr6GEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2254.namprd15.prod.outlook.com (2603:10b6:805:22::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 17:19:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 17:19:53 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for powerpc
 uprobes
To:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
 <YD4d+dmay+oKyiot@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c18d94d3-3e5d-08f7-a8ba-f13bfa7eec05@fb.com>
Date:   Tue, 2 Mar 2021 09:19:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <YD4d+dmay+oKyiot@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6ddf]
X-ClientProxiedBy: MWHPR18CA0031.namprd18.prod.outlook.com
 (2603:10b6:320:31::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:6ddf) by MWHPR18CA0031.namprd18.prod.outlook.com (2603:10b6:320:31::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 17:19:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e30e75c3-729b-4b39-0dfb-08d8dd9f64e5
X-MS-TrafficTypeDiagnostic: SN6PR15MB2254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2254A545545332A7C368FE9FD3999@SN6PR15MB2254.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJpdNZjbTLCILLoRdg6qLWKjQGYf02vqahbCmnGascYzjAMmrQKwz/HPQmL5i25YlxuAkUeJl+rS71opom5BL3oMkBA4/sXziXETXRtu/gZ90y+25qmSkZCS7nVDE1bM4hJ91LMGE1ODvvrT7BOhvOBhbeWjTpp0tED6Jk3uSn60G67Bm2Zu91MqV8WfZPGHhYvqnKFvfg6tg+MofXIlo4A+x3CT7wA/RA58EX4Tks5JflQMa7AciDjG9dDk4m3pOiKGmEEQZwkRydnrFBo4/a2q8Tqngk+0N3666pg1BqpU8FP11yWBcJQxWo2YemAUXDmqDkzceA6QWG+damJCXhvag86PY+MJL9Fjpeiv6ks/Tb257GQpocvyWh9bG7oNxTq3s+5cpO8HguuAOz4NO2HrhYmEbZxAvSJIkWCYXTMQ73vyk6tTeLO3+vdPzOpXjxx3LiVtjlaHe7owraig+YM1rADh+hdSFK2JLU/1MiBIPN6se5KlBhNouskp0ZCclfKgeGbThiG/80Y3byPoOvoiWykR6JMFRQnWwhwwSQM0T0Du/iGRHp+BwaxMHrvUjEYZz43G6uszOjTLJLBM0xwPbCoMyDbuFrRmF3sLCeE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(366004)(376002)(31686004)(66476007)(36756003)(4326008)(5660300002)(7416002)(86362001)(8936002)(110136005)(186003)(66946007)(66556008)(16526019)(2906002)(2616005)(31696002)(316002)(478600001)(52116002)(54906003)(53546011)(83380400001)(6486002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K3RobnlJMjF0Q3d1OFFHb3EwS1RzeWtSRWx2UitIbEs1T2taOElPUnNIYVlz?=
 =?utf-8?B?YzFsVmI1NmNRajIxbnhkTldSOXdVdVk0UlUzV1ZFTjRYVTVRb0p1eENaa2pF?=
 =?utf-8?B?Vzd0d2RNc3pRb0xwaEZsb001TCtmaEZadFYvR29KWTJtSXhLNlhlbUZWRmlr?=
 =?utf-8?B?RWNjUldnVzRocHRBV0xCRE50Zk5hYTRSYktlYWxXVWRrTXlKT1c0c2VhSXRi?=
 =?utf-8?B?MWxqWHhMRDMxdnFSdGFLSWJWcmdQNTBZeW5VMmkxUU5WSlM4V0puTnIyaThG?=
 =?utf-8?B?MHAwRzU0S0JWUlZLcTVpWXI4MWZFVXRwYjMyam5SYVljd1R1Q21ra0VwNHp2?=
 =?utf-8?B?YWR1Ly90Z1UwakpPNk9yM2J3bmFuYnFKbVJWeVFTSklLVG43R0tTVmt5V2RX?=
 =?utf-8?B?RHlTQysraHhOTFVhVDBvYUJwSmJpdmlPeElhd0kxVDU1Y3hpRWs5alIwbmNa?=
 =?utf-8?B?Y1gzK3FGSlRkUFI5bG9BNkVvTFZCenN5TTlkbk5yR01ZNzNwMGVQdHpKS0lp?=
 =?utf-8?B?M1I4djhrMm1NOW0xeEppWUd6Ui9lTENJT1lOQXBCWVFVZm9mVXZnYTdEelpx?=
 =?utf-8?B?V0JPZWszNEhNWXUzWDdvK2VSZEJsOEh6bnFXcmo0NWpWQjRPNVFIaXhoUE5O?=
 =?utf-8?B?c0NxTExFNHdKUXV6aVFCMEw1SlhzZGJQcWd6NjRlbUgzK1ZicVpvZDNHZjdT?=
 =?utf-8?B?UW9JdjVOeFg5MjNZbWJsSEtuekJHQTkzL05reHdLYzNuQU9kMitSa01ZcFky?=
 =?utf-8?B?Tng3WE9FM2Y1U052SmJHdDZFQXptS1FiMkFFSC9OOHdGbnRzMCs1SmZ2aUYy?=
 =?utf-8?B?RDZlTEc1UEp1TXZEclZnUlJaK1FtVzdlNFdIYmF4SjBWMjgvRXNQK1pqNnRw?=
 =?utf-8?B?ME0xRTY2VzJTQjJRRDZUYU5wZi95dE5vRDJVeWtQOVR4aTBYUS9zV1BRRUhm?=
 =?utf-8?B?QU9Ocm9mSW4rVnNFbHhFSklTdUdxeVU1UDIzclFKOU4vUkNmM3JOTlA2VW9n?=
 =?utf-8?B?ZjlKU3lscm5XalNaTXJrc0NCeUpGRW9mTzFhT0ZzZ3M2U2sraE9OTmNrVDc4?=
 =?utf-8?B?WUs5b2FsQkRnSTl3N0JUTE13ZTRFbHRBeGZkVFBpNTA5ODNUMlRkVkxYeTJq?=
 =?utf-8?B?UUpvcjFTY2NOeXVtc0RWWDNTSXdyajVRREZ1blJneXhmMk4vYzIweEczK3Rq?=
 =?utf-8?B?TUFHbWR2d3ZnaVVGYnJTZS9ROGUxS2greXFiMU5JeGQveFc3bjlHQzNxWVhZ?=
 =?utf-8?B?SkVqbE9IUS93UDczQTdOOVlob1B0UXdoSDhFRXdhUU43dG5rOTd3cUdQaEpD?=
 =?utf-8?B?cXZjdnpxZDdsQ0JXdE9HQ0tRdnNwY1h1b1VDUnJRdEtlb2ZiVFMyWnBoSW0x?=
 =?utf-8?B?b3BkeU4yNEgyMnBDNFk0UHowcGUyMVpYMDIvRmg0cllsTlZPQjJWaW1UYXdI?=
 =?utf-8?B?bURtM3RCMlJMUFBKNEVSK1FsYzR0Vnp5LzJxdlluS3BSa1ovZER5M1VlbkFX?=
 =?utf-8?B?cy9SU0xkdE9HOW42K04xTXhXY1JoTUZZdkwxTXhacnYvZWVMZzNDcWlvdWJK?=
 =?utf-8?B?V0o4S3c4ODluelFGMkk5MUZtc0JlQnE3M255MURoYWV2Vy8xbTh6QjJNalhp?=
 =?utf-8?B?ZFFRMDdINi9GR2pCWWg5Z2FENEhaRG42YlVUcEwzc2VwUFZEUTRua3hzblFr?=
 =?utf-8?B?akZHaExGS2FnM0NteDVhQXRpQWlhNUJCcGtyUTdzNWRtdTV1bFFac0dNK01X?=
 =?utf-8?B?alQ4cUtBckpOMTVleVc1TDJPVGFGa1VTUFluaVU2a3VHNjFHcWFCMjY0Zk5s?=
 =?utf-8?B?VHF0aTAzNlFaZmx1eXNOZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e30e75c3-729b-4b39-0dfb-08d8dd9f64e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 17:19:53.7075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bxkiQvzcVLE13yBvTtfFM7Tw0IE+2yztELg004AFW7ZxzNciy0q+0bgV6AzRJpT9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/21 3:14 AM, Jiri Olsa wrote:
> On Mon, Mar 01, 2021 at 04:34:24PM -0800, Andrii Nakryiko wrote:
>> On Mon, Mar 1, 2021 at 11:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>>
>>> When testing uprobes we the test gets GEP (Global Entry Point)
>>> address from kallsyms, but then the function is called locally
>>> so the uprobe is not triggered.
>>>
>>> Fixing this by adjusting the address to LEP (Local Entry Point)
>>> for powerpc arch.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
>>>   1 file changed, 17 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
>>> index a0ee87c8e1ea..c3cfb48d3ed0 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
>>> @@ -2,6 +2,22 @@
>>>   #include <test_progs.h>
>>>   #include "test_attach_probe.skel.h"
>>>
>>> +#if defined(__powerpc64__)
>>> +/*
>>> + * We get the GEP (Global Entry Point) address from kallsyms,
>>> + * but then the function is called locally, so we need to adjust
>>> + * the address to get LEP (Local Entry Point).
>>> + */
>>> +#define LEP_OFFSET 8
>>> +
>>> +static ssize_t get_offset(ssize_t offset)
>>
>> if we mark this function __weak global, would it work as is? Would it
>> get an address of a global entry point? I know nothing about this GEP
>> vs LEP stuff, interesting :)
> 
> you mean get_base_addr? it's already global
> 
> all the calls to get_base_addr within the object are made
> to get_base_addr+0x8
> 
> 00000000100350c0 <test_attach_probe>:
>      ...
>      100350e0:   59 fd ff 4b     bl      10034e38 <get_base_addr+0x8>
>      ...
>      100358a8:   91 f5 ff 4b     bl      10034e38 <get_base_addr+0x8>
> 
> 
> I'm following perf fix we had for similar issue:
>    7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup
> 
> I'll get more info on that

Thanks. The patch
    7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using 
kallsyms lookup
talked about offset + 8 for kernel symbols.
I guess uprobe symbol might be in the same situation if using the
same compilation mechanism as kernel. But it would be good
to get confirmation from ppc people.

> 
> jirka
> 
>>
>>> +{
>>> +       return offset + LEP_OFFSET;
>>> +}
>>> +#else
>>> +#define get_offset(offset) (offset)
>>> +#endif
>>> +
>>>   ssize_t get_base_addr() {
>>>          size_t start, offset;
>>>          char buf[256];
>>> @@ -36,7 +52,7 @@ void test_attach_probe(void)
>>>          if (CHECK(base_addr < 0, "get_base_addr",
>>>                    "failed to find base addr: %zd", base_addr))
>>>                  return;
>>> -       uprobe_offset = (size_t)&get_base_addr - base_addr;
>>> +       uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
>>>
>>>          skel = test_attach_probe__open_and_load();
>>>          if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
>>> --
>>> 2.29.2
>>>
>>
> 

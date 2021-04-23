Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328AC369D46
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhDWX10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:27:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhDWX1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:27:25 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NNOCxe032184;
        Fri, 23 Apr 2021 16:26:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8nE8znLCJUeVlPfX6GJzuuEo02nr/0f1qCCCTiFoX1Y=;
 b=nfe/D2q/21H/SdgYQnqxoXX+VUXBz1YU1R/3f6TyZO8S0PiTDf8LDuYUNvqBvtxSmWqx
 SKDNzY7FRG3NkEiVuFA4nYqbkmH67pMVtTKpFPYnCkkJJtyz0/wLOrcGrYhZrwdwcjaq
 Rz+u/uLcFYGXld45iiBNq/7MNl5QfwyOYAs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 383kvnp6a5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 16:26:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:26:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk6GgCpTF1dUKb7x8x2Cc7UBsrjbRB7vLuhGhCZoFp60GFjDqfPsm9KrzKpJDzeqA6MezAM7eFeSZS3dFDitO7OXcHWN1brAMjiVX/jNS/ZZCLvaM+K47UrWZiGTsQsmL128AGE2yD9HpuTCGur3rlNlKxLQli9wQ7oIsr+MALbPkRPYss1+DHQSKBYIy0NG43+kTTH0Usqq42CJzvP8vLfJVFgG47/NEvPxqLAjr9idfky0fb8TrDkQnl5dUDTmI5KJEr5UL/w3KzYIjcDV0sfat3z8ciHST8vacj9B2O5LjkOW+ZEKC9JxZ1Mtj3mTR7dFgyUpzQGqNhiArg2KpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nE8znLCJUeVlPfX6GJzuuEo02nr/0f1qCCCTiFoX1Y=;
 b=jewsc0ztuyGqXXzTZjOPklJ6/w4kAeJrnDrNtbwSSA/6nLz3rc7HdjB3vACeL5nRNMnnOpIOR/hAUHEOdQq3Sm24geB0zh+GZ2VF909a4q0zvieHA2TzMDhwoJhIC7guuQ/9Nsn2LLniO16bGfi1bBnJBlU9mQoDaFdczhtIA2xgxkxwaeaEEvp+Oe7LU1qZQt6EtMihs5beZm4AhMKZo2LV46ydEjVFHggzM9lPLaxvC5rvYrg9i+Hwmu3Giq3oLVqVxun07cMql4fksHN7foxZuDC12390wpvZ7zpjly/C7VMn3V7v5TuBRl5ng11QpCsxkEeLAqvcHESg4tjPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4339.namprd15.prod.outlook.com (2603:10b6:806:1ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 23:26:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 23:26:31 +0000
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
 <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
 <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <588c763f-1383-d92b-116a-c6826ffa1418@fb.com>
Date:   Fri, 23 Apr 2021 16:26:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7ce]
X-ClientProxiedBy: MWHPR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:300:16::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::134e] (2620:10d:c090:400::5:a7ce) by MWHPR13CA0008.namprd13.prod.outlook.com (2603:10b6:300:16::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Fri, 23 Apr 2021 23:26:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4940c9a1-6858-4265-fba4-08d906af39e7
X-MS-TrafficTypeDiagnostic: SA1PR15MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB433991A820C9EBFF5C3BC548D3459@SA1PR15MB4339.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccgDtqfS05UZ9LFYEq89zTY/Clw6cFjQYQAgOX2CKp+zpkNodbAogYGkD4S5l8VZHPvTyOocOEqGuwffpG+NxJD0kBIKWg1otEJC1BKJ5KgiQyzuljarCpFOVyDSBcpIH5nagE+3d/eNUI+u5lvFvXKoxrs2NPCglcHMf0IK/UBY/cnLGHUDygK0XcWKe71MhGvyVg4IQhET+OoMyBEECUvlS/qYK1AnZkTt6SuyJ+6vv1EGQeAmHOIanjjdSwnsrw64kWdsQ3WAYGPvv1KYLBl+Rx1jFWGIDNoewRP+U9mYGzDaWkPDZeMoc4hPLSKS7EWpE75H5T3LUTSUqGG3/jfcQHmmMSwRXr3HNfUCEaDuLGqsRiPSE6xRzm/B0ZtbuwXxzWLY7Ujk5YgD/nZQfwyNIdYsftBDYGxNn5Yn3riY5gnekDSdC1O51Z4veWwg2g68fnmcNWStxc/ktijvyTRWi19bzC/HIzYinTu7MUnyONXfH3XHe72KXbNNmyHZb7xkaTRPHkc8mvgxcncUAhNbicdmHr2sL3J8F52PwoOyTKsiqkiIjSZT8JfSSa9Uca5z+fx5x611rMEJLuRCvFCjWNB9kIpTdF281tvMFpO6c3xbZyXOQLlLkWCOFL8p0UkXrZ/XkQ7mxPWCSKYBjK/wehHai40ULtmDP4llumutevm3KBoTSTMepF8KKHQX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(36756003)(8936002)(4326008)(478600001)(52116002)(2616005)(53546011)(6916009)(31696002)(6666004)(86362001)(8676002)(186003)(16526019)(83380400001)(66556008)(66946007)(6486002)(66476007)(31686004)(2906002)(38100700002)(5660300002)(316002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djQydGZNVU5sM1loaG5iUm9BRGdSMjVUQStndU9nNThJRVd5TXNCUHNFUkFp?=
 =?utf-8?B?TTVJNWNSbHRuUUpuMW1SNXpRSTlmU1hXZllDbFl3Y2xvQTl5c3lRWHN1Yi9D?=
 =?utf-8?B?aW1YMkV1SDU1VTBwK2lmK2ZRVzBoSjI4R2NYQ1ZZc1lPVEozQS9wSURmRG1v?=
 =?utf-8?B?c0ZJY0hNdVdqd2U4UGJaR2d4ck9Wc25Gb1c5QVQwdWdLSm5oZ0FTRnRIOWV4?=
 =?utf-8?B?MEpiMGdHWmpTS2gzU2JRRVJqL3MyWEtyc0VMTS8yNDgyTElkQ21EK2U4Wmx2?=
 =?utf-8?B?ZGU3Q3QvNmh2RU1sUjVmUGRlSmFSYkVreGdmQ2cvci9wWks3SnVPcTZZcTho?=
 =?utf-8?B?TnRMbkx1ek51ZmFNMW0yNGxqZDZTQzhaOUZXWDlkZkJkYmdDcXJ1YTJ3VE9H?=
 =?utf-8?B?NFhCT1VoSWdwU0J4eC9iNGxHRTFEKzJRZG5pRGp3WVJHc1EzTmE5NWZ5NTFv?=
 =?utf-8?B?QmxzNmZ3R3VwNm5oZnhIVkhMUjlMVXk1MFZLNnRJVmkzODlWWERIZzBYM0Jt?=
 =?utf-8?B?aFF1V0R1ZVZWdFllQ2s0eDNzOUplNUJMM0ozaUs4ZHBUbmd2bXYvb0liQ2NS?=
 =?utf-8?B?WmV0VTV0RlJrV3d6SUl5U3QvQktzRHBRM2JOcnhackFFbEVuR0pacnRtRlA1?=
 =?utf-8?B?QjV2UGM5S25HVmtiV3J0eXFzdmhUakQyeWMxOVNUWG1zRDBTa2xZNVAvdDcr?=
 =?utf-8?B?S2htb1gvVER5eHpYc2hRaUZxZmlIaElFb1VsaTJtbDJvQWZ2QUhxK0F1Y3Rn?=
 =?utf-8?B?NCtSQldvSUUvbmJ3OUplRFhlQ25nQ1IyUWU0Z3BqWndqdWYvc0Vra0xCeFd0?=
 =?utf-8?B?dlR3YXFBdFJtcGVsaE9tVVU4QldpUEdPQlVzQ01PL1R2d1J5bS9pTTlINFBS?=
 =?utf-8?B?QjQ1SlB6VmdjME5aRWdsb1lEUFNBUzYveSt6Q3lIOWg3eTl6azRNVTVmWEZ2?=
 =?utf-8?B?Mmk0czhNWjVJalBqTTVKYnBkRVBpRUN3dDArSTZsbndSSXY4dDh4T1VFb0xj?=
 =?utf-8?B?bHozU1JoYldSZ0R4NUZYVTVQbGQzcVZ4azZFeDd5S1FVU210bnFQRkJqUm5F?=
 =?utf-8?B?V3BLbXp4d0FPSE80MFVUbUx2YXM5cjl2N21MbEVzN2cwaWVlRXJnbkt3Z0tW?=
 =?utf-8?B?VStUbnV3VkNVZ3VHUXFOWkFKUXFCYndZWkpWUEpucWxpMm1qZGFldUwranRx?=
 =?utf-8?B?d0w4VnJXWmFGQmNZUnJldHJyU3hWTW1SYmdSdzFlMEpvZFFUdHZrQlRZZkpo?=
 =?utf-8?B?bTNielJ5VitKYTNGWVVrUDI5ektDWG9Rd1d0R0lmeHlIUWtMdHJDNWQ0VjBX?=
 =?utf-8?B?WCs5Qm95cHBFTzhHNVlmaUdyR0dOelVRWmN6STdocjBRZE9zYS9CcFFQNTN5?=
 =?utf-8?B?YmlXaTdiaVN4WGd2YjNUVEh3VlZhbmpMbG1kNHB4alpYU0hrcXcybTQ4aWZ1?=
 =?utf-8?B?SkZmQkxqYlRzeTd0TWlvd2xKZDNsL0NncnZhRWhhNkVHYlQvV0ErL29VeWNu?=
 =?utf-8?B?QTZ2YzhsVnVnUHdzUUpOdEhaUFA2d09vZTY4ODRVRGs0Y3hydEhYMG5aa2cr?=
 =?utf-8?B?WEhVcktmVWovM1NFZE8vNHFvYUFTbDFhbXVmL3c2eStpRmNVdmc0RGd2KzQw?=
 =?utf-8?B?cHNwQW0zbVc2YlZSQVlTeDFtZ2VsMisrMjVZeC9VMnl6U3oza1JKdGQ0VU1Y?=
 =?utf-8?B?b0FyeUtING1PS0xzSDg4Tjk1eFJjNlZvM3FSclpVTWEvRHRGVkd0aVZnRC9j?=
 =?utf-8?B?RGFhd1ArVzh5UVVzby9yMmNUSDJKMS9nNW5RckJpQUdjOG84aWdPaTZHOXdm?=
 =?utf-8?Q?W/96aUougSK5Kc4+fHXBm22S4n2zLONXQf2W4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4940c9a1-6858-4265-fba4-08d906af39e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:26:31.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mCaXUWo5dLIWvFmtzICODrKF0l2Z5Fb5LQXUlfpX6RCys1ozPqjJQPxft/IYNN0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4339
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: G6qDaJ1juV0T2wIStG1fnCR6cLuwcKur
X-Proofpoint-ORIG-GUID: G6qDaJ1juV0T2wIStG1fnCR6cLuwcKur
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230157
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 4:05 PM, Alexei Starovoitov wrote:
> On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>
>>>>> -static volatile const __u32 print_len;
>>>>> -static volatile const __u32 ret1;
>>>>> +volatile const __u32 print_len = 0;
>>>>> +volatile const __u32 ret1 = 0;
>>>>
>>>> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
>>>> this is not in a static link test, right? The same for a few tests below.
>>>
>>> All the selftests are passed through a static linker, so it will
>>> append obj_name to each static variable. So I just minimized use of
>>> static variables to avoid too much code churn. If this variable was
>>> static, it would have to be accessed as
>>> skel->rodata->bpf_iter_test_kern4__print_len, for example.
>>
>> Okay this should be fine. selftests/bpf specific. I just feel that
>> some people may get confused if they write/see a single program in
>> selftest and they have to use obj_varname format and thinking this
>> is a new standard, but actually it is due to static linking buried
>> in Makefile. Maybe add a note in selftests/README.rst so we
>> can point to people if there is confusion.
> 
> I'm not sure I understand.
> Are you saying that
> bpftool gen object out_file.o in_file.o
> is no longer equivalent to llvm-strip ?

This is more about BTF and ELF.
Give a simple example,
$ cat t1.c
volatile static int aa = 10;
int foo() { return aa; }
$ clang -O2 -g -c -target bpf t1.c

Using bpftool compiled with this patch:
$ bpftool gen object output.o t1.o
$ llvm-readelf -s t1.o | grep aa
      3: 0000000000000000     4 OBJECT  LOCAL  DEFAULT     4 aa
$ llvm-readelf -s output.o | grep aa
      3: 0000000000000000     4 OBJECT  LOCAL  DEFAULT     4 aa

$ bpftool btf dump file t1.o | grep aa
[5] VAR 'aa' type_id=4, linkage=static
$ bpftool btf dump file output.o | grep aa
[5] VAR 't1..aa' type_id=4, linkage=static

So yes you are right, this will affect skeleton user
if you use static linker with single file.

> Since during that step static vars will get their names mangled?
> So a good chunk of code that uses skeleton right now should either
> 1. don't do the linking step
> or
> 2. adjust their code to use global vars
> or
> 3. adjust the usage of skel.h in their corresponding user code
>    to accommodate mangled static names?
> Did it get it right?
> 

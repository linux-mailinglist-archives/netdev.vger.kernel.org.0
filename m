Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55451AF820
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDSHCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:02:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51620 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgDSHC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:02:29 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03J6tIiY009959;
        Sun, 19 Apr 2020 00:02:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tMH5J0Nswj6r8JkARTbAgpu7QsI6bFAKn663zV7wnXY=;
 b=CrKv1SEOeZaiLdW2DhRr78eC5Go3zFUUrfqFtx7Ig6s0EojjllEbx/6fmblzo/Cl9p96
 j09EWPdrN7Qx4RzJvVkdEVGFs4Aod54Nu5Pdnyj9Emf1ikaw0UsuEC+xL54mrLqMfcxM
 LBbImAYrn9Zd+rDWV0Vu747Iyv+jItmfuZ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30g0vrb9rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 19 Apr 2020 00:02:13 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 19 Apr 2020 00:02:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T28PYLoWH0SfxOb6tf6M+jrzZ/A3LqljkBUEIP+J16PQl6yaB9UcWaAosF/dIy5kd5c/0wpTw+4m3sW3rlcmGilSic4uOti7Aj3O+fqiyMyuyOSfHtT3UAtGqfMK3eEVkI7eoFnSz/HvQdt9IsIKRKKFN40zNztt+7vbQg+SsoUmDlYLSrnD8nvpwge/gfI4QZahJxpm55MPUqrgjOZfzcNWRTaM+sWavDRl3Du/cCkGuJNV8Rd0eESTFfzJ0xrgHSB8lV71p2wWFQ4CuYIF1qZj07jCQHy9VHIi/2nLo26FrkTDqTXUZ/f725wsyD9tQ0YI6Nr0Kj0n3QBS8rwrDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMH5J0Nswj6r8JkARTbAgpu7QsI6bFAKn663zV7wnXY=;
 b=nt2YfNE6sMY5quG8yJtJKXxajtJWqHjGwnTTOtOdE356S2JKd9MIpoQoMvGzs73Mh2coUnnuLJSZcjoFvRAidleq12T1DRXYNmVOg1Q6Fye6SuvoEiTe0yrVbPvgDlGGA3c7LD1ebksIOGDoWE5IUC3FM2CQw5joRZAKGGsM7M0lSaHWuDvr23Keg1VyB2LyFhkjWMc3FMzZWH58Q7POh00lKTPy11Xffl1wq39QibhulWnISXN8fMhSfXAVeZh6k6g0VIkMLFxnZIEIakdtYl1fnQBeXC6NHsLcjyxbMH2xikNPVTyeAhUC8xjh/LvAtSTbSiGTvfgnfQU265e+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMH5J0Nswj6r8JkARTbAgpu7QsI6bFAKn663zV7wnXY=;
 b=B7il8qGsZWrcFRUi2o/p174+YHfOYtpao0ljgQyPQOS6Cq4RaXxgtM4a27u3afJs6OAWqLdOAtwt62HA1+F50bPGZ5FtBkVFM+5zVMZ71K+gxdxrAT72cwSZETaW6vfyC/RSKkEx+egyfW6IK6rzHSxkwn1ktIddNBqCztw8Tp4=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3865.namprd15.prod.outlook.com (2603:10b6:303:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 07:01:58 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 07:01:58 +0000
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
To:     Eelco Chaudron <echaudro@redhat.com>
CC:     <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <andriin@fb.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
 <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
Date:   Sun, 19 Apr 2020 00:01:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:300:13d::28) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wongal-imac.dhcp.thefacebook.com (2620:10d:c090:400::5:7ab3) by MWHPR20CA0018.namprd20.prod.outlook.com (2603:10b6:300:13d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Sun, 19 Apr 2020 07:01:57 +0000
X-Originating-IP: [2620:10d:c090:400::5:7ab3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73b3a1f2-84f4-45c2-9a73-08d7e42f8d47
X-MS-TrafficTypeDiagnostic: MW3PR15MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB386548E6C5805E24AA98C102D3D70@MW3PR15MB3865.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(366004)(346002)(396003)(136003)(376002)(4326008)(6486002)(2616005)(6512007)(6916009)(16526019)(186003)(66946007)(66476007)(66556008)(36756003)(478600001)(52116002)(81156014)(8936002)(86362001)(8676002)(31686004)(316002)(53546011)(31696002)(2906002)(5660300002)(6506007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zr8EufdWYrbpMkwCCOf298xtrUPlVxGVqv9WEWqfVjNQ3rTjhEj0FrQJgzHMaCsCn59QF/v+M0q/djJ2UXh6r/oCkMRjorYmT6lU6pwKh47f+/5mW2LhePQeGbqqXq109rgRPE6oLysoyCiujXNdQCl34l6bJMYQghSpUKpUWjXM0KmvZwk0CMS7P+QyAGv8Y1SymAqIVOPxNHeQm+LAsaKGmf6oGBeQWKPOKOyratjadg/ZuKMnvH0lC19PMyZQxjBTGyBD/126L5HZ5MC8OZYW5g/zPV1LRpeqNPLvxhb52qz1Lvuc+sDv90G785IVRwkU0ZNVWRXKemgqwvcvitSshLdIOgWu4TuSJlhwqA7nf0CCaEdaPjXA9qrJ/p1AB38K9CBHYADDU7JKBpiP2HOw8gq6dPIX9pNyX7nxOp1jgsb7GO/KWsCiMTEO8ORf
X-MS-Exchange-AntiSpam-MessageData: YGEtY4ztx7OJo21kDcv1MEfG9Nw8eW/TQoXq1HzsXAKbwcbWIqLHPpDVoKjXToRWn+oSVkWqBV8Yc/UXI9nfgzs8iDL6cllhNhlJASnA1jmcAfKO6hDLKKUZZhjOKB1s64WbLzFOedPRQL9Cg2MVx0nGmpkYC3BDR746O7iroFZUyz6IMRTDk9VynNqqnePiIJHXv6qJW5+XUW7MGlVo5S01FyDu4g01bSTOycrkxb1sE3R4EeQbj4hlk3ecx7VnTGnwCANm+6+AVR25584ew4IYe+m05IdxpF17Pp9mtdUk24xbjldSvcawbbWtDW8FuGZmTru/9aKgkmdF24mMl4skQm5dKKOvfv5E7eOdGswP8IUAOMvKCUIddjTfiJ++ejeKgP4Q65x7v954mPT+fgnhuK236+eWMpgfdzDkQs54umRcQ211ZZFMXZkuQkrerYYrlmipuPY6oERFnvmQGZAqSyMlbBN6RkcB0ZwEecF5fTQXtycqulNKmzeWTF64axCSGqJ6K5lIGrzcbteUQzZW7MHRqIPq982bRcSAW3UTKyPblVifKB/aJ0p44QxiFTTqmPysO65hWqCuBIG6aRftsZShgvBLbmbbK3EOkW96PufIdmPV7d3iKiHDlwnSlFyUEBd6Sfk9FQYudfsC2xOEBQwz7eFB+bZ1Yk3W4HW45IqkYoD1gVfAHs5h6/B/1Kw+zrUFFg96d0mokdHaSS9oSM/9AIRLLjeG2Gg2roibNhjw8KeL3ktzmy2tPActE5Aio+b8o0FSy79T/1VJgSRxkSeaHlFhsJnPSNzQUISL2GKhDFmNC8rpjCg9bln5HgYkvzT3/5Zk+A3imgheaw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b3a1f2-84f4-45c2-9a73-08d7e42f8d47
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 07:01:58.3310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2BLQ0tM8bVBwoUucgtcAakq/C3XI1bW9x7mHjHd+7M2y3QvvS1sHTr4/vD4sNSb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3865
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_10:2020-04-17,2020-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004190063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/20 5:45 AM, Eelco Chaudron wrote:
> 
> 
> On 23 Mar 2020, at 23:47, Yonghong Song wrote:
> 
>> On 3/18/20 6:06 AM, Eelco Chaudron wrote:
>>> I sent out this RFC to get an idea if the approach suggested here
>>> would be something other people would also like to see. In addition,
>>> this cover letter mentions some concerns and questions that need
>>> answers before we can move to an acceptable implementation.
>>>
>>> This patch adds support for tracing eBPF XDP programs that get
>>> executed using the __BPF_PROG_RUN syscall. This is done by switching
>>> from JIT (if enabled) to executing the program using the interpreter
>>> and record each executed instruction.
>>
>> Thanks for working on this! I think this is a useful feature
>> to do semi single step in a safe environment. The initial input,
>> e.g., packet or some other kernel context, may be captured
>> in production error path. People can use this to easily
>> do some post analysis. This feature can also be used for
>> initial single-step debugging with better bpftool support.
>>
>>>
>>> For now, the execution history is printed to the kernel ring buffer
>>> using pr_info(), the final version should have enough data stored in a
>>> user-supplied buffer to reconstruct this output. This should probably
>>> be part of bpftool, i.e. dump a similar output, and the ability to
>>> store all this in an elf-like format for dumping/analyzing/replaying
>>> at a later stage.
>>>
>>> This patch does not dump the XDP packet content before and after
>>> execution, however, this data is available to the caller of the API.
>>
>> I would like to see the feature is implemented in a way to apply
>> to all existing test_run program types and extensible to future
>> program types.
> 
> Yes, this makes sense, but as I’m only familiar with the XDP part, I 
> focused on that.

That is okay. Let us first focus on xdp and then to change it to make it 
more general before landing. During implementation you want to keep 
anything not related to xdp as separate functions so they can be
reused.

> 
>> There are different ways to send data back to user. User buffer
>> is one way, ring buffer is another way, seq_file can also be used.
>> Performance is not a concern here, so we can choose the one with best
>> usability.
> 
> As we need a buffer the easiest way would be to supply a user buffer. I 
> guess a raw perf buffer might also work, but the API might get complex… 
> I’ll dig into this a bit for the next RFC.

You may use xdp's perf_event_output. Not sure whether it can serve
your purpose or not. If not, I think user buffer is okay.

> 
>>>
>>> The __bpf_prog_run_trace() interpreter is a copy of __bpf_prog_run()
>>> and we probably need a smarter way to re-use the code rather than a
>>> blind copy with some changes.
>>
>> Yes, reusing the code is a must. Using existing interpreter framework
>> is the easiest for semi single step support.
> 
> Any idea how to do it cleanly? I guess I could move the interpreter code 
> out of the core file and include it twice.

I think refactor to a different file is totally okay. You can then pass
different callback functions from test_run and from interpreter call.

> 
>>> Enabling the interpreter opens up the kernel for spectre variant 2,
>>> guess that's why the BPF_JIT_ALWAYS_ON option was introduced (commit
>>> 290af86629b2). Enabling it for debugging in the field does not sound
>>> like an option (talking to people doing kernel distributions).
>>> Any idea how to work around this (lfence before any call this will
>>> slow down, but I guess for debugging this does not matter)? I need to
>>> research this more as I'm no expert in this area. But I think this
>>> needs to be solved as I see this as a show stopper. So any input is
>>> welcome.
>>
>> lfence for indirect call is okay here for test_run. Just need to be
>> careful to no introduce any performance penalty for non-test-run
>> prog run.
> 
> My idea here was to do it at compile time and only if the interpreter 
> was disabled.

This should be okay. If people do not have BPF_JIT_ALWAYS_ON, that
probably means they are not worried about interpreter indirect
calls...

> 
>>>
>>> To allow bpf_call support for tracing currently the general
>>> interpreter is enabled. See the fixup_call_args() function for why
>>> this is needed. We might need to find a way to fix this (see the above
>>> section on spectre).
>>>
>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>
> 
> One final question did you (or anyone else) looked at the actual code 
> and have some tips, thinks look at?

I briefly looked at the code, but did not go through details.
Next time will try to look at more details.

> 
> 
> I’ll try to do another RFC, cleaning up the duplicate interpreter code, 
> sent the actual trace data to userspace. Will hack some userspace 
> decoder together, or maybe even start integrating it in bpftool (if not 
> it will be part of the follow on RFC).
> 

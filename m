Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAED0424FB6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbhJGJI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:08:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49046 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240494AbhJGJIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 05:08:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1977pEY7022773;
        Thu, 7 Oct 2021 02:06:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=biUao3QymYC2Giv1/UKXS4nni4wWp8rqytK4WCtHA3I=;
 b=nnri0FXntipZmJQMtdAGdbFIKbpqdOeAxdzqeZwB+WP08TL9C5DKSueP2TktcBeoZjYz
 6lBOIQvxyNcaDOnymY194Tf/pwAiJ4PIEX0wub1dXq9tqKYLIpwgju1mOryxEuInhjUW
 zg+epqtI3/r5tebgpJLmu/8nJRkUGDpa02A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bhvv40g2t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Oct 2021 02:06:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 02:06:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkI/COefbpS5SJRQXeuWihu0pd/oAD1TgCIsmdsE96WB2c+DfV2O/sSHsp2cxku3DdC/s08BSiKY7RGIP8sfVbj9icJVAQ1uvGrW5ltGZfhA+5yP3Dlf9Dx/t/qFlkwLTgeXIhhF9KKWN9BINpHw5sQWUAV4FUPYF+va3FDGxwXGtnDkA5moBl5cJ78dVjuRm+ESl9dI8Juh9Sw9HGOkC2YP7K0LV2o1QQsPv4WXpDmo47IGnciUawAYjkgM+x3YRNQcucdkcyG0AcVbokTBkh8dOFU611Jy4GmQrbTVbytw/2wTJJzVl22ae0gkSMdsY4871j5ENZKWxNrpIaqtWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biUao3QymYC2Giv1/UKXS4nni4wWp8rqytK4WCtHA3I=;
 b=Ketj4Wx7PU4OddfeeK3KoBEDGqS+hpzGL13LQcXPsEYxPeVCDY49cn2e00muP/SXByn7kmRZT1WG49Shq38pYFKwD570Oz9AX0khYcd8+dkNxxs0axtsWeb2tMd+r/WREMt0b0IiFqblH1P4lfxQ2pBvx8ZNHHzaKW2FXEpnometvoZNYjHzFbEcFU4NLJY7j2KxChC/9a0ShmstKx5gWJu4Foezps+1qnLAne7djyYQSwlNdr2cANEtXBrU723QvM+wbHhexsExFzwPHE6IPwMt462TaI5tEesnRadYsSbsbAaNQbHOvX2CpsjoEqsQiL2IuG3oj3gX4I58D1WIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM5PR15MB1596.namprd15.prod.outlook.com (2603:10b6:3:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 09:06:40 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::955c:b423:995c:d239]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::955c:b423:995c:d239%4]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 09:06:40 +0000
Message-ID: <2c483e31-27e9-6b9b-15ec-1a3917ecefb3@fb.com>
Date:   Thu, 7 Oct 2021 05:06:38 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.2
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification
 stats
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp>
 <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
 <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
 <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com>
 <61520b6224619_397f208d7@john-XPS-13-9370.notmuch>
 <CAEf4BzbxYxnQND9JJ4SfQb4kxxkRtk4S4rR2iqkcz6bJ2jdFqw@mail.gmail.com>
 <615270f889bf9_e24c2083@john-XPS-13-9370.notmuch>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <615270f889bf9_e24c2083@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::27) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c0a8:11d9::13b3] (2620:10d:c091:480::1:e073) by BL1PR13CA0142.namprd13.prod.outlook.com (2603:10b6:208:2bb::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 7 Oct 2021 09:06:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86c70c57-8e94-45e4-5374-08d98971c69d
X-MS-TrafficTypeDiagnostic: DM5PR15MB1596:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB1596893A230979469585A011A0B19@DM5PR15MB1596.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l2trucGhU+pZijpMDDOFC2Yz7lnZUAqjzjvYc0kFzQUvCjF1i9cKeUMxb7e+v5I7gtgvg5I1/zD8tz+c+tJRpnnkp5dEoBbUVTVOtze0Xpa+MME+Tb/iw/phI8cvtxAXqcuDEvcb2X5iv2NKLmMhjEUmx44DUnN1/EBemprgS74pj27NmwhFUvVN8/wTk2zcjUJ8Y36jBaNLIvuS6c7ka2qjfALw+lH+EAg7Rp28kV5blC7BRzPqvkjjwLXDdODN6uKkQFBc2UzFdLCkY9ZjpSJiygn3VLRTmdXRlg7wFxu47sd6RWmQhcBbk8PkZVigw47cF47bupF1MoFiYPRuZIzbxkTCJiMv6IDibcGEcB3+0/yy/GInmJTRlvEVDHegY8b5wFEmW9R6EDscjbHok/vrWcnLTZnVoTcFjc4CCVhnF4u20sLkdFB7PEhcH5yzeqAhVpv7S3bD9uQdYMgvPR4qazzHnw2sPC127ZrhsM+tS6DgvDaIFHX6XxMeoph4ujLBGUCSrwh3BlTBMrlGHmUV0CAfa2ZVYzTOue8+iVZphxl1LvkwOx+bB44jrryBGWjUl0TP4ol2NyP5UlY7TQxnVuvEBKf8ChoCnrt+8/8s163P/4/s4/RBN287KMleMjtSfSSdO1rL4EwmY28x3uwIHRrZJVxSy3xRkN3HMwGr+JBvinUH6DsHGlLyFybTyvhmCsiImOAMH4lN/o69E7NPAVm7V7b2K/6YMftRL+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(31686004)(186003)(5660300002)(83380400001)(66476007)(2906002)(66556008)(110136005)(31696002)(6486002)(53546011)(66946007)(316002)(54906003)(86362001)(8676002)(8936002)(15650500001)(36756003)(38100700002)(2616005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzVlRDl5NTl1Unh3RlBJRkI3ZkMvd1l6MWdXeUNNWXdCY0pOMXZWaU9xbk1a?=
 =?utf-8?B?dEM0RGhSSXV5WXd3cEdzR0l4SUV2azRuTDZRVlpncGdVQzExWktmM0RVMUkr?=
 =?utf-8?B?TkJDLzJaMjk4dVVDL1p5YzRLMDgyZkFWYVIzSXN2bE9WbkFRZEtNbWhlOWpp?=
 =?utf-8?B?aDZoMTZUUGp2SlFtMGxudXRXa1dpNW9jVlZBdWFpYXgwclBRSGo3dWZiWlMv?=
 =?utf-8?B?NURpTW1QdG83dm1mOElsdFhCL1Zicm5hdmtDZUUyamwrZkczaXNzeWpsN3Rt?=
 =?utf-8?B?MUwwVGxxNlBZWkZsU0VCbUZlcTVpSENoNmFvSnRwN3N3SjBSRmlJTXBqbDJk?=
 =?utf-8?B?SGRoNVp0NFpudnF6djcyRmZBZVpJN1V6MUIrTjZIMXpxZmJYN3lFdXpBcVZ1?=
 =?utf-8?B?YnMwT0tqTWtTMXJNbE0yYXRWVFU0UUJITWJWak44Wmwxcy8vY1BQaUQ5KzFS?=
 =?utf-8?B?UkMrVWQ4bXNXcG05VHEyTlRJWjA0bm02TnByUXdDSGY0bkVMVEVHakZLWHNp?=
 =?utf-8?B?QmlYTTl4Ui9MSkZsTjUwN1ZnK3Y4YjRVTENnc0FCSXBlTVpyMVpLaUxtaUhZ?=
 =?utf-8?B?MUwrZU0wSFhqZ2VaUzVZTHdLN1FTM1hKRnBsQk9NRjdGdjFRaGNLV2tJbE9E?=
 =?utf-8?B?T2g3QmFOMlEwbGRCNHdjd0VDMVhtUDZSemVGdjE5ZWd6MU8zOFJXVUxhbHlp?=
 =?utf-8?B?NGdjY1lHTUg2WEFuYnNVQ285N1RRVlgyWE0wSGxpRHFVWTRGV3NGV3VIc0di?=
 =?utf-8?B?WWdMTCtrV3pXYkZZZVFpTllEOERzYU9zc3hzeWY4WlQyZnd5ZThMUkF5c2t3?=
 =?utf-8?B?Mys2d1lCSXQzaktqMmNMSzY0WmUxUEJoa1A5RGYxU1RsQUMzNzhaODFPdVpI?=
 =?utf-8?B?emNYOWV6c25mcGorcTNSdTYvMlVmV0pJdVU4TUhZcHpIL0ZUZkpodHFUTm54?=
 =?utf-8?B?b0tzcDBkYm16UFpWVC85aVF1OGRHUm5wSytybmpQT1dxR0pDTnkzcWNoN2Zk?=
 =?utf-8?B?ZUhjRVFHQVNoT1k4dU1FdWZOekMxWWxyNVhXck9BVGJiNWFTMHJ4SkM2eDd1?=
 =?utf-8?B?aHMzNGRMMzhVWmRZS3BWUG1ma0RndUNFZE9STUQ0b2phTW4vdzhRd2FsNWVL?=
 =?utf-8?B?dmZNWit5bmkzak1wOGIvaE0xNjdJTXVtenBieHJFOXQzL09LN3JyMGpCL0Zq?=
 =?utf-8?B?TzJpOCtBR05RVW1WeWh1ellWU1V1UTdwbTBaeW1WQjIzaEZDSEU2dGNOSkR4?=
 =?utf-8?B?VjYwRnlXalQxeG10Yy9QNzFoa1pDZ0k0R1lvaUU2UitZWGxzMENvSVpWRVQ5?=
 =?utf-8?B?SkJFVFpzNmRrN3JKTU1lTTBsSWVaUWcxaDBXRXcrak5SelVLZzYwVXNjV2cx?=
 =?utf-8?B?Um5lYis4cXlVNHFnZjhXd1JHbFowVndzLzVQSDI1ZHR3bUZFRjJ3Q3E0TGsz?=
 =?utf-8?B?UzNBcHVnbS9OUmFvdElYakJqbUF6OFFjbHdaRGF5ZTBnOVdkWHVDamh2bWFq?=
 =?utf-8?B?RzA3UjFacTE2K0szNXZhZ3B0dkJRdURxcFJHZi9UdktXNCtpNnZlWDVKcFZa?=
 =?utf-8?B?anBRbWx0enVUVkZ2cGVJVXZubE5LUGRWTnRGdjNpSGsvcm5DTkpKOFZjYzRj?=
 =?utf-8?B?ajdlZm1oalpUMkNHOTRKNzNmUDRTSzF6UU4rOWJUZEszZFZMWWl1ZlM4YllZ?=
 =?utf-8?B?S2hlOHNKYm94cWZPRFd1SXlwbUp5VjVNeFlydXJaQ0lIQVFneE11aW05b2Vi?=
 =?utf-8?B?T1VUVUxtSkk3a0RhNzZDdjVnN25CcmJFazF5cVdNVktmczN4TU5ic3BURnE2?=
 =?utf-8?B?OFB4ZU0rd0tIeTVOVytUQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c70c57-8e94-45e4-5374-08d98971c69d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 09:06:40.7668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSSp1XNsOCvmSWJg3B0pVUK6cYZCZGwhHf12TvCyE1MNMB8F8F28oyev2IqJSZcljG+IhqEp+AE9mVGTqFNuBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1596
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: pSQSKsZAesObi_nnD7tqb_WKaBnEsuo0
X-Proofpoint-GUID: pSQSKsZAesObi_nnD7tqb_WKaBnEsuo0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110070063
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 9:33 PM, John Fastabend wrote:   
> Andrii Nakryiko wrote:
>> On Mon, Sep 27, 2021 at 11:20 AM John Fastabend
>> <john.fastabend@gmail.com> wrote:
>>>
>>> Dave Marchevsky wrote:
>>>> On 9/23/21 10:02 PM, Andrii Nakryiko wrote:
>>>>> On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>>>>>>
>>>>>> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
>>>>>>> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
>>>>>>>> The verifier currently logs some useful statistics in
>>>>>>>> print_verification_stats. Although the text log is an effective feedback
>>>>>>>> tool for an engineer iterating on a single application, it would also be
>>>>>>>> useful to enable tracking these stats in a more structured form for
>>>>>>>> fleetwide or historical analysis, which this patchset attempts to do.
>>>>>>>>
> 
> [...] 
> 
>>>>
>>>> Seems reasonable to me - and attaching a BPF program to the tracepoint to
>>>> grab data is delightfully meta :)
>>>>
>>>> I'll do a pass on alternate implementation with _just_ tracepoint, no
>>>> prog_info or fdinfo, can add minimal or full stats to those later if
>>>> necessary.

Actually I ended up pushing a simple add of insn_processed to prog_info, 
fdinfo instead of bare tracepoint. The more general discussion here is
interesting - if we can inject some custom logic into various points in
verification process, can gather arbitrary stats or make policy decisions
from the same attach points.

>>>
>>> We can also use a hook point here to enforce policy on allowing the
>>> BPF program to load or not using the stats here. For now basic
>>> insn is a good start to allow larger/smaller programs to be loaded,
>>> but we might add other info like call bitmask, features, types, etc.
>>> If one of the arguments is the bpf_attr struct we can just read
>>> lots of useful program info out directly.
>>>
>>> We would need something different from a tracepoint though to let
>>> it return a reject|accept code. How about a new hook type that
>>> has something similar to sockops that lets us just return an
>>> accept or reject code?
>>>
>>> By doing this we can check loader signatures here to be sure the
>>> loader is signed or otherwise has correct permissions to be loading
>>> whatever type of bpf program is here.
>>
>> For signing and generally preventing some BPF programs from loading
>> (e.g., if there is some malicious BPF program that takes tons of
>> memory to be validated), wouldn't you want to check that before BPF
>> verifier spent all those resources on verification? So maybe there
>> will be another hook before BPF prog is validated for that? Basically,
>> if you don't trust any BPF program unless it is signed, I'd expect you
>> check signature before BPF verifier does its heavy job.
> 
> Agree, for basic sig check or anything that just wants to look at
> the task_struct storage for some attributes before we verify is
> more efficient. The only reason I suggested after is if we wanted
> to start auditing/enforcing on calls or map read/writes, etc. these
> we would need the verifier to help tabulate.

This is the "Bob isn't signed, so ensure that Bob can only read from 
Alice's maps" case from your recent talk, right? 

I'd like to add another illustrative usecase: "progs of type X can 
use 4k of stack, while type Y can only use 128 bytes of stack". For
the 4k case, a single attach point after verification is complete 
wouldn't work as the prog would've been eagerly rejected.

Alexei suggested adding some empty noinline functions with 
ALLOW_ERROR_INJECTION at potential attach points, then attaching 
BPF_MODIFY_RETURN progs to inject custom logic. This would allow 
arbitrarily digging around while optionally affecting return result.

WDYT?

> When I hacked it in for experimenting I put the hook in the sys
> bpf load path before the verifier runs. That seemed to work for
> the simpler sig check cases I was running.
> 
> OTOH though if we have a system with lots of BPF failed loads this
> would indicate a more serious problem that an admin should fix
> so might be nicer code-wise to just have a single hook after verifier
> vs optimizing to two one in front and one after. 
> 
>>
>>>
>>> Thanks,
>>> John
> 
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15821A4CE7
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDKAXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:23:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726641AbgDKAXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 20:23:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03B0FA5G006286;
        Fri, 10 Apr 2020 17:23:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SEJHshPI2UWEj6HyHhATXyhiph38t9VXdW2R/3n9XT4=;
 b=iA9aPbQIX8858shv2+GI5hqURhZY1L4sp/S2Hf41NodO9QG/Fh02fsm1JOjqzVQTbYyD
 fexVJaVxbxV/QoJiIHfs4B8qi4bkYXZxq5IPinOjay75oMWFKXp0CcX1+28TIIDIY7fb
 Bsg563+SLzyy41/pKRLdqe33m2dq9yuWXik= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30aur3ag5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 17:23:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 17:23:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DE9VVN1wEjXQC89k+voTFOXABmE2H5c+TUtD6cxrSt/3o00ZjJDWKx+iRFEWVOh7yAd3K6V6lSqtlF7mgRqw6UCTkvlCImbZAwNJYk41nxKq2Oiowr9b+z1DCLUG5GIKfdAKg2qyRzhhIEf8t3vhqyxgrUdjqKEob/ZlP+7V3h666pV6X1Fkxg7jOL7gl+jOs8bl6wz+bQUPs+v3a918CMHXyIZglbE+Yn3xgOZtopQXweZTUOVkqmi68V87X2Qf7vTG9cNmvHwMmni5Oq+TG21yaMYkkDR801L48LQJc2mPO094czVF8UEokLEIZ1IujzmPpMRt7q+lvvWTlPfRmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEJHshPI2UWEj6HyHhATXyhiph38t9VXdW2R/3n9XT4=;
 b=f6XdvbIX+rfPjG6KRqA4NyH8EzssLpEs4EPDq6v7/SxjlHRSQUjvFu953o+z6B0rIJRREQYQEeMVMbBaJ0Z6qFT4XNCYFVZ/yATKEZIDfKGny0rCYycW1RcSz/fDKgetGUKtcJeezR//C8nyCrg+SgZ+cc+vb9xM7rcVDTUkA6Iy16x7VsWoZXfQMHOAoGgJEJ2ptQfY2WeNBPdNSniMGQx4cA75k7HRwe4RnYrQnPH27MpT0f8PrOQlrwJewhDc/7RwxsMHrr4+ZQvHY/t9CD2Lc78OCzFQubGQcBlhvIrNfFM7fmUEVDS9oA19uz8y+bBtSQ6auocy0/SIsCzAJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEJHshPI2UWEj6HyHhATXyhiph38t9VXdW2R/3n9XT4=;
 b=W56wCkXA6UBCFNKjgdUkqNHpkOg7hiVKTdP1GnkOij6SJYyVdOU/B5lBur8ndL1AnR+r4kQ9zWf4xlzVtPWdB7atI3WMccuyEOh69yTm7RhxY7t9/SlHPQMMTxzPKVH+9MgzFDbtOPYD+tBw7W4YUx5YEK2ZZB7e732of/VymF0=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4058.namprd15.prod.outlook.com (2603:10b6:303:4c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Sat, 11 Apr
 2020 00:23:32 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Sat, 11 Apr 2020
 00:23:32 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bza8w9ypepeu6eoJkiXqKqEXtWAOONDpZ9LShivKUCOJbg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <334a91d2-1567-bf3d-4ae6-305646738132@fb.com>
Date:   Fri, 10 Apr 2020 17:23:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bza8w9ypepeu6eoJkiXqKqEXtWAOONDpZ9LShivKUCOJbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR01CA0042.prod.exchangelabs.com (2603:10b6:300:101::28)
 To MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR01CA0042.prod.exchangelabs.com (2603:10b6:300:101::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Sat, 11 Apr 2020 00:23:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c9b0813-3e6b-41c6-5a89-08d7ddae911c
X-MS-TrafficTypeDiagnostic: MW3PR15MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB405828D1CA231745D230034ED3DF0@MW3PR15MB4058.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(136003)(376002)(396003)(366004)(39860400002)(6486002)(4326008)(2616005)(478600001)(54906003)(31696002)(8676002)(2906002)(6512007)(53546011)(6506007)(66946007)(66476007)(66556008)(316002)(31686004)(81156014)(8936002)(36756003)(6916009)(16526019)(86362001)(186003)(52116002)(5660300002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbhHjkuXTs4hzk2TiLy0wtYrFpTPJWRm+LQvmrp4rthXNoJK/GFtm4njVTyxPE7Wiu8tHcl/Jo/xJaFcV7UvWJSdFaF0FzvTO/LenDhJfbbwSInFkNAtRMQlpeQUt/aOtqk0Qv7IfLu069s+7bSVYvZW3Noidcm64+Bvpfy/nY0AiUD5sF3KJx9F8NT3xvc6V9UugHjIviNUSbvfWEQOubhD7Cnn3TAnPPS64Z+xoHqAgHh60dNyX4Fm5PjmYgr2H/sGWulZIzfk4dn4evgijnGrYb1Q3Jy2Lufmz0E+Ulhai7I4srTG9hSbF9LPYOderGxl4strCVRceGxlCkqpBaEiYIWCQJJs32w6suf8PtrLAvuYTIefJLqPlsJO+3fp1Qc10wi1uBHOut95CycR7GX2FN2ZvsZ4KqNo6oQ/uZz8yGzhcxvdplfF4QcxuF3O
X-MS-Exchange-AntiSpam-MessageData: OvwfPL9wKpB1zO8Ld9wwTPySzh6iN5fFZBTpTzE4GHjL7hPjPZdPeWOaJfC7jUbq5BjpUQC4epjFLuAwzIHRN3toYDIKjdv+P51mH+DkAHwfIp3DPISW7zVFxrWNcQtMHygc/VVMxkh33pNANn23PRTCoUrzWeerLUgAHFRDmclNjX5sjHzd7Rf5Qvef3gm9
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9b0813-3e6b-41c6-5a89-08d7ddae911c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2020 00:23:32.6838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsyKR8OmYR+fv4c8Yn9uDw9sfOft+sFBRy4lqinzR4tjAaUb/yNsE/Ijkeq48940
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4058
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004110000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 4:25 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Given a loaded dumper bpf program, which already
>> knows which target it should bind to, there
>> two ways to create a dumper:
>>    - a file based dumper under hierarchy of
>>      /sys/kernel/bpfdump/ which uses can
>>      "cat" to print out the output.
>>    - an anonymous dumper which user application
>>      can "read" the dumping output.
>>
>> For file based dumper, BPF_OBJ_PIN syscall interface
>> is used. For anonymous dumper, BPF_PROG_ATTACH
>> syscall interface is used.
>>
>> To facilitate target seq_ops->show() to get the
>> bpf program easily, dumper creation increased
>> the target-provided seq_file private data size
>> so bpf program pointer is also stored in seq_file
>> private data.
>>
>> Further, a seq_num which represents how many
>> bpf_dump_get_prog() has been called is also
>> available to the target seq_ops->show().
>> Such information can be used to e.g., print
>> banner before printing out actual data.
> 
> So I looked up seq_operations struct and did a very cursory read of
> fs/seq_file.c and seq_file documentation, so I might be completely off
> here.
> 
> start() is called before iteration begins, stop() is called after
> iteration ends. Would it be a bit better and user-friendly interface
> to have to extra calls to BPF program, say with NULL input element,
> but with extra enum/flag that specifies that this is a START or END of
> iteration, in addition to seq_num?

The current design always pass a valid object (task, file, netlink_sock,
fib6_info). That is, access to fields to those data structure won't 
cause runtime exceptions.

Therefore, with the existing seq_ops implementation for ipv6_route
and netlink, etc, we don't have END information. We can get START
information though.

> 
> Also, right now it's impossible to write stateful dumpers that do any
> kind of stats calculation, because it's impossible to determine when
> iteration restarted (it starts from the very beginning, not from the
> last element). It's impossible to just rememebr last processed
> seq_num, because BPF program might be called for a new "session" in
> parallel with the old one.

Theoretically, session end can be detected by checking the return
value of last bpf_seq_printf() or bpf_seq_write(). If it indicates
an overflow, that means session end.

Or bpfdump infrastructure can help do this work to provide
session id.

> 
> So it seems like few things would be useful:
> 
> 1. end flag for post-aggregation and/or footer printing (seq_num == 0
> is providing similar means for start flag).

the end flag is a problem. We could say hijack next or stop so we
can detect the end, but passing a NULL pointer as the object
to the bpf program may be problematic without verifier enforcement
as it may cause a lot of exceptions... Although all these exception
will be silenced by bpf infra, but still not sure whether this
is acceptable or not.

> 2. Some sort of "session id", so that bpfdumper can maintain
> per-session intermediate state. Plus with this it would be possible to
> detect restarts (if there is some state for the same session and
> seq_num == 0, this is restart).

I guess we can do this.

> 
> It seems like it might be a bit more flexible to, instead of providing
> seq_file * pointer directly, actually provide a bpfdumper_context
> struct, which would have seq_file * as one of fields, other being
> session_id and start/stop flags.

As you mentioned, if we have more fields related to seq_file passing
to bpf program, yes, grouping them into a structure makes sense.

> 
> A bit unstructured thoughts, but what do you think?
> 
>>
>> Note the seq_num does not represent the num
>> of unique kernel objects the bpf program has
>> seen. But it should be a good approximate.
>>
>> A target feature BPF_DUMP_SEQ_NET_PRIVATE
>> is implemented specifically useful for
>> net based dumpers. It sets net namespace
>> as the current process net namespace.
>> This avoids changing existing net seq_ops
>> in order to retrieve net namespace from
>> the seq_file pointer.
>>
>> For open dumper files, anonymous or not, the
>> fdinfo will show the target and prog_id associated
>> with that file descriptor. For dumper file itself,
>> a kernel interface will be provided to retrieve the
>> prog_id in one of the later patches.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |   5 +
>>   include/uapi/linux/bpf.h       |   6 +-
>>   kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
>>   kernel/bpf/syscall.c           |  11 +-
>>   tools/include/uapi/linux/bpf.h |   6 +-
>>   5 files changed, 362 insertions(+), 4 deletions(-)
>>
> 
> [...]
> 

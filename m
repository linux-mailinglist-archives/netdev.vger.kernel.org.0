Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1E51AB841
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408286AbgDPGlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:41:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408206AbgDPGli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 02:41:38 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G6YMkP017159;
        Wed, 15 Apr 2020 23:41:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sHkWURrTuOEh4obYq6WmAsnq5U1NyXmNNZc1vefTcFY=;
 b=JQ3eUTL1FgvDZs1oSIG2mXUNF5WgxaSFUGMKAcSPZSdxfcKPF5evDe2STi6d5JIuOePU
 +AfM1oSbpyg5i0O5zd7v+Q2lTnG2Ulb8I2O0jHhQ6EB3ib9WWj1BlhUGIgTWu4w3CjxZ
 EcMZhvWMfyuHiILmCuK3Ie7mwxQDG/CKrSs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7g240n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Apr 2020 23:41:24 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 23:41:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0wLXSNYe4d3NXIIqexEC8r6kNr044nG0uwbZd/tTAJ3+s9zJxFdbK/m3asmFOE3Max8fFsF8eKrLMrDIfYzko9Qiy69+ICWxtIj+wvrE6BL/wB3NimfqBrTruXZz0XXwx7NRrVSNt4xHiVxVnWPuX6z1PalVIr8cpgMllb33+PJkfwJxUp0HyHBNqU/CXWI+n+ceVtKoeOOKVS94G/uYOknqqZv3vI+wr9uXOOji+oZ/b7BZQlfdZl3i+qLSZxg27bW5LIdau7Q1rzqfi+XO2mlZylancGuPbIY/ffdFjWllznlVINnf/H2bDQ7v8NRNrc+STyeKDoQRxOXMHMDOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHkWURrTuOEh4obYq6WmAsnq5U1NyXmNNZc1vefTcFY=;
 b=F9mDvl+0+n60/txKNAq7pHFAe4MutiDKl4Q6X8AN7zXDPMfrT2NwaaTWz+e1ewhaROJ8ZqNtLioD5ISY+PXIA912PxEZmOQVHl6AQcjCQawV/DSm7E2zNAs2CLGP4XTkaQfyPyDIIUohaKInjU0LQxTMQ1VqkHxjkxI7+VTPt1T6QAxzzCXKkE4+RBE8xV3GCbrk9orPnBTKMQdU7L1kaASm37gIyk/Nk/F1XCGLgDQjrIz2BJuf74FATGC4Qa4jdUw2TGIfzV587gGuWPrvvU5nK2st8HHYnWH8ERc7nCIqQbymArA59irjIUEGnyEpQ2yBhCmcHNzobfKk1HMD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHkWURrTuOEh4obYq6WmAsnq5U1NyXmNNZc1vefTcFY=;
 b=U2ctCsIV+Zbggqx9guuw4LK4d+enSKvp8u7qV4I+RS+YgLEAvoeXpdn4gwHu65idR8Bl13QK07eWNfxL6dJS2BTD+A/z9PyHhHfLG62+/sjSox00Qjymd79vgS3ZgzEu5X671e6pMWVunapQr7m2CAur9S0l63JhtXptJcN/oJw=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3754.namprd15.prod.outlook.com (2603:10b6:303:48::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Thu, 16 Apr
 2020 06:41:21 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 06:41:21 +0000
Subject: Re: [RFC PATCH bpf-next v2 00/17] bpf: implement bpf based dumping of
 kernel data structures
To:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
 <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e9d56004-d595-a3ac-5b4c-e4507705a7c2@fb.com>
Date:   Wed, 15 Apr 2020 23:41:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:300:115::26) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rupeshk-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:dd1a) by MWHPR11CA0040.namprd11.prod.outlook.com (2603:10b6:300:115::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Thu, 16 Apr 2020 06:41:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:dd1a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b474cdbb-3019-44af-5c04-08d7e1d12cf6
X-MS-TrafficTypeDiagnostic: MW3PR15MB3754:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB375413D02D4686F5185B08C5D3D80@MW3PR15MB3754.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0375972289
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(39860400002)(346002)(366004)(376002)(136003)(6666004)(54906003)(186003)(16526019)(52116002)(53546011)(5660300002)(110136005)(86362001)(6506007)(2906002)(4326008)(316002)(478600001)(31696002)(6512007)(2616005)(36756003)(6486002)(81156014)(31686004)(8676002)(66556008)(66476007)(8936002)(66946007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nU1ZX4BKvdZwCb1XiDiiA0ntSBaz6qIG9N7LVKgevuJxlu/xG21tH+5F1C6vNaDUPWZAllgZdVP293CWbaRjk3x5Olw52iHsq6WHDt3YF9pv9ZqOsEgXfDxN/efUmVO/zCdqeJlLB9SA3QBx4x/MJPZv2ZGdVsbpU9xgco9i7flqc1qTxk4cCzEP9TlVUqZKtblExxNS0md6yIN8Sj/RujdTBjFDSDvbi+A4qH23KY8AZPb8iZDLD2pShP65XWELFMreU76FG7N9/Dw2zMtyqXRCNmGORyupTa36PRzWc6lr5PwWFKtbImsJ5de0CEhtXAvInaVj8R4Bzgu66RRgsQCrVgXZrGLK+Cx/LGY5nQ/Iab1cuig/ok+fBSGXQnNtBTzHjVh2K21sKNFZasReVFL4vaKkAdedfiTu7MwFpRiC1/8dEgqkgs+VWme5LhLf
X-MS-Exchange-AntiSpam-MessageData: B53mbg49RSwr++kUHZ3uBz2pU1666hpYh1A6pMLdSfTEQZhdzkoyUWdVwT5d4IdMgBTRiTlidy7/JgU2yWDx4txWyE05t4BmZLzOzU3/MZ21hBACyF9yV4SxuEBmRPq2aGj6E5F9gYVX4WUAeUmUo6g5L2C1ad0uyAHSIJnCZd42QE9O/n09Nt1F+FYAAM3k
X-MS-Exchange-CrossTenant-Network-Message-Id: b474cdbb-3019-44af-5c04-08d7e1d12cf6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2020 06:41:21.6993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7hvr0wFpF+YQEfFPxC4kKlEmhROXtcK+lwIW4c0CJ1XKWY0y6os/1VAiwRt//p3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3754
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_02:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004160041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/20 7:23 PM, David Ahern wrote:
> On 4/15/20 1:27 PM, Yonghong Song wrote:
>>
>> As there are some discussions regarding to the kernel interface/steps to
>> create file/anonymous dumpers, I think it will be beneficial for
>> discussion with this work in progress.
>>
>> Motivation:
>>    The current way to dump kernel data structures mostly:
>>      1. /proc system
>>      2. various specific tools like "ss" which requires kernel support.
>>      3. drgn
>>    The dropback for the first two is that whenever you want to dump more, you
>>    need change the kernel. For example, Martin wants to dump socket local
> 
> If kernel support is needed for bpfdump of kernel data structures, you
> are not really solving the kernel support problem. i.e., to dump
> ipv4_route's you need to modify the relevant proc show function.

Yes, as mentioned two paragraphs below. kernel change is required.
The tradeoff is that this is a one-time investment. Once kernel change
is in place, printing new fields (in most cases except new fields
which need additional locks etc.) no need for kernel change any more.

> 
> 
>>    storage with "ss". Kernel change is needed for it to work ([1]).
>>    This is also the direct motivation for this work.
>>
>>    drgn ([2]) solves this proble nicely and no kernel change is not needed.
>>    But since drgn is not able to verify the validity of a particular pointer value,
>>    it might present the wrong results in rare cases.
>>
>>    In this patch set, we introduce bpf based dumping. Initial kernel changes are
>>    still needed, but a data structure change will not require kernel changes
>>    any more. bpf program itself is used to adapt to new data structure
>>    changes. This will give certain flexibility with guaranteed correctness.
>>
>>    Here, kernel seq_ops is used to facilitate dumping, similar to current
>>    /proc and many other lossless kernel dumping facilities.
>>
>> User Interfaces:
>>    1. A new mount file system, bpfdump at /sys/kernel/bpfdump is introduced.
>>       Different from /sys/fs/bpf, this is a single user mount. Mount command
>>       can be:
>>          mount -t bpfdump bpfdump /sys/kernel/bpfdump
>>    2. Kernel bpf dumpable data structures are represented as directories
>>       under /sys/kernel/bpfdump, e.g.,
>>         /sys/kernel/bpfdump/ipv6_route/
>>         /sys/kernel/bpfdump/netlink/
> 
> The names of bpfdump fs entries do not match actual data structure names
> - e.g., there is no ipv6_route struct. On the one hand that is a good
> thing since structure names can change, but that also means a mapping is
> needed between the dumper filesystem entries and what you get for context.

Yes, the later bpftool patch implements a new command to dump such
information.

   $ bpftool dumper show target
   target                  prog_ctx_type
   task                    bpfdump__task
   task/file               bpfdump__task_file
   bpf_map                 bpfdump__bpf_map
   ipv6_route              bpfdump__ipv6_route
   netlink                 bpfdump__netlink

in vmlinux.h generated by vmlinux BTF, we have

struct bpf_dump_meta {
         struct seq_file *seq;
         u64 session_id;
         u64 seq_num;
};

struct bpfdump__ipv6_route {
         struct bpf_dump_meta *meta;
         struct fib6_info *rt;
};

Here, bpfdump__ipv6_route is the bpf program context type.
User can based on this to write the bpf program.

> 
> Further, what is the expectation in terms of stable API for these fs
> entries? Entries in the context can change. Data structure names can
> change. Entries in the structs can change. All of that breaks the idea
> of stable programs that are compiled once and run for all future
> releases. When structs change, those programs will break - and
> structures will change.

Yes, the API (ctx) we presented to bpf program is indeed unstable.
CO-RE should help to certain extend but if some fields are gone, e.g.,
bpf program will need to be rewritten for that particular kernel 
version, or kernel bpfdump infrastructure can be enhanced to
change its ctx structure to have more information to the program
for that kernel version. In summary, I agree with you that this is
an unstable API similar to other tracing program
since it accesses kernel internal data structures.

> 
> What does bpfdumper provide that you can not do with a tracepoint on a
> relevant function and then putting a program on the tracepoint? ie., why
> not just put a tracepoint in the relevant dump functions.

In my very beginning to explore bpfdump, kprobe to "show" function is
one of options. But quickly we realized that we actually do not want
to just piggyback on "show" function, but want to replace it with
bpf. This will be useful in following different use cases:
   1. first catable dumper file, similar to /proc/net/ipv6_route,
      we want /sys/kernel/bpfdump/ipv6_route/my_dumper and you can cat
      to get it.

      Using kprobe when you are doing `cat /proc/net/ipv6_route`
      is complicated.  You probably need an application which
      runs through `cat /proc/net/ipv6_route` and discard its output,
      and at the same time gets the result from bpf program
      (filtered by pid since somebody may run
      `cat /proc/net/ipv6_route` at the same time. You may use
      perf ring_buffer to send the result back to the application.

      note that perf ring buffer may lose records for whatever
      reason and seq_ops are implemented not to lose records
      by built-in retries.

      Using kprobe approach above is complicated and for each dumper
      you need an application. We would like it to be just catable
      with minimum user overhead to create such a dumper.

   2. second, anonymous dumper, kprobe/tracepoint will incur
      original overhead of seq_printf per object. but user may
      be only interested in a very small portion of information.
      In such cases, bpf program directly doing filtering in
      the kernel can potentially speed up a lot if there are a lot of
      records to traverse.

   3. for data structures which do not have catable dumpers
      for example task, hopefully, as demonstrated in this patch set,
      kernel implementation and writing a bpf program are not
      too hard. This especially enables people to do in-kernel
      filtering which is the strength of the bpf.


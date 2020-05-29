Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F111E75E8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgE2GaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:30:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55300 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbgE2GaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 02:30:11 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T6TJPe015389;
        Thu, 28 May 2020 23:29:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BDU0PlUkUDR5SYzh8US1w8LDrK0HWzAN9xof22CqXnU=;
 b=XaovF7mK5aBxN8B4Y0OAbF7Io0QeMnKcZS7sH8CFW4MvDgRnBTlFm0qaIPCzWHJWFrv9
 rKPTDfx2AIHVbr5QQybMVv3hiqTmIK7+1JWetpfVJ3ZKe9ik+TK3aINZhOMO1yuDpPex
 x5+GsD/03uqV+2xk4WCA+Ky7UKB1SyNerPk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31a4ndmxa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 28 May 2020 23:29:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 28 May 2020 23:29:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWypZVoKfh2Fx3Y0FMJm0K5hqOYvz6mWaJoXYGj8B1xiazHYFU04ioBoB/Kft+enVetznwbH7cE0lOIB2bvsTkmjPzCRWjPWyJaPI2mHDoa6cBhcAniHH4GQUM9+Jy5KTMYXtoA7TaCeJLdJ1iYzRHBxicI2HJ9VvsRwxFW+Lje0Vgn9H+e03uXtT0QEjJ4AZT1y43jtTuc140RdTgm+Vmc1/j7jbi4AnLsSBNX251k5U0TPMdrDa5wm48iI7gTU29KYWJZfZ53b021JHLVY44uL/qQ0rI/tigJ1fWOIA7w0HufSz3t3cO+ktBeXIcTJF+QYwxJMhHR7PoQsRPVfwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDU0PlUkUDR5SYzh8US1w8LDrK0HWzAN9xof22CqXnU=;
 b=IEzrjiQ4q3vNz4JLELelPHD5q9K2Mw1u49SDQ804YJumQljYk8MDyZqTuTZGuiJiJRS3k0M6XtXQ8m6JG9NLjgko1UBcGwhNRyiyzmZbduUOUrzTwkGOEoIWOE2LlK2H5Z1dpq4gFZ9rwqMR33zGp5Ks74A+ldimDTzwFAhxg1qwx6GWsUsJnVyHSwlWL9NXAgg55AysIETNa7tUrmRFY7YjzjHDDxuWQXZfN31SDMGXtIDHjmNp2x25fof6DAYWDr4WrF7LeBqGwBCmj06g6ELN9TTnHSPiyuWHcev5VQiKgCILRo2ua6Wsj+AoLjLLuZi6uUqiSNzGHVHfmrV5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDU0PlUkUDR5SYzh8US1w8LDrK0HWzAN9xof22CqXnU=;
 b=K0y8w4yi79lrqs8ZoPZW91q/qhbnuV+bSWuL7d+N+b/Ky1sbEjEaAGofL1mIm+W46dvXBe+nceDFH9nl4eK3g9795bxr7FYQcqagwRQZFWtTmkLsBYSHmPjfhXRgpbRAahms3RMQcl9c8qAOS3iYyAmYvVygvOXISVJUSN+in9s=
Authentication-Results: linux-ipv6.org; dkim=none (message not signed)
 header.d=none;linux-ipv6.org; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
 by MW3PR15MB3753.namprd15.prod.outlook.com (2603:10b6:303:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:29:37 +0000
Received: from MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::998d:1003:4c7c:2219]) by MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::998d:1003:4c7c:2219%9]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:29:37 +0000
Subject: Re: general protection fault in inet_unhash
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        <ast@kernel.org>, <davem@davemloft.net>, <guro@fb.com>,
        <kuba@kernel.org>, <kuznet@ms2.inr.ac.ru>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <yoshfuji@linux-ipv6.org>
References: <00000000000018e1d305a6b80a73@google.com>
 <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
 <342a5525-e821-5cdd-487b-da6b5278a344@gmail.com>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <10aa8133-f9bd-2de6-fb47-3ad54aeb7db5@fb.com>
Date:   Thu, 28 May 2020 23:29:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <342a5525-e821-5cdd-487b-da6b5278a344@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:180::27) To MW3PR15MB3980.namprd15.prod.outlook.com
 (2603:10b6:303:48::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:657d) by BY5PR13CA0014.namprd13.prod.outlook.com (2603:10b6:a03:180::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.8 via Frontend Transport; Fri, 29 May 2020 06:29:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:657d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c059951-657c-4ab5-23f1-08d80399a8f8
X-MS-TrafficTypeDiagnostic: MW3PR15MB3753:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3753BF844A60EBE6A68625A4C68F0@MW3PR15MB3753.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CtG79/gcZUa7TupXVnRVd+b4NGjxj+17uW2DvAlll+mUx1lQSEcy30UDFwKNv/1oOIKuB6dfoVDawrb91Yl4CeDEec9RP9VeNJE5LGsEmE2thjb88spfiE3uE+NaJ0IN+6uJ5yGFUTJsDNooEJ4UjesYOJNRUykgk5tkXqItdN3Sh45Mq+lKhERs/qQAfCPCxjhTzbh6U+0b8w2HHO9uSWJgnxFeR9qindv7YGo0JO3aCGQ257TXDOTpInnwU5PMGtOoOPTeAaeRaCzwrdQroVYMPjtnhXqSU6mfXmXx76JeON0riLkNBg/7Riu63saEpRHR8EgJ0GJzn6bLDI/8Fxmo0NlWxpOxKgzNuvZyTpmP0S98OqRchV50YD3SH0sQrxl33WrW3+yOZ4Uwq7OhRKCFwf8Hj/9BZtuaVRCefZi3+GrCIbwV5cYhKLKUYID1olILtZ2jd7U0tExoldqXtIlwPyJAttHklfn1Draf6X5CNJ9oZ8fhKVHOQJNhcmpm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3980.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(966005)(7416002)(52116002)(2906002)(316002)(53546011)(110136005)(31696002)(86362001)(36756003)(5660300002)(83080400001)(66946007)(66476007)(66556008)(2616005)(31686004)(16526019)(186003)(6486002)(478600001)(8936002)(8676002)(921003)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mP0DqTNK1Lvh2F9PPf2euu+Sc4qMiom/Ye/88VwYFnnGX29VfF+JB310O1CBKHXI3NQu65EkTQoAhqlzM0erCw281jRtRPF+Uy2GuUHrgB/wGIFZY1W5QWQaWzC3i8HCA9SKlht30CXjuAesJWL52LR6UaPWcWMWzdAlJdCrVQS2ag3HzD2bb3qo+5BypiYYGBQZzeqYEJJxeCZ+rmLjb+TxIxyxipJvbZK5B1rrBabXErAndFPUkJhMS1Zfqbn22AtGQBlK1i820Lxn3eCFQqUmiryDVoOEdboet5MetGxZJ7sRcxfT9iufyCAbW+ruFOxbJvT55608bFxLNgAzA00pPy3DMZIMGxliEpb2CsQ343XjaCZ9IFTQEouDq3dHrgA/r+t1duffJzwHl54/cU1jLHiwkOsAZGbg+sGanGoCK9CoNN2KjaE9nwoU+BdAxBcK4AMSTTIIqM/KagyeW2Ip3e1eCZtrrdiND8T7eU0wgOB4vAZs2hIpY1YIDv/E55DvxD9ZFmDn41iRrhZ65g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c059951-657c-4ab5-23f1-08d80399a8f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:29:37.4690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBHod98Qq9j7RNNekOu8Ck+BYJLZJpIFrk0lIzfMp7fLEYeKanim8dfdjP96ixVk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3753
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 cotscore=-2147483648 mlxlogscore=768 spamscore=0 malwarescore=0
 clxscore=1015 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 2:27 PM, Eric Dumazet wrote:
> 
> 
> On 5/28/20 2:01 PM, Andrii Nakryiko wrote:
>> On 5/28/20 9:44 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    dc0f3ed1 net: phy: at803x: add cable diagnostics support f..
>>> git tree:       net-next
>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17289cd2100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=t1v5ZakZM9Aw_9u_I6FbFZ28U0GFs0e9dMMUOyiDxO4&e=
>>> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D7e1bc97341edbea6&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=yeXCTODuJF6ExmCJ-ppqMHsfvMCbCQ9zkmZi3W6NGHo&e=
>>> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D3610d489778b57cc8031&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=8fAJHh81yojiinnGJzTw6hN4w4A6XRZST4463CWL9Y8&e=
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D15f237aa100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=cPv-hQsGYs0CVz3I26BmauS0hQ8_YTWHeH5p-U5ElWY&e=
>>> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D1553834a100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=r6sGJDOgosZDE9sRxqFnVibDNJFt_6IteSWeqEQLbNE&e=
>>>
>>> The bug was bisected to:
>>>
>>> commit af6eea57437a830293eab56246b6025cc7d46ee7
>>> Author: Andrii Nakryiko <andriin@fb.com>
>>> Date:   Mon Mar 30 02:59:58 2020 +0000
>>>
>>>       bpf: Implement bpf_link-based cgroup BPF program attachment
>>>
>>> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D1173cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=rJIpYFSAMRfea3349dd7PhmLD_hriVwq8ZtTHcSagBA&e=
>>> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D1373cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=TWpx5JNdxKiKPABUScn8WB7u3fXueCp7BXwQHg4Unz0&e=
>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1573cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=-SMhn-dVZI4W51EZQ8Im0sdThgwt9M6fxUt3_bcYvk8&e=
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
>>> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
>>>
>>> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>>> CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>
>> No idea why it was bisected to bpf_link change. It seems completely struct sock-related. Seems like
>>
>> struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>>
>> ends up being NULL.
>>
>> Can some more networking-savvy people help with investigating this, please?
> 
> Well, the repro definitely uses BPF

It does. Even more so, it uses bpf_link_create for cgroup which was 
added in my patch. So before it, it just won't be attaching anything. I 
just suspect that bug can be repro'ed without cgroup bpf_link and 
existed before. This particular repro, though, will always stop on my 
commit.

> 
> On the following run, my kernel does not have L2TP, so does not crash.

You'd have to use syzbot's kernel config, there is a link to it above.

> 
> [pid 817013] bpf(BPF_TASK_FD_QUERY, {task_fd_query={pid=0, fd=-1, flags=0, buf_len=7, buf="cgroup", prog_id=0, fd_type=BPF_FD_TYPE_RAW_TRACEPOINT, probe_offset=0, probe_addr=0}}, 48) = -1 ENOENT (No such file or directory)
> [pid 817013] openat(AT_FDCWD, "cgroup", O_RDWR|O_PATH) = 3
> [pid 817013] bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=4, insns=0x20000000, license="GPL", log_level=0, log_size=0, log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0, prog_name="", prog_ifindex=0, expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=-1, func_info_rec_size=8, func_info=NULL, func_info_cnt=0, line_info_rec_size=16, line_info=NULL, line_info_cnt=0, attach_btf_id=0}, 112) = -1 EPERM (Operation not permitted)
> [pid 817013] bpf(BPF_LINK_CREATE, {link_create={prog_fd=-1, target_fd=3, attach_type=BPF_CGROUP_INET_SOCK_CREATE, flags=0}}, 16) = -1 EBADF (Bad file descriptor)
> [pid 817013] socket(AF_INET, SOCK_DGRAM, IPPROTO_L2TP <unfinished ...>
> [pid 816180] <... nanosleep resumed>NULL) = 0
> [pid 816180] wait4(-1, 0x7fffa59867cc, WNOHANG|__WALL, NULL) = 0
> [pid 816180] nanosleep({tv_sec=0, tv_nsec=1000000},  <unfinished ...>
> [pid 817013] <... socket resumed>)      = -1 EPROTONOSUPPORT (Protocol not supported)
> 


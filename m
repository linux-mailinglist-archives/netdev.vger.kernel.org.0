Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224961AB989
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 09:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438857AbgDPHQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 03:16:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52674 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438748AbgDPHQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 03:16:12 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03G7Fte2032656;
        Thu, 16 Apr 2020 00:15:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nnJK4kmrZzQK3O6UW+KkznfzhoUnjwbuH7nmdss3bXs=;
 b=elXZx5rFO6REgVJloMdx8w5nUxUGS8ld0SPzDYTErc3d0IByuZyLwwsbj6xmi7IpZhUe
 UTDFBodU80MY4JEDR7sHPu3OpV7iS5BsFot2Mahj5XHhNPVQ3+DaEoQ8k1lDDH0viFi8
 tBEaCGgeLJkzM/xId2Vt3TKbV9p0WTDZHQs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30dn85t1uq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Apr 2020 00:15:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 16 Apr 2020 00:15:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHPcaXW3ah9aHwfivjuu8TQ7NSFylSiCtSSQV+ildy4xs/tQ4viD31GVM5SrXhO/ycThLPVXPnFSS8/ZF9T8nWvDBzHTr+21oTNW4fJ15OPBa3TM/xOyLM86T/CQvLe7SmdXRci46YVnwTwcFTAXrGJwyeRZtuTHhQkPYKG2XnK8/jlkami/G/8YnqjIAp2SFzNTLHzrLUmWuLFhqxAclgRhPgDZQV94U1mzLAScvE8OomK8I1Uw5QZ8ZuAexuAcwLyCHzCUzgdeSuoFE7Y97PvTUxfPFiZ8+Q922xDijTYS6bgj7Wjt5j5QLNWp+YEiC8wDsGevDZTsar+0rK0fyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnJK4kmrZzQK3O6UW+KkznfzhoUnjwbuH7nmdss3bXs=;
 b=EPxqDL8qyYZzpfkJG1yBA06yy4gPqkzxJI+Qwxsd2uRTOIKuypMFQkjZ1BhdDBDYmela6RsLNYGeAFSRg5PlKiJHouQAG6sZdn32M1SgcuRUUi+0dA/nMpp8o4WuZaIsHQ/WP1B/GE/rwqvJGxyajFDxVOZn3RGisWh0IL1i5QiHgBYOqOhv/eJQPxEOXqt12+8ltW/lyLlO2+MhCGP1xNhFOdHhPU4Aq8RmU2bTEZe3+YQzXne/+2igWjWaGHpwFcETnSaT6EkGJTLipbOv9PiMXEOsJtpXTimdCzVR/3HZkY5hTJVailU1xcSubFzMF8rQjlszDcTpUM5zUu+Xpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnJK4kmrZzQK3O6UW+KkznfzhoUnjwbuH7nmdss3bXs=;
 b=UC0Ttpgk7oZuIkj9+b/frXAJ4KZFC7UXvmzTOevibBrPB9W0UVxf05JWCguzzXv+iMwGIJtqRG/W8c7bbWZGKSGZ7Mfl400xkgyDBA1ATgOJd7E15r0YhcO3zHMKqdYinsJEiw4PexgXuf+xKgtujT7LJ8GSK603pffKZj2FVJs=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3914.namprd15.prod.outlook.com (2603:10b6:303:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Thu, 16 Apr
 2020 07:15:54 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 07:15:54 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
 <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp>
 <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <55558493-4cc5-15f2-70b4-48ff30d39e06@fb.com>
Date:   Thu, 16 Apr 2020 00:15:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0102.namprd15.prod.outlook.com
 (2603:10b6:101:21::22) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rupeshk-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:dd1a) by CO1PR15CA0102.namprd15.prod.outlook.com (2603:10b6:101:21::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Thu, 16 Apr 2020 07:15:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:dd1a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ada1b4b-52b0-4bab-6d64-08d7e1d60049
X-MS-TrafficTypeDiagnostic: MW3PR15MB3914:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3914CACD22D31B34975715C4D3D80@MW3PR15MB3914.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0375972289
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(86362001)(52116002)(2616005)(6506007)(31686004)(31696002)(2906002)(5660300002)(8676002)(81156014)(53546011)(186003)(8936002)(16526019)(66556008)(66476007)(66946007)(6512007)(6486002)(36756003)(4326008)(316002)(110136005)(54906003)(478600001);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lHnjkpdLZPkxOGWweXQrDAYy9+CPFxzwikvuWK8CFuqdDR9o6Iwueq/tAj6HTyncQQUh7g1v4GWDKSnibwFzKHyhy9Lz5AeTGeLg6kwizt+iyX7f0ZKEp7xQ2BX80lBBZrC5CdxkO9JQqSK7itip+x2HLrHwtFtOMsz6UoYCT4QnVOy/Pq242y+k96hsFiausx8GtlyVats0E7HdbmlS2U2/Y4pKK92zp4j01BzE6kfqi0UngqP0HmoEjQU/pYvY9GJI/BYbCghBm3O1nM8MN3kjt2Ih9MMiHabYC9oBq41n8CEmzai1Aap+pVQzkvZ9d4HyX5M7vmc5HxBoHWD4gF3WgACMNMUfVGUU88iz9pz6ncU2PAnQf7WQPs1XOAqSJ1riKtdOuHn8xLtZp0tRPWXnHoJ4uZaZLZytAGaUiPpwFU4hulb4UKi51XkDDYch
X-MS-Exchange-AntiSpam-MessageData: O48q+ZjLczNTN5odFIqUzvikl8eI+CMgdB3Gaypp95QOwkfs4AWHg/K9wIGq35VWW1q6J2OyvdrfeVtkEKtgBMzVs5QFY8W87czJvj7CKmqD6qWQNauRgI7fnn0XxgJmgFf4sYvEcnCDDLdxe9QJ1f/c6FXNIbpyoPxPpGKjxdw49wJ2bsA/uxG2pXG80me8
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ada1b4b-52b0-4bab-6d64-08d7e1d60049
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2020 07:15:54.1890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SyFTWUCdxMhfLw07PUju4Nu+XAlmiLVphF/4ur/vLej0ELMafnKLH3rBl+nlxeC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3914
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_02:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/20 6:48 PM, Andrii Nakryiko wrote:
> On Wed, Apr 15, 2020 at 9:46 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Tue, Apr 14, 2020 at 09:45:08PM -0700, Andrii Nakryiko wrote:
>>>>
>>>>> FD is closed, dumper program is detached and dumper is destroyed
>>>>> (unless pinned in bpffs, just like with any other bpf_link.
>>>>> 3. At this point bpf_dumper_link can be treated like a factory of
>>>>> seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
>>>>> illustration purposes) command, that accepts dumper link FD and
>>>>> returns a new seq_file FD, which can be read() normally (or, e.g.,
>>>>> cat'ed from shell).
>>>>
>>>> In this case, link_query may not be accurate if a bpf_dumper_link
>>>> is created but no corresponding bpf_dumper_open_file. What we really
>>>> need to iterate through all dumper seq_file FDs.
>>>
>>> If the goal is to iterate all the open seq_files (i.e., bpfdump active
>>> sessions), then bpf_link is clearly not the right approach. But I
>>> thought we are talking about iterating all the bpfdump programs
>>> attachments, not **sessions**, in which case bpf_link is exactly the
>>> right approach.
>>
>> That's an important point. What is the pinned /sys/kernel/bpfdump/tasks/foo ?
> 
> Assuming it's not a rhetorical question, foo is a pinned bpf_dumper
> link (in my interpretation of all this).
> 
>> Every time 'cat' opens it a new seq_file is created with new FD, right ?
> 
> yes
> 
>> Reading of that file can take infinite amount of time, since 'cat' can be
>> paused in the middle.
> 
> yep, correct (though most use case probably going to be very short-lived)
> 
>> I think we're dealing with several different kinds of objects here.
>> 1. "template" of seq_file that is seen with 'ls' in /sys/kernel/bpfdump/
> 
> Let's clarify here again, because this can be interpreted differently.
> 
> Are you talking about, e.g., /sys/fs/bpfdump/task directory that
> defines what class of items should be iterated? Or you are talking
> about named dumper: /sys/fs/bpfdump/task/my_dumper?
> 
> If the former, I agree that it's not a link. If the latter, then
> that's what we've been so far calling "a named bpfdumper". Which is
> what I argue is a link, pinned in bpfdumpfs (*not bpffs*).
> 
> UPD: reading further, seems like it's some third interpretation, so
> please clarify.
> 
>> 2. given instance of seq_file after "template" was open
> 
> Right, corresponding to "bpfdump session" (has its own unique session_id).
> 
>> 3. bpfdumper program
> 
> Yep, BPF_PROG_LOAD returns FD to verified bpfdumper program.
> 
>> 4. and now links. One bpf_link from seq_file template to bpf prog and
> 
> So I guess "seq_file template" is /sys/kernel/bpfdump/tasks direntry
> itself, which has to be specified as FD during BPF_PROG_LOAD, is that
> right? If yes, I agree, "seq_file template" + attached bpf_prog is a
> link.
> 
>>    many other bpf_links from actual seq_file kernel object to bpf prog.
> 
> I think this one is not a link at all. It's a bpfdumper session. For
> me this is equivalent of a single BPF program invocation on cgroup due
> to a single packet. I understand that in this case it's multiple BPF
> program invocations, so it's not exactly 1:1, but if we had an easy
> way to do iteration from inside BPF program over all, say, tasks, that
> would be one BPF program invocation with a loop inside. So to me one
> seq_file session is analogous to a single BPF program execution (or,
> say one hardware event triggering one execution of perf_event BPF
> program).
> 
>>    I think both kinds of links need to be iteratable via get_next_id.
>>
>> At the same time I don't think 1 and 2 are links.
>> read-ing link FD should not trigger program execution. link is the connecting
>> abstraction. It shouldn't be used to trigger anything. It's static.
>> Otherwise read-ing cgroup-bpf link would need to trigger cgroup bpf prog too.
>> FD that points to actual seq_file is the one that should be triggering
>> iteration of kernel objects and corresponding execution of linked prog.
> 
> Yep, I agree totally, reading bpf_link FD directly as if it was
> seq_file seems weird and would support only a single time to read.
> 
>> That FD can be anon_inode returned from raw_tp_open (or something else)
> 
> raw_tp_open currently always returns bpf_link FDs, so if this suddenly
> returns readable seq_file instead, that would be weird, IMO.
> 
> 
>> or FD from open("/sys/kernel/bpfdump/foo").
> 
> Agreed.
> 
>>
>> The more I think about all the objects involved the more it feels that the
>> whole process should consist of three steps (instead of two).
>> 1. load bpfdump prog
>> 2. create seq_file-template in /sys/kernel/bpfdump/
>>     (not sure which api should do that)
> 
> Hm... ok, I think seq_file-template means something else entirely.
> It's not an attached BPF program, but also not a /sys/fs/bpfdump/task
> "provider". What is it and what is its purpose? Also, how is it
> cleaned up if application crashes between creating "seq_file-template"
> and attaching BPF program to it?
> 
>> 3. use bpf_link_create api to attach bpfdumper prog to that seq_file-template
>>
>> Then when the file is opened a new bpf_link is created for that reading session.
>> At the same time both kinds of links (to teamplte and to seq_file) should be
>> iteratable for observability reasons, but get_fd_from_id on them should probably
>> be disallowed, since holding such FD to these special links by other process
>> has odd semantics.
> 
> This special get_fd_from_id handling for bpfdumper links (in your
> interpretation) looks like a sign that using bpf_link to represent a
> specific bpfdumper session is not the right design.
> 
> As for obserabilitiy of bpfdumper sessions, I think using bpfdump
> program + task/file provider will give a good way to do this,
> actually, with no need to maintain a separate IDR just for bpfdumper
> sessions.
> 
>>
>> Similarly for anon seq_file it should be three step process as well:
>> 1. load bpfdump prog
>> 2. create anon seq_file (api is tbd) that returns FD
>> 3. use bpf_link_create to attach prog to seq_file FD
>>
>> May be it's all overkill. These are just my thoughts so far.
> 
> Just to contrast, in a condensed form, what I was proposing:
> 
> For named dumper:
> 1. load bpfdump prog
> 2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
> bpf_link anon FD back

I actually tried to prototype earlier today.
for existing tracing program (non-raw-tracepoint, e.g., fentry/fexit),
when raw_tracepoint_open() is called,
bpf_trampoline_link_prog() is called, trampoline is actually
updated with bpf_program and program start running. You can hold
this link_fd at user application or pin it to /sys/fs/bpf.

That is what I refers to in my previous email whether
we can have 'cat'-able link or not. But looks it is pretty hard.

Alternatively, we could still return a bpf_link.
The only thing bpf_link did is to hold a reference count for bpf_prog
and nothing else. Later on, we can use this bpf_link to pin dumper
or open anonymous seq_file.

But since bpf_link just holds a reference for prog and nothing more
and that is why I mentioned not 100% sure whether bpf_link is needed
as I could achieve the same thing with bpf_prog. Further,
it does not provide ability to query open files (a bpf program
for task/file target should be able to do it.)

But if for API consistency, we prefer raw_tracepoint_open() to
return a link fd. I can still do it, I guess. Or maybe link_query
still useful in some way.


> 3. pin link in bpfdumpfs (e.g., /sys/fs/bpfdump/task/my_dumper)
> 4. each open() of /sys/fs/bpfdump/task/my_dumper produces new
> bpfdumper session/seq_file
> 
> For anon dumper:
> 1. load bpfdump prog
> 2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
> bpf_link anon FD back
> 3. give bpf_link FD to some new API (say, BPF_DUMP_NEW_SESSION or
> whatever name) to create seq_file/bpfdumper session, which will create
> FD that can be read(). One can do that many times, each time getting
> its own bpfdumper session.
> 
> First two steps are exactly the same, as it should be, because
> named/anon dumper is still the same dumper. Note also that we can use
> bpf_link FD of named dumper and BPF_DUMP_NEW_SESSION command to also
> create sessions, which further underlines that the only difference
> between named and anon dumper is this bpfdumpfs direntry that allows
> to create new seq_file/session by doing normal open(), instead of
> BPF's BPF_DUMP_NEW_SESSION.
> 
> Named vs anon dumper is like "named" vs "anon" bpf_link -- we don't
> even talk in those terms about bpf_link, because the only difference
> is pinned direntry in a special FS, really.
> 

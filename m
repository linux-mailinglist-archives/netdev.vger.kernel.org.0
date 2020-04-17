Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645171AE066
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgDQPCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 11:02:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgDQPCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 11:02:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HEw4NI104956;
        Fri, 17 Apr 2020 15:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IM4u/O9m1Kbxkhtwt0QhoyIa9kJ6IGeuPbcANxRaXVs=;
 b=vHBDn9EP7d1RNVTKmc8H0S8z2Vm7/Jy7AbyGQ4lCRr8e71d+xbQDS10Rk1EdGiyQ/jyf
 gfvk8bwQmhTAlFpD7cdFNIVzOQL0gs/JhM9M5C/1AqJ0pkMluNfSZNr7SAE78nGVbt/w
 KfiAFylOV+8LhSzQbNMmcAupQ/CvPx6dqt1asA1zD1qGzIyCz/1IRT7DkmSMMFT1saxV
 nk6CI9RDGTTR/+7EVWAAmzcLQcyOPY96gUEJRooFxlkMJvgvPNdS81j4+uSaUndhnqNF
 A/7iCRFcpa6NGf6R+4y41BXdH9s8VhOl0n+c5IbWHwdtFRK7cz14aD8AfgDAflk4f2jf bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30emejqbkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 15:02:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HEvK5f084764;
        Fri, 17 Apr 2020 15:02:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn91pb2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 15:02:21 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HF2IcY007269;
        Fri, 17 Apr 2020 15:02:18 GMT
Received: from dhcp-10-175-205-33.vpn.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 08:02:17 -0700
Date:   Fri, 17 Apr 2020 16:02:09 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Yonghong Song <yhs@fb.com>
cc:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next v2 00/17] bpf: implement bpf based dumping
 of kernel data structures
In-Reply-To: <e9d56004-d595-a3ac-5b4c-e4507705a7c2@fb.com>
Message-ID: <alpine.LRH.2.21.2004171518090.16765@localhost>
References: <20200415192740.4082659-1-yhs@fb.com> <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com> <e9d56004-d595-a3ac-5b4c-e4507705a7c2@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=3 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=3 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020, Yonghong Song wrote:

> 
> 
> On 4/15/20 7:23 PM, David Ahern wrote:
> > On 4/15/20 1:27 PM, Yonghong Song wrote:
> >>
> >> As there are some discussions regarding to the kernel interface/steps to
> >> create file/anonymous dumpers, I think it will be beneficial for
> >> discussion with this work in progress.
> >>
> >> Motivation:
> >>    The current way to dump kernel data structures mostly:
> >>      1. /proc system
> >>      2. various specific tools like "ss" which requires kernel support.
> >>      3. drgn
> >>    The dropback for the first two is that whenever you want to dump more,
> >>    you
> >>    need change the kernel. For example, Martin wants to dump socket local
> > 
> > If kernel support is needed for bpfdump of kernel data structures, you
> > are not really solving the kernel support problem. i.e., to dump
> > ipv4_route's you need to modify the relevant proc show function.
> 
> Yes, as mentioned two paragraphs below. kernel change is required.
> The tradeoff is that this is a one-time investment. Once kernel change
> is in place, printing new fields (in most cases except new fields
> which need additional locks etc.) no need for kernel change any more.
>

One thing I struggled with initially when reading the cover
letter was understanding how BPF dumper programs get run.
Patch 7 deals with that I think and the answer seems to be to
create additional seq file infrastructure to the exisiting
one which executes the BPF dumper programs where appropriate.
Have I got this right? I guess more lightweight methods
such as instrumenting functions associated with an existing /proc
dumper are a bit too messy?

Thanks!

Alan

> > 
> > 
> >>    storage with "ss". Kernel change is needed for it to work ([1]).
> >>    This is also the direct motivation for this work.
> >>
> >>    drgn ([2]) solves this proble nicely and no kernel change is not needed.
> >>    But since drgn is not able to verify the validity of a particular
> >>    pointer value,
> >>    it might present the wrong results in rare cases.
> >>
> >>    In this patch set, we introduce bpf based dumping. Initial kernel
> >>    changes are
> >>    still needed, but a data structure change will not require kernel
> >>    changes
> >>    any more. bpf program itself is used to adapt to new data structure
> >>    changes. This will give certain flexibility with guaranteed correctness.
> >>
> >>    Here, kernel seq_ops is used to facilitate dumping, similar to current
> >>    /proc and many other lossless kernel dumping facilities.
> >>
> >> User Interfaces:
> >>    1. A new mount file system, bpfdump at /sys/kernel/bpfdump is
> >>    introduced.
> >>       Different from /sys/fs/bpf, this is a single user mount. Mount
> >>       command
> >>       can be:
> >>          mount -t bpfdump bpfdump /sys/kernel/bpfdump
> >>    2. Kernel bpf dumpable data structures are represented as directories
> >>       under /sys/kernel/bpfdump, e.g.,
> >>         /sys/kernel/bpfdump/ipv6_route/
> >>         /sys/kernel/bpfdump/netlink/
> > 
> > The names of bpfdump fs entries do not match actual data structure names
> > - e.g., there is no ipv6_route struct. On the one hand that is a good
> > thing since structure names can change, but that also means a mapping is
> > needed between the dumper filesystem entries and what you get for context.
> 
> Yes, the later bpftool patch implements a new command to dump such
> information.
> 
>   $ bpftool dumper show target
>   target                  prog_ctx_type
>   task                    bpfdump__task
>   task/file               bpfdump__task_file
>   bpf_map                 bpfdump__bpf_map
>   ipv6_route              bpfdump__ipv6_route
>   netlink                 bpfdump__netlink
> 
> in vmlinux.h generated by vmlinux BTF, we have
> 
> struct bpf_dump_meta {
>         struct seq_file *seq;
>         u64 session_id;
>         u64 seq_num;
> };
> 
> struct bpfdump__ipv6_route {
>         struct bpf_dump_meta *meta;
>         struct fib6_info *rt;
> };
> 
> Here, bpfdump__ipv6_route is the bpf program context type.
> User can based on this to write the bpf program.
> 
> > 
> > Further, what is the expectation in terms of stable API for these fs
> > entries? Entries in the context can change. Data structure names can
> > change. Entries in the structs can change. All of that breaks the idea
> > of stable programs that are compiled once and run for all future
> > releases. When structs change, those programs will break - and
> > structures will change.
> 
> Yes, the API (ctx) we presented to bpf program is indeed unstable.
> CO-RE should help to certain extend but if some fields are gone, e.g.,
> bpf program will need to be rewritten for that particular kernel version, or
> kernel bpfdump infrastructure can be enhanced to
> change its ctx structure to have more information to the program
> for that kernel version. In summary, I agree with you that this is
> an unstable API similar to other tracing program
> since it accesses kernel internal data structures.
> 
> > 
> > What does bpfdumper provide that you can not do with a tracepoint on a
> > relevant function and then putting a program on the tracepoint? ie., why
> > not just put a tracepoint in the relevant dump functions.
> 
> In my very beginning to explore bpfdump, kprobe to "show" function is
> one of options. But quickly we realized that we actually do not want
> to just piggyback on "show" function, but want to replace it with
> bpf. This will be useful in following different use cases:
>   1. first catable dumper file, similar to /proc/net/ipv6_route,
>      we want /sys/kernel/bpfdump/ipv6_route/my_dumper and you can cat
>      to get it.
> 
>      Using kprobe when you are doing `cat /proc/net/ipv6_route`
>      is complicated.  You probably need an application which
>      runs through `cat /proc/net/ipv6_route` and discard its output,
>      and at the same time gets the result from bpf program
>      (filtered by pid since somebody may run
>      `cat /proc/net/ipv6_route` at the same time. You may use
>      perf ring_buffer to send the result back to the application.
> 
>      note that perf ring buffer may lose records for whatever
>      reason and seq_ops are implemented not to lose records
>      by built-in retries.
> 
>      Using kprobe approach above is complicated and for each dumper
>      you need an application. We would like it to be just catable
>      with minimum user overhead to create such a dumper.
> 
>   2. second, anonymous dumper, kprobe/tracepoint will incur
>      original overhead of seq_printf per object. but user may
>      be only interested in a very small portion of information.
>      In such cases, bpf program directly doing filtering in
>      the kernel can potentially speed up a lot if there are a lot of
>      records to traverse.
> 
>   3. for data structures which do not have catable dumpers
>      for example task, hopefully, as demonstrated in this patch set,
>      kernel implementation and writing a bpf program are not
>      too hard. This especially enables people to do in-kernel
>      filtering which is the strength of the bpf.
> 
> 
> 

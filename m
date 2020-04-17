Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E0E1ADBAD
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbgDQK42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:56:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60798 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729985AbgDQK41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:56:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HArgTY052659;
        Fri, 17 Apr 2020 10:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=5etWj1bGduracVPl8axt8DZrMd40qx6Pd4VIwocWsKE=;
 b=duLYF5jtQtRF4KQwzFxtAeIdx/brHeL2aTgskddjrUQnaxsP7QmxxIWao+Rh3QbMgV26
 kMSRX7alEpvw+sTKEL8YhuIB0rVrw404hDnp6hmkOTn0y78ehgDW+L19Bfp+Dtr7VYd8
 nPr1F5s490iCP8Ieix4TbQpZqOipE0pxONnvVAAAIOMg7PJOf8i5mm2UzFf9uzJba9j7
 B4H2QAqchv4NnL2yFZMJMCLuebEeLYhDLHjr0/Qyoz6zKMv++WOd2KvBtPx8gw24FNOB
 qaZAF67Y0c44SXtfOo2rlRu2PrV1sapJl5c0/5JL9h1FCt5OGkAMLdP3JgBVkPMCFQFH Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30e0aac0d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:56:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HArIIm103855;
        Fri, 17 Apr 2020 10:54:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn91awcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:54:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HAs9mn024068;
        Fri, 17 Apr 2020 10:54:09 GMT
Received: from dhcp-10-175-205-33.vpn.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:54:08 -0700
Date:   Fri, 17 Apr 2020 11:54:01 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     David Ahern <dsahern@gmail.com>
cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next v2 00/17] bpf: implement bpf based dumping
 of kernel data structures
In-Reply-To: <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
Message-ID: <alpine.LRH.2.21.2004171106580.32559@localhost>
References: <20200415192740.4082659-1-yhs@fb.com> <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170086
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020, David Ahern wrote:

> On 4/15/20 1:27 PM, Yonghong Song wrote:
> > 
> > As there are some discussions regarding to the kernel interface/steps to
> > create file/anonymous dumpers, I think it will be beneficial for
> > discussion with this work in progress.
> > 
> > Motivation:
> >   The current way to dump kernel data structures mostly:
> >     1. /proc system
> >     2. various specific tools like "ss" which requires kernel support.
> >     3. drgn
> >   The dropback for the first two is that whenever you want to dump more, you
> >   need change the kernel. For example, Martin wants to dump socket local
> 
> If kernel support is needed for bpfdump of kernel data structures, you
> are not really solving the kernel support problem. i.e., to dump
> ipv4_route's you need to modify the relevant proc show function.
>

I need to dig into this patchset a bit more, but if there is
a need for in-kernel BTF-based structure dumping I've got a
work-in-progress patchset that does this by generalizing the code
that  deals with seq output in the verifier. I've posted it
as an RFC in case it has anything useful to offer here:

https://lore.kernel.org/bpf/1587120160-3030-1-git-send-email-alan.maguire@oracle.com/T/#t

The idea is that by using different callback function we can achieve
seq, snprintf or other output in-kernel using the kernel BTF data. 
I created one consumer as a proof-of-concept; it's a printk pointer 
format specifier.  Since the dump format is determined in kernel
it's a bit constrained format-wise, but may be good enough for
some cases.

To give a flavour for what the printed-out data looks like,
here we use pr_info() to display a struct sk_buff *.  Note
we specify the 'N' modifier to show type field names:

  struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);

  pr_info("%pTN<struct sk_buff>", skb);

...gives us:

{{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,.rb_right=00000000c7916e9c,.rb_left=00000000c7916e9c}|.list={.next=00000000c7916e9c,.prev=00000000c7916e9c}},{.sk=00000000c7916e9c|.ip_defrag_offset=0},{.tstamp=0|.skb_mstamp_ns=0},.cb=['\0'],{{._skb_refdst=0,.destructor=00000000c7916e9c}|.tcp_tsorted_anchor={.next=00000000c7916e9c,.prev=00000000c7916e9c}},._nfct=0,.len=0,.data_len=0,.mac_len=0,.hdr_len=0,.queue_mapping=0,.__cloned_offset=[],.cloned=0x0,.nohdr=0x0,.fclone=0x0,.peeked=0x0,.head_frag=0x0,.pfmemalloc=0x0,.active_extensions=0,.headers_start=[],.__pkt_type_offset=[],.pkt_type=0x0,.ignore_df=0x0,.nf_trace=0x0,.ip_summed=0x0,.ooo_okay=0x0,.l4_hash=0x0,.sw_hash=0x0,.wifi_acked_valid=0x0,.wifi_acked=0x0,.no_fcs=0x0,.encapsulation=0x0,.encap_hdr_csum=0x0,.csum_valid=0x0,.__pkt_vlan_present_offset=[],.vlan_present=0x0,.csum_complete_sw=0x0,.csum_level=0x0,.csum_not_inet=0x0,.dst_pending_co

[printk output is truncated at 1024 bytes, but more
compact output can be achieved by not specifying 'N'
for type names. I may need to add a specifier to avoid
pointer obfuscation]

With a printk format specifier, trace_printk() in BPF then
inherits this dumping behaviour for free, but I think it
would also be possible to add a helper so that the type
name didn't have to be specified.  The verifier could insert
BTF ids and type data could be dumped for tracing arguments
via a flavour of bpf_perf_event_output() helper or similar.
To be clear I haven't done any of that yet in the RFC patchset,
but it seems feasible at least.

Anyway perhaps there's something useful in it which can help
towards the goal of easier dumping of data structures.

I'll spend some time over the weekend looking at the
BTF dumper patchset; apologies I haven't got very far
with it yet.

Thanks!

Alan

> 
> >   storage with "ss". Kernel change is needed for it to work ([1]).
> >   This is also the direct motivation for this work.
> > 
> >   drgn ([2]) solves this proble nicely and no kernel change is not needed.
> >   But since drgn is not able to verify the validity of a particular pointer value,
> >   it might present the wrong results in rare cases.
> > 
> >   In this patch set, we introduce bpf based dumping. Initial kernel changes are
> >   still needed, but a data structure change will not require kernel changes
> >   any more. bpf program itself is used to adapt to new data structure
> >   changes. This will give certain flexibility with guaranteed correctness.
> > 
> >   Here, kernel seq_ops is used to facilitate dumping, similar to current
> >   /proc and many other lossless kernel dumping facilities.
> > 
> > User Interfaces:
> >   1. A new mount file system, bpfdump at /sys/kernel/bpfdump is introduced.
> >      Different from /sys/fs/bpf, this is a single user mount. Mount command
> >      can be:
> >         mount -t bpfdump bpfdump /sys/kernel/bpfdump
> >   2. Kernel bpf dumpable data structures are represented as directories
> >      under /sys/kernel/bpfdump, e.g.,
> >        /sys/kernel/bpfdump/ipv6_route/
> >        /sys/kernel/bpfdump/netlink/
> 
> The names of bpfdump fs entries do not match actual data structure names
> - e.g., there is no ipv6_route struct. On the one hand that is a good
> thing since structure names can change, but that also means a mapping is
> needed between the dumper filesystem entries and what you get for context.
> 
> Further, what is the expectation in terms of stable API for these fs
> entries? Entries in the context can change. Data structure names can
> change. Entries in the structs can change. All of that breaks the idea
> of stable programs that are compiled once and run for all future
> releases. When structs change, those programs will break - and
> structures will change.
> 
> What does bpfdumper provide that you can not do with a tracepoint on a
> relevant function and then putting a program on the tracepoint? ie., why
> not just put a tracepoint in the relevant dump functions.
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BD22904A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 07:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbfEXFLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 01:11:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEXFLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 01:11:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4O58OsX099722;
        Fri, 24 May 2019 05:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=REAUKjfQKEdcVeSuvq5zJFnMuBvwiLH8VFdTYr5FO2A=;
 b=N16bIUJUMgkuTYiVWaUyPgm0pnAAc3GzVg4umAtD70IztClaxxPGoU97HPBidT9mjnxl
 8cVLsdvzQHwy5qs1ERSiwsOwFicPCr0r5YL6zYPZNaiWflbuxaLMV6KqIXDyVCH6sXAK
 Io9e6gyFpat9tuq6/4jDXoC0migg4oRzUoruZX1TfsPHjKDCzaR8iqXezrvTybEAOsAP
 0SWJreZs+Ig3JmI1Jv9DTHxZK26teL52X/JlrySXh23FkUWBwoFS94s3vVAFDCIcmeo8
 AzEs6+N9JK+nLnHBudVv0/XdNfcNj0bx25Pbn+/R6AnKxqBT/2HeDEbz0P2b+cnMR0J2 hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2smsk5pjbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 May 2019 05:10:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4O5A9v0051514;
        Fri, 24 May 2019 05:10:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2smsh2njjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 May 2019 05:10:17 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4O5AG23052029;
        Fri, 24 May 2019 05:10:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2smsh2njja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 May 2019 05:10:16 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4O5AF8X001163;
        Fri, 24 May 2019 05:10:15 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 May 2019 05:10:15 +0000
Date:   Fri, 24 May 2019 01:10:11 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524051011.GV2422@oracle.com>
References: <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
 <20190523054610.GR2422@oracle.com>
 <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
 <20190523190243.54221053@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523190243.54221053@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905240035
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 07:02:43PM -0400, Steven Rostedt wrote:
> On Thu, 23 May 2019 14:13:31 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > > In DTrace, people write scripts based on UAPI-style interfaces and they don't
> > > have to concern themselves with e.g. knowing how to get the value of the 3rd
> > > argument that was passed by the firing probe.  All they need to know is that
> > > the probe will have a 3rd argument, and that the 3rd argument to *any* probe
> > > can be accessed as 'arg2' (or args[2] for typed arguments, if the provider is
> > > capable of providing that).  Different probes have different ways of passing
> > > arguments, and only the provider code for each probe type needs to know how
> > > to retrieve the argument values.
> > > 
> > > Does this help bring clarity to the reasons why an abstract (generic) probe
> > > concept is part of DTrace's design?  
> > 
> > It actually sounds worse than I thought.
> > If dtrace script reads some kernel field it's considered to be uapi?! ouch.
> > It means dtrace development philosophy is incompatible with the linux kernel.
> > There is no way kernel is going to bend itself to make dtrace scripts
> > runnable if that means that all dtrace accessible fields become uapi.
> 
> Now from what I'm reading, it seams that the Dtrace layer may be
> abstracting out fields from the kernel. This is actually something I
> have been thinking about to solve the "tracepoint abi" issue. There's
> usually basic ideas that happen. An interrupt goes off, there's a
> handler, etc. We could abstract that out that we trace when an
> interrupt goes off and the handler happens, and record the vector
> number, and/or what device it was for. We have tracepoints in the
> kernel that do this, but they do depend a bit on the implementation.
> Now, if we could get a layer that abstracts this information away from
> the implementation, then I think that's a *good* thing.

This is indeed what DTrace uses.  When a probe triggers (be it kprobe, network
event, tracepoint, etc), the core execution component is invoked with a probe
id, and a set of data items.  In its current implementation (not BPF based),
the probe triggers which causes a probe type specific handler to be called in
the provider module for that probe type.  The handler determines the probe id
(e.g. for a kprobe that might be based on the program counter value), and it
also prepares the list of data items (which we call arguments to the probe).
It then calls the execution component with the probe id and arguments.

All probe types are handled by a provider, and each provider has a handler
that determines the probe id and arguments, and then calls the execution
component.  So, at the level of the execution component all probes look the
same.

Scripts commonly operate on the abstract probe, but scriptr writers can opt
to do more fancy things that do depend on probe implementation details.  In
that case, there is of course no guarantee that the script will keep working
as kernel releases change.

> > In stark contrast to dtrace all of bpf tracing scripts (bcc scripts
> > and bpftrace scripts) are written for specific kernel with intimate
> > knowledge of kernel details. They do break all the time when kernel changes.
> > kprobe and tracepoints are NOT uapi. All of them can change.
> > tracepoints are a bit more stable than kprobes, but they are not uapi.
> 
> I wish that was totally true, but tracepoints *can* be an abi. I had
> code reverted because powertop required one to be a specific format. To
> this day, the wakeup event has a "success" field that writes in a
> hardcoded "1", because there's tools that depend on it, and they only
> work if there's a success field and the value is 1.
> 
> I do definitely agree with you that the Dtrace code shall *never* keep
> the kernel from changing. That is, if Dtrace depends on something that
> changes (let's say we record priority of a task, but someday priority
> is replaced by something else), then Dtrace must cope with it. It must
> not be a blocker like user space applications can be.

I fully agree that DTrace or any other tool should never prevent changes from
happening at the kernel level.  Even in its current (non-BPF) implementation
it has had to cope with changes.  The abstraction through the providers has
been a real benefit for that because changes to probe mechanisms can be dealt
with at the level of the providers, and everything else can remain the same
because the abstraction "hides" the implementation details.

	Kris

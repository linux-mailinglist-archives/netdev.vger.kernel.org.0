Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C95275B1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfEWFrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:47:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60460 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfEWFrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:47:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N5d1cX156360;
        Thu, 23 May 2019 05:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=SZvz3FNqQ2ERgyYAASIJsy0BAN5IplnozQnMx87tluY=;
 b=LMf9Yzf42e8K2iVK+yXVK+zULoZjU2vSspbLhDAXowYCB2XKAjRnxfEsFB/rA8RJ0IEc
 nMVKZGEKaU6ZhW/cRc2B30zoRL+2UjVIg8xpmBnqBWuOWW4GGBtrhICCRkNYI/x5UqdS
 Wwybw6YXhWfKZ57MuIexQWnc+kOgKOQSzi40cGQMq+JBoFVGVG0d+qY9g3EU1DQieJpL
 7+cCa6c+HwqeZNhfSQjsYK6s7LbB6U9kaXfgANtCJG2C9+cuAU6XwLCGCKwSCLYTSICl
 AtDzArXDubeNdkswEgVqRDoi2HtzvxYgRTNZK3zZcMS76zEFaUnIjsiD3DPJvQdYjCHd nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2smsk5fxkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 05:46:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N5jYJs087575;
        Thu, 23 May 2019 05:46:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2smsgt1h9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 May 2019 05:46:15 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4N5kEjY088530;
        Thu, 23 May 2019 05:46:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2smsgt1h9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 05:46:14 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4N5kDfW026192;
        Thu, 23 May 2019 05:46:13 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 05:46:13 +0000
Date:   Thu, 23 May 2019 01:46:10 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523054610.GR2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905230040
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 01:53:31PM -0700, Alexei Starovoitov wrote:
> On Wed, May 22, 2019 at 01:23:27AM -0400, Kris Van Hees wrote:
> > 
> > Userspace aside, there are various features that are not currently available
> > such as retrieving the ppid of the current task, and various other data items
> > that relate to the current task that triggered a probe.  There are ways to
> > work around it (using the bpf_probe_read() helper, which actually performs a
> > probe_kernel_read()) but that is rather clunky
> 
> Sounds like you're admiting that the access to all kernel data structures
> is actually available, but you don't want to change user space to use it?

I of course agree that access to all kernel structures can be done using the
bpf_probe_read() helper.  But I hope you agree that the availability of that
helper doesn't mean that there is no room for more elegant ways to access
information.  There are already helpers (e.g. bpf_get_current_pid_tgid) that
could be replaced by BPF code that uses bpf_probe_read to accomplish the same
thing.

> > triggered the execution.  Often, a single DTrace clause is associated with
> > multiple probes, of different types.  Probes in the kernel (kprobe, perf event,
> > tracepoint, ...) are associated with their own BPF program type, so it is not
> > possible to load the DTrace clause (translated into BPF code) once and
> > associate it with probes of different types.  Instead, I'd have to load it
> > as a BPF_PROG_TYPE_KPROBE program to associate it with a kprobe, and I'd have
> > to load it as a BPF_PROG_TYPE_TRACEPOINT program to associate it with a
> > tracepoint, and so on.  This also means that I suddenly have to add code to
> > the userspace component to know about the different program types with more
> > detail, like what helpers are available to specific program types.
> 
> That also sounds that there is a solution, but you don't want to change user space ?

I think there is a difference between a solution and a good solution.  Adding
a lot of knowledge in the userspace component about how things are imeplemented
at the kernel level makes for a more fragile infrastructure and involves
breaking down well established boundaries in DTrace that are part of the design
specifically to ensure that userspace doesn't need to depend on such intimate
knowledge.

> > Another advantage of being able to operate on a more abstract probe concept
> > that is not tied to a specific probe type is that the userspace component does
> > not need to know about the implementation details of the specific probes.
> 
> If that is indeed the case that dtrace is broken _by design_
> and nothing on the kernel side can fix it.
> 
> bpf prog attached to NMI is running in NMI.
> That is very different execution context vs kprobe.
> kprobe execution context is also different from syscall.
> 
> The user writing the script has to be aware in what context
> that script will be executing.

The design behind DTrace definitely recognizes that different types of probes
operate in different ways and have different data associated with them.  That
is why probes (in legacy DTrace) are managed by providers, one for each type
of probe.  The providers handle the specifics of a probe type, and provide a
generic probe API to the processing component of DTrace:

    SDT probes -----> SDT provider -------+
                                          |
    FBT probes -----> FBT provider -------+--> DTrace engine
                                          |
    syscall probes -> systrace provider --+

This means that the DTrace processing component can be implemented based on a
generic probe concept, and the providers will take care of the specifics.  In
that sense, it is similar to so many other parts of the kernel where a generic
API is exposed so that higher level components don't need to know implementation
details.

In DTrace, people write scripts based on UAPI-style interfaces and they don't
have to concern themselves with e.g. knowing how to get the value of the 3rd
argument that was passed by the firing probe.  All they need to know is that
the probe will have a 3rd argument, and that the 3rd argument to *any* probe
can be accessed as 'arg2' (or args[2] for typed arguments, if the provider is
capable of providing that).  Different probes have different ways of passing
arguments, and only the provider code for each probe type needs to know how
to retrieve the argument values.

Does this help bring clarity to the reasons why an abstract (generic) probe
concept is part of DTrace's design?

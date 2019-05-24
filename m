Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011F42905D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 07:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbfEXF1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 01:27:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57996 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfEXF1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 01:27:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4O5Oa9M125490;
        Fri, 24 May 2019 05:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2aOPtxdLHzGw7Dt5RbmFViI6+cHz5U3e+/7S2hdY2yo=;
 b=5bSbWAh6ORhjFoe5e8Ud++LhyOIRKEpBDq3BVVv/PpnMsWUhV2LIesc2uDaz5JtlSAXZ
 t1KsfNCUcxiicLYkbvRVuNf5sL5J0o7Wuff3A7Ghx3bqxtwR8xN591hUJ+z9zSfxM8n2
 GIfonrdnwqGnVMSsomLjO4qwVwmjQLZojqzkIl+ZW6gKjXz8VTOoDRFeuTOaPWnjEELE
 Bt0LkJ4ryqOb0OhhAQNkfR+CYl70IkJ5dZfF0F0AdnebnX9XWDU1YrRz0Gs8UBHNb0Qv
 ESmV//N4btvVBuFX784fk0z4vpc7h3n/VWX+8DkKHaHElKINdYpG2p+rKPhUsDVbuuQ8 uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2smsk5pmar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 May 2019 05:26:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4O5P9ud195612;
        Fri, 24 May 2019 05:26:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2smshfnajx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 May 2019 05:26:25 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4O5QPYn002381;
        Fri, 24 May 2019 05:26:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2smshfnajs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 May 2019 05:26:25 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4O5QJ6j012291;
        Fri, 24 May 2019 05:26:19 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 May 2019 05:26:19 +0000
Date:   Fri, 24 May 2019 01:26:16 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524052616.GW2422@oracle.com>
References: <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
 <20190523054610.GR2422@oracle.com>
 <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
 <20190523190243.54221053@gandalf.local.home>
 <20190524003148.pk7qbxn7ysievhym@ast-mbp.dhcp.thefacebook.com>
 <20190523215737.6601ab7c@oasis.local.home>
 <20190524020849.vxg3hqjtnhnicyzp@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524020849.vxg3hqjtnhnicyzp@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905240037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 07:08:51PM -0700, Alexei Starovoitov wrote:
> On Thu, May 23, 2019 at 09:57:37PM -0400, Steven Rostedt wrote:
> > On Thu, 23 May 2019 17:31:50 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > 
> > > > Now from what I'm reading, it seams that the Dtrace layer may be
> > > > abstracting out fields from the kernel. This is actually something I
> > > > have been thinking about to solve the "tracepoint abi" issue. There's
> > > > usually basic ideas that happen. An interrupt goes off, there's a
> > > > handler, etc. We could abstract that out that we trace when an
> > > > interrupt goes off and the handler happens, and record the vector
> > > > number, and/or what device it was for. We have tracepoints in the
> > > > kernel that do this, but they do depend a bit on the implementation.
> > > > Now, if we could get a layer that abstracts this information away from
> > > > the implementation, then I think that's a *good* thing.  
> > > 
> > > I don't like this deferred irq idea at all.
> > 
> > What do you mean deferred?
> 
> that's how I interpreted your proposal: 
> "interrupt goes off and the handler happens, and record the vector number"
> It's not a good thing to tell about irq later.
> Just like saying lets record perf counter event and report it later.

The abstraction I mentioned does not defer anything - it merely provides a way
for all probe events to be processed as a generic probe with a set of values
associated with it (e.g. syscall arguments for a syscall entry probe).  The
program that implements what needs to happen when that probe fires still does
whatever is necessary to collect information, and dump data in the output
buffers before execution continues.

I could trace entry into a syscall by using a syscall entry tracepoint or by
putting a kprobe on the syscall function itself.  I am usually interested in
whether the syscall was called, what the arguments were, and perhaps I need to
collect some other data related to it.  More often than not, both probes would
get the job done.  With an abstraction that hides the implementation details
of the probe mechanism itself, both cases are essentially the same.

> > > Abstracting details from the users is _never_ a good idea.
> > 
> > Really? Most everything we do is to abstract details from the user. The
> > key is to make the abstraction more meaningful than the raw data.
> > 
> > > A ton of people use bcc scripts and bpftrace because they want those details.
> > > They need to know what kernel is doing to make better decisions.
> > > Delaying irq record is the opposite.
> > 
> > I never said anything about delaying the record. Just getting the
> > information that is needed.
> > 
> > > > 
> > > > I wish that was totally true, but tracepoints *can* be an abi. I had
> > > > code reverted because powertop required one to be a specific
> > > > format. To this day, the wakeup event has a "success" field that
> > > > writes in a hardcoded "1", because there's tools that depend on it,
> > > > and they only work if there's a success field and the value is 1.  
> > > 
> > > I really think that you should put powertop nightmares to rest.
> > > That was long ago. The kernel is different now.
> > 
> > Is it?
> > 
> > > Linus made it clear several times that it is ok to change _all_
> > > tracepoints. Period. Some maintainers somehow still don't believe
> > > that they can do it.
> > 
> > From what I remember him saying several times, is that you can change
> > all tracepoints, but if it breaks a tool that is useful, then that
> > change will get reverted. He will allow you to go and fix that tool and
> > bring back the change (which was the solution to powertop).
> 
> my interpretation is different.
> We changed tracepoints. It broke scripts. People changed scripts.

In my world, the sequence is more like: tracepoints get changed, scripts
break, I fix the provider (abstraction), scripts work again.  Users really
appreciate that aspect because many of our users are not kernel experts.

> > > Some tracepoints are used more than others and more people will
> > > complain: "ohh I need to change my script" when that tracepoint
> > > changes. But the kernel development is not going to be hampered by a
> > > tracepoint. No matter how widespread its usage in scripts.
> > 
> > That's because we'll treat bpf (and Dtrace) scripts like modules (no
> > abi), at least we better. But if there's a tool that doesn't use the
> > script and reads the tracepoint directly via perf, then that's a
> > different story.
> 
> absolutely not.
> tracepoint is a tracepoint. It can change regardless of what
> and how is using it.

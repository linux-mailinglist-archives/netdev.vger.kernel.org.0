Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907CE37F32
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfFFVAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:00:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37236 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbfFFVAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:00:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56Kwvi7035512;
        Thu, 6 Jun 2019 20:58:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=drRR+6CX4wX/6UUl5ax5nLLNcEZtf2FgpdLY3+Avjx8=;
 b=tpAub7gDsWCoILP8GDMYVgaffNAV+Nma+Mi0gxs5ELnN0QrSWpzV2LPksjAn7jfK1R/L
 IMZ89tm+p8PkFwMw4SL8VOpBAVmDcHrjCgejmBwlijMv20xs7OvR9MB0NjF4h//ck3o9
 rq1zG5F8Y16jNuDIUMRlsy3YI9tsfTF/zQ9z5bFO5x1SAn4LjTtMHD08EiYrMeU9Yxua
 pqacmfVkZEtKO1JW55K5d0e/d1hI8/IMhS2/Ja49hm2nVJqoKU6BUX9IcZa97Mp+3WlC
 t4sn/25kB3fqQZBENJ231K1M5v/kqWsD9ScTXBFRVth+1MWOhw90BDWMPUzlQgNM91Gm IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugsttx57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 20:58:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56KwZrG096313;
        Thu, 6 Jun 2019 20:58:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2swnhaywtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Jun 2019 20:58:56 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x56KwuIf096743;
        Thu, 6 Jun 2019 20:58:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2swnhaywtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 20:58:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x56KwsrG017895;
        Thu, 6 Jun 2019 20:58:54 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 13:58:54 -0700
Date:   Thu, 6 Jun 2019 16:58:51 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Chris Mason <clm@fb.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "dtrace-devel@oss.oracle.com" <dtrace-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190606205851.GI11035@oracle.com>
References: <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com>
 <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
 <20190530161543.GA1835@oracle.com>
 <5AD44AC7-F88F-4068-B122-962839F968B2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5AD44AC7-F88F-4068-B122-962839F968B2@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 03:25:25PM +0000, Chris Mason wrote:
> 
> I'm being pretty liberal with chopping down quoted material to help 
> emphasize a particular opinion about how to bootstrap existing 
> out-of-tree projects into the kernel.  My goal here is to talk more 
> about the process and less about the technical details, so please 
> forgive me if I've ignored or changed the technical meaning of anything 
> below.
> 
> On 30 May 2019, at 12:15, Kris Van Hees wrote:
> 
> > On Thu, May 23, 2019 at 01:28:44PM -0700, Alexei Starovoitov wrote:
> >
> > ... I believe that the discussion that has been going on in other
> > emails has shown that while introducing a program type that provides a
> > generic (abstracted) context is a different approach from what has 
> > been done
> > so far, it is a new use case that provides for additional ways in 
> > which BPF
> > can be used.
> >
> 
> [ ... ]
> 
> >
> > Yes and no.  It depends on what you are trying to do with the BPF 
> > program that
> > is attached to the different events.  From a tracing perspective, 
> > providing a
> > single BPF program with an abstract context would ...
> 
> [ ... ]
> 
> >
> > In this model kprobe/ksys_write and 
> > tracepoint/syscalls/sys_enter_write are
> > equivalent for most tracing purposes ...
> 
> [ ... ]
> 
> >
> > I agree with what you are saying but I am presenting an additional use 
> > case
> 
> [ ... ]
> 
> >>
> >> All that aside the kernel support for shared libraries is an awesome
> >> feature to have and a bunch of folks want to see it happen, but
> >> it's not a blocker for 'dtrace to bpf' user space work.
> >> libbpf can be taught to do this 'pseudo shared library' feature
> >> while 'dtrace to bpf' side doesn't need to do anything special.
> 
> [ ... ]
> 
> This thread intermixes some abstract conceptual changes with smaller 
> technical improvements, and in general it follows a familiar pattern 
> other out-of-tree projects have hit while trying to adapt the kernel to 
> their existing code.  Just from this one email, I quoted the abstract 
> models with use cases etc, and this is often where the discussions side 
> track into less productive areas.
> 
> >
> > So you are basically saying that I should redesign DTrace?
> 
> In your place, I would have removed features and adapted dtrace as much 
> as possible to require the absolute minimum of kernel patches, or even 
> better, no patches at all.  I'd document all of the features that worked 
> as expected, and underline anything either missing or suboptimal that 
> needed additional kernel changes.  Then I'd focus on expanding the 
> community of people using dtrace against the mainline kernel, and work 
> through the series features and improvements one by one upstream over 
> time.

Well, that is actually what I am doing in the sense that the proposed patches
are quite minimal and lie at the core of the style of tracing that we need to
support.  So I definitely agree with your statement.  The code I posted
implements a minimal set of features (hardly any at all), although as Peter
pointed out, some more can be stripped from it and I have done that already
in a revision of the patchset I was preparing.

> Your current approach relies on an all-or-nothing landing of patches 
> upstream, and this consistently leads to conflict every time a project 
> tries it.  A more incremental approach will require bigger changes on 
> the dtrace application side, but over time it'll be much easier to 
> justify your kernel changes.  You won't have to talk in abstract models, 
> and you'll have many more concrete examples of people asking for dtrace 
> features against mainline.  Most importantly, you'll make dtrace 
> available on more kernels than just the absolute latest mainline, and 
> removing dependencies makes the project much easier for new users to 
> try.

I am not sure where I gave the impression that my approach relies on an
all-or-nothing landing of patches.  My intent (and the content of the patches
reflects that I think) was to work from a minimal base and build on that,
adding things as needed.  Granted, it depends on a rather crucial feature in
the design that apparently should be avoided for now as well, and I can
definitely work on avoiding that for now.  But I hope that it is clear from
the patch set I posted that an incremental approach is indeed what I intend
to do.

Thank you for putting it in clear terms and explaining patfalls that have
be observed in the past with projects.  I will proceed with an even more
minimalist approach.

To that end, could you advice on who patches should be Cc'd to to have the
first minimal code submitted to a tools/dtrace directory in the kernel tree?

	Kris

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E536111EA95
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfLMSnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:43:40 -0500
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:35700 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728473AbfLMSnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:43:40 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 39AD7182CED28;
        Fri, 13 Dec 2019 18:43:38 +0000 (UTC)
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1183:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:5007:6261:6742:7875:10004:10400:10848:10967:11232:11658:11914:12296:12297:12740:12760:12895:13069:13180:13229:13311:13357:13439:14181:14659:14721:21080:21627:30012:30054:30070:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: flame51_59855085f2047
X-Filterd-Recvd-Size: 2377
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (Authenticated sender: nevets@goodmis.org)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Fri, 13 Dec 2019 18:43:35 +0000 (UTC)
Date:   Fri, 13 Dec 2019 13:43:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [RFC] btf: Some structs are doubled because of struct
 ring_buffer
Message-ID: <20191213134333.19335555@gandalf.local.home>
In-Reply-To: <20191213183646.GB8994@krava>
References: <20191213153553.GE20583@krava>
        <20191213112438.773dff35@gandalf.local.home>
        <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
        <20191213121118.236f55b8@gandalf.local.home>
        <20191213180223.GE2844@hirez.programming.kicks-ass.net>
        <20191213132941.6fa2d1bd@gandalf.local.home>
        <20191213183646.GB8994@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 19:36:46 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> > Thinking about this, perhaps we should remove the word "ring" from
> > both. That is:
> > 
> >   perf_buffer and trace_buffer ?  
> 
> sounds good to me.. and too good to be true ;-)
> please let me know if I should send the perf change

Note, changing the other one is a lot more invasive. It's not as easy
as I thought. I forgot that even blktrace uses it. And a lot of the
trace event code is tied to the ring buffer code, as well as every
tracer.

-- Steve

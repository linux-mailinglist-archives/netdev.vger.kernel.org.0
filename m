Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75D11E9AD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfLMSDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:03:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51106 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMSC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kstcnju99/4uTkeBULCR49gexo2kDQXxkPqHdnoayrQ=; b=eTetltOhOvd8GfMlH1WcvAmkA
        1vfDGo/w2yy4HK1O09ym7FJxwYu03Vb0s/Cu44ECIFWxVFBe3ifBBAOWhmQced+aIPH7VCotHimx/
        Gjyg0vfIGklWdGNkB/xiYYkT44RzTIGw6yKxGH55ciFOzr2GKklPtibKo2PNNVIa4plprFmVx8Yv0
        AoBeBrU2ELaCMHLsjM7W/xi94xm8IydD9vtqfuwLYwCvcKP/aBrDswX5qM5u3Hnlsr2fxH/HE4y+s
        WBojoeF9OfXQQFTki8bEWfUH5UrnncdSZkRs3ZJ+rsjHX/XqFicFtJGQjFtDaHjSTCvcffsAVNSul
        wXdefbkww==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifpGk-0000Mj-V7; Fri, 13 Dec 2019 18:02:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C39ED304D2B;
        Fri, 13 Dec 2019 19:01:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7E68920427392; Fri, 13 Dec 2019 19:02:23 +0100 (CET)
Date:   Fri, 13 Dec 2019 19:02:23 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [RFC] btf: Some structs are doubled because of struct ring_buffer
Message-ID: <20191213180223.GE2844@hirez.programming.kicks-ass.net>
References: <20191213153553.GE20583@krava>
 <20191213112438.773dff35@gandalf.local.home>
 <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
 <20191213121118.236f55b8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213121118.236f55b8@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 12:11:18PM -0500, Steven Rostedt wrote:
> On Fri, 13 Dec 2019 08:51:57 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > It had two choices. Both valid. I don't know why gdb picked this one.
> > So yeah I think renaming 'ring_buffer' either in ftrace or in perf would be
> > good. I think renaming ftrace one would be better, since gdb picked perf one
> > for whatever reason.
> 
> Because of the sort algorithm. But from a technical perspective, the
> ring buffer that ftrace uses is generic, where the perf ring buffer can
> only be used for perf. Call it "event_ring_buffer" or whatever, but
> it's not generic and should not have a generic name.

Your ring buffer was so generic that I gave up trying to use it after
trying for days :-( (the fundamental problem was that it was impossible
to have a single cpu buffer; afaik that is still true today)

Nor is the perf buffer fundamentally specific to perf, but there not
being another user means there has been very little effort to remove
perf specific things from it.

There are major design differences between them, which is
unquestionably, but I don't think it is fair to say one is more or less
generic.

How about we rename both? I'm a bit adverse to long names, so how about
we rename the perf one to perf_buffer and the trace one to trace_buffer?

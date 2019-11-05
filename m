Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30002F01AF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbfKEPkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:40:32 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:51043 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389507AbfKEPkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:40:32 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 7EE5E182CF669;
        Tue,  5 Nov 2019 15:40:30 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2553:2559:2562:2693:2739:2895:2914:2987:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4385:5007:6119:6120:6261:7514:7875:7901:7903:8778:10010:10400:10848:10967:11026:11232:11658:11914:12043:12050:12296:12297:12438:12663:12740:12760:12895:13161:13229:13439:13972:14096:14097:14181:14659:14721:21080:21324:21433:21627:21740:21789:21939:30054:30070:30083:30090:30091,0,RBL:146.247.46.6:@goodmis.org:.lbl8.mailshell.net-62.14.41.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:1:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: mom97_3e4e71219012e
X-Filterd-Recvd-Size: 3221
Received: from grimm.local.home (unknown [146.247.46.6])
        (Authenticated sender: rostedt@goodmis.org)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Tue,  5 Nov 2019 15:40:27 +0000 (UTC)
Date:   Tue, 5 Nov 2019 10:40:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, peterz@infradead.org, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH bpf-next 0/7] Introduce BPF trampoline
Message-ID: <20191105104024.4e99a630@grimm.local.home>
In-Reply-To: <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
References: <20191102220025.2475981-1-ast@kernel.org>
        <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.4git49 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 06:31:56 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> Steven,
> look slike your branch hasn't been updated in 13 days.
> Are you still planning to fix the bugs and send it in for the merge window?
> I cannot afford to wait a full release, since I have my own follow for
> XDP/networking based on this and other folks are building their stuff on top of
> BPF trampoline too. So I'm thinking for v2 I will switch to using text_poke()
> and add appropriate guard checks, so it will be safe out of the box without
> ftrace dependency. If register_ftrace_direct() indeed comes in soon I'll
> switch to that and will make bpf trampoline to co-operate with ftrace.
> text_poke approach will make it such that what ever comes first to trace the
> fentry (either bpf trampoline or ftrace) will grab the nop and the other system
> will not be able to attach. That's safe and correct, but certainly not nice
> long term. So the fix will be needed. The key point that switching to text_poke
> will remove the register_ftrace_direct() dependency, unblock bpf developers and
> will give you time to land your stuff at your pace.

Alexei,

I am still working on it, and if it seems stable enough I will submit
it for this merge window, but there's no guarantees. It's ready when
it's ready. I gave 5 talks last week (4 in Lyon, and one is Sofia,
Bulgaria), thus I did not have time to work on it then. I'm currently
in the Sofia office, and I got a version working that seems to be
stable. But I still have to break it up into a patch series, and run it
through more stress tests.

If you have to wait you may need to wait. The Linux kernel isn't
something that is suppose to put in temporary hacks, just to satisfy
someone's deadline. Feel free to fork the kernel if you need to. That's
what everyone else does.

The RT patch has been out of tree specifically because we never pushed
in the hacks to make it work. We could have landed RT in the tree years
ago, but we *never* pushed in something that wasn't ready. I suggest
the BPF folks follow suit.

-- Steve

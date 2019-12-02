Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059F210F154
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 21:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfLBUJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 15:09:51 -0500
Received: from www62.your-server.de ([213.133.104.62]:45420 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfLBUJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 15:09:50 -0500
Received: from 29.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.29] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ibs0x-0006Oe-Kt; Mon, 02 Dec 2019 21:09:47 +0100
Date:   Mon, 2 Dec 2019 21:09:47 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
Message-ID: <20191202200947.GA14353@pc-9.home>
References: <20191129222911.3710-1-daniel@iogearbox.net>
 <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
 <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
 <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
 <20191202083006.GJ2844@hirez.programming.kicks-ass.net>
 <20191202091716.GA30232@localhost.localdomain>
 <CAADnVQJEqVmwAJ2V9NB+0Udwg5H9KJfCSjuSpARAGHLPuhnA=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJEqVmwAJ2V9NB+0Udwg5H9KJfCSjuSpARAGHLPuhnA=w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25651/Mon Dec  2 10:44:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 08:19:45AM -0800, Alexei Starovoitov wrote:
> On Mon, Dec 2, 2019 at 1:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Mon, Dec 02, 2019 at 09:30:06AM +0100, Peter Zijlstra wrote:
> > > On Sun, Dec 01, 2019 at 06:49:32PM -0800, Eric Dumazet wrote:
> > >
> > > > Thanks for the link !
> > > >
> > > > Having RO protection as a debug feature would be useful.
> > > >
> > > > I believe we have CONFIG_STRICT_MODULE_RWX (and CONFIG_STRICT_KERNEL_RWX) for that already.
> > > >
> > > > Or are we saying we also want to get rid of them ?
> > >
> > > No, in fact I'm working on making that stronger. We currently still have
> > > a few cases that violate the W^X rule.
> > >
> > > The thing is, when the BPF stuff is JIT'ed, the actual BPF instruction
> > > page is not actually executed at all, so making it RO serves no purpose,
> > > other than to fragment the direct map.
> >
> > Yes exactly, in that case it is only used for dumping the BPF insns back
> > to user space and therefore no need at all to set it RO. (The JITed image
> > however *is* set as RO. - Perhaps there was some confusion given your
> > earlier question.)
> 
> May be we should also flip the default to net.core.bpf_jit_enable=1
> for x86-64 ? and may be arm64 ? These two JITs are well tested
> and maintained.

Seems reasonable given their status and exposure they've had over the years. I
can follow-up on that.

Thanks,
Daniel

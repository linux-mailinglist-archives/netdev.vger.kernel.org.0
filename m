Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBEAEADEE
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfJaKz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:55:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:43312 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfJaKz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:55:56 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQ87H-0005tq-71; Thu, 31 Oct 2019 11:55:47 +0100
Date:   Thu, 31 Oct 2019 11:55:46 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Daniel Borkmann <borkmann@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Sage <eric@sage.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: Compile build issues with samples/bpf/ again
Message-ID: <20191031105546.GA24528@pc-63.home>
References: <20191030114313.75b3a886@carbon>
 <CAJ+HfNhSsnFXFG1ZHYCxSmYjdv0bWWszToJzmH1KFn7G5CBavQ@mail.gmail.com>
 <20191030120551.68f8b67b@carbon>
 <d7d91ac5-a579-2ada-f96d-4239b8dc11b6@iogearbox.net>
 <20191030153340.GE27327@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191030153340.GE27327@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25619/Thu Oct 31 09:55:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 12:33:40PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 30, 2019 at 04:07:32PM +0100, Daniel Borkmann escreveu:
> > On 10/30/19 12:05 PM, Jesper Dangaard Brouer wrote:
> > > On Wed, 30 Oct 2019 11:53:21 +0100
> > > Björn Töpel <bjorn.topel@gmail.com> wrote:
> > > > On Wed, 30 Oct 2019 at 11:43, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > [...]
> > > > > It is annoy to experience that simply building kernel tree samples/bpf/
> > > > > is broken as often as it is.  Right now, build is broken in both DaveM
> > > > > net.git and bpf.git.  ACME have some build fixes queued from Björn
> > > > > Töpel. But even with those fixes, build (for samples/bpf/task_fd_query_user.c)
> > > > > are still broken, as reported by Eric Sage (15 Oct), which I have a fix for.
> > > > 
> > > > Hmm, something else than commit e55190f26f92 ("samples/bpf: Fix build
> > > > for task_fd_query_user.c")?
> > > 
> > > I see, you already fixed this... and it is in the bpf.git tree.
> > > 
> > > Then we only need your other fixes from ACME's tree.  I just cloned a
> > > fresh version of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> > > to check that 'make M=samples/bpf' still fails.
> > 
> > Correct, the two fixes from Bjorn which made the test_attr__* optional were
> > taken by Arnaldo given the main change was under tools/perf/perf-sys.h. If
> > you cherry pick these ...
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=06f84d1989b7e58d56fa2e448664585749d41221
> > https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=fce9501aec6bdda45ef3a5e365a5e0de7de7fe2d
> > 
> > ... into bpf tree, then all builds fine. When Arnaldo took them, my assumption
> > was that these fixes would have been routed by him to Linus' tree, and upon
> > resync we pull them automatically into bpf tree again.
> > 
> > Look like didn't happen yet at this point, Arnaldo?
> 
> Yes, it will go to Linus, I was just unsure when was that it should go,
> i.e. next or in the current window, so I've queued it up to next.
> 
> [acme@quaco perf]$ git tag --contains 06f84d1989b7e58d56fa2e448664585749d41221
> perf-core-for-mingo-5.5-20191011
> perf-core-for-mingo-5.5-20191021
> [acme@quaco perf]$
> 
> So its in tip, but queued for 5.5, while I think you guys expect this to
> fast track into 5.4, right? If so, please get that queued up or tell me
> if you prefer for me to do it.

Personally, I don't think it is super critical, but I tend to agree with
Jesper that samples code should compile before final release is out the
door. I can cherry-pick both from tip into bpf tree, no problem. The commit
will end up twice in git history, but we've done this in very rare occasions
in the past to get dependencies into bpf.

> I agree with Jesper that when one changes something in common code, then
> one does have to test all tools/ that may use that common code, but in
> this specific case the breakage happened because tools/perf/ code was
> used outside tools/perf/ which I completely didn't expect to happen,
> whatever that is in tools/perf/perf-sys.h better go to tools/include or
> tools/arch or some other common area, agreed?

Some of the BPF samples code seems to be using sys_perf_event_open(), for
other BPF bits under tools/ this seems not the case.

Thanks,
Daniel

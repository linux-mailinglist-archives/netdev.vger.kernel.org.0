Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5475D34B0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJJXzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:55:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:40830 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJJXzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:55:24 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iIiHC-00021i-9B; Fri, 11 Oct 2019 01:55:22 +0200
Date:   Fri, 11 Oct 2019 01:55:21 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 1/3] uapi/bpf: fix helper docs
Message-ID: <20191010235521.GC20202@pc-63.home>
References: <20191007030738.2627420-1-andriin@fb.com>
 <20191007030738.2627420-2-andriin@fb.com>
 <20191007094346.GC27307@pc-66.home>
 <CAEf4BzZDKkxtMGwnn+Zam58sYwS33EDuw3hrUTexmC9o7Xnj1w@mail.gmail.com>
 <20191008214937.GH27307@pc-66.home>
 <CAEf4Bza=p1uiV0mHvzrbisSYS1s2Gnx4S2109eGjtP0Vhr_mbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza=p1uiV0mHvzrbisSYS1s2Gnx4S2109eGjtP0Vhr_mbg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25598/Thu Oct 10 10:50:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 04:32:01PM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 8, 2019 at 2:49 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Mon, Oct 07, 2019 at 10:47:19AM -0700, Andrii Nakryiko wrote:
> > > On Mon, Oct 7, 2019 at 2:43 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > On Sun, Oct 06, 2019 at 08:07:36PM -0700, Andrii Nakryiko wrote:
> > > > > Various small fixes to BPF helper documentation comments, enabling
> > > > > automatic header generation with a list of BPF helpers.
> > > > >
> > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > [...]
> > > > I'm wondering whether it would simply be much better to always just use 'void *ctx'
> > > > for everything that is BPF context as it may be just confusing to people why different
> > > > types are chosen sometimes leading to buggy drive-by attempts to 'fix' them back into
> > > > struct sk_buff * et al.
> > >
> > > I'm impartial on this issue. In some cases it might be helpful to
> > > specify what is the expected type of the context, if it's only ever
> > > one type, but there are lots of helpers that accept various contexts,
> > > so for consistency its better to just have "void *context".
> >
> > I would favor consistency here to always have "void *context". One
> > additional issue I could see happening otherwise on top of the 'fix'
> > attempts is that if existing helpers get enabled for multiple program
> > types and these have different BPF context, then it might be quite
> > easy to forget converting struct __sk_buff * and whatnot to void * in
> > the helper API doc, so the auto-generated BPF helpers will continue
> > to have only the old type.
> 
> Ok, I can create a follow-up clean up patch changing all of them to
> void *. There is also a weird singular case of having three
> declarations of bpf_get_socket_cookie() with different contexts. I
> assume I should just combine them into a single
> declaration/description, right?

Yes, definitely.

Thanks,
Daniel

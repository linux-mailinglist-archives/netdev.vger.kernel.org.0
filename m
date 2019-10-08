Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9BAD030F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfJHVtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:49:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:52294 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfJHVtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:49:41 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iHxMP-0002zs-J0; Tue, 08 Oct 2019 23:49:37 +0200
Date:   Tue, 8 Oct 2019 23:49:37 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 1/3] uapi/bpf: fix helper docs
Message-ID: <20191008214937.GH27307@pc-66.home>
References: <20191007030738.2627420-1-andriin@fb.com>
 <20191007030738.2627420-2-andriin@fb.com>
 <20191007094346.GC27307@pc-66.home>
 <CAEf4BzZDKkxtMGwnn+Zam58sYwS33EDuw3hrUTexmC9o7Xnj1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZDKkxtMGwnn+Zam58sYwS33EDuw3hrUTexmC9o7Xnj1w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25596/Tue Oct  8 10:33:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 10:47:19AM -0700, Andrii Nakryiko wrote:
> On Mon, Oct 7, 2019 at 2:43 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Sun, Oct 06, 2019 at 08:07:36PM -0700, Andrii Nakryiko wrote:
> > > Various small fixes to BPF helper documentation comments, enabling
> > > automatic header generation with a list of BPF helpers.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
[...]
> > I'm wondering whether it would simply be much better to always just use 'void *ctx'
> > for everything that is BPF context as it may be just confusing to people why different
> > types are chosen sometimes leading to buggy drive-by attempts to 'fix' them back into
> > struct sk_buff * et al.
> 
> I'm impartial on this issue. In some cases it might be helpful to
> specify what is the expected type of the context, if it's only ever
> one type, but there are lots of helpers that accept various contexts,
> so for consistency its better to just have "void *context".

I would favor consistency here to always have "void *context". One
additional issue I could see happening otherwise on top of the 'fix'
attempts is that if existing helpers get enabled for multiple program
types and these have different BPF context, then it might be quite
easy to forget converting struct __sk_buff * and whatnot to void * in
the helper API doc, so the auto-generated BPF helpers will continue
to have only the old type.

Thanks,
Daniel

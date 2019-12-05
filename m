Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7AF113D27
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 09:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfLEIgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 03:36:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60969 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729029AbfLEIgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 03:36:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575534965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unOsoMJ+PDB7YTVJj+V77yM295LedXddpTVeN1xxafA=;
        b=AXwzs1wHrcUpIU3bfzKqiWEMx1f1Dv97WM1FVwHw3wzN16qu7Q6VFxCgImuUZeTyqic7bE
        KceBnTKdi3Hd753pujLZ1FG2j6be8dNlip1S1isbqqq0UYddawlkPc2WxUAxLK30HvqcKu
        owL+tGvrGi0fmeM6Qrh+ayEmSwUU0f0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-k1QuIdDLNGS22CUrZdg5BA-1; Thu, 05 Dec 2019 03:36:03 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC9E664A7D;
        Thu,  5 Dec 2019 08:36:00 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8388C5D6A5;
        Thu,  5 Dec 2019 08:35:49 +0000 (UTC)
Date:   Thu, 5 Dec 2019 09:35:48 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        brouer@redhat.com, Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191205093548.6eee1449@carbon>
In-Reply-To: <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
References: <20191202131847.30837-1-jolsa@kernel.org>
        <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
        <87wobepgy0.fsf@toke.dk>
        <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
        <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
        <20191204135405.3ffb9ad6@cakuba.netronome.com>
        <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: k1QuIdDLNGS22CUrZdg5BA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Dec 2019 15:39:49 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Dec 04, 2019 at 01:54:05PM -0800, Jakub Kicinski wrote:
> > On Wed, 4 Dec 2019 13:16:13 -0800, Andrii Nakryiko wrote:  
> > > I wonder what big advantage having bpftool in libbpf's Github repo
> > > brings, actually? The reason we need libbpf on github is to allow
> > > other projects like pahole to be able to use libbpf from submodule.
> > > There is no such need for bpftool.
> > > 
> > > I agree about preference to release them in sync, but that could be
> > > easily done by releasing based on corresponding commits in github's
> > > libbpf repo and kernel repo. bpftool doesn't have to physically live
> > > next to libbpf on Github, does it?  
> > 
> > +1

I don't see any advantage of having bpftool in libbpf's GitHub repo.

As Jakub mention we have seen bpftool crash fixes, which would be
painful/annoying to maintain fixes for in the libbpf GitHub repo.

As Andrii also points out, it requires more work, as GitHub libbpf have
to maintain a separate Makefile for bpftool.


> > > Calling github repo a "mirror" is incorrect. It's not a 1:1 copy of
> > > files. We have a completely separate Makefile for libbpf, and we have
> > > a bunch of stuff we had to re-implement to detach libbpf code from
> > > kernel's non-UAPI headers. Doing this for bpftool as well seems like
> > > just more maintenance. Keeping github's Makefile in sync with kernel's
> > > Makefile (for libbpf) is PITA, I'd rather avoid similar pains for
> > > bpftool without a really good reason.  
> > 
> > Agreed. Having libbpf on GH is definitely useful today, but one can hope
> > a day will come when distroes will get up to speed on packaging libbpf,
> > and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> > bpftool in the same boat is just more baggage.  
> 
> Distros should be packaging libbpf and bpftool from single repo on github.
> Kernel tree is for packaging kernel.

I don't think that is a good idea.  You are creating double work and
wasting distro developers time.  Let me explain: 

1. First of all, GitHub libbpf does not have a stable branches (which
makes sense, given this is a read-only clone of kernel tree). Thus,
distro developers have to maintain that themselves, in their internal
package tree (that is based on GitHub libbpf).

2. Kernel BPF changes usually require updates to libbpf, as selftests
uses libbpf.  Thus, the distro kernel backporter is already required to
backport libbpf parts.

This is double work, the code changes to libbpf are now maintained in
two places for the distro.


The disadvantage for distros to package libbpf (+ bpftool and perf) off
their distro kernel tree is that a fix to libbpf, requires rolling a
new kernel minor release.  The solution to that is simply that distro
package for libbpf have a separate (RPM) spec file, with own
versioning, which sources points to distro kernel tree.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


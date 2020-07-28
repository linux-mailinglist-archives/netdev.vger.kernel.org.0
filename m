Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602422309B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgG1MNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgG1MNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 08:13:45 -0400
Received: from quaco.ghostprotocols.net (179.176.1.55.dynamic.adsl.gvt.net.br [179.176.1.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0880206D8;
        Tue, 28 Jul 2020 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595938424;
        bh=elgb9VJwDQUV7e8qJKF8s3/erPhoLE4ugpQnXtwPLEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=He3sp8UikoQ+i7onRo9OVHoDVJacJ//GewEeSnQj/cBZcalKDpHJtL9O2v4CRqSpZ
         +SPCLFcF8EdaFF81A78dct95GXnDW7AStzDIBIxDDYNhjWGSYA6Ea+RMh5yxTuCOHT
         lEHHteNEf+CWM83dmq0SQdtDPzAEHobXV5lRROYY=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 85F9E404B1; Tue, 28 Jul 2020 09:13:42 -0300 (-03)
Date:   Tue, 28 Jul 2020 09:13:42 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 35/35] perf: don't touch RLIMIT_MEMLOCK
Message-ID: <20200728121342.GD40195@kernel.org>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-36-guro@fb.com>
 <CAEf4BzYUhybiSz2S-jtuv5+KcaHSxCLoY=nq1g597bvwpUemZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYUhybiSz2S-jtuv5+KcaHSxCLoY=nq1g597bvwpUemZw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Jul 27, 2020 at 11:09:43PM -0700, Andrii Nakryiko escreveu:
> On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > Since bpf stopped using memlock rlimit to limit the memory usage,
> > there is no more reason for perf to alter its own limit.
> >
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> 
> Cc'd Armaldo, but I'm guessing it's a similar situation that latest
> perf might be running on older kernel and should keep working.

Yes, please leave it as is, the latest perf should continue working with
older kernels, so if there is a way to figure out if the kernel running
is one where BPF doesn't use memlock rlimit for that purpose, then in
those cases we shouldn't use it.

- Arnaldo
 
> >  tools/perf/builtin-trace.c      | 10 ----------
> >  tools/perf/tests/builtin-test.c |  6 ------
> >  tools/perf/util/Build           |  1 -
> >  tools/perf/util/rlimit.c        | 29 -----------------------------
> >  tools/perf/util/rlimit.h        |  6 ------
> >  5 files changed, 52 deletions(-)
> >  delete mode 100644 tools/perf/util/rlimit.c
> >  delete mode 100644 tools/perf/util/rlimit.h
> >
> 
> [...]

-- 

- Arnaldo

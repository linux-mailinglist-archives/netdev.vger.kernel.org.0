Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAD53C6FA9
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbhGMLZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235881AbhGMLZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 07:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3D966117A;
        Tue, 13 Jul 2021 11:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626175384;
        bh=Aae1Qk7FDHxDqCGXiyf7ZTDCvIv9/biiOfm0a9nKJLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsivhSf/eXgBzA3V5pV8jl3cs0+TKjdEJl3F/882r9uc0MpHVbf4q2AhlBXYEqfJt
         8Vwd/Mreg1/FRkqj4xTkRbQra3RJEjeVutP0dhSkgD4zANW5171+Xrq4iU+DoWQpnv
         qg0YaE6hvhQuoCd5zoLqL+dLdFpwHFerqDn7he+I=
Date:   Tue, 13 Jul 2021 13:23:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>, jic23@kernel.org,
        linux@rasmusvillemoes.dk
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
Message-ID: <YO13lSUdPfNGOnC3@kroah.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
 <YO1s+rHEqC9RjMva@kroah.com>
 <YO12ARa3i1TprGnJ@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO12ARa3i1TprGnJ@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 02:16:17PM +0300, Andy Shevchenko wrote:
> On Tue, Jul 13, 2021 at 12:37:46PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jul 13, 2021 at 11:45:41AM +0300, Andy Shevchenko wrote:
> > > kernel.h is being used as a dump for all kinds of stuff for a long time.
> > > Here is the attempt cleaning it up by splitting out container_of() and
> > > typeof_memeber() macros.
> > 
> > That feels messy, why?
> 
> Because the headers in the kernel are messy.

Life is messy and can not easily be partitioned into tiny pieces.  That
way usually ends up being even messier in the end...

> > Reading one .h file for these common
> > macros/defines is fine, why are container_of and typeof somehow
> > deserving of their own .h files?
> 
> It's explained here. There are tons of drivers that includes kernel.h for only
> a few or even solely for container_of() macro.

And why is that really a problem?  kernel.h is in the cache and I would
be amazed if splitting this out actually made anything build faster.

> > What speedups are you seeing by
> > splitting this up?
> 
> C preprocessing.

Numbers please.

greg k-h

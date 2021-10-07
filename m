Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD6424FF6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbhJGJXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:23:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:29344 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240304AbhJGJXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:23:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="223604774"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="223604774"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 02:21:11 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="439457666"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 02:21:02 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mYPaE-009TlL-CK;
        Thu, 07 Oct 2021 12:20:58 +0300
Date:   Thu, 7 Oct 2021 12:20:58 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kunit-dev@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
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
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
Message-ID: <YV67+vrn3MxpXABy@smile.fi.intel.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
 <YO1s+rHEqC9RjMva@kroah.com>
 <YO12ARa3i1TprGnJ@smile.fi.intel.com>
 <YO13lSUdPfNGOnC3@kroah.com>
 <CANiq72=vs8-88h3Z+BON=qA4CZQ1pS1nggnCFHDEHYyG+Y+3JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=vs8-88h3Z+BON=qA4CZQ1pS1nggnCFHDEHYyG+Y+3JQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 08:39:22PM +0200, Miguel Ojeda wrote:
> On Tue, Jul 13, 2021 at 1:23 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Life is messy and can not easily be partitioned into tiny pieces.  That
> > way usually ends up being even messier in the end...
> 
> I agree measurements would be ideal.
> 
> Having said that, even if it makes no performance difference, I think
> it is reasonable to split things (within reason) and makes a bunch of
> other things easier, plus sometimes one can enforce particular
> conventions in the separate header (like I did when introducing
> `compiler_attributes.h`).

It does almost 2% (steady) speedup. I will send a v2 with methodology
and numbers of testing.

-- 
With Best Regards,
Andy Shevchenko



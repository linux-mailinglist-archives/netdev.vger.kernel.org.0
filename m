Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD3964CDE2
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiLNQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbiLNQVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:21:35 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92282C9;
        Wed, 14 Dec 2022 08:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671034893; x=1702570893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sugwmwrUIAbwUVd9kUUcbnqMzWklglljdUgzpTG789o=;
  b=HGnDWEVEEFs82G5oXn1K7JNd1hyZhblpDhYzT/48TneA7w9Hi1QUek5s
   YS1RcYq9PW4xVQ2RYbAIoxgh04wfoffBtejEO4tX35Umv0JE8C0xWldEJ
   rGfIBd/AOoT6ASYeZRe5CNLe9qgz7F9DT0kK6/VIuHIOjAusqHnKc0W8e
   YK61SXjAen1i72ek46pYydcKTNrDiGtXQHhnvwU+J/b6ESj1WDrclo5wY
   gtZCyC3iBLeI0Fmr6sgsHOK4+5d732V+YgABIVdgL/1EjNtHR2PmCwwNW
   nqC32EZ8EllECpFl+mXn5bReoihuL89Ukv3eY6wdOclvdHaa5Qk4kCqiH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="404716272"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="404716272"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 08:21:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="642559944"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="642559944"
Received: from joe-255.igk.intel.com (HELO localhost) ([172.22.229.67])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 08:21:20 -0800
Date:   Wed, 14 Dec 2022 17:21:17 +0100
From:   Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        dri-devel@lists.freedesktop.org, Song Liu <song@kernel.org>,
        linux-mtd@lists.infradead.org, Stanislav Fomichev <sdf@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, ilay.bahat1@gmail.com,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Petr Mladek <pmladek@suse.com>,
        david.keisarschm@mail.huji.ac.il,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        intel-gfx@lists.freedesktop.org,
        Steven Rostedt <rostedt@goodmis.org>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Borislav Petkov <bp@alien8.de>, Hannes Reinecke <hare@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        bpf@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Hao Luo <haoluo@google.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        aksecurity@gmail.com, Jiri Olsa <jolsa@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/5] Renaming weak prng invocations -
 prandom_bytes_state, prandom_u32_state
Message-ID: <20221214162117.GC1062210@linux.intel.com>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <Y5c8KLzJFz/XZMiM@zx2c4.com>
 <20221214123358.GA1062210@linux.intel.com>
 <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 04:15:49PM +0100, Eric Dumazet wrote:
> On Wed, Dec 14, 2022 at 1:34 PM Stanislaw Gruszka
> <stanislaw.gruszka@linux.intel.com> wrote:
> >
> > On Mon, Dec 12, 2022 at 03:35:20PM +0100, Jason A. Donenfeld wrote:
> > > Please CC me on future revisions.
> > >
> > > As of 6.2, the prandom namespace is *only* for predictable randomness.
> > > There's no need to rename anything. So nack on this patch 1/5.
> >
> > It is not obvious (for casual developers like me) that p in prandom
> > stands for predictable. Some renaming would be useful IMHO.
> 
> Renaming makes backports more complicated, because stable teams will
> have to 'undo' name changes.
> Stable teams are already overwhelmed by the amount of backports, and
> silly merge conflicts.

Since when backporting problems is valid argument for stop making
changes? That's new for me.

> linux kernel is not for casual readers.

Sure.

Regards
Stanislaw

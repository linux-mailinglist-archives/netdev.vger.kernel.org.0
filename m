Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2C464CF6E
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbiLNS3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbiLNS3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:29:02 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5486FCD8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:29:01 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BEISlEt001171
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:28:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671042531; bh=yBGs7uN391IpXsrDxRmFEUWTGiaryut5x17IYCOizWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=iTvQW2ZcZl/RaloFVFvof3Xa5t0qJOPMbf9tEe1ZxUY/ml5As1AyeT37tSuPOcGw+
         17vCGhEEjx9LOnZs3GLmkDSXWr8W/CTALV2Vj0BYRVQmlX/+14VYvEZc9cLvJWdXVL
         9oIQx2LCrwfMWPFmSCPXfT4Hv2/oosDrkhOpQHhPv+0hz9gFTJV7qyI/FWZGTrENN7
         84ztbhtlutCuVHyOA0sewiP3fT74UfRtl1dIyLBRPrb4K2WVewrJxycNUFMnma8otO
         XQPs5XLQapq5t8UKt6SRlcg5Vr1Ov6Ww0fAJCCZS9NV3kc3QPwS8c73yxGFZtDnfx+
         ysY4rmQix2LxQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 615B615C40A2; Wed, 14 Dec 2022 13:28:47 -0500 (EST)
Date:   Wed, 14 Dec 2022 13:28:47 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
Message-ID: <Y5oV3zVhc2C2sUaF@mit.edu>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <Y5c8KLzJFz/XZMiM@zx2c4.com>
 <20221214123358.GA1062210@linux.intel.com>
 <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
 <20221214162117.GC1062210@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214162117.GC1062210@linux.intel.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 05:21:17PM +0100, Stanislaw Gruszka wrote:
> On Wed, Dec 14, 2022 at 04:15:49PM +0100, Eric Dumazet wrote:
> > On Wed, Dec 14, 2022 at 1:34 PM Stanislaw Gruszka
> > <stanislaw.gruszka@linux.intel.com> wrote:
> > >
> > > On Mon, Dec 12, 2022 at 03:35:20PM +0100, Jason A. Donenfeld wrote:
> > > > Please CC me on future revisions.
> > > >
> > > > As of 6.2, the prandom namespace is *only* for predictable randomness.
> > > > There's no need to rename anything. So nack on this patch 1/5.
> > >
> > > It is not obvious (for casual developers like me) that p in prandom
> > > stands for predictable. Some renaming would be useful IMHO.

I disagree.  pseudo-random has *always* menat "predictable".  And the
'p' in prandom was originally "pseudo-random".  In userspace,
random(3) is also pseudo-random, and is ***utterly*** predictable.  So
the original use of prandom() was a bit more of an explicit nod to the
fact that prandom is something which is inherently predictable.

So I don't think it's needed to rename it, whether it's to
"predictable_rng_prandom_u32", or "no_you_idiot_dont_you_dare_use_it_for_cryptographi_purposes_prandom_u32".

I think we need to assume a certain base level of competence,
especially for someone who is messing with security psensitive kernel
code.  If a developer doesn't know that a prng is predictable, that's
probably the *least* of the sort of mistakes that they might make.

					- Ted

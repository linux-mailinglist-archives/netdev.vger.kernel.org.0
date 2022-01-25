Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE249BDB6
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 22:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiAYVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 16:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiAYVKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 16:10:10 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9105C06173B;
        Tue, 25 Jan 2022 13:10:10 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id e9so19341861pgb.3;
        Tue, 25 Jan 2022 13:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tnjWQpPZgvym7mIT/FjIJfPnS74H3Mhitjmyd7nnFlo=;
        b=L27q8lyRF6ykweTX5ePXmmQhjYAAFtiNSy4iJXGogE4cAJZlvPCtKduexW5VQRBB3d
         B6bezGIYuNVdDeKhMAJrj4HIuLc+DpQ6S6naQXXTjOWZJ9P+PPyZ7Gho1eZ5ILX+1k7l
         lPY6Dlffry32GizStwlaOwbv1r+n5BD4p2VoiondyjWV89CbVEEQKCZC5ewhfJkVYXyy
         jQ36WaUVSmeNswPn74Dwcb2EZdl2KBiFr3LO6Oet3cIHonVdz28g1PTwGwEq0jTz5dT3
         PbducqBOxJDyH/AlejaEyWvh3Tier5RuDIaSZg0zNUkfUUsWq3aZ2nfYrtTzFyC8XH9S
         ufJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tnjWQpPZgvym7mIT/FjIJfPnS74H3Mhitjmyd7nnFlo=;
        b=GMgByO/3eyQkDHRBB4OSd1LPBTP4MCix8QkyIjw4Z3NjuISsD8H4W/VJmZ9DJX9flT
         kFInWZe/hiQPMEffqepMKZ8WGysRoHlFh+5v9qEO8ZSRSdcxK/Eaz8Lx7RhwC6SOGK1r
         63M7EmDo42M2/BxK9+Q4ThfFlgrc17SCZ4sQ3XalA9QdKrhEmpOkqNhRh9HlNc4TWhCF
         7KqILrqcH3H2g45Zmr+I5KRk4caHNY8bur50pB32Vq6Z4srtFN8EVaNxJ4EUHf0ikPV0
         WduqQU/t0E2nbkf96SVAB8htAfBaiO+0PsyjcozE+tJAbeYh2Wm3mC86SBROrZLlghUA
         0u4A==
X-Gm-Message-State: AOAM532nenhZ5V6MU4EdR05dyH8Q3yBBauOipz+G8sqzEYzwr7W7CGai
        yGbSzVJlDD9GtPOHYiM4n8zq7IXj6wwAdIc+8Mo=
X-Google-Smtp-Source: ABdhPJyS1xcS9vjK41rqH5RTB2vrCFG8u3jGfzOPkGf9wG+h1dX5CVmC4B5o7VE+knVptnHaEOZc/o1SmmpCxR4qNQw=
X-Received: by 2002:a63:91c4:: with SMTP id l187mr16426480pge.513.1643145009967;
 Tue, 25 Jan 2022 13:10:09 -0800 (PST)
MIME-Version: 1.0
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-11-yury.norov@gmail.com> <Ye6bUC1GyLLUV37p@smile.fi.intel.com>
In-Reply-To: <Ye6bUC1GyLLUV37p@smile.fi.intel.com>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Tue, 25 Jan 2022 13:09:58 -0800
Message-ID: <CAAH8bW_u6oNOkMsA_jRyWFHkzjMi0CB7gXmvLYAdjNMSqrrY7w@mail.gmail.com>
Subject: Re: [PATCH 10/54] net: ethernet: replace bitmap_weight with
 bitmap_empty for qlogic
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 4:29 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Sun, Jan 23, 2022 at 10:38:41AM -0800, Yury Norov wrote:
> > qlogic/qed code calls bitmap_weight() to check if any bit of a given
> > bitmap is set. It's better to use bitmap_empty() in that case because
> > bitmap_empty() stops traversing the bitmap as soon as it finds first
> > set bit, while bitmap_weight() counts all bits unconditionally.
>
> > -             if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
> > +             if (!bitmap_empty((unsigned long *)&pmap[item], 64 * 8))
>
> > -         (bitmap_weight((unsigned long *)&pmap[item],
> > +         (!bitmap_empty((unsigned long *)&pmap[item],
>
> Side note, these castings reminds me previous discussion and I'm wondering
> if you have this kind of potentially problematic places in your TODO as
> subject to fix.

In the discussion you mentioned above, the u32* was cast to u64*,
which is wrong. The code
here is safe because in the worst case, it casts u64* to u32*. This
would be OK wrt
 -Werror=array-bounds.

The function itself looks like doing this unsigned long <-> u64
conversions just for printing
purpose. I'm not a qlogic expert, so let's wait what people say?

The printing part may be refactored although to use %pb" format,
similarly to the snippet below
(not tested).

Thanks,
Yury

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 23b668de4640..72505517ced1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -336,17 +336,8 @@ void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,

        /* print aligned non-zero lines, if any */
        for (item = 0, line = 0; line < last_line; line++, item += 8)
-               if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
-                       DP_NOTICE(p_hwfn,
-                                 "line 0x%04x: 0x%016llx 0x%016llx
0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
-                                 line,
-                                 pmap[item],
-                                 pmap[item + 1],
-                                 pmap[item + 2],
-                                 pmap[item + 3],
-                                 pmap[item + 4],
-                                 pmap[item + 5],
-                                 pmap[item + 6], pmap[item + 7]);
+               if (bitmap_weight(bmap->bitmap, 64 * 8))
+                       DP_NOTICE(p_hwfn, "line 0x%04x: %512pb\n",
line, bmap->bitmap);

        /* print last unaligned non-zero line, if any */
        if ((bmap->max_count % (64 * 8)) &&

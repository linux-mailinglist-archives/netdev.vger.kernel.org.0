Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C32764CCEA
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiLNPQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238577AbiLNPQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:16:06 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDDF13CE0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:16:02 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3b5d9050e48so788507b3.2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i8/7ompYoprPv6p5gopqt1zlXtmepYGFLCWXe2gsqzg=;
        b=BUfL3YrZ28K+1n6E2SQ9fOqgRKi2RgeotU3ckXNn8xFWPTs42cuoGfphfjNQOV0pgx
         7/jp35I3w0HRIOFVcsghYPgMBrhr8AMNN8/bTKnJa17Hz49AiqnR3KxJME/VVIigK+sS
         o/Lm4IOiEo8w6nxX4t2A4IzKZLODEjcrKKDsdmGKLI1atzrsu3mpNZREk5A83gxmOZAt
         L+k/IzYKvXs7B7hnKP1erYHIobJ4iQu87BD3pnHQtG8fBQOI4ExEQ0QtE/CElufFbNCA
         yV0c98uSdPhEqukbLuFuzz8L6ZLLU8J5/FlBKjiGFYDWzKiB3XFMXdMwK39OTfRDW0AO
         GSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i8/7ompYoprPv6p5gopqt1zlXtmepYGFLCWXe2gsqzg=;
        b=Fogn7M2aBOsJ70kVhxLH+UbKmEqJNs1c6o4PZaKZNrjYVNfob1kfc5xsfLrVYTkhXO
         YtscQq7PeeVwqz2W66mD1s1S0kmu76RU67r+4z5KQO52AjucrtEV83FaIgCnzDV6YUh3
         Jnln/pVi+7ZiIXhxo+amLTNDENDzuXn01OeXXqpgkQZBF8ZDwQElasvRbDHrPt1huv7S
         fJkd4MJMzJkagkGy9mS2DMqGbeeAf0Qm9hOOouswatcfxlqSEZZmSZbwbb4h6DRKa1is
         kfAPWu7zYRLMDPDHVA5Mng8myLBLYEAfaarCP0MylQcmnS3R5U5YhVP+hYWeXcSiOdvB
         6N7w==
X-Gm-Message-State: ANoB5pmMX4SMuGGQWMQIq39DkD8y9ynAPfDkPu7zF3VsiSU2sVJAfKxC
        ZuXDWRp3CYPt25iXxtSK3JAIyoBQH537kTbZZuLcLA==
X-Google-Smtp-Source: AA0mqf6N7NofCRVaBdlZmzX/2IFdQaSJdENS2yaazN5Bc4VEowcispQ6llOh6euNJwrBHENhxHLAYZsrXmLpw9L8cy4=
X-Received: by 2002:a81:1e44:0:b0:370:7a9a:564 with SMTP id
 e65-20020a811e44000000b003707a9a0564mr27785992ywe.278.1671030961275; Wed, 14
 Dec 2022 07:16:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <Y5c8KLzJFz/XZMiM@zx2c4.com> <20221214123358.GA1062210@linux.intel.com>
In-Reply-To: <20221214123358.GA1062210@linux.intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 14 Dec 2022 16:15:49 +0100
Message-ID: <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
Subject: Re: [PATCH 1/5] Renaming weak prng invocations - prandom_bytes_state, prandom_u32_state
To:     Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        david.keisarschm@mail.huji.ac.il,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        dri-devel@lists.freedesktop.org, Song Liu <song@kernel.org>,
        linux-mtd@lists.infradead.org, Stanislav Fomichev <sdf@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Christoph Lameter <cl@linux.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, ilay.bahat1@gmail.com,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Pirko <jiri@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>,
        intel-gfx@lists.freedesktop.org, Petr Mladek <pmladek@suse.com>,
        Jiri Olsa <jolsa@kernel.org>, Hao Luo <haoluo@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        KP Singh <kpsingh@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Hannes Reinecke <hare@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        aksecurity@gmail.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 1:34 PM Stanislaw Gruszka
<stanislaw.gruszka@linux.intel.com> wrote:
>
> On Mon, Dec 12, 2022 at 03:35:20PM +0100, Jason A. Donenfeld wrote:
> > Please CC me on future revisions.
> >
> > As of 6.2, the prandom namespace is *only* for predictable randomness.
> > There's no need to rename anything. So nack on this patch 1/5.
>
> It is not obvious (for casual developers like me) that p in prandom
> stands for predictable. Some renaming would be useful IMHO.

Renaming makes backports more complicated, because stable teams will
have to 'undo' name changes.
Stable teams are already overwhelmed by the amount of backports, and
silly merge conflicts.

Take another example :

u64 timecounter_read(struct timecounter *tc)

You would think this function would read the timecounter, right ?

Well, it _updates_ many fields from @tc, so a 'better name' would also
be useful.

linux kernel is not for casual readers.

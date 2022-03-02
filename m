Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329134CA403
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbiCBLnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiCBLmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C25AC053;
        Wed,  2 Mar 2022 03:42:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DA861868;
        Wed,  2 Mar 2022 11:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26867C340F1;
        Wed,  2 Mar 2022 11:42:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="feD1be81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646221319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jadzoX9C/bN73zzy6zLRddYPuv7DzXHFERTBnqcFQsA=;
        b=feD1be81FDZ2KNZDT+O7BxX3N97L8bJKyyhtSYNWjc90kC2/8JaaMq0E03q6E2i8qzR4/n
        93xbahNhoXQTP0OGQgSK7RwbqaCe9yZQbcouQo6TC+IlvJFjK9KPlG8BAnKtoIm0m35W6x
        TGpSKfJjNM8MouWBwy+NhzXbThQ98vw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 394da782 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 11:41:59 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id t63so363579ybi.8;
        Wed, 02 Mar 2022 03:41:58 -0800 (PST)
X-Gm-Message-State: AOAM530oHUFl/pRPqvd2NeDF181BNq01QWu6WNnhGTTdFDaJxHOGhhFy
        le+EPGpcY7VRVlBtQt0jjaHX2y0zat7FfBOePsc=
X-Google-Smtp-Source: ABdhPJxmYa1ANBHWQvYIgvsmbhR6xdt5dMngHCS9hJH0CEVY032UXmyfEpxmE6jKmWGAuBe60OFdGZ3VincSNtqExx4=
X-Received: by 2002:a25:d116:0:b0:61d:e8c9:531e with SMTP id
 i22-20020a25d116000000b0061de8c9531emr28519929ybg.637.1646221317583; Wed, 02
 Mar 2022 03:41:57 -0800 (PST)
MIME-Version: 1.0
References: <20220301231038.530897-1-Jason@zx2c4.com> <20220301231038.530897-3-Jason@zx2c4.com>
 <Yh8wjrf7HVf56Anw@kroah.com>
In-Reply-To: <Yh8wjrf7HVf56Anw@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 12:41:46 +0100
X-Gmail-Original-Message-ID: <CAHmME9r4P+5pdrRxaUZs96nshp7rN4GP2xoV9h=umqMOAgs8iA@mail.gmail.com>
Message-ID: <CAHmME9r4P+5pdrRxaUZs96nshp7rN4GP2xoV9h=umqMOAgs8iA@mail.gmail.com>
Subject: Re: [PATCH 2/3] random: provide notifier for VM fork
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>, Jann Horn <jannh@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Wed, Mar 2, 2022 at 9:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> It seems crazy that the "we just were spawned as a new vm" notifier is
> based in the random driver, but sure, put it here for now!  :)

I was thinking you might say this. I see it both ways, but I think I'm
more inclined to doing it this way, at least for now. Here's how it
breaks down:

VM forking is usually an okay thing to do because computers are
deterministic. Usually. Where is there non-determinism in a place that
it matters? The RNG is supposed to be "the" place of non-determinism.
If anything is going to happen in response to a VM fork, it's going to
necessarily be _after_ the RNG becomes sufficiently non-deterministic
again, and so it's the RNG who announces, "hey I'm safe to use again,
and please read from me again if you're doing non-misuse resistant
crypto." It's the proper place to announce that.

On the other hand, I think you could argue that really this should
come from vmgenid itself, with the caveat that the notifier is called
after add_vmfork_randomness is called. For now that would exist in
vmgenid.o itself, and then if we ever have multiple drivers notifying,
some shared infrastructure could be made. Except vmgenid.o might be
vmgenid.ko, and then the whole problem gets kind of annoying and maybe
we actually want that shared infrastructure _now_ instead. And now we
find ourselves complicating everything with additional Kbuild symbols
and header files and stubs. It just seems like the road of more pain.

Anyway, even if we go with the first solution -- keeping it in
random.o -- now, I wouldn't be opposed to revisiting that decision
later if the landscape becomes more complex. Luckily this is just the
kernel side of things and not userspace, so we can easily change
things down the road.

Jason

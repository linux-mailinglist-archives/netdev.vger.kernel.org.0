Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9948CB68
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356341AbiALS6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbiALS57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:57:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A63C06173F;
        Wed, 12 Jan 2022 10:57:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D9BCB82061;
        Wed, 12 Jan 2022 18:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B60C36AE5;
        Wed, 12 Jan 2022 18:57:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LpIgVSvW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642013873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0nJw3qp+6ssaRAsQGf0Z8LxKHkMZcQjHMYTxWOuULA=;
        b=LpIgVSvWy74mNyI6bUeyXhJwMku7ldAgzyUrx7wW4aEY9++YH0eOQBx3QnZoNRqfjblCKh
        Bb2lzHp+gtos3MGpETNpDP8trNJfFOYbBCj3lPBt6jZ0FhGj+yRdlBw4RJNAZwhWZ+Uide
        X3BGgUDsZx+fj/DKQvh7TCp4aPnnRbw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c3e8b21a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 18:57:52 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id p5so8199216ybd.13;
        Wed, 12 Jan 2022 10:57:52 -0800 (PST)
X-Gm-Message-State: AOAM530WRfZ7kkIsv2nINfejkSrSx649bLMtSHQd35lNAyGSR/Gr7nWz
        hnTUwy/xDYgdvFh4ftA2t+aG7hL9IFkdGcyYMT8=
X-Google-Smtp-Source: ABdhPJw8qYUs7e9KQe2N4L+rImERUn9kUTTZvgDksyPryzq/g72RYmNwS7QVnzejY1mgkrru1T5lLNiPN9ehAqKwuLk=
X-Received: by 2002:a25:8c4:: with SMTP id 187mr1325248ybi.245.1642013871490;
 Wed, 12 Jan 2022 10:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112185004.GZ14046@twin.jikos.cz>
In-Reply-To: <20220112185004.GZ14046@twin.jikos.cz>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 12 Jan 2022 19:57:40 +0100
X-Gmail-Original-Message-ID: <CAHmME9qcW_cPq+ZvpBnYwJXURNs_3mqbzOKsqeoDNUDH4qDWEg@mail.gmail.com>
Message-ID: <CAHmME9qcW_cPq+ZvpBnYwJXURNs_3mqbzOKsqeoDNUDH4qDWEg@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/3] remove remaining users of SHA-1
To:     David Sterba <dsterba@suse.cz>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 7:50 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Jan 12, 2022 at 02:12:01PM +0100, Jason A. Donenfeld wrote:
> > Hi,
> >
> > There are currently two remaining users of SHA-1 left in the kernel: bpf
> > tag generation, and ipv6 address calculation. In an effort to reduce
> > code size and rid ourselves of insecure primitives, this RFC patchset
> > moves to using the more secure BLAKE2s function.
>
> What's the rationale to use 2s and not 2b? Everywhere I can find the 2s
> version is said to be for 8bit up to 32bit machines and it's worse than
> 2b in benchmarks (reading https://bench.cr.yp.to/results-hash.html).
>
> I'd understand you go with 2s because you also chose it for wireguard
> but I'd like know why 2s again even if it's not made for 64bit
> architectures that are preferred nowadays.

Fast for small inputs on all architectures, small code size. And it
performs well on Intel - there are avx512 and ssse3 implementations.
Even blake3 went with the 32-bit choice and abandoned 2b's thing.
Plus, this makes it even more similar to the well trusted chacha
permutation. As far as a general purpose high security library (keyed)
hash function for internal kernel usages, it seems pretty ideal.

Your choice for btrfs though is fine; don't let this patchset change
your thinking on that.

Anyway, I hope that's interesting to you, but I'm not so much
interested in bikeshedding about blake variants as I am in learning
from the net people on the feasibility of getting rid of sha1 in those
two places. So I'd appreciate it if we can keep the discussion focused
on that and not let this veer off into a tangential thread on blakes.

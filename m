Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3018960843F
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiJVEXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJVEXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:23:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B77A2A522F;
        Fri, 21 Oct 2022 21:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2A3601C6;
        Sat, 22 Oct 2022 04:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12835C433D7;
        Sat, 22 Oct 2022 04:23:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lBfM7/p5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666412617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9PpCweDWCdYmYRSGKDbVg7+bIAdj37ycm4g1XbG6yY=;
        b=lBfM7/p5gSu1DVM047xbGxryCNIAciT+I0Q1kb50i3cof6dUxtUjRk0MKc6LBWnUojKf0X
        jbelDSUzqG0P6n89hqlrpIScNnmnA8Sxg6K0tnlWQ+ezzUhF8JMb3pSyet7RU8t6uyzlok
        7b/CTDV1erpNv77ET1Dj8vxxRoEEcC0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1d387ad5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 22 Oct 2022 04:23:36 +0000 (UTC)
Date:   Sat, 22 Oct 2022 00:23:00 -0400
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v1 0/5] convert tree to
 get_random_u32_{below,above,between}()
Message-ID: <Y1NwJJOIB4gI5G11@zx2c4.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
 <20221021205522.6b56fd24@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221021205522.6b56fd24@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 08:55:22PM -0700, Jakub Kicinski wrote:
> On Fri, 21 Oct 2022 21:43:58 -0400 Jason A. Donenfeld wrote:
> > Since get_random_u32_below() sits in my random.git tree, these patches
> > too will flow through that same tree.
> 
> How big is it?  Can you provide a stable branch to pull in the new
> helpers and then everyone will be able to apply the patches to their
> subsystem?

It's a patch. But what you suggest sounds crazy to me. Supply some
branch and have every tree merge that branch separately, in duplicate,
and then get all of the conversion patches through every tree, and then
somehow coordinate the removal of the deprecated function after all of
that, and then baby sit the grand orchestration of all this over the
course of two and half months, watch it fail because of some
unmaintained corner that's affected, and then try to herd it through for
another two and a half months after that? Holy crap. That's torture.

Were this an actually technically interesting patchset that required
some really detailed expert review, maybe that'd have some iota of
merit. But this is a really boring refactoring, mostly automated with
Coccinelle. If having to baby sit one hundred separate patches over the
course of months, handling confusion of walking maintainers through the
exercise of merging some weird duplicate branch into their trees before,
and so forth, is required to get this kind of grunt work done, I'm just
going to wind up losing all motivation for this kind of thing, and
naturally, as a matter of human nature, stop doing it. The result will
be that we have garbage pile up over time that operates on the principle
of "least hassle to deal with for the time being" rather than "love of
the code and a desire for long term maintainability and quality". The
former is sometimes how things go. The latter is what I'm striving for.

So what you suggest sounds really dreadful to me. Sorry.

Instead, this series follows the same template as the last one, and the
last one was much more nuanced and invasive and went fine. In the very
worst case, it'll require me to be on the ball with what's happening
with -next, which is something I've done before and can do again.

Jason

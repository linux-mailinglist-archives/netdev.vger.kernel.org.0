Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5B6084BD
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJVFrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJVFrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897E62B2E29;
        Fri, 21 Oct 2022 22:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E66A260AAF;
        Sat, 22 Oct 2022 05:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C53C433B5;
        Sat, 22 Oct 2022 05:47:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hHr7JDma"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666417627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MOo+wGjr9tTo6HwzqSPOYV3cStPuCF8jDrSog97Sk6o=;
        b=hHr7JDmaUUZ2Fst7d0Piw902UrhZuwq0ZpiGi/Qr+8uvBxc/DkBO/F8XaQPQpx+IUhGl/k
        7dvZeA3olkG7dU3XrUzL1DeE/oRkYpB5ZHOk0TgNe9dUfQMPP6GyBrABMG9dGsoOSE6uEv
        2T0yEPVK8cum5EmZMyJEOhxpRJFcUOY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 370a5557 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 22 Oct 2022 05:47:07 +0000 (UTC)
Date:   Sat, 22 Oct 2022 07:47:06 +0200
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
Message-ID: <Y1OD2tdVwQsydSNV@zx2c4.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
 <20221021205522.6b56fd24@kernel.org>
 <Y1NwJJOIB4gI5G11@zx2c4.com>
 <20221021223242.05df0a5b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221021223242.05df0a5b@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 10:32:42PM -0700, Jakub Kicinski wrote:
> But whatever. I mean - hopefully there aren't any conflicts in the ~50
> networking files you touch. I just wish that people didn't pipe up with
> the tree wide changes right after the merge window. Feels like the
> worst possible timing.

Oh, if the timing is what makes this especially worrisome, I have
no qualms about rebasing much later, and reposting this series then.
I'll do that.

Jason

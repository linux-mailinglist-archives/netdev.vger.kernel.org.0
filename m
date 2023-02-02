Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D868779D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjBBIfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjBBIfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:35:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91D687586
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F089B824B7
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E60BC433EF;
        Thu,  2 Feb 2023 08:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675326874;
        bh=JoYFOL98pBCh6QNcjdEuUJESrOxAfwwUI/4jV/fiAco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRZF5pGcFvR/FJiq5IT7wyONMhSWOad1ybCuDuAA4L5cukP+qD/e1rrrKTHxk7k3c
         7hznKAbSfwZVdR6nmHxrvWnwcFp7hGmZBoD1VT5yvYP2f0nXO9p3kZqjm1gEsEwFY+
         lSTMwcImn2jaqZ/gFs++UMy0ZczXKEHkO3PEPdyfUFglAbluUzxOyFNr/JsIm02XaQ
         KdG70nKSpxbsFkXRNp3wIMg0pkL4agndZvQRPYBpL9BeMyOii+D4FaA8XMTRYeYXY5
         2KqoE9+Ry5D/SDGryouGf2qcHgt4w8HdHVG7xtsJ82PMhuohENKX3YZMwaHEPxE4Xz
         QCT5uWy2AuTCg==
Date:   Thu, 2 Feb 2023 10:34:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v2 0/4] sfc: support unicast PTP
Message-ID: <Y9t1lRYtHQ+ZLuBq@unreal>
References: <20230131160506.47552-1-ihuguet@redhat.com>
 <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201110541.1cf6ba7f@kernel.org>
 <CACT4oueX=MyKoUmzUs5Cdc0k5SuhavY=Toe_EGPgPOA8rVCmRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oueX=MyKoUmzUs5Cdc0k5SuhavY=Toe_EGPgPOA8rVCmRw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 08:08:10AM +0100, Íñigo Huguet wrote:
> On Wed, Feb 1, 2023 at 8:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed,  1 Feb 2023 09:08:45 +0100 Íñigo Huguet wrote:
> > > v2: fixed missing IS_ERR
> > >     added doc of missing fields in efx_ptp_rxfilter
> >
> > 1. don't repost within 24h, *especially* if you're reposting
> > because of compilation problems
> >
> > https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
> 
> Sorry, I wasn't aware of this.
> 
> > 2. please don't repost in a thread, it makes it harder for me
> > to maintain a review queue
> 
> What do you mean? I sent it with `git send-email --in-reply-to`, I
> thought this was the canonical way to send a v2 and superseed the
> previous version.

It was never canonical way. I'm second to Jakub, it messes review and
acceptance flow so badly that I prefer to do not take such patches due
to possible confusion.

> 
> > 3. drop the pointless inline in the source file in patch 4
> >
> > +static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
> > +                                            struct efx_ptp_rxfilter *rxfilter)
> 
> This is the second time I get pushback because of this. Could you
> please explain the rationale of not allowing it?
> 
> I understand that the compiler probably will do the right thing with
> or without the `inline`, and more being in the same translation unit.
> Actually, I checked the style guide [1] and I thought it was fine like
> this: it says that `inline` should not be abused, but it's fine in
> cases like this one. Quotes from the guide:
>   "Generally, inline functions are preferable to macros resembling functions"
>   "A reasonable rule of thumb is to not put inline at functions that
> have more than 3 lines of code in them"
> 
> I have the feeling that if I had made it as a macro it had been
> accepted, but inline not, despite the "prefer inline over macro".
> 
> I don't mind changing it, but I'd like to understand it so I can
> remember the next time. And if it's such a hard rule that it's
> considered a "fail" in the patchwork checks, maybe it should be
> documented somewhere.

GCC will automatically inline your not-inline function anyway.

Documentation/process/coding-style.rst
   958 15) The inline disease
...
   978 Often people argue that adding inline to functions that are static and used
   979 only once is always a win since there is no space tradeoff. While this is
   980 technically correct, gcc is capable of inlining these automatically without
   981 help, and the maintenance issue of removing the inline when a second user
   982 appears outweighs the potential value of the hint that tells gcc to do
   983 something it would have done anyway.


> 
> Thanks!
> 
> [1] https://www.kernel.org/doc/html/latest/process/coding-style.html
> 
> 
> -- 
> Íñigo Huguet
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264B36C7218
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCWVDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCWVC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:02:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35ED32CFA
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v41Uzc7Rv9i7N0Yv5b15xyHNDj7bAPZv3i2XxSJR6x8=; b=GvYu4i6/0P+gHXG681mxJIsx+L
        IEgiIwKX/U+JbluHp2VX5fw69HOEdwDPTcgyNPfaoWrFjOvP2m/JIUkHqKBJT5gvaVXjJ+r7BKiIb
        m7DcHTTi2Uvd3Aon2DeyzKfNSEB7YvX2XaXEGqn4ruEr1Yw1u42hZW8OR2UPd522UmoE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfS4r-008Era-Mu; Thu, 23 Mar 2023 22:02:29 +0100
Date:   Thu, 23 Mar 2023 22:02:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, alexander.duyck@gmail.com,
        michael.chan@broadcom.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <fccbd0cc-f760-4f1a-8830-64a245b228dc@lunn.ch>
References: <20230322233028.269410-1-kuba@kernel.org>
 <06d6a33e-60d4-45ea-b928-d3691912b85e@lunn.ch>
 <20230322180406.2a46c3bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322180406.2a46c3bd@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 06:04:06PM -0700, Jakub Kicinski wrote:
> CC: maintainers, in case there isn't a repost
> https://lore.kernel.org/all/20230322233028.269410-1-kuba@kernel.org/
> 
> On Thu, 23 Mar 2023 01:35:34 +0100 Andrew Lunn wrote:
> > On Wed, Mar 22, 2023 at 04:30:26PM -0700, Jakub Kicinski wrote:
> > > A lot of drivers follow the same scheme to stop / start queues
> > > without introducing locks between xmit and NAPI tx completions.
> > > I'm guessing they all copy'n'paste each other's code.
> > >
> > > Smaller drivers shy away from the scheme and introduce a lock
> > > which may cause deadlocks in netpoll.  
> > 
> > I notice there is no patch 0/X. Seems like the above would be good
> > material for it, along with a comment that a few drivers are converted
> > to make use of the new macros.
> 
> Then do I repeat the same text in the commit? Or cut the commit down?
> Doesn't that just take away information from the commit which will
> show up in git blame?
> 
> Having a cover letter is a good default, and required if the series 
> is a larger change decomposed into steps. But here there is a major
> change and a bunch of loose conversions. More sample users than
> meaningful part.
> 
> LMK what your preference for splitting this info is, I'm unsure.

We do seem to have a policy of asking for a 0/X. And it is used for
the merge commit. That is my real point. And i don't see why the text
can be repeated in the merge commit and the individual commits.

    Andrew

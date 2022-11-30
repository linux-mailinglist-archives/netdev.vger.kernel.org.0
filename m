Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D797B63E2DD
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiK3VkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3VkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:40:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F264445A04;
        Wed, 30 Nov 2022 13:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F66A61E03;
        Wed, 30 Nov 2022 21:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E308EC433C1;
        Wed, 30 Nov 2022 21:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669844414;
        bh=CxPqTNad3AlmtYDo7JpT7v5xUXJHj6RfoBJEHMwhH4o=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=qftdfNWtJsGXyRqj6DqkV9wyf2IZzm8WHgJixWCFmiHxnUBcG7ZaPFsG+nLb6E89v
         EG+hNEFxqAegH2emYTG5PoiV7FIvNuUhwpPz9bZXlCTrH49JpHySIoC8ixqDD3zvJ0
         iEuf4W5hziEvb++NOCGPv04/ge3zJ9JCmzfexCEG3+Naufvy/Buw4dd4AOUqKWwlrc
         +Tl1YTtU3mOqM3nq2bddTNOygvi+KDy9C3FYJcb7VVayeGejP7BvYl+XqwFh6Gmtzr
         dF4xxjcPCVU72pjYDRXR0/9gTqFXf7MAK3y9KA0iH5dmjbcEgFjix2ReMzUSyweWaF
         gijxBX7IcRn7g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8228F5C051C; Wed, 30 Nov 2022 13:40:13 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:40:13 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH rcu 15/16] net: Use call_rcu_hurry() for dst_release()
Message-ID: <20221130214013.GT4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-15-paulmck@kernel.org>
 <CAEXW_YQci19yD5wr2jyYi4wdNZ_CrZuGJ==jF9MObOzWg7f=_Q@mail.gmail.com>
 <CANn89iKifFXDpF8sZXd+rXPhF+3ajVLTuEj6n2Z4H9f27_K0kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKifFXDpF8sZXd+rXPhF+3ajVLTuEj6n2Z4H9f27_K0kA@mail.gmail.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 07:39:02PM +0100, Eric Dumazet wrote:
> Sure, thanks.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!!!

> I think we can work later to change how dst are freed/released to
> avoid using call_rcu_hurry()

Thank you for being willing to look into that!

							Thanx, Paul

> On Wed, Nov 30, 2022 at 7:17 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > Hi Eric,
> >
> > Could you give your ACK for this patch for this one as well? This is
> > the other networking one.
> >
> > The networking testing passed on ChromeOS and it has been in -next for
> > some time so has gotten testing there. The CONFIG option is default
> > disabled.
> >
> > Thanks a lot,
> >
> > - Joel
> >
> > On Wed, Nov 30, 2022 at 6:14 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > >
> > > In a networking test on ChromeOS, kernels built with the new
> > > CONFIG_RCU_LAZY=y Kconfig option fail a networking test in the teardown
> > > phase.
> > >
> > > This failure may be reproduced as follows: ip netns del <name>
> > >
> > > The CONFIG_RCU_LAZY=y Kconfig option was introduced by earlier commits
> > > in this series for the benefit of certain battery-powered systems.
> > > This Kconfig option causes call_rcu() to delay its callbacks in order
> > > to batch them.  This means that a given RCU grace period covers more
> > > callbacks, thus reducing the number of grace periods, in turn reducing
> > > the amount of energy consumed, which increases battery lifetime which
> > > can be a very good thing.  This is not a subtle effect: In some important
> > > use cases, the battery lifetime is increased by more than 10%.
> > >
> > > This CONFIG_RCU_LAZY=y option is available only for CPUs that offload
> > > callbacks, for example, CPUs mentioned in the rcu_nocbs kernel boot
> > > parameter passed to kernels built with CONFIG_RCU_NOCB_CPU=y.
> > >
> > > Delaying callbacks is normally not a problem because most callbacks do
> > > nothing but free memory.  If the system is short on memory, a shrinker
> > > will kick all currently queued lazy callbacks out of their laziness,
> > > thus freeing their memory in short order.  Similarly, the rcu_barrier()
> > > function, which blocks until all currently queued callbacks are invoked,
> > > will also kick lazy callbacks, thus enabling rcu_barrier() to complete
> > > in a timely manner.
> > >
> > > However, there are some cases where laziness is not a good option.
> > > For example, synchronize_rcu() invokes call_rcu(), and blocks until
> > > the newly queued callback is invoked.  It would not be a good for
> > > synchronize_rcu() to block for ten seconds, even on an idle system.
> > > Therefore, synchronize_rcu() invokes call_rcu_hurry() instead of
> > > call_rcu().  The arrival of a non-lazy call_rcu_hurry() callback on a
> > > given CPU kicks any lazy callbacks that might be already queued on that
> > > CPU.  After all, if there is going to be a grace period, all callbacks
> > > might as well get full benefit from it.
> > >
> > > Yes, this could be done the other way around by creating a
> > > call_rcu_lazy(), but earlier experience with this approach and
> > > feedback at the 2022 Linux Plumbers Conference shifted the approach
> > > to call_rcu() being lazy with call_rcu_hurry() for the few places
> > > where laziness is inappropriate.
> > >
> > > Returning to the test failure, use of ftrace showed that this failure
> > > cause caused by the aadded delays due to this new lazy behavior of
> > > call_rcu() in kernels built with CONFIG_RCU_LAZY=y.
> > >
> > > Therefore, make dst_release() use call_rcu_hurry() in order to revert
> > > to the old test-failure-free behavior.
> > >
> > > [ paulmck: Apply s/call_rcu_flush/call_rcu_hurry/ feedback from Tejun Heo. ]
> > >
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > Cc: David Ahern <dsahern@kernel.org>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: <netdev@vger.kernel.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > > ---
> > >  net/core/dst.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > index bc9c9be4e0801..a4e738d321ba2 100644
> > > --- a/net/core/dst.c
> > > +++ b/net/core/dst.c
> > > @@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
> > >                         net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
> > >                                              __func__, dst, newrefcnt);
> > >                 if (!newrefcnt)
> > > -                       call_rcu(&dst->rcu_head, dst_destroy_rcu);
> > > +                       call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
> > >         }
> > >  }
> > >  EXPORT_SYMBOL(dst_release);
> > > --
> > > 2.31.1.189.g2e36527f23
> > >

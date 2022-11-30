Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262FF63E2E4
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiK3Vp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiK3Vpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:45:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876ED31ED9;
        Wed, 30 Nov 2022 13:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 239BA61DDC;
        Wed, 30 Nov 2022 21:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E38BC433D6;
        Wed, 30 Nov 2022 21:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669844752;
        bh=tM+9kOjmhNW30fGZx4xWruX8dyBz5IQiM9+ibz5U9oY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=JHBoVJ3gb1rBuVJFUHBmDyWtNcnjQI8OwqLeUv4BEoSb9vxZ3JCmdLWtwS9DTSYzf
         e35Kxac6QACKBFa7Qk4Y1nFrF8j2Cy8YS5MjHwvisXGgBoFHJ0CMxYYMjw4IneO7Et
         iCtbakesaqPA1zydajA0mkKYQTpsOfXSnw1fpFBWhEHKk4RAgJD4UyZmW68AZGh0W0
         MHOy0QZWMQny/TlffXCmGNvah/Cchkqqe4Wi41AxagBI6cbip2zwGQSpiZBe8TyWmA
         uKn7rqr3It230jtcmUHzNiJe9vsBIBI9TqOhAdavY1hvcgbj+ZmIu0h4ClqMxqTd1/
         2KgWQQbyBzqtg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 347B05C051C; Wed, 30 Nov 2022 13:45:52 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:45:52 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of
 call_rcu()
Message-ID: <20221130214552.GW4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-14-paulmck@kernel.org>
 <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
 <CANn89iKg-Ka96yGFHCUWXtug494eO5i2KU_c8GTPNXDi6mWpYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKg-Ka96yGFHCUWXtug494eO5i2KU_c8GTPNXDi6mWpYg@mail.gmail.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 07:37:07PM +0100, Eric Dumazet wrote:
> Ah, I see a slightly better name has been chosen ;)

call_rcu_vite()?  call_rcu_tres_grande_vitesse()?  call_rcu_tgv()?

Sorry, couldn't resist!  ;-)

							Thanx, Paul

> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> On Wed, Nov 30, 2022 at 7:16 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > Hi Eric,
> >
> > Could you give your ACK for this patch?
> >
> > The networking testing passed on ChromeOS and it has been in -next for
> > some time so has gotten testing there. The CONFIG option is default
> > disabled.
> >
> > Thanks a lot,
> >
> > - Joel
> >
> > On Wed, Nov 30, 2022 at 6:13 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > >
> > > Earlier commits in this series allow battery-powered systems to build
> > > their kernels with the default-disabled CONFIG_RCU_LAZY=y Kconfig option.
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
> > > And another call_rcu() instance that cannot be lazy is the one
> > > in rxrpc_kill_connection(), which sometimes does a wakeup
> > > that should not be unduly delayed.
> > >
> > > Therefore, make rxrpc_kill_connection() use call_rcu_hurry() in order
> > > to revert to the old behavior.
> > >
> > > [ paulmck: Apply s/call_rcu_flush/call_rcu_hurry/ feedback from Tejun Heo. ]
> > >
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > Cc: David Howells <dhowells@redhat.com>
> > > Cc: Marc Dionne <marc.dionne@auristor.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: <linux-afs@lists.infradead.org>
> > > Cc: <netdev@vger.kernel.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > > ---
> > >  net/rxrpc/conn_object.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
> > > index 22089e37e97f0..9c5fae9ca106c 100644
> > > --- a/net/rxrpc/conn_object.c
> > > +++ b/net/rxrpc/conn_object.c
> > > @@ -253,7 +253,7 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
> > >          * must carry a ref on the connection to prevent us getting here whilst
> > >          * it is queued or running.
> > >          */
> > > -       call_rcu(&conn->rcu, rxrpc_destroy_connection);
> > > +       call_rcu_hurry(&conn->rcu, rxrpc_destroy_connection);
> > >  }
> > >
> > >  /*
> > > --
> > > 2.31.1.189.g2e36527f23
> > >

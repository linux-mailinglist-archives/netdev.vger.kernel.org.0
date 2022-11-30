Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C663DEA5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiK3SjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiK3SjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:39:15 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555A321A3
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:39:14 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 7so22706025ybp.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OmNYHQ87jUtb5aK4EnCchCezDsC03KpUUikHHBwmz1U=;
        b=hM8fAGmbVUpSg0bshwhdBqoAETj09emtZtyATn2/YdkJv/RppRRohbgPweefZuAJg3
         AggTj8vfGNLhroF4rzrh56LA4EvvnWZlCOfpKgNDBeadr75kfCsf2XXj262T99aH6sFM
         gdTOqZ5155WfFRf57Uus46Kqd9WTJYWtjwSyt9VUQL5l4fsAc8IKR7SM7YBD7Zc+hhOH
         IjQon4p4/tt0sPHle1d/rztok1ryFC9JMU8Ud7kiAZMqYA0p7E1fFY3n097+eRrMx+jI
         O1KxbFpYRtgondwzeZhENJ9nreC1GckW9wVyoLVtrCtum7ihKJ8HXVAHCy82IWrSKfas
         oevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmNYHQ87jUtb5aK4EnCchCezDsC03KpUUikHHBwmz1U=;
        b=waQkUyXVFCGPQKrCtOO0LIO6FWIGEM6EGHbzuho6GTdWh0HjfuMgESb+0K+DqRNXnS
         wYPDDQBE5BWnf6XPAa4p6lPZ/XtQcoKANS5yNbuuICCHboHhG3zMvkUly8Mfg0V/HvQW
         F4BYOLRCjfmGlIjXWv3heM5FDpch7XoaFO4Ko+KtS5/woh1SmTKdmOJDh65qbvjWUgI9
         gWr6R8G9+/Gmf++v25MSxERBIgD0ewu72MApaT8cKtUlvfcCc3o7i0xe0b64cEK2KNH+
         gm4t6oseoI9G0/FrtfOX4bEjlnlAeA68XmR1Nh2424lRebxq6UV/agVEsd31xqxCyfBj
         EjFA==
X-Gm-Message-State: ANoB5pmEidme78uWxPZnBj+O2IMWInpjpPKLBvKIUTA/msueYhPlBOna
        uhe/PxyC7BPBfAoexC1ZDFKIPNiz83jz3j9fYJHNOw==
X-Google-Smtp-Source: AA0mqf4Naxqj7J8vNfDSPzWzHopJH9dVe1p1cydYMctQ0Lsg/szV8QiM6gq07riGXHq8I3Cup0jlPb0dBsBGwUn4Bzg=
X-Received: by 2002:a25:5045:0:b0:6f0:9f69:6cd3 with SMTP id
 e66-20020a255045000000b006f09f696cd3mr33343170ybb.407.1669833553217; Wed, 30
 Nov 2022 10:39:13 -0800 (PST)
MIME-Version: 1.0
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-15-paulmck@kernel.org> <CAEXW_YQci19yD5wr2jyYi4wdNZ_CrZuGJ==jF9MObOzWg7f=_Q@mail.gmail.com>
In-Reply-To: <CAEXW_YQci19yD5wr2jyYi4wdNZ_CrZuGJ==jF9MObOzWg7f=_Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 30 Nov 2022 19:39:02 +0100
Message-ID: <CANn89iKifFXDpF8sZXd+rXPhF+3ajVLTuEj6n2Z4H9f27_K0kA@mail.gmail.com>
Subject: Re: [PATCH rcu 15/16] net: Use call_rcu_hurry() for dst_release()
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
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

Sure, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

I think we can work later to change how dst are freed/released to
avoid using call_rcu_hurry()

On Wed, Nov 30, 2022 at 7:17 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hi Eric,
>
> Could you give your ACK for this patch for this one as well? This is
> the other networking one.
>
> The networking testing passed on ChromeOS and it has been in -next for
> some time so has gotten testing there. The CONFIG option is default
> disabled.
>
> Thanks a lot,
>
> - Joel
>
> On Wed, Nov 30, 2022 at 6:14 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> >
> > In a networking test on ChromeOS, kernels built with the new
> > CONFIG_RCU_LAZY=y Kconfig option fail a networking test in the teardown
> > phase.
> >
> > This failure may be reproduced as follows: ip netns del <name>
> >
> > The CONFIG_RCU_LAZY=y Kconfig option was introduced by earlier commits
> > in this series for the benefit of certain battery-powered systems.
> > This Kconfig option causes call_rcu() to delay its callbacks in order
> > to batch them.  This means that a given RCU grace period covers more
> > callbacks, thus reducing the number of grace periods, in turn reducing
> > the amount of energy consumed, which increases battery lifetime which
> > can be a very good thing.  This is not a subtle effect: In some important
> > use cases, the battery lifetime is increased by more than 10%.
> >
> > This CONFIG_RCU_LAZY=y option is available only for CPUs that offload
> > callbacks, for example, CPUs mentioned in the rcu_nocbs kernel boot
> > parameter passed to kernels built with CONFIG_RCU_NOCB_CPU=y.
> >
> > Delaying callbacks is normally not a problem because most callbacks do
> > nothing but free memory.  If the system is short on memory, a shrinker
> > will kick all currently queued lazy callbacks out of their laziness,
> > thus freeing their memory in short order.  Similarly, the rcu_barrier()
> > function, which blocks until all currently queued callbacks are invoked,
> > will also kick lazy callbacks, thus enabling rcu_barrier() to complete
> > in a timely manner.
> >
> > However, there are some cases where laziness is not a good option.
> > For example, synchronize_rcu() invokes call_rcu(), and blocks until
> > the newly queued callback is invoked.  It would not be a good for
> > synchronize_rcu() to block for ten seconds, even on an idle system.
> > Therefore, synchronize_rcu() invokes call_rcu_hurry() instead of
> > call_rcu().  The arrival of a non-lazy call_rcu_hurry() callback on a
> > given CPU kicks any lazy callbacks that might be already queued on that
> > CPU.  After all, if there is going to be a grace period, all callbacks
> > might as well get full benefit from it.
> >
> > Yes, this could be done the other way around by creating a
> > call_rcu_lazy(), but earlier experience with this approach and
> > feedback at the 2022 Linux Plumbers Conference shifted the approach
> > to call_rcu() being lazy with call_rcu_hurry() for the few places
> > where laziness is inappropriate.
> >
> > Returning to the test failure, use of ftrace showed that this failure
> > cause caused by the aadded delays due to this new lazy behavior of
> > call_rcu() in kernels built with CONFIG_RCU_LAZY=y.
> >
> > Therefore, make dst_release() use call_rcu_hurry() in order to revert
> > to the old test-failure-free behavior.
> >
> > [ paulmck: Apply s/call_rcu_flush/call_rcu_hurry/ feedback from Tejun Heo. ]
> >
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: <netdev@vger.kernel.org>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > ---
> >  net/core/dst.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/dst.c b/net/core/dst.c
> > index bc9c9be4e0801..a4e738d321ba2 100644
> > --- a/net/core/dst.c
> > +++ b/net/core/dst.c
> > @@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
> >                         net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
> >                                              __func__, dst, newrefcnt);
> >                 if (!newrefcnt)
> > -                       call_rcu(&dst->rcu_head, dst_destroy_rcu);
> > +                       call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
> >         }
> >  }
> >  EXPORT_SYMBOL(dst_release);
> > --
> > 2.31.1.189.g2e36527f23
> >

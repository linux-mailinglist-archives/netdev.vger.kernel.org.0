Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B0356075E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiF2Raw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiF2Rav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:30:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EDA33889;
        Wed, 29 Jun 2022 10:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82541B82603;
        Wed, 29 Jun 2022 17:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CC4C34114;
        Wed, 29 Jun 2022 17:30:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VPJ/wvyO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656523843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nzpFb7EApUekHzpz3mO22Jl6tEsl6h0iB+dQdHcUEUw=;
        b=VPJ/wvyOk175tYD7uLJCskYvUM++WdD2Q8q1cq1VMFHK01Jh1ZstEAYoemSUPZw6KujEnR
        TO8VJvBEnfyrWsVFn2G2gU4AHtJxk9XaYZZT06QTQ/GFQCrJRa63QU9Mb8PP9Ndq2m7sKf
        re0GdWfl1nLiTbfyj0jhUSzzeL2qBZc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 146d0254 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 17:30:43 +0000 (UTC)
Date:   Wed, 29 Jun 2022 19:30:35 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YryMO6PX+G9owRGz@zx2c4.com>
References: <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <20220629164543.GA25672@lst.de>
 <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
 <YryFKXsx/Bgv/oBE@kroah.com>
 <YryHk06Ye/12dMEN@zx2c4.com>
 <YryJqI/ppVfMhRhI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YryJqI/ppVfMhRhI@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:19:36PM +0200, Greg Kroah-Hartman wrote:
> I would be totally and completly amazed if there are any Android kernels
> in real devices in the world that are not at the very least, based on
> LTS releases.  But maybe there is, this patch series isn't going to land
> until 5.20, and by then, I think the "define behavior, not hardware" fix
> for random and wg will be properly resolved :)

Properly resolved by whom? It sounds like you're up for intentionally
allowing a userspace regression, and also volunteering other people's
time into fixing that regression? The way I understand the kernel
development process is that the person proposing a change is responsible
for not intentionally causing regressions, and if one is pointed out, a
v+1 of that patch is provided that doesn't cause the regression.

> 
> > > In the meantime, this might actually fix issues in desktop distros that
> > > were enabling this option, thinking it only affected the building of a
> > > driver
> > 
> > That sounds like a false dichotomy. It's not about "fix Android" vs "fix
> > distros". What I'm suggesting is fixing Android AND fixing distros, by
> > looking at the problem holistically. Trading a bad problem on Android
> > (wg connections are broken) for a manageable problem on distros (something
> > something theoretical warm boot attack something) doesn't sound like a
> > nice trade off. Let's instead get this all fixed at the same time.
> 
> Agreed, so what should we use instead in the wg code?  What userspace
> functionality are you trying to trigger off of here in the current
> CONFIG_ANDROID check?

It's systems that go to sleep all the time, nonstop, like Android
handsets do. I'm fine with a compile time constant for this, or some
runtime sysctl, or whatever else. It doesn't really matter to me. The
only concern is that the Android people are okay with it and enable it
(and that the distros don't enable it, I guess). So whatever they want
is fine.  Or maybe such a runtime indicator already exists. I'm not
sure. But I think a v+1 of this patchset needs to work that out in one
direction or another.

To put it simply,

    - I highly suspect that this patch will cause a regression.
    - I don't have a ready-made solution offhand to fix said regression.
    - The submitter of the patch, now aware of regression potential,
      should look into not causing that regression.

That seems pretty clear cut: you're welcome to improve it, but please
don't *intentionally* break my code.

Jason

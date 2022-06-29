Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B035609DE
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiF2S7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiF2S7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9031A3AC;
        Wed, 29 Jun 2022 11:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFBE8B8266F;
        Wed, 29 Jun 2022 18:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F05C34114;
        Wed, 29 Jun 2022 18:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656529143;
        bh=9Tl8nspvMh6ngPRAWw8ovEMp2svi2hp6WG1mQ6AAVYo=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=GCCzvPBPnAEIapoBICOMeCtDdETDQJcQB/frQSnMZIyx5rVjnLokWQX4yXIp7Iyur
         ZzmNFroBQL2U3xKOXiCEeqRho2V9tVWrmR6BSBOY6mGvMYdxQ7z9LuxMj/yOL4FmN5
         DFOw/qW62U6shjrw5OTJzQUGEUtI7Cyjh+JFqnvYQmlWr5IePQjBlnpjgiRQGecJAn
         XGmqtmGfYGyhpxaH7kHb9a1431dLdrZvq3zrI8mXK53DiB8+cBCEPmuOReBdCjEUPv
         LpCYxsUIAX0C3tma7BkcpkbqPsCPWVcxxwox5ZXHsCg/rOHyj+ytdxHAaiGPoHyquX
         LLnhhs8Ix073w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2A3475C0E5F; Wed, 29 Jun 2022 11:59:03 -0700 (PDT)
Date:   Wed, 29 Jun 2022 11:59:03 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christoph Hellwig <hch@lst.de>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
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
Message-ID: <20220629185903.GL1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YryJqI/ppVfMhRhI@kroah.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:19:36PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 29, 2022 at 07:10:43PM +0200, Jason A. Donenfeld wrote:
> > On Wed, Jun 29, 2022 at 07:00:25PM +0200, Greg Kroah-Hartman wrote:

[ . . . ]

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
> 
> The RCU stuff is already handled as Paul has stated, so that's not an
> issue.

To be fair, one advantage that the RCU stuff has is that it only very
recently hit mainline, so people are only just now starting to make use
of it.  Jason's code has been in for some time, so he has more existing
practice to deal with.

							Thanx, Paul

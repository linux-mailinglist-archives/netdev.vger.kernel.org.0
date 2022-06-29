Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15C4560784
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiF2Rmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiF2Rmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:42:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4628C2AE3A;
        Wed, 29 Jun 2022 10:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94CDDCE2487;
        Wed, 29 Jun 2022 17:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5178C341CB;
        Wed, 29 Jun 2022 17:42:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Pj88VkUi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656524556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BkbZZBqxrQbFUO7G0vyjAc2ffxi5fV8Ir4nOELbUO48=;
        b=Pj88VkUizi8YxoOKuEP2ExBeXRd5D2Vb1oUwY7yU7pCb6qmhSafLrZYo6PZUoNrryvoiV9
        LLCPJm+hWi+rvbrxZnu09/wLw02izyCxWfPeJC+vRYS8oMGK5bJtGceh2qWtdkJB5R0oW2
        g2huxwkd9Q/YIy65QX3MVeApGyRH7nM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 28d764bb (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 17:42:36 +0000 (UTC)
Date:   Wed, 29 Jun 2022 19:42:28 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <YryPBDQEV/Z2g0GT@zx2c4.com>
References: <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <20220629164543.GA25672@lst.de>
 <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
 <YryFKXsx/Bgv/oBE@kroah.com>
 <YryHk06Ye/12dMEN@zx2c4.com>
 <YryJqI/ppVfMhRhI@kroah.com>
 <YryMO6PX+G9owRGz@zx2c4.com>
 <20220629173545.GA26648@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629173545.GA26648@lst.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:35:45PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 29, 2022 at 07:30:35PM +0200, Jason A. Donenfeld wrote:
> > Properly resolved by whom? It sounds like you're up for intentionally
> > allowing a userspace regression, and also volunteering other people's
> > time into fixing that regression? The way I understand the kernel
> > development process is that the person proposing a change is responsible
> > for not intentionally causing regressions, and if one is pointed out, a
> > v+1 of that patch is provided that doesn't cause the regression.
> 
> If you think the code does not work when the system frequently suspends
> and resumes, then well it is broken already, as that can happen just
> as much on non-Android systems.

I don't know how you arrived at that sentence or conclusion. The
regression I'm referring to in that paragraph is the one that *your*
patch would introduce were it to be applied.

The code currently does work well on Android devices. These very
messages are transiting through it, even.

Jason

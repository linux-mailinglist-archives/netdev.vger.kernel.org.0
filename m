Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4D56070D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiF2RK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiF2RK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CFB1A806;
        Wed, 29 Jun 2022 10:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EAC961E56;
        Wed, 29 Jun 2022 17:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C467FC34114;
        Wed, 29 Jun 2022 17:10:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aExlGSSP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656522652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bl3uaY3cRegdu8Xedo5QKvYZcFg8ZQEQBfUE65BNrGc=;
        b=aExlGSSP2ZDh66T/coO6aB/IVwm5xDpZVXleX8D0ABt5ix/QwGSlKWvj27VgZh7mEsafsq
        yZa6kbd4W7mfe09g2TNhf4MXmE0JxAeYHChRIFWwVB6J4tg9DdmsTmn1Jgelf/kWdlHTHc
        7PBZvkYyrEcXv0OPVt5sacdT5F/y4wc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9da54ae8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 17:10:51 +0000 (UTC)
Date:   Wed, 29 Jun 2022 19:10:43 +0200
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
Message-ID: <YryHk06Ye/12dMEN@zx2c4.com>
References: <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <20220629164543.GA25672@lst.de>
 <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
 <YryFKXsx/Bgv/oBE@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YryFKXsx/Bgv/oBE@kroah.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:00:25PM +0200, Greg Kroah-Hartman wrote:
> I think that by the time the next kernel release comes out, and
> percolates to a real Android device, the years gone by will have caused
> those who care about this to fix it.

You assume that there aren't Android devices using kernels outside of
the ones you're referring to. That's a rather Google-centric
perspective. It's still breakage, even if Google has the ability to fix
it locally after "years gone by". If you want Android things to be
upstream, this is the way you must think about it; otherwise, what's the
point? By your logic, upstream should probably remove the Android code
everywhere and let Google handle it downstream. Except nobody wants
that; we want Android upstream. So let's keep it working upstream, not
intentionally break it.

> In the meantime, this might actually fix issues in desktop distros that
> were enabling this option, thinking it only affected the building of a
> driver

That sounds like a false dichotomy. It's not about "fix Android" vs "fix
distros". What I'm suggesting is fixing Android AND fixing distros, by
looking at the problem holistically. Trading a bad problem on Android
(wg connections are broken) for a manageable problem on distros (something
something theoretical warm boot attack something) doesn't sound like a
nice trade off. Let's instead get this all fixed at the same time.

> So it's nothing to worry about now, I agree with Christoph, this config
> option should not be used for power management policy decisions like
> this.  This should be controlled by userspace properly in the Android
> userspace framework, like all other Linux distros/systems do this.

Except right now it is. So if it's going to be removed, the code that
was depending on it will need to be updated coherently.

Jason

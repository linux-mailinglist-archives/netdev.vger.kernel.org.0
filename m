Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330ED563B8C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiGAUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiGAUxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:53:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9139D31914;
        Fri,  1 Jul 2022 13:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 383F2B83202;
        Fri,  1 Jul 2022 20:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E896C3411E;
        Fri,  1 Jul 2022 20:53:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WVCDR+HX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656708825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JJUgAvEg59n4qTslnzMARg0Z7Fq1XNYlppr5mzNAEqY=;
        b=WVCDR+HXhx1XepQGWMhNtkhfpF4VuKMPP6hDrrkRVJxJJgKwabfBDrQXToI77SR9UXBm3F
        kLVpx3RB9+LYbBp2zHoJ97qA3TEMKLwsAvbGJdF3Zt4r0pmUB7vdHkgPGYFRu+T6oyyoSK
        VAYIk/Cx+c27Cg+gExj3m+nb5RQIEeQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b51dea0b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 1 Jul 2022 20:53:44 +0000 (UTC)
Date:   Fri, 1 Jul 2022 22:53:36 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     John Stultz <jstultz@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sultan@kerneltoast.com,
        android-kernel-team <android-kernel-team@google.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <Yr9e0JnUbu93Qq1p@zx2c4.com>
References: <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
 <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
 <YrzaCRl9rwy9DgOC@zx2c4.com>
 <CANDhNCpRzzULaGmEGCbbJgVinA0pJJB-gOP9AY0Hy488n9ZStA@mail.gmail.com>
 <YrztOqBBll66C2/n@zx2c4.com>
 <87a69slh0x.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a69slh0x.fsf@meer.lwn.net>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

On Fri, Jul 01, 2022 at 02:22:38PM -0600, Jonathan Corbet wrote:
> So please forgive the noise from the peanut gallery

Yuh oh, I sure hope this isn't newsworthy for LWN. This has already
consumed me for two days...

> myself wondering...do you really need a knob for this?  The kernel
> itself can observe how often (and for how long) the system is suspended,
> and might well be able to do the right thing without explicit input from
> user space.  If it works it would eliminate a potential configuration
> problem and also perhaps respond correctly to changing workloads.
> 
> For example, rather than testing a knob, avoid resetting keys on resume
> if the suspend time is less than (say) 30s?
> 
> Educate me on what I'm missing here, please :)

What you're missing is that wireguard needs to do this before going to
sleep, not when waking up, because one of the objectives is forward
secrecy. See
https://git.zx2c4.com/wireguard-linux/tree/drivers/net/wireguard/device.c#n63

	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
		return 0;
	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
		return 0;
	[...]
	wg_noise_handshake_clear(&peer->handshake);
	wg_noise_keypairs_clear(&peer->keypairs);

Somebody asked the same question on wgml here -
https://lore.kernel.org/wireguard/CAHmME9p2OYSTX2C5M0faKtw2N8jiyohvRqnAPKa=e7BWynF7fQ@mail.gmail.com/T/
- and then eventually suggested that I should wake up computers from
sleep to clear that memory. No way jose.

Anyway, this matter has been resolved in this thread here:
https://lore.kernel.org/lkml/20220630191230.235306-1-kaleshsingh@google.com/T/
And this Android change:
https://android-review.googlesource.com/c/kernel/common/+/2142693/1
Resulting in these two commits landing in Greg's tree:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/commit/?id=261e224d6a5c43e2bb8a07b7662f9b4ec425cfec
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/commit/?id=1045a06724f322ed61f1ffb994427c7bdbe64647
So hopefully this thread can come to an end and I can get back to work.

Jason

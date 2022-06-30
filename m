Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7BA56212E
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiF3RYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235694AbiF3RYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:24:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED432BAA;
        Thu, 30 Jun 2022 10:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F266215C;
        Thu, 30 Jun 2022 17:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18C9C34115;
        Thu, 30 Jun 2022 17:24:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nYUFivTb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656609849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KqhNJ/uonxDVhq9N5vUXRV4uCAlHxZ8s0M40k+RpZJ0=;
        b=nYUFivTbayxW5C1Xwhfi8LBwFkEzPR2Ftrki9pRJhiLP13gmPvoZsVareL/wCMsDipYiwO
        4JM0NCch9B0KYDriuCFZpfhvdaepv91UEYv5WtB6uyr/ol+Gh3lXWnSAteU4P6FsAT6seG
        GaipeCKAiYu/WxVhVrJ7xfFACN8YzOo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9ff8d2df (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 17:24:08 +0000 (UTC)
Date:   Thu, 30 Jun 2022 19:24:04 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     John Stultz <jstultz@google.com>
Cc:     Kalesh Singh <kaleshsingh@google.com>,
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
Message-ID: <Yr3cNF+A5xIRiiCQ@zx2c4.com>
References: <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
 <YrzaCRl9rwy9DgOC@zx2c4.com>
 <CANDhNCpRzzULaGmEGCbbJgVinA0pJJB-gOP9AY0Hy488n9ZStA@mail.gmail.com>
 <YrztOqBBll66C2/n@zx2c4.com>
 <YrzujZuJyfymC0LP@zx2c4.com>
 <CAC_TJvcNOx1C5csdkMCAPVmX4gLcRWkxKO8Vm=isgjgM-MowwA@mail.gmail.com>
 <Yr11fp13yMRiEphS@zx2c4.com>
 <CANDhNCrcEBUUNevNyZp2qttqWssWBEcXMZ5nPO0Ntk7Vszd3bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANDhNCrcEBUUNevNyZp2qttqWssWBEcXMZ5nPO0Ntk7Vszd3bQ@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Thu, Jun 30, 2022 at 10:12:30AM -0700, John Stultz wrote:
> Does this preference come out of the too-many-options-in-gpg
> antipattern? Or is there something else?

There are numerous presentations and threads galore on why WireGuard
doesn't do knobs. Not worth rehashing here; it's not a bikeshed I really
want to have yet again, and I'd appreciate you respecting my time by not
going down that route. Sorry.

> > Anyway if you don't want a runtime switch, make a compiletime switch
> > called CONFIG_PM_CONTINUOUS_RAPID_AUTOSLEEPING or whatever, write some
> > very discouraging help text, and call it a day. And this way you don't
> > have to worry about ABI and we can change this later on and do the whole
> > thing as a no-big-deal change that somebody can tweak later without
> > issue.
> 
> Yeah, this is ok with me, as I don't see much benefit to creating a
> userland ABI, as I don't think at this point we expect the behavior to
> shift or oscillate at runtime.

Okay, fine by me. You have my sample patch for this. Feel free to CC me
on Gerrit and on the cleaned up patch and I'll offer my acks there.

No need to keep this mega thread going longer here. I'll keep my eyes
open for Gerrit notifications and such though.

Jason

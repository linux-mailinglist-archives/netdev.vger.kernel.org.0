Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0F2560744
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiF2RTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiF2RTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:19:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4CA22289;
        Wed, 29 Jun 2022 10:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4920FB82606;
        Wed, 29 Jun 2022 17:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C585C34114;
        Wed, 29 Jun 2022 17:19:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BrbSg1Vt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656523179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fsBwgNg1ukyy5sKsyWfNHxn8YCblfO3rC3IUjQX7AoE=;
        b=BrbSg1VtIZauthhC7A4FpBWtPGMjymeSv7g8hWDginRCvLJ+RMLVDlJEcvsFYikaO4hrRJ
        Rh29fbfAO7/WdP5XiA1k+76aR94FCcwH+yW1gLEWAgQM0A4Y7u36Bp8u/TAFICDGVuTRRI
        Msyq4UJYlg3WGkRPkQZ0XTdLCNcFhLo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 68b5588d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 17:19:39 +0000 (UTC)
Date:   Wed, 29 Jun 2022 19:19:30 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Christoph Hellwig <hch@lst.de>,
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
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YryJotKWelr5KFPO@zx2c4.com>
References: <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <20220629164543.GA25672@lst.de>
 <20220629125643.393df70d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629125643.393df70d@gandalf.local.home>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 12:56:43PM -0400, Steven Rostedt wrote:
> > And it will also "break" anyone else doing frequent suspends from
> > userspace, as that behavior is still in no way related to
> > CONFIG_ANDROID.
> 
> Should there then be a CONFIG_FREQUENT_SUSPENDS ?

That'd be fine by me. It could be selected by PM_AUTOSLEEP as well.

[ Bikeshed: maybe CONFIG_PM_CONTINUOUS_SUSPENDS would make more sense,
  to really drive home how often these suspends are to make the option a
  reasonable thing to turn on. ]

I think Christoph had in mind a runtime switch instead (like a sysctl or
something), but it doesn't make a difference to me whether it's runtime
or compile time. If CONFIG_ANDROID is to go away, the code using it now
needs *some* replacement that's taken up by the Android people. So
whatever they agree to works for me, for what my concerns are.

Maybe v2 of this patchset can propose such an option and the right
Android people can be CC'd on it. (Who are they, by the way? There's no
android-kernel@vger mailing list, right?)

Jason

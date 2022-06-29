Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD8F560B3F
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiF2Urn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiF2Urm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:47:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC38E22535;
        Wed, 29 Jun 2022 13:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AD9960C2C;
        Wed, 29 Jun 2022 20:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997C4C34114;
        Wed, 29 Jun 2022 20:47:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PIocfaGZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656535651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nvJ3fw5U4MW8nxM8aCE1R+6sT2AFWOEF89xbodNQ+Ms=;
        b=PIocfaGZVNfSYsleBvWLhO5VJ+LmKrkUG0h5bDnae9hr+edK+R47EppxiopYDLw5kbSCAX
        eQK5Gw+P8AHe6C3tjz8QTOM+/lZgOrILQvf6fogiJXsrsiozuZkMVdJxFrZ5pMok7P2rLE
        r74GkuVYo0ZepToWUldrCEjQsXH8o8Q=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 019e7d6b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 20:47:31 +0000 (UTC)
Date:   Wed, 29 Jun 2022 22:47:26 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kalesh Singh <kaleshsingh@google.com>
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
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org,
        sultan@kerneltoast.com
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <Yry6XvOGge2xKx/n@zx2c4.com>
References: <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
 <Yryic4YG9X2/DJiX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yryic4YG9X2/DJiX@google.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalesh,

On Wed, Jun 29, 2022 at 12:05:23PM -0700, Kalesh Singh wrote:
> Thanks for raising this.
> 
> Android no longer uses PM_AUTOSLEEP, is correct. libsuspend is
> also now deprecated. Android autosuspend is initiatiated from the
> userspace system suspend service [1].
> 
> A runtime config sounds more reasonable since in the !PM_AUTOSLEEP
> case, it is userspace which decides the suspend policy.
> 
> [1] https://cs.android.com/android/platform/superproject/+/bf3906ecb33c98ff8edd96c852b884dbccb73295:system/hardware/interfaces/suspend/1.0/default/SystemSuspend.cpp;l=265

Bingo, thanks for the pointer. So looking at this, I'm trying to tease
out some heuristic that wouldn't require any changes, but I don't really
see anything _too_ perfect. One fragment of an idea would be that the
kernel treats things in autosuspending mode if anybody is holding open a
fd to /sys/power/state. But I worry this would interact with
non-autosuspending userspaces that also hold open the file. So barring
that, I'm not quite sure.

If you also can't think of something, maybe we should talk about adding
something that requires code changes. In that line of thinking, how
would you feel about opening /sys/power/userspace_autosuspender and
keeping that fd open. Then the kernel API would have
`bool pm_has_userspace_autosuspender(void)` that code could check.
Alternatively, if you don't want refcounting fd semantics for that, just
writing a "1" into a similar file seems fine?

Any strong opinions about it? Personally it doesn't make much of a
difference to me. The important thing is just that it'd be something
you're willing to implement in that SystemSuspend.cpp file.

Jason

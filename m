Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2249F5624EF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbiF3VOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiF3VOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:14:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B36F1FCCF;
        Thu, 30 Jun 2022 14:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5AA8B82D3B;
        Thu, 30 Jun 2022 21:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210E5C341C7;
        Thu, 30 Jun 2022 21:14:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="A1EpNQGs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656623685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5LqSDYksxpph4Ux5rfA5pCNDcFAhvGHpXJyugGDZSZk=;
        b=A1EpNQGszuHFSejnU7fJ/8YyQs7m40/Sfoqh/8cLOEb5GLyEZhzC9QvigC1o6WWqKKTVIt
        pXroP6g2vcxkBz8+Ci7UMGX8TwQ8Iya562wGVq0FeOc86pp0Igiz7yN0MIdIL/G+feTJVb
        xN3A8LCnZPlOXNKeLydARJDgZAAZTbY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7bed71ba (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 21:14:45 +0000 (UTC)
Date:   Thu, 30 Jun 2022 23:14:41 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kalesh Singh <kaleshsingh@google.com>
Cc:     John Stultz <jstultz@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Saravana Kannan <saravanak@google.com>,
        "T.J. Mercier" <tjmercier@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] pm/sleep: Add PM_USERSPACE_AUTOSLEEP Kconfig
Message-ID: <Yr4SQVjBCilyV1na@zx2c4.com>
References: <20220630191230.235306-1-kaleshsingh@google.com>
 <Yr3+RLhpp3g9A7vb@zx2c4.com>
 <CAC_TJvdV9bU2xWpbgrQuyrr6ens9gzDnZT2UzAY6Q6ZN9p7aEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC_TJvdV9bU2xWpbgrQuyrr6ens9gzDnZT2UzAY6Q6ZN9p7aEw@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 01:41:40PM -0700, Kalesh Singh wrote:
> Our latest supported kernels in Android are based on 5.15 so the
> config change isn't yet needed. Once there are newer versions with the
> CONFIG_ANDROID removed I will add this to the defconfig.

Okay. It might be still worth getting something uploaded to gerrit so
that it's easy to remember and submit whenever the time comes.

Also, what about android running on mainline? Where does that base
config live?

Jason

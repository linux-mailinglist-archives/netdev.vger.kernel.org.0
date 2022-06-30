Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2325625D2
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 00:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiF3WI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 18:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF3WI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 18:08:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DFE6341;
        Thu, 30 Jun 2022 15:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2AC5B82D74;
        Thu, 30 Jun 2022 22:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE37C34115;
        Thu, 30 Jun 2022 22:08:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="izP8boWZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656626900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Q4opgcj8y74lb4+vPMz7Aaz4RXLvbhbkqhgjW9tIvg=;
        b=izP8boWZFX5fMfz/RJGlnkHtlHosnp4H5Pul/iijp/E0mA3n7tapeU2lXvgfjFgRHC5EHI
        HG6iJ64PfQOjoSj6rup/5Vw7Jo/sEexsNUKxxrKW1hyuSTJzNglW5R4FV+q3TpYt5wpFVP
        pT6LxXQzcgYHKnMapyx7o8SPOSZ4nSs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a3c525e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 22:08:20 +0000 (UTC)
Date:   Fri, 1 Jul 2022 00:08:16 +0200
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
Message-ID: <Yr4e0FCo1l3Db4Gi@zx2c4.com>
References: <20220630191230.235306-1-kaleshsingh@google.com>
 <Yr3+RLhpp3g9A7vb@zx2c4.com>
 <CAC_TJvdV9bU2xWpbgrQuyrr6ens9gzDnZT2UzAY6Q6ZN9p7aEw@mail.gmail.com>
 <Yr4SQVjBCilyV1na@zx2c4.com>
 <CAC_TJvdZMr7KyUe7ro7jmFT1z5Gs3YbM9dhbL5Yp-weLvd0T3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC_TJvdZMr7KyUe7ro7jmFT1z5Gs3YbM9dhbL5Yp-weLvd0T3g@mail.gmail.com>
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

On Thu, Jun 30, 2022 at 03:02:46PM -0700, Kalesh Singh wrote:
> I've uploaded the changes on android-mainline [1]. We'll submit there
> once the upstream changes are finalized.
> 
> [1] https://android-review.googlesource.com/c/kernel/common/+/2142693/1

Excellent. I think everything is all set then, at least from my
perspective. There's a viable replacement for this usage of
CONFIG_ANDROID, there are patches ready to go both in the kernel and on
Android's configs, and now all we do is wait for Rafael. Great!

Maybe people will have opinions on the naming
(CONFIG_PM_RAPID_USERSPACE_AUTOSLEEP vs
CONFIG_PM_ANDROID_USERAPCE_AUTO_SLEEP vs what you have vs something else
vs who knows), but whatever is chosen seems probably fine, as this is a
pretty low key change since it can always be tweaked further later (it's
not ABI).

Jason

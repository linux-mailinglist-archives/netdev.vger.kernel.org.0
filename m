Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA709562375
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiF3Ttr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiF3Ttg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BFC42ECA;
        Thu, 30 Jun 2022 12:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE088B82CF6;
        Thu, 30 Jun 2022 19:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EB3C34115;
        Thu, 30 Jun 2022 19:49:30 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EG4WL/Zm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656618568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GRQOgseJsjlGCjwiVUpaQ9qdmIJEy/G5oWcB1T2bRMs=;
        b=EG4WL/ZmP1tBUTCf3y4mcpiroKBGDQFCS77y1nx7Ow4M2TM3JCJVjBNlbLjuT3e9sUgOMA
        TEF5V2e1t6j/+uAoR8AaSEEfI1WlehbtAlzu3mBKuHjaT5jYTp+kpmGv8yOalL2HxBVDWr
        m8Xh5oGX8B4AGcAXTpFG+ctazSMxshA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e7d677a8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 19:49:27 +0000 (UTC)
Date:   Thu, 30 Jun 2022 21:49:24 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kalesh Singh <kaleshsingh@google.com>
Cc:     jstultz@google.com, paulmck@kernel.org, rostedt@goodmis.org,
        rafael@kernel.org, hch@infradead.org, saravanak@google.com,
        tjmercier@google.com, surenb@google.com, kernel-team@android.com,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] pm/sleep: Add PM_USERSPACE_AUTOSLEEP Kconfig
Message-ID: <Yr3+RLhpp3g9A7vb@zx2c4.com>
References: <20220630191230.235306-1-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630191230.235306-1-kaleshsingh@google.com>
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

On Thu, Jun 30, 2022 at 07:12:29PM +0000, Kalesh Singh wrote:
> Systems that initiate frequent suspend/resume from userspace
> can make the kernel aware by enabling PM_USERSPACE_AUTOSLEEP
> config.
> 
> This allows for certain sleep-sensitive code (wireguard/rng) to
> decide on what preparatory work should be performed (or not) in
> their pm_notification callbacks.
> 
> This patch was prompted by the discussion at [1] which attempts
> to remove CONFIG_ANDROID that currently guards these code paths.
> 
> [1] https://lore.kernel.org/r/20220629150102.1582425-1-hch@lst.de/
> 
> Suggested-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Thanks, looks good to me. Do you have a corresponding Gerrit link to the
change adding this to the base Android kernel config? If so, have my
Ack:

    Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Jason

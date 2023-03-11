Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E146B57DD
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 03:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCKClE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 21:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCKClD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 21:41:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734D712E14F;
        Fri, 10 Mar 2023 18:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD7761D4C;
        Sat, 11 Mar 2023 02:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067D5C433D2;
        Sat, 11 Mar 2023 02:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678502461;
        bh=e3EkeatwGB7ReTwTJTCNu6ndB4YHPkrPvo60FUaAVSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KCBsiJ0OOCRmVlm3Bz5GUV/iiaWCYTfZPDsC/FGz1RHEjsbR0xhlBv60SpUIZItlI
         tLQ0kCGYdqcfsM7QxPBw80lEUiFNUYlr2dc0GdF20ABhnO7+8ey2hyOjGRXJE3zlqv
         JdqhySpv4b480Cjn7F2mrQdQh9YX7YINUGg2L1XLRdFITjlISQgut35VVVKzsm7DQx
         ODxm8q1s4Z3zzINPiACU0nhUEvDn9y137m32Pdb30KrLOuvKuFfAsP9m9lsNJCOGHS
         7h6w5ysBF/C09Q7RJH32GPr7Ji4wa02RE6VqIX9w1VamK9HADrGz0X257FfPgz9Bqt
         OGgZQBROKbVyA==
Date:   Fri, 10 Mar 2023 18:41:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <20230310184100.3b91896e@kernel.org>
In-Reply-To: <ZAuQQs8K2CJbs0oI@corigine.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
        <ZAt0gqmOifS65Z91@corigine.com>
        <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
        <ZAuQQs8K2CJbs0oI@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 21:17:06 +0100 Simon Horman wrote:
> > > nit: I think < 80 columns wide is still preferred for network code  
> > 
> > I can do it if it's a strict rule here.  
> 
> I think it is more a preference than a strict rule at this point.

You're right, but the longer I think about it the more I feel like 
it should be.

80 chars is an artificial constraint these day but it simply results 
in more readable code.

I can't see the entirety of "hellcreek->led_sync_good.brightness"
at once, using it as lval in 3 different places is not great.
Maybe it's my poor eyesight.

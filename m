Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEF263B5C3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiK1XVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiK1XVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:21:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFBE2B637;
        Mon, 28 Nov 2022 15:21:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB1FB614A8;
        Mon, 28 Nov 2022 23:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2C5C433D7;
        Mon, 28 Nov 2022 23:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669677706;
        bh=5A3/G2skf0olC1HaQUWvutOyDQ7X7G7Rh0WnKKsnAEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gp2hnwzvuguUJ/st4wijeawAH+DTZ3ygBiUJada8MKVTpuv7mPaZfEkzUet4p4GEr
         cDxJUhs83huiiptJUex7PeQ9z9+zN3hx7rNOmQ22RPF4KEYN6qMXKn6WCub5xf6xXv
         LMOOHACFbtP6Lrb/u3tmXph5aQhlpGZueKf3+dyhv1gHzo3BC/RT0NbulFHWr+2vG3
         0FKLwrpVtbiB6H3qLtJWUv3OlyLeNzkUgcv4W0CSx5gbajAgxamBQmDTb/LsWd9bYC
         jFFZtgiXRvh7a2xa0TJSHgGALVB/LrvMaLvtZfdDxhzmw9G/lqm5LUXNB1C4aQtNfT
         jScleAOzXlX7w==
Date:   Mon, 28 Nov 2022 15:21:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221128152145.486c6e4b@kernel.org>
In-Reply-To: <20221128205521.32116-1-jerry.ray@microchip.com>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
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

On Mon, 28 Nov 2022 14:55:21 -0600 Jerry Ray wrote:
> These statistics are maintained by the switch and count the packets
> dropped due to buffer limits. Note that the rtnl_link_stats: rx_dropped
> statistic does not include dropped packets due to buffer exhaustion and as
> such, part of this counter would more appropriately fall under the
> rx_missed_errors.

Why not add them there as well?

Are these drops accounted for in any drop / error statistics within
rtnl_link_stats? 

It's okay to provide implementation specific breakdown via ethtool -S
but user must be able to notice that there are some drops / errors in
the system by looking at standard stats.

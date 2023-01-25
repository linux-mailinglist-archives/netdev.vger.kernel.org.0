Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EDA67A941
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 04:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbjAYD2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 22:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYD2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 22:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A3CCDE1;
        Tue, 24 Jan 2023 19:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1215B81891;
        Wed, 25 Jan 2023 03:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8AFC433EF;
        Wed, 25 Jan 2023 03:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674617289;
        bh=pLxuGuWkccGl+3mFDrpQRG+awrUGbY9Q74QPWO25ak4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0Zc7D1uDkB+qqUqa023lG7O4aRym5yv4DUb1UU6ppMbs2Qa9hzNyDT3WtC/YL6j+
         BbCZQsF13tk+D8UA+/QvKcooFSIQPrw67fSBy72kLurfRAcypSsxVvKRnruAOl0ZzS
         sAnzF1n5mJ7PNE/bgXcsI0kCBOYDUjyQVvzqCKT0UzjVeSlmPjBzz9oimZF4MeDxHa
         rMZVfOsqihjgn/PXUudywNOSX0Yc0z3H2nPTascMLPejWAGXqVXfSzB1t1tc7sDJ7Q
         /IuylX6XasHzVSrJPn34uJRpZzJcX2JLJGFXmqdEiW7klfwtC2Xw9H5SquEiO6dyJ0
         fDmlZOPt5Rx+w==
Date:   Tue, 24 Jan 2023 19:28:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, a@unstable.cc,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6
 link local addresses
Message-ID: <20230124192808.056cf9e8@kernel.org>
In-Reply-To: <20230124032105.79487-1-Thomas.Winter@alliedtelesis.co.nz>
References: <20230124032105.79487-1-Thomas.Winter@alliedtelesis.co.nz>
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

On Tue, 24 Jan 2023 16:21:01 +1300 Thomas Winter wrote:
> For our point-to-point GRE tunnels, they have IN6_ADDR_GEN_MODE_NONE
> when they are created then we set IN6_ADDR_GEN_MODE_EUI64 when they
> come up to generate the IPv6 link local address for the interface.
> Recently we found that they were no longer generating IPv6 addresses.
> 
> Also, non-point-to-point tunnels were not generating any IPv6 link
> local address and instead generating an IPv6 compat address,
> breaking IPv6 communication on the tunnel.
> 
> These failures were caused by commit e5dd729460ca and this patch set
> aims to resolve these issues.

Ah, you have the problem statement here. It needs to go into the
patches, I'm afraid. The cover letters are not as visible in-tree
and certainly don't make it to stable trees.

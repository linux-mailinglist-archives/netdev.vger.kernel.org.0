Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DD751CE4B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352400AbiEFBed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiEFBec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:34:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E9F5B896
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19ED2B82E5D
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6E0C385A4;
        Fri,  6 May 2022 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800647;
        bh=rLvqzKiS73+aVA3DDRGt5LJEuBw08EoKUpgSOHubVr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tWBMVUwP9GE4RXaJAz8BtRgQn6l5jJSIQ+p7RgnHLY1ssxUDYs+yeb+piCjYF+UDW
         fFa2Z5mWZCwHWeFER3EKmND90nRlG6k8dZMmlzfJF1BpAGIk6GbUonArcyg0PiybOb
         7HX8ZgnWPyHcV7AwdQTUYzA/khWVorAZQNvEjBJ8kk739OtR/L2Tzemo1VGEEPzXe8
         FB8cUqMTMHgI/WXkkFlRhD0vsT5LiOwby2eEFMJnYGlWz1OWkB3QzWP154lhZa23DB
         fP+t5W+64ktukHkpvCrAY9Ja5sSqTDsEitPkhrheG/YroC4Ofg+OtqAVhPppOruvfP
         55nXz+ci/Dziw==
Date:   Thu, 5 May 2022 18:30:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net] net: Fix features skip in for_each_netdev_feature()
Message-ID: <20220505183046.19952bf2@kernel.org>
In-Reply-To: <20220504080914.1918-1-tariqt@nvidia.com>
References: <20220504080914.1918-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 11:09:14 +0300 Tariq Toukan wrote:
> The find_next_netdev_feature() macro gets the "remaining length",
> not bit index.
> Passing "bit - 1" for the following iteration is wrong as it skips
> the adjacent bit. Pass "bit" instead.
> 
> Fixes: 3b89ea9c5902 ("net: Fix for_each_netdev_feature on Big endian")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> ---
>  include/linux/netdev_features.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Hi,
> Please queue to -stable >= v5.0.

You can add the normal Cc: stable tags in networking these days, 
the rules were updated.

But I'll forgo doing that here since your >= 5.0 is incorrect, looks 
like the bad commit got backported to earlier stable branches.
Greg will probably do the right thing based on the Fixes tag, anyway.

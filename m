Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460FB67FE9E
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 12:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjA2LoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 06:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjA2LoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 06:44:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A01212BA
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10F7FB80B9E
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 11:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19453C433D2;
        Sun, 29 Jan 2023 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674992637;
        bh=TDNIdzHxTsptTuCNlpFYNF7gjfmaOn0rB2AsJX19J5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hOvSM4U1AJ7KK7hjfc/3LvNG/jlgHahNGjAbnGFqR6QKun/rCMcZr6mXMoXqgtEp1
         mIYGz2skNQJ/bUDvrxqGJsGk8gOukVsHq52r9i3vOZJ2EJDQoCsaIcLieHxOUf8OcC
         1yLqrgt8gC98ZSNqxQUhp6WOeTQIFcMV9FEf3bWliBJo4yUij5k9kqiymP89vayMpV
         62MXB7TfSvuGBHZFijK+dMsQ4ZqwP/KOhXO3Q98lMRL/ZS3S+y7fE2UP9VHR/DI+4r
         MujKSToQUXOktj9Qy+dEE7dEfbak6b7ltI1TLwxcr42tlREZiZyG4vkbTzRwKmFpl7
         YikMf3b9QUg0w==
Date:   Sun, 29 Jan 2023 13:43:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <Y9Zb+RU637gLIwgz@unreal>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
 <20230126223213.riq6i2gdztwuinwi@skbuf>
 <20230126143723.7593ce0b@kernel.org>
 <Y9NgdXk3NLtjG3Mj@unreal>
 <20230126232615.1901128c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126232615.1901128c@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 11:26:15PM -0800, Jakub Kicinski wrote:
> On Fri, 27 Jan 2023 07:26:13 +0200 Leon Romanovsky wrote:
> > > That'd be my preference too, FWIW. It's only the offload cases which
> > > need this sort of fallback.  
> > 
> > Of course not, almost any error unwind path which sets extack will need it.
> 
> I guess we can come up with scenarios where the new behavior would 
> be useful. But the fact is - your patch changes 4 places...

ok, I'll rename.

> 
> > See devlink as an example
> 
> I don't know what part of devlink you mean at a quick scroll.

I overlooked "return err" in the middle.
You are right.

Thanks

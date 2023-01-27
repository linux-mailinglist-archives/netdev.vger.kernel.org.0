Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1069067DE7C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjA0H0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjA0H0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:26:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AD5539AE
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:26:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C8161989
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426ADC433D2;
        Fri, 27 Jan 2023 07:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674804378;
        bh=YRpZqCUJGzHFe4qMsVOvMtBYuFuPJtP4nCTJvR/19U8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TboVLCAn/Zgr2F7n0/AWrfYqTJoIjiwQXuMqPI/rMzBWMMMY41XC3lh+wsQQwm8kH
         saxjDHpJssdcWWb/dQl8Fs5jwfdyMT3AvgMEFIH1mp8Tm6sTW+CohoYlS5Q/y/JXwx
         yasy5MHQLb1UMpUYLxZ5uV5ahWTNJQkPLkxg/VCfPFtUYqatgb7HHo2PMp86J6pzmJ
         zgpc3CeOgWvNvyTCMyxJUGCxQun96LF6aaMEDRqzKWzAucAIhS7SU4t3Qbm0v2uZVP
         WqnklZYL9zqOEQ7UefYCpZkjd6ZyzA26cNWBXW6ji2QNnb+IUYbQz7zm5BulHpDExR
         Q9AtJluRXF+Tg==
Date:   Thu, 26 Jan 2023 23:26:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20230126232615.1901128c@kernel.org>
In-Reply-To: <Y9NgdXk3NLtjG3Mj@unreal>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
        <20230126223213.riq6i2gdztwuinwi@skbuf>
        <20230126143723.7593ce0b@kernel.org>
        <Y9NgdXk3NLtjG3Mj@unreal>
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

On Fri, 27 Jan 2023 07:26:13 +0200 Leon Romanovsky wrote:
> > That'd be my preference too, FWIW. It's only the offload cases which
> > need this sort of fallback.  
> 
> Of course not, almost any error unwind path which sets extack will need it.

I guess we can come up with scenarios where the new behavior would 
be useful. But the fact is - your patch changes 4 places...

> See devlink as an example

I don't know what part of devlink you mean at a quick scroll.

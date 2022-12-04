Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4957C641CA6
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 12:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiLDLf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 06:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLDLfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 06:35:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C721182C
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 03:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 840C2CE0979
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 11:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BB8C433C1;
        Sun,  4 Dec 2022 11:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670153748;
        bh=9EHnDzPbgsQdF3oOEVbXRL65nh0eYYO03nI4p9lposQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIgXpY3hx3RhvjdIXESnOymBSaRkLdEGLIAKGpe0jgC5QShfL5ESYquJ+JBqYYjpp
         aiYyKqIPlVf/D7JEhgNWRSFO7TEJDDNMjyx8BNf/hMdt9EqbRLYd4SCt1lwXauuVh1
         Pj3YE/QJYJ2pl4aUb+rTHrsZnuXvZLHpRmR85Fb2SKikKZNsP6wOTTDuu+otk4ju7M
         7DYfbPMs++RTYpOb8UrycuxFdLchVq3iwoW5UV/ju5kf7DhkAvgruA2VSRj+L9UhYN
         B5ckziIJzSfjqIf6iZEKrkYkgGzqelYGeP00n/U/2Z4pwZh12M+VHQW6SYwEXqLEJd
         FLm4IKp2HfzmA==
Date:   Sun, 4 Dec 2022 13:35:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, yangyingliang@huawei.com
Subject: Re: [patch net-next RFC 0/7] devlink: make sure devlink port
 registers/unregisters only for registered instance
Message-ID: <Y4yGCTMyV2bdD+05@unreal>
References: <20221201164608.209537-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:46:01PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>

<...>

> Jiri Pirko (7):
>   devlink: Reorder devlink_port_register/unregister() calls to be done
>     when devlink is registered
>   netdevsim: Reorder devl_port_register/unregister() calls to be done
>     when devlink is registered
>   mlxsw: Reorder devl_port_register/unregister() calls to be done when
>     devlink is registered
>   nfp: Reorder devl_port_register/unregister() calls to be done when
>     devlink is registered
>   mlx4: Reorder devl_port_register/unregister() calls to be done when
>     devlink is registered
>   mlx5: Reorder devl_port_register/unregister() calls to be done when
>     devlink is registered
>   devlink: assert if devl_port_register/unregister() is called on
>     unregistered devlink instance

Thanks, it is more clear now what you wanted.
Everything here looks ok, but can you please find better titles for the
commit messages? They are too long.

Not related to the series, but spotted during the code review,
It will be nice if you can get rid of devlink_port->registered and rely
xarray marks for that. It will be cleaner and aligned with devlink object.

Thanks

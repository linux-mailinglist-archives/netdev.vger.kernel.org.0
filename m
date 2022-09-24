Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E475E8C07
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiIXMC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 08:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiIXMC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 08:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD5CA6AC8
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 05:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A0A5612BE
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 12:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F89C433C1;
        Sat, 24 Sep 2022 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664020945;
        bh=AKfBLQOtT4DSnn9eYdYTsOpELo1QGHZFywSwVgzGkOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FiVTg8VFm8UQZEgXU5GEcnkuJcOvCSStyGoBcujfggKkO4ZghR7KpxhhIR1G83FHn
         vAoYjHUEmq1HPAMMMtEz2otoJBCqapjCbijXaVyPdS6l+xnJC8j3Zo0fPXF9Tgo4mt
         Ji//jH+XsZRx0sO/hTtHV0NbjE5kNzYUgkyuK14U=
Date:   Sat, 24 Sep 2022 14:02:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] Revert "net: mvpp2: debugfs: fix memory leak when using
 debugfs_lookup()"
Message-ID: <Yy7xzZ/AhIn+VxYo@kroah.com>
References: <20220923234736.657413-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923234736.657413-1-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 07:47:36PM -0400, Sasha Levin wrote:
> This reverts commit fe2c9c61f668cde28dac2b188028c5299cedcc1e.
> 
> On Tue, Sep 13, 2022 at 05:48:58PM +0100, Russell King (Oracle) wrote:
> >What happens if this is built as a module, and the module is loaded,
> >binds (and creates the directory), then is removed, and then re-
> >inserted?  Nothing removes the old directory, so doesn't
> >debugfs_create_dir() fail, resulting in subsequent failure to add
> >any subsequent debugfs entries?
> >
> >I don't think this patch should be backported to stable trees until
> >this point is addressed.
> 
> Revert until a proper fix is available as the original behavior was
> better.
> 
> Cc: Marcin Wojtas <mw@semihalf.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: netdev@vger.kernel.org
> Cc: stable@kernel.org
> Reported-by: Russell King <linux@armlinux.org.uk>
> Fixes: fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

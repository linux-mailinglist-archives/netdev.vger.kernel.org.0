Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10DC5A87EE
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiHaVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiHaVJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67369A455;
        Wed, 31 Aug 2022 14:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8361E61A28;
        Wed, 31 Aug 2022 21:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCE0C433C1;
        Wed, 31 Aug 2022 21:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661980188;
        bh=qQ9PPWThzo6F2tksR4N0Q6cgv9GsxecTXAzubnqh6P0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XdGkVtjKtwMAZBLs6x3kXwcKqlFaaMbHWWb2clH9MfkCfHXBMM/JkOdrw6mvABNWu
         osmXMK4Lw74TrAhs19+tQtFFED/HqeEnhIEzWYGYW5CPh4sx2XtHtGrFqVILFn4ygR
         81GEZqL/E1aSyg/B6dTaeG5sLZlOhF9qqgD0yG5oXWG3NUw3vr7wTulXtTR35MRoGo
         wq4Sw8FLMFD9N8vLruz6m52im3zulRjC1u2mQKQUx9BJGXuE5Jp8nMHZzFwR6yDeT7
         /u4onFleDSlJ2jcismH1AWO92WbP0k2J9jHHutQ5uV0tqNB3DFs/Y/cNEjdbZWBdQ7
         JLlQeuhi8wD1Q==
Date:   Wed, 31 Aug 2022 14:09:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <20220831140947.7e8d06ee@kernel.org>
In-Reply-To: <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
References: <20220830101237.22782-1-gal@nvidia.com>
        <20220830231330.1c618258@kernel.org>
        <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
        <20220830233124.2770ffc2@kernel.org>
        <20220831112150.36e503bd@kernel.org>
        <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 22:59:14 +0200 Stefan Schmidt wrote:
> I was swamped today and I am only now finding time to go through mail.
> 
> Given the problem these ifdef are raising I am ok with having these 
> commands exposed without them.
> 
> Our main reason for having this feature marked as experimental is that 
> it does not have much exposure and we fear that some of it needs rewrites.
> 
> If that really is going to happen we will simply treat the current 
> commands as reserved/burned and come up with other ones if needed. While 
> I hope this will not be needed it is a fair plan for mitigating this.

Thanks for the replies. I keep going back and forth in my head on
what's better - un-hiding or just using NL802154_CMD_SET_WPAN_PHY_NETNS + 1 
as the start of validation, since it's okay to break experimental commands.

Any preference?

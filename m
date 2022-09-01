Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B915A8E61
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiIAGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiIAGio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:38:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953CF11E836;
        Wed, 31 Aug 2022 23:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D5AAB823D5;
        Thu,  1 Sep 2022 06:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B191C433C1;
        Thu,  1 Sep 2022 06:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662014319;
        bh=aKj0/wbm6Hh27T45TgtcfxcIXgi5AZxuQPZw4/oUtZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TFpf56YD3zUa6QH/suHwKpfSPjeE81oBUmeS6Ug7jhm4d7WXiCT4Pc9TpageDuydu
         jteKIkZ+1cpBR4r5mePLtEHOVHwN6bxOn04rqynQy6RzbRpNKbpgv6yJ3juIBbHKHx
         d6KsBcbmSTbwbNga53vgVzfOOw6wOWvmYc5rUDTW1za00Z8G5WTJwI7JfTvJD2Z/D/
         Hm2778NZUDXJLaXAZRITY4Ngw1vrSspmr3dPtQqchMzBlf0XIqscpz0hr5t5A1S4Tm
         uCEHQ4u39CBS0GYHqYddjX6bPQb/uHkFeHhNPdbe5fzExjX6geLccq/yr4oEPpQNuV
         3kiyyRjMVNsgg==
Date:   Thu, 1 Sep 2022 09:38:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <YxBTaxMmHKiLjcCo@unreal>
References: <20220830101237.22782-1-gal@nvidia.com>
 <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
 <20220830233124.2770ffc2@kernel.org>
 <20220831112150.36e503bd@kernel.org>
 <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
 <20220831140947.7e8d06ee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831140947.7e8d06ee@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 02:09:47PM -0700, Jakub Kicinski wrote:
> On Wed, 31 Aug 2022 22:59:14 +0200 Stefan Schmidt wrote:
> > I was swamped today and I am only now finding time to go through mail.
> > 
> > Given the problem these ifdef are raising I am ok with having these 
> > commands exposed without them.
> > 
> > Our main reason for having this feature marked as experimental is that 
> > it does not have much exposure and we fear that some of it needs rewrites.
> > 
> > If that really is going to happen we will simply treat the current 
> > commands as reserved/burned and come up with other ones if needed. While 
> > I hope this will not be needed it is a fair plan for mitigating this.
> 
> Thanks for the replies. I keep going back and forth in my head on
> what's better - un-hiding or just using NL802154_CMD_SET_WPAN_PHY_NETNS + 1 
> as the start of validation, since it's okay to break experimental commands.
> 
> Any preference?

Jakub,

There is no such thing like experimental UAPI. Once you put something
in UAPI headers and/or allowed users to issue calls from userspace
to kernel, they can use it. We don't control how users compile their
kernels.

So it is not break "experimental commands", but break commands that
maybe shouldn't exist in first place.

nl802154 code suffers from two basic mistakes:
1. User visible defines are not part of UAPI headers. For example,
include/net/nl802154.h should be in include/uapi/net/....
2. Used Kconfig option for pseudo-UAPI header.

In this specific case, I checked that Fedora didn't enable this
CONFIG_IEEE802154_NL802154_EXPERIMENTAL knob, but someone needs
to check debian and other distros too.

Most likely it is not used at all.

https://src.fedoraproject.org/rpms/kernel/tree/rawhide

Thanks

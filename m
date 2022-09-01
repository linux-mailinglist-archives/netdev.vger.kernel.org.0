Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA195A9821
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 15:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiIANL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 09:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbiIANLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 09:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097E63A480;
        Thu,  1 Sep 2022 06:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4710DB82566;
        Thu,  1 Sep 2022 13:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C332C433D7;
        Thu,  1 Sep 2022 13:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662037512;
        bh=I1esm+YEXGUP/UKS+J1Eamgs8fxbk/NydYiEPNA7aWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HneGwHD+5wujexWiwSzLqVz/B8UXT3d1m2ZA45deooZhdDJ8kbtSddkPcu832LYlE
         uUUPWiexvwjKehZ8dcteugu1dt1u52n26I4G22wOLz0uc4CtvC5qLSMosNF841mtCd
         /Z56P5pfWa09objnqgq5BvdXItMkRLcix/B6bASGyA7Az8vjpiYWqoWFxhHghytSpy
         lctbLSdKvpPTb6XivdzQ3igtAbrV2Cm4Ti6bvoEvL/R21QY2iIyTp0SHrboRKeKUXw
         3JpsXuZrX7cwry9mukgqT72mMM5tpQtCxalMjKagUZsCpJhG03hlQpbYLjXULt0Y9+
         TrKEn/SlGGugQ==
Date:   Thu, 1 Sep 2022 16:05:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <YxCuA3soEjtKW/VI@unreal>
References: <20220830101237.22782-1-gal@nvidia.com>
 <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
 <20220830233124.2770ffc2@kernel.org>
 <20220831112150.36e503bd@kernel.org>
 <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
 <20220831140947.7e8d06ee@kernel.org>
 <YxBTaxMmHKiLjcCo@unreal>
 <CAK-6q+hdNJymhcuOp9OJVTgiO2MCqa_xUa_MZuQK3toDLMudhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-6q+hdNJymhcuOp9OJVTgiO2MCqa_xUa_MZuQK3toDLMudhw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 08:50:16AM -0400, Alexander Aring wrote:
> Hi,
> 
> On Thu, Sep 1, 2022 at 2:38 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Aug 31, 2022 at 02:09:47PM -0700, Jakub Kicinski wrote:
> > > On Wed, 31 Aug 2022 22:59:14 +0200 Stefan Schmidt wrote:
> > > > I was swamped today and I am only now finding time to go through mail.
> > > >
> > > > Given the problem these ifdef are raising I am ok with having these
> > > > commands exposed without them.
> > > >
> > > > Our main reason for having this feature marked as experimental is that
> > > > it does not have much exposure and we fear that some of it needs rewrites.
> > > >
> > > > If that really is going to happen we will simply treat the current
> > > > commands as reserved/burned and come up with other ones if needed. While
> > > > I hope this will not be needed it is a fair plan for mitigating this.
> > >
> > > Thanks for the replies. I keep going back and forth in my head on
> > > what's better - un-hiding or just using NL802154_CMD_SET_WPAN_PHY_NETNS + 1
> > > as the start of validation, since it's okay to break experimental commands.
> > >
> > > Any preference?
> >
> > Jakub,
> >
> > There is no such thing like experimental UAPI. Once you put something
> > in UAPI headers and/or allowed users to issue calls from userspace
> > to kernel, they can use it. We don't control how users compile their
> > kernels.
> >
> > So it is not break "experimental commands", but break commands that
> > maybe shouldn't exist in first place.
> >
> > nl802154 code suffers from two basic mistakes:
> > 1. User visible defines are not part of UAPI headers. For example,
> > include/net/nl802154.h should be in include/uapi/net/....
> 
> yes, but no because then this will end in breaking UAPI because it
> will be exported to uapi headers if we change them?
> For now we say everybody needs to copy the header on their own into
> their user space application if they want to use the API which means
> it fits for the kernel that they copied from.

It is not how UAPI works. Once you allowed me to send ID number XXX to
the kernel without any header file. I can use it directly, so "hiding"
files from users make their development harder, but not impossible.

Basically, this is how vendoring and fuzzing works.

> 
> > 2. Used Kconfig option for pseudo-UAPI header.
> >
> > In this specific case, I checked that Fedora didn't enable this
> > CONFIG_IEEE802154_NL802154_EXPERIMENTAL knob, but someone needs
> > to check debian and other distros too.
> >
> 
> I would remove the CONFIG_IEEE802154_NL802154_EXPERIMENTAL config
> option but don't move the header to "include/uapi/..." which means
> that the whole nl802154 UAPI (and some others UAPIs) are still
> experimental because it's not part of UAPI "directory".
> btw: the whole subsystem is still experimental because f4671a90c418
> ("net/ieee802154: remove depends on CONFIG_EXPERIMENTAL") was never
> acked by any maintainer... but indeed has other reasons why it got
> removed.

I don't know anything about NL802154, just trying to explain that UAPI
rules are both relevant to binary and compilation compatibility.

In your case, concept of CONFIG_IEEE802154_NL802154_EXPERIMENTAL breaks
binary compatibility.

Thanks

> 
> - Alex
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E1D3433B0
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhCURWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhCURWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 13:22:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 370216192D;
        Sun, 21 Mar 2021 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616347344;
        bh=grRbkHiGMiSHWVuRSSoESXsJfOIy2CjZklOAVeWnZfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcb9EomaSRSVie+gdKKsQwIdFn/WQrFhUrocsGftn4xKjEuAb/x2g77wzd/sVauDs
         Xf59ahHNOYLQTAYJHjLqLcNjgkmj2xPSNhKTxbbkSMlH8Y9CFF5dX3OPQqrBslq/XU
         u2hfZg+BnhopjlvQyqJ3V9RTjCZx7wbBvJeKybIojz/4SGkiB771j2DTjG11r2Aot1
         6pCoJvR5rKCUl1n/lmG4h4jvnj/ixtCesI6+8yKLVrdDpIIUaGE11XpX3y4Aottgux
         dJdYY0ioXlP9jbOaS1+yU/x0hPPC8meih0pKze6ZXth0crA1GrmxwXr2mLuzt4ZCQW
         aC15QJ9UD3XQw==
Date:   Sun, 21 Mar 2021 19:22:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Hsu, Chiahao" <andyhsu@amazon.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        kuba@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YFeAzfJsHAqPvPuY@unreal>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch>
 <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch>
 <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com>
 <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 05:31:08PM +0100, Hsu, Chiahao wrote:
> 
> 
> Leon Romanovsky 於 2021/3/17 18:22 寫道:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > On Tue, Mar 16, 2021 at 04:22:21PM +0100, Hsu, Chiahao wrote:
> > > 
> > > Leon Romanovsky 於 2021/3/14 11:04 寫道:
> > > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > 
> > > > 
> > > > 
> > > > On Fri, Mar 12, 2021 at 09:36:59PM +0100, Andrew Lunn wrote:
> > > > > On Fri, Mar 12, 2021 at 04:18:02PM +0100, Hsu, Chiahao wrote:
> > > > > > Andrew Lunn 於 2021/3/12 15:52 寫道:
> > > > > > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > > > On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
> > > > > > > > In order to support live migration of guests between kernels
> > > > > > > > that do and do not support 'feature-ctrl-ring', we add a
> > > > > > > > module parameter that allows the feature to be disabled
> > > > > > > > at run time, instead of using hardcode value.
> > > > > > > > The default value is enable.
> > > > > > > Hi ChiaHao
> > > > > > > 
> > > > > > > There is a general dislike for module parameters. What other mechanisms
> > > > > > > have you looked at? Would an ethtool private flag work?
> > > > > > > 
> > > > > > >         Andrew
> > > > > > Hi Andrew,
> > > > > > 
> > > > > > I can survey other mechanisms, however before I start doing that,
> > > > > > 
> > > > > > could you share more details about what the problem is with using module
> > > > > > parameters? thanks.
> > > > > It is not very user friendly. No two kernel modules use the same
> > > > > module parameters. Often you see the same name, but different
> > > > > meaning. There is poor documentation, you often need to read the
> > > > > kernel sources it figure out what it does, etc.
> > > > +1, It is also global parameter to whole system/devices that use this
> > > > module, which is rarely what users want.
> > > > 
> > > > Thanks
> > > Hi,
> > > I think I would say the current implementation(modparams) isappropriate
> > > after reviewing it again.
> > > 
> > > We are talking about 'feature leveling', a way to support live migrationof
> > > guest
> > > between kernels that do and do not support the features. So we want to
> > > refrain
> > > fromadding the features if guest would be migrated to the kernel which does
> > > not support the feature. Everythingshould be done (in probe function) before
> > > frontend connects, and this is why ethtool is not appropriate for this.
> > It wouldn't be a surprise to you that feature discovery is not supposed
> > to be done through module parameters. Instead of asking from user to
> > randomly disable some feature, the system is expected to be backward
> > compatible and robust enough to query the list of supported/needed
> > features.
> > 
> > Thanks
> > 
> > > Thanks
> > > 
> > > 
> Typically there should be one VM running netback on each host,
> and having control over what interfaces or features it exposes is also
> important for stability.
> How about we create a 'feature flags' modparam, each bits is specified for
> different new features?

At the end, it will be more granular module parameter that user still
will need to guess.

Thanks

> 

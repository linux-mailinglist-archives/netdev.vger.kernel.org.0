Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65622F509C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbhAMREQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbhAMREQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 12:04:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4802339D;
        Wed, 13 Jan 2021 17:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610557415;
        bh=6dH61ju0PZwO74VMU9/uGp5UxpLqtK1+9LschrDlZx8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKE/Qt9utj/kDqQ1lRISX+8VJtqBQjJCD44GrmPkS0OsIr5Z5t0DJ2Kn5X6bxdWYs
         W2+IokoWajuDfADn5RO48jLz/OHXSIq3dEnopvH4tBXXmPMxSmbXMFepcspagvY/6X
         BWf9Iz/y0sHVk2ZN827UWRpaUl6WRTvP5ka2EiSUNKt4VoQLvyufsgEPdaw853yIfV
         9pYGGgAHZsKnNsaYBIhKF+3ErasOdnNZl5hP2fYDx02Ep8s0u6dq0D37Boxbkh48vk
         vB3JTgBB18snOKgLKU8hdAwMyZBx9YmpDqCTxdHLJXIozmBJ2Vz8A9j6HWlF1sbGov
         Z45FESNydCuhw==
Date:   Wed, 13 Jan 2021 18:03:31 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113180331.5e79ee08@kernel.org>
In-Reply-To: <20210113102849.GG1551@shell.armlinux.org.uk>
References: <20210113011823.3e407b31@kernel.org>
        <20210113102849.GG1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 10:28:49 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> I don't know whether the 88x3310 on the host side uses AN or not for
> 2500base-X - that detail isn't mentioned in the datasheet, and I don't
> have a setup that I could test that with.

It does not. I have been poking the registers on 88x3310, and also on
Peridot and Amethyst SERDES PHYs when cmode on the switch is set to
2500base-x, and by default the inband AN is disabled.

Enabling it on the PHY in Amethyst does not work at all. On Peridot
your code in mv88e6xxx enables it, but when 88x3310 is connected to
Peridot SERDES, it does not work until the AN is disabled on Peridot.

Enabling the AN on 2500base-x mode on 88x3310 does not seem to work.

I will do some more tests by poking the registers and report this.

Marek

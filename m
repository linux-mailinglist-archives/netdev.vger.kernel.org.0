Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7140D48E352
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiANEf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiANEf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:35:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF6C061574;
        Thu, 13 Jan 2022 20:35:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BDCBB823A8;
        Fri, 14 Jan 2022 04:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592F2C36AEA;
        Fri, 14 Jan 2022 04:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642134925;
        bh=5ujrF7TIlOeg9a58cDS1ACqnP2rvn0LCA4q1ER9VkWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cv0DqK+UwemWWlFsZxqshPiEwbp+K1z0lulrNtgjuiT1Ucq/Q5SaO1KImGbmnMcOt
         ib16xTYq+vHwd4UTUK6j0qWL4YPBuI5mYW6sp47Njg5JDp9b8jYCvsKAdW1Cf3Z4aV
         c2rqSgRJhbXI465f3oGQUCDFj6wU7HyJ5+J3Yos9qrg68rA4KU86a61+ecfZ9UOVPr
         /hQYu3jG/3jzcJ2bCN01NaemFLKvjIo6Z6l9FYYEhvbvGAORjC65qqjr0p/WbNL97R
         YbhYjumZi7K0gRnbxHlySFxndwkv3RPGj3IUJWfm7MSUDp0CkXxGvLLHkYe43DaheT
         +2+K+E90niP7w==
Date:   Thu, 13 Jan 2022 20:35:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
Message-ID: <20220113203523.310e13d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220114040755.1314349-2-kai.heng.feng@canonical.com>
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
        <20220114040755.1314349-2-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 12:07:54 +0800 Kai-Heng Feng wrote:
> BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> instead of setting another value, keep it untouched and restore the saved
> value on system resume.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

I defer to PHY experts for review. Coincidentally the first Marvell
flag appears dead, nobody sets it:

$ git grep MARVELL_PHY_M1145_FLAGS_RESISTANCE
drivers/net/phy/marvell.c:      if (phydev->dev_flags & MARVELL_PHY_M1145_FLAGS_RESISTANCE) {
include/linux/marvell_phy.h:#define MARVELL_PHY_M1145_FLAGS_RESISTANCE  0x00000001
$

unless it's read from DT under different name or something.


Once you get some reviews please wait for net-next to open:

http://vger.kernel.org/~davem/net-next.html

and repost. It should happen the week of Jan 24th. When you repost
please drop the first patch, I believe Russell does not like the BIT()
macro, his opinion overrides checkpatch.

Thanks!

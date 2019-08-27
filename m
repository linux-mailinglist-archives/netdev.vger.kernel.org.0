Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068F19F5C1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfH0WBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:01:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfH0WBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:01:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A536315256ED2;
        Tue, 27 Aug 2019 15:01:03 -0700 (PDT)
Date:   Tue, 27 Aug 2019 15:01:03 -0700 (PDT)
Message-Id: <20190827.150103.723109968950216148.davem@davemloft.net>
To:     marco.hartmann@nxp.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com
Subject: Re: [PATCH v2 net] Add genphy_c45_config_aneg() function to
 phy-c45.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
References: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 15:01:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Hartmann <marco.hartmann@nxp.com>
Date: Wed, 21 Aug 2019 11:00:46 +0000

> Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from calling
> genphy_config_aneg") introduced a check that aborts phy_config_aneg()
> if the phy is a C45 phy.
> This causes phy_state_machine() to call phy_error() so that the phy
> ends up in PHY_HALTED state.
> 
> Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
> (analogous to the C22 case) so that the state machine can run
> correctly.
> 
> genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
> in drivers/net/phy/marvell10g.c, excluding vendor specific
> configurations for 1000BaseT.
> 
> Fixes: 22b56e827093 ("net: phy: replace genphy_10g_driver with genphy_c45_driver")
> 
> Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>

Andrew, gentle ping to respond to Heiner who said:

> For me this patch would be ok, even though this generic config_aneg
> doesn't support 1000BaseT.
> 1. The whole genphy_c45 driver doesn't make sense w/o a config_aneg
>    callback implementation.
> 2. It can serve as a temporary fallback for new C45 PHY's that don't
>    have a dedicated driver yet.
> 3. We may have C45 PHYs not supporting 1000BaseT (e.g. T1).
> 
> Andrew?

Thanks.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2AE9F693
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfH0XKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:10:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfH0XKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YR2u+b2LhnAELUHnWiGJHlda9p+tN1nN+D0ZxNNeSFg=; b=Sku2ku6uvXejga+FlHP4Ua6LSc
        X5gdiJkvBtcjGDgiSAcFfFC0Gbfgpy2k8EzblZKgGxL8FcEFxg9V1mAM4TJ6NfaYydV092VkNonx6
        QL+Qp1QqgIh6aHRSB84A6Av0KoemlAKI1fb9TLcITbhvHy96AZpWYjewXq5XDTa0BUmY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2kbA-0007AK-8H; Wed, 28 Aug 2019 01:10:00 +0200
Date:   Wed, 28 Aug 2019 01:10:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     marco.hartmann@nxp.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com
Subject: Re: [PATCH v2 net] Add genphy_c45_config_aneg() function to phy-c45.c
Message-ID: <20190827231000.GA26248@lunn.ch>
References: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
 <20190827.150103.723109968950216148.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827.150103.723109968950216148.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 03:01:03PM -0700, David Miller wrote:
> From: Marco Hartmann <marco.hartmann@nxp.com>
> Date: Wed, 21 Aug 2019 11:00:46 +0000
> 
> > Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from calling
> > genphy_config_aneg") introduced a check that aborts phy_config_aneg()
> > if the phy is a C45 phy.
> > This causes phy_state_machine() to call phy_error() so that the phy
> > ends up in PHY_HALTED state.
> > 
> > Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
> > (analogous to the C22 case) so that the state machine can run
> > correctly.
> > 
> > genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
> > in drivers/net/phy/marvell10g.c, excluding vendor specific
> > configurations for 1000BaseT.
> > 
> > Fixes: 22b56e827093 ("net: phy: replace genphy_10g_driver with genphy_c45_driver")
> > 
> > Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
> 
> Andrew, gentle ping to respond to Heiner who said:

It at least makes it consistent with phy_restart_aneg() and
phy_aneg_done().

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

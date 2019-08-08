Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8383865A5
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbfHHPYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:24:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbfHHPYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1fu3o3KwM0ZdC1PdKsgvDRgOTasJSuEkT2fM7tKGHXQ=; b=npxLmLuQlU/e+zErTrXwhwqGls
        Vsi0dAi4OSidI1T/FPhzexGIImOkLM1x0Qna8hsaOBI5Xt8TZHoRMfxSDnKeM7BUTmdI4HV9gTY1C
        oLbt0PtFOsEpgK2H/93URjXuJXSSJM702oKTK4yJxNK+9Z3utNSEJqJoOQI8+hd2hqyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvkGp-0003nD-1C; Thu, 08 Aug 2019 17:24:03 +0200
Date:   Thu, 8 Aug 2019 17:24:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 02/15] net: phy: adin: hook genphy_read_abilities() to
 get_features
Message-ID: <20190808152403.GB27917@lunn.ch>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
 <20190808123026.17382-3-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808123026.17382-3-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 03:30:13PM +0300, Alexandru Ardelean wrote:
> The ADIN PHYs can operate with Clause 45, however they are not typical for
> how phylib considers Clause 45 PHYs.
> 
> If the `features` field & the `get_features` hook are unspecified, and the
> device wants to operate via Clause 45, it would also try to read features
> via the `genphy_c45_pma_read_abilities()`, which will try to read PMA regs
> that are unsupported.
> 
> Hooking the `genphy_read_abilities()` function to the `get_features` hook
> will ensure that this does not happen and the PHY features are read
> correctly regardless of Clause 22 or Clause 45 operation.

I think we need to stop and think about a PHY which supports both C22
and C45.

How does bus enumeration work? Is it discovered twice?  I've always
considered phydev->is_c45 means everything is c45, not that some
registers can be accessed via c45. But the driver is mixing c22 and
c45. Does the driver actually require c45? Are some features which are
only accessibly via C45? What does C45 actually bring us for this
device?

     Andrew

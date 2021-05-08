Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CA2377416
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 22:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhEHU5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 16:57:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHU5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 16:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g/WsiBFvrJ4SfQSvjJJFtE2IU9SObL9caGm/yUDzgis=; b=EEUFhQXK9kJAj1EPmMy0eFtAf2
        Xs3ZAfPEsCNYLbgS+g0f2GIpc4ftdalOtXJQDQBVKYOTbmsenQbWgGyWXs5UqZ/WRSs1PszTmKxaN
        wJpDjpdDhyG+lmUmB8kR4As7fUBOxpGhkPgKlE0rRGv/2EQAD93QaGY1Zu7C+kygz2Ac=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfTzS-003JA0-9Z; Sat, 08 May 2021 22:55:58 +0200
Date:   Sat, 8 May 2021 22:55:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <YJb63t/TFVs/3uIZ@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
 <20210506112458.yhgbpifebusc2eal@skbuf>
 <YJXMit3YfBXKM98j@Ansuel-xps.localdomain>
 <20210507233353.GE1336@shell.armlinux.org.uk>
 <20210508182620.vmzjvmqhexutj7p3@skbuf>
 <20210508193911.GG1336@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508193911.GG1336@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We do have the problem with Marvell DSA vs Marvell PHY setup in that
> the Marvell DSA driver assumes that all integrated PHYs that do not
> have an ID are all the same. They are most definitely not, and this
> shows itself up when we register the hwmon stuff inappropriately, or
> access the wrong registers to report hwmon values.

Hi Russell

This was to some degree fixed recently. Rather than always use the
6390 ID for everything, the family ID is now used. This should avoid
the issue with the SERDES being incorrectly considered a PHY, since
that particular family ID is not listed in the PHY driver.

      Andrew

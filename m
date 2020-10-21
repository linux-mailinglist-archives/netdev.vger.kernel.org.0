Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15032950D2
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 18:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502958AbgJUQe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 12:34:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438161AbgJUQe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 12:34:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVH4C-002qId-8a; Wed, 21 Oct 2020 18:34:24 +0200
Date:   Wed, 21 Oct 2020 18:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <ardeleanalex@gmail.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Subject: Re: [PATCH 1/2] net: phy: adin: clear the diag clock and set
 LINKING_EN during autoneg
Message-ID: <20201021163424.GQ139700@lunn.ch>
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135802.GM139700@lunn.ch>
 <CA+U=DsoRVt66cANFJD896R-aOJseAF-1VkgcvLZHQ1rUTks3Eg@mail.gmail.com>
 <20201021141342.GO139700@lunn.ch>
 <CA+U=DsoEbrYn8i+GcLBzNHLY7xbKLOnZOLo00r7YwcQ_rXF94w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+U=DsoEbrYn8i+GcLBzNHLY7xbKLOnZOLo00r7YwcQ_rXF94w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> i'll think about the frame-generator;

Here were the two main problems i can remember with my first version:

How do you discover what is can actually do? You probably need to
collect up all the open PHY datasheets and get an idea what the
different vendors provide, what is common, what could be shared
extensions etc, and think about how you can describe the
capabilities. Probably a netlink call will be needed to return what
the hardware is capable of doing.

At the time, it was necessary to hold RTNL while performing packet
generation. That is bad, because it means most of the control plane
stops for all devices. We will need to copy some of the ideas from the
cable test to avoid this, adding a state to the state machine, etc.

      Andrew

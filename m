Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1137B249F54
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHSNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:13:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgHSNNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:13:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8NtJ-00A5Kz-Mp; Wed, 19 Aug 2020 15:12:33 +0200
Date:   Wed, 19 Aug 2020 15:12:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@savoirfairelinux.com" 
        <vivien.didelot@savoirfairelinux.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "opensource@vdorst.com" <opensource@vdorst.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>,
        "dqfext@gmail.com" <dqfext@gmail.com>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mt7530: Add the support of
 MT7531 switch
Message-ID: <20200819131233.GA2403519@lunn.ch>
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <e980fda45e0fb478f55e72765643bb641f352c65.1597729692.git.landen.chao@mediatek.com>
 <20200818160901.GF2330298@lunn.ch>
 <1597830248.31846.78.camel@mtksdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597830248.31846.78.camel@mtksdccf07>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In general, according to phy.rst, RGMII delay should be done by phy, but
> some MoCA product need RGMII delay in MAC. These two requirements
> conflict. Is there any suggestion to solve the conflict?

Implementing the delay in the PHY is just a recommendation, not a
requirement. However, as i said, you need to be careful what is pass
to phylib. If the MAC is implementing "rgmii-id", whatever makes it
way down to phy_attach_direct() needs to be "rgmii". If the MAC
implements "rgmii-rxid", the phy should be implementing "rgmii-txid",
etc. If this is wrong, you get both the MAC and the PHY implementing
delays, and bad things happen.

	Andrew

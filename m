Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67C62779CE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIXT5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:57:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXT5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 15:57:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLXMl-00G4IN-8C; Thu, 24 Sep 2020 21:57:19 +0200
Date:   Thu, 24 Sep 2020 21:57:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] e1000e: Increase iteration on polling MDIC ready bit
Message-ID: <20200924195719.GF3821492@lunn.ch>
References: <20200924150958.18016-1-kai.heng.feng@canonical.com>
 <20200924164542.19906-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924164542.19906-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 12:45:42AM +0800, Kai-Heng Feng wrote:
> We are seeing the following error after S3 resume:
> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
> ...
> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
> 
> As Andrew Lunn pointed out, MDIO has nothing to do with phy, and indeed
> increase polling iteration can resolve the issue.
> 
> The root cause is quite likely Intel ME, since it's a blackbox to the
> kernel so the only approach we can take is to be patient and wait
> longer.

Please could you explain how you see Intel ME being responsible for
this. I'm not convinced.

      Andrew

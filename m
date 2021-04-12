Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2784B35D409
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbhDLXlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:41:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237567AbhDLXlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:41:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW6AS-00GNdF-QW; Tue, 13 Apr 2021 01:40:32 +0200
Date:   Tue, 13 Apr 2021 01:40:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     system@metrotek.ru, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <YHTacMwlsR8Wl5q/@lunn.ch>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 03:16:59PM +0300, Ivan Bornyakov wrote:
> Some SFP modules uses RX_LOS for link indication. In such cases link
> will be always up, even without cable connected. RX_LOS changes will
> trigger link_up()/link_down() upstream operations. Thus, check that SFP
> link is operational before actual read link status.

Sorry, but this is not making much sense to me.

LOS just indicates some sort of light is coming into the device. You
have no idea what sort of light. The transceiver might be able to
decode that light and get sync, it might not. It is important that
mv2222_read_status() returns the line side status. Has it been able to
achieve sync? That should be independent of LOS. Or are you saying the
transceiver is reporting sync, despite no light coming in?

	Andrew

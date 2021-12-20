Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42147AF76
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbhLTPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:12:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239832AbhLTPKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 10:10:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o+thjTOWE2UYctdxFm/V9c9ypGKbYsRqLgLROtcw6dg=; b=52aW0ITSrUS0UfqYZXz6RZx2dZ
        uOMZ74/mUApufgGFeZmHOEqbMNI2VtvdTvEnsUQ+yQh960i83OQtGSQc84j/0csAA00w9VvdNvYaT
        2mOu2Y5B5oSITrP+1Mlg8SmxtnSKn5/71zjWZaL73W/HwjDSIViBo3WHtdRJ1cz1YAtk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzKJH-00H3Yj-31; Mon, 20 Dec 2021 16:10:43 +0100
Date:   Mon, 20 Dec 2021 16:10:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 3/3] phy: nxp-c45-tja11xx: read the tx timestamp without
 lock
Message-ID: <YcCc84XAlckpTnkF@lunn.ch>
References: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
 <20211220120859.140453-3-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220120859.140453-3-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 02:08:59PM +0200, Radu Pirea (NXP OSS) wrote:
> The tx timestamps are read from only one place in interrupt or polling
> mode. Locking the mutex is useless.

You cannot take a mutex in an interrupt handler. So your description
is probably not accurate.

Is it safe for other ptp operations to be performed in parallel with
reading the TX timestamp? _nxp_c45_ptp_settime64()?

	Andrew

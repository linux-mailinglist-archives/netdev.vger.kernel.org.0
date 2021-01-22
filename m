Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADEC3010C8
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbhAVXPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:15:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbhAVXPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:15:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l35dP-002A4R-NY; Sat, 23 Jan 2021 00:14:31 +0100
Date:   Sat, 23 Jan 2021 00:14:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>
Subject: Re: [PATCH] net: dp83tc811: fix link detection and possbile IRQ storm
Message-ID: <YAtcVw4hctU1Bv6E@lunn.ch>
References: <20210122150334.2378703-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122150334.2378703-1-mkl@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 04:03:34PM +0100, Marc Kleine-Budde wrote:
> In our setup the dp83tc811 is configure to master mode. When there is no slave
> connected the dp83tc811 triggers an interrupt is triggerd, several bits in the
> status registers are set, and te INT_N pin goes low. One of interrupt bits is
> the NO_FRAME interrupt.
> 
> Reading the status register acknowledges the interrupt, but as there is still
> no slave connected, the NO_FRAME interrupt stays set and the INT_N pin low. For
> level triggered IRQs this results in an interrupt storm, as long as the slave
> is not connected. For edge triggered interupts the link change event, when the
> slave comes online, is lost.
> 
> To fix this problem the NO_FRAME interrupt is not enabled. At least in our
> testcase with edge triggered interrupts link change events are now properly
> detected.
> 
> Cc: Dan Murphy <dmurphy@ti.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Hi Marc

Seems reasonable. Please add to your rebased version:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

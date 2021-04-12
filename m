Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A6135C6DE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbhDLM54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:57:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241506AbhDLM5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:57:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVw85-00GGXV-JZ; Mon, 12 Apr 2021 14:57:25 +0200
Date:   Mon, 12 Apr 2021 14:57:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <YHRDtTKUI0Uck00n@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
 <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 01:02:07PM +0300, Radu Nicolae Pirea (NXP OSS) wrote:
> On Fri, 2021-04-09 at 21:36 +0200, Andrew Lunn wrote:
> > On Fri, Apr 09, 2021 at 09:41:06PM +0300, Radu Pirea (NXP OSS) wrote:
> > > Add driver for tja1103 driver and for future NXP C45 PHYs.
> > 
> > So apart from c45 vs c22, how does this differ to nxp-tja11xx.c?
> > Do we really want two different drivers for the same hardware? 
> > Can we combine them somehow?
> It looks like the PHYs are the same hardware, but that's not entirely
> true. Just the naming is the same. TJA1103 is using a different IP and
> is having timestamping support(I will add it later).

Is the IP very different? You often see different generations of a PHY
supported by the same driver, if the generations are similar.

Does it support C22 or it is purely a C45 device?

> TJA is also not an Ethernet PHY series, but a general prefix for media
> interfaces including also CAN, LIN, etc.
> > 
> > > +config NXP_C45_PHY
> > > +       tristate "NXP C45 PHYs"
> > 
> > This is also very vague. So in the future it will support PHYs other
> > than the TJA series?
> Yes, in the future this driver will support other PHYs too.

Based on the same IP? Or different IP? Are we talking about 2 more
PHYs, so like the nxp-tja11xx.c will support 3 PHYs. And then the
tja1106 will come along and need a new driver? What will you call
that? I just don't like 'NXP C45 PHYs", it gives no clue as to what it
actually supports, and it gives you problems when you need to add yet
another driver.

At minimum, there needs to be a patch to add tja1102 to the help for
the nxp-tja11xx.c driver. And this driver needs to list tja1103.

    Andrew

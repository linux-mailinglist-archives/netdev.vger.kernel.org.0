Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD5127FF98
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgJAM5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:57:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbgJAM5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 08:57:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNy8p-00H4Aq-3L; Thu, 01 Oct 2020 14:56:59 +0200
Date:   Thu, 1 Oct 2020 14:56:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/3] net: atlantic: implement media
 detect feature via phy tunables
Message-ID: <20201001125659.GA4067422@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-4-irusskikh@marvell.com>
 <20200929171815.GD3996795@lunn.ch>
 <b43fb357-3fd1-c1a5-e2ff-894eb11c2bbb@marvell.com>
 <20200930142204.GK3996795@lunn.ch>
 <04e72671-aa3e-ac11-ef92-bb17fc633a60@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04e72671-aa3e-ac11-ef92-bb17fc633a60@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 01:18:06PM +0300, Igor Russkikh wrote:
> Hi Andrew,
> 
> > Since this is your own PHY, not some magical black box, i assume you
> > actually know what value it is using? It probably even lists it in the
> > data sheet.
> > 
> > So just hard code that value in the driver. That has got to be better
> > than saying the incorrect value of 1ms.
> 
> You mean always return that value in get_, and ignore what we get in set_ ?
> That could be done, will investigate.

You should validate the set as well. Only two values are valid, 0 to
turn the feature off, and whatever the firmware is hard coded with.

This is where extack would be very useful. When the user initially
tries to set it to 42, you can return -EINVAL, plus a message listing
the acceptable values. The best you can do at the moment is write the
text to the kernel log.

    Andrew

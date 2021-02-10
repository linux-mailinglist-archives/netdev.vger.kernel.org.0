Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EC2316A4E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhBJPfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:35:01 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:38982 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhBJPeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:34:36 -0500
Received: from [51.148.178.73] (port=61110 helo=pbcllap7)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l9rUx-00EDVI-Pu; Wed, 10 Feb 2021 15:33:47 +0000
Reply-To: <john.efstathiades@pebblebay.com>
From:   "John Efstathiades" <john.efstathiades@pebblebay.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com> <20210204113121.29786-5-john.efstathiades@pebblebay.com> <YBv6tF1caI7L96sW@lunn.ch>
In-Reply-To: <YBv6tF1caI7L96sW@lunn.ch>
Subject: RE: [PATCH net-next 4/9] lan78xx: disable MAC address filter before updating entry
Date:   Wed, 10 Feb 2021 15:33:27 -0000
Organization: Pebble Bay Consulting Ltd
Message-ID: <004c01d6ffc2$1fd9e400$5f8dac00$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIpfIuWVWp4oXxuaZJopfPMH/GLnQGxgSEzAcpu6O2pkKoi4A==
Content-Language: en-gb
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: 04 February 2021 13:46
> 
> On Thu, Feb 04, 2021 at 11:31:16AM +0000, John Efstathiades wrote:
> > Disable the station MAC address entry in the perfect address filter
> > table before updating the table entry with a new MAC address.
> 
> This seems like a real fix. Please base this on net, not net-next, and
> add a Fixes: tag.

Thanks, I'll do that.

> > -	/* Added to support MAC address changes */
> > -	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
> > -	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
> > +	/* The station MAC address in the perfect address filter table
> > +	 * must also be updated to ensure frames are received
> > +	 */
> > +	ret = lan78xx_write_reg(dev, MAF_HI(0), 0);
> > +	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
> > +	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
> 
> Why bother with ret is you are going to 1) overwrite it, 2) ignore it!

This is a side-effect of my rebase on the latest net-next tree and linked to
patch 9/9 in this set, which you also commented on.

I need to change the way I rebased my work on the latest driver code so this
goes away.

John


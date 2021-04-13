Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80A635E016
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345988AbhDMNbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:31:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhDMNbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:31:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWJ7l-00GTjP-9q; Tue, 13 Apr 2021 15:30:37 +0200
Date:   Tue, 13 Apr 2021 15:30:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@oss.nxp.com>
Cc:     "Radu-nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <YHWc/afcY3OXyhAo@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
 <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
 <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
 <YHRX7x0Nm9Kb0Kai@lunn.ch>
 <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
 <YHR6sXvW959zY22K@lunn.ch>
 <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 08:56:30AM +0200, Christian Herber wrote:
> Hi Andrew,
> 
> On 4/12/2021 6:52 PM, Andrew Lunn wrote:
> > 
> > So what you are say is, you don't care if the IP is completely
> > different, it all goes in one driver. So lets put this driver into
> > nxp-tja11xx.c. And then we avoid all the naming issues.
> > 
> >       Andrew
> > 
> 
> As this seems to be a key question, let me try and shed some more light on
> this.
> The original series of BASE-T1 PHYs includes TJA110, TJA1101, and TJA1102.
> They are covered by the existing driver, which has the unfortunate naming
> TJA11xx. Unfortunate, because the use of wildcards is a bit to generous.

Yes, that does happen.

Naming is difficult. But i really think nxp-c45.c is much worse. It
gives no idea at all what it supports. Or in the future, what it does
not support, and you actually need nxp-c45-ng.c.

Developers are going to look at a board, see a tja1XYZ chip, see the
nxp-tja11xx.c and enable it. Does the chip have a big C45 symbol on
it? Anything to give the idea it should use the nxp-c45 driver?

Maybe we should actually swing the complete opposite direction. Name
it npx-tja1103.c. There are lots of drivers which have a specific
name, but actually support a lot more devices. The developer sees they
have an tja1XYZ, there are two drivers which look about right, and
enable them both?

       Andrew

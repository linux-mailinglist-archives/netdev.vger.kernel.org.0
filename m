Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD62748445A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiADPNf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jan 2022 10:13:35 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:48883 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiADPNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:13:34 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 6C09024000B;
        Tue,  4 Jan 2022 15:13:32 +0000 (UTC)
Date:   Tue, 4 Jan 2022 16:13:31 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN
 management
Message-ID: <20220104161331.454f34c0@xps13>
In-Reply-To: <20220104070127.34af925f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-9-miquel.raynal@bootlin.com>
        <20211222125555.576e60b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220104154151.0d592bff@xps13>
        <20220104070127.34af925f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

kuba@kernel.org wrote on Tue, 4 Jan 2022 07:01:27 -0800:

> On Tue, 4 Jan 2022 15:41:51 +0100 Miquel Raynal wrote:
> > > On Wed, 22 Dec 2021 16:57:33 +0100 Miquel Raynal wrote:    
> > > > +/* Maximum number of PAN entries to store */
> > > > +static int max_pan_entries = 100;
> > > > +module_param(max_pan_entries, uint, 0644);
> > > > +MODULE_PARM_DESC(max_pan_entries,
> > > > +		 "Maximum number of PANs to discover per scan (default is 100)");
> > > > +
> > > > +static int pan_expiration = 60;
> > > > +module_param(pan_expiration, uint, 0644);
> > > > +MODULE_PARM_DESC(pan_expiration,
> > > > +		 "Expiration of the scan validity in seconds (default is 60s)");      
> > > 
> > > Can these be per-device control knobs? Module params are rarely the
> > > best answer.    
> > 
> > I believe we can do that on a per FFD device basis (for now it will be
> > on a per-device basis, but later when we will have the necessary
> > information we might do something more fine grained). Would a couple of
> > sysfs entries work?  
> 
> Is there no netlink object where this would fit? Sorry, I'm not at all
> familiar with WPAN. If it's orthogonal to current cfg802154 objects
> sysfs is fine, I guess.

Yes it's definitely possible to add a netlink arg for these two
parameters as well.

Thanks,
Miquèl

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC7192EA7
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgCYQuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:50:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:44612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbgCYQuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 12:50:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35A68ABC7;
        Wed, 25 Mar 2020 16:49:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BE3D0E0FD3; Wed, 25 Mar 2020 17:49:58 +0100 (CET)
Date:   Wed, 25 Mar 2020 17:49:58 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, o.rempel@pengutronix.de,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Subject: RFC: future of ethtool tunables (Re: [RFC][PATCH 1/2] ethtool: Add
 BroadRReach Master/Slave PHY tunable)
Message-ID: <20200325164958.GZ31519@unicorn.suse.cz>
References: <20200325101736.2100-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325101736.2100-1-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:17:35AM +0100, Marek Vasut wrote:
> Add a PHY tunable to select BroadRReach PHY Master/Slave mode.

IMHO this should be preceded by more general discussion about future of
ethtool tunables so I changed the subject and added people who were most
active in review of the ethtool netlink interface.

The way the ethtool tunables are designed rather feels like a workaround
for lack of extensibility of the ioctl interface. And at least in one
case (PFC stall timeout) it was actually the case:

  http://lkml.kernel.org/r/CAKHjkjkGWoeeGXBSNZCcAND3bYaNhna-q1UAp=8UeeuBAN1=fQ@mail.gmail.com

Thus it's natural to ask if we want to preserve the idea of assorted
tunables in the netlink interface and add more or if we rather prefer
adding new attributes and finding suitable place for existing tunables.
Personally, I like the latter more.

What might be useful, on the other hand, would be device specific
tunables: an interface allowing device drivers to define a list of
tunables and their types for each device. It would be a generalization
of private flags. There is, of course, the risk that we could end up
with multiple NIC vendors defining the same parameters, each under
a different name and with slightly different semantics.

Ideas and opinions are welcome.

Michal

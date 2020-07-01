Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076C82111A1
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgGARJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:09:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbgGARJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 13:09:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqgEi-003BGQ-Eg; Wed, 01 Jul 2020 19:09:28 +0200
Date:   Wed, 1 Jul 2020 19:09:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, nicolas.ferre@microchip.com
Subject: Re: [PATCH 1/2] net: dsa: microchip: set the correct number of ports
 in dsa_switch
Message-ID: <20200701170928.GE752507@lunn.ch>
References: <20200701165128.1213447-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701165128.1213447-1-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 07:51:27PM +0300, Codrin Ciubotariu wrote:
> The number of ports is incorrectly set to the maximum available for a DSA
> switch. Even if the extra ports are not used, this causes some functions
> to be called later, like port_disable() and port_stp_state_set(). If the
> driver doesn't check the port index, it will end up modifying unknown
> registers.
> 
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")

Hi Codrin

You don't indicate which tree this is for. net-next, or net?  It looks
like it fixes a real issue, so it probably should be for net. But
patches to net should be minimal. Is it possible to do the

	ds->num_ports = swdev->port_cnt;

without all the other changes? You can then have a refactoring patch
in net-next.

Thanks
	Andrew

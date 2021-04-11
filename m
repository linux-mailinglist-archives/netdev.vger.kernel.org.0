Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A49835B768
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 01:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhDKXRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 19:17:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235005AbhDKXRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 19:17:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVjJx-00GAPY-Us; Mon, 12 Apr 2021 01:16:49 +0200
Date:   Mon, 12 Apr 2021 01:16:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
Message-ID: <YHODYWgHQOuwoTf4@lunn.ch>
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 10:55:11PM +0200, Martin Blumenstingl wrote:
> Add support for .get_regs_len and .get_regs so it is easier to find out
> about the state of the ports on the GSWIP hardware. For this we
> specifically add the GSWIP_MAC_PSTATp(port) and GSWIP_MDIO_STATp(port)
> register #defines as these contain the current port status (as well as
> the result of the auto polling mechanism). Other global and per-port
> registers which are also considered useful are included as well.

Although this is O.K, there has been a trend towards using devlink
regions for this, and other register sets in the switch. Take a look
at drivers/net/dsa/mv88e6xxx/devlink.c.

There is a userspace tool for the mv88e6xxx devlink regions here:

https://github.com/lunn/mv88e6xxx_dump

and a few people have forked it and modified it for other DSA
switches. At some point we might want to try to merge the forks back
together so we have one tool to dump any switch.

	 Andrew

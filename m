Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5A82F7ED5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbhAOPBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:01:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbhAOPBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 10:01:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0QaJ-000lPb-V0; Fri, 15 Jan 2021 16:00:19 +0100
Date:   Fri, 15 Jan 2021 16:00:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
Message-ID: <YAGuA8O0lr19l5lH@lunn.ch>
References: <20210115134239.126152-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115134239.126152-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 02:42:39PM +0100, Marek Vasut wrote:
> When either the SPI or PAR variant is compiled as module AND the other
> variant is compiled as built-in, the following build error occurs:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
> 
> Fix this by including the ks8851_common.c in both ks8851_spi.c and
> ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
> does not have to be defined again.

DEBUG should not be defined for production code. So i would remove it
altogether.

There is kconfig'ury you can use to make them both the same. But i'm
not particularly good with it.

    Andrew

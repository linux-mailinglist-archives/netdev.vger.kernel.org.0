Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1153290E4F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 02:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411526AbgJQADI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 20:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411283AbgJPX4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 19:56:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10802221FD;
        Fri, 16 Oct 2020 23:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602892589;
        bh=80m1BtrIQ04KtTo/JzXUp4n2uLG0keqXtJQ/EmbzMdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JNY4wUaWdOy9r6l1BK1hP/4OFDPcxQ0YJGQ0ctcFB9mq79BcEDp9++Yu+ZOk2Z5jJ
         C2qERZTB3YtAneFKOvrenxi93kQQokfuxhm0Qbry1NTF0oztuaT+hJXYPqXQ9FJP59
         D7ErUbgDteep0056tL55DAvKVaZt8ZZVA99kOFXk=
Date:   Fri, 16 Oct 2020 16:56:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rdunlap@infradead.org,
        Jose.Abreu@synopsys.com, andrew@lunn.ch, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org
Subject: Re: [PATCH net-next] net: pcs-xpcs: depend on MDIO_BUS instead of
 selecting it
Message-ID: <20201016165627.1d5ddf5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015200023.15746-1-ioana.ciornei@nxp.com>
References: <20201015200023.15746-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 23:00:23 +0300 Ioana Ciornei wrote:
> The below compile time error can be seen when PHYLIB is configured as a
> module.
> 
>  ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_read':
>  pcs-xpcs.c:(.text+0x29): undefined reference to `mdiobus_read'
>  ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_soft_reset.constprop.7':
>  pcs-xpcs.c:(.text+0x80): undefined reference to `mdiobus_write'
>  ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_config_aneg':
>  pcs-xpcs.c:(.text+0x318): undefined reference to `mdiobus_write'
>  ld: pcs-xpcs.c:(.text+0x38e): undefined reference to `mdiobus_write'
>  ld: pcs-xpcs.c:(.text+0x3eb): undefined reference to `mdiobus_write'
>  ld: pcs-xpcs.c:(.text+0x437): undefined reference to `mdiobus_write'
>  ld: drivers/net/pcs/pcs-xpcs.o:pcs-xpcs.c:(.text+0xb1e): more undefined references to `mdiobus_write' follow
> 
> PHYLIB being a module leads to MDIO_BUS being a module as well while the
> XPCS is still built-in. What should happen in this configuration is that
> PCS_XPCS should be forced to build as module. However, that select only
> acts in the opposite way so we should turn it into a depends.
> 
> Fix this up by explicitly depending on MDIO_BUS.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> Fixes: 2fa4e4b799e1 ("net: pcs: Move XPCS into new PCS subdirectory")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks!

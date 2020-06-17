Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F51F1FD23A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgFQQcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgFQQcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:32:20 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D98321527;
        Wed, 17 Jun 2020 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411539;
        bh=dosVYB527BP5Srr/9fHV6NJgxLs2rmKgkXamravjVTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gR3iYqxi/8pnlX85JZRtonRYglAcXRG48QIbQKHqB25TmMgQpFmEx6LddT/XI9CDq
         CLpyGHk9BimZuu8alat9WAWRhy5iVT4d1Mf1S0LlP4V1Udh+Bk3fwb5CNsIn4Wa3zV
         V1Eeua8z2rScaFbRk0dARUhwm4NqJLLqsinwka/k=
Date:   Wed, 17 Jun 2020 09:32:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net
Subject: Re: [PATCH net-next v2 6/8] net: phy: mscc: timestamping and PHC
 support
Message-ID: <20200617093217.2a664161@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617133127.628454-7-antoine.tenart@bootlin.com>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com>
        <20200617133127.628454-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 15:31:25 +0200 Antoine Tenart wrote:
> This patch adds support for PHC and timestamping operations for the MSCC
> PHY. PTP 1-step and 2-step modes are supported, over Ethernet and UDP.
> 
> To get and set the PHC time, a GPIO has to be used and changes are only
> retrieved or committed when on a rising edge. The same GPIO is shared by
> all PHYs, so the granularity of the lock protecting it has to be
> different from the ones protecting the 1588 registers (the VSC8584 PHY
> has 2 1588 blocks, and a single load/save pin).
> 
> Co-developed-by: Quentin Schulz <quentin.schulz@bootlin.com>
> Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

drivers/net/phy/mscc/mscc_ptp.c:406:24: warning: restricted __be16 degrades to integer
drivers/net/phy/mscc/mscc_ptp.c:407:24: warning: restricted __be16 degrades to integer
drivers/net/phy/mscc/mscc_ptp.c:1213:23: warning: symbol 'vsc85xx_clk_caps' was not declared. Should it be static?

Please make sure you don't add warnings when built with W=1 C=1 flags.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CC945F4C4
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241679AbhKZSmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243806AbhKZSkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:40:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCD9C0613FE;
        Fri, 26 Nov 2021 10:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94DC7B82869;
        Fri, 26 Nov 2021 18:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D37C93056;
        Fri, 26 Nov 2021 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637950373;
        bh=lTa9Y0/ejMx8gFkjVpdlFhYxyZgVE6QzlU94i0kFQO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NyubaV9eW/86kaB3aZ6mMSaT0WYPJDu1achGQOmCZt5Z4KThvbIoKl+ocvlOfyTKM
         eB6OV0S7Wn2poiasMX1LViieDuxtamikmB4RSMRnMJPJSUQGYE8JpwkSKvwetUDBIW
         qq0Fts150EygbAIXXpfyVRZ7b5Y9iZN51IlELlZzB1sZ+0D03IntttNOP4nTIV+PqW
         btz4q2QBakRxp8n0zZLHkczQR6goONCgledGaxtr0PHOGPgxUXTHD3iFyaj5QYPQ0T
         2i8Mi9tlsl8xA67W2TMQxETi5K3lOyNr9KXtxedJWLRQx7SZc3/OUp2ztqw3QQUfRl
         nXeth8X9jeS1w==
Date:   Fri, 26 Nov 2021 10:12:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 3/6] net: lan966x: add port module support
Message-ID: <20211126101251.3dceb6f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126090540.3550913-4-horatiu.vultur@microchip.com>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
        <20211126090540.3550913-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 10:05:37 +0100 Horatiu Vultur wrote:
> This patch adds support for netdev and phylink in the switch. The
> injection + extraction is register based. This will be replaced with DMA
> accees.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Clang sees issues here:

drivers/net/ethernet/microchip/lan966x/lan966x_main.c:409:8: warning: variable 'sz' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
                       if (err != 4)
                           ^~~~~~~~
drivers/net/ethernet/microchip/lan966x/lan966x_main.c:469:7: note: uninitialized use occurs here
               if (sz < 0 || err)
                   ^~
drivers/net/ethernet/microchip/lan966x/lan966x_main.c:409:4: note: remove the 'if' if its condition is always false
                       if (err != 4)
                       ^~~~~~~~~~~~~
drivers/net/ethernet/microchip/lan966x/lan966x_main.c:403:9: note: initialize the variable 'sz' to silence this warning
               int sz, buf_len;
                     ^
                      = 0

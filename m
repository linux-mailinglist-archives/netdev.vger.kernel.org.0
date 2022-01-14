Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6848E7C7
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 10:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbiANJql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 04:46:41 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:5167 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbiANJqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 04:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1642153600; x=1673689600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NNHPlTD0ftd7Yo4ZkVXD/Gn+srTlO5apnHVNSJQo2B8=;
  b=lrOjnFoEAQd2pTzpTHiRuJ6lC69NAkEWne9iyx9K24HzBc+xzaB6l1Tr
   CCvidFMKncewl2UdJYGTg8xgOzdO6tRbpEbqysTdZtE0z/ZomdpX1v7tZ
   8mgUSRfkXqrSJYJMqmtLTrBqT2KfkUr46sALGYIRUijYjlZG95JisZRM7
   FBJQcvhJNbiEozNzWi8rlhTReeEtOQVpxmZSQo+34p5CRqn1GERCX2iWT
   cJpN8KmHMcIv0D08g1ccHwTS0ZpWSELBLdbesMcNlGPImSJfx7dDVhyLm
   8CyaX6T3dv1LMiDW5EdXUReCR21e8dfBWq6OC/BAz1Qf3wShQxNEgtw6k
   g==;
X-IronPort-AV: E=Sophos;i="5.88,288,1635199200"; 
   d="scan'208";a="21502572"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 14 Jan 2022 10:46:39 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 14 Jan 2022 10:46:39 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 14 Jan 2022 10:46:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1642153599; x=1673689599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NNHPlTD0ftd7Yo4ZkVXD/Gn+srTlO5apnHVNSJQo2B8=;
  b=XmH3xUwV8P37+HKt9OalpH9XzYJRsNr6i4PkhGoMUQtzIDfOwVCgQYzn
   NkW344cf1M3I73f1xkZ9dz32vTmfWEewYGJEWEqxeAHDjgCObHPvBmwf1
   Wl98uasJbrTMMakM2U9vb0qbHLNNsujhzAnxt8LE5cZR0N5S1uyXUMR5G
   9ZVfRMI+8znpaz14wRQo7C3QeM/NFQtoldcs4zPfcQnYca684iKYuTfbh
   3XHwmuTimjiBmhz69VMic8bQ48haxgUQ8QTPTTOxFBwHL58iffP0SlD7H
   EY32LZyDliGcvQVxW02fpxxIMJxXkqju1nnJrPeTYhm32VNnavtAaAdRH
   A==;
X-IronPort-AV: E=Sophos;i="5.88,288,1635199200"; 
   d="scan'208";a="21502571"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 14 Jan 2022 10:46:39 +0100
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id B843E280065;
        Fri, 14 Jan 2022 10:46:38 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martyn Welch <martyn.welch@collabora.com>,
        Markus Reichl <m.reichl@fivetechno.de>
Cc:     Markus Reichl <m.reichl@fivetechno.de>,
        Gabriel Hojda <ghojda@yo2urs.ro>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: Correct reset handling of smsc95xx
Date:   Fri, 14 Jan 2022 10:46:38 +0100
Message-ID: <3127264.ElGaqSPkdT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20220113200113.30702-1-m.reichl@fivetechno.de>
References: <20220113200113.30702-1-m.reichl@fivetechno.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Markus,

Am Donnerstag, 13. Januar 2022, 21:01:11 CET schrieb Markus Reichl:
> On boards with LAN9514 and no preconfigured MAC address we don't get an
> ip address from DHCP after commit a049a30fc27c ("net: usb: Correct PHY
> handling of smsc95xx") anymore. Adding an explicit reset before starting
> the phy fixes the issue.
> 
> [1]
> https://lore.kernel.org/netdev/199eebbd6b97f52b9119c9fa4fd8504f8a34de18.came
> l@collabora.com/
> 
> From: Gabriel Hojda <ghojda@yo2urs.ro>
> Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
> Signed-off-by: Gabriel Hojda <ghojda@yo2urs.ro>
> Signed-off-by: Markus Reichl <m.reichl@fivetechno.de>
> ---
>  drivers/net/usb/smsc95xx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index abe0149ed917..bc1e3dd67c04 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1962,7 +1962,8 @@ static const struct driver_info smsc95xx_info = {
>  	.bind		= smsc95xx_bind,
>  	.unbind		= smsc95xx_unbind,
>  	.link_reset	= smsc95xx_link_reset,
> -	.reset		= smsc95xx_start_phy,
> +	.reset		= smsc95xx_reset,
> +	.check_connect	= smsc95xx_start_phy,
>  	.stop		= smsc95xx_stop,
>  	.rx_fixup	= smsc95xx_rx_fixup,
>  	.tx_fixup	= smsc95xx_tx_fixup,

Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>

This should go into stable-5.15!

Tested on a TQMa6x on MBa6 which uses a SMSC9500 as a second ethernet 
interface.
For the record: I noticed the problem as ARP replies were sent from the wrong 
interface. Thus my PC got the wrong MAC address which failed ping in the end.

Best regards,
Alexander




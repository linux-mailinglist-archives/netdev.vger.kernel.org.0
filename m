Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A354612FF
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242048AbhK2LC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:02:56 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23654 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354716AbhK2LA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638183459; x=1669719459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sni8GEGNKRIzcmDyxT+3sx8vltkStccv50jQbBQNb9I=;
  b=QvDMPLAjTlCCnNnZjHTanmr6Ornj5sayYQOaF5Bg843lufgcaP/JDoe7
   3QGy9RYlciBxeGDbjZPoVP9/Gwy0nfFbKqHBMRLuiCAngx61fPH7qunV6
   MZvjI7wDSO6eyZ1sB/LLaIQDMo/hzwLM/Bdkx989RTCDXzqQbBGBVf8Qt
   fhr3quFBybdBJJde1cFXPzp9gr6bgyRg2Bu5v60K8OF1eLjyoqPhj9X5M
   PrxD08nTwm+jdLQvMlDbWO6hLQRyXeKwHwDCeRsLJ7o0RWnPctdhsoOEj
   fpeWjBwBCF3CrUXqGAJA9ewZfuTe4eR8xlRBwD+zRqyH13swNUE7dG9Vi
   w==;
IronPort-SDR: pC9Mo1j3FSmWnO+dJz+sdo/h8/5YPxGZu/adW1G8JBTs9GQOUA5AIyOTg1I3h6dP4CcPh/+FBK
 14Ts3BA/nMQlFwRz2GP3LA7Ijf6SYeQRGAc7XWTxS9gFODzdLErHNETvd5PHWNQKHds+A6IU+O
 cvJORXOhzGAFA/JNVu49ctwGxj2KJcHlRZfE96tafhPleIWUEzKcUGcB9z7HnAZuL4NO5WDh3S
 W63evdf8YPbcG9b6t0WEN6n0FJTRoSYYoaDdRQvr2txxITgPKrIJ8SbMYiwuqONcE3JNrYCjij
 3Y0VkNrK17hU/S8CxHTXSd8U
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="140560457"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 03:57:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 03:57:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 29 Nov 2021 03:57:30 -0700
Date:   Mon, 29 Nov 2021 11:59:26 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 3/6] net: lan966x: add port module support
Message-ID: <20211129105926.4k6itzqakeu7znbw@soft-dev3-1.localhost>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
 <20211126090540.3550913-4-horatiu.vultur@microchip.com>
 <20211126101251.3dceb6f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211126101251.3dceb6f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/26/2021 10:12, Jakub Kicinski wrote:

Hi Jakub,

> 
> On Fri, 26 Nov 2021 10:05:37 +0100 Horatiu Vultur wrote:
> > This patch adds support for netdev and phylink in the switch. The
> > injection + extraction is register based. This will be replaced with DMA
> > accees.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> Clang sees issues here:
> 
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:409:8: warning: variable 'sz' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>                        if (err != 4)
>                            ^~~~~~~~
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:469:7: note: uninitialized use occurs here
>                if (sz < 0 || err)
>                    ^~
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:409:4: note: remove the 'if' if its condition is always false
>                        if (err != 4)
>                        ^~~~~~~~~~~~~
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:403:9: note: initialize the variable 'sz' to silence this warning
>                int sz, buf_len;
>                      ^
>                       = 0

Thanks for notification.
I should definitely need to start to build the kernel using Clang.


-- 
/Horatiu

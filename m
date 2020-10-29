Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D573B29E441
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgJ2HfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbgJ2HY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:58 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13658C0604DE;
        Wed, 28 Oct 2020 23:11:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5CF581409B1;
        Thu, 29 Oct 2020 07:11:23 +0100 (CET)
Date:   Thu, 29 Oct 2020 07:11:16 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, ashkan.boldaji@digi.com
Subject: Re: [PATCH v6 2/4] net: phy: Add 5GBASER interface mode
Message-ID: <20201029071116.42b4bd94@nic.cz>
In-Reply-To: <9b93cc79d7cc07ee77808150ca76c9d243c8ca60.1603944740.git.pavana.sharma@digi.com>
References: <cover.1603944740.git.pavana.sharma@digi.com>
        <9b93cc79d7cc07ee77808150ca76c9d243c8ca60.1603944740.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:42:00 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> Add new mode supported by MV88E6393 family.
> 

This commit message isn't ideal. It infers that the Amethyst is first
such device to implement this mode, which is not true. The 5gbase-r mode
is supported by various other hardware, for example Marvell's 88X3310
PHY. Just say:
  Add 5gbase-r PHY interface mode.

>  	PHY_INTERFACE_MODE_2500BASEX,
>  	PHY_INTERFACE_MODE_RXAUI,
>  	PHY_INTERFACE_MODE_XAUI,
> +	PHY_INTERFACE_MODE_5GBASER,
>  	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
>  	PHY_INTERFACE_MODE_10GBASER,
>  	PHY_INTERFACE_MODE_USXGMII,

The position is IMO out of order. RXAUI and XAUI are both 10G modes, so
5gbase-r should be between 2500base-x and rxaui.

> @@ -187,6 +188,8 @@ static inline const char *phy_modes(phy_interface_t interface)
>  		return "rxaui";
>  	case PHY_INTERFACE_MODE_XAUI:
>  		return "xaui";
> +	case PHY_INTERFACE_MODE_5GBASER:
> +		return "5gbase-r";
>  	case PHY_INTERFACE_MODE_10GBASER:
>  		return "10gbase-r";
>  	case PHY_INTERFACE_MODE_USXGMII:

Here as well.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573ED134AF6
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgAHSvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:51:15 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40654 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgAHSvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:51:14 -0500
Received: by mail-ed1-f65.google.com with SMTP id b8so3466516edx.7;
        Wed, 08 Jan 2020 10:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vethsP9E50DdWtICMPOkuQ6goKBYP2RJVrPlIQmJTMg=;
        b=XC5Zexf92SHypxHLvMmBI5w3FSHrSw3ChtdI2OF27PsAQbEUToKMp47NP0PJ5PZ4iO
         qvwclnwMcEmolMZ6JZwM2h3Ed7tAM0PZau2FG9JHoPmjAZlIJcgEnec56iw+K1AJIc8q
         adJ3qNq+HyYQiWySRj9+wQBXeJJV+9w8gUIJdUvR9SsRt7HrCnQf4ldX0KTSdZCxNRuJ
         qsd8FjWUJdfKQHqU+PoF+W+sYuDCW4BHUlPhd+hpwh+SYYbaSSgA2xMDB//uELrSoLRj
         LGwvQij5PnNS7eVmZjSVWF42QOkdTi0WFP6ZOdKO+o2LlFlc03BfqaTGx/3yZPUqwSYf
         /zeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vethsP9E50DdWtICMPOkuQ6goKBYP2RJVrPlIQmJTMg=;
        b=JMILJDm5sH62/DlqVg5yBXozlrSoiiyjkaCWDrxHLH+qF4PZhUqQhpGn10VSfclIBB
         wCmZmGDyPQu4baXYQl784elu7TAErDIKx4wjFV+nFTaQLDv3fytlu939trNI8jOwApxq
         yv0q/HlheJI9iAS9nDwDpAxzuENSWWmxbY8RRUCYphkDBY1Qvpyek7SPlY70P/NqDfes
         nn9nqBTtYCwMXj9I7s/Z39j3W+MBhX9vTbC/WLu5uFCQTArCfti+GXEYX1OOBfUXdVkA
         TqW59Kepe9OIqttwnTLOpW8pZcBdmAotINoaytAKuIxV2nUJtQjkMt5DMatyvgxLNfy0
         yFFw==
X-Gm-Message-State: APjAAAV1FsYVcJ+mBD48GvYReSUt+bxSZivoyS9c3Ot2u/A/50XGivyw
        e5+eGczryR6p8GVRXThU/Aqmh5rhTLNbwlPDgDMHS3uc
X-Google-Smtp-Source: APXvYqxj9WY6aFVY3QGDoy++bN3UIyzQmXGjf5q5b/ajYlIkYPYGNiUR8mdoppRNAUFyfzun/A2+8RJzsqQCeEQWPTE=
X-Received: by 2002:a05:6402:311b:: with SMTP id dc27mr7182618edb.36.1578509472684;
 Wed, 08 Jan 2020 10:51:12 -0800 (PST)
MIME-Version: 1.0
References: <20200108124844.1348395-1-arnd@arndb.de>
In-Reply-To: <20200108124844.1348395-1-arnd@arndb.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 8 Jan 2020 20:51:01 +0200
Message-ID: <CA+h21hqy6mK-Cy0VyXtDUtPqvqbTPGZ45aJ2eko+VQFzjDbtKg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: felix: fix link error
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Arnd!

On Wed, 8 Jan 2020 at 14:59, Arnd Bergmann <arnd@arndb.de> wrote:
>
> When the enetc driver is disabled, the mdio support fails to
> get built:
>
> drivers/net/dsa/ocelot/felix_vsc9959.o: In function `vsc9959_mdio_bus_alloc':
> felix_vsc9959.c:(.text+0x19c): undefined reference to `enetc_hw_alloc'
> felix_vsc9959.c:(.text+0x1d1): undefined reference to `enetc_mdio_read'
> felix_vsc9959.c:(.text+0x1d8): undefined reference to `enetc_mdio_write'
>
> Change the Makefile to enter the subdirectory for this as well.
>
> Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")

I agree the patch is only seen with the commit you pointed to, but the
problem is also introduced by:

Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and
export to include/linux/fsl")

[ please excuse me David, I don't know how to configure neither Gmail
nor Thunderbird to disable word wrapping ]

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/freescale/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
> index 6a93293d31e0..67c436400352 100644
> --- a/drivers/net/ethernet/freescale/Makefile
> +++ b/drivers/net/ethernet/freescale/Makefile
> @@ -25,4 +25,5 @@ obj-$(CONFIG_FSL_DPAA_ETH) += dpaa/
>  obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
>
>  obj-$(CONFIG_FSL_ENETC) += enetc/
> +obj-$(CONFIG_FSL_ENETC_MDIO) += enetc/
>  obj-$(CONFIG_FSL_ENETC_VF) += enetc/
> --
> 2.20.0
>

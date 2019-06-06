Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4604037152
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfFFKLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:11:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:53770 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfFFKLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ntYG98vIw8SBks2+iwma4fYIuw+qJBNTLrhwVKHXBpE=; b=WzStA+HhR1uA1MUXet6UrpqTpy
        6OWCYEZ2rzB7yeao3BJZlP9JARMqc03xXe16Pze/mZN+VfJDR3l+j6MblckY71dbh01iCmrk6hyEp
        +TZ6ORl3qXfMGqCUwdk35jbb0lL+KzwQjxxYAbqa0MIXMzsvMKc2SB5RkSyLfPl64EbpLBN3FGBkH
        06sOh9Ey2LlY65ZqrAjIDR7ZftncTdYx/5Dbv+f96ihOwBj+QMA+48U3ZdNDs1AsSN5zrKAhrJxS6
        itveatFisKOxU6ltd2vsRJlfF2MzVklRTyxpj4f2ZXJhq7R6aNn1BeD4lVtW/gyLKbnNjMo9edQBO
        edOlIAVA==;
Received: from [179.182.172.34] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYpMM-0005DZ-4y; Thu, 06 Jun 2019 10:11:02 +0000
Date:   Thu, 6 Jun 2019 07:10:52 -0300
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        marex@denx.de, stefan@agner.ch, airlied@linux.ie, daniel@ffwll.ch,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        b.zolnierkie@samsung.com, a.hajda@samsung.com,
        p.zabel@pengutronix.de, hkallweit1@gmail.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8] fix warnings for same module names
Message-ID: <20190606071052.412a766d@coco.lan>
In-Reply-To: <20190606094657.23612-1-anders.roxell@linaro.org>
References: <20190606094657.23612-1-anders.roxell@linaro.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu,  6 Jun 2019 11:46:57 +0200
Anders Roxell <anders.roxell@linaro.org> escreveu:

> Hi,
> 
> This patch set addresses warnings that module names are named the
> same, this may lead to a problem that wrong module gets loaded or if one
> of the two same-name modules exports a symbol, this can confuse the
> dependency resolution. and the build may fail.
> 
> 
> Patch "drivers: net: dsa: realtek: fix warning same module names" and
> "drivers: net: phy: realtek: fix warning same module names" resolves the
> name clatch realtek.ko.
> 
> warning: same module names found:
>   drivers/net/phy/realtek.ko
>   drivers/net/dsa/realtek.ko
> 
> 
> Patch  "drivers: (video|gpu): fix warning same module names" resolves
> the name clatch mxsfb.ko.
> 
> warning: same module names found:
>   drivers/video/fbdev/mxsfb.ko
>   drivers/gpu/drm/mxsfb/mxsfb.ko
> 
> Patch "drivers: media: i2c: fix warning same module names" resolves the
> name clatch adv7511.ko however, it seams to refer to the same device
> name in i2c_device_id, does anyone have any guidance how that should be
> solved?
> 
> warning: same module names found:
>   drivers/gpu/drm/bridge/adv7511/adv7511.ko
>   drivers/media/i2c/adv7511.ko
> 
> 
> Patch "drivers: media: coda: fix warning same module names" resolves the
> name clatch coda.ko.
> 
> warning: same module names found:
>   fs/coda/coda.ko
>   drivers/media/platform/coda/coda.ko

Media change look ok, and probably the other patches too, but the
problem here is: who will apply it and when.

The way you grouped the changes makes harder for subsystem maintainers
to pick, as the same patch touches multiple subsystems.

On the other hand, if this gets picked by someone else, it has the
potential to cause conflicts between linux-next and the maintainer's
tree.

So, the best would be if you re-arrange this series to submit one
patch per subsystem.


> 
> 
> Patch "drivers: net: phy: fix warning same module names" resolves the
> name clatch asix.ko.
> 
> warning: same module names found:
>   drivers/net/phy/asix.ko
>   drivers/net/usb/asix.ko
> 
> Patch "drivers: mfd: 88pm800: fix warning same module names" and
> "drivers: regulator: 88pm800: fix warning same module names" resolves
> the name clatch 88pm800.ko.
> 
> warning: same module names found:
>   drivers/regulator/88pm800.ko
>   drivers/mfd/88pm800.ko
> 
> 
> Cheers,
> Anders
> 
> Anders Roxell (8):
>   drivers: net: dsa: realtek: fix warning same module names
>   drivers: net: phy: realtek: fix warning same module names
>   drivers: (video|gpu): fix warning same module names
>   drivers: media: i2c: fix warning same module names
>   drivers: media: coda: fix warning same module names
>   drivers: net: phy: fix warning same module names
>   drivers: mfd: 88pm800: fix warning same module names
>   drivers: regulator: 88pm800: fix warning same module names
> 
>  drivers/gpu/drm/bridge/adv7511/Makefile | 10 +++++-----
>  drivers/gpu/drm/mxsfb/Makefile          |  4 ++--
>  drivers/media/i2c/Makefile              |  3 ++-
>  drivers/media/platform/coda/Makefile    |  4 ++--
>  drivers/mfd/Makefile                    |  7 +++++--
>  drivers/net/dsa/Makefile                |  4 ++--
>  drivers/net/phy/Makefile                |  6 ++++--
>  drivers/regulator/Makefile              |  3 ++-
>  drivers/video/fbdev/Makefile            |  3 ++-
>  9 files changed, 26 insertions(+), 18 deletions(-)
> 



Thanks,
Mauro

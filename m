Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B6E16F0E1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgBYVJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:09:48 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40410 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgBYVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:09:48 -0500
Received: by mail-ed1-f67.google.com with SMTP id p3so1046715edx.7;
        Tue, 25 Feb 2020 13:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ReknaT/FHBXByMXGGadMEzL/WYd/+sCy+KAJpp5ZwQ=;
        b=g6gfdjSUOo1daNt5JbO1OW+lwH1wDg11Aag/ldGmhkKkxyuiYo8+Th2fgxoAQQ4hXq
         TRfwhYem3PhxViqcWuVx+VibsoPJtyTVagbuspEnHeQYaT2u/LwJMeu3LbXXCD0Gb+P0
         kRLDLX6J05YQ2Y8hv4+QoX7W+8th93s38oDKyijo7aUk+0WA/Q35uUeEjwKyuKG1sJKb
         pHrmZYL+Ul2ujJ6ECXARZynFXSJa6Fk0D+GxbQh8iZeV9tRAEnb/IR6xJlRYeIfUjO0K
         m+I0aO92UvVW8NrmhRC7I6GzDK8oveynokyluJrJ/ckLFboCtOu9kXc5lv28q9nFAWd2
         pQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ReknaT/FHBXByMXGGadMEzL/WYd/+sCy+KAJpp5ZwQ=;
        b=o7YXXDxcoddy8+rCo+AszsSPtP3y2nym6aTxInR01gLGUkDcCiQduLPEwhQJO+AhD4
         74qaUbW+bw+lB2zglHEdxASxtX10pgiERyGAZXYt4sb1cGT9+2Fl4hyRcHkKvCL28+ur
         wLgdP+LtV9Y2g2WOuyRp46lYUNuhwpIx+QElTbzhlKXRd/m7UZ7oCvccyZR5bpiVjnLZ
         /Gz/JySOYKklOpsVmoO/ya9+gCXynCnZ6AFHeNS/s5zkVfg4vAlqBbImTmHVgAFbsqdO
         uiH9z3UdXiT1GIdp5B/dYXrTLGYw7dyLxQY/iC6cnc+8l8UBkruI9P/DOTyT7LNTDXwZ
         vhlQ==
X-Gm-Message-State: APjAAAXSrE3dYsXcwMRXL4M00Z9wZHKxHIYtgKx2UfmGnmKUA/CPuEWj
        kFNoEMw5Ojnp7GvER17pb/NwY//1u6cg8n+6y/c=
X-Google-Smtp-Source: APXvYqyAzVm/wNR8w7wh+lAC7aHiC7zE7iGdWgqO+BLhvYvGS2dy2yiQw4bZhX/VBimWuHByQuf8RvIEP4SD4vbjH9A=
X-Received: by 2002:a05:6402:128c:: with SMTP id w12mr909815edv.368.1582664986639;
 Tue, 25 Feb 2020 13:09:46 -0800 (PST)
MIME-Version: 1.0
References: <20200225093703.GS25745@shell.armlinux.org.uk> <E1j6Wg0-0000Ss-W7@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j6Wg0-0000Ss-W7@rmk-PC.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Feb 2020 23:09:35 +0200
Message-ID: <CA+h21hp8KCqhCasOAGz17k0eRteHVVYK-eANQmn4h443qv=2JQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/8] net: dsa: propagate resolved link config via mac_link_up()
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 25 Feb 2020 at 11:39, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Propagate the resolved link configuration down via DSA's
> phylink_mac_link_up() operation to allow split PCS/MAC to work.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/b53/b53_common.c       | 4 +++-
>  drivers/net/dsa/b53/b53_priv.h         | 4 +++-
>  drivers/net/dsa/bcm_sf2.c              | 4 +++-
>  drivers/net/dsa/lantiq_gswip.c         | 4 +++-
>  drivers/net/dsa/mt7530.c               | 4 +++-
>  drivers/net/dsa/mv88e6xxx/chip.c       | 4 +++-
>  drivers/net/dsa/sja1105/sja1105_main.c | 4 +++-
>  include/net/dsa.h                      | 4 +++-
>  net/dsa/port.c                         | 3 ++-
>  9 files changed, 26 insertions(+), 9 deletions(-)
>

It looks like you missed the felix_phylink_mac_link_up() conversion in
this patch? (which also makes it fail to build, by the way, I'm
supposed the Kbuild robot didn't already jump)
Nonetheless, I've manually added the missing speed, duplex, tx_pause
and rx_pause parameters, and it appears to work as before.
Same for sja1105.

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Regards,
-Vladimir

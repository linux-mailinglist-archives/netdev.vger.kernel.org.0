Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5943765C302
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbjACPb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbjACPbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:31:40 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2A711C03;
        Tue,  3 Jan 2023 07:31:39 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id t17so74516071eju.1;
        Tue, 03 Jan 2023 07:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UgDazkHViQhWU/TunvfaQ9iyJmO3IaGLASV26ikc1bQ=;
        b=icul13x0uv7tdn+CDDNJgBI8ANu2swmQ+j/S7khtaaizhpP6YJ8yCDtvTjy9054OIJ
         m50rAZtY1ECCqmPdK8FXMzyCVBjs6ee4IG9N2sPL+49qhAIk2CgM9NLB8egs727JGpIY
         R4mVjuYMaUUcWnM1hu/majQCmctkAG7JS0dIelHEbT9uEb/nq1KIvjfZaf3jJnoLTmAc
         8YuEwo4nss+x72k4B061kFIMaUKrnk213mewTNWGiRDK+GmwLwFl9qqeD2WjUH/lFDb3
         fSwq5J4tuJ4a0/Kvoadve0vZn15i/tp4fG9mhsURN0alGVLP3f2km9q/qTPDwh++JYip
         /gFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgDazkHViQhWU/TunvfaQ9iyJmO3IaGLASV26ikc1bQ=;
        b=zYH0fn3Mwo+J9Xf4kXHrT10C0fFuCo0nHN7SDOvnupvCZLK9PUKBNbRGF5dta0uSBk
         3Md+4G1yvX+s8Bq+X00VHWeIyC7jGNRVQ+/trp7wwFOD7C7EP3lWELDXc1ytWsYknQLY
         fh6xC699pxe5tN4WkwlV/bg54g1uQL6A4vSfoS+L3b0Z31ElMwHTSXtUXSZEUpwdfgrG
         5Ux2iAyd8ad3qul49j6fihW2clSsHcmFBlRnFjMzdr/VlO/gIb/XmPgqus+Ro3Y581a1
         VhDU9jJ0zHaQH4XiiH+mYdpQTeQJp5UVoLX1Gj2g2gWrIeDqSKSxuFRlvPmP74SAhg+k
         DQLw==
X-Gm-Message-State: AFqh2krwIfv8WcRCN95UYz707kgW8tvdlWOzQYG0KqEeN2BVbWF+SZ54
        HRUnX4ErJk28XtnBKzSdC2c=
X-Google-Smtp-Source: AMrXdXuqP8wyCQk/DQhn11BesM+10k5E+i0pNTziFhxYhIjlbS2WAZpdpMZf4Gvw7lEjZVKjkoFQ0A==
X-Received: by 2002:a17:906:910:b0:7ad:aed7:a5da with SMTP id i16-20020a170906091000b007adaed7a5damr50137194ejd.28.1672759897827;
        Tue, 03 Jan 2023 07:31:37 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709060dcb00b00782fbb7f5f7sm14014838eji.113.2023.01.03.07.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 07:31:37 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:31:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 11/12] net: dsa: Separate C22 and C45
 MDIO bus transaction methods
Message-ID: <20230103153134.utalc6kw3l34dp4s@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-11-ddb37710e5a7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 12:07:27AM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> By adding _c45 function pointers to the dsa_switch_op structure, the
> dsa core can register an MDIO bus with C45 accessors.
> 
> The dsa-loop driver could in theory provide such accessors, since it
> just passed requests to the MDIO bus it is on, but it seems unlikely
> to be useful at the moment. It can however be added later.
> 
> mt7530 does support C45, but its uses a mix of registering its MDIO
> bus and using the DSA core provided bus. This makes the change a bit
> more complex.

"using the DSA core provided bus" is a misrepresentation AFAICS.
Rather said, "providing its private MDIO bus to the DSA core too".

> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> v2:
>  - [al] Remove conditional c45, since all switches support c45
>  - [al] Remove dsa core changes, they are not needed
>  - [al] Add comment that DSA provided MDIO bus is C22 only.
> ---
>  drivers/net/dsa/mt7530.c | 87 ++++++++++++++++++++++++------------------------
>  drivers/net/dsa/mt7530.h | 15 ++++++---
>  include/net/dsa.h        |  2 +-
>  3 files changed, 56 insertions(+), 48 deletions(-)

This patch is not very coherent after the changes in v2.

There are really 2 distinct pieces:

1. a comment in include/net/dsa.h, which provides a justification for
why dsa_switch_ops :: {phy_read(), phy_write()} weren't split into
{phy_read(), phy_write()} and {phy_read_c45() and phy_write_c45()}.

2. a conversion of the mt7530 MDIO bus driver.

I would expect these to be distinct patches.

> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 96086289aa9b..732c7bc261a9 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -858,7 +858,7 @@ struct dsa_switch_ops {
>  	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
>  
>  	/*
> -	 * Access to the switch's PHY registers.
> +	 * Access to the switch's PHY registers. C22 only.
>  	 */
>  	int	(*phy_read)(struct dsa_switch *ds, int port, int regnum);
>  	int	(*phy_write)(struct dsa_switch *ds, int port,

Let me try to untangle for you what these operations really do.
When they are present, DSA will allocate ds->slave_mii_bus on behalf of
the driver, and use these methods for MDIO access of internal PHYs.

The purpose of ds->slave_mii_bus is to offer a non-OF based
phy_connect() for old-style device trees where there is no phy-handle
between the user port fwnode and the internal PHY fwnode (normally
because the ethernet-phy isn't described in the device tree at all).

Like this:

	ethernet-switch {
		ethernet-ports {
			port@1 {
				reg = <1>;
			};
		};
	};

So ds->slave_mii_bus is useful with or without the ds->ops->phy_read()
and ds->ops->phy_write() pointers, which is for example why mt7530
allocates its own MDIO bus with its own private methods (so it doesn't
populate ds->ops->phy_read()), but it also populates ds->slave_mii_bus
with its own bus.

Since clause 45 PHYs are identified by the "ethernet-phy-ieee802.3-c45"
compatible string (otherwise they are C22), then a PHY which is not
described in the device tree can only be C22. So this is why
ds->slave_mii_bus only deals with clause 22 methods, and the true reason
behind the comment above.

But actually this premise is no longer true since Luiz' commit
fe7324b93222 ("net: dsa: OF-ware slave_mii_bus"), which introduced the
strange concept of an "OF-aware helper for internal PHYs which are not
described in the device tree". After his patch, it is possible to have
something like this:

	ethernet-switch {
		ethernet-ports {
			port@1 {
				reg = <1>;
			};
		};

		mdio {
			ethernet-phy@1 {
				compatible = "ethernet-phy-ieee802.3-c45"
				reg = <1>;
			};
		};
	};

As you can see, this is a clause 45 internal PHY which lacks a
phy-handle, so its bus must be put in ds->slave_mii_bus in order for
dsa_slave_phy_connect() to see it without that phy-handle (based on the
port number matching with the PHY number). After Luiz' patch, this kind
of device tree is possible, and it invalidates the assumption about
ds->slave_mii_bus only driving C22 PHYs.

> 
> -- 
> 2.30.2

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769DA2FF82B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbhAUWqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbhAUWpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:45:49 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD696C061756;
        Thu, 21 Jan 2021 14:45:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id f1so4388738edr.12;
        Thu, 21 Jan 2021 14:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=js608cf7+b6uuSx4xSNXkCTdpGlQyO53l8ri6uI5Ugk=;
        b=OQ13GQFV3ZKMP2IsaYeS9IbNflRAvsauNeh1LiK6cY1iUbq+8h9tcm190yB2Y2cs9Z
         oo7YZxmWNtaAQoxDsMpl+WTlS3p8Wn+/HUoDI/lTY9kF2ha0KR9knHP38zbQtxLF4UQf
         oOn6twWZ1MEkgO1xJYJlPRHVdOA1sGybDrskKcm28EOl0RPytu/GLA0SnWpVTv3FAA+5
         BKdqo1dgkld0OE6+Z0h1wmGHbkOSR+hauscyqc4RFE1H7/HizN6MlYxPtHGOTHrWGM3d
         dJ12iOiQBd4uDN+r2xcRp36uuJ40snZXNtThkoXekqZlfI9eArVlww3XJARmlVZfIFJv
         40tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=js608cf7+b6uuSx4xSNXkCTdpGlQyO53l8ri6uI5Ugk=;
        b=XB6Ye/umNKIYkPLFospwDXGSowBJgdhY9NJjQfjV7c2PqdyAHrI8W6hYfEuAAH8feC
         jLBtODPqiZwi414+jQslK9juR2yOmTIoR5pmck1PInlSAfQz3YNf7FudskJRpwxEVmNe
         ISZvjg/MYVAmJ+n2CggFK9V8+tTCZeOLXmsQw0pzY/wb0nr4LugaT6POgK84EKaj4JPO
         X2iPSgbQUBts++8zyzlwKFs79MB3ND1atC9M1ENSu+ylC9hoAFUqjJ7/cFSZI8MB1Ylp
         eDv5qOJQBSlJYCp7sY7dIX5eq+C4gtfnEyLabj38EThPUwVamb4UafYr2xn2NePa9rXv
         XA7A==
X-Gm-Message-State: AOAM533bLUiwhlJTtopicenHrPCduvUnt/7th6lLat1nDJabtU/0d2+X
        kMvQ8D20BseHCSH6YqKGc7c=
X-Google-Smtp-Source: ABdhPJzdsAmZeMTtJofoH0OpmfOghYFNG5Mw7eCThZjIa7BwAAu43KDhcre/+DiKEUAE2RebrWMEpA==
X-Received: by 2002:aa7:d8c6:: with SMTP id k6mr1042147eds.265.1611269107502;
        Thu, 21 Jan 2021 14:45:07 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t21sm3595648edv.82.2021.01.21.14.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 14:45:06 -0800 (PST)
Date:   Fri, 22 Jan 2021 00:45:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Wallej <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
Message-ID: <20210121224505.nwfipzncw2h5d3rw@skbuf>
References: <20210120063019.1989081-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120063019.1989081-1-paweldembicki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pawel,

On Wed, Jan 20, 2021 at 07:30:18AM +0100, Pawel Dembicki wrote:
> This patch adds support for vlan filtering in vsc73xx driver.
> 
> After vlan filtering enable, CPU_PORT is configured as trunk, without
> non-tagged frames. This allows to avoid problems with transmit untagged
> frames because vsc73xx is DSA_TAG_PROTO_NONE.
> 
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>

What are the issues that are preventing you from getting rid of
DSA_TAG_PROTO_NONE? Not saying that making the driver VLAN aware is a
bad idea, but maybe also adding a tagging driver should really be the
path going forward. If there are hardware issues surrounding the native
tagging support, then DSA can make use of your VLAN features by
transforming them into a software-defined tagger, see
net/dsa/tag_8021q.c. But using a trunk CPU port with 8021q uppers on top
of the DSA master is a poor job of achieving that.

> ---
> +static int
> +vsc73xx_port_read_vlan_table_entry(struct dsa_switch *ds, u16 vid, u8 *portmap)
> +{
> +	struct vsc73xx *vsc = ds->priv;
> +	u32 val;
> +	int ret;
> +
> +	if (vid > 4095)
> +		return -EPERM;

This is a paranoid check and should be removed (not only here but
everywhere).

> +static int vsc73xx_port_vlan_prepare(struct dsa_switch *ds, int port,
> +				     const struct switchdev_obj_port_vlan *vlan)
> +{
> +	/* nothing needed */
> +	return 0;
> +}

Can you please rebase your work on top of the net-next/master branch?
You will see that the API has changed.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git

> +
> +static void vsc73xx_port_vlan_add(struct dsa_switch *ds, int port,
> +				  const struct switchdev_obj_port_vlan *vlan)
> +{
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	struct vsc73xx *vsc = ds->priv;
> +	int ret;
> +	u32 tmp;
> +
> +	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
> +		return;

Sorry, but no. You need to support the case where the bridge (or 8021q
module) adds a VLAN even when the port is not enforcing VLAN filtering.
See commit:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0ee2af4ebbe3c4364429859acd571018ebfb3424

> +
> +	ret = vsc73xx_port_update_vlan_table(ds, port, vlan->vid_begin,
> +					     vlan->vid_end, 1);
> +	if (ret)
> +		return;
> +
> +	if (untagged && port != CPU_PORT) {
> +		/* VSC73xx can have only one untagged vid per port. */
> +		vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
> +			     VSC73XX_TXUPDCFG, &tmp);
> +
> +		if (tmp & VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA)
> +			dev_warn(vsc->dev,
> +				 "Chip support only one untagged VID per port. Overwriting...\n");

Just return an error, don't overwrite, this leaves the bridge VLAN
information out of sync with the hardware otherwise, which is not a
great idea.

FWIW the drivers/net/dsa/ocelot/felix.c and drivers/net/mscc/ocelot.c
files support switching chips from the same vendor. The VSC73XX family
is much older, but some of the limitations apply to both architectures
nonetheless (like this one), you can surely borrow some ideas from
ocelot - in this case search for ocelot_vlan_prepare.

> +
> +		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> +				    VSC73XX_TXUPDCFG,
> +				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID,
> +				    (vlan->vid_end <<
> +				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_SHIFT) &
> +				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID);
> +		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> +				    VSC73XX_TXUPDCFG,
> +				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA,
> +				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA);
> +	}
> +	if (pvid && port != CPU_PORT) {
> +		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> +				    VSC73XX_CAT_DROP,
> +				    VSC73XX_CAT_DROP_UNTAGGED_ENA,
> +				    ~VSC73XX_CAT_DROP_UNTAGGED_ENA);
> +		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> +				    VSC73XX_CAT_PORT_VLAN,
> +				    VSC73XX_CAT_PORT_VLAN_VLAN_VID,
> +				    vlan->vid_end &
> +				    VSC73XX_CAT_PORT_VLAN_VLAN_VID);
> +	}
> +}

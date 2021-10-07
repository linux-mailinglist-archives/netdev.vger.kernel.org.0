Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DA5425D0E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhJGUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhJGUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:19:02 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8FEC061570;
        Thu,  7 Oct 2021 13:17:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b8so27598575edk.2;
        Thu, 07 Oct 2021 13:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+plWImOU9l+KmK1gHBeb8TkLTQenqco68zq/+N/xRCA=;
        b=AlLe2bSpk3ACJg4+aP1dPdv9y105tDEaYEuWFe/8PwqxYyWKktoEXDCh/0DfVWKFWO
         Fkd7VKAZEMBevISK9nAJL1gAK7BRHEajQfS71/HSXX5/M+kVNN3vOQutAmECatg9wRBC
         Liy/eGxa9LPlK8VCiqGkCeeKAmRUOn1obgttCO/I0ITjkoIlqUXIgpxq85S4buW0Uw7N
         mds5z1pf/y7+S46u+PIb4eC+XPbRplGnUn7Aso5AS0reCIG6/97l5vrP4djUV3bm7nxN
         Mzav3fMX9tRdw0nB+bMnq4/yGpIoNevVuz0Cd+J9Q+YfC4sIER20h10PV97rB/TJHsXg
         mbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+plWImOU9l+KmK1gHBeb8TkLTQenqco68zq/+N/xRCA=;
        b=Tm7f8eKTn5+zjRDVSYVWdo0jCFETJQEI5xHg4jwG0/3v+/2hgcVZu4Yg8q6z+JHU+2
         1NYW6ZfGadR4+bHnoUkx4eGGurfeE7EwHVSCwKgiJGlCAo04fAom/1eRbUY2o+bHfrjh
         INHJAT/QPuxe2c1VSdyBbSxDoQf1pny3nLbu/HWkJJibJEDOiPJOVNSQ8Mj/iGJLcnWZ
         cCOTVnIKowjC+tu3K7WTWWZsg8B3VsFi9jT2wteLk50uTwxwZTV7BZDWyZwQ5ONDIDOy
         /EHsncTU+CF1TPjQNgsOOsCoOe09n46EdQ4Tw9RH+vWYsEodITXO8Ed/jL0vsvOnnNPj
         6mTw==
X-Gm-Message-State: AOAM533s8sUPFSjSronO0dlAPOzyznwrWSCSg2EvHMe0TxYnNL0mJXRO
        CVjE0k0lEMleKzTAdATNdEc=
X-Google-Smtp-Source: ABdhPJw/uWfOz4fx52vESMTUS8qM+HHABmSRcaTiMLl3LdMVpnQLpnyrgzX2Ab/xbBDF7hTnxt2RdA==
X-Received: by 2002:a17:906:2816:: with SMTP id r22mr4625004ejc.158.1633637826699;
        Thu, 07 Oct 2021 13:17:06 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id z4sm139845ejn.112.2021.10.07.13.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:17:06 -0700 (PDT)
Date:   Thu, 7 Oct 2021 23:17:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
Message-ID: <20211007201705.polwaqgbzff4u3vx@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-11-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-11-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 08:42:00PM +0530, Prasanna Vengateshan wrote:
>  static int lan937x_read_table(struct ksz_device *dev, u32 *table)
>  {
>  	int ret;
> @@ -193,6 +292,102 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  		ksz_update_port_member(dev, port);
>  }
>  
> +static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				       bool flag,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret;
> +
> +	ret = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE,
> +			  flag);

If you're going to resend anyway, can you please check the entire
submission for this pattern, where you can eliminate the intermediary
"ret" variable and just return the function call directly?

	return lan937x_cfg(...)

Do you have an explanation for what SW_VLAN_ENABLE does exactly?

> +
> +	return ret;
> +}
> +
> +static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
> +				 const struct switchdev_obj_port_vlan *vlan,
> +				 struct netlink_ext_ack *extack)
> +{
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	struct ksz_device *dev = ds->priv;
> +	struct lan937x_vlan vlan_entry;
> +	int ret;
> +
> +	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
> +	if (ret < 0) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");
> +		return ret;
> +	}
> +
> +	vlan_entry.fid = lan937x_get_fid(vlan->vid);
> +	vlan_entry.valid = true;
> +
> +	/* set/clear switch port when updating vlan table registers */
> +	if (untagged)
> +		vlan_entry.untag_prtmap |= BIT(port);
> +	else
> +		vlan_entry.untag_prtmap &= ~BIT(port);
> +
> +	vlan_entry.fwd_map |= BIT(port);
> +
> +	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
> +	if (ret < 0) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table");
> +		return ret;
> +	}
> +
> +	/* change PVID */
> +	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
> +		ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID,
> +				       vlan->vid);
> +		if (ret < 0) {
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to set pvid");
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int lan937x_port_vlan_del(struct dsa_switch *ds, int port,
> +				 const struct switchdev_obj_port_vlan *vlan)
> +{
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	struct ksz_device *dev = ds->priv;
> +	struct lan937x_vlan vlan_entry;
> +	u16 pvid;
> +	int ret;
> +
> +	lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
> +	pvid &= 0xFFF;
> +
> +	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to get vlan table\n");
> +		return ret;
> +	}
> +	/* clear port fwd map */
> +	vlan_entry.fwd_map &= ~BIT(port);
> +
> +	if (untagged)
> +		vlan_entry.untag_prtmap &= ~BIT(port);

This is bogus.
The user can add a VLAN entry using:

bridge vlan add dev lan0 vid 100 pvid untagged

and remove it using

bridge vlan del dev lan0 vid 100

so BRIDGE_VLAN_INFO_UNTAGGED is not set on removal.

Considering the fact that it doesn't matter whether the port is
egress-tagged or not when it isn't in the fwd_map in the first place,
I suggest you completely drop this condition.

> +
> +	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to set vlan table\n");
> +		return ret;
> +	}
> +
> +	ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);

What is the point of reading the pvid and writing it back unmodified?
Is the AND-ing with 0xFFF supposed to do anything? Because when you
write to REG_PORT_DEFAULT_VID, you write it with nothing in the upper
bits, so I expect there to be nothing in the upper bits when you read it
back either.

> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to set pvid\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}

Also, consider the following set of commands:

ip link add br0 type bridge vlan_filtering 1
ip link set lan0 master br0
bridge vlan add dev lan0 vid 100 pvid untagged
bridge vlan del dev lan0 vid 100
ip link set br0 type bridge vlan_filtering 0

The expectation is that the switch, being VLAN-unaware as it is currently
configured, receives and sends any packet regardless of VLAN ID.
If you put an IP on br0 in this state, are you able to ping an outside host?

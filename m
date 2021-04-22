Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888483686E4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238698AbhDVTEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbhDVTEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:04:41 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F0EC06174A;
        Thu, 22 Apr 2021 12:04:04 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w6so17844943pfc.8;
        Thu, 22 Apr 2021 12:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wJWD0ypjjTq7fQ8rDgddX7owB8y+VHTM4qMJIH9fCHw=;
        b=Cin5h4rbv5pmzeuLH/DCXq5IMuHo05dhO7oVG1hDrMwCgq1DvBxxkhVi2y0UJjE/aA
         8MB1McePiIrkrvYrQIrEKunTV8ooTpDJaKGSp6m2ooTVhzL8RqWzN61yPEfnOnJ2mce6
         LjHK8KZKZmxPp5wsArK91feNOLD+NVotFYX5c0v94W9bpoV+s2934gq0axgUQiQSJubH
         pY+aThwzWqNJoyNuC/mrd/WFL7jaP8J4kIqcmhhNmB8UVqz+GIWJaPSBjFDr8aFJJQ1d
         fjBvjM4VkD+PQMWN+ilaUZ7UtgWyRaIg3SZ/nuk/+5WHrKwO+nk7DHNEV5oeuKO+nwsu
         PljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wJWD0ypjjTq7fQ8rDgddX7owB8y+VHTM4qMJIH9fCHw=;
        b=N5SK5cT1xNeMXVUz1jEsdQXJY2V9qGglOHyXf90L2AO6tD1upSk/6Y2RNUfld5lA2l
         UOVs3dc/pgVE7v5gFMdg6Mo326ELapWLrhU+ZDyj32Bo3rqJVkCdXhxh7Z0EjVF/dcmY
         hE6WOaIzy7QifRvHsMJXbrcZRfvDDxH+ko8ypKj8wAJxwgMRRy+GtljDMA2dD/1XRZ5x
         d89ugb5/MVQrIr8ey45sh0iiK6ynPElf5nR02r59SbFGa8eL5d1NfPec8qrufT6omG/s
         JL8AghjWQR3gXRMpKoGENgHfV3R02y96ethtLPni6WrryX118HTP1/Aa1cHhxe7z26dZ
         Ic3A==
X-Gm-Message-State: AOAM533ZBBRLoBaCMOwruNy6OITrlJ7Oh9q5svhyHNgmrP6jRbPQrva3
        +1S9H1iXbml3l9Gq6Rs0eJY=
X-Google-Smtp-Source: ABdhPJxRb14TpJppSAkwxeKcVHLhlrr2Hq1IwkG/+5lK0KcV0Rt1LDlxdCjkX/gXj+GsSpoqGJoJpQ==
X-Received: by 2002:a65:5c4a:: with SMTP id v10mr119919pgr.73.1619118244074;
        Thu, 22 Apr 2021 12:04:04 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n39sm2594911pfv.51.2021.04.22.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:04:03 -0700 (PDT)
Date:   Thu, 22 Apr 2021 22:03:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 9/9] net: dsa: microchip: add support for
 vlan operations
Message-ID: <20210422190351.qdv2xlnxghmfpjqj@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-10-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-10-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:12:57PM +0530, Prasanna Vengateshan wrote:
> Support for VLAN add, del, prepare and filtering operations.
> 
> It aligns with latest update of removing switchdev
> transactional logic from VLAN objects

Maybe more in the commit message about what the patch does, as opposed
to mentioning that you had to rebase it, would be helpful.

> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 214 +++++++++++++++++++++++
>  1 file changed, 214 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 7f6183dc0e31..35f3456c3506 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -14,6 +14,103 @@
>  #include "ksz_common.h"
>  #include "lan937x_dev.h"
>  
> +static int lan937x_wait_vlan_ctrl_ready(struct ksz_device *dev)
> +{
> +	unsigned int val;
> +
> +	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL,
> +					val, !(val & VLAN_START), 10, 1000);
> +}
> +
> +static int lan937x_get_vlan_table(struct ksz_device *dev, u16 vid,
> +				  u32 *vlan_table)
> +{
> +	int rc;
> +
> +	mutex_lock(&dev->vlan_mutex);
> +
> +	rc = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
> +	if (rc < 0)
> +		goto exit;
> +
> +	/* wait to be cleared */
> +	rc = lan937x_wait_vlan_ctrl_ready(dev);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &vlan_table[0]);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, &vlan_table[1]);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4, &vlan_table[2]);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
> +	if (rc < 0)
> +		goto exit;
> +
> +exit:
> +	mutex_unlock(&dev->vlan_mutex);
> +
> +	return rc;
> +}
> +
> +static int lan937x_set_vlan_table(struct ksz_device *dev, u16 vid,
> +				  u32 *vlan_table)
> +{
> +	int rc;
> +
> +	mutex_lock(&dev->vlan_mutex);
> +
> +	rc = ksz_write32(dev, REG_SW_VLAN_ENTRY__4, vlan_table[0]);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4, vlan_table[1]);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_table[2]);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
> +	if (rc < 0)
> +		goto exit;
> +
> +	/* wait to be cleared */
> +	rc = lan937x_wait_vlan_ctrl_ready(dev);
> +	if (rc < 0)
> +		goto exit;
> +
> +	rc = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
> +	if (rc < 0)
> +		goto exit;
> +
> +	/* update vlan cache table */
> +	dev->vlan_cache[vid].table[0] = vlan_table[0];
> +	dev->vlan_cache[vid].table[1] = vlan_table[1];
> +	dev->vlan_cache[vid].table[2] = vlan_table[2];
> +
> +exit:
> +	mutex_unlock(&dev->vlan_mutex);
> +
> +	return rc;
> +}
> +
>  static int lan937x_read_table(struct ksz_device *dev, u32 *table)
>  {
>  	int rc;
> @@ -190,6 +287,120 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  	mutex_unlock(&dev->dev_mutex);
>  }
>  
> +static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				       bool flag,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int rc;
> +
> +	if (flag) {
> +		rc = lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
> +				      PORT_VLAN_LOOKUP_VID_0, true);
> +		if (rc < 0)
> +			return rc;

What does this bit do?

> +
> +		rc = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, true);

How about this bit?

I see one bit is per port and the other is global.
Just FYI, you can have this configuration:

ip link add br0 type bridge vlan_filtering 0
ip link add br1 type bridge vlan_filtering 1
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp2 master br1
ip link set swp3 master br1

Do the swp0 and swp1 ports remain VLAN-unaware after you touch this
REG_SW_LUE_CTRL_0 bit?

> +	} else {
> +		rc = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, false);
> +		if (rc < 0)
> +			return rc;
> +
> +		rc = lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
> +				      PORT_VLAN_LOOKUP_VID_0, false);
> +	}
> +
> +	return rc;
> +}
> +
> +static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
> +				 const struct switchdev_obj_port_vlan *vlan,
> +				 struct netlink_ext_ack *extack)
> +{
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	struct ksz_device *dev = ds->priv;
> +	u32 vlan_table[3];

Maybe a structure would be nicer to read than an u32 array?

> +	int rc;
> +
> +	rc = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to get vlan table\n");

One of the reasons for which the extack exists is so that you can report
errors to user space and not to the console.

		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");

> +		return rc;
> +	}
> +
> +	vlan_table[0] = VLAN_VALID | (vlan->vid & VLAN_FID_M);
> +
> +	/* set/clear switch port when updating vlan table registers */
> +	if (untagged)
> +		vlan_table[1] |= BIT(port);
> +	else
> +		vlan_table[1] &= ~BIT(port);
> +	vlan_table[1] &= ~(BIT(dev->cpu_port));
> +
> +	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);

What's the business with the CPU port here? Does DSA not call
.port_vlan_add for the CPU port separately?

> +
> +	rc = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to set vlan table\n");
> +		return rc;
> +	}
> +
> +	/* change PVID */
> +	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
> +		rc = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan->vid);
> +
> +		if (rc < 0) {
> +			dev_err(dev->dev, "Failed to set pvid\n");
> +			return rc;
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
> +	u32 vlan_table[3];
> +	u16 pvid;
> +	int rc;
> +
> +	lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
> +	pvid &= 0xFFF;
> +
> +	rc = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
> +
> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to get vlan table\n");
> +		return rc;
> +	}
> +	/* clear switch port number */
> +	vlan_table[2] &= ~BIT(port);
> +
> +	if (pvid == vlan->vid)
> +		pvid = 1;

According to Documentation/networking/switchdev.rst:

When the bridge has VLAN filtering enabled and a PVID is not configured on the
ingress port, untagged and 802.1p tagged packets must be dropped. When the bridge
has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
priority-tagged packets must be accepted and forwarded according to the
bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
disabled, the presence/lack of a PVID should not influence the packet
forwarding decision.

So please don't reset the pvid.

> +
> +	if (untagged)
> +		vlan_table[1] &= ~BIT(port);
> +
> +	rc = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to set vlan table\n");
> +		return rc;
> +	}
> +
> +	rc = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
> +
> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to set pvid\n");
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
>  static u8 lan937x_get_fid(u16 vid)
>  {
>  	if (vid > ALU_FID_SIZE)
> @@ -955,6 +1166,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.port_bridge_flags	= lan937x_port_bridge_flags,
>  	.port_stp_state_set	= lan937x_port_stp_state_set,
>  	.port_fast_age		= ksz_port_fast_age,
> +	.port_vlan_filtering	= lan937x_port_vlan_filtering,
> +	.port_vlan_add		= lan937x_port_vlan_add,
> +	.port_vlan_del		= lan937x_port_vlan_del,
>  	.port_fdb_dump		= lan937x_port_fdb_dump,
>  	.port_fdb_add		= lan937x_port_fdb_add,
>  	.port_fdb_del		= lan937x_port_fdb_del,
> -- 
> 2.27.0
> 

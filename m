Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE343FB54
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhJ2L2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhJ2L2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 07:28:41 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E25C061570;
        Fri, 29 Oct 2021 04:26:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v127so8549692wme.5;
        Fri, 29 Oct 2021 04:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mx5xRcHewOCNfKto+f3Q6RnIkI0KlnLVzBrDF/QZ+nQ=;
        b=pjotHabvO/g98Fvu6YXdCADFNU4QcjIc9B8563Es8qbhXiU8ePD0bYLgislqOO44RX
         Dnt7ZFOK6B5SnTqLY5bteIzTsV2gSubcn0FkzORp13QlPoYgsnGAt8B/krwt26ajgrBM
         Hjo7r9VnfHYKC3uZ1JSaEiEEtw2rYdmEnDYW4Kir0eHWlC62m9BqRTngBMZTmDNSOgZR
         3brMCPxPT35JsLyDaYWdiW8j1D3F+kpoJ9dOkWBAPABuE1Cr+hCmhdGSwDUUk17LhccJ
         fCtsbH4GksSUWXxK3IM0PpTy3+AqjrjglcgMKeTqkRMVQFrFW7+2bFqdQJNoVaOzn19Z
         gQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mx5xRcHewOCNfKto+f3Q6RnIkI0KlnLVzBrDF/QZ+nQ=;
        b=6B4gG5PdhQfgjhnLSQr4EccAN0zBEojHU+kFQOsmjFHwZuxi2EBZfOC5AfNu91uHcq
         /6+Vn3NHaqEpZvj7k7etvb3+HKHarglJKL1jz/cuNxV+th7JVt4ibOv4SSpok6vP+BIb
         Wq/yO1O/HcrCMknt4HKnXUeD5tnPRzQky7IH/lmRFaLjjPNO74fhED5//Y3tJRNHqePZ
         BXsiBwghOxKxyAlzT+pb08jwkDs3GQLazi81dXARswlbPYqZV1AjTFBQmr7xsKatx2pu
         U8+dOm1Ilbkzc+6109b07Nmjf7JecCwXiN0asOU+vM1a9OJAY0pg6qqlDULmiVJvkgig
         RyvQ==
X-Gm-Message-State: AOAM530DD2d9ySsLkHCilJ2IQvnOqjPbaFM87JEzc/0A4rxK9Uk7DfdA
        D11I98ZfEnobSUWWq/q2T6k=
X-Google-Smtp-Source: ABdhPJzMogLDRDoDNMGMYlS8KmaiObn+3sxzB97zf0nbPuAJ2WXiSwJ4RrPFmh7nBP7qqS8UDC3U+A==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr18777199wmk.32.1635506771024;
        Fri, 29 Oct 2021 04:26:11 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id u10sm7290954wrs.5.2021.10.29.04.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 04:26:10 -0700 (PDT)
Date:   Fri, 29 Oct 2021 14:26:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
Message-ID: <20211029112609.5mb7ckgrjle3nl2i@skbuf>
References: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
 <20211029052256.144739-11-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029052256.144739-11-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 10:52:56AM +0530, Prasanna Vengateshan wrote:
> Support for VLAN add, del, prepare and filtering operations.
> 
> The VLAN aware is a global setting. Mixed vlan filterings
> are not supported. vlan_filtering_is_global is made as true
> in lan937x_setup function.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 188 +++++++++++++++++++++++
>  1 file changed, 188 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 980fd74b3bc1..3f1f86633173 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -17,6 +17,14 @@
>  #include "ksz_common.h"
>  #include "lan937x_dev.h"
>  
> +static int lan937x_wait_vlan_ctrl_ready(struct ksz_device *dev)
> +{
> +	unsigned int val;
> +
> +	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL, val,
> +					!(val & VLAN_START), 10, 1000);
> +}
> +
>  static u8 lan937x_get_fid(u16 vid)
>  {
>  	if (vid > ALU_FID_SIZE)
> @@ -25,6 +33,97 @@ static u8 lan937x_get_fid(u16 vid)
>  		return vid;
>  }
>  
> +static int lan937x_get_vlan_table(struct ksz_device *dev, u16 vid,
> +				  struct lan937x_vlan *vlan_entry)
> +{
> +	u32 data;
> +	int ret;
> +
> +	mutex_lock(&dev->vlan_mutex);
> +
> +	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_READ | VLAN_START);
> +	if (ret < 0)
> +		goto exit;
> +
> +	/* wait to be cleared */
> +	ret = lan937x_wait_vlan_ctrl_ready(dev);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY__4, &data);
> +	if (ret < 0)
> +		goto exit;
> +
> +	vlan_entry->valid = !!(data & VLAN_VALID);
> +	vlan_entry->fid	= data & VLAN_FID_M;
> +
> +	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_UNTAG__4,
> +			 &vlan_entry->untag_prtmap);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_read32(dev, REG_SW_VLAN_ENTRY_PORTS__4,
> +			 &vlan_entry->fwd_map);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, 0);
> +	if (ret < 0)
> +		goto exit;
> +
> +exit:
> +	mutex_unlock(&dev->vlan_mutex);
> +
> +	return ret;
> +}
> +
> +static int lan937x_set_vlan_table(struct ksz_device *dev, u16 vid,
> +				  struct lan937x_vlan *vlan_entry)
> +{
> +	u32 data;
> +	int ret;
> +
> +	mutex_lock(&dev->vlan_mutex);
> +
> +	data = vlan_entry->valid ? VLAN_VALID : 0;
> +	data |= vlan_entry->fid;
> +
> +	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY__4, data);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_UNTAG__4,
> +			  vlan_entry->untag_prtmap);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_write32(dev, REG_SW_VLAN_ENTRY_PORTS__4, vlan_entry->fwd_map);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_write16(dev, REG_SW_VLAN_ENTRY_INDEX__2, vid & VLAN_INDEX_M);
> +	if (ret < 0)
> +		goto exit;
> +
> +	ret = ksz_write8(dev, REG_SW_VLAN_CTRL, VLAN_START | VLAN_WRITE);
> +	if (ret < 0)
> +		goto exit;
> +
> +	/* wait to be cleared */
> +	ret = lan937x_wait_vlan_ctrl_ready(dev);
> +	if (ret < 0)
> +		goto exit;
> +
> +exit:
> +	mutex_unlock(&dev->vlan_mutex);
> +
> +	return ret;
> +}
> +
>  static int lan937x_read_table(struct ksz_device *dev, u32 *table)
>  {
>  	int ret;
> @@ -189,6 +288,92 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  		ksz_update_port_member(dev, port);
>  }
>  
> +static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				       bool flag,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	/* enable/disable VLAN mode, once enabled, look up process starts
> +	 * and then forwarding and discarding are done based on port
> +	 * membership of the VLAN table
> +	 */
> +	return lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE, flag);
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
> +	struct ksz_device *dev = ds->priv;
> +	struct lan937x_vlan vlan_entry;
> +	u16 pvid;
> +	int ret;
> +
> +	lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);

Why do you read the pvid here?

> +
> +	ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to get vlan table\n");
> +		return ret;
> +	}
> +	/* clear port fwd map & untag entries*/
> +	vlan_entry.fwd_map &= ~BIT(port);
> +	vlan_entry.untag_prtmap &= ~BIT(port);
> +
> +	ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "Failed to set vlan table\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
>  				const unsigned char *addr, u16 vid)
>  {
> @@ -1036,6 +1221,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.port_bridge_leave = ksz_port_bridge_leave,
>  	.port_stp_state_set = lan937x_port_stp_state_set,
>  	.port_fast_age = ksz_port_fast_age,
> +	.port_vlan_filtering = lan937x_port_vlan_filtering,
> +	.port_vlan_add = lan937x_port_vlan_add,
> +	.port_vlan_del = lan937x_port_vlan_del,
>  	.port_fdb_dump = lan937x_port_fdb_dump,
>  	.port_fdb_add = lan937x_port_fdb_add,
>  	.port_fdb_del = lan937x_port_fdb_del,
> -- 
> 2.27.0
> 


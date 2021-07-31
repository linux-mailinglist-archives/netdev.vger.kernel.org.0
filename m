Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A03DC686
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhGaPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbhGaPIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:08:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9247C0613CF;
        Sat, 31 Jul 2021 08:08:41 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id c16so15353332wrp.13;
        Sat, 31 Jul 2021 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=USLWxMtKm5Ti7FfzfTW9RvXxZbds4Oj1h9BYqj91L1E=;
        b=KFLFmV+p7hTgz57cq7tai2TtXyij86tt0x3TCKI0RgJs1b4FNJKgjqfgd8WTQnjuDT
         ujg/br/hY9+/Y+pPjAHiCT8/SzWPk0L+T8IfHO6CyaNF7p8dubKLC6wdtcneg7C8+kdb
         hryE9ZT/5A2v1QeoYpf0/3+XqyVgaB23kN1zdSi2+SaGurSkawsfvAAVmOBrDCCQtDON
         wWfq3cJyc2JfHIWFQx0DT3bzeGMG5RQrIVSb3+OkyIqpGDfQgGHK+cuL4TyG9SaDsJoB
         9aXxkf3qZqMlWC3EQC1veS4+74VpO0r1+kwzMliD0twnoT+bBz3i2Pj4kp9XC3vBp8Jq
         Q7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=USLWxMtKm5Ti7FfzfTW9RvXxZbds4Oj1h9BYqj91L1E=;
        b=EIBnXhuFRYKs+Pjb8m6GJ/oGi7wgp4mhwGun+bLd+mEyRN3g5hmRbaBXSV2M3AcyiJ
         uhJAChefKgCuytBcWFVOmC3r2SenCiQKqugIDDw//DO37ODHEnSmh9WkI+QwADc+YSUp
         VDeCqbiaDgAucY/SJ/sF4JyDBtvK3TiTCyIQ/67PqKEB6eVL5GAZ4Bh3oY3nJx+lwX4A
         zfNQAt+RYL+CzMNRDAb3sWcbxr7w+qe8Nhnu2AFznX6516RTyhy0tp0N13hSEgZv0OxU
         jLwXFPW7K9PDJcUWcGh1EQdkVwHmqePmO+drmk8sjauXr9qHbkuHJrpEiNUlprMLqE0w
         DTLw==
X-Gm-Message-State: AOAM532sUcCtfT3ODsMxLNWv3HcwDyJuKEuZK+0fOK4SaCUdmDufqglK
        6TZQNYN7QYP2FCMfmt5CSso=
X-Google-Smtp-Source: ABdhPJxQMBXFZp2V+lDscsQrPdCzPP1LSl2cKqKXQdgQlszpVM/x5xB4e1eHwUTyS09lMBhFsUm4bw==
X-Received: by 2002:a5d:4251:: with SMTP id s17mr8766148wrr.154.1627744120450;
        Sat, 31 Jul 2021 08:08:40 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id f26sm5176147wrd.41.2021.07.31.08.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:08:39 -0700 (PDT)
Date:   Sat, 31 Jul 2021 18:08:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
Message-ID: <20210731150838.2pigkik3iaeguflz@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-11-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-11-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:08PM +0530, Prasanna Vengateshan wrote:
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
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table\n");

The NL_SET_ERR_MSG_MOD function already adds the \n at the end.

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
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to set vlan table\n");
> +		return ret;
> +	}
> +
> +	/* change PVID */
> +	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
> +		ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID,
> +				       vlan->vid);
> +		if (ret < 0) {
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to set pvid\n");
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}

Side question: do you think the ds->configure_vlan_while_not_filtering = false
from ksz9477.c and ksz8795.c serve any purpose, considering that you did
not need this setting for lan937x? If not, could you please send a patch
to remove that setting from those 2 other KSZ drivers? Thanks.

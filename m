Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BEC3CA0EF
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhGOOw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbhGOOw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:52:26 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D993C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 07:49:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b14-20020a1c1b0e0000b02901fc3a62af78so6222962wmb.3
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 07:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VkHeawapFxvFE6350X6CQgGsPoo5+76V86NE1YTDZZY=;
        b=UCw4fcFiE2bu30hwS5e53xnmFf+zg/e3F4GQSOf+CxTd+/UU2nPZ0Lv4BfuRyw22uc
         CDod9C4FfBlOTDCB2ZUDsDPLR9UI29zIbwcxnnobpyQc2kXJiWaTdm/oSo3WFy2KTXol
         1qL7NpIrmTG+IC8MwIR3dC8yu/CLxOhBcApyJ9aIRHY4pyTYzpRRACAkcAnIpi81LY8g
         pmC74sEB878o/1vGjgLlk2EVOhfl54LAaFQNWEpUZuLTMtR92vHJb8i4ZSSXhnJaZZP/
         X9vdSHQVr5SU0CDzgCGNlu3m9L4siq0kEpBAtnbOlIirLJldET+9pt6bDAt8+GPdGv4D
         cddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VkHeawapFxvFE6350X6CQgGsPoo5+76V86NE1YTDZZY=;
        b=Lfz9+60JSjKhR1czrtcy40kvxyJueYrz2wqZOVMFDsMyZ6CLYt0XfNZM0vt/8e19T0
         GqNEaR1ecwd+6NvthewaUQfoM7ZKCJLqr4ACn1+fxXrU9hyApQPqn82UmBxlLmDEjVme
         lV0UtVChWgljw7C/rFPFt67MUiSmxqoylnkUCBfWg7hFQw6lhf84YvOP5edgyxK7LuJ+
         s3xZLYdZTS7M9yjidUICUKnK1z58HGIQ4CzWVg/BCOLkYB35hx1m6CZp8cq7xC9TSSY8
         VIqSnGJwGXvAMMm8GeTG3Wz//6aWycW3i2EPSzNaYbT76HpCstGytSVUsbVR2Coa7CWT
         X6Tw==
X-Gm-Message-State: AOAM533nc6hIYZ4Njg0tZuD4G1IXX+uM6/2ZUZ1eRBYLxeMfsKClVBUM
        EpbRjZqz/vawmWzhYS8YT/k=
X-Google-Smtp-Source: ABdhPJzIiQlCsY1cJjf6mEApH3G+KNcm4gc3JXaKMEnw1biTXn4fv73C/YDcYJ+yFsvtMviRpZLGbg==
X-Received: by 2002:a05:600c:1c0d:: with SMTP id j13mr5097890wms.34.1626360571117;
        Thu, 15 Jul 2021 07:49:31 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id q17sm249958wrv.47.2021.07.15.07.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 07:49:30 -0700 (PDT)
Date:   Thu, 15 Jul 2021 17:49:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC PATCH v3 net-next 22/24] net: dsa: add support for bridge
 TX forwarding offload
Message-ID: <20210715144929.oa3u44is3v6gewr5@skbuf>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
 <20210712152142.800651-23-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712152142.800651-23-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 06:21:40PM +0300, Vladimir Oltean wrote:
> +static bool dsa_port_bridge_tx_fwd_prepare(struct dsa_port *dp,
> +					   struct net_device *bridge_dev)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	struct dsa_switch_tree *dst;
> +	int bridge_num, err;
> +
> +	dst = ds->dst;
> +
> +	bridge_num = dsa_tree_find_bridge_num(dst, bridge_dev);
> +	if (bridge_num < 0) {
> +		/* First port that offloads TX forwarding for this bridge */
> +		int bridge_num;

Stupid bug: "bridge_num" is redeclared here as a different variable with
a different scope, shadowing the one from dsa_port_bridge_tx_fwd_prepare().

> +
> +		bridge_num = find_first_zero_bit(&dst->fwd_offloading_bridges,
> +						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
> +		if (bridge_num >= ds->num_fwd_offloading_bridges)
> +			return false;
> +
> +		set_bit(bridge_num, &dst->fwd_offloading_bridges);
> +	}
> +
> +	dp->bridge_num = bridge_num;

and then here, the scope from the "if" block is lost, so the bridge_num
variable is still -1. So dp->bridge_num remains -1.

Deleting the "int bridge_num" declaration from the "if" block fixes the
issue. This got introduced between v2 and v3.

> +
> +	/* Notify the driver */
> +	err = dsa_port_bridge_fwd_offload_add(dp, bridge_dev, bridge_num);
> +	if (err) {
> +		dsa_port_bridge_tx_fwd_unprepare(dp, bridge_dev);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>  			 struct netlink_ext_ack *extack)
>  {
> @@ -241,6 +310,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>  	};
>  	struct net_device *dev = dp->slave;
>  	struct net_device *brport_dev;
> +	bool tx_fwd_offload;
>  	int err;
>  
>  	/* Here the interface is already bridged. Reflect the current
> @@ -254,7 +324,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>  	if (err)
>  		goto out_rollback;
>  
> -	err = switchdev_bridge_port_offload(brport_dev, dev, dp, false, extack);
> +	tx_fwd_offload = dsa_port_bridge_tx_fwd_prepare(dp, br);
> +
> +	err = switchdev_bridge_port_offload(brport_dev, dev, dp, tx_fwd_offload,
> +					    extack);
>  	if (err)
>  		goto out_rollback_unbridge;
>  
> @@ -279,6 +352,8 @@ int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>  	struct net_device *dev = dp->slave;
>  
> +	dsa_port_bridge_tx_fwd_prepare(dp, br);

We are in the pre_bridge_leave path, this should have been _unprepare.

> +
>  	return switchdev_bridge_port_unoffload(brport_dev, dev, dp, extack);
>  }

The patches should work otherwise, if somebody wants to test they should
make these changes.

There are also some more changes that need to be made to mlxsw to
properly handle the unoffload of bridge ports that are LAG devices and
VLAN devices. I have them in my tree now. When net-next reopens I will
first send a series of 7 refactoring patches for dpaa2-switch, mlxsw and
prestera, and then the TX data plane offload in DSA as a 15-patch series.

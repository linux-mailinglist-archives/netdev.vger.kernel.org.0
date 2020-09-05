Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E6525EAB1
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgIEUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbgIEUmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 16:42:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31226C06125F;
        Sat,  5 Sep 2020 13:42:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l9so9776744wme.3;
        Sat, 05 Sep 2020 13:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BRoBcnrxi2saKKj9FzCOgRHvvrX34KucexohyVGoVsM=;
        b=RDPNyb+kkOtBlXCmxYk538QFv2w+G/M+a3v906doqcim2ZkU3gFmbJwXSiSIaWnx0l
         Tncd+qdWX9NPkpM3Z5z8pi8Lum17DxbKYxHMmVzS/0S0fTSikR5WsYZdtqdtmZt1XU86
         Hx+MW+pW8ihW+11yFru6J2Ik/pqQeFiBJPG2dN7E8kVvP220cUEbkizZA8qc3ZThBmz8
         vXideqgKkV5RKoZQpU3M2GUGcMzZwrU5JfdeKixwFWHZSwmZivLzQ9Aut8IcoBGWRHlR
         Nj4YneC9MtfH9kM76Q84gBk9Vkjc+oiSRXJGfVA47v2Da7ree0pgoOxMy4r96wKGKgCC
         mjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BRoBcnrxi2saKKj9FzCOgRHvvrX34KucexohyVGoVsM=;
        b=kUg2WbvYApIBycgOX4PQZvO5JM5Mm5glgkHIsCiQEmgPduY+dkqd7U+7Qpv8wttuoX
         aRJcppbh/zklONEDVQqbkzGA+xyooZpTcsM/ly/GpgbSFS89U8IJ/9wDDWTN+5pOc5jq
         c5spS8OpLYeJCDI7j03VkeI+lJ7ar03HwGibwrDmQ0BTE6Z4TgBU/tiXNSvKQXymzSz7
         cHePT5+4HaRXCTfZp1DbP+h/aUJi8zzydRellAOkzIPV6Q3HaBA+c12NEPF5qw4Ku0Pg
         SXzd3Jd3TnM7NaXpJmz/uk7UZYpp7YBfQmuJUpNT5eW1v5xM37SSh79K8XONuBuW7M31
         0KwQ==
X-Gm-Message-State: AOAM531XcBoJVEU3HJGudEOpemlkfGgmVCoTydZzQLnaBRf195mZ8XF8
        nMYJsERB6lIKCGzkONPdims=
X-Google-Smtp-Source: ABdhPJzTeJDGV7UaWMgk0TBdzBafuns1qotjvoLAz9Uq5Vxn+iw9/6M5dDDnOR3qAvgdDmPTvZ8CRg==
X-Received: by 2002:a7b:c342:: with SMTP id l2mr13034032wmj.153.1599338558674;
        Sat, 05 Sep 2020 13:42:38 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g2sm19888329wmg.32.2020.09.05.13.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 13:42:37 -0700 (PDT)
Date:   Sat, 5 Sep 2020 23:42:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200905204235.f6b5til4sc3hoglr@skbuf>
References: <20200904062739.3540-1-kurt@linutronix.de>
 <20200904062739.3540-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904062739.3540-3-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 08:27:34AM +0200, Kurt Kanzenbach wrote:
> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
> implementing features needed for Time Sensitive Networking (TSN) such as support
> for the Time Precision Protocol and various shapers like the Time Aware Shaper.
> 
> This driver includes basic support for networking:
> 
>  * VLAN handling
>  * FDB handling
>  * Port statistics
>  * STP
>  * Phylink
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
> +
> +/* Default setup for DSA:
> + *  VLAN 2: CPU and Port 1 egress untagged.
> + *  VLAN 3: CPU and Port 2 egress untagged.
> + */
> +static int hellcreek_setup_vlan_membership(struct dsa_switch *ds, int port,
> +					   bool enabled)

If you use VLAN 2 and 3 for port separation, then how does the driver
deal with the following:

ip link add link swp1 name swp1.100 type vlan id 100
ip link add link swp2 name swp2.100 type vlan id 100

In this case, frames with VLAN 100 shouldn't leak from one port to the
other, will they?

> +{
> +	int upstream = dsa_upstream_port(ds, port);
> +	struct switchdev_obj_port_vlan vlan = {
> +		.vid_begin = port,
> +		.vid_end = port,
> +	};
> +	int err = 0;
> +
> +	/* The CPU port is implicitly configured by
> +	 * configuring the front-panel ports
> +	 */
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
> +	/* Apply vid to port as egress untagged and port vlan id */
> +	vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID;
> +	if (enabled)
> +		hellcreek_vlan_add(ds, port, &vlan);
> +	else
> +		err = hellcreek_vlan_del(ds, port, &vlan);
> +	if (err) {
> +		dev_err(ds->dev, "Failed to apply VID %d to port %d: %d\n",
> +			port, port, err);
> +		return err;
> +	}
> +
> +	/* Apply vid to cpu port as well */
> +	vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED;
> +	if (enabled)
> +		hellcreek_vlan_add(ds, upstream, &vlan);
> +	else
> +		err = hellcreek_vlan_del(ds, upstream, &vlan);
> +	if (err) {
> +		dev_err(ds->dev, "Failed to apply VID %d to port %d: %d\n",
> +			port, port, err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void hellcreek_setup_ingressflt(struct hellcreek *hellcreek, int port,
> +				       bool enable)
> +{
> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
> +	u16 ptcfg;
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	ptcfg = hellcreek_port->ptcfg;
> +
> +	if (enable)
> +		ptcfg |= HR_PTCFG_INGRESSFLT;
> +	else
> +		ptcfg &= ~HR_PTCFG_INGRESSFLT;
> +
> +	hellcreek_select_port(hellcreek, port);
> +	hellcreek_write(hellcreek, ptcfg, HR_PTCFG);
> +	hellcreek_port->ptcfg = ptcfg;
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +}
> +
> +static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
> +				    bool vlan_filtering)

I remember asking in Message-ID: <20200716082935.snokd33kn52ixk5h@skbuf>
whether it would be possible for you to set
ds->configure_vlan_while_not_filtering = true during hellcreek_setup.
Did anything unexpected happen while trying that?

> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +
> +	dev_dbg(hellcreek->dev, "%s VLAN filtering on port %d\n",
> +		vlan_filtering ? "Enable" : "Disable", port);
> +
> +	/* Configure port to drop packages with not known vids */
> +	hellcreek_setup_ingressflt(hellcreek, port, vlan_filtering);
> +
> +	/* Drop DSA vlan membership config. The user can now do it. */
> +	hellcreek_setup_vlan_membership(ds, port, !vlan_filtering);
> +
> +	return 0;
> +}
> +

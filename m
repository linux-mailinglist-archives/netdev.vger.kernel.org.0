Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA8587B2A
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbiHBK7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236649AbiHBK7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:59:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F543286CC;
        Tue,  2 Aug 2022 03:59:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dc19so2540395ejb.12;
        Tue, 02 Aug 2022 03:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IX4JVwOdpTF1p2CR8tKM1WnNVnt9/39lsNOtwtKbZTI=;
        b=okC4YO5KqwR9XvSJlxxzLdjbMGPqY4ggh+sbxBKViwN0qc4labM+BAK6I+z5uQDgcS
         zMS8OfuiiWdahBE6PkzLmKCVqo91qzDL8mUAv28dK3ffrUalm/1P9p2O/dwDaZC5LP1W
         /wZxkxHMJXiHi9s1wRjDfMzWDMnThKepbqZ3WrR4FE9jN+Zve3iTrDhv0iaEdSDMzthF
         sLeyfED8rsc4CA8FGBzlYPIToruTJS5E7+hYB7FwmPHhK7207ne93/bLk2BMa9vfgbOl
         UdSTdLyIN18xkLSYYvNjQLLEatefcNWCGCmlUi1Tp73Ee/7oANT0BleOHtzSSdpiqham
         6SmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IX4JVwOdpTF1p2CR8tKM1WnNVnt9/39lsNOtwtKbZTI=;
        b=SCpRW6xXqslPt92X0FNFtjW4ZsmuW20uH6h6i8K1qAqOklPUeBxunZWiDVA9I8SCnJ
         NtHGOIw0OMiHqxY38G2yJT4KmWA2FLiSHjDRixXJnG512JUg4jlj77LxHEKuG6jg55/j
         nmgeW5iDWT/NwqdB80G1LyQA3ZB8o3d0L4XArDzApbYs21UMPxAPhNewPzBYYQ/t9DCc
         mvVegGOLxnM5MdBpNX3lUBxxXJZ4NwH1r1bfQbjBwFfy5lVRUqH1ZW1RdzuB+yK1DXAc
         hiPAC8TzMS257oMUGkABhJeGSg0tkthXP9hfv3ZJSLARNA+lVEObHniXv7JMHMgfF/XA
         gzAg==
X-Gm-Message-State: AJIora/vLYGi2b5ux/L+22NBurGLk0SK984gvPpzbSj1vI4zb+TzuQ7C
        97FT/BQ84NhFjRXH+oWqa+8=
X-Google-Smtp-Source: AGRyM1tZgR7N0/W51//RcfTMdjMbEhbjvSP+OgU0K5WcH8OJoAj/n2HnvnkqA+Ppl+h8iJb/bPqYaA==
X-Received: by 2002:a17:906:844c:b0:72b:4d77:fd83 with SMTP id e12-20020a170906844c00b0072b4d77fd83mr15757356ejy.151.1659437977918;
        Tue, 02 Aug 2022 03:59:37 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id ku7-20020a170907788700b0073092b543c3sm1741009ejc.141.2022.08.02.03.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:59:37 -0700 (PDT)
Date:   Tue, 2 Aug 2022 13:59:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch RFC net-next 4/4] net: dsa: microchip: use private pvid
 for bridge_vlan_unwaware
Message-ID: <20220802105935.gjjc3ft6zf35xrhr@skbuf>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-5-arun.ramadoss@microchip.com>
 <20220729151733.6032-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729151733.6032-5-arun.ramadoss@microchip.com>
 <20220729151733.6032-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:47:33PM +0530, Arun Ramadoss wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 516fb9d35c87..8a5583b1f2f4 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -161,6 +161,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
>  	.vlan_filtering = ksz8_port_vlan_filtering,
>  	.vlan_add = ksz8_port_vlan_add,
>  	.vlan_del = ksz8_port_vlan_del,
> +	.drop_untagged = ksz8_port_enable_pvid,

You'll have to explain this one. What impact does PVID insertion on KSZ8
have upon dropping/not dropping untagged packets? This patch is saying
that when untagged packets should be dropped, PVID insertion should be
enabled, and when untagged packets should be accepted, PVID insertion
should be disabled. How come?

>  	.mirror_add = ksz8_port_mirror_add,
>  	.mirror_del = ksz8_port_mirror_del,
>  	.get_caps = ksz8_get_caps,
> @@ -187,6 +188,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.vlan_filtering = ksz9477_port_vlan_filtering,
>  	.vlan_add = ksz9477_port_vlan_add,
>  	.vlan_del = ksz9477_port_vlan_del,
> +	.drop_untagged = ksz9477_port_drop_untagged,
>  	.mirror_add = ksz9477_port_mirror_add,
>  	.mirror_del = ksz9477_port_mirror_del,
>  	.get_caps = ksz9477_get_caps,
> @@ -220,6 +222,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
>  	.vlan_filtering = ksz9477_port_vlan_filtering,
>  	.vlan_add = ksz9477_port_vlan_add,
>  	.vlan_del = ksz9477_port_vlan_del,
> +	.drop_untagged = ksz9477_port_drop_untagged,
>  	.mirror_add = ksz9477_port_mirror_add,
>  	.mirror_del = ksz9477_port_mirror_del,
>  	.get_caps = lan937x_phylink_get_caps,
> @@ -1254,6 +1257,9 @@ static int ksz_enable_port(struct dsa_switch *ds, int port,
>  {
>  	struct ksz_device *dev = ds->priv;
>  
> +	dev->dev_ops->vlan_add(dev, port, KSZ_DEFAULT_VLAN,
> +			       BRIDGE_VLAN_INFO_UNTAGGED);
> +

How many times can this be executed before the VLAN add operation fails
due to the VLAN already being present on the port? I notice you're
ignoring the return code. Wouldn't it be better to do this at
port_setup() time instead?

(side note, the PVID for standalone mode can be added at port_setup
time. The PVID to use for bridges in VLAN-unaware mode can be allocated
at port_bridge_join time)

>  	if (!dsa_is_user_port(ds, port))
>  		return 0;
>  
> +static int ksz_commit_pvid(struct dsa_switch *ds, int port)
> +{
> +	struct dsa_port *dp = dsa_to_port(ds, port);
> +	struct net_device *br = dsa_port_bridge_dev_get(dp);
> +	struct ksz_device *dev = ds->priv;
> +	u16 pvid = KSZ_DEFAULT_VLAN;
> +	bool drop_untagged = false;
> +	struct ksz_port *p;
> +
> +	p = &dev->ports[port];
> +
> +	if (br && br_vlan_enabled(br)) {
> +		pvid = p->bridge_pvid.vid;
> +		drop_untagged = !p->bridge_pvid.valid;
> +	}

This is better in the sense that it resolves the need for the
configure_vlan_while_not_filtering hack. But standalone and VLAN-unaware
bridge ports still share the same PVID. Even more so, standalone ports
have address learning enabled, which will poison the address database of
VLAN-unaware bridge ports (and of other standalone ports):
https://patchwork.kernel.org/project/netdevbpf/patch/20220802002636.3963025-1-vladimir.oltean@nxp.com/

Are you going to do further work in this area?

> +
> +	ksz_set_pvid(dev, port, pvid);
> +
> +	if (dev->dev_ops->drop_untagged)
> +		dev->dev_ops->drop_untagged(dev, port, drop_untagged);
> +
> +	return 0;
> +}

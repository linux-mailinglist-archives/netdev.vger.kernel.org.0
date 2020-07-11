Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5FD21C62E
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgGKUdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgGKUds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:33:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D20C08C5DD;
        Sat, 11 Jul 2020 13:33:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x9so3675636plr.2;
        Sat, 11 Jul 2020 13:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xxFyaTUDlqYZPiLx7cw6iQb0IzTdQPTWfU0Rwm0JlVs=;
        b=GdGMnsDIMOZOWOPuNXUOM+uDbuRvSMwew9gZCRAJjrgpa5vgg9Kub94xh3o3yE8QEe
         +dO+zxVz4e4+CvVcIaOb82TQCFx6ob06qa54y9znY5sMWVgiq4FOp7fe5C4jKFnv8yg4
         0ZpfrfO+3KGUUxXfSHnGGzQiMjYBBHNpMuP0K9WlAIhssIMnYIa2M1+3cipRmedhoW7m
         2D4D5Sijg2v2Lo+O9lQCoQa9tNYva4TuoZWmJPR+V57nQeZfeGlojXb6IzLR2FnuqBN/
         SiBmqcLUqCekZwAQ88krleYV6r6xApsmngOPT/f9zHAgGB+LOzzYYFjCvag+cKSTCWko
         iZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xxFyaTUDlqYZPiLx7cw6iQb0IzTdQPTWfU0Rwm0JlVs=;
        b=BJH5hDGmAeIgiVkzHSVqFUvlHjVNeebSMmLK5sIMwpJNkQUOsPwIZjDwGee0H5/xW/
         Y7LUVeROOYcNTBzizu6AE7Pisn7dYJKq4QI/Q6gO8sGZYQQHcCRx+RmxtB3iHfqkhbbZ
         zdWvi3qt+PsW0gzV5LFbimAm/Nlsil91M6wwcvk0ej0L5wWMmp319EFYDYbhH0WlpfNx
         WV6nIPxXiVyPC5+535ktQ5eI+ZN6pu+GAMKeGSg5wXMEXcptUcyYV/dHW8h0SudMdQtr
         OAuNEEp9vxCb1fKyoxEYojnieo00yt9AExIWNV9Okt79f70AtY/VNmoOyD2qNcF/geUs
         eVKw==
X-Gm-Message-State: AOAM530byRaLqYYmmK2jrifAGwhsdgZeF32s1xrllm2GQwaYgOjsTYa2
        SAL5T21hjxHeop1OiJgn1Bo=
X-Google-Smtp-Source: ABdhPJx+P/rbJNgnNcf2dS/WX3yEMvUnmLoRU3TpttDH25GlFyhkUSewo5kXXHsU++8pT1+vzAtYzA==
X-Received: by 2002:a17:90a:65c7:: with SMTP id i7mr12080271pjs.103.1594499628074;
        Sat, 11 Jul 2020 13:33:48 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:108c:a2dd:75d1:a903? ([2001:470:67:5b9:108c:a2dd:75d1:a903])
        by smtp.gmail.com with ESMTPSA id s12sm9166097pgp.54.2020.07.11.13.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 13:33:47 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v1 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-3-kurt@linutronix.de>
Message-ID: <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com>
Date:   Sat, 11 Jul 2020 13:33:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710113611.3398-3-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
> implementing features needed for Time Sensitive Networking (TSN) such as support
> for the Time Precision Protocol and various shapers like the Time Aware Shaper.
> 
> This driver includes basic support for networking:
> 
>   * VLAN handling
>   * FDB handling
>   * Port statistics
>   * STP
>   * Phylink
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

[snip]

> +++ b/drivers/net/dsa/hirschmann/Kconfig
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config NET_DSA_HIRSCHMANN_HELLCREEK
> +	tristate "Hirschmann Hellcreek TSN Switch support"
> +	depends on NET_DSA

You most likely need a depends on HAS_IOMEM since this is a memory
mapped interface.

[snip]

> +static void hellcreek_select_port(struct hellcreek *hellcreek, int port)
> +{
> +	u16 val = 0;
> +
> +	val |= port << HR_PSEL_PTWSEL_SHIFT;

Why not just assign val to port << HR_PSEL_PTWSEL_SHIFT directly?

> +
> +	hellcreek_write(hellcreek, val, HR_PSEL);
> +}
> +
> +static void hellcreek_select_prio(struct hellcreek *hellcreek, int prio)
> +{
> +	u16 val = 0;
> +
> +	val |= prio << HR_PSEL_PRTCWSEL_SHIFT;
> +
> +	hellcreek_write(hellcreek, val, HR_PSEL);

Likewise

> +}
> +
> +static void hellcreek_select_counter(struct hellcreek *hellcreek, int counter)
> +{
> +	u16 val = 0;
> +
> +	val |= counter << HR_CSEL_SHIFT;
> +
> +	hellcreek_write(hellcreek, val, HR_CSEL);
> +
> +	/* Data sheet states to wait at least 20 internal clock cycles */
> +	ndelay(200);

Likewise.

[snip]

> +static void hellcreek_feature_detect(struct hellcreek *hellcreek)
> +{
> +	u16 features;
> +
> +	features = hellcreek_read(hellcreek, HR_FEABITS0);
> +
> +	/* Currently we only detect the size of the FDB table */
> +	hellcreek->fdb_entries = ((features & HR_FEABITS0_FDBBINS_MASK) >>
> +			       HR_FEABITS0_FDBBINS_SHIFT) * 32;
> +
> +	dev_info(hellcreek->dev, "Feature detect: FDB entries=%zu\n",
> +		 hellcreek->fdb_entries);

You may consider reporting this through devlink.

> +}
> +
> +static enum dsa_tag_protocol hellcreek_get_tag_protocol(struct dsa_switch *ds,
> +							int port,
> +							enum dsa_tag_protocol mp)
> +{
> +	return DSA_TAG_PROTO_HELLCREEK;
> +}
> +
> +static int hellcreek_port_enable(struct dsa_switch *ds, int port,
> +				 struct phy_device *phy)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +	unsigned long flags;
> +	u16 val;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "Enable port %d\n", port);
> +
> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);

Your usage of the spin lock is not entirely clear to me, but it protects
more than just the register access, usually it has been sprinkled at the
very beginning of the operations to be performed.

DSA operations should always be RTNL protected and they can sleep. You
do not appear to have an interrupt handler registered at all, so maybe
you can replace this by a mutex, or drop the spin lock entirely?

[snip]

> +static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
> +				      struct net_device *br)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	u16 rx_vid = port;
> +	int i;
> +
> +	dev_dbg(hellcreek->dev, "Port %d joins a bridge\n", port);
> +
> +	/* Configure port's vid to all other ports as egress untagged */
> +	for (i = 2; i < NUM_PORTS; ++i) {
> +		const struct switchdev_obj_port_vlan vlan = {
> +			.vid_begin = rx_vid,
> +			.vid_end = rx_vid,
> +			.flags = BRIDGE_VLAN_INFO_UNTAGGED,
> +		};
> +
> +		if (i == port)
> +			continue;
> +
> +		hellcreek_vlan_add(ds, i, &vlan);

Can you explain that part a little bit more what this VLAN programming
does and why you need it?

The bridge will send a VLAN programming request with VLAN ID 1 as PVID,
thus bringing all ports added to the bridge into the same broadcast domain.

> +	}
> +
> +	return 0;
> +}
> +
> +static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
> +					struct net_device *br)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	u16 rx_vid = port;
> +	int i, err;
> +
> +	dev_dbg(hellcreek->dev, "Port %d leaves a bridge\n", port);
> +
> +	/* Remove port's vid from all other ports */
> +	for (i = 2; i < NUM_PORTS; ++i) {
> +		const struct switchdev_obj_port_vlan vlan = {
> +			.vid_begin = rx_vid,
> +			.vid_end = rx_vid,
> +		};
> +
> +		if (i == port)
> +			continue;
> +
> +		err = hellcreek_vlan_del(ds, i, &vlan);
> +		if (err) {
> +			dev_err(hellcreek->dev, "Failed add vid %d to port %d\n",
> +				rx_vid, i);
> +			return;
> +		}
> +	}
> +}
> +
> +static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
> +			       const struct hellcreek_fdb_entry *entry)
> +{
> +	int ret;
> +	u16 meta = 0;
> +
> +	dev_dbg(hellcreek->dev, "Add static FDB entry: MAC=%pM, MASK=0x%02x, "
> +		"OBT=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac, entry->portmask,
> +		entry->is_obt, entry->reprio_en, entry->reprio_tc);
> +
> +	/* Add mac address */
> +	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FDBWDH);
> +	hellcreek_write(hellcreek, entry->mac[3] | (entry->mac[2] << 8), HR_FDBWDM);
> +	hellcreek_write(hellcreek, entry->mac[5] | (entry->mac[4] << 8), HR_FDBWDL);
> +
> +	/* Meta data */
> +	meta |= entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
> +	if (entry->is_obt)
> +		meta |= HR_FDBWRM0_OBT;
> +	if (entry->reprio_en) {
> +		meta |= HR_FDBWRM0_REPRIO_EN;
> +		meta |= entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
> +	}
> +	hellcreek_write(hellcreek, meta, HR_FDBWRM0);
> +
> +	/* Commit */
> +	hellcreek_write(hellcreek, 0x00, HR_FDBWRCMD);
> +
> +	/* Wait until done */
> +	ret = hellcreek_wait_fdb_ready(hellcreek);
> +
> +	return ret;

Can you just do a tail call return here?

> +}
> +
> +static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
> +			       const struct hellcreek_fdb_entry *entry)
> +{
> +	int ret;
> +
> +	dev_dbg(hellcreek->dev, "Delete FDB entry: MAC=%pM!\n", entry->mac);
> +
> +	/* Delete by matching idx */
> +	hellcreek_write(hellcreek, entry->idx | HR_FDBWRCMD_FDBDEL, HR_FDBWRCMD);
> +
> +	/* Wait until done */
> +	ret = hellcreek_wait_fdb_ready(hellcreek);
> +
> +	return ret;

Likewise

> +}
> +
> +/* Retrieve the index of a FDB entry by mac address. Currently we search through
> + * the complete table in hardware. If that's too slow, we might have to cache
> + * the complete FDB table in software.
> + */
> +static int hellcreek_fdb_get(struct hellcreek *hellcreek,
> +			     const unsigned char *dest,
> +			     struct hellcreek_fdb_entry *entry)
> +{
> +	size_t i;
> +
> +	/* Set read pointer to zero: The read of HR_FDBMAX (read-only register)
> +	 * should reset the internal pointer. But, that doesn't work. The vendor
> +	 * suggested a subsequent write as workaround. Same for HR_FDBRDH below.
> +	 */
> +	hellcreek_read(hellcreek, HR_FDBMAX);
> +	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
> +
> +	/* We have to read the complete table, because the switch/driver might
> +	 * enter new entries anywhere.
> +	 */
> +	for (i = 0; i < hellcreek->fdb_entries; ++i) {
> +		unsigned char addr[ETH_ALEN];
> +		u16 meta, mac;
> +
> +		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
> +		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
> +		addr[5] = mac & 0xff;
> +		addr[4] = (mac & 0xff00) >> 8;
> +		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
> +		addr[3] = mac & 0xff;
> +		addr[2] = (mac & 0xff00) >> 8;
> +		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
> +		addr[1] = mac & 0xff;
> +		addr[0] = (mac & 0xff00) >> 8;
> +
> +		/* Force next entry */
> +		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
> +
> +		if (memcmp(addr, dest, 6))

ETH_ALEN instead of 6 would make it obvious what this is about, don't
you also need to compare against a VLAN ID somehow?

[snip]

> +
> +/* Default setup for DSA:
> + *  VLAN 2: CPU and Port 1 egress untagged.
> + *  VLAN 3: CPU and Port 2 egress untagged.

Can you use any of the DSA_TAG_8021Q services to help you with that?

[snip]

> +
> +static const struct dsa_switch_ops hellcreek_ds_ops = {
> +	.get_tag_protocol    = hellcreek_get_tag_protocol,
> +	.setup		     = hellcreek_setup,
> +	.get_strings	     = hellcreek_get_strings,
> +	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
> +	.get_sset_count	     = hellcreek_get_sset_count,
> +	.port_enable	     = hellcreek_port_enable,
> +	.port_disable	     = hellcreek_port_disable,
> +	.port_vlan_filtering = hellcreek_vlan_filtering,
> +	.port_vlan_prepare   = hellcreek_vlan_prepare,
> +	.port_vlan_add	     = hellcreek_vlan_add,
> +	.port_vlan_del	     = hellcreek_vlan_del,
> +	.port_fdb_dump	     = hellcreek_fdb_dump,
> +	.port_fdb_add	     = hellcreek_fdb_add,
> +	.port_fdb_del	     = hellcreek_fdb_del,
> +	.port_bridge_join    = hellcreek_port_bridge_join,
> +	.port_bridge_leave   = hellcreek_port_bridge_leave,
> +	.port_stp_state_set  = hellcreek_port_stp_state_set,> +	.phylink_validate    = hellcreek_phylink_validate,

No mac_config, mac_link_up or mac_link_down operations?
-- 
Florian

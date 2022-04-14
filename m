Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7142501A86
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343979AbiDNRyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344003AbiDNRyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:54:10 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FA1EA778;
        Thu, 14 Apr 2022 10:51:43 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bv19so11486549ejb.6;
        Thu, 14 Apr 2022 10:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nlqwP4UUnq0R6X0+WoQ+ML6A0vXz2Dv8iv4/BWGtsr4=;
        b=DQCxjdMf9oR4ppuOzp9JfND9MyZ2mTXUgnu/FL25yTwVnbgoP5TsgPmrsfTIToUCnG
         6HjPEhiGR/UWbOsbZGCjPOgVjac6GMgfE3IpxXEGukmzdpbqRgrSsNSIN/Wn9GFqAV8u
         eYL+pkY5kcq3TYPUp8055rTszImgiPjCTUytvScDGRfAqkOCpalISTJPjX/UvK1Uxkc6
         K0ae9wBDfVXbWQlhkyZ57qELiHlxCZKkNaVrDS7NfjLaqUjgqOPX1cAWf+iO2SWu6h/y
         ua52Sx/gw+uka1Y/GpB4jcjvntLDZ4bzAgtFK5DkIML4xUxLaHBrche8vGSjjsu/oayZ
         CLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nlqwP4UUnq0R6X0+WoQ+ML6A0vXz2Dv8iv4/BWGtsr4=;
        b=ZfcPXPoNbyC4deQfEGdOhcQFhGWgy3/td8nLoHmMKm8yPVtlzQXoMAOk6L7HbND5wY
         bYCoTb+COlZDW/F/B/LvQUN9ckXNL6PjKGnHoaUzvnuNhPuj/7kmW174LG1fstsbx+KA
         JHr3nRL5/4DbHYXk2mw1sQdYHLuZqG46rjlMM0q6rku9dMXB00MweCueEWPwYX9Eduo6
         zqCah3yIjx6lOS7I0+vdLpKgnCabYoAoH//czs8M8ERVqMRqMfzjkIV80lPg4rcydb0C
         f0OZCKn7W0n+XwwyTUCUtjCWbhAtJDod53/U16FWe3w7SZWqFC+nSM+GUCBn7VX6G8xN
         QlPA==
X-Gm-Message-State: AOAM532CZNxCGWIUhxSQBbgnkLF9i8DKvu/rzb0wHpFeu0/0dl0+7v7r
        YkGAtRcMgFe4aEjOKM0Cczk=
X-Google-Smtp-Source: ABdhPJyTUSQpMDRq1qUtr/aZ5NMUfO5Ti1xW1kE46bXpPlC0VauPmp4yzhTpYmEcen2/UVJcDcRJug==
X-Received: by 2002:a17:907:8a26:b0:6e1:2646:ef23 with SMTP id sc38-20020a1709078a2600b006e12646ef23mr3493305ejc.109.1649958702327;
        Thu, 14 Apr 2022 10:51:42 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id w6-20020a170906184600b006e8914a0a9fsm844606eje.88.2022.04.14.10.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:51:41 -0700 (PDT)
Date:   Thu, 14 Apr 2022 20:51:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220414175140.p2vyy7f7yk6vlomi@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-9-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-9-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:46PM +0200, Clément Léger wrote:
> This commits add forwarding database support to the driver. It
> implements fdb_add(), fdb_del() and fdb_dump().
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 163 +++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/rzn1_a5psw.h |  16 ++++
>  2 files changed, 179 insertions(+)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 7ab7d9054427..8c763c2a1a1f 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -369,6 +369,166 @@ static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
>  	a5psw_port_fdb_flush(a5psw, port);
>  }
>  
> +static int a5psw_lk_execute_lookup(struct a5psw *a5psw, union lk_data *lk_data,
> +				   u16 *entry)
> +{
> +	u32 ctrl;
> +	int ret;
> +
> +	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_LO, lk_data->lo);
> +	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_HI, lk_data->hi);
> +
> +	ctrl = A5PSW_LK_ADDR_CTRL_LOOKUP;
> +	ret = a5psw_lk_execute_ctrl(a5psw, &ctrl);
> +	if (ret)
> +		return ret;
> +
> +	*entry = ctrl & A5PSW_LK_ADDR_CTRL_ADDRESS;
> +
> +	return 0;
> +}
> +
> +static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
> +			      const unsigned char *addr, u16 vid,
> +			      struct dsa_db db)

This isn't something that is documented because I haven't had time to
update that, but new drivers should comply to the requirements for FDB
isolation (not ignore the passed "db" here) and eventually set
ds->fdb_isolation = true. Doing so would allow your switch to behave
correctly when
- there is more than one bridge spanning its ports,
- some ports are standalone and some ports are bridged
- standalone ports are looped back via an external cable with bridged
  ports
- unrecognized upper interfaces (bond, team) are used, and those are
  bridged directly with some other switch ports

The most basic thing you need to do to satisfy the requirements is to
figure out what mechanism for FDB partitioning does your hardware have.
If the answer is "none", then we'll have to use VLANs for that: all
standalone ports to share a VLAN, each VLAN-unaware bridge to share a
VLAN across all member ports, each VLAN of a VLAN-aware bridge to
reserve its own VLAN. Up to a total of 32 VLANs, since I notice that's
what the limit for your hardware is.

But I see this patch set doesn't include VLAN functionality (and also
ignores the "vid" from FDB entries), so I can't really say more right now.
But if you could provide more information about the hardware
capabilities we can discuss implementation options.

> +{
> +	struct a5psw *a5psw = ds->priv;
> +	union lk_data lk_data = {0};
> +	bool inc_learncount = false;
> +	int ret = 0;
> +	u16 entry;
> +	u32 reg;
> +
> +	ether_addr_copy(lk_data.entry.mac, addr);
> +	lk_data.entry.port_mask = BIT(port);
> +
> +	spin_lock(&a5psw->lk_lock);
> +
> +	/* Set the value to be written in the lookup table */
> +	ret = a5psw_lk_execute_lookup(a5psw, &lk_data, &entry);
> +	if (ret)
> +		goto lk_unlock;
> +
> +	lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
> +	if (!lk_data.entry.valid) {
> +		inc_learncount = true;
> +		/* port_mask set to 0x1f when entry is not valid, clear it */
> +		lk_data.entry.port_mask = 0;
> +		lk_data.entry.prio = 0;
> +	}
> +
> +	lk_data.entry.port_mask |= BIT(port);
> +	lk_data.entry.is_static = 1;
> +	lk_data.entry.valid = 1;
> +
> +	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_HI, lk_data.hi);
> +
> +	reg = A5PSW_LK_ADDR_CTRL_WRITE | entry;
> +	ret = a5psw_lk_execute_ctrl(a5psw, &reg);
> +	if (ret)
> +		goto lk_unlock;
> +
> +	if (inc_learncount) {
> +		reg = A5PSW_LK_LEARNCOUNT_MODE_INC;
> +		a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
> +	}
> +
> +lk_unlock:
> +	spin_unlock(&a5psw->lk_lock);
> +
> +	return ret;
> +}
> +
> +static int a5psw_port_fdb_del(struct dsa_switch *ds, int port,
> +			      const unsigned char *addr, u16 vid,
> +			      struct dsa_db db)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	union lk_data lk_data = {0};
> +	bool clear = false;
> +	int ret = 0;
> +	u16 entry;
> +	u32 reg;
> +
> +	ether_addr_copy(lk_data.entry.mac, addr);
> +
> +	spin_lock(&a5psw->lk_lock);
> +
> +	ret = a5psw_lk_execute_lookup(a5psw, &lk_data, &entry);
> +	if (ret) {
> +		dev_err(a5psw->dev, "Failed to lookup mac address\n");
> +		goto lk_unlock;
> +	}
> +
> +	lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
> +	if (!lk_data.entry.valid) {
> +		dev_err(a5psw->dev, "Tried to remove non-existing entry\n");
> +		ret = -ENOENT;
> +		goto lk_unlock;
> +	}
> +
> +	lk_data.entry.port_mask &= ~BIT(port);
> +	/* If there is no more port in the mask, clear the entry */
> +	if (lk_data.entry.port_mask == 0)
> +		clear = true;
> +
> +	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_HI, lk_data.hi);
> +
> +	reg = entry;
> +	if (clear)
> +		reg |= A5PSW_LK_ADDR_CTRL_CLEAR;
> +	else
> +		reg |= A5PSW_LK_ADDR_CTRL_WRITE;
> +
> +	ret = a5psw_lk_execute_ctrl(a5psw, &reg);
> +	if (ret)
> +		goto lk_unlock;
> +
> +	/* Decrement LEARNCOUNT */
> +	if (clear) {
> +		reg = A5PSW_LK_LEARNCOUNT_MODE_DEC;
> +		a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
> +	}
> +
> +lk_unlock:
> +	spin_unlock(&a5psw->lk_lock);
> +
> +	return ret;
> +}
> +
> +static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
> +			       dsa_fdb_dump_cb_t *cb, void *data)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	union lk_data lk_data;
> +	int i = 0, ret;
> +	u32 reg;
> +
> +	for (i = 0; i < A5PSW_TABLE_ENTRIES; i++) {
> +		reg = A5PSW_LK_ADDR_CTRL_READ | A5PSW_LK_ADDR_CTRL_WAIT | i;
> +		spin_lock(&a5psw->lk_lock);
> +
> +		ret = a5psw_lk_execute_ctrl(a5psw, &reg);
> +		if (ret)
> +			return ret;
> +
> +		lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
> +		/* If entry is not valid or does not contain the port, skip */
> +		if (!lk_data.entry.valid ||
> +		    !(lk_data.entry.port_mask & BIT(port))) {
> +			spin_unlock(&a5psw->lk_lock);
> +			continue;
> +		}
> +
> +		lk_data.lo = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_LO);
> +		spin_unlock(&a5psw->lk_lock);
> +
> +		cb(lk_data.entry.mac, 0, lk_data.entry.is_static, data);

ret = cb(...)
if (ret)
	return ret;

This actually matters because the netlink skb used for the FDB dump may
run out of space and you'll have missing FDB entries.

> +	}
> +
> +	return 0;
> +}
> +
>  static void a5psw_get_strings(struct dsa_switch *ds, int port, u32 stringset,
>  			      uint8_t *data)
>  {
> @@ -500,6 +660,9 @@ const struct dsa_switch_ops a5psw_switch_ops = {
>  	.port_bridge_leave = a5psw_port_bridge_leave,
>  	.port_stp_state_set = a5psw_port_stp_state_set,
>  	.port_fast_age = a5psw_port_fast_age,
> +	.port_fdb_add = a5psw_port_fdb_add,
> +	.port_fdb_del = a5psw_port_fdb_del,
> +	.port_fdb_dump = a5psw_port_fdb_dump,
>  
>  };
>  
> diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> index b34ea549e936..37aa89383e70 100644
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -167,6 +167,22 @@
>  #define A5PSW_CTRL_TIMEOUT		1000
>  #define A5PSW_TABLE_ENTRIES		8192
>  
> +struct fdb_entry {

Shouldn't this contain something along the lines of a VID, FID, something?

> +	u8 mac[ETH_ALEN];
> +	u8 valid:1;
> +	u8 is_static:1;
> +	u8 prio:3;
> +	u8 port_mask:5;
> +} __packed;
> +
> +union lk_data {
> +	struct {
> +		u32 lo;
> +		u32 hi;
> +	};
> +	struct fdb_entry entry;
> +};
> +
>  /**
>   * struct a5psw - switch struct
>   * @base: Base address of the switch
> -- 
> 2.34.1
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E843351A577
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353445AbiEDQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353389AbiEDQ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:28:38 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0200146B1E;
        Wed,  4 May 2022 09:25:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p4so2323448edx.0;
        Wed, 04 May 2022 09:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gkHRcHfS7w5CofEz92GyvUhilsyAfWHpZdXGuml+4VI=;
        b=MrqFnnfdfWF3IOzivapO2Z8cc7tUZhGfNfCDgaaaZYHOHXli+Ztxq51reByvgEXBSb
         b9ra6Is1EknY41LaWR+eLf9e96M6uK861IP2bKSt2p+nV2xZGCZOMu0wz0EXWXFnTA6d
         hAhySow+RuM2cjPOqN66kEefedtcw5XuM+llYliwrX5v/udgH7xx6T7ru9qu/o2jxmvW
         NUehAzoLmoqiGxI5Zji5IEWo1hzrVoytemlfUNY9Cj5s3QGP4C3HuWFZ+MVSfPCJi6Jq
         ng28B3C9GVgLfhik7jImKEkTbnDGoVqh6tvUV4ivGaVb3ZK1+Pp0b2NvTw1l/JmZysGT
         9NBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gkHRcHfS7w5CofEz92GyvUhilsyAfWHpZdXGuml+4VI=;
        b=rwpA1xfwJsSCJNn1WLnNjeVZI1P3BYILUnJ8eW7M67n88Vte9uKwNfvPicDOQDuYd2
         MjI8RfINW55iFoE1Af/H+L8Y1tyBEAR/OLgxkpT8HhRwEI46Z97NGJBXhyDZGYq1EnzL
         RmROL1QL1tYVBiW2J/Yq4FILTUdIwx2ukmhmFvtsHGsavou5+CS1DIi6x6y6nYwurEZE
         iGotg+bU7H0vlhY9IvSR1UiISm6gpkUFLVSMmndXXnzUo/FddOqMMelygBdS2wgSso+v
         r2PEzcRdzf9fCwid3wMI2xjO/+fwUMbsy+YUC+s+vw5MirHUC4iP+QMLKPRMzKr7azeB
         J03w==
X-Gm-Message-State: AOAM533xFECbeCqVMgyC76deNu8FB5+X8kch/9a4Uo2b00Qi8SIpLZdC
        Pzid9c/Y/sM3Z1dvQdKmTFI=
X-Google-Smtp-Source: ABdhPJzrOLozI/AKcqatH8v1stPhqllmZWBNZ8Lbsg81cLGk5C+D6Wf5m4hKa/9s3lJRkAhtjHt48Q==
X-Received: by 2002:a05:6402:1941:b0:413:2b80:b245 with SMTP id f1-20020a056402194100b004132b80b245mr24287082edz.252.1651681500450;
        Wed, 04 May 2022 09:25:00 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id z3-20020aa7c643000000b0042617ba63bdsm9320765edr.71.2022.05.04.09.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:24:59 -0700 (PDT)
Date:   Wed, 4 May 2022 19:24:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 08/12] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220504162457.eeggo4xenvxddpkr@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
 <20220504093000.132579-9-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504093000.132579-9-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 11:29:56AM +0200, Clément Léger wrote:
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

These error messages can happen under quite normal use with your hardware.
For example:

ip link add br0 type bridge && ip link set br0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 vid 1 master static
bridge fdb add dev swp0 00:01:02:03:04:05 vid 2 master static
bridge fdb del dev swp0 00:01:02:03:04:05 vid 2 master static
bridge fdb del dev swp0 00:01:02:03:04:05 vid 1 master static

Because the driver ignores the VID, then as soon as the VID 2 FDB entry
is removed, the VID 1 FDB entry doesn't exist anymore, either.

The above is a bit artificial. More practically, the bridge installs
local FDB entries (MAC address of bridge device, MAC addresses of ports)
once in the VLAN-unaware database (VID 0), and once per VLAN installed
on br0.

When the MAC address of br0 is different from that of the ports, and it
is changed by the user, you'll get these errors too, since those changes
translate into a deletion of the old local FDB entries (installed as FDB
entries towards the CPU port). Do you want the users to see them and
think something is wrong?  I mean, something _is_ wrong (the hardware),
but you have to work with that somehow.

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

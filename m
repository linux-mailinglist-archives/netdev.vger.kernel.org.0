Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8783418E6D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 06:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhI0Eo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 00:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhI0Eo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 00:44:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E9EC061570
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 21:42:51 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so313700pjb.4
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=rMgSaqvZ1nSOH+evlGyBawrQ8UuZmrvb+lu4z8UOyV0=;
        b=pCvTr9pNIFN+mK+b7Ln3SnIUFYUwkpT+ZhtjMgz0pPlrmOM1uITA1NqTp9wX7Qci3j
         5EILZlKFPfOx8uQYpYZLMQ9TB/qQXzJYyO6k9qFI6HlpWhE1DfWu9kh5VJAqF1ePVOI3
         ryOK1ppXRgLdzZM9l4uWxaAnz8HulqQ5dch8w7tBRf841dOM/dyJMhDjlLncPp3YfeWk
         YLOK4yM+Ut0u7VaPAmpUdt11IcSm8xJthvZ+pl1aJfVEgmxhcVo8gM1JntCFYrtlMLFC
         PPNv4yd0bpL7CB/GlvDgUhTCAvOQq28aeDGgwF6Fg4jN4YI5hM5zQZv2eTtMB9i0nI5V
         mA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rMgSaqvZ1nSOH+evlGyBawrQ8UuZmrvb+lu4z8UOyV0=;
        b=EUl0aC2k/ZRcqYw1pgl63IzSp0BrPD3oUKqOt8exJ/5H6Y2efA1MPWtFiSxJDKGXq+
         phWerCa2WIV8YrSMdsXFrXT1oGV14uZecL8+xlRXAmPKW6DUG/U+BIsyM7bKZaRpNj62
         ao2j56H48zhuP7gUQ25/hPLst6QPNkzRMo/Em9mmrza8MPOdMJUdYj8xqiW3nsSPrrXn
         PVUuRlmqVD/ZKFGjwQQLbC9EKuRmVaFOJvKY6qqv8lXuUoF3y4GZBR0SSRm/Zb9e0PgF
         4S3kJyl0GUB3JyCIxJzo23Pewc4Qq4HSMgWEwc3upX/CDyt/ml+ITzVnRdofuGIhnfGF
         1ekQ==
X-Gm-Message-State: AOAM530ArzxiYHGmN2aDFyViwqaHfjgYl7uhM0ItC60QDkcmksdRLx1F
        Os3OoMfG9+myteysXDGlcN19WCjcUJDZaKHS
X-Google-Smtp-Source: ABdhPJzblm9OjH1affWS0OgQi4b3guk+NFlucjYWhfJYPnsi8gTdkAWJEBIA2SsxYBQM7stDU4sDoA==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr17108167pjg.191.1632717770646;
        Sun, 26 Sep 2021 21:42:50 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g9sm15303131pfh.13.2021.09.26.21.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 21:42:49 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 3/6 v7] net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
Date:   Mon, 27 Sep 2021 12:42:42 +0800
Message-Id: <20210927044242.760492-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925225929.2082046-4-linus.walleij@linaro.org>
References: <20210925225929.2082046-1-linus.walleij@linaro.org> <20210925225929.2082046-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 12:59:26AM +0200, Linus Walleij wrote:
> Implement the correct callback: we have two registers dealing
> with filtering on the RTL9366RB, so we implement an ASIC-specific

Typo

> callback and implement filering using the register bit that makes
> the switch drop frames if the port is not in the VLAN member set.
> 
> The DSA documentation Documentation/networking/switchdev.rst states:
> 
>   When the bridge has VLAN filtering enabled and a PVID is not
>   configured on the ingress port, untagged and 802.1p tagged
>   packets must be dropped. When the bridge has VLAN filtering
>   enabled and a PVID exists on the ingress port, untagged and
>   priority-tagged packets must be accepted and forwarded according
>   to the bridge's port membership of the PVID VLAN. When the
>   bridge has VLAN filtering disabled, the presence/lack of a
>   PVID should not influence the packet forwarding decision.
> 
> To comply with this, we add two arrays of bool in the RTL8366RB
> state that keeps track of if filtering and PVID is enabled or

You can use dsa_port_is_vlan_filtering() instead.

>  static struct rtl8366_mib_counter rtl8366rb_mib_counters[] = {
> @@ -933,11 +952,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> -	/* Discard VLAN tagged packets if the port is not a member of
> -	 * the VLAN with which the packets is associated.
> -	 */
> +	/* Accept all packets by default, we enable filtering on-demand */
> +	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
> +			   0);
> +	if (ret)
> +		return ret;
>  	ret = regmap_write(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
> -			   RTL8366RB_PORT_ALL);
> +			   0);
>  	if (ret)
>  		return ret;
>  
> @@ -1209,6 +1230,53 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
>  			   RTL8366RB_PORT_ISO_PORTS(port_bitmap), 0);
>  }
>  
> +/**
> + * rtl8366rb_drop_untagged() - make the switch drop untagged and C-tagged frames
> + * @smi: SMI state container
> + * @port: the port to drop untagged and C-tagged frames on
> + * @drop: whether to drop or pass untagged and C-tagged frames
> + */
> +static int rtl8366rb_drop_untagged(struct realtek_smi *smi, int port, bool drop)
> +{
> +	return regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL1_REG,
> +				  RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port),
> +				  drop ? RTL8366RB_VLAN_INGRESS_CTRL1_DROP(port) : 0);
> +}
> +
> +static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
> +				    bool vlan_filtering,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	struct rtl8366rb *rb;
> +	int ret;

Can standalone ports or VLAN-unaware bridges send/receive VLAN-tagged frames as
is? If not, please take a look at rtl8368s_setAsicVlanKeepCtagFormat function
in the vendor driver. Set the registers to all 1's in setup function, and
change them here.

> +
> +	rb = smi->chip_data;
> +
> +	dev_dbg(smi->dev, "port %d: %s VLAN filtering\n", port,
> +		vlan_filtering ? "enable" : "disable");
> +
> +	/* If the port is not in the member set, the frame will be dropped */
> +	ret = regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
> +				 BIT(port), vlan_filtering ? BIT(port) : 0);
> +	if (ret)
> +		return ret;
> +
> +	/* Keep track if filtering is enabled on each port */
> +	rb->vlan_filtering[port] = vlan_filtering;
> +
> +	/* If VLAN filtering is enabled and PVID is also enabled, we must
> +	 * not drop any untagged or C-tagged frames. If we turn off VLAN
> +	 * filtering on a port, we need ti accept any frames.

Typo

> +	 */
> +	if (vlan_filtering)
> +		ret = rtl8366rb_drop_untagged(smi, port, !rb->pvid_enabled[port]);
> +	else
> +		ret = rtl8366rb_drop_untagged(smi, port, false);

Can be simplified as
rtl8366rb_drop_untagged(smi, port, vlan_filtering && !rb->pvid_enabled[port]);

> +
> +	return ret;
> +}

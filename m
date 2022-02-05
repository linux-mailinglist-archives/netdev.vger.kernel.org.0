Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76264AA634
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379183AbiBED12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:27:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33678 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiBED10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:27:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE39AB83938;
        Sat,  5 Feb 2022 03:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E22C340E8;
        Sat,  5 Feb 2022 03:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644031643;
        bh=KCoKMnSN8XeAkkrt4NMq0x8wGofgwF4v98ZOjZJ/OpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rjP393CHvDx8PFubO7Ox4ZDVwt5wOL/0EfquqUWUqG9TCLF/W0NNHWTwCQBzYa7rG
         oWxiXZVPjY4ZH4xSQqXWLnkVancCEc/ehnyl+3o68G/r08L9CLEvxgFFS6m4ehp0JA
         GPldCZk0kFQS242FlZSyRonZc5Ub4Zl6Z2hu0ksPXJ4UO753hC1DJtyANcASDJUZxF
         MmYipDkO1a9nQCBvy0Aj/BfbN4I8a31V9AsSIKLIV/MUbfyC6HXA2h1D1hEpAg2OOB
         NgTfIxBY67vtUzj8rCiSsZZiai8NG7GxXZpR8XUjWspj6jnsSo2axvKOb0IzO17gOy
         KAdKuT5hD79Ow==
Date:   Fri, 4 Feb 2022 19:27:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 net-next 07/10] net: dsa: microchip: add support for
 ethtool port counters
Message-ID: <20220204192721.21835705@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204174500.72814-8-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
        <20220204174500.72814-8-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 23:14:57 +0530 Prasanna Vengateshan wrote:
> +static void lan937x_get_strings(struct dsa_switch *ds, int port, u32 stringset,
> +				uint8_t *buf)

not stdint types in the kernel, please use u8 instead

> +{
> +	struct ksz_device *dev = ds->priv;
> +	int i;
> +
> +	if (stringset != ETH_SS_STATS)
> +		return;
> +
> +	for (i = 0; i < dev->mib_cnt; i++) {
> +		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
> +		       ETH_GSTRING_LEN);
> +	}

parenthesis unnecessary around single expression

Also check out ethtool_sprintf(), although not strictly necessary since
you're not formatting

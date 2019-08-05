Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95F582764
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfHEWL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:11:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbfHEWL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 18:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CJCz2EY5Ag3J5AxOUx+/pQJH9PKhgAABBlxZIzlms+Q=; b=MLe8jpNoVmGyLtQqBN2RDThUa+
        m6e/MUFPCbgPn6MTNbLjZsmKIaD6FMr/E7xxqzZVA7QztM1UVG3Han3dTUxNq8kI7L/awdVMU3jTj
        bTLNJUQaeciG0KXmfLJclxY5kHQpGPjbrAyJ0nJlCt2sT7gRhmeNZNd0nhwgqNGzDku8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hulCo-0001fO-Ci; Tue, 06 Aug 2019 00:11:50 +0200
Date:   Tue, 6 Aug 2019 00:11:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 10/16] net: phy: adin: add EEE translation layer for
 Clause 22
Message-ID: <20190805221150.GE25700@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-11-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-11-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin_cl22_to_adin_reg(int devad, u16 cl22_regnum)
> +{
> +	struct clause22_mmd_map *m;
> +	int i;
> +
> +	if (devad == MDIO_MMD_VEND1)
> +		return cl22_regnum;
> +
> +	for (i = 0; i < ARRAY_SIZE(clause22_mmd_map); i++) {
> +		m = &clause22_mmd_map[i];
> +		if (m->devad == devad && m->cl22_regnum == cl22_regnum)
> +			return m->adin_regnum;
> +	}
> +
> +	pr_err("No translation available for devad: %d reg: %04x\n",
> +	       devad, cl22_regnum);

phydev_err(). 

	      Andrew

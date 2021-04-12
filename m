Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B834435D3EC
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344103AbhDLXZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237594AbhDLXZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B95356117A;
        Mon, 12 Apr 2021 23:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618269911;
        bh=8QG07yo2K7Dq82DhFt4x/CRGsKmIlCalkJF2oJJUeW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=opILwwLPfSjyUTuhgnq28UTotplWWvY+ZR5GFhP52CXxJlC5bDiQbI0k8BQx3aoor
         LBdX30bf20/cCiAi7YseA8M/3rrX9ySt1zvgCy/1WxzCxsMJ52HQHpcOdm1TjGqdIY
         YvRepcJXl7gOopy/HfE0k3zYDOKFsFRm4YCH4TujGnwzay16dKTgwuEIRKFpg2Eyfj
         7oSI9hFk8raOVtoYoX38WUbCFBPkgYLh2Cj3WSDJYBU1MkYqxT2BiomHYpdHJlIOTN
         pI2iInvJzsTvnAhDiVzn0BcELfLONas3zJtVDd+D/QxpCbjjh4DXHwgiYkQ3s+zf7s
         upQR6p1le99yg==
Date:   Tue, 13 Apr 2021 01:25:06 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: fix detection of PHY on Topaz
 switches
Message-ID: <20210413012507.355bc809@thinkpad>
In-Reply-To: <20210412165739.27277-1-pali@kernel.org>
References: <20210412121430.20898-1-pali@kernel.org>
        <20210412165739.27277-1-pali@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Some internal PHYs don't have a model number. */
> +	if (reg == MII_PHYSID2 && !(val & 0x3f0) &&
> +	    chip->info->family < ARRAY_SIZE(family_prod_id_table)) {
> +		prod_id = family_prod_id_table[chip->info->family];
> +		if (prod_id)
> +			val |= prod_id >> 4;

Isn't if(prod_id) check redundant here? If prod_id is 0, the |=
statement won't do anything.

Marek

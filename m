Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28F43A141A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbhFIMTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:19:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234448AbhFIMTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 08:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DGwxn+bZWtAvpA1OSTc+4zAEmH1VrC+7CgJGeQ0J8YA=; b=Idh1GhO3skYZIjFNizWUFSnXck
        yruSGCTYZm+sqB9Qr2IQxwT2x83WwldACMCnzY6GjUhR19M4o73/9mhlX9UQ12R765DG+YWZ35Iqs
        4D7ToC5JtdohmeaX9m/+991beCeBdsVPG6GQoqVSEOip1eTMf3a9Mx4lG9v9Q4siZYmg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqx9U-008UXB-6q; Wed, 09 Jun 2021 14:17:44 +0200
Date:   Wed, 9 Jun 2021 14:17:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Message-ID: <YMCxaAOs2UYRHEnF@lunn.ch>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
 <20210608031535.3651-4-qiangqing.zhang@nxp.com>
 <20210608175104.7ce18d1d@xhacker.debian>
 <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210609095633.1bce2c22@xhacker.debian>
 <DB8PR04MB67955F0424EAEBF362D34B30E6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210609110428.5a136b03@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609110428.5a136b03@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Aha, I see you want to keep the ALDPS bits(maybe configured by prelinux env) untouched.
> If ALDPS has been enabled by prelinux env, even there's no "realtek,aldps-enable"
> in DT, the ALDPS may be keep enabled in linux. Thus the ALDPS behavior rely on
> the prelinux env. I'm not sure whether this is correct or not.
> 
> IMHO, the "realtek,aldps-enable" is a "yes" or "no" bool. If it's set, ALDPS
> will be enabled in linux; If it's no, ALDPS will be disabled in linux. We
> should not rely on prelinux env.

If you look at V1 of this patch, you will see i commented that maybe
it needs to be a tristate, not a boolean. Disable it, enable it, leave
it as is. If we do need the third state, we can add it latter.

There is something to be said for not relying on the bootloader. But
the hardware default appears to be ALDPS enabled. So this case seems
reasonably safe.

	   Andrew

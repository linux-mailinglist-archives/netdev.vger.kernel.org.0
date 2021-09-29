Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03541BD1C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 05:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243815AbhI2DMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 23:12:49 -0400
Received: from mx24.baidu.com ([111.206.215.185]:46174 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230022AbhI2DMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 23:12:49 -0400
Received: from BJHW-Mail-Ex15.internal.baidu.com (unknown [10.127.64.38])
        by Forcepoint Email with ESMTPS id F090134BA411A96D99A6;
        Wed, 29 Sep 2021 11:11:06 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 29 Sep 2021 11:11:06 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 29
 Sep 2021 11:11:04 +0800
Date:   Wed, 29 Sep 2021 11:11:02 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <horatiu.vultur@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mdio-ipq4019: Fix the error for an optional regs
 resource
Message-ID: <20210929031102.GA2262@LAPTOP-UKSR4ENP.internal.baidu.com>
References: <20210928132157.2027-1-caihuoqing@baidu.com>
 <YVMZOy6gPhZCKIvy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVMZOy6gPhZCKIvy@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex05.internal.baidu.com (10.127.64.15) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2021-09-29 11:11:06:937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 9月 21 15:31:39, Andrew Lunn wrote:
> On Tue, Sep 28, 2021 at 09:21:57PM +0800, Cai Huoqing wrote:
> > The second resource is optional which is only provided on the chipset
> > IPQ5018. But the blamed commit ignores that and if the resource is
> > not there it just fails.
> > 
> > the resource is used like this,
> > 	if (priv->eth_ldo_rdy) {
> > 		val = readl(priv->eth_ldo_rdy);
> > 		val |= BIT(0);
> > 		writel(val, priv->eth_ldo_rdy);
> > 		fsleep(IPQ_PHY_SET_DELAY_US);
> > 	}
> > 
> > This patch reverts that to still allow the second resource to be optional
> > because other SoC have the some MDIO controller and doesn't need to
> > second resource.
> > 
> > Fix Commit fa14d03e014a ("net: mdio-ipq4019: Make use of
> > devm_platform_ioremap_resource()")
> 
> This is not a valid Fixes: tag.
> 
> Add to your ~/.gitconfig and add:
> 
> [pretty]
>         fixes = Fixes: %h (\"%s\")
> 
> You can then do
> 
> git log --pretty=fixes fa14d03e014a
>
Cool, it is a great help to me:)

Thanks,
Cai
> and get:
> 
> Fixes: fa14d03e014a ("net: mdio-ipq4019: Make use of devm_platform_ioremap_resource()")
> 
> Which is the correct format. Don't wrap it, if it is long.
> 
>       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581D23A3005
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhFJQD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:03:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56654 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhFJQD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hPwBfiq+EkDhbSpGp/S0/Q4kz8T22XzRb8/GRZUETBU=; b=qPuOfW2e58phjlkVYnrhIN1XEA
        hO2QyCzeh9JyOWrgUJSI8WnlMXSOq8etHn2VULLIfXPW9AH5x0gy9A8Q2xEiCq8r2+qXPNbTnBNOO
        y3efzMCF5Hu3MXBVtIaldRBmc8srMECAj8YWA2fgtgrh6hdavKhiaDu5TlqsI0fsYBGc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrN7W-008gcj-H9; Thu, 10 Jun 2021 18:01:26 +0200
Date:   Thu, 10 Jun 2021 18:01:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: mdio: mscc-miim: Use
 devm_platform_get_and_ioremap_resource()
Message-ID: <YMI3VsR/jnVVhmsh@lunn.ch>
References: <20210610091154.4141911-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610091154.4141911-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	dev->regs = devm_ioremap_resource(&pdev->dev, res);
> +	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
>  	if (IS_ERR(dev->regs)) {

Here, only dev->regs is considered.

>  		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
>  		return PTR_ERR(dev->regs);
>  	}



> +	dev->phy_regs = devm_platform_get_and_ioremap_resource(pdev, 1, &res);
> +	if (res && IS_ERR(dev->phy_regs)) {

Here you look at both res and dev->phy_regs.

This seems inconsistent. Can devm_platform_get_and_ioremap_resource()
return success despite res being NULL?

       Andrew

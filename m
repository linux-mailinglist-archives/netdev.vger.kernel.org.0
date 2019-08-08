Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E290E86AAF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390315AbfHHTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:40:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390275AbfHHTkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 15:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VqhqP3obHNPDSm8o2Lr2zTPYJaGXSOAQOEdyPFGfKV8=; b=DMLAeYBI7GF3NUaVvvMFCWA0GR
        e/qO994TcMeFO9NONrFyQuTzp2H4ues/yXB9y+RyD/D7UGqURd6ELM1Aj0kngGSHPcumm6X2BEhZk
        ngXlL7Ml5XL5l5JIqkoyyVAbqdHldBj4FpzDS383Ce+Iwj+uQg7DN+5YXF2QiaRnttuU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvoHJ-0005bZ-4Y; Thu, 08 Aug 2019 21:40:49 +0200
Date:   Thu, 8 Aug 2019 21:40:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Yonglong Liu <liuyonglong@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, shiju.jose@huawei.com
Subject: Re: [PATCH net] net: phy: rtl8211f: do a double read to get real
 time link status
Message-ID: <20190808194049.GM27917@lunn.ch>
References: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
 <d67831ab-8902-a653-3db9-b2f55adacabd@gmail.com>
 <e663235c-93eb-702d-5a9c-8f781d631c42@huawei.com>
 <080b68c7-abe6-d142-da4b-26e8a7d4dc19@gmail.com>
 <c15f820b-cc80-9a93-4c48-1b60bc14f73a@huawei.com>
 <b1140603-f05b-2373-445f-c1d7a43ff012@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1140603-f05b-2373-445f-c1d7a43ff012@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -568,6 +568,11 @@ int phy_start_aneg(struct phy_device *phydev)
>  	if (err < 0)
>  		goto out_unlock;
>  
> +	/* The PHY may not yet have cleared aneg-completed and link-up bit
> +	 * w/o this delay when the following read is done.
> +	 */
> +	usleep_range(1000, 2000);
> +

Hi Heiner

Does 802.3 C22 say anything about this?

If this PHY is broken with respect to the standard, i would prefer the
workaround is in the PHY specific driver code, not generic core code.

	   Andrew

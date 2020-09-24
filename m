Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1954E2765B7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgIXBKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgIXBKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:10:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1683C0613CE;
        Wed, 23 Sep 2020 18:10:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B48312711881;
        Wed, 23 Sep 2020 17:53:45 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:10:31 -0700 (PDT)
Message-Id: <20200923.181031.1814913923203712388.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net: mdio: Remove redundant parameter and check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923100532.18452-1-tangbin@cmss.chinamobile.com>
References: <20200923100532.18452-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:53:45 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Wed, 23 Sep 2020 18:05:32 +0800

> @@ -125,12 +124,9 @@ ipq8064_mdio_probe(struct platform_device *pdev)
>  		return PTR_ERR(priv->base);
>  	}
>  
> -	ret = of_mdiobus_register(bus, np);
> -	if (ret)
> -		return ret;
> -
>  	platform_set_drvdata(pdev, bus);
> -	return 0;
> +
> +	return of_mdiobus_register(bus, np);
>  }

You are changing the code rather than simplifying the return sequence.

The author of this code intended the platform_set_drvdata() to only
happen if all operations of this function succeeded.

I am not applying this patch, sorry.

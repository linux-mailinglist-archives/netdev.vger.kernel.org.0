Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923E7C39D5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733065AbfJAQDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:03:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAQDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:03:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1C82154A804B;
        Tue,  1 Oct 2019 09:03:23 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:03:20 -0700 (PDT)
Message-Id: <20191001.090320.1192378852987776883.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, andrew@lunn.ch,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ag71xx: fix mdio subnode support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001064147.23633-1-o.rempel@pengutronix.de>
References: <20191001064147.23633-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:03:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Tue,  1 Oct 2019 08:41:47 +0200

> @@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
>  		msleep(200);
>  	}
>  
> -	err = of_mdiobus_register(mii_bus, np);
> +	mnp = of_get_child_by_name(np, "mdio");
> +	err = of_mdiobus_register(mii_bus, mnp);

of_get_child_by_name() can fail, so error checking is necessary
before you pass mnp into of_mdiobus_register().

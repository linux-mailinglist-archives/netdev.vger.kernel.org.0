Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FCC26CFE3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIQAV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgIQAV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:21:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1248FC06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:21:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95EC613C7831C;
        Wed, 16 Sep 2020 17:05:07 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:21:53 -0700 (PDT)
Message-Id: <20200916.172153.376464259253056720.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net 4/7] net: mscc: ocelot: check for errors on memory
 allocation of ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915182229.69529-5-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
        <20200915182229.69529-5-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:05:08 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 15 Sep 2020 21:22:26 +0300

> @@ -993,6 +993,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
>  				     sizeof(struct ocelot_port *), GFP_KERNEL);
> +	if (!ocelot->ports)
> +		return -ENOMEM;

This leaks the reference to OF node 'ports'.

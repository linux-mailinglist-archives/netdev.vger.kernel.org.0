Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5759782452
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfHER4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:56:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHER4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:56:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D4841540A47B;
        Mon,  5 Aug 2019 10:56:35 -0700 (PDT)
Date:   Mon, 05 Aug 2019 10:56:35 -0700 (PDT)
Message-Id: <20190805.105635.1627696816449985561.davem@davemloft.net>
To:     h.feurstein@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: drop adjust_link to enabled
 phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731154239.19270-1-h.feurstein@gmail.com>
References: <20190731154239.19270-1-h.feurstein@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 10:56:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>
Date: Wed, 31 Jul 2019 17:42:39 +0200

> We have to drop the adjust_link callback in order to finally migrate to
> phylink.
> 
> Otherwise we get the following warning during startup:
>   "mv88e6xxx 2188000.ethernet-1:10: Using legacy PHYLIB callbacks. Please
>    migrate to PHYLINK!"
> 
> The warning is generated in the function dsa_port_link_register_of in
> dsa/port.c:
> 
>   int dsa_port_link_register_of(struct dsa_port *dp)
>   {
>   	struct dsa_switch *ds = dp->ds;
> 
>   	if (!ds->ops->adjust_link)
>   		return dsa_port_phylink_register(dp);
> 
>   	dev_warn(ds->dev,
>   		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
>   	[...]
>   }
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Applied.

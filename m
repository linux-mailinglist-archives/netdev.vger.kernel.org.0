Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306A3274DE5
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIWAhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgIWAhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:37:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38AAC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:37:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF14B13C05414;
        Tue, 22 Sep 2020 17:20:26 -0700 (PDT)
Date:   Tue, 22 Sep 2020 17:37:13 -0700 (PDT)
Message-Id: <20200922.173713.1987174886413946824.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, cphealy@gmail.com,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 2/2] net: dsa: sja1105: expose static config
 as devlink region
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921162741.4081710-3-vladimir.oltean@nxp.com>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
        <20200921162741.4081710-3-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 17:20:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 21 Sep 2020 19:27:41 +0300

> @@ -110,10 +222,15 @@ int sja1105_devlink_setup(struct dsa_switch *ds)
>  	if (rc)
>  		return rc;
>  
> +	rc = sja1105_setup_devlink_regions(ds);
> +	if (rc < 0)
> +		return rc;
> +
>  	return 0;
>  }

I think you need to release the devlink params on failure here.  Otherwise
I don't see anything that will clean that up.


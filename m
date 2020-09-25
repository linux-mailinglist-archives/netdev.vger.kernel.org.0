Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4391277E2E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 04:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgIYCsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 22:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIYCsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 22:48:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC17C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 19:48:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A676C135F4C59;
        Thu, 24 Sep 2020 19:31:27 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:48:14 -0700 (PDT)
Message-Id: <20200924.194814.1399518038719671160.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:31:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 23 Sep 2020 14:24:20 +0300

> Currently, ocelot switchdev passes the skb directly to the function that
> enqueues it to the list of skb's awaiting a TX timestamp. Whereas the
> felix DSA driver first clones the skb, then passes the clone to this
> queue.
> 
> This matters because in the case of felix, the common IRQ handler, which
> is ocelot_get_txtstamp(), currently clones the clone, and frees the
> original clone. This is useless and can be simplified by using
> skb_complete_tx_timestamp() instead of skb_tstamp_tx().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thank you.

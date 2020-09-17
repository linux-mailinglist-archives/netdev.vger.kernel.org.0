Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E9F26CFE1
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgIQATb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIQATa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:19:30 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 20:19:30 EDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2A5C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:19:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D9D013C7830B;
        Wed, 16 Sep 2020 17:02:40 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:19:26 -0700 (PDT)
Message-Id: <20200916.171926.383551951466329210.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net 2/7] net: mscc: ocelot: add locking for the port TX
 timestamp ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915182229.69529-3-olteanv@gmail.com>
References: <20200915182229.69529-1-olteanv@gmail.com>
        <20200915182229.69529-3-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:02:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 15 Sep 2020 21:22:24 +0300

> This is a problem because, at least theoretically, another timestampable
> skb might use the same ocelot_port->ts_id before that is incremented. So
> the logic of using and incrementing the timestamp id should be atomic
> per port.

Have you actually observed this race in practice?

All transmit calls are serialized by the netdev transmit spinlock.

Let's not add locking if it is not actually necessary.



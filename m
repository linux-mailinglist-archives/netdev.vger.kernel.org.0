Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5822934FFF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFDSw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:52:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfFDSw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:52:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DDEF414FA95B5;
        Tue,  4 Jun 2019 11:52:26 -0700 (PDT)
Date:   Tue, 04 Jun 2019 11:52:26 -0700 (PDT)
Message-Id: <20190604.115226.190918229563428960.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 1/1] net: dsa: sja1105: Fix link speed not
 working at 100 Mbps and below
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190602233137.17930-2-olteanv@gmail.com>
References: <20190602233137.17930-1-olteanv@gmail.com>
        <20190602233137.17930-2-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 11:52:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  3 Jun 2019 02:31:37 +0300

> The hardware values for link speed are held in the sja1105_speed_t enum.
> However they do not increase in the order that sja1105_get_speed_cfg was
> iterating over them (basically from SJA1105_SPEED_AUTO - 0 - to
> SJA1105_SPEED_1000MBPS - 1 - skipping the other two).
> 
> Another bug is that the code in sja1105_adjust_port_config relies on the
> fact that an invalid link speed is detected by sja1105_get_speed_cfg and
> returned as -EINVAL.  However storing this into an enum that only has
> positive members will cast it into an unsigned value, and it will miss
> the negative check.
> 
> So take the simplest approach and remove the sja1105_get_speed_cfg
> function and replace it with a simple switch-case statement.
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Applied.

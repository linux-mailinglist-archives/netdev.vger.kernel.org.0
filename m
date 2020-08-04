Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3CD23C1FC
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgHDW7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 18:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgHDW7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 18:59:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146FAC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 15:59:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 329DC12895DAC;
        Tue,  4 Aug 2020 15:43:05 -0700 (PDT)
Date:   Tue, 04 Aug 2020 15:59:50 -0700 (PDT)
Message-Id: <20200804.155950.60471933904505919.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: sja1105: use detected device id
 instead of DT one on mismatch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803164823.414772-1-olteanv@gmail.com>
References: <20200803164823.414772-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:43:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  3 Aug 2020 19:48:23 +0300

> Although we can detect the chip revision 100% at runtime, it is useful
> to specify it in the device tree compatible string too, because
> otherwise there would be no way to assess the correctness of device tree
> bindings statically, without booting a board (only some switch versions
> have internal RGMII delays and/or an SGMII port).
> 
> But for testing the P/Q/R/S support, what I have is a reworked board
> with the SJA1105T replaced by a pin-compatible SJA1105Q, and I don't
> want to keep a separate device tree blob just for this one-off board.
> Since just the chip has been replaced, its RGMII delay setup is
> inherently the same (meaning: delays added by the PHY on the slave
> ports, and by PCB traces on the fixed-link CPU port).
> 
> For this board, I'd rather have the driver shout at me, but go ahead and
> use what it found even if it doesn't match what it's been told is there.
> 
> [    2.970826] sja1105 spi0.1: Device tree specifies chip SJA1105T but found SJA1105Q, please fix it!
> [    2.980010] sja1105 spi0.1: Probed switch chip: SJA1105Q
> [    3.005082] sja1105 spi0.1: Enabled switch tagging
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Andrew/Florian, do we really want to set a precedence for doing this
kind of fallback in our drivers?

Thanks.

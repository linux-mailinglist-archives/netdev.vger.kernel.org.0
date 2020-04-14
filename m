Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1681A8F3A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392185AbgDNXim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392180AbgDNXic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:38:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E19DC061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:38:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A5091280C7B8;
        Tue, 14 Apr 2020 16:38:31 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:38:30 -0700 (PDT)
Message-Id: <20200414.163830.2151404177947586721.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, Chris.Healy@zii.aero,
        cphealy@gmail.com
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414004551.607503-1-andrew@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 16:38:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 14 Apr 2020 02:45:51 +0200

> Measurements of the MDIO bus have shown that driving the MDIO bus
> using interrupts is slow. Back to back MDIO transactions take about
> 90uS, with 25uS spent performing the transaction, and the remainder of
> the time the bus is idle.
> 
> Replacing the completion interrupt with polled IO results in back to
> back transactions of 40uS. The polling loop waiting for the hardware
> to complete the transaction takes around 27uS. Which suggests
> interrupt handling has an overhead of 50uS, and polled IO nearly
> halves this overhead, and doubles the MDIO performance.
> 
> Suggested-by: Chris Heally <cphealy@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Where are we with this?

Andrew, do you intend to submit a version that via iopoll.h does
cpu relax and usleeps?

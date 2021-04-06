Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C3355F43
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbhDFXOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:14:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34270 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbhDFXOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:14:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 92E8E4D2493A4;
        Tue,  6 Apr 2021 16:14:35 -0700 (PDT)
Date:   Tue, 06 Apr 2021 16:14:31 -0700 (PDT)
Message-Id: <20210406.161431.1568805748449868568.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     ms@dev.tdt.de, kuba@kernel.org, corbet@lwn.net, khc@pm.waw.pl,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: x25: Queue received packets in the
 drivers instead of per-CPU queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210402093000.72965-1-xie.he.0141@gmail.com>
References: <20210402093000.72965-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 06 Apr 2021 16:14:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Fri,  2 Apr 2021 02:30:00 -0700

> X.25 Layer 3 (the Packet Layer) expects layer 2 to provide a reliable
> datalink service such that no packets are reordered or dropped. And
> X.25 Layer 2 (the LAPB layer) is indeed designed to provide such service.
> 
> However, this reliability is not preserved when a driver calls "netif_rx"
> to deliver the received packets to layer 3, because "netif_rx" will put
> the packets into per-CPU queues before they are delivered to layer 3.
> If there are multiple CPUs, the order of the packets may not be preserved.
> The per-CPU queues may also drop packets if there are too many.
> 
> Therefore, we should not call "netif_rx" to let it queue the packets.
> Instead, we should use our own queue that won't reorder or drop packets.
> 
> This patch changes all X.25 drivers to use their own queues instead of
> calling "netif_rx". The patch also documents this requirement in the
> "x25-iface" documentation.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>


This no longe applies to net-next, please respin.

Thank you.

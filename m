Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4774253DD59
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbiFERXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 13:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiFERXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 13:23:52 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61AE818344;
        Sun,  5 Jun 2022 10:23:50 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 6102B10002E;
        Sun,  5 Jun 2022 17:23:49 +0000 (UTC)
Date:   Sun, 5 Jun 2022 19:23:47 +0200
From:   Max Staudt <max@enpas.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220605192347.518c4b3c.max@enpas.org>
In-Reply-To: <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Vincent for this cleanup!

Since I am upstreaming a driver that may (?) not fit the proposed
structure, one question below.


On Sun,  5 Jun 2022 01:29:53 +0900
Vincent Mailhol <mailhol.vincent@wanadoo.fr> wrote:

> * menu after this series *
> 
> Network device support
>   symbol: CONFIG_NETDEVICES
>   |
>   +-> CAN Device Drivers
>       symbol: CONFIG_CAN_DEV
>       |
>       +-> software/virtual CAN device drivers
>       |   (at time of writing: slcan, vcan, vxcan)
>       |
>       +-> CAN device drivers with Netlink support
>           symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
>           |
>           +-> CAN bit-timing calculation (optional for all drivers)
>           |   symbol: CONFIG_CAN_BITTIMING
>           |
>           +-> All other CAN devices not relying on RX offload
>           |
>           +-> CAN rx offload
>               symbol: CONFIG_CAN_RX_OFFLOAD
>               |
>               +-> CAN devices relying on rx offload
>                   (at time of writing: flexcan, m_can, mcp251xfd and
> ti_hecc)


This seemingly splits drivers into "things that speak to hardware" and
"things that don't". Except... slcan really does speak to hardware. It
just so happens to not use any of BITTIMING or RX_OFFLOAD. However, my
can327 (formerly elmcan) driver, which is an ldisc just like slcan,
*does* use RX_OFFLOAD, so where to I put it? Next to flexcan, m_can,
mcp251xfd and ti_hecc?

Is it really just a split by features used in drivers, and no longer a
split by virtual/real?


Max

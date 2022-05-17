Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C89F52A144
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 14:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345788AbiEQMOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 08:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345396AbiEQMOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 08:14:10 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF7F74578A;
        Tue, 17 May 2022 05:14:08 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 26B48FF9D7;
        Tue, 17 May 2022 12:14:07 +0000 (UTC)
Date:   Tue, 17 May 2022 14:14:04 +0200
From:   Max Staudt <max@enpas.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517141404.578d188a.max@enpas.org>
In-Reply-To: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
        <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
        <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
        <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
        <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
        <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
        <20220517104545.eslountqjppvcnz2@pengutronix.de>
        <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
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

On Tue, 17 May 2022 13:51:57 +0200
Oliver Hartkopp <socketcan@hartkopp.net> wrote:


> After looking through drivers/net/can/Kconfig I would probably phrase
> it like this:
> 
> Select CAN devices (hw/sw) -> we compile a can_dev module. E.g. to 
> handle the skb stuff for vcan's.
> 
> Select hardware CAN devices -> we compile the netlink stuff into
> can_dev and offer CAN_CALC_BITTIMING and CAN_LEDS to be compiled into
> can_dev too.
> 
> In the latter case: The selection of flexcan, ti_hecc and mcp251xfd 
> automatically selects CAN_RX_OFFLOAD which is then also compiled into 
> can_dev.
> 
> Would that fit in terms of complexity?

IMHO these should always be compiled into can-dev. Out of tree drivers
are fairly common here, and having to determine which kind of can-dev
(stripped or not) the user has on their system is a nightmare waiting to
happen.


Max

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3737553DE39
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 22:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347366AbiFEUqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 16:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiFEUqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 16:46:51 -0400
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B2EB266F;
        Sun,  5 Jun 2022 13:46:47 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id E5E28FF88D;
        Sun,  5 Jun 2022 20:46:45 +0000 (UTC)
Date:   Sun, 5 Jun 2022 22:46:40 +0200
From:   Max Staudt <max@enpas.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220605224640.3a09e704.max@enpas.org>
In-Reply-To: <20220605180641.tfqyxhkkauzoz2z4@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220605192347.518c4b3c.max@enpas.org>
        <20220605180641.tfqyxhkkauzoz2z4@pengutronix.de>
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

On Sun, 5 Jun 2022 20:06:41 +0200
Marc Kleine-Budde <mkl@pengutronix.de> wrote:

> On 05.06.2022 19:23:47, Max Staudt wrote:
> > This seemingly splits drivers into "things that speak to hardware"
> > and "things that don't". Except... slcan really does speak to
> > hardware. It just so happens to not use any of BITTIMING or
> > RX_OFFLOAD. However, my can327 (formerly elmcan) driver, which is
> > an ldisc just like slcan, *does* use RX_OFFLOAD, so where to I put
> > it? Next to flexcan, m_can, mcp251xfd and ti_hecc?
> > 
> > Is it really just a split by features used in drivers, and no
> > longer a split by virtual/real?  
> 
> We can move RX_OFFLOAD out of the "if CAN_NETLINK". Who wants to
> create an incremental patch against can-next/master?

Yes, this may be useful in the future. But for now, I think I can
answer my question myself :)

My driver does support Netlink to set CAN link parameters. So I'll just
drop it into the CAN_NETLINK -> RX_OFFLOAD category in Kconfig, unless
anyone objects.


I just got confused because in my mind, I'm still comparing it to
slcan, whereas in reality, it's now functionally closer to all the other
hardware drivers. Netlink and all.

Apologies for the noise! 


Max

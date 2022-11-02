Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770D4615705
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 02:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKBBa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 21:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKBBa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 21:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C860B1208D;
        Tue,  1 Nov 2022 18:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2558C616D3;
        Wed,  2 Nov 2022 01:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BA4C433D6;
        Wed,  2 Nov 2022 01:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667352637;
        bh=Hqo2ekGOuXv0sOiaeRNaO0JlK6Jut1KIfEbVwLHWFH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GsIOWwziv/+jbvLPguB1E5wUkRUE+dByHfGQvDY0CsaH2/jp32uHNvbnK4WxP/Oxu
         yP2GRM5O+1hqJvZXPQ1C4eersYYdt2W56xUGfKEsjSPZm8oqSqQlIOONcMas9QAUav
         KX6c1SMeIVCxwparV/1WFqielxKGoVKptsxQxZSg=
Date:   Wed, 2 Nov 2022 02:31:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <chris.paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] can: rcar_canfd: fix channel specific IRQ handling for
 RZ/G2L
Message-ID: <Y2HIctvwmuaQLI7G@kroah.com>
References: <20221031144317.963903-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031144317.963903-1-biju.das.jz@bp.renesas.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 02:43:17PM +0000, Biju Das wrote:
> commit d887087c896881715c1a82f1d4f71fbfe5344ffd upstream.
> 
> RZ/G2L has separate channel specific IRQs for transmit and error
> interrupts. But the IRQ handler processes both channels, even if there
> no interrupt occurred on one of the channels.
> 
> This patch fixes the issue by passing a channel specific context
> parameter instead of global one for the IRQ register and the IRQ
> handler, it just handles the channel which is triggered the interrupt.
> 
> Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Link: https://lore.kernel.org/all/20221025155657.1426948-3-biju.das.jz@bp.renesas.com
> Cc: stable@vger.kernel.org
> [mkl: adjust commit message]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [biju: fixed the conflicts manually]
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> Resending to 5.15 with conflicts[1] fixed
> [1] https://lore.kernel.org/stable/1667194217249235@kroah.com/T/#u
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)

Now queued up, thanks.

greg k-h

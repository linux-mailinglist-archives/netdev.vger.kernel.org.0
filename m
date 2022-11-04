Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C1E61A04B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiKDSvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKDSvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078D81DA71;
        Fri,  4 Nov 2022 11:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1AD062305;
        Fri,  4 Nov 2022 18:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAA8C433D6;
        Fri,  4 Nov 2022 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667587861;
        bh=wmLBR7F9N5ojDTlyhoSL9D6SBHhS5qD8LL3EJCvZ0kY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U8PeVcWnO64kbAEehPMQ2mokM5ubQDTHzNRUY7g4Ou2DkX/R5+IJcwmfRI9Eg1Dpu
         b2HPzB9z0qbmH7N+wYr3wsTVSwZDIL8ZPXxpebg1N6WHkdNwt/Jf0DdKt3c5Qu+qGX
         25b/ztn6fg3F7S1wvDlanOV+f7yWdATE3tYdfxPnFtBp96yyEyAl5t0Yi3KBGhm+kT
         yuDsdX/AsEyLV9UujzGxpMZyU4hYsfVuBlCb4UcZxkVbiH2ki1Wv3jF1J3kkYNDT/2
         1T9/LYOX7bVUWgaL5f2wJK/PCNpd3TxHFRiRouElPcAg4yp1FRlJy7EdHr5g+Yur7T
         0zh7eOLmKIdpQ==
Date:   Fri, 4 Nov 2022 11:50:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, stable@vger.kernel.org
Subject: Re: [PATCH net 4/5] can: dev: fix skb drop check
Message-ID: <20221104115059.429412fb@kernel.org>
In-Reply-To: <20221104130535.732382-5-mkl@pengutronix.de>
References: <20221104130535.732382-1-mkl@pengutronix.de>
        <20221104130535.732382-5-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 14:05:34 +0100 Marc Kleine-Budde wrote:
> -	if (can_dropped_invalid_skb(ndev, skb))
> +	if (can_dev_dropped_skb(dev, skb))

Compiler says "Did you mean ndev"?

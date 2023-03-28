Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351246CCC67
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjC1V5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjC1V5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087D3270B;
        Tue, 28 Mar 2023 14:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F316DB81EE3;
        Tue, 28 Mar 2023 21:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF81C433D2;
        Tue, 28 Mar 2023 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680040619;
        bh=EPCiwUL07Ou55Zwnf38AT7f1Gi9ehHg91AFs035DmEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c8SOygukOymSpvK1qkQba/J6jUIMOfj9hwR1mWvFIoq7Z/msNqRtIzBb8NUVc+yVC
         1xuXpNhA5XjIySaBOn+E8NxSpRX+lANf77N/NojM8vAPqW9OoBcXUulZe3BED2uc7O
         IYmmfIWWqJbyVwLrY8t5sU1kS8p/vYtQalgXMIgR5yXLdODBidshZgACcieVJufKM3
         pn+WopttQMu5FLnDfG3TY3Su3nLs+j1yuVZkhTj5ClPdD+/+QpYRXe7yJ811s912KK
         17xR7n/K8UXd3S2lmOwtIYlhD/O/kREY4Ns4CJf3yMGCm4kP2cazr9d4Iu3rgP1LYP
         gPpXrHe7kKKMw==
Date:   Tue, 28 Mar 2023 14:56:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <simon.horman@corigine.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH net-next 01/11] can: rcar_canfd: Add transceiver support
Message-ID: <20230328145658.7fdbc394@kernel.org>
In-Reply-To: <20230327073354.1003134-2-mkl@pengutronix.de>
References: <20230327073354.1003134-1-mkl@pengutronix.de>
        <20230327073354.1003134-2-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023 09:33:44 +0200 Marc Kleine-Budde wrote:
> @@ -1836,6 +1849,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
>  
>  static int rcar_canfd_probe(struct platform_device *pdev)
>  {
> +	struct phy *transceivers[RCANFD_NUM_CHANNELS] = { 0, };
>  	const struct rcar_canfd_hw_info *info;
>  	struct device *dev = &pdev->dev;
>  	void __iomem *addr;

[somehow this got stuck in my outgoing mail]

drivers/net/can/rcar/rcar_canfd.c:1852:59: warning: Using plain integer as NULL pointer

Could you follow up with a fix fix?

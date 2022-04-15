Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5634502EE1
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347742AbiDOTET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347623AbiDOTER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:04:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E014D9E9B;
        Fri, 15 Apr 2022 12:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED8FCB82ECD;
        Fri, 15 Apr 2022 19:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850EBC385A5;
        Fri, 15 Apr 2022 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650049305;
        bh=Z5tq7WhsfYCtbsBpe6vYTV676bSOimMfYuf424iszwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aV+e6hc/YF4o11T2Oms1tvdnTdFOUTPWcEW2d9B7X47iV5IgdOvthDZQHzb5HZQ23
         9l9KaD4MeUZOiH7SzithuFtnSoeUlv/o4Lpo4YyDME41z7B501NpoJGiFkRmF45BSM
         jpyxJ9WXisbunkgGL0p8RFCpAeZzaW27PAt61aO7Tgz+/sbSDIzh8zAgrIZysp6OF2
         gXBQs2I8YNN814UlqT3gGxH2hBVzNxDKl6FI3DfLXH/QscMkcUyHAP2eGpbQs4Qbps
         AiCzVD3nGWDsUYP0xIhez7Mqfq6z9PNYNpuBjq7MXu6z9N8bw9SSf6ikHavUmvlaZP
         xz1wDzi1VbD+w==
Date:   Fri, 15 Apr 2022 21:01:39 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net] net: lan966x: Make sure to release ptp interrupt
Message-ID: <20220415210139.2d338f4b@kernel.org>
In-Reply-To: <20220413195716.3796467-1-horatiu.vultur@microchip.com>
References: <20220413195716.3796467-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Apr 2022 21:57:16 +0200 Horatiu Vultur wrote:
> When the lan966x driver is removed make sure to remove also the ptp_irq
> IRQ.

I presume it's because you want to disable the IRQ so it doesn't fire
during / after remove? Would be good to have such justifications
spelled out in the commit message in the future!

> Fixes: e85a96e48e3309 ("net: lan966x: Add support for ptp interrupts")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

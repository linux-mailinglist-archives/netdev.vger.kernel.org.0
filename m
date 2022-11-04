Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C062D61A41E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKDWgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDWgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:36:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E74B2DAA8;
        Fri,  4 Nov 2022 15:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05153B82F60;
        Fri,  4 Nov 2022 22:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF34C433D6;
        Fri,  4 Nov 2022 22:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667601372;
        bh=ftFQ7NaOZiK4nmSEvsrsVbVm2SjTDawWqfO++yMnZus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r6PR1PMlj15qZTKBNkwVARnPU/RffHRVdGfGGlNzAQV2tki4KatxfrpljMh5wqfuh
         9Gl6ARWMz8uFaEkrGTzSzD05g4E87Q+bmbHLMK/tHoKJMFhRW21ymPwwVKHJe1eFhN
         UoQqJ4LTEgpGoFgqgauF15cU0lubYhpTu05E3mXvQ0XfX6E2THMdGcPDbhrIpsg63Z
         qb7OgvG6125lRqC3BUCbmbsQ8m0VXPY3f86C8/DowJXFhdJUD8SccLYC/ptlbekAR6
         c+5HlqH8V5QcjtvwXdndoat/p6RlHeBaR12wrX2P7hTSmQFcCTP8GAFe5MlzyZjBu8
         rZOz4le0uz+Jw==
Date:   Fri, 4 Nov 2022 15:36:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, stable@vger.kernel.org
Subject: Re: [PATCH net 4/5] can: dev: fix skb drop check
Message-ID: <20221104153611.53758e3a@kernel.org>
In-Reply-To: <68896ba9-68c6-1f7a-3c6c-c3ee3c98e32f@hartkopp.net>
References: <20221104130535.732382-1-mkl@pengutronix.de>
        <20221104130535.732382-5-mkl@pengutronix.de>
        <20221104115059.429412fb@kernel.org>
        <68896ba9-68c6-1f7a-3c6c-c3ee3c98e32f@hartkopp.net>
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

On Fri, 4 Nov 2022 21:33:16 +0100 Oliver Hartkopp wrote:
> On 04.11.22 19:50, Jakub Kicinski wrote:
> > On Fri,  4 Nov 2022 14:05:34 +0100 Marc Kleine-Budde wrote:  
> >> -	if (can_dropped_invalid_skb(ndev, skb))
> >> +	if (can_dev_dropped_skb(dev, skb))  
> > 
> > Compiler says "Did you mean ndev"?  
> 
> Your compiler is a smart buddy! Sorry!
> 
> Marc added that single change to my patch for the pch_can.c driver 
> (which is removed in net-next but not in 6.1-rc).
> 
> And in pch_can.c the netdev is named ndev.
> 
> Would you like to fix this up on your own or should we send an updated 
> PR for the series?

Updated PR would be better, if possible. 
We don't edit patches locally much (at all?) when applying to netdev.

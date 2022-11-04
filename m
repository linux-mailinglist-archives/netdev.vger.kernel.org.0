Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0208161A230
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKDUdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDUdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:33:32 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517DC45A0D;
        Fri,  4 Nov 2022 13:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667594003;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=9m5xgCCWtTY75QRL2nyoUUMBnApx/bdSDONEfsYu3Qg=;
    b=HyJmoM71kld6Bk2h5uOB5eRaoIPjiY2bX9a5uqUuGV0IYErMS6Ls3K6nKF9F9H2Yr2
    3SDmzhBOkUlmQLvMiOoLar3LMeMvxFJuuKt2gmAtOeTfsQ/u+abahl9MnreRCNjba1K9
    aoTtDNNOcH9FyNytxqAVO8v2UuUyWcbBVFXmLP4vonpolysL9/htUkq6EnPbX4Dp5616
    C5P19glDmhmNdXF5Ua6e03yk0lyVqbAqbd3gIvAdmW11OgFNFnKMcPjR6p2hHydPbvUF
    xhR1HSxIItd2aR3J6mUFS2nkYCjYfTO/6M8w3Nv0cA2GT+6l8e95/XYPxnEKteYcLrVj
    Lxug==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yA4KXMRT7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 4 Nov 2022 21:33:22 +0100 (CET)
Message-ID: <68896ba9-68c6-1f7a-3c6c-c3ee3c98e32f@hartkopp.net>
Date:   Fri, 4 Nov 2022 21:33:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net 4/5] can: dev: fix skb drop check
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, stable@vger.kernel.org
References: <20221104130535.732382-1-mkl@pengutronix.de>
 <20221104130535.732382-5-mkl@pengutronix.de>
 <20221104115059.429412fb@kernel.org>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221104115059.429412fb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 04.11.22 19:50, Jakub Kicinski wrote:
> On Fri,  4 Nov 2022 14:05:34 +0100 Marc Kleine-Budde wrote:
>> -	if (can_dropped_invalid_skb(ndev, skb))
>> +	if (can_dev_dropped_skb(dev, skb))
> 
> Compiler says "Did you mean ndev"?

Your compiler is a smart buddy! Sorry!

Marc added that single change to my patch for the pch_can.c driver 
(which is removed in net-next but not in 6.1-rc).

And in pch_can.c the netdev is named ndev.

Would you like to fix this up on your own or should we send an updated 
PR for the series?

Many thanks,
Oliver


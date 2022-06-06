Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C78B53EE8A
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiFFTYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 15:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiFFTY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 15:24:28 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86B6BF0;
        Mon,  6 Jun 2022 12:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654543461;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=RPmNSu8/QJlogBiUR3dv8QYSPVrk49UYvH70EI6bUmo=;
    b=mgXpuIWJdyKxDvAOvdwr83RMrLy1LZZS7jXbxPlZC5AgJuxjT7uzWFZlmocwCmlU4e
    fZaV3HKLycEjsZZLZFKwS11hGZgR2h2qtbpCVk01X2IoHU82nyLsfgPyXfD0JCRGux2G
    kVvdyoruTrBAx3g7eq0J4yJwSRe9UE22iEeCAHSfuOsmIfZvHM7/Y/tMB6IcgDYmsn+O
    7yS3j3J7A2H+EXe5HJkstDoR5okNXIgfc11eq0CrPG5wtC4Kjv34vG59PVJ+BcI6IXGu
    qzYlgOBGM91rXLc6rFHCkVXNogjR4BnQUVMw+4DPvA+h+KXJXO73QbDsI/lBrvlIRUb6
    FSSw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofo7wZbW6ThU4"
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy56JOK4tw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 6 Jun 2022 21:24:20 +0200 (CEST)
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
Date:   Mon, 6 Jun 2022 21:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

great work!

On 04.06.22 18:29, Vincent Mailhol wrote:

> * menu after this series *
> 
> Network device support
>    symbol: CONFIG_NETDEVICES
>    |
>    +-> CAN Device Drivers
>        symbol: CONFIG_CAN_DEV
>        |
>        +-> software/virtual CAN device drivers
>        |   (at time of writing: slcan, vcan, vxcan)
>        |
>        +-> CAN device drivers with Netlink support
>            symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
>            |
>            +-> CAN bit-timing calculation (optional for all drivers)
>            |   symbol: CONFIG_CAN_BITTIMING
>            |
>            +-> All other CAN devices not relying on RX offload
>            |
>            +-> CAN rx offload
>                symbol: CONFIG_CAN_RX_OFFLOAD

Is this still true in patch series 5?

If I understood it correctly CONFIG_CAN_BITTIMING and 
CONFIG_CAN_RX_OFFLOAD can be enabled by the user and 
(alternatively/additionally) the selection of "flexcan, m_can, mcp251xfd 
and ti_hecc" enables CONFIG_CAN_RX_OFFLOAD too.

Right?

>                |
>                +-> CAN devices relying on rx offload
>                    (at time of writing: flexcan, m_can, mcp251xfd and ti_hecc)

Best regards,
Oliver

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA935426DA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443810AbiFHCDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243368AbiFHBzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 21:55:16 -0400
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41531F7DAA;
        Tue,  7 Jun 2022 13:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654635116;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=JXSiYxgFZZ2tjAxBcyTrI4C3XZX0DeCU5mEV+jv6R6k=;
    b=tTIXRIwQyepuLXyRIEgr8laM1lqaJ/fmrXqiArmaPMoqiCXCC9HO6/UVS7VAqP3tyf
    Vvfg+spfS8Cm5h5lUdih2JmXw5jluDL4lUFeB1qpQp3K2x5isOTq+wYHGfHQYo5gLxwA
    OU/VijO4lXs8jPIFuQB4aGnGyrcuHQ0Zj2qZ3JGOISSO7aSY7GXlI0tQFZ/UpOoPulPm
    mIQ4fC8b1hbuyCmvdX1MTezHbP+PUoRwMz3VZx6jFc3Y51OUltbeZkk/p1RGCaHV4zpk
    aYB3UdEu1zQMZMoJ4SaU17Zv9/Eal9EHj+jLOJSaN0mY78t3tCexZXA3TrRj2qs2yNbc
    JmpA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofo7wY7W6Qxgy"
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy57Kpt8dN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 7 Jun 2022 22:51:55 +0200 (CEST)
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
 <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
 <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
 <f161fdd0-415a-8ea1-0aad-3a3a19f1bfa8@hartkopp.net>
 <20220607202706.7fbongzs3ixzpydm@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <44670e69-6d67-c6c7-160c-1ae6e740aabb@hartkopp.net>
Date:   Tue, 7 Jun 2022 22:51:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220607202706.7fbongzs3ixzpydm@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.06.22 22:27, Marc Kleine-Budde wrote:
> On 07.06.2022 22:12:46, Oliver Hartkopp wrote:
>> So what about:
>>
>>    symbol: CONFIG_NETDEVICES
>>    |
>>    +-> CAN Device Drivers
>>        symbol: CONFIG_CAN_DEV
>>        |
>>        +-> software/virtual CAN device drivers
>>        |   (at time of writing: slcan, vcan, vxcan)
>>        |
>>        +-> hardware CAN device drivers with Netlink support
>>            symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
>>            |
>>            +-> CAN bit-timing calculation (optional for all drivers)
>>            |   symbol: CONFIG_CAN_BITTIMING
>>            |
>>            +-> CAN rx offload (optional but selected by some drivers)
>>            |   symbol: CONFIG_CAN_RX_OFFLOAD
>>            |
>>            +-> CAN devices drivers
>>                (some may select CONFIG_CAN_RX_OFFLOAD)
>>
>> (I also added 'hardware' to CAN device drivers with Netlink support) to have
>> a distinction to 'software/virtual' CAN device drivers)
> 
> The line between hardware and software/virtual devices ist blurry, the
> new can327 driver uses netlink and the slcan is currently being
> converted....

Right, which could mean that slcan and can327 should be located in the 
'usual' CAN device driver section and not in the sw/virtual device section.

The slcan and can327 need some kind of hardware - while vcan and vxcan 
don't.

Best regards,
Oliver

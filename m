Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3216C63A2C6
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 09:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiK1IWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 03:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiK1IV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 03:21:57 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA007167F4;
        Mon, 28 Nov 2022 00:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669623711;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=r8DNEtzdUr23A31WbyF9m0tTQ4gvOo1TVcul6uPNYC4=;
    b=APDHWcTRLcAPh/L9ddyE3tqfyZ+vvfPXmy2/10noa5JyGTY5IJmucicG5K9FUDqIHq
    9VwN1XjHttm9f7BTXe6NwFsGLcsuYQLb5o1QjwiILaGhmtL2AN/RAUh5SR/gD5k1tIw0
    eIynHhMVQfH0qTkdm4BJiTJyY+yujZ2W4cZHFgril/qeZMpW00kLDD22trZWB6tXL04c
    gzQJtCPZtGkq/hyd6dZHxKfSWxoSlSBLQsn0TnjLwOLQoPQ9KOHv+nEARmrNIYsOSCwB
    UBYDaxKxvVz5Y79RHcPCUs9o24TjPPyG/xnXGjl6U4uVdLHg2g9XMtAnbWXpiEjBvvI8
    Sk6A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yAS8LoOkk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 28 Nov 2022 09:21:50 +0100 (CET)
Message-ID: <58a773bd-0db4-bade-f8a2-46e850df9b0b@hartkopp.net>
Date:   Mon, 28 Nov 2022 09:21:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
To:     Christoph Fritz <christoph.fritz@hexdev.de>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20221127190244.888414-1-christoph.fritz@hexdev.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Christoph,

are you already aware of this LIN project that uses the Linux SocketCAN 
infrastructure and implements the LIN protocol based on a serial tty 
adaption (which the serial LIN protocol mainly is)?

https://github.com/lin-bus

IIRC the implementation of the master/slave timings was the biggest 
challenge and your approach seems to offload this problem to your 
USB-attached hardware right?

Can I assume there will be a similar CAN-controlled programming 
interface to create real time master/slave protocol frames like in a 
usual CAN/LIN adapter (e.g. 
https://www.peak-system.com/PCAN-LIN.213.0.html) ??

Best regards,
Oliver


On 27.11.22 20:02, Christoph Fritz wrote:
> The intention of this series is to kick off a discussion about how to
> support LIN (ISO 17987) [0] in Linux.
> 
> This series consist of two patches which are two individual proposals
> for adding LIN abstraction into the kernel.
> 
> One approach is to add LIN ontop of CANFD:
>    [RFC] can: introduce LIN abstraction
> 
> The other approach is adding a new type of CAN-socket:
>    [RFC] can: Add LIN proto skeleton
> 
> These patches are abstracting LIN so that actual device drivers can
> make use of it.
> 
> For reference, the LIN-ontop-of-CANFD variant already has a device
> driver using it (not part of this series). It is a specially built USB
> LIN-BUS adapter hardware called hexLIN [1].  Its purpose is mainly to
> test, adapt and discuss different LIN APIs for mainline Linux kernel.
> But it can already be used productively as a Linux LIN node in
> controller (master) and responder (slave) mode. By sysfs, hexLIN
> supports different checksum calculations and setting up a
> responder-table.
> 
> For more info about hexLIN, see link below [1].
> 
> We are looking for partners with Linux based LIN projects for funding.
> 
> [0]: https://en.wikipedia.org/wiki/Local_Interconnect_Network
> [1]: https://hexdev.de/hexlin/
> 
> Christoph Fritz (1):
>    [RFC] can: Introduce LIN bus as CANFD abstraction
> 
> Richard Weinberger (1):
>    [RFC] can: Add LIN proto skeleton
> 
>   drivers/net/can/Kconfig          |  10 ++
>   drivers/net/can/Makefile         |   1 +
>   drivers/net/can/lin.c            | 181 +++++++++++++++++++++++++++
>   include/net/lin.h                |  30 +++++
>   include/uapi/linux/can.h         |   8 +-
>   include/uapi/linux/can/lin.h     |  15 +++
>   include/uapi/linux/can/netlink.h |   1 +
>   net/can/Kconfig                  |   5 +
>   net/can/Makefile                 |   3 +
>   net/can/lin.c                    | 207 +++++++++++++++++++++++++++++++
>   10 files changed, 460 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/net/can/lin.c
>   create mode 100644 include/net/lin.h
>   create mode 100644 include/uapi/linux/can/lin.h
>   create mode 100644 net/can/lin.c
> 

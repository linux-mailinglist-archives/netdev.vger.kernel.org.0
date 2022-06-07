Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED0D542047
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384909AbiFHAUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842144AbiFHAIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 20:08:49 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6909FA3383;
        Tue,  7 Jun 2022 13:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654632773;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=Gst6T9vPJJaniT6EGkMvyNGdNEUusbhezNnjdPnMqmg=;
    b=g1VjUKQATbB0IZd8VWSCRFshb/yOD6xJfQE3NXB3Kvi9R5u8sXOCG7AdarC/E98UbS
    DyZnu8VuR99GNxcC41Vj0cOXlAY5TBGuf2ku4hohnvaBEisgrl9MWu9X5apaRMTJE44o
    O1XxKUWDosL4oaUljokmeqTrUzGv3uknTdGPiM5Gfr/Yty1MJpmrL2bYyVj2xD6vRZA/
    n9833TLOjV7jJBAEer8V08fv0kRqZxuBhyCXtEGmsllyPR/rhXbDbKMi2zIQpucu+Mg5
    WHl0DydCzu6DUXkISNhP/8R1rMNhf+3YTdmHG2L8HwX1HywbhecMalmBW9y7GVXI1sZW
    BlHw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofo7wY7W6Qxgy"
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy57KCq8b5
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 7 Jun 2022 22:12:52 +0200 (CEST)
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
 <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
 <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <f161fdd0-415a-8ea1-0aad-3a3a19f1bfa8@hartkopp.net>
Date:   Tue, 7 Jun 2022 22:12:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On 07.06.22 04:49, Vincent MAILHOL wrote:
> On Tue. 7 Jun. 2022 at 04:43, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>>

>>>             |
>>>             +-> All other CAN devices not relying on RX offload
>>>             |
>>>             +-> CAN rx offload
>>>                 symbol: CONFIG_CAN_RX_OFFLOAD
>>
>> Is this still true in patch series 5?
>>
>> If I understood it correctly CONFIG_CAN_BITTIMING and
>> CONFIG_CAN_RX_OFFLOAD can be enabled by the user and
>> (alternatively/additionally) the selection of "flexcan, m_can, mcp251xfd
>> and ti_hecc" enables CONFIG_CAN_RX_OFFLOAD too.
>>
>> Right?
> 
> Yes, this is correct. Maybe what troubles you is the meaning of the
> "x --> y" arrow in the graph. I said it denotes that "y depends on x".
> Here "depends on" has a loose meaning. It translates to either:
>    * Feature Y is encapsulated in Kbuild by some "if X/endif" and won't
> show up unless X is selected.
>    * Feature Y has a "selects X" tag and will forcibly enable X if selected.
> 
> CONFIG_CAN_*CALC*_BITTIMING is on the left side of an arrow starting
> from CONFIG_CAN_NETLINK so it "depends" on CONFIG_CAN_NETLINK. On the
> other hand, CONFIG_CAN_*CALC*_BITTIMING does not have any arrow
> starting from it so indeed, it can be enabled by the user
> independently of the other features as long as CONFIG_CAN_NETLINK is
> selected.

Ok.

> CONFIG_CAN_RX_OFFLOAD is also on the left side of an arrow starting
> from CONFIG_CAN_NETLINK. Furthermore, there is an arrow starting from
> CONFIG_CAN_RX_OFFLOAD going to the "rx offload drivers". So those
> drivers need CONFIG_CAN_RX_OFFLOAD (which is implemented using the
> "selects CONFIG_CAN_RX_OFFLOAD"). However, CONFIG_CAN_RX_OFFLOAD can
> be selected independently of the "rx offload drivers" as long as its
> CONFIG_CAN_NETLINK dependency is met.
> 
> So I think that the diagram is correct. Maybe rephrasing the cover
> letter as below would address your concerns?
I applied your series and played with the options and it works like 
charm - and as expected.

But the point remains that from your figure I would still assume that 
the M_CAN driver would only show up when CONFIG_CAN_RX_OFFLOAD was 
selected by the user.

But the current (good) implementation shows *all* drivers and selects 
CONFIG_CAN_RX_OFFLOAD when e.g. M_CAN is selected.

So what about:

   symbol: CONFIG_NETDEVICES
   |
   +-> CAN Device Drivers
       symbol: CONFIG_CAN_DEV
       |
       +-> software/virtual CAN device drivers
       |   (at time of writing: slcan, vcan, vxcan)
       |
       +-> hardware CAN device drivers with Netlink support
           symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
           |
           +-> CAN bit-timing calculation (optional for all drivers)
           |   symbol: CONFIG_CAN_BITTIMING
           |
           +-> CAN rx offload (optional but selected by some drivers)
           |   symbol: CONFIG_CAN_RX_OFFLOAD
           |
           +-> CAN devices drivers
               (some may select CONFIG_CAN_RX_OFFLOAD)

(I also added 'hardware' to CAN device drivers with Netlink support) to 
have a distinction to 'software/virtual' CAN device drivers)

At least this would help me to understand the new configuration setup.

Best regards,
Oliver

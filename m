Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A91543D61
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiFHUKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiFHUKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:10:33 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B9C8BF3;
        Wed,  8 Jun 2022 13:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654719024;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=B2P//ROkf6YmQJj7jDHW1MNjeRCcZU5CXSgS81M75yY=;
    b=QuXrWehNNlVB9HzKGoApc1Utc4kEoFhWcRW6ZH9K735kX3nonDZe58GgHKevEd4n4u
    WC7YNvMB5uS3xXiVe/oMg0nZwf4kEIKtpOUFveQO+aBzgGhxKqfV1V255Z/BIqNgDjTX
    TVG4SrBekP+2H4qloJrpladzIGRoVDmThPIgDgmrYHulrGzXPIkHY/YYKgufRy9PDYKE
    jMXQtuBmBno2DgR2BW8RzVRWEVIuSBPZdW6LR1uvRWLk/apGPT9e0dt6dTTWX8i1yWQ3
    ifkFoQprGgSEmspVcwv16vVVlbiJid1/TTWspQjYK5BKm+WovCgrsNhjlIh0234so9oB
    SYQw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofov4eKO8Kg=="
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy58KANC2Y
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 8 Jun 2022 22:10:23 +0200 (CEST)
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
 <f161fdd0-415a-8ea1-0aad-3a3a19f1bfa8@hartkopp.net>
 <20220607202706.7fbongzs3ixzpydm@pengutronix.de>
 <44670e69-6d67-c6c7-160c-1ae6e740aabb@hartkopp.net>
 <CAMZ6RqJq70qv97oNbNXL6z+52b3pyg9rBNNd4BKmpO4-6Xg=Gw@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <4434ce21-3322-a05e-ed04-fd945fea54e3@hartkopp.net>
Date:   Wed, 8 Jun 2022 22:10:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqJq70qv97oNbNXL6z+52b3pyg9rBNNd4BKmpO4-6Xg=Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.06.22 01:59, Vincent MAILHOL wrote:
> On Wed. 8 Jun 2022 at 05:51, Oliver Hartkopp <socketcan@hartkopp.net> wrote:

>>>> (I also added 'hardware' to CAN device drivers with Netlink support) to have
>>>> a distinction to 'software/virtual' CAN device drivers)
> 
> This line you modified is the verbatim copy of the title in
> menuconfig. So you are suggesting adding "hardware" to the menuconfig
> as well? It did not have this word in the title before this series.
> I was hesitating on this. If we name the symbol CAN_NETLINK, then I do
> not see the need to also add "hardware" in the title. If you look at
> the help menu, you will see: "This is required by all platform and
> hardware CAN drivers." Mentioning it in the help menu is enough for
> me.
> 
> And because of the blur line between slcan (c.f. Marc's comment
> below), I am not convinced to add this.

Yes, discussing about this change I'm not convinced either ;-)

>>> The line between hardware and software/virtual devices ist blurry, the
>>> new can327 driver uses netlink and the slcan is currently being
>>> converted....
>>
>> Right, which could mean that slcan and can327 should be located in the
>> 'usual' CAN device driver section and not in the sw/virtual device section.
> 
> ACK, but as discussed with Marc, I will just focus on the series
> itself and ignore (for the moment) that slcan will probably be moved
> within CAN_NETLINK scope in the future.
> https://lore.kernel.org/linux-can/20220607103923.5m6j4rykvitofsv4@pengutronix.de/

Ok.

Sorry for the noise!

Best regards,
Oliver


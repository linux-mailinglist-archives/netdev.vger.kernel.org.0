Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C601542619
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbiFHBUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 21:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388331AbiFHAlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 20:41:00 -0400
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C1C1A;
        Tue,  7 Jun 2022 17:00:03 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id p13so33764910ybm.1;
        Tue, 07 Jun 2022 17:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djM9qxIv8WYqj0AGoYFkLyyQF5ybi28fwJWBEEtW3bs=;
        b=Do2AmXMGrLMH1zLONKYe3r6uZqjrYt4qmWQBwrZqa1tnBgPrfWz71vlYeBpi62Ri2o
         0HU4+rzWTXqTklR8sDKo+q7aeikMPseCA25KP1+T0abcqTu+ec6mbEXlM7dga8T7he+J
         cIKLWG6P6o/Z5U+6JIm/2UK8Qyweozlumuo//MR5S5Gbxn7P9YtDTAziGH6phhzFO0ni
         z3xKJO6M4ZonaUWAaLPD7z4dewnqyfqZq11ge/GtF8Gufvg2nrkdopYJ0OITdrZcLF1q
         1VkeqF1dnITmXrgmKVSGpNMjfHFnVr7R324aq3tSqpAzXM512dkabVxCrNjstm+YJoto
         dQ1w==
X-Gm-Message-State: AOAM5330Ox5iyM5EM2EXVkIkiDzkWWwGtLpBWcr44eHG07wQ2NfCrAj0
        WcTWlYd1WqmZbrYKZiCr63KSSzorrj7ovnNKMZvC8Q78kpKixA==
X-Google-Smtp-Source: ABdhPJz9g+8g0g0him4k8ulgm6ajYFAMb7TCbj1rvWSak+qkPb6HsK2dH1sUp5yR5pUwL2qYrNvSvCPXWdy80Dd524I=
X-Received: by 2002:a25:6588:0:b0:65d:57b9:c470 with SMTP id
 z130-20020a256588000000b0065d57b9c470mr33194296ybb.142.1654646402496; Tue, 07
 Jun 2022 17:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
 <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
 <f161fdd0-415a-8ea1-0aad-3a3a19f1bfa8@hartkopp.net> <20220607202706.7fbongzs3ixzpydm@pengutronix.de>
 <44670e69-6d67-c6c7-160c-1ae6e740aabb@hartkopp.net>
In-Reply-To: <44670e69-6d67-c6c7-160c-1ae6e740aabb@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 8 Jun 2022 08:59:51 +0900
Message-ID: <CAMZ6RqJq70qv97oNbNXL6z+52b3pyg9rBNNd4BKmpO4-6Xg=Gw@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 8 Jun 2022 at 05:51, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 07.06.22 22:27, Marc Kleine-Budde wrote:
> > On 07.06.2022 22:12:46, Oliver Hartkopp wrote:
> >> So what about:
> >>
> >>    symbol: CONFIG_NETDEVICES
> >>    |
> >>    +-> CAN Device Drivers
> >>        symbol: CONFIG_CAN_DEV
> >>        |
> >>        +-> software/virtual CAN device drivers
> >>        |   (at time of writing: slcan, vcan, vxcan)
> >>        |
> >>        +-> hardware CAN device drivers with Netlink support
> >>            symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
> >>            |
> >>            +-> CAN bit-timing calculation (optional for all drivers)
> >>            |   symbol: CONFIG_CAN_BITTIMING
> >>            |
> >>            +-> CAN rx offload (optional but selected by some drivers)
> >>            |   symbol: CONFIG_CAN_RX_OFFLOAD
> >>            |
> >>            +-> CAN devices drivers
> >>                (some may select CONFIG_CAN_RX_OFFLOAD)

OK, this does not follow the definition I set for the "x --> y" arrow,
but it is easy to read. I am OK with your suggestion. I will also
remove the definition of the "x --> y" arrow because your diagram is
self explanatory.

> >> (I also added 'hardware' to CAN device drivers with Netlink support) to have
> >> a distinction to 'software/virtual' CAN device drivers)

This line you modified is the verbatim copy of the title in
menuconfig. So you are suggesting adding "hardware" to the menuconfig
as well? It did not have this word in the title before this series.
I was hesitating on this. If we name the symbol CAN_NETLINK, then I do
not see the need to also add "hardware" in the title. If you look at
the help menu, you will see: "This is required by all platform and
hardware CAN drivers." Mentioning it in the help menu is enough for
me.

And because of the blur line between slcan (c.f. Marc's comment
below), I am not convinced to add this.

> > The line between hardware and software/virtual devices ist blurry, the
> > new can327 driver uses netlink and the slcan is currently being
> > converted....
>
> Right, which could mean that slcan and can327 should be located in the
> 'usual' CAN device driver section and not in the sw/virtual device section.

ACK, but as discussed with Marc, I will just focus on the series
itself and ignore (for the moment) that slcan will probably be moved
within CAN_NETLINK scope in the future.
https://lore.kernel.org/linux-can/20220607103923.5m6j4rykvitofsv4@pengutronix.de/

> The slcan and can327 need some kind of hardware - while vcan and vxcan
> don't.


Yours sincerely,
Vincent Mailhol

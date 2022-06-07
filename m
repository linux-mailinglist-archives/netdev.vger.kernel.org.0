Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D5253F412
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 04:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiFGCto convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Jun 2022 22:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiFGCtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 22:49:43 -0400
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC41E9FC2;
        Mon,  6 Jun 2022 19:49:42 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id r82so28833115ybc.13;
        Mon, 06 Jun 2022 19:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PpYh+QobaxTbaxOtO/UmMKh1nTqN4dPLt32NZJXUymI=;
        b=W0ojr3N2Zqce9e3aKtyFOzENSecZhvSUEDn0K5NtalpBcWtUJlpL5RZPc5MMR2bsWV
         QPX8yHysAaSn8+yrY66Md+yHYgR+rCY7qUdr90eIUCMI6T/NtE8VWOuUNX3Sxkpdbbof
         dsy/gVfLmEht754McwrdSzWHIapxAmBeVZCLz/9ewcBT8yjJfwkn7Yv5DDITAyRUwpnM
         PysMMRkK1uX3BRdAqEF9DMnNEwj8OOwcNnfDwYPaRtxTS6552MmtDnulSsal2G23ToOI
         RgSBX56V58R03jq6ywjOvNlo6OrhYgk7WK9FFvzQboDCfi+L5ukpisSkf4FKWbQszck4
         JT9A==
X-Gm-Message-State: AOAM531l3tyHpzotfrvPwi3V7G1yxHINk73F0R16W3xPml822YGW6jKA
        ZPbUTjqXTAX1ZiSOFleHhIKx+0rVr7wKs70FNglU1VWLCJM=
X-Google-Smtp-Source: ABdhPJw8jQiEYoAuCtiiDpozCoWcazk87mp/tYccYkibwis5yVlJutCamZsLZ9BNkSehIwHkSYGhuSUfb0pO4KGm3bE=
X-Received: by 2002:a25:55d7:0:b0:663:3850:e85f with SMTP id
 j206-20020a2555d7000000b006633850e85fmr16032131ybb.500.1654570182089; Mon, 06
 Jun 2022 19:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
In-Reply-To: <2e8666f3-1bd9-8610-6b72-e56e669d3484@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 11:49:30 +0900
Message-ID: <CAMZ6RqKWUyf6dZmxG809-yvjg5wbLwPSLtEfv-MgPpJ5ra=iGQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Max Staudt <max@enpas.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 7 Jun. 2022 at 04:43, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
> Hi Vincent,
>
> great work!

Thanks!

> On 04.06.22 18:29, Vincent Mailhol wrote:
>
> > * menu after this series *
> >
> > Network device support
> >    symbol: CONFIG_NETDEVICES
> >    |
> >    +-> CAN Device Drivers
> >        symbol: CONFIG_CAN_DEV
> >        |
> >        +-> software/virtual CAN device drivers
> >        |   (at time of writing: slcan, vcan, vxcan)
> >        |
> >        +-> CAN device drivers with Netlink support
> >            symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
> >            |
> >            +-> CAN bit-timing calculation (optional for all drivers)
> >            |   symbol: CONFIG_CAN_BITTIMING
                           ^^^^^^^^^^^^^^^^^^^^
Typo: the symbol is CONFIG_CAN_*CALC*_BITTIMING. I made that typo
twice in the cover letter (once in each diagram). The patches and
their comments remain correct.

> >            |
> >            +-> All other CAN devices not relying on RX offload
> >            |
> >            +-> CAN rx offload
> >                symbol: CONFIG_CAN_RX_OFFLOAD
>
> Is this still true in patch series 5?
>
> If I understood it correctly CONFIG_CAN_BITTIMING and
> CONFIG_CAN_RX_OFFLOAD can be enabled by the user and
> (alternatively/additionally) the selection of "flexcan, m_can, mcp251xfd
> and ti_hecc" enables CONFIG_CAN_RX_OFFLOAD too.
>
> Right?

Yes, this is correct. Maybe what troubles you is the meaning of the
"x --> y" arrow in the graph. I said it denotes that "y depends on x".
Here "depends on" has a loose meaning. It translates to either:
  * Feature Y is encapsulated in Kbuild by some "if X/endif" and won't
show up unless X is selected.
  * Feature Y has a "selects X" tag and will forcibly enable X if selected.

CONFIG_CAN_*CALC*_BITTIMING is on the left side of an arrow starting
from CONFIG_CAN_NETLINK so it "depends" on CONFIG_CAN_NETLINK. On the
other hand, CONFIG_CAN_*CALC*_BITTIMING does not have any arrow
starting from it so indeed, it can be enabled by the user
independently of the other features as long as CONFIG_CAN_NETLINK is
selected.
CONFIG_CAN_RX_OFFLOAD is also on the left side of an arrow starting
from CONFIG_CAN_NETLINK. Furthermore, there is an arrow starting from
CONFIG_CAN_RX_OFFLOAD going to the "rx offload drivers". So those
drivers need CONFIG_CAN_RX_OFFLOAD (which is implemented using the
"selects CONFIG_CAN_RX_OFFLOAD"). However, CONFIG_CAN_RX_OFFLOAD can
be selected independently of the "rx offload drivers" as long as its
CONFIG_CAN_NETLINK dependency is met.

So I think that the diagram is correct. Maybe rephrasing the cover
letter as below would address your concerns?

| Below diagrams illustrate the changes made. The arrow symbol "X --> Y"
| denotes that "Y needs X". Most of the time, it is implemented using "if X"
| and "endif" predicates in X’s Kbuild to encapsulate Y so that Y
| does not show up unless X is selected. The exception is rx
| offload which is implemented by adding a "selects
| CONFIG_CAN_RX_OFFLOAD" tag in Y’s Kbuild.

> >                |
> >                +-> CAN devices relying on rx offload
> >                    (at time of writing: flexcan, m_can, mcp251xfd and ti_hecc)

Yours sincerely,
Vincent Mailhol

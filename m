Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCC053DF18
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 02:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351856AbiFFAY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 20:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351837AbiFFAYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 20:24:51 -0400
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313A125C44;
        Sun,  5 Jun 2022 17:24:50 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id a64so23048293ybg.11;
        Sun, 05 Jun 2022 17:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhholLSVW1kM55iwZZI2t8gbPSyqvbmhGWq+MHhItoQ=;
        b=Zir4EekHNruFs92vHV7I4AyBbu/TmZsV/yKahGWguWGPdd3UAGCGBd6Z0dxmbVy2Q3
         btTnNonPIOUBh4sM0vYDCudGQyOTH6mSlCs4rm2Q+QjNhqTZJwpkRtHbhBBX8dn3S8P1
         ss71rtb0sghTHKn3OHUN6ys0no2wKkEnIZKpHht2dg1y07b0IZ6kHjCGhA/pSCWJbXaK
         pYlXPPFjJLvCL/yHPwo1KYbBcZ3mCbjWucTXVZk/O9EVQElaHxVaxbUiOJr7rcjoOphh
         KD69MZ3MDD08/0nS/VBdBtb7oGdVW9UtYif9G4gcQ6WWGM+RD+LRe6a0muBA0IpQL4GW
         SLxA==
X-Gm-Message-State: AOAM532Fhk1H/rvNjNXFNu4X+3TrycJxZm+MwuK+RZ8Y0ijdCwfuVR1b
        z1ZMjVaYpxxG3bLEJXMvr6oBFrjA5mPQpVCxDRurZg2zh/0=
X-Google-Smtp-Source: ABdhPJwDuaA1GQqCL2ElzvtIZOGwBwJjsmrAil55E8Zp2R0/mGtaP6SljfBW+/6NjBbzgldJW+p2/nZBPRzerGuuZ1k=
X-Received: by 2002:a25:55d7:0:b0:663:3850:e85f with SMTP id
 j206-20020a2555d7000000b006633850e85fmr10408274ybb.500.1654475089327; Sun, 05
 Jun 2022 17:24:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <20220605192347.518c4b3c.max@enpas.org>
 <20220605180641.tfqyxhkkauzoz2z4@pengutronix.de> <20220605224640.3a09e704.max@enpas.org>
In-Reply-To: <20220605224640.3a09e704.max@enpas.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 6 Jun 2022 09:24:38 +0900
Message-ID: <CAMZ6RqKZwC_OKcgH+WPacY6kbNbj4xR2Gdg2NQtm5Ka5Hfw79A@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] can: refactoring of can-dev module and of Kbuild
To:     Max Staudt <max@enpas.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
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

On Mon. 6 Jun. 2022, at 05:46, Max Staudt <max@enpas.org> wrote:
>
> On Sun, 5 Jun 2022 20:06:41 +0200
> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> > On 05.06.2022 19:23:47, Max Staudt wrote:
> > > This seemingly splits drivers into "things that speak to hardware"
> > > and "things that don't". Except... slcan really does speak to
> > > hardware.

slcan is just an oddity in this regard because all the netlink logic
is done in userspace using slcand. I think that it would really
benefit to be rewritten using the features under CAN_NETLINK.

This way, it could for example benefit from can_priv::bitrate_const to
manage the bitrates via iproute2 instead of relying on slcand c.f.:
https://elinux.org/Bringing_CAN_interface_up#SLCAN_based_Interfaces

Similarly, it doesn't seem that slcan loopbacks the TX frames which,
in some way, violates one of the core concepts of SocketCAN:

https://docs.kernel.org/networking/can.html#local-loopback-of-sent-frames

You did a great job by putting all the logic in your can327 driver
instead of requiring a userland tool and I think slcan merits to have
your can327 improvements backported to him.

> It just so happens to not use any of BITTIMING or
> > > RX_OFFLOAD. However, my can327 (formerly elmcan) driver, which is
> > > an ldisc just like slcan, *does* use RX_OFFLOAD, so where to I put
> > > it? Next to flexcan, m_can, mcp251xfd and ti_hecc?
> > >
> > > Is it really just a split by features used in drivers, and no
> > > longer a split by virtual/real?
> >
> > We can move RX_OFFLOAD out of the "if CAN_NETLINK". Who wants to
> > create an incremental patch against can-next/master?
>
> Yes, this may be useful in the future. But for now, I think I can
> answer my question myself :)

I was about to answer you, but you corrected the shot before I had
time to do so :)

> My driver does support Netlink to set CAN link parameters. So I'll just
> drop it into the CAN_NETLINK -> RX_OFFLOAD category in Kconfig, unless
> anyone objects.

This is the correct approach (and the only one). Try to maintain the
alphabetical order of the menu when you add it.

> I just got confused because in my mind, I'm still comparing it to
> slcan, whereas in reality, it's now functionally closer to all the other
> hardware drivers. Netlink and all.
>
> Apologies for the noise!

No problem!


Yours sincerely,
Vincent Mailhol

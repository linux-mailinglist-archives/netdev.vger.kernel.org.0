Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DA947D07B
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhLVLFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244383AbhLVLFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:05:49 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4082C06173F
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:05:49 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so2349838otv.9
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EnmkjG/M/mYPKhrbxJWx86dk/HHC8CyIdBk3edxvaYk=;
        b=iHO0C9290gjwIMXxBN9AdHEdMYecNXex8Tk/moQ0q/oN0EucJpu0GL5L13Fyn5dOOS
         fFG5jPrC6VPJmJ5fqPwD5nhDjKgpPe77n7May885zLnJACgENDaIqUGxPz6G9yxH1xXL
         WBcB8Lv/ztzK+PsWhQBRiq//bGTwXfZeXUtbfAQAVcL5KrZgZzLcgiYf97k08W/qI4oT
         2Sw9FDyX81gTwmBuuOnV0OIRkSLbuyInwfViXZ9vhZRIkFsp5sh9QgdTPvERowtzFTX3
         mMZaE4FlPsfmS/C80OToTv8DIGgPLb33hgLb4JxOqGcH17ETeNXOZlfJJqS5UKKPCHdy
         jRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EnmkjG/M/mYPKhrbxJWx86dk/HHC8CyIdBk3edxvaYk=;
        b=UIW6hI7EHQc71tWzSM4QfNlMUcgkVBe9NoaY9yj8/jGRlCQPh/zoyt555NRy/wCJMt
         kEnzv9pXPWIiTh7Ygnl7m6wjcJBQYdP1YZaiZGrMX6vDq+Lyt5O+G/HdVC7CTnMoIrxe
         urQmXVtcN1wJy5qGZYjvLQjqWzOe93nA/iYQNTTaf4PgDUwEHs8yYFoDWuNVzmkuK2Ll
         4FkjPGgu5BrhZhMsqfgzMg1Luz8nqr9mz4bvtaRcJm9PjKbAp7k39OhE4xaLlgIOXvE/
         wVKwNQK/+VeQg000qbk+6ulsE4YqLweeDDsMar0YsFJmxgw5DXjNzF3khRR+TqYYBCPT
         FNOQ==
X-Gm-Message-State: AOAM5305No1c0SDtJBG6BB8j20nW1kMGj7zv5spdv0Xi0meSYffdmEdA
        MyB1/38esFQTavaethCG4zG2QSkVuY+ocaJSHmTd1xGDMEw=
X-Google-Smtp-Source: ABdhPJw9eMDSPntvwjGka/b5RaL2w5vOnmKsIigdnepkScH4comDmsL4ABQXq6ujGWw6a//qQdZOaskw1iXxUQcxOEw=
X-Received: by 2002:a05:6830:1e8f:: with SMTP id n15mr1646087otr.259.1640171149062;
 Wed, 22 Dec 2021 03:05:49 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbj93LvTu9RjVXD+NcT0JYoA42BC7pSHumtNJfniSobAqA@mail.gmail.com>
 <DB8PR04MB679571AF60C377BB1242D26BE67D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB679571AF60C377BB1242D26BE67D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Wed, 22 Dec 2021 12:05:38 +0100
Message-ID: <CAMeyCbiYwB=SK3vvqdTEWhbnHwee8U6rfxzNs9B8-hyr45GhOw@mail.gmail.com>
Subject: Re: net: fec: memory corruption caused by err_enet_mii_probe error path
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 9:01 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrote:

> > This error path frees the DMA buffers, BUT as far I could see it does not stop
> > the DMA engines.
> > => open() fails => frees buffers => DMA still active => MAC receives network
> > packet => DMA starts => random memory corruption (use after
> > free) => random kernel panics
>
> A question here, why receive path still active? MAC has not connected to PHY when this failure happened, should not see network activities.

It is a imx.28 platform using the fec for dual ethernet eth0 & eth1.

One of our devices (out of 10) eth1 did not detect a phy for eth1 on
ifup ( fec_open() ) => mdio error path => random system crashes
But the phy is there and the link is good, only MDIO access failed.
phys have autoneg activated after reset. So the RX path is active,
even if the fec driver says that there is no phy.

Without attached ethernet cable the phy was also not detected, BUT the
system did not crash. => Because no packets will arrive without
attached cable.

So the main issue on our side is the not detected phy. And the other
issue is the use after free in the error path.

I think the main issue has something to do with phy reset handling.
On a cold boot the eth1 phy is detected successfully. A warm restart (
reboot -f ) will always lead to a not detected eth1 phy. The eth0 phy
is always detected.
From past experience the dual ethernet implementation in the driver
was not the most stable one. Maybe because of a smaller user base.
In our setup both phy reset lines are connected to gpios with the
correct entry in the mac0 & mac1 DT entry.
Revert of https://github.com/torvalds/linux/commit/7705b5ed8adccd921423019e870df672fa423279#diff-655f306656e7bccbec8fe6ebff2adf466bb8133f5bcb551112d3fe37e50b1a15
seems to get the phys in a correct state before the fec driver is
probed and both phys are detected.

> > So maybe fec_stop() as counterpart to fec_restart() is missing before freeing
> > the buffers?
> > err_enet_mii_probe:
> > fec_stop(ndev);
> > fec_enet_free_buffers(ndev);
> >
> > Issue happend with 5.10.83 and should also also happen with current master.
>
> It's fine for me, please see if anyone else has some comments. If not, please cook a formal patch, thanks.
So fec_stop is the right guess to stop the rx/tx dma rings.

Other paths use netif_tx_lock_bh before calling fec_stop().
I don't think this is necessary because netif_tx_start_all_queues()
was not called before in this error path case?
https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/freescale/fec_main.c#L3207

index 1b1f7f2a6..8f208b4a9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3211,8 +3211,9 @@ fec_enet_open(struct net_device *ndev)

        return 0;

 err_enet_mii_probe:
+       fec_stop(ndev);
        fec_enet_free_buffers(ndev);
 err_enet_alloc:
        fec_enet_clk_enable(ndev, false);
 clk_enable:

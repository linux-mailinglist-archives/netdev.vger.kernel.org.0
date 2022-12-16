Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937DF64E6C2
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiLPElI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Dec 2022 23:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLPElG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:41:06 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3BE6366;
        Thu, 15 Dec 2022 20:41:01 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id d3so1150529plr.10;
        Thu, 15 Dec 2022 20:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idu/8FxD+PQK9l8zHYNdC3ZtLj9zNJ2MUZIelYcW0aE=;
        b=DZZliLVsGkGfZ3eCapgMsgoH0YIUDl7AWu2TL7FybLjVYzfrBhBR5mL2feKGwbejjl
         SwGV6Zr5bMtb+gFHnw1YMshJClAe73t2d4nj6fLgoVrXzbm+1uGTg53Mo2YsCEB1h6gD
         1mlnZ8b3GGZELr97PCp5v0Q2iCHDLNYx9+xv3ItefXlcTqKusjnUnGyBy/sj0XVTfoAV
         Oz9fvOk/sAGx30+388ifbKnDORsE1OVlLDb0+9u4DL60dTTB0XjV/DBfoU5xqJ6Ja1X2
         QguNOFJaWaXaEndiN2Hqj3z2lIAYYcfuv8oI8IzEXpop17/euLx75J6gw3QynIPos9Gw
         p7pQ==
X-Gm-Message-State: AFqh2krBFg83wv2Mfqn4voonQYdyYDZ3VXJFGLnjA1VsM6S90cHgc7xr
        Abiw/aOqG6RvTLB1LpXY0GeQYeaVkE8J6JysUck=
X-Google-Smtp-Source: AMrXdXskktqxQqziYQg+ykW6hbRxVC+hH0xzdGaj1NKDK4YmlrmRd2Pfy0qK1CIcDYtsvUgnPs/g0eOpfbbowOjNEA0=
X-Received: by 2002:a17:90a:c7d3:b0:21c:bc8b:b080 with SMTP id
 gf19-20020a17090ac7d300b0021cbc8bb080mr421817pjb.19.1671165661121; Thu, 15
 Dec 2022 20:41:01 -0800 (PST)
MIME-Version: 1.0
References: <20221116205308.2996556-1-msp@baylibre.com> <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de> <20221214091406.g6vim5hvlkm34naf@blmsp>
 <20221214091820.geugui5ws3f7a5ng@pengutronix.de> <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
 <CAMZ6RqLAZNj9dm_frbKExHK8AYDj9D0rX_9=c8_wk9kFrO-srw@mail.gmail.com>
 <20221214103542.c5g32qtbuvn5mv4u@blmsp> <20221215093140.fwpezasd6whhk7p7@blmsp>
In-Reply-To: <20221215093140.fwpezasd6whhk7p7@blmsp>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 16 Dec 2022 13:40:50 +0900
Message-ID: <CAMZ6RqLTbD1KHqtg5E8tTGy1BFjJYjzVcK3-1L_WXo+Vw8cO4g@mail.gmail.com>
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 15 Dec. 2022 at 18:44, Markus Schneider-Pargmann
<msp@baylibre.com> wrote:
> Hi,
>
> On Wed, Dec 14, 2022 at 11:35:43AM +0100, Markus Schneider-Pargmann wrote:
> > Hi Vincent,
> >
> > On Wed, Dec 14, 2022 at 07:15:25PM +0900, Vincent MAILHOL wrote:
> > > On Wed. 14 Dec. 2022 at 18:28, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > > On 14.12.2022 10:18:20, Marc Kleine-Budde wrote:
> > > > > On 14.12.2022 10:14:06, Markus Schneider-Pargmann wrote:
> > > > > > Hi Marc,
> > > > > >
> > > > > > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > > > > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > > > > > Currently the driver waits to wakeup the queue until the interrupt for
> > > > > > > > the transmit event is received and acknowledged. If we want to use the
> > > > > > > > hardware FIFO, this is too late.
> > > > > > > >
> > > > > > > > Instead release the queue as soon as the transmit was transferred into
> > > > > > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > > > > > transferred.
> > > > > > >
> > > > > > > If you want to really speed up the TX path, remove the worker and use
> > > > > > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> > > > > > >
> > > > > > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > > > > > per SPI transfer.
> > > > > >
> > > > > > Just a quick question here, I mplemented a xmit_more() call and I am
> > > > > > testing it right now, but it always returns false even under high
> > > > > > pressure. The device has a txqueuelen set to 1000. Do I need to turn
> > > > > > some other knob for this to work?
> > >
> > > I was the first to use BQL in a CAN driver. It also took me time to
> > > first figure out the existence of xmit_more() and even more to
> > > understand how to make it so that it would return true.
> > >
> > > > > AFAIK you need BQL support: see 0084e298acfe ("can: mcp251xfd: add BQL support").
> > > > >
> > > > > The etas_es58x driver implements xmit_more(), I added the Author Vincent
> > > > > on Cc.
> > > >
> > > > Have a look at netdev_queue_set_dql_min_limit() in the etas driver.
> > >
> > > The functions you need are the netdev_send_queue() and the
> > > netdev_complete_queue():
> > >
> > >   https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L3424
> > >
> > > For CAN, you probably want to have a look to can_skb_get_frame_len().
> > >
> > >   https://elixir.bootlin.com/linux/latest/source/include/linux/can/length.h#L166
> > >
> > > The netdev_queue_set_dql_min_limit() gives hints by setting a minimum
> > > value for BQL. It is optional (and as of today I am the only user of
> > > it).
> >
> > Thank you for this summary, great that you already invested the time to
> > make it work with a CAN driver. I will give it a try in the m_can
> > driver.
>
> Thanks again, it looks like it is working after adding netdev_sent_queue
> and netdev_complete_queue.

Happy to hear that :)

A quick advice just in case: make sure to test the different error
branches (failed TX, can_restart() after bus off…).


Yours sincerely,
Vincent Mailhol

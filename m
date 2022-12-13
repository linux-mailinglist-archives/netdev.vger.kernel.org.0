Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682FB64BDA8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiLMTzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbiLMTzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:55:11 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115B626572;
        Tue, 13 Dec 2022 11:55:10 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id j4so6823130lfk.0;
        Tue, 13 Dec 2022 11:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nk3UifPWZ8X9jtpCKSxbryHT9Gexr5oq8yB6NwibN9U=;
        b=kemGwEJvt2zd6KBzrqEHTXqhqYMo0suffwvPbd2M1aN+H95ddC4bOnIAsVOr3cMo8o
         yWIp2zZ+ho46O0SrFNgYOz0Ln2mMlz6IXIDUiRgqPD4NgRn6CgHflkgfQLSPgBmdkJvI
         fNEejwpFG6MzxN9pXoXpfDZdBDHESaloM0SWssnhRRbrFhPx9A+WlUC4pxD49e7JJ1lY
         WrSCCsapw28AlaYeM+ut2dGp7GMbtcozMVpVY4wZW+6xFxtiCgOyWbbGd8EW/Fjb1RK2
         zA0fmeksK7R5yFVrc81xpO+LuGvsTRT0a3v5R3a3xsC4S4RGFarf5p8HN0ibI6xHEWD3
         Kz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nk3UifPWZ8X9jtpCKSxbryHT9Gexr5oq8yB6NwibN9U=;
        b=GnwSmT0ZKQSNheMxf49qZhC68uUr00UUeMokTdLTbWIFeCJliBfqCJ9J8DY8haiZQk
         v7qDoEiDNvOVG+4O54WOGlzuzrA5csJHIxbZfd4iKmGv5+NoHwUE/fYmxRsMJvmLra6J
         8arhsNlHm7x6RXFXwuV9h95LalDfLElQ4Vv6l21vWPKrRfJjv/la2RzhzjRCh3gDo0/d
         m9z5VW9iU7ebmiCpC2zJJTD0cqn4BsHUcrW7Yava5MNWHDc5PSTNchztXYO0JLLhA+z5
         y/pwajK71XRdExys3u6hCGHGDdyU4+hKq5Wh/G0Ek/VPS/AmNXxynu2RJQWlWodci+0k
         PZwQ==
X-Gm-Message-State: ANoB5pkiv/V3UgXXL2n3Z926DtgJvqyuBjhSVtU9r6NYgL1mujtZpZ9m
        ymzlBCVjQpPQZAfxfZNIiui3C1OwmyVPsQ/T3w==
X-Google-Smtp-Source: AA0mqf79C7AC3F6i3PzYfN/nJFEFP2hYsBNPvmmImhudch/GOumKMTpC2rBPdTzoRO8xQ6CvE/fdFQaYdUYQgmJPjnI=
X-Received: by 2002:a05:6512:238c:b0:4b5:87b5:75bf with SMTP id
 c12-20020a056512238c00b004b587b575bfmr4503074lfv.493.1670961308268; Tue, 13
 Dec 2022 11:55:08 -0800 (PST)
MIME-Version: 1.0
References: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
 <CAGRyCJGCrR_FVjCmsnbYhs76bDc0rD83n-=2ros2p9W_GeVq-w@mail.gmail.com>
In-Reply-To: <CAGRyCJGCrR_FVjCmsnbYhs76bDc0rD83n-=2ros2p9W_GeVq-w@mail.gmail.com>
From:   "Seija K." <doremylover123@gmail.com>
Date:   Tue, 13 Dec 2022 14:54:57 -0500
Message-ID: <CAA42iKzssPn2DAheYW3dczgj__pAJm1utR7NP1hushLPmrFSTA@mail.gmail.com>
Subject: Re: [PATCH] net: Fix for packets being rejected in the xHCI
 controller's ring buffer
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I did.

On Tue, Dec 13, 2022 at 1:23 PM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Hello Seija,
>
> Il giorno mar 13 dic 2022 alle ore 18:44 Seija K.
> <doremylover123@gmail.com> ha scritto:
> >
> > When a packet larger than MTU arrives in Linux from the modem, it is
> > discarded with -EOVERFLOW error (Babble error).
> >
> > This is seen on USB3.0 and USB2.0 buses.
> >
> > This is because the MRU (Max Receive Size) is not a separate entity
> > from the MTU (Max Transmit Size), and the received packets can be
> > larger than those transmitted.
> >
> > Following the babble error, there was an endless supply of zero-length
> > URBs that were rejected with -EPROTO (increasing the rx input error
> > counter each time).
> >
> > This is only seen on USB3.0. These continue to come ad infinitum until
> > the modem is shut down.
> >
> > There appears to be a bug in the core USB handling code in Linux that
> > doesn't deal with network MTUs smaller than 1500 bytes well.
> >
> > By default, the dev->hard_mtu (the real MTU) is in lockstep with
> > dev->rx_urb_size (essentially an MRU), and the latter is causing
> > trouble.
> >
> > This has nothing to do with the modems; the issue can be reproduced by
> > getting a USB-Ethernet dongle, setting the MTU to 1430, and pinging
> > with size greater than 1406.
> >
> > Signed-off-by: Seija Kijin <doremylover123@gmail.com>
> >
> > Co-Authored-By: TarAldarion <gildeap@tcd.ie>
> > ---
> > drivers/net/usb/qmi_wwan.c | 7 +++++++
> > 1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 554d4e2a84a4..39db53a74b5a 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
> > struct usb_interface *intf)
> > }
> > dev->net->netdev_ops = &qmi_wwan_netdev_ops;
> > dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> > + /* LTE Networks don't always respect their own MTU on the receiving side;
> > + * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> > + * far-end networks. Make the receive buffer large enough to accommodate
> > + * them, and add four bytes so MTU does not equal MRU on network
> > + * with 1500 MTU. Otherwise, usbnet_change_mtu() will change both.
> > + */
> > + dev->rx_urb_size = ETH_DATA_LEN + 4;
>
> Did you test this change with QMAP?
>
> To support qmap dl aggregated blocks qmi_wwan relies on the
> usbnet_change_mtu behavior of changing the rx_urb_size.
>
> Thanks,
> Daniele
>
> > err:
> > return status;
> > }
> > --
> > 2.38.2

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF4A63758F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiKXJvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiKXJvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:51:05 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E041255CD;
        Thu, 24 Nov 2022 01:51:04 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3b1ef5dac4fso10810377b3.5;
        Thu, 24 Nov 2022 01:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8lWiMxDH+iJN1TNL/zdh0bnlmHeCxHbKfTaVfV5w2gE=;
        b=hbWu9HdLp2Soa+boeaEHQzyGMp8td50ZVrHBMN6Q9OA3dnuF/iDpFOJyTc4KURE51F
         R2hFyT8h5k60D0/R53e6doXS6kGfx18Hzr2nmZNipgD135TzYGtWZkNGbXMTG1/gB10s
         Es1EiO3T7WGKn3LyssIR9tMzpmzvkQ/7rezH5IGGF+RKpUC33n85TllrBNO8UgsHVt2u
         BVrh8lspcLn8uIeTu27arFdKT/G5amPwmfJ278c/bs6BTGhvqBDFUMenGZtYDLCAvxdh
         rhDJFnOC4LQ6Mxhalv3M8uvrsWDea3Ywdv/uG9LzHuNFKjaxdaC0oXSRciR3wtUqAmsG
         evJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8lWiMxDH+iJN1TNL/zdh0bnlmHeCxHbKfTaVfV5w2gE=;
        b=ry7fb5/cM3IGhLWC1AX3hgK+YyrPXkKkgTxhDFqn5kxCkzTPN5S4Vq+JR6EmRUMUKP
         n05JqdDGa0ZGvb1edLxwxi2sivYFc90VaSwbTD1bHzHBBGuBiO94NRofyus62RUtfWQ2
         K30mvXXtKKpxrEvh0wPicF/BXqcRyp8MTydvhTB9w6iYAW9NZTs3Sdz0e+FMh73PdS6y
         lNbnYWCjWz36sibv6bm98Lc9w4iOSx7mST9Ynai853P9KVz1Q93lDAFA+fiM00Q5bOCT
         iUsFMezXhdNNuIYvmipHip0QVHWhBvXhvjUHaPpEr9ZuHNl+yWlVb8n6oIjXJSfzve6U
         qkTQ==
X-Gm-Message-State: ANoB5pkIKc3pt5PAVXK3glQlBaiM3E+RyHsP7qLWEvrZxYcrhW+6/RTU
        +7C22WSKOnFIgaMplyz46MOe/OKwzBHGzqmT9+eGDc8i
X-Google-Smtp-Source: AA0mqf5qc0jyGH4t/N1UqJBfKN9JZb6icBgPnbUG1+0s3ZDpzC9w9XhMwyvkq4PCt9bDrMnUdS0H4/9Hr25JKac3bEY=
X-Received: by 2002:a81:a0c4:0:b0:3b0:7636:6019 with SMTP id
 x187-20020a81a0c4000000b003b076366019mr5994903ywg.482.1669283463670; Thu, 24
 Nov 2022 01:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20221123194406.80575-1-yashi@spacecubics.com> <20221123223410.sg2ixkaqg4dpe7ew@pengutronix.de>
In-Reply-To: <20221123223410.sg2ixkaqg4dpe7ew@pengutronix.de>
From:   Yasushi SHOJI <yasushi.shoji@gmail.com>
Date:   Thu, 24 Nov 2022 18:50:52 +0900
Message-ID: <CAELBRWJoQjLD9UaFUmqnFWT9HkPMNb4kKF+1EZwcfrn_WBwBYw@mail.gmail.com>
Subject: Re: [PATCH] can: mcba_usb: Fix termination command argument
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     =?UTF-8?B?UmVtaWdpdXN6IEtvxYLFgsSFdGFq?= 
        <remigiusz.kollataj@mobica.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e1f69005ee3457fc"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e1f69005ee3457fc
Content-Type: text/plain; charset="UTF-8"

Hi,

On Thu, Nov 24, 2022 at 7:34 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> Let's take the original driver author into the loop.
>
> On 24.11.2022 04:44:06, Yasushi SHOJI wrote:
> > Microchip USB Analyzer can be set with termination setting ON or OFF.
> > As I've observed, both with my oscilloscope and USB packet capture
> > below, you must send "0" to turn it ON, and "1" to turn it OFF.
> >
> > Reverse the argument value to fix this.
> >
> > These are the two commands sequence, ON then OFF.
> >
> > > No.     Time           Source                Destination           Protocol Length Info
> > >       1 0.000000       host                  1.3.1                 USB      46     URB_BULK out
> > >
> > > Frame 1: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > > USB URB
> > > Leftover Capture Data: a80000000000000000000000000000000000a8
> > >
> > > No.     Time           Source                Destination           Protocol Length Info
> > >       2 4.372547       host                  1.3.1                 USB      46     URB_BULK out
> > >
> > > Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > > USB URB
> > > Leftover Capture Data: a80100000000000000000000000000000000a9
>
> Is this the USB data after applying the patch?

That's not from Linux.

> Can you measure the resistance between CAN-H and CAN-L to verify that
> your patch fixes the problem?

Sure.  The command I'm using on my Linux is:

    sudo ip link set can0 up type can bitrate 100000 termination X

where X is either 0 or 120.

With Debian Sid stock kernel: linux-image-6.0.0-4-amd64
  - termination 0: 135.4 Ohms
  - termination 120: 17.82 Ohms

With my patch on v6.1-rc6
  - termination 0: 22.20 Ohms
  - termination 120: 134.2 Ohms

> > Signed-off-by: Yasushi SHOJI <yashi@spacecubics.com>
> > ---
> >  drivers/net/can/usb/mcba_usb.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> > index 218b098b261d..67beff1a3876 100644
> > --- a/drivers/net/can/usb/mcba_usb.c
> > +++ b/drivers/net/can/usb/mcba_usb.c
> > @@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
> >       };
> >
> >       if (term == MCBA_TERMINATION_ENABLED)
> > -             usb_msg.termination = 1;
> > -     else
> >               usb_msg.termination = 0;
> > +     else
> > +             usb_msg.termination = 1;
> >
> >       mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
>
> What about the static void mcba_usb_process_ka_usb() function? Do you
> need to convert this, too?

Ah, yes. Thanks.
Attaching a compressed patch.

Let me know if I need to resend it as an email.

Best,
--
          yashi

--000000000000e1f69005ee3457fc
Content-Type: application/gzip; 
	name="0001-can-mcba_usb-Fix-termination-command-argument.patch.gz"
Content-Disposition: attachment; 
	filename="0001-can-mcba_usb-Fix-termination-command-argument.patch.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_lause9ku0>
X-Attachment-Id: f_lause9ku0

H4sICPwkf2MAAzAwMDEtY2FuLW1jYmFfdXNiLUZpeC10ZXJtaW5hdGlvbi1jb21tYW5kLWFyZ3Vt
ZW50LnBhdGNoALVVW3PqNhB+jn7FTh7aELBjG3MJaTKBJMyhzeVM4Dx0Oh2PLK9BPdiilkxCp+e/
d2UgIT3toX3IDoOl1be3T971sFAZiDTBsOkJRK+beCJOW3Hbb6UedsI0bSdB0kqa3BM+3KkcxrgA
vwOe16t+EHiez4bkpgc/c13qmYTxh4cfR/DDitPmUi+4QFHGUmhXqOyCXXODPZjMygYEIdyrJbkI
AvDCnh/0Wk2oe6eex8Zl/BsK04NfPvYnVx9+BcHzHmQi5lGp4x4M5TMYLDKZcyMpLXKd8TwBXkzL
DHPD2J0UhRIzuYBP4wH0cz5f/YGF9QMxgkYDT9LM3jghpZH5FB7uQRXwMBy6rK9h9P0SQcUaiyUm
DYgVWVWm2QqUFnI+p3+1QLDxbSyq+DO5F3xhygJZjHP11ICVKiErtaEohDv0DsEoIEAO0lDERmV+
6L9V2xTYIy6x0Ahmhi/1wZLPS7TY1DIxk5qAkxlqC1lDzZPa0qIp6O8l5gIbtjg6zTe+L+gGXLAy
kRnCq4xVWYhdRSXXqM2WrVf5WCijhJrDLeZTImaUp4o8r8UHz/Uq2Shmikj4Sny36fpfaS2dlYTt
9f5xEA0+3f4EqjTsgmIMC05p+z0LiFcGNVBmT5IoOGq2uxBLo2uN18PNnSQ7p+TERiHPtLrF1Chi
G67WQKC3lfeAd729wrtVQu9NZwCh2+wErbDzfnQG70+nv5fOU8bGcppj4qg0deLVf50vjuMwSApp
e+YkR3NCHX9CM+NkOzxcAX9CG+r1egX1qYPmCGLG86nt7ybInHrd3ok+qtesIsE5rvdOjbFEpik4
zpT6k5/sCRTvATCZJ/gMgd+NvdNuHLT9xHWDjk+DOOQi7jaBiGqHoa1qbzRGJe2PeHkJTthuNjpQ
Xz9IoQ29gwKWSiYvMzZa0PhEraPP1fZIm6IUZn28oBBwbP8bDA4O7MK5sDaETWWhTbTgWsM5pHyu
8YwwXxgw50CmcJTpqXOxM3UjGxxrrP6NUzg/B6/2GorKcncH9zncXQ360eTm8W5035+MHu6jm/v+
4Pbm2sZGyuF/2V6PxhtjS1an22qcQn39eCVL5hsy6KsR7TjcEkX0RwkuJXX9Ma1p2YDSb1cfHFvK
F0qNHrZoq7Il/lsRNaLuwNJL7Pwtd/+MzrYF/jPEOyNuK0j9G15sLi9X/5xJE4ksOaquGN7c/cYD
HNe+2yxr1preTxa4za7rM/YXQAXnF1YIAAA=
--000000000000e1f69005ee3457fc--

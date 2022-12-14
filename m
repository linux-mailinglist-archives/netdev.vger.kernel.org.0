Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9E964CD06
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiLNPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiLNPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:25:14 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F09EAE73;
        Wed, 14 Dec 2022 07:25:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kw15so45303436ejc.10;
        Wed, 14 Dec 2022 07:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pyBUH3WX+Oy1sPUYcOHZQQujYgyDt0tZIAPGgn38vpc=;
        b=j+ECA3ObDcDwKZ/gOsVb6iqxOmK9c6mpjTRYn8FOVx+iVAlCV+OW4eWgiSwyDFfL/d
         Kykb62y2LxaSy24jDd96VaD1OfZgYM3RUnvek60Mcwtws83ya0qExR1LXyWdYvh5xeJC
         o1BFo/vtUXtqvvMkXMnDsUeJSj6AXNgtOMT6QhupxaxvdkMkXaE53F7xZu8ROLEky59A
         w6Cw+alGPhNWOUdEvMP5chTSzc2oQPV+6Ry0uDuLIg9lzHKhc1R5WBDGTIMu4ymNSw7H
         4d8PEsVGfitbyKdyLRtA1Q6gn38CR722NG5b/ctbp60rU2B/ZgOSflKcwNpQEmg9jrhw
         bokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pyBUH3WX+Oy1sPUYcOHZQQujYgyDt0tZIAPGgn38vpc=;
        b=1PQuge9f3ZAxe7PSXyB4u6P+sDrYQK/3PBNuau7qlewiWd9W6wa3OrpSxjh/7dCkHz
         pjkUyOwsQIhyIIGs1A1+EGF9uo8dton4FXHsYbbSMWf+V+QRQAX9TSlXwoVsabwqie7Y
         e4H37oe40YVcVlMCWt9OzipbmIZT4QpvnPSWFkOlR7iew/xR9rYCvqrxZPlusttS6z9h
         e7MA1AN486r3rCrsKlJPDsOWUeX9C40eL24jM0RqkX/qt6Za5lQl+OP2w8vgygZ/qxmj
         6dikiCM2nf32iIk1UFtBnMetAghtYZcaUL5ob+MwC5n30kJwSZy45G/KlyGTNyaQEsKp
         iA8Q==
X-Gm-Message-State: ANoB5plb5CRPxuFVo+OY42JgIxYQEpl1OGkPYHKLUn222Hl12x1D1bbU
        PUtW72a8f7Sj/DG5Lso4C9q9Fkj8/my9hunhM/0=
X-Google-Smtp-Source: AA0mqf7BvOBLnE/e3JdF0ZoLKJyRIBaYiuR33FQeKjpxC/JyHueVYPzmJpbffFlYUxrjFOYCS2qcwLOqdC74OCB369E=
X-Received: by 2002:a17:906:4792:b0:7c1:3e9e:adc0 with SMTP id
 cw18-20020a170906479200b007c13e9eadc0mr1260307ejc.312.1671031511829; Wed, 14
 Dec 2022 07:25:11 -0800 (PST)
MIME-Version: 1.0
References: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
 <CAGRyCJGCrR_FVjCmsnbYhs76bDc0rD83n-=2ros2p9W_GeVq-w@mail.gmail.com> <CAA42iKzssPn2DAheYW3dczgj__pAJm1utR7NP1hushLPmrFSTA@mail.gmail.com>
In-Reply-To: <CAA42iKzssPn2DAheYW3dczgj__pAJm1utR7NP1hushLPmrFSTA@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 14 Dec 2022 16:18:12 +0100
Message-ID: <CAGRyCJGQpdLUzsaqdmbw4E9Sp=im-b6TQFEp1RpG1Wj3x_KVug@mail.gmail.com>
Subject: Re: [PATCH] net: Fix for packets being rejected in the xHCI
 controller's ring buffer
To:     "Seija K." <doremylover123@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Seija,

Il giorno mar 13 dic 2022 alle ore 20:55 Seija K.
<doremylover123@gmail.com> ha scritto:
> On Tue, Dec 13, 2022 at 1:23 PM Daniele Palmas <dnlplm@gmail.com> wrote:
> >
> > Did you test this change with QMAP?
> >
> > To support qmap dl aggregated blocks qmi_wwan relies on the
> > usbnet_change_mtu behavior of changing the rx_urb_size.
> >
> > Thanks,
> > Daniele
>
> Yes, I did.
>

I've applied your change and verified that the rx_urb_size can't be
changed anymore by modifying the mtu of the wwan netdevice and stays
fixed to 1504.

Just a heads-up, that this change is not working fine with qmap setup
procedure, since the URB size can't be changed anymore to the value of
the maximum dl aggregated block set through wda_set_data_format.

I know that linking MTU with the rx_urb_size is odd, but this is how
it's done currently.

Regards,
Daniele

> On Tue, Dec 13, 2022 at 1:23 PM Daniele Palmas <dnlplm@gmail.com> wrote:
> >
> > Hello Seija,
> >
> > Il giorno mar 13 dic 2022 alle ore 18:44 Seija K.
> > <doremylover123@gmail.com> ha scritto:
> > >
> > > When a packet larger than MTU arrives in Linux from the modem, it is
> > > discarded with -EOVERFLOW error (Babble error).
> > >
> > > This is seen on USB3.0 and USB2.0 buses.
> > >
> > > This is because the MRU (Max Receive Size) is not a separate entity
> > > from the MTU (Max Transmit Size), and the received packets can be
> > > larger than those transmitted.
> > >
> > > Following the babble error, there was an endless supply of zero-length
> > > URBs that were rejected with -EPROTO (increasing the rx input error
> > > counter each time).
> > >
> > > This is only seen on USB3.0. These continue to come ad infinitum until
> > > the modem is shut down.
> > >
> > > There appears to be a bug in the core USB handling code in Linux that
> > > doesn't deal with network MTUs smaller than 1500 bytes well.
> > >
> > > By default, the dev->hard_mtu (the real MTU) is in lockstep with
> > > dev->rx_urb_size (essentially an MRU), and the latter is causing
> > > trouble.
> > >
> > > This has nothing to do with the modems; the issue can be reproduced by
> > > getting a USB-Ethernet dongle, setting the MTU to 1430, and pinging
> > > with size greater than 1406.
> > >
> > > Signed-off-by: Seija Kijin <doremylover123@gmail.com>
> > >
> > > Co-Authored-By: TarAldarion <gildeap@tcd.ie>
> > > ---
> > > drivers/net/usb/qmi_wwan.c | 7 +++++++
> > > 1 file changed, 7 insertions(+)
> > >
> > > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > > index 554d4e2a84a4..39db53a74b5a 100644
> > > --- a/drivers/net/usb/qmi_wwan.c
> > > +++ b/drivers/net/usb/qmi_wwan.c
> > > @@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
> > > struct usb_interface *intf)
> > > }
> > > dev->net->netdev_ops = &qmi_wwan_netdev_ops;
> > > dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> > > + /* LTE Networks don't always respect their own MTU on the receiving side;
> > > + * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> > > + * far-end networks. Make the receive buffer large enough to accommodate
> > > + * them, and add four bytes so MTU does not equal MRU on network
> > > + * with 1500 MTU. Otherwise, usbnet_change_mtu() will change both.
> > > + */
> > > + dev->rx_urb_size = ETH_DATA_LEN + 4;
> >
> > Did you test this change with QMAP?
> >
> > To support qmap dl aggregated blocks qmi_wwan relies on the
> > usbnet_change_mtu behavior of changing the rx_urb_size.
> >
> > Thanks,
> > Daniele
> >
> > > err:
> > > return status;
> > > }
> > > --
> > > 2.38.2

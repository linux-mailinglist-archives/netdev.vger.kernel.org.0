Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2969D64D1E3
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 22:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLNVkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 16:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLNVkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 16:40:11 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777623D92F;
        Wed, 14 Dec 2022 13:40:07 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id j4so12735278lfk.0;
        Wed, 14 Dec 2022 13:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3jT8BbEnTMk4PvBeviyKw2FcYCYOfLeszTEBNvSB5Oo=;
        b=YaSXoKz3u/5HGMhU88zPl4NQgxVNjpIjM+WeKSNkZ/UrWgPauK3YyuOlu0RckPaFVe
         mFZccA/HUjQHaQd6JnPV5CvjrDK5PHvJck3kd1EQZkVTBaxrfoaAYOmbVB8W88NQqZkk
         j/Sir9JwwherHi9gjNtcUTvlnpEer1Td/C/pIbklsXE8SKjd7G1FYmL67uFCPwojI/Gu
         QLCP7lUDLrVBFXqxkGa6NpYnVAVI9KmnZAnkhBYK1zzVId3SXtp7E6n3knCzvtsFjNu1
         ZmhUL3LvZJlg4k4G6mpDjWB+pAMda0TaOBkdN1Yg24cp0j1Vm8nKSP1KsHWweye4fjUf
         8k0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jT8BbEnTMk4PvBeviyKw2FcYCYOfLeszTEBNvSB5Oo=;
        b=wToiWjsyeUoATfQCZJNHqhUkkGhIvtxPLNUhSsHhk1SBhtZ16GKnx98jU61HjIUMIe
         USz4/QlkG3gFuveY9hmZC+rLK6IfRLa2/402VcCpD5Ytsstd8BxlF9q+JngbUjJTKki4
         1wn/pvhcQdgeu8gERBdZDKAW9itkvfvCgvGXcy9oHInkQsd9cNMrJsLOu8Qx2JbjZzOJ
         tVESgEh7szU6TJ22snECOYrHAhNHXagiqJz95HTgt3TdkKA/89QyJxKoZsdQifH4kIPH
         KgRUkyNY+Gj33G0oduGFj1pS/Q+oCZrhAX2YiI/4APJaywMY96fToHr7ip9HBG5zzgOJ
         IaxQ==
X-Gm-Message-State: ANoB5plODRqXvpwI21MGemgSj/8jZ6ulNr0d9ER7F+B7bxiqc/y0Si9z
        X4+oSnBEsilc9DmblY/qOMPRU9jF7PiRJjbLcPbs/lWySm5z
X-Google-Smtp-Source: AA0mqf7JLxK2GaGobI65rgXEaQiHalaqMzK4Q3PyQi5VUYps2e/bZg/o9fLO2ag1Xx+ibtfmjao3pxbpbUWeQseafFQ=
X-Received: by 2002:a05:6512:324d:b0:4a2:4d28:73b9 with SMTP id
 c13-20020a056512324d00b004a24d2873b9mr36407500lfr.690.1671054005708; Wed, 14
 Dec 2022 13:40:05 -0800 (PST)
MIME-Version: 1.0
References: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
 <CAGRyCJGCrR_FVjCmsnbYhs76bDc0rD83n-=2ros2p9W_GeVq-w@mail.gmail.com>
 <CAA42iKzssPn2DAheYW3dczgj__pAJm1utR7NP1hushLPmrFSTA@mail.gmail.com> <CAGRyCJGQpdLUzsaqdmbw4E9Sp=im-b6TQFEp1RpG1Wj3x_KVug@mail.gmail.com>
In-Reply-To: <CAGRyCJGQpdLUzsaqdmbw4E9Sp=im-b6TQFEp1RpG1Wj3x_KVug@mail.gmail.com>
From:   "Seija K." <doremylover123@gmail.com>
Date:   Wed, 14 Dec 2022 16:39:54 -0500
Message-ID: <CAA42iKzrf_CT9Mc3PTxU7WPnpKxNNjZejzh_n8espFxD=yYa1w@mail.gmail.com>
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

Ok, thanks.

On Wed, Dec 14, 2022 at 10:25 AM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Hello Seija,
>
> Il giorno mar 13 dic 2022 alle ore 20:55 Seija K.
> <doremylover123@gmail.com> ha scritto:
> > On Tue, Dec 13, 2022 at 1:23 PM Daniele Palmas <dnlplm@gmail.com> wrote:
> > >
> > > Did you test this change with QMAP?
> > >
> > > To support qmap dl aggregated blocks qmi_wwan relies on the
> > > usbnet_change_mtu behavior of changing the rx_urb_size.
> > >
> > > Thanks,
> > > Daniele
> >
> > Yes, I did.
> >
>
> I've applied your change and verified that the rx_urb_size can't be
> changed anymore by modifying the mtu of the wwan netdevice and stays
> fixed to 1504.
>
> Just a heads-up, that this change is not working fine with qmap setup
> procedure, since the URB size can't be changed anymore to the value of
> the maximum dl aggregated block set through wda_set_data_format.
>
> I know that linking MTU with the rx_urb_size is odd, but this is how
> it's done currently.
>
> Regards,
> Daniele
>
> > On Tue, Dec 13, 2022 at 1:23 PM Daniele Palmas <dnlplm@gmail.com> wrote:
> > >
> > > Hello Seija,
> > >
> > > Il giorno mar 13 dic 2022 alle ore 18:44 Seija K.
> > > <doremylover123@gmail.com> ha scritto:
> > > >
> > > > When a packet larger than MTU arrives in Linux from the modem, it is
> > > > discarded with -EOVERFLOW error (Babble error).
> > > >
> > > > This is seen on USB3.0 and USB2.0 buses.
> > > >
> > > > This is because the MRU (Max Receive Size) is not a separate entity
> > > > from the MTU (Max Transmit Size), and the received packets can be
> > > > larger than those transmitted.
> > > >
> > > > Following the babble error, there was an endless supply of zero-length
> > > > URBs that were rejected with -EPROTO (increasing the rx input error
> > > > counter each time).
> > > >
> > > > This is only seen on USB3.0. These continue to come ad infinitum until
> > > > the modem is shut down.
> > > >
> > > > There appears to be a bug in the core USB handling code in Linux that
> > > > doesn't deal with network MTUs smaller than 1500 bytes well.
> > > >
> > > > By default, the dev->hard_mtu (the real MTU) is in lockstep with
> > > > dev->rx_urb_size (essentially an MRU), and the latter is causing
> > > > trouble.
> > > >
> > > > This has nothing to do with the modems; the issue can be reproduced by
> > > > getting a USB-Ethernet dongle, setting the MTU to 1430, and pinging
> > > > with size greater than 1406.
> > > >
> > > > Signed-off-by: Seija Kijin <doremylover123@gmail.com>
> > > >
> > > > Co-Authored-By: TarAldarion <gildeap@tcd.ie>
> > > > ---
> > > > drivers/net/usb/qmi_wwan.c | 7 +++++++
> > > > 1 file changed, 7 insertions(+)
> > > >
> > > > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > > > index 554d4e2a84a4..39db53a74b5a 100644
> > > > --- a/drivers/net/usb/qmi_wwan.c
> > > > +++ b/drivers/net/usb/qmi_wwan.c
> > > > @@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
> > > > struct usb_interface *intf)
> > > > }
> > > > dev->net->netdev_ops = &qmi_wwan_netdev_ops;
> > > > dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> > > > + /* LTE Networks don't always respect their own MTU on the receiving side;
> > > > + * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> > > > + * far-end networks. Make the receive buffer large enough to accommodate
> > > > + * them, and add four bytes so MTU does not equal MRU on network
> > > > + * with 1500 MTU. Otherwise, usbnet_change_mtu() will change both.
> > > > + */
> > > > + dev->rx_urb_size = ETH_DATA_LEN + 4;
> > >
> > > Did you test this change with QMAP?
> > >
> > > To support qmap dl aggregated blocks qmi_wwan relies on the
> > > usbnet_change_mtu behavior of changing the rx_urb_size.
> > >
> > > Thanks,
> > > Daniele
> > >
> > > > err:
> > > > return status;
> > > > }
> > > > --
> > > > 2.38.2

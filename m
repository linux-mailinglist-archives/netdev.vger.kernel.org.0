Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7562D591255
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiHLOfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 10:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238721AbiHLOft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 10:35:49 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744B3140EA;
        Fri, 12 Aug 2022 07:35:42 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-32868f43dd6so11733047b3.8;
        Fri, 12 Aug 2022 07:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=0kYVR6+4stXD5NihgEx+W2epkSuTWN7LouiH1TqpvX0=;
        b=FmRorQHDVf1T98DWjzluH6ubmJDtgVMRVvHHTH0SPqfy3BlLjX50vN725uvotnpuMS
         CyT32brlO4rCj0xoOC6tsgK7cC05RW4YdWzOtnb8Xd03UqVJlJk0ZQyziFZpjluVRCW9
         NwsvZSpw/x6wDMCCUCPUb7FY/2QCAWRxlE6gQuLXrUv6q1ouq+t/6fHbVPZQfIkHI1KS
         S7HWLSWjiGfc6w+EmnK0hIRu0awNBjn5AkofMptYU+xXwu/HykNi5mSNB7GsiaXhFPbT
         DjNsjCxbhIyctRUbaFpj7lQvTa1K7LabPfMaqnGZsniJ3IuCcfBXu/ET6QMYynRk1BEN
         NUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=0kYVR6+4stXD5NihgEx+W2epkSuTWN7LouiH1TqpvX0=;
        b=vgSLDoOgSExbqqUaepK6jINnyq9BhVA9nI0sOffvG/UVSr1DTtWRXeAMMn9z5DpmH/
         PlLJC5GSjHJpd1gK7E/iHJLkBuO60G/6yKB7dBj8BnrWNePRd+/EhZASo88nQlrG/9nJ
         ZaNTRzDW4KQjzTwUUbWtZ4jv7GF15UJZGgBMxroKQNpkGpx8TmwGbXwjOeZJ0ZqegH7r
         zNQa/TMfYV/piE4q+oK36dhAtYMlBPYf4APhg2YbjSu+jr1sQGbk+YqkYbCRYiTAXJh2
         wq0HksSDT3rapF+0JThmupPw94nmnzmakuw2guI9kjidxa53WjscMeo1Pjxo1bE1vtnz
         zRxw==
X-Gm-Message-State: ACgBeo0lMkHaBmRomhfJE6REU7zNkfI0sBho/Ie+uhx6BiHB+S7RQpDV
        G1n8jUnb0a2Czcad8DidSGYC6cRwg+Lp2oS3+HKCDeRkb7MyXAsW
X-Google-Smtp-Source: AA6agR7IcdrS9YgyMZ9ln2GufdnuxYTcL6g2sheNQdVhkt/8poOygwK2BqVV6B8qXsvSUchsWSr46tLkGHQCGopaKB0=
X-Received: by 2002:a0d:e682:0:b0:322:b5e1:5ed4 with SMTP id
 p124-20020a0de682000000b00322b5e15ed4mr4067254ywe.220.1660314942036; Fri, 12
 Aug 2022 07:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz> <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
 <202208020937.54675.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202208020937.54675.pisa@cmp.felk.cvut.cz>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Fri, 12 Aug 2022 23:35:30 +0900
Message-ID: <CAMZ6Rq+EehdX8Kkg_430tzbE072Fm0PXbzgSqBzeDygTZqzBLA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Jiri Novak <jnovak@fel.cvut.cz>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

On Tue. 2 Aug. 2022 at 16:38, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> Hello Vincent,
>
> thanks much for review. I am adding some notices to Tx timestamps
> after your comments
>
> On Tuesday 02 of August 2022 05:43:38 Vincent Mailhol wrote:
> > I just send a series last week which a significant amount of changes
> > for CAN timestamping tree-wide:
> > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/=
comm
> >it/?id=3D12a18d79dc14c80b358dbd26461614b97f2ea4a6
> >
> > I suggest you have a look at this series and harmonize it with the new
> > features (e.g. Hardware TX=E2=80=AFtimestamp).
> >
> > On Tue. 2 Aug. 2022 at 03:52, Matej Vasilevski
> ...
> > > +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq
> > > *ifr) +{
> > > +       struct ctucan_priv *priv =3D netdev_priv(dev);
> > > +       struct hwtstamp_config cfg;
> > > +
> > > +       if (!priv->timestamp_possible)
> > > +               return -EOPNOTSUPP;
> > > +
> > > +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > > +               return -EFAULT;
> > > +
> > > +       if (cfg.flags)
> > > +               return -EINVAL;
> > > +
> > > +       if (cfg.tx_type !=3D HWTSTAMP_TX_OFF)
> > > +               return -ERANGE;
> >
> > I have a great news: your driver now also support hardware TX timestamp=
s:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/=
comm
> >it/?id=3D8bdd1112edcd3edce2843e03826204a84a61042d
> >
> > > +
> > > +       switch (cfg.rx_filter) {
> > > +       case HWTSTAMP_FILTER_NONE:
> > > +               priv->timestamp_enabled =3D false;
> ...
> > > +
> > > +       cfg.flags =3D 0;
> > > +       cfg.tx_type =3D HWTSTAMP_TX_OFF;
> >
> > Hardware TX timestamps are now supported (c.f. supra).
> >
> > > +       cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILTER_A=
LL :
> > > HWTSTAMP_FILTER_NONE; +       return copy_to_user(ifr->ifr_data, &cfg=
,
> > > sizeof(cfg)) ? -EFAULT : 0; +}
> > > +
> > > +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, i=
nt
> > > cmd)
> >
> > Please consider using the generic function can_eth_ioctl_hwts()
> > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/=
comm
> >it/?id=3D90f942c5a6d775bad1be33ba214755314105da4a
> >
> > > +{
> ...
> > > +       info->so_timestamping |=3D SOF_TIMESTAMPING_RX_HARDWARE |
> > > +                                SOF_TIMESTAMPING_RAW_HARDWARE;
> > > +       info->tx_types =3D BIT(HWTSTAMP_TX_OFF);
> >
> > Hardware TX timestamps are now supported (c.f. supra).
> >
> > > +       info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> > > +                          BIT(HWTSTAMP_FILTER_ALL);
>
>
> I am not sure if it is good idea to report support for hardware
> TX timestamps by all drivers. Precise hardware Tx timestamps
> are important for some CAN applications but they require to be
> exactly/properly aligned with Rx timestamps.
>
> Only some CAN (FD) controllers really support that feature.
> For M-CAN and some others it is realized as another event
> FIFO in addition to Tx and Rx FIFOs.
>
> For CTU CAN FD, we have decided that we do not complicate design
> and driver by separate events channel. We have configurable
> and possibly large Rx FIFO depth which is logical to use for
> analyzer mode and we can use loopback to receive own messages
> timestamped same way as external received ones.
>
> See 2.14.1 Loopback mode
> SETTINGS[ILBP]=3D1.
>
> in the datasheet
>
>   http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf
>
> There is still missing information which frames are received
> locally and from which buffer they are in the Rx message format,
> but we plan to add that into VHDL design.
>
> In such case, we can switch driver mode and release Tx buffers
> only after corresponding message is read from Rx FIFO and
> fill exact finegrain (10 ns in our current design) timestamps
> to the echo skb. The order of received messages will be seen
> exactly mathing the wire order for both transmitted and received
> messages then. Which I consider as proper solution for the
> most applications including CAN bus analyzers.
>
> So I consider to report HW Tx timestamps for cases where exact,
> precise timestamping is not available for loopback messages
> as problematic because you cannot distinguish if you talk
> with driver and HW with real/precise timestamps support
> or only dummy implementation to make some tools happy.

Thank you for the explanation. I did not know about the nuance about
those different hardware timestamps.

So if I understand correctly, your hardware can deliver two types of
hardware timestamps:

  - The "real" one: fine grained with 10 ns precision when the frame
is actually sent

  - The "dummy" one: less precise timestamp generated when there is an
event on the device=E2=80=99s Rx or Tx FIFO.

Is this correct?

Are the "real" and the "dummy" timestamps synced on the same quartz?

What is the precision of the "dummy" timestamp? If it in the order of
magnitude of 10=C2=B5s? For many use cases, this is enough. 10=C2=B5s repre=
sents
roughly a dozen of time quata (more or less depending on the bitrate
and its prescaler).
Actually, I never saw hardware with a timestamp precision below 1=C2=B5s
(not saying those don't exist, just that I never encountered them).

I am not against what you propose. But my suggestion would be rather
to report both TX=E2=80=AFand RX timestamps and just document the precision
(i.e. TX has precision with an order of magnitude of 10=C2=B5s and RX has
precision of 10 ns).

At the end, I=E2=80=AFlet you decide what works the best for you. Just keep=
 in
mind that the micro second precision is already a great achievement
and not many people need the 10 nano second (especially for CAN).

P.S.: I am on holiday, my answers might be delayed :)


Yours sincerely,
Vincent Mailhol

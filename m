Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898A75A3207
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 00:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbiHZW0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 18:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiHZW0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 18:26:38 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEE46170B;
        Fri, 26 Aug 2022 15:26:36 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3378303138bso69547997b3.9;
        Fri, 26 Aug 2022 15:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=G/8P+IWXxtB4UDVUT1QFPBKI0gJOqLoj4OBu9WN5bXw=;
        b=THvI2OAx7z5XK2a9LCPFKGH6+tJBUXCVjm1ZodqpS0Elw+w0KQISJ2RH7rVEa+N3vN
         62dCem55voxlrjE4RQpNRYk1y0+hg/Ly8Rk+RcgTh0B0SU1dcz3+sT/xJTDr7OL8YBYh
         /vAL0FX2WAR7RI1tN/2RmISRUpvpE8gvJXUR+DEzB+0NCJT85JX65vizO33QQSGuzLDo
         B0FvIVtxEUYQWcnffeIqsmOIMDItVPfPbJ54mNAN+sIt6XY6P5vUxvoBzO2NvOV1oFmD
         uTDCVjsy/9521iprpsjLt72mSNnce95Ry7IjwxPLOECQFRFMklLjHFXL4XbLU2BPRxDw
         Oxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=G/8P+IWXxtB4UDVUT1QFPBKI0gJOqLoj4OBu9WN5bXw=;
        b=Jqz1kIQERb5QuIbClcYc5g9Sh3Yu32UANJpgZGSM4HnSUoyg76DQkx5lxXzb8X1iiu
         oiDTB4NoVrMTHHqzcPyNTJ1EolwCzU+JRRs9WwNh3U+ZfgawkOUSBsHct0X9FxxxCFzJ
         cTDZlnwqcgfFq8ufUdweqjRB0mxf/GjED66FITISaZUGA3bUrD9SxNRpxdhTkd6ykuu/
         tRQwmHRowqn/KaXeEtg2ZNYmI+JypBcqIF1jSjZmUWyIb42/nDzjfvEv8uq+hsCA7gg/
         /WZLrJ/6b5niYUReC7AT+ns+S6qZshwIDkFjxe6g78AZ/yAm2E+OowyFVtG83hVYHT9P
         Lr5g==
X-Gm-Message-State: ACgBeo0yuQu+de6gPuErrgmf5+LVEKeEZ83GMYNTfzD/2saS4Rtfal3V
        cHwk4bbOLjA3sQSWn76qZyZH8Uqgs9/iBh0nCXvsYgccRYlVKQ==
X-Google-Smtp-Source: AA6agR4ThogskA8LGXVg9c+JpHGk6sgHyzYoLjQCOp9BqKtTKTYK5H4YtFvD1sy2v/qWgKu+P4RwRvtu8qXEnIbwUxo=
X-Received: by 2002:a0d:f144:0:b0:33d:a554:b9b6 with SMTP id
 a65-20020a0df144000000b0033da554b9b6mr1971328ywf.172.1661552795513; Fri, 26
 Aug 2022 15:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <202208020937.54675.pisa@cmp.felk.cvut.cz> <CAMZ6Rq+EehdX8Kkg_430tzbE072Fm0PXbzgSqBzeDygTZqzBLA@mail.gmail.com>
 <202208121719.58328.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202208121719.58328.pisa@cmp.felk.cvut.cz>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sat, 27 Aug 2022 07:26:23 +0900
Message-ID: <CAMZ6Rq+VOjmkzi9aB_2Lo3C0qXfX7sKDi2hViDBoCuHTZYpKYQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Pavel Hronek <hronepa1@fel.cvut.cz>,
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

On Mon. 13 Aug. 2022 at 00:20, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> Hello Vincent,
>
> On Friday 12 of August 2022 16:35:30 Vincent Mailhol wrote:
> > Hi Pavel,
> >
> > On Tue. 2 Aug. 2022 at 16:38, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> > > Hello Vincent,
> > >
> > > thanks much for review. I am adding some notices to Tx timestamps
> > > after your comments
> > >
> > > On Tuesday 02 of August 2022 05:43:38 Vincent Mailhol wrote:
> > > > I just send a series last week which a significant amount of change=
s
> > > > for CAN timestamping tree-wide:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.=
git/
> > > >comm it/?id=3D12a18d79dc14c80b358dbd26461614b97f2ea4a6
> > > >
> > > > I suggest you have a look at this series and harmonize it with the =
new
> > > > features (e.g. Hardware TX=E2=80=AFtimestamp).
> > > >
> > > > On Tue. 2 Aug. 2022 at 03:52, Matej Vasilevski
> > >
> > > ...
> > >
> > > > > +static int ctucan_hwtstamp_set(struct net_device *dev, struct if=
req
> > > > > *ifr) +{
> > > > > +       struct ctucan_priv *priv =3D netdev_priv(dev);
> > > > > +       struct hwtstamp_config cfg;
> > > > > +
> > > > > +       if (!priv->timestamp_possible)
> > > > > +               return -EOPNOTSUPP;
> > > > > +
> > > > > +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > > > > +               return -EFAULT;
> > > > > +
> > > > > +       if (cfg.flags)
> > > > > +               return -EINVAL;
> > > > > +
> > > > > +       if (cfg.tx_type !=3D HWTSTAMP_TX_OFF)
> > > > > +               return -ERANGE;
> > > >
> > > > I have a great news: your driver now also support hardware TX
> > > > timestamps:
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.=
git/
> > > >comm it/?id=3D8bdd1112edcd3edce2843e03826204a84a61042d
> > > >
> > > > > +
> > > > > +       switch (cfg.rx_filter) {
> > > > > +       case HWTSTAMP_FILTER_NONE:
> > > > > +               priv->timestamp_enabled =3D false;
> > >
> > > ...
> > >
> > > > > +
> > > > > +       cfg.flags =3D 0;
> > > > > +       cfg.tx_type =3D HWTSTAMP_TX_OFF;
> > > >
> > > > Hardware TX timestamps are now supported (c.f. supra).
> > > >
> > > > > +       cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILT=
ER_ALL
> > > > > : HWTSTAMP_FILTER_NONE; +       return copy_to_user(ifr->ifr_data=
,
> > > > > &cfg, sizeof(cfg)) ? -EFAULT : 0; +}
> > > > > +
> > > > > +static int ctucan_ioctl(struct net_device *dev, struct ifreq *if=
r,
> > > > > int cmd)
> > > >
> > > > Please consider using the generic function can_eth_ioctl_hwts()
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.=
git/
> > > >comm it/?id=3D90f942c5a6d775bad1be33ba214755314105da4a
> > > >
> > > > > +{
> > >
> > > ...
> > >
> > > > > +       info->so_timestamping |=3D SOF_TIMESTAMPING_RX_HARDWARE |
> > > > > +                                SOF_TIMESTAMPING_RAW_HARDWARE;
> > > > > +       info->tx_types =3D BIT(HWTSTAMP_TX_OFF);
> > > >
> > > > Hardware TX timestamps are now supported (c.f. supra).
> > > >
> > > > > +       info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> > > > > +                          BIT(HWTSTAMP_FILTER_ALL);
> > >
> > > I am not sure if it is good idea to report support for hardware
> > > TX timestamps by all drivers. Precise hardware Tx timestamps
> > > are important for some CAN applications but they require to be
> > > exactly/properly aligned with Rx timestamps.
> > >
> > > Only some CAN (FD) controllers really support that feature.
> > > For M-CAN and some others it is realized as another event
> > > FIFO in addition to Tx and Rx FIFOs.
> > >
> > > For CTU CAN FD, we have decided that we do not complicate design
> > > and driver by separate events channel. We have configurable
> > > and possibly large Rx FIFO depth which is logical to use for
> > > analyzer mode and we can use loopback to receive own messages
> > > timestamped same way as external received ones.
> > >
> > > See 2.14.1 Loopback mode
> > > SETTINGS[ILBP]=3D1.
> > >
> > > in the datasheet
> > >
> > >   http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf
> > >
> > > There is still missing information which frames are received
> > > locally and from which buffer they are in the Rx message format,
> > > but we plan to add that into VHDL design.
> > >
> > > In such case, we can switch driver mode and release Tx buffers
> > > only after corresponding message is read from Rx FIFO and
> > > fill exact finegrain (10 ns in our current design) timestamps
> > > to the echo skb. The order of received messages will be seen
> > > exactly mathing the wire order for both transmitted and received
> > > messages then. Which I consider as proper solution for the
> > > most applications including CAN bus analyzers.
> > >
> > > So I consider to report HW Tx timestamps for cases where exact,
> > > precise timestamping is not available for loopback messages
> > > as problematic because you cannot distinguish if you talk
> > > with driver and HW with real/precise timestamps support
> > > or only dummy implementation to make some tools happy.
> >
> > Thank you for the explanation. I did not know about the nuance about
> > those different hardware timestamps.
> >
> > So if I understand correctly, your hardware can deliver two types of
> > hardware timestamps:
> >
> >   - The "real" one: fine grained with 10 ns precision when the frame
> > is actually sent
> >
> >   - The "dummy" one: less precise timestamp generated when there is an
> > event on the device=E2=80=99s Rx or Tx FIFO.
> >
> > Is this correct?
> >
> > Are the "real" and the "dummy" timestamps synced on the same quartz?
> >
> > What is the precision of the "dummy" timestamp? If it in the order of
> > magnitude of 10=C2=B5s? For many use cases, this is enough. 10=C2=B5s r=
epresents
> > roughly a dozen of time quata (more or less depending on the bitrate
> > and its prescaler).
> > Actually, I never saw hardware with a timestamp precision below 1=C2=B5=
s
> > (not saying those don't exist, just that I never encountered them).
> >
> > I am not against what you propose. But my suggestion would be rather
> > to report both TX=E2=80=AFand RX timestamps and just document the preci=
sion
> > (i.e. TX has precision with an order of magnitude of 10=C2=B5s and RX h=
as
> > precision of 10 ns).
> >
> > At the end, I=E2=80=AFlet you decide what works the best for you. Just =
keep in
> > mind that the micro second precision is already a great achievement
> > and not many people need the 10 nano second (especially for CAN).
> >
> > P.S.: I am on holiday, my answers might be delayed :)
>
> I am leaving off the Internet for next week as well now...
>
> My discussion has been reaction to your information about your
> CTU CAN FD change, but may it be I have lost the track.
>
> > > On Tuesday 02 of August 2022 05:43:38 Vincent Mailhol wrote:
> > > > I have a great news: your driver now also support hardware TX
> > > > timestamps:
>
> Our actual/mainline driver actually does not support neither Rx nor Tx
> timestamps. Matej Vasilevski has prepared and sent to review patches
> adding Rx timestamping (10 ns resolution for our actual designs).
> He has rebased his changes above yours... CTU CAN FD hardware
> supports such timestamping for many years... probably preceding 2.0
> IP core version.
>
> But even when this patch is clean up and accepted into mainline,
> CTU CAN FD driver will not support hardware Tx timestams, may it
> be software ones are implemented in generic CAN echo code, not checked
> now... So if your change add report of HW Tx stamps then it would be
> problem to distinguish situation when we implement hardware Tx timestamps=
.
>
> The rest of the previous text is how to implement precise Tx timestamps
> on other and our controller design. We do not have separate queue
> to report Tx timestamps for successfully sent frames. But we can
> enable copy of sent Tx frames to Rx FIFO so there is a way how
> to achieve that. But there is still minor design detail that
> we need to mark such frames as echo of local Tx in Rx FIFO queue
> and ideally add there even number of the Tx buffer or even some
> user provided information from some Tx buffer filed to distinguish
> that such frames should be reported through echo and ensure that
> they are not reported to that client who has sent them etc...
> But there are our implementation details...
>
> But what worries me, is your statement that HW Tx timestamps
> are already reported as available on CTU CAN FD by your patch,
> if I understood your reply well.

I read again the full exchange, and you were right from the beginning.
Please forget my comments on the hardware TX timestamps, I just
misread you.


Yours sincerely,
Vincent Mailhol

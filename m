Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE84F645B32
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiLGNpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLGNpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:45:05 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C5B42F56;
        Wed,  7 Dec 2022 05:45:03 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4D17820003;
        Wed,  7 Dec 2022 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670420700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnvkfWC2Exy39RJs170LBMmHp2JN0qbJhnwjtS/V4Cc=;
        b=dV74tlF10LFmiRh46NSGfdQklmp8ulT0nHKlEO48S/C07GnkRLC6OUYcJh2Ha0T//S0UBk
        mHZkS/TtIpWoonIdePC4FGPb9vtlEkLlbPz4jFCzxM/6PdD9hGPD/VpyE+xH7FNuUK3Y7z
        GUZkt09UAKBhurzFZBw5OVpq2tJO4mihQdhzT4zU3Ckq+jbGIzLJj+7/eoUjXr2t0t7Uel
        1mc4Sz3lvCdLzjwKHd3DZkBYBu+YIr1kZ11pbNg69EOquI9rbOFz5exp9oPZaKe1F4/UB1
        zxdRi6ZQx6uY+6bdyUwcYohNSXUSYI8OKv9WB5XmP60/MC093ttj93H4w/fzSg==
Date:   Wed, 7 Dec 2022 14:44:57 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20221207144457.3033270f@xps-13>
In-Reply-To: <CAK-6q+hMDMGqpNzStXu+tpGgwn13mYqRgAKUJQXdA3eWi-rsGQ@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+hjXKmOrf-p=hRzuD=4pOJeWNUu46iU8YAVL4BqWC437A@mail.gmail.com>
        <20221205105752.6ce87721@xps-13>
        <CAK-6q+hMDMGqpNzStXu+tpGgwn13mYqRgAKUJQXdA3eWi-rsGQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 7 Dec 2022 08:27:35 -0500:

> Hi,
>=20
> On Mon, Dec 5, 2022 at 4:58 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sun, 4 Dec 2022 17:44:24 -0500:
> > =20
> > > Hi,
> > >
> > > On Tue, Nov 29, 2022 at 11:02 AM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote: =20
> > > >
> > > > The ieee802154 layer should be able to scan a set of channels in or=
der
> > > > to look for beacons advertizing PANs. Supporting this involves addi=
ng
> > > > two user commands: triggering scans and aborting scans. The user sh=
ould
> > > > also be notified when a new beacon is received and also upon scan
> > > > termination.
> > > >
> > > > A scan request structure is created to list the requirements and to=
 be
> > > > accessed asynchronously when changing channels or receiving beacons.
> > > >
> > > > Mac layers may now implement the ->trigger_scan() and ->abort_scan()
> > > > hooks.
> > > >
> > > > Co-developed-by: David Girault <david.girault@qorvo.com>
> > > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/linux/ieee802154.h |   3 +
> > > >  include/net/cfg802154.h    |  25 +++++
> > > >  include/net/nl802154.h     |  49 +++++++++
> > > >  net/ieee802154/nl802154.c  | 215 +++++++++++++++++++++++++++++++++=
++++
> > > >  net/ieee802154/nl802154.h  |   3 +
> > > >  net/ieee802154/rdev-ops.h  |  28 +++++
> > > >  net/ieee802154/trace.h     |  40 +++++++
> > > >  7 files changed, 363 insertions(+)
> > > >
> > > > diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
> > > > index 0303eb84d596..b22e4147d334 100644
> > > > --- a/include/linux/ieee802154.h
> > > > +++ b/include/linux/ieee802154.h
> > > > @@ -44,6 +44,9 @@
> > > >  #define IEEE802154_SHORT_ADDR_LEN      2
> > > >  #define IEEE802154_PAN_ID_LEN          2
> > > >
> > > > +/* Duration in superframe order */
> > > > +#define IEEE802154_MAX_SCAN_DURATION   14
> > > > +#define IEEE802154_ACTIVE_SCAN_DURATION        15
> > > >  #define IEEE802154_LIFS_PERIOD         40
> > > >  #define IEEE802154_SIFS_PERIOD         12
> > > >  #define IEEE802154_MAX_SIFS_FRAME_SIZE 18
> > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > index d09c393d229f..76d4f95e9974 100644
> > > > --- a/include/net/cfg802154.h
> > > > +++ b/include/net/cfg802154.h
> > > > @@ -18,6 +18,7 @@
> > > >
> > > >  struct wpan_phy;
> > > >  struct wpan_phy_cca;
> > > > +struct cfg802154_scan_request;
> > > >
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > >  struct ieee802154_llsec_device_key;
> > > > @@ -67,6 +68,10 @@ struct cfg802154_ops {
> > > >                                 struct wpan_dev *wpan_dev, bool mod=
e);
> > > >         int     (*set_ackreq_default)(struct wpan_phy *wpan_phy,
> > > >                                       struct wpan_dev *wpan_dev, bo=
ol ackreq);
> > > > +       int     (*trigger_scan)(struct wpan_phy *wpan_phy,
> > > > +                               struct cfg802154_scan_request *requ=
est);
> > > > +       int     (*abort_scan)(struct wpan_phy *wpan_phy,
> > > > +                             struct wpan_dev *wpan_dev);
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > >         void    (*get_llsec_table)(struct wpan_phy *wpan_phy,
> > > >                                    struct wpan_dev *wpan_dev,
> > > > @@ -278,6 +283,26 @@ struct ieee802154_coord_desc {
> > > >         bool gts_permit;
> > > >  };
> > > >
> > > > +/**
> > > > + * struct cfg802154_scan_request - Scan request
> > > > + *
> > > > + * @type: type of scan to be performed
> > > > + * @page: page on which to perform the scan
> > > > + * @channels: channels in te %page to be scanned
> > > > + * @duration: time spent on each channel, calculated with:
> > > > + *            aBaseSuperframeDuration * (2 ^ duration + 1)
> > > > + * @wpan_dev: the wpan device on which to perform the scan
> > > > + * @wpan_phy: the wpan phy on which to perform the scan
> > > > + */
> > > > +struct cfg802154_scan_request {
> > > > +       enum nl802154_scan_types type;
> > > > +       u8 page;
> > > > +       u32 channels;
> > > > +       u8 duration;
> > > > +       struct wpan_dev *wpan_dev;
> > > > +       struct wpan_phy *wpan_phy;
> > > > +};
> > > > +
> > > >  struct ieee802154_llsec_key_id {
> > > >         u8 mode;
> > > >         u8 id;
> > > > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > > > index b79a89d5207c..79fbd820b25a 100644
> > > > --- a/include/net/nl802154.h
> > > > +++ b/include/net/nl802154.h
> > > > @@ -73,6 +73,9 @@ enum nl802154_commands {
> > > >         NL802154_CMD_DEL_SEC_LEVEL,
> > > >
> > > >         NL802154_CMD_SCAN_EVENT,
> > > > +       NL802154_CMD_TRIGGER_SCAN,
> > > > +       NL802154_CMD_ABORT_SCAN,
> > > > +       NL802154_CMD_SCAN_DONE, =20
> > >
> > > Is NL802154_CMD_SCAN_DONE reserved now? I don't see it implemented in
> > > this series and I think we had some discussion about the need of abort
> > > vs done. Is the event now? =20
> >
> > To be very honest I went back and forth about the "abort" information
> > so I don't remember exactly what was supposed to be implemented. The
> > current implementation forwards to userspace the reason (whether the
> > scan was finished or was aborted for an external reason). So it is
> > implemented this way:
> > =20
>=20
> I think it was also to implement a way to signal all listeners that
> there is such an operation ongoing? Do we have something like that?

When the kernel receives a CMD_TRIGGER_SCAN it starts the scan and if
everything is on track sends to the userspace listeners a
CMD_TRIGGER_SCAN in return, meaning "a scan has started".

So any listener would see:
CMD_TRIGGER_SCAN
SCAN_EVENT (+ content of the beacon)
...
SCAN_EVENT (+ content of the beacon)
CMD_SCAN_DONE (+ reason, see below)

> > * Patch 6/6 adds in mac802154/scan.c:
> >
> > +       cmd =3D aborted ? NL802154_CMD_ABORT_SCAN : NL802154_CMD_SCAN_D=
ONE;
> > +       nl802154_scan_done(wpan_phy, wpan_dev, cmd);
> >
> > * And in patch 1/6, in ieee802154/nl802154.c:
> >
> > +static int nl802154_send_scan_msg(struct cfg802154_registered_device *=
rdev,
> > +                                 struct wpan_dev *wpan_dev, u8 cmd)
> > +{
> > [...]
> > +
> > +       ret =3D nl802154_prep_scan_msg(msg, rdev, wpan_dev, 0, 0, 0, cm=
d);
> >
> > Is this working for you? =20
>=20
> Sure this works in some way, I would put a reason parameter on DONE,
> but however...

Of course, I can do that. So NL802154_CMD_SCAN_DONE plus an u8
parameter:
NL802154_SCAN_DONE_REASON_FINISHED
NL802154_SCAN_DONE_REASON_ABORTED
?

Thanks,
Miqu=C3=A8l

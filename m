Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602C1604603
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiJSMyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiJSMyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:54:19 -0400
X-Greylist: delayed 3036 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 05:37:17 PDT
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22EE104D0C;
        Wed, 19 Oct 2022 05:37:16 -0700 (PDT)
Received: from relay3-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::223])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id AEA26CED23;
        Wed, 19 Oct 2022 09:54:21 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 176A660018;
        Wed, 19 Oct 2022 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666173165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+xSpHnbSHJwUWAQJtI1fFnLN7XOJPIHWmq0NGHGk/g=;
        b=H4CQLOvVkySpdfn9bvPUdJffgMEOxITZnC1qpEFjS5TqqN6JAaZwPVu7p0bZE0K+OpjA6+
        qI6G/5U4iO5WmgdCv1mdlVdK9Dc0QOvLwc6sM/RnH/kEFesqAlGEH6yRzbTUqFPh0iw9/n
        v1Q9aElj3dBfG6e3qsI4fxXrqVCDlgEwcm3su3ErMc07/AqufxycmWn7wCRWX+ZpFnt/oV
        WDFH9Y09EqVKCD2Jl0UWEv4ou6pyuhWgzmxFMdthpvQ9dR1iq2X6JiB/UJ4n368Rkc/DZs
        muaJDWTluuUfCr1FwqTkM6lDKC+i5Py655vSuoyGtVYeAQ6zCZVvPxOx+qy3Zw==
Date:   Wed, 19 Oct 2022 11:52:42 +0200
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
Subject: Re: [PATCH wpan-next] mac802154: Allow the creation of coordinator
 interfaces
Message-ID: <20221019115242.571c19bb@xps-13>
In-Reply-To: <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com>
References: <20221018183639.806719-1-miquel.raynal@bootlin.com>
        <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Tue, 18 Oct 2022 19:57:19 -0400:

> Hi,
>=20
> On Tue, Oct 18, 2022 at 2:36 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > As a first strep in introducing proper PAN management and association,
> > we need to be able to create coordinator interfaces which might act as
> > coordinator or PAN coordinator.
> >
> > Hence, let's add the minimum support to allow the creation of these
> > interfaces. This support will be improved later, in particular regarding
> > the filtering.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/iface.c | 14 ++++++++------
> >  net/mac802154/main.c  |  2 ++
> >  net/mac802154/rx.c    | 11 +++++++----
> >  3 files changed, 17 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > index d9b50884d34e..682249f3369b 100644
> > --- a/net/mac802154/iface.c
> > +++ b/net/mac802154/iface.c
> > @@ -262,13 +262,13 @@ ieee802154_check_concurrent_iface(struct ieee8021=
54_sub_if_data *sdata,
> >                 if (nsdata !=3D sdata && ieee802154_sdata_running(nsdat=
a)) {
> >                         int ret;
> >
> > -                       /* TODO currently we don't support multiple nod=
e types
> > -                        * we need to run skb_clone at rx path. Check i=
f there
> > -                        * exist really an use case if we need to suppo=
rt
> > -                        * multiple node types at the same time.
> > +                       /* TODO currently we don't support multiple nod=
e/coord
> > +                        * types we need to run skb_clone at rx path. C=
heck if
> > +                        * there exist really an use case if we need to=
 support
> > +                        * multiple node/coord types at the same time.
> >                          */
> > -                       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_NOD=
E &&
> > -                           nsdata->wpan_dev.iftype =3D=3D NL802154_IFT=
YPE_NODE)
> > +                       if (wpan_dev->iftype !=3D NL802154_IFTYPE_MONIT=
OR &&
> > +                           nsdata->wpan_dev.iftype !=3D NL802154_IFTYP=
E_MONITOR)
> >                                 return -EBUSY;
> >
> >                         /* check all phy mac sublayer settings are the =
same.
> > @@ -565,6 +565,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_dat=
a *sdata,
> >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_ADDR_BROADCAST);
> >
> >         switch (type) {
> > +       case NL802154_IFTYPE_COORD:
> >         case NL802154_IFTYPE_NODE:
> >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> >                                         sdata->dev->dev_addr);
> > @@ -624,6 +625,7 @@ ieee802154_if_add(struct ieee802154_local *local, c=
onst char *name,
> >         ieee802154_le64_to_be64(ndev->perm_addr,
> >                                 &local->hw.phy->perm_extended_addr);
> >         switch (type) {
> > +       case NL802154_IFTYPE_COORD:
> >         case NL802154_IFTYPE_NODE:
> >                 ndev->type =3D ARPHRD_IEEE802154;
> >                 if (ieee802154_is_valid_extended_unicast_addr(extended_=
addr)) {
> > diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> > index 40fab08df24b..d03ecb747afc 100644
> > --- a/net/mac802154/main.c
> > +++ b/net/mac802154/main.c
> > @@ -219,6 +219,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
> >
> >         if (hw->flags & IEEE802154_HW_PROMISCUOUS)
> >                 local->phy->supported.iftypes |=3D BIT(NL802154_IFTYPE_=
MONITOR);
> > +       else
> > +               local->phy->supported.iftypes &=3D ~BIT(NL802154_IFTYPE=
_COORD);
> > =20
>=20
> So this means if somebody in the driver sets iftype COORD is supported
> but then IEEE802154_HW_PROMISCUOUS is not supported it will not
> support COORD?
>=20
> Why is IEEE802154_HW_PROMISCUOUS required for COORD iftype? I thought
> IEEE802154_HW_PROMISCUOUS is required to do a scan?

You are totally right this is inconsistent, I'll drop the else block
entirely. The fact that HW_PROMISCUOUS is supported when starting a
scan is handled by the -EOPNOTSUPP return code from
drv_set_promiscuous_mode() called by drv_start() in
mac802154_trigger_scan().

However I need your input on the following topic: in my branch I
have somewhere a patch adding IFTYPE_COORD to the list of
phy->supported.iftypes in each individual driver. But right now, if we
drop the promiscuous constraint as you suggest, I don't see anymore the
need for setting this as a per-driver value.

Should we make the possibility to create IFTYPE_COORD interfaces the
default instead, something like this?

--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -118,7 +118,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct =
ieee802154_ops *ops)
        phy->supported.lbt =3D NL802154_SUPPORTED_BOOL_FALSE;
=20
        /* always supported */
-       phy->supported.iftypes =3D BIT(NL802154_IFTYPE_NODE);
+       phy->supported.iftypes =3D BIT(NL802154_IFTYPE_NODE) | BIT(NL802154=
_IFTYPE_COORD);

> >         rc =3D wpan_phy_register(local->phy);
> >         if (rc < 0)
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index 2ae23a2f4a09..aca348d7834b 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -208,6 +208,7 @@ __ieee802154_rx_handle_packet(struct
> > ieee802154_local *local, int ret;
> >         struct ieee802154_sub_if_data *sdata;
> >         struct ieee802154_hdr hdr;
> > +       struct sk_buff *skb2;
> >
> >         ret =3D ieee802154_parse_frame_start(skb, &hdr);
> >         if (ret) {
> > @@ -217,7 +218,7 @@ __ieee802154_rx_handle_packet(struct
> > ieee802154_local *local, }
> >
> >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NODE)
> > +               if (sdata->wpan_dev.iftype =3D=3D
> > NL802154_IFTYPE_MONITOR) continue; =20
>=20
> I guess this will work but I would like to see no logic about if it's
> not MONITOR it's NODE or COORD, because introducing others requires
> updating those again... however I think it's fine.

Actually I don't get why we would not want this logic, it seem very
relevant to me. Do you want a helper instead and hide the condition
inside? Or something else? Or is it just fine for now?

> I would like to see
> a different receive path for coord_rx() and node_rx(), but yea
> currently I guess they are mostly the same... in future I think they
> are required as PACKTE_HOST, etc. will be changed regarding pan
> coordinator or just coordinator (so far I understood).

I agree it is tempting, but yeah, there is really very little changes
between the two, for me splitting the rx path would just darken the
code without bringing much...

About the way we handle the PAN coordinator role I have a couple of
questions:
- shall we consider only the PAN coordinator to be able to accept
  associations or is any coordinator in the PAN able to do it? (this is
  not clear to me)
- If a coordinator receives a packet with no destination it should
  expect it to be targeted at the PAN controller. Should we consider
  relaying the packet?
- Is relaying a hardware feature or should we do it in software?

> >                 if (!ieee802154_sdata_running(sdata))
> > @@ -230,9 +231,11 @@ __ieee802154_rx_handle_packet(struct
> > ieee802154_local *local, sdata->required_filtering =3D=3D
> > IEEE802154_FILTERING_4_FRAME_FIELDS) continue;
> >
> > -               ieee802154_subif_frame(sdata, skb, &hdr);
> > -               skb =3D NULL;
> > -               break;
> > +               skb2 =3D skb_clone(skb, GFP_ATOMIC);
> > +               if (skb2) {
> > +                       skb2->dev =3D sdata->dev;
> > +                       ieee802154_subif_frame(sdata, skb2, &hdr);
> > +               }
> >         }
> >
> >         kfree_skb(skb); =20
>=20
> If we do the clone above this kfree_skb() should be move to
> ieee802154_rx() right after __ieee802154_rx_handle_packet().

Ok!

> This patch also changes that we deliver one skb to multiple interfaces if
> there are more than one and I was not aware that we currently do that.
> :/

Just as a side note: we do that already if we have several MONITOR
interfaces opened on the same PHY, it is possible to have them all open.

Regarding the situation where we would have NODE + MONITOR or COORD +
MONITOR, while the interface creation would work, both could not be
open at the same time because the following happens:
mac802154_wpan_open() {
	ieee802154_check_concurrent_iface() {
		ieee802154_check_mac_settings() {
			/* prevent the two interface types from being
			 * open at the same time because the filtering
			 * needs are not compatible. */
		}
	}
}

Then, because you asked me to anticipate if we ever want to support more
than one NODE or COORD interface at the same time, or at least not to
do anything that would lead to a step back on this regard, I decided I
would provide all the infrastructure to gracefully handle this
situation in the Rx path, even though right now it still cannot happen
because when opening an interface, ieee802154_check_concurrent_iface()
will also prevent two NODE / COORD interfaces to be opened at the same
time.

TL;DR
* MONITOR + MONITOR
  =3D already supported and working
* (NODE + MONITOR) || (COORD + MONITOR)
  =3D iface creation allowed, but cannot be opened at the same time
  because of the filtering level incompatibility on a single PHY
* (NODE + NODE) || (COORD + COORD) || (NODE + COORD)
  =3D iface creation allowed, but cannot be opened at the same time
  because only one PHY available on the device

So for me we are safe and future proof.

Thanks,
Miqu=C3=A8l

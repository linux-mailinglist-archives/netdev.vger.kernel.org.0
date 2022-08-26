Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAD35A21EE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245384AbiHZHbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiHZHaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:30:46 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5127B2A3;
        Fri, 26 Aug 2022 00:30:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B8E9C60014;
        Fri, 26 Aug 2022 07:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661499034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oX2MMYRdBL3fMgi654ieTqHv7qv4T4+5c611KCXLe4I=;
        b=VRjIDTcSHeOJ7yn/aJuVyfbfKtyILRXnk+613Ga/Rn6bVPT6jHthJayM1didIbb66faVWU
        n6kC6J4lYnqHDM9F3SJSi/+hrsgbiobE7E0AxPu+ApyBJzxoGiQAsW+ccP8LkiatGJU4gh
        mqmiCnwSZ8mmLYrY7lYajv2x8L1EDLCPERH3VGXwIEmD3mbMm9dJWV1/M8CnX8WkhN4uvw
        aX4NdFy03QqTMeEpDbt2nqmoL2YOh/WOSoYn4DSdRLr/uStqf/tqrxfk7sp5RUyjYh5X0x
        idClouiiBkgUoiG26JKnW8EL36zgqQtuNn0lPp2yAfR6yHdjeDCIlzB7kXKhMA==
Date:   Fri, 26 Aug 2022 09:30:29 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
Message-ID: <20220826093029.474ae5b4@xps-13>
In-Reply-To: <CAK-6q+hxSpw1yJR5H5D6gy5gGdm6Qa3VzyjZXA45KFQfVVqwFw@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
        <20220823182950.1c722e13@xps-13>
        <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
        <20220824093547.16f05d15@xps-13>
        <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
        <20220825104035.11806a67@xps-13>
        <CAK-6q+hxSpw1yJR5H5D6gy5gGdm6Qa3VzyjZXA45KFQfVVqwFw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 25 Aug 2022 20:51:49 -0400:

> Hi,
>=20
> On Thu, Aug 25, 2022 at 4:41 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:43:11 -0400:
> > =20
> > > On Wed, Aug 24, 2022 at 3:35 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 17:44:52 -0400:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
> > > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
> > > > > > =20
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@=
bootlin.com> wrote: =20
> > > > > > > >
> > > > > > > > Hi Alexander,
> > > > > > > >
> > > > > > > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
> > > > > > > > =20
> > > > > > > > > Hi,
> > > > > > > > >
> > > > > > > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.ray=
nal@bootlin.com> wrote: =20
> > > > > > > > > >
> > > > > > > > > > As a first strep in introducing proper PAN management a=
nd association,
> > > > > > > > > > we need to be able to create coordinator interfaces whi=
ch might act as
> > > > > > > > > > coordinator or PAN coordinator.
> > > > > > > > > >
> > > > > > > > > > Hence, let's add the minimum support to allow the creat=
ion of these
> > > > > > > > > > interfaces. This might be restrained and improved later.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > > > > > ---
> > > > > > > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > > > > > > >  net/mac802154/rx.c    |  2 +-
> > > > > > > > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/ifac=
e.c
> > > > > > > > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > > > > > > > --- a/net/mac802154/iface.c
> > > > > > > > > > +++ b/net/mac802154/iface.c
> > > > > > > > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface=
(struct ieee802154_sub_if_data *sdata,
> > > > > > > > > >                 if (nsdata !=3D sdata && ieee802154_sda=
ta_running(nsdata)) {
> > > > > > > > > >                         int ret;
> > > > > > > > > >
> > > > > > > > > > -                       /* TODO currently we don't supp=
ort multiple node types
> > > > > > > > > > -                        * we need to run skb_clone at =
rx path. Check if there
> > > > > > > > > > -                        * exist really an use case if =
we need to support
> > > > > > > > > > -                        * multiple node types at the s=
ame time.
> > > > > > > > > > +                       /* TODO currently we don't supp=
ort multiple node/coord
> > > > > > > > > > +                        * types we need to run skb_clo=
ne at rx path. Check if
> > > > > > > > > > +                        * there exist really an use ca=
se if we need to support
> > > > > > > > > > +                        * multiple node/coord types at=
 the same time.
> > > > > > > > > >                          */
> > > > > > > > > > -                       if (wpan_dev->iftype =3D=3D NL8=
02154_IFTYPE_NODE &&
> > > > > > > > > > -                           nsdata->wpan_dev.iftype =3D=
=3D NL802154_IFTYPE_NODE)
> > > > > > > > > > +                       if (wpan_dev->iftype !=3D NL802=
154_IFTYPE_MONITOR &&
> > > > > > > > > > +                           nsdata->wpan_dev.iftype !=
=3D NL802154_IFTYPE_MONITOR)
> > > > > > > > > >                                 return -EBUSY;
> > > > > > > > > >
> > > > > > > > > >                         /* check all phy mac sublayer s=
ettings are the same.
> > > > > > > > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee8=
02154_sub_if_data *sdata,
> > > > > > > > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154=
_ADDR_BROADCAST);
> > > > > > > > > >
> > > > > > > > > >         switch (type) {
> > > > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > > > >                 ieee802154_be64_to_le64(&wpan_dev->exte=
nded_addr,
> > > > > > > > > >                                         sdata->dev->dev=
_addr);
> > > > > > > > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154=
_local *local, const char *name,
> > > > > > > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > > > > > > >                                 &local->hw.phy->perm_ex=
tended_addr);
> > > > > > > > > >         switch (type) {
> > > > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > > > > > > > >                 if (ieee802154_is_valid_extended_unicas=
t_addr(extended_addr)) {
> > > > > > > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > > > > > > index b8ce84618a55..39459d8d787a 100644
> > > > > > > > > > --- a/net/mac802154/rx.c
> > > > > > > > > > +++ b/net/mac802154/rx.c
> > > > > > > > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struc=
t ieee802154_local *local,
> > > > > > > > > >         }
> > > > > > > > > >
> > > > > > > > > >         list_for_each_entry_rcu(sdata, &local->interfac=
es, list) {
> > > > > > > > > > -               if (sdata->wpan_dev.iftype !=3D NL80215=
4_IFTYPE_NODE)
> > > > > > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802=
154_IFTYPE_MONITOR)
> > > > > > > > > >                         continue; =20
> > > > > > > > >
> > > > > > > > > I probably get why you are doing that, but first the over=
all design is
> > > > > > > > > working differently - means you should add an additional =
receive path
> > > > > > > > > for the special interface type.
> > > > > > > > >
> > > > > > > > > Also we "discovered" before that the receive path of node=
 vs
> > > > > > > > > coordinator is different... Where is the different handli=
ng here? I
> > > > > > > > > don't see it, I see that NODE and COORD are the same now =
(because that
> > > > > > > > > is _currently_ everything else than monitor). This change=
 is not
> > > > > > > > > enough and does "something" to handle in some way coordin=
ator receive
> > > > > > > > > path but there are things missing.
> > > > > > > > >
> > > > > > > > > 1. Changing the address filters that it signals the trans=
ceiver it's
> > > > > > > > > acting as coordinator
> > > > > > > > > 2. We _should_ also have additional handling for whatever=
 the
> > > > > > > > > additional handling what address filters are doing in mac=
802154
> > > > > > > > > _because_ there is hardware which doesn't have address fi=
ltering e.g.
> > > > > > > > > hwsim which depend that this is working in software like =
other
> > > > > > > > > transceiver hardware address filters.
> > > > > > > > >
> > > > > > > > > For the 2. one, I don't know if we do that even for NODE =
right or we
> > > > > > > > > just have the bare minimal support there... I don't assum=
e that
> > > > > > > > > everything is working correctly here but what I want to s=
ee is a
> > > > > > > > > separate receive path for coordinators that people can se=
nd patches to
> > > > > > > > > fix it. =20
> > > > > > > >
> > > > > > > > Yes, we do very little differently between the two modes, t=
hat's why I
> > > > > > > > took the easy way: just changing the condition. I really do=
n't see what
> > > > > > > > I can currently add here, but I am fine changing the style =
to easily
> > > > > > > > show people where to add filters for such or such interface=
, but right
> > > > > > > > now both path will look very "identical", do we agree on th=
at? =20
> > > > > > >
> > > > > > > mostly yes, but there exists a difference and we should at le=
ast check
> > > > > > > if the node receive path violates the coordinator receive pat=
h and
> > > > > > > vice versa.
> > > > > > > Put it in a receive_path() function and then coord_receive_pa=
th(),
> > > > > > > node_receive_path() that calls the receive_path() and do the
> > > > > > > additional filtering for coordinators, etc.
> > > > > > >
> > > > > > > There should be a part in the standard about "third level fil=
ter rule
> > > > > > > if it's a coordinator".
> > > > > > > btw: this is because the address filter on the transceiver ne=
eds to
> > > > > > > have the "i am a coordinator" boolean set which is missing in=
 this
> > > > > > > series. However it depends on the transceiver filtering level=
 and the
> > > > > > > mac802154 receive path if we actually need to run such filter=
ing or
> > > > > > > not. =20
> > > > > >
> > > > > > I must be missing some information because I can't find any pla=
ces
> > > > > > where what you suggest is described in the spec.
> > > > > >
> > > > > > I agree there are multiple filtering level so let's go through =
them one
> > > > > > by one (6.7.2 Reception and rejection):
> > > > > > - first level: is the checksum (FCS) valid?
> > > > > >         yes -> goto second level
> > > > > >         no -> drop
> > > > > > - second level: are we in promiscuous mode?
> > > > > >         yes -> forward to upper layers
> > > > > >         no -> goto second level (bis)
> > > > > > - second level (bis): are we scanning?
> > > > > >         yes -> goto scan filtering
> > > > > >         no -> goto third level
> > > > > > - scan filtering: is it a beacon?
> > > > > >         yes -> process the beacon
> > > > > >         no -> drop
> > > > > > - third level: is the frame valid? (type, source, destination, =
pan id,
> > > > > >   etc)
> > > > > >         yes -> forward to upper layers
> > > > > >         no -> drop
> > > > > >
> > > > > > But none of them, as you said, is dependent on the interface ty=
pe.
> > > > > > There is no mention of a specific filtering operation to do in =
all
> > > > > > those cases when running in COORD mode. So I still don't get wh=
at
> > > > > > should be included in either node_receive_path() which should be
> > > > > > different than in coord_receive_path() for now.
> > > > > >
> > > > > > There are, however, two situations where the interface type has=
 its
> > > > > > importance:
> > > > > > - Enhanced beacon requests with Enhanced beacon filter IE, whic=
h asks
> > > > > >   the receiving device to process/drop the request upon certain
> > > > > >   conditions (minimum LQI and/or randomness), as detailed in
> > > > > >   7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
> > > > > >   7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon R=
equest
> > > > > >   command is optional for an FFD and an RFD", so this series wa=
s only
> > > > > >   targeting basic beaconing for now.
> > > > > > - In relaying mode, the destination address must not be validat=
ed
> > > > > >   because the message needs to be re-emitted. Indeed, a receive=
r in
> > > > > >   relaying mode may not be the recipient. This is also optional=
 and out
> > > > > >   of the scope of this series.
> > > > > >
> > > > > > Right now I have the below diff, which clarifies the two path, =
without
> > > > > > too much changes in the current code because I don't really see=
 why it
> > > > > > would be necessary. Unless you convince me otherwise or read th=
e spec
> > > > > > differently than I do :) What do you think?
> > > > > > =20
> > > > >
> > > > > "Reception and rejection"
> > > > >
> > > > > third-level filtering regarding "destination address" and if the
> > > > > device is "PAN coordinator".
> > > > > This is, in my opinion, what the coordinator boolean tells the
> > > > > transceiver to do on hardware when doing address filter there. Yo=
u can
> > > > > also read that up in datasheets of transceivers as atf86rf233, se=
arch
> > > > > for I_AM_COORD. =20
> > > >
> > > > Oh right, I now see what you mean!
> > > > =20
> > > > > Whereas they use the word "PAN coordinator" not "coordinator", if=
 they
> > > > > really make a difference there at this point..., if so then the k=
ernel
> > > > > must know if the coordinator is a pan coordinator or coordinator
> > > > > because we need to set the address filter in kernel. =20
> > > >
> > > > Yes we need to make a difference, you can have several coordinators=
 but
> > > > a single PAN coordinator in a PAN. I think we can assume that the P=
AN
> > > > coordinator is the coordinator with no parent (association-wise). W=
ith
> > > > the addition of the association series, I can handle that, so I will
> > > > create the two path as you advise, add a comment about this additio=
nal
> > > > filter rule that we don't yet support, and finally after the
> > > > association series add another commit to make this filtering rule r=
eal.
> > > > =20
> > > > > =20
> > > > > > Thanks,
> > > > > > Miqu=C3=A8l
> > > > > >
> > > > > > ---
> > > > > >
> > > > > > --- a/net/mac802154/rx.c
> > > > > > +++ b/net/mac802154/rx.c
> > > > > > @@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee80=
2154_local *local,
> > > > > >         int ret;
> > > > > >         struct ieee802154_sub_if_data *sdata;
> > > > > >         struct ieee802154_hdr hdr;
> > > > > > +       bool iface_found =3D false;
> > > > > >
> > > > > >         ret =3D ieee802154_parse_frame_start(skb, &hdr);
> > > > > >         if (ret) {
> > > > > > @@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ieee=
802154_local *local,
> > > > > >         }
> > > > > >
> > > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, list=
) {
> > > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE=
_NODE)
> > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTY=
PE_MONITOR)
> > > > > >                         continue;
> > > > > >
> > > > > >                 if (!ieee802154_sdata_running(sdata))
> > > > > >                         continue;
> > > > > >
> > > > > > +               iface_found =3D true;
> > > > > > +               break;
> > > > > > +       }
> > > > > > +
> > > > > > +       if (!iface_found) {
> > > > > > +               kfree_skb(skb);
> > > > > > +               return;
> > > > > > +       }
> > > > > > +
> > > > > > +       /* TBD: Additional filtering is possible on NODEs and/o=
r COORDINATORs */
> > > > > > +       switch (sdata->wpan_dev.iftype) {
> > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > +       case NL802154_IFTYPE_NODE:
> > > > > >                 ieee802154_subif_frame(sdata, skb, &hdr);
> > > > > > -               skb =3D NULL;
> > > > > > +               break;
> > > > > > +       default:
> > > > > > +               kfree_skb(skb);
> > > > > >                 break;
> > > > > >         } =20
> > > > >
> > > > > Why do you remove the whole interface looping above and make it o=
nly
> > > > > run for one ?first found? ? =20
> > > >
> > > > To reduce the indentation level.
> > > > =20
> > > > > That code changes this behaviour and I do
> > > > > not know why. =20
> > > >
> > > > The precedent code did:
> > > > for_each_iface() {
> > > >         if (not a node)
> > > >                 continue;
> > > >         if (not running)
> > > >                 continue;
> > > >
> > > >         subif_frame();
> > > >         break;
> > > > }
> > > >
> > > > That final break also elected only the first running node iface.
> > > > Otherwise it would mean that we allow the same skb to be consumed
> > > > twice, which is wrong IMHO? =20
> > >
> > > no? Why is that wrong? There is a real use-case to have multiple
> > > interfaces on one phy (or to do it in near future, I said that
> > > multiple times). This patch does a step backwards to this. =20
> >
> > So we need to duplicate the skb because it automatically gets freed in
> > the "forward to upper layer" path. Am I right? I'm fine doing so if =20
>=20
> What is the definition of "duplicate the skb" here.

skb2 =3D skb_clone(skb, GFP_ATOMIC);
if (skb2) {
	skb2->dev =3D sdata->dev;
	ieee802154_deliver_skb(skb2);
	...
}

This is exactly what the ieee80254_monitors_rx() function does, it
loops over all the monitor interfaces and each time there is one
running, copies the skb and consumes it by forwarding it to the upper
layers. I've done the same in the other path to keep the ability to use
more than one "visible" interface on the same PHY (by visible I mean:
not a monitor).

> > this is the way to go, but I am interested if you can give me a real
> > use case where having NODE+COORDINATOR on the same PHY is useful?
> > =20
>=20
> Testing.

Ok :-)


Thanks,
Miqu=C3=A8l

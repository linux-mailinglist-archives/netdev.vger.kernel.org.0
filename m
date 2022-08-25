Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB35A0BB4
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbiHYIlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239431AbiHYIkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:40:43 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4297CB46;
        Thu, 25 Aug 2022 01:40:39 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 37767C000B;
        Thu, 25 Aug 2022 08:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661416837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Am4LqnkIKE/yX75vRmuOKr2JVZqFlZvk9xmw+zu4JEs=;
        b=QKZaHy5Zp9xLp6ZqS5O/4VCLkgikspkA5h5FIFggv1CcKPsd1fqjAkvD9DJ6EmrwMUihy6
        Q9UF9vLllphu1SIvd7hFRPZ3ldkqZy6XbqTJJ9kQxaRtx+z16ZZssEzDgymOYNq7wHEqG0
        mQL+zN7D0p+i6coQ2UQZR5RMBYkbcmDXWf7nuQi7bRYO3R93FvB3sYDWiOUAgvbvF2Gq/4
        vN30x/q65YW99kICQI8Fz/nQ7VFfPyT2XD7eX3sIqLQiSWTfwhiLoH3dC70f3lDjyuaIWk
        aMu4zj1ucE3cg2mUSXs4yl3oPkJ6ehYzibApsIUYqE581VUxYQefpSXV2yW6tg==
Date:   Thu, 25 Aug 2022 10:40:35 +0200
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
Message-ID: <20220825104035.11806a67@xps-13>
In-Reply-To: <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
        <20220823182950.1c722e13@xps-13>
        <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
        <20220824093547.16f05d15@xps-13>
        <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:43:11 -0400:

> On Wed, Aug 24, 2022 at 3:35 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Tue, 23 Aug 2022 17:44:52 -0400:
> > =20
> > > Hi,
> > >
> > > On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote: =20
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
> > > > > > =20
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@=
bootlin.com> wrote: =20
> > > > > > > >
> > > > > > > > As a first strep in introducing proper PAN management and a=
ssociation,
> > > > > > > > we need to be able to create coordinator interfaces which m=
ight act as
> > > > > > > > coordinator or PAN coordinator.
> > > > > > > >
> > > > > > > > Hence, let's add the minimum support to allow the creation =
of these
> > > > > > > > interfaces. This might be restrained and improved later.
> > > > > > > >
> > > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > > > ---
> > > > > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > > > > >  net/mac802154/rx.c    |  2 +-
> > > > > > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > > > > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > > > > > --- a/net/mac802154/iface.c
> > > > > > > > +++ b/net/mac802154/iface.c
> > > > > > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(str=
uct ieee802154_sub_if_data *sdata,
> > > > > > > >                 if (nsdata !=3D sdata && ieee802154_sdata_r=
unning(nsdata)) {
> > > > > > > >                         int ret;
> > > > > > > >
> > > > > > > > -                       /* TODO currently we don't support =
multiple node types
> > > > > > > > -                        * we need to run skb_clone at rx p=
ath. Check if there
> > > > > > > > -                        * exist really an use case if we n=
eed to support
> > > > > > > > -                        * multiple node types at the same =
time.
> > > > > > > > +                       /* TODO currently we don't support =
multiple node/coord
> > > > > > > > +                        * types we need to run skb_clone a=
t rx path. Check if
> > > > > > > > +                        * there exist really an use case i=
f we need to support
> > > > > > > > +                        * multiple node/coord types at the=
 same time.
> > > > > > > >                          */
> > > > > > > > -                       if (wpan_dev->iftype =3D=3D NL80215=
4_IFTYPE_NODE &&
> > > > > > > > -                           nsdata->wpan_dev.iftype =3D=3D =
NL802154_IFTYPE_NODE)
> > > > > > > > +                       if (wpan_dev->iftype !=3D NL802154_=
IFTYPE_MONITOR &&
> > > > > > > > +                           nsdata->wpan_dev.iftype !=3D NL=
802154_IFTYPE_MONITOR)
> > > > > > > >                                 return -EBUSY;
> > > > > > > >
> > > > > > > >                         /* check all phy mac sublayer setti=
ngs are the same.
> > > > > > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee80215=
4_sub_if_data *sdata,
> > > > > > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_ADD=
R_BROADCAST);
> > > > > > > >
> > > > > > > >         switch (type) {
> > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > >                 ieee802154_be64_to_le64(&wpan_dev->extended=
_addr,
> > > > > > > >                                         sdata->dev->dev_add=
r);
> > > > > > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_loc=
al *local, const char *name,
> > > > > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > > > > >                                 &local->hw.phy->perm_extend=
ed_addr);
> > > > > > > >         switch (type) {
> > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > > > > > >                 if (ieee802154_is_valid_extended_unicast_ad=
dr(extended_addr)) {
> > > > > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > > > > index b8ce84618a55..39459d8d787a 100644
> > > > > > > > --- a/net/mac802154/rx.c
> > > > > > > > +++ b/net/mac802154/rx.c
> > > > > > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ie=
ee802154_local *local,
> > > > > > > >         }
> > > > > > > >
> > > > > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, =
list) {
> > > > > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IF=
TYPE_NODE)
> > > > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_=
IFTYPE_MONITOR)
> > > > > > > >                         continue; =20
> > > > > > >
> > > > > > > I probably get why you are doing that, but first the overall =
design is
> > > > > > > working differently - means you should add an additional rece=
ive path
> > > > > > > for the special interface type.
> > > > > > >
> > > > > > > Also we "discovered" before that the receive path of node vs
> > > > > > > coordinator is different... Where is the different handling h=
ere? I
> > > > > > > don't see it, I see that NODE and COORD are the same now (bec=
ause that
> > > > > > > is _currently_ everything else than monitor). This change is =
not
> > > > > > > enough and does "something" to handle in some way coordinator=
 receive
> > > > > > > path but there are things missing.
> > > > > > >
> > > > > > > 1. Changing the address filters that it signals the transceiv=
er it's
> > > > > > > acting as coordinator
> > > > > > > 2. We _should_ also have additional handling for whatever the
> > > > > > > additional handling what address filters are doing in mac8021=
54
> > > > > > > _because_ there is hardware which doesn't have address filter=
ing e.g.
> > > > > > > hwsim which depend that this is working in software like other
> > > > > > > transceiver hardware address filters.
> > > > > > >
> > > > > > > For the 2. one, I don't know if we do that even for NODE righ=
t or we
> > > > > > > just have the bare minimal support there... I don't assume th=
at
> > > > > > > everything is working correctly here but what I want to see i=
s a
> > > > > > > separate receive path for coordinators that people can send p=
atches to
> > > > > > > fix it. =20
> > > > > >
> > > > > > Yes, we do very little differently between the two modes, that'=
s why I
> > > > > > took the easy way: just changing the condition. I really don't =
see what
> > > > > > I can currently add here, but I am fine changing the style to e=
asily
> > > > > > show people where to add filters for such or such interface, bu=
t right
> > > > > > now both path will look very "identical", do we agree on that? =
=20
> > > > >
> > > > > mostly yes, but there exists a difference and we should at least =
check
> > > > > if the node receive path violates the coordinator receive path and
> > > > > vice versa.
> > > > > Put it in a receive_path() function and then coord_receive_path(),
> > > > > node_receive_path() that calls the receive_path() and do the
> > > > > additional filtering for coordinators, etc.
> > > > >
> > > > > There should be a part in the standard about "third level filter =
rule
> > > > > if it's a coordinator".
> > > > > btw: this is because the address filter on the transceiver needs =
to
> > > > > have the "i am a coordinator" boolean set which is missing in this
> > > > > series. However it depends on the transceiver filtering level and=
 the
> > > > > mac802154 receive path if we actually need to run such filtering =
or
> > > > > not. =20
> > > >
> > > > I must be missing some information because I can't find any places
> > > > where what you suggest is described in the spec.
> > > >
> > > > I agree there are multiple filtering level so let's go through them=
 one
> > > > by one (6.7.2 Reception and rejection):
> > > > - first level: is the checksum (FCS) valid?
> > > >         yes -> goto second level
> > > >         no -> drop
> > > > - second level: are we in promiscuous mode?
> > > >         yes -> forward to upper layers
> > > >         no -> goto second level (bis)
> > > > - second level (bis): are we scanning?
> > > >         yes -> goto scan filtering
> > > >         no -> goto third level
> > > > - scan filtering: is it a beacon?
> > > >         yes -> process the beacon
> > > >         no -> drop
> > > > - third level: is the frame valid? (type, source, destination, pan =
id,
> > > >   etc)
> > > >         yes -> forward to upper layers
> > > >         no -> drop
> > > >
> > > > But none of them, as you said, is dependent on the interface type.
> > > > There is no mention of a specific filtering operation to do in all
> > > > those cases when running in COORD mode. So I still don't get what
> > > > should be included in either node_receive_path() which should be
> > > > different than in coord_receive_path() for now.
> > > >
> > > > There are, however, two situations where the interface type has its
> > > > importance:
> > > > - Enhanced beacon requests with Enhanced beacon filter IE, which as=
ks
> > > >   the receiving device to process/drop the request upon certain
> > > >   conditions (minimum LQI and/or randomness), as detailed in
> > > >   7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
> > > >   7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon Reque=
st
> > > >   command is optional for an FFD and an RFD", so this series was on=
ly
> > > >   targeting basic beaconing for now.
> > > > - In relaying mode, the destination address must not be validated
> > > >   because the message needs to be re-emitted. Indeed, a receiver in
> > > >   relaying mode may not be the recipient. This is also optional and=
 out
> > > >   of the scope of this series.
> > > >
> > > > Right now I have the below diff, which clarifies the two path, with=
out
> > > > too much changes in the current code because I don't really see why=
 it
> > > > would be necessary. Unless you convince me otherwise or read the sp=
ec
> > > > differently than I do :) What do you think?
> > > > =20
> > >
> > > "Reception and rejection"
> > >
> > > third-level filtering regarding "destination address" and if the
> > > device is "PAN coordinator".
> > > This is, in my opinion, what the coordinator boolean tells the
> > > transceiver to do on hardware when doing address filter there. You can
> > > also read that up in datasheets of transceivers as atf86rf233, search
> > > for I_AM_COORD. =20
> >
> > Oh right, I now see what you mean!
> > =20
> > > Whereas they use the word "PAN coordinator" not "coordinator", if they
> > > really make a difference there at this point..., if so then the kernel
> > > must know if the coordinator is a pan coordinator or coordinator
> > > because we need to set the address filter in kernel. =20
> >
> > Yes we need to make a difference, you can have several coordinators but
> > a single PAN coordinator in a PAN. I think we can assume that the PAN
> > coordinator is the coordinator with no parent (association-wise). With
> > the addition of the association series, I can handle that, so I will
> > create the two path as you advise, add a comment about this additional
> > filter rule that we don't yet support, and finally after the
> > association series add another commit to make this filtering rule real.
> > =20
> > > =20
> > > > Thanks,
> > > > Miqu=C3=A8l
> > > >
> > > > ---
> > > >
> > > > --- a/net/mac802154/rx.c
> > > > +++ b/net/mac802154/rx.c
> > > > @@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee802154=
_local *local,
> > > >         int ret;
> > > >         struct ieee802154_sub_if_data *sdata;
> > > >         struct ieee802154_hdr hdr;
> > > > +       bool iface_found =3D false;
> > > >
> > > >         ret =3D ieee802154_parse_frame_start(skb, &hdr);
> > > >         if (ret) {
> > > > @@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ieee8021=
54_local *local,
> > > >         }
> > > >
> > > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NOD=
E)
> > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE_M=
ONITOR)
> > > >                         continue;
> > > >
> > > >                 if (!ieee802154_sdata_running(sdata))
> > > >                         continue;
> > > >
> > > > +               iface_found =3D true;
> > > > +               break;
> > > > +       }
> > > > +
> > > > +       if (!iface_found) {
> > > > +               kfree_skb(skb);
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       /* TBD: Additional filtering is possible on NODEs and/or CO=
ORDINATORs */
> > > > +       switch (sdata->wpan_dev.iftype) {
> > > > +       case NL802154_IFTYPE_COORD:
> > > > +       case NL802154_IFTYPE_NODE:
> > > >                 ieee802154_subif_frame(sdata, skb, &hdr);
> > > > -               skb =3D NULL;
> > > > +               break;
> > > > +       default:
> > > > +               kfree_skb(skb);
> > > >                 break;
> > > >         } =20
> > >
> > > Why do you remove the whole interface looping above and make it only
> > > run for one ?first found? ? =20
> >
> > To reduce the indentation level.
> > =20
> > > That code changes this behaviour and I do
> > > not know why. =20
> >
> > The precedent code did:
> > for_each_iface() {
> >         if (not a node)
> >                 continue;
> >         if (not running)
> >                 continue;
> >
> >         subif_frame();
> >         break;
> > }
> >
> > That final break also elected only the first running node iface.
> > Otherwise it would mean that we allow the same skb to be consumed
> > twice, which is wrong IMHO? =20
>=20
> no? Why is that wrong? There is a real use-case to have multiple
> interfaces on one phy (or to do it in near future, I said that
> multiple times). This patch does a step backwards to this.

So we need to duplicate the skb because it automatically gets freed in
the "forward to upper layer" path. Am I right? I'm fine doing so if
this is the way to go, but I am interested if you can give me a real
use case where having NODE+COORDINATOR on the same PHY is useful?

Thanks,
Miqu=C3=A8l

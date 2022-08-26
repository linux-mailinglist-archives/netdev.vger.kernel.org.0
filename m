Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251EA5A229E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbiHZIIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiHZIIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:08:35 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98312D475F;
        Fri, 26 Aug 2022 01:08:30 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8A5BF1BF204;
        Fri, 26 Aug 2022 08:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661501308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6JpZSoa946jk0BQxxzywAyZYUXfBX6HOgUDYQzAJ4A=;
        b=X0vTU2ByLWlmQJ1bNfwXwUYouYthAJ4I0lcBsyewyEd3lNlTEaTzcCFTU4aXUyD48mWXEj
        W46NKtmSstLnPWL1PWPgkQX+JL9Ku70NpU+If3JQEc+InfsIDS6KBxU+mGh3MeN9gAwQEc
        U0At+95FTR6pxonsAny00C8HBuwHt9Kngq11iZ1UB2WJGDaUvEetX9PqwQeQzNkkncZDlQ
        dWcE6Ya+s6SUxvohZHs8g/wNf5mTz9dVm/9qrggZVE3H7vdnSUJi5PdP3DuChetyIcEOJ7
        8DKL6WPtpxmKydeFgVc7Lc3D4uCiR5JVGw8Us5TOFOwsckdGjXhg4F6cctAROg==
Date:   Fri, 26 Aug 2022 10:08:25 +0200
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
Message-ID: <20220826100825.4f79c777@xps-13>
In-Reply-To: <CAK-6q+jbBg4kCh88Oz7mBa0RBBX_+cqqoPjT3POEjbQKX1ZDKw@mail.gmail.com>
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
        <CAK-6q+jbBg4kCh88Oz7mBa0RBBX_+cqqoPjT3POEjbQKX1ZDKw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 25 Aug 2022 21:35:05 -0400:

> Hi,
>=20
> On Thu, Aug 25, 2022 at 8:51 PM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Thu, Aug 25, 2022 at 4:41 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:43:11 -0400:
> > > =20
> > > > On Wed, Aug 24, 2022 at 3:35 AM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote: =20
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 17:44:52 -0400:
> > > > > =20
> > > > > > Hi,
> > > > > >
> > > > > > On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
> > > > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > > > >
> > > > > > > Hi Alexander,
> > > > > > >
> > > > > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
> > > > > > > =20
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.rayna=
l@bootlin.com> wrote: =20
> > > > > > > > >
> > > > > > > > > Hi Alexander,
> > > > > > > > >
> > > > > > > > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -04=
00:
> > > > > > > > > =20
> > > > > > > > > > Hi,
> > > > > > > > > >
> > > > > > > > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.r=
aynal@bootlin.com> wrote: =20
> > > > > > > > > > >
> > > > > > > > > > > As a first strep in introducing proper PAN management=
 and association,
> > > > > > > > > > > we need to be able to create coordinator interfaces w=
hich might act as
> > > > > > > > > > > coordinator or PAN coordinator.
> > > > > > > > > > >
> > > > > > > > > > > Hence, let's add the minimum support to allow the cre=
ation of these
> > > > > > > > > > > interfaces. This might be restrained and improved lat=
er.
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.c=
om>
> > > > > > > > > > > ---
> > > > > > > > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > > > > > > > >  net/mac802154/rx.c    |  2 +-
> > > > > > > > > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/if=
ace.c
> > > > > > > > > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > > > > > > > > --- a/net/mac802154/iface.c
> > > > > > > > > > > +++ b/net/mac802154/iface.c
> > > > > > > > > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_ifa=
ce(struct ieee802154_sub_if_data *sdata,
> > > > > > > > > > >                 if (nsdata !=3D sdata && ieee802154_s=
data_running(nsdata)) {
> > > > > > > > > > >                         int ret;
> > > > > > > > > > >
> > > > > > > > > > > -                       /* TODO currently we don't su=
pport multiple node types
> > > > > > > > > > > -                        * we need to run skb_clone a=
t rx path. Check if there
> > > > > > > > > > > -                        * exist really an use case i=
f we need to support
> > > > > > > > > > > -                        * multiple node types at the=
 same time.
> > > > > > > > > > > +                       /* TODO currently we don't su=
pport multiple node/coord
> > > > > > > > > > > +                        * types we need to run skb_c=
lone at rx path. Check if
> > > > > > > > > > > +                        * there exist really an use =
case if we need to support
> > > > > > > > > > > +                        * multiple node/coord types =
at the same time.
> > > > > > > > > > >                          */
> > > > > > > > > > > -                       if (wpan_dev->iftype =3D=3D N=
L802154_IFTYPE_NODE &&
> > > > > > > > > > > -                           nsdata->wpan_dev.iftype =
=3D=3D NL802154_IFTYPE_NODE)
> > > > > > > > > > > +                       if (wpan_dev->iftype !=3D NL8=
02154_IFTYPE_MONITOR &&
> > > > > > > > > > > +                           nsdata->wpan_dev.iftype !=
=3D NL802154_IFTYPE_MONITOR)
> > > > > > > > > > >                                 return -EBUSY;
> > > > > > > > > > >
> > > > > > > > > > >                         /* check all phy mac sublayer=
 settings are the same.
> > > > > > > > > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct iee=
e802154_sub_if_data *sdata,
> > > > > > > > > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE8021=
54_ADDR_BROADCAST);
> > > > > > > > > > >
> > > > > > > > > > >         switch (type) {
> > > > > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > > > > >                 ieee802154_be64_to_le64(&wpan_dev->ex=
tended_addr,
> > > > > > > > > > >                                         sdata->dev->d=
ev_addr);
> > > > > > > > > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee8021=
54_local *local, const char *name,
> > > > > > > > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > > > > > > > >                                 &local->hw.phy->perm_=
extended_addr);
> > > > > > > > > > >         switch (type) {
> > > > > > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > > > > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > > > > > > > > >                 if (ieee802154_is_valid_extended_unic=
ast_addr(extended_addr)) {
> > > > > > > > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > > > > > > > index b8ce84618a55..39459d8d787a 100644
> > > > > > > > > > > --- a/net/mac802154/rx.c
> > > > > > > > > > > +++ b/net/mac802154/rx.c
> > > > > > > > > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(str=
uct ieee802154_local *local,
> > > > > > > > > > >         }
> > > > > > > > > > >
> > > > > > > > > > >         list_for_each_entry_rcu(sdata, &local->interf=
aces, list) {
> > > > > > > > > > > -               if (sdata->wpan_dev.iftype !=3D NL802=
154_IFTYPE_NODE)
> > > > > > > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL8=
02154_IFTYPE_MONITOR)
> > > > > > > > > > >                         continue; =20
> > > > > > > > > >
> > > > > > > > > > I probably get why you are doing that, but first the ov=
erall design is
> > > > > > > > > > working differently - means you should add an additiona=
l receive path
> > > > > > > > > > for the special interface type.
> > > > > > > > > >
> > > > > > > > > > Also we "discovered" before that the receive path of no=
de vs
> > > > > > > > > > coordinator is different... Where is the different hand=
ling here? I
> > > > > > > > > > don't see it, I see that NODE and COORD are the same no=
w (because that
> > > > > > > > > > is _currently_ everything else than monitor). This chan=
ge is not
> > > > > > > > > > enough and does "something" to handle in some way coord=
inator receive
> > > > > > > > > > path but there are things missing.
> > > > > > > > > >
> > > > > > > > > > 1. Changing the address filters that it signals the tra=
nsceiver it's
> > > > > > > > > > acting as coordinator
> > > > > > > > > > 2. We _should_ also have additional handling for whatev=
er the
> > > > > > > > > > additional handling what address filters are doing in m=
ac802154
> > > > > > > > > > _because_ there is hardware which doesn't have address =
filtering e.g.
> > > > > > > > > > hwsim which depend that this is working in software lik=
e other
> > > > > > > > > > transceiver hardware address filters.
> > > > > > > > > >
> > > > > > > > > > For the 2. one, I don't know if we do that even for NOD=
E right or we
> > > > > > > > > > just have the bare minimal support there... I don't ass=
ume that
> > > > > > > > > > everything is working correctly here but what I want to=
 see is a
> > > > > > > > > > separate receive path for coordinators that people can =
send patches to
> > > > > > > > > > fix it. =20
> > > > > > > > >
> > > > > > > > > Yes, we do very little differently between the two modes,=
 that's why I
> > > > > > > > > took the easy way: just changing the condition. I really =
don't see what
> > > > > > > > > I can currently add here, but I am fine changing the styl=
e to easily
> > > > > > > > > show people where to add filters for such or such interfa=
ce, but right
> > > > > > > > > now both path will look very "identical", do we agree on =
that? =20
> > > > > > > >
> > > > > > > > mostly yes, but there exists a difference and we should at =
least check
> > > > > > > > if the node receive path violates the coordinator receive p=
ath and
> > > > > > > > vice versa.
> > > > > > > > Put it in a receive_path() function and then coord_receive_=
path(),
> > > > > > > > node_receive_path() that calls the receive_path() and do the
> > > > > > > > additional filtering for coordinators, etc.
> > > > > > > >
> > > > > > > > There should be a part in the standard about "third level f=
ilter rule
> > > > > > > > if it's a coordinator".
> > > > > > > > btw: this is because the address filter on the transceiver =
needs to
> > > > > > > > have the "i am a coordinator" boolean set which is missing =
in this
> > > > > > > > series. However it depends on the transceiver filtering lev=
el and the
> > > > > > > > mac802154 receive path if we actually need to run such filt=
ering or
> > > > > > > > not. =20
> > > > > > >
> > > > > > > I must be missing some information because I can't find any p=
laces
> > > > > > > where what you suggest is described in the spec.
> > > > > > >
> > > > > > > I agree there are multiple filtering level so let's go throug=
h them one
> > > > > > > by one (6.7.2 Reception and rejection):
> > > > > > > - first level: is the checksum (FCS) valid?
> > > > > > >         yes -> goto second level
> > > > > > >         no -> drop
> > > > > > > - second level: are we in promiscuous mode?
> > > > > > >         yes -> forward to upper layers
> > > > > > >         no -> goto second level (bis)
> > > > > > > - second level (bis): are we scanning?
> > > > > > >         yes -> goto scan filtering
> > > > > > >         no -> goto third level
> > > > > > > - scan filtering: is it a beacon?
> > > > > > >         yes -> process the beacon
> > > > > > >         no -> drop
> > > > > > > - third level: is the frame valid? (type, source, destination=
, pan id,
> > > > > > >   etc)
> > > > > > >         yes -> forward to upper layers
> > > > > > >         no -> drop
> > > > > > >
> > > > > > > But none of them, as you said, is dependent on the interface =
type.
> > > > > > > There is no mention of a specific filtering operation to do i=
n all
> > > > > > > those cases when running in COORD mode. So I still don't get =
what
> > > > > > > should be included in either node_receive_path() which should=
 be
> > > > > > > different than in coord_receive_path() for now.
> > > > > > >
> > > > > > > There are, however, two situations where the interface type h=
as its
> > > > > > > importance:
> > > > > > > - Enhanced beacon requests with Enhanced beacon filter IE, wh=
ich asks
> > > > > > >   the receiving device to process/drop the request upon certa=
in
> > > > > > >   conditions (minimum LQI and/or randomness), as detailed in
> > > > > > >   7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
> > > > > > >   7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon=
 Request
> > > > > > >   command is optional for an FFD and an RFD", so this series =
was only
> > > > > > >   targeting basic beaconing for now.
> > > > > > > - In relaying mode, the destination address must not be valid=
ated
> > > > > > >   because the message needs to be re-emitted. Indeed, a recei=
ver in
> > > > > > >   relaying mode may not be the recipient. This is also option=
al and out
> > > > > > >   of the scope of this series.
> > > > > > >
> > > > > > > Right now I have the below diff, which clarifies the two path=
, without
> > > > > > > too much changes in the current code because I don't really s=
ee why it
> > > > > > > would be necessary. Unless you convince me otherwise or read =
the spec
> > > > > > > differently than I do :) What do you think?
> > > > > > > =20
> > > > > >
> > > > > > "Reception and rejection"
> > > > > >
> > > > > > third-level filtering regarding "destination address" and if the
> > > > > > device is "PAN coordinator".
> > > > > > This is, in my opinion, what the coordinator boolean tells the
> > > > > > transceiver to do on hardware when doing address filter there. =
You can
> > > > > > also read that up in datasheets of transceivers as atf86rf233, =
search
> > > > > > for I_AM_COORD. =20
> > > > >
> > > > > Oh right, I now see what you mean!
> > > > > =20
> > > > > > Whereas they use the word "PAN coordinator" not "coordinator", =
if they
> > > > > > really make a difference there at this point..., if so then the=
 kernel
> > > > > > must know if the coordinator is a pan coordinator or coordinator
> > > > > > because we need to set the address filter in kernel. =20
> > > > >
> > > > > Yes we need to make a difference, you can have several coordinato=
rs but
> > > > > a single PAN coordinator in a PAN. I think we can assume that the=
 PAN
> > > > > coordinator is the coordinator with no parent (association-wise).=
 With
> > > > > the addition of the association series, I can handle that, so I w=
ill
> > > > > create the two path as you advise, add a comment about this addit=
ional
> > > > > filter rule that we don't yet support, and finally after the
> > > > > association series add another commit to make this filtering rule=
 real.
> > > > > =20
> > > > > > =20
> > > > > > > Thanks,
> > > > > > > Miqu=C3=A8l
> > > > > > >
> > > > > > > ---
> > > > > > >
> > > > > > > --- a/net/mac802154/rx.c
> > > > > > > +++ b/net/mac802154/rx.c
> > > > > > > @@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee=
802154_local *local,
> > > > > > >         int ret;
> > > > > > >         struct ieee802154_sub_if_data *sdata;
> > > > > > >         struct ieee802154_hdr hdr;
> > > > > > > +       bool iface_found =3D false;
> > > > > > >
> > > > > > >         ret =3D ieee802154_parse_frame_start(skb, &hdr);
> > > > > > >         if (ret) {
> > > > > > > @@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ie=
ee802154_local *local,
> > > > > > >         }
> > > > > > >
> > > > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, li=
st) {
> > > > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTY=
PE_NODE)
> > > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IF=
TYPE_MONITOR)
> > > > > > >                         continue;
> > > > > > >
> > > > > > >                 if (!ieee802154_sdata_running(sdata))
> > > > > > >                         continue;
> > > > > > >
> > > > > > > +               iface_found =3D true;
> > > > > > > +               break;
> > > > > > > +       }
> > > > > > > +
> > > > > > > +       if (!iface_found) {
> > > > > > > +               kfree_skb(skb);
> > > > > > > +               return;
> > > > > > > +       }
> > > > > > > +
> > > > > > > +       /* TBD: Additional filtering is possible on NODEs and=
/or COORDINATORs */
> > > > > > > +       switch (sdata->wpan_dev.iftype) {
> > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > > +       case NL802154_IFTYPE_NODE:
> > > > > > >                 ieee802154_subif_frame(sdata, skb, &hdr);
> > > > > > > -               skb =3D NULL;
> > > > > > > +               break;
> > > > > > > +       default:
> > > > > > > +               kfree_skb(skb);
> > > > > > >                 break;
> > > > > > >         } =20
> > > > > >
> > > > > > Why do you remove the whole interface looping above and make it=
 only
> > > > > > run for one ?first found? ? =20
> > > > >
> > > > > To reduce the indentation level.
> > > > > =20
> > > > > > That code changes this behaviour and I do
> > > > > > not know why. =20
> > > > >
> > > > > The precedent code did:
> > > > > for_each_iface() {
> > > > >         if (not a node)
> > > > >                 continue;
> > > > >         if (not running)
> > > > >                 continue;
> > > > >
> > > > >         subif_frame();
> > > > >         break;
> > > > > }
> > > > >
> > > > > That final break also elected only the first running node iface.
> > > > > Otherwise it would mean that we allow the same skb to be consumed
> > > > > twice, which is wrong IMHO? =20
> > > >
> > > > no? Why is that wrong? There is a real use-case to have multiple
> > > > interfaces on one phy (or to do it in near future, I said that
> > > > multiple times). This patch does a step backwards to this. =20
> > >
> > > So we need to duplicate the skb because it automatically gets freed in
> > > the "forward to upper layer" path. Am I right? I'm fine doing so if =
=20
> >
> > What is the definition of "duplicate the skb" here.
> > =20
> > > this is the way to go, but I am interested if you can give me a real
> > > use case where having NODE+COORDINATOR on the same PHY is useful?
> > > =20
> >
> > Testing. =20
>=20
> I need to say that I really used multiple monitors at the same time on
> one phy only and I did that with hwsim to run multiple user space
> stacks. It was working and I was happy and didn't need to do a lot of
> phy creations in hwsim.

Indeed, looking at the code, you could use as many MONITOR interfaces
you needed, but only a single NODE. I've changed that to use as many
NODE and COORD that we wish.

> Most hardware can probably not run multiple
> nodes and coordinators at the same time ?yet?, _but_ there is a
> candidate which can do that and this is atusb. On atusb we have a
> co-processor that can deal with multiple address filters. People
> already asked to do something like a node which can operate on two
> pans as I remember, that would be a candidate for such a feature.

Oh nice! Yes this makes sense.

> I
> really don't want to move step backwards here and delete this thing
> which probably can be useful later. I don't know how wireless history
> dealt with it and how complicated it was to bring such a feature in to
> e.g. run multiple access points on one phy. I also see it in ethernet
> with macvlan, which is a similar feature.
>=20
> We don't need to support it, make it so that on an ifup it returns
> -EBUSY if something doesn't fit together as it currently is. We can
> later add support for it after playing around with hwsim a little bit
> more. We should at least take care that I can still run my multiple
> monitors at the same time (which is currently allowed).
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l

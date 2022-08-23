Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDA59EABC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiHWSPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiHWSPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:15:31 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C7EA1A2;
        Tue, 23 Aug 2022 09:29:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2E08924000D;
        Tue, 23 Aug 2022 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661272194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jj40USbvC2Rr9GNDMHj94juQ531fz6yeaBS6ARCKDuM=;
        b=Cx8zqDpK1QT+rnby9UXE1X+UU7YDWErYmf4YnnBMFxUBMVOG9fS6pDuzH6QFNE3/bTU2gx
        azeymH71sk7+LDzDd3mN+YzvwfQWO0BqkyjNHtPXjwWw3/pHXpurp3We2tekcgDB1f9gno
        O+pNFerRHvXOPRHr1dS64m9wmUZ6sTW8Pny1wY2yDE29bzp8VTm2j/mbMRQGHCKxQRZGwI
        oPtoMA+xyjGw03d7F8h4R9WCjzSoYbNIFglhqqEMr6OwSo7Y2ecD4zg602BcogbuKdJEAf
        9paCyUO0riewTwPv8DOS70GuU5c6V2V5f1wj9x7JqspivG+BpplXmtqTP6eTTQ==
Date:   Tue, 23 Aug 2022 18:29:50 +0200
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
Message-ID: <20220823182950.1c722e13@xps-13>
In-Reply-To: <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
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

aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:

> Hi,
>=20
> On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
> > =20
> > > Hi,
> > >
> > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > As a first strep in introducing proper PAN management and associati=
on,
> > > > we need to be able to create coordinator interfaces which might act=
 as
> > > > coordinator or PAN coordinator.
> > > >
> > > > Hence, let's add the minimum support to allow the creation of these
> > > > interfaces. This might be restrained and improved later.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  net/mac802154/iface.c | 14 ++++++++------
> > > >  net/mac802154/rx.c    |  2 +-
> > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > --- a/net/mac802154/iface.c
> > > > +++ b/net/mac802154/iface.c
> > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struct ieee=
802154_sub_if_data *sdata,
> > > >                 if (nsdata !=3D sdata && ieee802154_sdata_running(n=
sdata)) {
> > > >                         int ret;
> > > >
> > > > -                       /* TODO currently we don't support multiple=
 node types
> > > > -                        * we need to run skb_clone at rx path. Che=
ck if there
> > > > -                        * exist really an use case if we need to s=
upport
> > > > -                        * multiple node types at the same time.
> > > > +                       /* TODO currently we don't support multiple=
 node/coord
> > > > +                        * types we need to run skb_clone at rx pat=
h. Check if
> > > > +                        * there exist really an use case if we nee=
d to support
> > > > +                        * multiple node/coord types at the same ti=
me.
> > > >                          */
> > > > -                       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE=
_NODE &&
> > > > -                           nsdata->wpan_dev.iftype =3D=3D NL802154=
_IFTYPE_NODE)
> > > > +                       if (wpan_dev->iftype !=3D NL802154_IFTYPE_M=
ONITOR &&
> > > > +                           nsdata->wpan_dev.iftype !=3D NL802154_I=
FTYPE_MONITOR)
> > > >                                 return -EBUSY;
> > > >
> > > >                         /* check all phy mac sublayer settings are =
the same.
> > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if=
_data *sdata,
> > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_ADDR_BROADC=
AST);
> > > >
> > > >         switch (type) {
> > > > +       case NL802154_IFTYPE_COORD:
> > > >         case NL802154_IFTYPE_NODE:
> > > >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> > > >                                         sdata->dev->dev_addr);
> > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_local *loca=
l, const char *name,
> > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > >                                 &local->hw.phy->perm_extended_addr);
> > > >         switch (type) {
> > > > +       case NL802154_IFTYPE_COORD:
> > > >         case NL802154_IFTYPE_NODE:
> > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > >                 if (ieee802154_is_valid_extended_unicast_addr(exten=
ded_addr)) {
> > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > index b8ce84618a55..39459d8d787a 100644
> > > > --- a/net/mac802154/rx.c
> > > > +++ b/net/mac802154/rx.c
> > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ieee802154=
_local *local,
> > > >         }
> > > >
> > > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NOD=
E)
> > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE_M=
ONITOR)
> > > >                         continue; =20
> > >
> > > I probably get why you are doing that, but first the overall design is
> > > working differently - means you should add an additional receive path
> > > for the special interface type.
> > >
> > > Also we "discovered" before that the receive path of node vs
> > > coordinator is different... Where is the different handling here? I
> > > don't see it, I see that NODE and COORD are the same now (because that
> > > is _currently_ everything else than monitor). This change is not
> > > enough and does "something" to handle in some way coordinator receive
> > > path but there are things missing.
> > >
> > > 1. Changing the address filters that it signals the transceiver it's
> > > acting as coordinator
> > > 2. We _should_ also have additional handling for whatever the
> > > additional handling what address filters are doing in mac802154
> > > _because_ there is hardware which doesn't have address filtering e.g.
> > > hwsim which depend that this is working in software like other
> > > transceiver hardware address filters.
> > >
> > > For the 2. one, I don't know if we do that even for NODE right or we
> > > just have the bare minimal support there... I don't assume that
> > > everything is working correctly here but what I want to see is a
> > > separate receive path for coordinators that people can send patches to
> > > fix it. =20
> >
> > Yes, we do very little differently between the two modes, that's why I
> > took the easy way: just changing the condition. I really don't see what
> > I can currently add here, but I am fine changing the style to easily
> > show people where to add filters for such or such interface, but right
> > now both path will look very "identical", do we agree on that? =20
>=20
> mostly yes, but there exists a difference and we should at least check
> if the node receive path violates the coordinator receive path and
> vice versa.
> Put it in a receive_path() function and then coord_receive_path(),
> node_receive_path() that calls the receive_path() and do the
> additional filtering for coordinators, etc.
>=20
> There should be a part in the standard about "third level filter rule
> if it's a coordinator".
> btw: this is because the address filter on the transceiver needs to
> have the "i am a coordinator" boolean set which is missing in this
> series. However it depends on the transceiver filtering level and the
> mac802154 receive path if we actually need to run such filtering or
> not.

I must be missing some information because I can't find any places
where what you suggest is described in the spec.

I agree there are multiple filtering level so let's go through them one
by one (6.7.2 Reception and rejection):
- first level: is the checksum (FCS) valid?
	yes -> goto second level
	no -> drop
- second level: are we in promiscuous mode?
	yes -> forward to upper layers
	no -> goto second level (bis)
- second level (bis): are we scanning?
	yes -> goto scan filtering
	no -> goto third level
- scan filtering: is it a beacon?
	yes -> process the beacon
	no -> drop
- third level: is the frame valid? (type, source, destination, pan id,
  etc)
	yes -> forward to upper layers
	no -> drop

But none of them, as you said, is dependent on the interface type.
There is no mention of a specific filtering operation to do in all
those cases when running in COORD mode. So I still don't get what
should be included in either node_receive_path() which should be
different than in coord_receive_path() for now.

There are, however, two situations where the interface type has its
importance:
- Enhanced beacon requests with Enhanced beacon filter IE, which asks
  the receiving device to process/drop the request upon certain
  conditions (minimum LQI and/or randomness), as detailed in
  7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
  7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon Request
  command is optional for an FFD and an RFD", so this series was only
  targeting basic beaconing for now.
- In relaying mode, the destination address must not be validated
  because the message needs to be re-emitted. Indeed, a receiver in
  relaying mode may not be the recipient. This is also optional and out
  of the scope of this series.

Right now I have the below diff, which clarifies the two path, without
too much changes in the current code because I don't really see why it
would be necessary. Unless you convince me otherwise or read the spec
differently than I do :) What do you think?

Thanks,
Miqu=C3=A8l

---

--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *=
local,
        int ret;
        struct ieee802154_sub_if_data *sdata;
        struct ieee802154_hdr hdr;
+       bool iface_found =3D false;
=20
        ret =3D ieee802154_parse_frame_start(skb, &hdr);
        if (ret) {
@@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ieee802154_local=
 *local,
        }
=20
        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NODE)
+               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE_MONITOR)
                        continue;
=20
                if (!ieee802154_sdata_running(sdata))
                        continue;
=20
+               iface_found =3D true;
+               break;
+       }
+
+       if (!iface_found) {
+               kfree_skb(skb);
+               return;
+       }
+
+       /* TBD: Additional filtering is possible on NODEs and/or COORDINATO=
Rs */
+       switch (sdata->wpan_dev.iftype) {
+       case NL802154_IFTYPE_COORD:
+       case NL802154_IFTYPE_NODE:
                ieee802154_subif_frame(sdata, skb, &hdr);
-               skb =3D NULL;
+               break;
+       default:
+               kfree_skb(skb);
                break;
        }
-
-       kfree_skb(skb);
 }
=20
 static void

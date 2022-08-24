Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAD05A035B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiHXVn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiHXVn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:43:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA64C65658
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661377404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycJ9A403JTtScjaAi5V/tEfKc45b8tpq4GtD6hzwfJo=;
        b=WqQw5i7e5lqyR7Om2BARrVb3NYkwJtb9WE6Vpx8XHyDJEVyTdd9xpvSxqLoUKITqbuWH3W
        RlcOY2dAbnT9M1D92Mg6NerpiGa8snf6Yn+1EptDoaQN+cW/lQGh103PGRPrhk8lxtpFKf
        t47B50QtCl10Uqwvfaj54V7Sp+xafdE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-LfmMc_NNP-GS84txXgKRaw-1; Wed, 24 Aug 2022 17:43:23 -0400
X-MC-Unique: LfmMc_NNP-GS84txXgKRaw-1
Received: by mail-qv1-f70.google.com with SMTP id od16-20020a0562142f1000b00496e2ea7934so6353074qvb.13
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=ycJ9A403JTtScjaAi5V/tEfKc45b8tpq4GtD6hzwfJo=;
        b=oaShdWoWx4vaQjdKv1RskrKa+PW7SScBylIKHM49h7rMGppGMdSlOKSf0vJA+Z4YXT
         OZujOUrYAQVssxkf87B6bL0UOhFeK5jayD5Wnz+TcYU4fmWRXuQUaT+oJHlSB8v925fc
         +ZsvICffDSTpR0oFVsoPIGdBGbeAvqv0lpunZEQslR+SskYub8kI/ElLhrSy5dcyPYae
         pOZXcBJgpWHIdQYppK/EyWXOHLzJt/S/qTIf6sh0t3lufgQd02cRbUZtuX8QeFTAhbv2
         3jkdwKv3cAYMPJTkN6SC+2IpVO6bfwZarUCrZy+uHricl5opYDyJHr3nHKcmXilgZGWR
         vGcA==
X-Gm-Message-State: ACgBeo2/LINhnUO1/Ba7xFO2xub/vhTI3r8pDntEUx3nG7Hq7ZLio6Kv
        KKb+u/Q8OmlATl1DbCep+HNjdr18hgVM9RJx7De/edSM9Etzb5JhXYVhyBs/FTe3LuD0thaYDrl
        rMxcKmtFmmolEliCaP6tTIXEM0ZwwzKdR
X-Received: by 2002:a05:6214:23c7:b0:492:2ada:11d7 with SMTP id hr7-20020a05621423c700b004922ada11d7mr1013058qvb.116.1661377403074;
        Wed, 24 Aug 2022 14:43:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4vfMS3R1VOuPw66lOwg7gJF/vi2mEPvxypfudOc9ffglxgUbSToosdryZwxYzo0STl/Ce5HH0QjC3qc4hODOc=
X-Received: by 2002:a05:6214:23c7:b0:492:2ada:11d7 with SMTP id
 hr7-20020a05621423c700b004922ada11d7mr1013034qvb.116.1661377402762; Wed, 24
 Aug 2022 14:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824093547.16f05d15@xps-13>
In-Reply-To: <20220824093547.16f05d15@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 24 Aug 2022 17:43:11 -0400
Message-ID: <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 3:35 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 23 Aug 2022 17:44:52 -0400:
>
> > Hi,
> >
> > On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
> > > > >
> > > > > Hi Alexander,
> > > > >
> > > > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bo=
otlin.com> wrote:
> > > > > > >
> > > > > > > As a first strep in introducing proper PAN management and ass=
ociation,
> > > > > > > we need to be able to create coordinator interfaces which mig=
ht act as
> > > > > > > coordinator or PAN coordinator.
> > > > > > >
> > > > > > > Hence, let's add the minimum support to allow the creation of=
 these
> > > > > > > interfaces. This might be restrained and improved later.
> > > > > > >
> > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > > ---
> > > > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > > > >  net/mac802154/rx.c    |  2 +-
> > > > > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > > > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > > > > --- a/net/mac802154/iface.c
> > > > > > > +++ b/net/mac802154/iface.c
> > > > > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struc=
t ieee802154_sub_if_data *sdata,
> > > > > > >                 if (nsdata !=3D sdata && ieee802154_sdata_run=
ning(nsdata)) {
> > > > > > >                         int ret;
> > > > > > >
> > > > > > > -                       /* TODO currently we don't support mu=
ltiple node types
> > > > > > > -                        * we need to run skb_clone at rx pat=
h. Check if there
> > > > > > > -                        * exist really an use case if we nee=
d to support
> > > > > > > -                        * multiple node types at the same ti=
me.
> > > > > > > +                       /* TODO currently we don't support mu=
ltiple node/coord
> > > > > > > +                        * types we need to run skb_clone at =
rx path. Check if
> > > > > > > +                        * there exist really an use case if =
we need to support
> > > > > > > +                        * multiple node/coord types at the s=
ame time.
> > > > > > >                          */
> > > > > > > -                       if (wpan_dev->iftype =3D=3D NL802154_=
IFTYPE_NODE &&
> > > > > > > -                           nsdata->wpan_dev.iftype =3D=3D NL=
802154_IFTYPE_NODE)
> > > > > > > +                       if (wpan_dev->iftype !=3D NL802154_IF=
TYPE_MONITOR &&
> > > > > > > +                           nsdata->wpan_dev.iftype !=3D NL80=
2154_IFTYPE_MONITOR)
> > > > > > >                                 return -EBUSY;
> > > > > > >
> > > > > > >                         /* check all phy mac sublayer setting=
s are the same.
> > > > > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_=
sub_if_data *sdata,
> > > > > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_ADDR_=
BROADCAST);
> > > > > > >
> > > > > > >         switch (type) {
> > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > >                 ieee802154_be64_to_le64(&wpan_dev->extended_a=
ddr,
> > > > > > >                                         sdata->dev->dev_addr)=
;
> > > > > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_local=
 *local, const char *name,
> > > > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > > > >                                 &local->hw.phy->perm_extended=
_addr);
> > > > > > >         switch (type) {
> > > > > > > +       case NL802154_IFTYPE_COORD:
> > > > > > >         case NL802154_IFTYPE_NODE:
> > > > > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > > > > >                 if (ieee802154_is_valid_extended_unicast_addr=
(extended_addr)) {
> > > > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > > > index b8ce84618a55..39459d8d787a 100644
> > > > > > > --- a/net/mac802154/rx.c
> > > > > > > +++ b/net/mac802154/rx.c
> > > > > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ieee=
802154_local *local,
> > > > > > >         }
> > > > > > >
> > > > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, li=
st) {
> > > > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTY=
PE_NODE)
> > > > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IF=
TYPE_MONITOR)
> > > > > > >                         continue;
> > > > > >
> > > > > > I probably get why you are doing that, but first the overall de=
sign is
> > > > > > working differently - means you should add an additional receiv=
e path
> > > > > > for the special interface type.
> > > > > >
> > > > > > Also we "discovered" before that the receive path of node vs
> > > > > > coordinator is different... Where is the different handling her=
e? I
> > > > > > don't see it, I see that NODE and COORD are the same now (becau=
se that
> > > > > > is _currently_ everything else than monitor). This change is no=
t
> > > > > > enough and does "something" to handle in some way coordinator r=
eceive
> > > > > > path but there are things missing.
> > > > > >
> > > > > > 1. Changing the address filters that it signals the transceiver=
 it's
> > > > > > acting as coordinator
> > > > > > 2. We _should_ also have additional handling for whatever the
> > > > > > additional handling what address filters are doing in mac802154
> > > > > > _because_ there is hardware which doesn't have address filterin=
g e.g.
> > > > > > hwsim which depend that this is working in software like other
> > > > > > transceiver hardware address filters.
> > > > > >
> > > > > > For the 2. one, I don't know if we do that even for NODE right =
or we
> > > > > > just have the bare minimal support there... I don't assume that
> > > > > > everything is working correctly here but what I want to see is =
a
> > > > > > separate receive path for coordinators that people can send pat=
ches to
> > > > > > fix it.
> > > > >
> > > > > Yes, we do very little differently between the two modes, that's =
why I
> > > > > took the easy way: just changing the condition. I really don't se=
e what
> > > > > I can currently add here, but I am fine changing the style to eas=
ily
> > > > > show people where to add filters for such or such interface, but =
right
> > > > > now both path will look very "identical", do we agree on that?
> > > >
> > > > mostly yes, but there exists a difference and we should at least ch=
eck
> > > > if the node receive path violates the coordinator receive path and
> > > > vice versa.
> > > > Put it in a receive_path() function and then coord_receive_path(),
> > > > node_receive_path() that calls the receive_path() and do the
> > > > additional filtering for coordinators, etc.
> > > >
> > > > There should be a part in the standard about "third level filter ru=
le
> > > > if it's a coordinator".
> > > > btw: this is because the address filter on the transceiver needs to
> > > > have the "i am a coordinator" boolean set which is missing in this
> > > > series. However it depends on the transceiver filtering level and t=
he
> > > > mac802154 receive path if we actually need to run such filtering or
> > > > not.
> > >
> > > I must be missing some information because I can't find any places
> > > where what you suggest is described in the spec.
> > >
> > > I agree there are multiple filtering level so let's go through them o=
ne
> > > by one (6.7.2 Reception and rejection):
> > > - first level: is the checksum (FCS) valid?
> > >         yes -> goto second level
> > >         no -> drop
> > > - second level: are we in promiscuous mode?
> > >         yes -> forward to upper layers
> > >         no -> goto second level (bis)
> > > - second level (bis): are we scanning?
> > >         yes -> goto scan filtering
> > >         no -> goto third level
> > > - scan filtering: is it a beacon?
> > >         yes -> process the beacon
> > >         no -> drop
> > > - third level: is the frame valid? (type, source, destination, pan id=
,
> > >   etc)
> > >         yes -> forward to upper layers
> > >         no -> drop
> > >
> > > But none of them, as you said, is dependent on the interface type.
> > > There is no mention of a specific filtering operation to do in all
> > > those cases when running in COORD mode. So I still don't get what
> > > should be included in either node_receive_path() which should be
> > > different than in coord_receive_path() for now.
> > >
> > > There are, however, two situations where the interface type has its
> > > importance:
> > > - Enhanced beacon requests with Enhanced beacon filter IE, which asks
> > >   the receiving device to process/drop the request upon certain
> > >   conditions (minimum LQI and/or randomness), as detailed in
> > >   7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
> > >   7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon Request
> > >   command is optional for an FFD and an RFD", so this series was only
> > >   targeting basic beaconing for now.
> > > - In relaying mode, the destination address must not be validated
> > >   because the message needs to be re-emitted. Indeed, a receiver in
> > >   relaying mode may not be the recipient. This is also optional and o=
ut
> > >   of the scope of this series.
> > >
> > > Right now I have the below diff, which clarifies the two path, withou=
t
> > > too much changes in the current code because I don't really see why i=
t
> > > would be necessary. Unless you convince me otherwise or read the spec
> > > differently than I do :) What do you think?
> > >
> >
> > "Reception and rejection"
> >
> > third-level filtering regarding "destination address" and if the
> > device is "PAN coordinator".
> > This is, in my opinion, what the coordinator boolean tells the
> > transceiver to do on hardware when doing address filter there. You can
> > also read that up in datasheets of transceivers as atf86rf233, search
> > for I_AM_COORD.
>
> Oh right, I now see what you mean!
>
> > Whereas they use the word "PAN coordinator" not "coordinator", if they
> > really make a difference there at this point..., if so then the kernel
> > must know if the coordinator is a pan coordinator or coordinator
> > because we need to set the address filter in kernel.
>
> Yes we need to make a difference, you can have several coordinators but
> a single PAN coordinator in a PAN. I think we can assume that the PAN
> coordinator is the coordinator with no parent (association-wise). With
> the addition of the association series, I can handle that, so I will
> create the two path as you advise, add a comment about this additional
> filter rule that we don't yet support, and finally after the
> association series add another commit to make this filtering rule real.
>
> >
> > > Thanks,
> > > Miqu=C3=A8l
> > >
> > > ---
> > >
> > > --- a/net/mac802154/rx.c
> > > +++ b/net/mac802154/rx.c
> > > @@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_l=
ocal *local,
> > >         int ret;
> > >         struct ieee802154_sub_if_data *sdata;
> > >         struct ieee802154_hdr hdr;
> > > +       bool iface_found =3D false;
> > >
> > >         ret =3D ieee802154_parse_frame_start(skb, &hdr);
> > >         if (ret) {
> > > @@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ieee802154=
_local *local,
> > >         }
> > >
> > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NODE)
> > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE_MON=
ITOR)
> > >                         continue;
> > >
> > >                 if (!ieee802154_sdata_running(sdata))
> > >                         continue;
> > >
> > > +               iface_found =3D true;
> > > +               break;
> > > +       }
> > > +
> > > +       if (!iface_found) {
> > > +               kfree_skb(skb);
> > > +               return;
> > > +       }
> > > +
> > > +       /* TBD: Additional filtering is possible on NODEs and/or COOR=
DINATORs */
> > > +       switch (sdata->wpan_dev.iftype) {
> > > +       case NL802154_IFTYPE_COORD:
> > > +       case NL802154_IFTYPE_NODE:
> > >                 ieee802154_subif_frame(sdata, skb, &hdr);
> > > -               skb =3D NULL;
> > > +               break;
> > > +       default:
> > > +               kfree_skb(skb);
> > >                 break;
> > >         }
> >
> > Why do you remove the whole interface looping above and make it only
> > run for one ?first found? ?
>
> To reduce the indentation level.
>
> > That code changes this behaviour and I do
> > not know why.
>
> The precedent code did:
> for_each_iface() {
>         if (not a node)
>                 continue;
>         if (not running)
>                 continue;
>
>         subif_frame();
>         break;
> }
>
> That final break also elected only the first running node iface.
> Otherwise it would mean that we allow the same skb to be consumed
> twice, which is wrong IMHO?

no? Why is that wrong? There is a real use-case to have multiple
interfaces on one phy (or to do it in near future, I said that
multiple times). This patch does a step backwards to this.

- Alex


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F81D5A1E34
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiHZBfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiHZBfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:35:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9686928E1E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 18:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661477718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+ja7am3QeRHI6I33cst2TOCn2FBIIdrvDrYrb42nMI=;
        b=XKGWG7ChgSewrM0fkY3B1RZFF0u6nikJbLs7grWo4w+aPR9g9pa8Undq011R46AEaue59d
        DZFtntJEVZh2n7Y8va4C7kZm7/+NdazAIc53Uo73dTkShs+wViEfFziZJ+zWqnr20b7XzE
        QBkJVOejCI2rr8c8MNM9Gdp1qCg41Rk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-112-qlMJVrjdOX-ScTVtSD_T8Q-1; Thu, 25 Aug 2022 21:35:17 -0400
X-MC-Unique: qlMJVrjdOX-ScTVtSD_T8Q-1
Received: by mail-qk1-f199.google.com with SMTP id h20-20020a05620a245400b006bb0c6074baso181662qkn.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 18:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=D+ja7am3QeRHI6I33cst2TOCn2FBIIdrvDrYrb42nMI=;
        b=ubOBvpkGIC0FTcknIvh6X6InNYgyMGqS+zhcz8GiEVhsHDZ6bA2qOVuNAkHo7bLE8K
         LmprsFTlA9MYkSn07olLrvek7i3T9zw+D/r2GJfouvu+wWAYYn1pneyq39f+WDI6zjDP
         fkl9zCNdBZexaCozdk6gx/Q9ttczCMfviS3FwkWblw+RxfwzNJAgSqqNui6e7DPyq/bv
         w7ILuEyG2/lfxAn3IKXkYQerQAd7m6J4mvo6VAD2f/O9DZfazmrNKccMeVwRWcIxo43p
         wQSdunHXhlHHC0Fj74Ht3vzWzzR54s718ahEDUpbCOl7jxfljWT72OCgvKg4fkXYC5/h
         yGmA==
X-Gm-Message-State: ACgBeo26MAXrflNcKqdnZ8WMPxIy2mupZ3Q2pauXgl3D12goPaqvdEOq
        dWuoodCqKDFLnpak/zUODdvpKmaXWZ/0A2GvSHS6pR4yoMKlw5sCg1URwMVZALUiqi9xi2JTR6E
        z8K/wIF0UwznbH9zc3ZILA9V4mkW71B0j
X-Received: by 2002:ae9:e70f:0:b0:6bb:eb30:4916 with SMTP id m15-20020ae9e70f000000b006bbeb304916mr5128619qka.691.1661477716976;
        Thu, 25 Aug 2022 18:35:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4dvlJkz1vC2Hu8SO52FlMk78H4r60AwPa83vIOplBiO8ghA8N+ih9P7REhqNlQtBzwJM/IIUL92PuTKfEY8Gk=
X-Received: by 2002:ae9:e70f:0:b0:6bb:eb30:4916 with SMTP id
 m15-20020ae9e70f000000b006bbeb304916mr5128603qka.691.1661477716656; Thu, 25
 Aug 2022 18:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824093547.16f05d15@xps-13> <CAK-6q+gqX8w+WEgSk2J9FOdrFJPvqJOsgmaY4wOu=siRszBujA@mail.gmail.com>
 <20220825104035.11806a67@xps-13> <CAK-6q+hxSpw1yJR5H5D6gy5gGdm6Qa3VzyjZXA45KFQfVVqwFw@mail.gmail.com>
In-Reply-To: <CAK-6q+hxSpw1yJR5H5D6gy5gGdm6Qa3VzyjZXA45KFQfVVqwFw@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 25 Aug 2022 21:35:05 -0400
Message-ID: <CAK-6q+jbBg4kCh88Oz7mBa0RBBX_+cqqoPjT3POEjbQKX1ZDKw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Aug 25, 2022 at 8:51 PM Alexander Aring <aahringo@redhat.com> wrote=
:
>
> Hi,
>
> On Thu, Aug 25, 2022 at 4:41 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:43:11 -0400:
> >
> > > On Wed, Aug 24, 2022 at 3:35 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 17:44:52 -0400:
> > > >
> > > > > Hi,
> > > > >
> > > > > On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
> > > > > <miquel.raynal@bootlin.com> wrote:
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
> > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@=
bootlin.com> wrote:
> > > > > > > >
> > > > > > > > Hi Alexander,
> > > > > > > >
> > > > > > > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400=
:
> > > > > > > >
> > > > > > > > > Hi,
> > > > > > > > >
> > > > > > > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.ray=
nal@bootlin.com> wrote:
> > > > > > > > > >
> > > > > > > > > > As a first strep in introducing proper PAN management a=
nd association,
> > > > > > > > > > we need to be able to create coordinator interfaces whi=
ch might act as
> > > > > > > > > > coordinator or PAN coordinator.
> > > > > > > > > >
> > > > > > > > > > Hence, let's add the minimum support to allow the creat=
ion of these
> > > > > > > > > > interfaces. This might be restrained and improved later=
.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com=
>
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
> > > > > > > > > >                         continue;
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
> > > > > > > > > fix it.
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
at?
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
> > > > > > > not.
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
> > > > > > should be included in either node_receive_path() which should b=
e
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
> > > > > >
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
> > > > > for I_AM_COORD.
> > > >
> > > > Oh right, I now see what you mean!
> > > >
> > > > > Whereas they use the word "PAN coordinator" not "coordinator", if=
 they
> > > > > really make a difference there at this point..., if so then the k=
ernel
> > > > > must know if the coordinator is a pan coordinator or coordinator
> > > > > because we need to set the address filter in kernel.
> > > >
> > > > Yes we need to make a difference, you can have several coordinators=
 but
> > > > a single PAN coordinator in a PAN. I think we can assume that the P=
AN
> > > > coordinator is the coordinator with no parent (association-wise). W=
ith
> > > > the addition of the association series, I can handle that, so I wil=
l
> > > > create the two path as you advise, add a comment about this additio=
nal
> > > > filter rule that we don't yet support, and finally after the
> > > > association series add another commit to make this filtering rule r=
eal.
> > > >
> > > > >
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
> > > > > >         }
> > > > >
> > > > > Why do you remove the whole interface looping above and make it o=
nly
> > > > > run for one ?first found? ?
> > > >
> > > > To reduce the indentation level.
> > > >
> > > > > That code changes this behaviour and I do
> > > > > not know why.
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
> > > > twice, which is wrong IMHO?
> > >
> > > no? Why is that wrong? There is a real use-case to have multiple
> > > interfaces on one phy (or to do it in near future, I said that
> > > multiple times). This patch does a step backwards to this.
> >
> > So we need to duplicate the skb because it automatically gets freed in
> > the "forward to upper layer" path. Am I right? I'm fine doing so if
>
> What is the definition of "duplicate the skb" here.
>
> > this is the way to go, but I am interested if you can give me a real
> > use case where having NODE+COORDINATOR on the same PHY is useful?
> >
>
> Testing.

I need to say that I really used multiple monitors at the same time on
one phy only and I did that with hwsim to run multiple user space
stacks. It was working and I was happy and didn't need to do a lot of
phy creations in hwsim. Most hardware can probably not run multiple
nodes and coordinators at the same time ?yet?, _but_ there is a
candidate which can do that and this is atusb. On atusb we have a
co-processor that can deal with multiple address filters. People
already asked to do something like a node which can operate on two
pans as I remember, that would be a candidate for such a feature. I
really don't want to move step backwards here and delete this thing
which probably can be useful later. I don't know how wireless history
dealt with it and how complicated it was to bring such a feature in to
e.g. run multiple access points on one phy. I also see it in ethernet
with macvlan, which is a similar feature.

We don't need to support it, make it so that on an ifup it returns
-EBUSY if something doesn't fit together as it currently is. We can
later add support for it after playing around with hwsim a little bit
more. We should at least take care that I can still run my multiple
monitors at the same time (which is currently allowed).

- Alex


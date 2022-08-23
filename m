Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61E59EE5F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiHWVpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiHWVpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:45:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C885809A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661291105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bT110IhY/YJPaBMBiiGVAkizzsbfN0QFKvvZvwcCihc=;
        b=SiOjUo9m+ycuGBdQBE05pjn3dWDimQC4684id3tGwIaeAzL8/na+cTsl6EZP0+l2wf4dz9
        Jqp8hMh2qj0ZEv7CR5wZL5Nz9MB4UgEUjTqoxRAS0rjwPigXZEvO+XlDW2LbqryjnRl8G1
        sn3yOYz3dy80N51uBZNOviWRGWIxDDA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-220-GompFc32NqmSRoMfMyw2oA-1; Tue, 23 Aug 2022 17:45:04 -0400
X-MC-Unique: GompFc32NqmSRoMfMyw2oA-1
Received: by mail-qt1-f198.google.com with SMTP id ff27-20020a05622a4d9b00b0034306b77c08so11465972qtb.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=bT110IhY/YJPaBMBiiGVAkizzsbfN0QFKvvZvwcCihc=;
        b=SPflKR4y+MVFnTZIuOdAFjOgFTh+17p5w+fcs1meJZZP2Fz5uVytUO0hcaHfdzB6NN
         SqX46YG/ZAnf0dqmSODwsZNEEAAlCd762S0/Iuhz4gVgHsTZ/YuQ0AmHEK51NZnNd8q9
         RY7MVKIlUoGLacyfCDv5gXMUv6L9nbMPHShFj6AGWGjGLRJx4f9uHn1tGDD8jatigmxF
         +9aQ1HQLHeYMp6Z14RedrbxLWYjdBR/EmjUtoFC+yP9PmCZkTcSU62waRZIYk3+eXHeg
         8265JyHljLY2SV3IBOdxhytMxnEffmcbMC2BrCmtM6fgX9lWg5mRc812RvDRBZq+gIxr
         BsuA==
X-Gm-Message-State: ACgBeo0MiXKupA0bCG5G0Y5DJHVmdLL0slojmzhyDocipQ6KjtwtzZaQ
        kz6xb3tTNO7wX4uxSWoYBz2Zz592RbV2gKbJDiL13ENfdbhIgYDONXH+iYpUwREJ3kTRNlv7B6J
        cGPAGavv83J8qv7+0G0XHhK+wotd9vww0
X-Received: by 2002:a05:6214:2462:b0:496:2772:3211 with SMTP id im2-20020a056214246200b0049627723211mr21692472qvb.28.1661291103611;
        Tue, 23 Aug 2022 14:45:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4WgNCkHAj5V8PuusWjRYLbyfUnzomM1ClG4wzfWEduGB/5kNFzvwl8aC4BuDjwfAeuL3u+BLHA4Na9h9LVOLI=
X-Received: by 2002:a05:6214:2462:b0:496:2772:3211 with SMTP id
 im2-20020a056214246200b0049627723211mr21692460qvb.28.1661291103362; Tue, 23
 Aug 2022 14:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13>
In-Reply-To: <20220823182950.1c722e13@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 23 Aug 2022 17:44:52 -0400
Message-ID: <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
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

On Tue, Aug 23, 2022 at 12:29 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 23 Aug 2022 08:33:30 -0400:
>
> > Hi,
> >
> > On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
> > > > >
> > > > > As a first strep in introducing proper PAN management and associa=
tion,
> > > > > we need to be able to create coordinator interfaces which might a=
ct as
> > > > > coordinator or PAN coordinator.
> > > > >
> > > > > Hence, let's add the minimum support to allow the creation of the=
se
> > > > > interfaces. This might be restrained and improved later.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > >  net/mac802154/rx.c    |  2 +-
> > > > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > > > index 500ed1b81250..7ac0c5685d3f 100644
> > > > > --- a/net/mac802154/iface.c
> > > > > +++ b/net/mac802154/iface.c
> > > > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struct ie=
ee802154_sub_if_data *sdata,
> > > > >                 if (nsdata !=3D sdata && ieee802154_sdata_running=
(nsdata)) {
> > > > >                         int ret;
> > > > >
> > > > > -                       /* TODO currently we don't support multip=
le node types
> > > > > -                        * we need to run skb_clone at rx path. C=
heck if there
> > > > > -                        * exist really an use case if we need to=
 support
> > > > > -                        * multiple node types at the same time.
> > > > > +                       /* TODO currently we don't support multip=
le node/coord
> > > > > +                        * types we need to run skb_clone at rx p=
ath. Check if
> > > > > +                        * there exist really an use case if we n=
eed to support
> > > > > +                        * multiple node/coord types at the same =
time.
> > > > >                          */
> > > > > -                       if (wpan_dev->iftype =3D=3D NL802154_IFTY=
PE_NODE &&
> > > > > -                           nsdata->wpan_dev.iftype =3D=3D NL8021=
54_IFTYPE_NODE)
> > > > > +                       if (wpan_dev->iftype !=3D NL802154_IFTYPE=
_MONITOR &&
> > > > > +                           nsdata->wpan_dev.iftype !=3D NL802154=
_IFTYPE_MONITOR)
> > > > >                                 return -EBUSY;
> > > > >
> > > > >                         /* check all phy mac sublayer settings ar=
e the same.
> > > > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_=
if_data *sdata,
> > > > >         wpan_dev->short_addr =3D cpu_to_le16(IEEE802154_ADDR_BROA=
DCAST);
> > > > >
> > > > >         switch (type) {
> > > > > +       case NL802154_IFTYPE_COORD:
> > > > >         case NL802154_IFTYPE_NODE:
> > > > >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> > > > >                                         sdata->dev->dev_addr);
> > > > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_local *lo=
cal, const char *name,
> > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > >                                 &local->hw.phy->perm_extended_add=
r);
> > > > >         switch (type) {
> > > > > +       case NL802154_IFTYPE_COORD:
> > > > >         case NL802154_IFTYPE_NODE:
> > > > >                 ndev->type =3D ARPHRD_IEEE802154;
> > > > >                 if (ieee802154_is_valid_extended_unicast_addr(ext=
ended_addr)) {
> > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > index b8ce84618a55..39459d8d787a 100644
> > > > > --- a/net/mac802154/rx.c
> > > > > +++ b/net/mac802154/rx.c
> > > > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ieee8021=
54_local *local,
> > > > >         }
> > > > >
> > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) =
{
> > > > > -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_N=
ODE)
> > > > > +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE=
_MONITOR)
> > > > >                         continue;
> > > >
> > > > I probably get why you are doing that, but first the overall design=
 is
> > > > working differently - means you should add an additional receive pa=
th
> > > > for the special interface type.
> > > >
> > > > Also we "discovered" before that the receive path of node vs
> > > > coordinator is different... Where is the different handling here? I
> > > > don't see it, I see that NODE and COORD are the same now (because t=
hat
> > > > is _currently_ everything else than monitor). This change is not
> > > > enough and does "something" to handle in some way coordinator recei=
ve
> > > > path but there are things missing.
> > > >
> > > > 1. Changing the address filters that it signals the transceiver it'=
s
> > > > acting as coordinator
> > > > 2. We _should_ also have additional handling for whatever the
> > > > additional handling what address filters are doing in mac802154
> > > > _because_ there is hardware which doesn't have address filtering e.=
g.
> > > > hwsim which depend that this is working in software like other
> > > > transceiver hardware address filters.
> > > >
> > > > For the 2. one, I don't know if we do that even for NODE right or w=
e
> > > > just have the bare minimal support there... I don't assume that
> > > > everything is working correctly here but what I want to see is a
> > > > separate receive path for coordinators that people can send patches=
 to
> > > > fix it.
> > >
> > > Yes, we do very little differently between the two modes, that's why =
I
> > > took the easy way: just changing the condition. I really don't see wh=
at
> > > I can currently add here, but I am fine changing the style to easily
> > > show people where to add filters for such or such interface, but righ=
t
> > > now both path will look very "identical", do we agree on that?
> >
> > mostly yes, but there exists a difference and we should at least check
> > if the node receive path violates the coordinator receive path and
> > vice versa.
> > Put it in a receive_path() function and then coord_receive_path(),
> > node_receive_path() that calls the receive_path() and do the
> > additional filtering for coordinators, etc.
> >
> > There should be a part in the standard about "third level filter rule
> > if it's a coordinator".
> > btw: this is because the address filter on the transceiver needs to
> > have the "i am a coordinator" boolean set which is missing in this
> > series. However it depends on the transceiver filtering level and the
> > mac802154 receive path if we actually need to run such filtering or
> > not.
>
> I must be missing some information because I can't find any places
> where what you suggest is described in the spec.
>
> I agree there are multiple filtering level so let's go through them one
> by one (6.7.2 Reception and rejection):
> - first level: is the checksum (FCS) valid?
>         yes -> goto second level
>         no -> drop
> - second level: are we in promiscuous mode?
>         yes -> forward to upper layers
>         no -> goto second level (bis)
> - second level (bis): are we scanning?
>         yes -> goto scan filtering
>         no -> goto third level
> - scan filtering: is it a beacon?
>         yes -> process the beacon
>         no -> drop
> - third level: is the frame valid? (type, source, destination, pan id,
>   etc)
>         yes -> forward to upper layers
>         no -> drop
>
> But none of them, as you said, is dependent on the interface type.
> There is no mention of a specific filtering operation to do in all
> those cases when running in COORD mode. So I still don't get what
> should be included in either node_receive_path() which should be
> different than in coord_receive_path() for now.
>
> There are, however, two situations where the interface type has its
> importance:
> - Enhanced beacon requests with Enhanced beacon filter IE, which asks
>   the receiving device to process/drop the request upon certain
>   conditions (minimum LQI and/or randomness), as detailed in
>   7.4.4.6 Enhanced Beacon Filter IE. But, as mentioned in
>   7.5.9 Enhanced Beacon Request command: "The Enhanced Beacon Request
>   command is optional for an FFD and an RFD", so this series was only
>   targeting basic beaconing for now.
> - In relaying mode, the destination address must not be validated
>   because the message needs to be re-emitted. Indeed, a receiver in
>   relaying mode may not be the recipient. This is also optional and out
>   of the scope of this series.
>
> Right now I have the below diff, which clarifies the two path, without
> too much changes in the current code because I don't really see why it
> would be necessary. Unless you convince me otherwise or read the spec
> differently than I do :) What do you think?
>

"Reception and rejection"

third-level filtering regarding "destination address" and if the
device is "PAN coordinator".
This is, in my opinion, what the coordinator boolean tells the
transceiver to do on hardware when doing address filter there. You can
also read that up in datasheets of transceivers as atf86rf233, search
for I_AM_COORD.

Whereas they use the word "PAN coordinator" not "coordinator", if they
really make a difference there at this point..., if so then the kernel
must know if the coordinator is a pan coordinator or coordinator
because we need to set the address filter in kernel.

> Thanks,
> Miqu=C3=A8l
>
> ---
>
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local=
 *local,
>         int ret;
>         struct ieee802154_sub_if_data *sdata;
>         struct ieee802154_hdr hdr;
> +       bool iface_found =3D false;
>
>         ret =3D ieee802154_parse_frame_start(skb, &hdr);
>         if (ret) {
> @@ -203,18 +204,31 @@ __ieee802154_rx_handle_packet(struct ieee802154_loc=
al *local,
>         }
>
>         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> -               if (sdata->wpan_dev.iftype !=3D NL802154_IFTYPE_NODE)
> +               if (sdata->wpan_dev.iftype =3D=3D NL802154_IFTYPE_MONITOR=
)
>                         continue;
>
>                 if (!ieee802154_sdata_running(sdata))
>                         continue;
>
> +               iface_found =3D true;
> +               break;
> +       }
> +
> +       if (!iface_found) {
> +               kfree_skb(skb);
> +               return;
> +       }
> +
> +       /* TBD: Additional filtering is possible on NODEs and/or COORDINA=
TORs */
> +       switch (sdata->wpan_dev.iftype) {
> +       case NL802154_IFTYPE_COORD:
> +       case NL802154_IFTYPE_NODE:
>                 ieee802154_subif_frame(sdata, skb, &hdr);
> -               skb =3D NULL;
> +               break;
> +       default:
> +               kfree_skb(skb);
>                 break;
>         }

Why do you remove the whole interface looping above and make it only
run for one ?first found? ? That code changes this behaviour and I do
not know why. Move the switch case into the loop and do a different
receive path if coord and node and do whatever differs from filtering
and then call ieee802154_subif_frame().

- Alex


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC75E59E6B3
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbiHWQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243909AbiHWQMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C936825F687
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661258023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B7RL6Rg0320PkYWybc3HsS+NBLoW2T6OrM/yKT96X3M=;
        b=GUdHkgPpQhfgSaTa1SBFljJz2F7hs8NjqWSXHMmtyulfo8oZLCKtaDBZAAncWWNn7uL2qt
        7XaRMqp2xd+DIt/WhKnDT2VAqGReRKMFbKp95UnIsiVZqG/2S9VDkuaU1g4RGNaOSBOJ5N
        XL9UdLD1E5vsnk6KsEOzTuGUoRn21dg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-201-xvoK8KMdOji13EKibTjE9g-1; Tue, 23 Aug 2022 08:33:41 -0400
X-MC-Unique: xvoK8KMdOji13EKibTjE9g-1
Received: by mail-qv1-f70.google.com with SMTP id n17-20020ad444b1000000b00496d5b41d37so3700570qvt.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=B7RL6Rg0320PkYWybc3HsS+NBLoW2T6OrM/yKT96X3M=;
        b=LcyuANhsHTNl7+wRryNFmQR6njGgld/gcA1CPyiAp9jAhPVRK1EBhRtQqqQe44W8AQ
         aeSVAKgOYZgN/ueMNuFBuYnBlGudDfaAVQGv0y47ZnrNgQvpAIyGjgN2+cZdklzR6kUZ
         EvfncaK6CBMPvEHSCFIPBcXSsWrB7u+2/yeVW9qd7pmX/5W+HCCq6qugcVJvtBHg76ph
         lyDAidmvBTkxEwa6QhtQj9/D9y9he9PdDFVlSLXTgQ7MfZxF7c4CP9lGshyjqfoocLH4
         3aRmF3FcfXDCX5E/vaauHV4pHSp7HlhfRWHepM/I8FwxdvXuLMoyFcPsecSRD10HKaZl
         l4Wg==
X-Gm-Message-State: ACgBeo0cc5K6vn2zFP2QEfrCvMkw/QrLJJEh3YzXzYQdgSmLFaX9JDpa
        QYjtVYvDoG7wF+HHk/n88ka+xN0ihSdGSZ9OS5Da0vl8OmxLoZUJJ7WszNPuF1nt0egh0B6Hr8U
        wBTIywUPu3Lr2RPHY8ViRYdxiuhcOKMZh
X-Received: by 2002:a05:622a:4:b0:344:94b7:a396 with SMTP id x4-20020a05622a000400b0034494b7a396mr17581284qtw.123.1661258021295;
        Tue, 23 Aug 2022 05:33:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4DEr3LfrwPuNYexjcOCXXipt4XIghkH+zsbEOeIMCpBNb36NC7B8V5o+6weiNXQjfZqp1n3QnxlpxCQyPZdao=
X-Received: by 2002:a05:622a:4:b0:344:94b7:a396 with SMTP id
 x4-20020a05622a000400b0034494b7a396mr17581261qtw.123.1661258021051; Tue, 23
 Aug 2022 05:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13>
In-Reply-To: <20220819191109.0e639918@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 23 Aug 2022 08:33:30 -0400
Message-ID: <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 19, 2022 at 1:11 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:51:02 -0400:
>
> > Hi,
> >
> > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > As a first strep in introducing proper PAN management and association,
> > > we need to be able to create coordinator interfaces which might act as
> > > coordinator or PAN coordinator.
> > >
> > > Hence, let's add the minimum support to allow the creation of these
> > > interfaces. This might be restrained and improved later.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/mac802154/iface.c | 14 ++++++++------
> > >  net/mac802154/rx.c    |  2 +-
> > >  2 files changed, 9 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > index 500ed1b81250..7ac0c5685d3f 100644
> > > --- a/net/mac802154/iface.c
> > > +++ b/net/mac802154/iface.c
> > > @@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
> > >                 if (nsdata != sdata && ieee802154_sdata_running(nsdata)) {
> > >                         int ret;
> > >
> > > -                       /* TODO currently we don't support multiple node types
> > > -                        * we need to run skb_clone at rx path. Check if there
> > > -                        * exist really an use case if we need to support
> > > -                        * multiple node types at the same time.
> > > +                       /* TODO currently we don't support multiple node/coord
> > > +                        * types we need to run skb_clone at rx path. Check if
> > > +                        * there exist really an use case if we need to support
> > > +                        * multiple node/coord types at the same time.
> > >                          */
> > > -                       if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
> > > -                           nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
> > > +                       if (wpan_dev->iftype != NL802154_IFTYPE_MONITOR &&
> > > +                           nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
> > >                                 return -EBUSY;
> > >
> > >                         /* check all phy mac sublayer settings are the same.
> > > @@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
> > >         wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
> > >
> > >         switch (type) {
> > > +       case NL802154_IFTYPE_COORD:
> > >         case NL802154_IFTYPE_NODE:
> > >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> > >                                         sdata->dev->dev_addr);
> > > @@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
> > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > >                                 &local->hw.phy->perm_extended_addr);
> > >         switch (type) {
> > > +       case NL802154_IFTYPE_COORD:
> > >         case NL802154_IFTYPE_NODE:
> > >                 ndev->type = ARPHRD_IEEE802154;
> > >                 if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
> > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > index b8ce84618a55..39459d8d787a 100644
> > > --- a/net/mac802154/rx.c
> > > +++ b/net/mac802154/rx.c
> > > @@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
> > >         }
> > >
> > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > -               if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
> > > +               if (sdata->wpan_dev.iftype == NL802154_IFTYPE_MONITOR)
> > >                         continue;
> >
> > I probably get why you are doing that, but first the overall design is
> > working differently - means you should add an additional receive path
> > for the special interface type.
> >
> > Also we "discovered" before that the receive path of node vs
> > coordinator is different... Where is the different handling here? I
> > don't see it, I see that NODE and COORD are the same now (because that
> > is _currently_ everything else than monitor). This change is not
> > enough and does "something" to handle in some way coordinator receive
> > path but there are things missing.
> >
> > 1. Changing the address filters that it signals the transceiver it's
> > acting as coordinator
> > 2. We _should_ also have additional handling for whatever the
> > additional handling what address filters are doing in mac802154
> > _because_ there is hardware which doesn't have address filtering e.g.
> > hwsim which depend that this is working in software like other
> > transceiver hardware address filters.
> >
> > For the 2. one, I don't know if we do that even for NODE right or we
> > just have the bare minimal support there... I don't assume that
> > everything is working correctly here but what I want to see is a
> > separate receive path for coordinators that people can send patches to
> > fix it.
>
> Yes, we do very little differently between the two modes, that's why I
> took the easy way: just changing the condition. I really don't see what
> I can currently add here, but I am fine changing the style to easily
> show people where to add filters for such or such interface, but right
> now both path will look very "identical", do we agree on that?

mostly yes, but there exists a difference and we should at least check
if the node receive path violates the coordinator receive path and
vice versa.
Put it in a receive_path() function and then coord_receive_path(),
node_receive_path() that calls the receive_path() and do the
additional filtering for coordinators, etc.

There should be a part in the standard about "third level filter rule
if it's a coordinator".
btw: this is because the address filter on the transceiver needs to
have the "i am a coordinator" boolean set which is missing in this
series. However it depends on the transceiver filtering level and the
mac802154 receive path if we actually need to run such filtering or
not.

- Alex


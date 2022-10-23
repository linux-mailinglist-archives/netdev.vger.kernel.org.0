Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2FC609746
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 01:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJWX1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 19:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJWX1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 19:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE7863D21
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666567652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Me1CqXbwCU8jl4QVRbfvdZgQCQqwdjmWeH6HRLmVfVM=;
        b=GFoC3PwcFes13qgecIVozkX//Ouh+o9KxJkYkb8LytzDbbYtJ47rFv8d23i8u4ERT8cPHt
        sqxdbF8yOWR6sVWVryaaNi/a0WzArNFb373g0AFmZ4W1E8FSyhwoGW6ZD0g+e64TgP6s6Y
        yPd/MRTuf+MWQDeav2dcSXQKZghKznM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-312-5xbFNGZgNny0ztClGOWqSA-1; Sun, 23 Oct 2022 19:27:30 -0400
X-MC-Unique: 5xbFNGZgNny0ztClGOWqSA-1
Received: by mail-ed1-f70.google.com with SMTP id m20-20020a056402511400b0045da52f2d3cso7831911edd.20
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Me1CqXbwCU8jl4QVRbfvdZgQCQqwdjmWeH6HRLmVfVM=;
        b=VsHWg2wTd4mks8L08ovbBvFICsVGZsCBiJ6qnAPONgGD7folYwKcEpVfVuErx1nylJ
         LLDBDL0z7pFX0GnvHqprnGsoGD3eJQsX2hC8qdP0pZo2JOYX6mT4hS2LxTeGv6DHe4Qe
         suIiK3KYvAzET0bqfLNzDVNek63kKL5B6jcmaYKko9v8uxqBg6Bo5xmZKLKltJp+Nlc8
         da0xvtvQTdY4ZyzHjrT2vJewxw9ucSq+rs9Qzu8vyeNLhWpjO142NKdhflvnB26GcMNS
         P7kMMcSLHRVmm3cSW7gdKJTRBO3LQMVaJoUwLY4dZb3cjczal9IznjrSBjxYKliEaf1v
         elhg==
X-Gm-Message-State: ACrzQf29c7ioGEqAphSmsFoSb82Rw/nENr+2OdIgyMRBeYRzOT8PdUEy
        3uu3ropIolox3rxbmgYw4ZmfaU9sHSETuLdAN8kPJduyYyhXP99an9dswvVqw/Mf2/styB+J9Jb
        pGjT9thFMii9R3EnkvedD0+shHC/RigzW
X-Received: by 2002:a17:907:2d91:b0:78d:8747:71b4 with SMTP id gt17-20020a1709072d9100b0078d874771b4mr25163815ejc.545.1666567649063;
        Sun, 23 Oct 2022 16:27:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5HgzYXBS6O/oTS3rQyjX4iT6/ySBs8BS7FiAOQmELU/Vr4KGfcFAPcjO2Kw7GMN8827YFmYn4w2T7Rlb/IVLk=
X-Received: by 2002:a17:907:2d91:b0:78d:8747:71b4 with SMTP id
 gt17-20020a1709072d9100b0078d874771b4mr25163792ejc.545.1666567648790; Sun, 23
 Oct 2022 16:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221018183639.806719-1-miquel.raynal@bootlin.com>
 <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com>
 <20221019115242.571c19bb@xps-13> <CAK-6q+jna-UXWVvTjnJnJ+LADB0oP_WmVJV0N5r00cb1tfhkpA@mail.gmail.com>
 <CAK-6q+gCKU0htSwjAZ2vjekq-wD0+8tUc6zXHv_Y+MGb2VkM+Q@mail.gmail.com>
In-Reply-To: <CAK-6q+gCKU0htSwjAZ2vjekq-wD0+8tUc6zXHv_Y+MGb2VkM+Q@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 23 Oct 2022 19:27:17 -0400
Message-ID: <CAK-6q+jgF_fEBXePbNpHQortjEWxzWh4uKGp4+sJ=3hVAUbLSg@mail.gmail.com>
Subject: Re: [PATCH wpan-next] mac802154: Allow the creation of coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Oct 23, 2022 at 7:26 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Sun, Oct 23, 2022 at 7:13 PM Alexander Aring <aahringo@redhat.com> wrote:
> >
> > Hi,
> >
> > On Wed, Oct 19, 2022 at 5:52 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 18 Oct 2022 19:57:19 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Tue, Oct 18, 2022 at 2:36 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > As a first strep in introducing proper PAN management and association,
> > > > > we need to be able to create coordinator interfaces which might act as
> > > > > coordinator or PAN coordinator.
> > > > >
> > > > > Hence, let's add the minimum support to allow the creation of these
> > > > > interfaces. This support will be improved later, in particular regarding
> > > > > the filtering.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  net/mac802154/iface.c | 14 ++++++++------
> > > > >  net/mac802154/main.c  |  2 ++
> > > > >  net/mac802154/rx.c    | 11 +++++++----
> > > > >  3 files changed, 17 insertions(+), 10 deletions(-)
> > > > >
> > > > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > > > index d9b50884d34e..682249f3369b 100644
> > > > > --- a/net/mac802154/iface.c
> > > > > +++ b/net/mac802154/iface.c
> > > > > @@ -262,13 +262,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
> > > > >                 if (nsdata != sdata && ieee802154_sdata_running(nsdata)) {
> > > > >                         int ret;
> > > > >
> > > > > -                       /* TODO currently we don't support multiple node types
> > > > > -                        * we need to run skb_clone at rx path. Check if there
> > > > > -                        * exist really an use case if we need to support
> > > > > -                        * multiple node types at the same time.
> > > > > +                       /* TODO currently we don't support multiple node/coord
> > > > > +                        * types we need to run skb_clone at rx path. Check if
> > > > > +                        * there exist really an use case if we need to support
> > > > > +                        * multiple node/coord types at the same time.
> > > > >                          */
> > > > > -                       if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
> > > > > -                           nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
> > > > > +                       if (wpan_dev->iftype != NL802154_IFTYPE_MONITOR &&
> > > > > +                           nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
> > > > >                                 return -EBUSY;
> > > > >
> > > > >                         /* check all phy mac sublayer settings are the same.
> > > > > @@ -565,6 +565,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
> > > > >         wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
> > > > >
> > > > >         switch (type) {
> > > > > +       case NL802154_IFTYPE_COORD:
> > > > >         case NL802154_IFTYPE_NODE:
> > > > >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> > > > >                                         sdata->dev->dev_addr);
> > > > > @@ -624,6 +625,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
> > > > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > > > >                                 &local->hw.phy->perm_extended_addr);
> > > > >         switch (type) {
> > > > > +       case NL802154_IFTYPE_COORD:
> > > > >         case NL802154_IFTYPE_NODE:
> > > > >                 ndev->type = ARPHRD_IEEE802154;
> > > > >                 if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
> > > > > diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> > > > > index 40fab08df24b..d03ecb747afc 100644
> > > > > --- a/net/mac802154/main.c
> > > > > +++ b/net/mac802154/main.c
> > > > > @@ -219,6 +219,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
> > > > >
> > > > >         if (hw->flags & IEEE802154_HW_PROMISCUOUS)
> > > > >                 local->phy->supported.iftypes |= BIT(NL802154_IFTYPE_MONITOR);
> > > > > +       else
> > > > > +               local->phy->supported.iftypes &= ~BIT(NL802154_IFTYPE_COORD);
> > > > >
> > > >
> > > > So this means if somebody in the driver sets iftype COORD is supported
> > > > but then IEEE802154_HW_PROMISCUOUS is not supported it will not
> > > > support COORD?
> > > >
> > > > Why is IEEE802154_HW_PROMISCUOUS required for COORD iftype? I thought
> > > > IEEE802154_HW_PROMISCUOUS is required to do a scan?
> > >
> > > You are totally right this is inconsistent, I'll drop the else block
> > > entirely. The fact that HW_PROMISCUOUS is supported when starting a
> > > scan is handled by the -EOPNOTSUPP return code from
> > > drv_set_promiscuous_mode() called by drv_start() in
> > > mac802154_trigger_scan().
> > >
> > > However I need your input on the following topic: in my branch I
> > > have somewhere a patch adding IFTYPE_COORD to the list of
> > > phy->supported.iftypes in each individual driver. But right now, if we
> > > drop the promiscuous constraint as you suggest, I don't see anymore the
> > > need for setting this as a per-driver value.
> > >
> > > Should we make the possibility to create IFTYPE_COORD interfaces the
> > > default instead, something like this?
> > >
> > > --- a/net/mac802154/main.c
> > > +++ b/net/mac802154/main.c
> > > @@ -118,7 +118,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
> > >         phy->supported.lbt = NL802154_SUPPORTED_BOOL_FALSE;
> > >
> > >         /* always supported */
> > > -       phy->supported.iftypes = BIT(NL802154_IFTYPE_NODE);
> > > +       phy->supported.iftypes = BIT(NL802154_IFTYPE_NODE) | BIT(NL802154_IFTYPE_COORD);
> > >
> >
> > okay.
> >
> > > > >         rc = wpan_phy_register(local->phy);
> > > > >         if (rc < 0)
> > > > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > > > index 2ae23a2f4a09..aca348d7834b 100644
> > > > > --- a/net/mac802154/rx.c
> > > > > +++ b/net/mac802154/rx.c
> > > > > @@ -208,6 +208,7 @@ __ieee802154_rx_handle_packet(struct
> > > > > ieee802154_local *local, int ret;
> > > > >         struct ieee802154_sub_if_data *sdata;
> > > > >         struct ieee802154_hdr hdr;
> > > > > +       struct sk_buff *skb2;
> > > > >
> > > > >         ret = ieee802154_parse_frame_start(skb, &hdr);
> > > > >         if (ret) {
> > > > > @@ -217,7 +218,7 @@ __ieee802154_rx_handle_packet(struct
> > > > > ieee802154_local *local, }
> > > > >
> > > > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > > > -               if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
> > > > > +               if (sdata->wpan_dev.iftype ==
> > > > > NL802154_IFTYPE_MONITOR) continue;
> > > >
> > > > I guess this will work but I would like to see no logic about if it's
> > > > not MONITOR it's NODE or COORD, because introducing others requires
> > > > updating those again... however I think it's fine.
> > >
> > > Actually I don't get why we would not want this logic, it seem very
> > > relevant to me. Do you want a helper instead and hide the condition
> > > inside? Or something else? Or is it just fine for now?
> > >
> > > > I would like to see
> > > > a different receive path for coord_rx() and node_rx(), but yea
> > > > currently I guess they are mostly the same... in future I think they
> > > > are required as PACKTE_HOST, etc. will be changed regarding pan
> > > > coordinator or just coordinator (so far I understood).
> > >
> >
> > yes, I think so too.
> >
> > > I agree it is tempting, but yeah, there is really very little changes
> > > between the two, for me splitting the rx path would just darken the
> > > code without bringing much...
> > >
> >
> > ok.
> >
> > > About the way we handle the PAN coordinator role I have a couple of
> > > questions:
> > > - shall we consider only the PAN coordinator to be able to accept
> > >   associations or is any coordinator in the PAN able to do it? (this is
> > >   not clear to me)
> >
> > Me either, it sounds for me that coordinators are "leaves" and pan
> > coordinators are not. It is like in IPv6 level it is a host or router.
> >
>
> In this case pan coordinators are able to accept associations only but
> others can send associations.
>
> We should talk about how the difference is here between a node
> interface and a coordinator interface. For me a node interface is a
> "mesh" 802.15.4 interface. Coordinators/Pan Coordinators build up star
> topologies, or not? What I think about is maybe coord interfaces are
> just pan coordinators. Node interfaces act at the beginning as a fully

*are just node interfaces.

Sorry.

- Alex


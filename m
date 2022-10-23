Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C481609732
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 01:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJWXPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 19:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJWXPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 19:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA33F36BFB
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666566901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HiKCmrF7ZTGYBe9vL6fiKH7fWbLlHNR4MNkkZRj4hAk=;
        b=Fm/1GouqsdLTrV0Y3F8jCgT6rpNAmAoAuIYcJ/j97eJG83DNxlcEAp+U5vpIUhDbxpEnUd
        j6A5VKMI+1jiCE5sDwHL448x1mAasEqu36NIEeQ1Lp0fxStmx4cAmsTKp4XKnL+H86dxKm
        cuQBXHfqPMy0pcjqevQAVbvNYmbtVGE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-2-xHB-8uzuOuWP59_7gusA3Q-1; Sun, 23 Oct 2022 19:13:18 -0400
X-MC-Unique: xHB-8uzuOuWP59_7gusA3Q-1
Received: by mail-ed1-f71.google.com with SMTP id e15-20020a056402190f00b00461b0576620so1586792edz.2
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HiKCmrF7ZTGYBe9vL6fiKH7fWbLlHNR4MNkkZRj4hAk=;
        b=7q1zN3LfSX0vBUcl+hxrmSp0lo77YEptiZY+oyvwqnZ9Rj/qptijBHS6ZH4WN342G1
         KjcxGzoI1jOAMJnzPfqu4sakStbu4gMH5umOfLiDt5Mj4zxdDJx+KoG8HOMRVrfkEziT
         gK/IdAJQIMq+pL7eTCHF/C9KSlzSLIP4LnR94Nrg7pNxOxc0AH00J7UaEgk4380hYui8
         UMjlnzoxg5vnShqo3euAwqSrZQ8jpAIv77IL315jArOl+7yAHU9qoQNiKAMDbRmf3ESD
         PJVgXKkkvcjGofpQ3yFG8AQ5Uh7bfFPBQxeOLYVAKPOS4XG89z2BMhJKZcKI43dx/eNW
         bzDg==
X-Gm-Message-State: ACrzQf2mlrFvO+1ifDoY5+tawS0dC4Q8h5fkPh/V1Ng1Wvm908D0YgGx
        I7AplNunXF1DGmSJ2WJsPVZpewXUrPlRbaK6UoBDkwIfDpFpxXGzjci9tmEi4ZIhkGWZxPzGWLL
        kPc+5DNf1n/q7kl2D9s0i8+qBWX1gLlSP
X-Received: by 2002:a17:906:5dcc:b0:78d:fb98:6f85 with SMTP id p12-20020a1709065dcc00b0078dfb986f85mr25613663ejv.123.1666566797286;
        Sun, 23 Oct 2022 16:13:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7dtk3ZoxsrIuwizwQ+p+jHLq8CrF174riao3WkIzkxt5J9OyWsXmJs6ik/ekaML9EozYJ2RZ7hceDkq82v12c=
X-Received: by 2002:a17:906:5dcc:b0:78d:fb98:6f85 with SMTP id
 p12-20020a1709065dcc00b0078dfb986f85mr25613649ejv.123.1666566797051; Sun, 23
 Oct 2022 16:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221018183639.806719-1-miquel.raynal@bootlin.com>
 <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com> <20221019115242.571c19bb@xps-13>
In-Reply-To: <20221019115242.571c19bb@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 23 Oct 2022 19:13:05 -0400
Message-ID: <CAK-6q+jna-UXWVvTjnJnJ+LADB0oP_WmVJV0N5r00cb1tfhkpA@mail.gmail.com>
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

On Wed, Oct 19, 2022 at 5:52 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 18 Oct 2022 19:57:19 -0400:
>
> > Hi,
> >
> > On Tue, Oct 18, 2022 at 2:36 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > As a first strep in introducing proper PAN management and association,
> > > we need to be able to create coordinator interfaces which might act as
> > > coordinator or PAN coordinator.
> > >
> > > Hence, let's add the minimum support to allow the creation of these
> > > interfaces. This support will be improved later, in particular regarding
> > > the filtering.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/mac802154/iface.c | 14 ++++++++------
> > >  net/mac802154/main.c  |  2 ++
> > >  net/mac802154/rx.c    | 11 +++++++----
> > >  3 files changed, 17 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> > > index d9b50884d34e..682249f3369b 100644
> > > --- a/net/mac802154/iface.c
> > > +++ b/net/mac802154/iface.c
> > > @@ -262,13 +262,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
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
> > > @@ -565,6 +565,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
> > >         wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
> > >
> > >         switch (type) {
> > > +       case NL802154_IFTYPE_COORD:
> > >         case NL802154_IFTYPE_NODE:
> > >                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
> > >                                         sdata->dev->dev_addr);
> > > @@ -624,6 +625,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
> > >         ieee802154_le64_to_be64(ndev->perm_addr,
> > >                                 &local->hw.phy->perm_extended_addr);
> > >         switch (type) {
> > > +       case NL802154_IFTYPE_COORD:
> > >         case NL802154_IFTYPE_NODE:
> > >                 ndev->type = ARPHRD_IEEE802154;
> > >                 if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
> > > diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> > > index 40fab08df24b..d03ecb747afc 100644
> > > --- a/net/mac802154/main.c
> > > +++ b/net/mac802154/main.c
> > > @@ -219,6 +219,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
> > >
> > >         if (hw->flags & IEEE802154_HW_PROMISCUOUS)
> > >                 local->phy->supported.iftypes |= BIT(NL802154_IFTYPE_MONITOR);
> > > +       else
> > > +               local->phy->supported.iftypes &= ~BIT(NL802154_IFTYPE_COORD);
> > >
> >
> > So this means if somebody in the driver sets iftype COORD is supported
> > but then IEEE802154_HW_PROMISCUOUS is not supported it will not
> > support COORD?
> >
> > Why is IEEE802154_HW_PROMISCUOUS required for COORD iftype? I thought
> > IEEE802154_HW_PROMISCUOUS is required to do a scan?
>
> You are totally right this is inconsistent, I'll drop the else block
> entirely. The fact that HW_PROMISCUOUS is supported when starting a
> scan is handled by the -EOPNOTSUPP return code from
> drv_set_promiscuous_mode() called by drv_start() in
> mac802154_trigger_scan().
>
> However I need your input on the following topic: in my branch I
> have somewhere a patch adding IFTYPE_COORD to the list of
> phy->supported.iftypes in each individual driver. But right now, if we
> drop the promiscuous constraint as you suggest, I don't see anymore the
> need for setting this as a per-driver value.
>
> Should we make the possibility to create IFTYPE_COORD interfaces the
> default instead, something like this?
>
> --- a/net/mac802154/main.c
> +++ b/net/mac802154/main.c
> @@ -118,7 +118,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
>         phy->supported.lbt = NL802154_SUPPORTED_BOOL_FALSE;
>
>         /* always supported */
> -       phy->supported.iftypes = BIT(NL802154_IFTYPE_NODE);
> +       phy->supported.iftypes = BIT(NL802154_IFTYPE_NODE) | BIT(NL802154_IFTYPE_COORD);
>

okay.

> > >         rc = wpan_phy_register(local->phy);
> > >         if (rc < 0)
> > > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > > index 2ae23a2f4a09..aca348d7834b 100644
> > > --- a/net/mac802154/rx.c
> > > +++ b/net/mac802154/rx.c
> > > @@ -208,6 +208,7 @@ __ieee802154_rx_handle_packet(struct
> > > ieee802154_local *local, int ret;
> > >         struct ieee802154_sub_if_data *sdata;
> > >         struct ieee802154_hdr hdr;
> > > +       struct sk_buff *skb2;
> > >
> > >         ret = ieee802154_parse_frame_start(skb, &hdr);
> > >         if (ret) {
> > > @@ -217,7 +218,7 @@ __ieee802154_rx_handle_packet(struct
> > > ieee802154_local *local, }
> > >
> > >         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > -               if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
> > > +               if (sdata->wpan_dev.iftype ==
> > > NL802154_IFTYPE_MONITOR) continue;
> >
> > I guess this will work but I would like to see no logic about if it's
> > not MONITOR it's NODE or COORD, because introducing others requires
> > updating those again... however I think it's fine.
>
> Actually I don't get why we would not want this logic, it seem very
> relevant to me. Do you want a helper instead and hide the condition
> inside? Or something else? Or is it just fine for now?
>
> > I would like to see
> > a different receive path for coord_rx() and node_rx(), but yea
> > currently I guess they are mostly the same... in future I think they
> > are required as PACKTE_HOST, etc. will be changed regarding pan
> > coordinator or just coordinator (so far I understood).
>

yes, I think so too.

> I agree it is tempting, but yeah, there is really very little changes
> between the two, for me splitting the rx path would just darken the
> code without bringing much...
>

ok.

> About the way we handle the PAN coordinator role I have a couple of
> questions:
> - shall we consider only the PAN coordinator to be able to accept
>   associations or is any coordinator in the PAN able to do it? (this is
>   not clear to me)

Me either, it sounds for me that coordinators are "leaves" and pan
coordinators are not. It is like in IPv6 level it is a host or router.

> - If a coordinator receives a packet with no destination it should
>   expect it to be targeted at the PAN controller. Should we consider
>   relaying the packet?

I guess it depends what the standard says here?

> - Is relaying a hardware feature or should we do it in software?
>

I think for SoftMAC it is only the address filter which needs to be
changed. The rest is in software. So far what I can see here.

Question is what we are using here in the Linux kernel to provide such
functionality...

e.g. see:

include/net/dst.h

> > >                 if (!ieee802154_sdata_running(sdata))
> > > @@ -230,9 +231,11 @@ __ieee802154_rx_handle_packet(struct
> > > ieee802154_local *local, sdata->required_filtering ==
> > > IEEE802154_FILTERING_4_FRAME_FIELDS) continue;
> > >
> > > -               ieee802154_subif_frame(sdata, skb, &hdr);
> > > -               skb = NULL;
> > > -               break;
> > > +               skb2 = skb_clone(skb, GFP_ATOMIC);
> > > +               if (skb2) {
> > > +                       skb2->dev = sdata->dev;
> > > +                       ieee802154_subif_frame(sdata, skb2, &hdr);
> > > +               }
> > >         }
> > >
> > >         kfree_skb(skb);
> >
> > If we do the clone above this kfree_skb() should be move to
> > ieee802154_rx() right after __ieee802154_rx_handle_packet().
>
> Ok!
>
> > This patch also changes that we deliver one skb to multiple interfaces if
> > there are more than one and I was not aware that we currently do that.
> > :/
>
> Just as a side note: we do that already if we have several MONITOR
> interfaces opened on the same PHY, it is possible to have them all open.
>

yes, I used that feature with hwsim once.

> Regarding the situation where we would have NODE + MONITOR or COORD +
> MONITOR, while the interface creation would work, both could not be
> open at the same time because the following happens:
> mac802154_wpan_open() {
>         ieee802154_check_concurrent_iface() {
>                 ieee802154_check_mac_settings() {
>                         /* prevent the two interface types from being
>                          * open at the same time because the filtering
>                          * needs are not compatible. */
>                 }
>         }
> }
>
> Then, because you asked me to anticipate if we ever want to support more
> than one NODE or COORD interface at the same time, or at least not to
> do anything that would lead to a step back on this regard, I decided I
> would provide all the infrastructure to gracefully handle this
> situation in the Rx path, even though right now it still cannot happen
> because when opening an interface, ieee802154_check_concurrent_iface()
> will also prevent two NODE / COORD interfaces to be opened at the same
> time.

yes, but you are assuming the actual hardware here. A hardware with
multiple address filters can indeed support other interfaces at the
same time. I can also name one, hwsim and a real one - atusb.

>
> TL;DR
> * MONITOR + MONITOR
>   = already supported and working
> * (NODE + MONITOR) || (COORD + MONITOR)
>   = iface creation allowed, but cannot be opened at the same time
>   because of the filtering level incompatibility on a single PHY
> * (NODE + NODE) || (COORD + COORD) || (NODE + COORD)
>   = iface creation allowed, but cannot be opened at the same time
>   because only one PHY available on the device
>
> So for me we are safe and future proof.
>

Yes, this is currently kind of difficult to handle, but I see that we
check such default filtering type thing per phy which depends on what
kind of interface is currently running there? Something like that...

- Alex


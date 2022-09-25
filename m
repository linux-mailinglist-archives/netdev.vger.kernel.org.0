Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE95E9582
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiIYS5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiIYS5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4818424BEB
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664132219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h3q66F9eT2aQVbMBk0CYVVCbEvOxteorCcX0C9uU+GM=;
        b=Dzr36/jsvqxqhtNky7Vq/sNTddwMZuHVTXJasKvYXYdGxJ+wvXfqf3/xlGmitWWyv1wSYu
        CKnbmeInCdMsxTWOdDn03k9mdMX6R1dxRYynN/5fccLmqIen6BZ2NByA3L6VrbQXW3UTNn
        lKqRkInQLVZgMTZEWu7YNQig7HiCUoM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-IcRz9PW3Nf-5x0g4EfZbUg-1; Sun, 25 Sep 2022 14:56:57 -0400
X-MC-Unique: IcRz9PW3Nf-5x0g4EfZbUg-1
Received: by mail-wm1-f70.google.com with SMTP id 5-20020a05600c028500b003b4d2247d3eso5513361wmk.0
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 11:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=h3q66F9eT2aQVbMBk0CYVVCbEvOxteorCcX0C9uU+GM=;
        b=dsk9N/de/5zJTAAl5kqspkNKRkxf80BbnLFHgTYSp/vlty9PVgNw/l5+46Vt16G8la
         yPXxNazzgfwc9Nwo+KmnhLnBahXgM6uXpmm6guGlOt+kaVWlN/d1rG8HBYXjPiQQRrxP
         WHJzr1eIF2NIRJcjc1gsJKz1FkLv+rZPhkTBVxYIns+6DNzIkO/d1HT1gqL0hCzmYjhY
         734ppJA+HyCr9QFJnZDEi3k3PxE4qbFwRCorMxlgXTKB0amptKS3GEEZZDyTXilgb6q3
         3xgn7XJDVURBTCxmnzhO9vbYKolWLHDm/dlVMMRFaNGD5SUnCC0TExJAFN/FS8+jWyTa
         dZ3g==
X-Gm-Message-State: ACrzQf2F4o3Zb9Z7TGRF7eMJWtNmeR0ChTQTrnEJqIpdVGJvNU2yhA9U
        /UU+PKmsYuu5BBQ9G1s668t4Xm5KFS8UFJ+oEF2/komBEzhzRdx5X1gC9Kdj1lHcNaP/ASB6KXN
        aFDSC/GIq26fevnyFqRDYBGbDDeib7Al0
X-Received: by 2002:a5d:654d:0:b0:22a:ff55:e9c9 with SMTP id z13-20020a5d654d000000b0022aff55e9c9mr10992761wrv.14.1664132216640;
        Sun, 25 Sep 2022 11:56:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Hxq2+aJc3CaZOu/REND+CeSK7bQM9g3c0mFiegmisk3BMMLDE88ZAbAEXNSBDXcCzTjoQ+Xj1sAZAU9RPke8=
X-Received: by 2002:a5d:654d:0:b0:22a:ff55:e9c9 with SMTP id
 z13-20020a5d654d000000b0022aff55e9c9mr10992746wrv.14.1664132216314; Sun, 25
 Sep 2022 11:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
 <CAK-6q+g64BTFsHKKwoCqRGEERRgwoMSTX2LJMQMmmRseWBi=hQ@mail.gmail.com>
 <20220908093648.5bae41b2@xps-13> <CAK-6q+jDM=ewcCYtuHuH7sHJjbOpa4SPjY_VyeaCnoF1g6KSFA@mail.gmail.com>
 <20220921174554.266b04bc@xps-13>
In-Reply-To: <20220921174554.266b04bc@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 25 Sep 2022 14:56:44 -0400
Message-ID: <CAK-6q+hsE5_6ZiZnq7Q8bMni8i0-Osiert=Y4qf=EFUjX44V2w@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 0/9] net: ieee802154: Support scanning/beaconing
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
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Sep 21, 2022 at 11:46 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 8 Sep 2022 20:41:14 -0400:
>
> > Hi,
> >
> > On Thu, Sep 8, 2022 at 3:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Wed, 7 Sep 2022 21:40:13 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Mon, Sep 5, 2022 at 4:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > A third version of this series, dropping the scan patches for now
> > > > > because before we need to settle on the filtering topic and the
> > > > > coordinator interface topic. Here is just the filtering part, I've
> > > > > integrated Alexander's patches, as well as the atusb fix. Once this is
> > > > > merge there are a few coordinator-related patches, and finally the
> > > > > scan.
> > > >
> > > > I think we have a communication problem here and we should talk about
> > > > what the problems are and agree on a way to solve them.
> > > >
> > > > The problems are:
> > > >
> > > > 1. We never supported switching from an operating phy (interfaces are
> > > > up) into another filtering mode.
> > >
> > > In the trigger scan path there is a:
> > >
> > >         mlme_op_pre() // stop Tx
> > >         drv_stop() // stop Rx
> > >         synchronize_net()
> > >         drv_start(params) // restart Rx with another hw filtering level
> > >
> >
> > Okay, that's looking good.
> >
> > > > 2. Scan requires to be in "promiscuous mode" (according to the
> > > > 802.15.4 spec promiscuous mode). We don't support promiscuous mode
> > > > (according to the 802.15.4 spec promiscuous mode). We "can" however
> > > > use the currently supported mode which does not filter anything
> > > > (IEEE802154_FILTERING_NONE) when we do additional filtering in
> > > > mac802154. _But_ this is only required when the phy is scanning, it
> > > > will also deliver anything to the upper layers.
> > > >
> > > > This patch-series tries to do the second thing, okay that's fine. But
> > > > I thought this should only be done while the phy is in "scanning
> > > > mode"?
> > >
> > > I don't understand what's wrong then. We ask for the "scan mode"
> > > filtering level when starting the scan [1] and we ask for the normal
> > > filtering level when it's done/aborted [2] [3].
> > >
> >
> > There is no problem with that. There is for me a problem with the
> > receive path when certain filtering levels are active.
> >
> > > [1] https://github.com/miquelraynal/linux/blob/wpan-next/scan/net/mac802154/scan.c#L326
> > > [2] https://github.com/miquelraynal/linux/blob/wpan-next/scan/net/mac802154/scan.c#L55
> > >
> > > > The other receive path while not in promiscuous mode
> > > > (phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) should never
> > > > require any additional filtering. I somehow miss this point here.
> > >
> > > Maybe the drv_start() function should receive an sdata pointer. This way
> > > instead of changing the PHY filtering level to what has just be asked
> > > blindly, the code should look at the filtering level of all the
> > > interfaces up on the PHY and apply the lowest filtering level by
> > > hardware, knowing that on a per interface basis, the software will
> > > compensate.
> > >
> > > It should work just fine because local->phy->filtering shows the actual
> > > filtering level of the PHY while sdata->requested_filtering shows the
> > > level of filtering that was expected on each interface. If you don't
> > > like the idea of having a mutable sdata->requested_filtering entry, I
> > > can have an sdata->base_filtering which should only be set by
> > > ieee802154_setup_sdata() and an sdata->expected_filtering which would
> > > reflect what the mac expects on this interface at the present moment.
> > >
> >
> > From my view is that if we disable address filters (all filtering
> > modes except IEEE802154_FILTERING_4_FRAME_FIELDS) we never can call
> > netif_receive_skb(). This patch series tries to "compensate" the
> > missing filtering on phy which is fine only to handle things related
> > for the scan operation but nothing else.
> >
> > The reason why we can't call netif_receive_skb() is because we don't
> > have ackknowledge handling, whereas for scanning we ignore ack frames
> > and that's why we don't need it.
>
> I've digested all of that right before the conference so I think I now
> understand all your fears regarding the possible absence of ACK in
> certain situations. I even share them now.
>
> > > > For 1), the driver should change the filtering mode" when we start to
> > > > "listen", this is done by the start() driver callback. They should get
> > > > all receive parameters and set up receiving to whatever mac802154,
> > > > currently there is a bit of chaos there. To move it into drv_start()
> > > > is just a workaround to begin this step that we move it at some point
> > > > to the driver. I mention 1) here because that should be part of the
> > > > picture how everything works together when the phy is switched to a
> > > > different filter level while it's operating (I mean there are running
> > > > interfaces on it which requires IEEE802154_FILTERING_4_FRAME_FIELDS)
> > > > which then activates the different receive path for the use case of
> > > > scanning (something like (phy->state & WPANPHY_SCANING) == true)?
> > >
> > > Scanning is a dedicated filtering level per-se because it must discard
> > > !beacon frames, that's why I request this level of filtering (which
> > > maybe I should do on a per-interface basis instead of using the *local
> > > poiner).
> > >
> >
> > We only can do a per filter level per interface if the hardware has
> > support for such a thing. Currently there is one address filter and if
> > it's disabled we lose ackknowledge handling (as general rule), we
> > can't compensate by doing any additional filtering by software in this
> > mode.
>
> Yes.
>
> >
> > > > I am sorry, but I somehow miss the picture of how those things work
> > > > together. It is not clear for me and I miss those parts to get a whole
> > > > picture of this. For me it's not clear that those patches are going in
> > > > this direction.
> > >
> > > Please tell me if it's more clear and if you agree with this vision. I
> > > don't have time to draft something this week.
> > >
> >
> > That's fine. We should agree on things like compensate lower filter
> > levels by doing additional softmac filtering to reach
> > IEEE802154_FILTERING_4_FRAME_FIELDS filtering from others because we
> > will lose AACK handling. It is only fine to do that in mac802154
> > receive path but don't deliver it to the upper layer.
>
> So actually, if I try to summarize the situation.
>
> I've tried to make several different subif working on a single PHY.
> Unfortunately, today there is only one address filter per PHY, so

correct. But you are assuming hardware which is currently around. As I
said atusb is one candidate to make a more clever hardware because it
has a co-processor which eventually could handle ack handling if done
right.

> disabling the address filter on one interface would also disable it on
> the other, leading to the ACKs not being handled anymore, which we
> cannot afford.
>

For hardware which has such limitation of one address filter yes.

> So overall I guess we should settle on how we want to handle the
> situation. I propose, to move forward, that we continue to assume that
> it is *not* possible to have several different interfaces running at the
> same time on a single PHY. This involves dropping all the "software
> address filtering" which I proposed, but I guess that's fine.

I agree here, but don't remove code which could add such handling and
allow multiple monitors at the same time.

- Alex


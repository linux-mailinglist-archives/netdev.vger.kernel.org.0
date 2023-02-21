Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8373869D8BB
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbjBUCpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjBUCoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:44:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506FD1BDB
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 18:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676947446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=35lNyCeOTTGb6NzfkYZIke15JKTlHxDsq5X9LcHXNi8=;
        b=UK6XQGXzC/fnwAUcNr6pXaYSAgogZAgdplVKBdb33GKX9dPEPlv09aXYxT/XFW9D/EJNud
        GaVViGTyzQ0dcUimiuIi8l/vY5RF/32BW+u02ua8Cbwcf/c1nbAuuit/ovWXs4Up0YbQRJ
        AMhx56aBG5e9mJhTtOlsHsf5/abv7sM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-vicbN3yTMTaVk-GtBPCXCg-1; Mon, 20 Feb 2023 21:44:05 -0500
X-MC-Unique: vicbN3yTMTaVk-GtBPCXCg-1
Received: by mail-ed1-f71.google.com with SMTP id er17-20020a056402449100b004ad793116d5so2120948edb.23
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 18:44:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=35lNyCeOTTGb6NzfkYZIke15JKTlHxDsq5X9LcHXNi8=;
        b=UWNHBwQbjG266MEVGuMKkuYmH4aWT+nKQ0Gt6qQ64GO6s59VIDJFUDaJ+jHZlvRdLV
         co94mlyBsf69aS+GEkMOhxdgeGohBUA9ap1SL8aboJgW/TcJY4Mj8PmijGb8BKUR4THq
         S50s+Za2eI+7VauMWqlkQ2sfaVSebKiFuy+D5i9TsBCMhzA+cVasAl9j7T9B4giP/rnx
         h3RNsejaT9n83dgwzL/fepURZ5zDGYtp94AODVyjroTX1EwWHpHtIHtkudUp1pVXNhEQ
         m2PMXppEM5dkXzEiF/uIe3GZgIBReLwzDFDWKb/pxe76LR6Mu5VdmF5mbEmVi1Vijvtc
         mrFA==
X-Gm-Message-State: AO0yUKXCs55gKHtRRtpDMIUpt40fgiyHSScR6YDN2PfXj+m22WVkbmlL
        gAIB0y0e/MY/DkONoRzJe2/e1CdUTDksdKmgXAxQNq210iyL7Ir2qf66jYgH3Q+426xDWr8s6mC
        NLtYeUyKTSL9+/5Zq1CdFDSds8e0kyMo6
X-Received: by 2002:a17:906:5158:b0:883:ba3b:eb94 with SMTP id jr24-20020a170906515800b00883ba3beb94mr4960057ejc.3.1676947444012;
        Mon, 20 Feb 2023 18:44:04 -0800 (PST)
X-Google-Smtp-Source: AK7set+yWBdAMNAJ8kd3MYeOt3NIK1KP23Hz867jbJ6j4Frh2Ds77m+YkotEApr81wdgc0G6soMindxeg8Drbq6Kc60=
X-Received: by 2002:a17:906:5158:b0:883:ba3b:eb94 with SMTP id
 jr24-20020a170906515800b00883ba3beb94mr4960051ejc.3.1676947443678; Mon, 20
 Feb 2023 18:44:03 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
 <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
 <20230213183535.05e62c1c@xps-13> <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
 <CAK-6q+jU7-ETKeoM=MLmfyMUqywteBC8sUAndRF1vx0PgA+WAA@mail.gmail.com>
 <20230214150600.1c21066b@xps-13> <CAK-6q+g233giuLd56p0G5TqGF+S-NWSkD2MF5nhP+0HLxwnkCA@mail.gmail.com>
 <20230217100220.79a835e4@xps-13>
In-Reply-To: <20230217100220.79a835e4@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 20 Feb 2023 21:43:51 -0500
Message-ID: <CAK-6q+iY70aqCfg0uWTy+XfHxu58rY1Jw9WZ4Nh8Q79-TOgeAQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning requests
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Feb 17, 2023 at 4:02 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 16 Feb 2023 23:34:30 -0500:
>
> > Hi,
> >
> > On Tue, Feb 14, 2023 at 9:07 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:53:57 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Tue, Feb 14, 2023 at 8:34 AM Alexander Aring <aahringo@redhat.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
> > > > > <miquel.raynal@bootlin.com> wrote:
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > > > > > > > > > > +{
> > > > > > > > > > > +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > > > > > > > > > > +       struct net_device *dev = info->user_ptr[1];
> > > > > > > > > > > +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> > > > > > > > > > > +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> > > > > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > > > > +       u8 type;
> > > > > > > > > > > +       int err;
> > > > > > > > > > > +
> > > > > > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > > > > > +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > > > > > > > > > > +               return -EPERM;
> > > > > > > > > >
> > > > > > > > > > btw: why are monitors not allowed?
> > > > > > > > >
> > > > > > > > > I guess I had the "active scan" use case in mind which of course does
> > > > > > > > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > > > > > > > right now I don't remember why I strongly refused scans on monitors.
> > > > > > > >
> > > > > > > > Isn't it that scans really work close to phy level? Means in this case
> > > > > > > > we disable mostly everything of MAC filtering on the transceiver side.
> > > > > > > > Then I don't see any reasons why even monitors can't do anything, they
> > > > > > > > also can send something. But they really don't have any specific
> > > > > > > > source address set, so long addresses are none for source addresses, I
> > > > > > > > don't see any problem here. They also don't have AACK handling, but
> > > > > > > > it's not required for scan anyway...
> > > > > > > >
> > > > > > > > If this gets too complicated right now, then I am also fine with
> > > > > > > > returning an error here, we can enable it later but would it be better
> > > > > > > > to use ENOTSUPP or something like that in this case? EPERM sounds like
> > > > > > > > you can do that, but you don't have the permissions.
> > > > > > > >
> > > > > > >
> > > > > > > For me a scan should also be possible from iwpan phy $PHY scan (or
> > > > > > > whatever the scan command is, or just enable beacon)... to go over the
> > > > > > > dev is just a shortcut for "I mean whatever the phy is under this dev"
> > > > > > > ?
> > > > > >
> > > > > > Actually only coordinators (in a specific state) should be able to send
> > > > > > beacons, so I am kind of against allowing that shortcut, because there
> > > > > > are usually two dev interfaces on top of the phy's, a regular "NODE"
> > > > > > and a "COORD", so I don't think we should go that way.
> > > > > >
> > > > > > For scans however it makes sense, I've added the necessary changes in
> > > > > > wpan-tools. The TOP_LEVEL(scan) macro however does not support using
> > > > > > the same command name twice because it creates a macro, so this one
> > > > > > only supports a device name (the interface command has kind of the same
> > > > > > situation and uses a HIDDEN() macro which cannot be used here).
> > > > > >
> > > > >
> > > > > Yes, I was thinking about scanning only.
> > > > >
> > > > > > So in summary here is what is supported:
> > > > > > - dev <dev> beacon
> > > > > > - dev <dev> scan trigger|abort
> > > > > > - phy <phy> scan trigger|abort
> > > > > > - dev <dev> scan (the blocking one, which triggers, listens and returns)
> > > > > >
> > > > > > Do you agree?
> > > > > >
> > > > >
> > > > > Okay, yes. I trust you.
> > > >
> > > > btw: at the point when a scan requires a source address... it cannot
> > > > be done because then a scan is related to a MAC instance -> an wpan
> > > > interface and we need to bind to it. But I think it doesn't?
> > >
> > > I'm not sure I follow you here. You mean in case of active scan? The
> > > operation is always tight to a device in the end, even if you provide a
> > > phy in userspace. So I guess it's not a problem. Or maybe I didn't get
> > > the question right?
> >
> > As soon scan requires to put somewhere mib values inside e.g. address
> > information (which need to compared to source address settings (mib)?)
> > then it's no longer a phy operation -> wpan_phy, it is binded to a
> > wpan_dev (mac instance on a phy). But the addresses are set to NONE
> > address type?
> > I am not sure where all that data is stored right now for a scan
> > operation, if it's operating on a phy it should be stored on wpan_phy.
> >
> > Note: there are also differences between wpan_phy and
> > ieee802154_local, also wpan_dev and ieee802154_sub_if_data structures.
> > It has something to do with visibility and SoftMAC vs HardMAC, however
> > the last one we don't really have an infrastructure for and we
> > probably need to move something around there. In short
> > wpan_phy/wpan_dev should be only visible by HardMAC (I think) and the
> > others are only additional data for the same instances used by
> > mac802154...
>
> Ok, I got what you meant.
>
> So to be clear, I assume active and passive scans are phy activities,
> they only involve phy parameters. Beaconing however need access to mac
> parameters.
>

ok.

> For now the structure defining user requests in terms of scanning and
> beaconing is stored into ieee802154_local, but we can move it
> away if needed at some point? For now I have no real example of
> hardMAC device so it's a bit hard to anticipate all their
> needs, but do you want me to move it to wpan_dev? (I would like to keep
> both request descriptors aside from each other).

yes, forget about moving things to the right structure... somehow I
think it's good to have them to not get in too much pain when trying
to introduce a hardmac driver...

- Alex


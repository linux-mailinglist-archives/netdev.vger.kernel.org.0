Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761AA6466EA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLHCX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLHCXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:23:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F538E599
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670466172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0QhxpS2KiBOPym2udtsXiddqE0Zv4iUkp740zX0yZMs=;
        b=Anq9gBAs8MDyWQ/dxAgGK76FnH2u6b5ng/fEXDfdEMA9vsf1ZFXBaiB0bOCeHPw0MlXPgM
        G44zulv5gsUpcFqxkWI6FsTSP6ZAQv5aj5eEgVoE5PRN+Zzze1m6piWkzjjWi+UmJbpwhT
        e0GjUnweILDme0LaEWJdSq+8vOVeNCk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-wnnYGk7fOxyCHFiGrenmWQ-1; Wed, 07 Dec 2022 21:22:51 -0500
X-MC-Unique: wnnYGk7fOxyCHFiGrenmWQ-1
Received: by mail-ed1-f71.google.com with SMTP id c9-20020a05640227c900b00463de74bc15so151712ede.13
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 18:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0QhxpS2KiBOPym2udtsXiddqE0Zv4iUkp740zX0yZMs=;
        b=p4zjrHmSnId6WQqjgOyDleo6lKitHkKywVfGOm/oekA8DWNJZK5m1pkyginz+ymFyf
         HCiN90Wr8OOiFnCTsf2+GdRq1irqHlEz1t9oG1HTXQgEAsQcIU6vQ4Omyrr9eNiUPN10
         Xc6KQhJK3A9/MgozPUu7zcYoR/p2gUJT9V3jMT3y9DHTPSMIUj3pCxFKt3zeU4hVjVZh
         UrX+4w/dpOsZVrkIS0xmLBc6imnnOeHXfigHHq1SMY1Kk8dVdqxOP09BrCxT2Dvacdk+
         tey00bFD6wcJNOsmYsKQdwuCpjBSVIqFhEKkohwWdi97wIoW49nCJUPcktDK8q4PWp+J
         DPZw==
X-Gm-Message-State: ANoB5plx4SaHqxmtoLRLV0TQ+pOrdB2gnHrhQcEosD45hXgx7iJVnj9X
        c9403j/j9pJzgoHI8k02kj2yxNDdkEXNNTnCy+aycRw8HuUaCkdDmHlUeZvuJQC2INVNP2g77JP
        9dkfeGp3zlD7IpfSsni2fgWRPjpjO0YMG
X-Received: by 2002:a17:906:c251:b0:7be:88ed:3d4d with SMTP id bl17-20020a170906c25100b007be88ed3d4dmr44724894ejb.268.1670466170169;
        Wed, 07 Dec 2022 18:22:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4n6GjZvaVqS7oAk+130TJghX+hhTiUqmxf1zR0shCYG3ki3XNJ/p/rfjkBlPP+EvrcDaXSoSN8hQZfhGkuGmI=
X-Received: by 2002:a17:906:c251:b0:7be:88ed:3d4d with SMTP id
 bl17-20020a170906c25100b007be88ed3d4dmr44724880ejb.268.1670466169930; Wed, 07
 Dec 2022 18:22:49 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+hjXKmOrf-p=hRzuD=4pOJeWNUu46iU8YAVL4BqWC437A@mail.gmail.com>
 <20221205105752.6ce87721@xps-13> <CAK-6q+hMDMGqpNzStXu+tpGgwn13mYqRgAKUJQXdA3eWi-rsGQ@mail.gmail.com>
 <20221207144457.3033270f@xps-13>
In-Reply-To: <20221207144457.3033270f@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 7 Dec 2022 21:22:37 -0500
Message-ID: <CAK-6q+iL7hiaXBr7HFn051wZoD4rJD=uLsVnso9Ojer7kMY8Ug@mail.gmail.com>
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

On Wed, Dec 7, 2022 at 8:45 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Wed, 7 Dec 2022 08:27:35 -0500:
>
> > Hi,
> >
> > On Mon, Dec 5, 2022 at 4:58 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Sun, 4 Dec 2022 17:44:24 -0500:
> > >
> > > > Hi,
> > > >
> > > > On Tue, Nov 29, 2022 at 11:02 AM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > The ieee802154 layer should be able to scan a set of channels in order
> > > > > to look for beacons advertizing PANs. Supporting this involves adding
> > > > > two user commands: triggering scans and aborting scans. The user should
> > > > > also be notified when a new beacon is received and also upon scan
> > > > > termination.
> > > > >
> > > > > A scan request structure is created to list the requirements and to be
> > > > > accessed asynchronously when changing channels or receiving beacons.
> > > > >
> > > > > Mac layers may now implement the ->trigger_scan() and ->abort_scan()
> > > > > hooks.
> > > > >
> > > > > Co-developed-by: David Girault <david.girault@qorvo.com>
> > > > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  include/linux/ieee802154.h |   3 +
> > > > >  include/net/cfg802154.h    |  25 +++++
> > > > >  include/net/nl802154.h     |  49 +++++++++
> > > > >  net/ieee802154/nl802154.c  | 215 +++++++++++++++++++++++++++++++++++++
> > > > >  net/ieee802154/nl802154.h  |   3 +
> > > > >  net/ieee802154/rdev-ops.h  |  28 +++++
> > > > >  net/ieee802154/trace.h     |  40 +++++++
> > > > >  7 files changed, 363 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
> > > > > index 0303eb84d596..b22e4147d334 100644
> > > > > --- a/include/linux/ieee802154.h
> > > > > +++ b/include/linux/ieee802154.h
> > > > > @@ -44,6 +44,9 @@
> > > > >  #define IEEE802154_SHORT_ADDR_LEN      2
> > > > >  #define IEEE802154_PAN_ID_LEN          2
> > > > >
> > > > > +/* Duration in superframe order */
> > > > > +#define IEEE802154_MAX_SCAN_DURATION   14
> > > > > +#define IEEE802154_ACTIVE_SCAN_DURATION        15
> > > > >  #define IEEE802154_LIFS_PERIOD         40
> > > > >  #define IEEE802154_SIFS_PERIOD         12
> > > > >  #define IEEE802154_MAX_SIFS_FRAME_SIZE 18
> > > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > > index d09c393d229f..76d4f95e9974 100644
> > > > > --- a/include/net/cfg802154.h
> > > > > +++ b/include/net/cfg802154.h
> > > > > @@ -18,6 +18,7 @@
> > > > >
> > > > >  struct wpan_phy;
> > > > >  struct wpan_phy_cca;
> > > > > +struct cfg802154_scan_request;
> > > > >
> > > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > > >  struct ieee802154_llsec_device_key;
> > > > > @@ -67,6 +68,10 @@ struct cfg802154_ops {
> > > > >                                 struct wpan_dev *wpan_dev, bool mode);
> > > > >         int     (*set_ackreq_default)(struct wpan_phy *wpan_phy,
> > > > >                                       struct wpan_dev *wpan_dev, bool ackreq);
> > > > > +       int     (*trigger_scan)(struct wpan_phy *wpan_phy,
> > > > > +                               struct cfg802154_scan_request *request);
> > > > > +       int     (*abort_scan)(struct wpan_phy *wpan_phy,
> > > > > +                             struct wpan_dev *wpan_dev);
> > > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > > >         void    (*get_llsec_table)(struct wpan_phy *wpan_phy,
> > > > >                                    struct wpan_dev *wpan_dev,
> > > > > @@ -278,6 +283,26 @@ struct ieee802154_coord_desc {
> > > > >         bool gts_permit;
> > > > >  };
> > > > >
> > > > > +/**
> > > > > + * struct cfg802154_scan_request - Scan request
> > > > > + *
> > > > > + * @type: type of scan to be performed
> > > > > + * @page: page on which to perform the scan
> > > > > + * @channels: channels in te %page to be scanned
> > > > > + * @duration: time spent on each channel, calculated with:
> > > > > + *            aBaseSuperframeDuration * (2 ^ duration + 1)
> > > > > + * @wpan_dev: the wpan device on which to perform the scan
> > > > > + * @wpan_phy: the wpan phy on which to perform the scan
> > > > > + */
> > > > > +struct cfg802154_scan_request {
> > > > > +       enum nl802154_scan_types type;
> > > > > +       u8 page;
> > > > > +       u32 channels;
> > > > > +       u8 duration;
> > > > > +       struct wpan_dev *wpan_dev;
> > > > > +       struct wpan_phy *wpan_phy;
> > > > > +};
> > > > > +
> > > > >  struct ieee802154_llsec_key_id {
> > > > >         u8 mode;
> > > > >         u8 id;
> > > > > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > > > > index b79a89d5207c..79fbd820b25a 100644
> > > > > --- a/include/net/nl802154.h
> > > > > +++ b/include/net/nl802154.h
> > > > > @@ -73,6 +73,9 @@ enum nl802154_commands {
> > > > >         NL802154_CMD_DEL_SEC_LEVEL,
> > > > >
> > > > >         NL802154_CMD_SCAN_EVENT,
> > > > > +       NL802154_CMD_TRIGGER_SCAN,
> > > > > +       NL802154_CMD_ABORT_SCAN,
> > > > > +       NL802154_CMD_SCAN_DONE,
> > > >
> > > > Is NL802154_CMD_SCAN_DONE reserved now? I don't see it implemented in
> > > > this series and I think we had some discussion about the need of abort
> > > > vs done. Is the event now?
> > >
> > > To be very honest I went back and forth about the "abort" information
> > > so I don't remember exactly what was supposed to be implemented. The
> > > current implementation forwards to userspace the reason (whether the
> > > scan was finished or was aborted for an external reason). So it is
> > > implemented this way:
> > >
> >
> > I think it was also to implement a way to signal all listeners that
> > there is such an operation ongoing? Do we have something like that?
>
> When the kernel receives a CMD_TRIGGER_SCAN it starts the scan and if
> everything is on track sends to the userspace listeners a
> CMD_TRIGGER_SCAN in return, meaning "a scan has started".
>
> So any listener would see:
> CMD_TRIGGER_SCAN
> SCAN_EVENT (+ content of the beacon)
> ...
> SCAN_EVENT (+ content of the beacon)
> CMD_SCAN_DONE (+ reason, see below)
>

okay.

> > > * Patch 6/6 adds in mac802154/scan.c:
> > >
> > > +       cmd = aborted ? NL802154_CMD_ABORT_SCAN : NL802154_CMD_SCAN_DONE;
> > > +       nl802154_scan_done(wpan_phy, wpan_dev, cmd);
> > >
> > > * And in patch 1/6, in ieee802154/nl802154.c:
> > >
> > > +static int nl802154_send_scan_msg(struct cfg802154_registered_device *rdev,
> > > +                                 struct wpan_dev *wpan_dev, u8 cmd)
> > > +{
> > > [...]
> > > +
> > > +       ret = nl802154_prep_scan_msg(msg, rdev, wpan_dev, 0, 0, 0, cmd);
> > >
> > > Is this working for you?
> >
> > Sure this works in some way, I would put a reason parameter on DONE,
> > but however...
>
> Of course, I can do that. So NL802154_CMD_SCAN_DONE plus an u8
> parameter:
> NL802154_SCAN_DONE_REASON_FINISHED
> NL802154_SCAN_DONE_REASON_ABORTED
> ?

yes, please.

- Alex


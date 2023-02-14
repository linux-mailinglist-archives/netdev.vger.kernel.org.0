Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3969657D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjBNN4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjBNN4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:56:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C80328846
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676382852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MIEkIiVTqaVyY4OQ1tNP7iNR8iBTofvIDcc0iTg4IAs=;
        b=YqJG0EjRIhMvSC1sqCVg/oTkC9lfHPtj53mbwuhV6f0N9vHFN04Ei8oX7yuVPk0gDcGwSu
        fwYbHq43yjiheB83uNLajAX/72Yc4f48rYxoSqhggc8hAobXa8TQ0wt0GSTXGxvnFHjdd5
        S7UMu/xwpnk2conXLJk8DZe20W7ps9s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-KcvVFkXQNZO_N3vBMrMs2g-1; Tue, 14 Feb 2023 08:54:10 -0500
X-MC-Unique: KcvVFkXQNZO_N3vBMrMs2g-1
Received: by mail-ed1-f71.google.com with SMTP id h10-20020a056402280a00b004acc6cf6322so4139678ede.18
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:54:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIEkIiVTqaVyY4OQ1tNP7iNR8iBTofvIDcc0iTg4IAs=;
        b=HTr0ZrXkxt/nh2g4GP70koMp79PY9bq3oCJ/u9Df9gZWWa2W6c/AbZ37ONLU6GWk6w
         SarszyB6aat5hZrISlDdezlfWYnBRvE6Wz3xT31/hEs2+4qwbDLBI8KxahndZL4dqri7
         bw6ijT8OylndnRFLAgAwpHYWlnurbnmHKXSs7B0Prtjb2mLEdpQkhhb5vKRZIRpv3bpE
         tyOiEgmidPnYWNLNdhp2p0VZ30uCLIXZh/TGemL5RaR0Iy66q8snv42hf1HpB9lK9I+9
         e3VGwVlguS30Yl0wg5hzWMqW+t7svG3lDonrXTRNbZuCVoIS1Dws7xoX6LaBm0DMyujy
         SmkQ==
X-Gm-Message-State: AO0yUKWd2J8xNgbmTxjlK0m/DX9gct4zkfmxbBbLpKIryajq5AD6u6dX
        lfUsAsRcTlmQqoNE0Bn1FXCcTPwv6TAoDbqAsxwkg/RUqbM6HkDreGHWYM/QWGGAq0rC3bLUbey
        haaesPqKp8ubp13I64G3nT73HCi8eXKPw
X-Received: by 2002:a17:907:984a:b0:87b:dce7:c245 with SMTP id jj10-20020a170907984a00b0087bdce7c245mr1345463ejc.3.1676382848810;
        Tue, 14 Feb 2023 05:54:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+7hadw1dxMPAFu31dJ7JmuVakzkY4sOW+RpBc7shHyANZKavUEiC33+IZbiihrMjT6nOWLp3Dzp5k6Uq9pLL8=
X-Received: by 2002:a17:907:984a:b0:87b:dce7:c245 with SMTP id
 jj10-20020a170907984a00b0087bdce7c245mr1345456ejc.3.1676382848675; Tue, 14
 Feb 2023 05:54:08 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
 <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
 <20230213183535.05e62c1c@xps-13> <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
In-Reply-To: <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 14 Feb 2023 08:53:57 -0500
Message-ID: <CAK-6q+jU7-ETKeoM=MLmfyMUqywteBC8sUAndRF1vx0PgA+WAA@mail.gmail.com>
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

On Tue, Feb 14, 2023 at 8:34 AM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > > > > > > +{
> > > > > > > +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > > > > > > +       struct net_device *dev = info->user_ptr[1];
> > > > > > > +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> > > > > > > +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > +       u8 type;
> > > > > > > +       int err;
> > > > > > > +
> > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > > > > > > +               return -EPERM;
> > > > > >
> > > > > > btw: why are monitors not allowed?
> > > > >
> > > > > I guess I had the "active scan" use case in mind which of course does
> > > > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > > > right now I don't remember why I strongly refused scans on monitors.
> > > >
> > > > Isn't it that scans really work close to phy level? Means in this case
> > > > we disable mostly everything of MAC filtering on the transceiver side.
> > > > Then I don't see any reasons why even monitors can't do anything, they
> > > > also can send something. But they really don't have any specific
> > > > source address set, so long addresses are none for source addresses, I
> > > > don't see any problem here. They also don't have AACK handling, but
> > > > it's not required for scan anyway...
> > > >
> > > > If this gets too complicated right now, then I am also fine with
> > > > returning an error here, we can enable it later but would it be better
> > > > to use ENOTSUPP or something like that in this case? EPERM sounds like
> > > > you can do that, but you don't have the permissions.
> > > >
> > >
> > > For me a scan should also be possible from iwpan phy $PHY scan (or
> > > whatever the scan command is, or just enable beacon)... to go over the
> > > dev is just a shortcut for "I mean whatever the phy is under this dev"
> > > ?
> >
> > Actually only coordinators (in a specific state) should be able to send
> > beacons, so I am kind of against allowing that shortcut, because there
> > are usually two dev interfaces on top of the phy's, a regular "NODE"
> > and a "COORD", so I don't think we should go that way.
> >
> > For scans however it makes sense, I've added the necessary changes in
> > wpan-tools. The TOP_LEVEL(scan) macro however does not support using
> > the same command name twice because it creates a macro, so this one
> > only supports a device name (the interface command has kind of the same
> > situation and uses a HIDDEN() macro which cannot be used here).
> >
>
> Yes, I was thinking about scanning only.
>
> > So in summary here is what is supported:
> > - dev <dev> beacon
> > - dev <dev> scan trigger|abort
> > - phy <phy> scan trigger|abort
> > - dev <dev> scan (the blocking one, which triggers, listens and returns)
> >
> > Do you agree?
> >
>
> Okay, yes. I trust you.

btw: at the point when a scan requires a source address... it cannot
be done because then a scan is related to a MAC instance -> an wpan
interface and we need to bind to it. But I think it doesn't?

- Alex


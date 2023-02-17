Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E186769A4E9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 05:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBQEfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 23:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBQEfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 23:35:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80202CC42
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 20:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676608484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eIgQlEwJnCy9d00AQ+rz137v5zW738sYvywCgTZylJk=;
        b=aM7qjvcjKqNaQFfECU+BpJb3/YYiLY75StQgOF9Uy2jQ+zlcfBeAYRdkJZuVVfMCJ6jfDt
        c44CmpK/SOmbf2NqnNUBx+Wnf5YNPs4+7NIQURwOe57GQJ9cv5e3tYZHW7R16nXf0VlZeC
        Z7QlnZGeOwUsLYtbqeqMKrh0LPlCMH0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-345-wBDN7tAcMp-1VZ3ACwfnog-1; Thu, 16 Feb 2023 23:34:43 -0500
X-MC-Unique: wBDN7tAcMp-1VZ3ACwfnog-1
Received: by mail-ed1-f69.google.com with SMTP id bd13-20020a056402206d00b004acd97105ffso378916edb.19
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 20:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eIgQlEwJnCy9d00AQ+rz137v5zW738sYvywCgTZylJk=;
        b=oaVr3ZERQjlUI2yT2xJuGWzLbwNpcJjWpKWtvn8MF1Qvfdq5WBrkxBhSYDxku/oAsM
         eIJNyoWETfK9hGGD8PC/ZaIMN7etQvJusokjrglnQAI442ykNcyfyZ1Z+CQXLmaQvRXB
         ouiLKR+uxS9wM2pSwVzIh2Ffnrzbmd3M/Ou0wMWk+/4VOIaP2IBRb/A03VYuJg0DVJnH
         si5f2z9Ep6dpv95jZC1n5K6Bffz2PfQcrQzrtsicx3zNMEqbpfA2vObbjRH1dVN6YNYc
         mKIVtMg2mlJzJKloXqa0NutK5ABxoyRroA9Dn3/ds52OtcF3TCH6RWJBOjhijQq7lF/E
         aVaw==
X-Gm-Message-State: AO0yUKV6l36EPp6Z9esHjaBY1Xkuuio5QRMGXgTm+0ucPPlgbckIDpCf
        Fr0QlPkGUZUYvTNSU+xUKe5GLFhMyiP6KWMKdnP2yELJLn/jrYu4BNUKLZp8cLBg43E6EWhDbYs
        B6Tvu6sTTTF7wmYsDGvBpCoOioK0fgj7c
X-Received: by 2002:a50:bb48:0:b0:4ac:b8e1:7410 with SMTP id y66-20020a50bb48000000b004acb8e17410mr4260785ede.6.1676608482410;
        Thu, 16 Feb 2023 20:34:42 -0800 (PST)
X-Google-Smtp-Source: AK7set+5Ti3djw2yFVhoI+y7tZlsm+4W2pFRnsOOLKoZoqh97EE8oGOMho85aIb01RIqFCxJ4FVFz+8Zi7QTMfkWmLU=
X-Received: by 2002:a50:bb48:0:b0:4ac:b8e1:7410 with SMTP id
 y66-20020a50bb48000000b004acb8e17410mr4260779ede.6.1676608482124; Thu, 16 Feb
 2023 20:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
 <CAK-6q+jbcMZK16pfZTb5v8-jvhmvk9-USr6hZE34H1MOrpF=JQ@mail.gmail.com>
 <20230213183535.05e62c1c@xps-13> <CAK-6q+hkJpqNG9nO_ugngjGQ_q9VdLu+xDjmD09MT+5=tvd0QA@mail.gmail.com>
 <CAK-6q+jU7-ETKeoM=MLmfyMUqywteBC8sUAndRF1vx0PgA+WAA@mail.gmail.com> <20230214150600.1c21066b@xps-13>
In-Reply-To: <20230214150600.1c21066b@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 16 Feb 2023 23:34:30 -0500
Message-ID: <CAK-6q+g233giuLd56p0G5TqGF+S-NWSkD2MF5nhP+0HLxwnkCA@mail.gmail.com>
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

On Tue, Feb 14, 2023 at 9:07 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:53:57 -0500:
>
> > Hi,
> >
> > On Tue, Feb 14, 2023 at 8:34 AM Alexander Aring <aahringo@redhat.com> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, Feb 13, 2023 at 12:35 PM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > > > > > > > > +{
> > > > > > > > > +       struct cfg802154_registered_device *rdev = info->user_ptr[0];
> > > > > > > > > +       struct net_device *dev = info->user_ptr[1];
> > > > > > > > > +       struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
> > > > > > > > > +       struct wpan_phy *wpan_phy = &rdev->wpan_phy;
> > > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > > +       u8 type;
> > > > > > > > > +       int err;
> > > > > > > > > +
> > > > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > > > +       if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > > > > > > > > +               return -EPERM;
> > > > > > > >
> > > > > > > > btw: why are monitors not allowed?
> > > > > > >
> > > > > > > I guess I had the "active scan" use case in mind which of course does
> > > > > > > not work with monitors. Maybe I can relax this a little bit indeed,
> > > > > > > right now I don't remember why I strongly refused scans on monitors.
> > > > > >
> > > > > > Isn't it that scans really work close to phy level? Means in this case
> > > > > > we disable mostly everything of MAC filtering on the transceiver side.
> > > > > > Then I don't see any reasons why even monitors can't do anything, they
> > > > > > also can send something. But they really don't have any specific
> > > > > > source address set, so long addresses are none for source addresses, I
> > > > > > don't see any problem here. They also don't have AACK handling, but
> > > > > > it's not required for scan anyway...
> > > > > >
> > > > > > If this gets too complicated right now, then I am also fine with
> > > > > > returning an error here, we can enable it later but would it be better
> > > > > > to use ENOTSUPP or something like that in this case? EPERM sounds like
> > > > > > you can do that, but you don't have the permissions.
> > > > > >
> > > > >
> > > > > For me a scan should also be possible from iwpan phy $PHY scan (or
> > > > > whatever the scan command is, or just enable beacon)... to go over the
> > > > > dev is just a shortcut for "I mean whatever the phy is under this dev"
> > > > > ?
> > > >
> > > > Actually only coordinators (in a specific state) should be able to send
> > > > beacons, so I am kind of against allowing that shortcut, because there
> > > > are usually two dev interfaces on top of the phy's, a regular "NODE"
> > > > and a "COORD", so I don't think we should go that way.
> > > >
> > > > For scans however it makes sense, I've added the necessary changes in
> > > > wpan-tools. The TOP_LEVEL(scan) macro however does not support using
> > > > the same command name twice because it creates a macro, so this one
> > > > only supports a device name (the interface command has kind of the same
> > > > situation and uses a HIDDEN() macro which cannot be used here).
> > > >
> > >
> > > Yes, I was thinking about scanning only.
> > >
> > > > So in summary here is what is supported:
> > > > - dev <dev> beacon
> > > > - dev <dev> scan trigger|abort
> > > > - phy <phy> scan trigger|abort
> > > > - dev <dev> scan (the blocking one, which triggers, listens and returns)
> > > >
> > > > Do you agree?
> > > >
> > >
> > > Okay, yes. I trust you.
> >
> > btw: at the point when a scan requires a source address... it cannot
> > be done because then a scan is related to a MAC instance -> an wpan
> > interface and we need to bind to it. But I think it doesn't?
>
> I'm not sure I follow you here. You mean in case of active scan? The
> operation is always tight to a device in the end, even if you provide a
> phy in userspace. So I guess it's not a problem. Or maybe I didn't get
> the question right?

As soon scan requires to put somewhere mib values inside e.g. address
information (which need to compared to source address settings (mib)?)
then it's no longer a phy operation -> wpan_phy, it is binded to a
wpan_dev (mac instance on a phy). But the addresses are set to NONE
address type?
I am not sure where all that data is stored right now for a scan
operation, if it's operating on a phy it should be stored on wpan_phy.

Note: there are also differences between wpan_phy and
ieee802154_local, also wpan_dev and ieee802154_sub_if_data structures.
It has something to do with visibility and SoftMAC vs HardMAC, however
the last one we don't really have an infrastructure for and we
probably need to move something around there. In short
wpan_phy/wpan_dev should be only visible by HardMAC (I think) and the
others are only additional data for the same instances used by
mac802154...

- Alex


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BC0552931
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 04:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245364AbiFUCAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 22:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245502AbiFUCAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 22:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AAFA1CB04
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655776843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=klZr8mL9tpedL2IJ12vEkhVfm55k6eJ9xXpUbFx/f8c=;
        b=eTT49ws5F8Fhh6jMHKyBsF2N0K7/vIkNyk0Y+ar9RNK9IQp9LeNa/1jQoOHvRGyBAU950R
        ZdCqASEHGLM5+chlULBl1il7GLeUql7ENimrVIG+PRtFO8kMri5wBmhEKQ+0fHQQbr9v7z
        Fzz3kaAI9d2/N5BO5v8xiyyZGxWOgDE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-eHIwBn9cME2cckv-wQQH3g-1; Mon, 20 Jun 2022 22:00:41 -0400
X-MC-Unique: eHIwBn9cME2cckv-wQQH3g-1
Received: by mail-qk1-f199.google.com with SMTP id w22-20020a05620a445600b006a6c18678f2so14887001qkp.4
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:00:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=klZr8mL9tpedL2IJ12vEkhVfm55k6eJ9xXpUbFx/f8c=;
        b=yx1FOdqzHQDeHgMIAIZTUS+TrrryZboG4ZksPgtTeNegtMnSRqGg8AnQibRx7SqUuE
         nTkcIV59dDOzAfQzMDm6sbsFUnA4UWxFe1MW0CGaxs9WKiI3W/0cps6bwAKdiJdK7yVF
         wHdTY1jA8C94tjSp6OqX/ksahvHpIQL6YX+N4BDZew+TY0byQxHld6JSY/g1QOJzgzFB
         SNCQxXQFw8/Dnbeg+BsKDgfkBarN/fYeTMQT4bgAjp3YH46oUO9nFsAxitRrYAnnufrh
         z4/oxHVDS/dB2EbBbN2szBmZAEbdT4I3I9PylfIe7Hax51UO+bTr3jwGdBvTMM5ocgc+
         i3VA==
X-Gm-Message-State: AJIora9QmZQdTHW8Sv3N7eYkC2wysRg3v13aQkAvhKO87lhSdTZY80wg
        9Ub/W1XqWRbs5q7b+LEYFcoruQoA6aCpq2yrTfbC1NrGI7vv2bYMistkChvpVXn8K6zoPbrzp4r
        CRQ9ftTYsQxzGsvEClLvwRIGulOIcAFtE
X-Received: by 2002:a05:6214:628:b0:46b:188b:b8ac with SMTP id a8-20020a056214062800b0046b188bb8acmr21292402qvx.28.1655776841276;
        Mon, 20 Jun 2022 19:00:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uKTWra6g+3tPLcrKtBHQgDvdhG9gubVxF0Si1WHvqjU6BPumNkpvSC59XTqt8UpfgQJAgXR5L/rguXAIhMda4=
X-Received: by 2002:a05:6214:628:b0:46b:188b:b8ac with SMTP id
 a8-20020a056214062800b0046b188bb8acmr21292387qvx.28.1655776841039; Mon, 20
 Jun 2022 19:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
 <20220617193254.1275912-2-miquel.raynal@bootlin.com> <CAK-6q+g7pd14Bhng9r210kROttwtqQkF1JgAF283B9MPc22g3g@mail.gmail.com>
 <20220620112527.48c7ba54@xps-13>
In-Reply-To: <20220620112527.48c7ba54@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 20 Jun 2022 22:00:30 -0400
Message-ID: <CAK-6q+hXkAR6TZp0+Mb0y47NVNf6+1Axnt_UVZEemi-GoHWCFw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/6] net: ieee802154: Create a device type
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 20, 2022 at 5:26 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> aahringo@redhat.com wrote on Sun, 19 Jun 2022 20:18:43 -0400:
>
> > Hi,
> >
> > On Fri, Jun 17, 2022 at 3:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > A device can be either a fully functioning device or a kind of reduced
> > > functioning device. Let's create a device type member. Drivers will be
> > > in charge of setting this value if they handle non-FFD devices.
> > >
> > > FFD are considered the default.
> > >
> > > Provide this information in the interface get netlink command.
> > >
> > > Create a helper just to check if a rdev is a FFD or not, which will
> > > then be useful when bringing scan support.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/nl802154.h    | 9 +++++++++
> > >  net/ieee802154/core.h     | 8 ++++++++
> > >  net/ieee802154/nl802154.c | 6 +++++-
> > >  3 files changed, 22 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > > index 145acb8f2509..5258785879e8 100644
> > > --- a/include/net/nl802154.h
> > > +++ b/include/net/nl802154.h
> > > @@ -133,6 +133,8 @@ enum nl802154_attrs {
> > >         NL802154_ATTR_PID,
> > >         NL802154_ATTR_NETNS_FD,
> > >
> > > +       NL802154_ATTR_DEV_TYPE,
> > > +
> > >         /* add attributes here, update the policy in nl802154.c */
> > >
> > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > @@ -163,6 +165,13 @@ enum nl802154_iftype {
> > >         NL802154_IFTYPE_MAX = NUM_NL802154_IFTYPES - 1
> > >  };
> > >
> > > +enum nl802154_dev_type {
> > > +       NL802154_DEV_TYPE_FFD = 0,
> > > +       NL802154_DEV_TYPE_RFD,
> > > +       NL802154_DEV_TYPE_RFD_RX,
> > > +       NL802154_DEV_TYPE_RFD_TX,
> > > +};
> >
> > As I said in another mail, I think this is a "transceiver capability"
>
> Maybe I can rename it to PHY_TYPE if you prefer.
>
> > why it is required that a user sets a transceiver capability. It means
> > that you can actually buy hardware which is either one of those
> > capabilities, one reason why D in those acronyms stands for "Device".
>
> The user is not supposed to set this field, but it can get this field.
> This is what this enumeration is intended for.
>

I am sorry, I misunderstood it.

> > In SoftMac you probably find only FFD but out there you would probably
> > find hardware which cannot run as e.g. coordinator and is a RFD.
>
> My main concern was initially to be sure that we would not try to
> perform any unsupported MLME commands on these devices. But as you said
> in another mail, it is highly unlikely that we will ever have to support
> true RFD devices in Linux, so I can just drop this parameter.
>

oh, I think on HardMAC it can become more likely... for me is just the
question of FFD and RFD which kind of interfaces the driver supports
to create on. Forget about that RX, TX, thing... RX is your
transmitting something it will go to /dev/null and TX is for me... you
will not receive anything.
We mostly have FFD transceivers supported, except that HardMAC thing
which is somehow connected to SoftMAC and needs to be handled somehow
a little bit differently because of this situation... but I warned
them that the time will come that "just send dataframes out" will
come...

- Alex


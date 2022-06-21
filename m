Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17903552937
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 04:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241989AbiFUCDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 22:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245318AbiFUCD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 22:03:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EF9F1572E
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655777005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sc9+QmaUzTW0x6jUSO8l3xBhxoKbuPPF93VfdUZLmjs=;
        b=Rl1p8wFxtk67be4zZaT+CO67KaHzJcZBZdZaJszzci6Hh6dTq3c3b1L3pC3spC7xWVTk79
        rjjRoN2YwYUUiqT6zRn9EWaNHASgb3Fx1UeD9xdKk1Hgoxeoh5y1bxd3FnY/d5Jqffzob7
        utL2LbopCG1OKnJtEmGGdYka4iGtIwc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-sZ4_CIq1Ou2sE4c7Nv1coA-1; Mon, 20 Jun 2022 22:03:24 -0400
X-MC-Unique: sZ4_CIq1Ou2sE4c7Nv1coA-1
Received: by mail-qk1-f198.google.com with SMTP id u8-20020a05620a454800b006a74e6b39eeso14851790qkp.12
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sc9+QmaUzTW0x6jUSO8l3xBhxoKbuPPF93VfdUZLmjs=;
        b=r6GpZ38hvT6PhQ6btaMBHAsyaocx83ZS8jvVBgI4woZ1+7BXYxLM3vLybt+2e/NBRJ
         gCX1EEJjAxwTZ4/ccGaYCDEO7yNS1R8HA4iJEy6ik8YH1y5dGOUHGBhS36DukJ0CBujR
         49UE+K2SMRoGqmKbL/ieGZAsvdtgAeCWLgIIcCDqCJz2kfjJ7NKMhEQRMERYdVzL2B61
         XIaiChW21FvRcCzZAwMw0DaOqPHc9b0bi1Z3yIS3G6VUrqX+Ys7fNvn1JTqfm25OMHBz
         5XXl17TbePMN+sczFfzVXjYdgk7bvYjAqmgNd7BKmGW49ZuYx4eRL0/MRfsatOJ1cL3N
         mw5A==
X-Gm-Message-State: AJIora8128N96lW4rPWRtr8cCAeronTAM+pLzsTrD/e8hIaTiWbXA5Y+
        M9XmJ//noibqiLvucqPZcQdv6AP87HATj1/p7FI85la8OdkZiPiZWorFPW1vhZJ+cQrG+ZpNUDK
        yJE77VEjUpNyeDtYKTcikCJnVskzgSPJ/
X-Received: by 2002:a05:620a:6006:b0:6a6:c005:7c14 with SMTP id dw6-20020a05620a600600b006a6c0057c14mr18192128qkb.691.1655777003974;
        Mon, 20 Jun 2022 19:03:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tUxiOGt03wuL71/Doq0Ng52YMs8jynAKxxkcNzgg4R34zSFenI2NLNmjZ5S0OWc1DoRaqtg7hDp78r7hnrx1U=
X-Received: by 2002:a05:620a:6006:b0:6a6:c005:7c14 with SMTP id
 dw6-20020a05620a600600b006a6c0057c14mr18192117qkb.691.1655777003764; Mon, 20
 Jun 2022 19:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
 <20220617193254.1275912-3-miquel.raynal@bootlin.com> <CAK-6q+iJaZvtxXsFTPsYyWsDYmKhgVsMHKcDUCrCqmUR2YpEjg@mail.gmail.com>
 <20220620112834.7e8721a0@xps-13>
In-Reply-To: <20220620112834.7e8721a0@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 20 Jun 2022 22:03:12 -0400
Message-ID: <CAK-6q+gN3vJvOmdQdX4dYuqT4vcDHfiYeV8CWVix_UOKcBa_Fw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 2/6] net: ieee802154: Ensure only FFDs can
 become PAN coordinators
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

On Mon, Jun 20, 2022 at 5:28 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> aahringo@redhat.com wrote on Sun, 19 Jun 2022 20:24:48 -0400:
>
> > Hi,
> >
> > On Fri, Jun 17, 2022 at 3:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > This is a limitation clearly listed in the specification. Now that we
> > > have device types,let's ensure that only FFDs can become PAN
> > > coordinators.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/ieee802154/nl802154.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > > index 638bf544f102..0c6fc3385320 100644
> > > --- a/net/ieee802154/nl802154.c
> > > +++ b/net/ieee802154/nl802154.c
> > > @@ -924,6 +924,9 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
> > >                         return -EINVAL;
> > >         }
> > >
> > > +       if (type == NL802154_IFTYPE_COORD && !cfg802154_is_ffd(rdev))
> > > +               return -EINVAL;
> > > +
> >
> > Look at my other mail regarding why the user needs to set this device
> > capability, change the errno to "EOPNOTSUPP"... it would be nice to
> > have an identically nl80211 handling like nl80211 to see which
> > interfaces are supported. Please look how wireless is doing that and
> > probably we should not take the standard about those "wording" too
> > seriously. What I mean is that according to FFD or RFD it's implied on
> > what interfaces you can create on.
>
> This is true, I don't need this _is_ffd() helper, checking on the type
> of interface should be enough. I will drop the DEV(PHY)_TYPE enum

as I said that the driver needs somehow to report which interface can
be created on the phy and such thing also exists in wireless inclusive
netlink attribute to check which iftypes are supported (by calling
iw)... you can map this information to if it's FFD or RFD. I am not
sure if such an option makes sense now because we mostly have FFD only
supported right now.

- Alex


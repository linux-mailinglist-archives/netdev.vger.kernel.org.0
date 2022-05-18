Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18852B9AD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiERMGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbiERMGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:06:13 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F023B8;
        Wed, 18 May 2022 05:06:12 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u30so3217473lfm.9;
        Wed, 18 May 2022 05:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ylo1QhxU2T8oVyW34oyE8KHWeXlZLcaPL2RcWN9uY4=;
        b=gLxVxLa3SXkJNfSCcFq7G3SkqsEgE2QiadxDXb8qI39bLKw5/2Mh+DI9y24q8bR1NL
         GT4WEwOSMGMBU3UmUYgyzTgyl+F+JGtRp/ehvRTC9whZkZdQjAy8Ijq/s00S7pixSbkg
         JQBNC/cV5vz+Aby0KSY/HCw4zY0RHIgyz+jaN7dIK5CpUsubvRXUdHmYJmLoBuJgQp1n
         rAPashabkSBNM/GqXizfs7I9uNnVW4eK7wN/4wzsuepQUCNr5XqVz7Gm5Wu7gyjpFSwJ
         bHEquaw5SwU1CorsVpXbPzdkQRXbUKcEt+/rjOLKCwQfzOjNfgzovZZfH8oEPU039C0C
         ZWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ylo1QhxU2T8oVyW34oyE8KHWeXlZLcaPL2RcWN9uY4=;
        b=fAHPaxcQRSIP9KimnwVEuDsvG1OklrctiX9O17uRwwoZ/OeGBdXHzgdBKJWHytWJqz
         6+fUEp4+hlfby4QDxSQfwP5IzHXU+80nqP3dcyGAYXANLDU/8v0BNGQRVLMf96tgPgr8
         jHY4u9/c85kiU1QKt4B3nCPdrgT2RzACyMRD/e3NDIquN8qBkxdUkCsu3tqtxICRzTq8
         D+wBsTS6YS7f2q6+fvNfaSyuLbZBT7WOdt1oaY4dYvqTKUsyPJc0Xqpe5aDgurOUlUbz
         AT5nIFFOK0ig4E3rZuaCRGQcfaQ0HaF22rN+4zoiOyPwM+p7n3wELNIFSVLpkq50K/Bb
         73Cg==
X-Gm-Message-State: AOAM53211QOl1jICANgxCdT+uoZcjDiWSLskM+rKhQzr4+eWWG4JmHE0
        wIoPOK2UC3EFMo67zSnUE9Ht+mfiTbZwvL6DFug=
X-Google-Smtp-Source: ABdhPJwCKEotBOk/h/BVMLEmqrN/Jcle36SoBbOF6poIosWJae9eGy/CdO0OZkITLtq26D66UVk6X5hCFrURaA+DHGY=
X-Received: by 2002:a05:6512:3b28:b0:473:b9ec:187e with SMTP id
 f40-20020a0565123b2800b00473b9ec187emr20091694lfv.536.1652875570826; Wed, 18
 May 2022 05:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
 <20220512143314.235604-10-miquel.raynal@bootlin.com> <CAK-6q+ipHdD=NJB2N7SHQ0TUvNpc0GQXZ7dWM9nDxqyqNgxdSA@mail.gmail.com>
 <CAK-6q+i_T+FaK0tX6tF38VjyEfSzDi-QC85MTU2=4soepAag8g@mail.gmail.com>
 <20220517153045.73fda4ee@xps-13> <CAK-6q+h1fmJZobmUG5bUL3uXuQLv0kvHUv=7dW+fOCcgbrdPiA@mail.gmail.com>
 <20220518121200.2f08a6b1@xps-13>
In-Reply-To: <20220518121200.2f08a6b1@xps-13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 18 May 2022 08:05:46 -0400
Message-ID: <CAB_54W6XN4kytUMgMveVF7n7TPh+w75-ew25rVt-eUQiCgNuGw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 18, 2022 at 6:12 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
>
> aahringo@redhat.com wrote on Tue, 17 May 2022 21:14:03 -0400:
>
> > Hi,
> >
> > On Tue, May 17, 2022 at 9:30 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > >
> > > aahringo@redhat.com wrote on Sun, 15 May 2022 19:03:53 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Sun, May 15, 2022 at 6:28 PM Alexander Aring <aahringo@redhat.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> > > > > <miquel.raynal@bootlin.com> wrote:
> > > > > >
> > > > > > This is the slow path, we need to wait for each command to be processed
> > > > > > before continuing so let's introduce an helper which does the
> > > > > > transmission and blocks until it gets notified of its asynchronous
> > > > > > completion. This helper is going to be used when introducing scan
> > > > > > support.
> > > > > >
> > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > ---
> > > > > >  net/mac802154/ieee802154_i.h |  1 +
> > > > > >  net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
> > > > > >  2 files changed, 26 insertions(+)
> > > > > >
> > > > > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > > > > index a057827fc48a..f8b374810a11 100644
> > > > > > --- a/net/mac802154/ieee802154_i.h
> > > > > > +++ b/net/mac802154/ieee802154_i.h
> > > > > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > > > > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > > > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
> > > > > >  netdev_tx_t
> > > > > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > > > > >  netdev_tx_t
> > > > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > > > index 38f74b8b6740..ec8d872143ee 100644
> > > > > > --- a/net/mac802154/tx.c
> > > > > > +++ b/net/mac802154/tx.c
> > > > > > @@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> > > > > >         return ieee802154_sync_queue(local);
> > > > > >  }
> > > > > >
> > > > > > +int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > > > +{
> > > > > > +       int ret;
> > > > > > +
> > > > > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > > > > +        * MLME transmissions.
> > > > > > +        */
> > > > > > +       rtnl_lock();
> > > > >
> > > > > I think we should make an ASSERT_RTNL() here, the lock needs to be
> > > > > earlier than that over the whole MLME op. MLME can trigger more than
> > > >
> > > > not over the whole MLME_op, that's terrible to hold the rtnl lock so
> > > > long... so I think this is fine that some netdev call will interfere
> > > > with this transmission.
> > > > So forget about the ASSERT_RTNL() here, it's fine (I hope).
> > > >
> > > > > one message, the whole sync_hold/release queue should be earlier than
> > > > > that... in my opinion is it not right to allow other messages so far
> > > > > an MLME op is going on? I am not sure what the standard says to this,
> > > > > but I think it should be stopped the whole time? All those sequence
> > > >
> > > > Whereas the stop of the netdev queue makes sense for the whole mlme-op
> > > > (in my opinion).
> > >
> > > I might still implement an MLME pre/post helper and do the queue
> > > hold/release calls there, while only taking the rtnl from the _tx.
> > >
> > > And I might create an mlme_tx_one() which does the pre/post calls as
> > > well.
> > >
> > > Would something like this fit?
> >
> > I think so, I've heard for some transceiver types a scan operation can
> > take hours... but I guess whoever triggers that scan in such an
> > environment knows that it has some "side-effects"...
>
> Yeah, a scan requires the data queue to be stopped and all incoming
> packets to be dropped (others than beacons, ofc), so users must be
> aware of this limitation.

I think there is a real problem about how the user can synchronize the
start of a scan and be sure that at this point everything was
transmitted, we might need to real "flush" the queue. Your naming
"flush" is also wrong, It will flush the framebuffer(s) of the
transceivers but not the netdev queue... and we probably should flush
the netdev queue before starting mlme-op... this is something to add
in the mlme_op_pre() function.

- Alex

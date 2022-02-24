Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F774C215E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiBXByX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiBXByX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:54:23 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1992B2F029;
        Wed, 23 Feb 2022 17:53:54 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e2so761251ljq.12;
        Wed, 23 Feb 2022 17:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNixjqEdvg1jUTP8hxqpAK/scFhfE8wor5fVbIFu8aI=;
        b=dqVRkM5iqVKF6RB7x8u6HNBrVW72uggdwvkv+CKvrb9mvcEgaKfO08HiEJCrBkQ/qY
         vmvPDKOQdA7OAL4L5uV0Nodeuk2p2O0/xPFgR4cipl6qW+tCZRKgkeNVjtSZUx5UfbJw
         KLwmLy555cVQ9f4z1juFmUnx9U+NCcWc8oBAVsgGMvm4R34Q+muYNfkVzOZNbGkmDSP0
         1gX9l2zGHQ+8nWi19ZoNwKkQxbIKMsMv2oRAm3VN4ldl2Y7KBTxSUV/i5brqBqH04/hm
         yg2FxWOefYdIbkrCcJJ4twa6y0YSOsa1IZeqKJkG91sq3O8wnrWxAhp/PkpxSw0H5pGn
         bjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNixjqEdvg1jUTP8hxqpAK/scFhfE8wor5fVbIFu8aI=;
        b=oHLjBrqbh8gx9sxlW+qo9TqRvaUaMSeB/xJx3hOObebFBQfsCHcOOdiioehqtRMvOH
         z+VSjJ+rA4cdRpBr1VevHNK0BdPIRDk10oVZVNBrAbpIAOubUfzGH/mOlHDufFUKgaOe
         8QdEwa/d5eY5M3FJkEkbvH0vA+CpX9S0/ZX74H+q8mJIiRJH4vbKTsIcKDDAEhtCWgiA
         M5EfxqCQ34fojGLwhPICUU71h1RtQ5lBqPkFdy/YHv3FxmuPSH3IRAJ0pmZG6ZuKTL7e
         h/jZqMYJWuR7VCObL8b42GJyZUC/hHVmwiXR4ZXx3eZHzyvOyksDGdEeRNsmt7rUkYDl
         uGwQ==
X-Gm-Message-State: AOAM531gDho0+lYLDGZu0532GtP+4zcA4r0Q9FqpFu7hEMb6zlH1PGJ/
        Tby++zApy0QL2AoI7q3tNCsbNsDdP0+hhki3BCY=
X-Google-Smtp-Source: ABdhPJwZLQtkqcx5wkkbO74PxG/dLU0Fz6qnSP7eTR4+0BuPikfygPrFAVTlBDaKNqKayo1m9WFEsDHATiNDqo0H9JE=
X-Received: by 2002:a2e:7a15:0:b0:244:c138:7379 with SMTP id
 v21-20020a2e7a15000000b00244c1387379mr333586ljc.312.1645667632219; Wed, 23
 Feb 2022 17:53:52 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-3-miquel.raynal@bootlin.com> <CAK-6q+iebK43LComxxjvg0pBiD_AK0MMyMucLHmeVG2zbHPErQ@mail.gmail.com>
 <CAB_54W6iBmxnRjdjmbWTPzci0za7Lu5UwVFqLJsjQFacxAYQYQ@mail.gmail.com> <20220222094300.698c39c9@xps13>
In-Reply-To: <20220222094300.698c39c9@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 23 Feb 2022 20:53:40 -0500
Message-ID: <CAB_54W6TewPW3VU4PbcPdpW0XGT8-urGP1xrBpJzoM_ANd+49Q@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 02/14] net: mac802154: Create a transmit
 error helper
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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

On Tue, Feb 22, 2022 at 3:43 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Mon, 21 Feb 2022 15:22:40 -0500:
>
> > Hi,
> >
> > On Sun, Feb 20, 2022 at 6:31 PM Alexander Aring <aahringo@redhat.com> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, Feb 7, 2022 at 10:09 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > So far there is only a helper for successful transmission, which led
> > > > device drivers to implement their own handling in case of
> > > > error. Unfortunately, we really need all the drivers to give the hand
> > > > back to the core once they are done in order to be able to build a
> > > > proper synchronous API. So let's create a _xmit_error() helper.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/net/mac802154.h | 10 ++++++++++
> > > >  net/mac802154/util.c    | 10 ++++++++++
> > > >  2 files changed, 20 insertions(+)
> > > >
> > > > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > > > index 2c3bbc6645ba..9fe8cfef1ba0 100644
> > > > --- a/include/net/mac802154.h
> > > > +++ b/include/net/mac802154.h
> > > > @@ -498,4 +498,14 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw);
> > > >  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
> > > >                               bool ifs_handling);
> > > >
> > > > +/**
> > > > + * ieee802154_xmit_error - frame transmission failed
> > > > + *
> > > > + * @hw: pointer as obtained from ieee802154_alloc_hw().
> > > > + * @skb: buffer for transmission
> > > > + * @ifs_handling: indicate interframe space handling
> > > > + */
> > > > +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
> > > > +                          bool ifs_handling);
> > > > +
> > > >  #endif /* NET_MAC802154_H */
> > > > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > > > index 6f82418e9dec..9016f634efba 100644
> > > > --- a/net/mac802154/util.c
> > > > +++ b/net/mac802154/util.c
> > > > @@ -102,6 +102,16 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
> > > >  }
> > > >  EXPORT_SYMBOL(ieee802154_xmit_complete);
> > > >
> > > > +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
> > > > +                          bool ifs_handling)
> > > > +{
> > > > +       unsigned int skb_len = skb->len;
> > > > +
> > > > +       dev_kfree_skb_any(skb);
> > > > +       ieee802154_xmit_end(hw, ifs_handling, skb_len);
> > > > +}
> > >
> > > Remove ieee802154_xmit_end() function and just call to wake up the
> > > queue here, also drop the "ifs_handling" parameter here.
> >
> > I am sorry, I think I should deliver an explanation here... I think
> > the handling of success and error paths are just too different. In
> > error there will also never ifs handling in the error path. Also
> > please note there are not just errors as bus/transceiver errors, in
> > future transceiver should also deliver [0] to the caller, in sync
> > transmit it should return those errors to the caller... in async mode
> > there exists different ways to deliver errors like (no ack) to user
> > space by using socket error queue, here again is worth to look into
> > wireless subsystem which have a similar feature.
> >
> > The errors in [0] are currently ignored but I think should be switched
> > some time soon or with an additional patch by you to calling
> > xmit_error with an int for $REASON. Those errors are happening on the
> > transceiver because some functionality is offloaded. btw: so far I
> > know some MLME-ops need to know if an ack is received or not.
> >
> > You can split the functionality somehow it makes sense, but with the
> > above change I only see the wake up queue is the only thing that both
> > (success/error) should have in common.
>
> Very clear, thanks for the additional details. Indeed I would find much
> better to be able to propagate the error reasons to upper layers. Even
> though at this time we don't propagate them all the way up to userspace,
> having them *at least* in the ieee core would be a nice feature. I'll
> see what I can do.
>

For now I think we can live with "success" or "error". It would be
nice to have a reason and it is definitely necessary in future use.
The case NO_ACK is a very specific 802.15.4 case which I think is
important/sometimes even required to know and I would put it as an
error, that means it was not received on the other end. Of course this
error makes only sense if ack request bit was set and the transceiver
should only inform about it if it was set. The other errors which
might occur e.g. channel access failure... it might be that
transceivers handle such cases "differently?" Even I don't even know
if all transceivers have a functionality to request if there was an
ack or not (in case of offloaded ARET handling). In my opinion they
should at least have the possibility to report back if there was an
ack or not, if they don't have such functionality we might always
"think" there was an ack but the transceiver would act sometimes a
little bit weird. At this point I would blame the hardware because it
cannot report it.

However, as I see in the at86rf230 driver there can be different
success cases and different error cases... you don't need to support
that. We currently handle only some bus/misc transceiver issues which
should end in an error in the sync tx handling. Later we can look if
we might add more error cases into it. It would be nice to see that if
we can simply check in general if there was a success or error, if the
caller wants to be more specific there can be an if/switch-case
statement like the well-known handling with errnos.

Don't tackle it now for userspace, I think it will require a lot of
work... even it depends on which socket family you want to support it.
I think it was just worth mentioning...

- Alex

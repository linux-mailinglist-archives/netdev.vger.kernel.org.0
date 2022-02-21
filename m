Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ED14BEBBF
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiBUUXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:23:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBUUXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:23:18 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB431083;
        Mon, 21 Feb 2022 12:22:53 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id r20so16318442ljj.1;
        Mon, 21 Feb 2022 12:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8lP8zmhBYbpflQ0+nhCO46VybDBNFYhxhaJ1MKZ0Ms=;
        b=KTrBOGImMf1pcF5kfOTnDkoFI7V4ke2kyLCKYcbScvzDS7HxY6gVH7cc4Qo3I/8edi
         GnEPIzJKeOFyjl1h5yIQaUmP67OpR1/rxUR59WZze8/F78d6XkfDd6kyTMN6onVsD4sV
         tPjKDC01sCrxHTBdutAR1RmZkzooxY5pvQaPZzmZFasG7dAL2yaptPjPtZbi/k3uXfiP
         0XNzRbeUuHZPtAb+LxEriikz07SGPalEUUgl8ibX4nv5k4VpLHeJKOhFmvr+BqnwYV5c
         cbPnjpIbgCdVc3mO3dbi99sz9Hh0no+re+yPwAPE5SkevWGxJankbx7Pe6+ZFYF/shtM
         cySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8lP8zmhBYbpflQ0+nhCO46VybDBNFYhxhaJ1MKZ0Ms=;
        b=oIWME0nJbV4P58vECtYg3rUR3wmRf/H2ir4sM1liQCVkJRM5QR0YQ+Bdlc3qmZRDPL
         SfmCef8kH3FvUztekxUBsIicIwJ4TuNCyZKbsx8P84vEXAxjIkzSW1QZ6j05q7WL0JkP
         E4LkdmzAF+fm3fM1UAd9YWZJxQF0LOwdGj7nnlxKLs2hzg8GTA66s9yhFWKwpK+haF/k
         B3h6S6rqPdHH8HqT14fE7UNPgJTTL7xw/lgsH8cdvXsdjuzLOhg6lIKm/CUBbGRnULJt
         eTyXVPL1SI5UT0GUb3BlnI2DjczsrX8IvnZJ4WmKx68SjwcYUlp9TWbAIoNBwHabC4C5
         Er0w==
X-Gm-Message-State: AOAM532g9SGsVvD7g1DZ5D5vkZoBu7PYFMnlgPHSDqJq2FQBrXf82xtD
        +dJmg5qhnh+twP3DD/8Slsm9KDCn6SoKGfmUHQY=
X-Google-Smtp-Source: ABdhPJxJwDnxQRbVyMwmoo2aN0PfU2GO7knhpkuPvoCVLEKjPr4Y0/4vDkttgqbYK3cJX1rLGy0GXEVtmYhbfpdQ31E=
X-Received: by 2002:a2e:91d7:0:b0:245:fce2:4551 with SMTP id
 u23-20020a2e91d7000000b00245fce24551mr9254570ljg.446.1645474971588; Mon, 21
 Feb 2022 12:22:51 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-3-miquel.raynal@bootlin.com> <CAK-6q+iebK43LComxxjvg0pBiD_AK0MMyMucLHmeVG2zbHPErQ@mail.gmail.com>
In-Reply-To: <CAK-6q+iebK43LComxxjvg0pBiD_AK0MMyMucLHmeVG2zbHPErQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 21 Feb 2022 15:22:40 -0500
Message-ID: <CAB_54W6iBmxnRjdjmbWTPzci0za7Lu5UwVFqLJsjQFacxAYQYQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 02/14] net: mac802154: Create a transmit
 error helper
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
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

On Sun, Feb 20, 2022 at 6:31 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Mon, Feb 7, 2022 at 10:09 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > So far there is only a helper for successful transmission, which led
> > device drivers to implement their own handling in case of
> > error. Unfortunately, we really need all the drivers to give the hand
> > back to the core once they are done in order to be able to build a
> > proper synchronous API. So let's create a _xmit_error() helper.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/mac802154.h | 10 ++++++++++
> >  net/mac802154/util.c    | 10 ++++++++++
> >  2 files changed, 20 insertions(+)
> >
> > diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> > index 2c3bbc6645ba..9fe8cfef1ba0 100644
> > --- a/include/net/mac802154.h
> > +++ b/include/net/mac802154.h
> > @@ -498,4 +498,14 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw);
> >  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
> >                               bool ifs_handling);
> >
> > +/**
> > + * ieee802154_xmit_error - frame transmission failed
> > + *
> > + * @hw: pointer as obtained from ieee802154_alloc_hw().
> > + * @skb: buffer for transmission
> > + * @ifs_handling: indicate interframe space handling
> > + */
> > +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
> > +                          bool ifs_handling);
> > +
> >  #endif /* NET_MAC802154_H */
> > diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> > index 6f82418e9dec..9016f634efba 100644
> > --- a/net/mac802154/util.c
> > +++ b/net/mac802154/util.c
> > @@ -102,6 +102,16 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
> >  }
> >  EXPORT_SYMBOL(ieee802154_xmit_complete);
> >
> > +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
> > +                          bool ifs_handling)
> > +{
> > +       unsigned int skb_len = skb->len;
> > +
> > +       dev_kfree_skb_any(skb);
> > +       ieee802154_xmit_end(hw, ifs_handling, skb_len);
> > +}
>
> Remove ieee802154_xmit_end() function and just call to wake up the
> queue here, also drop the "ifs_handling" parameter here.

I am sorry, I think I should deliver an explanation here... I think
the handling of success and error paths are just too different. In
error there will also never ifs handling in the error path. Also
please note there are not just errors as bus/transceiver errors, in
future transceiver should also deliver [0] to the caller, in sync
transmit it should return those errors to the caller... in async mode
there exists different ways to deliver errors like (no ack) to user
space by using socket error queue, here again is worth to look into
wireless subsystem which have a similar feature.

The errors in [0] are currently ignored but I think should be switched
some time soon or with an additional patch by you to calling
xmit_error with an int for $REASON. Those errors are happening on the
transceiver because some functionality is offloaded. btw: so far I
know some MLME-ops need to know if an ack is received or not.

You can split the functionality somehow it makes sense, but with the
above change I only see the wake up queue is the only thing that both
(success/error) should have in common.

- Alex

[0] https://elixir.bootlin.com/linux/v5.16-rc7/source/drivers/net/ieee802154/at86rf230.c#L670

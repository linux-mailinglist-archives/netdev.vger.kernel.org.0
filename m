Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAEC4F541E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbiDFE0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360326AbiDFD3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 23:29:25 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F792B188;
        Tue,  5 Apr 2022 17:05:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m3so1198683lfj.11;
        Tue, 05 Apr 2022 17:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xs2rAw9nqngC2ye/WczsIFQv9q34pbZ+WzI2jT0sLxk=;
        b=iyR0yMVeoOnVjHnl/Sh/CipykXq7Lx47VftTP2f0ZQtX/w6nmpcZZ0b0o665ydhtBk
         xs6W5GYdZFDskL3cDbPyI9v/5Dz6S3lq5yS1b9pn/sz6DbwazU5vFAGMyimmgywq8Qts
         NzC9W+lcEMI+SZ21W5pwOppE6jMKjHrqyz8YFytNctmV06//XUjKLbSvR+w0LO5Sb78A
         oO5069HMZfWjgtlCJiaJQNKTVWnwueeFhsR5t3MVWI/kUNtCEwMr+lo03x/OMTQkNN6u
         wp0CDW/kGlgyuYWugQHoSicU7kNE3HsP7MOuIinWHYAxTudikTe/EK6naFus8y94UR9N
         O8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xs2rAw9nqngC2ye/WczsIFQv9q34pbZ+WzI2jT0sLxk=;
        b=YLF2Tkrmn8jxtI72bh+k0Jw5iINIPiFuY6af39eoVax0gv6q8Her3iXEgD5gAGgs+h
         vYMcM/FXHL4+eFRr4f3DeTEuNVqWT8eSREZCTM7NOGhDHJDBFBPV8n5fwMyQiXamQsvf
         nWvNNWW57V4wFKCd8VIr/mZTrvat+vSFfP7qV6B+JbqXg9UJfdVrezQ41nIqJdtPEwv9
         JXhWfPxQFGnZVE3JnbRSbS80PbZNvZwCB5gTGXo23VHTklt5Edu/8x+qwO1lSgfyYKzV
         PoOF9FzOKebjVwvoqqIid7QgoWkCR1+b39GF+HRTJgiI89rSNc9FC5TeWllexszcNTbM
         hWaw==
X-Gm-Message-State: AOAM531EVUSD3hk2Kx8ewh0+NHNt5HXzoOclLJqcEj1D55Uzqjcrp3Bg
        Fy4XCXGM+dKrrGtc1O3vr73snxkDTkfIbNVzZIU=
X-Google-Smtp-Source: ABdhPJxMRzMMO4z3JqgxJvfV4asrVk6MTpFZcJHgEO/W84Em3E9sDNjjsw08x76UKVh5LXAr4T0ppgkBjhhv91XQCfk=
X-Received: by 2002:ac2:4207:0:b0:442:bf8b:eee with SMTP id
 y7-20020ac24207000000b00442bf8b0eeemr4284573lfh.536.1649203535058; Tue, 05
 Apr 2022 17:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
 <20220318185644.517164-8-miquel.raynal@bootlin.com> <CAB_54W5A1xmHO-YrWS3+RD0N_66mzkDpPYjosHU3vHgn1zmONg@mail.gmail.com>
 <20220329183506.513b93cb@xps13> <20220404144038.050ffc2b@xps13>
In-Reply-To: <20220404144038.050ffc2b@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 5 Apr 2022 20:05:23 -0400
Message-ID: <CAB_54W5zMGVKZ2RJ68i66RcDxUoFB8pWWL+nnQ-4zD-AfucmiA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v4 07/11] net: ieee802154: at86rf230: Provide
 meaningful error codes when possible
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
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

On Mon, Apr 4, 2022 at 8:40 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> miquel.raynal@bootlin.com wrote on Tue, 29 Mar 2022 18:35:06 +0200:
>
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Sun, 27 Mar 2022 11:46:12 -0400:
> >
> > > Hi,
> > >
> > > On Fri, Mar 18, 2022 at 2:56 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Either the spi operation failed, or the offloaded transmit operation
> > > > failed and returned a TRAC value. Use this value when available or use
> > > > the default "SYSTEM_ERROR" otherwise, in order to propagate one step
> > > > above the error.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ieee802154/at86rf230.c | 25 +++++++++++++++++++++++--
> > > >  1 file changed, 23 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > > > index d3cf6d23b57e..34d199f597c9 100644
> > > > --- a/drivers/net/ieee802154/at86rf230.c
> > > > +++ b/drivers/net/ieee802154/at86rf230.c
> > > > @@ -358,7 +358,23 @@ static inline void
> > > >  at86rf230_async_error(struct at86rf230_local *lp,
> > > >                       struct at86rf230_state_change *ctx, int rc)
> > > >  {
> > > > -       dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > > > +       int reason;
> > > > +
> > > > +       switch (rc) {
> > >
> > > I think there was a miscommunication last time, this rc variable is
> > > not a trac register value, it is a linux errno. Also the error here
> > > has nothing to do with a trac error. A trac error is the result of the
> > > offloaded transmit functionality on the transceiver, here we dealing
> > > about bus communication errors produced by the spi subsystem. What we
> > > need is to report it to the softmac layer as "IEEE802154_SYSTEM_ERROR"
> > > (as we decided that this is a user specific error and can be returned
> > > by the transceiver for non 802.15.4 "error" return code.
> >
> > I think we definitely need to handle both, see below.
> >
> > >
> > > > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > > > +               reason = IEEE802154_CHANNEL_ACCESS_FAILURE;
> > > > +               break;
> > > > +       case TRAC_NO_ACK:
> > > > +               reason = IEEE802154_NO_ACK;
> > > > +               break;
> > > > +       default:
> > > > +               reason = IEEE802154_SYSTEM_ERROR;
> > > > +       }
> > > > +
> > > > +       if (rc < 0)
> > > > +               dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
> > > > +       else
> > > > +               dev_err(&lp->spi->dev, "xceiver error %d\n", reason);
> > > >
> > > >         at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
> > > >                                      at86rf230_async_error_recover);
> > > > @@ -666,10 +682,15 @@ at86rf230_tx_trac_check(void *context)
> > > >         case TRAC_SUCCESS:
> > > >         case TRAC_SUCCESS_DATA_PENDING:
> > > >                 at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86rf230_tx_on);
> > > > +               return;
> > > > +       case TRAC_CHANNEL_ACCESS_FAILURE:
> > > > +       case TRAC_NO_ACK:
> > > >                 break;
> > > >         default:
> > > > -               at86rf230_async_error(lp, ctx, -EIO);
> > > > +               trac = TRAC_INVALID;
> > > >         }
> > > > +
> > > > +       at86rf230_async_error(lp, ctx, trac);
> > >
> > > That makes no sense, at86rf230_async_error() is not a trac error
> > > handling, it is a bus error handling.
> >
> > Both will have to be handled asynchronously, which means we have to
> > tell the soft mac layer that something bad happened in each case.
> >
> > > As noted above. With this change
> > > you mix bus errors and trac errors (which are not bus errors).
> >
> > In the case of a SPI error, it will happen asynchronously, which means
> > the tx call is over and something bad happened. We are aware that
> > something bad happened and there was a bus error. We need to:
> > - Free the skb
> > - Restart the internal machinery
> > - Somehow tell the soft mac layer something bad happened and the packet
> >   will not be transmitted as expected (IOW, balance the "end" calls
> >   with the "start" calls, just because we did not return immediately
> >   when we got the transmit request).
> >
> > In the case of a transmission error, this is a trac condition that is
> > reported to us by an IRQ. We know it is a trac error, we can look at a
> > buffer to find which trac error exactly happened. In this case we need
> > to go through exactly the same steps as above.
> >
> > But you are right that a spi_async() error is not a trac error, hence
> > my choice in the switch statement to default to the
> > IEEE80154_SYSTEM_ERROR flag in this case.
> >
> > Should I ignore spi bus errors? I don't think I can, so I don't really
> > see how to handle it differently.
>
> Sorry to bother you again, but in the end, do you agree on returning
> IEEE802154_SYSTEM_ERROR upon asynchronous bus errors?
>

yes, I said nothing different here. What I said is that bus errors and
trac status get mixed here and this patch breaks things.

Really this is just changing either call xmit_complete() when trac was
one of the successful codes or xmit_error($REASON) when trac was one
which failed. In case of bus error and it was "tx" then call
xmit_error(SYSTEM_ERROR) in at86rf230_async_error_recover_complete().
You might need to store the last trac register to decide what to call
at the current places of "xmit_complete()".

I also would like to see a helper here which statically sends
SYSTEM_ERROR in case of bus error because I am worried that somebody
is choosing any other 802.15.4 error to return which might be
interpreted differently by SoftMAC.

> Any other modification of the driver in favor of having two distinct
> paths would be really costly in term of time spent and probability of
> breaking something, so I would rather avoid it, unless I am missing
> something simpler?

If it's too much time, then just update the driver like any others and
don't use the new feature, somebody else will send patches for it to
update the driver then.

- Alex

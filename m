Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D85E50E075
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 14:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiDYMjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 08:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241195AbiDYMjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 08:39:14 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E7E78922;
        Mon, 25 Apr 2022 05:36:08 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id w1so25896299lfa.4;
        Mon, 25 Apr 2022 05:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sw2r07tUzNeTjJz+RXy2LYwDHQp+ixSu7Pi6iHkG9jo=;
        b=UOPv8yd4pd9blsfxCve7mkXRTIBwk901U8Z9vMT/nDNlytqwVAZm84fWln35pioioC
         xqRFtQOcJtkVzLjqqJwf89tEKbAQF2ZOfDa/V7vUeLtXZ1Sh3b4R2rRGggB5NA1EsP3F
         Q2NxIow6Z6GHZcBT8N7GY8ZKzlg1nK5uE5iUUKjLy2hlbLC8rn9NW1E2C04o+jzcyhmy
         HrFcCppuj023GByYRMBW8GyVF1ZdlMKQXLAwZqCRyeS/uXNE5fUoxVbERtHPS/iYkR5a
         5ZL2So/UIXv27V0H0G0e1xmVrb7bY02KNWeD69mosjIzV2krzSa5hJVZ4ve6cKju31WK
         9LfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sw2r07tUzNeTjJz+RXy2LYwDHQp+ixSu7Pi6iHkG9jo=;
        b=pK+jwRncJ1lXY872PFoLoakVlmkwC4RCEuHbxxMRG3Ll/NHcOB2FAB2Sq1fRjNwg4k
         Vr4dJNzjpk49gHOOW9UmnwOTQ5y3/oSLAOzdrX6fjce2tysdSVNtSsqgPbXRfz60q6rD
         FofMbRgWbsEbaJCvSnj3pUN6uIxB8Ra2faFJUzzArcos7UpJ7Nuekj9hoKwufmQTW0Ce
         asuUfwr0XYW717vel6bpaNhbzINrSbYpzOn4wseYdNInnwPon3ykNBmUQrUVaERxQEwP
         To8SUrEJhgyqsihXvEcmiGPh2HDfgBNGVU2qqiX1l+luIi5TFikWsUpFGtADzryDmopq
         5ESg==
X-Gm-Message-State: AOAM530tYz3dd/JOaUlC5aJgJqyR2tM44IbKmn0Ra0oCA2M+q4aNv8Ri
        sGx5NIm1a6T/KqMf32jz9wWReH2t9pVm+hG3dw4=
X-Google-Smtp-Source: ABdhPJzavfbozblPzbAHoFS/GQBKeD4qlBoRzDs0KPF6gvI0LpJ/TMjdrY7LWmXv917Olwy8foN/5LwO1sLm9nvfSUQ=
X-Received: by 2002:a05:6512:15a0:b0:472:d09:a6b4 with SMTP id
 bp32-20020a05651215a000b004720d09a6b4mr1824931lfb.656.1650890166402; Mon, 25
 Apr 2022 05:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
 <20220406153441.1667375-10-miquel.raynal@bootlin.com> <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
 <20220407100646.049467af@xps13>
In-Reply-To: <20220407100646.049467af@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 25 Apr 2022 08:35:55 -0400
Message-ID: <CAB_54W5ovb9=rWB-H9oZygWuQpLSG58XFtgniNn9eDh51BBQNw@mail.gmail.com>
Subject: Re: [PATCH v5 09/11] net: ieee802154: atusb: Call _xmit_error() when
 a transmission fails
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Apr 7, 2022 at 4:06 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:58:59 -0400:
>
> > Hi,
> >
> > On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > ieee802154_xmit_error() is the right helper to call when a transmission
> > > has failed. Let's use it instead of open-coding it.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  drivers/net/ieee802154/atusb.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> > > index f27a5f535808..d04db4d07a64 100644
> > > --- a/drivers/net/ieee802154/atusb.c
> > > +++ b/drivers/net/ieee802154/atusb.c
> > > @@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
> > >                  * unlikely case now that seq == expect is then true, but can
> > >                  * happen and fail with a tx_skb = NULL;
> > >                  */
> > > -               ieee802154_wake_queue(atusb->hw);
> > > -               if (atusb->tx_skb)
> > > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
> > > +                                     IEEE802154_SYSTEM_ERROR);
> >
> > That should then call the xmit_error for ANY other reason which is not
> > 802.15.4 specific which is the bus_error() function?
>
> I'll drop the bus error function so we can stick to a regular
> _xmit_error() call.
>

Okay, this error is only hardware related.

> Besides, we do not have any trac information nor any easy access to
> what failed exactly, so it's probably best anyway.

This is correct, Somebody needs to write support for it for atusb firmware. [0]
However some transceivers can't yet or will never (because lack of
functionality?) report such errors back... they will act a little bit
weird.

However, this return value is a BIG step moving into the right
direction that other drivers can follow.

I think for MLME ops we can definitely handle some transmit errors now
and retry so that we don't wait for anything when we know the
transceiver was never submitting.

- Alex

[0] http://projects.qi-hardware.com/index.php/p/ben-wpan/source/tree/master/atusb/fw

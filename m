Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2891D6E3D
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgERAXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 20:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgERAX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 20:23:29 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D61CC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 17:23:29 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b71so8175261ilg.8
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 17:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0hp2Uj3fhUUKPHsc+7DR/UWLb8ELPoP40FkFG9hvcs=;
        b=tqz7XTKNUGAokZx+xCQ+E19cn4Wz1W16lqsj0CK3KhSUJp7aBXDAFyjQsDi8xUM687
         vlrNQId+U7UrFuA4vGlbc6znot4og8OQh34+gcQlPciLxkpCfzEGvnEwoV9LOpHtygvy
         NGYGwH9v/gG/BZ4zDD7RM8iTWu0hj24TOUf662VmjQfaCwq/RDKpD1ct2CfMi5XrH2D7
         Qw8+E2DONrViKsi4qW91Y4/RprfQHYse5rNH6QVv7U6Dak09tfGOYC9QXljeZ9m5KTQD
         80ZI2X9e/PZRr4oRdeVLw489MTBvNzj7DoXqqAEAvG6wDAg/khSzEdLWlH/wKX7X7JCE
         DMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0hp2Uj3fhUUKPHsc+7DR/UWLb8ELPoP40FkFG9hvcs=;
        b=bus4iP701gkm3108etmRcLSbG5atlm5DN/aliNertyQkCGTj7qT78htV7l8bx7mTQe
         PB1T98nsQPWjQV3rnVVDt58RMn/nJec4ZaRCTLHnLQkYhYM4V7T3r3YsWai9erYib/iV
         /jUNf/Ot5eCLBOHs+eLmQKehn3r1M0Q1mYN+SWU8dMe5QmEP3xH+XYhYiJkQsvzgRJ8u
         M2WKn+UJraZ/lKB6oXDEC61qpDCgBLddDUrft9Nxu4lz5te48PDCf3HCWFUFcb2bVnkh
         h13gjQM61WrOc2U/7fjDLQbFL2f27AoPgmmO4IqIscAv3LWZECx63IpBAPFEcnkM1vfA
         QA6Q==
X-Gm-Message-State: AOAM532+/B8qN5D843ouoJAo6MKRcFV4O93lPbK/V908IAdA2nP7QWlC
        sV0ffycQHqji3+2fjHamOvIM92+TRfYrTKV6pT0=
X-Google-Smtp-Source: ABdhPJwdNJ8RwDdeDJuWPX206HyxzKo2/J1esdqkKmitoMaXdeOZ4+KzmzndN/dUdErKdkwYJhEl79GT+y0JnFhGBVI=
X-Received: by 2002:a92:1b17:: with SMTP id b23mr13985825ilb.199.1589761408668;
 Sun, 17 May 2020 17:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195851.610435-1-andrew@lunn.ch> <20200517195851.610435-5-andrew@lunn.ch>
 <CAFXsbZohCG5OScjAszD5vpMacfUEUYK_74FU1tjz4Sm8nbegsg@mail.gmail.com> <20200517205150.GB610998@lunn.ch>
In-Reply-To: <20200517205150.GB610998@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 17 May 2020 17:23:14 -0700
Message-ID: <CAFXsbZqQAd0eG1tTqC-tiYRe_GT8jGuB5dzmxuJeRjG-O9-UNg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: phy: marvell: Add support for amplitude graph
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 1:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > +static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
> > > +                                          int meters)
> > > +{
> > > +       int mV_pair0, mV_pair1, mV_pair2, mV_pair3;
> > > +       int distance;
> > > +       u16 reg;
> > > +       int err;
> > > +
> > > +       distance = meters * 1000 / 805;
> >
> > With this integer based meters representation, it seems to me that we
> > are artificially reducing the resolution of the distance sampling.
> > For a 100 meter cable, the Marvell implementation looks to support 124
> > sample points.  This could result in incorrect data reporting as two
> > adjacent meter numbers would resolve to the same disatance value
> > entered into the register.  (eg - 2 meters = 2 distance  3 meters = 2
> > distance)
> >
> > Is there a better way of doing this which would allow for userspace to
> > use the full resolution of the hardware?
>
> Hi Chris
>
> I don't see a simple solution to this.
>
> PHYs/vendors seem to disagree about the ratio. Atheros use
> 824. Marvell use 805. I've no idea what Broadcom, aQuantia uses. We
> would need to limit the choice of step to multiples of whatever the
> vendor picks as its ratio. If the user picks a step of 2m, the driver
> needs to return an error and say sorry, please try 2.488 meter steps
> for Marvell, 2.427 meter steps on Atheros, and who knows what for
> Broadcom. And when the user requests data just for 1-25 meters, the
> driver needs to say sorry, try again with 0.824-24.62, or maybe
> 0.805-24.955. That is not a nice user experience.
>
> It is easy for you to disable this conversion. Do you see a noticeable
> difference in the quality of the results?
>
Could this be resolved by changing the interface slightly such that
the user specifies the range only (in meters or maybe centimetres) and
the driver figures out what to do with it and returns all the data
within that range in a centimetre format?

For example, if we were to provide a range of 10 to 20 meters with the
Marvell PHY, the driver would set the first offset to a register value
of 10/0.805 rounded down to the next lower integer value then
increment through the register values one by one until hitting
20/0.805 rounded up to the next integer value and return the results
for each of these 26 sets of values.  With each of these 26 sets of
values, the distance could be returned in a centimetre format thus
providing the data requested in the resolution of the PHY.

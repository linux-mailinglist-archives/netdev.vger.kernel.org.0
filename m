Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F032B12ABB8
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 11:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLZKu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 05:50:29 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46235 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLZKu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 05:50:29 -0500
Received: by mail-ed1-f65.google.com with SMTP id m8so22281480edi.13
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 02:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ccQ2qTZWdKadFNGf14fsJTEQuIgJ0rJImexUVH5TorU=;
        b=MO407RPAM7v1C8bT4ElsnojpFIqDwaDY27HQCupSQQqt5MiRW/nOJWRB2euC1/tB+R
         fKld5iJ2F/iUSIsBXpfmz0t4YNiqvs4g1obC04AFNXDfden+D7tzufKEmi/E/JsBx+5N
         pqCWKI4LRflT/wDzWfhWmCHTiXNUFn11X7lOXSB8o6IaNFE47qLfQtK6kTdmYFF3AdSZ
         osfm16061B9531NfYq84RmBowwOvLuuZ9U4qeN9fbpttu/JX5swCMmZSyAfTXVUHQ0JQ
         M+KFM7S/VU2+dl+m/Aft8yNyszqkGUqByW7UIncl9fmh5ztgS+WKTTTMtehj5ApW/nO8
         MC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ccQ2qTZWdKadFNGf14fsJTEQuIgJ0rJImexUVH5TorU=;
        b=YmSZYdWE19g4NQnFYX3FUhxgDIjhlQJWyIEoF1krnKCvzZBhTStNXZFdQy7P+O32DS
         gw1j/432nB9NlH0iEAONZnAGyjDheQmdBeOr6cHdxVQqZKhU7Db36YaQ1CemH7zta36U
         zYqqy84/0y8uOCqCwd+esZWr4DKX0NZUKqJ0o0biai6MOUsh7HYGZqrxDF65sEmcG8Cw
         THgVc2KyMid+HWQGa3ZAd0ocQJ0yDGhfuENvBRsho0DD8MHwq2JDVFcB87pU1eNY9Bl6
         MgHKJac5ov7JjLULsIBYC3Rsp1otVjcslEuN5FH+MFKFeEWHGd31kagimMnlwW++cVq7
         9miA==
X-Gm-Message-State: APjAAAU/A3udKB5Hka+jTKFv1XZ5fyI060pi8dGTBr7OiJXR0goGi89/
        uXavYnd9/I0/+ly4ftaD4Ra5D9XxvQR2MySN3UA=
X-Google-Smtp-Source: APXvYqxAuOnOOVgeCYPaxkfk+8Mr0v3vPSkebu3B1HFCa3FDOwOZ/1MVZWJ98hSgDkb6fji+y8DY+EAZsFnVIa19oqo=
X-Received: by 2002:a05:6402:21e3:: with SMTP id ce3mr49072328edb.165.1577357427316;
 Thu, 26 Dec 2019 02:50:27 -0800 (PST)
MIME-Version: 1.0
References: <20191226095851.24325-1-yangbo.lu@nxp.com> <CA+h21hojJ=UU2i1kucYoD4G9VQgpz1XytSOp_MT9pjRYFnkc4A@mail.gmail.com>
In-Reply-To: <CA+h21hojJ=UU2i1kucYoD4G9VQgpz1XytSOp_MT9pjRYFnkc4A@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Dec 2019 12:50:16 +0200
Message-ID: <CA+h21hqCp-a_ZE6qQL3CXEqwfrCBhdo1nYfK_ucJM0d7HFdYAQ@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 at 12:49, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Yangbo,
>
> On Thu, 26 Dec 2019 at 12:00, Yangbo Lu <yangbo.lu@nxp.com> wrote:
> >
> > This patch is to support PPS signal generation for Ocelot family
> > switches, including VSC9959 switch.
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
>
> Shouldn't this be integrated with the .enable callback of the PTP core?
>
> >  drivers/net/dsa/ocelot/felix_vsc9959.c  |  2 ++
> >  drivers/net/ethernet/mscc/ocelot.c      | 25 +++++++++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_ptp.h  |  2 ++
> >  drivers/net/ethernet/mscc/ocelot_regs.c |  2 ++
> >  include/soc/mscc/ocelot.h               |  2 ++
> >  5 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > index b9758b0..ee0ce7c 100644
> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > @@ -287,6 +287,8 @@ static const u32 vsc9959_ptp_regmap[] = {
> >         REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
> >         REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
> >         REG(PTP_PIN_TOD_NSEC,              0x00000c),
> > +       REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
> > +       REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
> >         REG(PTP_CFG_MISC,                  0x0000a0),
> >         REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
> >         REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 985b46d..c0f8a9e 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -2147,6 +2147,29 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
> >         .adjfine        = ocelot_ptp_adjfine,
> >  };
> >
> > +static void ocelot_ptp_init_pps(struct ocelot *ocelot)
> > +{
> > +       u32 val;
> > +
> > +       /* PPS signal generation uses CLOCK action. Together with SYNC option,
> > +        * a single pulse will be generated after <WAFEFORM_LOW> nanoseconds
> > +        * after the time of day has increased the seconds. The pulse will
> > +        * get a width of <WAFEFORM_HIGH> nanoseconds.
>
> Also, I think what you have implemented here is periodic output
> (PTP_CLK_REQ_PEROUT) not PPS [input] (PTP_CLK_REQ_PPS). I have found
> the PTP documentation to be rather confusing on what PTP_CLK_REQ_PPS
> means, so I'm adding Richard in the hope that he may clarify (also
> what's different between PTP_CLK_REQ_PPS and PTP_CLK_REQ_PPS).

EXTTS, sorry, obviously nothing is different between X and itself.

>
> > +        *
> > +        * In default,
> > +        * WAFEFORM_LOW = 0
> > +        * WAFEFORM_HIGH = 1us
> > +        */
> > +       ocelot_write_rix(ocelot, 0, PTP_PIN_WF_LOW_PERIOD, ALT_PPS_PIN);
> > +       ocelot_write_rix(ocelot, 1000, PTP_PIN_WF_HIGH_PERIOD, ALT_PPS_PIN);
> > +
> > +       val = ocelot_read_rix(ocelot, PTP_PIN_CFG, ALT_PPS_PIN);
> > +       val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
> > +       val |= (PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK));
> > +
>
> I suppose the reason why you didn't use ocelot_rmw_rix here is that it
> doesn't fit in 80 characters?
> Do you even need to read-modify-write? The only other field is the
> polarity bit which is by default 0 (active high) and non-configurable
> via the current API (struct ptp_pin_desc) as far as I can see.
>
> > +       ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ALT_PPS_PIN);
> > +}
> > +
> >  static int ocelot_init_timestamp(struct ocelot *ocelot)
> >  {
> >         struct ptp_clock *ptp_clock;
> > @@ -2478,6 +2501,8 @@ int ocelot_init(struct ocelot *ocelot)
> >                                 "Timestamp initialization failed\n");
> >                         return ret;
> >                 }
> > +
> > +               ocelot_ptp_init_pps(ocelot);
> >         }
> >
> >         return 0;
> > diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h b/drivers/net/ethernet/mscc/ocelot_ptp.h
> > index 9ede14a..21bc744 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_ptp.h
> > +++ b/drivers/net/ethernet/mscc/ocelot_ptp.h
> > @@ -13,6 +13,8 @@
> >  #define PTP_PIN_TOD_SEC_MSB_RSZ                PTP_PIN_CFG_RSZ
> >  #define PTP_PIN_TOD_SEC_LSB_RSZ                PTP_PIN_CFG_RSZ
> >  #define PTP_PIN_TOD_NSEC_RSZ           PTP_PIN_CFG_RSZ
> > +#define PTP_PIN_WF_HIGH_PERIOD_RSZ     PTP_PIN_CFG_RSZ
> > +#define PTP_PIN_WF_LOW_PERIOD_RSZ      PTP_PIN_CFG_RSZ
> >
> >  #define PTP_PIN_CFG_DOM                        BIT(0)
> >  #define PTP_PIN_CFG_SYNC               BIT(2)
> > diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
> > index b88b589..ed4dd01 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_regs.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_regs.c
> > @@ -239,6 +239,8 @@ static const u32 ocelot_ptp_regmap[] = {
> >         REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
> >         REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
> >         REG(PTP_PIN_TOD_NSEC,              0x00000c),
> > +       REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
> > +       REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
> >         REG(PTP_CFG_MISC,                  0x0000a0),
> >         REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
> >         REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 64cbbbe..c2ab20d 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -325,6 +325,8 @@ enum ocelot_reg {
> >         PTP_PIN_TOD_SEC_MSB,
> >         PTP_PIN_TOD_SEC_LSB,
> >         PTP_PIN_TOD_NSEC,
> > +       PTP_PIN_WF_HIGH_PERIOD,
> > +       PTP_PIN_WF_LOW_PERIOD,
> >         PTP_CFG_MISC,
> >         PTP_CLK_CFG_ADJ_CFG,
> >         PTP_CLK_CFG_ADJ_FREQ,
> > --
> > 2.7.4
> >
>
> Thanks,
> -Vladimir

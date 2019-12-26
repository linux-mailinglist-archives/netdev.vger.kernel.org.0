Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66C912ADEA
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 19:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfLZSYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 13:24:32 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35177 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfLZSYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 13:24:32 -0500
Received: by mail-ed1-f66.google.com with SMTP id f8so23390535edv.2
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 10:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GTzCUOyMXju09A0r3OFWJbfA6bnWFB/+Ryp/x6btYo8=;
        b=eMsJsJRf9AhfJ9fsEzblu799622AU1dEDK8z5JOiesSxNYWPfHtXkj+ALERGzgE3Zr
         XuJPE9YB9G0u8kSvKSQ9LhuoB4gsAuucdl8DjEAb5OE21yFDOQRIrkDQV/tFtfqUvs+J
         54imj57uw2bXMOhgbz13D86NDV/IoOK2Kj8gMqtGOWwrsVZnWd0N7tsCYV8ghYC+392L
         Llt4/it2QVsSMvyNgMqB9gJRQUOFqPkdFW23zQlIu5V9lkw9FpnuSUO5t1sXjwBkwck5
         XcWYW8kleJjCkdXb6pr5Rf5m3lnMQKYNWt7gzyYy6WYsg+k7/SjNG+ifZ3cqnh8THXWK
         cTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GTzCUOyMXju09A0r3OFWJbfA6bnWFB/+Ryp/x6btYo8=;
        b=tIf6Xyrb7yxOlunvEsAyocXi8INnM3u3prdmTvi94+5k2SNnjG5rBW8m2vG/tRd8ma
         spg4BGWV2ItiveFI4tydIlDKWxtq11kZ4Fvkn7+ra3h25WgsX5X2TyhfXQd6NGv3f0Wm
         rkuGBNVF2CzaDbeppVqagYiAI5uARDArEWtU8ad7CAs7p3++OvxM91SlKrPhF/dpeOrn
         cRwRvwogsLtPJ+t2By+Gdlkd7Qo69vcCqaLGqfHLRPNREOQVF4yKtCsbK+oPzfgpD7Fu
         TRaEmTVZAh2qb0WFFj3uqmOsEn4eU0kMBi9y7u+YEqD5d+rEOQiqSQEInpZKFn+hnpxH
         nlOQ==
X-Gm-Message-State: APjAAAXz3DTwaO3eAOpXi99Y6TBJuYlX3vcfl0XjeM/Kc/Zabi4M6Rr+
        Db936TsenPwNwOUhS2epdfP9hEnt2czBkQX1O9Y=
X-Google-Smtp-Source: APXvYqyjmlkW6RRPqeUhDqTW41DSLQK/GJjsA81W85Ua8j4UwmHz0eImM+4wvvYz3iZfWsDtXy3ZAplb8trTxhGM0CI=
X-Received: by 2002:a05:6402:21e3:: with SMTP id ce3mr51397124edb.165.1577384670185;
 Thu, 26 Dec 2019 10:24:30 -0800 (PST)
MIME-Version: 1.0
References: <20191216223344.2261-1-olteanv@gmail.com> <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com> <20191224190531.GA426@localhost>
In-Reply-To: <20191224190531.GA426@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Dec 2019 20:24:19 +0200
Message-ID: <CA+h21hrBLedLHCfP3oY2U96BJXqMQO=Uof3tsjji_Fp-b0smHQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Tue, 24 Dec 2019 at 21:05, Richard Cochran <richardcochran@gmail.com> wr=
ote:
>
> On Tue, Dec 17, 2019 at 10:21:29PM +0000, Keller, Jacob E wrote:
> > > -----Original Message-----
> > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > > Behalf Of Vladimir Oltean
>
> > > There are many more drivers that are in principle broken with DSA PTP=
,
> > > since they don't even have the equivalent check for priv->hwts_tx_en.
>
> Please stop saying that.  It is not true.
>

Why isn't it true?
You mean to say that this code in cavium/liquidio/lio_main.c will ever
work with a PTP-cable DSA switch or PHY?

static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *ne=
tdev)
{
(...)
    if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
        skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
        cmdsetup.s.timestamp =3D 1;
    }

Or this one in cavium/octeon/octeon_mgmt.c?

    re.s.tstamp =3D ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) !=3D 0);

Or this one in mscc/ocelot.c:

    /* Check if timestamping is needed */
    if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
        info.rew_op =3D ocelot_port->ptp_cmd;
        if (ocelot_port->ptp_cmd =3D=3D IFH_REW_OP_TWO_STEP_PTP)
            info.rew_op |=3D (ocelot_port->ts_id  % 4) << 3;
    }

Or this one in mellanox/mlx5/core/en_tx.c:

            if (unlikely(skb_shinfo(skb)->tx_flags &
                     SKBTX_HW_TSTAMP)) {
                struct skb_shared_hwtstamps hwts =3D {};

                hwts.hwtstamp =3D
                    mlx5_timecounter_cyc2time(sq->clock,
                                  get_cqe_ts(cqe));
                skb_tstamp_tx(skb, &hwts);
            }

etc etc.

How will these drivers not transmit a second hw TX timestamp to the
stack, if they don't check whether TX timestamping is enabled for
their netdev?

Of course, at least that breakage is going to be much more binary and
obvious: PTP simply won't work at all for drivers stacked on top of
them until they are fixed.

> No fix is needed.  MAC drivers must set SKBTX_IN_PROGRESS and call
> skb_tstamp_tx() to deliver the transmit time stamp.  DSA drivers
> should call skb_complete_tx_timestamp() to deliver the transmit time
> stamp, and they should *not* set SKBTX_IN_PROGRESS.
>

Who says so, and why? How would it be better than fixing gianfar in
this case? How would it be better in avoiding compatibility with the
drivers mentioned above?

Does the TI PHYTER driver count?

commit e2e2f51dd0254fa0002bcd1c5fda180348163f09
Author: Stefan S=C3=B8rensen <stefan.sorensen@spectralink.com>
Date:   Mon Feb 3 15:36:35 2014 +0100

    net:phy:dp83640: Declare that TX timestamping possible

    Set the SKBTX_IN_PROGRESS bit in tx_flags dp83640_txtstamp when doing
    tx timestamps as per Documentation/networking/timestamping.txt.

    Signed-off-by: Stefan S=C3=B8rensen <stefan.sorensen@spectralink.com>
    Acked-by: Richard Cochran <richardcochran@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 547725fa8671..3f882eea6e1d 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1281,6 +1281,7 @@ static void dp83640_txtstamp(struct phy_device *phyde=
v,
                }
                /* fall through */
        case HWTSTAMP_TX_ON:
+               skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
                skb_queue_tail(&dp83640->tx_queue, skb);
                schedule_work(&dp83640->ts_work);
                break;

I think this rule is somewhat made-up and arbitrary.

> Thanks,
> Richard

Thanks,
-Vladimir

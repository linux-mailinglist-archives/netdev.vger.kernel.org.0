Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF22489E35
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiAJRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbiAJRRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 12:17:13 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E0CC06173F;
        Mon, 10 Jan 2022 09:17:13 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r9so26329251wrg.0;
        Mon, 10 Jan 2022 09:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OspTksM1ZJ6oD0IVbU2kN9rq1ubtzw2y6Qqnpo9cR4E=;
        b=QZXR1ossMQjLElP15+K7a4teC+yrrvepXZkQBQ9gag1wUy4dFQ6k5XdFKGfInRY6f+
         tqasU+iagTMYWITaoIGzbhoRtwfT58Qem61YnuK5EhfvwIkru7vOL1T07bRM064lR1LN
         xU/x9WyuWT4zgIQLJxPEZhmRkFrGHNLfnRRrUUz55rZP5WKSP8zA1TbrqrVX/XjGT36h
         ZlRQlWw/PIZgn3TvPN3X8vh5qx/uIE6/g/Nn0Z3O1+8MedRzQtUCXVOhd9bxEZsOfMNt
         ZqEVwrQgGbj6huWQe9FR0sgM9i9i8fgmsgLuSU+XbcncW/ivKE1TZ3v7t7l8KczJMYDb
         CATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OspTksM1ZJ6oD0IVbU2kN9rq1ubtzw2y6Qqnpo9cR4E=;
        b=DH/rHZoDUQXrxXCbCNtZiVIfTVuumqOnnyx4Z6OreBCdx7ezqWl3TEbWetXqAvgHrW
         aJEYxvoZzplX/57ac4+45LhjFTd0CxDRykTQeUEMrTrN8k0UALQRGsz/jAiziDYjFhcT
         Z1C30RFtaIQpRUoYhyLejdoVI47fnZ8o/r5BdJTrFMm8DwEgy3El1N66RSaad+AKP6v+
         /UEslsNvxPpmebdz795dmHB7ecykGh0LMHRgmW7Vnt+/S25o0do+3QDbcXvgkOMok9Ad
         5eSEbceGKcRrb1mEYNOHVQievmv89Jsc1RU6SL59C0jCu8/fNs6nY3stJhyIlKt1UwYm
         7zmQ==
X-Gm-Message-State: AOAM533UvGZq3/Rl7rfFDMEGqHrvOPYZbrAgfZix29UH6xvFMk1NjHlc
        BkKxsr/nPJ5spt/R3SmKhPCFxnBpISxDT5qKFZ0=
X-Google-Smtp-Source: ABdhPJwwZuCfD7/bgyq5dInEMZrxdgueCg9GWP0XlvY7InW9pPIiLNDFg/wNYW+O3W1HvCvUtobN+HbxtVKTQBPSoWM=
X-Received: by 2002:a5d:588c:: with SMTP id n12mr530022wrf.56.1641835031879;
 Mon, 10 Jan 2022 09:17:11 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org> <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
 <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
 <20220104191802.2323e44a@xps13> <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
 <20220105215551.1693eba4@xps13> <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
 <20220106201516.6a48154a@xps13> <CAB_54W5=6Zo7CzwfZw-OfRx6i4__pRt=QdmNbWdm6EQS5tvE7w@mail.gmail.com>
 <20220107120226.513554db@xps13>
In-Reply-To: <20220107120226.513554db@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 10 Jan 2022 12:17:00 -0500
Message-ID: <CAB_54W5fqG-E4kdBN4GvDnOVOd177L-x+9X5XCrQX2u3UEguGg@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 7 Jan 2022 at 06:02, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
...
> > >
> >
> > Okay, I will look at this code closely regarding whenever multiple
> > wpan_devs are running.
>
> The "scanning" boolean is stored as a wpan_phy member (IIRC) so we
> should be good on this regard (now that I have a clearer picture of the
> dependencies).
>

ok.

> > You should also check for possible stop of all possible wpan dev
> > transmit queues, if it's not already done.
>
> I forgot about this path. Indeed I'll add a check in the transmit path
> as well, of course.
>

What I mean is look into the functions "ieee802154_stop_queue()" and
"ieee802154_wake_queue()".

> > I suppose a scan can take a
> > long time and we should not send some data frames out. I am thinking
> > about the long time scan operation... if we stop the queue for a long
> > time I think we will drop a lot, however the scan can only be
> > triggered by the right permissions and the user should be aware of the
> > side effects. Proper reliable upper layer protocols will care or non
> > reliable will not care about this.
> >
> > There still exists the driver "ca8210" which is the mentioned HardMAC
> > transceiver in SoftMAC. There should somehow be a flag that it cannot
> > do a scan and the operation should not be allowed as the xmit callback
> > allows dataframes only.
>
> So it cannot do an active scan, but a passive scan would be allowed
> (there is no transmission, and the beacons are regular valid frames,
> I suppose they should not be filtered out by the hardware).
>
> So we actually need these hooks back :-) Because the right thing to do
> here is to use the "FYI here is the scan op that is starting" message
> from the mac to the drivers and this driver should return "nope,
> -ENOTSUPP". The mac would react in this case by canceling the
> operation and returning an error to the caller. Same when sending
> beacons if we consider beacons as !dataframes.
>

I believe that a HardMAC transceiver will handle a lot of the scan
process on the transceiver side and is only capable of dumping what
it's stored and start/stop scan? This is one reason why the
scan/dump/etc cfg802154 interface  should be close to the standard
(MLME). At the end it should from userspace make no difference if at
the end is a HardMAC or SoftMAC. Although there will always be a
limitation and a SoftMAC is probably always "more" powerful than a
HardMAC, but at some point there is a "minimum" of capable
functionality... and SoftMAC transceivers might always have "some"
things which they might offload to the hardware.

- Alex
